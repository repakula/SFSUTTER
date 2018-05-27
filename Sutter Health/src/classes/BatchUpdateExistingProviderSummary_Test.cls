/**********************************************************************
Class Name   : BatchUpdateExistingProviderSummary_Test
Date Created : 25-May-2016
Created By   : Nagarjuna
Description  : Test class
Referenced/Used in : Used to test BatchUpdateExistingProviderSummary
**********************************************************************/
@isTest
public class BatchUpdateExistingProviderSummary_Test {
    static TestMethod void createSummaryNoTestRecords()
    {
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = AP01_TestDataUtility.createManageprofileSet();
            insert  mgrProfile;
        }
        Test.startTest();
        BatchUpdateExistingProviderSummary summaryBatch = new BatchUpdateExistingProviderSummary();
        Database.executeBatch(summaryBatch, 200);
        Test.stopTest();
        List<Contact_Validation_Summary__c> updatedList = [SELECT PDI_Campaign__c FROM Contact_Validation_Summary__c 
                                                           WHERE PDI_Campaign__c =: Label.CL175_PDI_Old_Campaign_Name
                                                           OR PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name];
        System.assertEquals(0, updatedList.size());
    }
    static TestMethod void createSummaryTestRecords()
    {
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = AP01_TestDataUtility.createManageprofileSet();
            insert  mgrProfile;
            List<Contact_Validation_Summary__c> summaryList = Util01_PDIUtilTestData.createSummaryRecords();
            List<Contact_Validation_Summary__c> summaryListToAdd = new List<Contact_Validation_Summary__c>();
            for(Contact_Validation_Summary__c cvs: summaryList)
            {
                cvs.PDI_Campaign__c = null;
                summaryListToAdd.add(cvs);
            }
            insert summaryListToAdd;
        }
        Test.startTest();
        BatchUpdateExistingProviderSummary summaryBatch = new BatchUpdateExistingProviderSummary();
        Database.executeBatch(summaryBatch, 200);
        Test.stopTest();
        List<Contact_Validation_Summary__c> updatedList = [SELECT PDI_Campaign__c FROM Contact_Validation_Summary__c 
                                                           WHERE PDI_Campaign__c =: Label.CL175_PDI_Old_Campaign_Name
                                                           OR PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name];
        System.assertNotEquals(0, updatedList.size());
    }
}