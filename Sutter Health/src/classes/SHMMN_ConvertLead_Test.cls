/**********************************************************************
  Name: SHMMN_SHMMN_ConvertLead_test
  Copyright © 2015 IDC Offshore
  ======================================================
  ======================================================
  Purpose:
  This is the test class for SHMMN_ConvertLead class            
  ======================================================
  ======================================================
  History
  -------
  VERSION  AUTHOR        DATE        DETAIL                 Description
  1.0      IDC Offshore  04/26/2015 Development complete   This class is defined to test functionality of SHMMN_ConvertLead class.  
  ***********************************************************************/
 
 @isTest
   Private class SHMMN_ConvertLead_Test 
   {   
    /*******************************************************************
    Purpose: method to create test data used by all test methods
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    @testsetup
    Static Void createTestData()
    {
    
            Id profileId = [SELECT Id FROM Profile WHERE Name = 'SHMMN Management' LIMIT 1].Id;
            Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN'].Id;
            
            User SHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod.com');
            insert SHMMNUser ;    
            // Assert to check user is created successfully
            system.assert(SHMMNUser.id!=null);   
            System.runAs (SHMMNUser ) 
            {    
                //Retrieve 'SHMMN Lead' recordtype id
                Id recType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('SHMMN Lead').getRecordTypeId();    
                Lead vlead = new Lead();
                vlead.RecordTypeId = recType;
                vlead.FirstName = 'Test Lead';
                vlead.LastName =  'Test Lead';
                vlead.email = 'test@test.com';
                vlead.Phone = '011-3214569'; 
                vlead.Lead_Assigned__c=SHMMNUser.id;   
                vlead.Company = 'Test Accenture ';
                vlead.Status = 'Qualified';  
                vlead.Street= 'Test';
                vlead.State= 'Test';
                vlead.City= 'Test';
                vlead.Country= 'Test';
                vlead.PostalCode= '123456';
                vlead.AnnualRevenue= 99999;
                vlead.NumberOfEmployees= 10;
                vlead.Industry= 'Agriculture';
                vlead.Description= 'Test';
                 vlead.Skip_Validation__c=true;
                insert vlead;
                //Assert to check lead is inserted successfully
                System.assert(vlead.id!=null);    
            }
    }  
   
/*******************************************************************
    Purpose: method to check duplicate  
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
 ********************************************************************/
   static testmethod void DuplicateCheck_Test()
   {       
            Id profileId = [SELECT Id FROM Profile WHERE Name Like 'SHMMN%' LIMIT 1].Id;
            Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN'].Id;
            // Fetch lead created in test setup method 
            Lead templead = [select id from Lead where Status ='Qualified' ];
            // Assert to check lead is fetched successfully.
            System.assert(templead!=null);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(templead);
            apexpages.currentpage().getparameters().put('id' , templead.id);
            SHMMN_ConvertLead  vfc = new SHMMN_ConvertLead (controller);
            Test.starttest();
            vfc.DuplicateCheck();
            vfc.Approve();
            vfc.Reject();
            vfc.viewHierarchy();
            vfc.Cancel();
            test.stoptest();        
   }
   
   /*******************************************************************
    Purpose: method to check  reject 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/
   static testmethod void checkReject_Test()
   {       
            // Fetch lead created in test setup method 
            Lead templead = [select id from Lead where Status ='Qualified' ];
            templead.status='Rejected';
            templead.Rejection_Reason__c='Other';
            templead.Skip_Validation__c=true;
            update templead;
            // Assert to check lead is fetched successfully.
            System.assert(templead!=null);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(templead);
            apexpages.currentpage().getparameters().put('id' , templead.id);
            SHMMN_ConvertLead  vfc = new SHMMN_ConvertLead (controller);
            Test.starttest();
            vfc.Reject();
            vfc.Approve();
            test.stoptest();          
   }
   
   /*******************************************************************
    Purpose: method to check approve 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
   static testmethod void checkApprove_Test()
   {
            Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId(); 
            Account acc = new Account();
            acc.RecordTypeId = accRecType;
            acc.Name = 'Test Account';
            acc.Phone = '011-3214569';
            acc.NumberOfEmployees = 100;
            acc.Industry = 'Agriculture';
            insert acc;
            /*********************************************************************** 
            Assert to check Account has been created successfully
            Expected Result: !=null
            Actual Result: !=null   
            ***********************************************************************/
            System.assert(acc.id!=null);
            Group queueId = [select Id from Group where Name = 'SHMMN Sales Managers Queue' and Type = 'Queue'];
            // assert to check queue is available .
            System.assert(queueId!=null); 
            // Fetch lead created in test setup method 
            Lead templead = [select id from Lead where Status ='Qualified' ];
            templead.Rejection_Reason__c='test';
            templead.OwnerId=queueId.id;
            templead.Parent_Account__c = acc.id ;
            templead.Skip_Validation__c=true;
            update templead;
            // Assert to check lead is fetched successfully.
            System.assert(templead!=null);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(templead);
            apexpages.currentpage().getparameters().put('id' , templead.id);
            SHMMN_ConvertLead  vfc = new SHMMN_ConvertLead (controller);
            Test.starttest();
            vfc.DuplicateCheck();
            vfc.Approve();
            vfc.Reject();
            vfc.viewHierarchy();
            vfc.Cancel();
            test.stoptest();   
   }
   
   /*******************************************************************
    Purpose: method to check negative scenario of approving lead with Rejection Reason not null 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/  
  static testmethod void checkRejectNegative_Test()
   {
            Id recType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('SHMMN Lead').getRecordTypeId();       
            Lead vlead = new Lead();
            vlead.RecordTypeId = recType;
            vlead.FirstName = 'Test Lead';
            vlead.LastName =  'Test Lead';
            vlead.email = 'test@test.com';
            vlead.Phone = '011-3214569'; 
            vlead.Lead_Assigned__c=UserInfo.getUserId();   
            vlead.Company = 'Test Accenture ';
            vlead.Status = 'Qualified';  
            vlead.Street= 'Test';
            vlead.State= 'Test';
            vlead.City= 'Test';
            vlead.Country= 'Test';
            vlead.PostalCode= '123456';
            vlead.AnnualRevenue= 99999;
            vlead.NumberOfEmployees= 10;
            vlead.Industry= 'Agriculture';
            vlead.Description= 'Test';
            insert vlead;
            //Assert to check lead is inserted successfully
            System.assert(vLead.id!=null);
            vlead.Rejection_Reason__c='Other'; 
            vlead.Approval_Rejection_Comments__c='test';
            //vlead.Lead_Assigned__c = '';
             vlead.Skip_Validation__c=true;
            update vlead;
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(vlead);
            apexpages.currentpage().getparameters().put('id' , vlead.id);
            SHMMN_ConvertLead  vfc = new SHMMN_ConvertLead (controller);
            Test.starttest();
            vfc.DuplicateCheck();
            vfc.Approve();
            vfc.Reject();
            vfc.viewHierarchy();
            vfc.Cancel();
            Test.stoptest();       
   }
    /*******************************************************************
    Purpose: method to check negative scenario where user other than SHMMN Manager cannot approve/ reject lead 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
   static testmethod void checkNegative_Test()
   {
                User SHMMNUser =[SELECT id from USER where UserName='SHMMNuser@testmethod.com']; 
                Id recType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('SHMMN Lead').getRecordTypeId(); 
                Lead vlead = new Lead();
                vlead.RecordTypeId = recType;
                vlead.FirstName = 'Test Lead';
                vlead.LastName =  'Test Lead';
                vLead.Status = 'Qualified';
                vlead.email = 'test@test.com';
                vlead.Company = 'Test Accenture';
                insert vLead;
            
                //assert to check lead is inserted successfully
                System.assert(vLead.id!=null);   
                System.runAs(SHMMNUser)
            {       
                Test.starttest();
                ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(vLead);
                apexpages.currentpage().getparameters().put('id' , vLead.id);
                SHMMN_ConvertLead  vfc = new SHMMN_ConvertLead (controller);
                test.stoptest();
            }   
                
    
   } 
 /*******************************************************************
    Purpose: method to check positive scenario of approve lead where parent account of converted account is provided during approving lead 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/  
   static testmethod void checkApprovePositive_Test()
   {    
            Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
            Id RecType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('SHMMN Lead').getRecordTypeId();    
            Account acc = new Account();
            acc.RecordTypeId = accRecType;
            acc.Name = 'Test Account';
            acc.Phone = '011-3214569';
            acc.NumberOfEmployees = 100;
            acc.Industry = 'Agriculture';
            insert acc;
            /*********************************************************************** 
            Assert to check Account has been created successfully
            Expected Result: !=null
            Actual Result: !=null   
            ***********************************************************************/
            System.assert(acc.id!=null);
            //Insert parent account data for converted account
            Account newAcc = new Account();
            newAcc.RecordTypeId = accRecType;
            newAcc.Name = 'Test Account1';
            newAcc.Phone = '011-3214569';
            newAcc.NumberOfEmployees = 200;
            newAcc.Industry = 'Agriculture';
            insert newAcc;
            /*********************************************************************** 
            Assert to check Account has been created successfully
            Expected Result: !=null
            Actual Result: !=null   
            ***********************************************************************/
            System.assert(newAcc.id!=null);
            Lead vlead = new Lead();
            vlead.RecordTypeId = recType;
            vlead.FirstName = 'Test Lead';
            vlead.LastName =  'Test Lead';
            vLead.Status = 'Qualified';
            vlead.email = 'test@test.com';
            vlead.Company = 'Test Accenture';   
            vLead.Parent_Account__c = newAcc.id;
            insert vLead;
            //Assert to check lead is inserted successfully
            System.assert(vLead.id!=null);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(vLead);
            apexpages.currentpage().getparameters().put('id' , vLead.id);   
            SHMMN_ConvertLead  vfc = new SHMMN_ConvertLead (controller);
            vLead.Account_Owner__c = null;
            Test.starttest();
            vfc.DuplicateCheck();
            vfc.Approve();   
            test.stoptest();   
   }
   
    /*******************************************************************
    Purpose: method to create relationship between account and contact
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
   static testmethod void insertContacts_Test()
   {
            Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId(); 
            Id conRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();               
            User SHMMNUser =[SELECT id from USER where UserName='SHMMNuser@testmethod.com']; 
            Id recType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('SHMMN Lead').getRecordTypeId(); 
            Lead vlead = new Lead();
            vlead.RecordTypeId = recType;
            vlead.FirstName = 'Test1Lead';
            vlead.LastName =  'Test2Lead';
            vLead.Status = 'Qualified';
            vlead.email = 'test1@test.com';
            vlead.Company = 'Test1Accenture';
            vLead.Lead_Assigned__c = NULL;
            insert vLead;
            Account acc = new Account();
            acc.RecordTypeId = accRecType;
            acc.Name = 'Test0Account';
            acc.Phone = '011-3214569';
            acc.NumberOfEmployees = 100;
            acc.Industry = 'Agriculture';
            insert acc;
            Account acc1 = new Account();
            acc1.RecordTypeId = accRecType;
            acc1.Name = 'Test1Account';
            acc1.Phone = '011-3214569';
            acc1.NumberOfEmployees = 100;
            acc1.Industry = 'Agriculture';
            insert acc1;
            Contact contactLead = new Contact();            
            contactLead.FirstName = 'Test1Lead';
            contactLead.LastName =  'Test2Lead';
            contactLead.Phone = '1212121212';
            contactLead.Email = 'test@accenture.com';
            contactLead.AccountId = acc.Id;
            contactLead.RecordTypeId = conRecType;
            insert contactLead;
            List<Contact> contactWrapperlist = new List<Contact>();            
            contactWrapperlist.add(contactLead);
            
            //assert to check lead is inserted successfully
            System.assert(vLead.id!=null);   
            System.runAs(SHMMNUser)
            {       
                Test.starttest();
                ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(vLead);
                apexpages.currentpage().getparameters().put('id' , vLead.id);
                SHMMN_ConvertLead  vfc = new SHMMN_ConvertLead (controller);
                SHMMN_ConvertLead.ContactsList wrapperObj = new SHMMN_ConvertLead.ContactsList();
                wrapperObj.con = contactLead;
                wrapperObj.selected = false;
                vfc.insertContacts(acc1,contactWrapperlist);
                
                test.stoptest();
            } 
   } 
   /*******************************************************************
    Purpose: method to check Approve Lead
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
   static testmethod void ApproveMethod_Test()
   {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'SHMMN Management' LIMIT 1].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN'].Id;
        
        User SHMMNUser = new User(Alias = 'standt1', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser1@testmethod.com');
        insert SHMMNUser ;
        Id recType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('SHMMN Lead').getRecordTypeId();       
        Lead vlead = new Lead();
        vlead.RecordTypeId = recType;        
        vlead.FirstName = 'Test';
        vlead.LastName =  'Employer';
        vlead.email = 'employer@test.com';
        vlead.Phone = '011-7654321'; 
        vlead.Lead_Assigned__c=UserInfo.getUserId();   
        vlead.Company = 'Test Accenture Employer';
        vlead.Status = 'Qualified';  
        vlead.Street= 'Test';
        vlead.State= 'Test';
        vlead.City= 'Test';
        vlead.Country= 'Test';
        vlead.PostalCode= '123456';
        vlead.AnnualRevenue= 99999;
        vlead.NumberOfEmployees= 10;
        vlead.Industry= 'Agriculture';
        vlead.Description= 'Test'; 
        vlead.Lead_type__c = 'Broker';
        
       Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId(); 
        Account acc = new Account();
        acc.RecordTypeId = accRecType;
        acc.Name = 'Test Accenture Employer';
        acc.Phone = '011-3214569';
        acc.NumberOfEmployees = 100;
        acc.Industry = 'Agriculture';
        
        Account accDuplicate = new Account();
        accDuplicate.RecordTypeId = accRecType;
        accDuplicate.Name = 'Test Accenture Employer';
        accDuplicate.Phone = '011-3214569';
        accDuplicate.NumberOfEmployees = 100;
        accDuplicate.Industry = 'Agriculture';        
        
       Contact contactDuplicate = new Contact();
        contactDuplicate.FirstName = 'Test';
        contactDuplicate.LastName = 'Employer';
        contactDuplicate.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(System.Label.CL_30_SM_SHMMNEmployer).getRecordTypeId();
        contactDuplicate.AccountId = acc.Id;
        contactDuplicate.Phone = '1234567890';
        contactDuplicate.Email = 'TestAccenture@sutter.com';/*
        insert vlead;
        insert acc;
        insert accDuplicate;
        insert contactDuplicate;
        */
        //User SHMMNUser =[SELECT id from USER where UserName='SHMMNuser@testmethod.com'];
        system.runAs(SHMMNUser){
            insert vlead;
            insert acc;
            insert accDuplicate;
            insert contactDuplicate;
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(vLead);
            apexpages.currentpage().getparameters().put('id' , vLead.id);   
            SHMMN_ConvertLead  vfc = new SHMMN_ConvertLead (controller);
            //vfc.selectedRecord = contactDuplicate.Id;
            //vLead.Account_Owner__c = null;
            //vlead.OwnerId =  vLead.CreatedById;
            //update vlead;
            Test.starttest();
            vfc.Approve();   
            system.debug('contactSearched --- '+vfc.contactSearched);
            vfc.Approve(); 
            system.debug('contactSearched --- '+vfc.contactSearched);
            
        }
   }
}