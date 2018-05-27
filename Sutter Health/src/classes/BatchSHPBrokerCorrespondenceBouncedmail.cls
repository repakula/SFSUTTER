/*************************************************************************************  
*     Class Name  : BatchSHPBrokerCorrespondenceBouncedmail                          *
*     Author      : IDC Offshore                                                     *
*     Date        : 09-Sept-2014                                                     *
*     Project Name: CRM - SFT - Sutter Health                                        *          
*     Description : batch class used for updating bounced correspondence mail for    *
*                   borker.                                                          *    
**************************************************************************************/

global class BatchSHPBrokerCorrespondenceBouncedmail implements Database.Batchable<sObject>,schedulable {
    global String query;
    static String strRecordTypeBrokerRO = '\'SHP_Sales_Broker_Contact_Read_Only\'';
    static String strRecordTypeBroker = '\'SHP_Sales_Broker_Contact\'';
    static String strMailBounced = 'Mail Bounced';
    
    /********************************************************************************
    *   @author ......: IDC Team                                                    *  
    *   @date ........: 09/09/2015                                                  *  
    *   @description .: This the default method provided by Schedulable interface.  *
    *                   This method executed by Database.Batchable.                 *
    *   @param........: SchedulableContext                                          *    
    *   @return ......: void                                                        *
    *********************************************************************************/  
    global void execute(SchedulableContext SC) {
        // invoke business logic from Apex Schedular 
        BatchSHPBrokerCorrespondenceBouncedmail runBatch = new BatchSHPBrokerCorrespondenceBouncedmail();
        ID batchprocessid = Database.executeBatch(runBatch, 200);
    }
    
    /********************************************************************************
    *   @author ......: IDC Team                                                    *  
    *   @date ........: 09/09/2015                                                  *  
    *   @description .: This the default method provided by Database.Batchable.     *
    *                   This method executed by Database.Batchable.                 *
    *   @param........: Database.BatchableContext                                   *    
    *   @return ......: Database.QueryLocator                                       *
    *********************************************************************************/  
    global Database.QueryLocator start(Database.BatchableContext BC) {  
        /* This is dynamic query which fetch the contact list where EmailBouncedDate is today and recordtype is  SHP Sales Broker Contact or 
            SHP Sales Broker Contact RO' and EmailBouncedReason is not empty*/
        String query = 'SELECT (Select Id, Contact__c, Correspondence_Letter__c,Bounced_Mail_Reasion__c, Selected_Template__c, Status__c  From Correspondence__r),EmailBouncedDate,EmailBouncedReason,RecordType.DeveloperName FROM Contact WHERE (RecordType.DeveloperName = '+strRecordTypeBrokerRO+' OR RecordType.DeveloperName ='+strRecordTypeBroker+') AND  EmailBouncedReason != null AND EmailBouncedDate = TODAY';
        System.debug('@@Query'+query); 
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
    global void execute(Database.BatchableContext BC, List<Contact> lstContact) {
        List<CorrespondenceContactAssociation__c> Letter = new List<CorrespondenceContactAssociation__c>();
        /* if coming contact list is not empty*/
        if(!lstContact.isEmpty()){
            for( Contact objCont: lstContact) {  
                for(CorrespondenceContactAssociation__c objCorrespContAssociation:objCont.Correspondence__r){
                    /* updating the status and Bounced mail Reason  of CorrespondenceContactAssociation__c */
                    objCorrespContAssociation.Status__c = strMailBounced;
                    objCorrespContAssociation.Bounced_Mail_Reasion__c = objCont.EmailBouncedReason; 
                    Letter.add(objCorrespContAssociation);
                }
            }
        }        
        if(!Letter.isEmpty()) {
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
    global void finish(Database.BatchableContext BC) { }
}