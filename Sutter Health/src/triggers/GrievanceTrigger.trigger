/**  
  *    Trigger: GrievanceTrigger 
  *    Author: IDC
  *    Date: 09-Oct-2014
  *    Description: This is the trigger to create/update call_back__c records. 
  *    If there is a CaseComment record associated with a Case(having recordtype other than Grievance) 
  *    then if it's recordtype is changed to 'Grievance' then create/update callback records for corresponding case comment records.
**/

trigger GrievanceTrigger on Case ( after update) {
    /** Recordtype : Grievance **/
    private static final String GRIEVANCE = 'Grievance';
    private static final String RESOLVED = 'Resolved';
    private static final String EXEMPT = 'Exempt';
    private static final String RESOLUTION = 'Resolution';    
    private List<CaseComment> caseCommentsList = new List<CaseComment>();
    private Map<Id, CaseComment> caseCommentIdMap = new Map<Id, CaseComment>();
    private Set<Id> caseIdSet = new set<Id>();
    Set<String> caseCommentsIdStrSet = new Set<String>();
    DateTime completionDate = System.now();

    //Get Grievance recordtype id. 
    Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case; 
    Map<String,Schema.RecordTypeInfo> rtMapByName = caseDescribe.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rtByName =  rtMapByName.get(GRIEVANCE);
     
    //system.debug('rtByName.getRecordTypeId() ='+rtByName.getRecordTypeId() );             
    /**
     * if a case with grievance recordtype is inserted or a case is changed to grievance record type and it has casecomment records 
     * then insert its corresponding callback records.
     */
    if(rtByName != null){
   
           /** Create a set of Case records(only for cases having 'Grievance' recordtype).*/
           for(Case caseRecord : Trigger.new){
               if(caseRecord.RecordTypeId == rtByName.getRecordTypeId() &&   
                  (Trigger.oldMap.get(caseRecord.id).RecordTypeId != rtByName.getRecordTypeId()) ){
                   caseIdSet.add(caseRecord.id);
               }
            }
            
            // If it is a 'Grievance' record with Entitlement and it also has Secondary Reason = 'Exempt', and Status='Resolved' then update 'Resolution' milestone's completion date.; 
            List<Id> updateCases = new List<Id>(); 
            for(Case caseObj : [Select c.Id, c.RecordTypeId, c.Status, c.Secondary_Reason__c, c.EntitlementId, c.SlaStartDate, c.SlaExitDate From Case c Where c.Id IN :Trigger.new]){
                
                Case oldCase = Trigger.oldMap.get(caseObj.Id);
                
                 if ((caseObj.Status == RESOLVED && oldCase.status != caseObj.Status) && (caseObj.Secondary_Reason__c == EXEMPT) && (caseObj.EntitlementId != null) && (caseObj.SlaStartDate <= completionDate) &&
                      (caseObj.SlaStartDate != null) && caseObj.RecordTypeId == rtByName.getRecordTypeId()){
                      updateCases.add(caseObj.Id);
                 }
            }
            
            try{
                
                if(updateCases.isEmpty() == false){
                    GrievanceTriggerSupport.completeMilestone(updateCases, RESOLUTION, completionDate);
                }
            } catch(Exception ex){
                
                if(ex.getMessage().contains('You can’t change the completion date on a customer inquiry milestone')){
                    
                    Trigger.new[0].addError('You can’t change the completion date on a customer inquiry milestone that’s already exited an entitlement process.');
                }
            }       
            //             

            /** If such records found then proceed.*/
            if(caseIdSet.size() > 0){
                
                /** Find all CaseComment records for corresponding Cases, convert CaseComment record ids into String and store it into a Set. **/
                for(CaseComment caseCommRec : [select id, CommentBody, ParentId from CaseComment where ParentID IN :caseIdSet]){ 
                     caseCommentsIdStrSet.add(String.valueOf(caseCommRec.id));
                     caseCommentIdMap.put(caseCommRec.id, caseCommRec);
                }
                
                Integer sizeOfRec = caseCommentsIdStrSet.size();
                if(sizeOfRec > 0) {
                    /** Find existing Call_Back__c records corresponding to given CaseComment records.*/
                    List<Call_Back__c> existingCallBackRecs = new List<Call_Back__c>();
                    existingCallBackRecs = [select id,CaseCommentID__c, Parent_Case__c from Call_Back__c where CaseCommentID__c IN :caseCommentsIdStrSet];
                    //system.debug('existingCallBackRecs ='+existingCallBackRecs );
                    
                    /** Create a Set of CaseComment record id. */ 
                    Set<Id> existingCallBackSet =  new Set<Id>();
                    Map<Id, Call_Back__c> existingCallBackRecordsMap =  new Map<Id, Call_Back__c>();
                    for(Call_Back__c rec : existingCallBackRecs){
                        existingCallBackSet.add(Id.valueOf(rec.CaseCommentID__c));
                        existingCallBackRecordsMap.put(String.valueOf(rec.CaseCommentID__c), rec);
                    }
                    //system.debug('existingCallBackSet='+existingCallBackSet);
                    //system.debug('existingCallBackRecordsMap='+existingCallBackRecordsMap);
                    
                    /** Find which Call_Back__c records has to be updated.  Make a list of all such records in 'updateCallBackRecords'.**/
                    List<Call_Back__c> updateCallBackRecords = new List<Call_Back__c>();
                    /** Find which CaseComment records does not have corresponding Call_Back__c records.  Make a list of all such records in 'newCaseComments'**/
                    List<CaseComment> newCaseComments = new List<CaseComment>();
                    for(Id commentId : caseCommentIdMap.keySet()){
                         if(existingCallBackSet.contains(commentId)){
                             Call_Back__c existingRec = existingCallBackRecordsMap.get(commentId);
                             CaseComment corospCommentRec = caseCommentIdMap.get(commentId);
                             existingRec.Notes__c = corospCommentRec.CommentBody;
                             updateCallBackRecords.add(existingRec);
                         }else{ 
                             newCaseComments.add(caseCommentIdMap.get(commentId));
                         }
                     }
                     
                     /** If List is not empty then create a list of Callback records with Case comments in 'callbackList' and insert records. **/
                     List<Call_back__c> callbackList = new List<Call_Back__c>(); 
                     for(CaseComment caCommentRec : newCaseComments){
                          callbackList.add(new Call_Back__c (Notes__c=caCommentRec.CommentBody,CaseCommentID__c=String.valueOf(caCommentRec.id), Parent_Case__c=caCommentRec.parentId));   
                     }
                     //system.debug('callbackList='+callbackList);
                     if(callbackList.size() > 0){
                         system.debug('Following records has to be inserted:'+ callbackList);
                         Database.insert(callbackList);
                         
                     }
                     /** If 'updateCallBackRecords' list is not empty then update Callback records in this list. **/
                     if(updateCallBackRecords.size() > 0){
                         system.debug('Following records has to be updated:'+ callbackList);
                         Database.update(updateCallBackRecords);
                     }
                    
                }
            }
        }

}