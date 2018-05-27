/*
This class is used to get Published Articles/Tools
and calls from SH_SearchBarController 
and SH_SearchBarRemoteController
==========================================================
Name                    Date                       version
==========================================================
Rishabh Pilani          7/31/2015                   1.0
==========================================================  
*/
public with sharing class SH_SearchArticles{
    /*
    This Method is used to fetch Published Articles/Tools
    based on params
    Version 2.0 is introduced to add the Exact phrase concept
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    Alok Verma              19/02/2016                  2.0
    ==========================================================  
    Input Param: String searchItem, set<id> setExclude
    ===========================================================
    Output : List<List <sObject>>
    ===========================================================
    */
    public static List<List <sObject>> fetchArticles(string searchItem, set<id> setExclude) {   
        List<List <sObject>> mainSearchList = new List<List <sObject>>();       
        Set<String> standardFieldsSet = new Set<String>{'Id','Summary','Title', 'KnowledgeArticleId', 'ArticleNumber'};           
        Set<String> customFieldsSet = new Set<String>{'Keywords__c','SH_Is_Priority__c','SH_Priority_Start_On__c','SH_Priority_End_On__c'};
        //added on 25-Aug-2015 for Notification
        Set<String> toolCustomFieldsSet = new Set<String>{'Keywords__c','SH_Is_Priority__c','SH_Priority_Start_On__c','SH_Priority_End_On__c','SH_Tool_Link__c','SH_Notification_Title__c','SH_Notification_Description__c','SH_Not_Supported_Browser__c','SH_More_Information_Link__c','SH_Is_Show_Notification__c','SH_Browser_Notification_Title__c','SH_Browser_Notification_Info_Link__c','SH_Browser_Notification_Description__c','SH_Is_Show_Browser_Notification__c'};
        
        String collegeString = '';
        for(String s:standardFieldsSet) {
           collegeString += (collegeString==''?'':',')+s;
        }
        Map<String, Schema.SObjectType> schemaMap =  Schema.getGlobalDescribe();    
        List<String> lstKAObjects = SH_Common.GetKnowledgeArticleObjects();        
        if(lstKAObjects != null && lstKAObjects.size()>0){
            String advanceSearchQuery = 'FIND \'' + searchItem + '\' IN ALL FIELDS RETURNING ';
            List<List<String>> lstBatchedLists = SH_Common.SplitSObjectTypeListToSubLists(lstKAObjects, integer.valueof(Math.ceil(lstKAObjects.size() / 4.00)));            
            for(List<String> lstSObjects : lstBatchedLists){
                String innerAdvanceSearchQuery = advanceSearchQuery;
                String innerCollegeString;
                for(String otype : lstSObjects){
                    innerCollegeString = collegeString;
                    //added on 25-Aug-2015 for Notification
                    Set<String> customFields = otype.equalsIgnoreCase('Tool__kav') ? toolCustomFieldsSet : customFieldsSet;
                    for(string s : customFields){
                        if(schemaMap.get(otype).getDescribe().fields.getMap().containsKey(s)){
                            innerCollegeString += ',' + s;
                        }
                    }
                    //updated on 19-02-2016 for adding exact phrase concept
                    //innerAdvanceSearchQuery += otype + ' ( ' + innerCollegeString + ' WHERE (PublishStatus = \'online\'  AND language =\'en_US\')), ';                                                 
                    innerAdvanceSearchQuery += otype + ' ( ' + innerCollegeString + ' WHERE (PublishStatus = \'online\'  AND language =\'en_US\''
                    + ((setExclude != null && setExclude.size()>0) ? ' AND KnowledgeArticleId not in: setExclude' : '' )
                    +')), ';                                                 
                }
                innerAdvanceSearchQuery = innerAdvanceSearchQuery.SubString(0, innerAdvanceSearchQuery.length() - 2);
                //system.debug('innerAdvanceSearchQuery '+innerAdvanceSearchQuery);
                List<List <sObject>> searchList = search.query(innerAdvanceSearchQuery);
                if(searchList != null && searchList.size() > 0)
                    mainSearchList.addAll(searchList);
            }
        }
        
        //system.debug('mainSearchList : '+mainSearchList);
        return mainSearchList;
    }
    
    /*
    This Method is used to fetch Published Articles/Tools
    based on params
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    ==========================================================  
    Input Param: String searchItem, Boolean showRating
    ===========================================================
    Output : List<SH_ResultItems>
    ===========================================================
    */
    public static List<SH_ResultItems> SearchArticles_Advance(String searchItem, Boolean showRating){   
        return SearchArticles_Advance(searchItem, showRating, null);
    }
    /*
    This Method is used to fetch Published Articles/Tools
    based on params
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    ==========================================================  
    Input Param: String searchItem, Boolean showRating, map<Id,Tool__kav> mapOfTools
    ===========================================================
    Output : List<SH_ResultItems>
    ===========================================================
    */
    public static List<SH_ResultItems> SearchArticles_Advance(String searchItem, Boolean showRating, map<Id,Tool__kav> mapOfTools){ 
        //added on 26-Aug-2015 for Flagged Keyword Articles
        string strSearchQuery = string.isBlank(searchItem) ? '' : searchItem.substringBeforeLast('*');
        
        //added on 18-sep-2015 for title match phrases
        strSearchQuery = (string.isNotBlank(strSearchQuery) ? strSearchQuery.removeStart('"').removeEnd('"') : '');
        
        //added on 26-Aug-2015 to escape the single Quote
        searchItem = String.escapeSingleQuotes(searchItem);
        
        List<SH_ResultItems> resultItemList = new List<SH_ResultItems>(); 
        //updated on 19-02-2016 for adding exact phrase concept
        /*
        List<List <sObject>> mainSearchList = new List<List <sObject>>();       
        Set<String> standardFieldsSet = new Set<String>{'Id','Summary','Title', 'KnowledgeArticleId', 'ArticleNumber'};           
        Set<String> customFieldsSet = new Set<String>{'Keywords__c','SH_Is_Priority__c','SH_Priority_Start_On__c','SH_Priority_End_On__c'};
        //added on 25-Aug-2015 for Notification
        Set<String> toolCustomFieldsSet = new Set<String>{'Keywords__c','SH_Is_Priority__c','SH_Priority_Start_On__c','SH_Priority_End_On__c','SH_Tool_Link__c','SH_Notification_Title__c','SH_Notification_Description__c','SH_Not_Supported_Browser__c','SH_More_Information_Link__c','SH_Is_Show_Notification__c','SH_Browser_Notification_Title__c','SH_Browser_Notification_Info_Link__c','SH_Browser_Notification_Description__c','SH_Is_Show_Browser_Notification__c'};
        
        String collegeString = '';
        for(String s:standardFieldsSet) {
           collegeString += (collegeString==''?'':',')+s;
        }
        Map<String, Schema.SObjectType> schemaMap =  Schema.getGlobalDescribe();    
        List<String> lstKAObjects = SH_Common.GetKnowledgeArticleObjects();        
        if(lstKAObjects != null && lstKAObjects.size()>0){
            String advanceSearchQuery = 'FIND \'' + searchItem + '\' IN ALL FIELDS RETURNING ';
            List<List<String>> lstBatchedLists = SH_Common.SplitSObjectTypeListToSubLists(lstKAObjects, integer.valueof(Math.ceil(lstKAObjects.size() / 4.00)));            
            for(List<String> lstSObjects : lstBatchedLists){
                String innerAdvanceSearchQuery = advanceSearchQuery;
                String innerCollegeString;
                for(String otype : lstSObjects){
                    innerCollegeString = collegeString;
                    //added on 25-Aug-2015 for Notification
                    Set<String> customFields = otype.equalsIgnoreCase('Tool__kav') ? toolCustomFieldsSet : customFieldsSet;
                    for(string s : customFields){
                        if(schemaMap.get(otype).getDescribe().fields.getMap().containsKey(s)){
                            innerCollegeString += ',' + s;
                        }
                    }
                    innerAdvanceSearchQuery += otype + ' ( ' + innerCollegeString + ' WHERE (PublishStatus = \'online\'  AND language =\'en_US\')), ';                                                 
                }
                innerAdvanceSearchQuery = innerAdvanceSearchQuery.SubString(0, innerAdvanceSearchQuery.length() - 2);
                List<List <sObject>> searchList = search.query(innerAdvanceSearchQuery);
                if(searchList != null && searchList.size() > 0)
                    mainSearchList.addAll(searchList);
            }
        }      
        */
        
        Set<Id> setArticleId = new Set<Id>();
        Map<SH_SearchResultType, List<SH_ResultItems>> resultItems = new Map<SH_SearchResultType, List<SH_ResultItems>>();
        Set<Id> setExcludeArticleToolId = new Set<Id>();
        //added on 19-02-2016 to fetch Articles with Exact Phrase Match starts
        if(string.isNotBlank(searchItem) && !(searchItem.startsWith('"') && searchItem.endsWith('"'))) {
            List<List <sObject>> mainSearchListExactPhrase = fetchArticles('"'+searchItem+'"', null);
            if(mainSearchListExactPhrase != null && mainSearchListExactPhrase.size()>0){
                for(List <sObject> lstobj: mainSearchListExactPhrase){
                    if(lstobj != null && lstobj.size()>0){
                        for(sObject sObj: lstobj){
                            SH_ResultItems rItem = GetAdvanceResultItems(sObj,strSearchQuery, mapOfTools, true);   
                            if(rItem != null){
                                setArticleId.add(rItem.Id);       
                                setExcludeArticleToolId.add(rItem.Id);       
                                if(resultItems.containsKey(rItem.SortingType)){
                                    resultItems.get(rItem.SortingType).add(rItem);
                                }else{
                                    resultItems.put(rItem.SortingType, new list<SH_ResultItems>{rItem});
                                }
                            }                           
                        }
                    }
                }
            }
        }
        //added on 19-02-2016 to fetch Articles with Exact Phrase Match Ends
        
        List<List <sObject>> mainSearchList = fetchArticles(searchItem, setExcludeArticleToolId);
        system.debug('setExcludeArticleToolId '+setExcludeArticleToolId);
        system.debug('mainSearchList '+mainSearchList);
        
        //added on 14-Sep-2015 for relevance sorting
        //Map<SH_RelevanceItem, List<SH_ResultItems>> resultRelevanceItems = new Map<SH_RelevanceItem, List<SH_ResultItems>>();
        if(mainSearchList != null && mainSearchList.size()>0){
            for(List <sObject> lstobj: mainSearchList){
                if(lstobj != null && lstobj.size()>0){
                    for(sObject sObj: lstobj){
                        List<SH_ResultItems> tempList;
                        //added on 19-02-2016 condition passed false for Exact Phrase match 
                        SH_ResultItems rItem = GetAdvanceResultItems(sObj,strSearchQuery, mapOfTools, false);   
                        if(rItem != null){
                            setArticleId.add(rItem.Id);       
                            if(resultItems.containsKey(rItem.SortingType)){
                                resultItems.get(rItem.SortingType).add(rItem);
                            }else{
                                resultItems.put(rItem.SortingType, new list<SH_ResultItems>{rItem});
                            }
                        }                           
                    }
                }
            }
        }
        
        //added on 18-Sep-2015 for Title match on priority starts
        if(resultItems.containsKey(SH_SearchResultType.ArticleNumberExactMatch)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ArticleNumberExactMatch));
        }
        if(resultItems.containsKey(SH_SearchResultType.TitleExactMatch)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.TitleExactMatch));
        }
        if(resultItems.containsKey(SH_SearchResultType.TitleStartsWith)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.TitleStartsWith));
        }
        if(resultItems.containsKey(SH_SearchResultType.TitleContains)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.TitleContains));
        }
        
        //added on 19-02-2016 to fetch Articles with Exact Phrase Match
        if(resultItems.containsKey(SH_SearchResultType.ArticleExactPhrase)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ArticleExactPhrase));
        }
        
        if(resultItems.containsKey(SH_SearchResultType.TitleJumbledExactMatch_SC)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.TitleJumbledExactMatch_SC));
        }
        if(resultItems.containsKey(SH_SearchResultType.TitleStartWithKeyFirstPart_SC)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.TitleStartWithKeyFirstPart_SC));
        }
        if(resultItems.containsKey(SH_SearchResultType.TitleJumbledExactMatch)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.TitleJumbledExactMatch));
        }
        if(resultItems.containsKey(SH_SearchResultType.TitleStartWithKeyFirstPart)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.TitleStartWithKeyFirstPart));
        }
        
        //added on 18-Sep-2015 for Title match on priority ends
        
        if(resultItems.containsKey(SH_SearchResultType.DATED_ARTICLE)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.DATED_ARTICLE));
        }
        //added on 18-Sep-2015 for Tool Title match on priority starts
        if(resultItems.containsKey(SH_SearchResultType.ToolArticleNumberExactMatch)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ToolArticleNumberExactMatch));
        }
        if(resultItems.containsKey(SH_SearchResultType.ToolTitleExactMatch)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ToolTitleExactMatch));
        }
        if(resultItems.containsKey(SH_SearchResultType.ToolTitleStartsWith)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ToolTitleStartsWith));
        }
        if(resultItems.containsKey(SH_SearchResultType.ToolTitleContains)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ToolTitleContains));
        }
        //added on 19-02-2016 to fetch Articles with Exact Phrase Match
        if(resultItems.containsKey(SH_SearchResultType.ToolExactPhrase)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ToolExactPhrase));
        }
        if(resultItems.containsKey(SH_SearchResultType.ToolTitleJumbledExactMatch_SC)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ToolTitleJumbledExactMatch_SC));
        }
        if(resultItems.containsKey(SH_SearchResultType.ToolTitleStartWithKeyFirstPart_SC)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ToolTitleStartWithKeyFirstPart_SC));
        }
        if(resultItems.containsKey(SH_SearchResultType.ToolTitleJumbledExactMatch)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ToolTitleJumbledExactMatch));
        }
        if(resultItems.containsKey(SH_SearchResultType.ToolTitleStartWithKeyFirstPart)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ToolTitleStartWithKeyFirstPart));
        }
        if(resultItems.containsKey(SH_SearchResultType.ToolTitleJumbledPartialMatch_SC)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ToolTitleJumbledPartialMatch_SC));
        }
        if(resultItems.containsKey(SH_SearchResultType.ToolTitleJumbledPartialMatch)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ToolTitleJumbledPartialMatch));
        }
        
        //added on 18-Sep-2015 for Tool Title match on priority Ends
        if(resultItems.containsKey(SH_SearchResultType.TOOL)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.TOOL));
        }
        //added on 26-Aug-2015 for FLAGGED_KEYWORD_ARTICLE
        if(resultItems.containsKey(SH_SearchResultType.FLAGGED_KEYWORD_ARTICLE)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.FLAGGED_KEYWORD_ARTICLE));
        }
        if(resultItems.containsKey(SH_SearchResultType.FLAG_KEY_JumbledExactMatchARTICLE_SC)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.FLAG_KEY_JumbledExactMatchARTICLE_SC));
        }
        if(resultItems.containsKey(SH_SearchResultType.FLAG_KEY_JumbledExactMatchARTICLE)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.FLAG_KEY_JumbledExactMatchARTICLE));
        }
        
        if(resultItems.containsKey(SH_SearchResultType.FLAGGED_ARTICLE)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.FLAGGED_ARTICLE));
        }
        //added on 18-Sep-2015 for Title match on priority starts
        if(resultItems.containsKey(SH_SearchResultType.TitleJumbledPartialMatch_SC)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.TitleJumbledPartialMatch_SC));
        }
        if(resultItems.containsKey(SH_SearchResultType.TitleJumbledPartialMatch)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.TitleJumbledPartialMatch));
        }
        
        //added on 18-Sep-2015 for Title match on priority ends
        if(resultItems.containsKey(SH_SearchResultType.FLAG_KEY_JumbledPartialMatchARTICLE_SC))
            resultItemList.addAll(resultItems.get(SH_SearchResultType.FLAG_KEY_JumbledPartialMatchARTICLE_SC));
        if(resultItems.containsKey(SH_SearchResultType.FLAG_KEY_JumbledPartialMatchARTICLE))
            resultItemList.addAll(resultItems.get(SH_SearchResultType.FLAG_KEY_JumbledPartialMatchARTICLE));
        
        if(resultItems.containsKey(SH_SearchResultType.ARTICLE)){
            resultItemList.addAll(resultItems.get(SH_SearchResultType.ARTICLE));
        }        
        
        if(showRating){
            Map<Id, Decimal> mapRating = SH_Common.GetArticleRatings(setArticleId);         
            for(SH_ResultItems rItem : resultItemList){
                rItem.ArticleRating = mapRating.containskey(rItem.Id)? mapRating.get(rItem.Id) : 0.00;
            }                               
        } 
        return resultItemList;
    }
    /*
    This Method is used to transform the Article type Sobject 
    into SH_ResultItems wrapper class
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    ==========================================================  
    Input Param: 
    1. sObject sObj, 
    2. string strSearchQuery, 
    3. map<Id,Tool__kav> mapOfTools
    4. boolean isForExactPhrase
    ===========================================================
    Output : SH_ResultItems
    ===========================================================
    */
    public static SH_ResultItems GetAdvanceResultItems(sObject sObj, string strSearchQuery, map<Id,Tool__kav> mapOfTools, boolean isForExactPhrase){
        SH_ResultItems rItem = new SH_ResultItems();
        try{                    
            rItem.Id = (ID)sObj.get('KnowledgeArticleId');
            rItem.Header = (String)sObj.get('Title');
            //added on 14-Sep-2015 for Relevance change
            rItem.ArticleNumber = (String)sObj.get('ArticleNumber');
            
            String strDescription = (String)sObj.get('Summary');
            rItem.Description = (strDescription != null && strDescription != '' && strDescription.length() > 130 ) ? strDescription.substring(0, 130) + '...' : strDescription;
            try{
                rItem.IsPrioritize = (Boolean)sObj.get('SH_Is_Priority__c');
            }catch(Exception e){
                rItem.IsPrioritize = false;
            }           
            try{
                rItem.Keywords = (String)sObj.get('Keywords__c');
            }catch(Exception e){}
            try{
                rItem.PriorityStartOn = (Date)sObj.get('SH_Priority_Start_On__c');
            }catch(Exception e){}
            try{
                rItem.PriorityEndOn = (Date)sObj.get('SH_Priority_End_On__c');
            }catch(Exception e){}  
            
            Schema.SObjectType objectType = sObj.getSObjectType();          
            if(objectType.getDescribe().getName().equalsIgnoreCase('Tool__kav')) {
                rItem.Type = SH_SearchResultType.TOOL;
                
                //added on 25-Aug-2015 for Notification starts
                if(mapOfTools != null)
                    mapOfTools.put(rItem.Id, (Tool__kav)sObj);
               
                //added on 13-Sep-2015 for notifications
                Tool__kav objTool = (Tool__kav)sObj; 
                if(objTool != null) {
                    //changed on 13-Sep-2015 for Notification
                    if(objTool.SH_Is_Show_Notification__c || objTool.SH_Is_Show_Browser_Notification__c) {
                        //changed on 13-Sep-2015 for Notification
                        rItem.link = 'javascript:CheckNotifications('+ Json.Serialize(objTool) + ');';
                    }
                    else{
                        //changed on 13-Sep-2015 for Notification
                        rItem.link = 'javascript:RedirectLink(\''+ (string.IsBlank(objTool.SH_Tool_Link__c) ? '#' : objTool.SH_Tool_Link__c) + '\' ,  \'' +(string.IsBlank(objTool.SH_Tool_Link__c) ? '_self' : '_blank') + '\');';
                    }
                }
                //added on 18-Sep-2015 for Tool Sorting on title basis
                if(string.isNotBlank(rItem.Header) && string.isNotBlank(rItem.ArticleNumber)) {
                    if(rItem.ArticleNumber.equalsIgnoreCase(strSearchQuery)) {
                        rItem.SortingType = SH_SearchResultType.ToolArticleNumberExactMatch;
                    }
                    else if(rItem.Header.equalsIgnoreCase(strSearchQuery)) {
                        
                        rItem.SortingType = SH_SearchResultType.ToolTitleExactMatch;
                    }
                    else if(rItem.Header.startsWithIgnoreCase(strSearchQuery)) {
                        
                        rItem.SortingType = SH_SearchResultType.ToolTitleStartsWith;
                    }
                    else if(rItem.Header.containsIgnoreCase(strSearchQuery)) {
                        rItem.SortingType = SH_SearchResultType.ToolTitleContains;
                    }
                    else {
                        //added on 19-02-2016 condition for Exact Phrase matching
                        if(isForExactPhrase) {
                            rItem.SortingType = SH_SearchResultType.ToolExactPhrase;
                        }
                        else {
                            //for Title JumbledExact and PartialMatch with Special characters
                            SH_SearchResultType toolType_Title_SC = getJumbledMatchTypeForKeyWordWithSpace(rItem.Header, strSearchQuery, false);
                            SH_SearchResultType toolType_Title = getJumbledMatchTypeForKeyWordWithSpace(rItem.Header, strSearchQuery, true);
                            if(toolType_Title_SC == SH_SearchResultType.TitleJumbledExactMatch)
                                rItem.SortingType = SH_SearchResultType.ToolTitleJumbledExactMatch_SC;
                            else if(toolType_Title_SC == SH_SearchResultType.TitleStartWithKeyFirstPart)
                                rItem.SortingType = SH_SearchResultType.ToolTitleStartWithKeyFirstPart_SC;
                            else if(toolType_Title == SH_SearchResultType.TitleJumbledExactMatch)
                                rItem.SortingType = SH_SearchResultType.ToolTitleJumbledExactMatch;
                            else if(toolType_Title == SH_SearchResultType.TitleStartWithKeyFirstPart)
                                rItem.SortingType = SH_SearchResultType.ToolTitleStartWithKeyFirstPart;
                            else if(toolType_Title_SC == SH_SearchResultType.TitleJumbledPartialMatch)
                                rItem.SortingType = SH_SearchResultType.ToolTitleJumbledPartialMatch_SC;
                            else if(toolType_Title == SH_SearchResultType.TitleJumbledPartialMatch)
                                rItem.SortingType = SH_SearchResultType.ToolTitleJumbledPartialMatch;
                            else{
                                rItem.SortingType = SH_SearchResultType.Tool;
                            }
                        }
                    }
                }
            }
            else{
                //added on 25-Aug-2015 for Notification starts
                rItem.link = 'SH_ArticleView?id='+rItem.Id;
                //added on 25-Aug-2015 for Notification ends
                
                Date currentDate = System.today();
                //added on 18-Sep-2015 for Title Match starts
                rItem.Type = SH_SearchResultType.ARTICLE;
                if(string.isNotBlank(rItem.Header) && string.isNotBlank(rItem.ArticleNumber)) {
                    if(rItem.ArticleNumber.equalsIgnoreCase(strSearchQuery)) {
                        rItem.SortingType = SH_SearchResultType.ArticleNumberExactMatch;
                    }
                    else if(rItem.Header.equalsIgnoreCase(strSearchQuery)) {
                        
                        rItem.SortingType = SH_SearchResultType.TitleExactMatch;
                    }
                    else if(rItem.Header.startsWithIgnoreCase(strSearchQuery)) {
                        
                        rItem.SortingType = SH_SearchResultType.TitleStartsWith;
                    }
                    else if(rItem.Header.containsIgnoreCase(strSearchQuery)) {
                        rItem.SortingType = SH_SearchResultType.TitleContains;
                    }
                    else {
                        //added on 19-02-2016 condition for Exact Phrase matching
                        if(isForExactPhrase) {
                            rItem.SortingType = SH_SearchResultType.ArticleExactPhrase;
                        }
                        else {
                            //for Title JumbledExact and PartialMatch
                            SH_SearchResultType articleType_Title_SC = getJumbledMatchTypeForKeyWordWithSpace(rItem.Header, strSearchQuery, false);
                            SH_SearchResultType articleType_Title = getJumbledMatchTypeForKeyWordWithSpace(rItem.Header, strSearchQuery, true);
                            if(articleType_Title_SC == SH_SearchResultType.TitleJumbledExactMatch)
                                rItem.SortingType = SH_SearchResultType.TitleJumbledExactMatch_SC;
                            else if(articleType_Title_SC == SH_SearchResultType.TitleStartWithKeyFirstPart)
                                rItem.SortingType = SH_SearchResultType.TitleStartWithKeyFirstPart_SC;
                            else if(articleType_Title == SH_SearchResultType.TitleJumbledExactMatch)
                                rItem.SortingType = SH_SearchResultType.TitleJumbledExactMatch;
                            else if(articleType_Title == SH_SearchResultType.TitleStartWithKeyFirstPart)
                                rItem.SortingType = SH_SearchResultType.TitleStartWithKeyFirstPart;
                            else if(rItem.PriorityStartOn != null && rItem.PriorityEndOn != null && (currentDate >= rItem.PriorityStartOn && currentDate <= rItem.PriorityEndOn)){
                                rItem.SortingType = SH_SearchResultType.DATED_ARTICLE;
                            }
                            else if((string.isNotBlank(strSearchQuery)) && (string.isNotBlank(rItem.Keywords)) && rItem.Keywords.containsIgnoreCase(strSearchQuery)) {
                                rItem.SortingType = SH_SearchResultType.FLAGGED_KEYWORD_ARTICLE;
                            }
                            else {
                                //for keyword JumbledExact and PartialMatch 
                                SH_SearchResultType articleType_Keyword_SC = getJumbledMatchTypeForKeyWordWithSpace(rItem.Keywords, strSearchQuery, false);
                                SH_SearchResultType articleType_Keyword = getJumbledMatchTypeForKeyWordWithSpace(rItem.Keywords, strSearchQuery, true);
                                if(articleType_Keyword_SC == SH_SearchResultType.TitleJumbledExactMatch)
                                    rItem.SortingType = SH_SearchResultType.FLAG_KEY_JumbledExactMatchARTICLE_SC;
                                else if(articleType_Keyword == SH_SearchResultType.TitleJumbledExactMatch)
                                    rItem.SortingType = SH_SearchResultType.FLAG_KEY_JumbledExactMatchARTICLE;
                                else if(rItem.IsPrioritize){
                                    rItem.SortingType = SH_SearchResultType.FLAGGED_ARTICLE;
                                }
                                else if(articleType_Title_SC == SH_SearchResultType.TitleJumbledPartialMatch)
                                    rItem.SortingType = SH_SearchResultType.TitleJumbledPartialMatch_SC;
                                else if(articleType_Title == SH_SearchResultType.TitleJumbledPartialMatch)
                                    rItem.SortingType = SH_SearchResultType.TitleJumbledPartialMatch;
                                else if(articleType_Keyword_SC == SH_SearchResultType.TitleJumbledPartialMatch || articleType_Keyword_SC == SH_SearchResultType.TitleStartWithKeyFirstPart)
                                    rItem.SortingType = SH_SearchResultType.FLAG_KEY_JumbledPartialMatchARTICLE_SC;
                                else if(articleType_Keyword == SH_SearchResultType.TitleJumbledPartialMatch || articleType_Keyword == SH_SearchResultType.TitleStartWithKeyFirstPart)
                                    rItem.SortingType = SH_SearchResultType.FLAG_KEY_JumbledPartialMatchARTICLE;
                                
                                else{
                                    rItem.SortingType = SH_SearchResultType.ARTICLE;
                                }
                            }
                        }
                    }
                }
                //added on 18-Sep-2015 for Title Match ends
            } 
            rItem.ArticleType = getObjectType(sObj);       
        }catch(Exception e){return null;}
        return rItem;
    }
    /*
    This Method is used to get the SobjectType
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    ==========================================================  
    Input Param: 
    1. SObject obj
    ===========================================================
    Output : string (SobjectType)
    ===========================================================
    */
    public static string getObjectType(SObject obj) {
        if(obj==null) return '';
        return obj.getSObjectType().getDescribe().getName()+'';
    }
    /*
    This Method is used to get the Sobject label
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    ==========================================================  
    Input Param: 
    1. SObject obj
    ===========================================================
    Output : string (Sobject label)
    ===========================================================
    */
    public static string getObjectLabel(SObject obj) {
        if(obj==null) return '';
        return obj.getSObjectType().getDescribe().getLabel()+'';
    }
    
    /*
    This Method is used to sort based on the keyword
    (relevance sorting)
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Alok Verma              14-Sep-2015                 1.0
    ==========================================================  
    Input Param: 
    1. string strTitle, 
    2. string strKeyword, 
    3. boolean matchWithSpecialChars
    ===========================================================
    Output : SH_SearchResultType
    ===========================================================
    */
    public static SH_SearchResultType getJumbledMatchTypeForKeyWordWithSpace(string strTitle, string strKeyword, boolean matchWithSpecialChars) {
        if(string.isNotBlank(strTitle) && string.isNotBlank(strKeyword)) {
            strKeyword = strKeyword.Trim();
            if(string.isNotBlank(strKeyword) && strKeyword.containsWhitespace()) {
                strTitle = strTitle.toLowerCase();
                strKeyword = strKeyword.toLowerCase();
                if(matchWithSpecialChars) {
                    string strRegex = '[^a-zA-Z0-9]';
                    strTitle = strTitle.replaceAll(strRegex, ' ');
                    strKeyword = strKeyword.replaceAll(strRegex, ' ');
                }
                set<string> setStrTitle = new set<string>();
                setStrTitle.addall(strTitle.split(' '));
                
                list<string> lstStrKeyword = strKeyword.split(' ');
                if(setStrTitle.containsAll(lstStrKeyword))
                    return SH_SearchResultType.TitleJumbledExactMatch;
                else {
                    if(lstStrKeyword != null && lstStrKeyword.size()>0) {
                        string strFirstKeyWord = getFirstNonBlankKeyWord(lstStrKeyword);
                        if(string.isNotBlank(strFirstKeyWord) && strTitle.StartsWithIgnoreCase(strFirstKeyWord))
                            return SH_SearchResultType.TitleStartWithKeyFirstPart;
                        else {
                            for(string strKey : lstStrKeyword) {
                                if(string.isNotBlank(strKey) && setStrTitle.contains(strKey)) {
                                    return SH_SearchResultType.TitleJumbledPartialMatch;   
                                }   
                            }
                        }
                    }
                }
            }
        }
        return null;
    }
    /*
    This Method is used to provide first non blank keyword
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Alok Verma              14-Sep-2015                 1.0
    ==========================================================  
    Input Param: 
    1. list<string> lstKeyWord
    ===========================================================
    Output : string
    ===========================================================
    */
    private static string getFirstNonBlankKeyWord(list<string> lstKeyWord) {
        if(lstKeyWord != null && lstKeyWord.size()>0) {
            for(string strKeyWord : lstKeyWord){
                if(string.isNotBlank(strKeyWord))
                    return strKeyWord;
            }
        }
        return null;
    }
}