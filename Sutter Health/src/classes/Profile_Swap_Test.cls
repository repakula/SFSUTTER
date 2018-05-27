/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Profile_Swap_Test {
	private static Integer CREATE_OWNER = 50;
    /*******************************************************************
	Purpose: Create the test data for use test
	Parameters: none
	Returns: none
	Throws [Exceptions]: None
	********************************************************************/
	@testSetup static void myTestSetup(){
		list<Id> profileList = new list<id>();
		profileList.addAll(Profile_Swap_CC.licenseProfileSet);
		
		list<UserRole> rootRoles = [Select id from UserRole where ParentRoleId = null limit 2];
		list<User> testRootUserList = new list<User>();
		for(integer i = 0; i < 2; i++){
			testRootUserList.add((User)User.sObjectType.newSObject(null,true));
			testRootUserList[i].Username = 'abc' + i + '@testorg.com.testRoot';
			testRootUserList[i].LastName = 'test' +i;
			testRootUserList[i].Email = 'abc' + i + '@testorg.com.testRoot';
			testRootUserList[i].Alias = 'test' + i + 'Rt';
			testRootUserList[i].CommunityNickname = 'tes' + i + 'root';
			testRootUserList[i].TimeZoneSidKey = 'America/Los_Angeles';
			testRootUserList[i].LocaleSidKey = 'en_US';
			testRootUserList[i].EmailEncodingKey = 'UTF-8';
			testRootUserList[i].ProfileId = profileList[getRandom(profileList.size()-1)];
			testRootUserList[i].LanguageLocaleKey = 'en_US';
			testRootUserList[i].UserRoleId = rootRoles[getRandom(rootRoles.size()-1)].id;
			testRootUserList[i].isActive = true;
		}
		insert testRootUserList;
		
		
		list<UserRole> nonRootRoles = [Select id from UserRole where ParentRoleId in :rootRoles];
		list<User> testUserList = new list<User>();
		for(integer i = 0; i < CREATE_OWNER; (i = i+2)){
			testUserList.add((User)User.sObjectType.newSObject(null,true));
			testUserList[i].Username = 'abc' + i + '@testorg.com.test';
			testUserList[i].LastName = 'test' +i;
			testUserList[i].Email = 'abc' + i + '@testorg.com';
			testUserList[i].Alias = 'test' + i;
			testUserList[i].CommunityNickname = 'tes' + i;
			testUserList[i].TimeZoneSidKey = 'America/Los_Angeles';
			testUserList[i].LocaleSidKey = 'en_US';
			testUserList[i].EmailEncodingKey = 'UTF-8';
			testUserList[i].ProfileId = profileList[getRandom(profileList.size()-1)];
			testUserList[i].LanguageLocaleKey = 'en_US';
			testUserList[i].UserRoleId = nonRootRoles[getRandom(nonRootRoles.size()-1)].id;
			testUserList[i].FederationIdentifier = 'abc' + i + '@testorg.com';
			testUserList[i].isActive = getRandom(1) == 1 ? true : false;
			
			testUserList.add((User)User.sObjectType.newSObject(null,true));
			testUserList[i+1].Username = 'abc' + i + '@testorg.com.test.duplicate';
			testUserList[i+1].LastName = 'test' +i;
			testUserList[i+1].Email = 'abc' + i + '@testorg.com';
			testUserList[i+1].Alias = 'test' + (i+1);
			testUserList[i+1].CommunityNickname = 'tes' + (i+1);
			testUserList[i+1].TimeZoneSidKey = 'America/Los_Angeles';
			testUserList[i+1].LocaleSidKey = 'en_US';
			testUserList[i+1].EmailEncodingKey = 'UTF-8';
			testUserList[i+1].ProfileId = profileList[getRandom(profileList.size()-1)];
			testUserList[i+1].LanguageLocaleKey = 'en_US';
			testUserList[i+1].UserRoleId = nonRootRoles[getRandom(nonRootRoles.size()-1)].id;
			testUserList[i+1].FederationIdentifier = 'abc' + i + '@testorg.com.duplicate';
			testUserList[i+1].isActive = testUserList[i].isActive ? false : true;
		}
		insert testUserList;
		
		
		
	}
	/*******************************************************************
	Purpose: test the Profile_Swap_CC class
	Parameters: none
	Returns: none
	Throws [Exceptions]: None
	********************************************************************/
	@isTest static void testProfileSwap() {
		list<User> rootRoleUser = [Select id from user where ProfileId in :Profile_Swap_CC.licenseProfileSet AND isActive = true AND UserRoleId in (Select id from UserRole where ParentRoleId = null) limit 1];
		for(User testUser : rootRoleUser){
			System.runAs(testUser){
				List<User> activeUsers = Profile_Swap_CC.getActiveUsers();
				if(!activeUsers.isEmpty()){
					User selectedPrimary = activeUsers.remove(getRandom(activeUsers.size()-1));
					list<User> inactiveUserList = Profile_Swap_CC.getRelatedUsers(selectedPrimary.id);
					if(!inactiveUserList.isEmpty()){
						for(User inactiveUser : inactiveUserList){
							system.assert(inactiveUser.Email.equals(selectedPrimary.Email));
						}
						User selectedSwap = inactiveUserList[getRandom(inactiveUserList.size()-1)];
						String notification = Profile_Swap_CC.swapUsers(selectedPrimary.id, selectedSwap.id);
						if(notification.equals(Profile_Swap_CC.SUCCESS_NOTIFICATION)){
							//set to inactive
							User updateUser = [Select Username, isActive from User where id =:selectedPrimary.id];
							system.assert(!updateUser.isActive);
							system.assert(updateUser.Username.equals(selectedSwap.Username));
							//set to active
							User updateUserSwap = [Select Username, isActive from User where id =:selectedSwap.id];
							system.assert(updateUserSwap.isActive);
							system.assert(updateUserSwap.Username.equals(selectedPrimary.Username));
						}
					}
					if(!activeUsers.isEmpty()){
						selectedPrimary = activeUsers.remove(getRandom(activeUsers.size()-1));
						inactiveUserList = Profile_Swap_CC.getRelatedUsers(selectedPrimary.id);
						if(!inactiveUserList.isEmpty()){
							for(User inactiveUser : inactiveUserList){
								system.assert(inactiveUser.Email.equals(selectedPrimary.Email));
							}
							User selectedSwap = inactiveUserList[getRandom(inactiveUserList.size()-1)];
							String notification = Profile_Swap_CC.swapUsers(selectedPrimary.id, selectedSwap.id);
							if(notification.equals(Profile_Swap_CC.SUCCESS_NOTIFICATION)){
								//set to inactive
								User updateUser = [Select Username, isActive from User where id =:selectedPrimary.id];
								system.assert(!updateUser.isActive);
								system.assert(updateUser.Username.equals(selectedSwap.Username));
								//set to active
								User updateUserSwap = [Select Username, isActive from User where id =:selectedSwap.id];
								system.assert(updateUserSwap.isActive);
								system.assert(updateUserSwap.Username.equals(selectedPrimary.Username));
							}
						}
					}
				}
				Profile_Swap_CC swapController = new Profile_Swap_CC();
				String notification = Profile_Swap_CC.swapUsers(null, null);
				system.assert(notification.equals(Profile_Swap_CC.BAD_VALUES));
			}
		}
	}
	
	 /*******************************************************************
	Purpose: Create a random number between 0 and a specified max
	Parameters: integer to specify the max 
	Returns: integer 
	Throws [Exceptions]: None
	********************************************************************/
    private static Integer getRandom(integer maxNumber){
    	return Math.round(Math.random() * maxNumber);
    }
}