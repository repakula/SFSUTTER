/**  
  *     Class Name  : VFC22_Kronos_Request_Form_Test
  *     Author      : IDC Offshore
  *     Date        : 16-Sep-2014
  *     Project Name: CRM - SFT - Sutter Health
  *     Description : Kronos Web Request Form
**/

@isTest
private class VFC22_Kronos_Request_Form_Test {
 
    static testMethod void testKronosRequestForm() {
        try {
            System.Test.startTest();
            Account accObj = new Account();
            accObj.Name = 'Account Name';
            insert accObj;
           
            Contact contObj = new Contact();
            contObj.FirstName = 'Contact FName';
            contObj.LastName = 'Contact LName';
            contObj.email = 'testContact@test.com';
            insert contObj;
            // Assert to check Contact is created succesfully
            system.assert(contObj.id!=null);
            System.Test.stopTest();
            Case caseObj = new Case();
            caseObj.subject = 'Test Case';
            caseObj.description = 'Test Case';
            caseObj.Internal_Comments__c = 'Test Case';        
            caseObj.accountId = accObj.id;
            caseObj.contactId = contObj.id;
            //insert caseObj;
            
            VFC22_Kronos_Request_Form clsObj = new VFC22_Kronos_Request_Form(new ApexPages.StandardController(caseObj));
            clsObj.caseRecord.Date_Requested__c = null;
            clsObj.saveAndSend();
            clsObj.caseRecord.Date_Requested__c = System.today();
            clsObj.caseRecord.Effective_Date_of_Change__c = null;
            clsObj.saveAndSend();
            clsObj.caseRecord.Date_Requested__c = System.today();
            clsObj.caseRecord.Effective_Date_of_Change__c = System.today();
            clsObj.saveAndSend();
       } catch(Exception ex) {} 
    }


    //SAASFOCUS
    static testMethod void testKronosRequestForm2() {
        try {
            System.Test.startTest();
            Account accObj = new Account();
            accObj.Name = 'Account Name';
            insert accObj;
           
            Contact contObj = new Contact();
            contObj.FirstName = 'Contact FName';
            contObj.LastName = 'Contact LName';
            contObj.email = 'testContact@test.com';
            insert contObj;
            // Assert to check Contact is created succesfully
            system.assert(contObj.id!=null);
            System.Test.stopTest();
            Case caseObj = new Case();
            caseObj.subject = 'Test Case';
            caseObj.description = 'Test Case';        
            caseObj.accountId = accObj.id;
            caseObj.contactId = contObj.id;
            //insert caseObj;
            
            SH_VFC22_Kronos_Request_Form clsObj = new SH_VFC22_Kronos_Request_Form(new ApexPages.StandardController(caseObj));
            clsObj.caseRecord.Date_Requested__c = null;
            clsObj.saveAndSend();
            clsObj.caseRecord.Date_Requested__c = System.today();
            clsObj.caseRecord.Effective_Date_of_Change__c = null;
            clsObj.caseRecord.Internal_Comments__c = 'test';
            clsObj.saveAndSend();
            clsObj.caseRecord.Date_Requested__c = System.today();
            clsObj.caseRecord.Effective_Date_of_Change__c = System.today();
            clsObj.saveAndSend();
       } catch(Exception ex) {} 
    }
}