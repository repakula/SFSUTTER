/*     Class Name: Account_Owner_ValidationTest
*     Author: Saket mohan Jha
*     Date: 02-January-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description: This class is defined to test ManageContactDatabase class.
*     
*    History
*    --------
*
*    VERSION    AUTHOR         DATE        DETAIL 
*      2.0    IDC Offshore  05/04/2016    Added Test Method to check the Req-3826 functionality of duplicate check on SHMMN Broker Account during account update.
**/
@isTest
private class Account_Owner_ValidationTest
{
/**    
*@author IDC Team    
*@date 01/01/2014    
*@description This Test Method is used to validate the Account Owner, if the owner is changed to SHP.
*@param     
*@return     
*/
    static testMethod void ChangeOwnerToSHP()
     {
          List<Profile> p = [SELECT Id FROM Profile WHERE Name='SHP Sales' limit 1];  
          User u = new User(Alias = 'standt', Email='abc@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p[0].Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='ABC@testorg.com');
          User u1 = new User(Alias = 'standt', Email='abc1@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p[0].Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='ABC1@testorg.com');
          insert u1;  
          //Assert to check user is inserted successfully
          System.assert(u1.id!=null);
          System.runAs(u)
          {
          Account acc = AP01_TestDataUtility.createAccountOwnerValidation();
          acc.OwnerId = u1.Id;
          update acc;
        }
    }
/**    
*@author IDC Team    
*@date 01/01/2014    
*@description This Test Method is used to validate the Account Owner, if the owner is changed to System Administrator.
*@param     
*@return     
*/
    static testMethod void ChangeOwnertoSysAdmin()
     { 

        List<Profile> p = [SELECT Id FROM Profile WHERE Name='SHP Sales' limit 1];
        //Assert to check SHP Sales Profile is fetched successfully
        System.assert(p.size()!=null);
        List<Profile> p1 = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];      
        User u = new User(Alias = 'standt', Email='abc@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p[0].Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ABC@testorg.com');       
        
        /*User u1 = new User(Alias = 'standt', Email='abc1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p1[0].Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ABC1@testorg.com');
        Test.startTest();
        upsert u1;
        Test.stopTest();       
        System.runAs(u){
        Account acc = AP01_TestDataUtility.createAccount(); 
        acc.OwnerId = u1.Id;
        try{
        update acc;
        }
        catch(Exception e)
        {
        system.assertEquals(true, e.getMessage().contains('You can only change to a User of SHP Sales Profile'));
        }
        }*/
        
    }
    
    
        /**    
*@author IDC Team    
*@date 12/09/2014    
*@description This Test Method is used to check the 3261 functionality of updating zipcode.
*@param     
*@return     
*/
    static testMethod void checkZipUpdate()
     {
        ZipcodeAndRegion__c zpcode =  new ZipcodeAndRegion__c(Name= 'test1',Region__c = 'ABC',Zipcode__c= '12345');
        insert zpcode;
    

        Test.startTest();
  
             Id RecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
             
             Account acc = new Account();
             acc.Name = 'newAcctforBillcodetest';
             acc.Phone = '2344556677';
             acc.RecordTypeID = RecTypeId;
             acc.BillingPostalCode = '54321';
             insert acc;
             //Assert to check Account is inserted successfully
             System.assert(acc.id!=null);
             acc.BillingPostalCode = '12345';
             update acc;
       Test.stopTest();   

       
    }
/**    
*@author IDC Team    
*@date 05/04/2016    
*@description This Test Method is used to check the 3826 functionality of duplicate check on SHMMN Broker Account during account insert.
*@param : NA     
*@return : NA     
*/
    static testMethod void checkSHMMNBrokerDuplicateInsert()
     {
        Account acc = new Account();
        Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Broker').getRecordTypeId();             
        acc.Name = 'Test Account';
        acc.Phone = '2344556677';
        acc.RecordTypeID = recType;
        acc.Status__C = 'Contracted';
        acc.Type = 'Reseller';
        insert acc;
        //Assert to check Account is inserted successfully
        System.assert(acc.id!=null);
        Test.startTest();           
        try
        {
        
        Account tempAcc = new Account();
        tempAcc.Name = 'Test Account';
        tempAcc.Phone = '11234567899';
        tempAcc.RecordTypeID = recType;
        tempAcc.Status__C = 'Contracted';
        tempAcc.Type = 'Reseller';
        tempAcc.Override_Duplicate__c = false;
        insert tempAcc;        
        
        }
         catch (exception ex)
         {
             System.assert(ex.getMessage()!=null);
         }       
         Test.stopTest();
       
    }
/**    
*@author IDC Team    
*@date 05/04/2016    
*@description This Test Method is used to check the 3826 functionality of duplicate check on SHMMN Broker Account during account update.
*@param : NA     
*@return : NA     
*/
    static testMethod void checkSHMMNBrokerDuplicateUpdate()
     {
        Account acc = new Account();
        Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Broker').getRecordTypeId();             
        acc.Name = 'Test Account';
        acc.Phone = '2344556677';
        acc.RecordTypeID = recType;
        acc.Status__C = 'Contracted';
        acc.Type = 'Reseller';
        insert acc;
        
        Account tempAcc = new Account();
        tempAcc.Name = 'Test Account1';
        tempAcc.Phone = '11234567899';
        tempAcc.RecordTypeID = recType;
        tempAcc.Status__C = 'Contracted';
        tempAcc.Type = 'Reseller';
        insert tempAcc; 
        //Assert to check Account is inserted successfully
        System.assert(tempAcc.id!=null);
        Test.startTest();           
        try
        {
        tempAcc.Name = 'Test Account';       
        tempAcc.Override_Duplicate__c = false;
        update tempAcc;
        }
         catch (exception ex)
         {
             System.assert(ex.getMessage()!=null);
         }       
         Test.stopTest();
       
    } 
/**    
*@author IDC Team    
*@date 05/04/2016    
*@description This Test Method is used to check the 3826 functionality of duplicate check on SHMMN Broker Account during account insert with override as true. his method tests for bulk   data.
*@param : NA    
*@return : NA     
*/
    static testMethod void checkBulkSHMMNBrokerDuplicateInsertPositive()
     {
        List<Account> accList = new List<Account>();
        Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Broker').getRecordTypeId();
        for(integer i=1; i<=200;i++)
        {
            Account a = new Account();
            a.Name = 'Test Account';
            a.RecordTypeID = recType;
            a.Override_Duplicate__c = true;
            accList.add(a);
        }
        insert accList;
        //Assert to check Account are inserted successfully
        System.assert(accList!=null);
        System.assertEquals(accList.size(),200);       
     }      
/**    
*@author IDC Team    
*@date 05/04/2016    
*@description This Test Method is used to check the 3826 functionality of duplicate check on SHMMN Broker Account during account update with override as true. his method tests for bulk   data.
*@param : NA    
*@return : NA     
*/
    static testMethod void checkBulkSHMMNBrokerDuplicateUpdate()
     {
        List<Account> accList = new List<Account>();
        Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Broker').getRecordTypeId();

        for(integer i=1; i<=200;i++)
            {
                Account a = new Account();
                a.Name = 'Test Account'+i;
                a.RecordTypeID = recType;
                accList.add(a);
            }
        insert accList;
        for(Account acc :accList )
            {
                acc.Name = 'Test';
                acc.Override_Duplicate__c = true;
            }
        test.startTest();
        update accList; 
        test.stopTest();
        //Assert to check Account are inserted successfully
        System.assert(accList!=null);
        System.assertEquals(accList[10].Name,'Test');       
     }    
    
    /**    
*@author IDC Team    
*@date 10/07/2016    
*@description This Test Method is used to check the archive contact for Broker Rep is existed for the account or not.
*@param : NA    
*@return : NA     
*/
    static testMethod void checkArchiveContactforBrokerRepInsert()
     {
         String ACNRECTYPE = 'SHP Sales Broker';
         String CONTACTRECTYPE = 'SHP Sales Broker Contact';
         Id RecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
         Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                          Type = 'Broker',
                                          NumberOfEmployees = 300);
         Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep'
                                           
                                          );
         Test.startTest();
         insert testBrokerAccount;
         
         Insert testContact;
         Account acc = new Account();
         acc.Name = 'newAcctforBillcodetest';
         acc.Phone = '2344556677';
         acc.RecordTypeID = RecTypeId;
         acc.BillingPostalCode = '54321';
         acc.Broker__c = testBrokerAccount.Id;
         acc.Broker_Rep__c = testContact.Id;
         try{
             insert acc;
         }catch(Exception e){}
         
         test.stopTest();
        
     } 
    
    
     
    /**    
*@author IDC Team    
*@date 10/07/2016    
*@description This Test Method is used to check the archive contact for Broker Contact is existed for the account or not.
*@param : NA    
*@return : NA     
*/
    static testMethod void checkArchiveContactforBrokerContactInsert()
     {
         String ACNRECTYPE = 'SHP Sales Broker';
         String CONTACTRECTYPE = 'SHP Sales Broker Contact';
         Id RecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
         Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                          Type = 'Broker',
                                          NumberOfEmployees = 300);
         Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep',
                                           Archive__c = true
                                          );
         Test.startTest();
         insert testBrokerAccount;
         
         Insert testContact;
         Account acc = new Account();
         acc.Name = 'newAcctforBillcodetest';
         acc.Phone = '2344556677';
         acc.RecordTypeID = RecTypeId;
         acc.BillingPostalCode = '54321';
         acc.Broker__c = testBrokerAccount.Id;
         acc.Broker_Contact__c = testContact.Id;
         try{
             insert acc;
         }catch(Exception e){}
         
         test.stopTest();
        
     } 
    
    /**    
*@author IDC Team    
*@date 10/07/2016    
*@description This Test Method is used to check the archive contact for Broker Rep is existed for the account or not.
*@param : NA    
*@return : NA     
*/
    static testMethod void checkArchiveContactforBrokerRepUpate()
     {
         String ACNRECTYPE = 'SHP Sales Broker';
         String CONTACTRECTYPE = 'SHP Sales Broker Contact';
         Id RecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
         Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                          Type = 'Broker',
                                          NumberOfEmployees = 300);
         Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep',
                                           Archive__c = false,
                                           License_Number__c = '1234567890',
                                           License_Expiration_Date__c = System.today()+30
                                          );
       
         Test.startTest();
         insert testBrokerAccount;
         
         Insert testContact;
         Account acc = new Account();
         acc.Name = 'newAcctforBillcodetest';
         acc.Phone = '2344556677';
         acc.RecordTypeID = RecTypeId;
         acc.BillingPostalCode = '54321';
         acc.Broker__c = testBrokerAccount.Id;
         acc.Broker_Rep__c = testContact.Id;
         
         insert acc;
         
         Contact conObj = [select id,archive__c from contact where id=:testContact.Id];
         conObj.Archive__c = true;
         update conObj;
         
         Account accObj = [select id,Broker_Rep__c from Account where name='newAcctforBillcodetest' limit 1];
         HighRoads_ArchivedContacts.isByPassValidationUpdated = true;
         accObj.Broker_Rep__c = conObj.id;
         
         try{
             update accObj;
         }catch(Exception e){}
         test.stopTest();
        
     } 
    
    
     
    /**    
*@author IDC Team    
*@date 10/07/2016    
*@description This Test Method is used to check the archive contact for Broker Contact is existed for the account or not.
*@param : NA    
*@return : NA     
*/
    static testMethod void checkArchiveContactforBrokerContactUpdate()
     {   
        Profile p = [SELECT Id FROM Profile WHERE Name='SHMMN Management']; 
        User testuser = new User(Alias = 'standt', Email='standarduser@testmethod.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testmethod909.com');
        insert testuser;
        
        system.runAs(testuser){
         String ACNRECTYPE = 'SHP Sales Broker';
         String CONTACTRECTYPE = 'SHP Sales Broker Contact';
         Id RecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
         Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                          Type = 'Broker',
                                          NumberOfEmployees = 300);
         
         Test.startTest();
         insert testBrokerAccount;
         Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                           LastName = 'Test contact',
                                           AccountId = testBrokerAccount.Id,
                                           Broker_Agent_Status__c = 'Prospect',
                                           Type__c = 'Broker Rep',
                                           Archive__c = False,
                                           License_Number__c = '1234567890',
                                           License_Expiration_Date__c = System.today()+30
                                          );
         Insert testContact;
         Account acc = new Account();
         acc.Name = 'newAcctforBillcodetest';
         acc.Phone = '2344556677';
         acc.RecordTypeID = RecTypeId;
         acc.BillingPostalCode = '54321';
         acc.Broker__c = testBrokerAccount.Id;
         acc.Broker_Contact__c = testContact.Id;
         
         insert acc;
         
         
         Contact conObj = [select id,archive__c from contact where id=:testContact.Id];
         conObj.Archive__c = true;
         update conObj;
         
         Account accObj = [select id,Broker_Contact__c from Account where id=:acc.id];
         HighRoads_ArchivedContacts.isByPassValidationUpdated = true;
         try{
             update accObj;
         }catch(Exception e){}
         test.stopTest();
         }
        
     } 
    
}