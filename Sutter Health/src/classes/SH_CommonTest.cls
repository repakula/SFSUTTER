//This class is uesd to create test data 
public with sharing class SH_CommonTest 
{
    //This method is uesd to create home page headliner record
    public static SH_Home_Page_Headliner__c CreateHomePageHeadliner(String strTitle, String strHeadDescription, Integer intOrderOfDisplay, String strContentType,
                                                             boolean IsPublished, boolean IsPreview, String srArticleToolId, String ContentLink)
    {
        SH_Home_Page_Headliner__c objHPHeadliner = new SH_Home_Page_Headliner__c();
        objHPHeadliner.SH_Title__c = strTitle;
        objHPHeadliner.SH_Headliner_description__c =  strHeadDescription;
        objHPHeadliner.SH_Order_of_display__c = intOrderOfDisplay;
        objHPHeadliner.SH_Content_Type__c = strContentType;
        objHPHeadliner.SH_Is_Publish__c = IsPublished;
        objHPHeadliner.SH_Is_Preview__c = IsPreview;
        objHPHeadliner.SH_Article_Tool_Id__c = srArticleToolId;
        objHPHeadliner.SH_Content_Link__c = ContentLink;
        objHPHeadliner.SH_Content_Image_Url__c = 'TestImage';
        objHPHeadliner.SH_Article_Tool_Id__c = srArticleToolId;
        insert objHPHeadliner;
        
        system.assertEquals(objHPHeadliner.SH_Title__c, strTitle);
        
        return objHPHeadliner;
    }
    
    //This method is uesd to create home page carousel record
    public static SH_HomePage_carousel__c CreateHomePageCarousel(String strTitle, String strCarouselDescription, Integer intOrderOfDisplay, String strContentType,
                                                             boolean IsPublished, boolean IsPreview, String srArticleToolId, String ContentLink)
    {
        SH_HomePage_carousel__c objHPCarousel = new SH_HomePage_carousel__c();
        objHPCarousel.SH_Title__c = strTitle;
        objHPCarousel.SH_Carousel_description__c =  strCarouselDescription;
        objHPCarousel.SH_Order_of_display__c = intOrderOfDisplay;
        objHPCarousel.SH_Content_Type__c = strContentType;
        objHPCarousel.SH_Is_Publish__c = IsPublished;
        objHPCarousel.SH_Is_Preview__c = IsPreview;
        objHPCarousel.SH_Article_Tool_Id__c = srArticleToolId;
        objHPCarousel.SH_Content_Link__c = ContentLink;
        objHPCarousel.SH_Icon__c = 'TestIcon';
        objHPCarousel.SH_Article_Tool_Id__c = srArticleToolId;
        insert objHPCarousel;
        
        system.assertEquals(objHPCarousel.SH_Title__c, strTitle);
        
        return objHPCarousel;
    }
    
    //This method is uesd to create home page Menu Item record
    public static SH_Menu_Item__c CreateMenuItem(String strName, String strDescription, Integer intOrderOfDisplay, boolean IsPublished, boolean IsPreview, 
                                            string strFunction, string strSubFunction)
    {
        SH_Menu_Item__c objMenuItem = new SH_Menu_Item__c();
        objMenuItem.Name = strName;
        objMenuItem.SH_Description__c = strDescription;
        objMenuItem.SH_Order_of_Display__c = intOrderOfDisplay;
        objMenuItem.SH_Is_Publish__c = IsPublished;
        objMenuItem.SH_Is_Preview__c = IsPreview;
        objMenuItem.SH_Function__c = strFunction;
        objMenuItem.SH_Sub_Function__c = strSubFunction;
        objMenuItem.SH_Content_Image_Url__c = 'testImage';
        objMenuItem.SH_Icon__c = 'testImage';
        insert objMenuItem;
        
        system.assertEquals(objMenuItem.Name, strName);
        
        return objMenuItem;
    }    
    
    //This method is uesd to create home page Sub Menu Item record
    public static SH_Sub_Menu_Item__c CreateSubMenuItem(String strName, String strDescription, Integer intOrderOfDisplay, boolean IsPublished, boolean IsPreview, 
                                            string strFunction, string strSubFunction, String strMenuItem)
    {
        SH_Sub_Menu_Item__c objSubMenuItem = new SH_Sub_Menu_Item__c();
        objSubMenuItem.Name = strName;
        objSubMenuItem.SH_Secondary_Page_Description__c = strDescription;
        objSubMenuItem.SH_Order_of_Display__c = intOrderOfDisplay;
        objSubMenuItem.SH_Is_Publish__c = IsPublished;
        objSubMenuItem.SH_Is_Preview__c = IsPreview;
        objSubMenuItem.SH_Function__c = strFunction;
        objSubMenuItem.SH_Sub_Function__c = strSubFunction;
        objSubMenuItem.SH_Menu_Item__c = strMenuItem;
        insert objSubMenuItem;
        
        system.assertEquals(objSubMenuItem.Name, strName);
        
        return objSubMenuItem;
    }
    
    //This method is uesd to create Level two Content record
    public static SH_Level_2_Content__c CreateLevel2Content(String strName, String strDescription, String strContentType, Integer intOrderOfDisplay, boolean IsPublished, boolean IsPreview, 
                                                    String strSubMenuItem, string strListingType, string strContentLink, string strArticleId)
    {
        SH_Level_2_Content__c objLevelTwo = new SH_Level_2_Content__c();
        objLevelTwo.Name = strName;
        objLevelTwo.SH_Description__c = strDescription;
        objLevelTwo.SH_Order_of_Display__c = intOrderOfDisplay;
        objLevelTwo.SH_Is_Publish__c = IsPublished;
        objLevelTwo.SH_Is_Preview__c = IsPreview;
        objLevelTwo.SH_Content_Type__c = strContentType;
        objLevelTwo.SH_Sub_Menu_Item__c = strSubMenuItem;
        objLevelTwo.SH_Content_Link__c = strContentLink;
        objLevelTwo.SH_Listing_Type__c = strListingType;
        objLevelTwo.SH_Show_on_Top_links__c = true;
        objLevelTwo.SH_Article_Tool_Id__c = strArticleId;
        objLevelTwo.SH_Content_Image_Url__c = 'TestImage';
        objLevelTwo.SH_Article_Tool_Id__c = strArticleId;
        insert objLevelTwo;
        
        system.assertEquals(objLevelTwo.Name, strName);
        
        return objLevelTwo;
    }
    
    //This methd is used to create user
    public static User CreateCommunityUser()
    {
        list<User> lstRoleUser = [select id from User where UserRoleId != null limit 1];
        
        //Profile
        Profile objProfie = [select id from profile where Name = 'Community Portal Manager'];
        
        //Account
        Account objAccount = new Account();
        objAccount.OwnerId = lstRoleUser[0].Id;
        objAccount.RecordTypeId = SH_Common.GetRecordTypeId('Account', 'SHP Sales Broker');
        objAccount.Name = 'Company Test Account';
        objAccount.Phone  = '1234567890';
        objAccount.Status__c = 'Prospect';
        objAccount.Type = 'Broker'; 
        insert objAccount;
        
        //Contact
        Contact objContact = new Contact();
        objContact.LastName = 'TSTest'; 
        objContact.Email = 'test@sutter.com';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        //User
        User objCommunityUser = new User();
        objCommunityUser.Email = 'test@sutter.com';
        objCommunityUser.FirstName = 'Test';
        objCommunityUser.LastName = 'Sutter';
        objCommunityUser.Alias = 'TS';
        objCommunityUser.ProfileId = objProfie.Id;
        objCommunityUser.LanguageLocaleKey = 'en_US';
        objCommunityUser.LocaleSidKey = 'en_US';
        objCommunityUser.Country = 'United States';
        objCommunityUser.TimeZoneSidKey = 'America/Los_Angeles';
        objCommunityUser.Username = 'TS1@sutter.com'; 
        objCommunityUser.EmailEncodingKey = 'UTF-8';    
        objCommunityUser.ContactId = objContact.Id;
        insert objCommunityUser;
        
        //Permission Set
        /*PermissionSet objPermissionSet = [SELECT ID From PermissionSet WHERE Name = ''];
        
        //Attach Permission Set
        List <PermissionSetAssignment> lstPermissionSetAssignment = new List <PermissionSetAssignment>();
        lstPermissionSetAssignment.add( new PermissionSetAssignment(AssigneeId = objCommunityUser.id, PermissionSetId = objPermissionSet.Id ) );
        insert lstPermissionSetAssignment;*/ 
                        
        return objCommunityUser;
    }
    
    //This method is used to create Article
    public static Contact_Script__kav CreateArticleData(String strTitle, string strURLName)
    {
        Contact_Script__kav objContactScript = new Contact_Script__kav();
        objContactScript.Title = strTitle;
        objContactScript.UrlName = strURLName;
        objContactScript.IsVisibleInCsp = true;
        insert objContactScript;
        
        objContactScript = [SELECT Title, PublishStatus, UrlName, language, KnowledgeArticleId FROM Contact_Script__kav WHERE Id = : objContactScript.Id];
        KbManagement.PublishingService.publishArticle(objContactScript.KnowledgeArticleId, true);
        
        system.assertEquals(objContactScript.Title, strTitle);
        
        return objContactScript;
    } 
    
    //This method is used to create tool
    public static Tool__kav CreateToolData(String strTitle, string strURLName)
    {
        Tool__kav objTool = new Tool__kav();
        objTool.Title = strTitle;
        objTool.UrlName = strURLName;
        objTool.IsVisibleInCsp = true;
        objTool.SH_Is_Show_Notification__c = true;
        objTool.SH_Is_Show_Browser_Notification__c = true;
        objTool.SH_Not_Supported_Browser__c = 'MSIE';
        insert objTool;
        
        objTool = [SELECT Title, PublishStatus, UrlName, language, KnowledgeArticleId FROM Tool__kav WHERE Id = : objTool.Id];
        KbManagement.PublishingService.publishArticle(objTool.KnowledgeArticleId, true);
                
        system.assertEquals(objTool.Title, strTitle);
        
        return objTool;
    }
    
    //This method is used to create custom setting 
    public static void CreateLevelTwoContentOrder(string strName, integer intOrder)
    {
        SH_Level_2_Content_Order__c objLevel = new SH_Level_2_Content_Order__c();
        objLevel.Name = strName;
        objLevel.SH_List_Order__c =  intOrder;
        insert objLevel;
        
        system.assertEquals(objLevel.Name, strName);
    } 
    
    public static void CreateArticleTypeVisiblity(string strName, string strApiName)
    {
        SH_Article_Type_Visibility_In_Community__c objArticleType = new SH_Article_Type_Visibility_In_Community__c();
        objArticleType.Name = strName;
        objArticleType.SH_Api_Name__c =     strApiName;
        insert objArticleType;
        
        system.assertEquals(objArticleType.Name, strName);
    }
    
    public static void CreateCommunitySetting()
    {
        SH_Community_Settings__c  objCommunity = new SH_Community_Settings__c();
        objCommunity.Name = 'Setting-1';
        objCommunity.SH_Mashape_Account_Endpoint_URL__c = 'https://montanaflynn-spellcheck.p.mashape.com/check/?text=';
        objCommunity.SH_Mashape_Account_Key__c = 'ocMnfaM9PQmshWfsUfpKfSXPolVup1QzcS8jsnWWaDgDSNNnn8';
        insert objCommunity;
        
        system.assertEquals(objCommunity.Name, 'Setting-1');
    }
    
    public static Case CreateCase(Id UserId, Id ContactId, string strRecordTypeId)
    {
        Case objCase = new Case();
        objCase.SuppliedEmail = 'prashant.kumar@gmail.com';
        objCase.SuppliedPhone = '1234567890';
        objCase.SuppliedName = 'Test'; 
        objCase.OwnerId = UserId;
        objCase.ContactId = ContactId;
        objCase.Status = 'Open';
        objCase.RecordTypeId = strRecordTypeId;
        objCase.Origin = 'Web';
        objCase.Description = 'test';
        insert objCase;
        
        system.assertEquals(objCase.OwnerId, UserId);
        
        return objCase;   
    } 
    
    public static void CreateCaseComment(Id CaseId)
    {
        CaseComment objCaseComment = new CaseComment();
        objCaseComment.IsPublished = true;
        objCaseComment.ParentId = CaseId;
        objCaseComment.CommentBody = 'test';
        insert objCaseComment;
        
        system.assertEquals(objCaseComment.ParentId,CaseId);
    }
    
    public static void CreateTriggerSetting(string strName, integer intPublishCount)
    {
         SH_Trigger_Settings__c objTS =new SH_Trigger_Settings__c();
         objTS.SH_Is_Active__c=True;
         objTS.Name = strName;
         objTS.SH_Max_Publish_Count__c= intPublishCount;
         insert objTS;
    }    
    
    public static void CreateImageDimension(string strName , integer intHeight, integer intWidth, string strImageType)
    {
        Image_Dimension__c objDimension = new Image_Dimension__c();
        objDimension.Name = strName;
        objDimension.SH_Height__c = intHeight;
        objDimension.SH_Image_Types__c = strImageType;
        objDimension.SH_Width__c = intWidth;
        insert objDimension;
        
        system.assertEquals(objDimension.Name, strName);
    }
    
    public static void CreateHistory(Id UserId, string strArticleId)
    {
        SH_History__c objHistory = new SH_History__c();
        objHistory.SH_Title__c = 'Title';
        objHistory.SH_Summary__c = 'Summary';
        objHistory.Sh_View_Date__c = system.today();
        objHistory.SH_User__c = UserId;
        objHistory.SH_Record_Count__c = 1;
        objHistory.SH_Article_Id__c = strArticleId;
        insert objHistory;
        
        system.assertEquals(objHistory.SH_User__c, UserId);
        
    }
    
    //This method is used to create DraftArticle
    public static Contact_Script__kav CreateDraftArticle(String strTitle, string strURLName)
    {
        Contact_Script__kav objContactScript = new Contact_Script__kav();
        objContactScript.Title = strTitle;
        objContactScript.UrlName = strURLName;
        objContactScript.IsVisibleInCsp = true;
        insert objContactScript;
        
        objContactScript = [SELECT Title, PublishStatus, UrlName, language, KnowledgeArticleId FROM Contact_Script__kav WHERE Id = : objContactScript.Id];
        system.assertEquals(objContactScript.Title, strTitle);
        
        return objContactScript;
    } 
    
    //added on 25-02-2016 for Search Article class
    //This method is used to create Article
    public static Contact_Script__kav CreateArticleData(Contact_Script__kav objContactScript)
    {
        insert objContactScript;
        
        objContactScript = [SELECT Title,ArticleNumber, Summary,PublishStatus, UrlName, language, KnowledgeArticleId FROM Contact_Script__kav WHERE Id = : objContactScript.Id];
        KbManagement.PublishingService.publishArticle(objContactScript.KnowledgeArticleId, true);
        
       return objContactScript;
    } 
    
    //This method is used to create tool
    public static Tool__kav CreateToolData(Tool__kav objTool)
    {
        insert objTool;
        
        objTool = [SELECT Title,ArticleNumber,SH_Is_Show_Notification__c, PublishStatus,Summary, UrlName, language, KnowledgeArticleId FROM Tool__kav WHERE Id = : objTool.Id];
        KbManagement.PublishingService.publishArticle(objTool.KnowledgeArticleId, true);
         
        return objTool;
    }
    
}