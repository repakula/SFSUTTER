/**  
  *    Trigger: GrievanceComments
  *    Author: IDC
  *    Date: 09-Oct-2014
  *    Description: This is the trigger to create call_back__c records for corresponding casecomments(only for Grievance Case records) . 
  *    If there is a CaseComment record inserted, where CaseComment record's parent Case has 'Grievance' recordtype, then check for it's corresponding Call_Back__c record, 
  *    if callback record not found then create callback record and insert with casecomment text. 
**/


trigger GrievanceComments on CaseComment (after insert) {
    /** Record type 'Grievance' **/
    private static final String GRIEVANCE = 'Grievance';
    if(GrievanceTriggerSupport.isFirstExecution()){
        
        //Get Grievance recordtype id. 
        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = caseDescribe.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get(GRIEVANCE);
        
        if(rtByName !=null){
            /** Create a set of CaseComment record's parent case ids. **/        
            Set<Id> parentIdSet = new Set<Id>();
            for(CaseComment  record : Trigger.new){
                parentIdSet.add(record.ParentId);
            }

            /** Fetch Parent Case records (with 'Grievance' recordtype only) and create a set of case record ids. **/        
            Set<Id> grievanceRecordIds = new Set<Id>(); 
            for(Case caseRecord : [select id, RecordTypeId from Case where id IN : parentIdSet AND RecordTypeId =: rtByName.getRecordTypeId()]){
                grievanceRecordIds.add(caseRecord.id);
            }
        
            /** Find only 'Grievance' Case record's CaseComments only and create a Set of such caseComment record ids (ids are converted into String). **/
            Set<Id> caseCommentIds = new Set<Id>();
            Set<String> recIdsStrSet = new Set<String>(); 
            for(CaseComment caCommentRecord : Trigger.newMap.values()){
                if(grievanceRecordIds.contains(caCommentRecord.ParentId)){
                    recIdsStrSet.add(String.valueOf(caCommentRecord.id));
                }
            }      
            
            List<Call_back__c> existingCallBackRecs = new List<Call_Back__c>();     
            List<Call_back__c> newCallBackRecs = new List<Call_Back__c>();
            
            /** Find a list of existing Call_Back__c records corresponing to CaseComments. **/            
            existingCallBackRecs = [select id,CaseCommentID__c from Call_Back__c where CaseCommentID__c IN :recIdsStrSet];
            
            Set<Id> setOfIds = new Set<Id>();
            for(Call_Back__c caCm : existingCallBackRecs ){
              setOfIds.add(Id.valueOf(caCm.CaseCommentID__c));
            }
            system.debug('setOfIds:'+setOfIds);
            
            /** If any CaseComment record does not have a corresponding Call_Back__c record then create a list of Call_Back__c records in 'newCallBackRecs'. **/
            for(CaseComment caComm : Trigger.new){
               if(grievanceRecordIds.contains(caComm.ParentId)){
                    system.debug('caComm.Id:'+caComm.Id);
                    if(!setOfIds.contains(caComm.Id)){
                        system.debug('not found:'+caComm.Id);               
                        newCallBackRecs.add(new Call_Back__c (Notes__c=caComm.CommentBody,CaseCommentID__c=String.valueOf(caComm.id), Parent_Case__c=caComm.parentId));                 
                    }
               }
            }
            system.debug('newCallBackRecs='+newCallBackRecs);   
            
            /** If 'newCallBackRecs' list is not empty then insert records. **/
            if(newCallBackRecs.size() > 0){
                Database.insert(newCallBackRecs);
            }  
         }   
    
    }
}