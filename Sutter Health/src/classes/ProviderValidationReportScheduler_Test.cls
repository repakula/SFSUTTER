/**  
*    Class Name: ProviderValidationReportScheduler_Test
*    Author: Umesh Vajpai
*    Date: 27/7/2016
*    Description: Test Class for ProviderValidationReportScheduler schedule class and ProviderValidationReport_New.
*    History
*
*    VERSION    AUTHOR              DATE          DETAIL 
*      1.0     Priyatham         July 27, 2016   Initial Creation
*    --------
**/

@isTest
Public Class ProviderValidationReportScheduler_Test{

    /*******************************************************************
    Purpose: Executes the method of ProviderValidationReportScheduler class and Batch class .
    Parameters: None
    Returns: none 
    Throws [Exceptions]: None
    ********************************************************************/
    
    Public testMethod static void executeMethod(){
    
        // Execute ProviderValidationReportScheduler class execution method
        Test.StartTest();
        ProviderValidationReportScheduler pv1 = new ProviderValidationReportScheduler();
        // Create time scheduled
        String sch = '0 0 23 * * ?'; 
        // Schedule ProviderValidationReportScheduler class
        system.schedule('Test Territory Check', sch, pv1); 
        Test.stopTest(); 
        
    } 
    
    /*******************************************************************
    Purpose: Executes the Execution method of ProviderValidationReportScheduler class and Batch class.
    Parameters: None
    Returns: none 
    Throws [Exceptions]: None
    ********************************************************************/
    
    Public testMethod static void ProviderValidationReportExecute(){
        // Recordtype id for adding it to contact
        string RecTypeId = [Select Id from RecordType where SObjectType = :'Contact' AND DeveloperName = 'Provider'].Id;
        // Created contact with employee record type
        Contact con = new Contact(Employee_ID__c='121212',LastName='Test Contact',Employee_Work_Email__c='test@accenture.com',Email='test@accenture.com',Phone='2123545',recordtypeid=RecTypeId);
        insert con;
        
        Test.StartTest();        
        // Create record for Contact_Validation_Summary__c object to use it in start method
        Contact_Validation_Summary__c objContactValidationSummary = new Contact_Validation_Summary__c();
        objContactValidationSummary .Last_Verified_Date__c=System.Date.Today()-1;
        objContactValidationSummary .Address_Type__c='Secondary';
        objContactValidationSummary .Contact_Id__c=con.Id;
        insert objContactValidationSummary ;
        // Create object for ProviderValidationReport_New batch class
        ProviderValidationReport_New objProviderValidationReport = new ProviderValidationReport_New();
        
        // Creating List for parameters to execute method of Contact_Validation_Summary__c class
        list<Contact_Validation_Summary__c> clist = new list<Contact_Validation_Summary__c>();
        clist.add(objContactValidationSummary);
                
        // Run execute method with Database.Batchable as NULL and list of Contact_Validation_Summary__c records as parameters
        objProviderValidationReport.execute(NULL,clist);
                
        Test.StopTest();
        
    }
}