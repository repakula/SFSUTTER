/*
    This class is used to store all the common data for its child classes
    ================================================================
    Name                       Date                       version
    ================================================================
    Alok Verma                9/25/2015                     1.0
    ================================================================
*/
public virtual class SH_BaseController 
{
    //class level variables
    public User objUser {get; set;}
    public list<SH_BreadCrumb> BreadCrumbs {get; set;}
    public string activePgName {get; set;}
    public Boolean isPreview{get; set;}
    public list<SH_Menu_Item__c> lstMenuItem {get; set;}
    public boolean IsCommunity {get; set;}
    public SH_Help_and_Support__c objHelp {get; set;}
    public string strCategoryForHelp {get; set;}
    public string strSubCategoryForHelp {get; set;}
    public string imgBaseUrl {get;set;}
    public string strTitle {get; set;}
    public string strDescription {get; set;}
    public string strInfo {get; set;}
    public string strBrowserTitle {get; set;}
    public string strBrowserDescription {get; set;}
    public string strBrowserInfo {get; set;}
    public map<Id,Tool__kav> mapOfToolKav {get; set;}
    public boolean IsBrowser {get; set;}
    public boolean IsNotify {get; set;} 
    public boolean IsShowTwoColumnLayout {get; set;}
    
    //added on 25-Aug-2015 for Notification
    public static final string strPgName = SH_Common.getCurrentPageName();
    public string strToolArticeId {get; set;}
    public map<string,string> mapUrlParam {get; set;}
    
    //added on 03-09-2015 for Help and support team and customer intent 
    public string strTeamForHelp {get; set;}
    public string strCustomerIntentForHelp {get; set;}
    
    //added on 17-09-2015 for Help and support team 
    public string strL1 {get; set;}
    public string strL1Id {get; set;}
    public string strL2 {get; set;}
    public string strL2Id {get; set;}
    
    public string browserName{get; set;}
    
    //added on 21-Sep-2015 by Saasfocus to redirect on last visited link strCancelLink 
    public string strCancelLink {get;set;}
    
    /*
        This is the constructor of base class
        ================================================================
        Name                       Date                       version
        ================================================================
        Alok Verma                9/25/2015                     1.0
        ================================================================
        Param : none
        ================================================================
        Output : none
        ================================================================    
    */
    public SH_BaseController()
    {
        IsShowTwoColumnLayout = false;
        mapOfToolKav = new map<Id,Tool__kav>();
        
        //Get is preview
        isPreview = ApexPages.currentPage().getParameters().get('cmd')==null ? false : true;
        
        GetUserData();
        GetMenuItem();
        
        if(objUser != null ) {
            IsCommunity = string.IsBlank(objUser.ContactID) ? false : true;
        }
        imgBaseUrl = IsCommunity ? '' : '/';
        objHelp = SH_Help_and_Support__c.getValues('Default');
        
        //added on 25-Aug-2015 for Notification
        mapUrlParam = Apexpages.currentPage().getParameters();
        strToolArticeId = '';
        browserName = '';
    }
    
    /*
        This method is used to get current loged in user data
        ================================================================
        Name                       Date                       version
        ================================================================
        Alok Verma                9/25/2015                     1.0
        ================================================================
        Param : none
        ================================================================
        Output : none
        ================================================================    
    */
    private void GetUserData()
    {
        list<User> lstUser = [select Id, ContactID, Contact.Employee_Region__c, Contact.Employee_EEO_SubCode__c,Contact.Employee_Exempt_non_exempt_Status__c, Contact.Employee_Exempt_nonexempt_Status__c, Contact.Email, Contact.Phone, Contact.Name from User where Id =: Userinfo.getUserId()];
        objUser = lstUser[0];
    }
    
    /*
        This method get Menu Item
        ================================================================
        Name                       Date                       version
        ================================================================
        Alok Verma                9/25/2015                     1.0
        ================================================================
        Param : none
        ================================================================
        Output : none
        ================================================================    
    */
    private void GetMenuItem()
    {
        lstMenuItem = SH_Common.GetMenuSubMenuItems(isPreview, objUser.Contact.Employee_EEO_SubCode__c, objUser.Contact.Employee_Exempt_non_exempt_Status__c);
    }  
    
    /*
        This method is used to redirect the guest user to login page
        ================================================================
        Name                       Date                       version
        ================================================================
        Alok Verma                9/25/2015                     1.0
        ================================================================
        Param : none
        ================================================================
        Output : pagereference
        ================================================================    
    */
    public PageReference forwardToLoginPage() {
        if(string.isNotBlank(UserInfo.getUserType()) && UserInfo.getUserType().equalsIgnoreCase('Guest')){
            return new PageReference('/SH_Login');
        }
        else{
            return null;
        }
    }
    
    /*
        This method is used for Article, Tool and Other content link starts
        ================================================================
        Name                       Date                       version
        ================================================================
        Alok Verma                9/25/2015                     1.0
        ================================================================
        Param : set
        ================================================================
        Output : none
        ================================================================    
    */
    public void setToolsMap(set<string> setOfToolId) {
         if(setOfToolId != null && setOfToolId.size() > 0) {
            for(Tool__kav objTool : [Select SH_Tool_Link__c, SH_Notification_Title__c, SH_Notification_Description__c, SH_Not_Supported_Browser__c, 
                                                                SH_More_Information_Link__c, SH_Is_Show_Notification__c, SH_Browser_Notification_Title__c, 
                                                                SH_Browser_Notification_Info_Link__c, SH_Browser_Notification_Description__c, PublishStatus, 
                                                                OwnerId, KnowledgeArticleId, SH_Is_Show_Browser_Notification__c 
                                                                From Tool__kav where KnowledgeArticleId in : setOfToolId and PublishStatus = 'Online']) {
                mapOfToolKav.put(objTool.KnowledgeArticleId, objTool);
            } 
        }
    }
    
    /*
        This method is used to get list of content wrapper for notification
        ================================================================
        Name                       Date                       version
        ================================================================
        Alok Verma                9/25/2015                     1.0
        ================================================================
        Param : list<sObject> , boolean 
        ================================================================
        Output : list<ContentWrapper>
        ================================================================    
    */
    public list<ContentWrapper> GetContentWrapper(list<sObject> lstSobject, boolean isLevel2Content) {
        list<ContentWrapper> lstContentWrapper = new list<ContentWrapper>();
        if(lstSobject == null || (lstSobject != null && lstSobject.size()<=0)) return lstContentWrapper;
        for(sObject oSobj : lstSobject) {
            ContentWrapper oContentWrapper = new ContentWrapper();
            oContentWrapper.objSObject = oSobj;
            if(!string.IsBlank((string)oSobj.get('SH_Content_Target__c')))
                oContentWrapper.target = (string)oSobj.get('SH_Content_Target__c');
            
            if(isLevel2Content) {
                oContentWrapper.strListingType = (string)oSobj.get('Sh_Listing_Type__c');
                
                if(oContentWrapper.strListingType != null && oContentWrapper.strListingType.equalsIgnoreCase('Two Column Layout'))
                    IsShowTwoColumnLayout = true;
            }
                
            oContentWrapper.contentType = (string)oSobj.get('SH_Content_Type__c');
            string strArticleToolLink = (string)oSobj.get('SH_Article_Link__c');
            
            if(!string.IsBlank(oContentWrapper.contentType)) {
                if(oContentWrapper.contentType.equalsIgnoreCase('Article')) {
                    oContentWrapper.link = 'SH_ArticleView?id='+ (string.IsBlank(strArticleToolLink) ? '#': strArticleToolLink);
                }
                else if(oContentWrapper.contentType.equalsIgnoreCase('Other')) {
                    string strContentLink = (string)oSobj.get('SH_Content_Link__c');
                    oContentWrapper.link = (string.IsBlank(strContentLink) ? '#': strContentLink);
                }
                else if(oContentWrapper.contentType.equalsIgnoreCase('Tool')) {
                    if(string.IsBlank(strArticleToolLink))
                        oContentWrapper.link = '#';
                    else {
                        Tool__kav objTool = (mapOfToolKav == null ? null : mapOfToolKav.get(strArticleToolLink)); 
                        if(objTool != null) {
                            //changed on 13-Sep-2015 for Notification
                            if(objTool.SH_Is_Show_Notification__c || objTool.SH_Is_Show_Browser_Notification__c) {
                                //oContentWrapper.link = 'javascript:SetNotification('\'+ strArticleToolLink + '\);';
                                //changed on 13-Sep-2015 for Notification
                                oContentWrapper.link = 'javascript:CheckNotifications('+ Json.Serialize(objTool) + ');';
                            }
                            else{
                                //changed on 13-Sep-2015 for Notification
                                //oContentWrapper.link = 'javascript:ShowBrNotification(\''+ strArticleToolLink + '\' , \'' + (string.IsBlank(objTool.SH_Tool_Link__c) ? '#' : objTool.SH_Tool_Link__c) + '\' , \'' + objTool.SH_Not_Supported_Browser__c + '\' , \'' +(string.IsBlank(objTool.SH_Tool_Link__c) ? '_self' : oContentWrapper.target) + '\');';
                                oContentWrapper.link = 'javascript:RedirectLink(\''+ (string.IsBlank(objTool.SH_Tool_Link__c) ? '#' : objTool.SH_Tool_Link__c) + '\' ,  \'' +(string.IsBlank(objTool.SH_Tool_Link__c) ? '_self' : '_blank') + '\');';
                            }
                        }   
                    }
                }         
            }
            lstContentWrapper.add(oContentWrapper);
        }
        return lstContentWrapper;
    }
    
    /*
        COntent Wrapper
        ================================================================
        Name                       Date                       version
        ================================================================
        Alok Verma                9/25/2015                     1.0
        ================================================================
    */
    public class ContentWrapper {
        public Sobject objSObject {get; set;}
        public string link {get; set;}
        public string target {get;set;}
        public string contentType {get;set;}
        public string strListingType {get;set;} //used for Level 2 Content only
        
        public ContentWrapper() {
            link = '';
            target = '_self';//default target
            contentType = '';
            strListingType = '';
        }
    }
    
    /*
        Wrapper class used to show Notification on Pages
        ================================================================
        Name                       Date                       version
        ================================================================
        Alok Verma                9/25/2015                     1.0
        ================================================================
        Param : none 
        ================================================================
        Output : none
        ================================================================    
    */
     public void showNotification() {
         IsBrowser = false; 
         IsNotify = false;
         if(string.isBlank(strToolArticeId))
            return ;
                
        if(!mapOfToolKav.containsKey(strToolArticeId ))
            setToolsMap(new set<string>{strToolArticeId });
            
        Tool__kav oTool = mapOfToolKav.get(strToolArticeId);
        if(oTool != null) {
            if(oTool.SH_Is_Show_Notification__c == true) {
                strTitle = oTool.SH_Notification_Title__c;
                strDescription = oTool.SH_Notification_Description__c;
                strInfo = oTool.SH_More_Information_Link__c;
                IsNotify = true;
            }
            
            if(oTool.SH_Is_Show_Browser_Notification__c == true && string.isNotBlank(browserName) && string.isNotBlank(oTool.SH_Not_Supported_Browser__c) && oTool.SH_Not_Supported_Browser__c.ContainsIgnoreCase(browserName)) {
                strBrowserTitle = oTool.SH_Browser_Notification_Title__c;
                strBrowserDescription = oTool.SH_Browser_Notification_Description__c;
                strBrowserInfo = oTool.SH_Browser_Notification_Info_Link__c;
                IsBrowser = true;
            }
        }
    }
    
    /*
        This method is used to set the bread crump values
        ================================================================
        Name                       Date                       version
        ================================================================
        Alok Verma                9/25/2015                     1.0
        ================================================================
        Param : none 
        ================================================================
        Output : none
        ================================================================    
    */
    public void setBreadCrumbs() {
        if(BreadCrumbs != null) {
            string strLOne = Apexpages.currentPage().getParameters().get('L1');
            string strLOneId = Apexpages.currentPage().getParameters().get('L1Id');
            string strLTwo = Apexpages.currentPage().getParameters().get('L2');
            string strLTwoId = Apexpages.currentPage().getParameters().get('L2Id');
            string isHelp = Apexpages.currentPage().getParameters().get('isHelp');
            string strM = Apexpages.currentPage().getParameters().get('M');
            string strSM = Apexpages.currentPage().getParameters().get('SM');
            string strT = Apexpages.currentPage().getParameters().get('T');
            string strCI = Apexpages.currentPage().getParameters().get('CI');
            string strC = Apexpages.currentPage().getParameters().get('C');
            string IsCase = Apexpages.currentPage().getParameters().get('IsCase');
            string IsHistory = Apexpages.currentPage().getParameters().get('H');
            string IsSearch = Apexpages.currentPage().getParameters().get('IsSearch');
            string strSearch = Apexpages.currentPage().getParameters().get('q');
            
            strCategoryForHelp = strM;
            strSubCategoryForHelp = strSM;
            strTeamForHelp = strT;
            strCustomerIntentForHelp = strCI;
            strL1 = strLOne;
            strL1Id = strLOneId;
            strL2 = strLTwo;
            strL2Id = strLTwoId;
                
            if(string.isNotBlank(strLOne) && string.isNotBlank(strLOneId))
                BreadCrumbs.add(new SH_BreadCrumb(strLOne, 'SH_LevelOne?id=' + strLOneId));
            
            if(string.isNotBlank(strLTwo ) && string.isNotBlank(strLTwoId ))
                BreadCrumbs.add(new SH_BreadCrumb(strLTwo , 'SH_LevelTwo?id=' + strLTwoId ));
            
            if(string.isNotBlank(isHelp) && isHelp.equalsIgnoreCase('true')) {
                
                string params = '?M=' + SH_Common.getUrlEncodedValue(strM)
                                +SH_Common.getUrlFormParam('SM', strSM)
                                +SH_Common.getUrlFormParam('T', strT)
                                +SH_Common.getUrlFormParam('CI', strCI)
                                +SH_Common.getUrlFormParam('L1', strLOne)
                                +SH_Common.getUrlFormParam('L1Id', strLOneId)
                                +SH_Common.getUrlFormParam('L2', strLTwo)
                                +SH_Common.getUrlFormParam('L2Id', strLTwoId);
                BreadCrumbs.add(new SH_BreadCrumb('Help' , 'SH_Help_Support'+params));
                
                if(string.isNotBlank(IsCase) && IsCase.equalsIgnoreCase('true'))
                {
                    params += SH_Common.getUrlFormParam('C', strC);
                    BreadCrumbs.add(new SH_BreadCrumb('Service Request' , 'SH_MyCases' + params + '&isHelp=true'));
                }
            }
            
            if(string.isNotBlank(IsHistory) && IsHistory.equalsIgnoreCase('true'))
            {
                BreadCrumbs.add(new SH_BreadCrumb('History' , 'SH_History'));
            }
            
            if(string.isNotBlank(IsSearch) && IsSearch.equalsIgnoreCase('true'))
            {
                BreadCrumbs.add(new SH_BreadCrumb('Search' , 'sh_searchresult?q=' + strSearch));
            }
        }
        
    }
}