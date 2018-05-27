/** 
* Trigger Name : AccumulateTaskDuration 
* Author : Manish
* Date : 05-Sep-2014
* Project Name: CRM - SFT - Sutter Health
* Description : Written to calculate accumulative duration for all tasks for each Training Request Case. 
**/
trigger AccumulateTaskDuration on Task (before insert, after update) {
    private final static string TRAINING_RECTYPE = 'Training';
    try{
        RecordType recType = [select Id , name from RecordType where sObjectType = 'Case' and Name=: TRAINING_RECTYPE limit 1];
        if(recType != null){
            
            Map<Id, Set<Task>> caseIdTaskMap = new Map<Id,Set<Task>>();
            List<Case> recordtoBeUpdated = new List<Case>(); 
                
            for(Task taskRecord : Trigger.new){
               Set<Task> tasks = new Set<Task>();
                   
               if(caseIdTaskMap.get(taskRecord.WhatId) == null){
                  tasks.add(taskRecord);
                  caseIdTaskMap.put(taskRecord.WhatId, tasks);
               }else{
                  tasks = caseIdTaskMap.get(taskRecord.WhatId);
                  tasks.add(taskRecord);
                  caseIdTaskMap.put(taskRecord.WhatId, tasks);
               }
                                    
            }
                        
                
            for(Case caseRec : [select id, RecordTypeId, Projected_Hours__c, Actual_Level_Of_Effort__c from Case where id IN : caseIdTaskMap.keySet() AND RecordTypeId =: recType.id]){
              system.debug('caseRec ='+caseRec );
               for(Task taskRecord : caseIdTaskMap.get(caseRec.id)){
                  //If it is a before insert trigger call then set 'tasktype= Training'.
                                  
                  if(Trigger.isInsert && Trigger.isBefore){
                  system.debug('entered before'+caserec.id);
                     if(caseRec != null && caseRec.id != null){
                          if(caseRec.Projected_Hours__c != null ){
                               system.debug('entered projected hours'+taskRecord.Projected_Hours__c);
                               caseRec.Projected_Hours__c = caseRec.Projected_Hours__c + taskRecord.Projected_Hours__c ;
                            }else{ 
                               system.debug('entered projected hours'+taskRecord.Projected_Hours__c);
                               caseRec.Projected_Hours__c = taskRecord.Projected_Hours__c;
                            }
                      if(taskRecord.Status == 'Completed'  ){
                 
                            if(caseRec.Actual_Level_Of_Effort__c != null ){
                               caseRec.Actual_Level_Of_Effort__c = caseRec.Actual_Level_Of_Effort__c + taskRecord.Actual_Hours__c ;
                            }else{
                               caseRec.Actual_Level_Of_Effort__c = taskRecord.Actual_Hours__c;
                            }
                            
                        }
                        recordtoBeUpdated.add(caseRec);
                    }
                  
                   // taskRecord.tasktype__c = TRAINING_RECTYPE;
                  }
                  else if(Trigger.isUpdate && Trigger.isAfter){
                    //If it is a after update trigger call then add actual hours of task to actual level of efforts in case.                 
                    if(taskRecord.Status == 'Completed'  &&  Trigger.oldMap.get(taskRecord.id).Status != 'Completed' && taskRecord.Completed_Date__c == null){                        //Removed the condition on 19 Sept 14&& taskRecord.Completed_Date__c == null
                        if(caseRec != null && caseRec.id != null){
                            if(caseRec.Actual_Level_Of_Effort__c != null ){
                               caseRec.Actual_Level_Of_Effort__c = caseRec.Actual_Level_Of_Effort__c + taskRecord.Actual_Hours__c ;
                            }else{
                               caseRec.Actual_Level_Of_Effort__c = taskRecord.Actual_Hours__c;
                            }
                            recordtoBeUpdated.add(caseRec);
                        }
                    }
                 }              
              }
            }              
            system.debug('before update recordtoBeUpdated='+ recordtoBeUpdated); 
            //update case records in after update.
            if(recordtoBeUpdated.size() > 0){
               update recordtoBeUpdated;
            }
            system.debug('after update in task: recordtoBeUpdated='+ recordtoBeUpdated);    
        }else{
            system.debug('Trigger: Could not find Training recordtypeon Case. Skipping triggers execution.');
        }
    }catch(Exception triggerException){
        Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
    }
}