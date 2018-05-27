/*****************************************************
Class Name: ProviderCampaignInitiatorController_Test
Created By: Nagarjuna Kaipu
Created Date: 07/06/2016
Description: test class for ProviderCampaignInitiatorController class
******************************************************/
@isTest
public class ProviderCampaignInitiatorController_Test {
    static TestMethod void testPdiCampaignControllerWithoutRecords()
    {
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = AP01_TestDataUtility.createManageprofileSet();
            insert  mgrProfile;
            PDI_Campaign_History__c pch = Util01_PDIUtilTestData.createCampaignHistory();
            insert pch;
            PageReference pref = Page.PDICampaignInitiation;
            Test.setCurrentPage(pref);  
            ApexPages.currentPage().getParameters().put('CampaignName', '2016 Wave1');
            ProviderCampaignInitiatorController con = new ProviderCampaignInitiatorController();
            con.isRetiredOrDeparted = true;
            con.isinActive = true;
            con.isResignedFromSutter = true;
            Test.startTest();
            con.save();
            Test.stopTest();
        }
        List<Contact_Validation_Summary__c> updatedList = [SELECT PDI_Campaign__c FROM Contact_Validation_Summary__c 
                                                           WHERE PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name];
        System.assertEquals(0, updatedList.size());
    }
    static TestMethod void testPdiCampaignController()
    {
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = AP01_TestDataUtility.createManageprofileSet();
            insert  mgrProfile;
            PDI_Campaign_History__c pch = Util01_PDIUtilTestData.createCampaignHistory();
            insert pch;
            List<Contact_Validation_Summary__c> exSummaryList =  Util01_PDIUtilTestData.createSummaryRecords();
            List<Contact_Validation_Summary__c> exCampRec = [Select Id, PDI_Campaign__c From Contact_Validation_Summary__c Where PDI_Campaign__c = '2016 Wave1'];
            delete exCampRec;
            insert exSummaryList;
            PageReference pref = Page.PDICampaignInitiation;
            Test.setCurrentPage(pref);  
            ApexPages.currentPage().getParameters().put('CampaignName', '2016 Wave1');
            ProviderCampaignInitiatorController con = new ProviderCampaignInitiatorController();
            con.isRetiredOrDeparted = true;
            con.isinActive = true;
            con.isResignedFromSutter = true;
            Test.startTest();
            con.save();
            Test.stopTest();
        }
        List<Contact_Validation_Summary__c> updatedList = [SELECT PDI_Campaign__c FROM Contact_Validation_Summary__c 
                                                           WHERE PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name];
        System.assertNotEquals(0, updatedList.size());
    }
}