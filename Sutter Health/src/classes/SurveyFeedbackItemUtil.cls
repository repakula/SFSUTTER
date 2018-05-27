/**  
*     Class Name  : SurveyFeedbackItemUtil
*     Author      : IDC Offshore
*     Project Name: CRM - SFT - Sutter Health
*     Description : Called from ViewSurveyController
*                   Used by  TakeSurvey
*                                      
*
**/
public without sharing class SurveyFeedbackItemUtil {
private static final string EXEPTION_MSG =  '\r\n';
private static final string EXEPTION_MSG2 = '--------------';
    public static void createSurveyFeedbackItem(string surveyTakenId) {
        try {
        
            //Create a map of recent submitted survey
            map<Id,SurveyTaker__c> mapSurveyTaker = new  map<Id,SurveyTaker__c>([Select User__c, Taken__c, Survey__c, Q4_Score__c, Q3_Score__c, Q2_Score__c,Contact__r.RecordType.Name, 
                                                                                    Q1_Score__c, Overall_Satisfaction_Score__c, Name, Contact__c, Contact__r.Name,Contact__r.Email,
                                                                                    Case__c,Case__r.Sub_Function__c,Case__r.RecordType.Name,Case__r.Preferred_Callback_Number__c,Case__r.Preferred_Callback_Number_SR__c,Case__r.Id,
                                                                                    Case__r.Requestor_Name__c,Case__r.Requestor_Email__c,Case__r.Requestor_Number__c,Case__r.Requestor_Type__c,
                                                                                    (Select Response__c, Q1_Score__c, Q2_Score__c, Q3_Score__c, Q4_Score__c, Response_Score__c From 
                                                                                    Survey_Question_Answers__r order by Survey_Question__r.OrderNumber__c asc) 
                                                                                    From SurveyTaker__c where Id = :surveyTakenId]); 
            

            List<Survey_Feedback__c> surveyFeedbackTOIns = new List<Survey_Feedback__c>();
            
            //Iterate through recent survey(S)
            for(SurveyTaker__c surveyTakerObj : mapSurveyTaker.Values()) 
            {
                /*Survey feedback item should be created  if below criteria meets:
                1- Question 1 & 2- Customer called > 2 times, IL/SR is closed, Issue is unresolved
                2- Question 1 & 2- Customer called > 2 calls, IL/SR is closed, Issue is resolved
                3- Question 3- Survey Quality Score </= 6 
                4- Question 4- How likely to Recommend S3: Score </= 6 
                */
                if(((surveyTakerObj.Survey_Question_Answers__r[0].Response__c == 'Yes' || surveyTakerObj.Survey_Question_Answers__r[0].Response__c == 'No') && surveyTakerObj.Survey_Question_Answers__r[1].Response__c == '>2') || Decimal.valueOf(surveyTakerObj.Survey_Question_Answers__r[2].Response__c)<=6 || Decimal.valueOf(surveyTakerObj.Survey_Question_Answers__r[3].Response__c)<=6)
                {
                  
                    Survey_Feedback__c sFIObj = new Survey_Feedback__c();
                    sFIObj.Survey_Taken__c = surveyTakerObj.id;
                    sFIObj.Status__c = 'New';
                    sFIObj.Q_1_Was_your_issue_resolved__c = surveyTakerObj.Survey_Question_Answers__r[0].Response__c;
                    sFIObj.Q_2_Times_you_contacted_S3_for_issue__c = surveyTakerObj.Survey_Question_Answers__r[1].Response__c; 
                    sFIObj.Q_3_Rating_on_QoS_you_got_from_initial_a__c= (surveyTakerObj.Survey_Question_Answers__r[2].Response__c != null) ? Decimal.valueOf(surveyTakerObj.Survey_Question_Answers__r[2].Response__c) : 0.00 ;
                    sFIObj.Q_4_Recommend_S3_Center_to_a_colleague__c= (surveyTakerObj.Survey_Question_Answers__r[3].Response__c != null) ? Decimal.valueOf(surveyTakerObj.Survey_Question_Answers__r[3].Response__c) : 0.00 ;
                    sFIObj.Comments__c= surveyTakerObj.Survey_Question_Answers__r[4].Response__c;
                    
                    /*
                        Set the promoter category using question 4 response as base criteria
                    */
                   if(sFIObj.Q_4_Recommend_S3_Center_to_a_colleague__c>=0 && sFIObj.Q_4_Recommend_S3_Center_to_a_colleague__c < 7) {
                        sFIObj.Net_Promoter_Category__c = 'Detractor';
                    } else if(sFIObj.Q_4_Recommend_S3_Center_to_a_colleague__c>=7 && sFIObj.Q_4_Recommend_S3_Center_to_a_colleague__c < 9) {
                        sFIObj.Net_Promoter_Category__c = 'Passive';
                    } else if(sFIObj.Q_4_Recommend_S3_Center_to_a_colleague__c>=9 && sFIObj.Q_4_Recommend_S3_Center_to_a_colleague__c < 11) {
                        sFIObj.Net_Promoter_Category__c = 'Promoter';
                    }
                    if(surveyTakerObj.Contact__r.RecordType.Name != null && Label.Survey_Feedback_Rt.containsIgnoreCase(surveyTakerObj.Contact__r.RecordType.Name) &&
                        Schema.SObjectType.Survey_Feedback__c.getRecordTypeInfosByName().get(surveyTakerObj.Contact__r.RecordType.Name) != null) {
                        sFIObj.recordTypeId = Schema.SObjectType.Survey_Feedback__c.getRecordTypeInfosByName().get(surveyTakerObj.Contact__r.RecordType.Name).getRecordTypeId();   
                    }
                    if(surveyTakerObj.Case__r.RecordType.Name != null && (surveyTakerObj.Case__r.RecordType.Name == 'S3 Interaction Log' || surveyTakerObj.Case__r.RecordType.Name == 'S3 Interaction Log RO')) {
                        sFIObj.Customer_Inquiry_Type_Txt__c = 'S3 Interaction Log';
                    } else {
                        sFIObj.Customer_Inquiry_Type_Txt__c = 'Service Request';
                    }
                    if(surveyTakerObj.Contact__c != null) {
                        sFIObj.Email_Address_Txt__c = surveyTakerObj.Contact__r.Email;
                        sFIObj.Preferred_Call_Back_Number_Txt__c = surveyTakerObj.Case__r.Preferred_Callback_Number__c != null ? surveyTakerObj.Case__r.Preferred_Callback_Number__c : 
                                                                    surveyTakerObj.Case__r.Preferred_Callback_Number_SR__c;
                        sFIObj.Survey_Taken_By_Contact_Txt__c = surveyTakerObj.Contact__r.Name;
                    } 
                    surveyFeedbackTOIns.add(sFIObj);
                }
            }
            if(!surveyFeedbackTOIns.isEmpty()) 
            {
                //insert the survey feedback
                insert surveyFeedbackTOIns;
                
                
                //Query Survey Feedback to do some update operations
                Survey_Feedback__c sFIObjAfterIns = [Select Target_Completion_Date__c, Survey_ID__c, Survey_Feedback_Type__c, SurveyDate__c,Survey_Date_Text__c, Sub_Function__c, Status__c,Case_Owner__c,InternalURL__c, 
                                                    Q_4_Recommend_S3_Center_to_a_colleague__c, Q_3_Rating_on_QoS_you_got_from_initial_a__c, Q_2_Times_you_contacted_S3_for_issue__c, 
                                                    Q_1_Was_your_issue_resolved__c, Priority__c, Name From Survey_Feedback__c where Id =:surveyFeedbackTOIns[0].id];
                                                    
                if(sFIObjAfterIns != null)
                {
                    //Set the owner id based on custom setting                                              
                    string ownerId = assignOwner(sFIObjAfterIns);
                    if(ownerId != null) { 
                        sFIObjAfterIns.ownerId = ownerId;
                    }
                    
                    
                    //*****START- Survey Date Fix (Day Light Saving )*********
                    String dateString = sFIObjAfterIns.Survey_Date_Text__c;
                    Integer year = Integer.valueOf(dateString.subString(0, 4));
                    Integer month = Integer.valueOf(dateString.subString(5,7));
                    Integer day = Integer.valueOf(dateString.subString(8,10));
                    Date newDate = Date.newInstance(year, month, day);
                    sFIObjAfterIns.SurveyDate__c = newDate;
                    //*****END- Survey Date Fix (Day Light Saving )*********
                    
                    //Query S3 Business Hours
                    BusinessHours bh = [SELECT Id FROM BusinessHours where Name = 'S3 Business Hours']; 
                    
                    /* Set the Target Date, Survey Feedback Type and Priority as below
                        HIGH- Target Date:1 Business Day    
                              Survey Feedback Type: Resolve 
                              Criteria- Question 1 and 2 - Customer called > 2 times, IL/SR is closed, Issue is unresolved
                        Medium- Target Date- 2 Business Days
                                Survey Feedback Type: Review    
                                Criteria- 1- Question 1 & 2 : Customer called > 2 calls, IL/SR is closed, Issue is resolved
                                          2- Question 3 : Survey Quality Score </= 6 
                                          3- Question 4 : How likely to Recommend S3: Score </= 6 

                    */
                    if(sFIObjAfterIns.Q_1_Was_your_issue_resolved__c == 'No' && (sFIObjAfterIns.Q_2_Times_you_contacted_S3_for_issue__c == '>2')) 
                    {
                        
                        //*****START- Survey Target Completion Date Fix (Day Light Saving )*********
                        Date dtTemp =  date.newinstance(Date.valueOf(sFIObjAfterIns.Survey_Date_Text__c).year(), Date.valueOf(sFIObjAfterIns.Survey_Date_Text__c).month(), Date.valueOf(sFIObjAfterIns.Survey_Date_Text__c).day())+1;
                        DateTime dtTimeTemp =  datetime.newInstance(dtTemp.year(), dtTemp.month(),dtTemp.day());
                        
                        Datetime resultDateTime = BusinessHours.nextStartDate(bh.id, dtTimeTemp);
                        Integer targetYear = resultDateTime.year();
                        Integer targetMonth = resultDateTime.month();
                        Integer targetDday = resultDateTime.day();
                        Date targetNewDate = Date.newInstance(targetYear, targetMonth, targetDday);
                        sFIObjAfterIns.Target_Completion_Date__c = targetNewDate;
                        //*****END- Survey Target Completion Date Fix *********
                        
                        sFIObjAfterIns.Priority__c = 'High';
                        sFIObjAfterIns.Survey_Feedback_Type__c  = 'Resolve';    
                    } 
                    else
                    {
                        if((sFIObjAfterIns.Q_1_Was_your_issue_resolved__c == 'Yes' && sFIObjAfterIns.Q_2_Times_you_contacted_S3_for_issue__c == '>2') || (sFIObjAfterIns.Q_3_Rating_on_QoS_you_got_from_initial_a__c <= 6 || sFIObjAfterIns.Q_4_Recommend_S3_Center_to_a_colleague__c <= 6)) 
                        {
                            //*****START- Survey Target Completion Date Fix (Day Light Saving )*********
                            Date dtTemp =  date.newinstance(Date.valueOf(sFIObjAfterIns.Survey_Date_Text__c).year(), Date.valueOf(sFIObjAfterIns.Survey_Date_Text__c).month(), Date.valueOf(sFIObjAfterIns.Survey_Date_Text__c).day())+2;
                            DateTime dtTimeTemp =  datetime.newInstance(dtTemp.year(), dtTemp.month(),dtTemp.day());
                            Datetime resultDateTime = BusinessHours.nextStartDate(bh.id, dtTimeTemp);
                            Integer targetYear = resultDateTime.year();
                            Integer targetMonth = resultDateTime.month();
                            Integer targetDday = resultDateTime.day();
                            Date targetNewDate = Date.newInstance(targetYear, targetMonth, targetDday);
                            sFIObjAfterIns.Target_Completion_Date__c = targetNewDate;
                            //*****END- Survey Target Completion Date Fix *********
                            
                            sFIObjAfterIns.Priority__c = 'Medium';
                            sFIObjAfterIns.Survey_Feedback_Type__c  = 'Review'; 
                        }
                    } 
                
                    update sFIObjAfterIns; 
                }
            }                                     
        } catch(Exception classException) {
             Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
            }    
    }
    
    /** To assign owner
    */ 
    public static string assignOwner(Survey_Feedback__c surveyFeedbackObj) {
        try {
            Map<string, Survey_Feedback_Item__c> sFICSMap = Survey_Feedback_Item__c.getAll();
            if(surveyFeedbackObj.Sub_Function__c != null && sFICSMap.get(surveyFeedbackObj.Sub_Function__c) !=null) {
                Survey_Feedback_Item__c csObj = sFICSMap.get(surveyFeedbackObj.Sub_Function__c);
                if(csObj.L1_Owner__c != null) {
                    List<User> userLst = [select Id from User where Name =:csObj.L1_Owner__c.trim() and (not Profile.Name like '%Community%')];
                    if(userLst != null && userLst.size()>0) {
                        return userLst[0].Id;
                    }
                }
            } else {
                List<Group> surveyFeedbackQueue = [select Id from Group where Name = 'Survey Feedback Queue' and Type = 'Queue' limit 1];
                if(surveyFeedbackQueue != null && surveyFeedbackQueue.size()>0)  {
                    return surveyFeedbackQueue[0].id;
                }
            }
        } catch(Exception classException) {
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
               
        }
        return null;
    }
    
    /** To send notification to sub-function leads
    */ 
    public static void sendNotification(Survey_Feedback__c surveyfeedbackObj) {
        try {
            Map<string, Survey_Feedback_Item__c> sFICSMap = Survey_Feedback_Item__c.getAll();
            if(surveyfeedbackObj.Sub_Function__c != null && sFICSMap.get(surveyfeedbackObj.Sub_Function__c) != null) {
                Survey_Feedback_Item__c csObj = sFICSMap.get(surveyfeedbackObj.Sub_Function__c);
                Survey_Feedback__c surveyFeedbackObjTOUpd = [select owner.email from Survey_Feedback__c where Id = :surveyfeedbackObj.id];
                surveyFeedbackObjTOUpd.Email_Address_To_Send_Mail1__c = csObj.Email_to_L1__c;
                surveyFeedbackObjTOUpd.Email_Address_To_Send_Mail2__c = csObj.Email_to_L2__c;
                update surveyFeedbackObjTOUpd;
            }
        } catch(Exception classException) {
             Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
    }
    
}

    //Code to be used in future 
     /*if(surveyTakerObj.Contact__r.RecordType.Name != null && surveyTakerObj.Contact__r.RecordType.Name == 'Employee') {
                    sFIObj.recordTypeId = Schema.SObjectType.Survey_Feedback__c.getRecordTypeInfosByName().get('Employee').getRecordTypeId();   
                } else if(surveyTakerObj.Contact__r.RecordType.Name != null && surveyTakerObj.Contact__r.RecordType.Name == 'Vendor') {
                    sFIObj.recordTypeId = Schema.SObjectType.Survey_Feedback__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
                }*/
                /*else {
                    sFIObj.Email_Address_Txt__c = surveyTakerObj.Case__r.Requestor_Email__c;
                    sFIObj.Preferred_Call_Back_Number_Txt__c = surveyTakerObj.Case__r.Requestor_Number__c;
                    sFIObj.Survey_Taken_By_Contact_Txt__c = surveyTakerObj.Case__r.Requestor_Name__c;
                    if(surveyTakerObj.Case__r.Requestor_Type__c == 'Vendor') {
                        sFIObj.recordTypeId = Schema.SObjectType.Survey_Feedback__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
                    } else {
                        sFIObj.recordTypeId = Schema.SObjectType.Survey_Feedback__c.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
                    }
                }*/
                  /*List<User> userLst = [select Id from User where Name =:csObj.L1_Owner__c and IsActive = true limit 1];
                if(userLst != null && userLst.size()>0) {
                    return userLst[0].Id;
                }*/