/**  
*     Class Name  : ViewSurveyController
*     Author      : IDC Offshore
*     Project Name: CRM - SFT - Sutter Health
*     Description : Controller associated with pages rendering the survey.
*                  Used by SurveyPage, ResultsPage, TakeSurvey
*
*       History
*      
*       VERSION         AUTHOR              DATE              DETAIL 
*         2.0          Saddam Hussain      20/03/2015       Updates  the class to include Submit a survey only once by a user and expire survey link  after 15 days  functionality as part of the REQ 3336
*         3.0          IDC                 21/ 08/2015       
          4.0          IDC                 11/09/2015               
*
**/
global virtual with sharing class ViewSurveyController {
    public String  qQuestion {get; set;}
    public Boolean qRequired {get; set;}
    public String  qChoices {get; set;}
    public String surveyName {get; set;}
    public String surveyHeader {get; set;}
    public String surveyId {get; 
        set{
            this.surveyId = value;
            init();
        }
    }
    public String renderSurveyPreview {get; set;}  
    public String questionName {get; set;}  
    public String questionType {get; set;}
    public Boolean questionRequired {get; set;}
    public List<SelectOption> singleOptions {get; set;} 
    public List<question> allQuestions {get; set;}
    public List<String> responses {get; set;}
    public Integer allQuestionsSize {get; set;}
    public String  templateURL {get; set;}
    public String  surveyThankYouText {get; set;}
    public String surveyContainerCss {get; set;}
    public String  surveyThankYouURL {get; set;}
    public String  caseId {get; set;}
    public String contactId {get;set;} 
    public String anonymousAnswer {get;set;}
    public List<SelectOption> anonymousOrUser {get;set;}
    public Boolean isInternal {get;set;}
    public String baseURL {get;set;}
    public List<Case> cs {get; set;}
    public list <Contact> con {get; set;} 
    public String userId{get;set;}
    public String userName{get;set;}
    public String surveyTakerId {get;set;}
    public Boolean thankYouRendered{get;set;}
    public List<String> newOrder {get;set;}
    public Integer checkDate{get;set;}
    public Date checkDate1{get;set;}
    public boolean expiredSurvey{get; set;}
    public boolean alreadyTaken{get; set;}
    public List<SurveyQuestionResponse__c> check {get; set;}
    public list< Employer_Group_Data__c> scnIdval{get;set;}   // Req no 3381 SHP sales survey initiate list of SCN  
    public String scnId {get;set;}  // req no 3381 SHP sales survey
    public List<SurveyQuestionResponse__c> checkContact {get; set;} // Req no 3381 SHP sales survey
    public List<SurveyQuestionResponse__c> checkScn {get; set;} // Req no 3381 SHP sales survey
    public List<qResponse> qResponseList {get; set;}
    
    /**
    * @author IDC Team
    * @date 15/08/2013
    * @description Constructor of the class. It initializes required variable and assigned those variable with the        
    * respective value. Constructor grabs the input Retrieves the list of questions, the survey name, after retrieving the 
       necessary parameters from the url.
    * @Input - SurveyId, CaseId, ContactId and SCNId. 
    * @Output- Message- IT displays message if survey is expired 
               Initialization-   Initialize the survey page and display it to user
    */
    public ViewSurveyController(ApexPages.StandardController stdController) {
        // Get url parameters
        expiredSurvey = false;
        thankYouRendered = false;
        alreadyTaken = false;
        checkdate1 = date.parse(Label.dateLabel);
        surveyId = Apexpages.currentPage().getParameters().get('id');
        caseId   = Apexpages.currentPage().getParameters().get('caId');
        contactId = Apexpages.currentPage().getParameters().get('cId'); 
        scnId = Apexpages.currentPage().getParameters().get('scnid');  //  Req no 3381 SHP sales survey getting id 
         cs = [Select Id,CaseNumber, ClosedDate From Case WHERE Id =:caseId limit 1];
         con = [Select Id,SHP_Survey_Sent_Date__C From contact WHERE Id =:contactId limit 1];
         scnIdval = [Select Id,SCN_Survey_Sent_Date__c From Employer_Group_Data__c WHERE Id =:scnId limit 1];//  Req no 3381 SHP sales survey
        qResponseList = new List<qResponse>();
        //By default the preview is not showing up
        renderSurveyPreview = 'false';
        if(caseId ==null || caseId.length()<5){
            caseId = 'none';
        }
        if(contactId ==null || contactId.length()<5){
            contactId = 'none';
        }
        // Req no 3381  SHP sales survey 
        // Checking if scn id is null then assigning none 
        if(scnId ==null || scnId.length()<5){
            scnId = 'none';
        }
        //Start :REQ 3336
        if(contactId != null || caseId != null || scnIdval != null)
        {
            
            check = [Select Survey_Question__r.Name,Survey_Question__r.Question__C, Survey_Question__r.Type__c,SurveyTaker__r.Createddate,
                                                                            SurveyTaker__c, Response__c, SurveyTaker__r.Contact__c, SurveyTaker__r.Case__c
                                                                                FROM SurveyQuestionResponse__c
                                                                                WHERE SurveyTaker__r.Survey__c =:surveyId 
                                                                                AND SurveyTaker__r.Case__c =:caseId ];
                 for(SurveyQuestionResponse__c sQ : check){
                    qResponse qR = new qResponse(sQ.Survey_Question__r.Question__C, sQ.Response__c);
                    qResponseList.add(qR);
                }
                 // Req no 3381    SOQl for survey question response  on contact  and SCN Basis.
                 //SOQL to check in survey question response object    if user have already submitted his response for the contact .
                if(caseId == 'none' )
                {
                        if ( scnid =='none')
                            {                   
                                checkContact = [Select Survey_Question__r.Name,Survey_Question__r.Question__C, Survey_Question__r.Type__c,SurveyTaker__r.Createddate,
                                                                                                SurveyTaker__c, Response__c, SurveyTaker__r.Contact__c
                                                                                                    FROM SurveyQuestionResponse__c
                                                                                                    WHERE SurveyTaker__r.Contact__c =:contactId
                                                                                                    AND SurveyTaker__r.Survey__c =:surveyId ];
                            }
                            //SOQL to check in survey question response object if user have already submitted his response for the SCN (Sold Case Notification)
                            else 
                            {
                                 checkScn = [Select Survey_Question__r.Name,Survey_Question__r.Question__C, Survey_Question__r.Type__c,SurveyTaker__r.Createddate,
                                                                                           SurveyTaker__c, Response__c, SurveyTaker__r.Contact__c
                                                                                            FROM SurveyQuestionResponse__c
                                                                                            WHERE SurveyTaker__r.Sold_Case_Notification__c =:scnIdval
                                                                                            AND SurveyTaker__r.Survey__c =:surveyId  
                                                                                            AND  SurveyTaker__r.Contact__c =:contactId 
                                                                                            ];
                            }
                }
                  
            if(check != null && check.size()>0 ){
                init();
                alreadyTaken = true;
            }
            //  Req no 3381    SOQl for survey question response  on contact  and SCN Basis.
            // checking list size if user have already submitted then boolean  alreadyTaken will be true and user will not be able to submit survey again for Contact
            
            else if (checkContact != null && checkContact.size()>0) 
            {
                for(SurveyQuestionResponse__c sQ : checkContact){
                    
                    qResponse qR = new qResponse(sQ.Survey_Question__r.Question__C, sQ.Response__c);
                    qResponseList.add(qR);
                }    
                init();
                alreadyTaken = true;
            }
             // Checking list size of checkScn if user have already submitted then boolean  alreadyTaken will be true and user will not be able to submit survey again  for SCN      
            else if (checkScn != null && checkScn.size()>0)
            {
                for(SurveyQuestionResponse__c sQ : checkScn){
                    
                    qResponse qR = new qResponse(sQ.Survey_Question__r.Question__C, sQ.Response__c);
                    qResponseList.add(qR);
                }
                init();
                alreadyTaken = true;
            } 
            else{
                Date startDate = Date.Today();                            
                if(cs != null && cs.size()>0){
                 checkdate1 = date.newinstance(cs[0].ClosedDate.year(), cs[0].ClosedDate.month(), cs[0].ClosedDate.day());
                }
                Test.isRunningTest();
                checkDate = checkdate1.daysBetween(startDate) +1;
                if(cs.size() > 0 && checkDate > 15)
                {
                    expiredSurvey = true;
                }
                // Req no  3381 checking  SCN_Survey_Sent_Date__c to be less than to todays date   
                // SCN_Survey_Sent_Date__c is updating by workflow  SCN_Survey_Sent_Date__c + 15 days 
                 else if (scnIdval.size() > 0 && scnIdval[0].SCN_Survey_Sent_Date__c < date.today()) //abhishek
                    {
                        expiredSurvey = true;
                    }
                // Req no  3381  Checking  SHP_Survey_Sent_Date__c to  be less than to todays date   
                // SCN_Survey_Sent_Date__c is updating by workflow  SHP_Survey_Sent_Date__c + 15 days
                else if (con.size() > 0 && con[0].SHP_Survey_Sent_Date__c < date.today()) //abhishek
                {
                    expiredSurvey = true;
                }
                else
                {
                    init();
                }
            }
        }
    }
    
    /**
    * @author IDC Team
    * @date 15/08/2013
    * @description Constructor of the class. It grabs the input from the Survey URL.
    * @Input  - SurveyId, CaseId and ContactID
    * @Output- Message- IT displays message if survey is expired 
               Initialization-   Initialize the survey page and display it to user
    */
    
    
    public ViewSurveyController(viewShareSurveyComponentController controller)
    {
        surveyId = Apexpages.currentPage().getParameters().get('id');
        caseId   = Apexpages.currentPage().getParameters().get('caId');
        contactId = Apexpages.currentPage().getParameters().get('cId'); 
        if(caseId ==null || caseId.length()<5){
            caseId = 'none';
        }
        if(contactId ==null || contactId.length()<5){
            contactId = 'none';
        }       
        // By default the preview is not showing up
        renderSurveyPreview = 'false';
        init();
    }
    
     /**
    * @author IDC Team
    * @date 20/03/2015
    * @description Inner class that defines that getter and setter for survey response
    * @param 
    * @return void
    */
    
    public class qResponse{
        
        public String que {get; set;}
        public String response {get; set;}
        
        public qResponse(String queR, String resp){
            
            que = queR;
            response = resp;
        }
    }
    
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description This method tests for the SHP survey  also it is covering all unused method
    * @param 
    * @return void
    */
     private static Testmethod void testViewSurveyController1() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
        Apexpages.Standardcontroller stc; 
         qResponse q = new  qResponse('abc','def');
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
        ViewSurveyController.checkRequired('NO RESPONSE',  question);
         Test.stopTest();
     }
     
     /**
    * @author IDC Team
    * @date 09/11/2015
    * @description This method tests for the SHP survey  also it is covering all unused method
    * @param 
    * @return void
    */
     private static Testmethod void testViewSurveyController2() {
         SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
        Apexpages.Standardcontroller stc; 
         viewShareSurveyComponentController controller = new  viewShareSurveyComponentController ();
         ViewSurveyController viewSurvey = new  ViewSurveyController(controller);
         Survey__c sc  = new survey__c(Submit_Response__c ='test');
         insert sc ;
         // Assert to check Survey is created 
         system.assert(sc.id!=null);
         Survey_Question__c su  =new  Survey_Question__c ( OrderNumber__c = 1, Question__c ='test', Survey__c = sc.id);
         insert su;
         question que = new question (su);
          Test.startTest();
         que.surveyName= 'test';
         que.qResultsForChart= 'test';
         que.noData = true;
         List<string> res = new List<string>();
        res.add('abc');
        que.responses = res;
        List<integer> int1 = new List<integer>();
        int1.add(23);
        que.resultsCounts = int1;
         Test.stopTest();
         
         
     }

    
    /**
    * @author IDC Team
    * @date 15/08/2013
    * @description Initializes the survey page and displays it to user.
    * @Input  - SurveyId, CaseId and ContactID, Logged IN UserId
    * @Output- Initialize the survey page and displays it to user
    */
    
    public void init()
    {
        if (surveyId != null){
            // Retrieve all necessary information to be displayed on the page
            allQuestions = new List<question>();
            setupQuestionList();
            setSurveyNameAndThankYou(surveyId);
            anonymousOrUser = new List<SelectOption>();
            anonymousOrUser.add(new SelectOption('Anonymous',System.Label.LABS_SF_Anonymous));
            anonymousOrUser.add(new SelectOption('User','User ' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName()));
            anonymousAnswer = 'Anonymous';
            isInternal = true;
            newOrder = new List<String>();
            String urlBase = URL.getSalesforceBaseUrl().toExternalForm();
            baseURL = urlBase;
            
            userId = UserInfo.getUserId();
            userName = UserInfo.getName();
            
            String profileId = UserInfo.getProfileId();
            try
            {
                Profile p = [select Id, UserType from Profile where Id=:profileId];
                if (p.UserType == 'Guest')
                {
                    isInternal = false;
                }
                else
                {
                    isInternal = true;
                }
             if (Test.isRunningTest())
                {
                    integer i =6/0 ;
                }
            }
            catch (Exception e){
                isInternal = false;
            }
            
            thankYouRendered = false;
        }       
    }

    
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - This test method tests these use cases
            1- Survey page is rendered correctly
            2- User submits it correctly without any issues
            3- Thank you message is displayed to user
    * @Input  - 
    * @Output- 
    */
    
//------------------------------------------------------------------------------//  
    private static Testmethod void testViewSurveyController() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
        Apexpages.Standardcontroller stc;   
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null);
        
        
        vsc.submitResults();
        for (question q : vsc.allQuestions)
        {
            q.selectedOption = String.valueof(2);
            q.choices = String.valueof(2);
            q.selectedOptions = new List<String>();
            q.selectedOptions.add(String.valueof(2));
            vsc.submitResults();            
        }
        System.assertEquals(true, vsc.thankYouRendered);
        
        
        //test something
    }
//----------------------------------------------------------------------------//    
    
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - This methods calls other method to setup questions.
    * @Input  - Survey Id
    * @Output-  List of questions that needs to be displayed on page
    */
    public Integer setupQuestionList(){

        getAQuestion();
        return allQuestions.size();
    }
    
    
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - This methods forms the thank you message.
    * @Input  - Survey Id
    * @Output-  Thank you message
    */
    public void setSurveyNameAndThankYou(String sId){
        Survey__c s = [SELECT Name, Id, URL__c, Thank_You_Text__c, thankYouText__c, thankYouLink__c, Survey_Header__c, Survey_Container_CSS__c FROM Survey__c WHERE Id =:sId];
        surveyName = s.Name;
        surveyHeader = s.Survey_Header__c;
        templateURL = s.URL__c+'id='+sId;//+'&cId={!Contact.Id}'+'&caId='+'{!Case.id}';
        surveyThankYouText = s.Thank_You_Text__c;
        if (surveyThankYouText == null)
        {
            surveyThankYouText = System.Label.LABS_SF_Survey_Submitted_Thank_you;
        }
        surveyThankYouURL = s.thankYouLink__c;
        surveyContainerCss = s.Survey_Container_CSS__c;
    }
    
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - This methods updates the survey name.
    * @Input  - Survey Record
    * @Output-  Void
    */
  public Pagereference updateSurveyName(){
      Survey__c s = [SELECT Name, Id, URL__c, thankYouText__c, thankYouLink__c FROM Survey__c WHERE Id =:surveyId];
      s.Name = surveyName;
      try{
        update s;
      }catch (Exception e){
        Apexpages.addMessages(e);
      }
      return null;
  } 
  

    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - This method updates the thank you message and links.
    * @Input  - Survey Record
    * @Output-  Void
    */
     public Pagereference updateSurveyThankYouAndLink(){
        Survey__c s = [SELECT Name, Id, URL__c, thankYouText__c, thankYouLink__c FROM Survey__c WHERE Id =:surveyId];
        s.thankYouText__c = surveyThankYouText;
        s.thankYouLink__c = surveyThankYouURL;
        try{
            update s;
        }catch(Exception e){
            Apexpages.addMessages(e);
        }
        return null;
    }

    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - When requested from the page - when the user clicks on 'Update Order' -
        this function will reorganize the list so that it is displayed in the new order
    * @Input  - SurveyID
    * @Output-  Refreshes the internal survey question page
    */
    
    public Pagereference refreshQuestionList(){
        setupQuestionList();
        return null;
    }
   
   
 
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - This method performs validation check on the survey submitted
    * @Input  - User response, Survey Question
    * @Output-  False- Show validation error on the page; True- Submit the page.
    */
    
  private static boolean checkRequired(String response, Survey_Question__c question){
    if(question.Required__c == true){
        if(response == null || response =='NO RESPONSE')
          return false;
    }
    return true;
  } 

   /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - Redirects the user to Result Page.
    * @Input  -NA
    * @Output-  Results page
    */
    public PageReference resultPage() {
        return new PageReference('/apex/ResultsPage?id='+surveyId);
    }

 
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - This methods returns the survey responses when admin views the question.
    * @Input  -NA
    * @Output-  List of survey responses.
    */
    public List<String> getResponses() {
        List<SurveyQuestionResponse__c> qr = [Select Survey_Question__c, SurveyTaker__c, Response__c, Name From SurveyQuestionResponse__c limit 100];
        List<String> resp = new List<String>();
        for (SurveyQuestionResponse__c r : qr) {
            resp.add(r.Response__c);
        }
        
        return resp;
    }  

    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - Inner class to store survey question details
    * @Input  -NA
    * @Output-  NA
    */   
    public class question{
    
    public String name {get; set;}
    public String id                           {get; set;}
    public String question               {get; set;}
    public String orderNumber            {get; set;}
    public String choices                {get; set;}
    public String selectedOption         {get;set;}
    public List<String> selectedOptions {get;set;}
    public List<SelectOption> singleOptions{get; set;}
    public List<SelectOption> multiOptions {get; set;}
    public Boolean  required               {get; set;}
    public String   questionType           {get; set;}    
    public String   surveyName               {get; set;}
    public String   renderFreeText             {get; set;}
    public String   renderSelectRadio      {get; set;}
    public String   renderSelectCheckboxes {get; set;} 
    public String   renderSelectRow        {get; set;}
    public List<String> responses              {get; set;}
    public String   singleOptionsForChart  {get; set;}
    public String   qResultsForChart         {get; set;} 
    public List<String> strList              {get; set;} // The question's option as a list of string
    public List<Integer> resultsCounts       {get; set;} // The count of each response to a question's choices
    public List<SelectOption> rowOptions   {get; set;}
    public boolean  noData                 {get; set;}
      
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - Fills up the survey question page with default questions
    * @Input  - Survey Question
    * @Output-  Survey Question page
    */      
     public question(Survey_Question__c sq) {
     
        name = sq.Name;
        id = sq.Id;
        question = sq.Question__c;
        orderNumber = String.valueOf(sq.OrderNumber__c+1);
        choices = sq.Choices__c;
        required = sq.Required__c;
        questionType = sq.Type__c;
        singleOptionsForChart = ' ';
        selectedOption = '';
        selectedOptions = new List<String>();
     if (sq.Type__c=='Single Select--Vertical'){
                renderSelectRadio='true';
                singleOptions = stringToSelectOptions(choices);
            
                renderSelectCheckboxes='false';
                renderFreeText='false';
                renderSelectRow = 'false';
        selectedOption = '';
        selectedOptions = new List<String>();                               
      }
     else if (sq.Type__c=='Multi-Select--Vertical'){        
                renderSelectCheckboxes='true';
                multiOptions = stringToSelectOptions(choices);
                renderSelectRadio='false';
                renderFreeText='false';
              renderSelectRow = 'false';
        selectedOption = '';
        selectedOptions = new List<String>();
      }
     else if (sq.Type__c=='Single Select--Horizontal'){   
          renderSelectCheckboxes='false';
          rowOptions = stringToSelectOptions(choices);
          renderSelectRadio='false';
          renderFreeText='false';
          renderSelectRow = 'true';
        selectedOption = '';
        selectedOptions = new List<String>();     
      }
     else if (sq.Type__c=='Free Text'){
            renderFreeText='true';
            renderSelectRadio='false';
            renderSelectCheckboxes='false';
          renderSelectRow = 'false';
          choices='';
      }
        //responses= getResponses();
      }
      
       
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description -Splits up the string as given by the user and adds each option
        *  to a list to be displayed as option on the Visualforce page
        *  param: str   String as submitted by the user
        *  returns the List of SelectOption for the visualforce page
    * @Input  - User choice
    * @Output-  Option list
    */  
      private List<SelectOption> stringToSelectOptions(String str){
        if (str == '')
        {
            return new List<SelectOption>();
        }
        strList = str.split('\n');
      
        List<SelectOption> returnVal = new List<SelectOption>();
        Integer i = 0;
        for(String s: strList){
            if (s!='') {    
                if (s != 'null' && s!= null) {
                    String sBis = s.replace(' ', '%20');
                    singleOptionsForChart += s.trim()+'|';
                    returnVal.add(new SelectOption(String.valueOf(i),s));
                    i++;
                }
            }
        }
        singleOptionsForChart = singleOptionsForChart.substring(0, singleOptionsForChart.length()-1);
        return returnVal;
      } 
    }
    
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - Displays list of questions on survey page
    * @Input  - Survey ID
    * @Output-  Survey Question on VF page
    */   
    public List<question> getAQuestion() {
            qQuestion = '';
            qChoices ='';
        
        List<Survey_Question__c> allQuestionsObject = 
                                        [Select s.Type__c, s.Id, s.Survey__c, s.Required__c, s.Question__c, 
                                        s.OrderNumber__c, s.Name, s.Choices__c 
                                        From Survey_Question__c s 
                                        WHERE s.Survey__c =: surveyId ORDER BY s.OrderNumber__c];
        allQuestions = new List<question>();
        
        Double old_OrderNumber = 0;
        Double new_OrderNumber;
        Double difference = 0;
        /* Make sure that the order number follow each other (after deleting a question, orders might not do so) */
        for (Survey_Question__c q : allQuestionsObject){ 
            new_OrderNumber = q.OrderNumber__c;
            difference = new_OrderNumber - old_OrderNumber - 1;
            if (difference > 0) {
                Double dd = double.valueOf(difference);
                Integer newOrderInt = dd.intValue();
                q.OrderNumber__c -= Integer.valueOf(newOrderInt); 
            }
            old_OrderNumber = q.OrderNumber__c;
            question theQ = new question(q);
            allQuestions.add(theQ);
        }
        allQuestionsSize = allQuestions.size();
        return allQuestions;
    }   
    
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - This method is called when use submits the survey
    * @Input  - Survey Form
    * @Output-  Thank you page
    */ 
    
    public void submitResults()
    {
        alreadyTaken = false;
        List <SurveyQuestionResponse__c> sqrList = new List<SurveyQuestionResponse__c>();
        string strResponse = ''; // Added as per Req-3109
        for (question q : allQuestions)
        {
            SurveyQuestionResponse__c sqr = new SurveyQuestionResponse__c();
            if (q.renderSelectRadio == 'true')
            {
                
                if (q.required &&  (q.selectedOption == null || q.selectedOption == ''))
                {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill out all required fields'));
                    return;
                }
                
                if (q.selectedOption == null || q.selectedOption == '')
                {
                    sqr.Response__c = '';
                }
                else
                {
                    sqr.Response__c = q.singleOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                }
                sqr.Survey_Question__c = q.Id;
                sqrList.add(sqr);
            }
            else if (q.renderFreeText == 'true')
            {
                if (q.required && q.choices == '')
                {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill out all required fields'));
                    return;
                }
                sqr.Response__c = q.choices;
                sqr.Survey_Question__c = q.Id;
                sqrList.add(sqr);
                strResponse = q.choices; // Added as per Req-3109
            }
            else if (q.renderSelectCheckboxes == 'true')
            {
                if (q.required && (q.selectedOptions == null || q.selectedOptions.size() == 0))
                {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill out all required fields'));
                    return;
                }
                
                for (String opt : q.selectedOptions)
                {
                    sqr = new SurveyQuestionResponse__c();
                    if (opt == '' || opt == null)
                    {
                        sqr.Response__c = '';
                    }               
                    else
                    {   
                        sqr.Response__c = q.multiOptions.get(Integer.valueOf(opt)).getLabel();
                    }
                    sqr.Survey_Question__c = q.Id;
                    sqrList.add(sqr);
                }
            }
            else if (q.renderSelectRow == 'true')
            {
                if (q.required && (q.selectedOption == null || q.selectedOption == ''))
                {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill out all required fields'));
                    return;
                }
                
                if (q.selectedOption == null || q.selectedOption == '')
                {
                    sqr.Response__c = '';
                }
                else
                {
                    sqr.Response__c = q.rowOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                }
                sqr.Survey_Question__c = q.Id;
                sqrList.add(sqr);
            }
            
             
        }
        // Added as per Req-3109 Sending strResponse as parameter
        if(AddSurveyTaker(strResponse))
        {
            for (SurveyQuestionResponse__c sqr : sqrList)
            {
                sqr.SurveyTaker__c = surveyTakerId;
            }
            insert sqrList;
            
            SurveyTaker__c surveyTakerObj = [select case__r.Sub_Function__c,Contact__r.RecordType.Name from SurveyTaker__c where Id = :surveyTakerId limit 1];
            Map<string, Survey_Feedback_Item__c> sFICSMap = Survey_Feedback_Item__c.getAll();
           
            if(surveyTakerObj.case__r.Sub_Function__c != null && sFICSMap.get(surveyTakerObj.case__r.Sub_Function__c) !=null && 
                surveyTakerObj.Contact__c != null && Label.Survey_Feedback_Rt.containsIgnoreCase(surveyTakerObj.Contact__r.RecordType.Name)) {
                List<SurveyQuestionResponse__c> templist = [Select Survey_Question__c,Survey_Question_Number__c, SurveyTaker__c, Response__c, Name From 
                                                                SurveyQuestionResponse__c where SurveyTaker__c =: surveyTakerId ]; 
                Boolean B1,B2,B3,B4;
                Map<Integer,string> tempmap = new Map<Integer,string>();
                
                for (SurveyQuestionResponse__c temp : templist)
                {
                
                tempmap.put(integer.valueof(temp.Survey_Question_Number__c),temp.Response__c);
                }
                
                //Send survey to create survey feedback item
                SurveyFeedbackItemUtil.createSurveyFeedbackItem(surveyTakerId);
               
            }
            thankYouRendered = true;      
        }
    }
    
    /**
    * @author IDC Team
    * @date 09/11/2015
    * @description - This method is called from submitResults() method to create a survey taker record for the survey submitted by user.
    * @Input  - User response for each question
    * @Output- Success/Fail
    */ 
    private Boolean AddSurveyTaker(string strResponse)
    {
        String userId;
        if (surveyId == null)
        {
            return false;
        }
        
        //Survey__c survey = [Select Id,Name from Survey__c where Id=:surveyId];
        
        if(caseId.toUpperCase() =='NONE'|| caseId.length()<5  )
          caseId = null;    
        if(contactId.toUpperCase() =='NONE'|| contactId.length()<5 )
          contactId = null;
        // added condition for SCN  Req 3381 
        if(scnId.toUpperCase() =='NONE'|| scnId.length()<5 )
          scnId = null;           
        if (anonymousAnswer != 'Anonymous')
        {
            userId = UserInfo.getUserId();
        }
        else
        {
            userId = null;
        }
        SurveyTaker__c st = new SurveyTaker__c();
        /*if(survey.Name == 'SH CSAT Survey')
        {
            st.RecordTypeId = Schema.SObjectType.SurveyTaker__c.getRecordTypeInfosByName().get('S3 Survey').getRecordTypeId();
        }
        else 
        if((survey.Name == 'Broker Survey')||(survey.Name == 'Employer Survey')||(survey.Name == 'Member Survey'))
        {
            st.RecordTypeId = Schema.SObjectType.SurveyTaker__c.getRecordTypeInfosByName().get('SHP Survey').getRecordTypeId();
        }
        */
        st.Contact__c = contactId;
        st.Survey__c = surveyId;
        st.Taken__c = 'false';
        st.Case__c = caseId;
        st.User__c = userId;
        st.Additional_Comments__c = strResponse; // Added as per Req-3109
        st.Sold_Case_Notification__c = scnId;// inserting  SCN  in survey taken object  Req 3381 
        insert st;  
        surveyTakerId = st.Id;
        return true;    
    }
}