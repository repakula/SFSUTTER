/**********************************************************************
Name: LeadTrigger_Test
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is the test class for LeadTrigger.
======================================================
======================================================
History
-------
VERSION             AUTHOR              DATE                DETAIL                  Description
1.0                 Sandeep Sharma      05-11-2015      INITIAL DEVELOPMENT         This class is intended to test LeadTrigger
***********************************************************************/
@isTest
public class LeadTrigger_Test {

//Static variables
 private static final String Candidate_Last_name = 'Test Last Name';
 private static final String Candidate_Email = 'test@test.com';
 private static final String Candidate_FirstName = 'Test First Name'; 
  private static final String Candidate_LeadSource = 'LinkedIn';
  private static final String Candidate_Status = 'Candidate Qualified';
  private static final String Candidate_Company = 'Test Company';
 private static final String Lead_Not_Started = 'Not Started';
 private static final String Lead_InProgress = 'In progress';
 

    /**
     * @author : Sandeep Sharma
     * @date :  10/27/2015
     * @description: Test method for bulk insertion of candidate lead.
     * @param : N/A
     * @return : void
     */

    static testMethod void bulkCandidateLeadInsertion() {

        RecordType leadRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'Lead'
            And DeveloperName = : Label.CL06_Candidate Limit 1
        ];
        List < Lead > candList = new List < lead > ();
        for (integer i = 0; i < 100; i++) {
            Lead candidateLead = new Lead();
            candidateLead.LastName = Candidate_Last_name;
            candidateLead.Email = 'test' + string.valueOf(i) + '@test.com';
            candidateLead.FirstName = Candidate_FirstName;
            candidateLead.LeadSource = Candidate_LeadSource;
            candidateLead.Status = Candidate_Status;
            candidateLead.Company = Candidate_Company;
            candidateLead.X30_Day_Connect_Session__c = true;
            candidateLead.First_Contact_Date__c = System.now().date();
            candidateLead.recordtypeid = leadRecordType.id;
            candList.add(candidateLead);
        }
        test.startTest();
        insert candList;
        test.stopTest();
        Set<Id> lIds = new Set<Id>();
        for(Lead l : candList){
            lIds.add(l.Id);
        }
       
        
        List<Task> t30List = [Select Id From Task Where WhoId In : lIds And Candidate_Connect__c =: Label.CL_30_days];
       
        System.AssertEquals(t30List.size(), 100);
        
        

    }

    /**
     * @author : Sandeep Sharma
     * @date :  10/27/2015
     * @description: Test method to support negative case. Last name and email are required but we are not passing these values.
     * @param : N/A
     * @return : void
     */

    static testMethod void negativeLeadInsertionMethod() {
        RecordType leadRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'Lead'
            And DeveloperName = : Label.CL06_Candidate Limit 1
        ];
        Lead candidateLead = new Lead();
        candidateLead.FirstName = Candidate_FirstName;
        candidateLead.LeadSource = Candidate_LeadSource ;
        candidateLead.Status = Candidate_Status ;
        candidateLead.Company = Candidate_Company ;
        candidateLead.X30_Day_Connect_Session__c = true;
        candidateLead.X60_Day_Connect_Session__c = true;
        candidateLead.First_Contact_Date__c = System.now().date();
        candidateLead.recordtypeid = leadRecordType.id;
        test.startTest();
        try {
            insert candidateLead;
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('Email is mandatory for Candidate Records') ? true : false;         
            System.AssertEquals(expectedExceptionThrown, true);
            
        }
        test.stopTest();

    }
    
       /**
     * @author : Sandeep Sharma
     * @date :  10/27/2015
     * @description: Test method to test candiate lead with 30 days connect task, and this task is in in-progress mode. There will be an exception.
     * @param : N/A
     * @return : N/A
     */

    static testMethod void  lead30DaysConnectNegativeCase() {
        test.startTest();
        try

        {
            RecordType leadRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'Lead'
                And DeveloperName = : Label.CL06_Candidate Limit 1
            ];
            Lead candidateLead = new Lead();
            candidateLead.LastName = Candidate_Last_name ;
            candidateLead.Email = Candidate_Email ;
            candidateLead.FirstName = Candidate_FirstName ;
            candidateLead.LeadSource = Candidate_LeadSource ;
            candidateLead.Status = Candidate_Status ;
            candidateLead.Company = Candidate_Company ;
            candidateLead.X30_Day_Connect_Session__c = true;
            candidateLead.First_Contact_Date__c = System.now().date();
            insert candidateLead;
            List < Task > taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
            for (Task t: taskList) {
                t.Status = Lead_InProgress;
            }
            update taskList;
            candidateLead.X30_Day_Connect_Session__c = false;
            update candidateLead;

        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('as there is an attached active task') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        test.stopTest();
    }

    /**
     * @author : Sandeep Sharma
     * @date :  10/27/2015
     * @description: Test method to test candiate lead with 60 days connect task, and this task is in in-progress mode. There will be an exception.
     * @param : N/A
     * @return : N/A
     */

    static testMethod void lead60DaysConnectPositiveCase() {

        RecordType leadRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'Lead'
            And DeveloperName = : Label.CL06_Candidate Limit 1
        ];
        Lead candidateLead = new Lead();
        candidateLead.LastName = Candidate_Last_name ;
        candidateLead.Email = Candidate_Email ;
        candidateLead.FirstName = Candidate_FirstName ;
        candidateLead.LeadSource = Candidate_LeadSource ;
        candidateLead.Status = Candidate_Status ;
        candidateLead.Company = Candidate_Company ;
        candidateLead.X30_Day_Connect_Session__c = true;
        candidateLead.X60_Day_Connect_Session__c = true;
        candidateLead.First_Contact_Date__c = System.now().date();

        test.startTest();
        insert candidateLead;
        candidateLead.X30_Day_Connect_Session__c = false;
        candidateLead.X60_Day_Connect_Session__c = false;
        update candidateLead;
        candidateLead.X30_Day_Connect_Session__c = true;
        update candidateLead;
        List < Task > taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
        for (Task t: taskList) {
            t.Status = Lead_InProgress;
        }
        update taskList;

        candidateLead.X60_Day_Connect_Session__c = true;
        update candidateLead;
        taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
        for (Task t: taskList) {
            if (t.Candidate_Connect__c == Label.CL_30_days)
                t.Status = Lead_Not_Started;
        }
        update taskList;
        candidateLead.X30_Day_Connect_Session__c = true;
        candidateLead.X60_Day_Connect_Session__c = false;
        update candidateLead;
        
        
        List<Task> t60List = [Select Id From Task Where WhoId  =: candidateLead.Id And Candidate_Connect__c =: Label.CL_60_days];
        System.AssertEquals(t60List.size(), 0);
        
        test.stopTest();


    }

       /**
     * @author : Sandeep Sharma
     * @date :  10/27/2015
     * @description:  Test method to test candiate lead with 90 days connect task, and this task is in in-progress mode. There will be an exception.
     * @param : N/A
     * @return : N/A
     */

    static testMethod void lead90DaysConnectNegativeCase() {
            test.startTest();
            try

            {
                RecordType leadRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'Lead'
                    And DeveloperName = : Label.CL06_Candidate Limit 1
                ];
                Lead candidateLead = new Lead();
                candidateLead.LastName = Candidate_Last_name ;
                candidateLead.Email = Candidate_Email ;
                candidateLead.FirstName = Candidate_FirstName ;
                candidateLead.LeadSource =Candidate_LeadSource ;
                candidateLead.Status = Candidate_Status ;
                candidateLead.Company = Candidate_Company ;
                candidateLead.X90_Day_Connect_Session__c = true;

                candidateLead.First_Contact_Date__c = System.now().date();


                insert candidateLead;

                List < Task > taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
                for (Task t: taskList) {
                    t.Status = Lead_InProgress;
                }
                update taskList;

                candidateLead.X90_Day_Connect_Session__c = false;
                update candidateLead;

            } catch (Exception e) {
                Boolean expectedExceptionThrown = e.getMessage().contains('as there is an attached active task') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
            test.stopTest();
        }
        /**
         * @author : Sandeep Sharma
         * @date :  10/27/2015
         * @description: Test method to test deletion of 'not started' task while de-selecting corresponding candidate connect task.
         * @param : N/A
         * @return : N/A
         */

    static testMethod void  Lead30DaysConnectInsertion() {
        RecordType leadRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'Lead'
            And DeveloperName = : Label.CL06_Candidate Limit 1
        ];
        Lead candidateLead = new Lead();
        candidateLead.LastName = Candidate_Last_name ;
        candidateLead.Email = Candidate_Email ;
        candidateLead.FirstName = Candidate_FirstName ;
        candidateLead.LeadSource = Candidate_LeadSource ;
        candidateLead.Status = Candidate_Status ;
        candidateLead.Company = Candidate_Company ;
        candidateLead.X30_Day_Connect_Session__c = true;
        candidateLead.X90_Day_Connect_Session__c = true;
        candidateLead.First_Contact_Date__c = System.now().date();

        test.startTest();
        insert candidateLead;
        candidateLead.X30_Day_Connect_Session__c = false;
        candidateLead.X90_Day_Connect_Session__c = false;
        update candidateLead;
        candidateLead.X90_Day_Connect_Session__c = true;
        update candidateLead;
        List < Task > taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
        for (Task t: taskList) {
            t.Status = Lead_InProgress;
        }
        update taskList;
        candidateLead.X30_Day_Connect_Session__c = true;
        update candidateLead;

        
        taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
        for (Task t: taskList) {
            if (t.Candidate_Connect__c == Label.CL_90_days)
                t.Status = Lead_Not_Started;
        }
        update taskList;
        candidateLead.X90_Day_Connect_Session__c = true;
        candidateLead.X30_Day_Connect_Session__c = false;
        update candidateLead;
        
        
        List<Task> t30List = [Select Id From Task Where WhoId  =: candidateLead.Id And Candidate_Connect__c =: Label.CL_30_days];
        System.AssertEquals(t30List.size(), 0);
        
        test.stopTest();

    }
    
     /**
     * @author : Sandeep Sharma
     * @date :  10/27/2015
     * @description: testNegativeLead60 includes data for a lead(with 60 day checkbox as true) for which we have a task in active mode .
     * @param : N/A
     * @return : N/A
     */


    static testMethod void lead60DaysConnectNegativeCase() {
        test.startTest();
        try

        {
            RecordType leadRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'Lead'
                And DeveloperName = : Label.CL06_Candidate Limit 1
            ];
            Lead candidateLead = new Lead();
            candidateLead.LastName = Candidate_Last_name ;
            candidateLead.Email = Candidate_Email ;
            candidateLead.FirstName = Candidate_FirstName ;
            candidateLead.LeadSource = Candidate_LeadSource ;
            candidateLead.Status = Candidate_Status ;
            candidateLead.Company = Candidate_Company ;
            candidateLead.X60_Day_Connect_Session__c = true;

            candidateLead.First_Contact_Date__c = System.now().date();


            insert candidateLead;

            List < Task > taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
            for (Task t: taskList) {
                t.Status = Lead_InProgress;
            }
            update taskList;

            candidateLead.X60_Day_Connect_Session__c = false;
            update candidateLead;

        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('as there is an attached active task') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        test.stopTest();
    }

    /**
     * @author : Sandeep Sharma
     * @date :  10/27/2015
     * @description: testAfterInsertLead90 includes data for insertion of records with 60 day checkbox as true.
     * @param : N/A
     * @return : N/A
     */

    static testMethod void lead90DaysConnectInsertion() {
        RecordType leadRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'Lead'
            And DeveloperName = : Label.CL06_Candidate Limit 1
        ];
        Lead candidateLead = new Lead();
        candidateLead.LastName = Candidate_Last_name ;
        candidateLead.Email = Candidate_Email ;
        candidateLead.FirstName = Candidate_FirstName ;
        candidateLead.LeadSource = Candidate_LeadSource ;
        candidateLead.Status = Candidate_Status ;
        candidateLead.Company = Candidate_Company ;
        candidateLead.X60_Day_Connect_Session__c = true;
        candidateLead.X90_Day_Connect_Session__c = true;
        candidateLead.First_Contact_Date__c = System.now().date();

        test.startTest();
        insert candidateLead;
        candidateLead.X60_Day_Connect_Session__c = false;
        candidateLead.X90_Day_Connect_Session__c = false;
        update candidateLead;
        candidateLead.X60_Day_Connect_Session__c = true;
        update candidateLead;
        List < Task > taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
      
        for (Task t: taskList) {
            t.Status = Lead_InProgress;
        }
        update taskList;
        candidateLead.X90_Day_Connect_Session__c = true;
        update candidateLead;
        taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
        for (Task t: taskList) {
            if (t.Candidate_Connect__c == Label.CL_60_days)
                t.Status = Lead_Not_Started;
        }
        update taskList;
        candidateLead.X60_Day_Connect_Session__c = true;
        candidateLead.X90_Day_Connect_Session__c = false;
        update candidateLead;
        
        List<Task> t90List = [Select Id From Task Where WhoId  =: candidateLead.Id And Candidate_Connect__c =: Label.CL_90_days];
        System.AssertEquals(t90List.size(), 0);        
        
        test.stopTest();
    } 
    
     /**
     * @author : Anupam Goel
     * @date :  11/20/2015
     * @description: testAfterInsertLead901 includes data for 90 days method.
     * @param : N/A
     * @return : N/A
     */

    static testMethod void insertLeadWith90DaysConnect() {
        RecordType leadRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'Lead'
            And DeveloperName = : Label.CL06_Candidate Limit 1
        ];
         Lead candidateLead = new Lead();
        candidateLead.LastName = Candidate_Last_name ;
        candidateLead.Email = Candidate_Email ;
        candidateLead.FirstName = Candidate_FirstName ;
        candidateLead.LeadSource = Candidate_LeadSource ;
        candidateLead.Status = Candidate_Status ;
        candidateLead.Company = Candidate_Company ;
        candidateLead.X60_Day_Connect_Session__c = true;
        candidateLead.X90_Day_Connect_Session__c = true;
        candidateLead.First_Contact_Date__c = System.now().date();
        candidateLead.recordtypeid = leadRecordType.id;
        test.startTest();
        insert candidateLead;
        candidateLead.X60_Day_Connect_Session__c = false;
        candidateLead.X90_Day_Connect_Session__c = false;
        update candidateLead;
        candidateLead.X60_Day_Connect_Session__c = true;
        update candidateLead;

        List < Task > taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
      
        for (Task t: taskList) {
            t.Candidate_Connect__c = Label.CL_90_days;
        }
        update taskList;
        candidateLead.X90_Day_Connect_Session__c = true;
        update candidateLead;
                
        List<Task> t90List = [Select Id From Task Where WhoId  =: candidateLead.Id And Candidate_Connect__c =: Label.CL_90_days];
        System.AssertNotEquals(t90List.size(), 0);
            
        test.stopTest();
    }
    
     /**
     * @author : Anupam Goel
     * @date :  11/20/2015
     * @description: testAfterInsertLead301 includes data for 30 days method.
     * @param : N/A
     * @return : N/A
     */

    static testMethod void insertLeadWith30DaysConnect() {
        RecordType leadRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'Lead'
            And DeveloperName = : Label.CL06_Candidate Limit 1
        ];
        Lead candidateLead = new Lead();
         candidateLead.LastName = Candidate_Last_name ;
        candidateLead.Email = Candidate_Email ;
        candidateLead.FirstName = Candidate_FirstName ;
        candidateLead.LeadSource = Candidate_LeadSource ;
        candidateLead.Status = Candidate_Status ;
        candidateLead.Company = Candidate_Company ;
        candidateLead.X30_Day_Connect_Session__c = true;
        candidateLead.X90_Day_Connect_Session__c = true;
        candidateLead.First_Contact_Date__c = System.now().date();
        candidateLead.recordtypeid = leadRecordType.id;
        test.startTest();
        insert candidateLead;
        candidateLead.X30_Day_Connect_Session__c = false;
        candidateLead.X90_Day_Connect_Session__c = false;
        update candidateLead;
        candidateLead.X90_Day_Connect_Session__c = true;
        update candidateLead;
        List < Task > taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
        for (Task t: taskList) {
           t.Candidate_Connect__c = Label.CL_30_days;
        }
        update taskList;
        candidateLead.X30_Day_Connect_Session__c = true;
        update candidateLead;
                            
        List<Task> t30List = [Select Id From Task Where WhoId  =: candidateLead.Id And Candidate_Connect__c =: Label.CL_30_days];
        System.AssertNotEquals(t30List.size(), 0);
        
        test.stopTest();

    }
    
      /**
     * @author : Anupam Goel
     * @date :  11/20/2015
     * @description: testAfterInsertLead601 includes data for 60 days method.
     * @param : N/A
     * @return : N/A
     */


    static testMethod void insertLeadWith60DaysConnect() {

        RecordType leadRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'Lead'
            And DeveloperName = : Label.CL06_Candidate Limit 1
        ];
        Lead candidateLead = new Lead();
        candidateLead.LastName = Candidate_Last_name ;
        candidateLead.Email = Candidate_Email ;
        candidateLead.FirstName = Candidate_FirstName ;
        candidateLead.LeadSource = Candidate_LeadSource ;
        candidateLead.Status = Candidate_Status ;
        candidateLead.Company = Candidate_Company ;
        candidateLead.X30_Day_Connect_Session__c = true;
        candidateLead.X60_Day_Connect_Session__c = true;
        candidateLead.First_Contact_Date__c = System.now().date();
        candidateLead.recordtypeid = leadRecordType.id;
        test.startTest();
        insert candidateLead;
        candidateLead.X30_Day_Connect_Session__c = false;
        candidateLead.X60_Day_Connect_Session__c = false;
        update candidateLead;
        candidateLead.X30_Day_Connect_Session__c = true;
        update candidateLead;
        List < Task > taskList = [Select Id, status, Candidate_Connect__c From Task Where WhoId = : candidateLead.Id];
        for (Task t: taskList) {
             t.Candidate_Connect__c = Label.CL_60_days;
        }
        update taskList;

        candidateLead.X60_Day_Connect_Session__c = true;
        update candidateLead;        
        
        List<Task> t60List = [Select Id From Task Where WhoId  =: candidateLead.Id And Candidate_Connect__c =: Label.CL_60_days];
        System.AssertNotEquals(t60List.size(), 0);
        
        test.stopTest();
    }    
}