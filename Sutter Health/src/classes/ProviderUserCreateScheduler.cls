/**  
  * Class Name  : ProviderUserCreateScheduler 
  * Author      : IDC Offshore
  * Date        : 25-March-2015
  * Project Name: CRM - SFT - Sutter Health
  * Description : This class is for REQ- 3399. ProviderUserCreateScheduler updates the Provider contacts that 
  * have employee adid value and provider type as "Internal", then updating standard email with dummy email id
  *	and calls another class to update the Contacts with the original email id that is present in Internal Provider Email field.
  **/
global class ProviderUserCreateScheduler implements schedulable{
    static final String provider = 'Provider';
    static final String dummyProviderMail = 'testpdv@dummypdv';
    static final String provEmaildotcom = 'email.com';
    static final String providerUserUpdateJob = 'Provider Job userupdate ';
    static final String providerUserCreateJob = 'Provider Job UserCreate ';
    static final String errorStr = '@@Error debug : ';
    static final String hyphenStr = '--------------';
    
    global void execute(SchedulableContext sc){

        String strProviderRecType = Schema.SObjectType.Contact.RecordTypeInfosByName.get(provider).RecordTypeId;
        system.debug('@recordtype  : '+ strProviderRecType);    
        // fetching the contacts that have Employee ADID value and Standard Email 
        // is null and RecordType is Provider with Internal Provider Email being populated.
        list<Contact> lstContacts = [Select id,Internal_Provider_Email__c,Email from Contact where RecordTypeId=:strProviderRecType 
                                         AND Email = null AND (Provider_Practicing_Physician__c = true OR Provider_Resigned_From_Sutter__c = true)
                                         AND Employee_ADID__c <> null AND Internal_Provider_Email__c <> null limit 190];
        String strRandomEmail;

        List<Contact> lstContactsToUpdate = new List<Contact>(); // List to store Contacts that are to be updated
		try {
            for(Contact objContact:lstContacts){
                strRandomEmail = GetRandomString.generateString();
                objContact.Email=dummyProviderMail+strRandomEmail+provEmaildotcom;
                lstContactsToUpdate.add(objContact);// adding Contacts to the list to be updated.
            }
            if(!lstContactsToUpdate.isEmpty()){
                Database.update(lstContactsToUpdate); // updating contacts with the dummy Email id in the Standard Email field
            }
            /* The below code schedules another class that will  update the Contact's standard 
             * email field with the original email id present in Internal Provider Email Field.
             * The below job will run after 3 minutes from the time ProviderUserCreateScheduler runs.
             */
            ProviderUserUpdateScheduler objBatchProviderUpdate = new ProviderUserUpdateScheduler();
            ProviderUserCreateScheduler objBatchUserCreate = new ProviderUserCreateScheduler();
            
            Datetime currentDatetime = datetime.now().addMinutes(3); // getting the current datetime value and add 3 minutes
            Datetime nextScheduleTime = datetime.now().addHours(1); // getting the current datetime value and add 3 minutes
            
            
            Integer currentHour = currentDatetime.hour(); // getting the current hour
            String strMin = String.valueOf(currentDatetime.minute()); // getting the current minute 
            Integer currentSec = currentDatetime.second(); // getting the current second value.
            String strHour = String.valueOf(currentHour);
            String strSec = String.valueOf(currentSec);
            string jobName = providerUserUpdateJob +  
                currentDatetime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            
            String strExp= strSec+' '+strMin+' '+strHour+' ';
            String strschExp = strExp+'* * ?';// Here we have created the Cron Expression for the job of User Update
            String jobID = system.schedule(jobName, strschExp, objBatchProviderUpdate);
            
            currentHour = nextScheduleTime.hour(); // getting the current hour
            strMin = String.valueOf(nextScheduleTime.minute()); // getting the current minute 
            currentSec = nextScheduleTime.second(); // getting the current second value.
            strHour = String.valueOf(currentHour);
            strSec = String.valueOf(currentSec);
            jobName = providerUserCreateJob +  
                currentDatetime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            strExp= strSec+' '+strMin+' '+strHour+' ';
            strschExp = strExp+'* * ?';// Here we have created the Cron Expression for the job of User Update
            String jobIDUserCreate = system.schedule(jobName, strschExp, objBatchUserCreate);   
            
            system.abortJob(sc.getTriggerId());         
        } catch(Exception ex) {
            system.debug(errorStr + ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + hyphenStr);
            Utility.handleExceptionFromCode(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + hyphenStr);
        } 
    }
}