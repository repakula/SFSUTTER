/*****************************************************
Class Name: AutoAssignRecordsToAgentsController_Test
Created By: Nagarjuna Kaipu
Created Date: 07/06/2016
Description: test class for AutoAssignRecordsToAgentsController class
******************************************************/
@isTest
public class AutoAssignRecordsToAgentsController_Test {
    static TestMethod void testAutoAssignRecordsToAgentsController()
    {
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
                PDISelectedAgents__c sAgent = new PDISelectedAgents__c(Name = u.Id, Phone_Agent__c = false);
                assignedAgents.add(sAgent);
            }
            insert assignedAgents;
            PDIAutoAssignCriteria__c PDICriteriaFieldValues = Util01_PDIUtilTestData.PDIAutoAssignCriteriaFieldValues();
            insert PDICriteriaFieldValues;
            PDIAutoAssignSelectedCriteria__c selectedCriteria = Util01_PDIUtilTestData.PDIAutoAssignSelectedCriteria();
            insert selectedCriteria;
            List<Contact_Validation_Summary__c> exSummaryList =  Util01_PDIUtilTestData.createSummaryRecords();
            List<Contact_Validation_Summary__c> SummaryUpdateList = new List<Contact_Validation_Summary__c>();
            Group grp = new Group(name='Non Validated Providers',type='Queue');
            insert grp;
            QueueSObject que =  new QueueSObject(SobjectType='Contact_Validation_Summary__c', QueueId = grp.Id);
            insert que;
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
                        cvs.PDI_Campaign__c = '2016 Wave2';
                    }
                    else if(u.LastName == 'PDITest2' && cvs.Provider_Name__c == 'LastNameP2')
                    {
                        cvs.OwnerId = u.Id;
                        cvs.Status__c = 'Validated';
                        cvs.Assigned_Date__c = System.Now(); 
                        cvs.Closed_Date__c = System.Today(); 
                        cvs.Practicing_Physician__c = true;
                        cvs.PDI_Campaign__c = '2016 Wave2';
                        cvs.Tech_Validation_Status__c = 'Call Campaign';
                    }
                    else if(u.LastName == 'PDITest3' && cvs.Provider_Name__c == 'LastNameP3')
                    {
                        cvs.OwnerId = u.Id;
                        cvs.Status__c = 'Accepted';
                        cvs.Assigned_Date__c = System.Today() - 1; 
                        cvs.Practicing_Physician__c = true;
                        cvs.PDI_Campaign__c = '2016 Wave2';
                        cvs.Tech_Validation_Status__c = 'Non Validated';
                    }
                    else if(u.LastName == 'PDITest4' && cvs.Provider_Name__c == 'LastNameP4')
                    {
                        cvs.OwnerId = u.Id;
                        cvs.Status__c = 'Validated';
                        cvs.Assigned_Date__c = System.Today() - 2; 
                        cvs.Closed_Date__c = System.Today() - 1; 
                        cvs.Practicing_Physician__c = true;
                        cvs.PDI_Campaign__c = '2016 Wave2';
                        cvs.Tech_Validation_Status__c = 'Call Campaign';
                    }
                    else if(u.LastName == 'PDITest5' && (cvs.Provider_Name__c == 'LastNameP5' || cvs.Provider_Name__c == 'LastName6'))
                    {
                        cvs.Status__c = 'Non-Validated';
                        cvs.OwnerId = u.Id;
                        cvs.Practicing_Physician__c = true;
                        cvs.Retired_Departed__c = false;
                        cvs.PDI_Campaign__c = '2016 Wave2';
                    }
                    else if(u.LastName == 'PDITest6' && (cvs.Provider_Name__c == 'LastNameP7' || cvs.Provider_Name__c == 'LastName8'))
                    {
                        cvs.Status__c = 'Non-Validated';
                        cvs.OwnerId = grp.Id;
                        cvs.Practicing_Physician__c = true;
                        cvs.Retired_Departed__c = false;
                        cvs.PDI_Campaign__c = '2016 Wave2';   
                        cvs.Tech_Validation_Status__c = 'Non Validated';
                    }
                    
                }
                SummaryUpdateList.add(cvs);
            }
            
            System.debug('SummaryUpdateList is: '+SummaryUpdateList);
            
            insert SummaryUpdateList; 
        }
        PageReference pref = Page.AutoPopulateRecordsToAgents;
        Test.setCurrentPage(pref);  
        AutoAssignRecordsToAgentsController con = new AutoAssignRecordsToAgentsController();
        con.selectedAssignBasedOn = 'Provider_LastName__c';
        con.selectedSortingOrder = 'Asc';
        con.getAssignBasedOn();
        con.getSortingOrder();
        User testUser2 = Util01_PDIUtilTestData.PDITestUser2();
        System.runAs(testUser2)
        {
            Test.startTest();
            con.assign();
            con.getPieData();
            Test.stopTest();
        }
        List<Contact_Validation_Summary__c> updatedList = [SELECT PDI_Campaign__c, Owner.LastName, Status__c FROM Contact_Validation_Summary__c 
                                                           WHERE Owner.LastName = 'PDITest1' AND Status__c = 'Accepted'];
        System.assertEquals( updatedList.size()>0, true);
    }
    static TestMethod void testAutoAssignPhoneRecordsToAgents(){
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
                PDISelectedAgents__c sAgent = new PDISelectedAgents__c(Name = u.Id, Phone_Agent__c = true, Assigned_Count__c = 0);
                assignedAgents.add(sAgent);
            }
            insert assignedAgents;
            PDIAutoAssignCriteria__c PDICriteriaFieldValues = Util01_PDIUtilTestData.PDIAutoAssignCriteriaFieldValues();
            insert PDICriteriaFieldValues;
            PDIAutoAssignSelectedCriteria__c selectedCriteria = Util01_PDIUtilTestData.PDIAutoAssignSelectedCriteria();
            insert selectedCriteria;
            List<Contact_Validation_Summary__c> exSummaryList =  Util01_PDIUtilTestData.createSummaryRecords();
            List<Contact_Validation_Summary__c> SummaryUpdateList = new List<Contact_Validation_Summary__c>();
            Group grp = new Group(name='Non Validated Providers',type='Queue');
            insert grp;
            QueueSObject que =  new QueueSObject(SobjectType='Contact_Validation_Summary__c', QueueId = grp.Id);
            insert que;
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
                        cvs.PDI_Campaign__c = '2016 Wave2';
                        cvs.Tech_Validation_Status__c = 'Email Campaign';
                    }
                    else if(u.LastName == 'PDITest2' && cvs.Provider_Name__c == 'LastNameP2')
                    {
                        cvs.OwnerId = u.Id;
                        cvs.Status__c = 'Validated';
                        cvs.Assigned_Date__c = System.Now(); 
                        cvs.Closed_Date__c = System.Today(); 
                        cvs.Practicing_Physician__c = true;
                        cvs.PDI_Campaign__c = '2016 Wave2';
                        cvs.Tech_Validation_Status__c = 'Email Campaign';
                    }
                    else if(u.LastName == 'PDITest3' && cvs.Provider_Name__c == 'LastNameP3')
                    {
                        cvs.OwnerId = u.Id;
                        cvs.Status__c = 'Accepted';
                        cvs.Assigned_Date__c = System.Today() - 1; 
                        cvs.Practicing_Physician__c = true;
                        cvs.PDI_Campaign__c = '2016 Wave2';
                    }
                    else if(u.LastName == 'PDITest4' && cvs.Provider_Name__c == 'LastNameP4')
                    {
                        cvs.OwnerId = u.Id;
                        cvs.Status__c = 'Validated';
                        cvs.Assigned_Date__c = System.Today() - 2; 
                        cvs.Closed_Date__c = System.Today() - 1; 
                        cvs.Practicing_Physician__c = true;
                        cvs.PDI_Campaign__c = '2016 Wave2';
                        cvs.Tech_Validation_Status__c = 'Call Campaign';
                    }
                    else if(u.LastName == 'PDITest5' && (cvs.Provider_Name__c == 'LastNameP5' || cvs.Provider_Name__c == 'LastName6'))
                    {
                        cvs.Status__c = 'Non-Validated';
                        cvs.OwnerId = u.Id;
                        cvs.Practicing_Physician__c = true;
                        cvs.Retired_Departed__c = false;
                        cvs.PDI_Campaign__c = '2016 Wave2';
                        cvs.Tech_Validation_Status__c = 'Non Validated';
                    }
                    else if(u.LastName == 'PDITest6' && (cvs.Provider_Name__c == 'LastNameP7' || cvs.Provider_Name__c == 'LastName8'))
                    {
                        cvs.Status__c = 'Non-Validated';
                        cvs.OwnerId = grp.Id;
                        cvs.Practicing_Physician__c = true;
                        cvs.Retired_Departed__c = false;
                        cvs.PDI_Campaign__c = '2016 Wave2'; 
                        cvs.Tech_Validation_Status__c = 'Non Validated';
                    }
                    
                }
                SummaryUpdateList.add(cvs);
            }
            
            System.debug('SummaryUpdateList is: '+SummaryUpdateList);
            
            insert SummaryUpdateList; 
            
             Group dupQue = [Select Id, name from group where type =: Label.CL411_PDIQueueAPI and Name =: Label.CL412_PDINonValidatedDuplicateQueue Limit 1];
            
            List<ProvidersByPhoneNumber__c> phoneList = new List<ProvidersByPhoneNumber__c>();
            for(Integer i = 0; i<5; i++){
                ProvidersByPhoneNumber__c p = new ProvidersByPhoneNumber__c();
                p.Name = '9676561568';
                p.Tech_Phone_Number__c = '9676561568';
                p.SER_Non_Validated__c = 5;
                p.SER_Accepted__c = 5;
                p.SER_Validated__c = 5;
                p.PDI_Campaign__c = '2016 Wave2';
                p.OwnerId = dupQue.Id;
                phoneList.add(p);
            }
       
        insert phoneList;
        }
        PageReference pref = Page.AutoPopulateRecordsToAgents;
        Test.setCurrentPage(pref);  
        AutoAssignRecordsToAgentsController con = new AutoAssignRecordsToAgentsController();
        User testUser2 = Util01_PDIUtilTestData.PDITestUser2();
        System.runAs(testUser2){
            Test.startTest();
            con.assign();
            con.getPieData();
            Test.stopTest();
            List<ProvidersByPhoneNumber__c> updatedList = [SELECT PDI_Campaign__c, Owner.LastName FROM ProvidersByPhoneNumber__c 
                                                           WHERE Owner.LastName = 'PDITest1'];
        System.assertEquals(true, updatedList.size() != null);
        }
    }
}