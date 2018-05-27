/**********************************************************************
Name: HighRoads_SendAttachmentsInEmail_Test
Purpose: Test Class for HighRoads_SendAttachmentsInEmail Class

History
-------
VERSION         AUTHOR          DATE        DETAIL                  Description
1.0             offshore IDC    06-Dec-2016 INITIAL DEVELOPMENT     Test class covers the scenario of Sending Attachments by EMail.   
***********************************************************************/

@isTest
private class HighRoads_SendAttachmentsInEmail_Test{    
    
    /*******************************************************************
    Purpose: test webservice method sendAttachments.
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
     static testMethod void testSendAttachments() {
        Test.StartTest();
        
        Account acc = HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        
        Incumbent_Carrier__c rfp = new Incumbent_Carrier__c();
        rfp.RecordtypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('RFP Form').getRecordTypeId();
        rfp.Opportunity__c = opp.id;
        insert rfp;
        
        Proposal__c quote = new Proposal__c();
        quote.Opportunity_ID__c = opp.id;
        quote.RFP_Form__c = rfp.Id;
        insert quote;
        
        Sold_Sign_Off__c sso = new Sold_Sign_Off__c();
        sso.Opportunity_ID__c = opp.id;
        sso.Quote__c = quote.id;
        sso.Stage__c = 'Draft';
        insert sso;
        
        Attachment myAttachment  = new Attachment();
        myAttachment.clear();
        myAttachment.Body = Blob.valueOf('Attachment Body'); 
        myAttachment.Name = 'New Attachment'; 
        myAttachment.ParentId = sso.id;             
        insert myAttachment;   
        
        String[] userEmail = new String[]{'bpaUser1@sutter.com', 'bpaUser2@sutter.com'};
        
        String strEmail = HighRoads_SendAttachmentsInEmail.sendAttachments(sso.Id,userEmail, 'Sold Sign Off',acc.Name,acc.DBA__c,'Employer Name : '+acc.Name+'/DBA:'+acc.DBA__c+' Sold Sign Off Attachments Requested');
        System.AssertEquals('Email has been sent successfully with all attachments',strEmail);
        String[] userEmailError = new String[]{'bpaUser2'};
        String strError = HighRoads_SendAttachmentsInEmail.sendAttachments(sso.Id,userEmailError, 'Sold Sign Off',acc.Name,acc.DBA__c,'Employer Name : '+acc.Name+'/DBA:'+acc.DBA__c+' Sold Sign Off Attachments Requested');
        System.Assert(!(strError == ''));
        Test.StopTest();
     }
}