/*****************************************************
Class Name: ProvidersByPhoneNumberController 
Created By: Nagarjuna Kaipu
Created Date: 29/08/2016
Description: This class is used to validate the providers by common phone numbers
*****************************************************/
public class ProvidersByPhoneNumberController {
    
    public string summaryId {get;set;}
    public string sumConId {get;set;}
    public String caseId {get;set;}
    public String CommonPhoneId {get; set;}
    public String phoneNumber {get; set;}
    public String formattedPhoneNumber {get; set;}
    public string providerName {get;set;}
    public String caseStatus {get;set;}
    public String strCaseContactPhoneNumber {get;set;}
    public String validationSource {get;set;}
    public String selectedRecord{get;set;}
    public string successMsg {get; set;}
    public string caseSuccessMsg {get; set;}
    public String strSpace = ' ';
    private string generalErrMsg;
    
    public boolean isAddressValidAllFields {get;set;}
    public boolean isEmailTrue {get; set;}
    public boolean isCurrentOwner {get; set;}
    public boolean isNewCase {get; set;}
    public boolean isValidate {get; set;}
    public boolean providerSearchFlag {get;set;}
    public boolean editAddrmode{get;set;}
    public boolean reordermode{get;set;}
    public boolean isCreatingCase {get;set;}
    public boolean showNewButtonFlag{get;set;}
    public boolean showReorderBtnFlag{get;set;}
    public boolean suggestedAddressFlag{get;set;}
    public boolean isAddressDoctorValidFields {get;set;}
    public boolean addressline2ErrorFlag {get;set;}
    public boolean isCaseValidated {get; set;}
    public Boolean byPassAddressVerificationFlag{get;set;} // Added on 21/12/2016 to Override the Address Verification
    
    public integer selectedPage;
    public date verifiedDate {get; set;}
    
    public Contact contactInfo {get;set;}
    public Contact_Validation_Summary__c sumObj {get; set;} 
    public List<Contact_Validation_Summary__c> summaryList {get; set;}
    public List<Contact_Validation_Audit_Trail__c> auditHistory {get; set;}
    public List<Contact_Validation_Audit_Trail__c> auditAddressHistory {get; set;}
    public Provider_Address__c primaryAddrObj{get;set;}
    public Provider_Address__c address{get;set;}
    public List<Provider_Address__c> providerAddressList {get;set;}
    public List<Provider_Address__c> SecondaryAddrList {get;set;}
    public List<Provider_Address__c> suggestedAddressList{get;set;}
    public List<Provider_Address__c> providerAddressVerfiyList{get;set;}
    public List<ProvidersByPhoneNumber__c> comPhone {get; set;}
    public Case caseObj {get;set;}
    public List<Case> inquirySummary {get; set;}
    public WrProviderDetails WrProviderDetailsObj {get;set;}
    public List<WrProviderDetails> wrAduitOldAddressLst {get;set;}
    public List<PDI_Address_Verification.addressAD> verifiedAddressList{get;set;}
    public List<PDI_Email_Address_Verification.wrapEmailVerification> emailStatusList{get;set;}
    
    public List<SelectOption> statePkList {get;set;}
    public List<SelectOption> subjectPkList {get;set;}
    public Set<String> correctAddrCodeSet{get;set;}
    public Set<String> verifiedAddrCodeSet{get;set;}
    public Set<String> processCodes{get;set;}
    public Map<Integer, String> statusMap{get;set;}
    public Map<String, String> resultStatusMap{get;set;}
    public Map<String,String> addressNotProcessedStatusMap{get;set;}
    public Map<String,String> addressWebserviceStatusMap{get;set;}
    public Map<String,String> emailStatusCodesMap{get;set;}
    public Map<String, Provider_Address__c> tempsecondaryAddrMap{get;set;}
    
    ApexPages.StandardController controller;
    ApexPages.StandardSetController setCon {get; set;}
    
    public static final String providerId_constant = '&providerId=';
    public static final String addressLine1Label = '<b>Address Line 1 : </b>';
    public static final String addressLine2Label = '<b>Address Line 2 : </b>';
    public static final String cityLabel =         '<b>City           : </b>';
    public static final String stateLabel =        '<b>State          : </b>';
    public static final String zipCodeLabel =      '<b>ZipCode        : </b>';
    public static final String securePhoneLabel =  '<b>SecurePhone    : </b>';
    public static final String phoneExtensionLabel='<b>PhoneExt       : </b>';
    public static final String faxLabel =          '<b>Fax            : </b>';
    public static final String addressTypeLabel =  '<b>Address Type   : </b>';
    public static final String addressStatusLabel ='<b>Address Status : </b>';
    
    /*Constructor to initialize the providers list
*/
    public ProvidersByPhoneNumberController(ApexPages.StandardController controller){
        isNewCase = false;
        isCurrentOwner = false;
        this.controller = controller;
        CommonPhoneId = controller.getId();
        comPhone = new List<ProvidersByPhoneNumber__c>();
        comPhone = [Select Name, Tech_Phone_Number__c, OwnerId From ProvidersByPhoneNumber__c Where Id =: CommonPhoneId Limit 1];
        phoneNumber = comPhone[0].Tech_Phone_Number__c;
        formattedPhoneNumber = comPhone[0].Name;
        PDICallCampaignEmail__c campaignEmail = PDICallCampaignEmail__c.getInstance(Label.CL409_PDIEmailInstance); 
        if(campaignEmail != null)
        {
            isEmailTrue = campaignEmail.Value__c;   
        }
        else
        {
            isEmailTrue = false;
        }
        PDIProviderSearch__c flag = PDIProviderSearch__c.getInstance('ProviderSearchFlag');
        providerSearchFlag = flag.Value__c;
        refreshProviderList();
        getStatePicklistVal();
        getSubjectPicklistVal();
        RetrieveCase(); 
        fillCaseAddressHistory();
    }
    
    /*
Method Name: RetrieveProviderDetails
input Param: summaryId
return type: void
Description: To retrieve the provider details based on the provider id
*/
    public PageReference RetrieveProviderDetails(){
        isAddressValidAllFields = false;
        if(String.isNotBlank(caseId) && String.isBlank(caseObj.PDV_Contact_Name__c)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL401_PDIFillContactName));
            isValidate = false;
            return null;
        }
        isValidate = true;
        selectedPage = getPageNumber();
        successMsg = strSpace;
        if(!string.isBlank(summaryId)) {
            //Querying to get contact id
            Contact_Validation_Summary__c providerSummary = [select Id,owner.Name,Contact_Id__c,Status__c, Assigned_Date__c, Closed_Date__c, Associated_Case_Id__r.Id,OwnerId,lastmodifiedbyId
                                                             FROM Contact_Validation_Summary__c 
                                                             WHERE Id =:summaryId and PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name Limit 1];
            //Updating summary with status, owner, associated case and assigned date
            Contact_Validation_Summary__c summarytoUpdate = new Contact_Validation_Summary__c(Id=summaryId);
            if(providerSummary.Status__c != Label.CL186_PDI_Accepted_Status){
                summarytoUpdate.Status__c = Label.CL186_PDI_Accepted_Status;
                summarytoUpdate.Tech_Validation_Status__c = 'Non Validated';
                summarytoUpdate.Tech_Success_Email__c = false;
            }
            if(providerSummary.Associated_Case_Id__r.Id != caseId){
                summarytoUpdate.Associated_Case_Id__c = caseId;
                summarytoUpdate.Assigned_Date__c = System.now();
                summarytoUpdate.Associated_Case_Closed__c = false;
                summarytoUpdate.Closed_Date__c = null;
            }
            if(providerSummary.ownerId == UserInfo.getUserId()){
                summarytoUpdate.ownerId = UserInfo.getUserId();
            }
            update summarytoUpdate;
            
            if(!String.IsBlank(providerSummary.Contact_Id__c)) {
                sumConId = providerSummary.Contact_Id__c;
                //Getting provider details
                getProviderInfo();
                //Getting address validation details
                getAddressValidation();
                //Getting customer inquiries list
                getCaseLst();
            }
        }
        return null;
    }
    
    /*
Method Name: createCase
input Param: N/A
return type: void
Description: To create new case or to retrieve the existing open case based on the phone number 
*/
    public void createCase() {
        if(isNewCase){
            caseSuccessMsg = strSpace;
            strCaseContactPhoneNumber = strSpace;
            caseObj = new Case();
            List<Case> caseList = new  List<Case>();
            //Querying the existing case based on the phone number
            caseList = [select OwnerId, casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,
                        Validated_or_not__c,Direct_Talk_to_Provider__c,status,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, 
                        Provider_Assigned_Date__c, subject,description,CreatedBy.Name,owner.Name from case 
                        where PDICommonPhoneNumber__c =: phoneNumber and Status !=: Label.CL384_PDICaseSatusClosed Order By CaseNumber Desc Limit 1];
            if(caseList.isEmpty()){
                caseObj.subject = Label.CL385_PDICaseInitialSubject;
                caseObj.recordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(Label.CL388_PDICaseRecordType).RecordTypeId;
                caseObj.origin = Label.CL387_PDICaseOutboundCall;
                caseObj.Common_Subject_Lines__c = Label.CL386_PDICaseSubjectValidated;
                caseObj.PDICommonPhoneNumber__c = phoneNumber;
                caseObj.Contact_Number__c = Decimal.valueOf(phoneNumber.replaceAll('[^0-9]',''));
                strCaseContactPhoneNumber = ProvidersByPhoneNumberHelper.FormatPhone(phoneNumber);
                caseObj.Provider_Assigned_Date__c = System.now();
                insert caseObj;
                caseId = caseObj.Id;
                //Querying case to get the case details based on the 
                caseObj = [select OwnerId, casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                           status,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, Provider_Assigned_Date__c,
                           subject,description,CreatedBy.Name,owner.Name from case where Id =: caseId];
                strCaseContactPhoneNumber = ProvidersByPhoneNumberHelper.FormatPhone(String.ValueOf(caseObj.Contact_Number__c));
                if(caseObj.Contact_Number__c != null)
                {
                    caseObj.Contact_Number__c = Decimal.valueOf(phoneNumber.replaceAll('[^0-9]',''));
                }
            }
            isNewCase = false;
            isCurrentOwner = true;
            caseStatus = caseObj.Status;
            fillCaseAddressHistory();
            refreshProviderList();
        }
        if(comPhone[0].OwnerId != UserInfo.getUserId())
        {
            ProvidersByPhoneNumber__c pOwnerChange = new ProvidersByPhoneNumber__c(Id = comPhone[0].Id, OwnerId = UserInfo.getUserId());
            update pOwnerChange;
            isCurrentOwner = true;
        }
        
    }
    
    /*
Method Name: retrieveCase
input Param: N/A
return type: void
Description: To retrieve the existing open case based on the phone number 
*/
    public void retrieveCase(){
        caseSuccessMsg = strSpace;
        strCaseContactPhoneNumber = strSpace;
        caseObj = new Case();
        List<Case> caseList = new  List<Case>();
        //Querying the existing case based on the phone number
        caseList = [select OwnerId, casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,
                    Validated_or_not__c,Direct_Talk_to_Provider__c,status,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, 
                    Provider_Assigned_Date__c, subject,description,CreatedBy.Name,owner.Name from case 
                    where PDICommonPhoneNumber__c =: phoneNumber and Status !=: Label.CL384_PDICaseSatusClosed Order By CaseNumber Desc Limit 1];
        if(!caseList.isEmpty()){
            caseId = caseList[0].Id;
            isNewCase = false;
            
            if(comPhone[0].OwnerId != UserInfo.getUserId())
            {
                isCurrentOwner = false;
            }
            else
            {
                isCurrentOwner = true;
            }
            //Querying case to get the case details based on the 
            caseObj = [select OwnerId, casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                       status,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, Provider_Assigned_Date__c,
                       subject,description,CreatedBy.Name,owner.Name from case where Id =: caseId];
            strCaseContactPhoneNumber = ProvidersByPhoneNumberHelper.FormatPhone(String.ValueOf(caseObj.Contact_Number__c));
            if(caseObj.Contact_Number__c != null)
            {
                caseObj.Contact_Number__c = Decimal.valueOf(phoneNumber.replaceAll('[^0-9]',''));
            }
        }
        else
        {
            isNewCase = true;
        }
    }
    /*
Method Name: statePkList
Input Param: N/A
Return type: void
Description: This is used to get state list. 
*/
    public void getStatePicklistVal() {
        statePkList = new List<SelectOption>(); 
        Schema.DescribeFieldResult fieldDesc = Contact_Validation_Summary__c.Secure_State__c.getDescribe();
        List<Schema.PicklistEntry> statePickValues = fieldDesc.getPicklistValues();
        statePkList.add(new SelectOption(Label.CL259_PDI_None, Label.CL260_PDI_None1));
        for(Schema.PicklistEntry obj : statePickValues) {
            SelectOption selectOption = new SelectOption(obj.getValue(),obj.getLabel());
            statePkList.add(selectOption);
        }
    }
    /*Method Name: getSubjectPicklistVal
Input Param: N/A
Return type: void
Description: This is used to get subject lines list. 
*/
    public void getSubjectPicklistVal() {
        subjectPkList = new List<SelectOption>(); 
        Schema.DescribeFieldResult fieldDesc = Case.Common_Subject_Lines__c.getDescribe();
        List<Schema.PicklistEntry> subjectPickValues = fieldDesc.getPicklistValues();
        subjectPkList.add(new SelectOption(Label.CL259_PDI_None, Label.CL260_PDI_None1));
        for(Schema.PicklistEntry obj : subjectPickValues) {
            if(obj.getValue() == Label.CL420_PDIValidatedProvider || obj.getValue() == Label.CL421_PDIVoicemail || obj.getValue() == Label.CL422_PDIProviderAgitated || obj.getValue() == Label.CL423_PDICaseSubjectOther)
            {
                SelectOption selectOption = new SelectOption(obj.getValue(),obj.getLabel());
                subjectPkList.add(selectOption);  
            }
        }
    } 
    
    /*
Method Name: getCaseLst
Input Param: N/A
Return type: List of cases
Description: This is used to get all cases per provider 
*/
    public List<Case> getCaseLst() {
        inquirySummary = new List<Case>();
        //Querying to get the list of cases associated by phone number
        inquirySummary = [select OwnerId, casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,
                          Validated_or_not__c,Direct_Talk_to_Provider__c,status,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, 
                          Provider_Assigned_Date__c, subject,description,CreatedBy.Name,owner.Name, CreatedDate from case 
                          where PDICommonPhoneNumber__c =: phoneNumber Order By CaseNumber Desc];
        return inquirySummary;
    } 
    
    /*
Method Name: getProviderInfo
Input Param: N/A
Return type: void
Description: This is used to get contact info 
*/
    public void getProviderInfo() {
        //Querying to get provider contact details
        contactInfo = [select id,No_of_Not_Reachable_Closed_Cases__c, FirstName, lastname, email, name, Gender__c, Preferred_Communication_Method__c,
                       Provider_Communication_Preferences_HIM__c, Provider_Retired_Departed__c, Provider_Resigned_From_Sutter__c, Provider_Practicing_Physician__c,  
                       Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c, Provider_Admin_Assistant_Phone__c, Provider_Delegate_Phone_Ext__c, 
                       Provider_UPIN__c, Provider_Title__c, Provider_Name__c, Provider_Name_Suffix__c, Provider_Admin_Assistant_Title__c, Provider_Admin_Assistant__c,
                       Provider_NPI__c, Provider_License_State__c, Provider_License_Number__c, Provider_ID__c, Contact_External_ID1__c, Provider_Admin_Assistant_Email__c,
                       Provider_Credential_Status__c,Provider_Active_Status__c, Provider_Active_Status_Date__c, Provider_Accepting_New_Patients__c,Provider_Specialty__c, 
                       Provider_Accepted_Patient_Age_Range_Min__c, Provider_Accepted_Patient_Age_Range_Max__c, Provider_Accepted_Patient_Age_Range__c, 
                       (Select Last_Verified_Date__c, Provider_FirstName__c, Provider_LastName__c, Provider_MiddleName__c,
                        Email__c, Mobile_Phone__c, Ok_to_Text__c, Names_Changes_Suggested__c, Admin_Assistant__c, Admin_Assistant_Title__c, 
                        Admin_Assistant_Email__c, Admin_Assistant_Phone__c, Delegate_Phone_Ext__c, Practicing_Physician__c, 
                        Resigned_From_Sutter__c, Retired_Departed__c, Is_Resigned_Provider_refer__c,
                        Deficiency_Provider__c, PDI_Campaign__c, Speciality__c, Department__c, Hospital_Affiliations__c,
                        Medical_Affiliations__c, Medical_Education__c, Website_Address__c, Online_Services__c, Spoken_Languages__c,
                        Internship__c, Professional_Ineterests__c, Residency__c, Board_Certifications__c, Community_Activities__c,
                        Publications__c, Personal_Interests__c, Additional_Information__c, Philosophy_of_Care__c,
                        Provider_Title__c, Provider_Access_Type__c, Provider_Type__c, Gender__c, Provider_ID__c,
                        Preferred_Communication_Method__c, Communication_Preferences_HIM__c, Tech_Validation_Status__c
                        From Summarys__r where PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name),
                       (Select Contact_Id__c,First_Name__c,Last_Name__c,Middle_Name__c, Secure_City__c, Secure_Fax__c,Secure_Phone_Ext__c,Secure_Phone__c, Secure_State__c, Secure_Street_Address__c,
                        Preferred_Communication_Method__c, Communication_Preferences_HIM__c, Retired_Departed__c, Resigned_From_Sutter__c,
                        Practicing_Physician__c,Admin_Assistant__c,Admin_Assistant_Email__c,Secure_Address_Line_2__c,Admin_Assistant_Phone__c, Delegate_Phone_Ext__c,
                        Admin_Assistant_Title__c,
                        Secure_Zip_Code__c, Address_Type__c, Address_Status__c, Provider_Information_Summary__c, Secure_Suite__c, Secure_Floor__c,LastModifiedDate, LastModifiedBy.Name,
                        Email__c, Mobile_Phone__c, Ok_to_Text__c, Address_Modified__c, Names_Changes_Suggested__c, New_Street_Address__c 
                        From Contact_Validation_Audit_Trails__r  order by LastModifiedDate desc),
                       (Select CaseNumber, Status, Subject,PDV_Contact_Name__c,Contact_Number__c,SOC_Document_Status__c,Origin, CreatedDate, CreatedBy.Name From Cases 
                        order by createddate asc)  
                       from Contact where Id =: sumConId];
        providerName = contactInfo.Name;
        //To display validation source in provider details section
        validationSource = contactInfo.Summarys__r[0].Tech_Validation_Status__c;
    }
    
    /*
Method Name: fillCaseAddressHistory
Input Param: N/A
Return type: void
Description: This method is used to fill the provider audit history based on the common phone number. 
*/
    public void fillCaseAddressHistory() {
        auditHistory = new List<Contact_Validation_Audit_Trail__c>();
        List<Case> caseAuditList = new List<Case>();
        //Querying provider audit history based on the common phone number
        caseAuditList = [Select CaseNumber,(Select Id, Address_Change__c, CreatedBy.Name, LastModifiedDate From Provider_Validation_Updates__r Order By Id Desc)
                         From Case Where Id = :caseId];
        if(!caseAuditList.isEmpty()){
            auditHistory = caseAuditList[0].Provider_Validation_Updates__r;
        }
    }
    
    /*
Method Name: getAddressValidation
Input Param: N/A
Return type: void
Description: This is used to get address validation details
*/
    public void getAddressValidation() {
        auditAddressHistory = new List<Contact_Validation_Audit_Trail__c>();
        //Querying Addresses history
        auditAddressHistory = [Select Contact_Id__c,First_Name__c,Last_Name__c,Middle_Name__c, Secure_City__c, Secure_Fax__c,Secure_Phone_Ext__c,Secure_Phone__c, Secure_State__c, Secure_Street_Address__c,
                               Preferred_Communication_Method__c, Communication_Preferences_HIM__c, Retired_Departed__c, Resigned_From_Sutter__c,
                               Practicing_Physician__c,Admin_Assistant__c,Admin_Assistant_Email__c,Secure_Address_Line_2__c,Admin_Assistant_Phone__c, Delegate_Phone_Ext__c,
                               Admin_Assistant_Title__c, Secure_Zip_Code__c, Address_Type__c, Address_Status__c, Provider_Information_Summary__c, Secure_Suite__c, Secure_Floor__c,
                               LastModifiedDate, LastModifiedBy.Name, Email__c, Mobile_Phone__c, Ok_to_Text__c, Address_Modified__c, Names_Changes_Suggested__c, New_Street_Address__c 
                               From Contact_Validation_Audit_Trail__c Where Provider_Information_Summary__r.Id =: summaryId and PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name  order by Id desc];
        
        WrProviderDetailsObj = new WrProviderDetails(); 
        
        sumObj = new Contact_Validation_Summary__c();
        //Querying provider summary information
        sumObj = [Select Last_Verified_Date__c,Provider_FirstName__c,Provider_LastName__c,Provider_MiddleName__c, Secure_City__c, Secure_Fax__c,Secure_Phone_Ext__c, Secure_Phone__c, Tech_Phone_Number__c, Address_Type__c, Secure_State__c, Secure_floor__c,Secure_Suite__c,
                  Email__c,Mobile_Phone__c,Ok_to_Text__c,Address_Modified__c,New_Street_Address__c,Names_Changes_Suggested__c, Admin_Assistant_Phone__c, Delegate_Phone_Ext__c, 
                  Secure_Street_Address__c, Secure_Zip_Code__c,Serial_Number__c,Retired_Departed__c,Address_Line_2__c,
                  Resigned_From_Sutter__c,Practicing_Physician__c,Communication_Preferences_HIM__c,Preferred_Communication_Method__c,Is_Resigned_Provider_refer__c,
                  Admin_Assistant__c,Admin_Assistant_Email__c,Deficiency_Provider__c, PDI_Campaign__c,
                  Admin_Assistant_Title__c, Decline_Fax__c, Decline_Phone__c, Speciality__c, Department__c, Hospital_Affiliations__c,
                  Medical_Affiliations__c, Medical_Education__c, Website_Address__c, Online_Services__c, Spoken_Languages__c,
                  Internship__c, Professional_Ineterests__c, Residency__c, Board_Certifications__c, Community_Activities__c,
                  Publications__c, Personal_Interests__c, Additional_Information__c, Philosophy_of_Care__c,
                  Provider_Title__c, Provider_Access_Type__c, Provider_Type__c, Gender__c, Tech_Validation_Status__c
                  From Contact_Validation_Summary__c where Id =: summaryId AND IsAddressDeactivated__c != true and PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name];
        
        WrProviderDetailsObj.strPDICampaign = sumObj.PDI_Campaign__c;
        WrProviderDetailsObj.strStreetAddress = sumObj.New_Street_Address__c;
        WrProviderDetailsObj.strAddressLine2 = sumObj.Address_Line_2__c;
        WrProviderDetailsObj.strCity = sumObj.Secure_City__c;
        WrProviderDetailsObj.strstate = sumObj.Secure_State__c;
        WrProviderDetailsObj.strZipCode = sumObj.Secure_Zip_Code__c;
        WrProviderDetailsObj.lastValidatedDate = sumObj.Last_Verified_Date__c != null ? sumObj.Last_Verified_Date__c.format() : ''; //string.valueOf(sumObj.Last_Verified_Date__c);
        WrProviderDetailsObj.straddressType = sumObj.Address_Type__c;
        WrProviderDetailsObj.strDeclineFax = sumObj.Decline_Fax__c;
        WrProviderDetailsObj.strDeclinePhone = sumObj.Decline_Phone__c;
        if(String.isNotBlank(sumObj.Secure_Phone__c))
        {
            WrProviderDetailsObj.strPhone = ProvidersByPhoneNumberHelper.FormatPhone(sumObj.Secure_Phone__c);
        }
        if(String.isNotBlank(sumObj.Secure_FAX__c))
        {
            WrProviderDetailsObj.strFax = ProvidersByPhoneNumberHelper.FormatPhone(sumObj.Secure_FAX__c);
        }
        if(String.isNotBlank(sumObj.Mobile_Phone__c))
        {
            WrProviderDetailsObj.strMobilePhone = ProvidersByPhoneNumberHelper.FormatPhone(sumObj.Mobile_Phone__c);
        }
        WrProviderDetailsObj.strPhoneExt = sumObj.Secure_Phone_Ext__c;
        WrProviderDetailsObj.recordId = sumObj.id;
        WrProviderDetailsObj.strEmail = sumObj.Email__c;
        
        WrProviderDetailsObj.strOkToText = sumObj.Ok_to_Text__c;
        WrProviderDetailsObj.strFirstName = sumObj.Provider_FirstName__c;
        WrProviderDetailsObj.strMiddleName = sumObj.Provider_MiddleName__c;
        WrProviderDetailsObj.strLastName = sumObj.Provider_LastName__c;
        
        WrProviderDetailsObj.strPracticingPhysician = sumObj.Practicing_Physician__c;
        WrProviderDetailsObj.strResignedFromSutter = sumObj.Resigned_From_Sutter__c;
        WrProviderDetailsObj.strResignedProvider_refer = sumObj.Is_Resigned_Provider_refer__c;
        WrProviderDetailsObj.strRetired = sumObj.Retired_Departed__c;
        WrProviderDetailsObj.strAdminAssistant = sumObj.Admin_Assistant__c;
        WrProviderDetailsObj.strAdminAssistantEmail = sumObj.Admin_Assistant_Email__c;
        if(String.isNotBlank(sumObj.Admin_Assistant_Phone__c)){
            WrProviderDetailsObj.strAdminAssistantPhone = ProvidersByPhoneNumberHelper.FormatPhone(sumObj.Admin_Assistant_Phone__c);
        }
        WrProviderDetailsObj.strAdminAssistantPhoneExt = sumObj.Delegate_Phone_Ext__c; 
        WrProviderDetailsObj.strAdminAssistantTitle = sumObj.Admin_Assistant_Title__c;
        WrProviderDetailsObj.strNameChangesSugg = sumObj.Names_Changes_Suggested__c;
        WrProviderDetailsObj.strProviderAccessType = sumObj.Provider_Access_Type__c;
        WrProviderDetailsObj.strProviderType = sumObj.Provider_Type__c;
        WrProviderDetailsObj.strSpeciality = sumObj.Speciality__c;
        WrProviderDetailsObj.strDeficiencyProvider = sumObj.Deficiency_Provider__c;
        
        verifiedDate = null;
        if(sumObj.Last_Verified_Date__c != null) {
            verifiedDate = Date.newInstance(sumObj.Last_Verified_Date__c.year(),sumObj.Last_Verified_Date__c.Month(),sumObj.Last_Verified_Date__c.day());
        }
        if(verifiedDate != null && verifiedDate.daysBetween(date.today()) <= 30) {
            WrProviderDetailsObj.isValidated = Label.CL261_PDI_Yes;    
        } else {
            WrProviderDetailsObj.isValidated = Label.CL262_PDI_No;
        }
        
        if(sumObj.address_modified__c != null && sumObj.address_modified__c == Label.CL261_PDI_Yes) {
            WrProviderDetailsObj.strAddressModified = Label.CL261_PDI_Yes;
        } else {
            WrProviderDetailsObj.strAddressModified = Label.CL262_PDI_No;
        }
        WrProviderDetailsObj.strSpeciality = sumObj.Speciality__c;
        WrProviderDetailsObj.strDepartment = sumObj.Department__c;
        WrProviderDetailsObj.strGender = sumObj.Gender__c;
        WrProviderDetailsObj.strMedicalEducation = sumObj.Medical_Education__c;
        WrProviderDetailsObj.strWebsiteAddress = sumObj.Website_Address__c;
        WrProviderDetailsObj.strHospitalAff = sumObj.Hospital_Affiliations__c;
        WrProviderDetailsObj.strMedicalAff = sumObj.Medical_Affiliations__c;
        WrProviderDetailsObj.strInternship = sumObj.Internship__c;
        WrProviderDetailsObj.strResidency = sumObj.Residency__c;
        WrProviderDetailsObj.strSpokenLanguages = sumObj.Spoken_Languages__c;
        WrProviderDetailsObj.strCommActivities = sumObj.Community_Activities__c;
        WrProviderDetailsObj.strPersonalInterests = sumObj.Personal_Interests__c;
        WrProviderDetailsObj.strProfessionalInterests = sumObj.Professional_Ineterests__c;
        WrProviderDetailsObj.strOnlineServices = sumObj.Online_Services__c;
        WrProviderDetailsObj.strBoardCertifications = sumObj.Board_Certifications__c;
        WrProviderDetailsObj.strPublications = sumObj.Publications__c;
        WrProviderDetailsObj.strAdditionalInfo = sumObj.Additional_Information__c;
        WrProviderDetailsObj.strPhilosophyCare = sumObj.Philosophy_of_Care__c;
        retriveAddressDetails();
        //Provider Audit Starts
        wrAduitOldAddressLst = new List<WrProviderDetails>(); 
        
        for(Contact_Validation_Audit_Trail__c auditObj : auditAddressHistory) {
            WrProviderDetails wrObj1 =  new WrProviderDetails();
            wrObj1.strStreetAddress = auditObj.Secure_Street_Address__c;
            wrObj1.strCity = auditObj.Secure_City__c;
            wrObj1.strstate = auditObj.Secure_State__c;
            wrObj1.strZipCode = auditObj.Secure_Zip_Code__c;
            wrObj1.strPhone = auditObj.Secure_Phone__c;
            wrObj1.strFax = auditObj.Secure_FAX__c;
            wrObj1.strPhoneExt = auditObj.Secure_Phone_Ext__c;
            wrObj1.strSuite = auditObj.Secure_suite__c;
            wrObj1.strFloor = auditObj.Secure_floor__c;
            wrObj1.recordId = auditObj.Provider_Information_Summary__c;
            wrObj1.lastmodifiedDate = auditObj.LastModifiedDate.format();
            wrObj1.lastmodifiedBy = auditObj.LastModifiedBy.Name;
            wrObj1.straddressType = auditObj.Address_Type__c;
            wrObj1.strAddressStatus = auditObj.Address_Status__c;
            wrObj1.strEmail = auditObj.Email__c;
            wrObj1.strMobilePhone = auditObj.Mobile_Phone__c;
            wrObj1.strOkToText = auditObj.Ok_to_Text__c;
            wrObj1.strNameChangesSugg = auditObj.Names_Changes_Suggested__c;
            wrObj1.strFirstName = auditObj.First_Name__c;
            wrObj1.strMiddleName = auditObj.Middle_Name__c;
            wrObj1.strLastName = auditObj.Last_Name__c;
            wrObj1.strRetired = auditObj.Retired_Departed__c;
            wrObj1.strResignedFromSutter = auditObj.Resigned_From_Sutter__c;
            wrObj1.strPracticingPhysician = auditObj.Practicing_Physician__c;
            wrObj1.strCommunicationHIM = auditObj.Communication_Preferences_HIM__c;
            wrObj1.strAdminAssistant = auditObj.Admin_Assistant__c;
            wrObj1.strAdminAssistantEmail = auditObj.Admin_Assistant_Email__c;
            wrObj1.strAdminAssistantPhone = auditObj.Admin_Assistant_Phone__c;
            wrObj1.strAdminAssistantPhoneExt = auditObj.Delegate_Phone_Ext__c; 
            wrObj1.strAdminAssistantTitle = auditObj.Admin_Assistant_Title__c;
            if(auditObj.address_modified__c != null) {
                if(auditObj.address_modified__c == Label.CL261_PDI_Yes) {
                    wrObj1.strAddressModified = Label.CL261_PDI_Yes;
                } else if(auditObj.address_modified__c == Label.CL262_PDI_No) {
                    wrObj1.strAddressModified = Label.CL262_PDI_No;
                }
            } else {
                wrObj1.strAddressModified = Label.CL262_PDI_No;
            }
            wrAduitOldAddressLst.add(wrObj1);
        }
        //Provider Audit Ends
    }
    
    
    
    /*
Method Name: saveUpdatedAddress
Input Param: N/A
Return type: PageReference
Description: This method is used to save/update address
*/
    public PageReference saveUpdatedAddress() {
        List<Provider_Address__c> providerOldAddrList = new List<Provider_Address__c>();
        List<Provider_Address__c> providerNewAddrList = new List<Provider_Address__c>();
        List<Contact_Validation_Audit_Trail__c> contactauditList = new List<Contact_Validation_Audit_Trail__c>();
        Contact_Validation_Audit_Trail__c auditObjOld;
        Contact_Validation_Audit_Trail__c auditObjNew;
        List<Contact_Validation_Audit_Trail__c> auditObjOldList = new List<Contact_Validation_Audit_Trail__c>();
        List<Contact_Validation_Audit_Trail__c> auditObjNewList = new List<Contact_Validation_Audit_Trail__c>();
        List<Contact_Validation_Audit_Trail__c> conNAAuditList = new List<Contact_Validation_Audit_Trail__c>();
        Map<String, String> auditAddrStatusMap = new Map<String, String>();
        Map<String, String> auditAddrMDMMap = new Map<String, String>();
        Map<String, Provider_Address__c> oldAddressMap = new Map<String, Provider_Address__c>();
        Set<String> serialNumberSet = new Set<String>();
        emailStatusCodesMap = new Map<String,String>();
        Savepoint sp;
        try {
            
            // Email Verification Service Details 
            for (PDIEmailStatusCodes__c emailStatus : PDIEmailStatusCodes__c.getAll().values()){
                emailStatusCodesMap.put(emailStatus.Name, emailStatus.Value__c);
            }
            isAddressValidAllFields = true;
            processCodes.add('I3');
            //Req:3969 //Req:3969 case contact name mandatory to trigger email
            if(caseObj.Status != Label.CL419_PDICannotReach && String.isBlank(caseObj.PDV_Contact_Name__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL401_PDIFillContactName));
                isCaseValidated = false;
                return null;
            }
            else
            {
                isCaseValidated = true;
            }
            if(isEmailTrue == true && string.isblank(WrProviderDetailsObj.strEmail)){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL265_PDI_BlankEmail));
                isAddressValidAllFields = false;  
            }
            if(!string.isblank(WrProviderDetailsObj.strEmail) && !patterMatcherEmail(WrProviderDetailsObj.strEmail)) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL264_PDI_InvalidEmail));
                isAddressValidAllFields = false;
            }
            
            if(WrProviderDetailsObj.strOkToText == true && string.isBlank(WrProviderDetailsObj.strMobilePhone)){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL266_PDI_BlankMobile));
                isAddressValidAllFields = false;
            }
            if(!string.isBlank(WrProviderDetailsObj.strMobilePhone) && (WrProviderDetailsObj.strMobilePhone.length() < 14 || WrProviderDetailsObj.strMobilePhone.length() > 14 )) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL267_PDI_InvalidMobile));
                isAddressValidAllFields = false;
            }
            //PDI-Wave1: If agent doesn't select any one provider service status, then we are displaying error message.
            //If agent selects retired/resigned and is resigned provide refer, then not validating clinical contact information,
            // Communication preferences and admin assistant fields.
            if(WrProviderDetailsObj.strPracticingPhysician == false && WrProviderDetailsObj.strRetired == false 
               && WrProviderDetailsObj.strResignedFromSutter == false)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL268_PDI_ProviderStatusEmpty));
                isAddressValidAllFields = false;
                
            }else if(WrProviderDetailsObj.strPracticingPhysician == true ||(WrProviderDetailsObj.strResignedFromSutter == true 
                                                                            && WrProviderDetailsObj.strResignedProvider_refer == true))
            {
                if(!string.isBlank(WrProviderDetailsObj.strAdminAssistantPhone) && (WrProviderDetailsObj.strAdminAssistantPhone.length() < 14 || WrProviderDetailsObj.strAdminAssistantPhone.length() > 14 )) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL304_InvalidDelegatePhone));
                    isAddressValidAllFields = false;
                }
                if(primaryAddrObj == null || primaryAddrObj.Address_Line1__c == NULL || String.isBlank(primaryAddrObj.Address_Line1__c)){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL541_PDI_PrimaryAddressReq));
                    isAddressValidAllFields = false; 
                }
                if(primaryAddrObj != null && string.isBlank(primaryAddrObj.Secure_Phone__c) && primaryAddrObj.Decline_Phone__c == false) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL272_PDI_BlankPhone));
                    isAddressValidAllFields = false;
                }
                if(primaryAddrObj != null && string.isBlank(primaryAddrObj.Secure_Fax__c) && primaryAddrObj.Decline_Fax__c == false) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL274_PDI_BlankFax));
                    isAddressValidAllFields = false;
                }
                // Added Tech_Bypass_Address_Verification__c condition check in below condition 
                    // on 21/12/2016 to Override the Address Verification validation check
                    if(primaryAddrObj.Tech_Bypass_Address_Verification__c == false && primaryAddrObj != null && (primaryAddrObj.Provider_Address_AD_Status__c == null || processCodes.contains(primaryAddrObj.Provider_Address_AD_Status__c))){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL542_PDI_PrimaryAddressInvalid));
                    isAddressValidAllFields = false; 
                }
                if(!SecondaryAddrList.isEmpty()){
                    for(Provider_Address__c addr : SecondaryAddrList){
                        // Added Tech_Bypass_Address_Verification__c condition check in below condition 
                            // on 21/12/2016 to Override the Secondary Address Verification validation check
                            if(addr.Tech_Bypass_Address_Verification__c == false && addr.Serial_Number__c != null || !String.isBlank(addr.Serial_Number__c)){
                            if(addr.Provider_Address_AD_Status__c == null || processCodes.contains(addr.Provider_Address_AD_Status__c)){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL562_PDISecAddSerNumber+ addr.Serial_Number__c + Label.CL563_PDIPleaseCorrect));
                                isAddressValidAllFields = false; 
                            }  
                        }
                        if(!String.isBlank(addr.Serial_Number__c)){
                            String serialNum = addr.Serial_Number__c;
                            if(serialNum.isNumeric()){
                                if(addr.Serial_Number__c != '0'){
                                    if(Integer.valueOf(addr.Serial_Number__c) <= SecondaryAddrList.size()){
                                        if(!serialNumberSet.contains(addr.Serial_Number__c)){
                                            serialNumberSet.add(addr.Serial_Number__c);
                                        }else{
                                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL543_PDI_SecondaryAddrMsg));
                                            isAddressValidAllFields = false;
                                        }
                                    }else{
                                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL554_PDI_InvalidSerialNumber));
                                        isAddressValidAllFields = false;
                                    }
                                }else{
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL544_PDI_SecondaryAddrMsg2));
                                    isAddressValidAllFields = false;
                                }
                            }else{
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL545_PDI_SecondaryAddressNumeric));
                                isAddressValidAllFields = false;
                            }
                        }
                    }
                }
            }
            //PDI Wave2: Added By Pass Email Verfication logic
            PDIByPassEmailVerification__c ByPassEmailList = PDIByPassEmailVerification__c.getInstance('ByPassEmailVerification');
            emailStatusList = new List<PDI_Email_Address_Verification.wrapEmailVerification>();
            if(ByPassEmailList.ByPassInCallCampaign__c != true){
                if(WrProviderDetailsObj.strEmail != null && String.isNotBlank(WrProviderDetailsObj.strEmail) && !Label.CL601_PDI_noReplyEmail.equalsIgnoreCase(WrProviderDetailsObj.strEmail)){
                    emailStatusList = PDI_Email_Address_Verification.emailAddressWebService(WrProviderDetailsObj.strEmail, null);
                    if(!emailStatusList.isEmpty()){
                        assignEmailVerificationDetails(emailStatusList);
                        if(WrProviderDetailsObj.strEmailVerificationError != null){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, WrProviderDetailsObj.strEmailVerificationError));
                            isAddressValidAllFields = false;
                        }else{
                            if(emailStatusCodesMap.containsKey(WrProviderDetailsObj.strEmailStatusNumber)){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL546_PDI_EmailErrorMsg + '('+WrProviderDetailsObj.strEmailStatusDescription+')'));
                                isAddressValidAllFields = false;
                            }
                        } 
                    } 
                }
                if(WrProviderDetailsObj.strAdminAssistantEmail != null && String.isNotBlank(WrProviderDetailsObj.strAdminAssistantEmail)){
                    emailStatusList = PDI_Email_Address_Verification.emailAddressWebService(WrProviderDetailsObj.strAdminAssistantEmail, null);
                    if(!emailStatusList.isEmpty()){
                        assignEmailVerificationDetails(emailStatusList);
                        if(WrProviderDetailsObj.strEmailVerificationError != null){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, WrProviderDetailsObj.strEmailVerificationError));
                            isAddressValidAllFields = false;
                        }else{
                            if(emailStatusCodesMap.containsKey(WrProviderDetailsObj.strEmailStatusNumber)){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL546_PDI_AsstEmailErrorMsg + '('+WrProviderDetailsObj.strEmailStatusDescription+')'));
                                isAddressValidAllFields = false;
                            }
                        } 
                    } 
                }
            }
 			//PDI Wave2: Added By Pass Email Verfication logic Ended
            if(!isAddressValidAllFields) {
                return null;
            }
            if(!string.isBlank(WrProviderDetailsObj.recordId)) {
                
                //REQ 3665 added field Provider_Service_Status__c to queury START
                // PDI-Wave1: Modified query to add provider information summary fields.
                // //Req:3903 included Delegate phone extension in the query
                Contact_Validation_Summary__c pISObjOld = [select id, Contact_Id__c, Practicing_Physician__c, Resigned_From_Sutter__c, Retired_Departed__c,
                                                           Email__c, Speciality__c, Department__c, Mobile_Phone__c, Ok_to_Text__c, Gender__c,Decline_Phone__c,Decline_Fax__c,
                                                           Preferred_Communication_Method__c, Communication_Preferences_HIM__c, Medical_Education__c, Website_Address__c, 
                                                           Hospital_Affiliations__c, Medical_Affiliations__c, Internship__c, Residency__c, Spoken_Languages__c, Community_Activities__c,
                                                           Personal_Interests__c, Professional_Ineterests__c, Online_Services__c, Board_Certifications__c, Publications__c, 
                                                           Additional_Information__c, Philosophy_of_Care__c, Admin_Assistant_Title__c, Admin_Assistant__c, Admin_Assistant_Email__c,
                                                           Admin_Assistant_Phone__c, Delegate_Phone_Ext__c, PDI_Campaign__c, Provider_Access_Type__c, Provider_Type__c,
                                                           Provider_FirstName__c, Provider_MiddleName__c, Provider_LastName__c, Provider_Name_Suffix__c, Serial_Number__c, Names_Changes_Suggested__c,
                                                           Deficiency_Provider__c, Provider_ID__c, Provider_NPI_F__c from Contact_Validation_Summary__c where 
                                                           PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name and Id= :WrProviderDetailsObj.recordId limit 1];
                
                providerOldAddrList = [SELECT id, Name, Serial_Number__c, Address_Line1__c, Address_Line_2__c, Address_Type__c, City__c, County__c, State__c, Suite__c, Floor__c,
                                       Secondary_Address_Only__c, Not_to_Send_to_EPIC__c, Patient_Facing__c, Only_for_Lab_Results__c, Zip_Code__c, Secure_Phone__c,
                                       Secure_Phone_Ext__c, Secure_Fax__c, Direct_Address__c, Address_Status__c, Address_Unique_Identifier__c
                                       FROM Provider_Address__c WHERE Contact_Id__c = :sumConId AND EPIC_Address_Status__c != :Label.CL471_PDI_EPICAddressInactive 
                                       AND PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name AND Address_Status__c != :Label.CL472_PDI_AddressDelete ORDER BY Serial_Number__c ASC];
                if(!providerOldAddrList.isEmpty()){
                    for(Provider_Address__c oldAddress : providerOldAddrList){
                        oldAddressMap.put(oldAddress.Serial_Number__c, oldAddress);
                    }
                }
                
                Integer totalauditrecords = [select count() from  Contact_Validation_Audit_Trail__c where Contact_Id__c= :pISObjOld.Contact_Id__c];
                contactauditList = [select id, Address_Unique_Identifier__c, Provider_Address_Id__c, Serial_Number__c, Address_Status__c, Sent_to_MDM__c from Contact_Validation_Audit_Trail__c where Contact_Id__c= :pISObjOld.Contact_Id__c];
                if(!contactauditList.isEmpty()){
                    for(Contact_Validation_Audit_Trail__c aduit : contactauditList){
                        auditAddrStatusMap.put(aduit.Provider_Address_Id__c, aduit.Address_Status__c);
                        auditAddrMDMMap.put(aduit.Provider_Address_Id__c, aduit.Sent_to_MDM__c);
                    }
                }
                /**** Prepare Provider Address list to save in Provider_Address table  starts ****/
                providerAddressList = new List<Provider_Address__c>();
                if(primaryAddrObj != null){
                    if(primaryAddrObj.Id != null && primaryAddrObj.EPIC_Address_Status__c != null && Label.CL474_PDI_NewAddress.equalsIgnoreCase(primaryAddrObj.Address_Status__c)){
                        primaryAddrObj.Address_Status__c = Label.CL473_PDI_ModifiedAddress;
                    }
                    primaryAddrObj.Tech_Find_suggestAddress__c = true;
                    providerAddressList.add(primaryAddrObj);
                }
                if(!SecondaryAddrList.isEmpty()){
                    for(Provider_Address__c addr : SecondaryAddrList){
                        if(addr.Id != null && primaryAddrObj.EPIC_Address_Status__c != null && Label.CL474_PDI_NewAddress.equalsIgnoreCase(addr.Address_Status__c)){
                            addr.Address_Status__c = Label.CL473_PDI_ModifiedAddress;
                        }
                        addr.Tech_Find_suggestAddress__c = true;
                        providerAddressList.add(addr);
                    }
                }
                providerAddressVerfiyList = new List<Provider_Address__c>();
                if(!providerAddressList.isEmpty()){
                    for(Provider_Address__c addressVerify : providerAddressList){
                        providerAddressVerfiyList.add(addressVerify);
                    }
                    if(!providerAddressVerfiyList.isEmpty()){
                        providerAddressList = PDI_Address_Verification.bulkAddressVerificationWebservice(providerAddressVerfiyList);
                    }
                }
                sp = Database.setSavepoint();
                if(!providerAddressList.isEmpty()){
                    upsert providerAddressList;
                }
                List<String> addressIdList = new List<String>();
                for(Provider_Address__c newAddr : providerAddressList){
                    addressIdList.add(newAddr.Id);
                }
                /**** Save Address information in Provider_Address table  Ends ****/
                providerNewAddrList = [SELECT id, Name, Serial_Number__c, Address_Line1__c, Address_Line_2__c, Address_Type__c, City__c, County__c, State__c, Suite__c, Floor__c,
                                       Secondary_Address_Only__c, Not_to_Send_to_EPIC__c, Patient_Facing__c, Only_for_Lab_Results__c,
                                       Zip_Code__c, Secure_Phone__c, Secure_Phone_Ext__c, Secure_Fax__c, Direct_Address__c, 
                                       Address_Status__c, Address_Unique_Identifier__c
                                       FROM Provider_Address__c WHERE Id IN :addressIdList ORDER BY Serial_Number__c ASC];
                
                if(totalauditrecords == 0 ){
                    /**** Capturing old values on audit object for history tracking starts ****/
                    if(!providerOldAddrList.isEmpty()){
                        for(Provider_Address__c provOldAddress : providerOldAddrList){
                            auditObjOld = new Contact_Validation_Audit_Trail__c();
                            
                            auditObjOld.PDI_Campaign__c = pISObjOld.PDI_Campaign__c;
                            auditObjOld.Provider_Information_Summary__c = pISObjOld.id;
                            auditObjOld.Contact_Id__c = sumConId;
                            auditObjOld.First_Name__c = pISObjOld.Provider_FirstName__c;
                            auditObjOld.Middle_Name__c = pISObjOld.Provider_MiddleName__c;
                            auditObjOld.Last_Name__c = pISObjOld.Provider_LastName__c;
                            auditObjOld.Provider_Name_Suffix__c = pISObjOld.Provider_Name_Suffix__c;
                            auditObjOld.Provider_ID__c = WrProviderDetailsObj.strProviderId;
                            auditObjOld.Provider_Title__c = WrProviderDetailsObj.strProviderTitle;
                            auditObjOld.Provider_NPI__c = pISObjOld.Provider_NPI_F__c;
                            auditObjOld.Practicing_Physician__c =  pISObjOld.Practicing_Physician__c;
                            auditObjOld.Resigned_From_Sutter__c =  pISObjOld.Resigned_From_Sutter__c;
                            auditObjOld.Retired_Departed__c =  pISObjOld.Retired_Departed__c;
                            auditObjOld.Provider_Access_Type__c =  pISObjOld.Provider_Access_Type__c;
                            auditObjOld.Provider_Type__c = pISObjOld.Provider_Type__c;
                            auditObjOld.Deficiency_Provider__c = pISObjOld.Deficiency_Provider__c;
                            auditObjOld.Email__c =  pISObjOld.Email__c;
                            auditObjOld.Speciality__c =  pISObjOld.Speciality__c;
                            auditObjOld.Department__c =  pISObjOld.Department__c;
                            auditObjOld.Mobile_Phone__c = pISObjOld.Mobile_Phone__c;
                            auditObjOld.Ok_to_Text__c = pISObjOld.Ok_to_Text__c;
                            auditObjOld.Preferred_Communication_Method__c = pISObjOld.Preferred_Communication_Method__c;
                            auditObjOld.Communication_Preferences_HIM__c = pISObjOld.Communication_Preferences_HIM__c;
                            auditObjOld.Medical_Education__c =  pISObjOld.Medical_Education__c;
                            auditObjOld.Website_Address__c =  pISObjOld.Website_Address__c;
                            auditObjOld.Hospital_Affiliations__c =  pISObjOld.Hospital_Affiliations__c;
                            auditObjOld.Medical_Affiliations__c =  pISObjOld.Medical_Affiliations__c;
                            auditObjOld.Internship__c =  pISObjOld.Internship__c;
                            auditObjOld.Residency__c =  pISObjOld.Residency__c;
                            auditObjOld.Spoken_Languages__c =  pISObjOld.Spoken_Languages__c;
                            auditObjOld.Community_Activities__c =  pISObjOld.Community_Activities__c;
                            auditObjOld.Personal_Interests__c =  pISObjOld.Personal_Interests__c;
                            auditObjOld.Professional_Ineterests__c =  pISObjOld.Professional_Ineterests__c;
                            auditObjOld.Online_Services__c =  pISObjOld.Online_Services__c;
                            auditObjOld.Board_Certifications__c =  pISObjOld.Board_Certifications__c;
                            auditObjOld.Publications__c =  pISObjOld.Publications__c;
                            auditObjOld.Additional_Information__c =  pISObjOld.Additional_Information__c;
                            auditObjOld.Philosophy_of_Care__c =  pISObjOld.Philosophy_of_Care__c;
                            auditObjOld.Admin_Assistant_Title__c =  pISObjOld.Admin_Assistant_Title__c;
                            auditObjOld.Admin_Assistant__c = pISObjOld.Admin_Assistant__c;
                            auditObjOld.Admin_Assistant_Email__c = pISObjOld.Admin_Assistant_Email__c;
                            auditObjOld.Admin_Assistant_Phone__c =  pISObjOld.Admin_Assistant_Phone__c;
                            auditObjOld.Delegate_Phone_Ext__c =  pISObjOld.Delegate_Phone_Ext__c;
                            auditObjOld.Names_Changes_Suggested__c = pISObjOld.Names_Changes_Suggested__c;
                            auditObjOld.Case__c = caseId;
                            auditObjOld.Sent_to_MDM__c = Label.CL365_PDI_NA;
                            //Address Information
                            auditObjOld.Provider_Address_Id__c = provOldAddress.Id;
                            auditObjOld.Serial_Number__c = provOldAddress.Serial_Number__c != null ? String.valueOf(provOldAddress.Serial_Number__c) : null;
                            auditObjOld.Address_Type__c = provOldAddress.Address_Type__c;
                            auditObjOld.Address_Unique_Identifier__c = provOldAddress.Address_Unique_Identifier__c;
                            auditObjOld.Address_Status__c = provOldAddress.Address_Status__c;
                            auditObjOld.Secure_Street_Address__c = provOldAddress.Address_Line1__c;
                            auditObjOld.Secure_Address_Line_2__c = provOldAddress.Address_Line_2__c;
                            auditObjOld.Secure_City__c = provOldAddress.City__c;
                            auditObjOld.Secure_Floor__c = provOldAddress.Floor__c;
                            auditObjOld.Secure_Suite__c = provOldAddress.Suite__c;
                            auditObjOld.Secure_State__c = provOldAddress.State__c;
                            auditObjOld.Secure_Zip_Code__c = provOldAddress.Zip_Code__c;
                            auditObjOld.Secure_Phone__c = provOldAddress.Secure_Phone__c;
                            auditObjOld.Secure_Phone_Ext__c = provOldAddress.Secure_Phone_Ext__c;
                            auditObjOld.Secure_Fax__c = provOldAddress.Secure_Fax__c;
                            auditObjOldList.add(auditObjOld);
                        }
                    }
                    /**** Capturing old values on audit object for history tracking Ends ****/
                    
                    /**** Capturing New values on audit object Starts ****/
                    if(!providerNewAddrList.isEmpty()){
                        for(Provider_Address__c provNewAddress : providerNewAddrList){
                            auditObjNew = new Contact_Validation_Audit_Trail__c();
                            
                            auditObjNew =  buildAuditObjList(provNewAddress, WrProviderDetailsObj, auditObjNew, oldAddressMap, pISObjOld);
                            
                            auditObjNew.Tech_Case_Contact_Name__c = caseObj.PDV_Contact_Name__c; 
                            auditObjNew.Provider_Name_Suffix__c = contactInfo.Provider_Name_Suffix__c;
                            auditObjNew.Provider_ID__c = WrProviderDetailsObj.strProviderId;
                            auditObjNew.Provider_Title__c = WrProviderDetailsObj.strProviderTitle;
                            auditObjNew.Provider_NPI__c = pISObjOld.Provider_NPI_F__c;
                            auditObjNew.Sent_to_MDM__c = '';
                            
                            auditObjNewList.add(auditObjNew);
                        }
                    }
                    /**** Capturing New values on audit object Ends ****/
                }else{
                    
                    /*@Description:Updating the Sent_to_MDM__c field of records of same contact created on the same day to N/A */
                    conNAAuditList= [SELECT id, Sent_To_MDM__c FROM Contact_Validation_Audit_Trail__c
                                     WHERE contact_id__c = :sumConId AND Serial_Number__c != '' AND Sent_To_MDM__c = null];
                    /*  For Req#3398 Modified the above query and removed this condition AND createdDate >= :Date.today() */
                    for(Integer i=0;i<conNAAuditList.size();i++){
                        conNAAuditList[i].Sent_To_MDM__c = Label.CL365_PDI_NA;
                    }  
                    
                    for(Provider_Address__c provNewAddress : providerNewAddrList){
                        auditObjNew = new Contact_Validation_Audit_Trail__c();
                        if(provNewAddress.Serial_Number__c != null || (Label.CL472_PDI_AddressDelete.equalsIgnoreCase(provNewAddress.Address_Status__c) 
                                                                       && auditAddrStatusMap.get(provNewAddress.Name) != Label.CL472_PDI_AddressDelete
                                                                       && auditAddrMDMMap.get(provNewAddress.Name) != Label.CL365_PDI_NA))
                        {
                            auditObjNew =  buildAuditObjList(provNewAddress, WrProviderDetailsObj, auditObjNew, oldAddressMap, pISObjOld);
                            
                            auditObjNew.Tech_Case_Contact_Name__c = caseObj.PDV_Contact_Name__c; 
                            auditObjNew.Provider_Name_Suffix__c = contactInfo.Provider_Name_Suffix__c;
                            auditObjNew.Provider_ID__c = WrProviderDetailsObj.strProviderId;
                            auditObjNew.Provider_Title__c = WrProviderDetailsObj.strProviderTitle;
                            auditObjNew.Provider_NPI__c = pISObjOld.Provider_NPI_F__c;
                            auditObjNew.Address_Status__c = Label.CL474_PDI_NewAddress;
                            auditObjNew.Sent_to_MDM__c = '';
                            
                            auditObjNewList.add(auditObjNew);
                        }
                    }
                }// Else Block Ends
                /**** Summary information save functionality Starts ****/
                Contact_Validation_Summary__c pISObj = new Contact_Validation_Summary__c(id=WrProviderDetailsObj.recordId);
                pISObj.Last_Verified_Date__c = system.now();
                pISObj.Email__c = WrProviderDetailsObj.strEmail;
                pISObj.Mobile_Phone__c = WrProviderDetailsObj.strMobilePhone;
                pISObj.Ok_to_Text__c = WrProviderDetailsObj.strOkToText;
                pISObj.Resigned_From_Sutter__c = WrProviderDetailsObj.strResignedFromSutter;                     
                pISObj.Retired_Departed__c = WrProviderDetailsObj.strRetired;
                pISObj.Is_Resigned_Provider_refer__c = WrProviderDetailsObj.strResignedProvider_refer;
                pISObj.Practicing_Physician__c = WrProviderDetailsObj.strPracticingPhysician;
                pISObj.Provider_Name__c=contactInfo.Provider_Name__c;
                pISObj.Provider_ID__c=WrProviderDetailsObj.strProviderId;
                pISObj.Tech_is_Contact_Updated__c = false; //Added to control isChanged Flags update through contact.
                pISObj.Email_Status_Number__c = WrProviderDetailsObj.strEmailStatusNumber;
                pISObj.Email_Status_Description__c = WrProviderDetailsObj.strEmailStatusDescription;
                pISObj.Email_Hygiene_Result__c = WrProviderDetailsObj.strEmailHygeineResult;
                
                if(WrProviderDetailsObj.strPracticingPhysician == true 
                   || (WrProviderDetailsObj.strResignedFromSutter == true
                       && WrProviderDetailsObj.strResignedProvider_refer == true))
                {
                    pISObj.Speciality__c = WrProviderDetailsObj.strSpeciality;
                    pISObj.Department__c = WrProviderDetailsObj.strDepartment;
                    pISObj.Hospital_Affiliations__c = WrProviderDetailsObj.strHospitalAff;
                    pISObj.Medical_Affiliations__c = WrProviderDetailsObj.strMedicalAff;
                    pISObj.Medical_Education__c = WrProviderDetailsObj.strMedicalEducation;
                    pISObj.Website_Address__c = WrProviderDetailsObj.strWebsiteAddress;
                    pISObj.Internship__c = WrProviderDetailsObj.strInternship;
                    pISObj.Residency__c = WrProviderDetailsObj.strResidency;
                    pISObj.Spoken_Languages__c = WrProviderDetailsObj.strSpokenLanguages;
                    pISObj.Community_Activities__c = WrProviderDetailsObj.strCommActivities;
                    pISObj.Personal_Interests__c = WrProviderDetailsObj.strPersonalInterests;
                    pISObj.Philosophy_of_Care__c = WrProviderDetailsObj.strPhilosophyCare;
                    pISObj.Professional_Ineterests__c = WrProviderDetailsObj.strProfessionalInterests;
                    pISObj.Online_Services__c = WrProviderDetailsObj.strOnlineServices;
                    pISObj.Board_Certifications__c = WrProviderDetailsObj.strBoardCertifications;
                    pISObj.Publications__c = WrProviderDetailsObj.strPublications;
                    pISObj.Additional_Information__c = WrProviderDetailsObj.strAdditionalInfo;
                    pISObj.Names_Changes_Suggested__c = WrProviderDetailsObj.strNameChangesSugg;
                    pISObj.Admin_Assistant_Title__c = WrProviderDetailsObj.strAdminAssistantTitle;
                    pISObj.Admin_Assistant__c = WrProviderDetailsObj.strAdminAssistant;
                    pISObj.Admin_Assistant_Email__c = WrProviderDetailsObj.strAdminAssistantEmail;
                    pISObj.Admin_Assistant_Phone__c = WrProviderDetailsObj.strAdminAssistantPhone;
                    pISObj.Delegate_Phone_Ext__c = WrProviderDetailsObj.strAdminAssistantPhoneExt; //Req:3903 Added Delegate phone extension
                }
                else{
                    pISObj.Speciality__c = pISObjOld.Speciality__c;
                    pISObj.Department__c = pISObjOld.Department__c;
                    pISObj.Hospital_Affiliations__c = pISObjOld.Hospital_Affiliations__c;
                    pISObj.Medical_Affiliations__c = pISObjOld.Medical_Affiliations__c;
                    pISObj.Medical_Education__c = pISObjOld.Medical_Education__c;
                    pISObj.Website_Address__c = pISObjOld.Website_Address__c;
                    pISObj.Internship__c = pISObjOld.Internship__c;
                    pISObj.Residency__c = pISObjOld.Residency__c;
                    pISObj.Spoken_Languages__c = pISObjOld.Spoken_Languages__c;
                    pISObj.Community_Activities__c = pISObjOld.Community_Activities__c;
                    pISObj.Personal_Interests__c = pISObjOld.Personal_Interests__c;
                    pISObj.Philosophy_of_Care__c = pISObjOld.Philosophy_of_Care__c;
                    pISObj.Professional_Ineterests__c = pISObjOld.Professional_Ineterests__c;
                    pISObj.Online_Services__c = pISObjOld.Online_Services__c;
                    pISObj.Board_Certifications__c = pISObjOld.Board_Certifications__c;
                    pISObj.Publications__c = pISObjOld.Publications__c;
                    pISObj.Additional_Information__c = pISObjOld.Additional_Information__c;
                    pISObj.Names_Changes_Suggested__c = pISObjOld.Names_Changes_Suggested__c;
                    pISObj.Admin_Assistant_Title__c = pISObjOld.Admin_Assistant_Title__c;
                    pISObj.Admin_Assistant__c = pISObjOld.Admin_Assistant__c;
                    pISObj.Admin_Assistant_Email__c = pISObjOld.Admin_Assistant_Email__c;
                    pISObj.Admin_Assistant_Phone__c = pISObjOld.Admin_Assistant_Phone__c;
                    pISObj.Delegate_Phone_Ext__c = pISObjOld.Delegate_Phone_Ext__c; //Req:3903 Added Delegate phone extension
                }
                pISObj.Tech_is_Contact_Updated__c = false; //Added to control isChanged Flags update through contact.
                pISObj.Associated_Case_Id__c = caseId;
                pISObj.Status__c = Label.CL187_PDI_Validated_Status;
                pISObj.Closed_Date__c = System.now();
                pISObj.Validation_Source_Channel__c = Label.CL390_PDIValidationSourceSFPA;
                pISObj.Tech_Validation_Status__c = 'Call Campaign';
                pISObj.OwnerId = UserInfo.getUserId();
                
                pISObj.Tech_Case_Contact_Name__c = caseObj.PDV_Contact_Name__c;
                pISObj.Tech_Success_Email__c = true;
                
                String addressSummary = '';
                    if(!providerNewAddrList.isEmpty()){
                        addressSummary += '<table Style="font-family: Arial; font-size: 14px;">';
                        for(Provider_Address__c provAddressObj : providerNewAddrList){
                            if(provAddressObj.Address_Line1__c != null){
                                if(Label.CL359_PDI_secondaryAddress.equalsIgnoreCase(provAddressObj.Address_Type__c)){
                                    if(provAddressObj.Serial_Number__c != null && String.isNotBlank(provAddressObj.Serial_Number__c)){
                                        addressSummary += Label.CL589_PDI_TR_Open + Label.CL591_PDI_Td_Top + Label.CL567_PDISecondaryAddressText + strSpace + Label.CL282_PDI_S_hash + strSpace + provAddressObj.Serial_Number__c + Label.CL588_PDI_TD_Close;
                                    }else{
                                        addressSummary += Label.CL589_PDI_TR_Open + Label.CL591_PDI_Td_Top + Label.CL600_PDI_DeletedSecondaryAddress + strSpace + Label.CL588_PDI_TD_Close; 
                                    }
                                }else {
                                    addressSummary += Label.CL589_PDI_TR_Open + Label.CL591_PDI_Td_Top + Label.CL566_PDIPrimaryAddressText + strSpace + Label.CL588_PDI_TD_Close;  
                                }
                                addressSummary +=  Label.CL587_PDI_TD_Open + addressLine1Label + provAddressObj.Address_Line1__c + Label.CL283_PDI_singleBreak + addressLine2Label + provAddressObj.Address_Line_2__c + Label.CL283_PDI_singleBreak
                                    + cityLabel + provAddressObj.City__c + Label.CL283_PDI_singleBreak + stateLabel + provAddressObj.State__c + Label.CL283_PDI_singleBreak + zipCodeLabel + provAddressObj.Zip_Code__c + Label.CL283_PDI_singleBreak + securePhoneLabel + provAddressObj.Secure_Phone__c + Label.CL283_PDI_singleBreak
                                    + phoneExtensionLabel + provAddressObj.Secure_Phone_Ext__c + Label.CL283_PDI_singleBreak + faxLabel + provAddressObj.Secure_Fax__c + Label.CL283_PDI_singleBreak + addressStatusLabel + provAddressObj.Address_Status__c + Label.CL284_doubleBreak + Label.CL588_PDI_TD_Close + Label.CL590_PDI_TR_Close;
                            }
                        }
                        addressSummary += Label.CL592_PDI_Table_End;
                    }
                pISObj.Address_Summary__c = addressSummary;
                
                update pISObj;
                /**** Summary information save functionality Ends ****/
                
                if(!auditObjOldList.isEmpty()){
                    insert auditObjOldList; 
                }
                if(!auditObjNewList.isEmpty()){
                    insert auditObjNewList;
                }
                if(!conNAAuditList.isEmpty()){
                    update conNAAuditList;
                }
            }
            successMsg = Label.CL408_PDISaveMessage;
            refreshProviderList();
            this.setCon.setpageNumber(selectedPage);
            getProviderInfo();
            getAddressValidation();
            fillCaseAddressHistory();
            isCreatingCase = true;
        }catch(DMLException ex) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        } catch(Exception classException) { 
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;
    }
    /*Method Name: assignEmailVerificationDetails
* Description:used to validate email address
* Input Params:List if Emails
* Return Type: void
*/
    private void assignEmailVerificationDetails(List<PDI_Email_Address_Verification.wrapEmailVerification> emailStatusList){
        for(PDI_Email_Address_Verification.wrapEmailVerification emailStat : emailStatusList){
            if(emailStat != null){
                if(!String.isBlank(emailStat.errorMessage)){
                    WrProviderDetailsObj.strEmailVerificationError = emailStat.errorMessage;
                }else{
                    WrProviderDetailsObj.strEmailStatusNumber = emailStat.statusNumber;
                    WrProviderDetailsObj.strEmailStatusDescription = emailStat.statusDescription;
                    WrProviderDetailsObj.strEmailHygeineResult = emailStat.hygeineResult; 
                }
            }
        }
    }
    /*Method Name: buildAuditObjList
* Description:used to create audit records and change log
* Input Params:Provider_Address__c, WrProviderDetails, Contact_Validation_Audit_Trail__c, Map<String,Provider_Address__c>, Contact_Validation_Summary__c
* Return Type: Contact_Validation_Audit_Trail__c
*/
    private Contact_Validation_Audit_Trail__c buildAuditObjList(Provider_Address__c provNewAddress, WrProviderDetails wrProviderObj,
                                                                Contact_Validation_Audit_Trail__c auditObjNew,
                                                                Map<String,Provider_Address__c> oldAddressMap, Contact_Validation_Summary__c pISObjOld)
    {
        Provider_Address__c oldAddress = new Provider_Address__c();
        
        auditObjNew.Tech_Success_Email__c = true; 
        
        auditObjNew.PDI_Campaign__c = wrProviderObj.strPDICampaign;
        auditObjNew.Provider_Information_Summary__c = wrProviderObj.recordId;
        auditObjNew.Contact_Id__c = sumConId;
        auditObjNew.First_Name__c = wrProviderObj.strFirstName;
        auditObjNew.Middle_Name__c = wrProviderObj.strMiddleName;
        auditObjNew.Last_Name__c = wrProviderObj.strLastName;
        
        auditObjNew.Practicing_Physician__c =  wrProviderObj.strPracticingPhysician;
        auditObjNew.Resigned_From_Sutter__c =  wrProviderObj.strResignedFromSutter;
        auditObjNew.Retired_Departed__c =  wrProviderObj.strRetired;
        auditObjNew.Provider_Access_Type__c =  wrProviderObj.strProviderAccessType;
        auditObjNew.Provider_Type__c = wrProviderObj.strProviderType;
        auditObjNew.Deficiency_Provider__c = wrProviderObj.strDeficiencyProvider;
        auditObjNew.Email__c =  wrProviderObj.strEmail;
        auditObjNew.Speciality__c =  wrProviderObj.strSpeciality;
        auditObjNew.Department__c =  wrProviderObj.strDepartment;
        auditObjNew.Mobile_Phone__c = wrProviderObj.strMobilePhone;
        auditObjNew.Ok_to_Text__c = wrProviderObj.strOkToText;
        auditObjNew.Preferred_Communication_Method__c = wrProviderObj.strCommunicationPref;
        auditObjNew.Communication_Preferences_HIM__c = wrProviderObj.strCommunicationHIM;
        auditObjNew.Medical_Education__c =  wrProviderObj.strMedicalEducation;
        auditObjNew.Website_Address__c =  wrProviderObj.strWebsiteAddress;
        auditObjNew.Hospital_Affiliations__c =  wrProviderObj.strHospitalAff;
        auditObjNew.Medical_Affiliations__c =  wrProviderObj.strMedicalAff;
        auditObjNew.Internship__c =  wrProviderObj.strInternship;
        auditObjNew.Residency__c =  wrProviderObj.strResidency;
        auditObjNew.Spoken_Languages__c =  wrProviderObj.strSpokenLanguages;
        auditObjNew.Community_Activities__c =  wrProviderObj.strCommActivities;
        auditObjNew.Personal_Interests__c =  wrProviderObj.strPersonalInterests;
        auditObjNew.Professional_Ineterests__c =  wrProviderObj.strProfessionalInterests;
        auditObjNew.Online_Services__c =  wrProviderObj.strOnlineServices;
        auditObjNew.Board_Certifications__c =  wrProviderObj.strBoardCertifications;
        auditObjNew.Publications__c =  wrProviderObj.strPublications;
        auditObjNew.Additional_Information__c =  wrProviderObj.strAdditionalInfo;
        auditObjNew.Philosophy_of_Care__c =  wrProviderObj.strPhilosophyCare;
        auditObjNew.Admin_Assistant_Title__c =  wrProviderObj.strAdminAssistantTitle;
        auditObjNew.Admin_Assistant__c = wrProviderObj.strAdminAssistant;
        auditObjNew.Admin_Assistant_Email__c = wrProviderObj.strAdminAssistantEmail;
        auditObjNew.Admin_Assistant_Phone__c =  wrProviderObj.strAdminAssistantPhone;
        auditObjNew.Delegate_Phone_Ext__c =  wrProviderObj.strAdminAssistantPhoneExt;
        auditObjNew.Names_Changes_Suggested__c = wrProviderObj.strNameChangesSugg;
        auditObjNew.Case__c = caseId;
        auditObjNew.Sent_to_MDM__c = Label.CL365_PDI_NA;
        //Address Information
        auditObjNew.Provider_Address_Id__c = provNewAddress.Id;
        auditObjNew.Serial_Number__c = provNewAddress.Serial_Number__c != null ? String.valueOf(provNewAddress.Serial_Number__c) : null;
        auditObjNew.Address_Type__c = provNewAddress.Address_Type__c;
        auditObjNew.Address_Unique_Identifier__c = provNewAddress.Address_Unique_Identifier__c;
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
        
        if(!oldAddressMap.isEmpty() && oldAddressMap.containsKey(auditObjNew.Serial_Number__c)){
            oldAddress = oldAddressMap.get(auditObjNew.Serial_Number__c);
        }
        
        String strLog = generateSummaryLog(oldAddress, pISObjOld, auditObjNew);
        
        auditObjNew.Address_Change__c = strLog;
        return auditObjNew;  
    }
    private String generateSummaryLog(Provider_Address__c oldAddress, Contact_Validation_Summary__c pISObjOld,
                                      Contact_Validation_Audit_Trail__c auditObjNew)
    {
        String strLog = strSpace;
        String strAddressType;
        String strSerNumber;
        String logAddressStatus;
        if(auditObjNew.Address_Type__c == Label.CL303_PDIPrimary){
            strAddressType = Label.CL566_PDIPrimaryAddressText;
            strSerNumber = strSpace;
        }
        else{
            strAddressType = Label.CL567_PDISecondaryAddressText;
            strSerNumber = Label.CL282_PDI_S_hash + auditObjNew.Serial_Number__c;
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
        if((auditObjNew.Secure_City__c != oldAddress.City__c) || (auditObjNew.Secure_Fax__c != oldAddress.Secure_Fax__c) || (auditObjNew.Secure_Street_Address__c != oldAddress.Address_Line1__c) || (auditObjNew.Secure_Address_Line_2__c != oldAddress.Address_Line_2__c) || (auditObjNew.Secure_State__c != oldAddress.State__c) || (auditObjNew.Secure_Zip_Code__c != oldAddress.Zip_Code__c) || (auditObjNew.Secure_Phone__c != oldAddress.Secure_Phone__c) || (auditObjNew.Secure_Phone_Ext__c != oldAddress.Secure_Phone_Ext__c))
        {
            auditObjNew.address_modified__c = Label.CL261_PDI_Yes;
            strLog = strLog + Label.CL417_PDIProviderNameLog + strSpace + auditObjNew.First_Name__c + strSpace + auditObjNew.Last_Name__c+ Label.CL283_PDI_singleBreak;
            strLog = strLog + strSerNumber + strSpace + strAddressType + strSpace + logAddressStatus + strSpace + Label.CL281_PDI_AT + strSpace + system.now().format() + Label.CL284_doubleBreak;
        } else {
            auditObjNew.address_modified__c = Label.CL262_PDI_No;
            strLog = strLog + Label.CL417_PDIProviderNameLog + strSpace + auditObjNew.First_Name__c + strSpace + auditObjNew.Last_Name__c+ Label.CL283_PDI_singleBreak;
            strLog = strLog + strSerNumber + strSpace + strAddressType + strSpace + Label.CL187_PDI_Validated_Status + strSpace + Label.CL281_PDI_AT + strSpace + system.now().format() + Label.CL284_doubleBreak;
        }
        if(String.isNotBlank(auditObjNew.Serial_Number__c)){
            if(auditObjNew.Secure_Street_Address__c != oldAddress.Address_Line1__c) {
                strLog  = strLog + Label.CL288_PDI_Log_Address1 + Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + oldAddress.Address_Line1__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Secure_Street_Address__c + Label.CL284_doubleBreak; 
            }
            if(auditObjNew.Secure_Address_Line_2__c != oldAddress.Address_Line_2__c) {
                strLog  = strLog + Label.CL289_PDI_Log_Address2 + Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + oldAddress.Address_Line_2__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Secure_Address_Line_2__c + Label.CL284_doubleBreak; 
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
            if(auditObjNew.Retired_Departed__c != pISObjOld.Retired_Departed__c) {
                strLog  = strLog + Label.CL244_PDI_Retired +  Label.CL283_PDI_singleBreak + Label.CL285_PDI_From + strSpace + pISObjOld.Retired_Departed__c + Label.CL283_PDI_singleBreak + Label.CL286_PDI_To + strSpace + auditObjNew.Retired_Departed__c + Label.CL284_doubleBreak; 
            }
            
            if(auditObjNew.Resigned_From_Sutter__c != pISObjOld.Resigned_From_Sutter__c) {
                strLog  = strLog + Label.CL245_PDI_Resign +  Label.CL283_PDI_singleBreak + Label.CL285_PDI_From + strSpace + pISObjOld.Resigned_From_Sutter__c + Label.CL283_PDI_singleBreak + Label.CL286_PDI_To + strSpace + auditObjNew.Resigned_From_Sutter__c + Label.CL284_doubleBreak; 
            }
            
            if(auditObjNew.Practicing_Physician__c != pISObjOld.Practicing_Physician__c){
                strLog  = strLog + Label.CL243_PDI_Practicing +  Label.CL283_PDI_singleBreak + Label.CL285_PDI_From + strSpace + pISObjOld.Practicing_Physician__c + Label.CL283_PDI_singleBreak + Label.CL286_PDI_To + strSpace + auditObjNew.Practicing_Physician__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Email__c != pISObjOld.Email__c) && (!String.isBlank(auditObjNew.Email__c) || !String.isBlank(pISObjOld.Email__c))) {
                strLog  = strLog + Label.CL294_PDI_Log_Email +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + pISObjOld.Email__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Email__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Mobile_Phone__c != pISObjOld.Mobile_Phone__c) && (!String.isBlank(auditObjNew.Mobile_Phone__c) || !String.isBlank(pISObjOld.Mobile_Phone__c))) {
                strLog  = strLog + Label.CL295_PDI_Log_Mobile +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + pISObjOld.Mobile_Phone__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Mobile_Phone__c + Label.CL284_doubleBreak; 
            }
            if(providerSearchFlag == true){
                if((auditObjNew.Speciality__c != pISObjOld.Speciality__c) && (!String.isBlank(auditObjNew.Speciality__c) || !String.isBlank(pISObjOld.Speciality__c))) {
                    strLog  = strLog + Label.CL426_PDI_Log_speciality +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Speciality__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Speciality__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Department__c != pISObjOld.Department__c) && (!String.isBlank(auditObjNew.Department__c) || !String.isBlank(pISObjOld.Department__c))) {
                    strLog  = strLog + Label.CL428_PDI_Log_Department +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Department__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Department__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Hospital_Affiliations__c != pISObjOld.Hospital_Affiliations__c) && (!String.isBlank(auditObjNew.Hospital_Affiliations__c) || !String.isBlank(pISObjOld.Hospital_Affiliations__c))) {
                    strLog  = strLog + Label.CL429_PDI_Log_Hospital_Affiliations +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Hospital_Affiliations__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Hospital_Affiliations__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Medical_Affiliations__c != pISObjOld.Medical_Affiliations__c) && (!String.isBlank(auditObjNew.Medical_Affiliations__c) || !String.isBlank(pISObjOld.Medical_Affiliations__c))) {
                    strLog  = strLog + Label.CL430_PDI_Log_Medical_Affiliations +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Medical_Affiliations__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Medical_Affiliations__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Medical_Education__c != pISObjOld.Medical_Education__c) && (!String.isBlank(auditObjNew.Medical_Education__c) || !String.isBlank(pISObjOld.Medical_Education__c))) {
                    strLog  = strLog + Label.CL430_PDI_Log_Medical_Education +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Medical_Education__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Medical_Education__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Website_Address__c != pISObjOld.Website_Address__c) && (!String.isBlank(auditObjNew.Website_Address__c) || !String.isBlank(pISObjOld.Website_Address__c))) {
                    strLog  = strLog + Label.CL432_PDI_Log_Website_Address +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Website_Address__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Website_Address__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Internship__c != pISObjOld.Internship__c) && (!String.isBlank(auditObjNew.Internship__c) || !String.isBlank(pISObjOld.Internship__c))) {
                    strLog  = strLog + Label.CL433_PDI_Log_Internship +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Internship__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Internship__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Residency__c != pISObjOld.Residency__c) && (!String.isBlank(auditObjNew.Residency__c) || !String.isBlank(pISObjOld.Residency__c))) {
                    strLog  = strLog + Label.CL434_PDI_Log_Residency +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Residency__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Residency__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Spoken_Languages__c != pISObjOld.Spoken_Languages__c) && (!String.isBlank(auditObjNew.Spoken_Languages__c) || !String.isBlank(pISObjOld.Spoken_Languages__c))) {
                    strLog  = strLog + Label.CL435_PDI_Log_Spoken_Languages +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Spoken_Languages__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Spoken_Languages__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Community_Activities__c != pISObjOld.Community_Activities__c) && (!String.isBlank(auditObjNew.Community_Activities__c) || !String.isBlank(pISObjOld.Community_Activities__c))) {
                    strLog  = strLog + Label.CL436_PDI_Log_Community_Activities +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Community_Activities__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Community_Activities__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Personal_Interests__c != pISObjOld.Personal_Interests__c) && (!String.isBlank(auditObjNew.Personal_Interests__c) || !String.isBlank(pISObjOld.Personal_Interests__c))) {
                    strLog  = strLog + Label.CL437_PDI_Log_Personal_Interests +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Personal_Interests__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Personal_Interests__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Philosophy_of_Care__c != pISObjOld.Philosophy_of_Care__c) && (!String.isBlank(auditObjNew.Philosophy_of_Care__c) || !String.isBlank(pISObjOld.Philosophy_of_Care__c))) {
                    strLog  = strLog + Label.CL438_PDI_Log_Philosophy_of_Care +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Philosophy_of_Care__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Philosophy_of_Care__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Professional_Ineterests__c != pISObjOld.Professional_Ineterests__c) && (!String.isBlank(auditObjNew.Professional_Ineterests__c) || !String.isBlank(pISObjOld.Professional_Ineterests__c))) {
                    strLog  = strLog + Label.CL439_PDI_Log_Professional_Interests +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Professional_Ineterests__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Professional_Ineterests__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Online_Services__c != pISObjOld.Online_Services__c) && (!String.isBlank(auditObjNew.Online_Services__c) || !String.isBlank(pISObjOld.Online_Services__c))) {
                    strLog  = strLog + Label.CL440_PDI_Log_Online_Services +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Online_Services__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Online_Services__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Board_Certifications__c != pISObjOld.Board_Certifications__c) && (!String.isBlank(auditObjNew.Board_Certifications__c) || !String.isBlank(pISObjOld.Board_Certifications__c))) {
                    strLog  = strLog + Label.CL441_PDI_Log_Board_Certifications +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Board_Certifications__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Board_Certifications__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Publications__c != pISObjOld.Publications__c) && (!String.isBlank(auditObjNew.Publications__c) || !String.isBlank(pISObjOld.Publications__c))) {
                    strLog  = strLog + Label.CL443_PDI_Log_Publications +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Publications__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Publications__c + Label.CL284_doubleBreak; 
                }
                if((auditObjNew.Additional_Information__c != pISObjOld.Additional_Information__c) && (!String.isBlank(auditObjNew.Additional_Information__c) || !String.isBlank(pISObjOld.Additional_Information__c))) {
                    strLog  = strLog + Label.CL442_PDI_Log_Additional_Information +  Label.CL283_PDI_singleBreak +
                        Label.CL285_PDI_From + strSpace + pISObjOld.Additional_Information__c + Label.CL283_PDI_singleBreak +
                        Label.CL286_PDI_To + strSpace + auditObjNew.Additional_Information__c + Label.CL284_doubleBreak; 
                }
            }
            if((auditObjNew.Admin_Assistant_Title__c != pISObjOld.Admin_Assistant_Title__c) && (!String.isBlank(auditObjNew.Admin_Assistant_Title__c) || !String.isBlank(pISObjOld.Admin_Assistant_Title__c))) {
                strLog  = strLog + Label.CL444_PDI_Log_Admin_Assistant_Title +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + pISObjOld.Admin_Assistant_Title__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Admin_Assistant_Title__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Admin_Assistant__c != pISObjOld.Admin_Assistant__c) && (!String.isBlank(auditObjNew.Admin_Assistant__c) || !String.isBlank(pISObjOld.Admin_Assistant__c))) {
                strLog  = strLog + Label.CL300_PDI_Log_AdminName +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + pISObjOld.Admin_Assistant__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Admin_Assistant__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Admin_Assistant_Email__c != pISObjOld.Admin_Assistant_Email__c) && (!String.isBlank(auditObjNew.Admin_Assistant_Email__c) || !String.isBlank(pISObjOld.Admin_Assistant_Email__c))) {
                strLog  = strLog + Label.CL301_PDI_Log_AdminEmail +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + pISObjOld.Admin_Assistant_Email__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Admin_Assistant_Email__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Admin_Assistant_Phone__c != pISObjOld.Admin_Assistant_Phone__c) && (!String.isBlank(auditObjNew.Admin_Assistant_Phone__c) || !String.isBlank(pISObjOld.Admin_Assistant_Phone__c))) {
                strLog  = strLog + Label.CL302_PDI_Log_AdminPhone +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + pISObjOld.Admin_Assistant_Phone__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Admin_Assistant_Phone__c + Label.CL284_doubleBreak; 
            }
            if((auditObjNew.Names_Changes_Suggested__c != pISObjOld.Names_Changes_Suggested__c) && (!String.isBlank(auditObjNew.Names_Changes_Suggested__c) || !String.isBlank(pISObjOld.Names_Changes_Suggested__c))) {
                strLog  = strLog + Label.CL296_PDI_Log_NameChange +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + pISObjOld.Names_Changes_Suggested__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + auditObjNew.Names_Changes_Suggested__c + Label.CL284_doubleBreak; 
            }
        }
        //retriveAddressDetails();
        return strLog;  
    }
    
    /*
Method Name: updateCase
Input Param: N/A
Return type: PageReference
Description: This method is used to update case
*/
    public PageReference updateCase() {
        caseStatus = strSpace;
        boolean isCaseValidated =  true;
        if(String.isBlank(caseObj.Common_Subject_Lines__c) || caseObj.Common_Subject_Lines__c == Label.CL426_PDIPickListNone || caseObj.Common_Subject_Lines__c == Label.CL424_PDINone) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL400_PDICaseFillSubject));
            isCaseValidated = false;
        }
        if(caseObj.Status != Label.CL419_PDICannotReach && String.isBlank(caseObj.PDV_Contact_Name__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL401_PDIFillContactName));
            isCaseValidated = false;
        }
        if(strCaseContactPhoneNumber == null || String.isBlank(strCaseContactPhoneNumber)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL402_PDIFillContactNumber));
            isCaseValidated = false;
        } else if(strCaseContactPhoneNumber.isNumeric() || strCaseContactPhoneNumber.length() < 14 || strCaseContactPhoneNumber.length() > 14) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL403_PDIContactNumberInvalid));
            isCaseValidated = false;
        }
        if(String.isBlank(caseObj.Status)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL404_PDICaseFillStatus));
            isCaseValidated = false;
        }
        if(isCaseValidated == false) {
            return null;
        }
        caseObj.OwnerId = UserInfo.getUserId();
        update caseObj;
        caseStatus = caseObj.Status;
        List<Contact_validation_Summary__c> sumUpdateList = new List<Contact_validation_Summary__c>();
        if(caseStatus == Label.CL384_PDICaseSatusClosed){
            for(Contact_validation_Summary__c sum: summaryList){
                if(sum.Associated_Case_Id__r.Id == caseObj.Id){
                    sum.Associated_Case_Closed__c = true;
                    sum.Tech_Success_Email__c = false;
                    sumUpdateList.add(sum);
                }
            }
            update sumUpdateList;
            isNewCase = true;
        }
        caseSuccessMsg = Label.CL413_CaseSaveMessage;
        return null;
    }
    
    // Address Related logic Starts
    /*
* @description  :   This method is used to retrieve Address Details of the contact
* @param        :   N/A
* @return       :   void
*/
    public void retriveAddressDetails(){
        SecondaryAddrList = new List<Provider_Address__c>();   
        primaryAddrObj = new Provider_Address__c();
        statusMap = new Map<Integer, String>();
        resultStatusMap = new Map<String, String>();
        processCodes = new Set<String>();
        correctAddrCodeSet = new Set<String>();
        verifiedAddrCodeSet = new Set<String>();
        addressNotProcessedStatusMap = new Map<String, String>();
        addressWebserviceStatusMap = new Map<String, String>();
        List<Provider_Address__c>  addrObjList = new List<Provider_Address__c>();
        List<Provider_Address__c> tempSecAddressActiveList = new List<Provider_Address__c>();
        try{
            editAddrmode = false;
            reordermode = false;
            
            addrObjList = [SELECT Serial_Number__c, id, Address_Line1__c, Address_Line_2__c, Address_Type__c, City__c, State__c, County__c, Country__c, Suite__c, Floor__c,
                           Address_Process_Status__c, Address_Mailability_Score__c, Address_Result_Percentage__c,
                           Patient_Facing__c, Address_Unique_Identifier__c, Contact_Id__c, Summary_Id__c, AD_Address_Verification_Status__c, AD_Element_Result_status__c,
                           Zip_Code__c, Secure_Phone__c, Secure_Phone_Ext__c, Secure_Fax__c, Direct_Address__c, Address_Status__c, Address_Validated__c,
                           Decline_Phone__c, Decline_Fax__c, Tech_Is_Address_Updated__c, PDI_Campaign__c, Provider_Address_AD_Status__c,
                           EPIC_Address_Status__c, EPIC_Address_Inactive_Status_Date__c, Tech_Is_Address_Verified__c
                           FROM Provider_Address__c WHERE Contact_Id__c = :sumConId AND EPIC_Address_Status__c != :Label.CL471_PDI_EPICAddressInactive 
                           AND PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name AND Address_Status__c != :Label.CL472_PDI_AddressDelete ORDER BY Serial_Number__c ASC];
            Integer secAddressActiveCounter = 0;
            if(!addrObjList.isEmpty()){
                for(Provider_Address__c addrObj1 : addrObjList)
                {
                    if(addrObj1.Secure_Phone__c != null){
                        addrObj1.Secure_Phone__c = ProvidersByPhoneNumberHelper.FormatPhone(addrObj1.Secure_Phone__c);
                    }
                    if(addrObj1.Secure_Fax__c != null){
                        addrObj1.Secure_Fax__c = ProvidersByPhoneNumberHelper.FormatPhone(addrObj1.Secure_Fax__c);
                    }
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(addrObj1.Address_Type__c))
                    {
                        primaryAddrObj=addrObj1;
                    }
                    else
                    {
                        tempSecAddressActiveList.add(addrObj1);
                        secAddressActiveCounter++;
                    }
                }
            }
            Integer maxSerailNumber = 0;
            if(!tempSecAddressActiveList.isEmpty()){
                for(Provider_Address__c secAddr : tempSecAddressActiveList){
                    maxSerailNumber = Integer.valueOf(secAddr.Serial_Number__c);
                }
            }
            if(!tempSecAddressActiveList.isEmpty()){
                if(maxSerailNumber != secAddressActiveCounter){
                    Integer activeSerialNumber = 0;
                    for(Provider_Address__c secAddr : tempSecAddressActiveList){
                        activeSerialNumber = activeSerialNumber + 1;
                        secAddr.Serial_Number__c =  String.valueOf(activeSerialNumber); 
                        SecondaryAddrList.add(secAddr);
                    }
                }else{
                    SecondaryAddrList = tempSecAddressActiveList.clone();
                }
            }
            // New Button Display Logic Starts
            if(primaryAddrObj == null && SecondaryAddrList.isEmpty()){
                showNewButtonFlag = true;
            }else if(primaryAddrObj != null && SecondaryAddrList.isEmpty()){
                showNewButtonFlag = true;
            }else{
                showNewButtonFlag = showNewButton(SecondaryAddrList);
            }
            // New Button Display Logic Ends
            if(reordermode == false){
                showReorderBtnFlag = showReorderButton(SecondaryAddrList);
            }
            
            // Address Doctor Each element status map Starts 
            for (PDIAddressElementStatus__c eleStatus : PDIAddressElementStatus__c.getAll().values()){
                statusMap.put(Integer.valueOf(eleStatus.Name), eleStatus.Value__c);
            }
            // Address Doctor Each element status result map Ends
            // Address Doctor valid or Invalid result map Starts
            for (PDIResultStatusCodes__c eleStatus : PDIResultStatusCodes__c.getAll().values()){
                resultStatusMap.put(eleStatus.Name, eleStatus.value__c);
            }
            // Address Doctor valid or Invalid result map Ends 
            // Address Doctor Correct Address Code Set Starts
            for (PDIADCorrectAddressCodes__c addrCodes : PDIADCorrectAddressCodes__c.getAll().values()){
                correctAddrCodeSet.add(addrCodes.Name);
            }
            // Address Doctor Correct Address Code Set Ends
            // Address Doctor Verified Address Codes Set Starts
            for (PDIADVerificationCodes__c verifiedCode : PDIADVerificationCodes__c.getAll().values()){
                verifiedAddrCodeSet.add(verifiedCode.Name);
            }
            // Address Doctor Verified Address Codes Set Ends
            // Address Doctor InCorrect Address Codes Set Starts
            for (PDIADErrorCodes__c processErrCode : PDIADErrorCodes__c.getAll().values()){
                processCodes.add(processErrCode.Name);
            }
            // Address Doctor Incorrect Address Codes Set Ends
            for (PDIADNotProcessedCodes__c notProcessed : PDIADNotProcessedCodes__c.getAll().values()){
                addressNotProcessedStatusMap.put(notProcessed.Name, notProcessed.Code__c);
            }
            for (PDIADWebServiceStatusCodes__c status : PDIADWebServiceStatusCodes__c.getAll().values()){
                addressWebserviceStatusMap.put(status.Name, status.Code__c);
            }
            // Added on 21/12/2016 to Override the Address Verification Custom Setting Code Starts
            PDI_Bypass_AddressVerification__c flag = PDI_Bypass_AddressVerification__c.getInstance('BypassCallCampaignAddressVerification');
            byPassAddressVerificationFlag = flag.byPassValue__c;
        }
        catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + '\r\n' + '--------------');
        }
    }
    /*
* @description  :   This method is used to display new button based on SecondaryAddrList size
* @param        :   N/A
* @return       :   Boolean
*/
    private Boolean showNewButton(List<Provider_Address__c> SecondaryAddrList){
        List<Provider_Address__c> tempSecAddrList = new List<Provider_Address__c>();
        Boolean showNewBtn = false;
        if(!SecondaryAddrList.isEmpty()){
            for(Provider_Address__c addressObj : SecondaryAddrList){
                if(!Label.CL472_PDI_AddressDelete.equalsIgnoreCase(addressObj.Address_Status__c)){
                    tempSecAddrList.add(addressObj);
                }
            }
        }
        if(!tempSecAddrList.isEmpty() && tempSecAddrList.size() < 4){
            showNewBtn = true;
        }
        return showNewBtn;
    }
    /*
* @description  :   This method is used to display reorder button based on SecondaryAddrList size
* @param        :   N/A
* @return       :   Boolean
*/
    private Boolean showReorderButton(List<Provider_Address__c> SecondaryAddrList){
        Boolean reorderBtn = false;
        if(!SecondaryAddrList.isEmpty() && SecondaryAddrList.size() > 1){
            reorderBtn = true;
        }else{
            reorderBtn = false;
        }
        return reorderBtn;
    }
    /*
* @description  :   This method is used to make serail number as editable
* @param        :   N/A
* @return       :   PageReference
*/
    public PageReference reorderAddress(){
        reordermode = true;
        showReorderBtnFlag = false;
        return null;
    }
    /*
* @description  :   This method is used to go back to read mode
* @param        :   N/A
* @return       :   PageReference
*/
    public PageReference cancelReorder(){
        reordermode = false;
        showReorderBtnFlag = true;
        return null;
    }
    /*
* @description  :   This method is used create New Address
* @param        :   N/A
* @return       :   void
*/
    public PageReference newAddress(){
        address = new Provider_Address__c();
        Integer lastAddrSerialNumber = 0;
        try{
            suggestedAddressFlag = false;
            selectedRecord = null;
            if(!SecondaryAddrList.isEmpty()){
                for(Provider_Address__c secAddr : SecondaryAddrList){
                    if(secAddr.Serial_Number__c != ''){
                        lastAddrSerialNumber = Integer.valueOf(secAddr.Serial_Number__c);
                    }
                }
                lastAddrSerialNumber += 1;
                address.Serial_Number__c = String.valueOf(lastAddrSerialNumber);
            }else{
                address.Serial_Number__c = '1';
            }
            address.Contact_Id__c = sumConId;
            address.Summary_Id__c = summaryId;
            address.Address_Status__c = Label.CL474_PDI_NewAddress;
            address.Address_Type__c = Label.CL359_PDI_secondaryAddress;
            address.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
                        // Added on 21/12/2016 to Override the Address Verification Starts
            if(byPassAddressVerificationFlag == true){
                address.Tech_Bypass_Address_Verification__c = true;
            }else{
                address.Tech_Bypass_Address_Verification__c = false;
            }
            // Added on 21/12/2016 to Override the Address Verification Ends
            editAddrmode = true;
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;
    }
    /*
* @description  :   This method is used Edit the selected Address
* @param        :   N/A
* @return       :   PageReference
*/
    public PageReference getselectedAddress(){
        address = new Provider_Address__c();
        try{
            suggestedAddressFlag = false;
            selectedRecord = null;
            String addressId = Apexpages.currentPage().getParameters().get('addressId');
            String serialNumber = Apexpages.currentPage().getParameters().get('serialnumber');
            editAddrmode = true;
            if(addressId != null && !String.isBlank(addressId)){
                if(addressId.equalsIgnoreCase(primaryAddrObj.Id)){
                    address = assignAddress(primaryAddrObj);
                    if(primaryAddrObj.EPIC_Address_Status__c != null){
                        address.Address_Status__c = Label.CL473_PDI_ModifiedAddress;
                    }else{
                        address.Address_Status__c = Label.CL474_PDI_NewAddress;
                    }
                }else{
                    for(Provider_Address__c secondaryAddr : SecondaryAddrList){
                        if(addressId.equalsIgnoreCase(secondaryAddr.Id)){
                            address = assignAddress(secondaryAddr);
                            if(secondaryAddr.EPIC_Address_Status__c != null){
                                address.Address_Status__c = Label.CL473_PDI_ModifiedAddress;
                            }else{
                                address.Address_Status__c = Label.CL474_PDI_NewAddress;
                            }
                        }
                    }
                }
            }else{
                if(serialNumber != null){
                    if(serialNumber.equalsIgnoreCase(primaryAddrObj.Serial_Number__c)){
                        address = assignAddress(primaryAddrObj);
                        address.Address_Status__c = Label.CL474_PDI_NewAddress;
                    }else{
                        for(Provider_Address__c secondaryAddr : SecondaryAddrList){
                            if(serialNumber.equalsIgnoreCase(secondaryAddr.Serial_Number__c)){
                                address = assignAddress(secondaryAddr);
                                address.Address_Status__c = Label.CL474_PDI_NewAddress;
                            }
                        }
                    }
                }
            }
        }
        catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens); return null;
        }
        return null;    
    }
    /*
* @description  :   This method is used assign primary or secondary address values to address obj
* @param        :   addressObj
* @return       :   Provider_Address__c
*/
    private Provider_Address__c assignAddress(Provider_Address__c addressObj){
        Provider_Address__c addrObj1 = new Provider_Address__c();
        
        addrObj1.id = addressObj.Id;
        addrObj1.Contact_Id__c = addressObj.Contact_Id__c;
        addrObj1.Summary_Id__c = addressObj.Summary_Id__c;
        addrObj1.Address_Unique_Identifier__c = addressObj.Address_Unique_Identifier__c;
        addrObj1.Tech_Is_Address_Updated__c = addressObj.Tech_Is_Address_Updated__c;
        addrObj1.PDI_Campaign__c = addressObj.PDI_Campaign__c;
        //Address Details
        addrObj1.Address_Type__c = addressObj.Address_Type__c;
        addrObj1.Address_Line1__c = addressObj.Address_Line1__c;
        addrObj1.Address_Line_2__c = addressObj.Address_Line_2__c;
        addrObj1.City__c = addressObj.City__c;
        addrObj1.State__c = addressObj.State__c;
        addrObj1.Zip_Code__c = addressObj.Zip_Code__c;
        addrObj1.County__c = addressObj.County__c;
        addrObj1.Suite__c = addressObj.Suite__c;
        addrObj1.Floor__c = addressObj.Floor__c;
        addrObj1.Country__c = addressObj.Country__c;
        addrObj1.Serial_Number__c = addressObj.Serial_Number__c;
        addrObj1.Direct_Address__c = addressObj.Direct_Address__c;
        addrObj1.Secure_Phone__c = addressObj.Secure_Phone__c;
        addrObj1.Secure_Phone_Ext__c = addressObj.Secure_Phone_Ext__c;
        addrObj1.Secure_Fax__c = addressObj.Secure_Fax__c;
        addrObj1.Decline_Phone__c = addressObj.Decline_Phone__c;
        addrObj1.Decline_Fax__c = addressObj.Decline_Fax__c;
        addrObj1.Tech_Is_Address_Verified__c = addressObj.Tech_Is_Address_Verified__c;
        // Added on 21/12/2016 to Override the Address Verification Starts
        if(byPassAddressVerificationFlag == true){
            addrObj1.Tech_Bypass_Address_Verification__c = true;
        }else{
            addrObj1.Tech_Bypass_Address_Verification__c = addressObj.Tech_Bypass_Address_Verification__c;
        }
        // Added on 21/12/2016 to Override the Address Verification Ends
        //Adress Doctor verification fields        
        addrObj1.Provider_Address_AD_Status__c = addressObj.Provider_Address_AD_Status__c;
        addrObj1.Address_Mailability_Score__c = addressObj.Address_Mailability_Score__c;
        addrObj1.Address_Result_Percentage__c = addressObj.Address_Result_Percentage__c;
        addrObj1.AD_Address_Verification_Status__c = addressObj.AD_Address_Verification_Status__c;
        addrObj1.AD_Element_Result_status__c = null;
        addrObj1.Address_Status__c = addressObj.Address_Status__c;
        //EPIC verification fields   
        addrObj1.Address_Process_Status__c = addressObj.Address_Process_Status__c;
        addrObj1.EPIC_Address_Status__c = addressObj.EPIC_Address_Status__c;
        addrObj1.EPIC_Address_Inactive_Status_Date__c = addressObj.EPIC_Address_Inactive_Status_Date__c;
        addrObj1.Patient_Facing__c = addressObj.Patient_Facing__c;
        
        return addrObj1;
    }
    /*
* @description  :   This method is used delete Address
* @param        :   N/A
* @return       :   void
*/
    public PageReference deleteAddress(){
        List<Provider_Address__c> secondaryAddrDeleteList;
        Integer addrCounter = 0;
        try{
            String serialNumber = Apexpages.currentPage().getParameters().get('serialNumber');
            if(serialNumber != null || serialNumber != ''){
                secondaryAddrDeleteList = new List<Provider_Address__c>();
                if(!SecondaryAddrList.isEmpty()){
                    for(Provider_Address__c secondaryAddr : SecondaryAddrList){
                        if(String.isNotBlank(secondaryAddr.Serial_Number__c)){
                            if(serialNumber.equalsIgnoreCase(secondaryAddr.Serial_Number__c)){
                                secondaryAddr.Address_Status__c = Label.CL472_PDI_AddressDelete;
                                secondaryAddr.Serial_Number__c = '';
                            }
                            if(secondaryAddr.Serial_Number__c != ''){
                                if(serialNumber < secondaryAddr.Serial_Number__c){
                                    Integer serNumber= Integer.valueOf(secondaryAddr.Serial_Number__c) - 1;
                                    secondaryAddr.Serial_Number__c =  String.valueOf(serNumber);
                                }
                                addrCounter++;
                            }
                            secondaryAddrDeleteList.add(secondaryAddr);
                        }
                    }
                    if(tempsecondaryAddrMap != null && !tempsecondaryAddrMap.isEmpty() && tempsecondaryAddrMap.containsKey(serialNumber)){
                        tempsecondaryAddrMap.remove(serialNumber);
                    }
                }
                if(!secondaryAddrDeleteList.isEmpty()){
                    SecondaryAddrList = new List<Provider_Address__c>();
                    SecondaryAddrList = secondaryAddrDeleteList.clone();
                }
            }
            if(addrCounter > 1 && reordermode == false){
                showReorderBtnFlag = true;
            }else{
                showReorderBtnFlag = false;
            }
            editAddrmode = false;
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;
    }
    /*
* @description  :   This method is used to return Address Readonly page.
* @param        :   N/A
* @return       :   PageReference
*/
    public PageReference cancelAddress(){
        if(suggestedAddressFlag == true){
            editAddrmode = true;
            suggestedAddressFlag = false;
            addressline2ErrorFlag = false;
            selectedRecord = null;
        }else{
            selectedRecord = null;
            editAddrmode = false;
            addressline2ErrorFlag = false;
        }
        return null;
    }
    /*
* @description  :   This method is used to invoke Address doctor service and display suggested Addresses.
* @param        :   N/A
* @return       :   PageReference
*/
    public PageReference findSuggestedAddress(){
        isAddressValidAllFields = true;
        isAddressDoctorValidFields = true;
        addressline2ErrorFlag = false;
        suggestedAddressList = new List<Provider_Address__c>();
        
        try{
            if(WrProviderDetailsObj.strPracticingPhysician == true ||(WrProviderDetailsObj.strResignedFromSutter == true  && WrProviderDetailsObj.strResignedProvider_refer == true))
            { 
                if(string.isBlank(address.Address_Line1__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL269_PDI_BlankAddress));
                    isAddressValidAllFields = false;
                }else if(patterMatcherCareOf(address.Address_Line1__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL271_PDI_streetAddressPattern));
                    isAddressValidAllFields = false;
                }
                if(string.isBlank(address.City__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL276_PDI_BlankCity));
                    isAddressValidAllFields = false;
                }
                if(string.isBlank(address.State__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL278_PDI_BlankState));
                    isAddressValidAllFields = false;
                }
                if(string.isBlank(address.Zip_Code__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL277_PDI_BlankZipCode));
                    isAddressValidAllFields = false;
                }
                if(string.isBlank(address.Secure_Phone__c) && address.Address_Type__c.equalsIgnoreCase(Label.CL303_PDIPrimary) && address.Decline_Phone__c == false) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL272_PDI_BlankPhone));
                    isAddressValidAllFields = false;
                } else if(!string.isBlank(address.Secure_Phone__c)) {
                    if(!string.isBlank(address.Secure_Phone__c) && (address.Secure_Phone__c.length() < 14 || address.Secure_Phone__c.length() > 14)) {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL273_PDI_InvalidPhone));
                        isAddressValidAllFields = false;
                    }
                }
                if(!String.isBlank(address.Secure_Phone_Ext__c) && !address.Secure_Phone_Ext__c.isNumeric()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL279_PDI_NumericExt));
                    isAddressValidAllFields = false;
                }
                if(string.isBlank(address.Secure_Fax__c) && address.Address_Type__c.equalsIgnoreCase(Label.CL303_PDIPrimary) && address.Decline_Fax__c == false) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL274_PDI_BlankFax));
                    isAddressValidAllFields = false;
                } else if(!string.isBlank(address.Secure_Fax__c) && (address.Secure_Fax__c.length() < 14 || address.Secure_Fax__c.length() > 14)) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL275_PDI_InvalidFax));
                    isAddressValidAllFields = false;
                }
            }
            if(!isAddressValidAllFields){
                editAddrmode = true;
                return null;
            }else{
                editAddrmode = true;
            }
            if(address.Tech_Bypass_Address_Verification__c == false){
            if(suggestedAddressFlag == false){
                verifiedAddressList = new List<PDI_Address_Verification.addressAD>();
                verifiedAddressList = PDI_Address_Verification.checkProviderAddress(address);
                if(!verifiedAddressList.isEmpty()){
                    for(PDI_Address_Verification.addressAD adAddress : verifiedAddressList){
                        if(adAddress.errorStatus != null && !String.isBlank(adAddress.errorStatus)){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg +adAddress.errorStatus));
                            isAddressValidAllFields = false;
                            suggestedAddressFlag = false;
                            return null;
                        }else{
                            if(adAddress.addressProcessStatus != null && addressNotProcessedStatusMap.containsKey(adAddress.addressProcessStatus)){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg +addressNotProcessedStatusMap.get(adAddress.addressProcessStatus)));
                                isAddressValidAllFields = false;
                                suggestedAddressFlag = false;
                                return null;
                            }else if(adAddress.addressProcessStatus != null && addressWebserviceStatusMap.containsKey(adAddress.addressProcessStatus)){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg +addressWebserviceStatusMap.get(adAddress.addressProcessStatus)));
                                isAddressValidAllFields = false;
                                suggestedAddressFlag = false;
                                return null;
                            }else{
                                if(adAddress.addressProcessStatus != null && !processCodes.contains(adAddress.addressProcessStatus))
                                {
                                    if(adAddress.elementResultStatus != null){
                                        String[] responseEleStatusStr = adAddress.elementResultStatus.split('');
                                        for(Integer key : statusMap.keySet()){
                                            if(responseEleStatusStr.get(key) == '3' || responseEleStatusStr.get(key) == '4'){
                                                String addrValue = statusMap.get(key);
                                                if(!Label.CL558_PDISubBuildingText.equalsIgnoreCase(addrValue.substring(0, addrValue.length()-1))){
                                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL559_PDIAddressContainsText + strSpace + addrValue.substring(0, addrValue.length()-1) + Label.CL560_PDICorrectItText));
                                                    isAddressDoctorValidFields = false;
                                                    isAddressValidAllFields = false;
                                                }
                                            }
                                        } 
                                    }
                                    if(!isAddressDoctorValidFields){
                                        editAddrmode = true;
                                        return null;
                                    }else{
                                        editAddrmode = true;
                                    }
                                    for(Provider_Address__c addrObj : adAddress.verifiedProvAddressList){
                                        suggestedAddressList.add(addrObj);
                                    }
                                    if(!suggestedAddressList.isEmpty()){
                                        suggestedAddressFlag = true;
                                    }   
                                }else{
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'We are unable to validate the entered address. Please correct.'));
                                    isAddressValidAllFields = false;
                                    suggestedAddressFlag = false;
                                    return null;
                                } 
                            }
                        }
                    }
                }
            }
            }
            else{  // Added on 21/12/2016 to Override the Address Verification Starts
                saveProviderAddressDetails(address); 
            }
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + '--------------');
            return null;
        }
        return null;
    }
    /*
* @description  :   This method is used to map suggested Address and prepare final address list.
* @param        :   N/A
* @return       :   PageReference
*/
    public PageReference saveAddress(){
        isAddressDoctorValidFields = true;
        addressline2ErrorFlag = false;
        String elementResult = '';
        try{
            if(suggestedAddressFlag == true){
                if(!suggestedAddressList.isEmpty()){
                    for(Provider_Address__c addr : suggestedAddressList){
                        if(addr.Formatted_Address__c == selectedRecord){
                            verifiedAddressList = new List<PDI_Address_Verification.addressAD>();
                            verifiedAddressList = PDI_Address_Verification.checkProviderAddress(addr);
                            if(!verifiedAddressList.isEmpty()){
                                for(PDI_Address_Verification.addressAD adAddress : verifiedAddressList){
                                    if(adAddress.errorStatus != null && !String.isBlank(adAddress.errorStatus)){
                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg +adAddress.errorStatus));
                                        isAddressValidAllFields = false;
                                        suggestedAddressFlag = false;
                                        return null;
                                    }else{
                                        if(adAddress.addressProcessStatus != null && addressNotProcessedStatusMap.containsKey(adAddress.addressProcessStatus)){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg + addressNotProcessedStatusMap.get(adAddress.addressProcessStatus)));
                                            isAddressValidAllFields = false;
                                            suggestedAddressFlag = false;
                                            return null;
                                        }else if(adAddress.addressProcessStatus != null && addressWebserviceStatusMap.containsKey(adAddress.addressProcessStatus)){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg + addressWebserviceStatusMap.get(adAddress.addressProcessStatus)));
                                            isAddressValidAllFields = false;
                                            suggestedAddressFlag = false;
                                            return null;
                                        }else{
                                            if(adAddress.addressProcessStatus != null && !processCodes.contains(adAddress.addressProcessStatus))
                                            {
                                                if(adAddress.elementResultStatus != null){
                                                    String[] responseEleStatusStr = adAddress.elementResultStatus.split('');
                                                    for(Integer key : statusMap.keySet()){
                                                        if(responseEleStatusStr.get(key) != '0'){
                                                            String addrValue = statusMap.get(key);
                                                            elementResult += '<b>'+ addrValue + ':</b>&nbsp;&nbsp;'+ resultStatusMap.get(responseEleStatusStr.get(key)) + '<br/>';
                                                        }
                                                        if(responseEleStatusStr.get(key) == '3' || responseEleStatusStr.get(key) == '4'){
                                                            String addrValue = statusMap.get(key);
                                                            if(Label.CL558_PDISubBuildingText.equalsIgnoreCase(addrValue.substring(0, addrValue.length()-1))){
                                                                isAddressDoctorValidFields = false;
                                                                addressline2ErrorFlag = true;
                                                            }else {
                                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL559_PDIAddressContainsText + strSpace + addrValue.substring(0, addrValue.length()-1) + Label.CL560_PDICorrectItText));
                                                                isAddressDoctorValidFields = false;
                                                                isAddressValidAllFields = false;
                                                            }
                                                        }
                                                    } 
                                                }
                                                for(Provider_Address__c addrObj : adAddress.verifiedProvAddressList){
                                                    address.Address_Line1__c = addr.Address_Line1__c;
                                                    address.Address_Line_2__c = addr.Address_Line_2__c;
                                                    address.City__c = addr.City__c;
                                                    address.State__c = addr.State__c;
                                                    address.Zip_Code__c = addr.Zip_Code__c;
                                                    address.County__c = addr.County__c;
                                                    address.Provider_Address_AD_Status__c = addr.Provider_Address_AD_Status__c;
                                                    address.Address_Mailability_Score__c = addr.Address_Mailability_Score__c;
                                                    address.Address_Result_Percentage__c = addr.Address_Result_Percentage__c;
                                                    address.AD_Element_Result_status__c = elementResult;
                                                    address.Tech_Is_Address_Verified__c = true;
                                                    address.Tech_Bypass_Address_Verification__c = address.Tech_Bypass_Address_Verification__c; // Added on 21/12/2016 to Override the Address Verification
                                                }
                                                if(!isAddressDoctorValidFields){
                                                    editAddrmode = true;
                                                    suggestedAddressFlag = false;
                                                    return null;
                                                }else{
                                                    editAddrmode = false;
                                                    selectedRecord = '';
                                                }
                                            }else{
                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL548_PDI_ADErrorMessage));
                                                suggestedAddressFlag = false;
                                                return null;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // Added on 21/12/2016 to Override the Address Verification Starts. Calls the saveProviderAddressDetails method to Save the address
            // information once after verification.
            saveProviderAddressDetails(address);
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;
    }
    /*
* @description  :   This method is used to Convert the secondary addresses as primary address.
* @param        :   N/A
* @return       :   PageReference
*/
    public PageReference convertAddress(){
        Provider_Address__c dummyprimaryAddr = new Provider_Address__c();
        List<Provider_Address__c> secAddrList = new List<Provider_Address__c>();
        String changedSerialNumber = null;
        try{
            String addressSerialNumber = Apexpages.currentPage().getParameters().get('serNumber');
            if(addressSerialNumber != null || addressSerialNumber != ''){
                if(!SecondaryAddrList.isEmpty()){
                    for(Provider_Address__c provAddress : SecondaryAddrList){
                        if(addressSerialNumber.equalsIgnoreCase(provAddress.Serial_Number__c)){
                            changedSerialNumber = provAddress.Serial_Number__c;
                            dummyprimaryAddr = provAddress;
                            dummyprimaryAddr.Address_Type__c = Label.CL303_PDIPrimary;
                            dummyprimaryAddr.Serial_Number__c = '0';
                            if(primaryAddrObj.Address_Line1__c != null){
                                primaryAddrObj.Serial_Number__c = changedSerialNumber;
                                primaryAddrObj.Address_Type__c = Label.CL359_PDI_secondaryAddress;
                                secAddrList.add(primaryAddrObj);  
                            }
                        }else{
                            secAddrList.add(provAddress);
                        }
                    }
                    SecondaryAddrList = new List<Provider_Address__c>();
                    if(!secAddrList.isEmpty()){
                        if(primaryAddrObj.Address_Line1__c == null){
                            for(Provider_Address__c objAddr : secAddrList){
                                if(Integer.valueOf(changedSerialNumber) < Integer.valueOf(objAddr.Serial_Number__c)){
                                    Integer serNumber= Integer.valueOf(objAddr.Serial_Number__c) - 1;
                                    objAddr.Serial_Number__c = String.valueOf(serNumber);
                                }
                                SecondaryAddrList.add(objAddr);
                            }
                        }else{
                            SecondaryAddrList = secAddrList.clone();
                        }
                    }else{
                        if(tempsecondaryAddrMap != null && tempsecondaryAddrMap.containsKey(changedSerialNumber)){
                            tempsecondaryAddrMap.remove(changedSerialNumber);
                        }
                    }
                }
                if(changedSerialNumber != null){
                    primaryAddrObj = dummyprimaryAddr;
                }
                editAddrmode = false;
            }
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;
    }
    
        /*
    * @description  :   This method is used prepare the provider address primary and secondary address lists.
    * @param        :   address
    * @return       :   void
    */
    public void saveProviderAddressDetails(Provider_Address__c address){
        List<Provider_Address__c> secAddrList = new List<Provider_Address__c>();
        suggestedAddressFlag = false;
        editAddrmode = false;
        if(address.Provider_Address_AD_Status__c != null){
            if(correctAddrCodeSet.contains(address.Provider_Address_AD_Status__c)){
                address.AD_Address_Verification_Status__c = Label.CL475_PDI_ADCorrect;
            }else if(verifiedAddrCodeSet.contains(address.Provider_Address_AD_Status__c)){
                address.AD_Address_Verification_Status__c = Label.CL476_PDI_AD_Verified;
            }else if(processCodes.contains(address.Provider_Address_AD_Status__c)){
                address.AD_Address_Verification_Status__c = Label.CL477_PDI_AD_InCorrect;
            }
        }
        if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
            address.Serial_Number__c = '0';
            address.Tech_Is_Address_Updated__c = true;
            primaryAddrObj = address;
        }else{
            if(address.Id == null){
                if(tempsecondaryAddrMap != null && tempsecondaryAddrMap.containsKey(address.Serial_Number__c)){
                    for(Provider_Address__c secaddr : SecondaryAddrList){
                        if(address.Serial_Number__c == secaddr.Serial_Number__c){
                            secaddr.Address_Line1__c = address.Address_Line1__c;
                            secaddr.Address_Line_2__c = address.Address_Line_2__c;
                            secaddr.City__c = address.City__c;
                            secaddr.State__c = address.State__c;
                            secaddr.County__c = address.County__c;
                            secaddr.Zip_Code__c = address.Zip_Code__c;
                            secaddr.Secure_Phone__c = address.Secure_Phone__c;
                            secaddr.Secure_Fax__c = address.Secure_Fax__c;
                            secaddr.Provider_Address_AD_Status__c = address.Provider_Address_AD_Status__c;
                            secaddr.Address_Mailability_Score__c = address.Address_Mailability_Score__c;
                            secaddr.Address_Result_Percentage__c = address.Address_Result_Percentage__c;
                            secaddr.AD_Address_Verification_Status__c = address.AD_Address_Verification_Status__c;
                            secaddr.AD_Element_Result_status__c = address.AD_Element_Result_status__c;
                            secaddr.Tech_Is_Address_Verified__c = address.Tech_Is_Address_Verified__c;
                            secaddr.Tech_Is_Address_Updated__c = true;
                            secaddr.Tech_Bypass_Address_Verification__c = address.Tech_Bypass_Address_Verification__c; // Added on 21/12/2016 to Override the Address Verification
                        }
                        secAddrList.add(secaddr);
                    }
                }else{
                    SecondaryAddrList.add(address); 
                }
            }else{
                for(Provider_Address__c secaddr : SecondaryAddrList){
                    if(address.Id == secaddr.Id){
                        secaddr.Address_Line1__c = address.Address_Line1__c;
                        secaddr.Address_Line_2__c = address.Address_Line_2__c;
                        secaddr.City__c = address.City__c;
                        secaddr.State__c = address.State__c;
                        secaddr.County__c = address.County__c;
                        secaddr.Zip_Code__c = address.Zip_Code__c;
                        secaddr.Secure_Phone__c = address.Secure_Phone__c;
                        secaddr.Secure_Fax__c = address.Secure_Fax__c;
                        secaddr.Provider_Address_AD_Status__c = address.Provider_Address_AD_Status__c;
                        secaddr.Address_Mailability_Score__c = address.Address_Mailability_Score__c;
                        secaddr.Address_Result_Percentage__c = address.Address_Result_Percentage__c;
                        secaddr.AD_Address_Verification_Status__c = address.AD_Address_Verification_Status__c;
                        secaddr.AD_Element_Result_status__c = address.AD_Element_Result_status__c;
                        secaddr.Tech_Is_Address_Verified__c = address.Tech_Is_Address_Verified__c;
                        secaddr.Tech_Is_Address_Updated__c = true;
                        secaddr.Tech_Bypass_Address_Verification__c = address.Tech_Bypass_Address_Verification__c; // Added on 21/12/2016 to Override the Address Verification
                    }
                    secAddrList.add(secaddr);
                }
            }
            if(!secAddrList.isEmpty()){
                SecondaryAddrList = new List<Provider_Address__c>();
                SecondaryAddrList = secAddrList.clone();
            }
        }
        tempsecondaryAddrMap = new Map<String, Provider_Address__c>();
        if(!SecondaryAddrList.isEmpty()){
            for(Provider_Address__c secaddr : SecondaryAddrList){
                tempsecondaryAddrMap.put(secaddr.Serial_Number__c, secaddr);
            }
        }
        if(reordermode == false){
            showReorderBtnFlag = showReorderButton(SecondaryAddrList);
        }
        if(primaryAddrObj == null && SecondaryAddrList.isEmpty()){ 
            showNewButtonFlag = true;
        }else if(primaryAddrObj != null && SecondaryAddrList.isEmpty()){
            showNewButtonFlag = true;
        }else{
            showNewButtonFlag = showNewButton(SecondaryAddrList);
        }
    }
    // Address Related logic Ends 
    
    
    public class WrProviderDetails {
        public string strProviderId {get; set;}
        public string recordId {get;set;}
        public boolean isSelected {get;set;}
        public string strEmail {get;set;}
        public string strFirstName {get; set;}
        public string strMiddleName {get; set;}
        public string strLastName {get; set;}
        public String strProviderTitle {get; set;}
        public string strProviderStatus {get; set;}
        public boolean strPracticingPhysician{get; set;}
        public boolean strResignedFromSutter{get; set;}
        public boolean strResignedProvider_refer {get; set;}
        public boolean strRetired{get; set;}
        public string strCommunicationPref {get; set;}
        public string strCommunicationHIM {get; set;}
        public String strPDICampaign{get;set;}
        public string strProviderAccessType {get; set;}
        public string strProviderType {get; set;}
        public string strSpeciality {get; set;}
        public string strDepartment {get; set;}
        public string strMobilePhone {get; set;}
        public boolean strOktoText {get; set;}
        public string strGender {get; set;}
        public string strMedicalEducation {get; set;}
        public string strWebsiteAddress {get; set;}
        public string strHospitalAff {get; set;}
        public string strMedicalAff {get; set;}
        public string strInternship {get; set;}
        public string strResidency {get; set;}
        public string strSpokenLanguages {get; set;}
        public string strCommActivities {get; set;}
        public string strPersonalInterests {get; set;}
        public string strProfessionalInterests {get; set;}
        public string strOnlineServices {get; set;}
        public string strBoardCertifications {get; set;}
        public string strPublications {get; set;}
        public string strAdditionalInfo {get; set;}
        public string strPhilosophyCare {get; set;}
        public String strAdminAssistantTitle{get;set;}
        public string strAdminAssistant {get; set;}
        public string strAdminAssistantEmail {get; set;}
        public string strAdminAssistantPhone {get; set;}
        public string strAdminAssistantPhoneExt {get; set;}
        public string strsumConId {get; set;}
        public string strProviderNPI {get; set;}
        public string lastValidatedDate {get;set;}
        public string isValidated {get;set;}
        public string lastmodifiedDate {get;set;}
        public string lastmodifiedBy {get;set;}
        public string strNameChangesSugg {get;set;}
        public boolean strDeclineFax{get;set;}
        public boolean strDeclinePhone{get;set;}
        public boolean strDeficiencyProvider{get; set;}
        
        public string strSerialNumber {get; set;}
        public string strStreetAddress {get;set;}
        public string strAddressLine1 {get;set;}
        public string strAddressLine2 {get;set;}
        public string strSuite {get;set;}
        public string strFloor {get;set;}
        public string strPhone {get;set;}
        public string strPhoneExt {get;set;}
        public string strFax {get;set;}
        public string strCity {get;set;}
        public string strstate {get;set;}
        public string strZipCode {get;set;}
        public string straddressType {get;set;}
        public string strAddrMailabilityScore {get;set;}
        public string strAddrProcessStatus {get;set;}
        public string strAddrResultPercent {get;set;}
        public string strAddressStatus {get;set;}
        public string strAddrUniqueIdentifier {get;set;}
        public string strAddrVerificationStatus {get;set;}
        public string strAddressModified {get;set;}
        public boolean strPatientFacing {get;set;}
        public string strDirectAddress {get;set;}
        public string strEmailStatusNumber {get;set;}
        public string strEmailStatusDescription {get;set;}
        public string strEmailHygeineResult {get;set;}
        public string strEmailVerificationError {get;set;}
    }
    /*
Method Name: patterMatcherEmail
Input Param: String
Return type: Boolean
Description: This method is used to check the entered Email Address against a particular Regular Expression
*/ 
    public boolean patterMatcherEmail(string value) {
        Pattern MyPattern = Pattern.compile('^[0-9a-zA-Z]+([0-9a-zA-Z]*[-._+])*[0-9a-zA-Z]+@[0-9a-zA-Z]+([-.][0-9a-zA-Z]+)*([0-9a-zA-Z]*[.])[a-zA-Z]{2,6}$');
        Matcher MyMatcher = MyPattern.matcher(value);
        return MyMatcher.matches();
    }
    
    /*
Method Name: patterMatcherPOBoxStart
Input Param: String
Return type: Boolean
Description: This method is used to check the entered Care Of against a particular Regular Expression
*/ 
    public boolean patterMatcherCareOf(string value) {
        if(value.containsIgnoreCase('Care Of') || value.containsIgnoreCase('C\\O') || value.containsIgnoreCase('D\\O') || value.containsIgnoreCase('S\\O')) {
            return true;
        }
        return false;
    }
    
    /*
Method Name: closeProvider
Input Param: N/A
Return type: void
Description: used to refresh the provider status on close
*/
    public void updateProviderOnClose(){
        refreshProviderList();
        if(selectedPage != null){
            this.setCon.setpageNumber(selectedPage);    
        }
    }
    /*
Method Name: refreshProviderList
Input Param: N/A
Return type: void
Description: getting providers list by phone number
*/
    public void refreshProviderList(){
        summaryList = new List<Contact_Validation_Summary__c>();
        //Querying summary records to refresh and display with pagination
        summaryList = [Select Id, Contact_Id__r.ServiceTabLabel__c, Provider_LastName__c, Secure_Phone__c, Tech_Phone_Number__c, Email__c, Provider_NPI_F__c, 
                       Provider_ID__c, Status__c, Associated_Case_Closed__c, Associated_Case_Id__r.Id, Owner.Name From Contact_Validation_Summary__c 
                       Where Tech_Phone_Number__c =: phoneNumber And PDI_Campaign__c = :Label.CL176_PDI_Current_Campaign_Name Order By Provider_LastName__c];
        this.setCon = new ApexPages.StandardSetController(summaryList);
        this.setCon.setPageSize(15);
    }
    
    /*
Method Name: getProvidersList
Input Param: N/A
Return type: List<Contact_Validation_Summary__c>
Description: Initialize setCon and return a list of records for pagination
*/
    public List<Contact_Validation_Summary__c> getProvidersList() {
        List<Contact_Validation_Summary__c> providerList = new List<Contact_Validation_Summary__c>();
        providerList = setCon.getRecords();
        return providerList;
    }
    
    /*
*   advance to next page
*/
    public Pagereference doNext(){
        if(this.setCon.getHasNext()){
            this.setCon.next();
        }
        return null;
    }
    
    /*
*   advance to previous page
*/
    public Pagereference doPrevious(){
        if(this.setCon.getHasPrevious()){
            this.setCon.previous();
        }
        return null;
    }
    
    /*
*   advance to first page
*/
    public Pagereference doFirst(){
        this.setCon.first();
        return null;
    }
    
    /*
*   advance to last page
*/
    public Pagereference doLast(){
        this.setCon.last();
        return null;
    }
    
    /*
*   return whether previous page exists
*/
    public Boolean getHasPrevious(){
        return this.setCon.getHasPrevious();
    }
    
    /*
*   return whether next page exists
*/
    public Boolean getHasNext(){
        return this.setCon.getHasNext();
    }
    
    /*
*   return page number
*/
    public Integer getPageNumber(){
        return this.setCon.getPageNumber();  
    }
    
    /*
*    return total pages
*/
    public Integer getTotalPages(){
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
        Decimal pages = totalSize/pageSize;
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
}