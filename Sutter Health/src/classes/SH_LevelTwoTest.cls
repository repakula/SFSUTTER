/*
    This class is used to cover the SH_LevelTwo class
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Prashant Kumar          23/09/2015                   1.0
    ==========================================================  
*/
@isTest
private class SH_LevelTwoTest 
{
    static testmethod void ValidateLevelTwo()
    {
        Test.startTest();
        
        //Headliner data
        Contact_Script__kav objContactScript1 = SH_CommonTest.CreateArticleData('Nokia SMD Article', 'www-Nokia-com');
        SH_CommonTest.CreateHomePageHeadliner('Article Nokia', 'Description', 1, 'Article', true, true, String.valueOf(objContactScript1.KnowledgeArticleId).substring(0,15), '');
        
        Tool__kav objTool1 = SH_CommonTest.CreateToolData('Nokia SMD Tool', 'www-Sutter-com');
        SH_CommonTest.CreateHomePageHeadliner('Tool', 'Description', 2, 'Tool', true, true, String.valueOf(objTool1.KnowledgeArticleId).substring(0,15), '');
        
        //Caurosel Data
        Contact_Script__kav objContactScript2 = SH_CommonTest.CreateArticleData('Barcoding Article', 'www-barcoding-com');
        SH_CommonTest.CreateHomePageCarousel('Article Barcoding', 'Description', 1, 'Article', true, true, String.valueOf(objContactScript2.KnowledgeArticleId).substring(0,15), '');
        
        Tool__kav objTool2 = SH_CommonTest.CreateToolData('Barcoding Tool', 'www-Barcodingtool-com');
        SH_CommonTest.CreateHomePageCarousel('Tool', 'Description', 2, 'Tool', true, true, String.valueOf(objTool2.KnowledgeArticleId).substring(0,15), '');
        
        //Menu
        SH_Menu_Item__c objMenuItem = SH_CommonTest.CreateMenuItem('Benifit', 'Description', 1, true, true, 'Human Resource', 'HR Benefits');
        
        //SubMenu
        SH_Sub_Menu_Item__c objSubMenu = SH_CommonTest.CreateSubMenuItem('Discount', 'Description', 1, true, true, 'Human Resource', 'HR Benefits', objMenuItem.id);
        
        //Level2
        Contact_Script__kav objContactScript3 = SH_CommonTest.CreateArticleData('Nokia test Articel', 'www-Nokiatest-com');
        SH_CommonTest.CreateLevel2Content('Nokia Health Tool', 'Descritpion', 'Article', 1, true, true, objSubMenu.id, 'Simple List View (Full Width)', '', String.valueOf(objContactScript3.KnowledgeArticleId).substring(0,15));
        SH_CommonTest.CreateLevel2Content('Nokia Health Tool', 'Descritpion', 'Article', 1, true, true, objSubMenu.id, 'List With Right Image', '', String.valueOf(objContactScript3.KnowledgeArticleId).substring(0,15));
        
        Tool__kav objTool3 = SH_CommonTest.CreateToolData('Nokia Tool', 'www-Suttertest-com');
        SH_CommonTest.CreateLevel2Content('Nokia Tool', 'Descritpion', 'Tool', 1, true, true, objSubMenu.id, 'List With Left Image', '', String.valueOf(objTool3.KnowledgeArticleId).substring(0,15));
        SH_CommonTest.CreateLevel2Content('Nokia Tool', 'Descritpion', 'Tool', 1, true, true, objSubMenu.id, 'Two Column Layout', '', String.valueOf(objTool3.KnowledgeArticleId).substring(0,15));
        
        SH_CommonTest.CreateLevel2Content('Form', 'Descritpion', 'Other', 1, true, true, objSubMenu.id, 'Simple List View (Full Width)', 'form', '');
        
        //Custom setting
        SH_CommonTest.CreateLevelTwoContentOrder('Simple List View (Full Width)',1);
        SH_CommonTest.CreateLevelTwoContentOrder('List With Left Image',2);
        SH_CommonTest.CreateLevelTwoContentOrder('List With Right Image',3);
        SH_CommonTest.CreateLevelTwoContentOrder('Two Column Layout',4);
        
        User objUser = SH_CommonTest.CreateCommunityUser();
        SH_LevelTwo.ContentListWrapper objwrp = new SH_LevelTwo.ContentListWrapper();
        
        
        Test.stopTest();
        
        system.runAs(objUser)
        {
            Apexpages.currentpage().getparameters().put('Id',objSubMenu.Id);
            SH_LevelTwo objLevelTwo = new SH_LevelTwo();
            objLevelTwo.lstContentListWrapper.add(objwrp);
            
            ApexPages.currentPage().getParameters().put('cmd','true');
            SH_LevelTwo objLevelTwo1 = new SH_LevelTwo();
        }
    }
}