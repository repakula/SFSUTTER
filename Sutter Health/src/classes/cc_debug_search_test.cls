/**
 ** Version
 * 1.0 Brian Lee 5/7/2017
 */
@isTest
private class cc_debug_search_test {
    @testSetup
    static void manage_case_setup(){
        list<Nursing__kav> testArticleList = new list<Nursing__kav>();
        testArticleList.add(new Nursing__kav(Title='Unit Test1',UrlName = 'Unit-Test1', Language = 'en_US'));
        testArticleList.add(new Nursing__kav(Title='Unit Test2',UrlName = 'Unit-Test2', Language = 'en_US'));
        testArticleList.add(new Nursing__kav(Title='Unit Test3',UrlName = 'Unit-Test3', Language = 'en_US'));
        testArticleList.add(new Nursing__kav(Title='Unit Test4',UrlName = 'Unit-Test4', Language = 'en_US'));
        testArticleList.add(new Nursing__kav(Title='I AM',Summary ='I AM',Article_Body__c='I AM', UrlName = 'I-AM-Test5', Language = 'en_US'));
        insert testArticleList;

        for (Nursing__kav thisArticle : [select KnowledgeArticleId from Nursing__kav where id =: testArticleList]) {
            String articleId = thisArticle.KnowledgeArticleId;
            KbManagement.PublishingService.publishArticle(articleId, true);
        }
        list<Nursing__DataCategorySelection> testCategoriesList = new list<Nursing__DataCategorySelection>();
        testCategoriesList.add(
            new Nursing__DataCategorySelection(
                ParentId = testArticleList[0].id,
                DataCategoryGroupName = 'learn_articles',
                DataCategoryName = 'part1'
            ));
        testCategoriesList.add(
            new Nursing__DataCategorySelection (
                ParentId = testArticleList[1].id,
                DataCategoryGroupName = 'learn_articles',
                DataCategoryName = 'part2'
            ));
        testCategoriesList.add(                                                 
            new Nursing__DataCategorySelection (
                ParentId = testArticleList[2].id,
                DataCategoryGroupName = 'learn_articles',
                DataCategoryName = 'iam'
            ));
        testCategoriesList.add(                                                 
            new Nursing__DataCategorySelection (
                ParentId = testArticleList[3].id,
                DataCategoryGroupName = 'learn_articles',
                DataCategoryName = 'iam_subarticles'
            ));
        testCategoriesList.add(                                                 
            new Nursing__DataCategorySelection (
                ParentId = testArticleList[4].id,
                DataCategoryGroupName = 'learn_articles',
                DataCategoryName = 'iam'
            ));
                                                            
        insert testCategoriesList;                                                      
                                                            
    }
     
    @isTest 
    static void testSearchResults() {
        Nursing__kav testArticle = [Select id from Nursing__kav where Title='Unit Test1' AND PublishStatus = 'Online' AND Language = 'en_US'];
        system.assert(testArticle != null);
        PageReference pageRef = Page.custom_home_article;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', testArticle.id);
        cc_debug_search initController = new cc_debug_search();
        List<Nursing__kav> searchResults = initController.getSearchResults();
        system.assert(searchResults != null);
        system.assert(searchResults[0].id == testArticle.id);
        
    }
    @isTest 
    static void testGetArticle() {
        Nursing__kav testArticle = [Select id from Nursing__kav where Title='Unit Test2' AND PublishStatus = 'Online' AND Language = 'en_US'];
        system.assert(testArticle != null);
        PageReference pageRef = Page.custom_home_article;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', testArticle.id);
        cc_debug_search initController = new cc_debug_search();

        List<Nursing__kav> searchResults = (List<Nursing__kav>)  cc_debug_search.getArticle();
        system.assert(searchResults != null);
        system.assert(searchResults[0].id == testArticle.id);
        
    }
    @isTest 
    static void testGetArticleDetails() {
        Nursing__kav testArticle = [Select id from Nursing__kav where Title='Unit Test3' AND PublishStatus = 'Online' AND Language = 'en_US'];
        system.assert(testArticle != null);
        PageReference pageRef = Page.custom_home_article;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', testArticle.id);
        cc_debug_search initController = new cc_debug_search();
        List<Nursing__kav> searchResults = (List<Nursing__kav>)  cc_debug_search.getArticleDetails();
        system.assert(searchResults != null);
        system.assert(searchResults[0].id == testArticle.id);
        
    }
    @isTest 
    static void testGetArticleByCategory() {
        Nursing__kav testArticle = [Select id from Nursing__kav where Title='Unit Test4' AND PublishStatus = 'Online' AND Language = 'en_US'];
        system.assert(testArticle != null);
        PageReference pageRef = Page.custom_home_article;
        Test.setCurrentPage(pageRef);
        cc_debug_search initController = new cc_debug_search();
        List<Nursing__kav> searchResults = (List<Nursing__kav>)  cc_debug_search.getArticleByCategory();
        system.assert(searchResults != null);
        system.assert(searchResults[0].id == testArticle.id);
        
    }
    @isTest 
    static void testGetMegaMenuArticles() {
        Nursing__kav testArticle = [Select id from Nursing__kav where Title='Unit Test4' AND PublishStatus = 'Online' AND Language = 'en_US'];
        system.assert(testArticle != null);
        PageReference pageRef = Page.custom_home_article;
        Test.setCurrentPage(pageRef);
        cc_debug_search initController = new cc_debug_search();
        List<Nursing__kav> searchResults = (List<Nursing__kav>)  cc_debug_search.getMegaMenuArticles();
        system.assert(searchResults != null);
        system.assert(searchResults[0].id == testArticle.id);
        
    }
     @isTest 
    static void testGetIamArticle() {
        Nursing__kav testArticle = [Select id from Nursing__kav where Title='I AM' AND PublishStatus = 'Online' AND Language = 'en_US'];
        system.assert(testArticle != null);
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = testArticle.id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        PageReference pageRef = Page.custom_home_article;
        Test.setCurrentPage(pageRef);
        cc_debug_search initController = new cc_debug_search();
        List<List<sObject>> searchResults = (List<List<sObject>>) cc_debug_search.getIamArticle();
        system.assert(searchResults != null);
        list<Nursing__kav> returnArticleList = ((list<Nursing__kav>) searchResults[0]);
        system.assert(returnArticleList != null);
        system.assert(!returnArticleList.isEmpty());
        system.assert(returnArticleList[0].id == testArticle.id);
    }
}