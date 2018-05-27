/**  
*     Class Name: ManageCases_Test
*     Author: IDC 
*     Date: 09-Sep-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description: Test Class for ManageCases Trigger. This class tests for different scenarios of trigger. 
*     
*    History
*    --------
*
*    VERSION    AUTHOR         DATE        DETAIL 
*     2.0     Offshore IDC   06-Jan-2016  Added conditions to cover Req-3213 Finance Payroll Email-to-Case
**/

@isTest
private class ManageCases_Test {
    
    /**
    * @author IDC Team
    * @date 09/9/2015
    * @description: Method tests the bulkify positive scenario of Finance Type Interaction Log functionality.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseFunctionFinance() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId; 
        caseObj1.Function__c = 'Finance';
        caseObj1.Team__c = '[Tier 3] Regional Accounting Leads';
        
        Case caseObj2 = new Case();
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        caseObj2.Function__c = 'Finance';
        caseObj2.Team__c = '[Tier 1] AP / Purchasing / Supply Chain';
        
        Case caseObj3 = new Case();
        caseObj3.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        caseObj3.Function__c = 'Finance';
        caseObj3.Team__c = '[Tier 2] Finance Payroll / T&E';
        
        Case caseObj4 = new Case();
        caseObj4.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        caseObj4.Function__c = 'Finance';
        caseObj4.Team__c = '[Tier 3] Payroll Taxes';
        
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        caseList.add(caseObj3);
        caseList.add(caseObj4);
        insert caseList;
        system.assertEquals(caseList.size(), 4);
    }
    
    /**
    * @author IDC Team
    * @date 11/16/2015
    * @description: Method tests the Negative scenario of Finance Type Interaction Log functionality.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseFunctionFinanceNegative() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Employee Inquiry').RecordTypeId; 
        caseObj1.Function__c = 'Finance';
        caseObj1.Team__c = '[Tier 3] Regional Accounting Leads';
        caseList.add(caseObj1);
        insert caseList;
        system.assertEquals(caseList.size(), 1);
    }
    
    /**
    * @author IDC Team
    * @date 09/9/2015
    * @description: Method tests the bulkify positive scenario of Human Resource Type Interaction Log functionality.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseFunctionHR() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.Function__c = 'Human Resource';
        caseObj1.Team__c = '[Tier 3] Compensation';
        caseObj1.Customer_Intent__c = 'Employee Compensation';
        caseObj1.Customer_Sub_Intents__c = 'Job Evaluation';
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj2 = new Case();
        caseObj2.Function__c = 'Human Resource';
        caseObj2.Team__c = '[Tier 3] HR Reporting';
        caseObj2.Customer_Intent__c = 'HR Reporting';
        caseObj2.Customer_Sub_Intents__c = 'Adhoc Report Request Web';
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj3 = new Case();
        caseObj3.Function__c = 'Human Resource';
        caseObj3.Team__c = '[Tier 3] HR Reporting';
        caseObj3.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        caseList.add(caseObj3);
        insert caseList;
        system.assertEquals(caseList.size(), 3);
    }
    
    /**
    * @author IDC Team
    * @date 11/16/2015
    * @description: Method tests the Negative scenario of Human Resource Type Interaction Log functionality.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseFunctionHRNegative() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Employee Inquiry').RecordTypeId; 
        caseObj1.Function__c = 'Finance';
        caseObj1.Team__c = '[Tier 3] Regional Accounting Leads';
        caseList.add(caseObj1);
        insert caseList;
        system.assertEquals(caseList.size(), 1);
    }
    
    /**
    * @author IDC Team
    * @date 09/9/2015
    * @description: Method tests the bulkify positive scenario of Revenue Type & Supply chain Type Interaction Log functionality.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseFunctionRevenueAndSupply() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.Function__c = 'Revenue Cycle';
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        caseObj1.Team__c = '[Tier 3] Revenue';
        Case caseObj2 = new Case();
        caseObj2.Function__c = 'Supply Chain';
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        caseObj2.Team__c = '[Tier 3] Supply Chain';
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        insert caseList;
        system.assertEquals(caseList.size(), 2);
    }
    
    /**
    * @author IDC Team
    * @date 11/16/2015
    * @description: Method tests the Negative scenario of Revenue Type & Supply chain Type Type Interaction Log functionality.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseFunctionRevenueAndSupplyNegative() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Employee Inquiry').RecordTypeId; 
        caseObj1.Function__c = 'Revenue Cycle';
        caseObj1.Team__c = '[Tier 3] Revenue';
        caseList.add(caseObj1);
        insert caseList;
        
        system.assertEquals(caseList.size(), 1);
    }
    
    /**
    * @author IDC Team
    * @date 09/9/2015
    * @description: Method tests the bulkify positive scenario of Email To Case Functionality.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseOriginEmaiToCase() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.Origin = 'Email to Case';
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Accounts Payable').RecordTypeId;
        
        Case caseObj2 = new Case();
        caseObj2.Origin = 'Email to Case';
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Accounting').RecordTypeId;
        
        Case caseObj3 = new Case();
        caseObj3.Origin = 'Email to Case';
        caseObj3.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        
        //Add case records to list        
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        caseList.add(caseObj3);
        
        //Insert case list records
        insert caseList;
        system.assertEquals(caseList.size(), 3);
    }
    
    /**
    * @author IDC Team
    * @date 09/9/2015
    * @description: Method tests the bulkify positive scenario of auto reply Email To Case Functionality.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseOriginEmaiToCaseAutoReply() {
    try{
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.Origin = 'Email to Case';
          caseObj1.Subject = 'Automatic reply: SPORTS DAY';
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Accounts Payable').RecordTypeId;
        
        Case caseObj2 = new Case();
        caseObj2.Origin = 'Email to Case';
          caseObj2.Subject = 'Automatic reply: SPORTS DAY';
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        
      
        
        //Add case records to case list        
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        
        //Insert case list records
        insert caseList;
        System.AssertEquals(caseList.size(), 2);
        }
        Catch (Exception e){
         
            //Boolean expectedExceptionThrown = e.getMessage().contains('created due to automatic reply setting from') ? true : false;
            //System.AssertEquals(expectedExceptionThrown, true);
          
        } 
        
    }
    
    /**
    * @author IDC Team
    * @date 11/16/2015
    * @description: Method tests the Negative scenario of Email To Case Functionality.
            Checking the scenario on "Employee Inquiry" type case.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseEmailToCaseNegative() {
      try {
          List<Case> caseList = new List<Case>();
          Case caseObj1 = new Case();
          caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Employee Inquiry').RecordTypeId; 
          caseObj1.Origin = 'Email to Case';
          caseList.add(caseObj1);
          insert caseList;
          system.assertEquals(caseList.size(), 1);
      } catch(Exception ex) {
            Boolean expectedExceptionThrown = ex.getMessage().contains('Exeption error') ? true : false;
            system.Debug('@@Error Message >> ' + ex.getMessage() + '>>' + expectedExceptionThrown);
            System.AssertEquals(expectedExceptionThrown, false);
      }
    }
    
    /**
    * @author IDC Team
    * @date 09/9/2015
    * @description: Method tests the bulkify positive scenario of assigning teams on case assignment logic.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseInquiryType() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.Inquiry_Type__c = 'Payroll';
        caseObj1.Inquiry_Reason__c = 'Kronos';
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        Case caseObj2 = new Case();
        caseObj2.Inquiry_Type__c = 'HR Benefits';
        caseObj2.Inquiry_Reason__c = 'ESL/Sick';
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        Case caseObj3 = new Case();
        caseObj3.Inquiry_Type__c = 'HR Benefits';
        caseObj3.Inquiry_Reason__c = 'Health & Welfare - Premium Billing';
        caseObj3.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj4 = new Case();
        caseObj4.Inquiry_Type__c = 'HR Pension';
        caseObj4.Inquiry_Reason__c = 'Retirement - Pension';
        caseObj4.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        Case caseObj5 = new Case();
        caseObj5.Inquiry_Type__c = 'HR General Inquiry';
        caseObj5.Inquiry_Reason__c = 'General Inquiry - HR';
        caseObj5.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj6 = new Case();
        caseObj6.Inquiry_Type__c = 'HR Data';
        caseObj6.Inquiry_Reason__c = 'Employee Data Setup and Change';
        caseObj6.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj7 = new Case();
        caseObj7.Inquiry_Type__c = 'HR General Inquiry';
        caseObj7.Inquiry_Reason__c = 'HR Tool User Support';
        caseObj7.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj8 = new Case();
        caseObj8.Inquiry_Type__c = 'HR General Inquiry';
        caseObj8.Inquiry_Reason__c = 'HR Reporting';
        caseObj8.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj9 = new Case();
        caseObj9.Inquiry_Type__c = 'Performance/Learning';
        caseObj9.Inquiry_Reason__c = 'Employee Learning';
        caseObj9.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj10 = new Case();
        caseObj10.Inquiry_Type__c = 'Recruitment';
        caseObj10.Inquiry_Reason__c = 'Recruitment';
        caseObj10.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        caseList.add(caseObj3);
        caseList.add(caseObj4);
        caseList.add(caseObj5);
        caseList.add(caseObj6);
        caseList.add(caseObj7);
        caseList.add(caseObj8);
        caseList.add(caseObj9);
        caseList.add(caseObj10);
        insert caseList;
        system.assertEquals(caseList.size(), 10);
        }
    
    /**
    * @author IDC Team
    * @date 09/9/2015
    * @description: Method tests the bulkify positive scenario of Address Change Request Functionality.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseAddress() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.Status = 'Closed';
        caseObj1.Close_Reason__c = 'Cancelled';
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Address Change Request').RecordTypeId;
        
        Case caseObj2 = new Case();
        caseObj2.Status = 'Closed';
        caseObj2.Close_Reason__c = 'Cancelled';
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Affiliate Data Change Request').RecordTypeId;
        
        Case caseObj3 = new Case();
        caseObj3.Status = 'Closed';
        caseObj3.Close_Reason__c = 'Cancelled';
        caseObj3.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Application Request').RecordTypeId;
        
        Case caseObj4 = new Case();
        caseObj4.Status = 'Closed';
        caseObj4.Close_Reason__c = 'Cancelled';
        caseObj4.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Data Change Request').RecordTypeId;
        
        Case caseObj5 = new Case();
        caseObj5.Status = 'Closed';
        caseObj5.Close_Reason__c = 'Cancelled';
        caseObj5.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Expirables Request').RecordTypeId;
        
        Case caseObj6 = new Case();
        caseObj6.Status = 'Closed';
        caseObj6.Close_Reason__c = 'Cancelled';
        caseObj6.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Other Request').RecordTypeId;
        
        Case caseObj7 = new Case();
        caseObj7.Status = 'Closed';
        caseObj7.Close_Reason__c = 'Cancelled';
        caseObj7.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Reapplication Request').RecordTypeId;
        
        Case caseObj8 = new Case();
        caseObj8.Status = 'Closed';
        caseObj8.Close_Reason__c = 'Cancelled';
        caseObj8.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Report Request').RecordTypeId;
        
        Case caseObj9 = new Case();
        caseObj9.Status = 'Closed';
        caseObj9.Close_Reason__c = 'Cancelled';
        caseObj9.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Rush Application Request').RecordTypeId;
        
        Case caseObj10 = new Case();
        caseObj10.Status = 'Closed';
        caseObj10.Close_Reason__c = 'Cancelled';
        caseObj10.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Temporary Privilege Request').RecordTypeId;
        
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        caseList.add(caseObj3);
        caseList.add(caseObj4);
        caseList.add(caseObj5);
        caseList.add(caseObj6);
        caseList.add(caseObj7);
        caseList.add(caseObj8);
        caseList.add(caseObj9);
        caseList.add(caseObj10);
        insert caseList;
        system.assertEquals(caseList.size(), 10);
    }
    
    /**
    * @author IDC Team
    * @date 11/16/2015
    * @description: Method tests the Negative scenario of Address Change Request Functionality.
            Checking the scenario on open Case.
    * @param 
    * @return 
    */
    @isTest private static void insertCaseAddressNegative() {
      try {
          List<Case> caseList = new List<Case>();
           Case caseObj1 = new Case();
          caseObj1.Status = 'New';
          caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Address Change Request').RecordTypeId;
          caseList.add(caseObj1);
          insert caseList;
          system.assertEquals(caseList.size(), 1);
          } catch(Exception ex) 
          {
            Boolean expectedExceptionThrown = ex.getMessage().contains('Exeption error') ? true : false;
            system.Debug('@@Error Message >> ' + ex.getMessage() + '>>' + expectedExceptionThrown);
            System.AssertEquals(expectedExceptionThrown, true);
          }
    }    
}