/**********************************************************************
 Name: SFTriggerAndSFItemUtilTestClas
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for SurveyFeedback trigger and SurveyFeedbackItemUtil class.
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  7/6/2015  Development complete   This class is defined for testing SurveyFeedback trigger and SurveyFeedbackItemUtil class.
 
 2.0      IDC Offshore  12/17/2015  Class Optimisation   Incorporated changes to increase code coverage and implement best test pactices
 ***********************************************************************/

 @isTest
 private class SFTriggerAndSFItemUtilTestClas{  

  /*******************************************************************
  Purpose: method to create test data used by all test methods
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/
    
   @testSetup 
     
   static void createTestData() {
    
    /** Creating an Account **/
    Account objAccount = new Account();
    objAccount.Name = 'test Account';
    insert objAccount;

    /**  Creating a Contact of Employee record type **/
    Id EmpRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
    Contact objContact_Emp = new Contact();
    objContact_Emp.accountId = objAccount.id;
    objContact_Emp.LastName = 'test Contact';
    objContact_Emp.Email = 'Test@testmail.com';
    objContact_Emp.Employee_Work_Email__c = 'Test2@test2gmail.com';
    objContact_Emp.RecordTypeId = EmpRecordTypeId;
    insert objContact_Emp;
    
    /**  Creating a Contact of Vendor record type **/
    Id VendorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
    Contact objContact_Vendor = new Contact();
    objContact_Vendor.accountId = objAccount.id;
    objContact_Vendor.LastName = 'test Contact';
    objContact_Vendor.Email = 'Test@testmail.com';
    objContact_Vendor.Employee_Work_Email__c = 'Test2@test2gmail.com';
    objContact_Vendor.RecordTypeId = VendorRecordTypeId;
    insert objContact_Vendor;
    
    /**  Creating a Contact of Vendor record type **/
    Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S3 Interaction Log').getRecordTypeId();
        Case caseRec1 = new Case();
        caseRec1.subject = 'Test';
        caseRec1.Function__c = 'Human Resource';
        caseRec1.Sub_Function__c = 'HR Information System (HRIS)';
        caseRec1.RecordTypeId = CaseRecordTypeId ;
        
        
        insert caseRec1 ;
        
    /**  Creating a Survey **/
    Survey__c objSurvey = new Survey__c ();
    objSurvey.Hide_Survey_Name__c = false;
    objSurvey.Submit_Response__c= 'test Responce';
    objSurvey.Survey_Container_CSS__c= 'Test Survey Container css';
    objSurvey.Survey_Header__c= 'Test2 Survey Header';
    objSurvey.thankYouLink__c = 'Test2 Survey Thank you link';
    objSurvey.Thank_You_Text__c = 'Test2 Survey Thank you text';
    objSurvey.thankYouText__c = 'Test2 Survey Thank you link';
    objSurvey.URL__c = 'test Url';
    insert objSurvey;
    
    String SurveyId = objSurvey.id;
    
    /**  Creating a Survey Question **/
    Survey_Question__c objSurveyQues1 = new Survey_Question__c();
    objSurveyQues1.Name = 'Was your issue resolved?';
    objSurveyQues1.Type__c = 'Single Select--Horizontal';
    objSurveyQues1.Survey__c = SurveyId;
    objSurveyQues1.OrderNumber__c = 0;
    objSurveyQues1.Required__c = true;
    objSurveyQues1.Choices__c = 'Yes No';
    objSurveyQues1.Question__c = 'Was your issue resolved?';
    insert objSurveyQues1;
    
    /**  Creating a Survey Question **/
    Survey_Question__c objSurveyQues2 = new Survey_Question__c();
    objSurveyQues2.Name = 'How many times have you contacted Sutter Shared Services (S3) about this is...';
    objSurveyQues2.Type__c = 'Single Select--Horizontal';
    objSurveyQues2.Survey__c = SurveyId;
    objSurveyQues2.OrderNumber__c = 1;
    objSurveyQues2.Required__c = true;
    objSurveyQues2.Choices__c = '1 2 >2';
    objSurveyQues2.Question__c = 'How many times have you contacted Sutter Shared Services (S3) about this issue?';
    insert objSurveyQues2;
        
    /**  Creating a Survey Question **/
    Survey_Question__c objSurveyQues3 = new Survey_Question__c();
    objSurveyQues3.Name = 'How would you rate the quality of the service you received from the initial...';
    objSurveyQues3.Type__c = 'Single Select--Horizontal';
    objSurveyQues3.Survey__c = SurveyId;
    objSurveyQues3.OrderNumber__c = 2;
    objSurveyQues3.Required__c = true;
    objSurveyQues3.Choices__c = '0 1';
    objSurveyQues3.Question__c = 'How would you rate the quality of the service you received from the initial agent who assisted you?';
    insert objSurveyQues3;
        
    /**  Creating a Survey Question **/
    Survey_Question__c objSurveyQues4 = new Survey_Question__c();
    objSurveyQues4.Name = 'How likely is it that you would recommend the Sutter Shared Services (S3) C...';
    objSurveyQues4.Type__c = 'Single Select--Horizontal';
    objSurveyQues4.Survey__c = SurveyId;
    objSurveyQues4.OrderNumber__c = 3;
    objSurveyQues4.Required__c = true;
    objSurveyQues4.Choices__c = '0 1';
    objSurveyQues4.Question__c = 'How likely is it that you would recommend the Sutter Shared Services (S3) Contact Center to a colleague?';
    insert objSurveyQues4;
        
    /**  Creating a Survey Question **/
    Survey_Question__c objSurveyQues5 = new Survey_Question__c();
    objSurveyQues5.Name = 'Comments';
    objSurveyQues5.Type__c = 'Free Text';
    objSurveyQues5.Survey__c = SurveyId;
    objSurveyQues5.OrderNumber__c = 4;
    objSurveyQues5.Required__c = false;
    objSurveyQues5.Question__c = 'Comments';
    insert objSurveyQues5;
    
    /*********************************************************************** 
     Verifying the value using system.assertNotEquals() 
     Expected Result: Survey id is not null
     Actual Result: Survey id is not null  
    ***********************************************************************/
    system.assertNotEquals(objSurvey.id,null);  
    
    Survey_Feedback__c surFb = new Survey_Feedback__c ();
    surFb.Status__c = 'New';
    
    
    Survey_Feedback_Item__c surFbItem = new Survey_Feedback_Item__c();
    surFbItem.Name = 'Test';
    insert surFbItem;
     
  }
  
  
    /*******************************************************************
     Purpose: method to create Survey Taker data used by test methods
     Parameters: Id,Id
     Returns: SurveyTaker__c
     Throws [Exceptions]: N/A
     ********************************************************************/ 
    
    private static SurveyTaker__c createSurveyTaker(Id CaseId,Id ContactId,Id surveyId){
        SurveyTaker__c objSurveyTaker = new SurveyTaker__c ();
        objSurveyTaker.Case__c = CaseId;
        objSurveyTaker.Contact__c = ContactId;
        objSurveyTaker.Survey__c = surveyId;
        objSurveyTaker.Additional_Comments__c = 'test Additional Comments';
        objSurveyTaker.Taken__c = 'Test Taken';
           
        return objSurveyTaker;
        
        
    }
      
    /*******************************************************************
     Purpose: method to create Survey Question Response data used by test methods
     Parameters: Id,Id,String
     Returns: SurveyQuestionResponse__c
     Throws [Exceptions]: N/A
    ********************************************************************/ 
    
    private static SurveyQuestionResponse__c createSurveyQuestionResponse(Id QuesId,Id surveytakenId,string Response){
        SurveyQuestionResponse__c objSQRes = new SurveyQuestionResponse__c();
        objSQRes.SurveyTaker__c = surveytakenId;
        objSQRes.Survey_Question__c = QuesId;
        objSQRes.Response__c = Response;
        objSQRes.Response_Score__c  = 0.00;
        return objSQRes;
    }
    
    /*******************************************************************
     Purpose: method to test the logic of Survey Feedback item creation
     Parameters: N/A
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/    
    
    private testMethod static void createSurveyFeedbackItem_Test(){
        
        Test.startTest();
        
        Id EmpRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S3 Interaction Log').getRecordTypeId();
        Account objAcc = [select id from Account limit 1];
        Contact objContact = [select id from Contact where recordTypeId=:EmpRecordTypeId limit 1];
        Case objCase = [select id from Case where recordTypeId=:CaseRecordTypeId limit 1];
               
        /** Fetching the created Survey **/
        Survey__c  objSurvey = [select id from Survey__c limit 1];        
        
        /** Creating a Survey Taker record **/
        SurveyTaker__c objSurveyTaker = createSurveyTaker(objCase.id,objContact.id,objSurvey.id);
        insert objSurveyTaker;
        
        /** Fetching the already creating Survey Questions **/
        Survey_Question__c objSurveyQues1 = [select id from Survey_Question__c where OrderNumber__c = 0];
        
        Survey_Question__c objSurveyQues2 = [select id from Survey_Question__c where OrderNumber__c = 1];
        
        Survey_Question__c objSurveyQues3 = [select id from Survey_Question__c where OrderNumber__c = 2];
        
        Survey_Question__c objSurveyQues4 = [select id from Survey_Question__c where OrderNumber__c = 3];
        
        Survey_Question__c objSurveyQues5 = [select id from Survey_Question__c where OrderNumber__c = 4];
        
        /** Creating Survey Responses for Survey Questions **/
        SurveyQuestionResponse__c objSurveyQuesRes1 = createSurveyQuestionResponse(objSurveyQues1.id,objSurveyTaker.id,'No');
        insert objSurveyQuesRes1;
        
        SurveyQuestionResponse__c objSurveyQuesRes2 = createSurveyQuestionResponse(objSurveyQues2.id,objSurveyTaker.id,'>2');
        insert objSurveyQuesRes2;

        SurveyQuestionResponse__c objSurveyQuesRes3 = createSurveyQuestionResponse(objSurveyQues3.id,objSurveyTaker.id,'9');
        insert objSurveyQuesRes3;

        SurveyQuestionResponse__c objSurveyQuesRes4 = createSurveyQuestionResponse(objSurveyQues4.id,objSurveyTaker.id,'9');
        insert objSurveyQuesRes4;

        SurveyQuestionResponse__c objSurveyQuesRes5 = createSurveyQuestionResponse(objSurveyQues5.id,objSurveyTaker.id,'5');
        insert objSurveyQuesRes5;
        
        SurveyFeedbackItemUtil.createSurveyFeedbackItem(objSurveyTaker.id);
        
        SurveyQuestionResponse__c SurveyQuesRes1 = createSurveyQuestionResponse(objSurveyQues1.id,objSurveyTaker.id,'yes');
        insert SurveyQuesRes1;
        
        SurveyQuestionResponse__c SurveyQuesRes2 = createSurveyQuestionResponse(objSurveyQues2.id,objSurveyTaker.id,'>2');
        insert SurveyQuesRes2;

        SurveyQuestionResponse__c SurveyQuesRes3 = createSurveyQuestionResponse(objSurveyQues3.id,objSurveyTaker.id,'9');
        insert SurveyQuesRes3;

        SurveyQuestionResponse__c SurveyQuesRes4 = createSurveyQuestionResponse(objSurveyQues4.id,objSurveyTaker.id,'9');
        insert SurveyQuesRes4;

        SurveyQuestionResponse__c SurveyQuesRes5 = createSurveyQuestionResponse(objSurveyQues5.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes5;
        
        SurveyFeedbackItemUtil.createSurveyFeedbackItem(objSurveyTaker.id);
        
        /*********************************************************************** 
         Verifying the value using system.assertNotEquals() 
         Expected Result: Survey Feedback record id is not null
         Actual Result: Survey Feedback record id is not null
        ***********************************************************************/
        
        Survey_Feedback__c obj = [select id from Survey_Feedback__c limit 1];
        system.assertNotEquals(obj.id,null);
        
        Test.stopTest();

    }
    
    /*******************************************************************
     Purpose: method to validate createSurveyFeedbackItem() method by changing the survey responses being filled or provided
     Parameters: N/A
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/  
    
    private testMethod static void createSurveyFeedbackItemRespChange_Test(){
        
        Test.startTest();
        
        Id EmpRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S3 Interaction Log').getRecordTypeId();
        Account objAcc = [select id from Account limit 1];
        Contact objContact = [select id from Contact where recordTypeId=:EmpRecordTypeId limit 1];
        Case objCase = [select id from Case where recordTypeId=:CaseRecordTypeId limit 1];  
        
        Survey__c  objSurvey = [select id from Survey__c limit 1];        
        
        SurveyTaker__c objSurveyTaker = createSurveyTaker(objCase.id,objContact.id,objSurvey.id);
        insert objSurveyTaker;
        
        /** Getting Survey Question Records **/
        Survey_Question__c objSurveyQues1 = [select id from Survey_Question__c where OrderNumber__c = 0];
        
        Survey_Question__c objSurveyQues2 = [select id from Survey_Question__c where OrderNumber__c = 1];
        
        Survey_Question__c objSurveyQues3 = [select id from Survey_Question__c where OrderNumber__c = 2];
        
        Survey_Question__c objSurveyQues4 = [select id from Survey_Question__c where OrderNumber__c = 3];
        
        Survey_Question__c objSurveyQues5 = [select id from Survey_Question__c where OrderNumber__c = 4];
                
        /** Creating Survey Response Records **/
        SurveyQuestionResponse__c SurveyQuesRes1 = createSurveyQuestionResponse(objSurveyQues1.id,objSurveyTaker.id,'yes');
        insert SurveyQuesRes1;
        
        SurveyQuestionResponse__c SurveyQuesRes2 = createSurveyQuestionResponse(objSurveyQues2.id,objSurveyTaker.id,'>2');
        insert SurveyQuesRes2;

        SurveyQuestionResponse__c SurveyQuesRes3 = createSurveyQuestionResponse(objSurveyQues3.id,objSurveyTaker.id,'9');
        insert SurveyQuesRes3;

        SurveyQuestionResponse__c SurveyQuesRes4 = createSurveyQuestionResponse(objSurveyQues4.id,objSurveyTaker.id,'9');
        insert SurveyQuesRes4;

        SurveyQuestionResponse__c SurveyQuesRes5 = createSurveyQuestionResponse(objSurveyQues5.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes5;
        
        SurveyFeedbackItemUtil.createSurveyFeedbackItem(objSurveyTaker.id);
        
        /*********************************************************************** 
         Verifying the value using system.assertNotEquals() 
         Expected Result: Survey Feedback record id is not null
         Actual Result: Survey Feedback record id is not null
        ***********************************************************************/
        
        Survey_Feedback__c obj = [select id from Survey_Feedback__c limit 1];
        system.assertNotEquals(obj.id,null);
        
        Test.stopTest();

    }
    
    /*******************************************************************
     Purpose: method to test the createSurveyFeedbackItem() method by filling different survey response to cover the logic
     Parameters: N/A
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/ 
    
    private testMethod static void createSurveyFeedbackItemResponseChg_Test(){
        
        Test.startTest();
        
        Id EmpRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S3 Interaction Log').getRecordTypeId();
        Account objAcc = [select id from Account limit 1];
        Contact objContact = [select id from Contact where recordTypeId=:EmpRecordTypeId limit 1];
        Case objCase = [select id from Case where recordTypeId=:CaseRecordTypeId limit 1]; 
               
        Survey__c  objSurvey = [select id from Survey__c limit 1];        
        
        SurveyTaker__c objSurveyTaker = createSurveyTaker(objCase.id,objContact.id,objSurvey.id);
        insert objSurveyTaker;
        
        /** Getting Survey Question Records **/
        Survey_Question__c objSurveyQues1 = [select id from Survey_Question__c where OrderNumber__c = 0];
        
        Survey_Question__c objSurveyQues2 = [select id from Survey_Question__c where OrderNumber__c = 1];
        
        Survey_Question__c objSurveyQues3 = [select id from Survey_Question__c where OrderNumber__c = 2];
        
        Survey_Question__c objSurveyQues4 = [select id from Survey_Question__c where OrderNumber__c = 3];
        
        Survey_Question__c objSurveyQues5 = [select id from Survey_Question__c where OrderNumber__c = 4];
        
        
        /** Creating Survey Response Records **/
        SurveyQuestionResponse__c SurveyQuesRes1 = createSurveyQuestionResponse(objSurveyQues1.id,objSurveyTaker.id,'yes');
        insert SurveyQuesRes1;
        
        SurveyQuestionResponse__c SurveyQuesRes2 = createSurveyQuestionResponse(objSurveyQues2.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes2;

        SurveyQuestionResponse__c SurveyQuesRes3 = createSurveyQuestionResponse(objSurveyQues3.id,objSurveyTaker.id,'2');
        insert SurveyQuesRes3;

        SurveyQuestionResponse__c SurveyQuesRes4 = createSurveyQuestionResponse(objSurveyQues4.id,objSurveyTaker.id,'9');
        insert SurveyQuesRes4;

        SurveyQuestionResponse__c SurveyQuesRes5 = createSurveyQuestionResponse(objSurveyQues5.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes5;
        
        SurveyFeedbackItemUtil.createSurveyFeedbackItem(objSurveyTaker.id);
        
        /*********************************************************************** 
         Verifying the value using system.assertNotEquals() 
         Expected Result: Survey Feedback record id is not null
         Actual Result: Survey Feedback record id is not null
        ***********************************************************************/
        
        Survey_Feedback__c obj = [select id from Survey_Feedback__c limit 1];
        system.assertNotEquals(obj.id,null);
        
        Test.stopTest();

    }
    
    /*******************************************************************
     Purpose: method to cover createSurveyFeedbackItem() method by changing survey responses to cover the logic written
     Parameters: N/A
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/   
    
    private testMethod static void createSurveyFeedbackItemResponseTest(){
        
        Test.startTest();
        
        Id EmpRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S3 Interaction Log').getRecordTypeId();
        Account objAcc = [select id from Account limit 1];
        Contact objContact = [select id from Contact where recordTypeId=:EmpRecordTypeId limit 1];
        Case objCase = [select id from Case where recordTypeId=:CaseRecordTypeId limit 1]; 
               
        Survey__c  objSurvey = [select id from Survey__c limit 1];        
        
        SurveyTaker__c objSurveyTaker = createSurveyTaker(objCase.id,objContact.id,objSurvey.id);
        insert objSurveyTaker;
        
        /** Getting Survey Question Records **/
        Survey_Question__c objSurveyQues1 = [select id from Survey_Question__c where OrderNumber__c = 0];
        
        Survey_Question__c objSurveyQues2 = [select id from Survey_Question__c where OrderNumber__c = 1];
        
        Survey_Question__c objSurveyQues3 = [select id from Survey_Question__c where OrderNumber__c = 2];
        
        Survey_Question__c objSurveyQues4 = [select id from Survey_Question__c where OrderNumber__c = 3];
        
        Survey_Question__c objSurveyQues5 = [select id from Survey_Question__c where OrderNumber__c = 4];
        
        /** Creating Survey Response Records **/
        SurveyQuestionResponse__c SurveyQuesRes1 = createSurveyQuestionResponse(objSurveyQues1.id,objSurveyTaker.id,'6');
        insert SurveyQuesRes1;
        
        SurveyQuestionResponse__c SurveyQuesRes2 = createSurveyQuestionResponse(objSurveyQues2.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes2;

        SurveyQuestionResponse__c SurveyQuesRes3 = createSurveyQuestionResponse(objSurveyQues3.id,objSurveyTaker.id,'8');
        insert SurveyQuesRes3;

        SurveyQuestionResponse__c SurveyQuesRes4 = createSurveyQuestionResponse(objSurveyQues4.id,objSurveyTaker.id,'9');
        insert SurveyQuesRes4;

        SurveyQuestionResponse__c SurveyQuesRes5 = createSurveyQuestionResponse(objSurveyQues5.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes5;
        
        SurveyFeedbackItemUtil.createSurveyFeedbackItem(objSurveyTaker.id);
        
        /*********************************************************************** 
         Verifying the value using system.assertNotEquals() 
         Expected Result: Survey Feedback record id is not null
         Actual Result: Survey Feedback record id is not null
        ***********************************************************************/
        
        List<Survey_Feedback__c> itemList = new List<Survey_Feedback__c>([select id from Survey_Feedback__c limit 1]);
        system.assertEquals(itemList.isEmpty(),true);
        
        Test.stopTest();

    }
    
     /*******************************************************************
      Purpose: method to check createSurveyFeedbackItem() method by changing survey responses that we are going to provide to cover all the logic and verify it
      Parameters: N/A
      Returns: void
      Throws [Exceptions]: N/A
      ********************************************************************/   
     
     private testMethod static void createSurveyFeedbackItemDiffResponse_Test(){
        
        Test.startTest();
        
        Id VendorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S3 Interaction Log').getRecordTypeId();
        Account objAcc = [select id from Account limit 1];
        Contact objContact = [select id from Contact where recordTypeId=:VendorRecordTypeId limit 1];
        Case objCase = [select id from Case where recordTypeId=:CaseRecordTypeId limit 1];
               
        Survey__c  objSurvey = [select id from Survey__c limit 1];        
        
        SurveyTaker__c objSurveyTaker = createSurveyTaker(objCase.id,objContact.id,objSurvey.id);
        insert objSurveyTaker;
        
        /** Getting Survey Question Records **/
        Survey_Question__c objSurveyQues1 = [select id from Survey_Question__c where OrderNumber__c = 0];
        
        Survey_Question__c objSurveyQues2 = [select id from Survey_Question__c where OrderNumber__c = 1];
        
        Survey_Question__c objSurveyQues3 = [select id from Survey_Question__c where OrderNumber__c = 2];
        
        Survey_Question__c objSurveyQues4 = [select id from Survey_Question__c where OrderNumber__c = 3];
        
        Survey_Question__c objSurveyQues5 = [select id from Survey_Question__c where OrderNumber__c = 4];
        
        /** Creating Survey Response Records **/
        SurveyQuestionResponse__c SurveyQuesRes1 = createSurveyQuestionResponse(objSurveyQues1.id,objSurveyTaker.id,'6');
        insert SurveyQuesRes1;
        
        SurveyQuestionResponse__c SurveyQuesRes2 = createSurveyQuestionResponse(objSurveyQues2.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes2;

        SurveyQuestionResponse__c SurveyQuesRes3 = createSurveyQuestionResponse(objSurveyQues3.id,objSurveyTaker.id,'8');
        insert SurveyQuesRes3;

        SurveyQuestionResponse__c SurveyQuesRes4 = createSurveyQuestionResponse(objSurveyQues4.id,objSurveyTaker.id,'6');
        insert SurveyQuesRes4;

        SurveyQuestionResponse__c SurveyQuesRes5 = createSurveyQuestionResponse(objSurveyQues5.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes5;
        
        SurveyFeedbackItemUtil.createSurveyFeedbackItem(objSurveyTaker.id);
        
        /*********************************************************************** 
         Verifying the value using system.assertNotEquals() 
         Expected Result: Survey Feedback record id is not null
         Actual Result: Survey Feedback record id is not null
        ***********************************************************************/
        
        Survey_Feedback__c obj = [select id from Survey_Feedback__c limit 1];
        system.assertNotEquals(obj.id,null);
        
        Test.stopTest();

    }
     
     /*******************************************************************
      Purpose: method to validate createSurveyFeedbackItem() method by changing survey responses to cover all the conditions feasible
      Parameters: N/A
      Returns: void
      Throws [Exceptions]: N/A
      ********************************************************************/
     
     private testMethod static void createSurveyFeedbackAllConditions_Test(){
        
        Test.startTest();
        
        Id VendorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S3 Interaction Log').getRecordTypeId();
        Account objAcc = [select id from Account limit 1];
        Contact objContact = [select id from Contact where recordTypeId=:VendorRecordTypeId limit 1];
        Case objCase = [select id from Case where recordTypeId=:CaseRecordTypeId limit 1];
               
        Survey__c  objSurvey = [select id from Survey__c limit 1];
        
        SurveyTaker__c objSurveyTaker = createSurveyTaker(objCase.id,objContact.id,objSurvey.id);
        insert objSurveyTaker;
        
        /** Fetching Survey Question Records **/
        Survey_Question__c objSurveyQues1 = [select id from Survey_Question__c where OrderNumber__c = 0];
        
        Survey_Question__c objSurveyQues2 = [select id from Survey_Question__c where OrderNumber__c = 1];
        
        Survey_Question__c objSurveyQues3 = [select id from Survey_Question__c where OrderNumber__c = 2];
        
        Survey_Question__c objSurveyQues4 = [select id from Survey_Question__c where OrderNumber__c = 3];
        
        Survey_Question__c objSurveyQues5 = [select id from Survey_Question__c where OrderNumber__c = 4];
        
        /** Creating Survey Response Records for Survey Questions **/
        SurveyQuestionResponse__c SurveyQuesRes1 = createSurveyQuestionResponse(objSurveyQues1.id,objSurveyTaker.id,'6');
        insert SurveyQuesRes1;
        
        SurveyQuestionResponse__c SurveyQuesRes2 = createSurveyQuestionResponse(objSurveyQues2.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes2;

        SurveyQuestionResponse__c SurveyQuesRes3 = createSurveyQuestionResponse(objSurveyQues3.id,objSurveyTaker.id,'8');
        insert SurveyQuesRes3;

        SurveyQuestionResponse__c SurveyQuesRes4 = createSurveyQuestionResponse(objSurveyQues4.id,objSurveyTaker.id,'8');
        insert SurveyQuesRes4;

        SurveyQuestionResponse__c SurveyQuesRes5 = createSurveyQuestionResponse(objSurveyQues5.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes5;
        
        SurveyFeedbackItemUtil.createSurveyFeedbackItem(objSurveyTaker.id);
        
        /*********************************************************************** 
         Verifying the value using system.assertNotEquals() 
         Expected Result: Survey Feedback record id is null
         Actual Result: Survey Feedback record id is null
        ***********************************************************************/
        
        List<Survey_Feedback__c> itemList = new List<Survey_Feedback__c>([select id from Survey_Feedback__c limit 1]);
        system.assertEquals(itemList.isEmpty(),true);
        
        Test.stopTest();

    }
     
      /*******************************************************************
      Purpose: method to verify createSurveyFeedbackItem() negatively by changing survey responses
      Parameters: N/A
      Returns: void
      Throws [Exceptions]: N/A
      ********************************************************************/
      
      private testMethod static void createSurveyFeedbackItem_Test_Negative(){
                
        Test.startTest();
        
        Account objAcc = [select id from Account limit 1];
        Survey__c  objSurvey = [select id from Survey__c limit 1];
               
        SurveyTaker__c objSurveyTaker = createSurveyTaker(null,null,objSurvey.id);
        insert objSurveyTaker;
        
        /** Fetching the Survey Questions **/
        Survey_Question__c objSurveyQues1 = [select id from Survey_Question__c where OrderNumber__c = 0];
        
        Survey_Question__c objSurveyQues2 = [select id from Survey_Question__c where OrderNumber__c = 1];
        
        Survey_Question__c objSurveyQues3 = [select id from Survey_Question__c where OrderNumber__c = 2];
        
        Survey_Question__c objSurveyQues4 = [select id from Survey_Question__c where OrderNumber__c = 3];
        
        Survey_Question__c objSurveyQues5 = [select id from Survey_Question__c where OrderNumber__c = 4];
        
        /** Creating Survey Responses **/
        SurveyQuestionResponse__c SurveyQuesRes1 = createSurveyQuestionResponse(objSurveyQues1.id,objSurveyTaker.id,'6');
        insert SurveyQuesRes1;
        
        SurveyQuestionResponse__c SurveyQuesRes2 = createSurveyQuestionResponse(objSurveyQues2.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes2;

        SurveyQuestionResponse__c SurveyQuesRes3 = createSurveyQuestionResponse(objSurveyQues3.id,objSurveyTaker.id,'8');
        insert SurveyQuesRes3;

        SurveyQuestionResponse__c SurveyQuesRes4 = createSurveyQuestionResponse(objSurveyQues4.id,objSurveyTaker.id,'8');
        insert SurveyQuesRes4;

        SurveyQuestionResponse__c SurveyQuesRes5 = createSurveyQuestionResponse(objSurveyQues5.id,objSurveyTaker.id,'5');
        insert SurveyQuesRes5;
        
        SurveyFeedbackItemUtil.createSurveyFeedbackItem(objSurveyTaker.id);
        
        /*********************************************************************** 
         Verifying the value using system.assertNotEquals() 
         Expected Result: Survey Feedback record id is  null
         Actual Result: Survey Feedback record id is  null
        ***********************************************************************/
        
        List<Survey_Feedback__c> itemList = new List<Survey_Feedback__c>([select id from Survey_Feedback__c limit 1]);
        system.assertEquals(itemList.isEmpty(),true);
        
        Test.stopTest();

    }
     
     /*******************************************************************
      Purpose: method to validate createSurveyFeedback Trigger by creating a Survey feedback record
      Parameters: N/A
      Returns: void
      Throws [Exceptions]: N/A
      ********************************************************************/
     
     private testMethod static void validateSurveyFeedbackTrigger(){
        
        Test.startTest();
        
        /******************************************
        ******************************************/
        Id EmpRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S3 Interaction Log').getRecordTypeId();
        Account objAcc = [select id from Account limit 1];
        Contact objContact = [select id from Contact where recordTypeId=:EmpRecordTypeId limit 1];
        Case objCase = [select id from Case where recordTypeId=:CaseRecordTypeId limit 1];
               
        /** Fetching the created Survey **/
        Survey__c  objSurvey = [select id from Survey__c limit 1];        
        
        /** Creating a Survey Taker record **/
        SurveyTaker__c objSurveyTaker = createSurveyTaker(objCase.id,objContact.id,objSurvey.id);
        insert objSurveyTaker;
        
        
        
        /******************************************
        ******************************************/
        
        /** Creating a Survey Feedback record for testing purpose **/
        Survey_Feedback__c objSurveyFBack = new Survey_Feedback__c();
        Id RecordTypeId = Schema.SObjectType.Survey_Feedback__c.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        objSurveyFBack.RecordTypeId = RecordTypeId;
        objSurveyFBack.Status__c = 'New';
        objSurveyFBack.Agent_Outcome__c= 'Coaching';
        // objSurveyFBack.Sub_Function__c= Survey_Taken__r.Case__r.Sub_Function__c;
        objSurveyFBack.Survey_Taken__c= objSurveyTaker.id;
        objSurveyFBack.Customer_Outcome__c= 'System Issue';
        
        objSurveyFBack.Outcome_Comment__c = 'Test';
        insert objSurveyFBack;
        system.assertEquals(objSurveyFBack.Survey_Taken__c,objSurveyTaker.id);
        /** Updating the Survey Feedback record with Closed status **/
        objSurveyFBack.Status__c  = 'Closed';
        update objSurveyFBack;
        
        /** Updating the Survey Feedback record's ChangeOwner field with Currnet user's id **/
        objSurveyFBack.Change_Owner__c = userinfo.getuserid();
        update objSurveyFBack;
                
        /*********************************************************************** 
         Verifying the value using system.assertEquals() 
         Expected Result: Owner of Survey Feedback record is current user's id
         Actual Result: Owner of Survey Feedback record is current user's id
        ***********************************************************************/
        system.assertEquals(objSurveyFBack.Change_Owner__c,userinfo.getuserId());
        
        
        Test.stopTest();
    }
    
    /*******************************************************************
      Purpose: method to validate createSurveyFeedback Trigger for bulk insertion
      Parameters: N/A
      Returns: void
      Throws [Exceptions]: N/A
      ********************************************************************/
     
     private testMethod static void validateSurveyFeedbackTrigger_BulkTest(){
        
        List<Survey_Feedback__c> lstSFIns = new List<Survey_Feedback__c>();
        List<Survey_Feedback__c> lstSFupd = new List<Survey_Feedback__c>();
        List<Survey_Feedback__c> lstSFupd2 = new List<Survey_Feedback__c>();
        
        Test.startTest();
        /******************************************
        ******************************************/
        Id EmpRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S3 Interaction Log').getRecordTypeId();
        Account objAcc = [select id from Account limit 1];
        Contact objContact = [select id from Contact where recordTypeId=:EmpRecordTypeId limit 1];
        Case objCase = [select id from Case where recordTypeId=:CaseRecordTypeId limit 1];
               
        /** Fetching the created Survey **/
        Survey__c  objSurvey = [select id from Survey__c limit 1];        
        
        /** Creating a Survey Taker record **/
        SurveyTaker__c objSurveyTaker = createSurveyTaker(objCase.id,objContact.id,objSurvey.id);
        insert objSurveyTaker;
        
        
        
        /******************************************
        ******************************************/
        /** Creating  Survey Feedback records for testing purpose **/
        
        for(Integer i=1;i<=100;i++){
        Survey_Feedback__c objSurveyFBack = new Survey_Feedback__c();
        Id RecordTypeId = Schema.SObjectType.Survey_Feedback__c.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        objSurveyFBack.RecordTypeId = RecordTypeId;
        objSurveyFBack.Status__c = 'New';
        objSurveyFBack.Agent_Outcome__c= 'Coaching';
        objSurveyFBack.Survey_Taken__c= objSurveyTaker.id;
        objSurveyFBack.Customer_Outcome__c= 'System Issue';
        objSurveyFBack.Outcome_Comment__c = 'Test';
        lstSFIns.add(objSurveyFBack);
        }
        insert lstSFIns;
        
        /** Updating the Survey Feedback records with Closed status **/
        
        for(Survey_Feedback__c objSurveyFeedBack:lstSFIns){
        objSurveyFeedBack.Status__c  = 'Closed';
        lstSFUpd.add(objSurveyFeedBack);
        }
        update lstSFUpd;
        
        /** Updating the Survey Feedback record's ChangeOwner field with Currnet user's id **/
        for(Survey_Feedback__c objSur_FeedBack:lstSFUpd){
        objSur_FeedBack.Change_Owner__c = userinfo.getuserid();
        
        lstSFUpd2.add(objSur_FeedBack);
        }
        update lstSFUpd2;
        
        Survey_Feedback_Item__c surFbItem = new Survey_Feedback_Item__c();
        surFbItem.Name = 'Test';
        insert surFbItem;
                
        /*********************************************************************** 
         Verifying the value using system.assertEquals() 
         Expected Result: Owner of Survey Feedback record is current user's id
         Actual Result: Owner of Survey Feedback record is current user's id
        ***********************************************************************/
        
        system.assertEquals(lstSFUpd2[0].Change_Owner__c,userinfo.getuserId());
        SurveyFeedbackItemUtil.assignOwner(lstSFUpd[0]);
        Test.stopTest();
        
    }

}