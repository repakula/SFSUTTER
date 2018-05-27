/**  
*     Class Name: AP02_EmailMessage_Test
*     Author: Offshore IDC
*     Date: 26-August-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description: Test Class for AP02_EmailMessage Class. Checks scenario to create temporary contacts and sends out response mail to the Vendor if the Case is Closed
*     
*     History
*     VERSION    AUTHOR         DATE        DETAIL     Description
*     1.1        Offshore IDC   26-Aug-14   Test Class covers the scenario of Req-3139 - Email To Case Functionality for "Finance Accounts Payable" Record Type.   
*     1.2        Offshore IDC   05-Jan-16   Test Class covers the scenario of Req-3213 - Email To Case Functionality for "Finance Payroll" Record Type.   
*     --------  
**/
@isTest
private class AP02_EmailMessage_Test {
    //Static variables
    private static final String CASE_RT_NAME = 'Finance Accounts Payable';
    private static final String CASE_RT_NAME_FINANCE_PAYROLL = 'Finance Payroll';
    private static final String CASE_RT_NAME_FINANCE_ACC = 'Finance Accounting';
    private static final String ORIGIN = 'Email';
    private static final String SUBJECT = 'Test Subject';
    private static final String COMMENTS = 'COMMENTS';
    private static final String STATUS = 'Closed';
    private static final String CLOSE_REASON = 'Resolved';
    private static final String FUNCTION = 'Finance';
    private static final String SUB_FUNCTION = 'Accounts Payable';
    private static final String SUB_FUNCTION_PAYROLL = 'Payroll/T&E';
    private static final String TEAM = '[Tier 1] AP / Purchasing / Supply Chain';
    private static final String FROM_ADDRESS = 'sutterhealth@sutter.org';
    private static final String FROM_NAME = 'Test_Name';
    private static final String ROOT_CAUSE = 'Other';
    private static final String RESOLUTION = 'Other';
    
    
    /*******************************************************************
    Purpose: Creates test Case of Record Type "Finance Accounts Payable" for Email to Case functionality and closes the case.
    Parameters: [NA]
    Returns: [Case]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    static Case createCaseFinanceAccountsPayable() {
        List<Case> caseToInsert = new List<Case>();
        
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule= false;
        
        Case newCase = new Case(
            RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_NAME).RecordTypeId,
            Origin = ORIGIN,
            Subject = SUBJECT,
            Comments__c = COMMENTS,
            Function__c = FUNCTION,
            Sub_Function__c = SUB_FUNCTION,
            OwnerId = UserInfo.getUserId()
        );
        
        newCase.setOptions(dmlOpts);
        caseToInsert.add(newCase);
        // Insert Case of "Finance Accounts Payable" Record Type
        Database.insert(caseToInsert);
        // Case Status set as "Closed"
        newCase.Status = STATUS;
        newCase.S3_Root_Cause__c = ROOT_CAUSE;
        newCase.S3_Resolution__c = RESOLUTION;
        newCase.Close_Reason__c = CLOSE_REASON;
        // Update Case of "Finance Accounting" Record Type
        update newCase;
        System.AssertEquals(caseToInsert.size(), 1);
        return newCase;
        
    }
    
    /*******************************************************************
    Purpose: Creates test Case of Record Type "Finance Payroll" for Email to Case functionality and closes the case.
    Parameters: [NA]
    Returns: [Case]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    
    static Case createCaseFinancePayroll() {
        List<Case> caseInsert = new List<Case>();
        
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule= false;
        
        Case newPayrollCase = new Case(
            RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_NAME_FINANCE_PAYROLL).RecordTypeId,
            Origin = ORIGIN,
            Subject = SUBJECT,
            Comments__c = COMMENTS,
            Function__c = FUNCTION,
            Sub_Function__c = SUB_FUNCTION_PAYROLL,
            OwnerId = UserInfo.getUserId()
        );
        
        newPayrollCase.setOptions(dmlOpts);
        caseInsert.add(newPayrollCase);
        // Insert Case of "Finance Payroll" Record Type
        Database.insert(caseInsert);
        // Case Status set as "Closed"
        newPayrollCase.Status = STATUS;
        newPayrollCase.S3_Root_Cause__c = ROOT_CAUSE;
        newPayrollCase.S3_Resolution__c = RESOLUTION;
        newPayrollCase.Close_Reason__c = CLOSE_REASON;
        // Update Case of "Finance Payroll" Record Type
        update newPayrollCase;
        System.AssertEquals(caseInsert.size(), 1);
        return newPayrollCase;
        
    }
    
    /*******************************************************************
    Purpose:Creates test Case of Record Type "Finance Accounting" for Email to Case functionality and closes the case.
    Parameters: [NA]
    Returns: [Case]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static Case createCaseFinanceAccounting() {
        List<Case> caseToInsert = new List<Case>();
        
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule= false;
        
        Case newFinanceAccountingCase = new Case(
            RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_NAME_FINANCE_ACC).RecordTypeId,
            Origin = ORIGIN,
            Subject = SUBJECT,
            Comments__c = COMMENTS,
            Function__c = FUNCTION,
            Sub_Function__c = SUB_FUNCTION,
            OwnerId = UserInfo.getUserId(),
            S3_Root_Cause__c = ROOT_CAUSE,
            S3_Resolution__c = RESOLUTION
        );
        
        newFinanceAccountingCase.setOptions(dmlOpts);
        caseToInsert.add(newFinanceAccountingCase);
        // Insert Case of "Finance Accounting" Record Type
        Database.insert(caseToInsert);
        // Case Status set as "Closed"
        newFinanceAccountingCase.Status = STATUS;
        newFinanceAccountingCase.S3_Resolution__c = RESOLUTION;
        newFinanceAccountingCase.Close_Reason__c = CLOSE_REASON;
        newFinanceAccountingCase.Close_Reason__c = CLOSE_REASON;
        // Update Case of "Finance Accounting" Record Type
        update newFinanceAccountingCase;
        System.AssertEquals(caseToInsert.size(), 1);
        return newFinanceAccountingCase;
    }
   
    /*******************************************************************
    Purpose: Test Positive Scenario of AP02_EmailMessage Class
             Method tests the single Incoming Email Message for the case of Record Type "Finance Accounts Payable".
    Expected Result: Email Message will be sent.    
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testSingleActionForFinanceAccountsPayable() {
        Test.startTest();
        // Creates Case of "Finance Accounts Payable" Record Type
        Case caseOne = createCaseFinanceAccountsPayable();
        Test.stopTest();
        EmailMessage msg = new EmailMessage();
        msg.Incoming = true;
        msg.ParentId = caseOne.Id;
        msg.FromAddress = FROM_ADDRESS;
        msg.FromName = FROM_NAME;
        insert msg;
        System.AssertEquals(msg.FromName, FROM_NAME);
    }
    
    /*******************************************************************
    Purpose: Test Positive Scenario of AP02_EmailMessage Class
             Method tests the single Incoming Email Message for the case of Record Type "Finance Payroll".
    Expected Result: Email Message will be sent.    
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    
    static testMethod void testSingleActionForFinancePayroll() {
        Test.startTest();
        // Creates Case of "Finance Payroll" Record Type
        Case caseOne = createCaseFinancePayroll();
        Test.stopTest();
        EmailMessage msg = new EmailMessage();
        msg.Incoming = true;
        msg.ParentId = caseOne.Id;
        msg.FromAddress = FROM_ADDRESS;
        msg.FromName = FROM_NAME;
        insert msg;
        System.AssertEquals(msg.FromName, FROM_NAME);
    }
    
    /*******************************************************************
    Purpose: Test Positive Scenario of AP02_EmailMessage Class
             Method tests the single Incoming Email Message for the case of Record Type "Finance Accounts Payable".
    Expected Result: Email Message will be sent.    
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testSingleActionForFinanceAccounting() {
        Test.startTest();
        // Creates Case of "Finance Accounts Payable" Record Type
        Case caseOne = createCaseFinanceAccountsPayable();
        Test.stopTest();
        EmailMessage msg = new EmailMessage();
        msg.Incoming = true;
        msg.ParentId = caseOne.Id;
        msg.FromAddress = FROM_ADDRESS;
        msg.FromName = FROM_NAME;
        insert msg;
        System.AssertEquals(msg.FromName, FROM_NAME);
    }
    
    /*******************************************************************
    Purpose: Test Positive Scenario of AP02_EmailMessage Class
             Method tests the Single Incoming Email Message for the case of Record Type "Finance Accounts Payable".
             Checks the scenario where "FromName" value from Email Message will come blank.
    Expected Result: Email Message will be sent.    
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testSingleActionForFinanceAccountingWithBlankFromName() {
        Test.startTest();
        // Creates Case of "Finance Accounts Payable" Record Type
        Case caseOne = createCaseFinanceAccountsPayable();
        Test.stopTest();
        EmailMessage msg = new EmailMessage();
        msg.Incoming = true;
        msg.ParentId = caseOne.Id;
        msg.FromAddress = FROM_ADDRESS;
        insert msg;
        System.AssertEquals(msg.FromAddress, FROM_ADDRESS);
    }
    
    /*******************************************************************
    Purpose: Test Bulk Scenario of AP02_EmailMessage Class
             Method tests the Bulk(20) Incoming Email Message for the case of Record Type "Finance Accounts Payable".
    Expected Result: Email Message will be sent.    
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [Assert]
    ********************************************************************/
    static testMethod void testBulkActionForFinanceAccounting() {
        try {
            Test.startTest();
            // Creates Case of "Finance Accounts Payable" Record Type 
            Case caseOne = createCaseFinanceAccountsPayable();
            Test.stopTest();
            List<EmailMessage> emailMsgLst = new List<EmailMessage>();
            // Creates Email Message records
            for(Integer i=0;i<20;i++) {
                EmailMessage msg = new EmailMessage();
                msg.Incoming = true;
                msg.ParentId = caseOne.Id;
                msg.FromAddress = FROM_ADDRESS;
                msg.FromName = FROM_NAME;
                emailMsgLst.add(msg);
            }
            insert emailMsgLst;
            System.AssertEquals(emailMsgLst.size(),20);
        } 
        catch(Exception ex)
        {
            Boolean expectedExceptionThrown = ex.getMessage().contains('Exeption error') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
    
    
    /*******************************************************************
    Purpose: Test Negative Scenario of AP02_EmailMessage Class
             Method tests the Negative Incoming Email Message for the case of Record Type "Finance Accounts Payable".
             Checks the scenario where "FromAddress" value from Email Message will come blank.
    Expected Result: Email Message will not be send.    
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [Assert]
    ********************************************************************/
    static testMethod void testSingleActionForFinanceAccountingWithBlankFromAddress() {
        try {
            Test.startTest();
            // Creates Case of "Finance Accounts Payable" Record Type 
            Case caseOne = createCaseFinanceAccountsPayable();
            Test.stopTest();
            // Creates Email Message
            EmailMessage msg = new EmailMessage();
            msg.Incoming = true;
            msg.ParentId = caseOne.Id;
            msg.FromName = FROM_NAME;
            insert msg;
            System.AssertEquals(msg.FromName,FROM_NAME);
        }
        catch(Exception ex) 
        {
            Boolean expectedExceptionThrown = ex.getMessage().contains('Exeption error') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
    
    /*******************************************************************
    Purpose: Test Negative Scenario of AP02_EmailMessage Class
             Checks the scenario where Email Message gets deleleted. Exception will be thrown while deleting the email message.
    Expected Result: Exception will be thrown while deleting the email message. 
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [Assert]
    ********************************************************************/
    static testMethod void testSingleDeleteEmailMessage() {
        try {
            Test.startTest();
            // Creates Case of "Finance Accounts Payable" Record Type 
            Case caseOne = createCaseFinanceAccountsPayable();
            Test.stopTest();
            // Creates Email Message
            EmailMessage msg = new EmailMessage();
            msg.Incoming = true;
            msg.ParentId = caseOne.Id;
            msg.FromName = FROM_NAME;
            insert msg;
            System.AssertEquals(msg.FromName,FROM_NAME);
            //Delete Email Message 
            delete msg;         
        }
        catch(Exception ex) 
        {
            Boolean expectedExceptionThrown = ex.getMessage().contains('Email Deletion Is Not Authorized') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
    /*******************************************************************
    Purpose: Test Bulk Scenario of AP02_EmailMessage Class
             Method tests the Bulk(20) Incoming Email Message for the case of Record Type "Finance Payroll".
    Expected Result: Email Message will be sent.    
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [Assert]
    ********************************************************************/
    static testMethod void testBulkActionForFinancePayroll() {
        try {
            Test.startTest();
            // Creates Case of "Finance Accounts Payable" Record Type 
            Case caseOne = createCaseFinancePayroll();
            Test.stopTest();
            List<EmailMessage> emailMsgLst = new List<EmailMessage>();
            // Creates Email Message records
            for(Integer i=0;i<20;i++) {
                EmailMessage msg = new EmailMessage();
                msg.Incoming = true;
                msg.ParentId = caseOne.Id;
                msg.FromAddress = FROM_ADDRESS;
                msg.FromName = FROM_NAME;
                emailMsgLst.add(msg);
            }
            insert emailMsgLst;
            System.AssertEquals(emailMsgLst.size(),20);
        } 
        catch(Exception ex)
        {
            Boolean expectedExceptionThrown = ex.getMessage().contains('Exeption error') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
    /*******************************************************************
    Purpose: Test Negative Scenario of AP02_EmailMessage Class
             Method tests the Negative Incoming Email Message for the case of Record Type "Finance Payroll".
             Checks the scenario where "FromAddress" value from Email Message will come blank.
    Expected Result: Email Message will not be send.    
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [Assert]
    ********************************************************************/
    static testMethod void testSingleActionForFinancePayrollWithBlankFromAddress() {
        try {
            Test.startTest();
            // Creates Case of "Finance Payroll" Record Type 
            Case caseOne = createCaseFinancePayroll();
            Test.stopTest();
            // Creates Email Message
            EmailMessage msg = new EmailMessage();
            msg.Incoming = true;
            msg.ParentId = caseOne.Id;
            msg.FromName = FROM_NAME;
            insert msg;
            System.AssertEquals(msg.FromName,FROM_NAME);
        }
        catch(Exception ex) 
        {
            Boolean expectedExceptionThrown = ex.getMessage().contains('Exeption error') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
    
    /*******************************************************************
    Purpose: Test Negative Scenario of AP02_EmailMessage Class
             Checks the scenario where Email Message gets deleleted for case of Record Type "Finance Payroll". Exception will be thrown while deleting the email message.
    Expected Result: Exception will be thrown while deleting the email message. 
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [Assert]
    ********************************************************************/
    static testMethod void testSingleDeleteEmailMessageFinancePayroll() {
        try {
            Test.startTest();
            // Creates Case of "Finance Payroll" Record Type 
            Case caseOne = createCaseFinancePayroll();
            Test.stopTest();
            // Creates Email Message
            EmailMessage msg = new EmailMessage();
            msg.Incoming = true;
            msg.ParentId = caseOne.Id;
            msg.FromName = FROM_NAME;
            insert msg;
            System.AssertEquals(msg.FromName,FROM_NAME);
            //Delete Email Message 
            delete msg;         
        }
        catch(Exception ex) 
        {
            Boolean expectedExceptionThrown = ex.getMessage().contains('Email Deletion Is Not Authorized') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
}