/*
This class is used for handling trigger
==========================================================
Name                    Date                       version
==========================================================
Alok Verma              08/11/2015                  1.0
==========================================================  
*/
public class SH_HomePageCarouselTriggerHandler {
 
    /*
    This Method is called from trigger on Before insert event
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        9/10/2015        1.0
    ================================================================
    Input Param: 
        1. list<SH_HomePage_carousel__c> triggerNew, 
        2. integer maxPublish_PreiewCount
    ================================================================
    Output : None
    ================================================================  
   */
    public void onBeforeInsert(list<SH_HomePage_carousel__c> triggerNew, integer maxPublish_PreiewCount) {
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
        1. list<SH_HomePage_carousel__c> triggerNew, 
        2. map<ID, SH_HomePage_carousel__c> triggerOldMap, 
        3. integer maxPublish_PreiewCount
    ================================================================
    Output : None
    ================================================================  
   */
    public void onBeforeUpdate(list<SH_HomePage_carousel__c> triggerNew, map<ID, SH_HomePage_carousel__c> triggerOldMap, integer maxPublish_PreiewCount) {
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
        1. list<SH_HomePage_carousel__c> triggerNew,  
        2. integer maxPublish_PreiewCount
    ================================================================
    Output : None
    ================================================================  
   */
    private void validationToStopPublish_Preview(list<SH_HomePage_carousel__c> triggerNew, integer maxPublish_PreiewCount) {
        if(triggerNew != null && triggerNew.size()>0) {
            integer publishedCount = [select count() from SH_HomePage_carousel__c where SH_Is_Publish__c = true];
            //added on 03-09-2015 to restrict user to mark preview more than defined
            integer previewCount = [select count() from SH_HomePage_carousel__c where SH_Is_Preview__c = true];
            
            for(SH_HomePage_carousel__c oHomePageCarousel : triggerNew) {
                
                //Insert case
                if(oHomePageCarousel.SH_Is_Publish__c == true) {
                    if((publishedCount + 1) > maxPublish_PreiewCount) {
                        oHomePageCarousel.addError('You cannot publish more than '+maxPublish_PreiewCount+' records.');
                    }
                    else{
                        publishedCount += 1;
                    }
                }
                
                //added on 03-09-2015 to restrict user to mark preview more than defined
                if(oHomePageCarousel.SH_Is_Preview__c == true) {
                    if((previewCount + 1) > maxPublish_PreiewCount) {
                        oHomePageCarousel.addError('You cannot preview more than '+maxPublish_PreiewCount+' records.');
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
        1. list<SH_HomePage_carousel__c> triggerNew,  
        2. map<ID, SH_HomePage_carousel__c> triggerOldMap
        3. integer maxPublish_PreiewCount
    ================================================================
    Output : None
    ================================================================  
   */
    private void validationToStopPublish_Preview(list<SH_HomePage_carousel__c> triggerNew, map<ID, SH_HomePage_carousel__c> triggerOldMap, integer maxPublish_PreiewCount) {
        if(triggerNew != null && triggerNew.size()>0 && triggerOldMap != null) {
            integer publishedCount = [select count() from SH_HomePage_carousel__c where SH_Is_Publish__c = true];
            //added on 03-09-2015 to restrict user to mark preview more than defined
            integer previewCount = [select count() from SH_HomePage_carousel__c where SH_Is_Preview__c = true];
            
            //Update case
            for(SH_HomePage_carousel__c oHomePageCarousel : triggerNew) {
                if(oHomePageCarousel.SH_Is_Publish__c == false) {
                    if(triggerOldMap.get(oHomePageCarousel.ID).SH_Is_Publish__c == true)
                        publishedCount -= 1;
                }
                else {
                    if(triggerOldMap.get(oHomePageCarousel.ID).SH_Is_Publish__c == false) {
                        if((publishedCount + 1) > maxPublish_PreiewCount) {
                            oHomePageCarousel.addError('You cannot publish more than '+maxPublish_PreiewCount+' records.');
                        }
                        else{
                            publishedCount += 1;
                        }
                    }
                }
                
                //added on 03-09-2015 to restrict user to mark preview more than defined
                if(oHomePageCarousel.SH_Is_Preview__c == false) {
                    if(triggerOldMap.get(oHomePageCarousel.ID).SH_Is_Preview__c == true)
                        previewCount -= 1;
                }
                else {
                    if(triggerOldMap.get(oHomePageCarousel.ID).SH_Is_Preview__c == false) {
                        if((previewCount + 1) > maxPublish_PreiewCount) {
                            oHomePageCarousel.addError('You cannot preview more than '+maxPublish_PreiewCount+' records.');
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
        1. list<SH_HomePage_carousel__c> triggerNew,  
        2. map<Id, SH_HomePage_carousel__c> triggerOldMap
    ================================================================
    Output : None
    ================================================================  
   */
    private void validateAndSetArticleToolId(list<SH_HomePage_carousel__c> triggerNew, map<ID, SH_HomePage_carousel__c> triggerOldMap) {
        if(triggerNew != null && triggerNew.size()>0) {
            set<Id> setOfArticleToolId = new set<Id>();
            list<SH_HomePage_carousel__c> lstHomePageCarousel = new list<SH_HomePage_carousel__c>();
            for(SH_HomePage_carousel__c oHomePageCarousel : triggerNew) {
                SH_HomePage_carousel__c oOldHomePageCarousel = triggerOldMap != null ? triggerOldMap.get(oHomePageCarousel.Id) : null;  
                
                if((oOldHomePageCarousel == null  && string.isNotBlank(oHomePageCarousel.SH_Article_Link__c))//Insert case
                    ||(oOldHomePageCarousel != null && (!SH_Common.equals(oHomePageCarousel.SH_Article_Link__c, oOldHomePageCarousel.SH_Article_Link__c)))) //update case
                {
                    oHomePageCarousel.SH_Article_Link__c.addError('Invalid Field to assign Article/Tool Id, Valid field is SH_Article_Tool_Id__c.');
                }
                else if(string.isBlank(oHomePageCarousel.SH_Content_Type__c)){
                    oHomePageCarousel.SH_Content_Type__c.addError('Content Type is required.');
                }
                else {
                   if((oHomePageCarousel.SH_Content_Type__c.equalsIgnoreCase('Article') || oHomePageCarousel.SH_Content_Type__c.equalsIgnoreCase('Tool')) && string.isBlank(oHomePageCarousel.SH_Article_Tool_Id__c ))   
                        oHomePageCarousel.SH_Article_Tool_Id__c.addError(oHomePageCarousel.SH_Content_Type__c+' Id is required.');
                    else if(string.isNotBlank(oHomePageCarousel.SH_Article_Tool_Id__c )){  
                        if(oOldHomePageCarousel == null 
                        || (oOldHomePageCarousel != null && 
                            ((!SH_Common.equals(oHomePageCarousel.SH_Article_Tool_Id__c,oOldHomePageCarousel.SH_Article_Tool_Id__c))
                            || (!SH_Common.equals(oHomePageCarousel.SH_Content_Type__c,oOldHomePageCarousel.SH_Content_Type__c)))
                           )
                        ) {
                            Id ArticleToolId;
                            try {
                                ArticleToolId = oHomePageCarousel.SH_Article_Tool_Id__c;
                                setOfArticleToolId.add(ArticleToolId);
                                lstHomePageCarousel.add(oHomePageCarousel);   
                            }
                            catch(Exception ee) {
                                oHomePageCarousel.SH_Article_Tool_Id__c.addError(ee.getMessage());   
                            }
                        }
                    }
                    else {
                        oHomePageCarousel.SH_Article_Link__c = null;   
                    }
                }
            }
            
            if(setOfArticleToolId.size()>0 && lstHomePageCarousel.size()>0)
                ValidateAndAssignArticleTool18digitId(setOfArticleToolId, lstHomePageCarousel);
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
        2. list<SH_HomePage_carousel__c> lstHomePageCarousel
    ================================================================
    Output : None
    ================================================================  
   */
    private void ValidateAndAssignArticleTool18digitId(set<Id> setOfArticleToolId, list<SH_HomePage_carousel__c> lstHomePageCarousel) {
        if(lstHomePageCarousel != null && lstHomePageCarousel.size()>0 
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
            
            for(SH_HomePage_carousel__c oHomePageCarousel : lstHomePageCarousel) {
                Id ArticleToolId;
                try {
                    ArticleToolId = oHomePageCarousel.SH_Article_Tool_Id__c;
                    KnowledgeArticleVersion objKnowledgeArticleVersion = mapArticleToolIdToKnowledgeArticleVersion.get(ArticleToolId) ;
                    if(objKnowledgeArticleVersion != null) {
                        if((oHomePageCarousel.SH_Content_Type__c.equalsIgnoreCase('Article') && objKnowledgeArticleVersion.ArticleType.equalsIgnoreCase('Tool__kav'))
                            ||(oHomePageCarousel.SH_Content_Type__c.equalsIgnoreCase('Tool') && !objKnowledgeArticleVersion.ArticleType.equalsIgnoreCase('Tool__kav'))
                        )
                            oHomePageCarousel.SH_Article_Tool_Id__c.addError('Invalid '+oHomePageCarousel.SH_Content_Type__c +' Id.');
                        else
                            oHomePageCarousel.SH_Article_Link__c = objKnowledgeArticleVersion.KnowledgeArticleId;
                    }
                    else 
                        oHomePageCarousel.SH_Article_Tool_Id__c.addError('Invalid '+(oHomePageCarousel.SH_Content_Type__c.equalsIgnoreCase('Other') ? 'Article/Tool' :oHomePageCarousel.SH_Content_Type__c )+' Id.');
                }
                catch(Exception ee) {
                    oHomePageCarousel.addError(ee.getMessage());   
                }
            }
            
        }
    }
}