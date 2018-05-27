@isTest
private class SH_ArticleViewTest 
{
    static testMethod void VaidateArticleView() 
    {
        Test.startTest();
        
        //Headliner data
        Contact_Script__kav objContactScript1 = SH_CommonTest.CreateArticleData('Nokia SMD Article', 'www-Nokia-com');
        SH_CommonTest.CreateHomePageHeadliner('Article Nokia', 'Description', 1, 'Article', true, true, String.valueOf(objContactScript1.KnowledgeArticleId).substring(0,15), '');
        
        Tool__kav objTool1 = SH_CommonTest.CreateToolData('Nokia SMD Tool', 'www-Sutter-com');
        SH_CommonTest.CreateHomePageHeadliner('Tool', 'Description', 2, 'Tool', true, true, String.valueOf(objTool1.KnowledgeArticleId).substring(0,15), '');
        
        //Caurosel Data
        Contact_Script__kav objContactScript2 = SH_CommonTest.CreateArticleData('Nokia Article', 'www-barcoding-com');
        SH_CommonTest.CreateHomePageCarousel('Article Barcoding', 'Description', 1, 'Article', true, true, String.valueOf(objContactScript2.KnowledgeArticleId).substring(0,15), '');
        
        Tool__kav objTool2 = SH_CommonTest.CreateToolData('Nokia Tool', 'www-Barcodingtool-com');
        SH_CommonTest.CreateHomePageCarousel('Tool', 'Description', 2, 'Tool', true, true, String.valueOf(objTool2.KnowledgeArticleId).substring(0,15), '');
        
        //Menu
        SH_Menu_Item__c objMenuItem = SH_CommonTest.CreateMenuItem('Benifit', 'Description', 1, true, true, 'Human Resource', 'HR Benefits');
        
        //SubMenu
        SH_Sub_Menu_Item__c objSubMenu = SH_CommonTest.CreateSubMenuItem('Discount', 'Description', 1, true, true, 'Human Resource', 'HR Benefits', objMenuItem.id);
        
        //Level2
        Contact_Script__kav objContactScript3 = SH_CommonTest.CreateArticleData('Nokia', 'www-Nokiatest-com');
        SH_Level_2_Content__c objContent = SH_CommonTest.CreateLevel2Content('Nokia', 'Descritpion', 'Article', 1, true, true, objSubMenu.id, 'Simple List View (Full Width)', '', String.valueOf(objContactScript3.KnowledgeArticleId).substring(0,15));
        
        Contact_Script__kav objContactScript4 = SH_CommonTest.CreateArticleData('Nokia', 'www-Nokiatest123-com');
        SH_Level_2_Content__c objContent1 = SH_CommonTest.CreateLevel2Content('Nokia', 'Descritpion', 'Article', 1, true, true, objSubMenu.id, 'Simple List View (Full Width)', '', String.valueOf(objContactScript4.KnowledgeArticleId).substring(0,15));
        
        Tool__kav objTool3 = SH_CommonTest.CreateToolData('Nokia Tool', 'www-Suttertest-com');
        SH_CommonTest.CreateLevel2Content('Nokia Tool', 'Descritpion', 'Tool', 1, true, true, objSubMenu.id, 'List With Left Image', '', String.valueOf(objTool3.KnowledgeArticleId).substring(0,15));
        
        SH_CommonTest.CreateArticleTypeVisiblity('Contact Script', 'Contact_Script__kav');
        SH_CommonTest.CreateArticleTypeVisiblity('Tool', 'Tool__kav');
        
        User objUser = SH_CommonTest.CreateCommunityUser();
        
        SH_CommonTest.CreateHistory(objUser.Id, objContactScript3.KnowledgeArticleId);
                
        Test.stopTest();
                
        system.runAs(objUser)
        {
            Apexpages.currentpage().getparameters().put('Id',objContent.SH_Article_Tool_Id__c);
            Id[] fixedSearchResults= new Id[3];
            fixedSearchResults[0] = objContactScript1.Id;
            fixedSearchResults[1] = objContactScript2.Id;
            fixedSearchResults[2] = objContactScript3.Id;
            Test.setFixedSearchResults(fixedSearchResults);
            
            SH_ArticleView objArticle = new SH_ArticleView();
            objArticle.CreateHistoryRecord();     
        }
        
        system.runAs(objUser)
        {
            Apexpages.currentpage().getparameters().put('Id',objContent1.SH_Article_Tool_Id__c);
            Id[] fixedSearchResults = new Id[4];
            fixedSearchResults[0] = objContactScript1.Id;
            fixedSearchResults[1] = objContactScript2.Id;
            fixedSearchResults[2] = objContactScript3.Id;
            fixedSearchResults[3] = objContactScript4.Id;
            Test.setFixedSearchResults(fixedSearchResults);
            
            SH_ArticleView objArticle = new SH_ArticleView();
            objArticle.CreateHistoryRecord();
        }
    }
}