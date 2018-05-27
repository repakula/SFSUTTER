/*****************************************************
Class Name: BatchUpdateDuplicateProvidersQueue 
Created By: Nagarjuna Kaipu
Created Date: 28/07/2016
Description: this batch class is used to update the duplicate phone number records with duplicate queue
*****************************************************/
global class BatchUpdateDuplicateProvidersQueue implements Database.Batchable<sObject>{
    global List<String> lstPhoneNumbers = new List<String>();
    
    /* Name: Start
*Input: Batchable Context
* Return Type: Database.QueryLocator
* Description: Used to get the list if records to pass to execute method
*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //Querying Duplicate Phone Numbers
        AggregateResult[] arrDupPhoneNumbers = [select Secure_Phone__c from contact_validation_summary__c 
                                                where Secure_Phone__c != null and PDI_Campaign__c = :Label.CL176_PDI_Current_Campaign_Name and status__c in (:Label.CL185_PDI_Non_Validated_Status, :Label.CL186_PDI_Accepted_Status)  
                                                group by Secure_Phone__c having  count(secure_phone__c) >1 limit 50000];
        for(AggregateResult arr: arrDupPhoneNumbers)
        {
            lstPhoneNumbers.Add(String.ValueOf(arr.get('Secure_Phone__c')));
        }
        //Querying duplicate phone number provider summary records.
        String query = 'SELECT ID, PDI_Campaign__c FROM Contact_Validation_Summary__c WHERE PDI_Campaign__c = \''+Label.CL176_PDI_Current_Campaign_Name+'\' AND Status__c != \''+Label.CL187_PDI_Validated_Status+'\' AND Secure_Phone__c IN: lstPhoneNumbers';
        return Database.getQueryLocator(query);
        
    }
    /* Name: Execute
*Input: List of Summary records
* Return Type: void
* Description:Used to assign duplicate phone number provider records to Duplicate Queue
*/
    global void execute(Database.BatchableContext BC, List<Contact_Validation_Summary__c> existingProvidersSummaryList)
    {
        List<Contact_Validation_Summary__c> providerSummaryRecordsToUpdate = 
            new List<Contact_Validation_Summary__c>();
        SystemException__c systemException = new SystemException__c();
        try
        {
            //Querying Duplicate Queue
            Group que = [Select Id, name from group where type = 'queue' and Name =: Label.CL382_PDIDuplicatePhoneNumberQueue Limit 1];
            
            for(Contact_Validation_Summary__c providerSummaryRecord: existingProvidersSummaryList)
            {
                //Setting PDI Campaign name to Old Campaign Name
                providerSummaryRecord.OwnerId = que.Id;
                //Adding to list to update the Provider Summary records with Campaign Name and provider service statuses
                providerSummaryRecordsToUpdate.add(providerSummaryRecord);
            }
            //Updating Provider Summary records
            update providerSummaryRecordsToUpdate;
            
        } catch(Exception ex) {
            systemException.ExceptionMessage__c = ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now(); insert systemException;
        }
    }
    /* Name: finish
*Input: Batchable Context
* Return Type: void
* Description: Used to log the status
*/
    global void finish(Database.BatchableContext BC)
    {
        
    }
}