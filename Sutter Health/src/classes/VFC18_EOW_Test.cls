/**
 * Name : VFC18_EOW
 * Description : Test class used for testing the VFC18_EOW class
 * Date : 10/07/14 
 */
 
@isTest
private class VFC18_EOW_Test{ 
    
    /*
     *@name testShowArticle() 
     *@return void 
     *@description This method for testShowArticle() In CLASS VFC18_EOW class
     */
     
     static testMethod void  testShowArticle() { 
        Test.startTest();
        VFC18_EOW  art = new VFC18_EOW();
        art.gotoLink();        
        Test.stopTest();
    }
    
    static testMethod void  testShowMangerArticle() { 
        Test.startTest();
        VFC18_EOW  art = new VFC18_EOW();
        user u = [select u.id , u.name from user u where u.profile.name='Community Portal Manager' and isActive=true limit 1];
        System.runAs(u){
        List < KnowledgeArticleVersion > articleList;
        string  qryString = 'SELECT Id, title,Summary,ArticleType,ArticleNumber,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\') AND title like \'%EOW Manager%\'  limit 10';
        articleList = Database.query(qryString);
        art.gotoLink();   
        }
        Test.stopTest();
    }
     static testMethod void  testNotShowArticle() { 
        Test.startTest();
        VFC18_EOW  art = new VFC18_EOW();
        user u = [select u.id , u.name from user u where u.profile.name='SHP Agent' and isActive=true limit 1];
         system.runAs(u){
        List < KnowledgeArticleVersion > articleList = new List < KnowledgeArticleVersion >();
        string  qryString = 'SELECT Id, title,Summary,ArticleType,ArticleNumber,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\') AND title like \'%EOW Employee%\'  limit 10';
        articleList = Database.query(qryString);      
        art.gotoLink();   
         }
        Test.stopTest();
    }
}