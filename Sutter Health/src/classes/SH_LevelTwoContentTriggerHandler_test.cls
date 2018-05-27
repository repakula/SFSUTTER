/*
    This class is used to cover the SH_LevelTwoContentTriggerHandler class
    and SH_LevelTwoContentTrigger trigger
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Prashant Kumar          25/09/2015                   1.0
    ==========================================================  
*/
@isTest 
private class SH_LevelTwoContentTriggerHandler_test
{
    static testmethod void validateTest() 
    {
        list<SH_Level_2_Content__c> lstLevel2Content = new list<SH_Level_2_Content__c>();
        SH_Trigger_Settings__c objTS =new SH_Trigger_Settings__c();
        objTS.SH_Is_Active__c=True;
        objTS.Name='SH_LevelTwoContentTrigger';
        objTS.SH_Max_Publish_Count__c=1;
        insert objTS;
    
    
       Contact_Script__kav objArticle = Sh_commontest.CreateArticleData('TestarticleTitle','TestarticleTitle');
       string articleId = objArticle.knowledgeArticleId ;
      
       tool__kav objTool = sh_commontest.CreateToolData('TesttoolTitle', 'TesttoolTitle');
       string toolId = objTool.knowledgeArticleId ;
       
       Contact_Script__kav objDraftArticle = Sh_commontest.CreateDraftArticle('TestDraftArticle','TestDraftArticle');
       string DraftarticleId = objDraftArticle.knowledgeArticleId ;
       
       SH_Menu_Item__c objMI = new SH_Menu_Item__c();
       objMI.Name = 'Test Menu Item';
       objMI.SH_Description__c = 'Test Description';
       objMI.SH_Order_of_Display__c = 1;
       insert objMI;
      
       SH_Sub_Menu_Item__c objSL = new SH_Sub_Menu_Item__c();
       objSL.Name = 'Test Submenu';
       objSL.SH_Menu_Item__c = objMI.id;
       objSL.SH_Order_of_Display__c = 4;
       objSL.SH_Secondary_Page_Description__c = 'Test Seconarty description';
       insert objSL;
    
       SH_Level_2_Content__c objSH  = new SH_Level_2_Content__c();
       objSH.Name = 'Test Name';
       objSH.SH_Content_Type__c = 'Article';
       objSH.SH_Background_Class__c = 'background-orange';
       objSH.SH_Listing_Type__c = 'Two Column Layout';
       objSH.SH_Order_of_Display__c = 5;
       objSH.SH_Article_Tool_Id__c = articleId.substring(0,15) ;
       objSH.SH_Sub_Menu_Item__c = objSL.id;
       objSH.SH_Description__c = 'Test Desc';
       
       lstLevel2Content.add(objSH);
      
       SH_Level_2_Content__c objSH1  = new SH_Level_2_Content__c();
       objSH1.Name = 'Test Name';
       objSH1.SH_Content_Type__c = 'Tool';
       objSH1.SH_Background_Class__c = 'background-orange';
       objSH1.SH_Listing_Type__c = 'Two Column Layout';
       objSH1.SH_Order_of_Display__c = 5;
       objSH1.SH_Article_Tool_Id__c = toolId.substring(0,15);
       objSH1.SH_Sub_Menu_Item__c = objSL.id;
       objSH1.SH_Description__c = 'Test Desc34';
       
       lstLevel2Content.add(objSH1);
       
       SH_Level_2_Content__c objSH3  = new SH_Level_2_Content__c();
       objSH3.Name = 'Test Name';
       objSH3.SH_Content_Type__c = 'Tool'; 
       objSH3.SH_Background_Class__c = 'background-orange';
       objSH3.SH_Listing_Type__c = 'Two Column Layout';
       objSH3.SH_Order_of_Display__c = 5;
       objSH3.SH_Article_Tool_Id__c = '';
       objSH3.SH_Sub_Menu_Item__c = objSL.id;
       objSH3.SH_Description__c = 'Test Desc34';
       
       lstLevel2Content.add(objSH3);
       
       SH_Level_2_Content__c objSH4  = new SH_Level_2_Content__c();
       objSH4.Name = 'Test Name';
       objSH4.SH_Content_Type__c = '';
       objSH4.SH_Background_Class__c = 'background-orange';
       objSH4.SH_Listing_Type__c = 'Two Column Layout';
       objSH4.SH_Order_of_Display__c = 5;
       objSH4.SH_Article_Tool_Id__c = articleId.substring(0,15) ;
       objSH4.SH_Sub_Menu_Item__c = objSL.id;
       objSH4.SH_Description__c = 'Test Desc';
       objSH4.SH_Article_Link__c = 'TestArticle';
       
       lstLevel2Content.add(objSH4);
        
       SH_Level_2_Content__c objSH5 = new SH_Level_2_Content__c();
       objSH5.Name = 'Test Name';
       objSH5.SH_Content_Type__c = '';
       objSH5.SH_Background_Class__c = 'background-orange';
       objSH5.SH_Listing_Type__c = 'Two Column Layout';
       objSH5.SH_Order_of_Display__c = 5;
       objSH5.SH_Sub_Menu_Item__c = objSL.id;
       objSH5.SH_Description__c = 'Test Desc';
       objSH5.SH_Article_Link__c = '';
       
       lstLevel2Content.add(objSH5);
       
       SH_Level_2_Content__c objSH6 = new SH_Level_2_Content__c();
       objSH6.Name = 'Test Name';
       objSH6.SH_Content_Type__c = 'Article';
       objSH6.SH_Background_Class__c = 'background-orange';
       objSH6.SH_Listing_Type__c = 'Two Column Layout';
       objSH6.SH_Order_of_Display__c = 5;
       objSH6.SH_Article_Tool_Id__c = toolId.substring(0,15);
       objSH6.SH_Sub_Menu_Item__c = objSL.id;
       objSH6.SH_Description__c = 'Test Desc';
       objSH6.SH_Article_Link__c = '';
       
       lstLevel2Content.add(objSH6);
       
       SH_Level_2_Content__c objSH7 = new SH_Level_2_Content__c();
       objSH7.Name = 'Test Name';
       objSH7.SH_Content_Type__c = 'Article';
       objSH7.SH_Background_Class__c = 'background-orange';
       objSH7.SH_Listing_Type__c = 'Two Column Layout';
       objSH7.SH_Order_of_Display__c = 5;
       objSH7.SH_Article_Tool_Id__c = 'kA0ytyt123ertyu'; //For invalid id 
       objSH7.SH_Sub_Menu_Item__c = objSL.id;
       objSH7.SH_Description__c = 'Test Desc';
       objSH7.SH_Article_Link__c = '';
       
       lstLevel2Content.add(objSH7);
       
       SH_Level_2_Content__c objSH8  = new SH_Level_2_Content__c();
       objSH8.Name = 'Test Name';
       objSH8.SH_Content_Type__c = 'Article';
       objSH8.SH_Background_Class__c = 'background-orange';
       objSH8.SH_Listing_Type__c = 'Two Column Layout';
       objSH8.SH_Order_of_Display__c = 5;
       objSH8.SH_Article_Tool_Id__c = DraftarticleId.substring(0,15) ;
       objSH8.SH_Sub_Menu_Item__c = objSL.id;
       objSH8.SH_Description__c = 'Test Desc';
       
       lstLevel2Content.add(objSH8);
       
       try
       {
            Database.insert(lstLevel2Content, false);
       }
       catch(exception ex) {
        }
       objSH.SH_Description__c = 'Test Desc1';
       try
       {
        update objSH;
       }
       catch(exception ex) {
        }
       
    } 
}