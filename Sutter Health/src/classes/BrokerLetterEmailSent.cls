/*************************************************************************************  
*     Class Name  : BrokerLetterEmailSent                                            *
*     Author      : IDC Offshore                                                     *
*     Date        : 09-Sept-2014                                                     *
*     Project Name: CRM - SFT - Sutter Health                                        *          
*     Description : batch class used for sending Broker letter to Broker.            *    
**************************************************************************************/
global class BrokerLetterEmailSent implements  Database.Batchable<sObject>,Schedulable {
    /* variable section:*/
    global String query;
    static string mailSent = 'Mail Sent';
    static string fromAddress ='salesforce@sutterhealth.org';
    
    /********************************************************************************
    *   @author ......: IDC Team                                                    *  
    *   @date ........: 09/09/2015                                                  *  
    *   @description .: This the default method provided by Schedulable interface.  *
    *                   This method executed by Apex Schedular.                     *
    *   @param........: SchedulableContext                                          *    
    *   @return ......: void                                                        *
    *********************************************************************************/    
    global void execute(SchedulableContext SC) {
        // invoke business logic from Apex Schedular 
        BrokerLetterEmailSent runBatch = new BrokerLetterEmailSent();
        ID batchprocessid = Database.executeBatch(runBatch, 200);
    }
    
    /********************************************************************************
    *   @author ......: IDC Team                                                    *  
    *   @date ........: 09/09/2015                                                  *  
    *   @description .: This the default method provided by Database.Batchable.     *
    *                   This method executed by Apex Schedular.                     *
    *   @param........: Database.BatchableContext                                   *    
    *   @return ......: Database.QueryLocator                                       *
    *********************************************************************************/  
    global Database.QueryLocator start(Database.BatchableContext BC){
      /* dynamic query where status is 'Ready for Email Sent' and limit 400 beacuse bussiness want only 400 mail should be sent on single day*/
      query='select id,Selected_Template__c,Contact__r.Email,contact__r.EmailBouncedReason,status__c,Correspondence_Letter__r.Selected_Template__c from CorrespondenceContactAssociation__c where status__c =\'Ready For Email Sent\' limit 400';
      return Database.getQueryLocator(query);
    }
    
    /********************************************************************************
    *   @author ......: IDC Team                                                    *  
    *   @date ........: 09/09/2015                                                  *  
    *   @description .: This the default method provided by Database.Batchable.     *
    *                   This method executed Database.BatchableContext.             *
    *   @param........: Database.BatchableContext,                                  *
    *                   List<CorrespondenceContactAssociation__c>                   *    
    *   @return ......: void                                                        *
    *********************************************************************************/  
    global void execute(Database.BatchableContext BC, List<CorrespondenceContactAssociation__c> Letter){
        List<Messaging.SingleEmailMessage> lstEmailSent = new List<Messaging.SingleEmailMessage>() ; 
        Map<String,Id> emialtemplate = new map<string,Id>(); 
        // the below query will always return only one result for OrgWideEmailAddress
        OrgWideEmailAddress objOWEA = [select Id from OrgWideEmailAddress where Address =:fromAddress Limit 1];     
        for(CorrespondenceContactAssociation__c objCorrConAssoc : Letter) {  
            if(objCorrConAssoc.contact__r.email!=null && objCorrConAssoc.contact__r.EmailBouncedReason == null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ; 
                mail.setTargetObjectId(objCorrConAssoc.contact__r.id);
                if (objOWEA != null) {
                    mail.setOrgWideEmailAddressId(objOWEA.Id);
                }
                mail.setTemplateId(objCorrConAssoc.Correspondence_Letter__r.Selected_Template__c);
                lstEmailSent.add(mail);
                objCorrConAssoc.status__C = mailSent;
            }      
        }
        if(!lstEmailSent.isEmpty()) {           
            Messaging.sendEmail(lstEmailSent);
            update Letter;
        }
    }
    
    /********************************************************************************
    *   @author ......: IDC Team                                                    *  
    *   @date ........: 09/09/2015                                                  *  
    *   @description .: This the default method provided by Database.Batchable.     *
    *                   This method executed Database.BatchableContext.             *
    *   @param........: Database.BatchableContext,                                  *
    *                   List<CorrespondenceContactAssociation__c>                   *    
    *   @return ......: void                                                        *
    *********************************************************************************/ 
    global void finish(Database.BatchableContext BC){ }    
   
}