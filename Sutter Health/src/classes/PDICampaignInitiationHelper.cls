/*****************************************************
Class Name: PDICampaignInitiationHelper 
Created By: Nagarjuna Kaipu
Created Date: 21/06/2016
Description: This class is used to create the new campaign initiation records
References: ManageContactDatabase Class
*****************************************************/
public class PDICampaignInitiationHelper {
    /*
Method Name: CreateNewCampaignProviderRecords
Description: Used to create new campaign records as part of MDM full file for updated records.
Params: Contacts map
return type: Void
*/
    public static Void CreateNewCampaignProviderRecords(Map<Id, Contact> newContactMap)
    {
        String CommunicationPreferencesHIM;
        Id oldSummaryId;
        Datetime providerLastLoginDate;
        Decimal serialNumber;
        String newStreetAddress;
        List<Contact_Validation_Summary__c> cvsList = new List<Contact_Validation_Summary__c>(); 
        List<Contact_Validation_Summary__c> summaryContacts = new List<Contact_Validation_Summary__c>();
        List<Contact> providerContacts = new List<Contact>();
        Map<Id,List<Contact_Validation_Summary__c>> mapContactRelatedSummary = new Map<id,List<Contact_Validation_Summary__c>>();
        Map<id,Contact> mapSummaryCreateContacts = new Map<id,Contact>();
        
        
        mapSummaryCreateContacts = newContactMap;
        System.debug('mapSummaryCreateContacts1 are: '+mapSummaryCreateContacts);
        summaryContacts = [select Contact_Id__c,Address_Type__c from Contact_Validation_Summary__c where Contact_Id__c in: mapSummaryCreateContacts.keyset() and  Address_Type__c =: Label.CL303_PDIPrimary and PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name ];     
        System.debug('summaryContacts are: '+summaryContacts);
        for(Contact_Validation_Summary__c tempsummary:summaryContacts){  
            mapSummaryCreateContacts.remove(tempsummary.Contact_Id__c); 
        }
        System.debug('mapSummaryCreateContacts are: '+mapSummaryCreateContacts);
        //Querying updated contact field values
        providerContacts =  [select Id, Name, Preferred_Communication_Method__c,Ok_To_Text__c,Provider_Name__c,Provider_Address_Line_2__c,
                             Provider_Title__c,Email,MobilePhone,Provider_Correspondence_Address__c,Provider_Admin_Assistant_Phone__c,
                             Provider_Correspondence_City__c,Provider_Correspondence_State__c,Provider_Correspondence_PostalCode__c,
                             Provider_Correspondence_Phone__c,Provider_Correspondence_Fax_Number__c, Provider_Active_Status__c, Provider_Retired_Departed__c,
                             Provider_Resigned_From_Sutter__c, Provider_Practicing_Physician__c, Provider_Communication_Preferences_HIM__c,
                             Provider_ID__c,Provider_NPI__c,Provider_Admin_Assistant__c,Provider_Admin_Assistant_Email__c,
                             Provider_Access_Type__c,Provider_Type__c,Deficiency_Provider__c,Phone_Extension__c,Provider_Admin_Assistant_Title__c,
                             Contact_External_ID1__c,Username__c,Teleform_Last_Validation_Date__c,
                             (select Id, Contact_Id__c, ProviderInfoHistory__c, Provider_Last_Login_Date__c, New_Street_Address__c, Serial_Number__c, Address_Type__c from Summarys__r Where PDI_Campaign__c =: Label.CL175_PDI_Old_Campaign_Name and Address_Type__c =: Label.CL303_PDIPrimary Limit 1)
                             from contact 
                             where id in: mapSummaryCreateContacts.keyset() and Provider_Active_Status__c = true];
        
        //Querying Non Validate Queue Id
        List<Group> nonValidatedProviderQueue = [select Id from Group where Name = 'Non Validated Providers' and Type = 'Queue' limit 1];
        if(!providerContacts.isEmpty()) {  
            for(Contact tempCon : providerContacts) {
                if(tempCon.Summarys__r.Size()>0)
                {
                    oldSummaryId = tempCon.Summarys__r[0].Id;
                    providerLastLoginDate = tempCon.Summarys__r[0].Provider_Last_Login_Date__c;
                    serialNumber = tempCon.Summarys__r[0].Serial_Number__c;
                    newStreetAddress = tempCon.Summarys__r[0].New_Street_Address__c;
                }
                if(tempCon.Provider_Communication_Preferences_HIM__c!=null && tempCon.Provider_Communication_Preferences_HIM__c.containsIgnoreCase('Printed Letter')){
                    CommunicationPreferencesHIM = 'Printed Letter (USPS)';
                }
                else
                {
                    CommunicationPreferencesHIM = tempCon.Provider_Communication_Preferences_HIM__c;
                }
                
                if('true'.equalsIgnoreCase(Label.CL375_PDIAllowInactiveProvider) && tempCon.Provider_Resigned_From_Sutter__c == true){
                    tempCon.Provider_Practicing_Physician__c = true;
                    tempCon.Provider_Resigned_From_Sutter__c = false;
                }
                
                cvsList.add(new Contact_Validation_Summary__c(
                    ProviderInfoHistory__c = oldSummaryId
                    , Provider_Name__c = tempCon.Provider_Name__c
                    , Provider_Title__c = tempCon.Provider_Title__c
                    , Provider_ID__c = tempCon.Provider_ID__c
                    , Contact_ID__c = tempCon.id
                    , Username__c = tempCon.Username__c
                    , Name = tempCon.Name
                    , Email__c = tempCon.Email
                    //Replacing 1 from mobile phone
                    , Mobile_Phone__c = String.isNotBlank(tempCon.MobilePhone) && tempCon.MobilePhone.SubString(0,1).Contains('1') ? 
                    tempCon.MobilePhone.SubString(1, tempCon.MobilePhone.Length()): tempCon.MobilePhone
                    , Ok_To_Text__c = String.isNotBlank(tempCon.Ok_To_Text__c)? Boolean.valueOf(tempCon.Ok_To_Text__c) : false
                    
                    , Address_Type__c = Label.CL303_PDIPrimary
                    , Serial_Number__c = serialNumber
                    , New_Street_Address__c = tempCon.Provider_Correspondence_Address__c
                    , Address_Line_2__c = tempCon.Provider_Address_Line_2__c
                    , Secure_Street_Address__c = tempCon.Provider_Correspondence_Address__c
                    , Secure_City__c = tempCon.Provider_Correspondence_City__c
                    , Secure_State__c = tempCon.Provider_Correspondence_State__c
                    , Secure_Zip_Code__c = tempCon.Provider_Correspondence_PostalCode__c
                    , Secure_Phone__c = String.isNotBlank(tempCon.Provider_Correspondence_Phone__c) && tempCon.Provider_Correspondence_Phone__c.SubString(0,1).Contains('1') ? 
                    tempCon.Provider_Correspondence_Phone__c.SubString(1, tempCon.Provider_Correspondence_Phone__c.Length()): tempCon.Provider_Correspondence_Phone__c
                    , Secure_Phone_Ext__c = tempCon.Phone_Extension__c
                    , Secure_Fax__c = String.isNotBlank(tempCon.Provider_Correspondence_Fax_Number__c) && tempCon.Provider_Correspondence_Fax_Number__c.SubString(0,1).Contains('1') ? 
                    tempCon.Provider_Correspondence_Fax_Number__c.SubString(1, tempCon.Provider_Correspondence_Fax_Number__c.Length()): tempCon.Provider_Correspondence_Fax_Number__c
                    , Tech_Phone_Number__c = String.isNotBlank(tempCon.Provider_Correspondence_Phone__c) ? tempCon.Provider_Correspondence_Phone__c.replaceAll('[^0-9]','') : null
                    , Preferred_Communication_Method__c = tempCon.Preferred_Communication_Method__c
                    , Communication_Preferences_HIM__c = CommunicationPreferencesHIM 
                    , Provider_Access_Type__c = tempCon.Provider_Access_Type__c 
                    , Provider_Type__c = tempCon.Provider_Type__c
                    , Deficiency_Provider__c = tempCon.Deficiency_Provider__c
                    , PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name
                    , Retired_Departed__c = tempCon.Provider_Retired_Departed__c 
                    , Resigned_From_Sutter__c = tempCon.Provider_Resigned_From_Sutter__c 
                    , Practicing_Physician__c = tempCon.Provider_Practicing_Physician__c 
                    
                    , Admin_Assistant__c = tempCon.Provider_Admin_Assistant__c 
                    , Admin_Assistant_Email__c = tempCon.Provider_Admin_Assistant_Email__c 
                    , Admin_Assistant_Phone__c = String.isNotBlank(tempCon.Provider_Admin_Assistant_Phone__c) && tempCon.Provider_Admin_Assistant_Phone__c.SubString(0,1).Contains('1') ? 
                    tempCon.Provider_Admin_Assistant_Phone__c.SubString(1, tempCon.Provider_Admin_Assistant_Phone__c.Length()): tempCon.Provider_Admin_Assistant_Phone__c
                    , Admin_Assistant_Title__c = tempCon.Provider_Admin_Assistant_Title__c
                    
                    , Status__c = 'Non-Validated'
                    , Provider_Last_Login_Date__c = providerLastLoginDate
                    , OwnerId = nonValidatedProviderQueue.size()>0 ? nonValidatedProviderQueue[0].id : UserInfo.getUserId()
                    
                ));
            }
            
            List<Id> successIds = new List<Id>();
            List<Id> IdstoUpdate = new List<Id>();
            List<Contact_Validation_Summary__c> successListToUpdate = new List<Contact_Validation_Summary__c>();
            
            if(!cvsList.isEmpty())
            {
                Database.SaveResult[] newCampRecs = Database.insert(cvsList, false);
                for(Database.SaveResult dsr : newCampRecs){
                    if(dsr.isSuccess()){
                        successIds.add(dsr.getId());
                    }
                }
                
                
                if(!successIds.isEmpty())
                {
                    for(Contact_Validation_Summary__c cvsIds: [SELECT ProviderInfoHistory__c FROM Contact_Validation_Summary__c WHERE Id IN: successIds LIMIT 2000])
                    {
                        IdstoUpdate.add(cvsIds.ProviderInfoHistory__c);
                    }
                    successListToUpdate = [SELECT Id FROM Contact_Validation_Summary__c WHERE Id IN: IdstoUpdate LIMIT 2000];
                    for(Contact_Validation_Summary__c campUpdate: successListToUpdate)
                    {
                        campUpdate.Tech_Is_Campaign_Done__c = true;
                    }
                    update successListToUpdate;
                    successIds.clear();
                    IdstoUpdate.clear();
                    successListToUpdate.clear();
                } 

            }
            
        }      
    }
}