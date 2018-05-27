/**
* @author       :   Kishore Jonnadula
* @date         :   29/09/2016 (DD/MM/YYYY)
* @description  :   Scheduler Class for BatchAdminUserUpdateScheduler 
* @param        :   N/A
* @return       :   N/A
*/
global class BatchAdminUserUpdateScheduler implements schedulable{
    static final String errorStr = '@@Error debug : ';
    static final String hyphenStr = '--------------';
    static final String dummyAsstEmail = '%testadmin@dummyAsst%';
    
    global void execute(SchedulableContext sc)
    {
        // fetching the Recordtype id of Provider Recordtype of Contact
        String strAdminAsstRecType = Schema.SObjectType.Contact.RecordTypeInfosByName.get(Label.CL468_PDI_AdminAssistant).RecordTypeId;
        List<Contact> contacttoUpdate = new List<Contact>();
        for(Contact objCntct:[select id, Email, Admin_Temp_Email__c from Contact where RecordTypeId=:strAdminAsstRecType 
                              AND Email != null AND Admin_Temp_Email__c <> null
                              AND Email like :dummyAsstEmail limit 190])
        {
            if(objCntct.Email != null)
            {
                objCntct.Email = objCntct.Admin_Temp_Email__c;
                objCntct.Admin_Temp_Email__c = null;
                contacttoUpdate.add(objCntct);
            }
        }
        
        try{
            if(!contacttoUpdate.isEmpty()){ Database.update(contacttoUpdate); } // Updating Contacts
            system.abortJob(sc.getTriggerId());
        }catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + hyphenStr);
        } 
        
    }
    
}