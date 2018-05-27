/**
   @Author      : IDC Offshore
   @name        : BatchPasswordreset Class
   @CreateDate  : 01/03/2015 (DD/MM/YYYY)
   @Description : REQ 3399 - Class for sending the Welcome Email with dynamic password change url.
   @Version     : 1.0
   @reference   : NA
*/

global class BatchPasswordresetTeleForm implements Database.Batchable<sObject>,Database.AllowsCallouts{

    global List <SystemException__c> BatchExceptions = new List < SystemException__c > ();
    
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

    global Database.QueryLocator start(Database.BatchableContext BC){
    
        EmailTemplate ProviderTeleForm = [select id from EmailTemplate where name='Provider Community: Provider Welcome Email For TeleForm'];
        ChangeNetworkTemplate objChangeNetwork = new ChangeNetworkTemplate();
        objChangeNetwork.ChangeTemplate(ProviderTeleForm.id);
        
        String query;
        
        /** Fetching the TeleForm Contacts **/
        
        if(test.isRunningTest())
        query = 'Select id from Contact where Source_of_E_mail__c LIKE \'%'+System.Label.TeleForm+'%\' and Email_Alert__c = \'YES\' AND Email!=null limit 20';
    
        else
        query = 'Select id from Contact where Source_of_E_mail__c LIKE \'%'+System.Label.TeleForm+'%\' and Email_Alert__c = \'YES\' AND Email!=null AND Provider_Service_Status__c=null AND Username__c!=null';
    
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, list<Contact> teleformcontacts){
      
        Database.SaveResult[] resultsUpdateContacts;
          
        try {
            map<id,id> conId_userId_map = new map<id,id>();
            list<Id> conIdList = new list<Id>();
            for(Contact temp : teleformcontacts){ 
                conIdList.add(temp.id); 
            }
            for(User temp : [select id, contactId from User WHERE IsActive = true and  ContactId IN :conIdList]){
                conId_userId_map.put(temp.contactId,temp.id);
            }

            for(Contact temp : teleformcontacts) {
                if(conId_userId_map.get(temp.id) <> null) {
                    system.resetPassword(conId_userId_map.get(temp.id),true);
                    temp.Email_Alert__c = 'Sent on' + system.now();
                }
            }
            system.debug('@@teleformcontacts : '+ teleformcontacts);
            resultsUpdateContacts = Database.update(teleformcontacts, false);

            //Exception handling for Contacts Update 
            if(resultsUpdateContacts != null && resultsUpdateContacts.size() > 0) {
                catchExceptionsFromCode(resultsUpdateContacts);
            }
        } catch(Exception e) {
            System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext BC){
        try{
            if( BatchExceptions != null && BatchExceptions.size() > 0)  {
                Database.insert(BatchExceptions,false);
            }

            EmailTemplate ProviderNonTeleForm = [select id from EmailTemplate where name='Provider Community: Provider Welcome Email'];
            ChangeNetworkTemplate objChangeNetwork = new ChangeNetworkTemplate();
            objChangeNetwork.ChangeTemplate(ProviderNonTeleForm.id);

        }catch( Exception ex){
            System.debug(ex.getTypeName() + ' - ' + ex.getCause() + ': ' + ex.getMessage());
        }
    }
}