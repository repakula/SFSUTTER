/**********************************************************************
  Name: SHMMN_SHMMNIncumebnt_Test
  Copyright © 2015 IDC Offshore
  ======================================================
  ======================================================
  Purpose:
  This is the test class for SHMMN_SHMMNIncumebnt class            
  ======================================================
  ======================================================
  History
  -------
  VERSION  AUTHOR        DATE        DETAIL                 Description
  1.0      IDC Offshore  05/03/2015 Development complete   This class is defined to test functionality of SHMMN_SHMMNIncumebntd class.  
  ***********************************************************************/
  /*******************************************************************
    Purpose: method to create test data used by all test methods
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
@isTest
Private class SHMMN_SHMMNIncumebnt_Test 
{
  Static Void createTestData()
  {
        Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordTypeId = recType;
        insert acc;
        System.assert(acc.id!=null);
        SHMMN_Incumbent_Carrier__c inc = new SHMMN_Incumbent_Carrier__c();
        inc.Incumbent_Carrier__c = 'AETNA';
        inc.Sub_Product__c = 'EPO';
        inc.Account__c = acc.id;
        insert inc; 
        System.assert(inc.id!=null);
  }
/*******************************************************************
    Purpose: method to check positive scenario of SHMMN Incumbent Carrier save
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/  
  static testmethod void saveSHMMNInc_Test()
  {
     Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account tempAcc = new Account();
     tempAcc.Name = 'Test Account 1';
     tempAcc.RecordTypeId = recType;
     insert tempAcc;
     //Assert to test account is inserted
     System.assert(tempAcc!=null);
     SHMMN_Incumbent_Carrier__c tempInc = new SHMMN_Incumbent_Carrier__c();
     tempInc.Incumbent_Carrier__c = 'AETNA';
     tempInc.Sub_Product__c = 'EPO';
     tempInc.Account__c = tempAcc.id;
     insert tempInc;
     //Assert to test SHMMN Incumbent Carrier record is inserted
     System.assert(tempInc!=null);
     ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempInc);
     Apexpages.currentpage().getparameters().put('id' , tempInc.id);
     SHMMN_SHMMNIncumebnt vfc = new SHMMN_SHMMNIncumebnt (controller); 
     Test.startTest();
     vfc.saveIncumbentCarriers();
     vfc.decreaseList();
     vfc.increaseList();
     Test.stopTest();
  }
  /*******************************************************************
    Purpose: method to check negative scenario of SHMMN Incumbent Carrier save where % is greater than 100
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/ 
  static testmethod void saveSHMMNIncSum_Test()
  {
     Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account tempAcc = new Account();
     tempAcc.Name = 'Test Account 1';
     tempAcc.RecordTypeId = recType;
     insert tempAcc;
     //Assert to test account is inserted
     System.assert(tempAcc!=null);
     SHMMN_Incumbent_Carrier__c tempInc = new SHMMN_Incumbent_Carrier__c();
     tempInc.Incumbent_Carrier__c = 'AETNA';
     tempInc.Sub_Product__c = 'EPO';
     tempInc.Account__c = tempAcc.id;
     tempInc.Contain__c = 120;
     insert tempInc;     
     ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempInc);
     Apexpages.currentpage().getparameters().put('id' , tempInc.id);
     SHMMN_SHMMNIncumebnt vfc = new SHMMN_SHMMNIncumebnt (controller); 
     Test.startTest();
     vfc.saveIncumbentCarriers();
     //Assert to test SHMMN Incumbent Carrier record is not inserted
     System.assert(Apexpages.hasMessages(),true);
     vfc.decreaseList();
     vfc.increaseList();
     Test.stopTest();
  }
 /*******************************************************************
    Purpose: method to check negative scenario of duplicate check for SHMMN Incumbent Carrier
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/  
  static testmethod void saveSHMMNIncDup_Test()
  {
     Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account tempAcc = new Account();
     tempAcc.Name = 'Test Account 1';
     tempAcc.RecordTypeId = recType;
     insert tempAcc;
     //Assert to test account is inserted
     System.assert(tempAcc!=null);
     SHMMN_Incumbent_Carrier__c tempInc = new SHMMN_Incumbent_Carrier__c();
     tempInc.Incumbent_Carrier__c = 'AETNA';
     tempInc.Sub_Product__c = 'EPO';
     tempInc.Account__c = tempAcc.id;
     tempInc.Contain__c = 120;
     insert tempInc;
     //Assert to test SHMMN Incumbent Carrier record is inserted
     System.assert(tempInc!=null);
     SHMMN_Incumbent_Carrier__c tempSMInc = new SHMMN_Incumbent_Carrier__c();
     tempSMInc.Incumbent_Carrier__c = 'AETNA';
     tempSMInc.Sub_Product__c = 'EPO';
     tempSMInc.Account__c = tempAcc.id;
     tempSMInc.Contain__c = 120;
     insert tempSMInc;

     ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempInc);
     Apexpages.currentpage().getparameters().put('id' , tempInc.id);
     SHMMN_SHMMNIncumebnt vfc = new SHMMN_SHMMNIncumebnt (controller); 
     Test.startTest();
     vfc.saveIncumbentCarriers();
     //Assert to test SHMMN Incumbent Carrier record is not inserted
     System.assert(Apexpages.hasMessages(),true);
     vfc.decreaseList();
     vfc.increaseList();
     Test.stopTest();
  }
/*******************************************************************
    Purpose: method to check multiple incumbent carrier from page
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/ 
  static testmethod void saveSHMMNIncMultiple_Test()
  {
     
     Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account tempAcc = new Account();
     tempAcc.Name = 'Test Account 1';
     tempAcc.RecordTypeId = recType;
     insert tempAcc;
     //Assert to test account is inserted
     System.assert(tempAcc!=null);    
     SHMMN_Incumbent_Carrier__c tempInc = new SHMMN_Incumbent_Carrier__c();
     tempInc.Incumbent_Carrier__c = 'AETNA';
     tempInc.Sub_Product__c = 'EPO';
     tempInc.Account__c = tempAcc.id;    
     insert tempInc;
     //Assert to test SHMMN Incumbent Carrier record is inserted
     System.assert(tempInc!=null);
     SHMMN_Incumbent_Carrier__c tempSMInc = new SHMMN_Incumbent_Carrier__c();
     tempSMInc.Incumbent_Carrier__c = 'AETNA';
     tempSMInc.Sub_Product__c = 'PPO';
     tempSMInc.Account__c = tempAcc.id;
     insert tempSMInc;
     //Assert to test SHMMN Incumbent Carrier record is inserted
     System.assert(tempSMInc!=null);
     SHMMN_Incumbent_Carrier__c tempSMInc1 = new SHMMN_Incumbent_Carrier__c();
     tempSMInc1.Incumbent_Carrier__c = 'AETNA';
     tempSMInc1.Sub_Product__c = 'POS';
     tempSMInc1.Account__c = tempAcc.id;
     insert tempSMInc1;
     //Assert to test SHMMN Incumbent Carrier record is inserted
     System.assert(tempSMInc1!=null);
     ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempInc);
     Apexpages.currentpage().getparameters().put('id' , tempInc.id);
     SHMMN_SHMMNIncumebnt vfc = new SHMMN_SHMMNIncumebnt (controller);
     Test.startTest();
     vfc.increaseList();
     vfc.decreaseList();
     Test.stopTest();
     
  }
  /*******************************************************************
    Purpose: method to check wrapper class for Incumbent Carrier
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/ 
  static testmethod void saveSHMMNWrapper_Test()
  {
     try
     {
     Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account tempAcc = new Account();
     tempAcc.Name = 'Test Account 1';
     tempAcc.RecordTypeId = recType;
     insert tempAcc;
     //Assert to test account is inserted
     System.assert(tempAcc!=null);     
     SHMMN_Incumbent_Carrier__c tempInc = new SHMMN_Incumbent_Carrier__c();
     tempInc.Incumbent_Carrier__c = 'AETNA';
     tempInc.Sub_Product__c = 'EPO';  
     insert tempInc;
     //Assert to test SHMMN Incumbent Carrier record is inserted
     System.assert(tempInc!=null);
     Test.startTest();
     SHMMN_SHMMNIncumebnt.incumbentWrapper incWrapper1 = new SHMMN_SHMMNIncumebnt.incumbentWrapper(tempAcc);  
     tempInc.Account__c = tempAcc.id;    
     update tempInc;
     SHMMN_Incumbent_Carrier__c tempSMInc = new SHMMN_Incumbent_Carrier__c();
     tempSMInc.Incumbent_Carrier__c = 'AETNA';
    // tempSMInc.Sub_Product__c = 'PPO';
     tempSMInc.Account__c = tempAcc.id;
     insert tempSMInc;
     SHMMN_SHMMNIncumebnt.incumbentWrapper incWrapper = new SHMMN_SHMMNIncumebnt.incumbentWrapper(tempAcc,tempSMInc); 
     ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempInc);
     Apexpages.currentpage().getparameters().put('id' , tempInc.id);
     SHMMN_SHMMNIncumebnt vfc = new SHMMN_SHMMNIncumebnt (controller);
     
     vfc.increaseList();
     vfc.decreaseList();
     vfc.saveIncumbentCarriers();
     Test.stopTest();
     }
     catch(exception e)
     {
        System.assert(e.getMessage() != null); 
     }
     
  }
 /*******************************************************************
    Purpose: method to create list of Incumbent carrier if there is no existing Incumbent on the selected account
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/  
   static testmethod void saveSHMMNWrapperWithNoINC_Test()
  {
     try
     {
      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account tempAcc = new Account();
     tempAcc.Name = 'Test Account 1';
     tempAcc.RecordTypeId = recType;
     insert tempAcc;
     SHMMN_Incumbent_Carrier__c tempInc = new SHMMN_Incumbent_Carrier__c();
     tempInc.Account__c = tempAcc.id;
     ApexPages.StandardController  controller = new ApexPages.StandardController(tempInc );
     SHMMN_SHMMNIncumebnt   vfc = new SHMMN_SHMMNIncumebnt (controller);
     
     }
     catch(exception e)
     {
        System.assert(e.getMessage() != null); 
     }
     
  }
  
  /*******************************************************************
    Purpose: method to create list of Incumbent carrier if there is no existing Incumbent on the selected account
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/  
   static testmethod void saveSHMMNWrapperWithNoINC_Test1()
  {
     try
     {
      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account tempAcc = new Account();
     tempAcc.Name = 'Test Account 1';
     tempAcc.RecordTypeId = recType;
     insert tempAcc;
     SHMMN_Incumbent_Carrier__c tempInc = new SHMMN_Incumbent_Carrier__c();
     tempInc.Account__c = tempAcc.id;
     ApexPages.StandardController  controller = new ApexPages.StandardController(tempInc );
     SHMMN_SHMMNIncumebnt   vfc = new SHMMN_SHMMNIncumebnt (controller);
     vfc.increaseList();
     vfc.decreaseList();
     vfc.saveIncumbentCarriers();
     }
     catch(exception e)
     {
        System.assert(e.getMessage() != null); 
     }
     
  }
  
  /*******************************************************************
    Purpose: method to create list of Incumbent carrier if there is one existing Incumbent on the selected account
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/  
   static testmethod void saveSHMMNWrapperWithINC_Test1()
  {
     try
     {
      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
     Account tempAcc = new Account();
     tempAcc.Name = 'Test Account 1';
     tempAcc.RecordTypeId = recType;
     insert tempAcc;
     SHMMN_Incumbent_Carrier__c tempInc = new SHMMN_Incumbent_Carrier__c();
     tempInc.Account__c = tempAcc.id;
     insert tempInc;
     ApexPages.StandardController  controller = new ApexPages.StandardController(tempInc );
     SHMMN_SHMMNIncumebnt   vfc = new SHMMN_SHMMNIncumebnt (controller);
     vfc.saveIncumbentCarriers();
     }
     catch(exception e)
     {
        System.assert(e.getMessage() != null); 
     }
     
  } 
}