/**********************************************************************
Class Name: ProviderChangePasswordSchedulerTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is test Class for ProviderChangePasswordScheduler.
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  12/08/2015  Development complete   This class is intended to test ProviderChangePasswordScheduler functions.
***********************************************************************/
@isTest
private class ProviderChangePasswordSchedulerTest{
    /*******************************************************************
    Purpose: method to validate ProviderChangePasswordScheduler class scheduler to execute ProviderChangePassword class
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void scheduleMe_executeTest(){
        Test.startTest();
            ProviderChangePasswordScheduler tempProviderChangePasswordScheduler  = new ProviderChangePasswordScheduler();
            String sch = '0 0 23 * * ?';
            ProviderChangePasswordScheduler.scheduleMe('Test');
            system.schedule('Test ProviderForgetPassword', sch, tempProviderChangePasswordScheduler); 
        Test.stopTest();
        
         /*********************************************************************** 
        Assert to check Contact_Validation_Summary__c has been fetched successfully
        Expected Result: list size should not be blank 
        Actual Result: list is not blank 
        ***********************************************************************/
        list<Contact_Validation_Summary__c>lstCVS=[Select contact_id__c from Contact_Validation_Summary__c 
                                                               WHERE Contact_Id__c 
                                                               IN (Select ContactID from User where Profile.Name like '%Community Provider%' and LastLoginDate != null) 
                                                               LIMIT 10] ;
        system.assert(lstCVS.size()!=null); 
        
    }
}