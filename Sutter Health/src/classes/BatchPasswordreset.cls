/**
@Author      : IDC Offshore
@name        : BatchPasswordreset Class
@CreateDate  : 01/03/2015 (DD/MM/YYYY)
@Description : Class for sending the Welcome Email with dynamic password change url.
@Version     : 1.0
@reference   : NA

History
--------
Version  Author               Date        Detail 
1.0     IDC Offshore        01/03/2015  Class for sending the Welcome Email with dynamic password change url.
2.0     IDC Offshore        12/04/2016  PDI Wave1 Code changes - Sending remainder Emails to External Providers for every 5 days up to 3 times.
*/
global class BatchPasswordreset implements Database.Batchable<sObject>, Database.Stateful
{
    global String errMsg = null;
    public String query;
    public String printedFloor;

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
    global void execute(Database.BatchableContext BC, list<Contact_Validation_Summary__c> nvcList)
    {
        try {
            map<id,id> conId_userId_map = new map<id,id>();
            map<id,list<Messaging.SendEmailResult>> conId_serList_map = new  map<id,list<Messaging.SendEmailResult>>();
            map<id,Contact_Validation_Summary__c> conId_cvsObj_map = new map<id,Contact_Validation_Summary__c>();
            list<OrgWideEmailAddress> owea = new list<OrgWideEmailAddress>();
            list<Id> conIdList = new list<Id>();
            list<Messaging.SendEmailResult> resultList = new list<Messaging.SendEmailResult>();
            String emailTemplateId = null;
            Contact_Validation_Summary__c cvsObj = new Contact_Validation_Summary__c();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            for(Contact_Validation_Summary__c temp : nvcList) 
            {
                conIdList.add(temp.contact_id__c); 
            }
            
            for(User temp : [select id, contactId from User WHERE IsActive = true and  ContactId IN :conIdList limit 50000]) 
            {
                conId_userId_map.put(temp.contactId,temp.id);
            }
            
            Map<id,string> loginstatus = new Map<id,string>();
            
            for(LoginHistory temp: [Select Id, Status,UserId from LoginHistory WHERE 
                                    UserId  IN : conId_userId_map.values() limit 50000]){
                                        if(temp.Status.contains(Label.CL216_PDISuccess)){
                                            loginstatus.put(temp.UserId,temp.Status);
                                        }
                                    }
            if(Test.isRunningTest()){
                loginstatus = PDIPasswordResetHelper.testRecordHelper(nvcList, conId_userId_map);
            }
            for(Contact_Validation_Summary__c temp : nvcList) {
                if(loginstatus.containsKey(conId_userId_map.get(temp.contact_id__c))) {
                    conId_cvsObj_map.put(temp.contact_id__c,temp); 
                } else if(conId_userId_map.get(temp.contact_id__c) <> null) {
                    if(temp.Contact_Id__r.Provider_Type__c == Label.CL602_PDIInternalText){
                        conId_cvsObj_map.put(temp.contact_id__c,temp);
                    }else{
                        system.resetPassword(conId_userId_map.get(temp.contact_id__c),true);
                        if(temp.Welcome_Email_Sent_History__c != null)
                        {  
                            temp.Welcome_Email_Sent_History__c +=  Label.CL223_PasswordWelcomeEmailSentOn + system.now();
                        }
                        else
                        {
                            temp.Welcome_Email_Sent_History__c =  Label.CL223_PasswordWelcomeEmailSentOn + system.now();
                        }
                        temp.Printed_Floor__c = printedFloor;
                        temp.Tech_Success_Email__c = false;
                    }
                }           
            }
            
            Database.update(nvcList);
            if (conId_cvsObj_map.size() > 0) {
                owea = [select Id from OrgWideEmailAddress where Address = :Label.CL204_ProviderOrgWideEmail limit 1];
                String externalTemplateId = [Select id from EmailTemplate where name = :Label.CL222_ExternalFollowUpEmailTemplate limit 1].id;
                String internalTemplateId = [Select id from EmailTemplate where name = :Label.CL224_PDIInternalWelcomeEmailTemplate limit 1].id;
                
                for(ID c : conId_cvsObj_map.keySet()) {
                    Messaging.reserveSingleEmailCapacity(1);  
                    mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    mail.setTargetObjectId(c);
                    if(conId_cvsObj_map.get(c).Contact_Id__r.Provider_Type__c == Label.CL602_PDIInternalText && conId_cvsObj_map.get(c).Contact_Id__r.Employee_ADID__c != null){
                        emailTemplateId = internalTemplateId;
                    }
                    else if(conId_cvsObj_map.get(c).Contact_Id__r.Provider_Type__c == 'External'){
                        emailTemplateId = externalTemplateId;
                    }
                    mail.setTemplateId(emailTemplateId);
                    resultList=Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    conId_serList_map.put(c,resultList);                 
                }
                
                if(conId_serList_map.size()>0) {
                    for(Id tempId : conId_serList_map.keySet()) {
                        resultList = conId_serList_map.get(tempId);
                        
                        if (resultList[0].isSuccess()) {
                            cvsObj  = conId_cvsObj_map.get(tempId);
                            if(cvsObj.Welcome_Email_Sent_History__c != null)
                            {
                                cvsObj.Welcome_Email_Sent_History__c += Label.CL221_WelcomeEmailSentOn + system.now();
                            }
                            else
                            {
                                cvsObj.Welcome_Email_Sent_History__c = Label.CL221_WelcomeEmailSentOn + system.now();
                            }
                            cvsObj.Printed_Floor__c = printedFloor;
                            cvsObj.Tech_Success_Email__c = false;
                            conId_cvsObj_map.put(tempId,cvsObj);  
                        } else {
                            errMsg = Label.CL219_rSlashNContactId + tempId + Label.CL220_rSlashNMessage + resultList[0].getErrors()[0].getMessage();
                            
                        }
                    }
                }
                if(conId_cvsObj_map.size() > 0) 
                {
                    Database.update(conId_cvsObj_map.values()); 
                }
            } 
        } catch(Exception ex) {
            errMsg = ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN;
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
        SystemException__c systemException = new SystemException__c();
        if(String.isNotBlank(errMsg)){
            systemException.ExceptionMessage__c ='BatchPasswordreset has finished at'+a.CompletedDate+''+ errMsg; insert systemException;
        }
        
    }
}