/**  
*    Trigger Name: ManageContacts
*    Author: Brandon Cassis
*    Date: 26-June-2013
*    Description: This Trigger inserts and updates Contacts for certain criteria, based on those Contacts creates Users and assigns them Permission Sets.

*    History
*    --------
*    VERSION    AUTHOR           DATE        DETAIL 
*       1.0     IDC Offshore   29/07/2013  Ad ded Comments and Indentation
*       2.0     IDC Offshore   7/05/2015  Adding code for REQ 3399 TeleForm and adding proper Comments
**/
trigger ManageContacts on Contact (before insert, before update, after insert, after update) 
{
    
    /** @ Description: Variables used to pass Contact data to Classes**/
    List<Contact> updateContact = new List<Contact>();
    List<Contact> insertContact = new List<Contact>();
    Map<Id, Contact> newMap = new Map<Id, Contact>();
    Map<Id, Contact> oldMap = new Map<Id, Contact>();
    System.Debug('Trigger 1');
    Id providerRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Provider').getRecordTypeId(); //added for PDI Wave2
    List<Profile> profileNameList = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    String userProfile = null;
    if(profileNameList != null && !profileNameList.isEmpty()){ userProfile = profileNameList[0].Name; }
    
	Id shpSalesBrokerRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SHP Sales Broker Contact').getRecordTypeId();
	Id shpSalesBrokerRORecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SHP Sales Broker Contact Read Only').getRecordTypeId();
	Id shpSalesEmpRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SHP Sales Employer Contact').getRecordTypeId();
	Id shpSalesEmpRORecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SHP Sales Employer Contact Read Only').getRecordTypeId();
	/* Req - 3880 archive lookup fields update  STARTS*/
	if(Trigger.isBefore){
	    List<Contact> conList = new List<Contact>();
	    if(Trigger.isInsert && HighRoads_ArchivedContacts.isContactBeforeInsert){
	        for(Contact conObj : Trigger.New){
	            if(conObj.recordtypeid == shpSalesBrokerRecTypeId || conObj.recordtypeid == shpSalesBrokerRORecTypeId ||
	               conObj.recordtypeid == shpSalesEmpRecTypeId || conObj.recordtypeid == shpSalesEmpRORecTypeId ){
	                if(conObj.Archive__c){
	                    conObj.Archive_lookup__c = conObj.AccountId;
	                    conObj.Unarchived_Lookup__c = null;
	                }else{
	                    conObj.Archive_lookup__c = null;
	                    conObj.Unarchived_Lookup__c = conObj.AccountId;
	                }
	            }
	        }
	        HighRoads_ArchivedContacts.isContactBeforeInsert= false;
	    }
	    if(Trigger.isUpdate && HighRoads_ArchivedContacts.isContactBeforeUpdate){
	        
	        for(Contact conObj : Trigger.New){
	            if((conObj.recordtypeid == shpSalesBrokerRecTypeId || conObj.recordtypeid == shpSalesBrokerRORecTypeId ||
	               conObj.recordtypeid == shpSalesEmpRecTypeId || conObj.recordtypeid == shpSalesEmpRORecTypeId ) &&
	               Trigger.OldMap.get(conObj.id).Archive__c != Trigger.NewMap.get(conObj.id).Archive__c){
	               if(conObj.Archive__c){
	                    conObj.Archive_lookup__c = conObj.AccountId;
	                    conObj.Unarchived_Lookup__c = null;
	                }else{
	                    conObj.Archive_lookup__c = null;
	                    conObj.Unarchived_Lookup__c = conObj.AccountId;
	                }
	            }
	        }
	        
	            HighRoads_ArchivedContacts.isContactBeforeUpdate= false;
	
	    }
	}
	
	/* Req - 3880 archive lookup fields update  ENDS*/
    /** @ Description: This section will execute if this trigger is fired due to an insert operation, from the Salesforce user interface, Apex, or the API. **/
    if(Trigger.isInsert) 
    {
        /** @Req.3098 Release 5.2 Changes **/
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : Trigger.new)
        {
            accountIds.add(con.AccountId);
        }
        
        /** @Update Accounts **/
        Map<ID, Account> mapAccounts = new Map<ID, Account>([SELECT Id, Vendor_Tax_ID__c FROM Account where Id IN :accountIds]);
        Map<Id,Account> lstAccToUpdate = new Map<Id,Account>();
        set<id> successAccountID = new set<id>();
        for(Contact con : Trigger.new)
        {
            Account acc = mapAccounts.get(con.AccountId);
            if(acc!=Null)
            {
                acc.Vendor_Tax_ID__c = con.Vendor_TaxID__c;
                lstAccToUpdate.put(acc.Id,acc);
            }
            
        }
        //  database.insert(lstAccToUpdate.values(),false);
        database.saveresult[] saveResults;
        
        if (lstAccToUpdate!= Null && lstAccToUpdate.size()>0 )
        {
            saveResults = database.insert(lstAccToUpdate.values(),false);
        }
        if (saveResults != Null)
        {
            for(Database.saveresult sr: saveResults )
            {
                if(sr.isSuccess())
                {
                    successAccountID.add(sr.getId());
                }
            }
        }
        
        if(Trigger.isBefore)
        {
            /** @ Description: Capturing a list of the new versions of the Contact records by iterating the "Trigger.New" and storing in list variable of Contact type **/
            for(Contact loopContact: Trigger.new) 
            {
                //Added for PDI Wave 2
                if(loopContact.recordtypeid == providerRecTypeId &&  loopContact.Provider_Active_Status__c == true && (userProfile != null && userProfile == Label.CL561_PDIIntegrationProfile)){
                    loopContact.Provider_Practicing_Physician__c = true;
                }
                //Wave2 Ended
                /** @ Description: Adding new version of record in list. **/
                insertContact.add(loopContact);        
            }
            if(insertContact.size() > 0) {
                /** @ Description: REQ # 3399 - Sending Contacts to the method for TeleForm logic **/
                ManageContactDatabase.ManageInsertedContactsOnBefore(insertContact);
            }
        }
        else
        {
            /** @ Description: Capturing a list of the new versions of the Contact records by iterating the "Trigger.New" and storing in list variable of Contact type **/
            for(Contact conObj: Trigger.new) 
            {
                /** @ Description: Adding new version of record in list. **/
                insertContact.add(conObj);        
            }
            /** @ Description: Before passing the InsertContact list in function, we are validating its size, which must be greater than 0**/
            if(insertContact.size() > 0) 
            {
                /**  @ Description: This method will insert the new version of contact whose record type is Employee and 
                *    status is active, this create a new user and than assign the profile to Community Portal. 
                **/
                ManageContactDatabase.ManageInsertedContacts(insertContact);
            }
        }
    }
    
    /** @ Description: This section will execute if this trigger is fired due to an update operation, from the Salesforce user interface, Apex, or the API. **/
    else if(Trigger.isUpdate) 
    { 
        /** @Req.3098 Release 5.2 Changes **/
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : Trigger.new)
        {
            accountIds.add(con.AccountId);
        }
        
        /** @Update Accounts **/
        Map<ID, Account> mapAccounts = new Map<ID, Account>([SELECT Id, Vendor_Tax_ID__c FROM Account where Id IN :accountIds]);
        Map<Id,Account> lstAccToUpdate = new Map<Id,Account>();
        set<id> successAccountID = new set<id>();
        //list<Retirement_Eligibility__c> lstRE = new list<Retirement_Eligibility__c>();
        
        for(Contact con : Trigger.new)
        {
            Account acc = mapAccounts.get(con.AccountId);
            if(acc!=Null)
            {
                acc.Vendor_Tax_ID__c = con.Vendor_TaxID__c;
                lstAccToUpdate.put(acc.Id,acc);
            }
            // Start Retirement Eligibility
            // Insert Retirement records..//Assumption con.Employee_Employment_Status__c is only applicable for Employee so not null check is not required 
            /*if(con.Employee_Employment_Status__c!=null && con.Employee_Employment_Status__c == 'TE'){
            Retirement_Eligibility__c RE = new Retirement_Eligibility__c();
            RE.Employee__c = con.id;
            RE.Contact_SSN_E__c = con.Contact_SSN_E__c; 
            RE.Status__c = 'New';
            lstRE.add(RE);   
            }*/
            // End Retirement Eligibility
        }
        
        
        // Start Retirement Eligibility
        /* if(lstRE.size()>0)
{
insert lstRE;
}*/
        // End Retirement Eligibility
        //  database.update(lstAccToUpdate.values(),false);
        database.saveresult[] saveResults;
        
        if (lstAccToUpdate!= Null && lstAccToUpdate.size()>0 )
        {
            saveResults = database.update(lstAccToUpdate.values(),false);
        }
        if (saveResults != Null)
        {
            for(Database.saveresult sr: saveResults )
            {
                if(sr.isSuccess())
                {
                    successAccountID.add(sr.getId());
                }
            }
        }
        
        if(Trigger.isBefore)
        {
            List<Contact> contactListWithUpdatedOwner = new List<Contact>();
            
            for(Contact con:Trigger.new)
            {
                //Added for PDI Wave2
                //If the email field on existing record is null and in the next load, if we get the Secondary email, we will copy that secondary
                //email value to Email field.
                if(con.recordtypeid == providerRecTypeId){
                    if(String.isNotBlank(con.Provider_Secondary_Email__c) && String.isBlank(con.Email) && String.isBlank(con.Internal_Provider_Email__c)){
                        con.Email = con.Provider_Secondary_Email__c;
                    }
                    /*if(String.isNotBlank(Trigger.OldMap.get(con.id).Email) && con.Email <> trigger.oldMap.get(con.Id).Email && userProfile == Label.CL561_PDIIntegrationProfile){
                        con.Provider_Secondary_Email__c = Trigger.NewMap.get(con.id).Email;
                        con.Email = trigger.oldMap.get(con.Id).Email;
                    }*/
                    String contactEmail = con.Email;
                    String oldEmail = Trigger.OldMap.get(con.id).Email;
                    //In the existing record, if there is no email value and in next load, if we get email value, we will cpy that email into 
                    //tech field named as Internal_provider_Email field to donot create user record immediately for that contact.
                    if(con.Employee_ADID__c != null && con.Email != null && !contactEmail.contains('testpdv@dummypdv')
                       && (Trigger.OldMap.get(con.id).Email == null && con.Email_Alert__c != 'YES')
                       && con.Internal_Provider_Email__c == null && con.recordTypeId == providerRecTypeId && con.Provider_Retired_Departed__c != true
                       && 'Internal'.equalsIgnorecase(con.Provider_Type__c) && con.Provider_Active_Status__c == true)
                    {
                        con.Internal_Provider_Email__c = con.Email;
                        con.Email = null; 
                    }
                }
                //Ended PDI Wave2
                if(con.OwnerId <> trigger.oldMap.get(con.Id).OwnerId)
                {
                    contactListWithUpdatedOwner.add(con);
                }
            }
            system.debug('@@contactListWithUpdatedOwner :'+contactListWithUpdatedOwner);
            if(!contactListWithUpdatedOwner.isEmpty())
            {
                ManageContactDatabase.contactOwnerValidation(contactListWithUpdatedOwner);  
            }
        }
        
        if(Trigger.isAfter)
        {
            
            /** @ Description: Capturing a list of the new versions of the Contact records by iterating Trigger.New and storing in list variable of Contact type **/
            for(Contact loopContact: Trigger.new) {
                
                /** @ Description: Add iterated contact variable to contact list updateContact **/
                updateContact.add(loopContact);        
            }
            
            /** @ Description: Copies a map of new value ID's of the contact records in newMap. **/
            newMap.putall(Trigger.newMap);
            
            /** @ Description: Copies a map of old value ID's of the contact records in oldMap. **/
            oldMap.putall(Trigger.oldMap);
            
            /** @ Description:  Null check for the List of Updated Contacts**/
            if(updateContact.size() > 0) {
                
                /** 
*    @ Description: For the updated contact passed list, if the user already exists then it will update
*    the contact with the user otherwise it creates a new user and associate the contact with the new user.
*    To accomplish this we pass the updated contact list with the old map IDs and new map IDs
**/
                System.debug(':::::::::::::::in manageContacts:updatedContacts:::'+updateContact);
                System.debug(':::::::::::::::in manageContacts:oldContactMap:::'+oldMap);
                System.debug(':::::::::::::::in manageContacts::newContactMap::'+newMap);
                ManageContactDatabase.ManageUpdatedContacts(updateContact, oldMap, newMap);
            }
        }
        
    }
    
}