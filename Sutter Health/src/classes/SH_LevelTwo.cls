/*
    This class is used to show the third level data
    ================================================
    Name                Date                version
    ================================================
    Prashant Kumar    7/16/2015                1.0
    ================================================         
*/
public with sharing class SH_LevelTwo extends SH_BaseController
{
    //Class Level Variables
    public String strSubMenuId {get; set;}
    public SH_Sub_Menu_Item__c objSubMenuItem {get; set;}
    public boolean isShowInsufficientPnl {get;set;}
    //added on 14-Sep-2015 to provide two column layout structure list<contentListWrapper> lstContentListWrapper
    public list<contentListWrapper> lstContentListWrapper {get;set;}
    public list<ContentWrapper> lstContentWithRightImage {get;set;} 
    public list<ContentWrapper> lstContentWithLeftImage {get;set;}
    public list<ContentWrapper> lstContentFullWidth {get;set;}
    
    public string strActiveMenuId {get; set;}
    public string strActiveSubMenuId {get; set;}
    
    //Constructor
    public SH_LevelTwo()
    {
        Initialise();
        BindData();
        getListOrder();
    }
    
    /*
        This method is used to Initialise the variables
        ================================================
        Name                Date                version
        ================================================
        Prashant Kumar    7/16/2015                1.0
        ================================================     
        Input Param: None
        =================================================
        Output : None
        =================================================       
    */
    public void Initialise() {
        //added on 14-Sep-2015 to provide two column layout structure 
        lstContentListWrapper = new list<contentListWrapper> ();
        
        lstContentWithRightImage = new list<ContentWrapper>(); 
        lstContentWithLeftImage = new list<ContentWrapper>();
        lstContentFullWidth = new list<ContentWrapper>();
        
        strSubMenuId = SH_Common.IsNullOrEmptyString(Apexpages.currentpage().getparameters().get('Id')) == false ? Apexpages.currentpage().getparameters().get('Id') : '';
        strActiveSubMenuId = strSubMenuId;
        strActiveMenuId = '';
         
        objSubMenuItem = new SH_Sub_Menu_Item__c();
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        isShowInsufficientPnl = true;
    }
    
    /*
        This method is used to bind the data on page 
        ================================================
        Name                Date                version
        ================================================
        Prashant Kumar    7/16/2015                1.0
        ================================================     
        Input Param: None
        ================================================
        Output : None
        ================================================
    */
    public void BindData() {
        set<String> setOfArticleId = new set<String>();
        set<String> setOfToolId = new set<String>();
        if(string.isNotBlank(strSubMenuId))  {
            for(KnowledgeArticleVersion objArticle : SH_Common.GetPublishedArticle()) {
                setOfArticleId.add(objArticle.KnowledgeArticleId);
            }
            
            list<SH_Sub_Menu_Item__c> lstSubMenuItem = isPreview ? [Select id, SH_Menu_Item__c, SH_Menu_Item__r.name, SH_Function__c, SH_Sub_Function__c, SH_Menu_Item__r.ID, Name, SH_Secondary_Page_Description__c,
                                                                         SH_Customer_Intent__c, SH_Team__c, 
                                                                        (Select id, Name, SH_Description__c, SH_Order_of_Display__c, SH_Article_Link__c
                                                                        ,SH_Background_Class__c, SH_Listing_Type__c, SH_Content_Image_Url__c, SH_Content_Type__c
                                                                        ,SH_Content_Link__c,SH_Content_Target__c 
                                                                        from Level_2_Contents__r where SH_Is_Preview__c = true 
                                                                        AND (SH_Article_Link__c in: setOfArticleId or SH_Content_Type__c = 'Other') 
                                                                        order by SH_Order_of_Display__c asc limit 999 ) 
                                                                     from SH_Sub_Menu_Item__c where id =: strSubMenuId 
                                                                     and SH_Is_Preview__c = true order by SH_Order_of_Display__c asc]:
                                                                    [Select id, SH_Menu_Item__r.name,SH_Function__c, SH_Sub_Function__c, SH_Menu_Item__r.ID, Name, SH_Secondary_Page_Description__c,
                                                                        SH_Customer_Intent__c, SH_Team__c,
                                                                        (Select id, Name, SH_Description__c, SH_Order_of_Display__c, SH_Article_Link__c
                                                                        ,SH_Background_Class__c, Sh_Listing_Type__c, SH_Content_Image_Url__c,SH_Content_Type__c
                                                                        ,SH_Content_Link__c,SH_Content_Target__c 
                                                                         from Level_2_Contents__r where SH_Is_Publish__c = true 
                                                                         AND (SH_Article_Link__c in: setOfArticleId or SH_Content_Type__c = 'Other') 
                                                                         order by SH_Order_of_Display__c asc  limit 999) 
                                                                     from SH_Sub_Menu_Item__c where id =: strSubMenuId
                                                                     and SH_Is_Publish__c = true order by SH_Order_of_Display__c asc];
           
           if(lstSubMenuItem != null && lstSubMenuItem.size() > 0) {
                objSubMenuItem = lstSubMenuItem[0];
                                
                //Get Tool id and fetch the notification data from tool type object
                if(objSubMenuItem.Level_2_Contents__r != null && objSubMenuItem.Level_2_Contents__r.size() > 0) {
                    for(SH_Level_2_Content__c objTempLevelTwoContent : objSubMenuItem.Level_2_Contents__r) {
                        if(string.isNotBlank(objTempLevelTwoContent.SH_Content_Type__c ) && objTempLevelTwoContent.SH_Content_Type__c.equalsIgnoreCase('Tool') && string.isNotBlank(objTempLevelTwoContent.SH_Article_Link__c))
                            setOfToolId.add(objTempLevelTwoContent.SH_Article_Link__c);      
                    }
                    setToolsMap(setOfToolId);
                    list<ContentWrapper> lstContent = GetContentWrapper(objSubMenuItem.Level_2_Contents__r, true); 
                    if(lstContent != null && lstContent.size()>0 ) {
                        isShowInsufficientPnl = false;
                        
                        //added on 14-Sep-2015 to provide two column layout structure 
                        integer counter=0;
                        ContentListWrapper oContentListWrapper;
                        for(ContentWrapper oContentWrapper : lstContent) {
                            if(string.isNotBlank(oContentWrapper.strListingType)) {
                                if(oContentWrapper.strListingType.equalsIgnoreCase('Two Column Layout')) {
                                    if(Math.mod(counter, 2)==0 ){
                                        oContentListWrapper = new ContentListWrapper();
                                        lstContentListWrapper.add(oContentListWrapper);
                                    }
                                    if(oContentListWrapper != null && oContentListWrapper.ContentWrapperList != null) {
                                        oContentListWrapper.ContentWrapperList.add(oContentWrapper);
                                    }
                                    counter ++;
                                }
                                else if(oContentWrapper.strListingType.equalsIgnoreCase('Simple List View (Full Width)')) {
                                    lstContentFullWidth.add(oContentWrapper);
                                }
                                else if(oContentWrapper.strListingType.equalsIgnoreCase('List With Left Image')) {
                                    lstContentWithLeftImage.add(oContentWrapper);
                                }
                                else if(oContentWrapper.strListingType.equalsIgnoreCase('List With Right Image')) {
                                    lstContentWithRightImage.add(oContentWrapper);
                                }
                            }
                        }
                    }
                }
                
                BreadCrumbs.add(new SH_BreadCrumb(objSubMenuItem.SH_Menu_Item__r.name , 'Sh_LevelOne?id='+objSubMenuItem.SH_Menu_Item__r.ID));
                BreadCrumbs.add(new SH_BreadCrumb(objSubMenuItem.name , '#'));
                activePgName = objSubMenuItem.name;
                
                strL1 = objSubMenuItem.SH_Menu_Item__r.name;
                strL1Id = objSubMenuItem.SH_Menu_Item__c;
                strActiveMenuId = strL1Id; 
                strL2 = objSubMenuItem.name;
                strL2Id = objSubMenuItem.Id;
                
                strCategoryForHelp = objSubMenuItem.SH_Function__c;
                strSubCategoryForHelp = objSubMenuItem.SH_Sub_Function__c;
                //added on 03-09-2015 for Help and support team and customer intent 
                strTeamForHelp = objSubMenuItem.SH_Team__c;
                strCustomerIntentForHelp = objSubMenuItem.SH_Customer_Intent__c;
                
            }                                            
        }
    }
    
    /*
        This method is used to get portal level 2 listing order from custom settings 
        ============================================================================
        Name                    Date                    version
        ============================================================================
        Rishabh Pilani          8/05/2015                1.0
        ============================================================================ 
        Input Param: None
        ============================================================================
        Output : List<ListOrder>
        ============================================================================    
    */
    public List<ListOrder> getListOrder(){
        List<ListOrder> lstOrder = new List<ListOrder>();
        Map<string, SH_Level_2_Content_Order__c> allRecords = SH_Level_2_Content_Order__c.getAll();        
        for(SH_Level_2_Content_Order__c obj:allRecords.values()){
            lstOrder.add(new ListOrder(obj));
        }
        lstOrder.sort();
        return lstOrder;
    }
    
    /*
        This class is used for sorting the list order.
        ================================================
        Name                Date                version
        ================================================
        Rishabh Pilani    8/05/2015                1.0
        ================================================         
    */
    public class ListOrder implements Comparable
    {
        public string ListName {get; set;}
        public Decimal ListOrder {get; set;}
        
        public ListOrder(SH_Level_2_Content_Order__c obj)
        {
            ListName = obj.Name;
            ListOrder = obj.SH_List_Order__c;
        }
        
        public Integer compareTo(Object compareTo) 
        {
            ListOrder compareToList = (ListOrder)compareTo;
            if (ListOrder == compareToList.ListOrder) return 0;
            if (ListOrder > compareToList.ListOrder) return 1;
            return -1;  
        }
    }

    /*
        This class is to provide two column layout structure.
        ======================================================
        Name                Date                version
        ======================================================
        Alok Verma          14-Sep-2015         1.0
        ======================================================   
    */
    public class ContentListWrapper {
        public list<ContentWrapper> ContentWrapperList {get;set;}
        public ContentListWrapper() {
            contentWrapperList = new list<ContentWrapper> ();
        }
    }
}