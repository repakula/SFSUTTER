/**  
*     Class Name: EmailToCaseNotificationController_Test
*     Author: Offshore IDC
*     Date: 05-Nov-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description: Test Class for EmailToCaseNotificationController Class. This class tests for different scenarios that are handled in the code
*                  Email to case notification service console component.
*     History
*     VERSION    AUTHOR         DATE         DETAIL     Description
*     1.1        Offshore IDC   05-Nov-2015  Test Class covers the functionality of Email to case notification service console component of Req-3139.
*     1.2        Offshore IDC   06-Jan-2016  Added conditions to cover functionality of Email to case notification service console component of Req-3213.
*     --------  
**/
@isTest
private class EmailToCaseNotificationController_Test {
    //Static variables
    private static final String CASE_RT_NAME = 'Finance Accounts Payable';
    private static final String CASE_RT_NAME_PAYROLL = 'Finance Payroll';
    private static final String ORIGIN = 'Email';
    private static final String SUBJECT = 'Test Subject';
    private static final String COMMENTS = 'COMMENTS';
    private static final String STATUS = 'New';    
    private static final String FUNCTION = 'Finance';
    private static final String SUB_FUNCTION = 'Accounts Payable';
    private static final String SUB_FUNCTION_PAYROLL = 'Payroll/T&E';
    private static final String TEAM = '[Tier 1] AP / Purchasing / Supply Chain';
    private static final String FROM_ADDRESS = 'sutterhealth@sutter.org';
    private static final String FROM_NAME = 'Test_Name';
    private static integer msgTotalPageCount;
    
    /*******************************************************************
    Purpose: Creates test Case of Record Type "Finance Accounts Payable".
    Parameters: [NA]
    Returns: [List of Case]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static List<Case> createCasesFinanceAccountsPayable()
    {
        List<Case> caseToInsert = new List<Case>();
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule= false;
        for (integer i=1;i<=36;i++){
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
        // Insert Case Records
        caseToInsert.add(newCase);
       }
        Database.insert(caseToInsert);
        System.AssertEquals(caseToInsert.size(), 36);
        // Return List of Cases
        return caseToInsert;
    }
    /*******************************************************************
    Purpose: Creates test Case of Record Type "Finance Payroll".
    Parameters: [NA]
    Returns: [List of Case]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static List<Case> createCasesFinancePayroll()
    {
        List<Case> caseToInsert = new List<Case>();
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule= false;
        for (integer i=1;i<=36;i++){
        Case newCase = new Case(
            RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_NAME_PAYROLL).RecordTypeId,
            Origin = ORIGIN,
            Subject = SUBJECT,
            Comments__c = COMMENTS,
            Function__c = FUNCTION,
            Sub_Function__c = SUB_FUNCTION_PAYROLL,
            OwnerId = UserInfo.getUserId()
        );
        
        newCase.setOptions(dmlOpts);
        // Insert Case Records
        caseToInsert.add(newCase);
       }
        Database.insert(caseToInsert);
        System.AssertEquals(caseToInsert.size(), 36);
        // Return List of Cases
        return caseToInsert;
    }
   
    /*******************************************************************
    Purpose: Creates Single Email Message Test Record
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static void createSingleEmailMessage()
    {
        // Create Case Records
        List<Case> caseOne = createCasesFinanceAccountsPayable();
        EmailMessage msg = new EmailMessage();
        msg.Incoming = true;
        msg.ParentId = caseOne[1].Id; 
        msg.FromAddress = FROM_ADDRESS;
        msg.ToAddress = System.Label.EmailToCaseId;
        msg.FromName = FROM_NAME;
        msg.status = '0';
        // Insert Email Message
        insert msg;
    }
    /*******************************************************************
    Purpose: Creates Single Email Message Test Record for Finance Payroll
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static void createSingleEmailMessageFinancePayroll()
    {
        // Create Case Records
        List<Case> caseOne = createCasesFinancePayroll();
        EmailMessage msg = new EmailMessage();
        msg.Incoming = true;
        msg.ParentId = caseOne[1].Id; 
        msg.FromAddress = FROM_ADDRESS;
        msg.ToAddress = System.Label.EmailToCaseId;
        msg.FromName = FROM_NAME;
        msg.status = '0';
        // Insert Email Message
        insert msg;
    }
    
    /*******************************************************************
    Purpose: Creates Bulk Email Message Test Records
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static void createBulkEmailMessage()
    {
        // Create Case Records
        List<Case> caseOne = createCasesFinanceAccountsPayable();
        List<EmailMessage> msgList = new List<EmailMessage>();
        for(case ca:caseOne) {
            EmailMessage msg = new EmailMessage();
            msg.Incoming = true;
            msg.ParentId = ca.Id;
            msg.FromAddress = FROM_ADDRESS;
            msg.ToAddress = System.Label.EmailToCaseId;
            msg.FromName = FROM_NAME;
            msg.status = '0';
            msgList.add(msg) ;
        }
        // Insert Email Messages 
        insert msgList;
    }
    /*******************************************************************
    Purpose: Creates Bulk Email Message Test Records for Finance Payroll
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static void createBulkEmailMessageFinancePayroll()
    {
        // Create Case Records
        List<Case> caseOne = createCasesFinancePayroll();
        List<EmailMessage> msgList = new List<EmailMessage>();
        for(case ca:caseOne) {
            EmailMessage msg = new EmailMessage();
            msg.Incoming = true;
            msg.ParentId = ca.Id;
            msg.FromAddress = FROM_ADDRESS;
            msg.ToAddress = System.Label.EmailToCaseId;
            msg.FromName = FROM_NAME;
            msg.status = '0';
            msgList.add(msg) ;
        }
        // Insert Email Messages 
        insert msgList;
    }
    
    /*******************************************************************
    Purpose: Creates both Single & bulkified Email Message records
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static void createSingleAndBulkEmailMessage()
    {
        // Create Case Records
        List<Case> caseOne = createCasesFinanceAccountsPayable();
        List<EmailMessage> msgList = new List<EmailMessage>();
            for(case ca:caseOne) {
              EmailMessage msg = new EmailMessage();
                msg.Incoming = true;
                msg.ParentId = ca.Id;
                msg.FromAddress = FROM_ADDRESS;
                msg.ToAddress = System.Label.EmailToCaseId;
                msg.FromName = FROM_NAME;
                msg.status = '0';
                msgList.add(msg) ;
        }
        if(!msgList.isempty()){
            // Insert Email Messages
            insert msgList;
            EmailMessage msg = new EmailMessage();
            msg.Incoming = true;
            msg.ParentId = caseOne[1].Id;
            msg.FromAddress = FROM_ADDRESS;
            msg.ToAddress = System.Label.EmailToCaseId;
            msg.FromName = FROM_NAME;
            msg.status = '0';
            // Insert Email Message
            insert msg;
    
        }
        System.AssertEquals(msgList.size(), 36);
    }
    /*******************************************************************
    Purpose: Creates both Single & bulkified Email Message records for Finance Payroll
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static void createSingleAndBulkEmailMessageFinancePayroll()
    {
        // Create Case Records
        List<Case> caseOne = createCasesFinancePayroll();
        List<EmailMessage> msgList = new List<EmailMessage>();
            for(case ca:caseOne) {
              EmailMessage msg = new EmailMessage();
                msg.Incoming = true;
                msg.ParentId = ca.Id;
                msg.FromAddress = FROM_ADDRESS;
                msg.ToAddress = System.Label.EmailToCaseId;
                msg.FromName = FROM_NAME;
                msg.status = '0';
                msgList.add(msg) ;
        }
        if(!msgList.isempty()){
            // Insert Email Messages
            insert msgList;
            EmailMessage msg = new EmailMessage();
            msg.Incoming = true;
            msg.ParentId = caseOne[1].Id;
            msg.FromAddress = FROM_ADDRESS;
            msg.ToAddress = System.Label.EmailToCaseId;
            msg.FromName = FROM_NAME;
            msg.status = '0';
            // Insert Email Message
            insert msg;
    
        }
        System.AssertEquals(msgList.size(), 36);
    }
    
    /*******************************************************************
    Purpose: Tests Single & Bulk positive scenarios of "EmailToCasenotificationContoller".
             Calls "callMethod" after creating Email Message
    Expected Result: Email Message record will be created successfully.    
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testSingleEmailCaseNotification() {
        Test.startTest();
        EmailToCaseNotificationController EmailToCaseNotification = new EmailToCaseNotificationController();
        EmailToCaseNotification.getTotalPages();
        EmailToCaseNotification.getHasPrevious();
        EmailToCaseNotification.getHasNext();
        // Call to create Email Messages
        createSingleAndBulkEmailMessage();
        // Call Method has been called after creating the Email Message       
        EmailToCaseNotification.callMethod();
        EmailToCaseNotification.getListCases();
        EmailToCaseNotification.doFirst();
        EmailToCaseNotification.doNext();
        EmailToCaseNotification.getHasNext();
        EmailToCaseNotification.doLast();
        EmailToCaseNotification.doPrevious();
        EmailToCaseNotification.getHasPrevious(); 
        EmailToCaseNotification.getPageNumber();
        EmailToCaseNotification.getTotalPages();
        msgTotalPageCount = EmailToCaseNotification.getTotalPages();
        Test.stopTest();
        System.AssertEquals(EmailToCaseNotification.getTotalPages(), msgTotalPageCount);        
    }
    
    /*******************************************************************
    Purpose: Tests Bulk positive scenarios of "EmailToCasenotificationContoller".
             Calls "callMethod" after creating Email Message
    Expected Result: Email Message record will be created successfully.    
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testBulkEmailCaseNotification() {
        Test.startTest();
        EmailToCaseNotificationController EmailToCaseNotification = new EmailToCaseNotificationController();
        EmailToCaseNotification.getTotalPages();
        EmailToCaseNotification.getHasPrevious();
        EmailToCaseNotification.getHasNext();
        // Call to create Email Messages
        createBulkEmailMessage();
        // Call Method has been called after creating the Email Message        
        EmailToCaseNotification.callMethod();
        EmailToCaseNotification.getListCases();
        EmailToCaseNotification.doFirst();
        EmailToCaseNotification.doNext();
        EmailToCaseNotification.getHasNext();
        EmailToCaseNotification.doLast();
        EmailToCaseNotification.doPrevious();
        EmailToCaseNotification.getHasPrevious(); 
        EmailToCaseNotification.getPageNumber();
        EmailToCaseNotification.getTotalPages();
        msgTotalPageCount = EmailToCaseNotification.getTotalPages();
        Test.stopTest();
        System.AssertEquals(EmailToCaseNotification.getTotalPages(), msgTotalPageCount);        
    }
    
    /*******************************************************************
    Purpose: Tests Negative scenarios of "EmailToCasenotificationContoller".
             Calls "callMethod" before creating Email Message. Functionality will be check when no email message records has been created.
    Expected Result: Email Message record count will be 0.    
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testSingleEmailCaseNotificationNegative() {
        Test.startTest();
        EmailToCaseNotificationController EmailToCaseNotification = new EmailToCaseNotificationController();
        // Call Method has been called before creating the Email Message
        EmailToCaseNotification.callMethod();
        System.AssertEquals(EmailToCaseNotification.getTotalPages(), 0);
        // Call to create Email Message 
        createSingleEmailMessage();
        // Call Method has been called after creating the Email Message
        EmailToCaseNotification.callMethod();
        EmailToCaseNotification.getListCases();  
        EmailToCaseNotification.doFirst();
        EmailToCaseNotification.doNext();
        EmailToCaseNotification.getHasNext();
        EmailToCaseNotification.doLast();
        EmailToCaseNotification.doPrevious();
        EmailToCaseNotification.getHasPrevious(); 
        EmailToCaseNotification.getPageNumber();
        EmailToCaseNotification.getTotalPages();
        msgTotalPageCount = EmailToCaseNotification.getTotalPages();
        Test.stopTest();
        System.AssertEquals(EmailToCaseNotification.getTotalPages(), msgTotalPageCount);           
    }
}