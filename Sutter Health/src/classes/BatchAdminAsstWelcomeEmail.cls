/**  
  * Class Name: BatchAdminAsstWelcomeEmail
  * Author: Kishore Jonnadula
  * Date: 03/10/2016
  * Description: This batch class contains the logic to change the email template and send welcome emails to Admin Assistants.
  *				 Again replace the email template with the original email template.
 **/
global class BatchAdminAsstWelcomeEmail implements Database.Batchable<sObject>,Database.AllowsCallouts{
    global List <SystemException__c> batchExceptions = new List < SystemException__c > ();
    static final String errorStr = '@@Error debug : ';
    static final String hyphenStr = '--------------';
    
   /**
	 *   @Description: This is a method to insert exception messages caught by failure of Contacts  update  during Batch Operation.
     *   @Arguments: String exception messages     
     *   @Return: Void
    **/
    global void catchExceptionsFromCode( Database.SaveResult[] results ) {
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                Database.Error[] errs = result.getErrors();
                for(Database.Error err : errs) {
                    SystemException__c systemException = new SystemException__c();
                    systemException.ExceptionMessage__c = err.getMessage();
                    BatchExceptions.add(systemException);
                }
            }
        }
    }
   /* Name: Start
	* Input: Batchable Context
	* Return Type: Database.QueryLocators
 	* Description: Used to get the list of records to pass to execute method
	*/
    global Database.QueryLocator start(Database.BatchableContext BC){
        Id assistantRecordTypeId = [select Id from RecordType where name=:Label.CL468_PDI_AdminAssistant and SObjectType=:Label.CL469_PDI_Contact limit 1].Id;
        
        EmailTemplate providerADID = [select id from EmailTemplate where name=:Label.CL384_PDI_AdminAsstEmailTemplate limit 1];
        ChangeNetworkTemplate objChangeNetwork = new ChangeNetworkTemplate();
        objChangeNetwork.ChangeTemplate(providerADID.id);
        String query = null;
        
        /** Fetching the Admin Assistant Contacts **/
        query = 'Select id from Contact where Email_Alert__c = \'YES\' AND'
                +' Email != null AND Username__c != null AND RecordTypeId = \''+assistantRecordTypeId+'\'';
        
        return Database.getQueryLocator(query);
    }
   /* Name: Execute
    * Input: List of Admin Contacts
    * Return Type: void
    * Used to to change the welcome email template and will send the email to internal providers
    * and update email sent date and time on provider contact
    */
    global void execute(Database.BatchableContext BC, list<Contact> adminContacts){
        try {
            map<id,id> conId_userId_map = new map<id,id>();
            list<Id> conIdList = new list<Id>();
            for(Contact temp : adminContacts){ 
                conIdList.add(temp.id); 
            }
            for(User temp : [select id, contactId from User WHERE IsActive = true and  ContactId IN :conIdList limit 50000]){
                conId_userId_map.put(temp.contactId,temp.id);
            }
            
            for(Contact temp : adminContacts) {
                if(conId_userId_map.get(temp.id) <> null) {
                    system.resetPassword(conId_userId_map.get(temp.id),true);
                    temp.Email_Alert__c = Label.CL225_PDISentOn + system.now();
                }
            }
            
            Database.SaveResult[] resultsUpdateContacts = Database.update(adminContacts, false);
            
            //Exception handling for Contacts Update 
            if(resultsUpdateContacts != null && resultsUpdateContacts.size() > 0) {
                catchExceptionsFromCode(resultsUpdateContacts);
            }
        } catch(Exception e) { System.debug(e.getTypeName() + Label.CL218_rSlashN + e.getCause() + Label.CL218_rSlashN + e.getMessage());
        }
    }
   
   /* Name: finish
    * Input: Batchable Context
    * Return Type: void
    */
    global void finish(Database.BatchableContext BC){
        try{
            if( BatchExceptions != null && BatchExceptions.size() > 0)  {
                Database.insert(BatchExceptions,false);
            }
            EmailTemplate providerNonADID = [select id from EmailTemplate where name=:Label.CL226_PDIExternalWelcomeEmail limit 1];
            ChangeNetworkTemplate objChangeNetwork = new ChangeNetworkTemplate();
            objChangeNetwork.ChangeTemplate(providerNonADID.id);
        }catch( Exception ex){
            system.debug(errorStr + ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + hyphenStr);
            Utility.handleExceptionFromCode(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + hyphenStr);
        }
    }
}