/*****************************************************
Class Name: BatchAutoAssignPhoneRecordsToAgents 
Created By: Nagarjuna Kaipu
Created Date: 13/09/2016
Description: This batch class is used to auto assign the non validated duplicate phone number records to agents based selected criteria
*****************************************************/
global class BatchAutoAssignPhoneRecordsToAgents implements Database.Batchable<sObject>, Database.Stateful {
    private Map<Id, User> selectedUsers = new Map<Id, User>();
    private Integer recordCount ;
    /* Name: Start
*Input: Batchable Context
* Return Type: Database.QueryLocator
* Description: Used to get the list if records to pass to execute method
*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //Gettting selected criteria field values from custom settings
        PDIAutoAssignSelectedCriteria__c selectedCriteria = 
            PDIAutoAssignSelectedCriteria__c.getInstance(Label.CL201_AutoAssignSelectedCriteria);
        recordCount = Integer.valueOf(selectedCriteria.Record_Count_Per_Agent__c);
        //Querying the Non Validated duplicate Providers queue id from the queue object
        Group dupQue = [Select Id, name from group where type =: Label.CL411_PDIQueueAPI and Name =: Label.CL412_PDINonValidatedDuplicateQueue Limit 1];
        //Querying Non-Validated pohne records to assign to the agents
        String query = 'SELECT Name, Tech_Phone_Number__c, NonValidatedCount__c, PDI_Campaign__c FROM ProvidersByPhoneNumber__c'
            +' WHERE NonValidatedCount__c != 0 AND OwnerId = \''+dupQue.Id+'\' AND  PDI_Campaign__C = \''+Label.CL176_PDI_Current_Campaign_Name+'\'';
        return Database.getQueryLocator(query);
    }
    /* Name: Execute
*Input: List of Summary records
* Return Type: void
* Description:Used to auto assign the non validated provider records to agents based on the selected criteria
*/
    global void execute(Database.BatchableContext BC, List<ProvidersByPhoneNumber__c> nonValidatedRecList)
    {
        AutoAssignRecordsToAgentsController autoAssign = new AutoAssignRecordsToAgentsController();
        autoAssign.assignDuplicateRecords(recordCount, nonValidatedRecList);
    }
    /* Name: finish
*Input: Batchable Context
* Return Type: void
* Description: Used to send email notification
*/
    global void finish(Database.BatchableContext BC)
    {
        SystemException__c systemException = new SystemException__c();
        try
        {
            // Get the AsyncApexJob that represents the Batch job using the Id from the BatchableContext 
            AsyncApexJob asynchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                      TotalJobItems, CreatedBy.Email, ExtendedStatus, CompletedDate
                                      from AsyncApexJob where Id = :bc.getJobId() LIMIT 1];        
            
            //below code will send an email to Administrator about the status
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //Getting Orgwide email address
            OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :Label.CL204_ProviderOrgWideEmail LIMIT 1];
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }   
            // Email the Batch Job's submitter that the Job is finished.
            String[] toAddresses = new String[] {asynchJob.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
            mail.setSubject(Label.CL202_AutoAssignSubject + asynchJob.Status);
            mail.setPlainTextBody(Label.CL203_AutoAssignBody +asynchJob.CompletedDate);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(Exception ex) {
            systemException.ExceptionMessage__c = ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now(); insert systemException;
        }
    }
}