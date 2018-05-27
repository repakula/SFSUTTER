/**********************************************************************
 Name: Test_VendorTaxID_DataMigration
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for VendorTaxID_DataMigration batch class
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  5/2/2014 Development complete   This class is defined to test VendorTaxID_DataMigration class.
 2.0      IDC Offshore  12/22/2015  Class Optimsation   Incorporated changes to implement best test practices in the test class.
 ***********************************************************************/
 
  @isTest
   private class Test_VendorTaxID_DataMigration {
     
   /*******************************************************************
    Purpose: method to create test data used by all test methods
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    
    @testSetup 
    static void createTestData() {
   
        string recAccTypeId = [Select Id from RecordType where sObjectType = 'Account' AND Name = 'S3 Vendor'].Id;
        Account assignedAccount = AP01_TestDataUtility.createAccount();
        Account acc = new Account();
        acc.Broker_Firm_HCC_ID__c = AP01_TestDataTokens.BROKER_FIRM_HCC_ID;
        acc.Name = AP01_TestDataTokens.ACCOUNT_NAME;
        acc.Phone = AP01_TestDataTokens.PHONE;
        acc.Tax_ID__c = AP01_TestDataTokens.TAX_ID;
        acc.Account_TIN_Type__c = AP01_TestDataTokens.ACCOUNT_TIN_TYPE;
        acc.RecordTypeId =recAccTypeId ;
        insert acc;
        
       /*********************************************************************** 
        Verifying the value of Account record created above
        Expected Result: id value should not be null 
        Actual Result: id value should not be null 
       **********************************************************************/
        system.assert(acc.id!=null);
        
        string recTypeId = [Select Id from RecordType where sObjectType = 'Contact' AND Name = 'Vendor'].Id;
         list<Contact> lstCont = new list<Contact>();      
        /** Creating Contact records of Vendor Recordtype **/
        for(Integer i = 0;i<=20;i++){
        Contact testCon = new Contact();
        testCon.AccountId = acc.Id;
        testCon.RecordTypeId = recTypeId;
        testCon.FirstName = 'Test';
        testCon.LastName = 'PortalReactivation';
        testCon.Employee_Work_Email__c = 'test.portalReactivation@test.com';
        testCon.Employee_Union_Affiliate__c = 'CHEU';
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_Affiliate_Facility__c = 'Sutter Shared Services';
        testCon.Employee_EEO_SubCode__c = '0';
        testCon.Vendor_TaxID__c = '123456';
        lstCont.add(testCon);
        }
        
        insert lstCont;
        
       /*********************************************************************** 
        Verifying the value of Contact records created above
        Expected Result: id values should not be null 
        Actual Result: id values should not be null 
       **********************************************************************/
        system.assert(lstCont[0].id !=null);
        
    }  

    /*******************************************************************
    Purpose: method to test the logic of the batch class on contact records
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
         
    static testMethod void VendorTaxID_DataMigration_Test() {
               
      Test.startTest();
      database.executeBatch(new VendorTaxID_DataMigration());
      Test.stopTest();
      
      /*********************************************************************** 
        Verifying the value of Contact's Account Vendor_Tax_ID__c field value is updated by Contact's Vendor_TaxID__c field value
        Expected Result: Vendor_Tax_ID__c value should be '123456'. 
        Actual Result: Vendor_Tax_ID__c values should not be '123456'.
       **********************************************************************/
        Account TempAcc = [select id,Vendor_Tax_ID__c from Account where Vendor_Tax_ID__c = '123456' limit 1];
        system.assert(TempAcc.Vendor_Tax_ID__c == '123456');
      
    }
    
    /*******************************************************************
    Purpose: Method to test the negative scenario of the batch class on contact records to update Account Vendor_Tax_ID__c field value
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
         
    static testMethod void VendorTaxID_DataMigration_NegativeTest() {
        
        /** Creating Account record **/
    
        Account acc = new Account();
        acc.Broker_Firm_HCC_ID__c = AP01_TestDataTokens.BROKER_FIRM_HCC_ID;
        acc.Name = 'Test Negative';
        acc.Phone = '7834904627';
        acc.Tax_ID__c = AP01_TestDataTokens.TAX_ID;
        acc.Account_TIN_Type__c = AP01_TestDataTokens.ACCOUNT_TIN_TYPE;
    
        insert acc;
        /*********************************************************************** 
        Verifying the value of Account record created above
        Expected Result: id value should not be null 
        Actual Result: id value should not be null 
       **********************************************************************/
        system.assert(acc.id!=null);
        
        string recTypeId = [Select Id from RecordType where sObjectType = 'Contact' AND Name = 'Vendor'].Id;
         /** Creating Contact records of Vendor Recordtype **/
        Contact testCon = new Contact();
        testCon.AccountId = acc.Id;
        testCon.FirstName = 'Test';
        testCon.LastName = 'PortalReactivation';
        testCon.Employee_Work_Email__c = 'test.portalReactivation@test.com';
        testCon.Employee_Union_Affiliate__c = 'CHEU';
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_Affiliate_Facility__c = 'Sutter Shared Services';
        testCon.Employee_EEO_SubCode__c = '0';
        testCon.Vendor_TaxID__c = '123456';
        testCon.RecordTypeId = recTypeId;
        insert testCon;
        /*********************************************************************** 
        Verifying the value of Contact records created above
        Expected Result: id values should not be null 
        Actual Result: id values should not be null 
       **********************************************************************/
        system.assert(testCon.id !=null);
        
      Test.startTest();
      database.executeBatch(new VendorTaxID_DataMigration());
      Test.stopTest();
      
      /*********************************************************************** 
        Verifying the value of Contact's Account Vendor_Tax_ID__c field value is updated by Contact's Vendor_TaxID__c field value
        Expected Result: Vendor_Tax_ID__c value should not be '123456'. 
        Actual Result: Vendor_Tax_ID__c values should not be '123456'.
       **********************************************************************/
        Account TempAcc = [select id,Vendor_Tax_ID__c from Account where name = 'Test Negative' and Phone = '7834904627' limit 1];
        system.assert(TempAcc.Vendor_Tax_ID__c != '123456');
      
    }   
}