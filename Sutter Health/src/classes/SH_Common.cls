/*
    This class is used for Common Functionality used in Community site
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Alok Verma        7/14/2015                        1.0
    ==========================================================  
*/
public with sharing class SH_Common {

    /*
        This method is called from each page and return Menu, subMenu items 
        for Left menu Panel
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: boolean isPreview , string strEmployeeCode, string strExemptNonExempt
        ===================================================================
        Output : list<SH_Menu_Item__c>
        ================================================================  
    */
    public static list<SH_Menu_Item__c> GetMenuSubMenuItems(boolean isPreview , string strEmployeeCode, string strExemptNonExempt) 
    {
         string strMenuSubMenuQuery = 'select Id, Name, SH_Icon__c, SH_Function__c, SH_Sub_Function__c,'
                                        +'(select id , Name, SH_Function__c, SH_Sub_Function__c from Sub_Menu_Items__r where '
                                        + (isPreview ? 'SH_Is_Preview__c' : 'SH_Is_Publish__c') + '= true '
                                        + (string.isBlank(strExemptNonExempt)? ' ' : 'and SH_Employee_Exempt_non_exempt_Status__c includes (:strExemptNonExempt) ')
                                        +'order by SH_Order_of_Display__c asc) '     
                                     +'from SH_Menu_Item__c '
                                     +'where ' + (isPreview ? 'SH_Is_Preview__c' : 'SH_Is_Publish__c') + ' = true '
                                     + (string.isBlank(strEmployeeCode)? ' ' : 'and SH_Employee_EEO_subcode__c includes (:strEmployeeCode) ')
                                     +'order by SH_Order_of_Display__c asc';
                         
         return Database.Query(strMenuSubMenuQuery);   
    }
     
    /*
        This method is used to fetch published Article
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: none
        ===================================================================
        Output : list<KnowledgeArticleVersion>
        ================================================================  
    */
    public static list<KnowledgeArticleVersion> GetPublishedArticle()
    {
        //Get Articles
        return [Select ArticleNumber, Id, UrlName, Title, Summary, KnowledgeArticleId, IsVisibleInPrm, IsVisibleInPkb, IsVisibleInCsp, IsLatestVersion 
                From KnowledgeArticleVersion where (PublishStatus = 'online'  AND language ='en_US')];
    }
    
    /*
        This method is used to return the published version of the article
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: string articleId
        ===================================================================
        Output : KnowledgeArticleVersion
        ================================================================  
    */ 
    public static KnowledgeArticleVersion FetchPublishedArticleData(string articleId) {
        if(!string.isBlank(articleId)) {
            list<KnowledgeArticleVersion> lstKnowledgeArticleVersion = [Select ArticleNumber, Id, UrlName, Title, Summary, KnowledgeArticleId 
                From KnowledgeArticleVersion where (PublishStatus = 'online'  AND language ='en_US') and KnowledgeArticleId =:articleId];
                
            if(lstKnowledgeArticleVersion.size()>0)
                return lstKnowledgeArticleVersion[0];
        }
        return null;
    } 
    
    ///////////////////////////////////////////Generic Methods//////////////////////////////////////////////////////
    
    
    /*
        This method is used to find object name based on provided record ID prefix.
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: String recordIdOrPrefix, Map<String, Schema.SObjectType> gd
        ===================================================================
        Output :  string (object Name)
        ================================================================  
    */
    public static string findObjectNameFromRecordIdPrefix(String recordIdOrPrefix, Map<String, Schema.SObjectType> gd){
        string sObjectAPIName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            if(String.valueOf(recordIdOrPrefix).length()<3 || gd == null) return null;
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    sObjectAPIName = r.getName();
                    break;
                }
            }
        }catch(Exception e){
        }
        return sObjectAPIName;
    }
    
    /*
        This method is used to get the record type id based on object name and record type name
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: string objectAPIName, string recordTypeName
        ===================================================================
        Output :  Id (Record Type Id)
        ================================================================  
    */   
    public static id GetRecordTypeId(string objectAPIName, string recordTypeName)
    {
        if(IsNullOrEmptyString(objectAPIName) || IsNullOrEmptyString(recordTypeName)){
            return null;
        }
        //Get schema information
        Map<String, Schema.SObjectType> globalDescription =  Schema.getGlobalDescribe();
        Schema.SObjectType sObjType = globalDescription.get(objectAPIName);  
        Schema.DescribeSObjectResult cfrSchema = sObjType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id recordTypeId = RecordTypeInfo.get(recordTypeName).getRecordTypeId();
        return recordTypeId;
    }
    
    /*
        This method is used to check empty string
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: string strInput
        ===================================================================
        Output :  boolean
        ================================================================  
    */
    public static boolean IsNullOrEmptyString(string strInput)
    {
        if(string.isBlank(strInput)){
            return true;
        }
        return false;
    } 
    
    /*
        This method is used to get all Knowledge Article Objects.
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: none
        ===================================================================
        Output :  List<String>
        ================================================================  
    */
    public static List<String> GetKnowledgeArticleObjects(){
        List<String> lstSOT = new List<String>();
        Map<string, SH_Article_Type_Visibility_In_Community__c> allRecords = SH_Article_Type_Visibility_In_Community__c.getAll();        
        if(allRecords != null){
            Map<String, Schema.SObjectType> schemaMap =  Schema.getGlobalDescribe();
            for(SH_Article_Type_Visibility_In_Community__c obj:allRecords.values())
            {
                if(schemaMap.get(obj.SH_Api_Name__c) != null)
                {
                    lstSOT.add(obj.SH_Api_Name__c);
                }
            }        
        }
        /*List<Schema.SObjectType> lstSOT = new List<Schema.SObjectType>();
        for(Schema.SObjectType f : Schema.getGlobalDescribe().Values())
        {
            if(f.getDescribe().getName().endswith('__kav'))
                lstSOT.add(f);          
        }*/
        return lstSOT;
    }

    /*
        This method is used to get Knowledge Article Objects label.
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: none
        ===================================================================
        Output :  List<SelectOption>
        ================================================================  
    */
    public static List<SelectOption> getKnowledgeArticleObjectsLabels(){
        List<SelectOption> options = new List<SelectOption>();
        Map<string, SH_Article_Type_Visibility_In_Community__c> allRecords = SH_Article_Type_Visibility_In_Community__c.getAll();        
        if(allRecords != null){
            Map<String, Schema.SObjectType> schemaMap =  Schema.getGlobalDescribe();
            for(SH_Article_Type_Visibility_In_Community__c obj:allRecords.values()){
                if(schemaMap.get(obj.SH_Api_Name__c) != null){
                    options.add(new SelectOption(obj.SH_Api_Name__c, obj.Name));
                }
            }        
        }
        /*for(Schema.SObjectType f : Schema.getGlobalDescribe().Values())
        {
            if(f.getDescribe().getName().endswith('__kav'))
                options.add(new SelectOption(f.getDescribe().getName(), f.getDescribe().getLabel()));           
        }*/
        return options;
    }
    
   /*
        This method is used to split SObjectType list to sub-lists.
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: List<String> parentList, integer subListSize
        ===================================================================
        Output :  List<List<String>>
        ================================================================  
    */
    public static List<List<String>> SplitSObjectTypeListToSubLists(List<String> parentList, integer subListSize) 
    {
        List<List<String>> subLists = new List<List<String>>();
        
        if (subListSize > parentList.size()) 
        {
            subLists.add(parentList);
        } 
        else 
        {
            integer remainingElements = parentList.size();
            integer startIndex = 0;
            integer endIndex = subListSize;
            
            do 
            {
                List<String> subList = new List<String>();
                
                for(integer i = startIndex; i < endIndex; i++)
                {
                    subList.add(parentList[i]);
                }               
                subLists.add(subList);
                startIndex = endIndex;
                
                if (remainingElements - subListSize >= subListSize) {
                    endIndex = startIndex + subListSize;
                } else {
                    endIndex = startIndex + remainingElements - subList.size();
                }
                remainingElements -= subList.size();
            } while (remainingElements > 0);
        }
        return subLists;
    }
    
    /*
        This method is used for spell-check and suggustions
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: String text
        ===================================================================
        Output :  SpellChecker
        ================================================================  
    */
    public static SpellChecker Spellcheck(String text){
        try{            
            String strBaseURL = '';
            String strAppKey = '';
            Map<string, SH_Community_Settings__c> allRecords = SH_Community_Settings__c.getAll();        
            for(SH_Community_Settings__c obj:allRecords.values()){
                strBaseURL = obj.SH_Mashape_Account_Endpoint_URL__c;
                strAppKey = obj.SH_Mashape_Account_Key__c;
                break;
            }
            if(strBaseURL != '' && strAppKey != ''){
                HttpRequest req = new HttpRequest();
                req.setEndpoint(strBaseURL + text);
                req.setMethod('GET');
                req.setHeader('X-Mashape-Key', strAppKey);  
                req.setHeader('Accept', 'application/json'); 
                Http http = new Http();
                HTTPResponse res;
                
                if(!Test.isRunningTest())
                {
                    res = http.send(req);              
                    return parse(res.getBody());
                }
                else
                {
                    string strBody = '{ "original": "Nok", "suggestion": "health", "corrections": { "helth": [ "health", "heath", "Ethel", "helot", "helmet", "bethel", "held", "hell" ] } }';
                    return parse(strBody);
                }
            }
        }catch(Exception e){}
        return null;
    }
    
    //Spell Checker wrapper
    public class SpellChecker {
        public String original {get; set;}
        public String suggestion {get; set;}
        public List<String> corrections {get; set;}
    }
    
    /*
        This method parse the json string
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: String jsonstring
        ===================================================================
        Output :  SpellChecker
        ================================================================  
    */
    public static SpellChecker parse(String jsonstring) {
        Map<String,Object> m = (Map<String,Object>)JSON.deserializeUntyped(jsonstring);
        SpellChecker sc = new SpellChecker();
        sc.original = string.valueof(m.get('original'));
        sc.suggestion = string.valueof(m.get('suggestion'));
        Map<String,Object> corr = (Map<String, Object>)m.get('corrections');        
        String strCorrections = string.valueof(corr.get(string.valueof(m.get('original'))));        
        strCorrections = strCorrections.replace('(','');    
        strCorrections = strCorrections.replace(')','');
        if(strCorrections != '')
        {
            sc.corrections = new List<String>();
            String[] strArray = strCorrections.split(',');
            for(string s : strArray){
                sc.corrections.add(s.trim());
            }
        }
        return sc;
    }
    
    /*
        This method is used to return the Article Rating
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: set<ID> setArticleId
        ===================================================================
        Output :  map<ID,Decimal>
        ================================================================  
    */
    public static map<ID,Decimal> GetArticleRatings(set<ID> setArticleId) {
        map<ID,Decimal> mapArticleIdToScore = new map<ID,Decimal>();
        if(setArticleId != null && setArticleId.size()>0) {
            for(KnowledgeArticleVoteStat oKnowledgeArticleVoteStat : [select NormalizedScore, ParentId from KnowledgeArticleVoteStat where ParentId in: setArticleId and channel='Csp']) {
                mapArticleIdToScore.put(oKnowledgeArticleVoteStat.ParentId, oKnowledgeArticleVoteStat.NormalizedScore);
            }
        }
        return mapArticleIdToScore;
    }
    
    /*
        This method is used to get Url Encode Vaues
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: string strParamValue
        ===================================================================
        Output :  string
        ================================================================  
    */
    public static string getUrlEncodedValue(string strParamValue) {
        return string.isBlank(strParamValue) ?  '' : EncodingUtil.urlEncode(strParamValue, 'UTF-8');
    }
    
    /*
        This method is used to get current page name
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: none
        ===================================================================
        Output :  string
        ================================================================  
    */
    public static string getCurrentPageName() {
        string pgname ='';
        string currentUrl = Apexpages.currentPage().getUrl() != null ? Apexpages.currentPage().getUrl() : '';
        
        if(currentUrl.contains('apex'))
            currentUrl = currentUrl.replace('/apex/', '');
            
        if(currentUrl.indexOf('?') >0)
            pgname  = currentUrl.substring(0,currentUrl.indexOf('?'));
        
        return pgname ;
    }
    
    /*
        This method is used to compare two strings casesensitive way
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: string strS1, string strS2
        ===================================================================
        Output :  boolean
        ================================================================  
    */
    public static boolean equals(string strS1, string strS2) {
        if(string.isBlank(strS1)) {
            if(string.isNotBlank(strS2))
                return false;
            else 
                return true;
        }
        else {
            return strS1.equals(strS2);
        }   
    }
    
    /*
        This method is used to get url param string
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: none
        ===================================================================
        Output :  string
        ================================================================  
    */
    public static string getUrlParamString() {
        string strUrlParamString = '' ;
        map<string,string> mapUrlParam =Apexpages.currentPage().getParameters();
        if(mapUrlParam != null && mapUrlParam.size()>0) {
            for(string strKey : mapUrlParam.keySet()) {
                strUrlParamString += getUrlFormParam(strKey, mapUrlParam.get(strKey));
            }
        }
        return strUrlParamString;
    }
    
    /*
        This method is used to get url form param
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: string strkey, string strValue
        ===================================================================
        Output :  string
        ================================================================  
    */
    public static string getUrlFormParam(string strkey, string strValue) {
        return string.IsNotBlank(strValue)? ('&'+SH_Common.getUrlEncodedValue(strkey)+'='+ SH_Common.getUrlEncodedValue(strValue)) : '';
    }
    
    /*
        This method is used to get url form param
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: string strkey, string strValue
        ===================================================================
        Output :  string
        ================================================================  
    */
    public static string getSF15DigitId(string strId) {
        if(string.isNotBlank(strId) && (strId.length()== 15 || strId.length()== 18)) {
            return strId.substring(0,15);
        }
        return null;
    }
    
    /*
        This method is used to cancel the form
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: list<SH_BreadCrumb> lstBreadCrumbs
        ===================================================================
        Output :  string
        ================================================================  
    */
    public static string CancelForm(list<SH_BreadCrumb> lstBreadCrumbs) {
        if(lstBreadCrumbs != null && lstBreadCrumbs.size()>1) {
            SH_BreadCrumb link = lstBreadCrumbs[(lstBreadCrumbs.size()-2)];
            if(link != null && string.isNotBlank(link.pgLink))
                return link.pgLink;
        }
        return null;
    }
    
    /*
        This method is used to set the form url
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Alok Verma        7/14/2015                        1.0
        ===================================================================
        Param: PageReference pgRef
        ===================================================================
        Output :  none
        ================================================================  
    */
    public static void setFormUrlParams(PageReference pgRef) {
        if(pgRef != null) {
            string strLOne = Apexpages.currentPage().getParameters().get('L1');
            string strLOneId = Apexpages.currentPage().getParameters().get('L1Id');
            string strLTwo = Apexpages.currentPage().getParameters().get('L2');
            string strLTwoId = Apexpages.currentPage().getParameters().get('L2Id');
            string strM = Apexpages.currentPage().getParameters().get('M');
            string strSM = Apexpages.currentPage().getParameters().get('SM');
            string strT = Apexpages.currentPage().getParameters().get('T');
            string strCI = Apexpages.currentPage().getParameters().get('CI');
            
            if(string.isNotBlank(strM))
                pgRef.getParameters().put('M', strM);
            if(string.isNotBlank(strSM))
                pgRef.getParameters().put('SM', strSM);
            if(string.isNotBlank(strT))
                pgRef.getParameters().put('T', strT);
            if(string.isNotBlank(strCI))
                pgRef.getParameters().put('CI', strCI);
            if(string.isNotBlank(strLOne) && string.isNotBlank(strLOneId )) {
                pgRef.getParameters().put('L1', strLOne);
                pgRef.getParameters().put('L1Id', strLOneId );
            }
            if(string.isNotBlank(strLTwo) && string.isNotBlank(strLTwoId)) {
                pgRef.getParameters().put('L2', strLTwo);
                pgRef.getParameters().put('L2Id', strLTwoId);
            }
        }
    }
}