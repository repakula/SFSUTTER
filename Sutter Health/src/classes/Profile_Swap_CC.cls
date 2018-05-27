/**********************************************************************
Name: Profile_Swap_CC
======================================================
======================================================
Purpose: Controller for the page Profile_Swap.  This class allows a user to swap an active user record with a deactive one.  Swapping requires that the emails match
on both the active and inactive record.  The swapable User must have a record that is in a role below the current.  The additional user(s) records can be in different 
roles as long the highest parent role match that of the current user.  This allows the user swapping to be restricted based on business line.  
-------	
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL Description
1.0 Brian Lee 07/08/2016 INITIAL DEVELOPMENT CSR:
***********************************************************************/
public without sharing class Profile_Swap_CC {
    private static set<id> activeUsers;
    private static set<id> inactiveUsers;
    private static map<id,set<id>> activeUserToRelatedMap;
    private static map<id,User> usersMap;
    @TestVisible private static final string SUCCESS_NOTIFICATION = 'Update Successful';
    @TestVisible private static final string UPDATE_FAILED = 'Update Failed';
    @TestVisible private static final string BAD_VALUES = 'Error finding users';
    @TestVisible private static final set<String> LICENSE_TYPES = new set<String>{'Salesforce'};
    @TestVisible private static final set<String> EXCLUDE_NAME = new set<String>{'System Administrator'};
    @TestVisible private static final set<id> licenseProfileSet;
    
    static{
    	licenseProfileSet = new set<id>();
    	for(Profile tempProfile : [Select id from Profile where Name not in : EXCLUDE_NAME AND UserLicense.Name in :LICENSE_TYPES]){
    		licenseProfileSet.add(tempProfile.id);
    	}
    }
    /*******************************************************************
	Purpose: Instantiates the Profile_Swap_CC 
	Parameters: none
	Returns: none 
	Throws [Exceptions]: None
	********************************************************************/
    public Profile_Swap_CC(){
    }
    
    /*******************************************************************
	Purpose: Get the active users that are availeable for swap based on the current user and their role
	Parameters: None  
	Returns: list of users record
	Throws [Exceptions]: None
	********************************************************************/
    private static list<User> activeUsers(){
    	Id currentUserRoleId = userInfo.getUserRoleId();
    	Id currentUserId = userInfo.getUserId();
		set<id> roleSet = getChildRoles(currentUserRoleId);
		map<String, set<User>> emailToUserMap = new map<String,set<User>>();
		set<id> validId = new set<id>();
		set<String> emailSet = new set<String>();
		set<String> inactiveEmailSet = new set<String>();
		for(User tempUser : [Select  Username, Name, Profile.Name, UserRole.Name, UserRoleId, Email, isActive from User where id != :currentUserId AND UserRoleId in :roleSet AND ProfileId in: licenseProfileSet]){
			emailSet.add(tempUser.Email);
			if(tempUser.isActive){
				if(emailToUserMap.containsKey(tempUser.Email)){
					emailToUserMap.get(tempUser.Email).add(tempUser);
				}
				else{
					emailToUserMap.put(tempUser.Email, new set<User>{tempUser});
				}
				validId.add(tempUser.id);
			}
			else{
				inactiveEmailSet.add(tempUser.Email);
			}
			
		}
		Id rootParent = getParentRootId(currentUserRoleId);
		roleSet = getChildRoles(rootParent);
		for(User relatedTempUser : [Select  Username, Name, Profile.Name, UserRole.Name, UserRoleId, Email, isActive from User where id != :currentUserId AND UserRoleId in :roleSet AND id not in :validId AND Email in :emailSet AND ProfileId in: licenseProfileSet]){
			if(relatedTempUser.isActive){
				if(emailToUserMap.containsKey(relatedTempUser.Email)){
					emailToUserMap.get(relatedTempUser.Email).add(relatedTempUser);
				}
				else{
					emailToUserMap.put(relatedTempUser.Email, new set<User>{relatedTempUser});
				}
				
			}
			else{
				inactiveEmailSet.add(relatedTempUser.Email);
			}
		}
		system.debug('before ' + emailToUserMap.size());
		emailToUserMap.keySet().retainAll(inactiveEmailSet);
		system.debug('after ' + emailToUserMap.size());
	
		list<User> returnList = new list<User>();
		for(set<User> tempUserSet : emailToUserMap.values()){
			returnList.addAll(tempUserSet);
		}
		return returnList;
	}

	private static map<id,set<id>> parentMap;
	private static map<id,id> childToParentMap;
	
	/*******************************************************************
	Purpose:initializes the parentmap and childtoparentmap with roles
	Parameters: None  
	Returns: None
	Throws [Exceptions]: None
	********************************************************************/
	private static void setRoleMaps(){
		if(parentMap == null || childToParentMap == null){
			parentMap = new map<id,set<id>>();
			childToParentMap = new map<id,id>();
			for(UserRole thisRole : [Select id, ParentRoleId from UserRole]){
				if(parentMap.containsKey(thisRole.ParentRoleId)){
					parentMap.get(thisRole.ParentRoleId).add(thisRole.id); 
				}
				else{
					parentMap.put(thisRole.ParentRoleId, new set<id>{thisRole.id}); 
				}
				//Root roles will not ahve a parentId
				if(thisRole.ParentRoleId != null){
					childToParentMap.put(thisRole.id,thisRole.ParentRoleId);
				}
			}
		}
	}
	
	/*******************************************************************
	Purpose:Return the top most parent role id. 
	Parameters: id of Userrole to find parent of  
	Returns: Id of UserRole at or above provided role where the parentid is null 
	Throws [Exceptions]: None
	********************************************************************/
	private static id getParentRootId(Id childId){
		Id returnParentId = childId;
		if(childToParentMap == null){
			setRoleMaps();
		}
		while(childToParentMap.containsKey(returnParentId)){
			returnParentId = childToParentMap.get(returnParentId);
		}
		
		return returnParentId;
	}
	
	/*******************************************************************
	Purpose:Returns a set of roles that are below the specified UserRole. 
	Parameters: id of Userrole to find children of 
	Returns: set of ids that are below the provided role in the hierarchy 
	Throws [Exceptions]: None
	********************************************************************/
	private static set<id> getChildRoles(Id rootId){
		set<id> childSet = new set<id>();
		if(parentMap == null){
			setRoleMaps();
		}
		childSet = getMyChildren(rootId);
		return childSet;
	}
	
	/*******************************************************************
	Purpose:Recursive method to find all child roles. 
	Parameters: id of Userrole to find children of 
	Returns: set of ids that are below the provided role in the hierarchy 
	Throws [Exceptions]: None
	********************************************************************/
	private static set<id> getMyChildren(Id rootId){
		set<id> returnSet = new set<id>();
		if(parentMap.containsKey(rootId)){
			set<id> tempSet = parentMap.get(rootId);
			returnSet.addAll(tempSet);
			for(id childId : tempSet){
				if(parentMap.containsKey(childId)){
					returnSet.addAll(getMyChildren(childId));
				}
			}
	
		}
		return returnSet;
	}

    /*******************************************************************
	Purpose: Swaps the nickname username and federation id of provided users and makes the primary inactive and secondary active.  Swap only occurs provided the 
				specified IDs match emails, one is in role below current user and both have same root userrole.
	Parameters: primaryid for user who should be deactivated, secondaryid of user to be activated
	Returns: string message of success or failure 
	Throws [Exceptions]: Exceptions caught.  Return message holds any error
	********************************************************************/
    @remoteAction
    public static String swapUsers(Id primaryId, Id secondaryId){
    	String returnMessage;
    	list<User> inactiveUserList = getRelatedUsers(primaryId);
    	boolean validUsers = false;
    	for(User tempUser : inactiveUserList){
    		if(tempUser.id == secondaryId){
    			validUsers = true;
    		}
    	}
    	if(validUsers){
    		list<User> updateList = new list<User>();
    		User primaryUser = [Select 	CommunityNickname, Username, Email, FederationIdentifier from user where id = :primaryId];
    		User secondaryUser = [Select CommunityNickname, Username, Email, FederationIdentifier from user where id = :secondaryId];
    		User secondClone = secondaryUser.clone();
    		secondaryUser.CommunityNickname = primaryUser.CommunityNickname;
    		secondaryUser.Username = primaryUser.Username;
    		secondaryUser.FederationIdentifier = primaryUser.FederationIdentifier;
    		
    		
    		primaryUser.CommunityNickname += '.SWAP';
    		primaryUser.Username += '.SWAP';
    		primaryUser.FederationIdentifier = String.isNotBlank(primaryUser.FederationIdentifier) ? primaryUser.FederationIdentifier + '.SWAP' : '';
    		primaryUser.isActive = false;
    		
    		try{
    			update primaryUser;
    			update secondaryUser;
    			secondaryUser.isActive = true;
    			update secondaryUser;
	    		primaryUser.CommunityNickname = secondClone.CommunityNickname;
	    		primaryUser.Username = secondClone.Username;
	    		primaryUser.FederationIdentifier = secondClone.FederationIdentifier;
    			update primaryUser;
    			returnMessage = SUCCESS_NOTIFICATION;
    		}
    		catch(Exception e){
    			returnMessage = UPDATE_FAILED;
    		}
    	}
    	else{
    		returnMessage = BAD_VALUES;
    	}
    	
    	
    	return returnMessage;
    }
    
    /*******************************************************************
	Purpose: Returns a list of active users based on current user role 
	Parameters: none
	Returns: list of active users which have one or more inactive users with matching emails 
	Throws [Exceptions]: None
	********************************************************************/
    @remoteAction
    public static list<User> getActiveUsers(){
    	list<User> returnList;

    	returnList = activeUsers();
    	return returnList;
    }
    
    /*******************************************************************
	Purpose: Returns a list of inactive users related to the specified user 
	Parameters: user id that we are matching
	Returns: list of inactive users related to the provided active user 
	Throws [Exceptions]: None
	********************************************************************/
    @remoteAction
    public static list<User> getRelatedUsers(Id selectUserId){
    	list<User> returnList = new list<User>();
    	list<User> activeList = getActiveUsers();
    	User activeUser;
    	for(User tempUser : activeList){
    		if(tempUser.id == selectUserId){
    			activeUser = tempUser;
    		}
    	}
    	if(activeUser != null){
    		returnList = [Select  Username, Name, Profile.Name, UserRole.Name, UserRoleId, Email, isActive from User where isActive = false AND id !=  :activeUser.Id AND Email = :activeUser.Email AND ProfileId in: licenseProfileSet];
    	}
    	
    	return returnList;
    }

}