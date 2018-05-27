/**********************************************************************
Class Name   : BatchUpdateDuplicateProvidersQueue_Test
Date Created : 28/07/2016
Created By   : Kishore
Description  : Test class
Referenced/Used in : Used to test BatchUpdateDuplicateProvidersQueue
**********************************************************************/
@isTest
public class BatchUpdateDuplicateProvidersQueue_Test {
    
    static TestMethod void createSummaryTestRecords()
    {
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        String queueId = null;
        System.runAs(testUser)
        {
            Group g1 = new Group(Name='PDIDuplicatePhoneNumberQueue', type='Queue');
            insert g1;
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Contact_Validation_Summary__c');
            insert q1;
            queueId = q1.Id;            
            List<Contact_Validation_Summary__c> summaryList = Util01_PDIUtilTestData.createDuplicatePhoneSummaryRecords();
        }
        Test.startTest();
        BatchUpdateDuplicateProvidersQueue summaryBatch = new BatchUpdateDuplicateProvidersQueue();
        Database.executeBatch(summaryBatch);
        Test.stopTest();
        List<Contact_Validation_Summary__c> updatedList = [SELECT Provider_Name__c, Owner.Name, OwnerId, Secure_Phone__c,
                                                           PDI_Campaign__c FROM Contact_Validation_Summary__c 
                                                           WHERE Secure_Phone__c =: '(565) 765-7688'];
        System.assertNotEquals(0, updatedList.size());
    }

}