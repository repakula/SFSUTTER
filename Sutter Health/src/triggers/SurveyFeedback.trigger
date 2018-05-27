trigger SurveyFeedback on Survey_Feedback__c (before update,after update) {
    if(trigger.isAfter) {
        if(trigger.isUpdate) {
            try {
                /*map<Id,Survey_Feedback__c> mapSurveyFeedback = new map<Id,Survey_Feedback__c>([Select Target_Completion_Date__c, Survey_ID__c, Survey_Feedback_Type__c, Survey_Date__c, 
                                                                            Sub_Function__c, Status__c,Case_Owner__c,InternalURL__c,ownerId, Survey_Taken__r.Contact__c,Is_Email_Need_To_Send__c,
                                                                            Q_4_Recommend_S3_Center_to_a_colleague__c, Q_3_Rating_on_QoS_you_got_from_initial_a__c, Q_2_Times_you_contacted_S3_for_issue__c, 
                                                                            Q_1_Was_your_issue_resolved__c, Priority__c, Name From Survey_Feedback__c where Id IN :trigger.newMap.keyset()]);*/
                for(Survey_Feedback__c surveyObj : trigger.new) {
                    if(surveyObj.OwnerId != trigger.oldMap.get(surveyObj.Id).OwnerId) {
                        SurveyFeedbackItemUtil.sendNotification(surveyObj);
                    }
                }
            } catch(Exception ex) {}
        }
    }
    if(trigger.isbefore) {
        if(trigger.isUpdate) {
            for(Survey_Feedback__c surveyFeedbackObj : trigger.New) {
                if(surveyFeedbackObj.Change_Owner__c != null){
                    surveyFeedbackObj.Ownerid = surveyFeedbackObj.Change_Owner__c;
                    surveyFeedbackObj.Change_Owner__c = null;
                }
                if(surveyFeedbackObj.status__c != trigger.oldmap.get(surveyFeedbackObj.id).status__c && surveyFeedbackObj.status__c == 'Closed') {
                    surveyFeedbackObj.closed_Date__c = system.today();
                }
            }
        }
    }
}