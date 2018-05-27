/*****************************************************
Trigger Name: ProvidersByPhoneNumberTrigger 
Created By: Nagarjuna Kaipu
Created Date: 09/06/2016
Description: this trigger is used to update common phone number object id on common phone number provider summary records.
*****************************************************/
trigger ProvidersByPhoneNumberTrigger on ProvidersByPhoneNumber__c (before insert, after insert) {
    
    SystemException__c systemException = new SystemException__c();
    Map<String, Id> phoneMap = new map<String, Id>();
    List<Contact_Validation_Summary__c> sumList = new List<Contact_Validation_Summary__c>();
    if(Trigger.isInsert && Trigger.isBefore){
        if(ProvidersByPhoneNumberHelper.firstRunbeforeInsert){
            for(ProvidersByPhoneNumber__c dupP: trigger.new){
                //Settiing the phone number in the format (999) 999-9999.
                dupP.Name = ProvidersByPhoneNumberHelper.FormatPhone(dupP.Tech_Phone_Number__c);
            }  
            ProvidersByPhoneNumberHelper.firstRunbeforeInsert = false;
        }
    }
    
    try{
        if(Trigger.isInsert && Trigger.isAfter){
            if(ProvidersByPhoneNumberHelper.firstRunAfterInsert){
                for(ProvidersByPhoneNumber__c phone: trigger.new){
                    //Setting all the common phone numbers to map 
                    phoneMap.put(phone.Tech_Phone_Number__c, phone.Id);
                }
                //Updating phonenumber record id on summary object after creating the phone number record for provider common phone number records
                //In noraml trigger process 200 records at a time and the query is limited to 50000
                for(Contact_Validation_Summary__c summary: [SELECT Id, Tech_Phone_Number__c, Providers_By_Phone_Number__c FROM Contact_Validation_Summary__c 
                                                            WHERE Tech_Phone_Number__c IN: phoneMap.KeySet() AND PDI_Campaign__c = :Label.CL176_PDI_Current_Campaign_Name 
                                                            AND Status__c in (:Label.CL185_PDI_Non_Validated_Status, :Label.CL186_PDI_Accepted_Status) LIMIT 50000]){
                                                                if(phoneMap.containsKey(summary.Tech_Phone_Number__c)){
                                                                    summary.Providers_By_Phone_Number__c = phoneMap.get(summary.Tech_Phone_Number__c);
                                                                    summary.Tech_Success_Email__c = false;
                                                                    sumList.add(summary);
                                                                }
                                                            }
                //Updating phone number record Id on common phone number summary records
                update sumList;
                ProvidersByPhoneNumberHelper.firstRunAfterInsert = false;
            }
        }
    } catch(Exception ex) {
       Utility.handleExceptionFromCode(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN);
    }
}