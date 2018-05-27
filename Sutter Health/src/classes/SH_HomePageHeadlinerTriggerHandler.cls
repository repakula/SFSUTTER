/*
This class is used for handling trigger
==========================================================
Name                    Date                       version
==========================================================
Alok Verma              08/11/2015                  1.0
==========================================================  
*/
public class SH_HomePageHeadlinerTriggerHandler {
 
    /*
    This Method is called from trigger on Before insert event
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        9/10/2015        1.0
    ================================================================
    Input Param: 
        1. list<SH_Home_Page_Headliner__c> triggerNew, 
        2. integer maxPublish_PreiewCount
    ================================================================
    Output : None
    ================================================================  
   */
    public void onBeforeInsert(list<SH_Home_Page_Headliner__c> triggerNew, integer maxPublish_PreiewCount) {
        validationToStopPublish_Preview(triggerNew,maxPublish_PreiewCount);
        validateAndSetArticleToolId(triggerNew, null);
    }   
    /*
    This Method is called from trigger on Before update event
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        9/10/2015        1.0
    ================================================================
    Input Param: 
        1. list<SH_Home_Page_Headliner__c> triggerNew, 
        2. map<ID, SH_Home_Page_Headliner__c> triggerOldMap, 
        3. integer maxPublish_PreiewCount
    ================================================================
    Output : None
    ================================================================  
   */
    public void onBeforeUpdate(list<SH_Home_Page_Headliner__c> triggerNew, map<ID, SH_Home_Page_Headliner__c> triggerOldMap, integer maxPublish_PreiewCount) {
        validationToStopPublish_Preview(triggerNew, triggerOldMap,maxPublish_PreiewCount);
        validateAndSetArticleToolId(triggerNew, triggerOldMap);
    }
    /*
    This Method is used to restrict user to publish/preview 
    more than specified count on insert
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        9/10/2015        1.0
    ================================================================
    Input Param: 
        1. list<SH_Home_Page_Headliner__c> triggerNew,  
        2. integer maxPublish_PreiewCount
    ================================================================
    Output : None
    ================================================================  
   */
    private void validationToStopPublish_Preview(list<SH_Home_Page_Headliner__c> triggerNew, integer maxPublish_PreiewCount) {
        if(triggerNew != null && triggerNew.size()>0) {
            integer publishedCount = [select count() from SH_Home_Page_Headliner__c where SH_Is_Publish__c = true];
            
            //added on 03-09-2015 to restrict user to mark preview more than defined
            integer previewCount = [select count() from SH_Home_Page_Headliner__c where SH_Is_Preview__c = true];
            
            for(SH_Home_Page_Headliner__c oHomePageHeadliner : triggerNew) {
                //Insert case
                if(oHomePageHeadliner.SH_Is_Publish__c == true) {
                    if((publishedCount + 1) > maxPublish_PreiewCount) {
                        oHomePageHeadliner.addError('You cannot publish more than '+maxPublish_PreiewCount+' records.');
                    }
                    else{
                        publishedCount += 1;
                    }
                }
                //added on 03-09-2015 to restrict user to mark preview more than defined
                if(oHomePageHeadliner.SH_Is_Preview__c == true) {
                    if((previewCount + 1) > maxPublish_PreiewCount) {
                        oHomePageHeadliner.addError('You cannot preview more than '+maxPublish_PreiewCount+' records.');
                    }
                    else{
                        previewCount += 1;
                    }
                }
            }
        }
    }
    /*
    This Method is used to restrict user to publish/preview 
    more than specified count on update
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        9/10/2015        1.0
    ================================================================
    Input Param: 
        1. list<SH_Home_Page_Headliner__c> triggerNew,  
        2. map<ID, SH_Home_Page_Headliner__c> triggerOldMap
        3. integer maxPublish_PreiewCount
    ================================================================
    Output : None
    ================================================================  
   */
    private void validationToStopPublish_Preview(list<SH_Home_Page_Headliner__c> triggerNew, map<ID, SH_Home_Page_Headliner__c> triggerOldMap, integer maxPublish_PreiewCount) {
        if(triggerNew != null && triggerNew.size()>0 && triggerOldMap != null) {
            integer publishedCount = [select count() from SH_Home_Page_Headliner__c where SH_Is_Publish__c = true];
            
            //added on 03-09-2015 to restrict user to mark preview more than defined
            integer previewCount = [select count() from SH_Home_Page_Headliner__c where SH_Is_Preview__c = true];
            
            //Update case
            for(SH_Home_Page_Headliner__c oHomePageHeadliner : triggerNew) {
                if(oHomePageHeadliner.SH_Is_Publish__c == false) {
                    if(triggerOldMap.get(oHomePageHeadliner.ID).SH_Is_Publish__c == true)
                        publishedCount -= 1;
                }
                else {
                    if(triggerOldMap.get(oHomePageHeadliner.ID).SH_Is_Publish__c == false) {
                        if((publishedCount + 1) > maxPublish_PreiewCount) {
                            oHomePageHeadliner.addError('You cannot publish more than '+maxPublish_PreiewCount+' records.');
                        }
                        else{
                            publishedCount += 1;
                        }
                    }
                }
                
                //added on 03-09-2015 to restrict user to mark preview more than defined
                if(oHomePageHeadliner.SH_Is_Preview__c == false) {
                    if(triggerOldMap.get(oHomePageHeadliner.ID).SH_Is_Preview__c == true)
                        previewCount -= 1;
                }
                else {
                    if(triggerOldMap.get(oHomePageHeadliner.ID).SH_Is_Preview__c == false) {
                        if((previewCount + 1) > maxPublish_PreiewCount) {
                            oHomePageHeadliner.addError('You cannot preview more than '+maxPublish_PreiewCount+' records.');
                        }
                        else{
                            previewCount += 1;
                        }
                    }
                }
            }
        }
    } 
    /*
    This Method is used to validate Artile/Tool Id
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        9/10/2015        1.0
    ================================================================
    Input Param: 
        1. list<SH_Home_Page_Headliner__c> triggerNew,  
        2. map<Id, SH_Home_Page_Headliner__c> triggerOldMap
    ================================================================
    Output : None
    ================================================================  
   */
    private void validateAndSetArticleToolId(list<SH_Home_Page_Headliner__c> triggerNew, map<ID, SH_Home_Page_Headliner__c> triggerOldMap) {
        if(triggerNew != null && triggerNew.size()>0) {
            set<Id> setOfArticleToolId = new set<Id>();
            list<SH_Home_Page_Headliner__c> lstHomePageHeadliner = new list<SH_Home_Page_Headliner__c>();
            for(SH_Home_Page_Headliner__c oHomePageHeadliner : triggerNew) {
                SH_Home_Page_Headliner__c oOldHomePageHeadliner = triggerOldMap != null ? triggerOldMap.get(oHomePageHeadliner.Id) : null;  
                
                if((oOldHomePageHeadliner == null  && string.isNotBlank(oHomePageHeadliner.SH_Article_Link__c))//Insert case
                    ||(oOldHomePageHeadliner != null && (!SH_Common.equals(oHomePageHeadliner.SH_Article_Link__c,oOldHomePageHeadliner.SH_Article_Link__c))))//update case
                {
                    oHomePageHeadliner.SH_Article_Link__c.addError('Invalid Field to assign Article/Tool Id, Valid field is SH_Article_Tool_Id__c.');
                }
                else if(string.isBlank(oHomePageHeadliner.SH_Content_Type__c)){
                    oHomePageHeadliner.SH_Content_Type__c.addError('Content Type is required.');
                }
                else {
                   if((oHomePageHeadliner.SH_Content_Type__c.equalsIgnoreCase('Article') || oHomePageHeadliner.SH_Content_Type__c.equalsIgnoreCase('Tool')) && string.isBlank(oHomePageHeadliner.SH_Article_Tool_Id__c ))   
                        oHomePageHeadliner.SH_Article_Tool_Id__c.addError(oHomePageHeadliner.SH_Content_Type__c+' Id is required.');
                    else if(string.isNotBlank(oHomePageHeadliner.SH_Article_Tool_Id__c )){  
                        if(oOldHomePageHeadliner == null 
                        || (oOldHomePageHeadliner != null && 
                            ((!SH_Common.equals(oHomePageHeadliner.SH_Article_Tool_Id__c, oOldHomePageHeadliner.SH_Article_Tool_Id__c))
                            || (!SH_Common.equals(oHomePageHeadliner.SH_Content_Type__c, oOldHomePageHeadliner.SH_Content_Type__c)))
                           )
                        ) {
                            Id ArticleToolId;
                            try {
                                ArticleToolId = oHomePageHeadliner.SH_Article_Tool_Id__c;
                                setOfArticleToolId.add(ArticleToolId);
                                lstHomePageHeadliner.add(oHomePageHeadliner);   
                            }
                            catch(Exception ee) {
                                oHomePageHeadliner.SH_Article_Tool_Id__c.addError(ee.getMessage());   
                            }
                        }
                    }
                    else {
                        oHomePageHeadliner.SH_Article_Link__c = null;   
                    }
                }
            }
            
            if(setOfArticleToolId.size()>0 && lstHomePageHeadliner.size()>0)
                ValidateAndAssignArticleTool18digitId(setOfArticleToolId, lstHomePageHeadliner);
        }
    }
    /*
    This Method is used to validate and assign Artile/Tool Id
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        9/10/2015        1.0
    ================================================================
    Input Param: 
        1. set<Id> setOfArticleToolId,  
        2. list<SH_Home_Page_Headliner__c> lstHomePageHeadliner
    ================================================================
    Output : None
    ================================================================  
   */
    private void ValidateAndAssignArticleTool18digitId(set<Id> setOfArticleToolId, list<SH_Home_Page_Headliner__c> lstHomePageHeadliner) {
        if(lstHomePageHeadliner != null && lstHomePageHeadliner.size()>0 
        && setOfArticleToolId != null && setOfArticleToolId.size()>0) {
            map<Id,KnowledgeArticleVersion> mapArticleToolIdToKnowledgeArticleVersion = new map<Id,KnowledgeArticleVersion>();
            //searching in Published version
            for(KnowledgeArticleVersion objKnowledgeArticleVersion : [Select Id, KnowledgeArticleId, ArticleType From KnowledgeArticleVersion 
                                                                                where (PublishStatus = 'online'  AND language ='en_US') 
                                                                                and KnowledgeArticleId in: setOfArticleToolId]) {
                mapArticleToolIdToKnowledgeArticleVersion.put(objKnowledgeArticleVersion.KnowledgeArticleId, objKnowledgeArticleVersion);
            }
            
            //searching in Draft Version
            for(KnowledgeArticleVersion objKnowledgeArticleVersion : [Select Id, KnowledgeArticleId, ArticleType From KnowledgeArticleVersion 
                                                                                where (PublishStatus = 'Draft'  AND language ='en_US') 
                                                                                and KnowledgeArticleId in: setOfArticleToolId]) {
                if(mapArticleToolIdToKnowledgeArticleVersion.get(objKnowledgeArticleVersion.KnowledgeArticleId) == null)
                    mapArticleToolIdToKnowledgeArticleVersion.put(objKnowledgeArticleVersion.KnowledgeArticleId, objKnowledgeArticleVersion);
               
            }
            
            for(SH_Home_Page_Headliner__c oHomePageHeadliner : lstHomePageHeadliner) {
                Id ArticleToolId;
                try {
                    ArticleToolId = oHomePageHeadliner.SH_Article_Tool_Id__c;
                    KnowledgeArticleVersion objKnowledgeArticleVersion = mapArticleToolIdToKnowledgeArticleVersion.get(ArticleToolId) ;
                    if(objKnowledgeArticleVersion != null) {
                        if((oHomePageHeadliner.SH_Content_Type__c.equalsIgnoreCase('Article') && objKnowledgeArticleVersion.ArticleType.equalsIgnoreCase('Tool__kav'))
                            ||(oHomePageHeadliner.SH_Content_Type__c.equalsIgnoreCase('Tool') && !objKnowledgeArticleVersion.ArticleType.equalsIgnoreCase('Tool__kav'))
                        )
                            oHomePageHeadliner.SH_Article_Tool_Id__c.addError('Invalid '+oHomePageHeadliner.SH_Content_Type__c +' Id.');
                        else
                            oHomePageHeadliner.SH_Article_Link__c = objKnowledgeArticleVersion.KnowledgeArticleId;
                    }
                    else 
                        oHomePageHeadliner.SH_Article_Tool_Id__c.addError('Invalid '+(oHomePageHeadliner.SH_Content_Type__c.equalsIgnoreCase('Other') ? 'Article/Tool' :oHomePageHeadliner.SH_Content_Type__c )+' Id.');
                }
                catch(Exception ee) {
                    oHomePageHeadliner.addError(ee.getMessage());   
                }
            }
            
        }
    }
}