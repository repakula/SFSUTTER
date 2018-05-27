/**********************************************************************
Name: AccumulatehoursTriggerTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is the test class for AccumulateTaskDuration.
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  10/20/2014  Development complete   This class is intended to test AccumulateTaskDuration trigger.
***********************************************************************/

    @isTest
    private class AccumulatehoursTriggerTest{
    
    /*******************************************************************
    Purpose: This method creates test data to be used in test methods.It creates Cases of Training recordtype with variations in field values of Actual Level of Effort and Projected Hours
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    
    @testSetup
    static void createTestData(){
        
        /** List of Case to be used to insert Case records **/
        List<Case> lstCasesIns = new List<Case>();  
        
        /** Creating a Case record for Training recordtype and populating data in Projected Hours and Actual Level of Effort **/
        Case objCaseProjectedHrs = new Case(
            RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Training').RecordTypeId,
            Projected_Hours__c = 5,
            Actual_Level_Of_Effort__c = 2
        );
        
        lstCasesIns.add(objCaseProjectedHrs);
        
        /** Creating a Case record for Training recordtype and populating data in Actual Level of Effort **/
        Case objCaseNonProjectedHrs = new Case(
            RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Training').RecordTypeId,
            Actual_Level_Of_Effort__c = 2
        );
        
        lstCasesIns.add(objCaseNonProjectedHrs);
        
        /** Creating a Case record for Training recordtype only **/
        Case objCaseNoHrsNoEffort = new Case(
            RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Training').RecordTypeId,
            Actual_Level_Of_Effort__c = null
        );
        
        lstCasesIns.add(objCaseNoHrsNoEffort);
                
        insert lstCasesIns;
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: null
        Actual Result: null 
        ***********************************************************************/
        Case objTestCase = [select id from Case where  Projected_Hours__c = 5 AND Actual_Level_Of_Effort__c = 2 limit 1];
        system.assertNotEquals(objTestCase.id,null);
        
    }
    
    /*******************************************************************
    Purpose: This test method inserts Task records attached to a Case which has Projected hours value present in it.Case's Projected Hours value remains unchanged even after trigger processing
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testMethod void insertTasks_withCaseProjectedHours() {
        
        Test.startTest();
        
        /** Fetching the id of Case with value present in both Projected Hours and Actual Level of Effort **/
        String strCaseProjectedHrs = [select id from Case where  Projected_Hours__c = 5 AND Actual_Level_Of_Effort__c = 2 limit 1].id;
                
        List<Task> taskList = new List<Task>();
        
        /** Creating 100 task records specifying CaseId with above created Case's id and inserting them **/
        for(Integer i = 0; i < 100; i++){
          
            Task loopTask = new Task();
            loopTask.WhatId = strCaseProjectedHrs;
            taskList.add(loopTask);
        }
        insert taskList;
        // Assert to check task are inserted successfully
        system.assert(taskList!=null);
                
        Test.stopTest();
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: 5
        Actual Result: 5    
        ***********************************************************************/
        Case objCase = [select id,Projected_Hours__c from Case where id=:strCaseProjectedHrs];
        system.assertEquals(objCase.Projected_Hours__c,5);
    }
    
    /*******************************************************************
    Purpose: This test method inserts Task records attached to a Case which has Projected hours value not present in it and Case's Projected Hours value remains unchanged(it comes out to be null) after processing of the trigger completes
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testMethod void insertTasks_withOutCaseProjectedHours() {
        
        Test.startTest();
        
        /** Fetching the id of Case with null value in Projected Hours but value present in Actual Level of Effort **/
        String strCaseNonProjectedHrs = [select id from Case where  Projected_Hours__c = null AND Actual_Level_Of_Effort__c = 2 limit 1].id;
               
        List<Task> taskList = new List<Task>();
        
        /** Creating 100 task records specifying CaseId with above created Case's id and inserting them **/
        for(Integer i = 0; i < 100; i++){
          
            Task loopTask = new Task();
            loopTask.WhatId = strCaseNonProjectedHrs;
            taskList.add(loopTask);
        }
        insert taskList;
        // Assert to check task are inserted successfully
        system.assert(taskList!=null);
        
        Test.stopTest();
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: null
        Actual Result: null 
        ***********************************************************************/
        Case objCase = [select id,Projected_Hours__c from Case where id=:strCaseNonProjectedHrs];
        system.assertEquals(objCase.Projected_Hours__c,null);
        
    }
    
    /*******************************************************************
    Purpose: This test method creates Tasks with Status as Completed and covers the logic related to Task insertion scenario in trigger where Completed Tasks are being processed for Effort value mentioned in the Case.At the end,Case's Actual Level of Effort value is unchanged
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testMethod void insertTasks_withOutCaseProjectedHours_Completed_Negative() {
        
        Test.startTest();
        
        /** Fetching the id of Case with null value in Projected Hours but value present in Actual Level of Effort **/
        String strCaseNonProjectedHrs = [select id from Case where  Projected_Hours__c = null AND Actual_Level_Of_Effort__c = 2 limit 1].id;
              
        List<Task> taskList = new List<Task>();
        
        /** Creating 100 task records specifying CaseId with above created Case's id and inserting them **/
        for(Integer i = 0; i < 100; i++){
          
            Task loopTask = new Task();
            loopTask.Status='Completed';
            loopTask.WhatId = strCaseNonProjectedHrs;
            taskList.add(loopTask);
        }
        insert taskList;
        // Assert to check task are inserted successfully
        system.assert(taskList!=null);
        
        Test.stopTest();
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: 2
        Actual Result: 2
        ***********************************************************************/
        Case objCase = [select id,Actual_Level_of_Effort__c from Case where id=:strCaseNonProjectedHrs];
        system.assertEquals(objCase.Actual_Level_of_Effort__c,2);
    }
    
    /*******************************************************************
    Purpose: This test method creates Tasks with Status as Completed and covers the logic related to Task insertion scenario in trigger where Completed Tasks are being processed for Effort value not mentioned in the Case.After the processing is over,Case's Actual Level of Effort value is unchanged
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testMethod void insertTasks_withOutProjectedHours_WithoutEffort_Completed() {
        
         Test.startTest();
         
        /** Fetching the id of Case with null value in both Projected Hours and Actual Level of Effort **/
        String strCaseNoHrsNoEffort = [select id from Case where  Projected_Hours__c = null AND Actual_Level_Of_Effort__c = null limit 1].id;
            
        List<Task> taskList = new List<Task>();
        
        /** Creating 100 task records specifying CaseId with above created Case's id and inserting them **/
        for(Integer i = 0; i < 100; i++){
          
            Task loopTask = new Task();
            loopTask.Status='Completed';
            loopTask.WhatId = strCaseNoHrsNoEffort;
            taskList.add(loopTask);
        }
        insert taskList;
        // Assert to check task are inserted successfully
        system.assert(taskList!=null);
        
        Test.stopTest();
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: null
        Actual Result: null 
        ***********************************************************************/
        Case objCase = [select id,Actual_Level_of_Effort__c from Case where id=:strCaseNoHrsNoEffort];
        system.assertEquals(objCase.Actual_Level_of_Effort__c,null);
        
    }
            
    /*******************************************************************
    Purpose: This test method creates Tasks with Status as In Progress and covers the logic related to Task updation scenario in trigger where Completed Tasks are being processed for Effort value not mentioned in the Case.Post successful processing,Case's Actual Level of Effort value is unchanged
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testMethod void updateTasks_withOutProjectedHours_WithoutEffort_Completed_Negative() {
        
        Test.startTest();
        
        /** Fetching the id of Case with null value in both Projected Hours and Actual Level of Effort **/
        String strCaseNoHrsNoEffort = [select id from Case where  Projected_Hours__c = null AND Actual_Level_Of_Effort__c = null limit 1].id;
        
        List<task> lstTaskUpd = new List<Task>();
        List<Task> taskList = new List<Task>();
        
        /** Creating 100 task records specifying CaseId with above created Case's id and inserting them with In Progress Status**/
        for(Integer i = 0; i < 100; i++){
          
            Task loopTask = new Task();
            loopTask.Status='In Progress';
            loopTask.WhatId = strCaseNoHrsNoEffort;
            taskList.add(loopTask);
         }
         insert taskList;
         // Assert to check task are inserted successfully
        system.assert(taskList!=null);
    
        /** Updating the Tasks with Completed Status  **/
        for(Task objTask:taskList){
        
        objTask.Status = 'Completed';
        lstTaskUpd.add(objTask);
                
        }
    
        update lstTaskUpd;
    
        Test.stopTest();
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: null
        Actual Result: null 
        ***********************************************************************/
        Case objCase = [select id,Actual_Level_of_Effort__c from Case where id=:strCaseNoHrsNoEffort];
        system.assertEquals(objCase.Actual_Level_of_Effort__c,null);
    
    }

    /*******************************************************************
    Purpose:This test method creates Tasks with Status as In Progress and covers the logic related to Task updation scenario in trigger where Completed Tasks are being processed for Effort value mentioned in the Case.Post successful processing,Case's Actual Level of Effort value is unchanged
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testMethod void updateTasks_withOutProjectedHours_Completed() {
        
        Test.startTest();
        
        /** Fetching the id of Case with null value in Projected Hours but value present in Actual Level of Effort **/
        String strCaseNonProjectedHrs = [select id from Case where  Projected_Hours__c = null AND Actual_Level_Of_Effort__c = 2 limit 1].id;
        
        List<task> lstTaskUpd = new List<Task>();
        List<Task> taskList = new List<Task>();
        
        /** Creating 100 task records specifying CaseId with above created Case's id and inserting them with In Progress Status**/
        for(Integer i = 0; i < 100; i++){
          
            Task loopTask = new Task();
            loopTask.Status='In Progress';
            loopTask.WhatId = strCaseNonProjectedHrs;
            taskList.add(loopTask);
        }
        insert taskList;
        // Assert to check task are inserted successfully
        system.assert(taskList!=null);
    
        /** Updating the Tasks with Completed Status  **/
        for(Task objTask:taskList){
        
        objTask.Status = 'Completed';
        lstTaskUpd.add(objTask);
                
       }
    
       update lstTaskUpd;
    
       Test.stopTest();
       
       /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: 2
        Actual Result: 2    
        ***********************************************************************/
        Case objCase = [select id,Actual_Level_of_Effort__c from Case where id=:strCaseNonProjectedHrs];
        system.assertEquals(objCase.Actual_Level_of_Effort__c,2);
    
    }

}