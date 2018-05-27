@isTest
private class SurveyTest {
  
 private static Testmethod void testUpdateSurveyName() {
 
      SurveyTestingUtil tu = new SurveyTestingUtil();
      PageReference pageRef = Page.takeSurvey;
      Test.setCurrentPageReference(pageRef); 
      System.currentPageReference().getParameters().put('id', tu.surveyId);
      
      ///Apexpages.Standardcontroller stc; 
      
      List<SurveyTaker__c>  st = new List<SurveyTaker__c>();
      
      insert st;
      
      for(SurveyTaker__c s:st){
      
      ApexPages.StandardController stc = new ApexPages.standardController(s);
      
      ViewSurveyController vsc = new ViewSurveyController(stc);
      vsc.surveyName = 'new name';
      vsc.submitResults();
      
       
      system.assert(vsc.updateSurveyName() == null);
      }
  }

    private static Testmethod void testupdateSurveyThankYouAndLink() {
        try{
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
        Apexpages.Standardcontroller stc; 
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.surveyThankYouText = 'new stuff';
        vsc.surveyThankYouURL = 'more new stff';
        List<SurveyQuestionResponse__c>  sqr = new List<SurveyQuestionResponse__c>();
        
        system.assert(vsc.updateSurveyThankYouAndLink()==null);
        }catch(Exception ex) {}
    }
    
    private static Testmethod void testViewSurveyController() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
        Apexpages.Standardcontroller stc;   
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null);
        //vsc.qResponse vsc1 = new vsc.qResponse(stc);
        
        vsc.submitResults();
        vsc.updateSurveyName();
        vsc.refreshQuestionList();
        vsc.resultPage();
        
       
        
    }
    
    }