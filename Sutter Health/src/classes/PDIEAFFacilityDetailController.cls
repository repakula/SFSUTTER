/*****************************************************
Class Name: PDIEAFFacilityDetailController 
Created By: Nagarjuna Kaipu
Created Date: 11/03/2016
Description: This class is used to validate the facility details
*****************************************************/
public class PDIEAFFacilityDetailController {
    public String caseId {get;set;}
    public String EAFId {get; set;}
    public String strCaseContactPhoneNumber {get;set;}
    public String selectedRecord{get;set;}
    public string caseStatus {get;set;}
    public string successMsg {get; set;}
    public string caseSuccessMsg {get; set;}
    public String strSpace = ' ';
    
    public boolean isNewCase {get; set;}
    public boolean isEAFInQueue {get; set;}
    public boolean isValidate {get; set;}
    public boolean isAddressValidated {get; set;}
    public boolean isAddressDoctorValidFields {get;set;}
    public Boolean suggestedAddressFlag{get;set;}
    public boolean addressline2ErrorFlag {get;set;}
    public Boolean byPassAddressVerificationFlag{get;set;} // Added on 21/12/2016 to Override the Address Verification
    public Boolean byPassAddressControlFlag{get;set;} // Added on 21/12/2016 to Override the Address Verification
    public List<SelectOption> statePkList {get;set;}
    
    public PDV_EAF_Facility__c EAF {get; set;}
    public List<PDV_EAF_Facility__c> suggestedAddressList{get;set;}
    public List<PDV_EAF_Validation_Audit_Trail__c> auditAddressHistory {get; set;}
    public List<PDV_EAF_Validation_Audit_Trail__c> auditChangeHistory {get; set;}
    public Case caseObj {get;set;}
    public List<Case> inquirySummary {get; set;}
    public List<PDI_Address_Verification.addressAD> verifiedAddressList{get;set;}
    
    public Set<String> processCodes{get;set;}
    public Set<String> correctAddrCodeSet{get;set;}
    public Set<String> verifiedAddrCodeSet{get;set;}
    public Map<String,String> addressNotProcessedStatusMap{get;set;}
    public Map<String,String> addressWebserviceStatusMap{get;set;}
    public Map<String, String> resultStatusMap{get;set;}
    public Map<Integer, String> statusMap{get;set;}
    
    /*Constructor to initialise*/
    public PDIEAFFacilityDetailController(ApexPages.StandardController con){
        EAFId = ApexPages.currentPage().getParameters().get(Label.CL448_PDIEAFId);
        statusMap = new Map<Integer, String>();
        resultStatusMap = new Map<String, String>();
        processCodes = new Set<String>();
        correctAddrCodeSet = new Set<String>();
        verifiedAddrCodeSet = new Set<String>();
        addressNotProcessedStatusMap = new Map<String, String>();
        addressWebserviceStatusMap = new Map<String, String>();
        auditAddressHistory = new List<PDV_EAF_Validation_Audit_Trail__c>();
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
        if(String.isBlank(EAFId)){
            EAFId = con.getId(); 
        }
    }
    
    /*
*Method Name: checkAllparameters
*Input Param: N/A
*Return type: PageReference
*Description: This is used to set all the parameters
*/
    public PageReference checkAllparameters() {
        try {
            caseStatus = strSpace;
            if(!string.isBlank(EAFId)) {
                getFacilityInfo();
                getStatePicklistVal();
                RetrieveCase();
                getCaseList();
            }
            if(!string.isBlank(caseId)) {
                //Querying case details
                caseObj =  [Select Id, ownerId, Provider_Id_EAF_ID__c, casenumber,Provider_Name__c, Provider_Type__c, PDV_Contact_Name__c, Contact_Number__c,
                            Validated_or_not__c, Direct_Talk_to_Provider__c, Owner.Name, status,Origin, Common_Subject_Lines__c, subject,description, Close_Reason__c, 
                            CreatedDate, CreatedBy.Name,Internal_Comments__c, 
                            (Select Id, Address_Line_1__c, City__c, State__c, Zip_Code__c, Phone__c, Fax_Number__c, Phone_Extension__c, 
                             Address_Modified__c, lastmodifieddate From EAF_Validation_Audit_Trails__r)  
                            From Case Where Id = :caseId];
                caseStatus = caseObj.status;
                if(caseObj.Contact_Number__c != null)
                {
                    strCaseContactPhoneNumber = caseObj.Contact_Number__c != null ? FormatPhone(String.valueOf(caseObj.Contact_Number__c)) : strSpace;
                }
            }
            else{
                caseId = null;
            }
            fillCaseAddressHistory();
        }catch(Exception ex){
            Utility.handleExceptionFromCode(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN); return null;
        }
        return null;
    }
    
    /*
*Method Name: getProviderInfo
*Input Param: N/A
*Return type: void
*Description: This is used to get contact info 
*/
    public void getFacilityInfo() {
        isNewCase = false;
        EAF = new PDV_EAF_Facility__c();
        byPassAddressVerificationFlag = false;
        // Added on 21/12/2016 to Override the Address Verification Custom Setting Code Starts
        PDI_Bypass_AddressVerification__c flag = PDI_Bypass_AddressVerification__c.getInstance('ByPassAddressVerificationInEAF');
        byPassAddressVerificationFlag = flag.byPassValue__c;
        //Querying Facility information
        EAF = [Select Id, Name, Facility_ID__c, External__c, Emp_Id__c, ADDRESS__c, Address_Line_1__c, Address_Line_2__c ,Suite__c, Floor__c, CITY__c, 
               STATE__c, ZIP_CODE__c, PHONE__c, Decline_Phone__c, Phone_Extension__c, FAX_NUMBER__c, Decline_Fax__c, Names_Changes_Suggested__c, 
               Address_Modified__c, Is_Address_Chagned__c, Is_Address_Line_2_Changed__c, Is_City_Changed__c, Is_State_Changed__c, Is_Zip_Code_Changed__c,
               Is_Phone_Changed__c, Is_Phone_Extension_Changed__c, Is_Fax_Changed__c,
               Last_Verified_date__c, Status__c, Owner.Name, Case__c, Tech_is_Facility_Updated__c, Tech_ByPass_Address_Verification__c From PDV_EAF_Facility__c Where Id =: EAFId];
        caseId = EAF.Case__c;
        isEAFInQueue = false;
        if(String.valueOf(EAF.Owner.Name) == Label.CL445_PDINonValidatedFacilityQueue || caseId == null){
            isEAFInQueue = true;   
        }
        if(EAF.Tech_ByPass_Address_Verification__c == true){
            byPassAddressControlFlag = true;
        }
        if(byPassAddressVerificationFlag == true){
            EAF.Tech_ByPass_Address_Verification__c = true;
            byPassAddressControlFlag = true;
        }
        if(byPassAddressControlFlag == true){
            EAF.Tech_ByPass_Address_Verification__c = true;
        }
        
        //Querying facility address history
        auditAddressHistory = [Select Id, Name, Facility_ID__c, ADDRESS__c,Suite__c, Floor__c, CITY__c, STATE__c, ZIP_CODE__c, PHONE__c, 
                               FAX_NUMBER__c, Address_Modified__c, Last_Verified_date__c, LastModifiedDate, LastModifiedBy.Name From PDV_EAF_Validation_Audit_Trail__c Where EAF_Facility__c = :EAFId Order By Id Desc];
    
    }
    
    /*
*Method Name: createCase
*input Param: N/A
*return type: void
*Description: To create new case or to retrieve the existing open case based on the phone number 
*/
    public void createCase() {
        if(caseId == null || isNewCase == true){
            caseSuccessMsg = strSpace;
            strCaseContactPhoneNumber = strSpace;
            caseObj = new Case();
            List<Case> caseList = new  List<Case>();
            //Querying the existing case based on the phone number
            caseList = [Select OwnerId, casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,
                        Validated_or_not__c,Direct_Talk_to_Provider__c,status,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, 
                        Provider_Assigned_Date__c, subject,description,CreatedBy.Name,owner.Name From Case 
                        Where Id =: caseid And Status !=: Label.CL384_PDICaseSatusClosed Order By CaseNumber Desc Limit 1];
            if(caseList.isEmpty()){
                caseObj.subject = Label.CL385_PDICaseInitialSubject;
                caseObj.recordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(Label.CL446_PDISummaryOfCareCaseRecType).RecordTypeId;
                caseObj.origin = Label.CL387_PDICaseOutboundCall;
                caseObj.Common_Subject_Lines__c = Label.CL549_PDIEAFValidatedSubject;
                if(!String.isBlank(EAF.PHONE__c)){
                    caseObj.Contact_Number__c = Decimal.valueOf(EAF.PHONE__c.replaceAll('[^0-9]',''));
                    strCaseContactPhoneNumber = ProvidersByPhoneNumberHelper.FormatPhone(EAF.PHONE__c);
                }
                caseObj.Provider_Assigned_Date__c = System.now();
                caseObj.EAF_Facility__c = EAFId;
                insert caseObj;
                caseId = caseObj.Id;
                //Querying case to get the case details based on the case id
                caseObj = [Select OwnerId, casenumber,Close_Reason__c,Provider_Name__c, Facility_Name__c, Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                           status,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, Provider_Assigned_Date__c,
                           subject,description,CreatedBy.Name,owner.Name From Case Where Id =: caseId];
                if(!String.isBlank(EAF.PHONE__c)){
                    strCaseContactPhoneNumber = ProvidersByPhoneNumberHelper.FormatPhone(String.ValueOf(caseObj.Contact_Number__c));
                }
                caseStatus = caseObj.Status;
            }
            isNewCase = false;
            PDV_EAF_Facility__c eafObj = new PDV_EAF_Facility__c(Id = EAFId);
            eafObj.ownerId = UserInfo.getUserId();
            eafObj.Status__c = Label.CL186_PDI_Accepted_Status;
            eafObj.Case__c = caseId;
            eafObj.Assigned_Date__c = System.now();
            update eafObj;
            isEAFInQueue = false;
            getCaseList();
            fillCaseAddressHistory();
            isAddressValidated = false;
        }
    }
    
    /*
*Method Name: statePkList
*Input Param: N/A
*Return type: void
*Description: This is used to get state list. 
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
    
    /*
*Method Name: retrieveCase
*input Param: N/A
*return type: void
*Description: To retrieve the existing open cases based on facility 
*/
    public void retrieveCase(){
        caseSuccessMsg = strSpace;
        strCaseContactPhoneNumber = strSpace;
        caseObj = new Case();
        List<Case> caseList = new  List<Case>();
        //Querying the existing case based on the phone number
        caseList = [Select OwnerId, casenumber,Close_Reason__c,PDV_Contact_Name__c, Facility_Name__c, Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                    status,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, Provider_Assigned_Date__c,
                    subject,description,CreatedBy.Name,owner.Name From Case Where Id =: caseId];
        if(!caseList.isEmpty()){
            caseId = caseList[0].Id;
            isNewCase = false;
            //Querying case to get the case details based on the 
            caseObj = [Select OwnerId, casenumber,Close_Reason__c,Provider_Name__c, Facility_Name__c, Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                       status,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, Provider_Assigned_Date__c,
                       subject,description,CreatedBy.Name,owner.Name From Case Where Id =: caseId];
            strCaseContactPhoneNumber = ProvidersByPhoneNumberHelper.FormatPhone(String.ValueOf(caseObj.Contact_Number__c));
        }
        if(caseList.isEmpty() || caseObj.Status == Label.CL447_PDIEAFCaseClosed){
            isNewCase = true;
        }
    }
    /*
Method Name: updateCase
Input Param: N/A
Return type: PageReference
Description: This method is used to update case
*/
    public PageReference updateCase() {
        caseStatus = strSpace;
        isValidate = false;
        successMsg = strSpace;
        boolean isCaseValidated =  true;
        if(caseObj.Status == Label.CL447_PDIEAFCaseClosed && isAddressValidated != true){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL449_PDIEAFValidateBeforeCaseClose));
            isCaseValidated = false;
        }
        if(String.isBlank(caseObj.PDV_Contact_Name__c)) {
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
        if(String.isBlank(caseObj.Common_Subject_Lines__c) || caseObj.Common_Subject_Lines__c == Label.CL426_PDIPickListNone || caseObj.Common_Subject_Lines__c == Label.CL424_PDINone) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL400_PDICaseFillSubject));
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
        caseObj.Contact_Number__c = Decimal.valueOf(strCaseContactPhoneNumber.replaceAll('[^0-9]',''));
        caseObj.Facility_Name__c = EAF.Name;
        update caseObj;
        fillCaseAddressHistory();
        if(caseObj.Status == Label.CL447_PDIEAFCaseClosed){
            caseStatus = Label.CL447_PDIEAFCaseClosed;
            EAF.Status__c = Label.CL458_PDIEAFValidated;
            EAF.Closed_Date__c = System.now();
            Update EAF;
            isNewCase = true;
        }
        caseSuccessMsg = Label.CL413_CaseSaveMessage;
        return null;
    }
    
    /*
Method Name: getCaseLst
Input Param: N/A
Return type: List of cases
Description: This is used to get all cases per facility 
*/
    public List<Case> getCaseList() {
        inquirySummary = new List<Case>();
        //Querying to get the list of cases associated to facility
        inquirySummary = [Select OwnerId, casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,
                          Validated_or_not__c,Direct_Talk_to_Provider__c,status,Origin,Common_Subject_Lines__c, EAF_Facility__c,
                          subject,description,CreatedBy.Name,owner.Name, CreatedDate From Case 
                          Where EAF_Facility__c =: EAFId Order By CaseNumber Desc];
        return inquirySummary;
    }
    
    /*
Method Name: fillCaseAddressHistory
Input Param: N/A
Return type: void
Description: This method is used to fill the facility audit history based on the case id
*/
    public void fillCaseAddressHistory() {
        auditChangeHistory = new List<PDV_EAF_Validation_Audit_Trail__c>();
        //Querying audit inquiry change log
        auditChangeHistory = [Select Id, Name, Address_Change__c, Address_Modified__c, Last_Verified_date__c,  CreatedBy.Name, LastModifiedDate, 
                              LastModifiedBy.Name From PDV_EAF_Validation_Audit_Trail__c Where Case__c = :caseId And Last_Verified_date__c != null Order By Id Desc];
    }
    
    /*
Method Name: saveUpdatedAddress
Input Param: N/A
Return type: PageReference
Description: This method is used to save/update address
*/
    public PageReference saveUpdatedAddress() {
        try{
            isValidate = true;
            successMsg = strSpace;
            isAddressValidated = true;
            if(String.isBlank(EAF.Address_Line_1__c)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL450_PDIFillEAFAddressLine1));
                isAddressValidated = false;
            }
            else if(patterMatcherCareOf(EAF.Address_Line_1__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL271_PDI_streetAddressPattern));
                isAddressValidated = false;
            }
            if(String.isBlank(EAF.CITY__c)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL451_PDIEAFFillCity));
                isAddressValidated = false;
            }
            if(EAF.STATE__c == Label.CL463_PDIEAFNone){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL452_PDIEAFFillState));
                isAddressValidated = false;
            }
            if(String.isBlank(EAF.ZIP_CODE__c)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL453_PDIEAFFillZipCode));
                isAddressValidated = false;
            }
            if(String.isBlank(EAF.PHONE__c) && EAF.Decline_Phone__c == false){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL454_PDIEAFFllPhoneNumber));
                isAddressValidated = false;
            }
            if(String.isBlank(EAF.FAX_NUMBER__c) && EAF.Decline_Fax__c == false){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL455_PDIEAFFillFaxNumber));
                isAddressValidated = false;
            }
            if(isAddressValidated == false){
                return null;
            }
            Integer auditCount = [Select Count() From PDV_EAF_Validation_Audit_Trail__c Where EAF_Facility__c = :EAFId];
            //Querying existing facility address information
            PDV_EAF_Facility__c oldEAF = [Select Id, Name, Facility_ID__c, Emp_Id__c, Address_Line_1__c, Address_Line_2__c, ADDRESS__c, CITY__c, STATE__c, ZIP_CODE__c, PHONE__c, Decline_Phone__c, Phone_Extension__c, 
                                          FAX_NUMBER__c, Decline_Fax__c, Names_Changes_Suggested__c, Last_Verified_date__c, Status__c, Owner.Name, Case__c,Tech_ByPass_Address_Verification__c From PDV_EAF_Facility__c Where Id =: EAFId];
            
            if(oldEAF.PHONE__c != null){
                oldEAF.PHONE__c = FormatPhone(oldEAF.PHONE__c);  
            }
            if(oldEAF.FAX_NUMBER__c != null){
                oldEAF.FAX_NUMBER__c = FormatPhone(oldEAF.FAX_NUMBER__c);  
            }
            EAF.ADDRESS__c = EAF.Address_Line_1__c + strSpace + EAF.Address_Line_2__c;
            if((EAF.ADDRESS__c != OldEAF.ADDRESS__c) || (EAF.CITY__c != OldEAF.CITY__c) || (EAF.STATE__c != OldEAF.STATE__c) || (EAF.ZIP_CODE__c != OldEAF.ZIP_CODE__c)){
                   EAF.Address_Modified__c = Label.CL456_PDIEAFModifiedYes;
               }
            else{
                EAF.Address_Modified__c = Label.CL457_PDIEAFModifiedNo;
            }
            if(byPassAddressControlFlag == true){
                EAF.Tech_ByPass_Address_Verification__c = true;
            }
            else{
              EAF.Tech_ByPass_Address_Verification__c = false;  
            }
            EAF.Tech_is_Facility_Updated__c = false;
            EAF.Last_Verified_date__c = System.today();
            EAF.Status__c = Label.CL458_PDIEAFValidated;
            EAF.OwnerId =  UserInfo.getUserId();
            EAF.Case__c = caseId;
            EAF.Tech_ByPass_Address_Verification__c = byPassAddressControlFlag;
            update EAF;
            isAddressValidated = true;
            if(auditCount == 0){
                PDV_EAF_Validation_Audit_Trail__c auditExist = new PDV_EAF_Validation_Audit_Trail__c();
                auditExist.EAF_Facility__c = EAFId;
                auditExist.Name = oldEAF.Name;
                auditExist.Case__c = caseId;
                auditExist.Serial_Number__c = Label.CL464_PDIEAFSerialNumber1;
                auditExist.Facility_ID__c = oldEAF.Facility_ID__c;
                auditExist.ADDRESS__c = oldEAF.ADDRESS__c;
                auditExist.Address_Line_1__c = oldEAF.Address_Line_1__c;
                auditExist.Address_Line_2__c = oldEAF.Address_Line_2__c;
                auditExist.CITY__c = oldEAF.CITY__c;
                auditExist.STATE__c = oldEAF.STATE__c;
                auditExist.ZIP_CODE__c = oldEAF.ZIP_CODE__c;
                auditExist.PHONE__c = oldEAF.PHONE__c;
                auditExist.FAX_NUMBER__c = oldEAF.FAX_NUMBER__c;
                auditExist.Phone_Extension__c = oldEAF.Phone_Extension__c;
                auditExist.Names_Changes_Suggested__c = oldEAF.Names_Changes_Suggested__c;
                auditExist.Sent_to_MDM__c = Label.CL459_PDIEAFMDMNA;
                //inserting initial facility info into audit object
                insert auditExist;
            }
            else{
                List<PDV_EAF_Validation_Audit_Trail__c> auditExList = new List<PDV_EAF_Validation_Audit_Trail__c>();
                //Querying and Updating existing audit records to N/A
                for(PDV_EAF_Validation_Audit_Trail__c audiExist: [Select Id, Sent_to_MDM__c From PDV_EAF_Validation_Audit_Trail__c Where EAF_Facility__c = :EAFId]){
                    audiExist.Sent_to_MDM__c = Label.CL365_PDI_NA;
                    auditExList.add(audiExist);
                }
                //Updating existing audit object records to N/A 
                update auditExList;
            }
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.EAF_Facility__c = EAF.Id;
            auditObj.Name = EAF.Name;
            auditObj.Case__c = caseId;
            auditObj.Serial_Number__c = Label.CL464_PDIEAFSerialNumber1;
            auditObj.Facility_ID__c = EAF.Facility_ID__c;
            auditObj.Address_Line_1__c = EAF.Address_Line_1__c;
            auditObj.Address_Line_2__c = EAF.Address_Line_2__c;
            auditObj.ADDRESS__c = EAF.Address_Line_1__c + strSpace + EAF.Address_Line_2__c;
            auditObj.CITY__c = EAF.CITY__c;
            auditObj.STATE__c = EAF.STATE__c;
            auditObj.ZIP_CODE__c = EAF.ZIP_CODE__c;
            auditObj.PHONE__c = EAF.PHONE__c;
            auditObj.FAX_NUMBER__c = EAF.FAX_NUMBER__c;
            auditObj.Phone_Extension__c = EAF.Phone_Extension__c;
            auditObj.Names_Changes_Suggested__c = EAF.Names_Changes_Suggested__c;
            auditObj.Address_Modified__c = EAF.Address_Modified__c;
            auditObj.Verified_By__c = UserInfo.getUserId();
            auditObj.Last_Verified_date__c = System.today();
            auditObj.Sent_to_MDM__c = '';
            
            //Inquiry log
            string strLog = strSpace;
            strLog = strLog + Label.CL460_PDIEAFFacilityNameLog + strSpace + auditObj.Name + Label.CL283_PDI_singleBreak;
            if(auditObj.address_modified__c == Label.CL261_PDI_Yes){
                strLog = strLog + Label.CL187_PDI_Validated_Status + strSpace + Label.CL281_PDI_AT+ strSpace + system.now().format() + Label.CL284_doubleBreak;
            }else if(auditObj.address_modified__c == Label.CL262_PDI_No){
                strLog = strLog + Label.CL187_PDI_Validated_Status + strSpace + Label.CL281_PDI_AT+ strSpace + system.now().format();
            }
            
            if(EAF.Address_Line_1__c != oldEAF.Address_Line_1__c) {
                strLog  = strLog + Label.CL288_PDI_Log_Address1 + Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + oldEAF.Address_Line_1__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + EAF.Address_Line_1__c + Label.CL284_doubleBreak; 
            }
            if((String.isNotBlank(EAF.Address_Line_2__c) || String.isNotBlank(oldEAF.Address_Line_2__c)) && EAF.Address_Line_2__c != oldEAF.Address_Line_2__c) {
                strLog  = strLog + Label.CL289_PDI_Log_Address2 + Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + oldEAF.Address_Line_2__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + EAF.Address_Line_2__c + Label.CL284_doubleBreak; 
            }
            if(EAF.City__c != oldEAF.City__c) {
                strLog  = strLog + Label.CL287_PDI_Log_City + Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + oldEAF.City__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + EAF.City__c + Label.CL284_doubleBreak; 
            }
            if((EAF.State__c != oldEAF.State__c)) {
                strLog  = strLog + Label.CL291_PDI_Log_State +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + oldEAF.State__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + EAF.State__c + Label.CL284_doubleBreak; 
            }
            if(EAF.Zip_Code__c != oldEAF.Zip_Code__c) {
                strLog  = strLog + Label.CL290_PDI_Log_ZipCode +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + oldEAF.Zip_Code__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + EAF.Zip_Code__c + Label.CL284_doubleBreak; 
            }
            if((EAF.Phone__c != oldEAF.Phone__c) && (!String.isBlank(EAF.Phone__c) || !String.isBlank(oldEAF.Phone__c))) {
                strLog  = strLog + Label.CL292_PDI_Log_Phone +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + oldEAF.Phone__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + EAF.Phone__c + Label.CL284_doubleBreak; 
            }
            if((EAF.Phone_Extension__c != oldEAF.Phone_Extension__c) && (!String.isBlank(EAF.Phone_Extension__c) || !String.isBlank(oldEAF.Phone_Extension__c))) {
                strLog  = strLog + Label.CL461_PDIEAFFacilityPhoneExtLog +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + oldEAF.Phone_Extension__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + EAF.Phone_Extension__c + Label.CL284_doubleBreak; 
            }
            if((EAF.FAX_Number__c != oldEAF.FAX_Number__c) && (!String.isBlank(EAF.FAX_Number__c) || !String.isBlank(oldEAF.FAX_Number__c))) {
                strLog  = strLog + Label.CL293_PDI_Log_Fax +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + oldEAF.FAX_Number__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + EAF.FAX_Number__c + Label.CL284_doubleBreak; 
            }
            if((EAF.Names_Changes_Suggested__c != oldEAF.Names_Changes_Suggested__c) && (!String.isBlank(EAF.Names_Changes_Suggested__c) || !String.isBlank(oldEAF.Names_Changes_Suggested__c))) {
                strLog  = strLog + strSpace + Label.CL418_PDINameChangesSuggested + strSpace +  Label.CL283_PDI_singleBreak +
                    Label.CL285_PDI_From + strSpace + oldEAF.Names_Changes_Suggested__c + Label.CL283_PDI_singleBreak +
                    Label.CL286_PDI_To + strSpace + EAF.Names_Changes_Suggested__c + Label.CL284_doubleBreak; 
            }
            auditObj.Address_Change__c = strLog;
            //Inserting into audit object
            insert auditObj;
            strLog = strSpace;
            successMsg = Label.CL462_PDIEAFSuccessMessage;
            
            getFacilityInfo();
            fillCaseAddressHistory();
            addressline2ErrorFlag = false;
        }catch(Exception classException){
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN); return null;
        }
        return null;
    }
    /**
* Name      : patterMatcherCareOf
* description : This method is used to check the entered Care Of against a particular Regular Expression
* param       : String
* return      : Boolean
*/
    public boolean patterMatcherCareOf(string value) {
        if(value.containsIgnoreCase('Care Of') || value.containsIgnoreCase('C\\O') || value.containsIgnoreCase('D\\O') || value.containsIgnoreCase('S\\O')) {
            return true;
        }
        return false;
    }
    /*
* Method Name: findSuggestedAddress
* description  :   This method is used to invoke Address doctor service and display suggested Addresses.
* param        :   N/A
* return       :   PageReference
*/
    public PageReference findSuggestedAddress(){
        isValidate = true;
        successMsg = strSpace;
        caseStatus = strSpace;
        EAF.Status__c = Label.CL186_PDI_Accepted_Status;
        isAddressValidated = true;
        isAddressDoctorValidFields = true;
        addressline2ErrorFlag = false;
        suggestedAddressList = new List<PDV_EAF_Facility__c>();
        
        try{
            if(string.isBlank(EAF.Address_Line_1__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL450_PDIFillEAFAddressLine1));
                isAddressValidated = false;
            }
            if(string.isBlank(EAF.City__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL451_PDIEAFFillCity));
                isAddressValidated = false;
            }
            if(string.isBlank(EAF.State__c) || EAF.State__c == Label.CL259_PDI_None) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL452_PDIEAFFillState));
                isAddressValidated = false;
            }
            if(string.isBlank(EAF.Zip_Code__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL453_PDIEAFFillZipCode));
                isAddressValidated = false;
            }
            if(string.isBlank(EAF.Phone__c) && EAF.Decline_Phone__c == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL454_PDIEAFFllPhoneNumber));
                isAddressValidated = false;
            } else if(!string.isBlank(EAF.Phone__c)) {
                if(!string.isBlank(EAF.Phone__c) && (EAF.Phone__c.length() < 14 || EAF.Phone__c.length() > 14)) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL273_PDI_InvalidPhone));
                    isAddressValidated = false;
                }
            }
            if(!String.isBlank(EAF.Phone_Extension__c) && !EAF.Phone_Extension__c.isNumeric()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL279_PDI_NumericExt));
                isAddressValidated = false;
            }
            if(string.isBlank(EAF.Fax_Number__c) && EAF.Decline_Fax__c == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL455_PDIEAFFillFaxNumber));
                isAddressValidated = false;
            } else if(!string.isBlank(EAF.Fax_Number__c) && (EAF.Fax_Number__c.length() < 14 || EAF.Fax_Number__c.length() > 14)) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL275_PDI_InvalidFax));
                isAddressValidated = false;
            }
            if(!isAddressValidated){
                isValidate = true;
                return null;
            }
            suggestedAddressFlag = false;
            if(suggestedAddressFlag == false){
                verifiedAddressList = new List<PDI_Address_Verification.addressAD>();
                Provider_Address__c addressSugg = new Provider_Address__c();
                addressSugg.Formatted_Address__c = EAF.Formatted_Address__c;
                addressSugg.Address_Line1__c = EAF.Address_Line_1__c;
                addressSugg.Address_Line_2__c = EAF.Address_Line_2__c;
                addressSugg.City__c = EAF.City__c;
                addressSugg.State__c = EAF.State__c;
                addressSugg.Zip_Code__c = EAF.Zip_Code__c;
                verifiedAddressList = PDI_Address_Verification.checkProviderAddress(addressSugg);
                if(!verifiedAddressList.isEmpty()){
                    for(PDI_Address_Verification.addressAD adAddress : verifiedAddressList){
                        if(adAddress.errorStatus != null && !String.isBlank(adAddress.errorStatus)){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL557_PDIADServiceText + strSpace +adAddress.errorStatus));
                            isAddressValidated = false;
                            suggestedAddressFlag = false;
                            return null;
                        }else{
                            if(adAddress.addressProcessStatus != null && addressNotProcessedStatusMap.containsKey(adAddress.addressProcessStatus)){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL557_PDIADServiceText + strSpace +addressNotProcessedStatusMap.get(adAddress.addressProcessStatus)));
                                isAddressValidated = false;
                                suggestedAddressFlag = false;
                                return null;
                            }else if(adAddress.addressProcessStatus != null && addressWebserviceStatusMap.containsKey(adAddress.addressProcessStatus)){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL557_PDIADServiceText + strSpace +addressWebserviceStatusMap.get(adAddress.addressProcessStatus)));
                                isAddressValidated = false;
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
                                                  }
                                            }
                                        } 
                                    }
                                    if(!isAddressDoctorValidFields){
                                        return null;
                                    }
                                    PDV_EAF_Facility__c verifiedEAFObj = new PDV_EAF_Facility__c();
                                    for(Provider_Address__c addrObj : adAddress.verifiedProvAddressList){
                                        verifiedEAFObj.Formatted_Address__c = addrObj.Formatted_Address__c;
                                        verifiedEAFObj.Address_Line_1__c = addrObj.Address_Line1__c;
                                        verifiedEAFObj.Address_Line_2__c = addrObj.Address_Line_2__c;
                                        verifiedEAFObj.City__c = addrObj.City__c;
                                        verifiedEAFObj.State__c = addrObj.State__c;
                                        verifiedEAFObj.Zip_Code__c = addrObj.Zip_Code__c;
                                        suggestedAddressList.add(verifiedEAFObj);
                                    }
                                    if(!suggestedAddressList.isEmpty()){
                                        suggestedAddressFlag = true;
                                        isAddressValidated = false;
                                    }   
                                }else{
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL556_UnabletoFindAddress));
                                    isAddressValidated = false;
                                    suggestedAddressFlag = false;
                                    return null;
                                } 
                            }
                        }
                    }
                }
            }
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, strSpace));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN); return null;
        }
        return null;
    }
    
    /*
* Method Name: saveAddress
* Description: used to update the selected AD address
* Input Param: N/A
* Return Type: PageReference
*/
    public PageReference saveAddress(){
        successMsg = strSpace;
        caseStatus = strSpace;
        EAF.Status__c = Label.CL186_PDI_Accepted_Status;
        Provider_Address__c addressSugg = new Provider_Address__c();
        isAddressDoctorValidFields = true;
        addressline2ErrorFlag = false;
        String elementResult = strSpace;
        if(!suggestedAddressList.isEmpty()){
            for(PDV_EAF_Facility__c addr : suggestedAddressList){
                if(addr.Formatted_Address__c == selectedRecord){
                    verifiedAddressList = new List<PDI_Address_Verification.addressAD>();
                    addressSugg.Formatted_Address__c = EAF.Formatted_Address__c;
                    addressSugg.Address_Line1__c = EAF.Address_Line_1__c;
                    addressSugg.Address_Line_2__c = EAF.Address_Line_2__c;
                    addressSugg.City__c = EAF.City__c;
                    addressSugg.State__c = EAF.State__c;
                    addressSugg.Zip_Code__c = EAF.Zip_Code__c;
                    verifiedAddressList = PDI_Address_Verification.checkProviderAddress(addressSugg);
                    if(!verifiedAddressList.isEmpty()){
                        for(PDI_Address_Verification.addressAD adAddress : verifiedAddressList){
                            if(adAddress.errorStatus != null && !String.isBlank(adAddress.errorStatus)){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL557_PDIADServiceText + strSpace +adAddress.errorStatus));
                                isAddressValidated = false;
                                suggestedAddressFlag = false;
                                return null;
                            }else{
                                if(adAddress.addressProcessStatus != null && addressNotProcessedStatusMap.containsKey(adAddress.addressProcessStatus)){
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL557_PDIADServiceText + strSpace + addressNotProcessedStatusMap.get(adAddress.addressProcessStatus)));
                                    isAddressValidated = false;
                                    suggestedAddressFlag = false;
                                    return null;
                                }else if(adAddress.addressProcessStatus != null && addressWebserviceStatusMap.containsKey(adAddress.addressProcessStatus)){
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL557_PDIADServiceText + strSpace + addressWebserviceStatusMap.get(adAddress.addressProcessStatus)));
                                    isAddressValidated = false;
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
                                                        isAddressValidated = false;
                                                        addressline2ErrorFlag = true;
                                                        
                                                    }else {
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL559_PDIAddressContainsText + strSpace + addrValue.substring(0, addrValue.length()-1) + Label.CL560_PDICorrectItText));
                                                        isAddressDoctorValidFields = false;
                                                    }
                                                }
                                            } 
                                        }
                                        for(Provider_Address__c addrObj : adAddress.verifiedProvAddressList){
                                            EAF.Address_Line_1__c = addrObj.Address_Line1__c;
                                            EAF.Address_Line_2__c = addrObj.Address_Line_2__c;
                                            EAF.City__c = addrObj.City__c;
                                            EAF.State__c = addrObj.State__c;
                                            EAF.Zip_Code__c = addrObj.Zip_Code__c;
                                            EAF.AD_Address_Process_Status__c = addrObj.Provider_Address_AD_Status__c;
                                            EAF.AD_Address_Mailability_Score__c = addrObj.Address_Mailability_Score__c;
                                            EAF.AD_Address_Result_Percentage__c = addrObj.Address_Result_Percentage__c;
                                            EAF.AD_Element_Result_status__c = elementResult;
                                        }
                                        if(!isAddressDoctorValidFields){
                                            suggestedAddressFlag = false;
                                            isAddressValidated = false;
                                            return null;
                                        }else{
                                            selectedRecord = strSpace;
                                        }
                                    }else{
                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL556_UnabletoFindAddress));
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
        if(EAF.AD_Address_Process_Status__c != null){
            if(correctAddrCodeSet.contains(EAF.AD_Address_Process_Status__c)){
                EAF.AD_Address_Verification_Status__c = Label.CL475_PDI_ADCorrect;
            }else if(verifiedAddrCodeSet.contains(EAF.AD_Address_Process_Status__c)){
                EAF.AD_Address_Verification_Status__c = Label.CL476_PDI_AD_Verified;
            }else if(processCodes.contains(EAF.AD_Address_Process_Status__c)){
                EAF.AD_Address_Verification_Status__c = Label.CL477_PDI_AD_InCorrect;
            }
        }
        suggestedAddressFlag = false;
        isAddressValidated = false;
        return null;
    } 
    
    /*
* Method Name: overrideAddress
* Description: used to override the address
* Input Param: N/A
* Return Type: PageReference
*/
    public PageReference overrideAddress(){
        return null;
    }
    /*
* Method Name: cancelAddress
* Description: used to return to edit the address
* Input Param: N/A
* Return Type: PageReference
*/
    public PageReference cancelAddress(){
        suggestedAddressFlag = false;
        addressline2ErrorFlag = false;
        isAddressValidated = false;
        EAF.Status__c = Label.CL186_PDI_Accepted_Status;
        caseStatus = caseObj.Status;
        return null;
    }
    //Used to format the phone number into US format
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