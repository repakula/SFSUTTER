/**
   @Author      : Shakti Mehtani
   @name        : DeliverabilityCheck
   @CreateDate  : 01/14/2015 (DD/MM/YYYY)
   @Description : Class for processing Queued up Deliverability E-Mails
   @Version     : 1.0
   @reference   : NA
*/
public class DeliverabilityCheck {
     
    private integer emailInvocations;
    Email_Invocation_Limit__c eilObj;

    /**
    * @author       :   Shakti Mehtani
    * @date         :   01/14/2015 (DD/MM/YYYY)
    * @description  :   Constructor
    * @param        :   N/A
    * @return       :   N/A
    */ 
    public DeliverabilityCheck() {
        eilObj = Email_Invocation_Limit__c.getValues('Email Invocations');
        emailInvocations=integer.valueOf(eilObj.Daily_Limit__c);
    }
    
    
    /**
    * @author       :   Shakti Mehtani
    * @date         :   01/14/2015 (DD/MM/YYYY)
    * @description  :   Processes queued up Deliverability E-Mails
    * @param        :   N/A
    * @return       :   N/A
    */
    public void sendDeliverabilityEmails(set<id> p_contactIdSet) { 
        
        try { 
            list<Messaging.SendEmailResult> resultList;
            list<Contact_Validation_Summary__c> cvsList;
            
            map<id,Contact_Validation_Summary__c> contactId_cvs_map = new map<id,Contact_Validation_Summary__c>();
            map<id,String> faliedContactId_errMsg_map = new map<id,String>();

            set<Id> contactIdSet = new set<Id>();
            set<Id> failedEmailContactIdSet = new set<Id>();
                        
            String qryStr;
            String errStr;
            Contact_Validation_Summary__c cvsObj;
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            String emailTemplateId = [Select id from EmailTemplate where name = 'Provider Community: Deliveribilty Email'].id;
            
            getMassEmailLimit();
            
            qryStr = 'SELECT contact_id__c, createdDate FROM Contact_Validation_Summary__c WHERE Deliverability_Email_Sent__c = false ';
            qryStr += 'AND contact_id__r.is_portal_user__c = true ';
            
             if(p_contactIdSet != null && p_contactIdSet.size() > 0) qryStr += 'AND contact_id__c IN :p_contactIdSet';
            
            qryStr += ' ORDER BY createdDate ASC LIMIT ' + emailInvocations;
            cvsList = database.query(qryStr);
            
            for(Contact_Validation_Summary__c temp : cvsList) {
                contactId_cvs_map.put(temp.contact_id__c,temp);         
            }
            
            contactIdSet = contactId_cvs_map.keySet();
                  
            mail.setTargetObjectIds(new list<id>(contactIdSet));
            mail.setTemplateID(emailTemplateId);
            resultList = Messaging.sendEmail(new Messaging.MassEmailMessage[] {mail});  
            
            /*Creating MAP [Failed E-Mail Contact ID : Error string]*/
            for(Messaging.SendEmailResult temp : resultList) {
                if (!temp.isSuccess()) {
                    errStr = 'STATUS CODE : ' + temp.getErrors()[0].getStatusCode();
                    errStr += '\r\n';
                    errStr += 'MESSAGE : ' + temp.getErrors()[0].getMessage();
                    faliedContactId_errMsg_map.put(temp.getErrors()[0].getTargetObjectId(),errStr);
                }
            }
            
            failedEmailContactIdSet = faliedContactId_errMsg_map.keySet();
            
            /*Updating Deliverability_Email_Sent__c = true*/
            if(failedEmailContactIdSet.size() < contactIdSet.size()) {
                for(id tempId : contactIdSet) {
                    if(!failedEmailContactIdSet.contains(tempId)) {
                        cvsObj = contactId_cvs_map.get(tempId);
                        cvsObj.Deliverability_Email_Sent__c = true;
                        contactId_cvs_map.put(tempId,cvsObj);       
                    }
                }
                
                cvsList = contactId_cvs_map.values();
                update cvsList;
            }
    
                
            /*Creating Error String for Error Log*/
            for(id tempId : faliedContactId_errMsg_map.keySet()) {
                errStr = 'CONTACT ID : ' + tempId + '\r\n';
                errStr += faliedContactId_errMsg_map.get(tempId) + '\r\n\r\n';
                
            }
            
            Utility.handleExceptionFromCode('---DELIVERABILITY CHECK MASS EMAIL FAILURE---' + '\r\n' + System.now() + '\r\n\r\n' + errStr);
            
        } catch(Exception ex) {
           
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author       :   OffshoreTeam
    * @date         :   01/15/2015 (DD/MM/YYYY)
    * @description  :   Counter for checking daily limit.
    * @param        :   N/A
    * @return       :   N/A
    */
    public void getMassEmailLimit()
    {
       
            try{
                Messaging.reserveMassEmailCapacity(emailInvocations);
                }
            catch (Exception e)
                {
                emailInvocations=emailInvocations-10;
                getMassEmailLimit();
                System.debug('You have used up your daily allowance of mails');
                }
    
    }
    
 }