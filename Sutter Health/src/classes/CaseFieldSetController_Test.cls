/**********************************************************************
 Name: CaseFieldSetController_Test
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for CaseFieldSetController class.
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  09/17/14 Development complete   This class is defined to test CaseFieldSetController class.
 2.0      IDC Offshore  12/22/2015  Class Optimsation   Incorporated changes to implement best test practices in the test class.
 ***********************************************************************/
 
@isTest
private class CaseFieldSetController_Test { 
         
     /*******************************************************************
     Purpose: method to create test data used by all test methods
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
     ********************************************************************/
     
    @testSetup 
    static void createTestData() {
        
     RecordType rtMapByName = [Select Id From RecordType  Where SobjectType = 'Case' and DeveloperName = 'Human_Resource_Job_Evaluation_Form' limit 1]; 
         
     Case caseRecord   = new Case();
     caseRecord.Name_of_Employee_Needing_Access__c = 'Test1';
     caseRecord.Effective_Date_of_Change__c= System.today();
     caseRecord.Employee_s_Job_Title__c= 'Test2' ;
     caseRecord.Type_Of_Access_Needed__c= 'Yes';
     caseRecord.Employee__c= 'Test3';
     caseRecord.Employee_Reports_To_Direct_Supervisor__c= 'Test4';
     caseRecord.Employee_s_Current_Affiliate__c= 'Test5';
     caseRecord.Level_Of_Access_Needed__c= 'Yes' ;
     caseRecord.recordTypeId = rtMapByName.Id;
     caseRecord.Section_View__c  = 'test';
     caseRecord.ownerId = UserInfo.getUserId();
     insert caseRecord; 
     
     /*********************************************************************** 
      Verifying the id of Case record created above
      Expected Result: id value should not be null 
      Actual Result: id value should not be null 
      **********************************************************************/
      system.assert(caseRecord.id!=null);

    }   
     
     /*******************************************************************
     Purpose: method to test CaseFieldSetController's saveAndSend() method negatively
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
     ********************************************************************/
     
     static testMethod void saveAndSend_NegativeTest() {
              
        Test.startTest();
        Case caseRecord   = [select id,ownerid from Case limit 1];
                       
        ApexPages.StandardController ctr = new ApexPages.StandardController(caseRecord);
        CaseFieldSetController CaseFieldSetControllerTest =  new CaseFieldSetController(ctr);
        CaseFieldSetControllerTest.saveAndSend();
        
        Test.stopTest();
        
        /*********************************************************************** 
        Verifying the value returned from the saveAndSend() method
        Expected Result:  value should be null 
        Actual Result:  value should be null 
        **********************************************************************/
        system.assertEquals(CaseFieldSetControllerTest.saveAndSend(),null);     
        
    }
    
    /*******************************************************************
     Purpose: method to test CaseFieldSetController's saveAndSend() method to catch exception block
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: Yes
     ********************************************************************/
     
     static testMethod void saveAndSend_ExceptiionTest(){
            
        RecordType rtMapByName = [Select Id From RecordType  Where SobjectType = 'Case' and DeveloperName = 'Human_Resource_Job_Evaluation_Form' limit 1];
        try{
        Test.startTest();
        
        Case objCase = new Case();
        objCase.Name_of_Employee_Needing_Access__c = 'Test1';
        objCase.Effective_Date_of_Change__c= System.today();
        objCase.Employee_s_Job_Title__c= 'Test2' ;
        objCase.Type_Of_Access_Needed__c= 'Yes';
        objCase.Employee__c= 'Test3';
        objCase.Employee_Reports_To_Direct_Supervisor__c= 'Test4';
        objCase.Employee_s_Current_Affiliate__c= 'Test5';
        objCase.Level_Of_Access_Needed__c= 'Yes' ;
        objCase.recordTypeId = rtMapByName.Id;
        objCase.Section_View__c  = 'Portal View';
        objCase.ownerId = UserInfo.getUserId();
        insert objCase; 
             
                       
        ApexPages.StandardController ctr = new ApexPages.StandardController(objCase);
        CaseFieldSetController CaseFieldSetControllerTest =  new CaseFieldSetController(ctr);
        CaseFieldSetControllerTest.saveAndSend();
        
        Test.stopTest();
        }
        catch(exception ex){
        /*********************************************************************** 
        Verifying the exception through the saveAndSend() method
        Expected Result:  exception != null 
        Actual Result:  exception != null
        **********************************************************************/
        system.assert(ex.getMessage() != null);
        }
    }
    
    /*******************************************************************
     Purpose: method to test CaseFieldSetController's saveAndSend() method.
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
     ********************************************************************/
     
     static testMethod void saveAndSend_Test(){
            
        RecordType rtMapByName = [Select Id From RecordType  Where SobjectType = 'Case' and DeveloperName = 'Human_Resource_Job_Evaluation_Form' limit 1];
        
        Test.startTest();
        
        Case objCase = new Case();
        objCase.Name_of_Employee_Needing_Access__c = 'Test1';
        objCase.Effective_Date_of_Change__c= System.today();
        objCase.Employee_s_Job_Title__c= 'Test2' ;
        objCase.Type_Of_Access_Needed__c= 'Yes';
        objCase.Employee__c= 'Test3';
        objCase.Employee_Reports_To_Direct_Supervisor__c= 'Test4';
        objCase.Employee_s_Current_Affiliate__c= 'Test5';
        objCase.Level_Of_Access_Needed__c= 'Yes' ;
        objCase.recordTypeId = rtMapByName.Id;
        objCase.Section_View__c  = 'Portal View';
        objCase.ownerId = UserInfo.getUserId();
        insert objCase;
        
        objCase.isFiredAcceptButton__c = true;
        update objCase;
        
        ApexPages.StandardController ctr = new ApexPages.StandardController(objCase);
        CaseFieldSetController CaseFieldSetControllerTest =  new CaseFieldSetController(ctr);
        CaseFieldSetControllerTest.saveAndSend();
        
        Test.stopTest();
        
        /*********************************************************************** 
        Verifying the value returned from the saveAndSend() method
        Expected Result:  value should not be null 
        Actual Result:  value should not be null 
        **********************************************************************/
        system.assert(CaseFieldSetControllerTest.saveAndSend() != null);     
        
    }
}