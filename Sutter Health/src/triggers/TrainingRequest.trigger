/** 
* Trigger Name : TrainingRequest
* Author : Manish
* Date : 03-Sep-2014
* Project Name: CRM - SFT - Sutter Health
* Description : Written to update Status to 'In Progress' on Owner change from Queue('S3 Training' or 'Revenue Cycle Training') to User.
* Also assign date value to 'Date_ownership_is_taken__c' field.  
**/

trigger TrainingRequest on Case (before update) {
     
    private static final String NEW_STATUS = 'New';               
    private static final String CLOSED_STATUS = 'Closed';        
    private static final String WHATID = 'WhatId';
    private static final String TRAINING_TYPE = 'Training';    
    private static final String TRAINING_S3_QUEUE = 'Training - S3';
    private static final String TRAINING_REVENUE_QUEUE = 'Training - Revenue Cycle';
    private static final String QUEUE = 'Queue';
    
    private static final String IN_PROGRESS = 'In Progress';
    private static final String USER= 'User';
    
    /** @ Description: show this error message if Training Request has open tasks. **/  
    private static final String TASK_NOT_CLOSED_ERRORMSG = 'This Training Request cannot be closed because all of the tasks are not completed.';    

    /** @ Description: List used to store Tasks associated to the Cases.**/  
    List<Task> openTasks = new List<Task>();
    List<Id> checkTaskForCases = new List<Id>();
    
    /** Check only for Cases which have RecordTypeId value for 'Training' recordtype. **/
    try{
         
        Id queue1Id ;
        Id queue2Id ;
        
        /** @ Description: 'isFirstTime = true' to ensure that query executes only once for all Training requests.**/ 
        boolean isFirstTime = true;
        /** @ Description: continue execution if 'Training' RecordType exists for 'Case' object.**/    
        //RecordType recType = [select Id , name from RecordType where sObjectType = 'Case' and Name=: TRAINING_TYPE limit 1];
        Id recType = Schema.SObjectType.Case.RecordTypeInfosByName.get(TRAINING_TYPE).getRecordTypeId();
        
        if(recType !=null){
            /** @ Description: Map of Training request(Case) record ownerids and Training request(Case) records. **/
            Map<Id, Case> userIdCaseRecordMap = new Map<Id, Case>();        
            /** iterate through Trigger.oldMap.values() **/
             List<Group> queueRecords = [select id from Group where (Name =: TRAINING_S3_QUEUE OR Name =: TRAINING_REVENUE_QUEUE) AND Type =: QUEUE limit 2]; 
            for(Case oldRec : Trigger.oldMap.values()){
                /** Description: get corresponding Trigger.new record from Trigger.newMap **/
                Case newRec = Trigger.newMap.get(oldRec.id);
                
                /** Description: Check if request recordtype is a Training request or not. **/ 
                //if(newRec.RecordTypeId == recType.id){
                if(newRec.RecordTypeId == recType ){
                    
                     /** Description: If this record is a Training recordtype and 'isFirstTime' is true then execute query to find out TRAINING_S3_QUEUE or TRAINING_REVENUE_QUEUE queue records. **/  
                     if(isFirstTime){
                                           
                        if(queueRecords != null && queueRecords.size() > 0){                        
                             queue1Id = queueRecords.get(0).id;
                             queue2Id = queueRecords.get(1).id;                                         
                        }
                        //system.debug('queueRecords ='+queueRecords );
                        /** Description: Set 'isFirstTime = false' to skip further executions of this query for other training request records. **/
                        isFirstTime = false;
                    }
                    //system.debug('newRec.status='+newRec.status);
                    /** Description: Check if Status='New' in Trigger.old and Trigger.new record and owner changed from TRAINING_S3_QUEUE or TRAINING_REVENUE_QUEUE queue to 'User'. **/
                    if((oldRec.OwnerId == queue1Id || oldRec.OwnerId == queue2Id ) && (newRec.OwnerId != queue1Id  && newRec.OwnerId != queue2Id)
                      && oldRec.status == NEW_STATUS   &&   newRec.status == NEW_STATUS ){
                        
                        userIdCaseRecordMap.put(newRec.OwnerId, newRec);
                                             
                    }else if(oldRec.status != CLOSED_STATUS && newRec.status == CLOSED_STATUS ){
                        /** Description: Check if Status is 'Closed' now. **/
                        checkTaskForCases.add(newRec.id);
                    } 
                }
            }
            
            /** Description:  If Owner is changed for any training record then execute this block.**/
            if(userIdCaseRecordMap.size() > 0){
                /** Description:  Find out all user records based upon trainingrequest owner ids. **/
                Map<ID, User > usersMap = new Map<ID, User >([SELECT Id, Name FROM User where id IN : userIdCaseRecordMap.keySet()]);
                //system.debug('usersMap='+usersMap);
                if(usersMap != null && usersMap.size() > 0){
                    for(Case caseRecord : userIdCaseRecordMap.values()){
                       //system.debug('usersMap.get(caseRecord.OwnerId)='+usersMap.get(caseRecord.OwnerId));
                       /** Description:  If Owner is a user then set status to 'in progress' and update 'Date_ownership_is_taken__c' field value. **/
                       if(usersMap.get(caseRecord.OwnerId) != null) {
                           userIdCaseRecordMap.get(caseRecord.OwnerId).status = IN_PROGRESS; 
                           userIdCaseRecordMap.get(caseRecord.OwnerId).Date_ownership_is_taken__c = Date.today();
                       }
                       //system.debug('Trigger.newMap.get(caseRecord.id).status ='+Trigger.newMap.get(caseRecord.id).status);  
                       //system.debug('Trigger.newMap.get(caseRecord.id).Date_ownership_is_taken__c ='+Trigger.newMap.get(caseRecord.id).Date_ownership_is_taken__c );
                    }
                }
            }            

            if(checkTaskForCases.size() > 0){           
                /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
                try{
                   /** @ Description: SOQL call to retrieve the Tasks associated to the Case.**/          
                   openTasks = [select Id, WhatId, isClosed From Task Where WhatId IN : checkTaskForCases];         
                } catch(Exception triggerException) {          
                   Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');        
                } 
            
                if(!openTasks.isEmpty()){          
                    /** @ Description: Iterate over the list of Tasks to see if they are not closed.**/      
                    for (Task loopTask: openTasks) {        
                        if(!loopTask.isClosed){          
                            Id mfId = (Id) loopTask.get(WHATID);                
                            /** @ Description: If any Tasks are not closed, it adds an error that does not allow DML operation to occur**/         
                            Case errorTrainingReq = Trigger.newMap.get(mfId);                    
                            /** @ Description: Error Message to  be displayed when there is a case error**/          
                            errorTrainingReq.addError(TASK_NOT_CLOSED_ERRORMSG );         
                        }      
                    }        
                }
            }
        }
        
    }catch(Exception ex){
        system.debug('Exception is:'+ex);
        Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' +  '--------------');
    }
}