/**
* @author       :   OffshoreTeam
* @date         :   01/03/2015 (DD/MM/YYYY)
* @description  :   Scheduler Class for BatchPasswordreset 
*/
global class BatchPasswordresetScheduler implements Schedulable
{
    /*Execute method to shedule the batch apex class BatchPasswordreset*/
    global void execute(SchedulableContext sc)
    {
        BatchPasswordreset resetPassword = new BatchPasswordreset();
        resetPassword.printedFloor = '1';
        resetPassword.query = 'SELECT Contact_id__c, Email__c, Contact_Id__r.Email, Contact_Id__r.Provider_Type__c,' 
            +' Contact_Id__r.Employee_ADID__c, Last_Verified_Date__c, Printed_Floor__c, Provider_Active_Status__c,'
            +' Contact_id__r.is_portal_user__c, Contact_id__r.Provider_Practicing_Physician__c, PDI_Campaign__c,'
            +' Welcome_Email_Sent_History__c, Provider_Last_Login_Date__c, Status__c, Tech_Success_Email__c'
            +' FROM Contact_Validation_Summary__c'
            +' WHERE (Last_Verified_Date__c = NULL' 
            +' AND Printed_Floor__c != \'1\''
            +' AND Provider_Admin_Emails_Are_Same__c = False'
            +' AND Provider_Active_Status__c = true' 
            +' AND Contact_id__r.is_portal_user__c = true'
            +' AND Contact_id__r.Provider_Practicing_Physician__c = true'
            +' AND (Not Email__c Like \'noreply%\')'
            +' AND Contact_Id__r.Email != null'
            +' AND Contact_Id__r.Provider_Type__c != null'
            +' AND PDI_Campaign__c = \''+Label.CL176_PDI_Current_Campaign_Name+'\''
            +' AND Status__c != \''+Label.CL187_PDI_Validated_Status+'\') Limit 200';
        Database.executeBatch(resetPassword, 1);    
    }
}