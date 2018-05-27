/*****************************************************
Class Name: PDIEmailProviderAssistantApproval_Test
Created By: Nagarjuna Kaipu
Created Date: 15/11/2016
Description: test class for PDIEmailHandlerProviderAssistantApproval class
******************************************************/
@isTest
public class PDIEmailProviderAssistantApproval_Test {
    //Method to test inbound email reply from email service handler.
    static testMethod void inBoundApprovalEmailTest()
    {
        Contact c = Util01_PDIUtilTestData.createContact();
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        List<PDIAdminAssistantApprovalKeywords__c> appKeyWords = Util01_PDIUtilTestData.PDIApprovalKeyWords();
        System.runAs(testUser)
        {
            insert appKeyWords;
            c.Provider_Admin_Assistant_Email__c = 'nagarjuna.kaipu@accenture.com';
            insert c;
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
            insert  mgrProfile;
            
            List<Contact_Validation_Summary__c> summary = [Select Id, Name, Admin_Assistant_Email__c From Contact_Validation_Summary__c 
                                                           Where Admin_Assistant_Email__c = 'nagarjuna.kaipu@accenture.com' Limit 1];
            // create a new email and envelope object
            Messaging.InboundEmail email = new Messaging.InboundEmail() ;
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            
            // setup the data for the email
            email.subject = 'Action Required: Admin Assistant Confirmation: '+summary[0].Id;
            email.fromAddress = 'nagarjuna.kaipu@accenture.com';
            email.plainTextBody = 'Approve';
            email.HtmlBody = 'Approve';
            Test.startTest();
            // call the email service class and test it with the data in the testMethod
            PDIEmailHandlerProviderAssistantApproval testInbound = new PDIEmailHandlerProviderAssistantApproval();
            testInbound.handleInboundEmail(email, env);
            List<Contact_Validation_Summary__c> sumList = [Select Id, Admin_Assistant_Email__c, Admin_Assistant_Approval_Status__c From Contact_Validation_Summary__c
                                                           Where Admin_Assistant_Email__c = 'nagarjuna.kaipu@accenture.com' Limit 1];
            System.assertEquals(sumList.size()>0, true);
            Test.stopTest();
        }
    }
    //Method to test inbound email reply rejection status from email service handler.
    static testMethod void inBoundApprovalEmailRejectedStatus()
    {
        Contact c = Util01_PDIUtilTestData.createContact();
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        List<PDIAdminAssistantApprovalKeywords__c> appKeyWords = Util01_PDIUtilTestData.PDIApprovalKeyWords();
        System.runAs(testUser)
        {
            insert appKeyWords;
            c.Provider_Admin_Assistant_Email__c = 'nagarjuna.kaipu@accenture.com';
            insert c;
            List<CS_ManageProfile__c> mgrProfile = new List<CS_ManageProfile__c>();
            mgrProfile = Util01_PDIUtilTestData.createManageprofileSet();
            insert  mgrProfile;
            
            List<Contact_Validation_Summary__c> summary = [Select Id, Name, Admin_Assistant_Email__c From Contact_Validation_Summary__c 
                                                           Where Admin_Assistant_Email__c = 'nagarjuna.kaipu@accenture.com' Limit 1];
            // create a new email and envelope object
            Messaging.InboundEmail email = new Messaging.InboundEmail() ;
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            
            // setup the data for the email
            email.subject = 'Action Required: Admin Assistant Confirmation: '+summary[0].Id;
            email.fromAddress = 'nagarjuna.kaipu@accenture.com';
            email.HtmlBody = 'Rejected';
            email.plainTextBody = 'Rejected';
            Test.startTest();
            // call the email service class and test it with the data in the testMethod
            PDIEmailHandlerProviderAssistantApproval testInbound = new PDIEmailHandlerProviderAssistantApproval();
            testInbound.handleInboundEmail(email, env);
            List<Contact_Validation_Summary__c> sumList = [Select Id, Admin_Assistant_Email__c, Admin_Assistant_Approval_Status__c From Contact_Validation_Summary__c
                                                           Where Admin_Assistant_Email__c = 'nagarjuna.kaipu@accenture.com' Limit 1];
            System.assertEquals(sumList.size()>0, true);
            Test.stopTest();
        }
    }
}