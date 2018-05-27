/**  
*     Class Name: VFC01_CustomConsole_ArticleTest
*     Author: Offshore IDC
*     Date: 14-Dec-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description: Test Class for VFC01_CustomConsole_ArticleTest Class. Checks functionality of REQ-3145 & REQ-3146
*     
*     History
*     VERSION    AUTHOR         DATE           DETAIL     Description
*     1          Offshore IDC   14-Dec-2015   Test Class covers the scenario of Req-3145 & REQ-3146 - Articles of different type will be search using different parameters like Function & Sub-function.   
*     --------  
**/
@isTest
private class VFC01_CustomConsole_ArticleTest {
    
    /*******************************************************************
    Purpose: Creates test knowledge articles of Type "FAQ_KAV".
    Parameters: [NA]
    Returns: [Case]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    static List<FAQ__kav> createFAQTypeArticles() {
        List<FAQ__kav> testFQArticleLst = new List<FAQ__kav>();
        for(Integer i=0;i<10;i++) {
            FAQ__kav testFaq = new FAQ__kav();
            testFaq.Title = 'Human Test FAQ'+i;
            testFaq.Summary = 'Human KB Summary'+i;
            testFaq.URLName = 'FAQ-TestArticle'+i;
            testFaq.Functional_Area__c = 'Human Resource';
            testFaq.Sub_Function__c = 'New Joinee'; 
            testFQArticleLst.add(testFaq); 
        }
        insert testFQArticleLst;
        return testFQArticleLst;
    }
    
    /*******************************************************************
    Purpose: Publish the Articles. Covers the Article Search with Parameters like Article Type, Function & Sub-Function only.
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testFAQArticleWithFunctionAndSubFunction() {
        try {
            List<FAQ__kav> testFQArticleLst = new List<FAQ__kav>();
            for(Integer i=0;i<10;i++) {
                FAQ__kav testFaq = new FAQ__kav();
                testFaq.Title = 'Test FAQ'+i;
                testFaq.Summary = 'KB Summary'+i;
                testFaq.URLName = 'FAQ-TestArticle'+i;
                testFaq.Functional_Area__c = 'Human Resource';
                testFaq.Sub_Function__c = 'New Joinee'; 
                testFQArticleLst.add(testFaq);
            }
            insert testFQArticleLst; 
            set<Id> setId = new set<Id>();
            for(FAQ__kav testFaq : testFQArticleLst) {
                setId.add(testFaq.id);
            }
            // Get the KnowledgeArticleId
            map<Id,FAQ__kav> mapFAQId = new map<Id,FAQ__kav>([Select KnowledgeArticleId from FAQ__kav where ID IN :setId]);
            // Publish
            for(Id idObj: setId) {
                KbManagement.PublishingService.publishArticle(mapFAQId.get(idObj).KnowledgeArticleId, true);
            }
            VFC01_CustomConsole vfCnsObj = new VFC01_CustomConsole();
            vfCnsObj.getarticleWrLst();
            vfCnsObj.getNextRequiredOffSet();
            vfCnsObj.nextOffSet();
            vfCnsObj.getPrevRequiredOffSet();
            vfCnsObj.previousOffSet();
            // Set Article Type as "FAQ__KAV"
            System.currentPageReference().getParameters().put('articleType','FAQ__kav');
            vfCnsObj.getarticleWrLst();
            vfCnsObj.getNextRequiredOffSet();
            vfCnsObj.nextOffSet();
            vfCnsObj.getPrevRequiredOffSet();
            vfCnsObj.previousOffSet();
            System.currentPageReference().getParameters().put('articleType','');
            System.currentPageReference().getParameters().put('hdnfunctionalFilter','Human Resource');
            vfCnsObj.getarticleWrLst();
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','New Joinee');
            vfCnsObj.getarticleWrLst();
            System.currentPageReference().getParameters().put('articleType','FAQ__kav');
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','');
            vfCnsObj.getarticleWrLst();
            // Set Sub Functional Area Parameter as New Joinee
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','New Joinee');
            vfCnsObj.getarticleWrLst();
            system.assert(vfCnsObj.articleWrLst.size()>0);
        } catch(Exception ex) {}
    }
    
    /*******************************************************************
    Purpose: Publish the Articles. Covers the Article Search with Parameters like Search String, Article Type, Function & Sub-Function only.
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testFAQArticleWithSearchStringAndFunctionAndSubFunction() {
        try {
            List<FAQ__kav> testFQArticleLst = new List<FAQ__kav>();
            for(Integer i=0;i<10;i++) {
                FAQ__kav testFaq = new FAQ__kav();
                testFaq.Title = 'Human FAQ'+i;
                testFaq.Summary = 'Human Summary'+i;
                testFaq.URLName = 'FAQ-TestArticle'+i;
                testFaq.Functional_Area__c = 'Human Resource';
                testFaq.Sub_Function__c = 'New Joinee';
                testFQArticleLst.add(testFaq);
            }
            insert testFQArticleLst;
            set<Id> setId = new set<Id>();
            for(FAQ__kav testFaq : testFQArticleLst) {
                setId.add(testFaq.id);
            }
            
            // Get the KnowledgeArticleId
            map<Id,FAQ__kav> mapFAQId = new map<Id,FAQ__kav>([Select KnowledgeArticleId from FAQ__kav where ID IN :setId]);
            //system.assertEquals(testFaq[0].KnowledgeArticleId,null);
            // Publish
            for(Id idObj: setId) {
                KbManagement.PublishingService.publishArticle(mapFAQId.get(idObj).KnowledgeArticleId, true);
            }
            
            VFC01_CustomConsole vfCnsObj = new VFC01_CustomConsole();
            System.currentPageReference().getParameters().put('theSearchstring','Human Resource');
            vfCnsObj.getarticleWrLst();
            //system.assert(vfCnsObj.articleWrLst == NULL);
            vfCnsObj.getNextRequiredOffSet();
            vfCnsObj.nextOffSet();
            vfCnsObj.getPrevRequiredOffSet();
            vfCnsObj.previousOffSet();
            System.currentPageReference().getParameters().put('articleType','FAQ__kav');
            vfCnsObj.getarticleWrLst();
            vfCnsObj.getNextRequiredOffSet();
            vfCnsObj.nextOffSet();
            vfCnsObj.getPrevRequiredOffSet();
            vfCnsObj.previousOffSet();
            System.currentPageReference().getParameters().put('articleType','');
            System.currentPageReference().getParameters().put('hdnfunctionalFilter','Human Resource');
            Test.startTest();
            vfCnsObj.getarticleWrLst();
            Test.stopTest();
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','New Joinee');
            vfCnsObj.getarticleWrLst();
            System.currentPageReference().getParameters().put('articleType','FAQ__kav');
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','');
            vfCnsObj.getarticleWrLst();
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','New Joinee');
            vfCnsObj.getarticleWrLst();
            
            system.assert(vfCnsObj.adhocType=='--None--');
        } catch(Exception ex) {}
    }
    
    /*******************************************************************
    Purpose: Publish the Articles. Covers the Article Search with Parameters like Data Category, Article Type, Function & Sub-Function only.
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testFAQArticleWithDataCategory() {
        try {
            List<FAQ__kav> testFQArticleLst = new List<FAQ__kav>();
            for(Integer i=0;i<10;i++) {
                FAQ__kav testFaq = new FAQ__kav();
                testFaq.Title = 'Human FAQ'+i;
                testFaq.Summary = 'Human Summary'+i;
                testFaq.URLName = 'FAQ-TestArticle'+i;
                testFaq.Functional_Area__c = 'Human Resource';
                testFaq.Sub_Function__c = 'New Joinee';
                testFQArticleLst.add(testFaq);
            }
            insert testFQArticleLst;
            set<Id> setId = new set<Id>();
            List<FAQ__DataCategorySelection> faqDataCategoryLst = new List<FAQ__DataCategorySelection>();
            for(FAQ__kav testFaq : testFQArticleLst) {
                FAQ__DataCategorySelection faqDataCatObj = new FAQ__DataCategorySelection();
                faqDataCatObj.parentId = testFaq.Id;
                faqDataCatObj.DataCategoryGroupName = 'Region_Affiliate';
                faqDataCatObj.DataCategoryName = 'CVR_All';
                faqDataCategoryLst.add(faqDataCatObj);
                setId.add(testFaq.id);
            }
            insert faqDataCategoryLst;
            // Get the KnowledgeArticleId
            map<Id,FAQ__kav> mapFAQId = new map<Id,FAQ__kav>([Select KnowledgeArticleId from FAQ__kav where ID IN :setId]);
            // Publish
            for(Id idObj: setId) {
                KbManagement.PublishingService.publishArticle(mapFAQId.get(idObj).KnowledgeArticleId, true);
            }
            
            VFC01_CustomConsole vfCnsObj = new VFC01_CustomConsole();
            // Set Data Category parameter as "CVR_ALL"
            System.currentPageReference().getParameters().put('categoryType_Region_Affiliate','CVR_All');
            vfCnsObj.getarticleWrLst();
            vfCnsObj.getNextRequiredOffSet();
            vfCnsObj.nextOffSet();
            vfCnsObj.getPrevRequiredOffSet();
            vfCnsObj.previousOffSet();
            // Set Article Type as "FAQ__KAV"
            System.currentPageReference().getParameters().put('articleType','FAQ__kav');
            vfCnsObj.getarticleWrLst();
            vfCnsObj.getNextRequiredOffSet();
            vfCnsObj.nextOffSet();
            vfCnsObj.getPrevRequiredOffSet();
            vfCnsObj.previousOffSet();
            System.currentPageReference().getParameters().put('articleType','');
            System.currentPageReference().getParameters().put('hdnfunctionalFilter','Human Resource');
            Test.startTest();
            vfCnsObj.getarticleWrLst();
            Test.stopTest();
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','New Joinee');
            vfCnsObj.getarticleWrLst();
            System.currentPageReference().getParameters().put('articleType','FAQ__kav');
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','');
            vfCnsObj.getarticleWrLst();
            // Set Sub Functional Area Parameter as New Joinee
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','New Joinee');
            vfCnsObj.getarticleWrLst();
            system.assert(vfCnsObj.articleWrLst.size()>0);
        } catch(Exception ex) {}
    }
    
    /*******************************************************************
    Purpose: Publish the Articles. Covers the Article Search with Parameters like Search String,Data Category, Article Type, Function & Sub-Function only.
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testFAQArticleWithAllPosibleParameters() {
        try {
            List<FAQ__kav> testFQArticleLst = new List<FAQ__kav>();
            for(Integer i=0;i<10;i++) {
                FAQ__kav testFaq = new FAQ__kav();
                testFaq.Title = 'Human FAQ'+i;
                testFaq.Summary = 'Human Summary'+i;
                testFaq.URLName = 'FAQ-TestArticle'+i;
                testFaq.Functional_Area__c = 'Human Resource';
                testFaq.Sub_Function__c = 'New Joinee';
                testFQArticleLst.add(testFaq);
            }
            insert testFQArticleLst;
            set<Id> setId = new set<Id>();
            List<FAQ__DataCategorySelection> faqDataCategoryLst = new List<FAQ__DataCategorySelection>();
            for(FAQ__kav testFaq : testFQArticleLst) {
                FAQ__DataCategorySelection faqDataCatObj = new FAQ__DataCategorySelection();
                faqDataCatObj.parentId = testFaq.Id;
                faqDataCatObj.DataCategoryGroupName = 'Region_Affiliate';
                faqDataCatObj.DataCategoryName = 'CVR_All';
                faqDataCategoryLst.add(faqDataCatObj);
                setId.add(testFaq.id);
            }
            
            insert faqDataCategoryLst;
            
            // Get the KnowledgeArticleId
            map<Id,FAQ__kav> mapFAQId = new map<Id,FAQ__kav>([Select KnowledgeArticleId from FAQ__kav where ID IN :setId]);
            //system.assertEquals(testFaq[0].KnowledgeArticleId,null);
            // Publish
            for(Id idObj: setId) {
                KbManagement.PublishingService.publishArticle(mapFAQId.get(idObj).KnowledgeArticleId, true);
            }
            
            VFC01_CustomConsole vfCnsObj = new VFC01_CustomConsole();
            System.currentPageReference().getParameters().put('theSearchstring','Human Resource');
            system.assert(vfCnsObj.articleWrLst == NULL);
            System.currentPageReference().getParameters().put('categoryType_Region_Affiliate','CVR_All');
            vfCnsObj.getarticleWrLst();
            vfCnsObj.getNextRequiredOffSet();
            vfCnsObj.nextOffSet();
            vfCnsObj.getPrevRequiredOffSet();
            vfCnsObj.previousOffSet();
            System.currentPageReference().getParameters().put('articleType','FAQ__kav');
            vfCnsObj.getarticleWrLst();
            vfCnsObj.getNextRequiredOffSet();
            vfCnsObj.nextOffSet();
            vfCnsObj.getPrevRequiredOffSet();
            vfCnsObj.previousOffSet();
            System.currentPageReference().getParameters().put('articleType','');
            System.currentPageReference().getParameters().put('hdnfunctionalFilter','Human Resource');
            Test.startTest();
            vfCnsObj.getarticleWrLst();
            Test.stopTest();
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','New Joinee');
            vfCnsObj.getarticleWrLst();
            System.currentPageReference().getParameters().put('articleType','FAQ__kav');
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','');
            vfCnsObj.getarticleWrLst();
            System.currentPageReference().getParameters().put('hdnSubfunctionalFilter','New Joinee');
            vfCnsObj.getarticleWrLst();
            vfCnsObj.refreshSearchResult();
            vfCnsObj.getPrevRequired();
            vfCnsObj.getNextRequired();
            vfCnsObj.getCurrentPageNumber();
            vfCnsObj.next();
            vfCnsObj.previous();
        } catch(Exception ex) {}
    }
    
    /*******************************************************************
    Purpose: Test Negative Scenario With Article Type & Data Category as NULL
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testFAQArticleWithNULLValues() {
        try {
            List<FAQ__kav> testFQArticleLst = createFAQTypeArticles();   
            set<Id> setId = new set<Id>();
            List<FAQ__DataCategorySelection> faqDataCategoryLst = new List<FAQ__DataCategorySelection>();
            for(FAQ__kav testFaq : testFQArticleLst) {
                FAQ__DataCategorySelection faqDataCatObj = new FAQ__DataCategorySelection();
                faqDataCatObj.parentId = testFaq.Id;
                faqDataCatObj.DataCategoryGroupName = 'Region_Affiliate';
                faqDataCatObj.DataCategoryName = 'CVR_All';
                faqDataCategoryLst.add(faqDataCatObj);
                setId.add(testFaq.id);
            }
            insert faqDataCategoryLst;
            // Get the KnowledgeArticleId
            map<Id,FAQ__kav> mapFAQId = new map<Id,FAQ__kav>([Select KnowledgeArticleId from FAQ__kav where ID IN :setId]);
            // Publish
            for(Id idObj: setId) {
                KbManagement.PublishingService.publishArticle(mapFAQId.get(idObj).KnowledgeArticleId, true);
            }
            VFC01_CustomConsole vfCnsObj = new VFC01_CustomConsole();
            // Set Article Type as NULL
            System.currentPageReference().getParameters().put('articleType',NULL);
            vfCnsObj.getarticleWrLst();
            system.assert(vfCnsObj.articleWrLst.size() > 0);
        } catch(Exception ex) {}
    }
}