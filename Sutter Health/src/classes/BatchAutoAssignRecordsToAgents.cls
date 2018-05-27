/*****************************************************
Class Name: BatchAutoAssignRecordsToAgents 
Created By: Nagarjuna Kaipu
Created Date: 13/04/2016
Description: This batch class is used to auto assign the non validated records to agents based selected criteria
*****************************************************/
global class BatchAutoAssignRecordsToAgents implements Database.Batchable<sObject>, Database.Stateful {
    private Map<Id, User> selectedUsers = new Map<Id, User>();
    private Integer recordCount ;
    private String selectedAssignBasedOn;
    private String selectedSortingOrder;
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
        selectedAssignBasedOn = selectedCriteria.Assign_Based_On__c;
        selectedSortingOrder = selectedCriteria.Sorting_Order__c;
        //Querying the Non Validated Providers queue id from the queue object
        Group que = [Select Id, name from group where type = 'queue' 
                     and Name =: Label.CL211_PDIQueue Limit 1];
        //Querying Non-Validated records to assign to the agents
        String query = 'SELECT Id, Owner.Id, Name, Assigned_Date__c, Closed_Date__c, PDI_Campaign__C, Retired_Departed__c, Provider_Active_Status__c, ' 
            +'Status__c, Provider_FirstName__c, Provider_LastName__c, Provider_NPI_F__c, Tech_Last_Verified_Date__c FROM Contact_Validation_Summary__c'
            +' WHERE OwnerId = \''+que.Id+'\' AND  PDI_Campaign__C = \''
            +Label.CL176_PDI_Current_Campaign_Name+'\' AND'
            +' Retired_Departed__c != true AND Provider_Active_Status__c = true AND '
            +' Status__c = \''+Label.CL185_PDI_Non_Validated_Status+'\' ORDER BY '
            +selectedAssignBasedOn +' '
            +selectedSortingOrder+' NULLS LAST';
        return Database.getQueryLocator(query);
    }
    /* Name: Execute
*Input: List of Summary records
* Return Type: void
* Description:Used to auto assign the non validated provider records to agents based on the selected criteria
*/
    global void execute(Database.BatchableContext BC, List<Contact_Validation_Summary__c> nonValidatedRecList)
    {
        AutoAssignRecordsToAgentsController autoAssign = new AutoAssignRecordsToAgentsController();
        autoAssign.AssignToAgents(recordCount, nonValidatedRecList);
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