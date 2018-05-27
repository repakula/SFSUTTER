/*****************************************************
Class Name: BatchAutoAssignPhoneAgentsScheduler_Test
Created By: Nagarjuna Kaipu
Created Date: 07/06/2016
Description: test class for BatchAutoAssignPhoneToAgentsScheduler && BatchAutoAssignPhoneRecordsToAgents classes
******************************************************/
@isTest
public class BatchAutoAssignPhoneAgentsScheduler_Test {
    static testmethod void batchAutoAssignPhoneRecordsToAgentsTest() {
        List<User> PDIAgents =  Util01_PDIUtilTestData.createPDIAgents();
        insert PDIAgents;
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
            insert  mgrProfile;
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<Contact> cList = Util01_PDIUtilTestData.CreateDupPhoneContacts();
            insert cList;
            List<PDISelectedAgents__c> assignedAgents = new List<PDISelectedAgents__c>();
            List<User> uList = [Select Id, Name from User Where Name Like '%PDITest%'];
            for(User u: uList)
            {
                PDISelectedAgents__c sAgent = new PDISelectedAgents__c(Name = u.Id, Phone_Agent__c = true, Assigned_Count__c = 0);
                assignedAgents.add(sAgent);
            }
            insert assignedAgents;
            PDIAutoAssignSelectedCriteria__c selectedCriteria = Util01_PDIUtilTestData.PDIAutoAssignSelectedCriteria();
            insert selectedCriteria;
        }
                
        Group dupQue = [Select Id, name from group where type =: Label.CL411_PDIQueueAPI and Name =: Label.CL412_PDINonValidatedDuplicateQueue Limit 1];
        
        List<ProvidersByPhoneNumber__c> phoneList = new List<ProvidersByPhoneNumber__c>();
        for(Integer i = 0; i<5; i++){
            ProvidersByPhoneNumber__c p = new ProvidersByPhoneNumber__c();
            p.Name = '9676561568';
            p.Tech_Phone_Number__c = '9676561568';
            p.SER_Non_Validated__c = 5;
            p.SER_Accepted__c = 5;
            p.SER_Validated__c = 5;
            p.PDI_Campaign__c = '2016 Wave1';
            p.OwnerId = dupQue.Id;
            phoneList.add(p);
        }
        User testUser2 = Util01_PDIUtilTestData.PDITestUser2();
        System.runAs(testUser2)
        {
            insert phoneList;
        }
        Test.startTest();
        // Schedule the test job
        String CRON_EXP = '0 0 8,12,16 ? * MON-FRI';
        String jobId = System.schedule('BatchAutoAssignPhoneToAgentsScheduler',
                                       CRON_EXP, 
                                       new BatchAutoAssignPhoneToAgentsScheduler());
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}