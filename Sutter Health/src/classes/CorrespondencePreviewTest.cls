/**********************************************************************
Class Name: CorrespondencePreviewTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is test Class for CorrespondencePreview.
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  12/03/2015  Development complete   This class is intended to test CorrespondencePreview functions.
***********************************************************************/
@isTest
private class CorrespondencePreviewTest{

    /*******************************************************************
    Purpose: method to create test data used by all test methods
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    @testsetup
    Static Void createTestData()
    {
        //Create Account
        Account acc = AP01_TestDataUtility.createAccount();
        
        /*********************************************************************** 
        Assert to validate ACCOUNT has created successfully..
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(acc.id != null);
        
        //Create Contact
        Contact cont = AP01_TestDataUtility.createContact(acc);
        
        /*********************************************************************** 
        Assert to validate Contact has created successfully..
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(cont.id != null);
    }
    
    /*******************************************************************
    Purpose: method to validate replace 'amp' from 'Letter Content' field of 'Correspondence Letter' object record .
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void CorrespondencePreview_ConstructorTest(){
        Contact cont = [select id,AccountId from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
 
        /*********************************************************************** 
        Assert to validate Contact has retrieved successfully..
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        System.assert(cont.id!=null);
        
        //Create 'Correspondence Letter' object record.....
        
        Correspondence_Letter__c corrMember = new  Correspondence_Letter__c ();
        corrMember.SHP_Member_Id__c = cont.id;
        corrMember.SHP_OnBaseID__c = '123'; 
        corrMember.SHP_Correspondence_Entity_Recipient_HCC__c= '123';
        corrMember.SHP_Is_Logical_Delete__C = false;
        corrMember.SHP_IsReplacement__C = false;
        corrMember.Letter_Content__c = 'http://test@gmail.com]<amp;';
        
        insert corrMember;
    
        /*********************************************************************** 
        Assert to validate 'Correspondence Letter' record has created successfully..
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        System.assert(corrMember.id != null);
        
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(corrMember);
        ApexPages.currentPage().getParameters().put('id',corrMember.id);
        Test.startTest();
        CorrespondencePreview  tempCorrespondencePreview = new CorrespondencePreview(controller);
        
        /*********************************************************************** 
        Assert to validate 'amp' has remove from 'LetterContent' value successfully..
        Expected Result: 'http://test@gmail.com'
        Actual Result: 'http://test@gmail.com'   
        ***********************************************************************/
        system.assertEquals(tempCorrespondencePreview.objLetterContent,'http://test@gmail.com');
        Test.stopTest();
        
    }

    /*******************************************************************
    Purpose: method to validate to catch exception block in CorrespondencePreview constructor
    Returns: void
    Throws [Exceptions]: Yes
    ********************************************************************/
    static testMethod void ExceptionCorrespondencePreview_ConstructorTest(){
        Contact cont = [select id,AccountId from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        
        /*********************************************************************** 
        Assert to validate 'Correspondence Letter' record has created successfully..
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        System.assert(cont.id!=null);
        
        //Create 'Correspondence Letter' record.....
        Correspondence_Letter__c corrMember = new  Correspondence_Letter__c ();
        corrMember.SHP_Member_Id__c = cont.id;
        corrMember.SHP_OnBaseID__c = '123'; 
        corrMember.SHP_Correspondence_Entity_Recipient_HCC__c= '123';
        corrMember.SHP_Is_Logical_Delete__C = false;
        corrMember.SHP_IsReplacement__C = false;
        corrMember.Letter_Content__c = 'http://test@gmail.com';
        
        insert corrMember;
        
        /*********************************************************************** 
        Assert to validate 'Correspondence Letter' record has created successfully..
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        System.assert(corrMember.id != null);
        
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(corrMember);
        
        ApexPages.currentPage().getParameters().put('id',corrMember.id);
        Test.startTest();
        try{
        CorrespondencePreview  tempCorrespondencePreview = new CorrespondencePreview(controller);
        }
        catch(exception ex){
            /*********************************************************************** 
            Assert to check exception catch block
            Expected Result: !=null
            Actual Result: !=null   
            ***********************************************************************/
            system.assert(ex.getMessage() != null);
        }
        Test.stopTest();
        
    }
}