/*****************************************************
Class Name: BatchAutoAssignToAgentsScheduler_Test
Created By: Nagarjuna Kaipu
Created Date: 07/06/2016
Description: test class for BatchAutoAssignToAgentsScheduler class
******************************************************/
@isTest
public class BatchAutoAssignToAgentsScheduler_Test {
    static testmethod void testBatchAutoAssignToAgents() {
        List<User> PDIAgents =  Util01_PDIUtilTestData.createPDIAgents();
        insert PDIAgents;
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
            insert  mgrProfile;
            List<PDISelectedAgents__c> assignedAgents = new List<PDISelectedAgents__c>();
            List<User> uList = [Select Id, Name from User Where Name Like '%PDITest%'];
            for(User u: uList)
            {
                PDISelectedAgents__c sAgent = new PDISelectedAgents__c(Name = u.Id);
                assignedAgents.add(sAgent);
            }
            insert assignedAgents;
            PDIAutoAssignSelectedCriteria__c selectedCriteria = Util01_PDIUtilTestData.PDIAutoAssignSelectedCriteria();
            insert selectedCriteria;
            List<Contact_Validation_Summary__c> exSummaryList =  Util01_PDIUtilTestData.createSummaryRecords();
            List<Contact_Validation_Summary__c> SummaryUpdateList = new List<Contact_Validation_Summary__c>();
            Group grp = [Select Id, name from group where type = 'queue' 
                     and Name =: Label.CL211_PDIQueue Limit 1];
            for(Contact_Validation_Summary__c cvs: exSummaryList)
            {
                for(User u: PDIAgents)
                {
                    if(u.LastName == 'PDITest1' && cvs.Provider_Name__c == 'LastNameP1')
                    {
                        cvs.OwnerId = u.Id;
                        cvs.Status__c = 'Accepted';
                        cvs.Assigned_Date__c = System.now();  
                        cvs.Practicing_Physician__c = true;
                        cvs.PDI_Campaign__c = '2016 Wave1';
                    }
                    else if(u.LastName == 'PDITest2' && cvs.Provider_Name__c == 'LastNameP2')
                    {
                        cvs.OwnerId = u.Id;
                        cvs.Status__c = 'Validated';
                        cvs.Assigned_Date__c = System.Now(); 
                        cvs.Closed_Date__c = System.Today(); 
                        cvs.Practicing_Physician__c = true;
                        cvs.PDI_Campaign__c = '2016 Wave1';
                    }
                    else if(u.LastName == 'PDITest3' && cvs.Provider_Name__c == 'LastNameP3')
                    {
                        cvs.OwnerId = u.Id;
                        cvs.Status__c = 'Accepted';
                        cvs.Assigned_Date__c = System.Today() - 1; 
                        cvs.Practicing_Physician__c = true;
                        cvs.PDI_Campaign__c = '2016 Wave1';
                    }
                    else if(u.LastName == 'PDITest4' && cvs.Provider_Name__c == 'LastNameP4')
                    {
                        cvs.OwnerId = u.Id;
                        cvs.Status__c = 'Validated';
                        cvs.Assigned_Date__c = System.Today() - 2; 
                        cvs.Closed_Date__c = System.Today() - 1; 
                        cvs.Practicing_Physician__c = true;
                        cvs.PDI_Campaign__c = '2016 Wave1';
                    }
                    else if(u.LastName == 'PDITest5' && (cvs.Provider_Name__c == 'LastNameP5' || cvs.Provider_Name__c == 'LastName6'))
                    {
                        cvs.Status__c = 'Non-Validated';
                        cvs.OwnerId = u.Id;
                        cvs.Practicing_Physician__c = true;
                        cvs.Retired_Departed__c = false;
                        cvs.PDI_Campaign__c = '2016 Wave1';
                    }
                    else if(u.LastName == 'PDITest6' && (cvs.Provider_Name__c == 'LastNameP7' || cvs.Provider_Name__c == 'LastName8'))
                    {
                        cvs.Status__c = 'Non-Validated';
                        cvs.OwnerId = grp.Id;
                        cvs.Practicing_Physician__c = true;
                        cvs.Retired_Departed__c = false;
                        cvs.PDI_Campaign__c = '2016 Wave1';   
                    }
                }
                SummaryUpdateList.add(cvs);
            }

            insert SummaryUpdateList; 
        }
        Test.startTest();
        // Schedule the test job
        String CRON_EXP = '0 0 8,12,16 ? * MON-FRI';
        String jobId = System.schedule('BatchAutoAssignRecordsToAgentsScheduler',
                                       CRON_EXP, 
                                       new BatchAutoAssignRecordsToAgentsScheduler());
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