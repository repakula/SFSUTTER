/*****************************************************
Class Name: BatchPDIAdminAssistantApprovalEmail_Test
Created By: Nagarjuna Kaipu
Created Date: 15/11/2016
Description: test class for BatchPDIAdminAssistantApprovalEmail class
******************************************************/
@isTest
public class BatchPDIAdminAssistantApprovalEmail_Test {
    static testmethod void PDIAdminAssistantApprovalEmailTest() {
        Contact c = Util01_PDIUtilTestData.createContact();
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            c.Provider_Admin_Assistant_Email__c = 'nagarjuna.kaipu@accenture.com';
            Test.startTest();
            insert c;
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
            insert  mgrProfile;
        }
  
        BatchPDIAdminAssistantApprovalEmail emailBatch = new BatchPDIAdminAssistantApprovalEmail();
        emailBatch.query = 'SELECT Id, Contact_Id__c, Admin_Assistant__c, Admin_Assistant_Email__c, Admin_Assistant_Phone__c, Email__c,'
            +' PDI_Campaign__c, Provider_Active_Status__c, Status__c, Provider_Admin_Emails_Are_Same__c FROM Contact_Validation_Summary__c'
            +' WHERE Email__c != null' 
            +' AND Admin_Assistant_Email__c != null' 
            +' AND PDI_Campaign__c = \''+Label.CL176_PDI_Current_Campaign_Name+'\''
            +' AND Status__c != \''+Label.CL187_PDI_Validated_Status+'\' Limit 10000';
        Database.executeBatch(emailBatch, 1);
        List<Contact_Validation_Summary__c> sumList = new List<Contact_Validation_Summary__c>();
        //Querying the inserted summary record to check the assertion
        sumList = [SELECT Id, Contact_Id__c, Admin_Assistant__c, Admin_Assistant_Email__c, Admin_Assistant_Phone__c, Email__c, 
                   PDI_Campaign__c, Provider_Active_Status__c, Status__c, Provider_Admin_Emails_Are_Same__c FROM Contact_Validation_Summary__c 
                   Where Admin_Assistant_Email__c = 'nagarjuna.kaipu@accenture.com' Limit 1];
        System.assertEquals(sumList[0].Admin_Assistant_Email__c, 'nagarjuna.kaipu@accenture.com');
        Test.stopTest();
    }
}