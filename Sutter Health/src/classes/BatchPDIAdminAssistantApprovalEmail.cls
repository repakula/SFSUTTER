/*****************************************************
Class Name: BatchPDIAdminAssistantApprovalEmail
Created By: Nagarjuna Kaipu
Created Date: 15/11/2016
Description: used to send admin assistant confirmation emails to providers
******************************************************/
global class BatchPDIAdminAssistantApprovalEmail implements Database.Batchable<sObject>, Database.Stateful
{
    public String query;
    global String errMsg = null;
    /* Name: Start
*Input: Batchable Context
* Return Type: Database.QueryLocators
* Description: Used to get the list of records to pass to execute method
*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    /* Name: Execute
*Input: List of Summary records
* Return Type: void
* Used to to send follow up emails to external providers
*/
    global void execute(Database.BatchableContext BC, list<Contact_Validation_Summary__c> providerList)
    {
        SystemException__c systemException = new SystemException__c();
        try{
            list<OrgWideEmailAddress> owea = new list<OrgWideEmailAddress>();
            list<Messaging.SendEmailResult> resultList = new list<Messaging.SendEmailResult>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String emailTemplateId = null;
            owea = [select Id from OrgWideEmailAddress where Address = :Label.CL204_ProviderOrgWideEmail limit 1];
            emailTemplateId = [Select id from EmailTemplate where name =: Label.CL598_PDIAdminApprovalEmailTemplate limit 1].id; 
            List<Contact_Validation_Summary__c> emailSentList = new List<Contact_Validation_Summary__c>();
            for(Contact_Validation_Summary__c sum : providerList) 
            {
                Messaging.reserveSingleEmailCapacity(1);  
                mail = new Messaging.SingleEmailMessage();
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                mail.setWhatId(sum.Id);
                mail.setTargetObjectId(sum.Contact_Id__c);
                mail.setToAddresses(new String[]{sum.Email__c});
                mail.setTemplateId(emailTemplateId);
                mail.SaveAsActivity = false;
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                sum.Admin_Approval_Status_Email_Sent_On__c = System.now();
                sum.Tech_Success_Email__c = false;
                emailSentList.add(sum);
            }
            if(!emailSentList.isEmpty()){
                update emailSentList;
            }
        } catch(Exception ex) {
            systemException.ExceptionMessage__c = ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now(); insert systemException;
        }
    }   
    /* Name: finish
*Input: Batchable Context
* Return Type: void
*/
    global void finish(Database.BatchableContext BC)
    {
        //Querying Job id and other attributes 
        AsyncApexJob a = [SELECT id, ApexClassId,
                          JobItemsProcessed, TotalJobItems,
                          NumberOfErrors, CreatedBy.Email, CompletedDate
                          FROM AsyncApexJob
                          WHERE id = :BC.getJobId()];
    }
}