/* 
     Class Name: CaseAcceptButtonHelper 
     Author: IDC Offshore
     Date: 18-Dec-2016
     Description: Custom Accept button helper class.
     
     History:
     VERSION    AUTHOR              DATE        DETAIL 
     1.0        Prerna Chandak      18-Dec-2016    Web Service class to be designed for custom accept button to find all the group members.
     
*/
global class CaseAcceptButtonHelper
{
    
    global static Set<Id> allGroupIdsSet = new Set<Id>();
    
    /********************************************************************************
    *   @author ......: IDC Team                                                      
    *   @date ........: 18-Dec-2016                                                   
    *   @description .: Web Service method to be invoked from detail page accept button.                           
    *   @param........: none                                                            
    *   @return ......: String userMessage                                          
    *********************************************************************************/
    webservice static String getGroupMembers(Id ownerId)
    {
        Boolean isMember = false;
        Boolean doesIncludeBosses = false;
        String userMessage = '';
        String userType = Schema.SObjectType.User.getKeyPrefix();
        
        //Get the logged in user ID
        Id  loggedInUserId = Userinfo.getUserId(); 
        
        //Check if user has edit permission on the object
        Boolean runningUserMayUpdate = Schema.sObjectType.Case.isUpdateable();
        if(runningUserMayUpdate)
        {
            /*  If case owner ID is a user ID :
                - Check if owner Id = Logged In user Id. If yes, confirm user that ticket is already assigned to them.'
                - Check if owner Id = Other User. If Yes, prevent ownership transfer.
            */
            if(String.valueOf(ownerId).startsWith(userType))
            {
                if(loggedInUserId == ownerId)
                {
                    userMessage = Label.AcceptButtonLabel_A;
                }
                else 
                {
                    userMessage = Label.AcceptButtonLabel_B;
                }
            }
            else
            {
            
                try
                {
                    /* Find all the group members who meets below criteria
                        1- Members directly added to group
                        2- Members who are added in a nested groups
                        3- Member Role's added to the group
                    */
                    Map<ID, User> groupMemberMap = new Map<Id, User>([Select Id from User where ID IN :GetUserIdsFromGroup(new Set<Id>{ownerId}) and isActive=true]);
                    
                    //Logged in user is a member if it does exist in above groupMemberMap
                    if(groupMemberMap.containsKey(loggedInUserId ))
                    {
                        isMember=true;
                        userMessage = Label.AcceptButtonLabel_C;
                    }
                    else
                    {
                        /*
                            If user doesn't exist in groupMemberMap, there may be a possibility that doesIncludeBosses is enabled for any group and logged in user is a manager.
                            Find the DoesIncludeBosses for all nested groups.
                        
                        */
                         for(Group memberGroup : [Select DoesIncludeBosses from Group where Id IN :allGroupIdsSet])
                         {
                            if(memberGroup.DoesIncludeBosses)
                            {
                                doesIncludeBosses = true;
                            }
                         }
                         
                        //Check if DoesIncludeBosses is enabled for any nested group
                        if(doesIncludeBosses)
                        {
                            /* Find if logged user is a member :
                                - Traverse role hierarchy to get all the sub-ordinates.
                                - If any sub-ordinate is direct member of the group, logged in user would be a member.
                            */
                            
                            Map<Id,User> subOridinatesMap = getRoleSubordinateUsers(loggedInUserId /* '005G0000003OWxs'*/);
                            
                            // if logged in user is top in the hierarchy
                            for(User groupMember : groupMemberMap.values())
                            {
                                if(subOridinatesMap.containsKey(groupMember.ID))
                                {
                                    isMember = true;
                                    userMessage = Label.AcceptButtonLabel_D;
                                    break;
                                }
                            }
                            
                        }
                    }
                    
                    if(!isMember)
                    {
                        userMessage = Label.AcceptButtonLabel_E;
                    }
                }
                catch(Exception e)
                {
                    userMessage = userMessage = Label.AcceptButtonLabel_F;
                }
                
            } 
            
        }
        else
        {
            userMessage = Label.AcceptButtonLabel_G;
        }
        return userMessage; 
    }
    
    
    /********************************************************************************
    *   @author ......: IDC Team                                                      
    *   @date ........: 18-Dec-2016                                                   
    *   @description .: Method to get Sub-ordinates                            
    *   @param........: none                                                            
    *   @return ......: Map<Id,User>                                       
    *********************************************************************************/
    public static Map<Id,User> getRoleSubordinateUsers(Id userId) 
    {
        // get requested user's role
        Id roleId = [select UserRoleId from User where Id = :userId].UserRoleId;
        // get all of the roles underneath the user
        Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
        // get all of the ids for the users in those roles
        Map<Id,User> userMap = new Map<Id, User>([Select Id, Name From User where UserRoleId IN :allSubRoleIds]);
        // return the ids as a set so you can do what you want with them
        return userMap;
    }

    /********************************************************************************
    *   @author ......: IDC Team                                                      
    *   @date ........: 18-Dec-2016                                                   
    *   @description .: Recursive method to get Sub-ordinate roles                            
    *   @param........: none                                                            
    *   @return ......: Set<ID>                                        
    *********************************************************************************/
    private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) 
    {
        Set<ID> currentRoleIds = new Set<ID>();
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id, name from UserRole where ParentRoleId IN :roleIds AND ParentRoleID != null])
        currentRoleIds.add(userRole.Id);

        // go fetch some more rolls!
        if(currentRoleIds.size() > 0)
        currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        return currentRoleIds;
    }
  
    /********************************************************************************
    *   @author ......: IDC Team                                                      
    *   @date ........: 18-Dec-2016                                                   
    *   @description .: Recursive method to get group members that includes direct member, roles, groups.                           
    *   @param........: none                                                            
    *   @return ......: Set<ID>                                        
    *********************************************************************************/
    public static Set<id> GetUserIdsFromGroup(Set<Id> groupIds)
    {
        // store the results in a set so we don't get duplicates
        Set<Id> result=new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        Set<Id> groupIdProxys = new Set<Id>();
        // Loop through all group members in a group
        for(GroupMember m : [Select Id, UserOrGroupId, Group.Type, Group.RelatedId From GroupMember Where GroupId in :groupIds])
        {
            // If the user or group id is a user
            if(((String)m.UserOrGroupId).startsWith(userType))
            {
                result.add(m.UserOrGroupId);
            }
            // If the user or group id is a group
            // Note: there may be a problem with governor limits if this is called too many times
            else if (((String)m.UserOrGroupId).startsWith(groupType))
            {
                // Call this function again but pass in the group found within this group
                groupIdProxys.add(m.userOrGroupId);
                
            }
        }
        
        if(groupIdProxys.size() > 0)
        {    
            Set<id> groupIdSet = new set<id>();
            Set<id> roleIdSet = new set<id>();
            Set<id> roleAndSubIdSet = new set<Id>();

            for(Group nestedGroup : [Select Id, Type, relatedId From Group Where Id = :groupIdProxys]){
                if(nestedGroup.Type == 'Role'){
                    roleIdSet.add(nestedGroup.relatedId);    
                }
                else if(nestedGroup.Type== 'RoleAndSubordinates'){
                    roleAndSubIdSet.add(nestedGroup.relatedId);    
                }
                else if(nestedGroup.Type== 'PRMOrganization'){
                    roleIdSet.add(nestedGroup.relatedId);    
                }
                else if(nestedGroup.Type== 'Regular'){
                    groupIdSet.add(nestedGroup.id);    
                }
            }
            
            //add all groups to global group to check doesIncludeBosses
            allGroupIdsSet.addAll(groupIdProxys);
            allGroupIdsSet.addAll(groupIdSet);
            
            // Get all sub-ordinate roles
            if(roleAndSubIdSet.size()>0){
                roleIdSet.addAll(getAllSubRoleIds(roleAndSubIdSet));
            }
            // Get all sub-ordinate users
            if(roleIdSet.size()>0){
                for(User u: [select id from user where UserRoleId IN: roleIdSet and isActive=true]){
                   result.add(u.id);
                }
            }
            
            // If nested groups, call method recursively to another set of group members
            if(groupIdSet.size()>0){
                result.addAll(GetUserIdsFromGroup(groupIdSet));
            }
        }
        return result;  
    }
    
    //=======================================================================================
    
    // FUTURE USE
    
    /********************************************************************************
    *   @author ......: IDC Team                                                      
    *   @date ........: 18-Dec-2016                                                   
    *   @description .: Method to get groups where relatedId = role                            
    *   @param........: none                                                            
    *   @return ......: Map<Id,User>                                       
    *********************************************************************************/
    /*public static Set<Id> getGroupsWhereRoleAssigned(Id roleId) 
    {
        List<String> roleRelatedGroupIds = new List<String>();
        for (Group g : [SELECT id, RelatedId, Type FROM Group where RelatedId= :UserInfo.getUserRoleId()]){
           roleRelatedGroupIds.add(g.id);
        }

        Set<Id> allGroupIDs = new Set<Id>();
        for (GroupMember gm : [SELECT Id, group.id, group.name, group.type FROM GroupMember where (UserOrGroupId = :UserInfo.getUserId() AND group.type='Regular') OR (UserOrGroupId IN :roleRelatedGroupIds AND group.type='Regular')]){
        allGroupIDs.add(gm.group.id);
        }
        
        return allGroupIDs;
    }*/
    
}