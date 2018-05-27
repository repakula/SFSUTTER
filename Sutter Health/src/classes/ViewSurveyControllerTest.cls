/**********************************************************************
 Name: ViewSurveyController_Test
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for ViewSurveyController class
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  05-Jan-2016 Development complete   Test Class for ViewSurveyController.
 ***********************************************************************/
@isTest
private class ViewSurveyControllerTest{
    /*******************************************************************
    Purpose: This method is used to test updates the survey name.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/ 
    static Testmethod void updateSurveyName_Test() {
        SurveyTestingUtil tu = new SurveyTestingUtil();

        Survey_Question__c q = new Survey_Question__c();
        q.Name = 'Testing Question';
        q.Survey__c = tu.surveyId;
        q.Type__c =  'Multi-Select--Vertical';
        q.Choices__c = 'one\ntwo\nthree\n';
        q.Question__c = 'Testing Question question';
        q.OrderNumber__c = 50;
        q.Required__c = true;
        insert q;
        
        /*********************************************************************** 
        Verifying Survey_Question__c has been created successfully.
        Expected Result: Survey_Question__c record id is not null
        Actual Result: Survey_Question__c record id  is not null 
        ***********************************************************************/ 
        system.assert(q.id != null);
        
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
        Apexpages.Standardcontroller stc; 

        ViewSurveyController viewSurvey = new  ViewSurveyController(stc);
        Test.startTest();
        viewSurvey.updateSurveyName();
        viewSurvey.updateSurveyThankYouAndLink();
        viewSurvey.refreshQuestionList();
        Test.StopTest();
    }
 
    /*******************************************************************
    Purpose: This method is used to test updates the thank you message and links.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static Testmethod void updateSurveyThankYouAndLinkTest() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId); 
        Apexpages.currentPage().getParameters().put('cId',tu.contactId);
        
        Employer_Group_Data__c tempobj = new Employer_Group_Data__c();
        tempobj.SCN_Survey_Sent_Date__c = system.today();
        insert tempobj;

        Apexpages.currentPage().getParameters().put('scnid',tempobj.id);
        SurveyTaker__c tempSurveyTaker = new SurveyTaker__c(id = tu.surveyTakerId);

        tempSurveyTaker.Sold_Case_Notification__c = tempobj.id;
        update tempSurveyTaker;
        
        Apexpages.Standardcontroller stc; 
         ViewSurveyController viewSurvey = new  ViewSurveyController(stc);
         Test.startTest();
         viewSurvey.updateSurveyName();
         viewSurvey.updateSurveyThankYouAndLink();
         viewSurvey.refreshQuestionList();
         viewSurvey.resultPage();
         viewSurvey.getResponses();
         viewSurvey.qRequired = true;
         viewSurvey.questionName ='abc';
         viewSurvey.questionType ='test';
         
         // Assert to check Survey
        /*********************************************************************** 
        Verifying Survey value
        Expected Result: Survey value should be null
        Actual Result: Survey value should be null 
        ***********************************************************************/ 
        system.assertnotequals(viewSurvey,null);
          
        List<SelectOption> abc = new List<SelectOption>();
        abc.add(new SelectOption('Anonymous',System.Label.LABS_SF_Anonymous));
        viewSurvey.singleOptions =abc;
        List<string> res = new List<string>();
        res.add('abc');
        viewSurvey.responses =res;
        viewSurvey.questionRequired = true;
         Survey__c sc  = new survey__c(Submit_Response__c ='test');
         insert sc ;
        Survey_Question__c  question = new  Survey_Question__c( OrderNumber__c = 1, Question__c ='test', Survey__c = sc.id,Required__C = true);
        insert question;
        Test.stopTest();
     }
    /*******************************************************************
    Purpose: This method is used to test Initializes the survey page and displays it to user.
    Parameters: N/A 
    Returns: void 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static Testmethod void ConstructorInit_Test(){
    SurveyTestingUtil tu = new SurveyTestingUtil();
    /*********************************************************************** 
    Verifying the Survey has been created successfully
    Expected Result: Survey id is not null
    Actual Result: Survey id  is not null 
    ***********************************************************************/ 
    system.assert(tu.surveyId != null);
    
    Apexpages.currentPage().getParameters().put('id',tu.surveyId);
    Case tempCase  = AP01_TestDataUtility.createCase();
    Apexpages.currentPage().getParameters().put('caId',tempCase.id);
    SurveyTaker__c tempSurveyTaker = new SurveyTaker__c(id = tu.surveyTakerId);
    tempSurveyTaker.Case__c = tempCase.id;
    update tempSurveyTaker;

    Apexpages.Standardcontroller stc;
    Test.startTest();
    ViewSurveyController viewSurvey = new  ViewSurveyController(stc);
    Test.stopTest();
    }
         
    /*******************************************************************
    Purpose: This method is used to negating testing Initializes the survey page and displays it to user.
    Parameters: N/A 
    Returns: void 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static Testmethod void ConstructorInit_NegativeTest(){
    SurveyTestingUtil tu = new SurveyTestingUtil();
    /*********************************************************************** 
    Verifying the Survey has been created successfully
    Expected Result: Survey id is not null
    Actual Result: Survey id  is not null 
    ***********************************************************************/ 
    system.assert(tu.surveyId != null);
    
    Apexpages.currentPage().getParameters().put('id',tu.surveyId);
    Case tempCase  = AP01_TestDataUtility.createCase();
    tempCase.status = 'Closed';
    tempCase.Close_Reason__c = 'test closed ';
    update tempCase;
    Survey_Question__c question =  new Survey_Question__c();
    question.Required__c = true;

    Apexpages.currentPage().getParameters().put('caId',tempCase.id);
    Apexpages.Standardcontroller stc; 
    Test.startTest();
    ViewSurveyController viewSurvey = new  ViewSurveyController(stc);
    Test.stopTest();
    }
     
    /*******************************************************************
    Purpose: This method is used to test Constructor of the class. It grabs the input from the Survey URL
    Parameters: N/A 
    Returns: N/A 
    Throws [Exceptions]: N/A
    ********************************************************************/
    private static Testmethod void viewShareSurveyComponentController_Test() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        /*********************************************************************** 
        Verifying the Survey and Contact have been created successfully
        Expected Result: Survey and Contact id's are not null
        Actual Result: Survey and Contact id's  are not null 
        ***********************************************************************/ 
        system.assert(tu.surveyId != null);
        system.assert(tu.contactId != null);
        
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);
        Apexpages.currentPage().getParameters().put('cId',tu.contactId);        
        Apexpages.Standardcontroller stc; 
        Test.startTest();
        viewShareSurveyComponentController controller = new  viewShareSurveyComponentController();
        ViewSurveyController viewSurvey = new  ViewSurveyController(controller);
        Test.stopTest();
        Survey__c sc  = new survey__c(Submit_Response__c ='test');
        insert sc ;
        // Assert to check Survey is created 
        system.assert(sc.id!=null);
        Survey_Question__c su  =new  Survey_Question__c ( OrderNumber__c = 1, Question__c ='test', Survey__c = sc.id);
        insert su;
    }
      
   /*******************************************************************
    Purpose: This method is used to negative testing Initializes the survey page and displays it to user.
    Parameters: N/A 
    Returns: void 
    Throws [Exceptions]: N/A
    ********************************************************************/
    private static Testmethod void init_NegativeTest() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        /*********************************************************************** 
        Verifying the Survey has been created successfully
        Expected Result: Survey id is not null
        Actual Result: Survey id  is not null 
        ***********************************************************************/ 
        system.assert(tu.surveyId != null);
    
        list<Survey_Question__c> lstSurveyQues = new list<Survey_Question__c>();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId); 
        Apexpages.currentPage().getParameters().put('cId',tu.contactId);
        Apexpages.Standardcontroller stc;   
        Test.startTest();
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        //System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null); 
        vsc.submitResults();
        Test.stopTest();
    }
    /*******************************************************************
    Purpose: This method is used to test called when use submits the survey
    Parameters: N/A 
    Returns: void 
    Throws [Exceptions]: N/A
    ********************************************************************/
    private static Testmethod void submitResults_Test() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        /*********************************************************************** 
        Verifying the Survey has been created successfully
        Expected Result: Survey id is not null
        Actual Result: Survey id  is not null 
        ***********************************************************************/ 
        system.assert(tu.surveyId != null);
        
        list<Survey_Question__c> lstSurveyQues = new list<Survey_Question__c>();
        for(Id QuesId : tu.questionIds){
        Survey_Question__c objTemp = new Survey_Question__c(id = QuesId);
        lstSurveyQues.add(objTemp);
        }
        delete lstSurveyQues;
        
        Survey_Question__c q = new Survey_Question__c();
        q.Name = 'Testing Question';
        q.Survey__c = tu.surveyId;
        q.Type__c =  'Single Select--Vertical';
        q.Choices__c = 'one\ntwo\nthree\n';
        q.Question__c = 'Testing Question question';
        q.OrderNumber__c = 50;
        q.Required__c = true;
        insert q;
        
        Apexpages.currentPage().getParameters().put('id',tu.surveyId); 
        Apexpages.currentPage().getParameters().put('cId',tu.contactId);
        Apexpages.Standardcontroller stc;   
        Test.startTest();
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        //System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null); 
        vsc.submitResults();
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method is used to negative testing called when use submits the survey
    Parameters: N/A 
    Returns: void 
    Throws [Exceptions]: N/A
    ********************************************************************/
    private static Testmethod void submitResults_NegativeTest() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        /*********************************************************************** 
        Verifying the Survey has been created successfully
        Expected Result: Survey id is not null
        Actual Result: Survey id  is not null 
        ***********************************************************************/ 
        system.assert(tu.surveyId != null);
        
        list<Survey_Question__c> lstSurveyQues = new list<Survey_Question__c>();
        for(Id QuesId : tu.questionIds){
        Survey_Question__c objTemp = new Survey_Question__c(id = QuesId);
        lstSurveyQues.add(objTemp);
        }
        delete lstSurveyQues;
        
        Survey_Question__c q = new Survey_Question__c();
        q.Name = 'Testing Question';
        q.Survey__c = tu.surveyId;
        q.Type__c =  'Single Select--Vertical';
        q.Choices__c = 'one\ntwo\nthree\n';
        q.Question__c = 'Testing Question question';
        q.OrderNumber__c = 50;
        q.Required__c = false;
        insert q;
        
        Apexpages.currentPage().getParameters().put('id',tu.surveyId); 
        Apexpages.currentPage().getParameters().put('cId',tu.contactId);
        Apexpages.Standardcontroller stc;
        Test.startTest();       
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        //System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null);
        vsc.submitResults();
        Test.stopTest();
    }
    /*******************************************************************
    Purpose: This method is used to test setupQuestionLis method calls other method to setup questions.
    Parameters: N/A 
    Returns: void 
    Throws [Exceptions]: N/A
    ********************************************************************/
    private static Testmethod void setupQuestionList_Test() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        /*********************************************************************** 
        Verifying the Survey has been created successfully
        Expected Result: Survey id is not null
        Actual Result: Survey id  is not null 
        ***********************************************************************/ 
        system.assert(tu.surveyId != null);
        
        list<Survey_Question__c> lstSurveyQues = new list<Survey_Question__c>();
        for(Id QuesId : tu.questionIds){
        Survey_Question__c objTemp = new Survey_Question__c(id = QuesId);
        lstSurveyQues.add(objTemp);
        }
        delete lstSurveyQues;
        
        Survey_Question__c q = new Survey_Question__c();
        q.Name = 'Testing Question';
        q.Survey__c = tu.surveyId;
        q.Type__c =  'Free Text';
        q.Choices__c = 'one\ntwo\nthree\n';
        q.Question__c = 'Testing Question question';
        q.OrderNumber__c = 50;
        q.Required__c = false;
        insert q;
        
        Apexpages.currentPage().getParameters().put('id',tu.surveyId); 
        Apexpages.currentPage().getParameters().put('cId',tu.contactId);
        Apexpages.Standardcontroller stc;  
        Test.startTest();       
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        //System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null);
        vsc.submitResults();
        vsc.setupQuestionList();
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: This method is used to negative testing setupQuestionLis method calls other method to setup questions.
    Parameters: N/A 
    Returns: void 
    Throws [Exceptions]: N/A
    ********************************************************************/
    private static Testmethod void setupQuestionList_NegativeTest() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        /*********************************************************************** 
        Verifying the Survey has been created successfully
        Expected Result: Survey id is not null
        Actual Result: Survey id  is not null 
        ***********************************************************************/ 
        system.assert(tu.surveyId != null);
        
        list<Survey_Question__c> lstSurveyQues = new list<Survey_Question__c>();
        for(Id QuesId : tu.questionIds){
        Survey_Question__c objTemp = new Survey_Question__c(id = QuesId);
        lstSurveyQues.add(objTemp);
        }
        delete lstSurveyQues;
        
        Survey_Question__c q = new Survey_Question__c();
        q.Name = 'Testing Question';
        q.Survey__c = tu.surveyId;
        q.Type__c =  'Free Text';
        q.Choices__c = 'one\ntwo\nthree\n';
        q.Question__c = 'Testing Question question';
        q.OrderNumber__c = 50;
        q.Required__c = true;
        insert q;
        
        Apexpages.currentPage().getParameters().put('id',tu.surveyId); 
        Apexpages.currentPage().getParameters().put('cId',tu.contactId);
        Apexpages.Standardcontroller stc;
        Test.startTest();
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        //System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null);
        vsc.submitResults();
        vsc.setupQuestionList();
        Test.stopTest();
    }
    /*******************************************************************
    Purpose: This method is used to test createSurveyFeedbackItem method to create Survey Feedback Items.
    Parameters: N/A 
    Returns: void 
    Throws [Exceptions]: N/A
    ********************************************************************/
    private static Testmethod void createSurveyFeedbackItem_Test(){
        SurveyTestingUtil tu = new SurveyTestingUtil();
        /*********************************************************************** 
        Verifying the Survey has been created successfully
        Expected Result: Survey id is not null
        Actual Result: Survey id  is not null 
        ***********************************************************************/ 
        system.assert(tu.surveyId != null);
        
        list<Survey_Question__c> lstSurveyQues = new list<Survey_Question__c>();
        for(Id QuesId : tu.questionIds){
        Survey_Question__c objTemp = new Survey_Question__c(id = QuesId);
        lstSurveyQues.add(objTemp);
        }
        delete lstSurveyQues;
        
        Survey_Question__c q = new Survey_Question__c();
        q.Name = 'Testing Question';
        q.Survey__c = tu.surveyId;
        q.Type__c =  'Multi-Select--Vertical';
        q.Choices__c = 'one\ntwo\nthree\n';
        q.Question__c = 'Testing Question question';
        q.OrderNumber__c = 50;
        q.Required__c = true;
        insert q;
        
        Apexpages.currentPage().getParameters().put('id',tu.surveyId); 
        Apexpages.currentPage().getParameters().put('cId',tu.contactId);
        Apexpages.Standardcontroller stc;   
        Test.startTest();
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        //System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null); 
        vsc.submitResults();
        Test.stopTest();
    }
    /*******************************************************************
    Purpose: This method is used to negative testing AddSurveyTaker method called from submitResults() method to create a survey taker record for the survey submitted by user.
    Parameters: N/A 
    Returns: void 
    Throws [Exceptions]: N/A
    ********************************************************************/  
    private static Testmethod void AddSurveyTaker_NegativeTest(){
        SurveyTestingUtil tu = new SurveyTestingUtil();
        /*********************************************************************** 
        Verifying the Survey has been created successfully
        Expected Result: Survey id is not null
        Actual Result: Survey id  is not null 
        ***********************************************************************/ 
        system.assert(tu.surveyId != null);
        
        list<Survey_Question__c> lstSurveyQues = new list<Survey_Question__c>();
        for(Id QuesId : tu.questionIds){
        Survey_Question__c objTemp = new Survey_Question__c(id = QuesId);
        lstSurveyQues.add(objTemp);
        }
        delete lstSurveyQues;
        
        Survey_Question__c q = new Survey_Question__c();
        q.Name = 'Testing Question';
        q.Survey__c = tu.surveyId;
        q.Type__c =  'Multi-Select--Vertical';
        q.Choices__c = 'one\ntwo\nthree\n';
        q.Question__c = 'Testing Question question';
        q.OrderNumber__c = 50;
        q.Required__c = false;
        insert q;
        
        Apexpages.currentPage().getParameters().put('id',tu.surveyId); 
        Apexpages.currentPage().getParameters().put('cId',tu.contactId);
        Apexpages.Standardcontroller stc;   
        Test.startTest();
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        //System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null); 
        vsc.submitResults();
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method is used to test AddSurveyTaker method called from submitResults() method to create a survey taker record for the survey submitted by user.
    Parameters: N/A 
    Returns: void 
    Throws [Exceptions]: N/A
    ********************************************************************/  
    private static Testmethod void AddSurveyTaker_Test() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        /*********************************************************************** 
        Verifying the Survey has been created successfully
        Expected Result: Survey id is not null
        Actual Result: Survey id  is not null 
        ***********************************************************************/ 
        system.assert(tu.surveyId != null);
        
        Case tempCase  = AP01_TestDataUtility.createCase();
        tempCase.Sub_Function__c = 'Accounts Payable';
        tempCase.status = 'Closed';
        tempCase.Close_Reason__c = 'test closed ';
        update tempCase;
        
        Apexpages.currentPage().getParameters().put('caId',tempCase.id);
        SurveyTaker__c tempSurveyTaker = new SurveyTaker__c(id = tu.surveyTakerId);
        tempSurveyTaker.Case__c = tempCase.id;
        update tempSurveyTaker;
        
        list<Survey_Feedback_Item__c> lstSurveyFeedbackItem = new list<Survey_Feedback_Item__c>();
        Survey_Feedback_Item__c objTempServeyFeedBackItem = new Survey_Feedback_Item__c();
        objTempServeyFeedBackItem.Name = 'Accounts Payable';
        objTempServeyFeedBackItem.Email_to_L1__c = 'test@test.com';
        objTempServeyFeedBackItem.Email_to_L2__c = 'test1@test.com';
    
        lstSurveyFeedbackItem.add(objTempServeyFeedBackItem);
        insert lstSurveyFeedbackItem;
        SurveyQuestionResponse__c objSurveyQuestionResponse = [select id,Response__c,Survey_Question__c,Survey_Question_Number__c,SurveyTaker__c  from SurveyQuestionResponse__c limit 1];
        delete objSurveyQuestionResponse;
        
        list<Survey_Question__c> lstSurveyQues = new list<Survey_Question__c>();
        for(Id QuesId : tu.questionIds){
        Survey_Question__c objTemp = new Survey_Question__c(id = QuesId);
        lstSurveyQues.add(objTemp);
        }
        delete lstSurveyQues;
        
        Survey_Question__c q = new Survey_Question__c();
        q.Name = 'Testing Question';
        q.Survey__c = tu.surveyId;
        q.Type__c =  'Single Select--Horizontal';
        q.Choices__c = 'one\ntwo\nthree\n';
        q.Question__c = 'Testing Question question';
        q.OrderNumber__c = 0;
        q.Required__c = false;
        insert q;
        
        list<SurveyQuestionResponse__c> lstSurveyQuestionResponse = new list<SurveyQuestionResponse__c>();
        SurveyQuestionResponse__c r = new SurveyQuestionResponse__c();
        r.Response__c = 'No';
        r.Survey_Question__c = q.id;
        r.SurveyTaker__c = tu.surveyTakerId;
        lstSurveyQuestionResponse.add(r);
        
        Survey_Question__c q1 = new Survey_Question__c();
        q1.Name = 'Testing Question';
        q1.Survey__c = tu.surveyId;
        q1.Type__c =  'Single Select--Horizontal';
        q1.Choices__c = 'one\ntwo\nthree\n';
        q1.Question__c = 'Testing Question question';
        q1.OrderNumber__c = 1;
        q1.Required__c = false;
        insert q1;
        
        SurveyQuestionResponse__c r1 = new SurveyQuestionResponse__c();
        r1.Response__c = '>2';
        r1.Survey_Question__c = q1.id;
        r1.SurveyTaker__c = tu.surveyTakerId;
        lstSurveyQuestionResponse.add(r1);
        
        insert lstSurveyQuestionResponse;
        
        Apexpages.currentPage().getParameters().put('id',tu.surveyId); 
        //Apexpages.currentPage().getParameters().put('cId',tu.contactId);
        Apexpages.Standardcontroller stc;   
        Test.startTest();
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        //System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null);
        vsc.anonymousAnswer = 'testAnonymousAnswer';
        vsc.submitResults();
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method is used to test wrapper class and it's constructor to store survey question details and Fills up the survey question page with default questions.
    Parameters: N/A 
    Returns: N/A  
    Throws [Exceptions]: N/A
    ********************************************************************/
    private static Testmethod void question_Test() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        /*********************************************************************** 
        Verifying the Survey has been created successfully
        Expected Result: Survey id is not null
        Actual Result: Survey id  is not null 
        ***********************************************************************/ 
        system.assert(tu.surveyId != null);
        
        Case tempCase  = AP01_TestDataUtility.createCase();
        tempCase.Sub_Function__c = 'Accounts Payable';
        tempCase.status = 'Closed';
        tempCase.Close_Reason__c = 'test closed ';
        update tempCase;
        
        Apexpages.currentPage().getParameters().put('caId',tempCase.id);
        SurveyTaker__c tempSurveyTaker = new SurveyTaker__c(id = tu.surveyTakerId);
        tempSurveyTaker.Case__c = tempCase.id;
        update tempSurveyTaker;
        
        list<Survey_Feedback_Item__c> lstSurveyFeedbackItem = new list<Survey_Feedback_Item__c>();
        Survey_Feedback_Item__c objTempServeyFeedBackItem = new Survey_Feedback_Item__c();
        objTempServeyFeedBackItem.Name = 'Accounts Payable';
        objTempServeyFeedBackItem.Email_to_L1__c = 'test@test.com';
        objTempServeyFeedBackItem.Email_to_L2__c = 'test1@test.com';
    
        lstSurveyFeedbackItem.add(objTempServeyFeedBackItem);
        insert lstSurveyFeedbackItem;
        SurveyQuestionResponse__c objSurveyQuestionResponse = [select id,Response__c,Survey_Question__c,Survey_Question_Number__c,SurveyTaker__c  from SurveyQuestionResponse__c limit 1];
        delete objSurveyQuestionResponse;
        
        list<Survey_Question__c> lstSurveyQues = new list<Survey_Question__c>();
        for(Id QuesId : tu.questionIds){
        Survey_Question__c objTemp = new Survey_Question__c(id = QuesId);
        lstSurveyQues.add(objTemp);
        }
        delete lstSurveyQues;
        
        Survey_Question__c q = new Survey_Question__c();
        q.Name = 'Testing Question';
        q.Survey__c = tu.surveyId;
        q.Type__c =  'Single Select--Horizontal';
        q.Choices__c = 'one\ntwo\nthree\n';
        q.Question__c = 'Testing Question question';
        q.OrderNumber__c = 0;
        q.Required__c = false;
        insert q;
        
        list<SurveyQuestionResponse__c> lstSurveyQuestionResponse = new list<SurveyQuestionResponse__c>();
        SurveyQuestionResponse__c r = new SurveyQuestionResponse__c();
        r.Response__c = 'No';
        r.Survey_Question__c = q.id;
        r.SurveyTaker__c = tu.surveyTakerId;
        lstSurveyQuestionResponse.add(r);
        
        Survey_Question__c q1 = new Survey_Question__c();
        q1.Name = 'Testing Question';
        q1.Survey__c = tu.surveyId;
        q1.Type__c =  'Single Select--Horizontal';
        q1.Choices__c = 'one\ntwo\nthree\n';
        q1.Question__c = 'Testing Question question';
        q1.OrderNumber__c = 1;
        q1.Required__c = false;
        insert q1;
        
        SurveyQuestionResponse__c r1 = new SurveyQuestionResponse__c();
        r1.Response__c = '>2';
        r1.Survey_Question__c = q1.id;
        r1.SurveyTaker__c = tu.surveyTakerId;
        lstSurveyQuestionResponse.add(r1);
        
        insert lstSurveyQuestionResponse;
        
        Apexpages.currentPage().getParameters().put('id',tu.surveyId); 
        Apexpages.currentPage().getParameters().put('cId',tu.contactId);
        Apexpages.Standardcontroller stc;  
        Test.startTest();       
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        //System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null);
        
        vsc.submitResults();
        
        vsc.allQuestions[0].surveyName = '';
        vsc.allQuestions[0].responses = new List<String>();
        vsc.allQuestions[0].qResultsForChart = '';
        vsc.allQuestions[0].resultsCounts = new List<Integer>();
        vsc.allQuestions[0].noData = false;
        Test.stopTest();
    }
}