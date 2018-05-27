/**********************************************************************
Class Name: CaseInternalServiceRequestCtrlTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is test Class for CaseInternalServiceRequestCtrl.
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  12/04/2015  Development complete   This class is intended to test CaseInternalServiceRequestCtrl functions.
***********************************************************************/
@isTest
private class CaseInternalServiceRequestCtrlTest{
    /*******************************************************************
    Purpose: method to create test data used by all test methods
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    @testsetup
    Static Void createTestData()
    {
        //Retrieve 'SHP Internal Service Request' recordtype id
        Id recType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SHP Internal Service Request').getRecordTypeId();
        //Create Case...
        Case cust = new Case();
        cust.RecordTypeId = recType;
        cust.subject = 'Test Case';
        cust.description =  'Test Case';
        cust.Provider_Name__c = 'Test Provider';
        cust.Provider_Type__c = 'Provider';   //Facility and Provider
        cust.PDV_Contact_Name__c = 'Test Provider';
        cust.Contact_Number__c = Integer.valueOf('1234567890');
        insert cust;
        
        /*********************************************************************** 
        Assert to check case has been created successfully
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        System.assert(cust.id!=null);
    }
    
    /*******************************************************************
    Purpose:  method to validate Page Redirect to record details page for 'Internal Service Request' recordtype.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void CaseInternalServiceRequestCtrl_redirectPageTest(){
        Case tempCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempCase);
        
        Test.startTest();
        CaseInternalServiceRequestCtrl  TempIntSerCtrl = new CaseInternalServiceRequestCtrl(controller);
        TempIntSerCtrl.redirectPage();
        
        /*********************************************************************** 
        Assert to check redirectPage method return value
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(TempIntSerCtrl.redirectPage() != null);
        Test.stopTest();
        
    }
}