/**  
  *     Class Name  : HandleFailedContacts_Test
  *     Author      : IDC Offshore
  *     Date        : 11-Aug-2014
  *     Project Name: CRM - SFT - Sutter Health
  *     Description : Test Class for HandleFailedContacts Class. This class tests different scenarios that are handled in the code
  **/

@isTest
public class HandleFailedContacts_Test {
    
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description: method to create test data used by all tests       
     * @return void        
     */
    @testsetup
    static void createTestData() {
    
         //Create Test Account 
        Account acc =   AP01_TestDataUtility.createAccount();
            
        //@description This method create test data for CS_ManageProfile custom setting.
        //list<CS_ManageProfile__c> lstManageProfile  = AP01_TestDataUtility.createManageprofileSet();
        //insert lstManageProfile;
        CS_ManageProfile__c profilecustsett = AP01_TestDataUtility.createManageProfileCustSetting();
            
        List<Contact> ProvidercontactPortalList = AP01_TestDataUtility.createProviderPortalContacts(acc);
           //select user profile
            Profile pp1;
            UserRole portalRole; 
            pp1 = [Select Id from Profile where name = 'Community Portal' Limit 1];
            portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            User testUser = new User(
                ProfileId = pp1.Id,
                Username = 'tester49_nky7@test.com',
                //UserRoleId = portalRole.Id,
                Alias = 'tester1',
                ContactId = ProvidercontactPortalList[0].id,
                Email='tester49_nky@test.com',
                EmailEncodingKey='UTF-8',
                Firstname='One',
                Lastname='Tester1',
                CommunityNickname = 'tester49_nky7',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Los_Angeles'
            );
                
            insert testUser;
                
        // Assert to check User has been inserted successfully
        System.assert(testUser.id!=null);
    }
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description: method to cover processAgain and  insertFailList methods   
     * @return void        
     */
    public static testMethod void HandleFailedContactsTestMethod(){
    
        test.starttest();
        HandleFailedContacts hfcObj = new HandleFailedContacts();
        hfcObj.insertFailList();
        HandleFailedContacts.processAgain();
        hfcObj.insertFailList();
        
        // Assert to check failed contact
        failed_contacts__c failedcontact = [select id,Contact_Id__c from failed_contacts__c ];
        System.assert(failedcontact!=null );
        
        test.stoptest();
    }
}