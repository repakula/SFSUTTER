/*
    This class is used to cover the SH_HomePageHeadlinerTriggerHandler class
    and SH_HomePageHeadlinerTrigger trigger
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Alok verma             25/09/2015                   1.0
    ==========================================================  
*/
@isTest
private class SH_HomePageHeadlinerTriggerHandlerTest  {

    static testmethod void ValidateHomePageHeadlinerTriggerHandlerInsert(){

        SH_CommonTest.CreateTriggerSetting('SH_HomePageHeadlinerTrigger',1 );
    
        try
        {
            SH_Home_Page_Headliner__c  objHPC = SH_CommonTest.CreateHomePageHeadliner('testtitle', 'testDesc', 1, 'other', true, true, '', 'www.test.com');
            SH_Home_Page_Headliner__c  objHPC2 = SH_CommonTest.CreateHomePageHeadliner('testtitle1', 'testDesc2', 1, 'other', true, true, '', 'www.test.com');
        }
        catch (exception e)
        {

        }
    }
    static testmethod void ValidateHomePageHeadlinerTriggerHandlerUpdate(){

        SH_CommonTest.CreateTriggerSetting('SH_HomePageHeadlinerTrigger',1 );
        SH_Home_Page_Headliner__c  objHPC, objHPC2, objHPC3;
        try
        {
            objHPC = SH_CommonTest.CreateHomePageHeadliner('testtitle', 'testDesc', 1, 'other', true, true, '', 'www.test.com');
            objHPC2 = SH_CommonTest.CreateHomePageHeadliner('testtitle1', 'testDesc2', 1, 'other', false, false, '', 'www.test.com');
            objHPC3 = SH_CommonTest.CreateHomePageHeadliner('testtitle1', 'testDesc2', 1, 'other', false, false, '', 'www.test.com');
        }
        catch (exception e){ }
        
        try {
            objHPC.SH_Is_Publish__c = false;
            objHPC.SH_Is_Preview__c = false;
        
            objHPC2.SH_Is_Publish__c = true;
            objHPC2.SH_Is_Preview__c = true;
            
            objHPC3.SH_Is_Publish__c = true;
            objHPC3.SH_Is_Preview__c = true;
        
            list<SH_Home_Page_Headliner__c > lstHomePageHeadliner = new list<SH_Home_Page_Headliner__c >();
            lstHomePageHeadliner.add(objHPC);
            lstHomePageHeadliner.add(objHPC2);
            lstHomePageHeadliner.add(objHPC3);
            Database.Update(lstHomePageHeadliner, false);
        }
        catch(exception e) {}
    }
    
    static testmethod void validateAndSetArticleToolIdTest1(){
        SH_CommonTest.CreateTriggerSetting('SH_HomePageHeadlinerTrigger',1 );
        SH_Home_Page_Headliner__c  objHPC, objHPC2, objHPC3;
        objHPC3 = SH_CommonTest.CreateHomePageHeadliner('testtitle1', 'testDesc2', 1, 'other', false, false, '', 'www.test.com');
        //for assigning value in wrong field SH_Article_Link__c
        try {
            objHPC3.SH_Article_Link__c = 'test';
            update objHPC3;
        }
        catch(exception e) {}
        
        //for content type blank
        try {
            objHPC = SH_CommonTest.CreateHomePageHeadliner('testtitle', 'testDesc', 1, null, false, false, '', 'www.test.com');
        }
        catch  (exception e){ }
        //for SH_Article_Tool_Id__c blank if content type is Article/Tool
        try{
            objHPC2 = SH_CommonTest.CreateHomePageHeadliner('testtitle1', 'testDesc2', 1, 'Article', false, false, null, 'www.test.com');
        }
        catch(exception e){}
        
        //for invalid ID (not a salesforce ID)
        try{
            objHPC2 = SH_CommonTest.CreateHomePageHeadliner('testtitle1', 'testDesc2', 1, 'Article', false, false, 'kA1234567891234', 'www.test.com');
        }
        catch(exception e){}
    }
    
    static testmethod void validateAndSetArticleToolIdTest2(){
        SH_CommonTest.CreateTriggerSetting('SH_HomePageHeadlinerTrigger',1 );
        Contact_Script__kav objArticle = SH_CommonTest.CreateArticleData('testArticel', 'testArticle');
        Tool__kav  objTool = SH_CommonTest.CreateToolData('testTool', 'testTool');
        Contact_Script__kav  objDraftArticle = SH_CommonTest.CreateDraftArticle('testDraftArticle', 'testDraftArticle');
        Contact_Script__kav  objArticle1 = SH_CommonTest.CreateArticleData('testArticle1', 'testArticle1');
        
        SH_Home_Page_Headliner__c  objHPC, objHPC2, objHPC3, objHPC4, objHPC5;
        
        objHPC = SH_CommonTest.CreateHomePageHeadliner('testtitle1', 'testDesc2', 1, 'Article', false, false, string.valueOf(objArticle.KnowledgeArticleId) .substring(0,15), 'www.test.com');
        objHPC3 = SH_CommonTest.CreateHomePageHeadliner('testtitle1', 'testDesc2', 1, 'Tool', false, false, string.valueOf(objTool.KnowledgeArticleId).substring(0,15), 'www.test.com');
        objHPC2 = SH_CommonTest.CreateHomePageHeadliner('testtitle1', 'testDesc2', 1, 'Article', false, false, string.valueOf(objDraftArticle.KnowledgeArticleId).substring(0,15), 'www.test.com');
        
        try{
            objHPC4 = SH_CommonTest.CreateHomePageHeadliner('testtitle1', 'testDesc2', 1, 'Article', false, false, string.valueOf(objTool.KnowledgeArticleId).substring(0,15), 'www.test.com');
        }
        catch(exception e){}
        try{
            objHPC4 = SH_CommonTest.CreateHomePageHeadliner('testtitle1', 'testDesc2', 1, 'Article', false, false, string.valueOf(objArticle1.KnowledgeArticleId).substring(0,15), 'www.test.com');
        }
        catch(exception e){}
        
    }
}