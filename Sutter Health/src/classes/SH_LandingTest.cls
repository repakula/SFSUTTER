/*
    This class is used to cover the SH_Landing class
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Prashant Kumar          24/09/2015                   1.0
    ==========================================================  
*/
@isTest
private class SH_LandingTest 
{
    static testmethod void ValidateLanding()
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
        SH_HomePage_carousel__c objCouresel = SH_CommonTest.CreateHomePageCarousel('Tool', 'Description', 2, 'Tool', true, true, String.valueOf(objTool2.KnowledgeArticleId).substring(0,15), '');
        
        //Menu
        SH_Menu_Item__c objMenuItem = SH_CommonTest.CreateMenuItem('Benifit', 'Description', 1, true, true, 'Human Resource', 'HR Benefits');
        
        //SubMenu
        SH_Sub_Menu_Item__c objSubMenu = SH_CommonTest.CreateSubMenuItem('Discount', 'Description', 1, true, true, 'Human Resource', 'HR Benefits', objMenuItem.id);
        
        //Level2
        Contact_Script__kav objContactScript3 = SH_CommonTest.CreateArticleData('Nokia test Articel', 'www-Nokiatest-com');
        SH_Level_2_Content__c objLevelCon = SH_CommonTest.CreateLevel2Content('Nokia Health Tool', 'Descritpion','Article', 1, true, true, objSubMenu.id, 'Simple List View (Full Width)', '', String.valueOf(objContactScript3.KnowledgeArticleId).substring(0,15));
        
        Tool__kav objTool3 = SH_CommonTest.CreateToolData('Nokia Tool', 'www-Suttertest-com');
        SH_CommonTest.CreateLevel2Content('Nokia Tool', 'Descritpion', 'Tool', 1, true, true, objSubMenu.id, 'Simple List View (Full Width)', '', String.valueOf(objTool3.KnowledgeArticleId).substring(0,15));
        
        User objUser = SH_CommonTest.CreateCommunityUser();
        
        Test.stopTest();
        
        system.runAs(objUser) 
        {
            SH_Landing objLanding = new SH_Landing();
            
            SH_BaseController objBase = new SH_BaseController();
            objBase.forwardToLoginPage();
            
            objBase.strToolArticeId = objCouresel.SH_Article_Tool_Id__c;
                        
            objBase.setToolsMap(objLanding.setToolId);
            objBase.browserName = 'MSIE';
            objBase.showNotification();
            
            SH_Common.findObjectNameFromRecordIdPrefix(objLevelCon.Id, Schema.getGlobalDescribe());
        }
    } 
}