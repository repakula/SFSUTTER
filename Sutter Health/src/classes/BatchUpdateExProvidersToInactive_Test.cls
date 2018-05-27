/**********************************************************************
Class Name   : BatchUpdateExProvidersToInactive_Test
Date Created : 25-May-2016
Created By   : Nagarjuna
Description  : Test class
Referenced/Used in : BatchUpdateExProvidersToInactive_Test
**********************************************************************/
@isTest
public class BatchUpdateExProvidersToInactive_Test {
    
    static TestMethod void createProviderContactWithNorecords()
    {
        try
        {
            User testUser = Util01_PDIUtilTestData.PDITestUser();
            System.runAs(testUser)
            {
                List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
                mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
                insert  mgrProfile;
                
                Contact con = Util01_PDIUtilTestData.createContact();
                con.Provider_Active_Status__c = false;
                insert con;  
            }
            
            Test.startTest();
            BatchUpdateExistingProvidersToInactive batchInActive = new BatchUpdateExistingProvidersToInactive();
            Database.executeBatch(batchInActive);
            Test.stopTest();
            List<contact> updatedContactList = [SELECT Provider_Active_Status__c FROM Contact 
                                                WHERE RecordType.Name = 'Provider' AND  Provider_Active_Status__c = false];
            System.assertNotEquals(0, updatedContactList.size());
        }
        catch(Exception ex)
        {
            System.debug('Exception occured in test class: BatchUpdateExProvidersToInactive_Test');
        }
    }
    static TestMethod void createProviderContacts()
    {
        try
        {
            User testUser = Util01_PDIUtilTestData.PDITestUser();
            System.runAs(testUser)
            {
                List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
                mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
                insert  mgrProfile;
                
                List<contact> contactList = Util01_PDIUtilTestData.createContacts();
                insert contactList;  
            }
            
            Test.startTest();
            BatchUpdateExistingProvidersToInactive batchInActive = new BatchUpdateExistingProvidersToInactive();
            Database.executeBatch(batchInActive);
            Test.stopTest();
            List<contact> updatedContactList = [SELECT Provider_Active_Status__c FROM Contact 
                                                WHERE RecordType.Name = 'Provider' AND  Provider_Active_Status__c = false];
            System.assertNotEquals(0, updatedContactList.size());
        }
        catch(Exception ex)
        {
            System.debug('Exception occured in test class: BatchUpdateExProvidersToInactive_Test');
        }
    }
}