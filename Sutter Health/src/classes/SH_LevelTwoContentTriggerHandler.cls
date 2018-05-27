/*
This class is used for handling trigger
==========================================================
Name                    Date                       version
==========================================================
Alok Verma              08/11/2015                  1.0
==========================================================  
*/
public class SH_LevelTwoContentTriggerHandler
{
    /*
    This Method is called from trigger on Before insert event
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        9/10/2015        1.0
    ================================================================
    Input Param: list<SH_Level_2_Content__c> lstLevelTwoContent
    ================================================================
    Output : None
    ================================================================  
   */
    public void OnBeforeInsert(list<SH_Level_2_Content__c> lstLevelTwoContent)
    {
        validateAndSetArticleToolId(lstLevelTwoContent, null);
    }   
    /*
    This Method is called from trigger on Before update event
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        9/10/2015        1.0
    ================================================================
    Input Param: 
        1. list<SH_Level_2_Content__c> lstLevelTwoContent,  
        2. map<Id, SH_Level_2_Content__c> mapOfLevelTwoContent
    ================================================================
    Output : None
    ================================================================  
   */
    public void OnBeforeUpdate(list<SH_Level_2_Content__c> lstLevelTwoContent, map<Id, SH_Level_2_Content__c> mapOfLevelTwoContent)
    {
        validateAndSetArticleToolId(lstLevelTwoContent, mapOfLevelTwoContent);
    }
    /*
    This Method is used to validate Artile/Tool Id
    ================================================================
    Name              Date             version
    ================================================================
    Alok Verma        9/10/2015        1.0
    ================================================================
    Input Param: 
        1. list<SH_Level_2_Content__c> triggerNew,  
        2. map<Id, SH_Level_2_Content__c> triggerOldMap
    ================================================================
    Output : None
    ================================================================  
   */
    private void validateAndSetArticleToolId(list<SH_Level_2_Content__c> triggerNew, map<ID, SH_Level_2_Content__c> triggerOldMap) {
        if(triggerNew != null && triggerNew.size()>0) {
            set<Id> setOfArticleToolId = new set<Id>();
            list<SH_Level_2_Content__c> lstLevelTwoContent = new list<SH_Level_2_Content__c>();
            for(SH_Level_2_Content__c oLevelTwoContent : triggerNew) {
                SH_Level_2_Content__c oOldLevelTwoContent = triggerOldMap != null ? triggerOldMap.get(oLevelTwoContent.Id) : null;  
                
                if((oOldLevelTwoContent == null  && string.isNotBlank(oLevelTwoContent.SH_Article_Link__c))//Insert case
                    ||(oOldLevelTwoContent != null && (!SH_Common.equals(oLevelTwoContent.SH_Article_Link__c, oOldLevelTwoContent.SH_Article_Link__c))) )//update case
                {
                    oLevelTwoContent.SH_Article_Link__c.addError('Invalid Field to assign Article/Tool Id, Valid field is SH_Article_Tool_Id__c.');
                }
                else if(string.isBlank(oLevelTwoContent.SH_Content_Type__c)){
                    oLevelTwoContent.SH_Content_Type__c.addError('Content Type is required.');
                }
                else {
                   if((oLevelTwoContent.SH_Content_Type__c.equalsIgnoreCase('Article') || oLevelTwoContent.SH_Content_Type__c.equalsIgnoreCase('Tool')) && string.isBlank(oLevelTwoContent.SH_Article_Tool_Id__c ))   
                        oLevelTwoContent.SH_Article_Tool_Id__c.addError(oLevelTwoContent.SH_Content_Type__c+' Id is required.');
                    else if(string.isNotBlank(oLevelTwoContent.SH_Article_Tool_Id__c )){  
                        if(oOldLevelTwoContent == null 
                        || (oOldLevelTwoContent != null && 
                            ((!SH_Common.equals(oLevelTwoContent.SH_Article_Tool_Id__c, oOldLevelTwoContent.SH_Article_Tool_Id__c))
                            || (!SH_Common.equals(oLevelTwoContent.SH_Content_Type__c , oOldLevelTwoContent.SH_Content_Type__c)))
                           )
                        ) {
                            Id ArticleToolId;
                            try {
                                ArticleToolId = oLevelTwoContent.SH_Article_Tool_Id__c;
                                setOfArticleToolId.add(ArticleToolId);
                                lstLevelTwoContent.add(oLevelTwoContent);   
                            }
                            catch(Exception ee) {
                                oLevelTwoContent.SH_Article_Tool_Id__c.addError(ee.getMessage());   
                            }
                        }
                    }
                    else {
                        oLevelTwoContent.SH_Article_Link__c = null;   
                    }
                }
            }
            
            if(setOfArticleToolId.size()>0 && lstLevelTwoContent.size()>0)
                ValidateAndAssignArticleTool18digitId(setOfArticleToolId, lstLevelTwoContent);
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
        2. list<SH_Level_2_Content__c> lstLevelTwoContent
    ================================================================
    Output : None
    ================================================================  
   */
    private void ValidateAndAssignArticleTool18digitId(set<Id> setOfArticleToolId, list<SH_Level_2_Content__c> lstLevelTwoContent) {
        if(lstLevelTwoContent != null && lstLevelTwoContent.size()>0 
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
            
            for(SH_Level_2_Content__c oLevelTwoContent : lstLevelTwoContent) {
                Id ArticleToolId;
                try {
                    ArticleToolId = oLevelTwoContent.SH_Article_Tool_Id__c;
                    KnowledgeArticleVersion objKnowledgeArticleVersion = mapArticleToolIdToKnowledgeArticleVersion.get(ArticleToolId) ;
                    if(objKnowledgeArticleVersion != null) {
                        if((oLevelTwoContent.SH_Content_Type__c.equalsIgnoreCase('Article') && objKnowledgeArticleVersion.ArticleType.equalsIgnoreCase('Tool__kav'))
                            ||(oLevelTwoContent.SH_Content_Type__c.equalsIgnoreCase('Tool') && !objKnowledgeArticleVersion.ArticleType.equalsIgnoreCase('Tool__kav'))
                        )
                            oLevelTwoContent.SH_Article_Tool_Id__c.addError('Invalid '+oLevelTwoContent.SH_Content_Type__c +' Id.');
                        else
                            oLevelTwoContent.SH_Article_Link__c = objKnowledgeArticleVersion.KnowledgeArticleId;
                    }
                    else 
                        oLevelTwoContent.SH_Article_Tool_Id__c.addError('Invalid '+(oLevelTwoContent.SH_Content_Type__c.equalsIgnoreCase('Other') ? 'Article/Tool' :oLevelTwoContent.SH_Content_Type__c )+' Id.');
                }
                catch(Exception ee) {
                    oLevelTwoContent.addError(ee.getMessage());   
                }
            }
            
        }
    }
}