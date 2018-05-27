public with sharing class HandleFailedContacts {
    private list<failed_contacts__c> fcList = new list<failed_contacts__c>();
    private list<Id> contactIdList;
    private failed_contacts__c fcObj;
    
    public HandleFailedContacts() {
        fcList = new list<failed_contacts__c>();
        contactIdList = new list<Id>();
    }
    
    public void addToFailList(User p_userObj,Database.SaveResult  p_sr) {
        contactIdList.add(p_userObj.contactId);
        
        fcObj = new failed_contacts__c();
        fcObj.contact_id__c = String.valueOf(p_userObj.contactId);
        fcObj.first_name__c = p_userObj.firstName;
        fcObj.last_name__c = p_userObj.lastName;
        fcObj.username__c = p_userObj.username;
        fcObj.nickname__c = p_userObj.CommunityNickname;
        
        for(Database.Error err : p_sr.getErrors()) {
            fcObj.error_message__c = err.getMessage();
            fcObj.error_code__c = String.valueOf(err.getStatusCode());
        }
        
        fcList.add(fcObj);
    }
    

    
    public void insertFailList() {
        
        if(fcList.size() > 0)   insert fcList;
       
        
        /** REQ 3399 - Condition added in the query to skip for TeleForm Contacts **/
        //PDI - Wave1
        list<Contact_Validation_Summary__c> cvsList = [SELECT id FROM Contact_Validation_Summary__c WHERE Contact_Id__c IN :contactIdList 
                                                       And ((NOT Contact_Id__r.Source_of_E_Mail__c LIKE '%TLFM%')
                                                       And (Contact_Id__r.Employee_ADID__c = null))];
        
        /*@PDI-Wave1 Description: Commented below delete code as part of PDI-Wave1*/
        //if(cvsList.size() > 0)  delete cvsList; 
    }
    
    
    public void removeFromFailList(set<Id> p_contactIdSet) {
        list<failed_contacts__c> fcList = [SELECT id FROM failed_contacts__c WHERE contact_id__c IN :p_contactIdSet];
        

            for(failed_contacts__c temp : fcList)   temp.processed_successfully__c = true;
            if(fcList.size() > 0) update fcList;
    }
    
    
    
    
    public static void processAgain() {
        list<contact> conList = new list<contact>();
        list<Id> conIdList = new list<Id>();
        list<failed_contacts__c> fcList = [SELECT id, contact_id__c FROM failed_contacts__c limit 50000];
        Integer i = 1;
        
            
        for(failed_contacts__c temp : fcList)   conIdList.add(temp.contact_id__c);
            
        conList = [SELECT Id,Email,Provider_Name__c,FirstName,LastName,Provider_Title__c,MobilePhone,Provider_Correspondence_Address__c
                    ,Provider_Correspondence_City__c,Provider_Correspondence_State__c,Provider_Correspondence_PostalCode__c,Employee_ADID__c
                    ,Provider_Correspondence_Phone__c,Provider_Correspondence_Fax_Number__c,Contact_External_ID1__c,Contact.RecordType.Name 
                    FROM Contact WHERE id IN :conIdList AND Is_Portal_User__c = false];
                    
                    
        ManageCommunityUsers.CreateProviderUsers(conList);
            
        i = i + 1;
    }
}