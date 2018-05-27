/**  
  * Class Name  : ProviderUserUpdateScheduler 
  * Author      : IDC Offshore
  * Date        : 25-March-2015
  * Project Name: CRM - SFT - Sutter Health
  * Description : This class is for REQ- 3399. ProviderUserUpdateScheduler updates the Provider contacts that 
                 have Employee ADID value, provider type as "Internal" and have a Corresponding User created 
                 for them with a dummy email id.It updates the Standard Email field of Contact with the 
                 original email that is present in Internal Provider Email field and this in turn updates the Related User.
**/
  
global class ProviderUserUpdateScheduler implements schedulable{
    static final String provider = 'Provider';
    static final String errorStr = '@@Error debug : ';
    static final String hyphenStr = '--------------';
    
    global void execute(SchedulableContext sc){

        // fetching the Recordtype id of Provider Recordtype of Contact
        String strProviderRecType = Schema.SObjectType.Contact.RecordTypeInfosByName.get(provider).RecordTypeId;
        List<Contact_Validation_Summary__c> lstSummariesToUpdate=new List<Contact_Validation_Summary__c>();

        List<Contact> lstContactsEmailUpdate = new List<Contact>();// List used to update Emails on Contact

        //fetching Provider Contacts of Employee ADID value that have Standard Email field populated 
        //with dummy email id and have original Email in Internal Provider Email field
        for(Contact objCntct:[select id,Email,Internal_Provider_Email__c, (select id,Email__c from Summarys__r)
                              from Contact where RecordTypeId=:strProviderRecType AND Email != null
                              AND Employee_ADID__c <> null AND Internal_Provider_Email__c <> null
                              AND Email like '%testpdv@dummypdv%' limit 190])
        {
            if(objCntct.Email != objCntct.Internal_Provider_Email__c)
            {
                objCntct.Email = objCntct.Internal_Provider_Email__c; //Copying the original Email from Teleform Email field to Standard Email field.
                objCntct.Internal_Provider_Email__c = null;
                List<Contact_Validation_Summary__c> lstSummaries = objCntct.Summarys__r;
                
                for(Contact_Validation_Summary__c objSummary:lstSummaries)
                {
                    objSummary.Email__c=objCntct.Email;
                    objSummary.Tech_Success_Email__c = false;
                    lstSummariesToUpdate.add(objSummary);
                }
                lstContactsEmailUpdate.add(objCntct);       
            }
        }           
        try{
            if(!lstContactsEmailUpdate.isEmpty()){
                Database.update(lstContactsEmailUpdate);// Updating Contacts
            }
            if(!lstSummariesToUpdate.isEmpty()){
                Database.update(lstSummariesToUpdate);// Updating Summary record
            }
            system.abortJob(sc.getTriggerId());
        }catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + hyphenStr);
        } 
    }
}