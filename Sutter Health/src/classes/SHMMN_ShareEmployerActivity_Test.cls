/**********************************************************************
  Name: SHMMN_ShareEmployerActivity_Test
  Copyright © 2015 IDC Offshore
  ======================================================
  ======================================================
  Purpose:
  This is the test class for ShareEmployerActivity trigger            
  ======================================================
  ======================================================
  History
  -------
  VERSION  AUTHOR        DATE        DETAIL                 Description
  1.0     IDC Offshore 05/04/2015 Development complete   This class is defined to test functionality of ShareEmployerActivity trigger.  
  ***********************************************************************/
@isTest
Private class SHMMN_ShareEmployerActivity_Test 
{
  /*******************************************************************
    Purpose: method to share Employer Agreement on insert of record
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
  static testmethod void shareEmpActInsert_Test()
  {  
     Id profileId = [SELECT Id FROM Profile WHERE Name='SHMMN Management'].Id;
     Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN'].Id;           
     User SHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod4.com');
     insert SHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(SHMMNUser.id!=null);
     User tempSHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod3.com');
     insert tempSHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(tempSHMMNUser.id!=null);
     
     Id recType = Schema.SObjectType.Employer_Activity__c.getRecordTypeInfosByName().get('Annual Action Plan').getRecordTypeId();
     Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account acc = new Account();
     Employer_Activity__c empAct = new Employer_Activity__c();
     System.runAs(SHMMNUser)
     {
         acc.Name = 'Test Account';
         acc.RecordTypeId = accRecType;
         insert acc;
         // Assert to check account is created successfully
         System.assert(acc.id!=null);
         
         empAct.Account_Name__c = acc.id;
         empAct.Start_Date__c = date.newInstance(2016,04,05);
         empAct.Due_Date__c = date.newInstance(2016,04,05);
         empAct.Assigned_To__c = tempSHMMNUser.id;
         empAct.Status__c = 'In Progress';
         empAct.RecordTypeId = recType;
         insert empAct; 
     }
     List<Employer_Activity__Share> shares = [select id from Employer_Activity__Share where ParentId = :empAct.id and RowCause = 'Manual'];
     //Assert to check record is shared with user through apex sharing
     System.assertEquals(shares.size(),1);
         
  }
  /*******************************************************************
    Purpose: method to share Employer Agreement on update of record
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
  static testmethod void shareEmpActUpdate_Test()
  {  
     Id profileId = [SELECT Id FROM Profile WHERE Name='SHMMN Management'].Id;
     Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN'].Id;           
     User SHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod4.com');
     insert SHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(SHMMNUser.id!=null);
     User tempSHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod5.com');
     insert tempSHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(tempSHMMNUser.id!=null);
     
     Id recType = Schema.SObjectType.Employer_Activity__c.getRecordTypeInfosByName().get('Annual Action Plan').getRecordTypeId();
     Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account acc = new Account();
     Employer_Activity__c empAct = new Employer_Activity__c();
     System.runAs(SHMMNUser)
     {
         acc.Name = 'Test Account';
         acc.RecordTypeId = accRecType;
         insert acc;
         // Assert to check account is created successfully
         System.assert(acc.id!=null);
         
         empAct.Account_Name__c = acc.id;
         empAct.Start_Date__c = date.newInstance(2016,04,05);
         empAct.Due_Date__c = date.newInstance(2016,04,05);
         empAct.Assigned_To__c = SHMMNUser.id;
         empAct.Status__c = 'In Progress';
         empAct.RecordTypeId = recType;
         insert empAct; 
         
         empAct.Assigned_To__c = tempSHMMNUser.id;
         update empAct;
         
     }
     List<Employer_Activity__Share> shares = [select id from Employer_Activity__Share where ParentId = :empAct.id and RowCause = 'Manual'];
     //Assert to check record is shared with user assigned through apex sharing
     System.assertEquals(shares.size(),1);
         
  }
  /*******************************************************************
    Purpose: method to check sharing is removed from user on removing from Assigned To
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
  static testmethod void shareEmpActNegative_Test()
  {  
     Id profileId = [SELECT Id FROM Profile WHERE Name='SHMMN Management'].Id;
     Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN'].Id;           
     User SHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod4.com');
     insert SHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(SHMMNUser.id!=null);
     User tempSHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod5.com');
     insert tempSHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(tempSHMMNUser.id!=null);
     
     Id recType = Schema.SObjectType.Employer_Activity__c.getRecordTypeInfosByName().get('Annual Action Plan').getRecordTypeId();
     Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account acc = new Account();
     Employer_Activity__c empAct = new Employer_Activity__c();
     System.runAs(SHMMNUser)
     {
         acc.Name = 'Test Account';
         acc.RecordTypeId = accRecType;
         insert acc;
         // Assert to check account is created successfully
         System.assert(acc.id!=null);
         
         empAct.Account_Name__c = acc.id;
         empAct.Start_Date__c = date.newInstance(2016,04,05);
         empAct.Due_Date__c = date.newInstance(2016,04,05);
         empAct.Assigned_To__c = SHMMNUser.id;
         empAct.Status__c = 'In Progress';
         empAct.RecordTypeId = recType;
         insert empAct; 
         
         empAct.Assigned_To__c = tempSHMMNUser.id;
         update empAct;
         
         empAct.Assigned_To__c = SHMMNUser.id;
         update empAct;
     }
     List<Employer_Activity__Share> shares = [select id from Employer_Activity__Share where ParentId = :empAct.id and RowCause = 'Manual'];
     //Assert to check no record is shared with user through apex sharing
     System.assertEquals(shares.size(),0);
         
  }
  /*******************************************************************
    Purpose: method to check bulk scenario for Employer Activity Share on insert of Employer Activity record.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
  static testmethod void shareEmpActBulk_Test()
  {  
    Id profileId = [SELECT Id FROM Profile WHERE Name='SHMMN Management'].Id;
     Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN'].Id;           
     User SHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod4.com');
     insert SHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(SHMMNUser.id!=null);
     User tempSHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod5.com');
     insert tempSHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(tempSHMMNUser.id!=null);
     List<Employer_Activity__c> empActList = new List<Employer_Activity__c>();
     Id recType = Schema.SObjectType.Employer_Activity__c.getRecordTypeInfosByName().get('Annual Action Plan').getRecordTypeId();
     Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account acc = new Account();
     
     System.runAs(SHMMNUser)
     {
         acc.Name = 'Test Account SHMMN Employer';
         acc.RecordTypeId = accRecType;
         insert acc;
         // Assert to check account is created successfully
         System.assert(acc.id!=null);
         
         for(integer i=1; i<=200;i++)
         {
             Employer_Activity__c empAct = new Employer_Activity__c();
             empAct.Account_Name__c = acc.id;
             empAct.Start_Date__c = date.newInstance(2016,04,05);
             empAct.Due_Date__c = date.newInstance(2016,04,05);
             empAct.Assigned_To__c = tempSHMMNUser.id;
             empAct.Status__c = 'In Progress';
             empAct.RecordTypeId = recType;
             empActList.add(empAct);
         }
         insert empActList;
         List<Employer_Activity__Share> shares = [select id from Employer_Activity__Share where UserOrGroupId = :tempSHMMNUser.id and RowCause = 'Manual'];
         //Assert to check record is shared with user through apex sharing
         System.assertEquals(shares.size(),200);
     }   
  }
   /*******************************************************************
    Purpose: method to check bulk scenario for Employer Activity Share on update of Employer Activity record.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
  static testmethod void shareEmpActBulkUpdate_Test()
  {  
    Id profileId = [SELECT Id FROM Profile WHERE Name='SHMMN Management'].Id;
     Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN'].Id;           
     User SHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod4.com');
     insert SHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(SHMMNUser.id!=null);
     User tempSHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod5.com');
     insert tempSHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(tempSHMMNUser.id!=null);
     List<Employer_Activity__c> empActList = new List<Employer_Activity__c>();
     Id recType = Schema.SObjectType.Employer_Activity__c.getRecordTypeInfosByName().get('Annual Action Plan').getRecordTypeId();
     Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account acc = new Account();
     
     System.runAs(SHMMNUser)
     {
         acc.Name = 'Test Account SHMMN Employer';
         acc.RecordTypeId = accRecType;
         insert acc;
         // Assert to check account is created successfully
         System.assert(acc.id!=null);
         
         for(integer i=1; i<=200;i++)
         {
             Employer_Activity__c empAct = new Employer_Activity__c();
             empAct.Account_Name__c = acc.id;
             empAct.Start_Date__c = date.newInstance(2016,04,05);
             empAct.Due_Date__c = date.newInstance(2016,04,05);
             empAct.Assigned_To__c = SHMMNUser.id;
             empAct.Status__c = 'In Progress';
             empAct.RecordTypeId = recType;
             empActList.add(empAct);
         }
         insert empActList;
         List<Employer_Activity__Share> shares = [select id from Employer_Activity__Share where UserOrGroupId = :SHMMNUser.id and RowCause = 'Owner'];
         //Assert to check record is shared with user through apex sharing
         System.assertEquals(shares.size(),200);
         for (Employer_Activity__c empActShare : empActList)
         {
             empActShare.Assigned_To__c = tempSHMMNUser.id;
         }
         update empActList;
         
         List<Employer_Activity__Share> sharesNew = [select id from Employer_Activity__Share where UserOrGroupId = :tempSHMMNUser.id and RowCause = 'Manual'];
         //Assert to check record is shared with user through apex sharing
         System.assertEquals(sharesNew.size(),200);
     }   
  }
  /*******************************************************************
    Purpose: method to check bulk scenario for Employer Activity Share on update of Employer Activity record. This method tests for negative scenario where sharing is removed from user on removing from Assigned To
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
  static testmethod void shareEmpActBulkUpdateNegative_Test()
  {  
    Id profileId = [SELECT Id FROM Profile WHERE Name='SHMMN Management'].Id;
     Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN'].Id;           
     User SHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod4.com');
     insert SHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(SHMMNUser.id!=null);
     User tempSHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod5.com');
     insert tempSHMMNUser ;
     // Assert to check user is inserted successfully.
     System.assert(tempSHMMNUser.id!=null);
     List<Employer_Activity__c> empActList = new List<Employer_Activity__c>();
     Id recType = Schema.SObjectType.Employer_Activity__c.getRecordTypeInfosByName().get('Annual Action Plan').getRecordTypeId();
     Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account acc = new Account();
     
     System.runAs(SHMMNUser)
     {
         acc.Name = 'Test Account SHMMN Employer';
         acc.RecordTypeId = accRecType;
         insert acc;
         // Assert to check account is created successfully
         System.assert(acc.id!=null);
         
         for(integer i=1; i<=200;i++)
         {
             Employer_Activity__c empAct = new Employer_Activity__c();
             empAct.Account_Name__c = acc.id;
             empAct.Start_Date__c = date.newInstance(2016,04,05);
             empAct.Due_Date__c = date.newInstance(2016,04,05);
             empAct.Assigned_To__c = tempSHMMNUser.id;
             empAct.Status__c = 'In Progress';
             empAct.RecordTypeId = recType;
             empActList.add(empAct);
         }
         insert empActList;
         List<Employer_Activity__Share> shares = [select id from Employer_Activity__Share where UserOrGroupId = :tempSHMMNUser.id and RowCause = 'Manual'];
         //Assert to check record is shared with user through apex sharing
         System.assertEquals(shares.size(),200);
         for (Employer_Activity__c empActShare : empActList)
         {
             empActShare.Assigned_To__c = SHMMNUser.id;
         }
         update empActList;
         
         List<Employer_Activity__Share> sharesNew = [select id from Employer_Activity__Share where UserOrGroupId = :SHMMNUser.id and RowCause = 'Owner'];
         //Assert to check record is shared with user through apex sharing
         System.assertEquals(sharesNew.size(),200);
     }   
  }

}