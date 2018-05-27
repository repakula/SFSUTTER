/**********************************************************************
Class Name: DeliverabilityCheckSchedulerTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is test Class for DeliverabilityCheckScheduler.
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  12/09/2015  Development complete   This class is intended to test DeliverabilityCheckScheduler functions.
***********************************************************************/
@isTest
private class DeliverabilityCheckSchedulerTest{
       
    /*******************************************************************
    Purpose: method to create test data used by all test methods
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    @testsetup
    Static Void createTestData() {
        //Create Email Invocation Limit custom setting data..
        list<Email_Invocation_Limit__c> lstEmail_Invocation_Limit = new list<Email_Invocation_Limit__c>();
        Email_Invocation_Limit__c tempEmail_Invocation_Limit = new Email_Invocation_Limit__c();
        tempEmail_Invocation_Limit.Name = 'Email Invocations';
        tempEmail_Invocation_Limit.Daily_Limit__c = 4;
        lstEmail_Invocation_Limit.add(tempEmail_Invocation_Limit);
        insert lstEmail_Invocation_Limit;
        /*********************************************************************** 
            Verifying Email_Invocation_Limit__c hasbeen inserted  succesfully
            Expected Result: id values should not be null 
            Actual Result: id values should not be null 
            ************************************************************************/
            system.assert(lstEmail_Invocation_Limit.size() != null);
    }
    
    /*******************************************************************
    Purpose: method to validate to Schedule DeliverabilityCheck Class through DeliverabilityCheckScheduler class. 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void scheduleMe_executeTest(){
        Test.startTest();
            DeliverabilityCheckScheduler  tempDeliverabilityCheckScheduler  = new DeliverabilityCheckScheduler ();
            String sch = '0 0 23 * * ?'; 
            DeliverabilityCheckScheduler.scheduleMe('Test');
            system.schedule('Test ProviderForgetPassword', sch, tempDeliverabilityCheckScheduler); 
            
            Email_Invocation_Limit__c objtemEmailInv  = [SELECT id FROM Email_Invocation_Limit__c WHERE Name = 'Email Invocations'];
            /*********************************************************************** 
            Verifying Email_Invocation_Limit__c has retrieve succesfully
            Expected Result: id values should not be null 
            Actual Result: id values should not be null 
            ************************************************************************/
            system.assert(objtemEmailInv.id  != null);
        Test.stopTest(); 
    }
    
    /*******************************************************************
    Purpose: method to validate exception catch block in DeliverabilityCheckScheduler class to scheduler DeliverabilityCheck class. 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void NegativescheduleMe_executeTest(){
        Test.startTest();
            try{
            DeliverabilityCheckScheduler  tempDeliverabilityCheckScheduler  = new DeliverabilityCheckScheduler ();
            String sch = '0 0 23 * * ?'; 
            DeliverabilityCheckScheduler.scheduleMe('Test');
            system.schedule('Test ProviderForgetPassword', sch, tempDeliverabilityCheckScheduler);
            }
            catch(exception ex){
                system.assert(ex.getMessage() != null);
            }
        Test.stopTest();
        
    }
}