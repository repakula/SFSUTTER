@isTest
/*
    This class is used to cover the SH_History class
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Prashant Kumar          05/10/2015                   1.0
    ==========================================================  
*/
private class SH_HistoryTest {
    //this method is used to cover the validateHistory method
    static testmethod void ValidateHistory() {
        Contact_Script__kav objArticle = Sh_commontest.CreateArticleData('TestarticleTitle','TestarticleTitle');
        string articleId = objArticle.knowledgeArticleId ;

        Test.startTest();

        User objUser = SH_CommonTest.CreateCommunityUser();
        SH_History__c oHistory = new SH_History__c();
        oHistory.SH_Summary__c='Test';
        oHistory.SH_Title__c='Test';
        oHistory.SH_User__c=objUser.id;
        oHistory.SH_Article_Id__c= articleId ;
        insert oHistory;
        
        SH_History.ArticleHistory objAh=new SH_History.ArticleHistory(oHistory);
        Test.stopTest();
        system.runAs(objUser)
        {
            SH_History objHistory = new SH_History();
        }
    }
}