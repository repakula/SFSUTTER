@isTest
private class SH_SearchBarControllerTest 
{
    static testMethod void ValidateSearchBarController() 
    {
        Test.startTest();
        Sh_SearchArticles.getObjectLabel(null);
        Sh_SearchArticles.getObjectLabel(new Account());
        Sh_SearchArticles.getJumbledMatchTypeForKeyWordWithSpace('Nokia', null, true );
        Sh_SearchArticles.getJumbledMatchTypeForKeyWordWithSpace('Nokia tool?s', 'Nokia tool?s', true );
        Sh_SearchArticles.getJumbledMatchTypeForKeyWordWithSpace('Nokia tool?s', 'Nokia tool?s', false );
        Sh_SearchArticles.getJumbledMatchTypeForKeyWordWithSpace('Nokia tool', 'Nokia tool?s', false );
        Sh_SearchArticles.getJumbledMatchTypeForKeyWordWithSpace('Nokia tool going', 'tool work going', false );
        //Headliner data
        Contact_Script__kav objContactScript1 = SH_CommonTest.CreateArticleData('Nokia SMD Article', 'www-Nokia-com');
        SH_CommonTest.CreateHomePageHeadliner('Article Nokia', 'Description', 1, 'Article', true, true, String.valueOf(objContactScript1.KnowledgeArticleId).substring(0,15), '');
        
        Tool__kav objTool1 = SH_CommonTest.CreateToolData('Nokia SMD Tool', 'www-Sutter-com');
        SH_CommonTest.CreateHomePageHeadliner('Tool', 'Description', 2, 'Tool', true, true, String.valueOf(objTool1.KnowledgeArticleId).substring(0,15), '');
        
        //Caurosel Data
        Contact_Script__kav objContactScript2 = SH_CommonTest.CreateArticleData('Nokia Article', 'www-barcoding-com');
        SH_CommonTest.CreateHomePageCarousel('Article Barcoding', 'Description', 1, 'Article', true, true, String.valueOf(objContactScript2.KnowledgeArticleId).substring(0,15), '');
        
        Tool__kav objTool2 = SH_CommonTest.CreateToolData('Barcoding Tool', 'www-Barcodingtool-com');
        SH_CommonTest.CreateHomePageCarousel('Tool', 'Description', 2, 'Tool', true, true, String.valueOf(objTool2.KnowledgeArticleId).substring(0,15), '');
        
        //Menu
        SH_Menu_Item__c objMenuItem = SH_CommonTest.CreateMenuItem('Benifit', 'Description', 1, true, true, 'Human Resource', 'HR Benefits');
        
        //SubMenu
        SH_Sub_Menu_Item__c objSubMenu = SH_CommonTest.CreateSubMenuItem('Discount', 'Description', 1, true, true, 'Human Resource', 'HR Benefits', objMenuItem.id);
        
        //Level2
        Contact_Script__kav objContactScript3 = SH_CommonTest.CreateArticleData('Nokia test Articel', 'www-Nokiatest-com');
        SH_CommonTest.CreateLevel2Content('Nokia Health Tool', 'Descritpion','Article', 1, true, true, objSubMenu.id, 'Simple List View (Full Width)', '', String.valueOf(objContactScript3.KnowledgeArticleId).substring(0,15));
        
        Tool__kav objTool3 = SH_CommonTest.CreateToolData('Nokia Tool', 'www-Suttertest-com');
        SH_CommonTest.CreateLevel2Content('Nokia Tool', 'Descritpion', 'Tool', 1, true, true, objSubMenu.id, 'Simple List View (Full Width)', '', String.valueOf(objTool3.KnowledgeArticleId).substring(0,15));
        
        SH_CommonTest.CreateCommunitySetting();
        SH_CommonTest.CreateArticleTypeVisiblity('Contact Script', 'Contact_Script__kav');
        SH_CommonTest.CreateArticleTypeVisiblity('Tool', 'Tool__kav');
        //User objUser = SH_CommonTest.CreateCommunityUser();
        
        Test.stopTest();
        
        //system.runAs(objUser)
        //{
            ApexPages.currentPage().getParameters().put('q','No');
            SH_SearchBarController objSearch = new SH_SearchBarController();
            objSearch.DoPageLoadActon();
            objSearch.ChangeView();
            
            Id[] fixedSearchResults= new Id[6];
            fixedSearchResults[0] = objContactScript1.Id;
            fixedSearchResults[1] = objContactScript2.Id;
            fixedSearchResults[2] = objContactScript3.Id;
            fixedSearchResults[3] = objTool1.Id;
            fixedSearchResults[4] = objTool2.Id;
            fixedSearchResults[5] = objTool3.Id;
            Test.setFixedSearchResults(fixedSearchResults);
                        
            ApexPages.currentPage().getParameters().put('q','Nokia');
            SH_SearchBarController objSearch1 = new SH_SearchBarController();
            objSearch1.DoPageLoadActon();
            objSearch1.ChangeView();
            objSearch1.SelectedView='nl';
            objSearch1.ChangeView();
            
            SH_SearchBarRemoteController objSearchRemote = new SH_SearchBarRemoteController();
            objSearchRemote.SearchString = 'Nok';
            objSearchRemote.RedirectToSearchResultPage();
            
            SH_SearchBarRemoteController.getSearchResult('Nok'); 
            
        //}   
    }
    static testMethod void ValidateSH_SearchArticlesArticleNumMatch() 
    {
        Test.startTest();
        Contact_Script__kav objContactScript1 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia SMD Article', UrlName = 'www-Nokia-com',IsVisibleInCsp = true));
        Contact_Script__kav objContactScript2 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia Article?', UrlName = 'www-barcoding-com',IsVisibleInCsp = true));
        Contact_Script__kav objContactScript3 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia test Articel', UrlName = 'www-Nokiatest-com',IsVisibleInCsp = true));
        
        Tool__kav objTool1 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Nokia SMD Tool', UrlName = 'www-Nokia-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        Tool__kav objTool2 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Barcoding Tool', UrlName = 'www-Barcodingtool-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        Tool__kav objTool3 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Nokia Tool', UrlName = 'www-Suttertest-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        
        SH_CommonTest.CreateCommunitySetting();
        SH_CommonTest.CreateArticleTypeVisiblity('Contact Script', 'Contact_Script__kav');
        SH_CommonTest.CreateArticleTypeVisiblity('Tool', 'Tool__kav');
        //User objUser = SH_CommonTest.CreateCommunityUser();
        
        Test.stopTest();
        
        //system.runAs(objUser)
        //{
            ApexPages.currentPage().getParameters().put('q',objContactScript1.ArticleNumber);
            SH_SearchBarController objSearch = new SH_SearchBarController();
            objSearch.DoPageLoadActon();
            objSearch.ChangeView();
            
            Id[] fixedSearchResults= new Id[6];
            fixedSearchResults[0] = objContactScript1.Id;
            fixedSearchResults[1] = objContactScript2.Id;
            fixedSearchResults[2] = objContactScript3.Id;
            fixedSearchResults[3] = objTool1.Id;
            fixedSearchResults[4] = objTool2.Id;
            fixedSearchResults[5] = objTool3.Id;
            Test.setFixedSearchResults(fixedSearchResults);
                        
            ApexPages.currentPage().getParameters().put('q',objContactScript1.ArticleNumber);
            SH_SearchBarController objSearch1 = new SH_SearchBarController();
            objSearch1.DoPageLoadActon();
            objSearch1.ChangeView();
            objSearch1.SelectedView='nl';
            objSearch1.ChangeView();
            
            SH_SearchBarRemoteController objSearchRemote = new SH_SearchBarRemoteController();
            objSearchRemote.SearchString = objTool1.ArticleNumber;
            objSearchRemote.RedirectToSearchResultPage();
            
            SH_SearchBarRemoteController.getSearchResult(objTool1.ArticleNumber); 
            
        //}   
    }
    static testMethod void ValidateSH_SearchArticlesArticleTitleMatch() 
    {
        Test.startTest();
        Contact_Script__kav objContactScript1 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia SMD Article', UrlName = 'www-Nokia-com',IsVisibleInCsp = true));
        Contact_Script__kav objContactScript2 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia Article?', UrlName = 'www-barcoding-com',IsVisibleInCsp = true));
        Contact_Script__kav objContactScript3 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia test Articel', UrlName = 'www-Nokiatest-com',IsVisibleInCsp = true));
        
        Tool__kav objTool1 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Nokia SMD Tool', UrlName = 'www-Nokia-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        Tool__kav objTool2 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Barcoding Tool', UrlName = 'www-Barcodingtool-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        Tool__kav objTool3 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Nokia Tool', UrlName = 'www-Suttertest-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        
        SH_CommonTest.CreateCommunitySetting();
        SH_CommonTest.CreateArticleTypeVisiblity('Contact Script', 'Contact_Script__kav');
        SH_CommonTest.CreateArticleTypeVisiblity('Tool', 'Tool__kav');
        //User objUser = SH_CommonTest.CreateCommunityUser();
        
        Test.stopTest();
        
        //system.runAs(objUser)
        //{
            
            ApexPages.currentPage().getParameters().put('q','Nokia SMD Article');
            SH_SearchBarController objSearch = new SH_SearchBarController();
            objSearch.DoPageLoadActon();
            objSearch.ChangeView();
            
            Id[] fixedSearchResults= new Id[6];
            fixedSearchResults[0] = objContactScript1.Id;
            fixedSearchResults[1] = objContactScript2.Id;
            fixedSearchResults[2] = objContactScript3.Id;
            fixedSearchResults[3] = objTool1.Id;
            fixedSearchResults[4] = objTool2.Id;
            fixedSearchResults[5] = objTool3.Id;
            Test.setFixedSearchResults(fixedSearchResults);
                        
            ApexPages.currentPage().getParameters().put('q','Nokia SMD Tool');
            SH_SearchBarController objSearch1 = new SH_SearchBarController();
            objSearch1.DoPageLoadActon();
            objSearch1.ChangeView();
            objSearch1.SelectedView='nl';
            objSearch1.ChangeView();
            
            SH_SearchBarRemoteController objSearchRemote = new SH_SearchBarRemoteController();
            objSearchRemote.SearchString = 'Nokia SMD Article';
            objSearchRemote.RedirectToSearchResultPage();
            
            SH_SearchBarRemoteController.getSearchResult('Nokia SMD Article'); 
            
            
        //}   
    }
    
    static testMethod void ValidateSH_SearchArticlesArticleTitleContains() 
    {
        Test.startTest();
        Contact_Script__kav objContactScript1 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia SMD Article', UrlName = 'www-Nokia-com',IsVisibleInCsp = true));
        Contact_Script__kav objContactScript2 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia Article?', UrlName = 'www-barcoding-com',IsVisibleInCsp = true));
        Contact_Script__kav objContactScript3 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia test Articel', UrlName = 'www-Nokiatest-com',IsVisibleInCsp = true));
        
        Tool__kav objTool1 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Nokia SMD Tool', UrlName = 'www-Nokia-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        Tool__kav objTool2 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Barcoding Tool', UrlName = 'www-Barcodingtool-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        Tool__kav objTool3 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Nokia Tool', UrlName = 'www-Suttertest-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        
        SH_CommonTest.CreateCommunitySetting();
        SH_CommonTest.CreateArticleTypeVisiblity('Contact Script', 'Contact_Script__kav');
        SH_CommonTest.CreateArticleTypeVisiblity('Tool', 'Tool__kav');
        //User objUser = SH_CommonTest.CreateCommunityUser();
        
        Test.stopTest();
        
        //system.runAs(objUser)
        //{
            
            ApexPages.currentPage().getParameters().put('q','SMD');
            SH_SearchBarController objSearch = new SH_SearchBarController();
            objSearch.DoPageLoadActon();
            objSearch.ChangeView();
            
            Id[] fixedSearchResults= new Id[6];
            fixedSearchResults[0] = objContactScript1.Id;
            fixedSearchResults[1] = objContactScript2.Id;
            fixedSearchResults[2] = objContactScript3.Id;
            fixedSearchResults[3] = objTool1.Id;
            fixedSearchResults[4] = objTool2.Id;
            fixedSearchResults[5] = objTool3.Id;
            Test.setFixedSearchResults(fixedSearchResults);
                        
            ApexPages.currentPage().getParameters().put('q','SMD Tool');
            SH_SearchBarController objSearch1 = new SH_SearchBarController();
            objSearch1.DoPageLoadActon();
            objSearch1.ChangeView();
            objSearch1.SelectedView='nl';
            objSearch1.ChangeView();
            
            SH_SearchBarRemoteController objSearchRemote = new SH_SearchBarRemoteController();
            objSearchRemote.SearchString = 'SMD Nokia Article';
            objSearchRemote.RedirectToSearchResultPage();
            
            SH_SearchBarRemoteController.getSearchResult('SMD Nokia Article'); 
            
            
        //}   
    }
    static testMethod void ValidateSH_SearchArticlesArticleTitleJumbled() 
    {
        Test.startTest();
        Contact_Script__kav objContactScript1 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia SMD Article', UrlName = 'www-Nokia-com',IsVisibleInCsp = true));
        Contact_Script__kav objContactScript2 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia Article?', UrlName = 'www-barcoding-com',IsVisibleInCsp = true));
        Contact_Script__kav objContactScript3 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia test Articel', UrlName = 'www-Nokiatest-com',IsVisibleInCsp = true));
        
        Tool__kav objTool1 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Nokia SMD Tool? s', UrlName = 'www-Nokia-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        Tool__kav objTool2 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Barcoding Tool', UrlName = 'www-Barcodingtool-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        Tool__kav objTool3 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Nokia Tool', UrlName = 'www-Suttertest-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        
        SH_CommonTest.CreateCommunitySetting();
        SH_CommonTest.CreateArticleTypeVisiblity('Contact Script', 'Contact_Script__kav');
        SH_CommonTest.CreateArticleTypeVisiblity('Tool', 'Tool__kav');
        //User objUser = SH_CommonTest.CreateCommunityUser();
        
        Test.stopTest();
        
        //system.runAs(objUser)
        //{
            
            ApexPages.currentPage().getParameters().put('q','Tool? SMD Nokia s');
            SH_SearchBarController objSearch = new SH_SearchBarController();
            objSearch.DoPageLoadActon();
            objSearch.ChangeView();
            
            Id[] fixedSearchResults= new Id[6];
            fixedSearchResults[0] = objContactScript1.Id;
            fixedSearchResults[1] = objContactScript2.Id;
            fixedSearchResults[2] = objContactScript3.Id;
            fixedSearchResults[3] = objTool1.Id;
            fixedSearchResults[4] = objTool2.Id;
            fixedSearchResults[5] = objTool3.Id;
            Test.setFixedSearchResults(fixedSearchResults);
                        
            ApexPages.currentPage().getParameters().put('q','Tool Barcoding');
            SH_SearchBarController objSearch1 = new SH_SearchBarController();
            objSearch1.DoPageLoadActon();
            objSearch1.ChangeView();
            objSearch1.SelectedView='nl';
            objSearch1.ChangeView();
            
            SH_SearchBarRemoteController objSearchRemote = new SH_SearchBarRemoteController();
            objSearchRemote.SearchString = 'Nokia Tool';
            objSearchRemote.RedirectToSearchResultPage();
            
            SH_SearchBarRemoteController.getSearchResult('Nokia Article'); 
            
        //}   
    }
    static testMethod void ValidateSH_SearchArticlesArticleNonExact() 
    {
        Test.startTest();
        Contact_Script__kav objContactScript1 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia SMD Article', UrlName = 'www-Nokia-com',IsVisibleInCsp = true));
        Contact_Script__kav objContactScript2 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia Article?', UrlName = 'www-barcoding-com',IsVisibleInCsp = true));
        Contact_Script__kav objContactScript3 = SH_CommonTest.CreateArticleData(new Contact_Script__kav(Title = 'Nokia test Articel', UrlName = 'www-Nokiatest-com',IsVisibleInCsp = true));
        
        Tool__kav objTool1 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Nokia SMD Tool? s', UrlName = 'www-Nokia-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        Tool__kav objTool2 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Barcoding Tool', UrlName = 'www-Barcodingtool-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        Tool__kav objTool3 = SH_CommonTest.CreateToolData(new Tool__kav(Title = 'Nokia Tool', UrlName = 'www-Suttertest-comTool',IsVisibleInCsp = true,SH_Is_Show_Notification__c=true,SH_Is_Show_Browser_Notification__c=true,SH_Not_Supported_Browser__c='MSIE' ));
        
        SH_CommonTest.CreateCommunitySetting();
        SH_CommonTest.CreateArticleTypeVisiblity('Contact Script', 'Contact_Script__kav');
        SH_CommonTest.CreateArticleTypeVisiblity('Tool', 'Tool__kav');
        //User objUser = SH_CommonTest.CreateCommunityUser();
        
        Test.stopTest();
        
        //system.runAs(objUser)
        //{
            Id[] fixedSearchResults= new Id[6];
            fixedSearchResults[0] = objContactScript1.Id;
            fixedSearchResults[1] = objContactScript2.Id;
            fixedSearchResults[2] = objContactScript3.Id;
            fixedSearchResults[3] = objTool1.Id;
            fixedSearchResults[4] = objTool2.Id;
            fixedSearchResults[5] = objTool3.Id;
            Test.setFixedSearchResults(fixedSearchResults);
                        
            sh_searchArticles.SearchArticles_Advance('"Tool working"', false);
            sh_searchArticles.SearchArticles_Advance('"Article working"', false);
            
        //}   
    }
    
    
}