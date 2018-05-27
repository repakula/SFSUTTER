/**  
*    Trigger Name: ProviderSummaryTrigger 
*    Date: 10-April-2015
*    Description: This Trigger inserts the Serial Number for ProviderSummary records and update the status of the record and
*                 track the changes of phone/fax value
**/

/**

*    History
*    --------
*    VERSION    AUTHOR          DATE                 DETAIL
*       1.0     IDC Offshore   10/04/2015       Added Comments and Indentation
*       2.0     IDC Offshore   11/09/2015       Modified for REQ 3670- To Track Change in Value of Phone and Fax 
*       3.0     IDC Offshore   20/04/2016       Modified for PDI-Wave1 - To track change in Email, Communication Preferences-eHR, HIM
Mobile Phone, Street Address, Secure City, Secure State, Secure Suite, Secure Floor,
Secure zip code, Secure Phone Ext, Retired/Departed, Resigned from sutter, practicing physician,
Admin Assistant, Admin Assistant Email.
*      4.0 		IDC Offshore   06/09/2016		Req:3950 To refresh the common phone numbers validation status 
**/

/**
* @author       :   IDC Offshore
* @date         :   
* @description  :   Trigger to compare the provider fields are changed
* @param        :   N/A
* @return       :   N/A
*/ 

trigger ProviderSummaryTriggerBkup on Contact_Validation_Summary__c (before insert, before update, after insert, after update) {
    ProvidersByPhoneNumberHelper phoneHelper = new ProvidersByPhoneNumberHelper();
    
    if(Trigger.isInsert && Trigger.isbefore) {
        if(ProvidersByPhoneNumberHelper.firstRunbeforeInsert)
        {
            
            ProvidersByPhoneNumberHelper.UpdatePhoneObjectIdOnSummary(Trigger.New);
            ProvidersByPhoneNumberHelper.firstRunbeforeInsert = false;
        }
    }
    if(Trigger.isUpdate && Trigger.isbefore) {
        if(ProvidersByPhoneNumberHelper.firstRunSummaryBeforeUpdate)
        {
            ProvidersByPhoneNumberHelper.UpdatePhoneObjectIdOnSummary(Trigger.New);
            ProvidersByPhoneNumberHelper.firstRunSummaryBeforeUpdate = false;
        }
        //Req:3950: Added to store primary phone number without special characters
        for(Contact_Validation_Summary__c objSummary :  Trigger.New) {
            
            /*if(ProvidersByPhoneNumberHelper.firstRunSummaryBeforeUpdate)
            {
                if(objSummary.Secure_Phone__c != null){
                    objSummary.Tech_Phone_Number__c = String.valueOf(objSummary.Secure_Phone__c).replaceAll('[^0-9]',''); 
                }
                ProvidersByPhoneNumberHelper.firstRunSummaryBeforeUpdate = false;
            }*/
            //Req:3950: Ended
            if(objSummary.Tech_is_Contact_Updated__c == false)
            {
                // REQ- 3670 Tracking changes on Fax and Phone Number by comparing the old and new value
                if(objSummary.Is_Phone_Changed__c==false && Trigger.oldMap.get(objSummary.id).Secure_Phone__c!=Trigger.newMap.get(objSummary.id).Secure_Phone__c){
                    String strOldValue = ExtractNumbersFromString.extractMethod(Trigger.oldMap.get(objSummary.id).Secure_Phone__c);
                    String strNewValue = ExtractNumbersFromString.extractMethod(Trigger.NewMap.get(objSummary.id).Secure_Phone__c);
                    
                    if(strOldValue!=strNewValue)
                        objSummary.Is_Phone_Changed__c = true; // Setting the Phone Change Checkbox true
                }
                if(objSummary.Is_Fax_Changed__c==false && Trigger.oldMap.get(objSummary.id).Secure_Fax__c!=Trigger.newMap.get(objSummary.id).Secure_Fax__c){
                    String strOldValue = ExtractNumbersFromString.extractMethod(Trigger.oldMap.get(objSummary.id).Secure_Fax__c);
                    String strNewValue = ExtractNumbersFromString.extractMethod(Trigger.NewMap.get(objSummary.id).Secure_Fax__c);
                    
                    if(strOldValue!=strNewValue)
                        objSummary.Is_Fax_Changed__c = true; // Setting the Fax Change Checkbox true
                }
                if(Trigger.newMap.get(objSummary.id).Email__c != null){
                    if(objSummary.Is_Email_Changed__c==false 
                       && Trigger.oldMap.get(objSummary.id).Email__c!=Trigger.newMap.get(objSummary.id).Email__c){
                           objSummary.Is_Email_Changed__c = true; // Setting the Email Change Checkbox true
                       } 
                }
                if(objSummary.Is_Practicing_Physician_Changed__c==false && Trigger.oldMap.get(objSummary.id).Practicing_Physician__c!=Trigger.newMap.get(objSummary.id).Practicing_Physician__c){
                    objSummary.Is_Practicing_Physician_Changed__c = true; // Setting the Practicing Physician Change Checkbox true
                }
                if(objSummary.Is_Resigned_From_Sutter_Changed__c==false && Trigger.oldMap.get(objSummary.id).Resigned_From_Sutter__c!=Trigger.newMap.get(objSummary.id).Resigned_From_Sutter__c){
                    objSummary.Is_Resigned_From_Sutter_Changed__c = true; // Setting the Resigned from Sutter Change Checkbox true
                }
                if(objSummary.Is_Retired_Departed_Changed__c==false && Trigger.oldMap.get(objSummary.id).Retired_Departed__c!=Trigger.newMap.get(objSummary.id).Retired_Departed__c){
                    objSummary.Is_Retired_Departed_Changed__c = true; // Setting the Retired/Departed Change Checkbox true
                }
                if(objSummary.Is_Admin_Assistant_Title_Changed__c ==false && Trigger.oldMap.get(objSummary.id).Admin_Assistant_Title__c!=Trigger.newMap.get(objSummary.id).Admin_Assistant_Title__c){
                    objSummary.Is_Admin_Assistant_Title_Changed__c = true; // Setting the Admin Assistant Change Checkbox true
                }
                if(objSummary.Is_Admin_Assistant_Changed__c==false && Trigger.oldMap.get(objSummary.id).Admin_Assistant__c!=Trigger.newMap.get(objSummary.id).Admin_Assistant__c){
                    objSummary.Is_Admin_Assistant_Changed__c = true; // Setting the Admin Assistant Change Checkbox true
                }
                if(objSummary.Is_Admin_Assistant_Email_Changed__c==false && Trigger.oldMap.get(objSummary.id).Admin_Assistant_Email__c!=Trigger.newMap.get(objSummary.id).Admin_Assistant_Email__c){
                    objSummary.Is_Admin_Assistant_Email_Changed__c = true; // Setting the Admin Assistant Email Change Checkbox true
                }
                if(objSummary.Is_Admin_Assistant_Phone_Changed__c==false && Trigger.oldMap.get(objSummary.id).Admin_Assistant_Phone__c!=Trigger.newMap.get(objSummary.id).Admin_Assistant_Phone__c){
                    objSummary.Is_Admin_Assistant_Phone_Changed__c = true; // Setting the Admin Assistant Email Change Checkbox true
                }
                if(objSummary.Is_Admin_Assistant_Phone_Ext_Changed__c==false && Trigger.oldMap.get(objSummary.id).Delegate_Phone_Ext__c!=Trigger.newMap.get(objSummary.id).Delegate_Phone_Ext__c){
                    objSummary.Is_Admin_Assistant_Phone_Ext_Changed__c = true; // Setting the Admin Assistant Phone Extension Change Checkbox true
                }
                if(objSummary.Is_Mobile_Phone_Changed__c==false && Trigger.oldMap.get(objSummary.id).Mobile_Phone__c!=Trigger.newMap.get(objSummary.id).Mobile_Phone__c){
                    String strOldValue = ExtractNumbersFromString.extractMethod(Trigger.oldMap.get(objSummary.id).Mobile_Phone__c);
                    String strNewValue = ExtractNumbersFromString.extractMethod(Trigger.NewMap.get(objSummary.id).Mobile_Phone__c);
                    if(strOldValue!=strNewValue)
                        objSummary.Is_Mobile_Phone_Changed__c = true; // Setting the Mobile Phone Change Checkbox true
                }
                if(objSummary.Is_Speciality_Changed__c==false && Trigger.oldMap.get(objSummary.id).Speciality__c!=Trigger.newMap.get(objSummary.id).Speciality__c){
                    objSummary.Is_Speciality_Changed__c = true; // Setting the Speciality Change Checkbox true
                }
                if(objSummary.Is_Department_Changed__c==false && Trigger.oldMap.get(objSummary.id).Department__c!=Trigger.newMap.get(objSummary.id).Department__c){
                    objSummary.Is_Department_Changed__c = true; // Setting the Department Change Checkbox true
                }
                if(objSummary.Is_Hospital_Affiliations_Changed__c==false && Trigger.oldMap.get(objSummary.id).Hospital_Affiliations__c!=Trigger.newMap.get(objSummary.id).Hospital_Affiliations__c){
                    objSummary.Is_Hospital_Affiliations_Changed__c = true; // Setting the Hospital Affiliations Change Checkbox true
                }
                if(objSummary.Is_Medical_Education_Changed__c==false && Trigger.oldMap.get(objSummary.id).Medical_Education__c!=Trigger.newMap.get(objSummary.id).Medical_Education__c){
                    objSummary.Is_Medical_Education_Changed__c = true; // Setting the Medical Education Change Checkbox true
                }
                if(objSummary.Is_Internship_Changed__c==false && Trigger.oldMap.get(objSummary.id).Internship__c!=Trigger.newMap.get(objSummary.id).Internship__c){
                    objSummary.Is_Internship_Changed__c = true; // Setting the Internship Change Checkbox true
                }
                if(objSummary.Is_Residency_Changed__c==false && Trigger.oldMap.get(objSummary.id).Residency__c!=Trigger.newMap.get(objSummary.id).Residency__c){
                    objSummary.Is_Residency_Changed__c = true; // Setting the Residency Change Checkbox true
                }
                if(objSummary.Is_Spoken_Languages_Changed__c==false && Trigger.oldMap.get(objSummary.id).Spoken_Languages__c!=Trigger.newMap.get(objSummary.id).Spoken_Languages__c){
                    objSummary.Is_Spoken_Languages_Changed__c = true; // Setting the Spoken_Languages Change Checkbox true
                }
                if(objSummary.Is_Community_Activities_Changed__c==false && Trigger.oldMap.get(objSummary.id).Community_Activities__c!=Trigger.newMap.get(objSummary.id).Community_Activities__c){
                    objSummary.Is_Community_Activities_Changed__c = true; // Setting the Community_Activities Change Checkbox true
                }
                if(objSummary.Is_Personal_Interests_Changed__c==false && Trigger.oldMap.get(objSummary.id).Personal_Interests__c!=Trigger.newMap.get(objSummary.id).Personal_Interests__c){
                    objSummary.Is_Personal_Interests_Changed__c = true; // Setting the Personal Interests Change Checkbox true
                }
                if(objSummary.Is_Philosophy_of_care_Changed__c==false && Trigger.oldMap.get(objSummary.id).Philosophy_of_Care__c!=Trigger.newMap.get(objSummary.id).Philosophy_of_Care__c){
                    objSummary.Is_Philosophy_of_care_Changed__c = true; // Setting the Philosophy_of_Care Change Checkbox true
                }
                if(objSummary.Is_Medical_Affiliations_Changed__c==false && Trigger.oldMap.get(objSummary.id).Medical_Affiliations__c!=Trigger.newMap.get(objSummary.id).Medical_Affiliations__c){
                    objSummary.Is_Medical_Affiliations_Changed__c = true; // Setting the Medical_Affiliations Change Checkbox true
                }
                if(objSummary.Is_Website_Address_Changed__c==false && Trigger.oldMap.get(objSummary.id).Website_Address__c!=Trigger.newMap.get(objSummary.id).Website_Address__c){
                    objSummary.Is_Website_Address_Changed__c = true; // Setting the Website_Address Change Checkbox true
                }
                if(objSummary.Is_Professional_Interests_Changed__c==false && Trigger.oldMap.get(objSummary.id).Professional_Ineterests__c!=Trigger.newMap.get(objSummary.id).Professional_Ineterests__c){
                    objSummary.Is_Professional_Interests_Changed__c = true; // Setting the Professional_Ineterests Change Checkbox true
                }
                if(objSummary.Is_Online_Services_Changed__c==false && Trigger.oldMap.get(objSummary.id).Online_Services__c!=Trigger.newMap.get(objSummary.id).Online_Services__c){
                    objSummary.Is_Online_Services_Changed__c = true; // Setting the Online_Services Change Checkbox true
                }
                if(objSummary.Is_Board_Certifications_Changed__c==false && Trigger.oldMap.get(objSummary.id).Board_Certifications__c!=Trigger.newMap.get(objSummary.id).Board_Certifications__c){
                    objSummary.Is_Board_Certifications_Changed__c = true; // Setting the Board_Certifications Change Checkbox true
                }
                if(objSummary.Is_Publications_Changed__c==false && Trigger.oldMap.get(objSummary.id).Publications__c!=Trigger.newMap.get(objSummary.id).Publications__c){
                    objSummary.Is_Publications_Changed__c = true; // Setting the Publications Change Checkbox true
                }
                if(objSummary.Is_Additional_Information_Changed__c==false && Trigger.oldMap.get(objSummary.id).Additional_Information__c!=Trigger.newMap.get(objSummary.id).Additional_Information__c){
                    objSummary.Is_Additional_Information_Changed__c = true; // Setting the Additional_Information Change Checkbox true
                }
                //Primary Address is address changed flags 
                if(objSummary.Is_Secure_Street_Address_Changed__c==false && Trigger.oldMap.get(objSummary.id).Secure_Street_Address__c!=Trigger.newMap.get(objSummary.id).Secure_Street_Address__c){
                    objSummary.Is_Secure_Street_Address_Changed__c = true; // Setting the Secure Street Change Checkbox true
                }
                if(objSummary.Is_Secure_Address_Line_2_Changed__c==false 
                   && Trigger.oldMap.get(objSummary.id).Address_Line_2__c!=Trigger.newMap.get(objSummary.id).Address_Line_2__c){
                       objSummary.Is_Secure_Address_Line_2_Changed__c = true;
                   }
                if(objSummary.Is_Secure_City_Changed__c==false && Trigger.oldMap.get(objSummary.id).Secure_City__c!=Trigger.newMap.get(objSummary.id).Secure_City__c){
                    objSummary.Is_Secure_City_Changed__c = true; // Setting the Secure City Change Checkbox true
                }
                if(objSummary.Is_Secure_State_Changed__c==false && Trigger.oldMap.get(objSummary.id).Secure_State__c!=Trigger.newMap.get(objSummary.id).Secure_State__c){
                    objSummary.Is_Secure_State_Changed__c = true; // Setting the Secure State Change Checkbox true
                }
                if(objSummary.Is_Secure_Zip_Code_Changed__c==false && Trigger.oldMap.get(objSummary.id).Secure_Zip_Code__c!=Trigger.newMap.get(objSummary.id).Secure_Zip_Code__c){
                    objSummary.Is_Secure_Zip_Code_Changed__c = true; // Setting the Secure zip code Change Checkbox true
                }
                if(objSummary.Is_Secure_Phone_Ext_Changed__c==false && Trigger.oldMap.get(objSummary.id).Secure_Phone_Ext__c!=Trigger.newMap.get(objSummary.id).Secure_Phone_Ext__c){
                    objSummary.Is_Secure_Phone_Ext_Changed__c = true; // Setting the Secure Phone Ext Change Checkbox true
                }
            }// changed flags block Ends
            String oldOwnerId = trigger.oldMap.get(objSummary.Id).OwnerId;
            String newOwnerId = objSummary.OwnerId;
            
            /** REQ 3611 - IDC Offshore - 7/14/2015 : Update summary record Status to Accepted on Accept START **/
            if(oldOwnerId.subString(0,3).equalsIgnoreCase(Label.CL357_PDI_00G) && newOwnerId.subString(0,3).equalsIgnoreCase(Label.CL358_PDI_005)){
                objSummary.Status__c = Label.CL186_PDI_Accepted_Status;
                // REQ 3670 Start- Update Status
                if(trigger.oldMap.get(objSummary.Id).Validation_Source_Channel__c != objSummary.Validation_Source_Channel__c) { 
                    objSummary.Status__c = Label.CL187_PDI_Validated_Status;
                } // REQ 3670 End
            }
        }
    }
    //Req:3950 Started: To update the common phone numbers providers status count of phone number object
    SystemException__c systemException = new SystemException__c();
    try{
        if(Trigger.isInsert && Trigger.isAfter){
            List<String> phoneNumbers = new List<String>();
            List<String> lstPhoneNumbers = new List<String>();
            List<Id> setSummaryIds = new List<Id>();
            List<AggregateResult> arrDupPhoneNumbers = new List<AggregateResult>();
            
            for(Contact_Validation_Summary__c summary: Trigger.new)
            {
                if(summary.Secure_Phone__c != null && String.isNotBlank(summary.Secure_Phone__c)){
                    phoneNumbers.add(summary.Tech_Phone_Number__c);
                }
            }
            if(!phoneNumbers.isEmpty()){
                //Querying Duplicate Phone Numbers
                arrDupPhoneNumbers = [SELECT Tech_Phone_Number__c FROM Contact_Validation_Summary__c 
                                      WHERE Tech_Phone_Number__c IN : phoneNumbers AND PDI_Campaign__c = :Label.CL176_PDI_Current_Campaign_Name 
                                      GROUP BY Tech_Phone_Number__c HAVING  COUNT(Tech_Phone_Number__c) >1 LIMIT 1000];
            }
            //Updation provider validation status count in phone number object.
            if(!arrDupPhoneNumbers.isEmpty()){
                for(AggregateResult arr: arrDupPhoneNumbers)
                {
                    lstPhoneNumbers.Add(String.ValueOf(arr.get(Label.CL414_PDITechPhoneNumber)));
                }
                
                if(!lstPhoneNumbers.isEmpty()){
                    phoneHelper.updateProvidersStatusCount(lstPhoneNumbers, null);  
                }
                
            }
            ProvidersByPhoneNumberHelper.firstRunSummaryAfterInsert = false; 
        }
        if(Trigger.isUpdate && Trigger.isAfter){
            List<String> phoneNumbers = new List<String>();
            List<String> lstPhoneNumbers = new List<String>();
            List<AggregateResult> arrDupPhoneNumbers = new List<AggregateResult>();
            List<String> summaryIdsList = new List<String>();
            List<Id> setSummaryIds = new List<Id>();
            List<String> oldPhoneNumbers = new List<String>();
            for(Contact_Validation_Summary__c summary: Trigger.new)
            {
                //Getting dupplicate phone number and pld phone number
                if(String.isNotBlank(summary.Tech_Phone_Number__c)){
                    phoneNumbers.add(summary.Tech_Phone_Number__c);
                    if(Trigger.OldMap.get(summary.Id).Tech_Phone_Number__c != null && Trigger.OldMap.get(summary.Id).Tech_Phone_Number__c != summary.Tech_Phone_Number__c)
                    {
                        phoneNumbers.add(Trigger.OldMap.get(summary.Id).Tech_Phone_Number__c);
                    }
                }
                if(Trigger.OldMap.get(summary.Id).Tech_Phone_Number__c != null){
                	oldPhoneNumbers.add(Trigger.OldMap.get(summary.Id).Tech_Phone_Number__c);
                }
                
            }
            if(!phoneNumbers.isEmpty()){
                //Querying Duplicate Phone Numbers from contact validation summary object
                arrDupPhoneNumbers = [SELECT Tech_Phone_Number__c FROM Contact_Validation_Summary__c 
                                      WHERE Tech_Phone_Number__c IN : phoneNumbers AND PDI_Campaign__c = :Label.CL176_PDI_Current_Campaign_Name 
                                      GROUP BY Tech_Phone_Number__c HAVING  COUNT(Tech_Phone_Number__c) >1 LIMIT 1000];
            }
            //Updating validation status count on phone number object.
            if(!arrDupPhoneNumbers.isEmpty()){
                for(AggregateResult arr: arrDupPhoneNumbers)
                {
                    lstPhoneNumbers.Add(String.ValueOf(arr.get(Label.CL414_PDITechPhoneNumber)));
                }
                phoneHelper.updateProvidersStatusCount(lstPhoneNumbers, oldPhoneNumbers); 
            }
            else{
                phoneHelper.updateProvidersStatusCount(lstPhoneNumbers, oldPhoneNumbers); 
            }
            ProvidersByPhoneNumberHelper.firstRunSummaryAfterUpdate = false;
        }
    } catch(Exception ex) {
        systemException.ExceptionMessage__c = ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now(); insert systemException;
    }
    //Req:3950 Ended
}