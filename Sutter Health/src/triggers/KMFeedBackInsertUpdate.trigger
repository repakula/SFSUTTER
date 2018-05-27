trigger KMFeedBackInsertUpdate on KM_Feedback_Item__c (before insert, before update) {

    if(Trigger.isInsert)
    {
        new VFC18_KM_Feedback().filterKMFeedbackItems(trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isInsert)
    {
        for(KM_Feedback_Item__c km : Trigger.new)
        {
            if(km.Type_of_feedback__c == 'Positive')
            {
                km.Feedback_Reason__c = 'Positive Feedback';
            }
            else if(km.Type_of_feedback__c == 'Negative')
            {
                km.Feedback_Reason__c = 'Negative Feedback';
            }
            else if(km.Type_of_feedback__c == 'Content')
            {
                km.Feedback_Reason__c = 'Content';
            }
            else if(km.Type_of_feedback__c == 'URL Issue')
            {
                km.Feedback_Reason__c = 'URL';
            }
            else if(km.Type_of_feedback__c == 'Access Issue')
            {
                km.Feedback_Reason__c = 'Access Issue';
            }
            else if(km.Type_of_feedback__c == 'Multiple Issues')
            {
                km.Feedback_Reason__c = 'Multiple Issues';
            }
            else
            {
                km.Feedback_Reason__c = 'Other';
            }
        }
    }
    
    system.debug('##############'+trigger.new[0]);
    
    
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        for(KM_Feedback_Item__c km : Trigger.new)
        {
            if(km.Status__c == 'Closed - Completed' || km.Status__c == 'Closed - No Action')
            {
                /** @ Description: List used to store Tasks associated to the Cases.**/
                List<Task> openTasks = new List<Task>();
        
                /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
                try{
                
                    /** @ Description: SOQL call to retrieve the Tasks associated to the Case.**/
                    openTasks = [select Id, WhatId, isClosed From Task Where WhatId In :Trigger.new]; 
                    system.debug('Testing 1');
                } catch(Exception triggerException) {
                    Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                }
                
                /** @ Description: Iterate over the list of Tasks to see if they are not closed.**/
                for (Task loopTask: openTasks) 
                {
                    if(!loopTask.isClosed)
                    {
                        Id kmId = (Id) loopTask.get('WhatId');
                
                        /** @ Description: If any Tasks are not closed, it adds an error that does not allow DML operation to occur**/
                        KM_Feedback_Item__c errorKM = Trigger.newMap.get(kmId);
                        
                        /** @ Description: Error Message to  be displayed when there is a case error**/
                        errorKM.addError('This KM Feedback Item cannot be closed because not all of the tasks are completed'); 
                    }
                }
            }
        }
    }
}