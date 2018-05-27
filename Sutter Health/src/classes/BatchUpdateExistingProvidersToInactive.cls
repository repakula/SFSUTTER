/*****************************************************
Class Name: BatchUpdateExistingProvidersToInactive
Created By: Nagarjuna Kaipu
Created Date: 01/04/2016
Description: This class is used to update all the existing provider summary records with inactive status in Salesforce system.
*****************************************************/
global class BatchUpdateExistingProvidersToInactive implements Database.Batchable<sObject>, Database.Stateful
{   
    global String errMsg = '';
    global Integer totalCount = 0;
    global Integer successCount = 0;
    global Integer errorCount = 0;
    global String query;
    
    /* Name: Start
*Input: Batchable Context
* Return Type: Database.QueryLocator
* Description: Used to get the list of records to pass to execute method
*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //Querying existing active status provider,() contact records.
        query = 'SELECT Id, Email, Provider_Active_Status__c, Provider_Practicing_Physician__c, Provider_Resigned_From_Sutter__c, Provider_Retired_Departed__c,'
            +' Provider_Admin_Assistant_Title__c, Provider_Admin_Assistant__c, Provider_Admin_Assistant_Email__c,'
            +' Provider_Admin_Assistant_Phone__c, Provider_Delegate_Phone_Ext__c,'                       
            +' (SELECT Id, Email__c, Contact_Id__c, Admin_Assistant_Title__c, Admin_Assistant__c,'
            +' Admin_Assistant_Email__c, Admin_Assistant_Phone__c, Delegate_Phone_Ext__c, Practicing_Physician__c,'
            +' Resigned_From_Sutter__c, Retired_Departed__c, Is_Resigned_Provider_refer__c,'
            +' PDI_Campaign__c From Summarys__r where PDI_Campaign__c = \''+Label.CL176_PDI_Current_Campaign_Name+'\') from Contact'
            +' WHERE Provider_Active_Status__c = true' 
            +' AND RecordType.Name =\''+Label.CL178_PDI_Provider_Rec_Type+'\'';
        
        return Database.getQueryLocator(query);
    }
    /* Name: Execute
*Input: List of contacts
* Return Type: void
* Used to update provider active status to inactive
*/
    global void execute(Database.BatchableContext BC, List<Contact> providerList)
    {
        SystemException__c systemException = new SystemException__c();
        List<Contact> providerListToUpdate = new List<Contact>();
        try
        {
            for(Contact providerContact: providerList)
            {
                //Setting Status to InActive
                providerContact.Provider_Active_Status__c = false;
                for(Contact_Validation_Summary__c summary: providerContact.Summarys__r){
                    if(summary.PDI_Campaign__c == Label.CL176_PDI_Current_Campaign_Name){
                        providerContact.Provider_Practicing_Physician__c = summary.Practicing_Physician__c;
                        providerContact.Provider_Resigned_From_Sutter__c = summary.Resigned_From_Sutter__c;
                        providerContact.Provider_Retired_Departed__c = summary.Retired_Departed__c;
                        providerContact.Email = summary.Email__c;
                        providerContact.Provider_Admin_Assistant_Title__c = summary.Admin_Assistant_Title__c;
                        providerContact.Provider_Admin_Assistant__c =  summary.Admin_Assistant__c;
                        providerContact.Provider_Admin_Assistant_Email__c = summary.Admin_Assistant_Email__c;
                        providerContact.Provider_Admin_Assistant_Phone__c = summary.Admin_Assistant_Phone__c;
                        providerContact.Provider_Delegate_Phone_Ext__c = summary.Delegate_Phone_Ext__c;
                        providerListToUpdate.add(providerContact);
                    }
                    
                }
            }
            System.debug('providerListToUpdate is: '+providerListToUpdate);
            //updating provider contact records with InActive status
            Database.SaveResult[] updateList = Database.update(providerListToUpdate, false);
            for(Database.SaveResult dsr : updateList){
                if(!dsr.isSuccess()){
                    errMsg = dsr.getErrors()[0].getMessage(); errorCount++;
                }
                else
                {
                    successCount++;
                }
                totalCount++;
            }
        }catch(Exception ex){
            systemException.ExceptionMessage__c = ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now(); insert systemException;
        }
    }
    /* Name: finish
*Input: Batchable Context
* Return Type: void
* Description: Used to log the job status
*/
    global void finish(Database.BatchableContext BC)
    {
        SystemException__c systemException = new SystemException__c();
        //Querying Job id and other attributes 
        AsyncApexJob a = [SELECT id, ApexClassId,
                          JobItemsProcessed, TotalJobItems,
                          NumberOfErrors, CreatedBy.Email, CompletedDate
                          FROM AsyncApexJob
                          WHERE id = :BC.getJobId()];
        if(totalCount != 0 && (errorCount != 0 || successCount != 0))
        {
            systemException.ExceptionMessage__c = 'Your batch job '
                + 'BatchUpdateExistingProvidersToInactive '
                + 'has finished at '+a.CompletedDate+'. Out of '
                +totalCount+' records, There were '
                +successCount+' success records and '
                +errorCount+' error records. '
                +errMsg ;
            insert systemException;
        }
        else 
        {
            systemException.ExceptionMessage__c = 'Your batch job BatchUpdateExistingProvidersToInactive has finished at '
                +a.CompletedDate+'. There were no records processed as part of this batch job';
            insert systemException;
        }
    }
}