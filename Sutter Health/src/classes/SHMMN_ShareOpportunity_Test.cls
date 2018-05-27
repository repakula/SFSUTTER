/**********************************************************************
  Name: SHMMN_ShareOpportunity_Test
  Copyright © 2015 IDC Offshore
  ======================================================
  ======================================================
  Purpose:
  This is the test class for SHMMN_ShareOpportunity class            
  ======================================================
  ======================================================
  History
  -------
  VERSION  AUTHOR        DATE        DETAIL                 Description
  1.0     IDC Offshore 05/04/2015 Development complete   This class is defined to test functionality of SHMMN_ShareOpportunity class.  
  ***********************************************************************/
@isTest
Private class SHMMN_ShareOpportunity_Test 
{
  /*******************************************************************
    Purpose: method to create test data used by all test methods
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
  @TestSetup
  Static Void createTestData()
  {
        Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
        Id oppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHMMN Opportunity').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordTypeId = recType;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Industry';
        insert acc;
        // Assert to check account is created successfully
        System.assert(acc.id!=null);
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.Type = 'New Business';
        opp.AccountId = acc.id;
        opp.CloseDate = date.newInstance(2016,04,05);
        Opp.Close_Date__c = date.newInstance(2016,05,06);
        opp.StageName = 'Interest';
        opp.Probability = 25;
        opp.RecordTypeId = oppRecType;
        insert opp; 
        // Assert to check opportunity is created successfully
        System.assert(opp.id!=null);
        Opportunity newOpp = new Opportunity();
        newOpp.Name = 'Test Opp';
        newOpp.Type = 'New Business';
        newOpp.AccountId = acc.id;
        newOpp.CloseDate = date.newInstance(2016,04,05);
        newOpp.StageName = 'Closed Won';
        newOpp.Close_Date__c = date.newInstance(2016,05,06);
        newOpp.Probability = 30;
        newOpp.RecordTypeId = oppRecType;
        insert newOpp; 
        // Assert to check opportunity is created successfully
        System.assert(newOpp.id!=null);
  }
  /*******************************************************************
    Purpose: method to share opportunity and check positive scenario  
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/
  static testmethod void shareOpp1_Test()
  {
         string userProfile =  [SELECT Id,Name FROM Profile WHERE Name like 'SHMMN%' limit 1].Name;
         Opportunity tempOpp = [select id from Opportunity where StageName = 'Interest' ]; 
         // Assert to check opportunity is fetched successfully.
         System.assert(tempOpp!=null);           
         ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempOpp);
         Apexpages.currentpage().getparameters().put('OpportunityId' , tempOpp.id);
         Apexpages.currentpage().getparameters().put('user' , userProfile);
         SHMMN_ShareOpportunity vfc = new SHMMN_ShareOpportunity (controller); 
         Test.startTest();
         vfc.shareOpp();
         Test.stopTest();
  }
  /*******************************************************************
    Purpose: method to share Closed Won opportunity and check negative scenario  
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/
  static testmethod void shareOpp2_Test()
  {     
         Opportunity tempOpp = [select id from Opportunity where StageName ='Closed Won' ];  
         String profileName = [SELECT Id,Name FROM Profile WHERE Name like 'SHMMN%' limit 1].Name;      
         // Assert to check opportunity is fetched successfully.
         System.assert(tempOpp!=null);
         ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempOpp);
         Apexpages.currentpage().getparameters().put('OpportunityId' , tempOpp.id);         
         Apexpages.currentpage().getparameters().put('user' , profileName);         
         SHMMN_ShareOpportunity vfc = new SHMMN_ShareOpportunity (controller); 
         Test.startTest();
         vfc.shareOpp();
         Test.stopTest();
  }
  /*******************************************************************
    Purpose: method to call cancel method and check positive scenario  
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/
  static testmethod void shareOpp3_Test()
  {
     
         Opportunity tempOpp = [select id from Opportunity where StageName ='Interest' ];        
         // Assert to check opportunity is fetched successfully.
         System.assert(tempOpp!=null);
         ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempOpp);
         Apexpages.currentpage().getparameters().put('OpportunityId' , tempOpp.id);
         SHMMN_ShareOpportunity vfc = new SHMMN_ShareOpportunity (controller); 
         Test.startTest();       
         vfc.Cancel();
         Test.stopTest();
  }
  /*******************************************************************
    Purpose: method to share opportunity owned by other user and check negative scenario  
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/
  static testmethod void shareOpp4_Test()
  {     
     
         Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
         Id oppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHMMN Opportunity').getRecordTypeId();
         Id profileId = [SELECT Id,Name FROM Profile WHERE Name like 'SHMMN%' limit 1].Id;
         String profileName = [SELECT Id,Name FROM Profile WHERE Name like 'SHMMN%' limit 1].Name;
         Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN'].Id;           
         User SHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod.com');
         insert SHMMNUser ;
         // Assert to check user is inserted successfully.
         System.assert(SHMMNUser.id!=null);
         Account acc = new Account();
         Opportunity tempOpp = new Opportunity();
         System.runAs(SHMMNUser)
         {
            
            acc.Name = 'Test Account';
            acc.RecordTypeId = recType;
            insert acc;
            // Assert to check account is created successfully
            System.assert(acc.id!=null);            
            tempOpp.Name = 'Test Opp';
            tempOpp.Type = 'New Business';
            tempOpp.AccountId = acc.id;
            tempOpp.CloseDate = date.newInstance(2016,04,05);
            tempOpp.StageName = 'Sales Released';
            tempOpp.Probability = 30;
            tempOpp.RecordTypeId = oppRecType;
            insert tempOpp; 
            // Assert to check opportunity is created successfully
            System.assert(tempOpp.id!=null);
         }
         ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempOpp);
         Apexpages.currentpage().getparameters().put('OpportunityId' , tempOpp.id);
         Apexpages.currentpage().getparameters().put('user' , profileName);
         SHMMN_ShareOpportunity vfc = new SHMMN_ShareOpportunity (controller); 
         Test.startTest();
         vfc.shareOpp();
         Test.stopTest();
  }
  
}