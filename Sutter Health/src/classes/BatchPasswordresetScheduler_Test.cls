/*****************************************************
Class Name: BatchPasswordresetScheduler_Test
Created By: Nagarjuna Kaipu
Created Date: 07/06/2016
Description: test class for BatchPasswordresetScheduler class
******************************************************/
@isTest
public class BatchPasswordresetScheduler_Test {
    
    
    static testmethod void passwordresetTest() {
        // CRON expression: ealry morning at 4am. Because this is a test, job executes immediately after Test.stopTest().
        String CRON_EXP = '0 0 4 * * ?';
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
            insert  mgrProfile;
            Contact c= Util01_PDIUtilTestData.createContact();
            insert c;
            
            System.debug('contact is: '+c);
            
            Contact_Validation_Summary__c exSummary =  [Select Id, Email__c, Provider_LastName__c from 
                                                        Contact_Validation_Summary__c Where Provider_LastName__c = 'ContactLastName' Limit 1];
            System.debug('exSummary is: '+exSummary);
            exSummary.Status__c = 'Non-Validated';
            exSummary.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            update exSummary;
        }
        Test.startTest();
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleBatchPasswordReset',
                                       CRON_EXP, 
                                       new BatchPasswordresetScheduler());
        
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
    
    static testmethod void passwordresetTest2() {
        // CRON expression: ealry morning at 4am. Because this is a test, job executes immediately after Test.stopTest().
    	String CRON_EXP = '0 0 4 * * ?';
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
            insert  mgrProfile;
            Contact c= Util01_PDIUtilTestData.createContact();
            insert c;
            
            System.debug('contact is: '+c);
            
            Contact_Validation_Summary__c exSummary =  [Select Id, Email__c, Provider_LastName__c from 
                                                        Contact_Validation_Summary__c Where Provider_LastName__c = 'ContactLastName' Limit 1];
            System.debug('exSummary is: '+exSummary);
            exSummary.Status__c = 'Non-Validated';
            exSummary.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            exSummary.Welcome_Email_Sent_History__c = 'yes';
            update exSummary;
        }
        Test.startTest();
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleBatchPasswordReset',
                                       CRON_EXP, 
                                       new BatchPasswordresetScheduler());
        
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
    
    static testmethod void passwordresetTest3() {
        // CRON expression: ealry morning at 4am. Because this is a test, job executes immediately after Test.stopTest().
    	String CRON_EXP = '0 0 4 * * ?';
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
            insert  mgrProfile;
            Contact c= Util01_PDIUtilTestData.createContact();
            c.LastName = 'ContactLastName1';
            c.Email = 'testEmail@test.com1';
            insert c;
            
            System.debug('contact is: '+c);
            
            Contact_Validation_Summary__c exSummary =  [Select Id, Email__c, Provider_LastName__c from 
                                                        Contact_Validation_Summary__c Where Provider_LastName__c = 'ContactLastName1' Limit 1];
            System.debug('exSummary is: '+exSummary);
            exSummary.Status__c = 'Non-Validated';
            exSummary.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            update exSummary;
        }
        Test.startTest();
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleBatchPasswordReset',
                                       CRON_EXP, 
                                       new BatchPasswordresetScheduler());
        
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
    static testmethod void passwordresetTest4() {
        // CRON expression: ealry morning at 4am. Because this is a test, job executes immediately after Test.stopTest().
    	String CRON_EXP = '0 0 4 * * ?';
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
            insert  mgrProfile;
            Contact c= Util01_PDIUtilTestData.createContact();
            c.LastName = 'ContactLastName1';
            c.Email = 'testEmail@test.com1';
            insert c;
            
            System.debug('contact is: '+c);
            
            Contact_Validation_Summary__c exSummary =  [Select Id, Email__c, Provider_LastName__c from 
                                                        Contact_Validation_Summary__c Where Provider_LastName__c = 'ContactLastName1' Limit 1];
            System.debug('exSummary is: '+exSummary);
            exSummary.Status__c = 'Non-Validated';
            exSummary.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            exSummary.Welcome_Email_Sent_History__c = 'Yes';
            update exSummary;
        }
        Test.startTest();
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleBatchPasswordReset',
                                       CRON_EXP, 
                                       new BatchPasswordresetScheduler());
        
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