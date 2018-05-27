/**    
 *    Trigger: CallBackTrigger
 *    Author: IDC  
 *    Date: 08-Oct-2014  
 *    Description: The trigger create/update/delete corresponding CaseComment records for call_back__c records(only for Grievance Case records).
 **/

trigger CallBackTrigger on Call_Back__c (after insert, after update, after delete) {
        
    private static final String GRIEVANCE = 'Grievance';
    /** if custom label 'Label.Skip_CallbackTrigger' is not null or 'true' then execute trigger otherwise skip execution. **/
    if(Label.Skip_CallbackTrigger == null || !Label.Skip_CallbackTrigger.equalsIgnoreCase('true')){ 
        /** Get 'Grievance' recordtype id. **/ 
        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = caseDescribe.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get(GRIEVANCE);
        
        if(rtByName !=null){
            /** If it is after insert trigger execution then insert a new Case Comment record 
             *  and also add case comment record id in 'CaseCommentID' field of callback record.
             **/     
            if(Trigger.isInsert && Trigger.isAfter){    
                /** Set 'isFirstTime' variable (from 'GrievanceTriggerSupport' class) to 'false' to skip creation of 'Call_Back__c' records from 'GrievanceComments' trigger. **/
                GrievanceTriggerSupport.isFirstTime = false;
                
                /** If callback record's 'CaseCommentID__c' field is empty then create corresponding 'CaseComment' records. **/            
                Map<CaseComment, Id> mapOfCommentCallBackID = new Map<CaseComment, Id>();
                List<CaseComment> caseCommList = new List<CaseComment>();
                for(Call_Back__c callbackRec : Trigger.new){
                    if(callbackRec.CaseCommentID__c == null || callbackRec.CaseCommentID__c == ''){
                        CaseComment newRec = new CaseComment(CommentBody = callbackRec.Notes__c, parentID = callbackRec.Parent_Case__c); 
                        caseCommList.add(newRec );
                    }
                }
                
                /** If 'caseCommList' list is not empty then insert 'CaseComment' records. **/            
                if(caseCommList.size() > 0 ){
                    insert caseCommList;
                    Integer i=0;
                    for(Call_Back__c callbackRec : Trigger.new)
                    {
                        if(callbackRec.CaseCommentID__c == null || callbackRec.CaseCommentID__c == '')
                        {
                            mapOfCommentCallBackID.put(caseCommList[i], callbackRec.id);
                            i++;
                        }
                    }
                }
            
                /** Fetch 'Call_Back__c' records to update 'CaseCommentID__c' field with corresponding 'CaseComment' record's id and update records. **/            
                List<Call_Back__c> listOfRecords = new List<Call_Back__c>();
                listOfRecords  = [select id,Parent_Case__c, CaseCommentID__c from Call_Back__c where id IN : Trigger.newMap.keySet()];
                boolean updateRecord = false;
                //Note: Keep this comment here to show 'mapOfCommentCallBackID' before update. Observed different behavior (if(callRec.id == prevRecId) condition is not matching if comment removed before for loop) which is affecting functionality if this comment is removed from this place. Need to check more details.              
                if(listOfRecords.size() > 0){
                    for(CaseComment rec  : caseCommList){
                        Id prevRecId = mapOfCommentCallBackID.get(rec);                                   
                        for(Call_back__c callRec : listOfRecords ){                   
                            if(callRec.id == prevRecId){
                                callRec.CaseCommentID__c = rec.id;
                                updateRecord = true;                        
                            }
                        }
                    }
                                     
                    if(updateRecord){
                        update listOfRecords;
                    }              
                }            
            }
            
            
            /** If it is a after update trigger then use 'Trigger.new' and if it is a after delete trigger then use 'Trigger.old'.**/
            List<Call_Back__c> listOfTriggerRecords = new List<Call_Back__c>();
            if(Trigger.isUpdate && Trigger.isAfter){
                listOfTriggerRecords = Trigger.new;
            }else if(Trigger.isDelete && Trigger.isAfter){
                listOfTriggerRecords = Trigger.old;
            }
            
            //If it is after update trigger execution then update related Case Comment records.
            //If it is after delete trigger execution then delete related Case Comment records.         
            //query related case comment records associated with callback record and update 'Notes__c' field value from callback record to corresponding 'CaseComment' record's 'CommentBody' field.
            Map<Id, Call_Back__c> mapOfCommentIdAndCallback = new Map<Id, Call_Back__c>();      
            for(Call_Back__c callbackRec : listOfTriggerRecords){
                if(callbackRec.CaseCommentID__c != null && callbackRec.CaseCommentID__c != ''){     
                    if( (Trigger.isUpdate && Trigger.isAfter && Trigger.oldMap.get(callbackRec.id).Notes__c != callbackRec.Notes__c) ||
                        (Trigger.isDelete && Trigger.isAfter) ){
                       Id recId = Id.valueOf(callbackRec.CaseCommentID__c);                
                       mapOfCommentIdAndCallback.put(recId, callbackRec);
                    }                 
                }                
    
                if(mapOfCommentIdAndCallback.size() >0){
                    List<CaseComment> caseCommentList = new List<CaseComment>();      
                    List<CaseComment> listOfCaseComments = [select id, CommentBody from CaseComment where id IN : mapOfCommentIdAndCallback.keySet()];
                    for(CaseComment caseCommentRec : listOfCaseComments){
                        if(mapOfCommentIdAndCallback.get(caseCommentRec.id) != null){
                            /** Update 'CommentBody' field(of CaseComment record) from 'Notes__c' field(of Call_Back__c).  **/                
                            if(Trigger.isUpdate && Trigger.isAfter){              
                                Call_Back__c callback  = mapOfCommentIdAndCallback.get(caseCommentRec.id);
                                caseCommentRec.CommentBody = callback.Notes__c;
                            } 
                            caseCommentList.add(caseCommentRec);                 
                        }
                    }
                  
                    /** If 'caseCommentList' list is not empty and it is after update execution then update casecomment records.
                      * If 'caseCommentList' list is not empty and it is after delete execution then delete casecomment records.
                     **/  
                    if(caseCommentList.size() >0){
                        if(Trigger.isUpdate && Trigger.isAfter){           
                            update caseCommentList ;
                          
                        }else if(Trigger.isDelete && Trigger.isAfter){           
                            delete caseCommentList ;
                           
                        }           
                    }                 
                }
            }
        }
    }
}