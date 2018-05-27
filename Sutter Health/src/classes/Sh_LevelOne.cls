/*
    This class is used to access the information of submenu and articles
    Sharing due to fetch the Article based on access (Role , Profile , Permissionset)
    =====================================================================
    Name                        Date                            Version
    =====================================================================
    Prashant Kumar            7/15/2015                            1.0
    =====================================================================
*/
public with sharing class Sh_LevelOne extends SH_BaseController 
{
    //class level variables
    public String strMenuId {get; set;}
    public String strMenuName {get; set;}
    public String strMenuDescrition {get; set;}
    public string strMenuImgUrl {get; set;}
    //added on 13-Sep-2015 to provide two column layout structure list<subMenuItemListWrapper> lstSubMenuListWrapper
    public list<subMenuItemListWrapper> lstSubMenuListWrapper {get; set;}
    
    public string strActiveMenuId {get; set;}
    public string strActiveSubMenuId {get; set;}
    
    /*
        Constructor is used to Initialise the variables
        ================================================
        Name                Date                version
        ================================================
        Prashant Kumar      7/15/2015            1.0
        ================================================     
        Input Param: None
        =================================================
        Output : None
        =================================================       
    */
    public Sh_LevelOne()
    {
        Initialize();
        BindData();
    }
    
    /*
        This method is used to initialize the variables
        =====================================================================
        Name                        Date                            Version
        =====================================================================
        Prashant Kumar            7/15/2015                            1.0
        =====================================================================
        Input Param: None
        ================================================================
        Output : None
        ================================================================
    */
    public void Initialize() {
        strMenuId = Apexpages.currentpage().getparameters().get('Id');
        strActiveMenuId = Apexpages.currentpage().getparameters().get('Id');
        strActiveSubMenuId = '';
        strMenuName ='';
        strMenuDescrition = '';
        strMenuImgUrl = '';
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        
        //added on 13-Sep-2015 to provide two column layout structure 
        lstSubMenuListWrapper  = new list<subMenuItemListWrapper>();
    }
    
    /*
        This method is used to Bind the submenu data on page
        =====================================================================
        Name                        Date                            Version
        =====================================================================
        Prashant Kumar            7/15/2015                            1.0
        =====================================================================
        Input Param: None
        ================================================================
        Output : None
        ================================================================
    */
    public void BindData() {
        set<String> setOfArticleId = new set<String>();
        
        if(string.isNotBlank(strMenuId )) {
            //added on 13-Sep-2015 to provide two column layout structure 
            list<subMenuWrapper> lstSubMenuWrapper = new list<subMenuWrapper>();
            
            for(KnowledgeArticleVersion objArticle : SH_Common.GetPublishedArticle()) {
                setOfArticleId.add(objArticle.KnowledgeArticleId);
            }
                
            set<string> setToolId = new set<string>();
           
            string strExemptNonExempt = objUser.Contact.Employee_Exempt_non_exempt_Status__c;
            string strSubMenuQuery = 'select id, Name, SH_Menu_Item__r.Name, SH_Menu_Item__r.SH_Description__c, '
                                      +'SH_Menu_Item__r.SH_Function__c, SH_Menu_Item__r.SH_Sub_Function__c, SH_Menu_Item__r.SH_Customer_Intent__c, SH_Menu_Item__r.SH_Team__c, ' 
                                      +'SH_Menu_Item__r.SH_Content_Image_Url__c, '
                                      +'SH_Secondary_Page_Description__c , '
                                      //added on sutter request on 05-Nov-2015 to pass menu name in breadcrumb and pass category subcategory from submenu on article and other link click
                                       +'SH_Function__c,SH_Sub_Function__c,SH_Customer_Intent__c,SH_Team__c, '
                                                +'(select id, SH_Article_Link__c, Name,SH_Content_Type__c, SH_Content_Link__c,SH_Content_Target__c,SH_Listing_Type__c from Level_2_Contents__r ' 
                                                +'where (SH_Article_Link__c in: setOfArticleId or SH_Content_Type__c = \'Other\') and SH_Show_on_Top_links__c = true ' 
                                                + 'and '+(isPreview ? 'SH_Is_Preview__c' : 'SH_Is_Publish__c') + '= true '  
                                                    +'order by SH_Order_of_Display__c asc limit 3) '
                                            +'from SH_Sub_Menu_Item__c where SH_Menu_Item__c =:strMenuId ' 
                                            + (string.isBlank(strExemptNonExempt)? ' ' : 'and SH_Employee_Exempt_non_exempt_Status__c includes (:strExemptNonExempt) ')
                                            + 'and '+ (isPreview ? 'SH_Is_Preview__c' : 'SH_Is_Publish__c') + '= true ' 
                                            +'order by SH_Order_of_Display__c asc';
            list<SH_Sub_Menu_Item__c> lstSubMenu = Database.Query(strSubMenuQuery); 
            if(lstSubMenu.size() <= 0) {
                list<SH_Menu_Item__c> lstMenuItem = [select id, name,SH_Description__c,SH_Content_Image_Url__c,SH_Function__c, SH_Sub_Function__c, SH_Customer_Intent__c, SH_Team__c from SH_Menu_Item__c where id =: strMenuId];
                if(lstMenuItem.size()>0)
                    setMenuItemDetails(lstMenuItem[0].Name, lstMenuItem[0].SH_Description__c, lstMenuItem[0].SH_Content_Image_Url__c, lstMenuItem[0].SH_Function__c, lstMenuItem[0].SH_Sub_Function__c, lstMenuItem[0].SH_Team__c, lstMenuItem[0].SH_Customer_Intent__c);
            }
                
            for(SH_Sub_Menu_Item__c oSubMenuItem : lstSubMenu ) {
                if(string.isBlank(strMenuName)) {
                    setMenuItemDetails(oSubMenuItem.SH_Menu_Item__r.Name, oSubMenuItem.SH_Menu_Item__r.SH_Description__c, oSubMenuItem.SH_Menu_Item__r.SH_Content_Image_Url__c, oSubMenuItem.SH_Menu_Item__r.SH_Function__c, oSubMenuItem.SH_Menu_Item__r.SH_Sub_Function__c, oSubMenuItem.SH_Menu_Item__r.SH_Team__c, oSubMenuItem.SH_Menu_Item__r.SH_Customer_Intent__c);
                }
                
                for(SH_Level_2_Content__c olevel2Content : oSubMenuItem.Level_2_Contents__r) {
                    if(string.isNotBlank(olevel2Content.SH_Content_Type__c) && olevel2Content.SH_Content_Type__c.equalsIgnoreCase('Tool') && string.isNotBlank(olevel2Content.SH_Article_Link__c ))
                        setToolId.add(olevel2Content.SH_Article_Link__c);   
                }
                lstSubMenuWrapper.add(new subMenuWrapper(oSubMenuItem));
            }
            
            setToolsMap(setToolId);
            if(lstSubMenuWrapper.size()>0) {
                //added on 13-Sep-2015 to provide two column layout structure 
                integer counter=0;
                subMenuItemListWrapper osubMenuItemListWrapper;
                for(subMenuWrapper oSubMenuWrapper : lstSubMenuWrapper) {
                    oSubMenuWrapper.lstTopLevel2Content = GetContentWrapper(oSubMenuWrapper.subMenuItem.Level_2_Contents__r, true);
                    
                    //added on 13-Sep-2015 to provide two column layout structure 
                    if(Math.mod(counter, 2)==0 ){
                        osubMenuItemListWrapper = new subMenuItemListWrapper();
                        lstSubMenuListWrapper.add(osubMenuItemListWrapper);
                    }
                    if(osubMenuItemListWrapper != null && osubMenuItemListWrapper.subMenuWrapperList != null)
                        osubMenuItemListWrapper.subMenuWrapperList.add(oSubMenuWrapper);
                    counter ++;
                }
            }
        }
    }
    /*
    This Method is used to set Menu item details
    ================================================================
    Name              Date             version
    ================================================================
    Prashant Kumar            7/15/2015                            1.0
    ================================================================
    Input Param: string strMenuItemName, string strMenuItemDesc, string strMenuItemImgUrl, string strMenuItemCategory, string strMenuItemSubCategory, string strMenuItemTeam, string strMenuItemCustomerIntent
    ================================================================
    Output : None
    ================================================================  
    */
    private void setMenuItemDetails(string strMenuItemName, string strMenuItemDesc, string strMenuItemImgUrl, string strMenuItemCategory, string strMenuItemSubCategory, string strMenuItemTeam, string strMenuItemCustomerIntent) {
        strMenuName = strMenuItemName;
        BreadCrumbs.add(new SH_BreadCrumb(strMenuName , '#'));
        activePgName = strMenuName;
        strL1 = strMenuItemName;
        strL1Id = strMenuId;
         
        strMenuDescrition = strMenuItemDesc;
        strMenuImgUrl = strMenuItemImgUrl;
        strCategoryForHelp = strMenuItemCategory;
        strSubCategoryForHelp = strMenuItemSubCategory; 
        //added on 03-09-2015 for Help and support team and customer intent 
        strTeamForHelp = strMenuItemTeam;
        strCustomerIntentForHelp = strMenuItemCustomerIntent;
    }
    /*
    This is used to wrap subMenuItem and display on Page
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        7/15/2015         1.0
    ================================================================
    */
    public class subMenuWrapper {
        public SH_Sub_Menu_Item__c subMenuItem {get; set;}
        public list<ContentWrapper> lstTopLevel2Content {get;set;}
        
        /*
        Constructor is used to Initialise the variables
        ================================================
        Name                Date                version
        ================================================
        Alok Verma        7/15/2015              1.0
        ================================================     
        Input Param: SH_Sub_Menu_Item__c oSub_Menu
        =================================================
        Output : None
        =================================================       
       */
        public subMenuWrapper (SH_Sub_Menu_Item__c oSub_Menu) {
            subMenuItem = oSub_Menu;
            lstTopLevel2Content = new list<ContentWrapper>();
        }
    }
    
    /*
    This is to provide two column layout structure
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        13-Sep-2015      1.0
    ================================================================
    */
    public class subMenuItemListWrapper {
        public list<subMenuWrapper> subMenuWrapperList {get;set;}
        
        /*
        Constructor is used to Initialise the variables
        ================================================
        Name                Date                version
        ================================================
        Alok Verma        13-Sep-2015      1.0
        ================================================     
        Input Param: None
        =================================================
        Output : None
        =================================================       
       */
        public subMenuItemListWrapper() {
            subMenuWrapperList = new list<subMenuWrapper> ();
        }
    }
}