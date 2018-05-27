/**  
*    Class Name: EAFValidationReportScheduler_Test
*    Author: Hussain Khan
*    Date: 29/7/2016
*    Description: Test Class for EAFValidationReportScheduler schedule class and EAFValidationReport_New.
*    History
*
*    VERSION    AUTHOR              DATE          DETAIL 
*      1.0     Hussain Khan         July 29, 2016   Initial Creation
*    --------
**/

@isTest
Public Class EAFValidationReportScheduler_Test{

    Public testMethod static void executeMethod(){

// Execute EAFValidationReportScheduler class execution method
        Test.StartTest();
        EAFValidationReportScheduler EAFv1 = new EAFValidationReportScheduler();
        // Create time scheduled
        String sch = '0 0 23 * * ?'; 
        // Schedule EAFValidationReportScheduler class
        system.schedule('Test Territory Check', sch, EAFv1); 
        Test.stopTest(); 
        
    

    }
    
   /*******************************************************************
    Purpose: Executes the Execution method of EAFValidationReportScheduler class and Batch class.
    Parameters: None
    Returns: none 
    Throws [Exceptions]: None
    ********************************************************************/
    
    Public testMethod static void EAFValidationReportExecute(){
       
        Test.StartTest();        
        // Create record for PDV_EAF_Facility__c  object to use it in start method
        PDV_EAF_Facility__c  PDV_EAF_Facility = new PDV_EAF_Facility__c();
        PDV_EAF_Facility .Last_Verified_Date__c=System.Date.Today()-1;
        
        
        insert PDV_EAF_Facility ;
        // Create object for EAFValidationReport_New batch class
        EAFValidationReport_New objEAFValidationReport = new EAFValidationReport_New();
        
        // Creating List for parameters to execute method of PDV_EAF_Facility__c class
        list<PDV_EAF_Facility__c> clist = new list<PDV_EAF_Facility__c>();
        clist.add(PDV_EAF_Facility);
                
        // Run execute method with Database.Batchable as NULL and list of PDV_EAF_Facility__c records as parameters
        objEAFValidationReport.execute(NULL,clist);
                
        Test.StopTest();
        
    }

}