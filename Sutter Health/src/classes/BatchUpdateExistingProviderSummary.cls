/*****************************************************
Class Name: BatchUpdateExistingProviderSummary 
Created By: Nagarjuna Kaipu
Created Date: 18/03/2016
Description: This class is used to update the existing Provider Summary records 
with PDI Campaign Name based on the threshold date
*****************************************************/
global class BatchUpdateExistingProviderSummary implements Database.Batchable<sObject>, Database.Stateful
{
    global String errMsg = '';
    global Integer totalCount = 0;
    global Integer successCount = 0;
    global Integer errorCount = 0;
    
    /* Name: Start
*Input: Batchable Context
* Return Type: Database.QueryLocator
* Description: Used to get the list if records to pass to execute method
*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //Querying existing provider summary records.
        String query = 'SELECT ID, PDI_Campaign__c, createdDate, Practicing_Physician__c, Retired_Departed__c, Resigned_From_Sutter__c, contact_Id__r.Provider_Service_Status__c'
            +' FROM Contact_Validation_Summary__c WHERE PDI_Campaign__c = null';
        return Database.getQueryLocator(query);
    }
    /* Name: Execute
*Input: List of Summary records
* Return Type: void
* Description:Used to update PDI campaign name and provider service status picklist values
*/
    global void execute(Database.BatchableContext BC, List<Contact_Validation_Summary__c> existingProvidersSummaryList)
    {
        List<Contact_Validation_Summary__c> providerSummaryRecordsToUpdate = 
            new List<Contact_Validation_Summary__c>();
        SystemException__c systemException = new SystemException__c();
        try
        {
            for(Contact_Validation_Summary__c providerSummaryRecord: existingProvidersSummaryList)
            {
                //Setting PDI Campaign name to Old Campaign Name
                providerSummaryRecord.PDI_Campaign__c = Label.CL175_PDI_Old_Campaign_Name;
                //Adding to list to update the Provider Summary records with Campaign Name and provider service statuses
                providerSummaryRecordsToUpdate.add(providerSummaryRecord);
            }
            //Updating with campaign flag and status chekboxes
            Database.SaveResult[] recordsToUpdate = 
                Database.update(providerSummaryRecordsToUpdate, false);
            
            for(Database.SaveResult dsr : recordsToUpdate){
                if(!dsr.isSuccess()){
                    errMsg = dsr.getErrors()[0].getMessage(); errorCount++;
                }
                else
                {
                    successCount++;
                }
                totalCount++;
            }
            
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
        //Send an email to the User after your batch completes 
        AsyncApexJob a = [SELECT id, ApexClassId,
                          JobItemsProcessed, TotalJobItems,
                          NumberOfErrors, CreatedBy.Email, CompletedDate
                          FROM AsyncApexJob
                          WHERE id = :BC.getJobId()];
        SystemException__c systemException = new SystemException__c();
        if(totalCount != 0 && (errorCount != 0 || successCount != 0))
        {
            systemException.ExceptionMessage__c = 'Your batch job '
                + 'BatchUpdateExistingProviderSummary '
                + 'has finished at '+a.CompletedDate+'. Out of '
                +totalCount+' records, There were '
                +successCount+' success records and '
                +errorCount+' error records. '
                +errMsg ;
            insert systemException;
        }
        else 
        {
            systemException.ExceptionMessage__c = 'Your batch job BatchUpdateExistingProviderSummary has finished at '
                +a.CompletedDate+'. There were no records processed as part of this batch job' ;
            insert systemException;
        }
    }
}