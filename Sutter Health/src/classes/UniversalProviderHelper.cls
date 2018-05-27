/**
@Author      : Kishore Jonnadula
@name        : UniversalProviderHelper 
@CreateDate  : 27/09/2016 (DD/MM/YYYY)
@Description : This class is used to generate summary log and to save provider audit records.
@Version     : 1.0
@reference   : NA
*/
public class UniversalProviderHelper {
    public static final String strSpace = ' ';
    
    /*
    * @description  :   This method is used to create audit records for validated contact.
    * @param        :   summaryOld, AddressOld List, AddressNewList, contact Id, summary Record, providerSearchFlag
    * @return       :   void
    */
    public static void saveProviderInfo(Contact_Validation_Summary__c summaryOld, List<Provider_Address__c> provAddrOldList, List<Provider_Address__c> provAddrNewList,
                                        String contactId, Contact_Validation_Summary__c summaryObj, Boolean providerSearchFlag)
    {
        List<Contact_Validation_Audit_Trail__c> contactauditList = new List<Contact_Validation_Audit_Trail__c>();
        Contact_Validation_Audit_Trail__c auditObjOld;
        Contact_Validation_Audit_Trail__c auditObjNew;
        List<Contact_Validation_Audit_Trail__c> auditObjOldList = new List<Contact_Validation_Audit_Trail__c>();
        List<Contact_Validation_Audit_Trail__c> auditObjNewList = new List<Contact_Validation_Audit_Trail__c>();
        List<Contact_Validation_Audit_Trail__c> conNAAuditList = new List<Contact_Validation_Audit_Trail__c>();
        String providerStatus = '';
        String oktoText1 = '';
        Map<String, String> auditAddrStatusMap = new Map<String, String>();
        Map<String, String> auditAddrMDMMap = new Map<String, String>();
        Map<String, Provider_Address__c> oldAddressMap = new Map<String, Provider_Address__c>();
        
        //Old Address Map with key as serial number and value as old address object.
        if(!provAddrOldList.isEmpty()){
            for(Provider_Address__c oldAddress : provAddrOldList){
                oldAddressMap.put(oldAddress.Serial_Number__c, oldAddress);
            }
        }
        // This is the existing code, If there is no audit records for the contact, then it will capture the old value and new values once 
        // after the validation. If there totalAduitRecords count is greater than one, then it will capture only the new validated details
        // in Audit Object.
        Integer totalauditrecords = [select count() from  Contact_Validation_Audit_Trail__c where Contact_Id__c= :summaryOld.Contact_Id__c];
        contactauditList = [select id, Address_Unique_Identifier__c, Provider_Address_Id__c, Serial_Number__c, Address_Status__c, Sent_to_MDM__c from Contact_Validation_Audit_Trail__c where Contact_Id__c= :summaryOld.Contact_Id__c];
        
        if(!contactauditList.isEmpty()){
            for(Contact_Validation_Audit_Trail__c aduit : contactauditList){
                auditAddrStatusMap.put(aduit.Provider_Address_Id__c, aduit.Address_Status__c);
                auditAddrMDMMap.put(aduit.Provider_Address_Id__c, aduit.Sent_to_MDM__c);
            }
        }
        
        if(totalauditrecords == 0 ){
            /**** Capturing old values on audit object for history tracking starts ****/
            if(!provAddrOldList.isEmpty()){
                for(Provider_Address__c provOldAddress : provAddrOldList){
                    auditObjOld = new Contact_Validation_Audit_Trail__c();
                    
                    auditObjOld.PDI_Campaign__c = summaryOld.PDI_Campaign__c;
                    auditObjOld.Provider_Information_Summary__c = summaryOld.id;
                    auditObjOld.Contact_Id__c = contactId;
                    auditObjOld.First_Name__c = summaryOld.Provider_FirstName__c;
                    auditObjOld.Middle_Name__c = summaryOld.Provider_MiddleName__c;
                    auditObjOld.Last_Name__c = summaryOld.Provider_LastName__c;
                    auditObjOld.Provider_Title__c = summaryOld.Provider_Title__c;
                    auditObjOld.Provider_ID__c = summaryOld.Provider_ID__c;
                    auditObjOld.Provider_NPI__c = summaryOld.Provider_NPI_F__c;
                    auditObjOld.Practicing_Physician__c =  summaryOld.Practicing_Physician__c;
                    auditObjOld.Resigned_From_Sutter__c =  summaryOld.Resigned_From_Sutter__c;
                    auditObjOld.Retired_Departed__c =  summaryOld.Retired_Departed__c;
                    auditObjOld.Email__c =  summaryOld.Email__c;
                    auditObjOld.Speciality__c =  summaryOld.Speciality__c;
                    auditObjOld.Department__c =  summaryOld.Department__c;
                    auditObjOld.Mobile_Phone__c = summaryOld.Mobile_Phone__c;
                    auditObjOld.Ok_to_Text__c = summaryOld.Ok_to_Text__c;
                    auditObjOld.Preferred_Communication_Method__c = summaryOld.Preferred_Communication_Method__c;
                    auditObjOld.Communication_Preferences_HIM__c = summaryOld.Communication_Preferences_HIM__c;
                    auditObjOld.Medical_Education__c =  summaryOld.Medical_Education__c;
                    auditObjOld.Website_Address__c =  summaryOld.Website_Address__c;
                    auditObjOld.Hospital_Affiliations__c =  summaryOld.Hospital_Affiliations__c;
                    auditObjOld.Medical_Affiliations__c =  summaryOld.Medical_Affiliations__c;
                    auditObjOld.Internship__c =  summaryOld.Internship__c;
                    auditObjOld.Residency__c =  summaryOld.Residency__c;
                    auditObjOld.Spoken_Languages__c =  summaryOld.Spoken_Languages__c;
                    auditObjOld.Community_Activities__c =  summaryOld.Community_Activities__c;
                    auditObjOld.Personal_Interests__c =  summaryOld.Personal_Interests__c;
                    auditObjOld.Professional_Ineterests__c =  summaryOld.Professional_Ineterests__c;
                    auditObjOld.Online_Services__c =  summaryOld.Online_Services__c;
                    auditObjOld.Board_Certifications__c =  summaryOld.Board_Certifications__c;
                    auditObjOld.Publications__c =  summaryOld.Publications__c;
                    auditObjOld.Additional_Information__c =  summaryOld.Additional_Information__c;
                    auditObjOld.Philosophy_of_Care__c =  summaryOld.Philosophy_of_Care__c;
                    auditObjOld.Admin_Assistant_Title__c =  summaryOld.Admin_Assistant_Title__c;
                    auditObjOld.Admin_Assistant__c = summaryOld.Admin_Assistant__c;
                    auditObjOld.Admin_Assistant_Email__c = summaryOld.Admin_Assistant_Email__c;
                    auditObjOld.Admin_Assistant_Phone__c =  summaryOld.Admin_Assistant_Phone__c;
                    auditObjOld.Delegate_Phone_Ext__c =  summaryOld.Delegate_Phone_Ext__c;
                    auditObjOld.Provider_Access_Type__c =  summaryOld.Provider_Access_Type__c;
                    auditObjOld.Provider_Type__c = summaryOld.Provider_Type__c;
                    auditObjOld.Deficiency_Provider__c = summaryOld.Deficiency_Provider__c;
                    auditObjOld.Sent_to_MDM__c = Label.CL365_PDI_NA;
                    //Address Information
                    auditObjOld.Provider_Address_Id__c = provOldAddress.Id;
                    auditObjOld.Address_Unique_Identifier__c = provOldAddress.Address_Unique_Identifier__c;
                    auditObjOld.Serial_Number__c = provOldAddress.Serial_Number__c;
                    auditObjOld.Address_Type__c = provOldAddress.Address_Type__c;
                    auditObjOld.Address_Status__c = provOldAddress.Address_Status__c;
                    auditObjOld.Secure_Street_Address__c = provOldAddress.Address_Line1__c;
                    auditObjOld.Secure_Address_Line_2__c = provOldAddress.Address_Line_2__c;
                    auditObjOld.Secure_City__c = provOldAddress.City__c;
                    auditObjOld.Secure_Floor__c = provOldAddress.Floor__c;
                    auditObjOld.Secure_Suite__c = provOldAddress.Suite__c;
                    auditObjOld.Secure_State__c = provOldAddress.State__c;
                    //auditObjOld.County__c = provOldAddress.County__c;
                    auditObjOld.Secure_Zip_Code__c = provOldAddress.Zip_Code__c;
                    auditObjOld.Secure_Phone__c = provOldAddress.Secure_Phone__c;
                    auditObjOld.Secure_Fax__c = provOldAddress.Secure_Fax__c;
                    auditObjOld.Address_Status__c = provOldAddress.Address_Status__c;
                    auditObjOldList.add(auditObjOld);
                }
            }//Old Address if condition Ends - Line no:38
            /**** Capturing old values on audit object for history tracking Ends ****/
            /**** Capturing New values on audit object Starts ****/
            if(!provAddrNewList.isEmpty()){
                for(Provider_Address__c provNewAddress : provAddrNewList){
                    auditObjNew = new Contact_Validation_Audit_Trail__c();
                    
                    auditObjNew.Tech_Success_Email__c = true;
                    auditObjNew.PDI_Campaign__c = summaryOld.PDI_Campaign__c;
                    auditObjNew.Provider_Information_Summary__c = summaryOld.id;
                    auditObjNew.Contact_Id__c = contactId;
                    auditObjNew.Provider_Name_Suffix__c = summaryObj.contact_Id__r.Provider_Name_Suffix__c;
                    auditObjNew.First_Name__c = summaryObj.contact_Id__r.firstName;
                    auditObjNew.Middle_Name__c = summaryObj.contact_Id__r.Contact_Middle_Name__c;
                    auditObjNew.Last_Name__c = summaryObj.contact_Id__r.lastName;
                    auditObjNew.Provider_Title__c = summaryObj.Provider_Title__c;
                    auditObjNew.Provider_ID__c = summaryObj.Provider_ID__c;
                    auditObjNew.Provider_NPI__c = summaryObj.Provider_NPI_F__c;
                    auditObjNew.Practicing_Physician__c = summaryObj.Practicing_Physician__c; 
                    auditObjNew.Resigned_From_Sutter__c = summaryObj.Resigned_From_Sutter__c; 
                    auditObjNew.Retired_Departed__c = summaryObj.Retired_Departed__c;
                    auditObjNew.Email__c = summaryObj.Email__c;
                    auditObjNew.Speciality__c = summaryObj.Speciality__c;  
                    auditObjNew.Department__c = summaryObj.Department__c; 
                    if(String.isNotBlank(summaryObj.Mobile_Phone__c))
                    {
                        auditObjNew.Mobile_Phone__c = FormatPhone(summaryObj.Mobile_Phone__c);
                    } 
                    auditObjNew.Ok_to_Text__c = summaryObj.Ok_to_Text__c;
                    auditObjNew.Preferred_Communication_Method__c = summaryObj.Preferred_Communication_Method__c;
                    auditObjNew.Communication_Preferences_HIM__c = summaryObj.Communication_Preferences_HIM__c;
                    auditObjNew.Medical_Education__c = summaryObj.Medical_Education__c; 
                    auditObjNew.Website_Address__c = summaryObj.Website_Address__c; 
                    auditObjNew.Hospital_Affiliations__c = summaryObj.Hospital_Affiliations__c; 
                    auditObjNew.Medical_Affiliations__c = summaryObj.Medical_Affiliations__c;
                    auditObjNew.Internship__c =  summaryObj.Internship__c;
                    auditObjNew.Residency__c =  summaryObj.Residency__c;
                    auditObjNew.Spoken_Languages__c =  summaryObj.Spoken_Languages__c;
                    auditObjNew.Community_Activities__c =  summaryObj.Community_Activities__c;
                    auditObjNew.Personal_Interests__c =  summaryObj.Personal_Interests__c;
                    auditObjNew.Professional_Ineterests__c =  summaryObj.Professional_Ineterests__c;
                    auditObjNew.Online_Services__c =  summaryObj.Online_Services__c;
                    auditObjNew.Board_Certifications__c =  summaryObj.Board_Certifications__c;
                    auditObjNew.Publications__c =  summaryObj.Publications__c;
                    auditObjNew.Additional_Information__c =  summaryObj.Additional_Information__c;
                    auditObjNew.Philosophy_of_Care__c =  summaryObj.Philosophy_of_Care__c;
                    auditObjNew.Provider_Access_Type__c =  summaryObj.Provider_Access_Type__c;
                    auditObjNew.Provider_Type__c = summaryObj.Provider_Type__c;
                    auditObjNew.Deficiency_Provider__c = summaryObj.Deficiency_Provider__c;
                    //Address Information
                    auditObjNew.Provider_Address_Id__c = provNewAddress.Id;
                    auditObjNew.Address_Unique_Identifier__c = provNewAddress.Address_Unique_Identifier__c;
                    auditObjNew.Serial_Number__c = provNewAddress.Serial_Number__c;
                    auditObjNew.Address_Type__c = provNewAddress.Address_Type__c;
                    auditObjNew.Address_Status__c = provNewAddress.Address_Status__c;
                    auditObjNew.Secure_Street_Address__c = provNewAddress.Address_Line1__c;
                    auditObjNew.Secure_Address_Line_2__c = provNewAddress.Address_Line_2__c;
                    auditObjNew.Secure_City__c = provNewAddress.City__c;
                    auditObjNew.Secure_Floor__c = provNewAddress.Floor__c;
                    auditObjNew.Secure_Suite__c = provNewAddress.Suite__c;
                    auditObjNew.Secure_State__c = provNewAddress.State__c;
                    auditObjNew.Secure_Zip_Code__c = provNewAddress.Zip_Code__c;
                    auditObjNew.Secure_Phone__c = provNewAddress.Secure_Phone__c;
                    auditObjNew.Secure_Phone_Ext__c = provNewAddress.Secure_Phone_Ext__c;
                    auditObjNew.Secure_Fax__c = provNewAddress.Secure_Fax__c;
                    // PDI-Wave1 Decription: If the provider service status is 'Resigned' or 'Retired', 
                    // then assign existing values to below fields and insert audit record.
                    if(summaryObj.Practicing_Physician__c == true || (summaryObj.Resigned_From_Sutter__c == true && summaryObj.Is_Resigned_Provider_refer__c == true))
                    {
                        auditObjNew.Admin_Assistant_Title__c = summaryObj.Admin_Assistant_Title__c;
                        auditObjNew.Admin_Assistant__c = summaryObj.Admin_Assistant__c;
                        auditObjNew.Admin_Assistant_Email__c = summaryObj.Admin_Assistant_Email__c;
                        auditObjNew.Admin_Assistant_Phone__c = summaryObj.Admin_Assistant_Phone__c;
                        auditObjNew.Delegate_Phone_Ext__c =  summaryObj.Delegate_Phone_Ext__c;
                    }else{
                        auditObjNew.Admin_Assistant_Title__c = summaryOld.Admin_Assistant_Title__c;
                        auditObjNew.Admin_Assistant__c = summaryOld.Admin_Assistant__c;
                        auditObjNew.Admin_Assistant_Email__c = summaryOld.Admin_Assistant_Email__c;
                        auditObjNew.Admin_Assistant_Phone__c = summaryOld.Admin_Assistant_Phone__c;
                        auditObjNew.Delegate_Phone_Ext__c =  summaryOld.Delegate_Phone_Ext__c;
                    }
                    /**** Log File Starts ****/
                    String summaryLog = generateSummaryLog(summaryOld, auditObjNew, oldAddressMap, providerSearchFlag);
                    auditObjNew.Address_Change__c = summaryLog;
                    auditObjNew.Sent_to_MDM__c = '';
                    auditObjNewList.add(auditObjNew);
                }//for loop Ends
            }//New Address if condition Ends - Line no:106
            /**** Capturing New values on audit object Ends ****/
        }// total records if condition Ends
        else{
            /*@Description:Updating the Sent_to_MDM__c field of records of same contact created on the same day to N/A */
            conNAAuditList= [SELECT id, Sent_To_MDM__c FROM Contact_Validation_Audit_Trail__c
                             WHERE contact_id__c = :contactId AND Serial_Number__c != '' AND Sent_To_MDM__c = null];
            /*  For Req#3398 Modified the above query and removed this condition AND createdDate >= :Date.today() */
            for(Integer i=0;i<conNAAuditList.size();i++){
                conNAAuditList[i].Sent_To_MDM__c = Label.CL365_PDI_NA;
            }
            if(!provAddrNewList.isEmpty()){
                for(Provider_Address__c provNewAddress : provAddrNewList){
                    auditObjNew = new Contact_Validation_Audit_Trail__c();
                    if(provNewAddress.Serial_Number__c != null || (Label.CL472_PDI_AddressDelete.equalsIgnoreCase(provNewAddress.Address_Status__c) 
                                                                   && auditAddrStatusMap.get(provNewAddress.Name) != Label.CL472_PDI_AddressDelete
                                                                   && auditAddrMDMMap.get(provNewAddress.Name) != Label.CL365_PDI_NA))
                    {
                        auditObjNew.Tech_Success_Email__c = true;
                        auditObjNew.PDI_Campaign__c = summaryOld.PDI_Campaign__c;
                        auditObjNew.Provider_Information_Summary__c = summaryOld.id;
                        auditObjNew.Contact_Id__c = contactId;
                        auditObjNew.Provider_Name_Suffix__c = summaryObj.contact_Id__r.Provider_Name_Suffix__c;
                        auditObjNew.First_Name__c = summaryObj.contact_Id__r.firstName;
                        auditObjNew.Middle_Name__c = summaryObj.contact_Id__r.Contact_Middle_Name__c;
                        auditObjNew.Last_Name__c = summaryObj.contact_Id__r.lastName;
                        auditObjNew.Provider_Title__c = summaryObj.Provider_Title__c;
                        auditObjNew.Provider_ID__c = summaryObj.Provider_ID__c;
                        auditObjNew.Provider_NPI__c = summaryObj.Provider_NPI_F__c;
                        auditObjNew.Practicing_Physician__c = summaryObj.Practicing_Physician__c; 
                        auditObjNew.Resigned_From_Sutter__c = summaryObj.Resigned_From_Sutter__c; 
                        auditObjNew.Retired_Departed__c = summaryObj.Retired_Departed__c;
                        auditObjNew.Email__c = summaryObj.Email__c;
                        auditObjNew.Speciality__c = summaryObj.Speciality__c;  
                        auditObjNew.Department__c = summaryObj.Department__c; 
                        if(String.isNotBlank(summaryObj.Mobile_Phone__c))
                        {
                            auditObjNew.Mobile_Phone__c = FormatPhone(summaryObj.Mobile_Phone__c);
                        } 
                        auditObjNew.Ok_to_Text__c = summaryObj.Ok_to_Text__c;
                        auditObjNew.Preferred_Communication_Method__c = summaryObj.Preferred_Communication_Method__c;
                        auditObjNew.Communication_Preferences_HIM__c = summaryObj.Communication_Preferences_HIM__c;
                        auditObjNew.Medical_Education__c = summaryObj.Medical_Education__c; 
                        auditObjNew.Website_Address__c = summaryObj.Website_Address__c; 
                        auditObjNew.Hospital_Affiliations__c = summaryObj.Hospital_Affiliations__c; 
                        auditObjNew.Medical_Affiliations__c = summaryObj.Medical_Affiliations__c;
                        auditObjNew.Internship__c =  summaryObj.Internship__c;
                        auditObjNew.Residency__c =  summaryObj.Residency__c;
                        auditObjNew.Spoken_Languages__c =  summaryObj.Spoken_Languages__c;
                        auditObjNew.Community_Activities__c =  summaryObj.Community_Activities__c;
                        auditObjNew.Personal_Interests__c =  summaryObj.Personal_Interests__c;
                        auditObjNew.Professional_Ineterests__c =  summaryObj.Professional_Ineterests__c;
                        auditObjNew.Online_Services__c =  summaryObj.Online_Services__c;
                        auditObjNew.Board_Certifications__c =  summaryObj.Board_Certifications__c;
                        auditObjNew.Publications__c =  summaryObj.Publications__c;
                        auditObjNew.Additional_Information__c =  summaryObj.Additional_Information__c;
                        auditObjNew.Philosophy_of_Care__c =  summaryObj.Philosophy_of_Care__c;
                        auditObjNew.Provider_Access_Type__c =  summaryObj.Provider_Access_Type__c;
                        auditObjNew.Provider_Type__c = summaryObj.Provider_Type__c;
                        auditObjNew.Deficiency_Provider__c = summaryObj.Deficiency_Provider__c;
                        //Address Information
                        auditObjNew.Provider_Address_Id__c = provNewAddress.Id;
                        auditObjNew.Address_Unique_Identifier__c = provNewAddress.Address_Unique_Identifier__c;
                        auditObjNew.Serial_Number__c = provNewAddress.Serial_Number__c;
                        auditObjNew.Address_Type__c = provNewAddress.Address_Type__c;
                        auditObjNew.Address_Status__c = provNewAddress.Address_Status__c;
                        auditObjNew.Secure_Street_Address__c = provNewAddress.Address_Line1__c;
                        auditObjNew.Secure_Address_Line_2__c = provNewAddress.Address_Line_2__c;
                        auditObjNew.Secure_City__c = provNewAddress.City__c;
                        auditObjNew.Secure_Floor__c = provNewAddress.Floor__c;
                        auditObjNew.Secure_Suite__c = provNewAddress.Suite__c;
                        auditObjNew.Secure_State__c = provNewAddress.State__c;
                        auditObjNew.Secure_Zip_Code__c = provNewAddress.Zip_Code__c;
                        auditObjNew.Secure_Phone__c = provNewAddress.Secure_Phone__c;
                        auditObjNew.Secure_Phone_Ext__c = provNewAddress.Secure_Phone_Ext__c;
                        auditObjNew.Secure_Fax__c = provNewAddress.Secure_Fax__c;
                        // PDI-Wave1 Decription: If the provider service status is 'Resigned' or 'Retired', 
                        // then assign existing values to below fields and insert audit record.
                        if(summaryObj.Practicing_Physician__c == true || (summaryObj.Resigned_From_Sutter__c == true && summaryObj.Is_Resigned_Provider_refer__c == true))
                        {
                            auditObjNew.Admin_Assistant_Title__c = summaryObj.Admin_Assistant_Title__c;
                            auditObjNew.Admin_Assistant__c = summaryObj.Admin_Assistant__c;
                            auditObjNew.Admin_Assistant_Email__c = summaryObj.Admin_Assistant_Email__c;
                            auditObjNew.Admin_Assistant_Phone__c = summaryObj.Admin_Assistant_Phone__c;
                            auditObjNew.Delegate_Phone_Ext__c =  summaryObj.Delegate_Phone_Ext__c;
                        }else{
                            auditObjNew.Admin_Assistant_Title__c = summaryOld.Admin_Assistant_Title__c;
                            auditObjNew.Admin_Assistant__c = summaryOld.Admin_Assistant__c;
                            auditObjNew.Admin_Assistant_Email__c = summaryOld.Admin_Assistant_Email__c;
                            auditObjNew.Admin_Assistant_Phone__c = summaryOld.Admin_Assistant_Phone__c;
                            auditObjNew.Delegate_Phone_Ext__c =  summaryOld.Delegate_Phone_Ext__c;
                        }
                        /**** Log File Starts ****/
                        
                        String summaryLog = generateSummaryLog(summaryOld, auditObjNew, oldAddressMap, providerSearchFlag);
                        auditObjNew.Address_Change__c = summaryLog;
                        auditObjNew.Sent_to_MDM__c = '';
                    }
                    auditObjNewList.add(auditObjNew);
                }//for loop Ends
            }//if conditon Ends
        }//Else block Ends - line no:194
        
        if(!auditObjOldList.isEmpty()){
            insert auditObjOldList; 
        }
        if(!auditObjNewList.isEmpty()){
            insert auditObjNewList;
        }
        if(!conNAAuditList.isEmpty()){
            update conNAAuditList;
        }
    }//saveProviderInfo Method ends
    
    /*
    * @description  :   This method used to generate summary log of old and new address values.
    * @param        :   sumOld, auditObjNew, oldAddressMap, providerSearchFlag
    * @return       :   String
    */
    private static String generateSummaryLog(Contact_Validation_Summary__c sumOld, Contact_Validation_Audit_Trail__c auditObjNew, Map<String, Provider_Address__c> oldAddressMap, Boolean providerSearchFlag){
        
        Provider_Address__c oldAddress = new Provider_Address__c();
        String strLog = strSpace;
        String strAddressType;
        String strSerNumber;
        String logAddressStatus;
        
        if(!oldAddressMap.isEmpty() && oldAddressMap.containsKey(auditObjNew.Serial_Number__c)){
            oldAddress = oldAddressMap.get(auditObjNew.Serial_Number__c);
        }
        
        if(auditObjNew.Address_Type__c == Label.CL303_PDIPrimary){
            strAddressType = Label.CL566_PDIPrimaryAddressText;
            strSerNumber = strSpace;
        }
        else if(auditObjNew.Address_Type__c == Label.CL359_PDI_secondaryAddress){
            strAddressType = Label.CL567_PDISecondaryAddressText;
            strSerNumber = Label.CL282_PDI_S_hash + auditObjNew.Serial_Number__c;
        }else{
            strSerNumber = strSpace;
            logAddressStatus = Label.CL187_PDI_Validated_Status;
        }
        if(auditObjNew.Address_Status__c == Label.CL568_PDIAddressNewText){
            logAddressStatus = Label.CL569_PDIAddressAddedText;
            
        }
        else if(auditObjNew.Address_Status__c == Label.CL570_PDIAddressModifyText){
            logAddressStatus = Label.CL571_PDIAddressModifiedText;
        }
        else if(auditObjNew.Address_Status__c == Label.CL572_PDIAddressDeleteText){
            logAddressStatus = Label.CL573_PDIAddressDeletedText;
            strSerNumber = strSpace;
        }
        if((auditObjNew.Secure_City__c != oldAddress.City__c) || (auditObjNew.Secure_Fax__c != oldAddress.Secure_Fax__c)
           || (auditObjNew.Secure_Street_Address__c != oldAddress.Address_Line1__c)
           || (auditObjNew.Secure_Address_Line_2__c != oldAddress.Address_Line_2__c)
           || (auditObjNew.Secure_State__c != oldAddress.State__c)
           || (auditObjNew.Secure_Zip_Code__c != oldAddress.Zip_Code__c) || (auditObjNew.Secure_Phone__c != oldAddress.Secure_Phone__c)
           || (auditObjNew.Secure_Phone_Ext__c != oldAddress.Secure_Phone_Ext__c))
        {
            auditObjNew.address_modified__c = Label.CL261_PDI_Yes;
            strLog = strLog + Label.CL417_PDIProviderNameLog + strSpace + auditObjNew.First_Name__c + strSpace + auditObjNew.Last_Name__c+ Label.CL283_PDI_singleBreak;
            strLog = strLog + strSerNumber + strSpace + strAddressType + strSpace + logAddressStatus + strSpace + Label.CL281_PDI_AT + strSpace + system.now().format() + Label.CL284_doubleBreak;
        } else {
            auditObjNew.address_modified__c = Label.CL262_PDI_No;
            strLog = strLog + Label.CL417_PDIProviderNameLog + strSpace + auditObjNew.First_Name__c + strSpace + auditObjNew.Last_Name__c+ Label.CL283_PDI_singleBreak;
            strLog = strLog + strSerNumber + strSpace + strAddressType + strSpace + Label.CL187_PDI_Validated_Status + strSpace + Label.CL281_PDI_AT + strSpace + system.now().format() + Label.CL284_doubleBreak;
        }
        
        if(auditObjNew.Secure_Street_Address__c != oldAddress.Address_Line1__c) {
            strLog  = strLog + Label.CL288_PDI_Log_Address1 + Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + oldAddress.Address_Line1__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Secure_Street_Address__c + Label.CL284_doubleBreak; 
        }
        if(auditObjNew.Secure_City__c != oldAddress.City__c) {
            strLog  = strLog + Label.CL287_PDI_Log_City + Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + oldAddress.City__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Secure_City__c + Label.CL284_doubleBreak; 
        }
        if(auditObjNew.Secure_State__c != oldAddress.State__c) {
            strLog  = strLog + Label.CL291_PDI_Log_State + Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + oldAddress.State__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Secure_State__c + Label.CL284_doubleBreak; 
        }
        if(auditObjNew.Secure_Zip_Code__c != oldAddress.Zip_Code__c) {
            strLog  = strLog + Label.CL290_PDI_Log_ZipCode + Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + oldAddress.Zip_Code__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Secure_Zip_Code__c + Label.CL284_doubleBreak; 
        }
        if(auditObjNew.Secure_Phone__c != oldAddress.Secure_Phone__c) {
            strLog  = strLog + Label.CL292_PDI_Log_Phone + Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + oldAddress.Secure_Phone__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Secure_Phone__c + Label.CL284_doubleBreak; 
        }
        if(auditObjNew.Secure_Phone_Ext__c != oldAddress.Secure_Phone_Ext__c) {
            strLog  = strLog + Label.CL444_PDI_Log_Secure_Phone_Ext + Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + oldAddress.Secure_Phone_Ext__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Secure_Phone_Ext__c + Label.CL284_doubleBreak; 
        }
        if(auditObjNew.Secure_Fax__c != oldAddress.Secure_Fax__c) {
            strLog  = strLog + Label.CL293_PDI_Log_Fax + Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + oldAddress.Secure_Fax__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Secure_Fax__c + Label.CL284_doubleBreak; 
        }
        
        if(auditObjNew.Retired_Departed__c != sumOld.Retired_Departed__c) {
            strLog  = strLog + Label.CL244_PDI_Retired +  Label.CL283_PDI_singleBreak + Label.CL285_PDI_From + strSpace + sumOld.Retired_Departed__c + Label.CL283_PDI_singleBreak + Label.CL286_PDI_To + strSpace + auditObjNew.Retired_Departed__c + Label.CL284_doubleBreak; 
        }
        
        if(auditObjNew.Resigned_From_Sutter__c != sumOld.Resigned_From_Sutter__c) {
            strLog  = strLog + Label.CL245_PDI_Resign +  Label.CL283_PDI_singleBreak + Label.CL285_PDI_From + strSpace + sumOld.Resigned_From_Sutter__c + Label.CL283_PDI_singleBreak + Label.CL286_PDI_To + strSpace + auditObjNew.Resigned_From_Sutter__c + Label.CL284_doubleBreak; 
        }
        
        if(auditObjNew.Practicing_Physician__c != sumOld.Practicing_Physician__c){
            strLog  = strLog + Label.CL243_PDI_Practicing +  Label.CL283_PDI_singleBreak + Label.CL285_PDI_From + strSpace + sumOld.Practicing_Physician__c + Label.CL283_PDI_singleBreak + Label.CL286_PDI_To + strSpace + auditObjNew.Practicing_Physician__c + Label.CL284_doubleBreak; 
        }
        if((auditObjNew.Email__c != sumOld.Email__c) && (!String.isBlank(auditObjNew.Email__c) || !String.isBlank(sumOld.Email__c))) {
            strLog  = strLog + Label.CL294_PDI_Log_Email +  Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + sumOld.Email__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Email__c + Label.CL284_doubleBreak; 
        }
        if((auditObjNew.Mobile_Phone__c != sumOld.Mobile_Phone__c) && (!String.isBlank(auditObjNew.Mobile_Phone__c) || !String.isBlank(sumOld.Mobile_Phone__c))) {
            strLog  = strLog + Label.CL295_PDI_Log_Mobile +  Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + sumOld.Mobile_Phone__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Mobile_Phone__c + Label.CL284_doubleBreak; 
        }
        if(providerSearchFlag == true){
            if((auditObjNew.Speciality__c != sumOld.Speciality__c) && (!String.isBlank(auditObjNew.Speciality__c) || !String.isBlank(sumOld.Speciality__c))) {
                strLog  = strLog + Label.CL426_PDI_Log_speciality +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Speciality__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Speciality__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Department__c != sumOld.Department__c) && (!String.isBlank(auditObjNew.Department__c) || !String.isBlank(sumOld.Department__c))) {
                strLog  = strLog + Label.CL428_PDI_Log_Department +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Department__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Department__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Hospital_Affiliations__c != sumOld.Hospital_Affiliations__c) && (!String.isBlank(auditObjNew.Hospital_Affiliations__c) || !String.isBlank(sumOld.Hospital_Affiliations__c))) {
                strLog  = strLog + Label.CL429_PDI_Log_Hospital_Affiliations +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Hospital_Affiliations__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Hospital_Affiliations__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Medical_Affiliations__c != sumOld.Medical_Affiliations__c) && (!String.isBlank(auditObjNew.Medical_Affiliations__c) || !String.isBlank(sumOld.Medical_Affiliations__c))) {
                strLog  = strLog + Label.CL430_PDI_Log_Medical_Affiliations +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Medical_Affiliations__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Medical_Affiliations__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Medical_Education__c != sumOld.Medical_Education__c) && (!String.isBlank(auditObjNew.Medical_Education__c) || !String.isBlank(sumOld.Medical_Education__c))) {
                strLog  = strLog + Label.CL430_PDI_Log_Medical_Education +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Medical_Education__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Medical_Education__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Website_Address__c != sumOld.Website_Address__c) && (!String.isBlank(auditObjNew.Website_Address__c) || !String.isBlank(sumOld.Website_Address__c))) {
                strLog  = strLog + Label.CL432_PDI_Log_Website_Address +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Website_Address__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Website_Address__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Internship__c != sumOld.Internship__c) && (!String.isBlank(auditObjNew.Internship__c) || !String.isBlank(sumOld.Internship__c))) {
                strLog  = strLog + Label.CL433_PDI_Log_Internship +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Internship__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Internship__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Residency__c != sumOld.Residency__c) && (!String.isBlank(auditObjNew.Residency__c) || !String.isBlank(sumOld.Residency__c))) {
                strLog  = strLog + Label.CL434_PDI_Log_Residency +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Residency__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Residency__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Spoken_Languages__c != sumOld.Spoken_Languages__c) && (!String.isBlank(auditObjNew.Spoken_Languages__c) || !String.isBlank(sumOld.Spoken_Languages__c))) {
                strLog  = strLog + Label.CL435_PDI_Log_Spoken_Languages +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Spoken_Languages__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Spoken_Languages__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Community_Activities__c != sumOld.Community_Activities__c) && (!String.isBlank(auditObjNew.Community_Activities__c) || !String.isBlank(sumOld.Community_Activities__c))) {
                strLog  = strLog + Label.CL436_PDI_Log_Community_Activities +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Community_Activities__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Community_Activities__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Personal_Interests__c != sumOld.Personal_Interests__c) && (!String.isBlank(auditObjNew.Personal_Interests__c) || !String.isBlank(sumOld.Personal_Interests__c))) {
                strLog  = strLog + Label.CL437_PDI_Log_Personal_Interests +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Personal_Interests__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Personal_Interests__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Philosophy_of_Care__c != sumOld.Philosophy_of_Care__c) && (!String.isBlank(auditObjNew.Philosophy_of_Care__c) || !String.isBlank(sumOld.Philosophy_of_Care__c))) {
                strLog  = strLog + Label.CL438_PDI_Log_Philosophy_of_Care +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Philosophy_of_Care__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Philosophy_of_Care__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Professional_Ineterests__c != sumOld.Professional_Ineterests__c) && (!String.isBlank(auditObjNew.Professional_Ineterests__c) || !String.isBlank(sumOld.Professional_Ineterests__c))) {
                strLog  = strLog + Label.CL439_PDI_Log_Professional_Interests +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Professional_Ineterests__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Professional_Ineterests__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Online_Services__c != sumOld.Online_Services__c) && (!String.isBlank(auditObjNew.Online_Services__c) || !String.isBlank(sumOld.Online_Services__c))) {
                strLog  = strLog + Label.CL440_PDI_Log_Online_Services +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Online_Services__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Online_Services__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Board_Certifications__c != sumOld.Board_Certifications__c) && (!String.isBlank(auditObjNew.Board_Certifications__c) || !String.isBlank(sumOld.Board_Certifications__c))) {
                strLog  = strLog + Label.CL441_PDI_Log_Board_Certifications +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Board_Certifications__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Board_Certifications__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Publications__c != sumOld.Publications__c) && (!String.isBlank(auditObjNew.Publications__c) || !String.isBlank(sumOld.Publications__c))) {
                strLog  = strLog + Label.CL443_PDI_Log_Publications +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Publications__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Publications__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Additional_Information__c != sumOld.Additional_Information__c) && (!String.isBlank(auditObjNew.Additional_Information__c) || !String.isBlank(sumOld.Additional_Information__c))) {
                strLog  = strLog + Label.CL442_PDI_Log_Additional_Information +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + sumOld.Additional_Information__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Additional_Information__c + Label.CL284_doubleBreak; 
            }
        }
        if((auditObjNew.Admin_Assistant_Title__c != sumOld.Admin_Assistant_Title__c) && (!String.isBlank(auditObjNew.Admin_Assistant_Title__c) || !String.isBlank(sumOld.Admin_Assistant_Title__c))) {
            strLog  = strLog + Label.CL444_PDI_Log_Admin_Assistant_Title +  Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + sumOld.Admin_Assistant_Title__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Admin_Assistant_Title__c + Label.CL284_doubleBreak; 
        }
        if((auditObjNew.Admin_Assistant__c != sumOld.Admin_Assistant__c) && (!String.isBlank(auditObjNew.Admin_Assistant__c) || !String.isBlank(sumOld.Admin_Assistant__c))) {
            strLog  = strLog + Label.CL300_PDI_Log_AdminName +  Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + sumOld.Admin_Assistant__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Admin_Assistant__c + Label.CL284_doubleBreak; 
        }
        if((auditObjNew.Admin_Assistant_Email__c != sumOld.Admin_Assistant_Email__c) && (!String.isBlank(auditObjNew.Admin_Assistant_Email__c) || !String.isBlank(sumOld.Admin_Assistant_Email__c))) {
            strLog  = strLog + Label.CL301_PDI_Log_AdminEmail +  Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + sumOld.Admin_Assistant_Email__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Admin_Assistant_Email__c + Label.CL284_doubleBreak; 
        }
        if((auditObjNew.Admin_Assistant_Phone__c != sumOld.Admin_Assistant_Phone__c) && (!String.isBlank(auditObjNew.Admin_Assistant_Phone__c) || !String.isBlank(sumOld.Admin_Assistant_Phone__c))) {
            strLog  = strLog + Label.CL302_PDI_Log_AdminPhone +  Label.CL283_PDI_singleBreak +
                Label.CL285_PDI_From + strSpace + sumOld.Admin_Assistant_Phone__c + Label.CL283_PDI_singleBreak +
                Label.CL286_PDI_To + strSpace + auditObjNew.Admin_Assistant_Phone__c + Label.CL284_doubleBreak; 
        }
        
        return strLog;   
    }
    /*
* @author       :   IDC Offshore
* @date         :   06/06/2016
* @description  :   Used to format the phone number into US format
* @param        :   N/A
* @return       :   String
*/
    public static String FormatPhone(String Phone) {
        string nondigits = '[^0-9]';
        string PhoneDigits;
        
        // remove all non numeric
        PhoneDigits = Phone.replaceAll(nondigits,'');
        
        // 10 digit: reformat with dashes
        if (PhoneDigits.length() == 10) 
            return '('+PhoneDigits.substring(0,3)+')' + ' ' +
            PhoneDigits.substring(3,6) + '-' +
            PhoneDigits.substring(6,10);
        // 11 digit: if starts with 1, format as 10 digit 
        if (PhoneDigits.length() == 11) {
            if (PhoneDigits.substring(0,1) == '1') {
                return  '('+PhoneDigits.substring(1,4)+')' + ' ' +
                    PhoneDigits.substring(4,7) + '-' +
                    PhoneDigits.substring(7,11);
            }
        }
        
        // if it isn't a 10 or 11 digit number, return the original because
        // it may contain an extension or special information
        return( Phone );
    }
}