@isTest
public class PDICampaignInitiationHelper_Test {
    static TestMethod void testCreateNewCampaignProviderRecords()
    {
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
            insert  mgrProfile;
            List<Contact> contactLst =  Util01_PDIUtilTestData.createContacts();
            insert contactLst;
            Map<Id, Contact> contactMap = new Map<Id, Contact>();
            for(Contact c: contactLst)
            {
                contactMap.put(c.Id, c);
            }
            List<Contact_Validation_Summary__c> sumList = [Select id, Contact_Id__r.Id From Contact_Validation_Summary__c Where Contact_Id__r.Id IN: contactMap.keySet() LIMIT 3];
            delete sumList;
            Contact_Validation_Summary__c summaryRecord = new Contact_Validation_Summary__c(
                    Provider_Name__c = 'NagaTest', Email__c = 'NagaTest111@test.com', Address_Type__c = 'Primary', Contact_Id__c = contactLst[0].Id,
                    Practicing_Physician__c = true, Resigned_From_Sutter__c = false, Retired_Departed__c = false, 
                    PDI_Campaign__c = '2015 Phase', Tech_Is_Campaign_Done__c = false);
            insert summaryRecord;
            Test.startTest();
            PDICampaignInitiationHelper.CreateNewCampaignProviderRecords(contactMap);
            Test.stopTest();
        }
        List<Contact_Validation_Summary__c> updatedList = [SELECT PDI_Campaign__c FROM Contact_Validation_Summary__c 
                                                           WHERE PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name];
        System.assertNotEquals(0, updatedList.size());
    }
    
}