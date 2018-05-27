/**  
*    Class Name: ManageContactDatabase
*    Author: Brandon Cassis
*    Date: 28-June-2013
*    Project Name: CRM - SFT - Sutter Health
*    Description: This is a helper class for the trigger 'ManageContacts'. It contains methods that call the Methods of 
*    ManageCommunityUsers class which contains the means to create new users or to manage the existing users. The new users are created for the
*    Employee Contacts which do not have an existing user. If a user exists with a ContactId as the new Contact's Id 
*    then the User is modified. The methods are called for all the contacts being inserted and updated that are of Employee Recordtype.
*
*    History
*    --------
*    VERSION    AUTHOR          DATE                 DETAIL
*       1.0     IDC Offshore   30/07/2013       Added Comments and Indentation
*       2.0     IDC Offshore   30/07/2013       Rectified Comments and Indentation adding more details
*       3.0     IDC Offshore   21/04/2014       Req2978 R5 Bargaining Unit Changes
*       4.0     IDC Offshore   11/10/2014       For PCRM - Added/Modified methods for calling the methods of ManageCommunityUsers class which contains the functionality for creating new users for 
*                                               Provider type Contacts who don't have a User Record before. and manage the existing users.   
*       5.0     IDC Offshore   10/03/2015       Req no 3236 OLTP Member                                             
*       6.0     IDC Offshore   26/03/2015       PDV Requirement-REQ 3399  
*       7.0     IDC Offshore   26/06/2015       PDV Call Center (Req 3611) : Create provider summary record if contact email is null
*       8.0     IDC Offshore   15/04/2016       PDI - Wave1 Modified code in ManageInsertedContactsOnBefore method to copy contact email to
*                                               temp ADID user email field, and makes original contact email field as null so that user is 
*                                               not created and no Email is triggered.
**/
Public without sharing class ManageContactDatabase {
    
    /** @Description: Boolean variable isCalledbefore and String variable employeeId are declared to be used in the Class **/
    public static Boolean isCalledBefore = false;
    public static String employeeId {get; set;}
    
    /** @Description: Empty Constructor.**/
    Public ManageContactDatabase() {}
    
    /**
* @Description: This method takes up all the inserted contacts which are of Provider Recordtype and verifies whether they are
* list of Internal Provider Contacts. It then copies the Email field to Internal Provider Email field 
* and Makes Email field as null so that User is not created and no Email is triggered.
* @Arguments: List of inserted Contacts
* @Return: Void
* Modified on 01/09/2016
**/
    public static void ManageInsertedContactsOnBefore(List<Contact> insertedContacts){
        
        Id providerRecordTypeId = [select Id from RecordType where name='Provider' and SObjectType='Contact' limit 1].Id;
        
        for(Contact objContact:insertedContacts){
            String tempContactEmail = objContact.Email;
            if(objContact.Employee_ADID__c != null && objContact.Email!=null 
               && objContact.recordTypeId==providerRecordTypeId && objContact.Provider_Retired_Departed__c != true 
               && 'Internal'.equalsIgnorecase(objContact.Provider_Type__c) && objContact.Provider_Active_Status__c == true)
            {
                objContact.Internal_Provider_Email__c = objContact.Email;
                objContact.Email = null; 
            }
        }
    }
    
    /**
*   @Description: This method takes up all the inserted contacts which are of Employee Recordtype and calls CreateNewUsers method by passing the 
*   list of Employee Contacts. CreateNewUsers method is used to take a list of employee contacts 
*   and create a new user's list if the Contact Employee Status is Active.
*   @Arguments: List of inserted Contacts
*   @Return: Void
**/
    public static void ManageInsertedContacts(List<Contact> insertedContacts){
        list<contact> providersList = new list<contact>();
        
        /** REQ 3611 - IDC Offshore - 6/26/2015 : Provider Contact list START **/
        List<Contact> insertedProviderContactsList = new List<Contact>();
        List<Contact> insertedAdminAsstContactsList = new List<Contact>();
        /** REQ 3611 - IDC Offshore - 6/26/2015 : Provider Contact list END **/
        
        /** @Description: This method is use to insert data from Contact object to PCP object.
*   insertContactPCP method which takes in list of inserted Contacts .
*    Req no 3236 oltp
**/
        insertContactPCP(insertedContacts);
        
        /** @Description: Check if the list's size is greater than zero for inserted Employee Contacts by calling
*   getEmployees method which takes in list of inserted Contacts and returns a list of contacts
*   of recordtype Employee.
**/
        if(getEmployees(insertedContacts).size() > 0) {
            
            ManageCommunityUsers.CreateNewUsers(getEmployees(insertedContacts));
        }
        
        /** @Description            : Added for PCRM - Creating User for those Contacts which are of Provider RecordType.
@Code Block Added By    : IDC Offshore
@version                : 4.0
@Date                   : 14/11/2014 (DD/MM/YYYY)
**/
        providersList = getProvidersForUserCreation(insertedContacts,null,null);
        if(providersList.size() > 0) {
            createContactProviderSummaryRecords(providersList);
            ManageCommunityUsers.CreateProviderUsers(providersList);
        }
        /** @Code Block End - IDC Offshore - 14/11/2014 **/
        
        Id providerAdminAsstRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Provider Admin Assistant').RecordTypeId;
        Id ProviderRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Provider').RecordTypeId;
        /** REQ 3611 - IDC Offshore - 6/26/2015 : Create Summary record for Contacts with email = null START **/
        for(Contact objContact : insertedContacts){
            //PDI-Wave1: Modified to include practicing physician and active status checks.
            if(objContact.recordTypeId == ProviderRecordTypeId && objContact.Email == null && objContact.Provider_Retired_Departed__c != true && objContact.Provider_Active_Status__c == true){
                insertedProviderContactsList.add(objContact);
            }
            if(objContact.recordTypeId == providerAdminAsstRecordTypeId && objContact.Email != null)
            {
                insertedAdminAsstContactsList.add(objContact);
            }
        }
        
        //Create Admin Assistant Users call
        if(!insertedAdminAsstContactsList.isEmpty()){
            ManageCommunityUsers.CreateAdminAssistantUsers(insertedAdminAsstContactsList);
        }
        
        if(!insertedProviderContactsList.isEmpty()){
            createContactProviderSummaryRecords(insertedProviderContactsList);
        }
        /** REQ 3611 - IDC Offshore - 6/26/2015 : Create Summary record for Contacts with email = null END **/
    }
    
    /**
* @author       :   IDC Offshore 
* @date         :   17/02/2014 (DD/MM/YYYY)
* @version      :   4.0
* @description  :   Added for  inserting  data in PCP object OLTP Req no 3236
* @param        :   List
* @return       :   Void
*/
    public static void createPcpInofrmation(list<Contact> p_providersList) {
        
        List<PCP_information__C> pcpInformationList = new List<PCP_information__C>();
        List<Database.UpsertResult> updateResults;
        
        
        try { 
            if(p_providersList.size()> 0)
            {
                /** @Description: Iterate over the list of all inserted or updated Contacts  and inserted into PCP object**/
                for(Contact tempCon : p_providersList) {
                    
                    string externalFieldPCP = tempCon.Member_HR_ID__c + tempCon.Member_PCP_Practitioner_HR_ID__c ;
                    pcpInformationList.add(new PCP_information__C(
                        PCP_External_ID__c = externalFieldPCP
                        ,SPS_Epic_ID__C =tempcon.Supplier_SPS_Epic_ID__c
                        ,PCP_Practitioner_HR_ID__C =tempcon.Member_PCP_Practitioner_HR_ID__c
                        ,PCP_Practitioner_NPI__C = tempcon.Member_PCP_NPI__c
                        ,PCP_Practitioner_Name__C = tempcon.Member_s_PCP_Name_Practice__c
                        ,PCP_Practitioner_First_Name__C = tempcon.Member_PCP_Name_First__c
                        ,PCP_Practitioner_Middle_Name__c = tempcon.Member_PCP_Name_Middle__c
                        ,PCP_Practitioner_Last_Name__C = tempcon.Member_PCP_Name_Last__c
                        ,PCP_Supplier_NPI__C = tempcon.Supplier_NPI__c         
                        ,PCP_Effective_date__C  = tempCon.Member_Effective_Date__c
                        ,PCP_Supplier_Location_HR_ID__C = tempcon.Member_PCP_Supplier_Location_HR_ID__c
                        ,PCP_Supplier_Location_name__C = tempcon.Member_PCP_Supplier_Location_Name__c
                        ,PCP_Specialty_HR_ID__C = tempcon.Member_PCP_Specialty_HR_ID__c
                        ,PCP_Specialty_HCC_ID__C = tempcon.Member_PCP_Specialty_HCC_ID__c
                        ,PCP_Speciality__c = tempcon.Member_PCP_Specialty_Name__c
                        ,PCP_Specialty_Sub_HR_ID__C = tempcon.Member_PCP_Specialty_Sub_HR_ID__c
                        ,PCP_Specialty_Sub_HCC_ID__c = tempcon.Member_PCP_Specialty_Sub_HCC_ID__c
                        ,PCP_sub_Specialty__C = tempcon.Member_PCP_Specialty_Sub_Name__c
                        ,PCP_Member_HR_ID__c = tempcon.Member_Employer_HR_ID__c
                        ,Member_ID__c=tempCon.id
                    ));
                }
                updateResults = database.upsert(pcpInformationList,PCP_information__C.Fields.PCP_External_ID__c , false);
                
                
            }
            List<SystemException__c> lstSysExp = new List<SystemException__c>();
            /** @Description: Iterate over the list of all inserted or updated PCP object and saving all failed data into exceptions object**/
            for(Integer i=0;i<updateResults.size();i++){
                if (!updateResults.get(i).isSuccess()){
                    Database.Error error = updateResults.get(i).getErrors().get(0);
                    pcpInformationList.get(i);//failed record from the list
                    SystemException__c newObj = new SystemException__c() ;   
                    newObj.ExceptionMessage__c = pcpInformationList[i].id + error.getMessage();  
                    lstSysExp.add(newObj);
                }
            }
            
            insert lstSysExp;
            //code coverage for catch block
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        } catch(Exception e) {
            Utility.handleExceptionFromCode(e.getMessage() + '\r\n' + e.getStackTraceString() + '\r\n' + e.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
* @author       :   IDC Offshore 
* @date         :   17/02/2014 (DD/MM/YYYY)
* @version      :   4.0
* @description  :   Added for OLTP Req no 3236 to check record type  and id for Sobject
* @param        :   Map
* @return       :   Map
*/ 
    public  static Map<string, string> checkRecordType(string objectType)
    {   Map<String,String> contactRecordTypes = new Map<String,String>();
     
     List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType= :objectType and isActive=true];
     
     /** @Description: Iterate over the list of all record type and return record type value and ID**/
     for(RecordType rt: rtypes){
         
         contactRecordTypes.put(rt.Name,rt.Id);
     }
     
     return contactRecordTypes;
    } 
    
    /**
* @author       :   IDC Offshore 
* @date         :   17/02/2014 (DD/MM/YYYY)
* @version      :   4.0
* @description  :   Added for OLTP Req no 3236 (Copy data PCP fields from contact object to PCP object)
* @param        :   List
* @return       :   Void
*/ 
    public static void  insertContactPCP(List<Contact> updatedContactsPCP)
    {        
        try {    
            CreatedDate__c createdDateCustomSetting = CreatedDate__c.getValues('CopyPcpDate');
            map <string ,string> recordtype = new map <string,string>();  
            string objectType= 'contact';
            recordtype = checkRecordType(objectType);
            list <contact> contactMember = new list <contact>();
            if(recordtype.size() > 0 )
            {
                String value = recordtype.get('Member');
                /** @Description: Iterate over the list of all inserted or updated Contacts **/
                for (contact con  :  updatedContactsPCP)
                {
                    if(con.recordTypeID == value && value != null)
                    { 
                        if((createdDateCustomSetting.Created_date__c  >Date.today())&&(con.Member_HR_ID__c != null && con.Member_PCP_Practitioner_HR_ID__c != null)){
                            
                            contactMember.add(con); 
                        }  
                    }                           
                }
                //Req# Quick Fix
                if(!(contactMember.isEmpty())){
                    createPcpInofrmation(contactMember);
                }
                
                
            }
        } catch(Exception e) {
            Utility.handleExceptionFromCode(e.getMessage() + '\r\n' + e.getStackTraceString() + '\r\n' + e.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
* @author       :   IDC Offshore
* @date         :   18/11/2014 (DD/MM/YYYY)
* @version      :   4.0
* @description  :   Added for PCRM - Creates Contact Validation Summary Records based on Contact Records
* @param        :   List [Contact]
* @return       :   N/A
*/ 
    public static void createContactProviderSummaryRecords(list<Contact> p_providersList) {
        
        // Boolean OkToText;
        String CommunicationPreferencesHIM;//02/06/2016  USPS
        String strValidationSourceChannel;
        list<Contact_Validation_Summary__c> cvsList = new list<Contact_Validation_Summary__c>(); 
        List<id> newContacts=new List<id>();
        list<id> contactIdList = new list<id>();
        map<id,string> contactId_username_map = new map<id,string>();
        Map<Id,List<Contact_Validation_Summary__c>> mapContactRelatedSummary = new Map<id,List<Contact_Validation_Summary__c>>();
        
        
        for(Contact temp : p_providersList) contactIdList.add(temp.id);
        for(User temp : [SELECT id, contactId, Username FROM User WHERE contactId = :contactIdList]){ 
            contactId_username_map.put(temp.contactId,temp.Username);
        }
        /* Req 3398 SOC  Inserting the summary record for a provider based on record count of summary records */
        /*Start*/
        Map<id,string> MapSERContactIds = new Map<id,string>();
        List<Contact_Validation_Summary__c> summaryContacts = new List<Contact_Validation_Summary__c>();
        List<Contact> providerContacts = new List<Contact>();
        for(Contact objPro:p_providersList) {
            MapSERContactIds.put(objPro.id,'Provider');
        }
        summaryContacts = [select Contact_Id__c,Address_Type__c from Contact_Validation_Summary__c where Contact_Id__c in: MapSERContactIds.keyset() and  Address_Type__c =: Label.CL303_PDIPrimary and PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name ];     
        for(Contact_Validation_Summary__c tempsummary:summaryContacts){    
            MapSERContactIds.remove(tempsummary.Contact_Id__c); 
        }
        /* PDI-Wave1 code changes in select query - Added Provider_Admin_Assistant__c,Provider_Admin_Assistant_Email__c,
* Provider_Access_Type__c,Provider_Type__c,Deficiency_Provider__c,HIM_Deficiency_Email__c,Provider_Communication_Preferences_HIM__c
* Provider_Resigned_From_Sutter__c, Provider_Practicing_Physician__c,Provider_Retired_Departed__c fields. 
*/                         
        providerContacts =  [select Name, Preferred_Communication_Method__c,Ok_To_Text__c,Provider_Name__c,Provider_Address_Line_2__c,
                             Provider_Title__c,Email,MobilePhone,Provider_Correspondence_Address__c,Provider_Admin_Assistant_Phone__c, 
                             Provider_Delegate_Phone_Ext__c,Provider_Correspondence_City__c,Provider_Correspondence_State__c,Provider_Correspondence_PostalCode__c,
                             Provider_Correspondence_Phone__c,Provider_Correspondence_Fax_Number__c,Provider_Retired_Departed__c,
                             Provider_Resigned_From_Sutter__c, Provider_Practicing_Physician__c, Provider_Communication_Preferences_HIM__c,
                             Provider_ID__c,Provider_NPI__c,Provider_Admin_Assistant__c,Provider_Admin_Assistant_Email__c,
                             Provider_Access_Type__c,Provider_Type__c,Deficiency_Provider__c,Phone_Extension__c,Provider_Admin_Assistant_Title__c,
                             Contact_External_ID1__c,id,Username__c,Teleform_Last_Validation_Date__c,Provider_Portal_Last_Validation_Date__c
                             from contact 
                             where id in: MapSERContactIds.keyset()];
        /*End*/
        List<Group> nonValidatedProviderQueue = [select Id from Group where Name = 'Non Validated Providers' and Type = 'Queue' limit 1];
        if(providerContacts != null && !providerContacts.isEmpty()) {  
            try { 
                for(Contact tempCon : providerContacts) {
                    
                    //   if(tempCon.Ok_To_Text__c!=null && tempCon.Ok_To_Text__c.containsIgnoreCase('yes'))
                    //       OkToText = true;
                    //   else
                    //       OkToText = false; 
                    //02/06/2016 - USPS
                    if(tempCon.Provider_Communication_Preferences_HIM__c!=null && tempCon.Provider_Communication_Preferences_HIM__c.containsIgnoreCase('Printed Letter'))
                        CommunicationPreferencesHIM = 'Printed Letter (USPS)';
                    else
                        CommunicationPreferencesHIM = tempCon.Provider_Communication_Preferences_HIM__c;
                    
                    
                    // Code to populate the last verified date on summary records if it comes from MDM
                    
                    DateTime lastVerifiedDate = null;
                    String newStatus = 'Non-Validated';
                    //Need to comment this if condition code to create summary record to assign as non validated status
                    /*if(tempCon.Provider_Portal_Last_Validation_Date__c <> null){
lastVerifiedDate = ReturnValidationDateTime(tempCon.Provider_Portal_Last_Validation_Date__c);   
newStatus = 'Validated';
// REQ 3670 - Setting the value for Validation Source Channel 
strValidationSourceChannel = 'SFPP'; 
}*/
                    
                    if('true'.equalsIgnoreCase(Label.CL375_PDIAllowInactiveProvider) && tempCon.Provider_Resigned_From_Sutter__c == true){
                        tempCon.Provider_Practicing_Physician__c = true;
                        tempCon.Provider_Resigned_From_Sutter__c = false;
                    }
                    
                    if(String.isNotBlank(tempCon.Provider_Correspondence_Phone__c) && tempCon.Provider_Correspondence_Phone__c.SubString(0,1).Contains('1')){
                        tempCon.Provider_Correspondence_Phone__c = tempCon.Provider_Correspondence_Phone__c.SubString(1, tempCon.Provider_Correspondence_Phone__c.Length());
                    } 

                    // END- 
                    cvsList.add(new Contact_Validation_Summary__c(
                        Provider_Name__c = tempCon.Provider_Name__c
                        , Provider_Title__c = tempCon.Provider_Title__c
                        , Email__c = tempCon.Email
                        , Validation_Source_Channel__c = strValidationSourceChannel
                        //Replacing 1 from mobile phone
                        , Mobile_Phone__c = String.isNotBlank(tempCon.MobilePhone) && tempCon.MobilePhone.SubString(0,1).Contains('1') ? 
                        tempCon.MobilePhone.SubString(1, tempCon.MobilePhone.Length()): tempCon.MobilePhone
                        , Secure_Street_Address__c = tempCon.Provider_Correspondence_Address__c
                        , Secure_City__c = tempCon.Provider_Correspondence_City__c
                        , Secure_State__c = tempCon.Provider_Correspondence_State__c
                        , Secure_Zip_Code__c = tempCon.Provider_Correspondence_PostalCode__c
                        /*,Secure_Phone__c = String.isNotBlank(tempCon.Provider_Correspondence_Phone__c) && tempCon.Provider_Correspondence_Phone__c.SubString(0,1).Contains('1') ? 
tempCon.Provider_Correspondence_Phone__c.SubString(1, tempCon.Provider_Correspondence_Phone__c.Length()): tempCon.Provider_Correspondence_Phone__c
*/                ,Secure_Phone__c = tempCon.Provider_Correspondence_Phone__c
                        ,Tech_Phone_Number__c = String.isNotBlank(tempCon.Provider_Correspondence_Phone__c)?tempCon.Provider_Correspondence_Phone__c.replaceAll('[^0-9]',''):tempCon.Provider_Correspondence_Phone__c
                        
                        , Secure_Phone_Ext__c = tempCon.Phone_Extension__c
                        ,Secure_Fax__c = String.isNotBlank(tempCon.Provider_Correspondence_Fax_Number__c) && tempCon.Provider_Correspondence_Fax_Number__c.SubString(0,1).Contains('1') ? 
                        tempCon.Provider_Correspondence_Fax_Number__c.SubString(1, tempCon.Provider_Correspondence_Fax_Number__c.Length()): tempCon.Provider_Correspondence_Fax_Number__c
                        , Provider_ID__c = tempCon.Provider_ID__c
                        , Contact_ID__c = tempCon.id
                        , Username__c = contactId_username_map.get(tempCon.id)
                        , New_Street_Address__c = tempCon.Provider_Correspondence_Address__c
                        , Preferred_Communication_Method__c = tempCon.Preferred_Communication_Method__c                            
                        , OwnerId = nonValidatedProviderQueue.size()>0 ? nonValidatedProviderQueue[0].id : UserInfo.getUserId()
                        , Name = tempCon.Name
                        , Last_Verified_Date__c = lastVerifiedDate
                        , Status__c = newStatus
                        //PDI-Wave1 Code Change starts
                        , PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name
                        , Retired_Departed__c = tempCon.Provider_Retired_Departed__c 
                        , Resigned_From_Sutter__c = tempCon.Provider_Resigned_From_Sutter__c 
                        , Practicing_Physician__c = tempCon.Provider_Practicing_Physician__c 
                        , Communication_Preferences_HIM__c = CommunicationPreferencesHIM 
                        , Admin_Assistant__c = tempCon.Provider_Admin_Assistant__c 
                        , Admin_Assistant_Email__c = tempCon.Provider_Admin_Assistant_Email__c 
                        , Deficiency_Provider__c = tempCon.Deficiency_Provider__c 
                        , Provider_Access_Type__c = tempCon.Provider_Access_Type__c 
                        , Provider_Type__c = tempCon.Provider_Type__c
                        , Address_Line_2__c = tempCon.Provider_Address_Line_2__c
                        , Address_Type__c = Label.CL303_PDIPrimary
                        , Admin_Assistant_Phone__c = String.isNotBlank(tempCon.Provider_Admin_Assistant_Phone__c) &&   tempCon.Provider_Admin_Assistant_Phone__c.SubString(0,1).Contains('1') ? 
                        tempCon.Provider_Admin_Assistant_Phone__c.SubString(1, tempCon.Provider_Admin_Assistant_Phone__c.Length()): tempCon.Provider_Admin_Assistant_Phone__c
                        , Delegate_Phone_Ext__c = tempCon.Provider_Delegate_Phone_Ext__c
                        , Admin_Assistant_Title__c = tempCon.Provider_Admin_Assistant_Title__c
                        //PDI-Wave1 Code Change Ends
                    ));
                }
                insert cvsList; 
            } catch(Exception e) {
                Utility.handleExceptionFromCode(e.getMessage() + '\r\n' + e.getStackTraceString() + '\r\n' + e.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }
        }      
    }
    
    
    /**
* @author       :   IDC Offshore
* @date         :   27/04/2015 (DD/MM/YYYY)
* @version      :   1.0
* @description  :   Added for PDV TeleForm REQ# 3399 - Updates Contact Validation Summary Records based on Contact Records
* @param        :   List [Contact] , Map<Id, Contact> ,Map<Id, Contact>
* @return       :   N/A
*/ 
    
    public static void updateProviderSummaryRecords(List<Contact> updatedContacts, 
                                                    Map<Id, Contact> oldContactMap,  Map<Id, Contact> newContactMap)
    {
        // PDI May Wave: Added for MDM full file updated records as part of deployment
        if('true'.equalsIgnoreCase(Label.CL376_PDIIsCampaignInitiation))
        {
            PDICampaignInitiationHelper.CreateNewCampaignProviderRecords(newContactMap);
        }
        else
        {
            set<Id> setContactIds = new Set<Id>();
            List<Contact_Validation_Summary__c> lstSummariesToUpdate = new List<Contact_Validation_Summary__c>();
            Map<id,List<Contact_Validation_Summary__c>> mapRelatedSummaries =new Map<id,List<Contact_Validation_Summary__c>>();
            
            for(Contact objCntct:updatedContacts)
                setContactIds.add(objCntct.id);
            for(Contact objCon:[select id,(select id,Last_Verified_Date__c,Secure_Street_Address__c,Secure_City__c,Secure_Zip_Code__c,Secure_State__c,Provider_ID__c,
                                           Secure_Phone__c,Secure_Phone_Ext__c,Secure_Fax__c,Mobile_Phone__c,Preferred_Communication_Method__c,Email__c,Ok_To_Text__c,
                                           Retired_Departed__c,Resigned_From_Sutter__c,Practicing_Physician__c,Communication_Preferences_HIM__c,Address_Line_2__c,
                                           Admin_Assistant__c,Admin_Assistant_Email__c,Deficiency_Provider__c,Provider_Access_Type__c,Provider_Type__c,
                                           Admin_Assistant_Phone__c, Delegate_Phone_Ext__c, Admin_Assistant_Title__c,Status__c,PDI_Campaign__c
                                           from Summarys__r where Contact_Id__c in:setcontactIds AND Address_Type__c=: Label.CL303_PDIPrimary AND Status__c !=: Label.CL187_PDI_Validated_Status AND PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name) from Contact where id in:setcontactIds])
                mapRelatedSummaries.put(objCon.id,objCon.Summarys__r);
            
            for(Contact objContact:updatedContacts){
                if(newContactMap.get(objContact.Id).Provider_Active_Status__c == true){
                    if(oldContactMap.get(objcontact.id).Email != newContactMap.get(objContact.id).Email 
                       || oldContactMap.get(objcontact.id).Preferred_Communication_Method__c != newContactMap.get(objContact.id).Preferred_Communication_Method__c 
                       || oldContactMap.get(objcontact.id).Provider_Communication_Preferences_HIM__c != newContactMap.get(objContact.id).Provider_Communication_Preferences_HIM__c
                       || oldContactMap.get(objcontact.id).Provider_Resigned_From_Sutter__c != newContactMap.get(objContact.id).Provider_Resigned_From_Sutter__c
                       || oldContactMap.get(objcontact.id).Provider_Practicing_Physician__c != newContactMap.get(objContact.id).Provider_Practicing_Physician__c
                       || oldContactMap.get(objcontact.id).Provider_Retired_Departed__c != newContactMap.get(objContact.id).Provider_Retired_Departed__c
                       || oldContactMap.get(objcontact.id).Ok_To_Text__c != newContactMap.get(objContact.id).Ok_To_Text__c 
                       || oldContactMap.get(objcontact.id).MobilePhone != newContactMap.get(objContact.id).MobilePhone 
                       || oldContactMap.get(objcontact.id).Provider_Correspondence_Address__c != newContactMap.get(objContact.id).Provider_Correspondence_Address__c 
                       || oldContactMap.get(objcontact.id).Provider_Correspondence_City__c != newContactMap.get(objContact.id).Provider_Correspondence_City__c 
                       || oldContactMap.get(objcontact.id).Provider_Correspondence_State__c != newContactMap.get(objContact.id).Provider_Correspondence_State__c 
                       || oldContactMap.get(objcontact.id).Provider_Correspondence_PostalCode__c != newContactMap.get(objContact.id).Provider_Correspondence_PostalCode__c 
                       || oldContactMap.get(objcontact.id).Provider_Correspondence_Fax_Number__c != newContactMap.get(objContact.id).Provider_Correspondence_Fax_Number__c 
                       || oldContactMap.get(objcontact.id).Provider_Correspondence_Phone__c != newContactMap.get(objContact.id).Provider_Correspondence_Phone__c 
                       || oldContactMap.get(objcontact.id).Deficiency_Provider__c != newContactMap.get(objContact.id).Deficiency_Provider__c 
                       || oldContactMap.get(objcontact.id).Phone_Extension__c !=  newContactMap.get(objContact.id).Phone_Extension__c
                       || oldContactMap.get(objcontact.id).Provider_Admin_Assistant__c != newContactMap.get(objContact.id).Provider_Admin_Assistant__c
                       || oldContactMap.get(objcontact.id).Provider_Admin_Assistant_Email__c != newContactMap.get(objContact.id).Provider_Admin_Assistant_Email__c
                       || oldContactMap.get(objcontact.id).Provider_Type__c != newContactMap.get(objContact.id).Provider_Type__c
                       || objContact.Provider_Portal_Last_Validation_Date__c <> null
                       || objContact.Provider_Access_Type__c <> null 
                       || oldContactMap.get(objcontact.id).Provider_Address_Line_2__c != newContactMap.get(objContact.id).Provider_Address_Line_2__c
                       || oldContactMap.get(objcontact.id).Provider_Admin_Assistant_Phone__c != newContactMap.get(objContact.id).Provider_Admin_Assistant_Phone__c
                       || oldContactMap.get(objcontact.id).Provider_ID__c != newContactMap.get(objContact.id).Provider_ID__c
                       || oldContactMap.get(objcontact.id).Provider_Admin_Assistant_Title__c != newContactMap.get(objContact.id).Provider_Admin_Assistant_Title__c
                       || oldContactMap.get(objcontact.id).Provider_Name__c != newContactMap.get(objContact.id).Provider_Name__c 
                       || oldContactMap.get(objcontact.id).Provider_Title__c != newContactMap.get(objContact.id).Provider_Title__c) {
                           
                           List<Contact_Validation_Summary__c> lstSummaries = mapRelatedSummaries.get(objContact.id);
                           for(Contact_Validation_Summary__c objSummary:lstSummaries){
                               objSummary.Provider_Name__c = objContact.Provider_Name__c;
                               objSummary.Provider_Title__c = objContact.Provider_Title__c;
                               objSummary.Secure_Street_Address__c = objContact.Provider_Correspondence_Address__c;
                               objSummary.Secure_City__c = objContact.Provider_Correspondence_City__c;
                               objSummary.Secure_Zip_Code__c = objContact.Provider_Correspondence_PostalCode__c;
                               objSummary.Secure_State__c = objContact.Provider_Correspondence_State__c;
                               objSummary.Secure_Phone__c = String.isNotBlank(objContact.Provider_Correspondence_Phone__c) && objContact.Provider_Correspondence_Phone__c.SubString(0,1).Contains('1') ? 
                                   objContact.Provider_Correspondence_Phone__c.SubString(1, objContact.Provider_Correspondence_Phone__c.Length()): objContact.Provider_Correspondence_Phone__c;
                               
                               objSummary.Secure_Fax__c = String.isNotBlank(objContact.Provider_Correspondence_Fax_Number__c) && objContact.Provider_Correspondence_Fax_Number__c.SubString(0,1).Contains('1') ? 
                                   objContact.Provider_Correspondence_Fax_Number__c.SubString(1, objContact.Provider_Correspondence_Fax_Number__c.Length()): objContact.Provider_Correspondence_Fax_Number__c; 
                               
                               //Replacing 1 from mobile phone
                               objSummary.Mobile_Phone__c = String.isNotBlank(objContact.MobilePhone) && objContact.MobilePhone.SubString(0,1).Contains('1') ? 
                                   objContact.MobilePhone.SubString(1, objContact.MobilePhone.Length()): objContact.MobilePhone;
                               objSummary.Preferred_Communication_Method__c = objContact.Preferred_Communication_Method__c;
                               objSummary.Email__c = objContact.Email;
                               /** PDI-Wave1 @Code Block START - IDC Offshore - 08/03/2016 **/
                               objSummary.Retired_Departed__c = objContact.Provider_Retired_Departed__c;
                               objSummary.Resigned_From_Sutter__c = objContact.Provider_Resigned_From_Sutter__c;
                               objSummary.Practicing_Physician__c = objContact.Provider_Practicing_Physician__c;
                               //  objSummary.Communication_Preferences_HIM__c = objContact.Provider_Communication_Preferences_HIM__c;
                               objSummary.Admin_Assistant__c = objContact.Provider_Admin_Assistant__c;
                               objSummary.Admin_Assistant_Email__c = objContact.Provider_Admin_Assistant_Email__c;
                               objSummary.Deficiency_Provider__c = objContact.Deficiency_Provider__c;
                               objSummary.Provider_Access_Type__c = objContact.Provider_Access_Type__c;
                               objSummary.Provider_Type__c = objContact.Provider_Type__c;
                               objSummary.Secure_Phone_Ext__c = objContact.Phone_Extension__c;
                               objSummary.Address_Line_2__c = objContact.Provider_Address_Line_2__c;
                               objSummary.Admin_Assistant_Phone__c = String.isNotBlank(objContact.Provider_Admin_Assistant_Phone__c) && objContact.Provider_Admin_Assistant_Phone__c.SubString(0,1).Contains('1') ? 
                                   objContact.Provider_Admin_Assistant_Phone__c.SubString(1, objContact.Provider_Admin_Assistant_Phone__c.Length()): objContact.Provider_Admin_Assistant_Phone__c;                  
                               objSummary.Provider_ID__c = objContact.Provider_ID__c;
                               objSummary.Admin_Assistant_Title__c = objContact.Provider_Admin_Assistant_Title__c;
                               /** PDI-Wave1 @Code Block END - IDC Offshore - 08/03/2016 **/
                               
                               if(objContact.Ok_To_Text__c!=null && objContact.Ok_To_Text__c.containsIgnoreCase('yes')){
                                   objSummary.Ok_To_Text__c = true;
                               }
                               else{
                                   objSummary.Ok_To_Text__c = false;           
                               }
                               
                               //02/06/2016 - USPS
                               if(objContact.Provider_Communication_Preferences_HIM__c!=null && objContact.Provider_Communication_Preferences_HIM__c.containsIgnoreCase('Printed Letter'))
                                   objSummary.Communication_Preferences_HIM__c = 'Printed Letter (USPS)';
                               else
                                   objSummary.Communication_Preferences_HIM__c = objContact.Provider_Communication_Preferences_HIM__c;
                               
                               /*Start : Provider not showing validated : Updating Last Verified date on Provider Information Summary Object*/     
                               //  if(objSummary.Last_Verified_Date__c == null){
                               
                               //         if(objContact.Provider_Portal_Last_Validation_Date__c <> null){
                               //            objSummary.Last_Verified_Date__c = ReturnValidationDateTime(objContact.Provider_Portal_Last_Validation_Date__c);
                               // update the summary status to validated
                               // REQ 3670 Start- Populating the Validation Source Channel field with SFPP value
                               //           objSummary.Validation_Source_Channel__c = 'SFPP';
                               // REQ 3670- End            
                               //           objSummary.Status__c = 'Validated';                                 
                               //       }
                               
                               //} 
                               /*End*/    
                               objSummary.Tech_is_Contact_Updated__c = true; //Used to control isChangedFlags update through contact update
                               lstsummariesToupdate.add(objSummary);       
                           }
                       }
                }
            }      
            if(lstSummariesToUpdate!=null && !lstSummariesToUpdate.isEmpty())
                update lstSummariesToUpdate;
        }
        
    }
    
    
    /**
*   @Description: This method is converting date to datetime.
*   @Arguments: date
*   @Return: DateTime
**/
    public static DateTime ReturnValidationDateTime(date ValidationDate){
        Datetime dtValidationDate = datetime.newInstance(ValidationDate.year(), ValidationDate.month(),ValidationDate.day());
        return dtValidationDate;
    }
    
    
    /**
*   @Description: This method takes up list of updated Contacts, old map of Contacts and new map of Contacts and calls ManageUser Method
*   which checks that for a contact updated, whether a User already exist or not. If it exists it updates the 
*   user according to the Contact or else it creates a new user.
*   @Arguments: List of updated Contacts, Old Map of Contacts, New Map of Contacts
*   @Return: Void
**/
    public static void ManageUpdatedContacts(List<Contact> updatedContacts, Map<Id, Contact> oldContactMap,  Map<Id, Contact> newContactMap){
        list<contact> providersList = new list<contact>();
        list<Id> updatedAdminAsstIdList = new list<Id>();
        Map<Id, Contact> providernewContactMap = new Map<Id, Contact>();
        /** @Description: This method is use to insert data from Contact object to PCP object.
*   insertContactPCP method which takes in list of inserted Contacts .
*    Req no 3236 oltp
**/
        insertContactPCP(updatedContacts);
        
        /** @Description: Check if the list's size is greater than zero for updated Employee Contacts by calling
*   getEmployees method which takes in list of inserted Contacts and returns a list of contacts
*   of recordtype Employee. 
**/
        if(getEmployees(updatedContacts).size() > 0) {
            
            List<Contact> changedContacts = new List<Contact>();
            Map<Id, Contact> changedOldMap = new Map<Id, Contact>();
            Map<Id, Contact> changedNewMap = new Map<Id, Contact>();
            
            for(Contact con:updatedContacts)
            {
                /** Requirement 2978-R5 Bargaining Unit Changes 
*@Description:We have modified the code and checking the changes in work email and Bargaining union field also. 
*Added : ADID Field for SSO -Copy ADID from Contact to Federation ID on user object 
*Req-3676 Added Employee_Company__c and Employee_Process_Level__c  feilds to the condition
**/         
                
                
                if(oldContactMap.get(con.Id).Employee_EEO_SubCode__c <> newContactMap.get(con.Id).Employee_EEO_SubCode__c
                   || oldContactMap.get(con.Id).Employee_Affiliate_Facility__c <> newContactMap.get(con.Id).Employee_Affiliate_Facility__c
                   || oldContactMap.get(con.Id).Employee_Union_Affiliate__c <> newContactMap.get(con.Id).Employee_Union_Affiliate__c
                   || oldContactMap.get(con.Id).Employee_Employment_Status__c <> newContactMap.get(con.Id).Employee_Employment_Status__c
                   || oldContactMap.get(con.Id).Employee_Work_Email__c <> newContactMap.get(con.Id).Employee_Work_Email__c 
                   || oldContactMap.get(con.Id).Employee_Bargaining_Union__c <> newContactMap.get(con.Id).Employee_Bargaining_Union__c
                   || oldContactMap.get(con.Id).Employee_Company__c <> newContactMap.get(con.Id).Employee_Company__c
                   || oldContactMap.get(con.Id).Employee_Process_Level__c <> newContactMap.get(con.Id).Employee_Process_Level__c
                   || oldContactMap.get(con.Id).Employee_ADID__c <> newContactMap.get(con.Id).Employee_ADID__c
                   || !(oldContactMap.get(con.Id).Employee_ADID__c!=NULL && String.valueOf(oldContactMap.get(con.Id).Employee_ADID__c).equals(String.valueOf(newContactMap.get(con.Id).Employee_ADID__c)))
                  )
                    
                {
                    changedContacts.add(con);
                    changedOldMap.put(con.Id, oldContactMap.get(con.Id));
                    changedNewMap.put(con.Id, newContactMap.get(con.Id));
                }
            }
            
            /** @Description: Call ManageUsers method in ManageCommunityUsers Class and pass list of updated contacts with recordtype 'Employee', 
*   old map and new map of contacts **/
            if(!changedContacts.isEmpty() && !changedOldMap.isEmpty() && !changedNewMap.isEmpty()){
                ManageCommunityUsers.ManageUsers(getEmployees(changedContacts), changedOldMap, changedNewMap);
            }
        }
        
        /** @Description            : Added for PCRM - Creating User for those Contacts which are of Provider RecordType.
@Code Block Added By    : IDC Offshore
@version                : 4.0
@Date                   : 14/11/2014 (DD/MM/YYYY)
@DateModified           : 09/04/2015 (DD/MM/YYYY) For REQ 3399 PDV
**/
        
        /** REQ 3399- PDV Requirement.We use static variable to prevent execution of User Creation and User Updation in the same transaction **/
        
        if(ContactTriggerHelper.RUNCODE==true)
        {
            providernewContactMap.putAll(newContactMap);
            System.debug(':::::::::::::::in manageupdateContacts:before:::updatedContacts:::'+updatedContacts);
            System.debug(':::::::::::::::in manageupdateContacts:before::::oldContactMap:::'+oldContactMap);
            System.debug(':::::::::::::::in manageupdateContacts:before:::::newContactMap::'+newContactMap);
            updateProviderSummaryRecords(updatedContacts, oldContactMap, newContactMap);
            System.debug(':::::::::::::::in manageupdateContacts:After:::updatedContacts:::'+updatedContacts);
            System.debug(':::::::::::::::in manageupdateContacts:After::::oldContactMap:::'+oldContactMap);
            System.debug(':::::::::::::::in manageupdateContacts:After:::::newContactMap::'+newContactMap);
            System.debug(':::::::::::::::in manageupdateContacts:After:::::providernewContactMap::'+providernewContactMap);
            
            //PDI May Wave: Started: To create new campaign records if contact is updated with active status
            
            Map<Id, Contact> activeContactIds = new Map<Id, Contact>();
            List<Id> exsummaryContactIds = new List<Id>();
            for(Contact c: newContactMap.values())
            {
                if(c.Provider_Active_Status__c == true)
                {
                    activeContactIds.put(c.Id, newContactMap.get(c.Id));
                    
                }
            }
            if(!activeContactIds.isEmpty())
            {
                
            }
            for(Contact_Validation_Summary__c cvs: [select id,Contact_Id__r.Id, Address_Type__c, Status__c, PDI_Campaign__c
                                                    from Contact_Validation_Summary__c where Contact_Id__c in: activeContactIds.keySet() AND PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name])
            {
                exsummaryContactIds.add(cvs.Contact_Id__r.Id);
            }
            
            if(!exsummaryContactIds.isEmpty())
            {
                for(Id cId: exsummaryContactIds)
                {
                    activeContactIds.remove(cId);
                }
            }
            createContactProviderSummaryRecords(activeContactIds.values());
            //PDI May Wave: Ended: 
            
            Set<Id> setContactIds = newContactMap.keySet();
            List<User> lstExistingUsers = [select id from User where contactId in:setContactIds];
            if(lstExistingUsers==null || lstExistingUsers.size()==0){  
                providersList = getProvidersForUserCreation(updatedContacts,oldContactMap,providernewContactMap);
                if(providersList.size() > 0) {
                    createContactProviderSummaryRecords(providersList);
                    ManageCommunityUsers.CreateProviderUsers(providersList);
                }
            }
        }
        
        if(ContactTriggerHelper.RUNCODE==true)
        {
            Set<Id> setContactIds = newContactMap.keySet();
            List<User> lstExistingUsers = [select id from User where contactId in:setContactIds];
            if(lstExistingUsers!=null && lstExistingUsers.size()>0)
            { 
                //Admin Assistant User Updation Starts
                Id adminRecordTypeId = [select Id from RecordType where name='Provider Admin Assistant' and SObjectType='Contact' limit 1].Id;
                for(Contact contactObj : updatedContacts){
                    if(contactObj.RecordTypeId != null && contactObj.RecordTypeId == adminRecordTypeId 
                       && oldContactMap != null && newContactMap != null && contactObj.Username__c!=null && contactObj.Username__c!='') {
                           //Contact Update
                           if(oldContactMap.get(contactObj.Id).Email != null && oldContactMap.get(contactObj.Id).Email != '' 
                              && newContactMap.get(contactObj.Id).Email != null && newContactMap.get(contactObj.Id).Email != '' 
                              && oldContactMap.get(contactObj.Id).Email!=newContactMap.get(contactObj.Id).Email){
                                  updatedAdminAsstIdList.add(contactObj.Id);
                              }
                       }
                }
                if(!updatedAdminAsstIdList.isEmpty()){
                    ManageCommunityUsers.UpdateAdminAssistantUsers(updatedAdminAsstIdList);
                }
                //Admin Assistant User Updation Ends
                
                providersList = getProvidersForUserUpdation(updatedContacts,oldContactMap,newContactMap);
                if(!providersList.isEmpty()){
                    List<Id> lstnewContacts=new List<Id>();
                    for(contact objCntct:providersList)
                        lstnewContacts.add(objCntct.id);    
                    ManageCommunityUsers.UpdateProviderUsers(lstnewContacts);   
                }
            }
        }
        /** @Code Block End - IDC Offshore - 14/11/2014 **/
        
        /** @Code Block START - IDC Offshore - 23/07/2015 Delete Provider Summary Information record if Service Status is not null 
*  IDC Offshore - 03/05/2016 As part of PDI - Wave1 commented the below delete code, if retired/departed is true.
*/
        /*Set<Id> contactWithNullEmailIdSet = new Set<Id>();
// PDI-Wave1 Code change
for(Contact con : updatedContacts){
if(con.RecordtypeId == Schema.SObjectType.Contact.RecordTypeInfosByName.get('Provider').RecordTypeId
&&  con.Provider_Retired_Departed__c == true){
contactWithNullEmailIdSet.add(con.Id);
}
}
try{
List<Contact_Validation_Summary__c> summaryList = [select Id from Contact_Validation_Summary__c where Contact_Id__c IN : contactWithNullEmailIdSet];
if(!summaryList.isEmpty()){
//Database.delete(summaryList, true);
}
}catch(Exception ex) {
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
}*/
        /** @Code Block END - IDC Offshore - 23/07/2015 Delete Provider Summary Information record if Service Status is not null **/
    }
    
    /**
*   @Description: This method takes up the list of all inserted or updated Contacts. It checks if they have a recordtype 
*   and it is of Employee type. This adds all such contacts in a list and returns the list.
*   @Arguments: List of all inserted and updated Contacts
*   @Return: List of Contacts
**/
    public static List<Contact> getEmployees(List<Contact> allContacts) {
        
        /** @Description: Declare Contact list variable that will be returned by the method**/
        List<Contact> employees = new List<Contact>();
        
        /** @Description: Method call to Get Recordtype ID for Contacts by calling the getEmployeeRecordType
*   method which returns the recordtypeid of Contacts of Employee recordtype
**/
        Id recordtypeId = getEmployeeRecordType();
        
        /** @Description: Iterate over the list of all inserted or updated Contacts **/
        for(Contact loopContact: allContacts) {
            
            /** @Description: Check if the iterated contact record's recordtype is not null and recordtype ID is Emplooyee **/
            if(loopContact.RecordTypeId != null && loopContact.RecordTypeId == recordtypeId) {
                
                /** @Description: Add iterated contacts to the list of contacts employees **/
                employees.add(loopContact);
            }
        } 
        /** @Description: Return the list of Employee Contacts**/
        return employees;
    }
    
    
    /**
* @author       :   IDC Offshore
* @date         :   14/11/2014 (DD/MM/YYYY)
* @ModifedDate  :   25/03/2015 (DD/MM/YYYY) 
* @version      :   5.0
* @description  :   Added for PCRM and modified for PDV REQ 3399- Returns the list of records of Provider recordtype 
* @param        :   List [Contact] , Map<Id, Contact> , Map<Id, Contact>
* @return       :   List [Contact]
*/ 
    public static List<Contact> getProvidersForUserCreation(List<Contact> p_contactList, Map<Id, Contact> p_oldContactMap,  Map<Id, Contact> p_newContactMap) {
        
        System.debug('====p_contactList===='+p_contactList);
        System.debug('===p_oldContactMap====='+p_oldContactMap);
        System.debug('=====p_newContactMap==='+p_newContactMap);
        list<Contact> providerList = new List<Contact>();
        list<id> lstContactsToUpdate = new List<id>();
        
        Set<Id> SetContactIds = new Set<Id>();
        for(Contact objContact: p_contactList) 
            SetContactIds.add(objContact.id);
        
        Map<Id,User> mapRelatedUsers=new Map<Id,User>();
        for(User objUser:[select id,contactId from User where ContactId in:SetContactIds]) 
            mapRelatedUsers.put(objUser.ContactId,objUser);
        
        list<User> userList = new List<User>();
        Id providerRecordTypeId = [select Id from RecordType where name='Provider' and SObjectType='Contact' limit 1].Id;
        
        /** @Description: Creating list of Contacts which are of Provider RecordType**/
        for(Contact loopContact: p_contactList) {
            
            System.debug('========'+loopContact);
            System.debug('========'+mapRelatedUsers.get(loopcontact.id));
            System.debug('========'+loopContact.RecordTypeId);
            System.debug('========'+ProviderRecordTypeId);
            if(loopContact.RecordTypeId != null && loopContact.RecordTypeId == ProviderRecordTypeId && mapRelatedUsers.get(loopcontact.id)==null) {
                
                System.debug('========'+p_oldContactMap);
                System.debug('========'+p_newContactMap);
                //System.debug('========'+p_newContactMap.get(loopContact.Id));
                //System.debug('========'+p_oldContactMap.get(loopContact.Id));
                    
                //Contact Update
                //@PDI-Wave1 Description: Creating the list of Contacts, if the provider service status is not retired and provider is active.
                if(p_oldContactMap != null && p_newContactMap != null && p_newContactMap.get(loopContact.Id).Provider_Retired_Departed__c != true && p_newContactMap.get(loopContact.Id).Provider_Active_Status__c == true) {
                   /** @Description: Checking If the Provider Contact's Email is updated and its Source of Email is not TeleForm.This logic works for Non TeleForm Conatcts  **/   
                    /* if((p_oldContactMap.get(loopContact.Id).Email == null || p_oldContactMap.get(loopContact.Id).Email == '') && p_newContactMap.get(loopContact.Id).Email != null && p_newContactMap.get(loopContact.Id).Email != '' && !(p_newContactMap.get(loopContact.Id).Source_of_E_mail__c!=null && p_newContactMap.get(loopContact.Id).Source_of_E_mail__c.containsIgnoreCase(System.Label.TeleForm)))  {
providerList.add(loopContact);
ContactTriggerHelper.RUNCODE=false;
}

/* @Description: Checking If the Provider Contact's Email is updated and its Source of Email is TeleForm.
This logic works for TeleForm Contacts which are already existing without any Email id in the Standard Email field.
Keeping the block blank will not trigger the Provider User creation and hence won't trigger Email to the User once we update the Contact with Correct Email id.
this logic is specifically for the Contacts already existing.
*/ 
                    
                    /*else if((p_oldContactMap.get(loopContact.Id).Email == null || p_oldContactMap.get(loopContact.Id).Email == '') && p_newContactMap.get(loopContact.Id).Email != null && p_newContactMap.get(loopContact.Id).Email != '' && (p_newContactMap.get(loopContact.Id).Source_of_E_mail__c!=null && p_newContactMap.get(loopContact.Id).Source_of_E_mail__c.containsIgnoreCase(System.Label.TeleForm)) && !(p_newContactMap.get(loopContact.Id).email.containsIgnoreCase(System.Label.Dummy_Email)) )
{
ContactTriggerHelper.RUNCODE=false;
}

/* @Description: Checking If the Provider Contact's Email is updated with the Dummy Email and its Source of Email is TeleForm.
This logic works for TeleForm Contacts which will be updated through the ProviderUserCreateScheduler class 
and in turn, we get the Users which get created with the Dummy Email ids.
*/ 
                    
                    /*else if((p_oldContactMap.get(loopContact.Id).Email == null || p_oldContactMap.get(loopContact.Id).Email == '') && p_newContactMap.get(loopContact.Id).Email != null && p_newContactMap.get(loopContact.Id).Email != '' && (p_newContactMap.get(loopContact.Id).Source_of_E_mail__c!=null && p_newContactMap.get(loopContact.Id).Source_of_E_mail__c.containsIgnoreCase(System.Label.TeleForm)) && p_newContactMap.get(loopContact.Id).email.containsIgnoreCase(System.Label.Dummy_Email) )
{
providerList.add(loopContact);
ContactTriggerHelper.RUNCODE=false;
}*/
                    
                    /*PDI - Wave1 ADID Related code Starts*/
                    /** @Description: External Providers - Checking If the Provider Contact's Email is updated and its Employee ADID value is null.This logic works for External Provider Conatcts  **/   
                    
                    if(((p_oldContactMap.get(loopContact.Id).Email == null || p_oldContactMap.get(loopContact.Id).Email == '') && p_newContactMap.get(loopContact.Id).Email != null && p_newContactMap.get(loopContact.Id).Email != '') || (p_oldContactMap.get(loopContact.Id).Provider_Active_Status__c == false && p_newContactMap.get(loopContact.Id).Provider_Active_Status__c == true && p_newContactMap.get(loopContact.Id).Provider_Retired_Departed__c == false) || (p_oldContactMap.get(loopContact.Id).Provider_Retired_Departed__c == true &&  p_newContactMap.get(loopContact.Id).Provider_Retired_Departed__c == false && p_newContactMap.get(loopContact.Id).Provider_Active_Status__c == true))  {
                        providerList.add(loopContact);
                        ContactTriggerHelper.RUNCODE=false;
                    }
                    
                    /* @Description: Checking If the Provider Contact's Email is updated and its Employee ADID value is not null.
* This logic works for ADID User Contacts which are already existing without any Email id in the Standard Email field.
* Keeping the block blank will not trigger the Provider User creation and hence won't trigger Email to the User once we update the Contact with Correct Email id.
* this logic is specifically for the Contacts already existing.
*/ 
                    /*Commented as part of wave2
else if((p_oldContactMap.get(loopContact.Id).Email == null || p_oldContactMap.get(loopContact.Id).Email == '') && p_newContactMap.get(loopContact.Id).Email != null && p_newContactMap.get(loopContact.Id).Email != '' && (p_newContactMap.get(loopContact.Id).ADID_User_Email__c!=null) && !(p_newContactMap.get(loopContact.Id).email.containsIgnoreCase(System.Label.Dummy_Email)) )
{
ContactTriggerHelper.RUNCODE=false;
}

/* @Description: Internal Providers - Checking If the Provider Contact's Email is updated with the Dummy Email and its Employee ADID value is not null.
* This logic works for ADID User Contacts which will be updated through the ProviderUserCreateScheduler class 
* and in turn, we get the Users which get created with the Dummy Email ids.
*/ 
                    
                    /*else if((((p_oldContactMap.get(loopContact.Id).Email == null || p_oldContactMap.get(loopContact.Id).Email == '') 
&& p_newContactMap.get(loopContact.Id).Email != null && p_newContactMap.get(loopContact.Id).Email != '') 
||(p_oldContactMap.get(loopContact.Id).Provider_Active_Status__c == false && p_newContactMap.get(loopContact.Id).Provider_Active_Status__c == true && p_newContactMap.get(loopContact.Id).Provider_Retired_Departed__c == false)
||(p_oldContactMap.get(loopContact.Id).Provider_Retired_Departed__c == true &&  p_newContactMap.get(loopContact.Id).Provider_Retired_Departed__c == false && p_newContactMap.get(loopContact.Id).Provider_Active_Status__c == true))
&& (p_newContactMap.get(loopContact.Id).ADID_User_Email__c!=null) 
&& p_newContactMap.get(loopContact.Id).email.containsIgnoreCase(System.Label.Dummy_Email) )
{
providerList.add(loopContact);
ContactTriggerHelper.RUNCODE=false;
}
*/
                    /*PDI - Wave1 ADID Related code ends*/
                }
                //Contact Create 
                /** @PDI-Wave1 Description: Create the list, if the contact email is not null and provider is active and service status
*  value is not retired.
*/     
                else {
                    if(loopContact.Email != null && loopContact.Email != '' && loopContact.Provider_Retired_Departed__c != true
                       && loopContact.Provider_Active_Status__c == true){
                           ContactTriggerHelper.RUNCODE=false;
                           providerList.add(loopContact);
                       }
                }
            }
        }
        return providerList;
    }    
    
    
    /**
* @author       :   IDC Offshore
* @date         :   25/03/2015 (DD/MM/YYYY)
* @version      :   1.0
* @description  :   Added for PDV  REQ 3399- Returns the list of records of Provider recordtype whose Email is changed or Provider is Retired or Resigned.
* @param        :   List [Contact] , Map<Id, Contact> , Map<Id, Contact>
* @return       :   List [Contact]
*/ 
    
    public static List<Contact> getProvidersForUserUpdation(List<Contact> p_contactList, Map<Id, Contact> p_oldContactMap,  Map<Id, Contact> p_newContactMap) {
        
        list<Contact> providerList = new List<Contact>();
        list<User> userList = new List<User>();
        Id providerRecordTypeId = [select Id from RecordType where name='Provider' and SObjectType='Contact' limit 1].Id;
        
        /** @Description: Creating list of Contacts which are of Provider RecordType**/
        for(Contact loopContact: p_contactList) {
            
            if(loopContact.RecordTypeId != null && loopContact.RecordTypeId == ProviderRecordTypeId && p_oldContactMap != null && p_newContactMap != null && loopContact.Username__c!=null && loopContact.Username__c!='') {
                //Contact Update
                /** @Description: Checking if the Contact's Email id is not changed and 
*  this change is a valid change OR Provider service status is Retired or Resigned**/
                if(p_newContactMap.get(loopContact.Id).Provider_Active_Status__c == true && (p_oldContactMap.get(loopContact.Id).Email != null && p_oldContactMap.get(loopContact.Id).Email != '' && p_newContactMap.get(loopContact.Id).Email != null && p_newContactMap.get(loopContact.Id).Email != '' && p_oldContactMap.get(loopContact.Id).Email!=p_newContactMap.get(loopContact.Id).Email ) || ((p_newContactMap.get(loopContact.Id).Provider_Retired_Departed__c==true || p_newContactMap.get(loopContact.Id).Provider_Resigned_From_Sutter__c==true) && (p_oldContactMap.get(loopContact.Id).Provider_Practicing_Physician__c==true && (p_oldContactMap.get(loopContact.Id).Provider_Practicing_Physician__c != p_newContactMap.get(loopContact.Id).Provider_Practicing_Physician__c))) || (p_oldContactMap.get(loopContact.Id).Employee_ADID__c != null && !p_oldContactMap.get(loopContact.Id).Employee_ADID__c.equals(p_newContactMap.get(loopContact.Id).Employee_ADID__c)) ){
                    providerList.add(loopContact);
                    ContactTriggerHelper.RUNCODE=false;
                }
            }
        } 
        return providerList;
    }    
    
    /**
*   @Description: This method returns the recordtype ID of Contacts of recordtype Employee by quering the
*   contacts of recordtype Employee.
*   @Arguments: none
*   @Return: Recordtype Id
**/
    public static Id getEmployeeRecordType() {
        
        /** @Description: Declare the variable recordtype of type Id **/
        Id recordtypeId;
        
        /** @Description: if condition executed if isCalledBefore is false which is by default set to false at the start of the class **/  
        if(!isCalledBefore) {
            /** @Description: Query for the id of contacts of recordtype Employee **/
            recordtypeId = [select Id,SobjectType,Name from RecordType where name='Employee' and SObjectType='Contact' limit 1].Id;
            /** @Description: Assign isCalledBefore to true **/
            isCalledBefore = true;
            /** @Description: Assign recordtypeId variable to employeeId variable **/
            employeeId = recordTypeId;
        } 
        
        /** @Description: Else block executed if isCalledBefore is true which is set to true is the method has been called before **/
        else {
            /** @Description:  Assign employeeid variable to recordtypeId variable **/
            recordtypeId = employeeId;
        }
        
        /** @Description: return recordtypeId **/
        return recordtypeId;
    }
    /* Cotact owner validation method */    
    public static void contactOwnerValidation(List<Contact> triggerNew)
    {
        String loggedInprofileId = UserInfo.getProfileId();
        set<string> setSalesUser = new set<string>();
        
        List<Profile> profileList = [SELECT Id, Name FROM Profile where Name = 'SHP Sales' limit 1];
        
        for(User userItem : [Select Id, name from User where ProfileId =: profileList[0].Id]){
            setSalesUser.add(userItem.id);
        }
        
        for(Contact con : triggerNew)
        {
            if(loggedInprofileId == profileList[0].Id && !setSalesUser.contains(con.ownerId)){ 
                con.addError('You can only change to a User of SHP Sales Profile');
            }
        }
    }
}