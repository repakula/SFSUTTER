/**  
*     Class Name  : SOCCallController
*     Author      : IDC Offshore
*     Date        : 15-04-2015
*     Project Name: SOC Sutter Health
*     Description : SOCCallController Class.
*
**/
public without sharing class SOCCallController {
    
    public List<WrAddressValidation> wrAddressValidationlist {get;set;}
    public string providerId {get;set;}
    //atul
    public boolean isCustInqSaved {get; set;}
    private static final string SOC_SENT_STATUS = 'Sent';
    private static final string CASE_CLOSED_STATUS = 'Closed';
    //print
    private static final string SOC_STATUS_PRINT = 'Print';
    
    public boolean showPleaseValidate {get; set;}
    public string socId {get;set;}
    public string addressRecordId {get;set;}
    public Contact contactInfo {get;set;}
    public PDV_EAF_Facility__c faciltyInfo {get;set;}
    public WrAddressValidation newAddress {get;set;}
    public map<Id,WrAddressValidation> mapAddress {get;set;}
    public List<WrAddressValidation> wrOldAddressLst {get;set;}
    public string prefix {get;set;}
    public Case caseObj {get;set;}
    public List<WrCase> wrCaseLst {get;set;}
    public string caseId {get;set;}
    public string MUCaseStatus {get;set;}
    public List<WRAddressCaseHistory> lstCaseAddressHistory {get;set;}
    public string socStatus {get;set;}
    //print
    public String printedAddressId {get; set;}
    public boolean isViewAddress {get; set;}
    public boolean isPrintAddButton {get; set;}
    public String printSOCName {get; set;}
    
    ApexPages.StandardController controller;
    
    // Constructor
    public SOCCallController(ApexPages.StandardController controller) {
        wrAddressValidationlist = new List<WrAddressValidation>();
        lstCaseAddressHistory = new List<WRAddressCaseHistory>(); 
        this.controller = controller;
        isCancelCaseOk = false;
        isAddressValidated = false;
        isAllAddressValidates = false;
        isAddressValidAllFields = true;
        wrCaseLst = new List<WrCase>();
        providerId = ApexPages.currentPage().getParameters().get('providerId');
        socId = ApexPages.currentPage().getParameters().get('socId');
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        if(string.isBlank(socId)) {
                socId = controller.getId();
                
        }
        isProviderExist = true;
        isSOCExists = true;
        isSOCInQueue = false;
        //atul
        isCustInqSaved = false;
        
        strCaseContactPhoneNumber = '';
        faciltyInfo = new PDV_EAF_Facility__c();
        mapAddress = new map<Id,WrAddressValidation>(); 
        newAddress = new WrAddressValidation();
        contactInfo =  new Contact();
        wrOldAddressLst = new List<WrAddressValidation>();
        caseObj = new Case();
        isCreatingCase = false; 
        phoneCheck = false;
        faxCheck = false;
        //print
        isViewAddress = false;
        isPrintAddButton = false;
        printedAddressId = '';
        printSOCName = '';

    }
    
    /**
    * @author IDC Team
    * @description -- this is used to set all the parameters
    * @param 
    * @return Pagereference
    */
    public boolean isProviderExist {get;set;}
    public boolean isSOCExists {get;set;}
    public boolean isSOCInQueue {get;set;}
    public boolean isSOCAccepted {get;set;}
    
    //Escalate CR
    public boolean isCaseInQueue {get;set;}
    public string caseStatus {get;set;}
    public String loggedInUserRoleName {get;set;}
    
    public PageReference checkAllparameters() {
        try {
                
                isSOCInQueue = false;
                isSOCAccepted = false;
                //Escalate CR START
                isCaseInQueue = false;
                Id userRoleId = UserInfo.getUserRoleId();
                loggedInUserRoleName = [Select Name from UserRole where Id =: userRoleId].Name;
                
                //Escalate CR END
                if(!string.isBlank(socId) && string.isBlank(providerId)) {
                    //print
                        SOC_Queue__c socQueue = [select Name,Provider_Facility_ID__c, Printed_Id__c, Facility_Id__c,OwnerId,Associated_Case_Id__c,owner.Name,status__c,lastmodifiedbyId 
                                                    from SOC_Queue__c where Id =:socId];
                        //print
                        if(!String.isBlank(socQueue.Printed_Id__c)){
                            isViewAddress = true;
                            printedAddressId = socQueue.Printed_Id__c;
                        }
                        if(socQueue.status__c == SOC_SENT_STATUS){
                            isPrintAddButton = true;
                        }
                        printSOCName = socQueue.Name;
                        
                        socStatus = socQueue.status__c;                         
                        caseId = socQueue.Associated_Case_Id__c;
                       
                        if(!String.IsBlank(socQueue.Provider_Facility_ID__c)) {
                                providerId = socQueue.Provider_Facility_ID__c;
                        } else if(!String.IsBlank(socQueue.Facility_Id__c)) {
                                providerId = socQueue.Facility_Id__c;
                        } else {
                                isProviderExist = false;
                                return null;
                        }
                        if(String.valueOf(socQueue.OwnerId).substring(0,3) == '00G' && socQueue.owner.Name != 'Meaningful Use Team') {
                                isSOCInQueue = true;
                        } else  {
                                isSOCInQueue = false;
                        }
                        if(socQueue.status__c == 'Accepted' && socQueue.lastmodifiedbyId != userInfo.getUserId()) {
                            isSOCAccepted = true;
                        }
                        if(socQueue.status__c == 'Sent') {
                            isAllAddressValidates = true;
                        }
                } else if(string.isBlank(socId) && !string.isBlank(providerId)) {
                        isSOCExists = false;
                } else if(!string.isBlank(socId) && !string.isBlank(providerId)) {
                        //print
                        SOC_Queue__c socQueue = [select Name, Provider_Facility_ID__c, Printed_Id__c, Facility_Id__c,OwnerId,owner.Name,Associated_Case_Id__c,status__c,lastmodifiedbyId 
                                                    from SOC_Queue__c where Id =:socId];
                        //print
                        if(!String.isBlank(socQueue.Printed_Id__c)){
                            isViewAddress = true;
                            printedAddressId = socQueue.Printed_Id__c;
                        }
                        if(socQueue.status__c == SOC_SENT_STATUS){
                            isPrintAddButton = true;
                        }
                        printSOCName = socQueue.Name;
                        
                        socStatus = socQueue.status__c;
                        if(socQueue.status__c == 'Sent') {
                            isAllAddressValidates = true;
                        }                           
                        if(String.valueOf(socQueue.OwnerId).substring(0,3) == '00G' && socQueue.owner.Name != 'Meaningful Use Team') {
                            isSOCInQueue = true;
                        }
                        if(socQueue.status__c == 'Accepted' && socQueue.lastmodifiedbyId != userInfo.getUserId()) {
                            isSOCAccepted = true;
                        }
                        caseId = socQueue.Associated_Case_Id__c;
                }
                if(!string.IsBlank(providerId)) {
                    prefix = providerId.substring(0,3);
                    getProviderInfo();
                    getAddressValidation();
                    getCaseLst();
                    getStatePicklistVal();
                    getCaseMUStatus();
                }
                if(!string.isBlank(caseId)) {
                    isCreatingCase = true;
                    caseObj =  [select ownerId, casenumber,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,Owner.Name,
                                status,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c,Communication_Preference_Changed_To_Fax__c,
                                subject,description,Close_Reason__c,CreatedBy.Name,Internal_Comments__c,MU_Escalation_Status__c,MU_Comments__c,
                                (Select ADDRESS__c, CITY__c, STATE__c, ZIP_CODE__c, PHONE__c, FAX_NUMBER__c, Suite__c, Floor__c, Address_Modified__c,lastmodifieddate From EAF_Validation_Audit_Trails__r), 
                                (Select Secure_City__c, Secure_Fax__c, Secure_Phone__c, Secure_State__c, Secure_Street_Address__c, Secure_Zip_Code__c, Secure_Suite__c, Secure_Floor__c, 
                                Secure_Phone_Ext__c, Address_Modified__c,lastmodifieddate From Provider_Validation_Updates__r)     
                                from case where Id = :caseId];
                    caseStatus = caseObj.status;
                    strCaseContactPhoneNumber = caseObj.Contact_Number__c != null ? String.valueOf(caseObj.Contact_Number__c) : ' ';
                    /*List<MU_Object__c> lstMU = [select Case__c,Comments__c,Escalation_Status__c,Status__c from MU_Object__c where Case__c =:caseId limit 1];
                    if(lstMU != null && lstMU.size()>0) {
                        caseMUStatus = lstMU[0].Escalation_Status__c;
                        caseMUReason = lstMU[0].Comments__c;
                        MUCaseStatus = lstMU[0].Status__c;
                    }
                    */
                    //Escalate CR START
                    if(loggedInUserRoleName == 'MU Agent'){
                        caseMUStatus = caseObj.MU_Escalation_Status__c;
                        caseMUReason = caseObj.MU_Comments__c ;
                        MUCaseStatus = caseObj.Status;
                    }
                    if(String.valueOf(caseObj.ownerId).substring(0,3) == '00G'){
                        isCaseInQueue = true;
                    }
                    //Escalate CR END
                }
                fillCaseAddressHistory();

        } catch(Exception ex) {}
        return null;
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to fill the audit list on case.
    * @param 
    * @return Void
    */
    public void fillCaseAddressHistory() {
        try {
            lstCaseAddressHistory = new List<WRAddressCaseHistory>();
            if(!string.isBlank(caseId)) {
                caseObj =  [select OwnerId, casenumber,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,owner.Name,
                                        status,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c,Communication_Preference_Changed_To_Fax__c,
                                        subject,description,Close_Reason__c,CreatedBy.Name,Internal_Comments__c,MU_Escalation_Status__c,MU_Comments__c,
                                        (Select ADDRESS__c, CITY__c, STATE__c, ZIP_CODE__c, PHONE__c, FAX_NUMBER__c, Suite__c, Floor__c, Address_Modified__c,lastmodifieddate,Address_Change__c,
                                            LastModifiedBy.Name,CreatedBy.Name From EAF_Validation_Audit_Trails__r order by LastModifiedDate desc), 
                                        (Select Secure_City__c, Secure_Fax__c, Secure_Phone__c, Secure_State__c, Secure_Street_Address__c, Secure_Zip_Code__c, Secure_Suite__c, Secure_Floor__c,
                                        Address_Change__c, Secure_Phone_Ext__c, Address_Modified__c,lastmodifieddate,LastModifiedBy.Name,CreatedBy.Name,Serial_Number__c 
                                            From Provider_Validation_Updates__r  order by LastModifiedDate desc)     
                                        from case where Id = :caseId];
                if(prefix=='003') {
                        for(Contact_Validation_Audit_Trail__c obj : caseObj.Provider_Validation_Updates__r) {
                                WRAddressCaseHistory wrObj = new WRAddressCaseHistory();
                                wrObj.auditId = obj.id;
                                wrObj.addressModified = obj.Address_Modified__c;
                                //wrObj.strAddress = 'Modified By ' +obj.LastModifiedBy.Name + ': ' +obj.lastmodifieddate.format()+' '+'Address S#: '+obj.Serial_Number__c+' From '+ obj.Secure_Street_Address__c +' '+ obj.Secure_City__c+' To';//New Change
                                wrObj.strAddress  = obj.Address_Change__c;
                                wrObj.lastModifiedDate = obj.lastmodifieddate.format();
                                wrObj.strAddressModifiedBy = obj.CreatedBy.Name;
                                lstCaseAddressHistory.add(wrObj);
                        }
                } else {
                        for(PDV_EAF_Validation_Audit_Trail__c obj : caseObj.EAF_Validation_Audit_Trails__r) {
                                WRAddressCaseHistory wrObj = new WRAddressCaseHistory();
                                wrObj.auditId = obj.id;
                                wrObj.addressModified = obj.Address_Modified__c;
                                //wrObj.strAddress = 'Modified By ' +obj.LastModifiedBy.Name + ':' +obj.ADDRESS__c+' '+ obj.CITY__c;//New Change
                                wrObj.strAddress  = obj.Address_Change__c;
                                wrObj.lastModifiedDate = obj.lastmodifieddate.format();
                                wrObj.strAddressModifiedBy = obj.CreatedBy.Name;
                                lstCaseAddressHistory.add(wrObj);
                        }
                }
            }
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to create SOC record.
    * @param 
    * @return PageReference
    */
    public PageReference createSOCCall() {
        try {
                SOC_Queue__c socObj = new SOC_Queue__c();
                socObj.status__c = 'Accepted';
                if(prefix == '003') {
                        socObj.Provider_Facility_ID__c = providerId;
                        socObj.Name = contactInfo.Name + ' ' + 'SER' + ' ' + (contactInfo.Provider_NPI__c != null ? contactInfo.Provider_NPI__c : '');
                        socObj.Type_of_Provider__c = 'SER';
                        socObj.Date_Imported_Into_Salesforce__c=system.today();
                } else {
                        socObj.Facility_Id__c = providerId;
                        socObj.Name = faciltyInfo.Name + ' ' + 'EAF' + ' ' + (faciltyInfo.Facility_ID__c != null ? faciltyInfo.Facility_ID__c : '');
                        socObj.Type_of_Provider__c = 'EAF';
                        socObj.Date_Imported_Into_Salesforce__c=system.today();
                }
                insert socObj;
                if(socObj.id != null) {
                        socId = socObj.id;
                        isSOCExists = true;
                        PageReference pgRef = new PageReference('/apex/SOCCall?socId='+ socId + '&providerId=' + providerId);
                        pgRef.setRedirect(false);
                        return pgRef;
                }
        } catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        return null;
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to accept SOC record.
    * @param 
    * @return PageReference
    */
    public PageReference acceptSOCCall() {
        try {
                SOC_Queue__c socObj = new SOC_Queue__c(id=socId);
                socObj.ownerId = UserInfo.getUserId();
                socObj.status__c = 'Accepted';
                update socObj;
                if(socObj.id != null) {
                        socId = socObj.id;
                        isSOCInQueue = false;
                        PageReference pgRef = new PageReference('/apex/SOCCall?socId='+ socId + '&providerId=' + providerId);
                        pgRef.setRedirect(false);
                        return pgRef;
                } 
        } catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        return null;
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to accept Associated Case record
    * @param 
    * @return PageReference
    */
    public PageReference acceptAssociatedCase() {
        try {
                Case associatedCase = new Case(id=caseId);
                associatedCase.ownerId = UserInfo.getUserId();
                update associatedCase;

                isCaseInQueue = false;
                PageReference pgRef = new PageReference('/apex/SOCCall?socId='+ socId + '&providerId=' + providerId);
                pgRef.setRedirect(false);
                return pgRef;
                
        } catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        return null;
    }
    
    public void fillContactName() {
        caseObj.PDV_Contact_Name__c  = caseObj.Provider_Name__c;
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to get state list.
    * @param 
    * @return List<SelectOption>
    */
    public List<SelectOption> statePkList {get;set;}
    public void getStatePicklistVal() {
        try {
            statePkList = new List<SelectOption>(); 
            Schema.DescribeFieldResult fieldDesc = Contact_Validation_Summary__c.Secure_State__c.getDescribe();
            List<Schema.PicklistEntry> statePickValues = fieldDesc.getPicklistValues();
            statePkList.add(new SelectOption('None','--None--'));
            for(Schema.PicklistEntry obj : statePickValues) {
                SelectOption selectOption = new SelectOption(obj.getValue(),obj.getLabel());
                statePkList.add(selectOption);
            }
        } catch(Exception ex) {}
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to get MU Escalation Status list.
    * @param 
    * @return List<SelectOption>
    */
    public List<SelectOption> caseMUStatusLstOption {get;set;}
    public void getCaseMUStatus() {
        try {
            caseMUStatusLstOption = new List<SelectOption>(); 
            Schema.DescribeFieldResult fieldDesc = Case.MU_Escalation_Status__c.getDescribe();
            List<Schema.PicklistEntry> statePickValues = fieldDesc.getPicklistValues();
            caseMUStatusLstOption.add(new SelectOption('None','--None--'));
            for(Schema.PicklistEntry obj : statePickValues) {
                SelectOption selectOption = new SelectOption(obj.getValue(),obj.getLabel());
                caseMUStatusLstOption.add(selectOption);
            }
        } catch(Exception ex) {}
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to get all cases per contact/Facility
    * @param 
    * @return void
    */
    public void getCaseLst() {
        wrCaseLst = new List<WrCase>();
        if(prefix == '003') {
            for(Case caseObj : contactInfo.Cases) {
                
                WrCase wrcaseObj = new WrCase();
                wrcaseObj.caseId = caseObj.id;
                wrcaseObj.strSubject = caseObj.subject;
                wrcaseObj.strCaseNumber = caseObj.caseNumber;
                wrcaseObj.strStatus = caseObj.status;
                wrcaseObj.strCaseOrigin = caseObj.origin;
                wrcaseObj.strCaseContactNumber = caseObj.Contact_Number__c != null ? string.valueOf(caseObj.Contact_Number__c) : '';
                wrcaseObj.strCaseContactName = caseObj.PDV_Contact_Name__c;
                wrcaseObj.strCaseEscaltionReason = caseObj.PDV_Escalation_Reason__c;
                wrCaseLst.add(wrcaseObj); //= new List<WrCase>();
            }
        } else {
            for(Case caseObj : faciltyInfo.Cases__r) {

                WrCase wrcaseObj = new WrCase();
                wrcaseObj.caseId = caseObj.id;
                wrcaseObj.strSubject = caseObj.subject;
                wrcaseObj.strCaseNumber = caseObj.caseNumber;
                wrcaseObj.strStatus = caseObj.status;
                wrcaseObj.strCaseOrigin = caseObj.origin;
                wrcaseObj.strCaseContactNumber = caseObj.Contact_Number__c != null ? string.valueOf(caseObj.Contact_Number__c) : '';
                wrcaseObj.strCaseContactName = caseObj.PDV_Contact_Name__c;
                wrcaseObj.strCaseEscaltionReason = caseObj.PDV_Escalation_Reason__c;
                wrCaseLst.add(wrcaseObj); //= new List<WrCase>();
            }
        }   
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to update SOC record
    * @param 
    * @return boolean
    */
    public boolean isAllAddressValidates {get;set;}
    public pageReference updateSOCStatus(){
        try {
            isAllAddressValidates = true;
            for(WrAddressValidation wAdd : wrAddressValidationlist) {
                
                if(wAdd.isValidated == 'No' || String.isBlank(wAdd.isValidated)) {
                    
                    isAllAddressValidates = false;
                    break;
                }
            }
            if(isAllAddressValidates == false) {
                return null;
            }
            
            if(isCreatingCase == true) {
                if(caseStatus != 'Closed') { 
                    caseObj.SOC_Document_Status__c = 'Sent';
                    if(caseObj.Id != null) {
                        update caseObj;
                    }
                } 
            } else {
                SOC_Queue__c socRecord = [Select Id from SOC_Queue__c where Id =: socId];
                socRecord.Status__c = 'Sent';
                socRecord.Date_SOC_Documents_Sent__c = system.now(); 
                update socRecord;
            }
        } catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        } 
        return null;
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to get contact/facility info
    * @param 
    * @return void
    */
    public string providerName {get;set;}
    public void getProviderInfo() {
        try {
            if(prefix == '003') {
                        contactInfo = [select id,FirstName,lastname,email,name,Gender__c,Preferred_Communication_Method__c,  
                        Provider_UPIN__c, Provider_Title__c, Provider_Sub_Specialty__c, Provider_Specialty__c, Provider_Specialty_Subspecialty__c, 
                        Provider_Specialty_3__c, Provider_Specialty_2__c, Provider_Specialty_1__c, Provider_Service_Status__c, Provider_SHIS_Enterprise_ID__c, 
                        Provider_PCP_Indicator__c, Provider_Org_Structure__c, Provider_Operation_Hours__c, Provider_Name__c, Provider_Name_Suffix__c, 
                        Provider_NPI__c, Provider_Max_Panel_Membership__c, Provider_License_State__c, Provider_License_Number__c, Provider_Languages_Spoken__c, 
                        Provider_InNetwork_Flag__c, Provider_ID__c,Contact_External_ID1__c, Provider_Credential_Status__c, Provider_Correspondence_State__c, Provider_Correspondence_PostalCode__c, 
                        Provider_Correspondence_Phone__c, Provider_Correspondence_Fax_Number__c, Provider_Correspondence_County__c, Provider_Correspondence_City__c, 
                        Provider_Correspondence_Address__c, Provider_Benefit_Network__c, Provider_Alt_Correspondence_State__c, Provider_Alt_Correspondence_PostalCode__c, 
                        Provider_Alt_Correspondence_Phone__c, Provider_Alt_Correspondence_Fax__c, Provider_Alt_Correspondence_City__c, Provider_Alt_Correspondence_Address__c, 
                        Provider_Active_Status__c, Provider_Active_Status_Date__c, Provider_Accepting_New_Patients__c, Provider_Accepted_Patient_Age_Range__c, 
                        Provider_Accepted_Patient_Age_Range_Min__c, Provider_Accepted_Patient_Age_Range_Max__c,
                        (Select Last_Verified_Date__c,Provider_FirstName__c,Provider_LastName__c,Provider_MiddleName__c, Secure_City__c, Secure_Fax__c,Secure_Phone_Ext__c, Secure_Phone__c,Address_Type__c, Secure_State__c, Secure_floor__c,Secure_Suite__c,
                        Email__c,Mobile_Phone__c,Ok_to_Text__c,Address_Modified__c,New_Street_Address__c,Attn_To__c,Names_Changes_Suggested__c,  
                        Secure_Street_Address__c, Secure_Zip_Code__c,Serial_Number__c From Summarys__r where IsAddressDeactivated__c != true order by Serial_Number__c asc),
                        (Select Contact_Id__c,First_Name__c,Last_Name__c,Middle_Name__c, Secure_City__c, Secure_Fax__c,Secure_Phone_Ext__c,Secure_Phone__c, Secure_State__c, Secure_Street_Address__c,
                            Secure_Zip_Code__c, Address_Type__c, Provider_Information_Summary__c, Secure_Suite__c, Secure_Floor__c,LastModifiedDate, LastModifiedBy.Name,
                            Provider_Information_Summary__r.Address_Type__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,Address_Modified__c,Attn_To__c,Names_Changes_Suggested__c,New_Street_Address__c 
                            From Contact_Validation_Audit_Trails__r  order by LastModifiedDate desc),
                        (Select CaseNumber, Status, Subject,PDV_Contact_Name__c,Contact_Number__c,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin From Cases 
                            order by createddate asc)  
                        from Contact where Id= :providerId];
                                    providerName = contactInfo.Name;
            } else {
                    faciltyInfo = [Select ZIP_CODE__c, STATE__c, PHONE__c, Name, Facility_ID__c, FAX_NUMBER__c, CITY__c, ADDRESS__c,Last_Verified_date__c,Case__c,
                                    Suite__c,Floor__c,Phone_Extension__c,Address_Modified__c,Serial_Number__c,Attn_To__c,Names_Changes_Suggested__c,
                                    (Select Facility_ID__c, ADDRESS__c, CITY__c, STATE__c, ZIP_CODE__c, PHONE__c, FAX_NUMBER__c, Last_Verified_date__c, EAF_Facility__c,
                                    Suite__c,Floor__c,Phone_Extension__c,lastmodifieddate,lastmodifiedBy.Name,Address_Modified__c,Names_Changes_Suggested__c,Attn_To__c 
                                    From EAF_Validation_Audit_Trails__r order by LastModifiedDate desc),
                                     (Select CaseNumber, Status, Subject,PDV_Contact_Name__c,Contact_Number__c,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin From Cases__r
                                     order by createddate asc)  
                    From PDV_EAF_Facility__c where id = :providerId];
                    providerName = faciltyInfo.Name;
            }
        } catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to get address list
    * @param 
    * @return void
    */
    public map<Id,List<WrAddressValidation>> mapToListAddress {get;set;}   
    public void getAddressValidation() {
        try {
                wrAddressValidationlist = new List<WrAddressValidation>();
                mapToListAddress = new map<Id,List<WrAddressValidation>>();
                if(prefix == '003') {
                    WrAddressValidation wrAddressValidationObj =  new WrAddressValidation();
                    for(Contact_Validation_Summary__c sumObj : contactInfo.Summarys__r) {
                        WrAddressValidation wrAddressValidationObj1 =  new WrAddressValidation();
                        wrAddressValidationObj1.isSelected = false;
                        //wrAddressValidationObj1.strStreetAddress = sumObj.Secure_Street_Address__c;
                        wrAddressValidationObj1.strStreetAddress = sumObj.New_Street_Address__c;
                        wrAddressValidationObj1.strCity = sumObj.Secure_City__c;
                        wrAddressValidationObj1.strstate = sumObj.Secure_State__c;
                        wrAddressValidationObj1.strZipCode = sumObj.Secure_Zip_Code__c;
                        wrAddressValidationObj1.lastValidatedDate = sumObj.Last_Verified_Date__c != null ? sumObj.Last_Verified_Date__c.format() : ''; //string.valueOf(sumObj.Last_Verified_Date__c);
                        wrAddressValidationObj1.straddressType = sumObj.Address_Type__c;
                        wrAddressValidationObj1.strSuite = sumObj.Secure_suite__c;
                        wrAddressValidationObj1.strFloor = sumObj.Secure_floor__c;
                        wrAddressValidationObj1.strPhone = sumObj.Secure_Phone__c;
                        wrAddressValidationObj1.strFax = sumObj.Secure_FAX__c;
                        wrAddressValidationObj1.strPhoneExt = sumObj.Secure_Phone_Ext__c;
                        wrAddressValidationObj1.recordId = sumObj.id;
                        wrAddressValidationObj1.strEmail = sumObj.Email__c;
                        wrAddressValidationObj1.strMobilePhone = sumObj.Mobile_Phone__c;
                        wrAddressValidationObj1.strOkToText = sumObj.Ok_to_Text__c;
                        wrAddressValidationObj1.strSnumber = String.valueOf(sumObj.Serial_Number__c);//New Change
                        wrAddressValidationObj1.strAttenTo = sumObj.Attn_To__c;
                        wrAddressValidationObj1.strNameChangesSugg = sumObj.Names_Changes_Suggested__c;
                        wrAddressValidationObj1.strFirstName = sumObj.Provider_FirstName__c;
                        wrAddressValidationObj1.strMiddleName = sumObj.Provider_MiddleName__c;
                        wrAddressValidationObj1.strLastName = sumObj.Provider_LastName__c;
                        if(sumObj.Last_Verified_Date__c != null) {
                            Date date1 = Date.newInstance(sumObj.Last_Verified_Date__c.year(),sumObj.Last_Verified_Date__c.Month(),sumObj.Last_Verified_Date__c.day());
                            if(date1.daysBetween(date.today()) <= 30) {
                                wrAddressValidationObj1.isValidated = 'Yes';    
                            } else {
                                wrAddressValidationObj1.isValidated = 'No';
                            }
                        } else {
                            wrAddressValidationObj1.isValidated = 'No';
                        }
                        if(sumObj.address_modified__c != null) {
                            if(sumObj.address_modified__c == 'Yes') {
                                wrAddressValidationObj1.strAddressModified = 'Yes';
                            } else if(sumObj.address_modified__c == 'No') {
                                wrAddressValidationObj1.strAddressModified = 'No';
                            }
                        } else {
                            wrAddressValidationObj1.strAddressModified = 'No';
                        }
                        mapAddress.put(wrAddressValidationObj1.recordId,wrAddressValidationObj1);
                        wrAddressValidationlist.add(wrAddressValidationObj1);
                    }
                    for(Contact_Validation_Audit_Trail__c auditObj : contactInfo.Contact_Validation_Audit_Trails__r) {
                        List<WrAddressValidation> wrList1 = new List<WrAddressValidation>();
                       
                        if(mapToListAddress.get(auditObj.Provider_Information_Summary__c) != null && mapToListAddress.get(auditObj.Provider_Information_Summary__c).size()>0 )  {
                            wrList1 = mapToListAddress.get(auditObj.Provider_Information_Summary__c);
                        }
                        WrAddressValidation wrObj1 =  new WrAddressValidation();
                        //wrObj1.strStreetAddress = auditObj.Secure_Street_Address__c;
                        wrObj1.strStreetAddress = auditObj.New_Street_Address__c;
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
                        wrObj1.straddressType = auditObj.Provider_Information_Summary__r.Address_Type__c;
                        wrObj1.strEmail = auditObj.Email__c;
                        wrObj1.strMobilePhone = auditObj.Mobile_Phone__c;
                        wrObj1.strOkToText = auditObj.Ok_to_Text__c;
                        wrObj1.strAttenTo = auditObj.Attn_To__c;
                        wrObj1.strNameChangesSugg = auditObj.Names_Changes_Suggested__c;
                        wrObj1.strFirstName = auditObj.First_Name__c;
                        wrObj1.strMiddleName = auditObj.Middle_Name__c;
                        wrObj1.strLastName = auditObj.Last_Name__c;
                        if(auditObj.address_modified__c != null) {
                            if(auditObj.address_modified__c == 'Yes') {
                                wrObj1.strAddressModified = 'Yes';
                            } else if(auditObj.address_modified__c == 'No') {
                                wrObj1.strAddressModified = 'No';
                            }
                        } else {
                            wrObj1.strAddressModified = 'No';
                        }
                        wrList1.add(wrObj1);
                        mapToListAddress.put(auditObj.Provider_Information_Summary__c,wrList1);
                    }
                   
            } else {
               WrAddressValidation wrAddressValidationObj =  new WrAddressValidation();
               wrAddressValidationObj.isSelected = false;
               wrAddressValidationObj.strStreetAddress = faciltyInfo.ADDRESS__c;
               wrAddressValidationObj.strCity = faciltyInfo.CITY__c;
               wrAddressValidationObj.strstate = faciltyInfo.STATE__c;
               wrAddressValidationObj.strZipCode = faciltyInfo.ZIP_CODE__c;
               wrAddressValidationObj.strPhone = faciltyInfo.PHONE__c;
               wrAddressValidationObj.strFax = faciltyInfo.FAX_NUMBER__c;
               wrAddressValidationObj.strPhoneExt = faciltyInfo.Phone_Extension__c;
               wrAddressValidationObj.strSuite = faciltyInfo.Suite__c;
               wrAddressValidationObj.strFloor = faciltyInfo.Floor__c;
               wrAddressValidationObj.straddressType = 'Primary';
               wrAddressValidationObj.strSnumber = String.valueOf(faciltyInfo.Serial_Number__c);//New Change
               wrAddressValidationObj.lastValidatedDate = faciltyInfo.Last_Verified_date__c != null ? faciltyInfo.Last_Verified_date__c.format() : '';
               wrAddressValidationObj.strAttenTo = faciltyInfo.Attn_To__c;
               wrAddressValidationObj.strNameChangesSugg = faciltyInfo.Names_Changes_Suggested__c;
               wrAddressValidationObj.recordId = faciltyInfo.id;
               if(faciltyInfo.Last_Verified_Date__c != null) {
                    Date date1 = Date.newInstance(faciltyInfo.Last_Verified_Date__c.year(),faciltyInfo.Last_Verified_Date__c.Month(),faciltyInfo.Last_Verified_Date__c.day());
                    if(date1.daysBetween(date.today()) <= 30) {
                        wrAddressValidationObj.isValidated = 'Yes'; 
                    } else {
                        wrAddressValidationObj.isValidated = 'No';
                    }
                } else {
                    wrAddressValidationObj.isValidated = 'No';
                }
                if(faciltyInfo.address_modified__c != null) {
                    if(faciltyInfo.address_modified__c == 'Yes') {
                        wrAddressValidationObj.strAddressModified = 'Yes';
                    } else if(faciltyInfo.address_modified__c == 'No') {
                        wrAddressValidationObj.strAddressModified = 'No';
                    }
                } else {
                    wrAddressValidationObj.strAddressModified = 'No';
                } 
               mapAddress.put(wrAddressValidationObj.recordId,wrAddressValidationObj);
               wrAddressValidationlist.add(wrAddressValidationObj);
               for(PDV_EAF_Validation_Audit_Trail__c auditObj : faciltyInfo.EAF_Validation_Audit_Trails__r) {
                    List<WrAddressValidation> wrList1 = new List<WrAddressValidation>();
                    if(mapToListAddress.get(auditObj.EAF_Facility__c) != null && mapToListAddress.get(auditObj.EAF_Facility__c).size()>0 )  {
                        wrList1 = mapToListAddress.get(auditObj.EAF_Facility__c);
                    }
                    WrAddressValidation wrObj1 =  new WrAddressValidation();
                    wrObj1.strStreetAddress = auditObj.ADDRESS__c;
                    wrObj1.strCity = auditObj.CITY__c;
                    wrObj1.strstate = auditObj.STATE__c;
                    wrObj1.strZipCode = auditObj.ZIP_CODE__c;
                    wrObj1.strPhone = auditObj.PHONE__c;
                    wrObj1.strFax = auditObj.FAX_NUMBER__c;
                    wrObj1.strPhoneExt = auditObj.Phone_Extension__c;
                    wrObj1.strSuite = auditObj.Suite__c;
                    wrObj1.strFloor = auditObj.Floor__c;
                    wrObj1.recordId = auditObj.EAF_Facility__c;
                    wrObj1.lastmodifiedDate = auditObj.LastModifiedDate.format();
                    wrObj1.lastmodifiedBy = auditObj.LastModifiedBy.Name;
                    wrObj1.straddressType = 'Primary';
                    //wrObj1.strEmail = auditObj.Email__c;
                    //wrObj1.strMobilePhone = auditObj.Mobile_Phone__c;
                    //wrObj1.strOkToText = auditObj.Ok_to_Text__c;
                    wrObj1.strAttenTo = auditObj.Attn_To__c;
                    wrObj1.strNameChangesSugg = auditObj.Names_Changes_Suggested__c;
                    if(auditObj.address_modified__c != null) {
                            if(auditObj.address_modified__c == 'Yes') {
                                wrObj1.strAddressModified = 'Yes';
                            } else if(auditObj.address_modified__c == 'No') {
                                wrObj1.strAddressModified = 'No';
                            }
                        } else {
                            wrObj1.strAddressModified = 'No';
                        } 
                    wrList1.add(wrObj1);
                    mapToListAddress.put(auditObj.EAF_Facility__c,wrList1);
                }
            } 
        } catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to fill selected address information
    * @param 
    * @return void
    */
    public void setAddressParam() {
       
        wrOldAddressLst = new List<WrAddressValidation>();
        
        if(addressRecordId != null && mapAddress != null) {
                newAddress.strStreetAddress = mapAddress.get(addressRecordId).strStreetAddress;
                newAddress.strCity = mapAddress.get(addressRecordId).strCity;
                newAddress.strstate = mapAddress.get(addressRecordId).strstate;
                newAddress.strZipCode = mapAddress.get(addressRecordId).strZipCode;
                newAddress.strPhone = mapAddress.get(addressRecordId).strPhone;
                newAddress.strFax = mapAddress.get(addressRecordId).strFax;
                newAddress.strPhoneExt = mapAddress.get(addressRecordId).strPhoneExt;
                newAddress.strSuite = mapAddress.get(addressRecordId).strSuite;
                newAddress.strFloor = mapAddress.get(addressRecordId).strFloor;
                newAddress.strPhoneExt = mapAddress.get(addressRecordId).strPhoneExt;
                newAddress.straddressType = mapAddress.get(addressRecordId).straddressType;
                newAddress.strEmail = mapAddress.get(addressRecordId).strEmail;
                newAddress.strMobilePhone = mapAddress.get(addressRecordId).strMobilePhone;
                newAddress.strOkToText = mapAddress.get(addressRecordId).strOkToText;
                newAddress.strAttenTo = mapAddress.get(addressRecordId).strAttenTo;
                newAddress.strNameChangesSugg = mapAddress.get(addressRecordId).strNameChangesSugg;
                newAddress.strFirstName = mapAddress.get(addressRecordId).strFirstName;
                newAddress.strMiddleName = mapAddress.get(addressRecordId).strMiddleName;
                newAddress.strLastName = mapAddress.get(addressRecordId).strLastName;
        }
        if(addressRecordId != null && mapToListAddress != null) {
            wrOldAddressLst = mapToListAddress.get(addressRecordId);
            
        }
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to delete/deactivate selected address
    * @param 
    * @return void
    */
    public void deleteAddress() {
        try {
            if(addressRecordId != null) {
                Contact_Validation_Summary__c delObj = [select Serial_Number__c from Contact_Validation_Summary__c where Id = :addressRecordId];
                delObj.IsAddressDeactivated__c = true;
                //delete delObj;
                update delObj;
                Contact_Validation_Audit_Trail__c auditObj = new Contact_Validation_Audit_Trail__c();                                           
                auditObj.Provider_Information_Summary__c = delObj.id;
                auditObj.Address_Change__c = 'At '+ system.now().format() + ' S#' +  delObj.Serial_Number__c + ' Deleted';
                auditObj.Case__c = caseId;
                insert auditObj;
                getProviderInfo();
                getAddressValidation();
                addressRecordId = null;
                newAddress = new WrAddressValidation();
                isAddressValidAllFields = true;
                isCreatingCase = true;
                fillCaseAddressHistory();
            } 
        } catch(Exception ex)  {
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to create new address
    * @param 
    * @return void
    */
    public void createNewAddress() {
        newAddress = new WrAddressValidation();
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to save/update address
    * @param 
    * @return void
    */
    boolean isAddressValidated; 
    public boolean isAddressValidAllFields {get;set;}
    public boolean phoneCheck {get;set;}
    public boolean faxCheck {get;set;}
    public PageReference saveUpdatedAddress() {
        try {
            
            isAddressValidAllFields = true;
            
            //ApexPages.addMessage
            if(newAddress.strAddressType == 'Primary' && prefix=='003') {
                /*if(string.isBlank(newAddress.strEmail)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Email.'));
                    isAddressValidAllFields = false;
                } else */
                if(!string.isblank(newAddress.strEmail) && !patterMatcherEmail(newAddress.strEmail)) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Email is invalid.'));
                    isAddressValidAllFields = false;
                }
                /*if(string.isBlank(newAddress.strMobilePhone)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Mobile Phone.'));
                    isAddressValidAllFields = false;
                } else */
                if(!string.isBlank(newAddress.strMobilePhone)) {
                    if(!string.isBlank(newAddress.strMobilePhone) && (newAddress.strMobilePhone.length() < 14 || newAddress.strMobilePhone.length() > 14)) {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Mobile Phone is invalid. It must be either in the form of (999) 999-9999.'));
                        isAddressValidAllFields = false;
                    }
                }
            }
            if(string.isBlank(newAddress.strStreetAddress)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Street Address.'));
                isAddressValidAllFields = false;
            } else if(!patterMatcherStreetAddress(newAddress.strStreetAddress))  {//.substring(0,1)
                if(prefix != '003') {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Street Address must start with a Number.'));
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Street Address must start with a Number or P O BOX.'));
                }
                isAddressValidAllFields = false;
            } else if(patterMatcherPOBox(newAddress.strStreetAddress) && prefix != '003') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Street Address must not contain P O Box.. like words.'));
                isAddressValidAllFields = false;
            } else if(patterMatcherCareOf(newAddress.strStreetAddress)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Street Address must not contain Care Of or C\\O or S\\O or D\\O.. like words.'));
                isAddressValidAllFields = false;
            } else if(patterMatcherSUiteOrFloor(newAddress.strStreetAddress)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Street Address must not contain Suite or Floor information.'));
                isAddressValidAllFields = false;
            }
            if(string.isBlank(newAddress.strPhone) && phoneCheck == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Phone.'));
                isAddressValidAllFields = false;
            } else if(!string.isBlank(newAddress.strPhone)) {
                if(!string.isBlank(newAddress.strPhone) && (newAddress.strPhone.length() < 14 || newAddress.strPhone.length() > 14)) {
                   
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Phone is invalid. It must be either in the form of (999) 999-9999.'));
                    isAddressValidAllFields = false;
                }
            }
            if(string.isBlank(newAddress.strFax) && faxCheck == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Fax.'));
                isAddressValidAllFields = false;
            } else if(!string.isBlank(newAddress.strFax) && (newAddress.strFax.length() < 14 || newAddress.strFax.length() > 14)) {
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Fax is invalid. It must contain 10 digits numeric value only.'));
                isAddressValidAllFields = false;
            }
            if(string.isBlank(newAddress.strCity)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the City.'));
                isAddressValidAllFields = false;
            }
            if(string.isBlank(newAddress.strZipcode)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the ZipCode.'));
                isAddressValidAllFields = false;
            } /*else if(!string.isBlank(newAddress.strZipcode) && ((newAddress.strZipcode.length() < 5) || ((newAddress.strZipcode.length() > 5 && newAddress.strZipcode.length() < 9)) 
                        || (newAddress.strZipcode.length() > 9))) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Zip Code is invalid. It must contain 5 digits only.'));
                isAddressValidAllFields = false;
            }*/
        
            if(newAddress.strState == 'None') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the State.'));
                isAddressValidAllFields = false;
            }
            
            if(!String.isBlank(newAddress.strPhoneExt) && !newAddress.strPhoneExt.isNumeric()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Extension must be Numeric.'));
                isAddressValidAllFields = false;
            }
            
            if(!String.isBlank(newAddress.strSuite) && patterMatcherPOBox(newAddress.strSuite) && prefix != '003') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Suite must not contain P O Box.. like words.'));
                isAddressValidAllFields = false;
            } else if(!String.isBlank(newAddress.strSuite) && patterMatcherCareOf(newAddress.strSuite)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Suite must not contain Care Of or C\\O or S\\O or D\\O.. like words.'));
                isAddressValidAllFields = false;
            }
            
            if(!String.isBlank(newAddress.strFloor) && patterMatcherPOBox(newAddress.strFloor) && prefix != '003') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Floor must not contain P O Box.. like words.'));
                isAddressValidAllFields = false;
            } else if(!String.isBlank(newAddress.strFloor) && patterMatcherCareOf(newAddress.strFloor)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Floor must not contain Care Of or C\\O or S\\O or D\\O.. like words.'));
                isAddressValidAllFields = false;
            }
            
            
            if(!isAddressValidAllFields) {
                //phoneCheck = false;
                //faxCheck = false;
                return null;
            }
            phoneCheck = false;
            faxCheck = false;
            if(prefix == '003') {
                    if(!string.isBlank(addressRecordId)) {
                        Contact_Validation_Summary__c pISObjOld = [select Secure_Street_Address__c,Provider_ID__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,Secure_City__c,Secure_State__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                                                                 Attn_To__c,Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c, 
                                                                 Names_Changes_Suggested__c ,New_Street_Address__c,Preferred_Communication_Method__c from  Contact_Validation_Summary__c where Id= :addressRecordId];
                        Integer totalauditrecords = [select count() from  Contact_Validation_Audit_Trail__c where Contact_Id__c= :pISObjOld.Contact_Id__c and 
                                                        Serial_Number__c =: String.valueOf(pISObjOld.Serial_Number__c) ]; 
                        pISObjOld.Secure_City__c = pISObjOld.Secure_City__c == null ? '' : pISObjOld.Secure_City__c;
                        pISObjOld.New_Street_Address__c = pISObjOld.New_Street_Address__c == null ? '' : pISObjOld.New_Street_Address__c;
                        pISObjOld.Secure_Floor__c = pISObjOld.Secure_Floor__c == null ? '' : pISObjOld.Secure_Floor__c;
                        pISObjOld.Secure_Zip_Code__c = pISObjOld.Secure_Zip_Code__c == null ? '' : pISObjOld.Secure_Zip_Code__c;
                        pISObjOld.Secure_Suite__c = pISObjOld.Secure_Suite__c == null ? '' : pISObjOld.Secure_Suite__c;
                        if(totalauditrecords == 0) {
                            //Old Values
                            Contact_Validation_Audit_Trail__c auditObj = new Contact_Validation_Audit_Trail__c();                                           
                            auditObj.Provider_Information_Summary__c = pISObjOld.id;
                            auditObj.New_Street_Address__c = pISObjOld.New_Street_Address__c;
                            auditObj.Secure_Suite__c = pISObjOld.Secure_Suite__c;
                            auditObj.Secure_Floor__c = pISObjOld.Secure_Floor__c;
                            auditObj.First_Name__c = pISObjOld.Provider_FirstName__c;
                            auditObj.Middle_Name__c = pISObjOld.Provider_MiddleName__c;
                            auditObj.Last_Name__c = pISObjOld.Provider_LastName__c;
                            string addressFormat1 = '';
                            if(!String.isBlank(auditObj.New_Street_Address__c)) {
                                addressFormat1 =  auditObj.New_Street_Address__c; 
                            }
                            /*if(!string.isBlank(auditObj.Secure_Suite__c)) {
                                addressFormat1 = addressFormat1 + ' STE ' + pISObjOld.Secure_Suite__c;
                            }
                            if(!string.isBlank(auditObj.Secure_Floor__c)) {
                                addressFormat1 = addressFormat1 + ' FL ' + pISObjOld.Secure_Floor__c;
                            }*/
                            if(!string.isBlank(pISObjOld.Secure_Suite__c)) {
                                if(!pISObjOld.Secure_Suite__c.containsIgnoreCase('STE')) {
                                    addressFormat1 = addressFormat1 + ' STE ' + pISObjOld.Secure_Suite__c;
                                } else {
                                    addressFormat1 = addressFormat1 + ' ' + pISObjOld.Secure_Suite__c;
                                }
                            }
                            if(!string.isBlank(pISObjOld.Secure_Floor__c)) {
                                if(!pISObjOld.Secure_Floor__c.containsIgnoreCase('FL')) {
                                    addressFormat1 = addressFormat1 + ' FL ' + pISObjOld.Secure_Floor__c;
                                } else {
                                    addressFormat1 = addressFormat1 + '  ' + pISObjOld.Secure_Floor__c;
                                }
                            }
                            auditObj.Secure_Street_Address__c = addressFormat1;
                            auditObj.Secure_City__c = pISObjOld.Secure_City__c;
                            auditObj.Secure_State__c = pISObjOld.Secure_State__c;
                            auditObj.Secure_Zip_Code__c = pISObjOld.Secure_Zip_Code__c; 
                            auditObj.Secure_Phone__c = pISObjOld.Secure_Phone__c;
                            auditObj.Secure_FAX__c = pISObjOld.Secure_FAX__c;
                            auditObj.Secure_Phone_Ext__c = pISObjOld.Secure_Phone_Ext__c;
                            auditObj.Contact_Id__c = providerId;
                            auditObj.Email__c = pISObjOld.Email__c;
                            auditObj.Mobile_Phone__c = pISObjOld.Mobile_Phone__c;
                            auditObj.Ok_to_Text__c = pISObjOld.Ok_to_Text__c;
                            auditObj.Serial_Number__c = pISObjOld.Serial_Number__c != null ? String.valueOf(pISObjOld.Serial_Number__c) : null; //New Change 
                            auditObj.Preferred_Communication_Method__c = pISObjOld.Preferred_Communication_Method__c;
                            auditObj.Attn_To__c = pISObjOld.Attn_To__c;
                            auditObj.Names_Changes_Suggested__c = pISObjOld.Names_Changes_Suggested__c;
                            /*Req-3696:Description : Date 15/10/2015 Provider Id inserted to the 'Contact Validation Audit Trail' Object */
                            auditObj.Provider_ID__c = pISObjOld.Provider_ID__c;
                            /*Description : Date 15/10/2015 Provider Id inserted to the 'Contact Validation Audit Trail' Object */
                            
                            auditObj.Case__c = caseId;
                           
                            if((newAddress.strCity != pISObjOld.Secure_City__c) || (newAddress.strStreetAddress != pISObjOld.New_Street_Address__c) || 
                                (newAddress.strZipCode != pISObjOld.Secure_Zip_Code__c) || (newAddress.strSuite != pISObjOld.Secure_Suite__c) || (newAddress.strFloor != pISObjOld.Secure_Floor__c)
                                || (newAddress.strPhone != pISObjOld.Secure_Phone__c) || (newAddress.strFax != pISObjOld.Secure_FAX__c) || (newAddress.strstate != pISObjOld.Secure_State__c) ) {
                                auditObj.address_modified__c = 'Yes';
                            } else {
                                auditObj.address_modified__c = 'No';
                            }
                            //pISObjOld.Secure_Suite__c = pISObjOld.Secure_Suite__c == null ? pISObjOld.Secure_Suite__c = '' : pISObjOld.Secure_Suite__c;
                            //pISObjOld.Secure_Floor__c = pISObjOld.Secure_Floor__c == null ? pISObjOld.Secure_Floor__c = '' : pISObjOld.Secure_Floor__c;
                            string strLog = '';
                            strLog = strLog + 'At ' + system.now().format() + ' S#' +  auditObj.Serial_Number__c + '<br/>';
                            if(newAddress.strCity != pISObjOld.Secure_City__c) {
                                strLog  = strLog + ' City ' + '<br/>' +
                                            'From ' + pISObjOld.Secure_City__c + '<br/>' +
                                            'To ' + newAddress.strCity + '<br/><br/>'; 
                            }
                            if(newAddress.strStreetAddress != pISObjOld.New_Street_Address__c) {
                                strLog  = strLog + ' Street Address ' + '<br/> ' +
                                            'From ' + pISObjOld.New_Street_Address__c + '<br/>' +
                                            'To ' + newAddress.strStreetAddress + '<br/><br/>'; 
                            }
                            if(newAddress.strZipCode != pISObjOld.Secure_Zip_Code__c) {
                                strLog  = strLog + ' ZipCode ' +  '<br/> ' +
                                            'From ' + pISObjOld.Secure_Zip_Code__c + '<br/>' +
                                            'To ' + newAddress.strZipCode + '<br/><br/>'; 
                            }
                            if((newAddress.strSuite != pISObjOld.Secure_Suite__c) && (!String.isBlank(newAddress.strSuite) || !String.isBlank(pISObjOld.Secure_Suite__c))) {
                                strLog  = strLog + ' Suite ' +  '<br/> ' +
                                            'From ' + pISObjOld.Secure_Suite__c + '<br/>' +
                                            'To ' + newAddress.strSuite  + '<br/><br/>'; 
                            }
                            if((newAddress.strFloor != pISObjOld.Secure_Floor__c) && (!String.isBlank(newAddress.strFloor) || !String.isBlank(pISObjOld.Secure_Floor__c))) {
                                strLog  = strLog + ' Floor ' +  '<br/> ' +
                                            'From ' + pISObjOld.Secure_Floor__c + '<br/>' +
                                            'To ' + newAddress.strFloor + '<br/><br/>'; 
                            }
                            if((newAddress.strstate != pISObjOld.Secure_State__c)) {
                                strLog  = strLog + ' State ' +  '<br/> ' +
                                            'From ' + pISObjOld.Secure_State__c + '<br/>' +
                                            'To ' + newAddress.strstate + '<br/><br/>'; 
                            }
                            if((newAddress.strPhone != pISObjOld.Secure_Phone__c) && (!String.isBlank(newAddress.strPhone) || !String.isBlank(pISObjOld.Secure_Phone__c))) {
                                strLog  = strLog + ' Phone ' +  '<br/> ' +
                                            'From ' + pISObjOld.Secure_Phone__c + '<br/>' +
                                            'To ' + newAddress.strPhone + '<br/><br/>'; 
                            }
                            if((newAddress.strFAX != pISObjOld.Secure_FAX__c) && (!String.isBlank(newAddress.strFAX) || !String.isBlank(pISObjOld.Secure_FAX__c))) {
                                strLog  = strLog + ' Fax ' +  '<br/> ' +
                                            'From ' + pISObjOld.Secure_FAX__c + '<br/>' +
                                            'To ' + newAddress.strFAX + '<br/><br/>'; 
                            }
                            if((newAddress.strEmail != pISObjOld.Email__c) && (!String.isBlank(newAddress.strEmail) || !String.isBlank(pISObjOld.Email__c))) {
                                strLog  = strLog + ' Email ' +  '<br/> ' +
                                            'From ' + pISObjOld.Email__c + '<br/>' +
                                            'To ' + newAddress.strEmail + '<br/><br/>'; 
                            }
                            if((newAddress.strMobilePhone != pISObjOld.Mobile_Phone__c) && (!String.isBlank(newAddress.strMobilePhone) || !String.isBlank(pISObjOld.Mobile_Phone__c))) {
                                strLog  = strLog + ' Mobile Phone ' +  '<br/> ' +
                                            'From ' + pISObjOld.Mobile_Phone__c + '<br/>' +
                                            'To ' + newAddress.strMobilePhone + '<br/><br/>'; 
                            }
                            if((newAddress.strAttenTo != pISObjOld.Attn_To__c) && (!String.isBlank(newAddress.strAttenTo) || !String.isBlank(pISObjOld.Attn_To__c))) {
                                strLog  = strLog + ' Attn To ' +  '<br/> ' +
                                            'From ' + pISObjOld.Attn_To__c + '<br/>' +
                                            'To ' + newAddress.strAttenTo + '<br/><br/>'; 
                            }
                            if((newAddress.strNameChangesSugg != pISObjOld.Names_Changes_Suggested__c) && (!String.isBlank(newAddress.strNameChangesSugg) || !String.isBlank(pISObjOld.Names_Changes_Suggested__c))) {
                                strLog  = strLog + ' Name Changes Suggestion ' +  '<br/> ' +
                                            'From ' + pISObjOld.Names_Changes_Suggested__c + '<br/>' +
                                            'To ' + newAddress.strNameChangesSugg + '<br/><br/>'; 
                            }
                            auditObj.Address_Change__c = strLog;
                            auditObj.Sent_to_MDM__c = 'N/A';//New Field
                            auditObj.Preferred_Communication_Method__c = pISObjOld.Preferred_Communication_Method__c;
                            if(auditObj.Serial_Number__c == '1') {
                                auditObj.Address_Type__c = 'Primary';
                            } else {
                                auditObj.Address_Type__c = 'Secondary';
                            }
                            insert  auditObj;
                           
                           
                           
                           //New Values 
                            Contact_Validation_Audit_Trail__c auditObjNew = new Contact_Validation_Audit_Trail__c();                                           
                            auditObjNew.Provider_Information_Summary__c = addressRecordId;
                            auditObjNew.New_Street_Address__c = newAddress.strStreetAddress;
                            auditObjNew.Secure_Suite__c = newAddress.strSuite;
                            auditObjNew.Secure_Floor__c = newAddress.strFloor;
                            auditObjNew.First_Name__c = newAddress.strFirstName;
                            auditObjNew.Middle_Name__c = newAddress.strMiddleName;
                            auditObjNew.Last_Name__c = newAddress.strLastName;
                            
                            string addressFormat2 = '';
                            if(!String.isBlank(auditObjNew.New_Street_Address__c)) {
                                addressFormat2 =  auditObjNew.New_Street_Address__c; 
                            }
                            /*if(!string.isBlank(auditObjNew.Secure_Suite__c)) {
                                addressFormat2 = addressFormat2 + ' STE ' + auditObjNew.Secure_Suite__c;
                            }
                            if(!string.isBlank(auditObjNew.Secure_Floor__c)) {
                                addressFormat2 = addressFormat2 + ' FL ' + auditObjNew.Secure_Floor__c;
                            }*/
                            if(!string.isBlank(auditObjNew.Secure_Suite__c)) {
                                if(!newAddress.strSuite.containsIgnoreCase('STE')) {
                                    addressFormat2 = addressFormat2 + ' STE ' + auditObjNew.Secure_Suite__c;
                                } else {
                                    addressFormat2 = addressFormat2 + ' ' + auditObjNew.Secure_Suite__c;
                                }
                            }
                            if(!string.isBlank(auditObjNew.Secure_Floor__c)) {
                                if(!newAddress.strFloor.containsIgnoreCase('FL')) {
                                    addressFormat2 = addressFormat2 + ' FL ' + auditObjNew.Secure_Floor__c;
                                } else {
                                    addressFormat2 = addressFormat2 + '  ' + auditObjNew.Secure_Floor__c;
                                }
                            }
                            auditObjNew.Secure_Street_Address__c = addressFormat2;
                            auditObjNew.Secure_City__c = newAddress.strCity;
                            auditObjNew.Secure_State__c = newAddress.strstate;
                            auditObjNew.Secure_Zip_Code__c = newAddress.strZipCode; 
                            auditObjNew.Secure_Phone__c = newAddress.strPhone;
                            auditObjNew.Secure_FAX__c = newAddress.strFAX;
                            auditObjNew.Secure_Phone_Ext__c = newAddress.strPhoneExt;
                            auditObjNew.Contact_Id__c = providerId;
                            auditObjNew.Email__c = newAddress.strEmail;
                            auditObjNew.Mobile_Phone__c = newAddress.strMobilePhone;
                            auditObjNew.Ok_to_Text__c = newAddress.strOkToText;
                            /*Req-3696:Description : Date 15/10/2015 Provider Id inserted to the 'Contact Validation Audit Trail' Object */
                            auditObjNew.Provider_ID__c = pISObjOld.Provider_ID__c;
                            /*Description : Date 15/10/2015 Provider Id inserted to the 'Contact Validation Audit Trail' Object */
                            auditObjNew.Serial_Number__c = pISObjOld.Serial_Number__c != null ? String.valueOf(pISObjOld.Serial_Number__c) : null;//New Change 
                            //auditObjNew.Case__c = caseId;
                            if((newAddress.strCity != pISObjOld.Secure_City__c) || (newAddress.strStreetAddress != pISObjOld.New_Street_Address__c) || 
                                (newAddress.strZipCode != pISObjOld.Secure_Zip_Code__c) || (newAddress.strSuite != pISObjOld.Secure_Suite__c) || (newAddress.strFloor != pISObjOld.Secure_Floor__c)
                                || (newAddress.strPhone != pISObjOld.Secure_Phone__c) || (newAddress.strFAX != pISObjOld.Secure_FAX__c) || (newAddress.strstate != pISObjOld.Secure_State__c)) {
                                auditObjNew.address_modified__c = 'Yes';
                            } else {
                                auditObjNew.address_modified__c = 'No';
                            }
                            if(String.valueOf(pISObjOld.Serial_Number__c) == '1') {
                               auditObjNew.Sent_to_MDM__c = ''; //New Field
                               auditObjNew.Address_Type__c = 'Primary';
                            } else {
                                auditObjNew.Sent_to_MDM__c = 'N/A'; //New Field
                                auditObjNew.Address_Type__c = 'Secondary';
                            }
                            auditObjNew.Preferred_Communication_Method__c = pISObjOld.Preferred_Communication_Method__c;
                            auditObjNew.Attn_To__c = newAddress.strAttenTo;
                            auditObjNew.Names_Changes_Suggested__c = newAddress.strNameChangesSugg;
                            insert  auditObjNew;
                            
                           
                           
                       } else {
                                //Update MDM for all existed records
                                if(String.valueOf(pISObjOld.Serial_Number__c) == '1') {
                                    List<Contact_Validation_Audit_Trail__c> updatemdm = [select Sent_to_MDM__c from  Contact_Validation_Audit_Trail__c where 
                                                                                            Contact_Id__c= :pISObjOld.Contact_Id__c and Serial_Number__c = '1' and Sent_to_MDM__c = null]; 
                                    for(Contact_Validation_Audit_Trail__c aulist : updatemdm) {
                                        aulist.Sent_to_MDM__c = 'N/A';
                                        aulist.Address_Type__c = 'Primary';
                                    }                       
                                    update updatemdm;
                                }
                               //New Values 
                                Contact_Validation_Audit_Trail__c auditObj = new Contact_Validation_Audit_Trail__c();                                           
                                auditObj.Provider_Information_Summary__c = addressRecordId;
                                auditObj.New_Street_Address__c = newAddress.strStreetAddress;
                                auditObj.Secure_Suite__c = newAddress.strSuite;
                                auditObj.Secure_Floor__c = newAddress.strFloor;
                                auditObj.First_Name__c = newAddress.strFirstName;
                                auditObj.Middle_Name__c = newAddress.strMiddleName;
                                auditObj.Last_Name__c = newAddress.strLastName;
                                string addressFormat2 = '';
                                if(!String.isBlank(auditObj.New_Street_Address__c)) {
                                    addressFormat2 =  auditObj.New_Street_Address__c; 
                                }
                                if(!string.isBlank(newAddress.strSuite)) {
                                    if(!newAddress.strSuite.containsIgnoreCase('STE')) {
                                        addressFormat2 = addressFormat2 + ' STE ' + newAddress.strSuite;
                                    } else {
                                        addressFormat2 = addressFormat2 + ' ' + newAddress.strSuite;
                                    }
                                }
                                if(!string.isBlank(newAddress.strFloor)) {
                                    if(!newAddress.strFloor.containsIgnoreCase('FL')) {
                                        addressFormat2 = addressFormat2 + ' FL ' + newAddress.strFloor;
                                    } else {
                                        addressFormat2 = addressFormat2 + '  ' + newAddress.strFloor;
                                    }
                                }
                                auditObj.Secure_Street_Address__c = addressFormat2;
                                auditObj.Secure_City__c = newAddress.strCity;
                                auditObj.Secure_State__c = newAddress.strstate;
                                auditObj.Secure_Zip_Code__c = newAddress.strZipCode; 
                                auditObj.Secure_Phone__c = newAddress.strPhone;
                                auditObj.Secure_FAX__c = newAddress.strFAX;
                                auditObj.Secure_Phone_Ext__c = newAddress.strPhoneExt;
                                auditObj.Contact_Id__c = providerId;
                                auditObj.Email__c = newAddress.strEmail;
                                auditObj.Mobile_Phone__c = newAddress.strMobilePhone;
                                auditObj.Ok_to_Text__c = newAddress.strOkToText;
                                auditObj.Serial_Number__c = pISObjOld.Serial_Number__c != null ? String.valueOf(pISObjOld.Serial_Number__c) : null; //New Change 
                                
                                /* Req-3696:Description : Date 15/10/2015 Provider Id inserted to the 'Contact Validation Audit Trail' Object */
                                auditObj.Provider_ID__c = pISObjOld.Provider_ID__c;
                                /*Description : Date 15/10/2015 Provider Id inserted to the 'Contact Validation Audit Trail' Object */
                                auditObj.Case__c = caseId;
                                auditObj.Attn_To__c = newAddress.strAttenTo;
                                auditObj.Names_Changes_Suggested__c = newAddress.strNameChangesSugg;
                                if((newAddress.strCity != pISObjOld.Secure_City__c) || (newAddress.strStreetAddress != pISObjOld.New_Street_Address__c) || 
                                    (newAddress.strZipCode != pISObjOld.Secure_Zip_Code__c) || (newAddress.strSuite != pISObjOld.Secure_Suite__c) || (newAddress.strFloor != pISObjOld.Secure_Floor__c)
                                    || (newAddress.strPhone != pISObjOld.Secure_Phone__c) || (newAddress.strFAX != pISObjOld.Secure_FAX__c) || (newAddress.strstate != pISObjOld.Secure_State__c)) {
                                    auditObj.address_modified__c = 'Yes';
                                    
                                } else {
                                    auditObj.address_modified__c = 'No';
                                    
                                }
                                string strLog = '';
                                strLog = strLog + 'At ' + system.now().format() + ' S#' +  auditObj.Serial_Number__c + '<br/>';
                                if(newAddress.strCity != pISObjOld.Secure_City__c) {
                                    strLog  = strLog + ' City ' + '<br/>' +
                                                'From ' + pISObjOld.Secure_City__c + '<br/>' +
                                                'To ' + newAddress.strCity + '<br/><br/>'; 
                                }
                                if(newAddress.strStreetAddress != pISObjOld.New_Street_Address__c) {
                                    strLog  = strLog + ' Street Address ' + '<br/> ' +
                                                'From ' + pISObjOld.New_Street_Address__c + '<br/>' +
                                                'To ' + newAddress.strStreetAddress + '<br/><br/>'; 
                                }
                                
                                if(newAddress.strZipCode != pISObjOld.Secure_Zip_Code__c) {
                                    strLog  = strLog + ' ZipCode ' +  '<br/> ' +
                                                'From ' + pISObjOld.Secure_Zip_Code__c + '<br/>' +
                                                'To ' + newAddress.strZipCode + '<br/><br/>';
                                               
                                }
                                
                                if((newAddress.strSuite != pISObjOld.Secure_Suite__c) && (!String.isBlank(newAddress.strSuite) || !String.isBlank(pISObjOld.Secure_Suite__c))) {
                                strLog  = strLog + ' Suite ' +  '<br/> ' +
                                            'From ' + pISObjOld.Secure_Suite__c + '<br/>' +
                                            'To ' + newAddress.strSuite  + '<br/><br/>'; 
                                }
                                if((newAddress.strFloor != pISObjOld.Secure_Floor__c) && (!String.isBlank(newAddress.strFloor) || !String.isBlank(pISObjOld.Secure_Floor__c))) {
                                    strLog  = strLog + ' Floor ' +  '<br/> ' +
                                                'From ' + pISObjOld.Secure_Floor__c + '<br/>' +
                                                'To ' + newAddress.strFloor + '<br/><br/>'; 
                                }
                                if((newAddress.strstate != pISObjOld.Secure_State__c)) {
                                    strLog  = strLog + ' State ' +  '<br/> ' +
                                                'From ' + pISObjOld.Secure_State__c + '<br/>' +
                                                'To ' + newAddress.strstate + '<br/><br/>'; 
                                }
                                if((newAddress.strPhone != pISObjOld.Secure_Phone__c) && (!String.isBlank(newAddress.strPhone) || !String.isBlank(pISObjOld.Secure_Phone__c))) {
                                    strLog  = strLog + ' Phone ' +  '<br/> ' +
                                                'From ' + pISObjOld.Secure_Phone__c + '<br/>' +
                                                'To ' + newAddress.strPhone + '<br/><br/>'; 
                                }
                                if((newAddress.strFAX != pISObjOld.Secure_FAX__c) && (!String.isBlank(newAddress.strFAX) || !String.isBlank(pISObjOld.Secure_FAX__c))) {
                                    strLog  = strLog + ' Fax ' +  '<br/> ' +
                                                'From ' + pISObjOld.Secure_FAX__c + '<br/>' +
                                                'To ' + newAddress.strFAX + '<br/><br/>'; 
                                }
                                if((newAddress.strEmail != pISObjOld.Email__c) && (!String.isBlank(newAddress.strEmail) || !String.isBlank(pISObjOld.Email__c))) {
                                    strLog  = strLog + ' Email ' +  '<br/> ' +
                                                'From ' + pISObjOld.Email__c + '<br/>' +
                                                'To ' + newAddress.strEmail + '<br/><br/>'; 
                                }
                                if((newAddress.strMobilePhone != pISObjOld.Mobile_Phone__c) && (!String.isBlank(newAddress.strMobilePhone) || !String.isBlank(pISObjOld.Mobile_Phone__c))) {
                                    strLog  = strLog + ' Mobile Phone ' +  '<br/> ' +
                                                'From ' + pISObjOld.Mobile_Phone__c + '<br/>' +
                                                'To ' + newAddress.strMobilePhone + '<br/><br/>'; 
                                }
                                if((newAddress.strAttenTo != pISObjOld.Attn_To__c) && (!String.isBlank(newAddress.strAttenTo) || !String.isBlank(pISObjOld.Attn_To__c))) {
                                    strLog  = strLog + ' Attn To ' +  '<br/> ' +
                                                'From ' + pISObjOld.Attn_To__c + '<br/>' +
                                                'To ' + newAddress.strAttenTo + '<br/><br/>'; 
                                }
                                if((newAddress.strNameChangesSugg != pISObjOld.Names_Changes_Suggested__c) && (!String.isBlank(newAddress.strNameChangesSugg) || !String.isBlank(pISObjOld.Names_Changes_Suggested__c))) {
                                    strLog  = strLog + ' Name Changes Suggestion ' +  '<br/> ' +
                                                'From ' + pISObjOld.Names_Changes_Suggested__c + '<br/>' +
                                                'To ' + newAddress.strNameChangesSugg + '<br/><br/>'; 
                                }
                                auditObj.Address_Change__c = strLog;
                                if(String.valueOf(pISObjOld.Serial_Number__c) == '1'){
                                   auditObj.Sent_to_MDM__c = '';//New Field
                                   auditObj.Address_Type__c = 'Primary';
                                }
                                else{
                                     auditObj.Sent_to_MDM__c = 'N/A';//New Field
                                     auditObj.Address_Type__c = 'Secondary';
                                }
                                auditObj.Preferred_Communication_Method__c = pISObjOld.Preferred_Communication_Method__c;
                                insert  auditObj;
                                              
                               //-----------------------------------------------------
                            }
                        
                        Contact_Validation_Summary__c pISObj = new Contact_Validation_Summary__c(id=addressRecordId);
                        
                         // REQ 3670 Start- Populating the Validation Source Channel field with SFSA value
                        pISObj.Validation_Source_Channel__c = 'SFSA';
                        pISObj.Status__c = 'Validated';
                        
                        List<Contact_Validation_Audit_Trail__c> lstAudit = [select id,Secure_City__c,Secure_Floor__c,Secure_State__c,Secure_Street_Address__c,Secure_Suite__c,Secure_Zip_Code__c from Contact_Validation_Audit_Trail__c where Provider_Information_Summary__c=:addressRecordId AND Sent_to_MDM__c='N/A' Order By CreatedDate ASC limit 1];
                
                       //REQ 3670 start - Address Changes Tracking 
                     /**  if(!lstAudit.isEmpty()){
                 
                        Contact_Validation_Audit_Trail__c objaudit = lstAudit[0];
                 
                       if(pISObj.Secure_City__c!=objAudit.Secure_City__c || pISObj.Secure_Floor__c!=objAudit.Secure_Floor__c || pISObj.Secure_State__c!=objAudit.Secure_State__c || pISObj.New_Street_Address__c!=objAudit.Secure_Street_Address__c || pISObj.Secure_Suite__c!=objAudit.Secure_Suite__c || pISObj.Secure_Zip_Code__c!=objAudit.Secure_Zip_Code__c )
                         pISObj.Address_Only_Modified__c = true;                     
                    
                    
                       } **/
                        
                        
                        
                        // REQ 3670 End
                        
                        pISObj.New_Street_Address__c = newAddress.strStreetAddress;
                        pISObj.Secure_Suite__c = newAddress.strSuite;
                        pISObj.Secure_Floor__c = newAddress.strFloor;
                        //Start:Added for Production Defect
                        pISObj.Provider_Name__c=contactInfo.Provider_Name__c;
                        //Req-3696 Updated Provider ID with Provider External ID
                        pISObj.Provider_ID__c=contactInfo.Contact_External_ID1__c;
                        //End:Added for Production Defect
                        string addressFormat = '';
                        if(!String.isBlank(pISObj.New_Street_Address__c)) {
                            addressFormat =  pISObj.New_Street_Address__c; 
                        }
                        if(!string.isBlank(pISObj.Secure_Suite__c)) {
                            if(!pISObj.Secure_Suite__c.containsIgnoreCase('STE')) {
                                addressFormat = addressFormat + ' STE ' + pISObj.Secure_Suite__c;
                            } else {
                                addressFormat = addressFormat + ' ' + pISObj.Secure_Suite__c;
                            }
                        }
                        if(!string.isBlank(pISObj.Secure_Floor__c)) {
                            if(!pISObj.Secure_Floor__c.containsIgnoreCase('FL')) {
                                addressFormat = addressFormat + ' FL ' + pISObj.Secure_Floor__c;
                            } else {
                                addressFormat = addressFormat + '  ' + pISObj.Secure_Floor__c;
                            }
                        }
                        pISObj.Secure_Street_Address__c = addressFormat; 
                        pISObj.Secure_City__c = newAddress.strCity;
                        pISObj.Secure_State__c = newAddress.strstate;
                        pISObj.Secure_Zip_Code__c = newAddress.strZipCode;
                        pISObj.Secure_Phone__c = newAddress.strPhone;
                        pISObj.Secure_FAX__c = newAddress.strFAX;
                        pISObj.Secure_Phone_Ext__c = newAddress.strPhoneExt;
                        pISObj.Last_Verified_Date__c = system.now();
                        pISObj.Email__c = newAddress.strEmail;
                        pISObj.Mobile_Phone__c = newAddress.strMobilePhone;
                        pISObj.Ok_to_Text__c = newAddress.strOkToText;
                        pISObj.Attn_To__c = newAddress.strAttenTo;
                        pISObj.Names_Changes_Suggested__c = newAddress.strNameChangesSugg;
                        /** REQ 3611 : Update Summary record owner on address validation **/
                        pISObj.OwnerId = UserInfo.getUserId();
                
                        if((newAddress.strCity != pISObjOld.Secure_City__c) || (newAddress.strStreetAddress != pISObjOld.New_Street_Address__c) || 
                            (newAddress.strZipCode != pISObjOld.Secure_Zip_Code__c) || (newAddress.strSuite != pISObjOld.Secure_Suite__c) || (newAddress.strFloor != pISObjOld.Secure_Floor__c)
                            || (newAddress.strPhone != pISObjOld.Secure_Phone__c) || (newAddress.strFAX != pISObjOld.Secure_FAX__c) || (newAddress.strstate != pISObjOld.Secure_State__c)) {
                            pISObj.address_modified__c = 'Yes';
                        } 
                        //Req 3670-Start Address change tracking 
                        if((newAddress.strCity != pISObjOld.Secure_City__c) || (newAddress.strStreetAddress != pISObjOld.New_Street_Address__c) || 
                            (newAddress.strZipCode != pISObjOld.Secure_Zip_Code__c) || (newAddress.strSuite != pISObjOld.Secure_Suite__c) || (newAddress.strFloor != pISObjOld.Secure_Floor__c)
                            || (newAddress.strstate != pISObjOld.Secure_State__c)) {
                            pISObj.address_only_modified__c = 'Yes';
                        }

                        //Req 3670-End Address change tracking                      
                        
                        
                        update pISObj;
                    } else {
                        Contact_Validation_Summary__c pISObj = new Contact_Validation_Summary__c();
                        pISObj.New_Street_Address__c = newAddress.strStreetAddress;
                        pISObj.Secure_Suite__c = newAddress.strSuite;
                        pISObj.Secure_Floor__c = newAddress.strFloor;
                        string addressFormat = '';
                        if(!String.isBlank(pISObj.New_Street_Address__c)) {
                            addressFormat =  pISObj.New_Street_Address__c; 
                        }
                        if(!string.isBlank(pISObj.Secure_Suite__c)) {
                            if(!pISObj.Secure_Suite__c.containsIgnoreCase('STE')) {
                                addressFormat = addressFormat + ' STE ' + pISObj.Secure_Suite__c;
                            } else {
                                addressFormat = addressFormat + ' ' + pISObj.Secure_Suite__c;
                            }
                        }
                        if(!string.isBlank(pISObj.Secure_Floor__c)) {
                            if(!pISObj.Secure_Floor__c.containsIgnoreCase('FL')) {
                                addressFormat = addressFormat + ' FL ' + pISObj.Secure_Floor__c;
                            } else {
                                addressFormat = addressFormat + '  ' + pISObj.Secure_Floor__c;
                            }
                        }
                        pISObj.Secure_Street_Address__c = addressFormat;
                        pISObj.Secure_City__c = newAddress.strCity;
                        pISObj.Secure_State__c = newAddress.strstate;
                        pISObj.Secure_Zip_Code__c = newAddress.strZipCode;
                        pISObj.Secure_Phone__c = newAddress.strPhone;
                        pISObj.Secure_FAX__c = newAddress.strFAX;
                        pISObj.Secure_Phone_Ext__c = newAddress.strPhoneExt;
                        pISObj.Contact_Id__c = providerId;
                        pISObj.Last_Verified_Date__c = system.now();
                        pISObj.Address_Type__c = 'Secondary';
                        pISObj.Attn_To__c = newAddress.strAttenTo;
                        pISObj.Names_Changes_Suggested__c = newAddress.strNameChangesSugg;
                        //Start:Added for Production Defect
                        pISObj.Provider_Name__c=contactInfo.Provider_Name__c;
                        //Req-3696:Updated Provider Id with Provider External ID
                        pISObj.Provider_ID__c=contactInfo.Contact_External_ID1__c;
                        //End:Added for Production Defect
                        insert pISObj;
                        pISObj = [select Serial_Number__c,Provider_ID__c,New_Street_Address__c,Secure_Suite__c,Secure_Floor__c,Secure_Street_Address__c,Secure_City__c,Secure_State__c,Secure_Zip_Code__c,Secure_FAX__c,Secure_Phone__c,Secure_Phone_Ext__c,
Contact_Id__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,Preferred_Communication_Method__c,Provider_FirstName__c,Provider_LastName__c,Provider_MiddleName__c,Address_Type__c,Attn_To__c,Names_Changes_Suggested__c from Contact_Validation_Summary__c where Id = :pISObj.Id];
                        
                        Contact_Validation_Audit_Trail__c auditObj = new Contact_Validation_Audit_Trail__c();                                           
                        auditObj.Provider_Information_Summary__c = pISObj.id;
                        //Req-3696:10/26/2015 Updated FirstName,MiddleName,LastName
                        auditObj.First_Name__c = pISObj.Provider_FirstName__c;
                        auditObj.Middle_Name__c = pISObj.Provider_MiddleName__c;
                        auditObj.Last_Name__c = pISObj.Provider_LastName__c;
                        auditObj.New_Street_Address__c = pISObj.New_Street_Address__c;
                        auditObj.Secure_Suite__c = pISObj.Secure_Suite__c;
                        auditObj.Secure_Floor__c = pISObj.Secure_Floor__c;
                        auditObj.Secure_Street_Address__c = pISObj.Secure_Street_Address__c;
                        auditObj.Secure_City__c = pISObj.Secure_City__c;
                        auditObj.Secure_State__c = pISObj.Secure_State__c;
                        auditObj.Secure_Zip_Code__c = pISObj.Secure_Zip_Code__c; 
                        auditObj.Secure_Phone__c = pISObj.Secure_Phone__c;
                        auditObj.Secure_FAX__c = pISObj.Secure_FAX__c;
                        auditObj.Secure_Phone_Ext__c = pISObj.Secure_Phone_Ext__c;
                        auditObj.Contact_Id__c = pISObj.Contact_Id__c;
                        auditObj.Email__c = pISObj.Email__c;
                        auditObj.Mobile_Phone__c = pISObj.Mobile_Phone__c;
                        auditObj.Ok_to_Text__c = pISObj.Ok_to_Text__c;
                       /*Req-3696:Description : Date 15/10/2015 Provider Id inserted to the 'Contact Validation Audit Trail' Object */
                       auditObj.Provider_ID__c = pISObj.Provider_ID__c;
                       /*Description : Date 15/10/2015 Provider Id inserted to the 'Contact Validation Audit Trail' Object */
                       auditObj.Serial_Number__c = pISObj.Serial_Number__c != null ? String.valueOf(pISObj.Serial_Number__c) : null;
                       auditObj.address_modified__c = 'No';
                       auditObj.Address_Change__c = 'At '+ system.now().format() + ' S#' +  pISObj.Serial_Number__c + ' Validated';
                       auditObj.Preferred_Communication_Method__c = pISObj.Preferred_Communication_Method__c;
                       auditObj.Attn_To__c = pISObj.Attn_To__c;
                       auditObj.Names_Changes_Suggested__c = pISObj.Names_Changes_Suggested__c;
                    if(String.valueOf(pISObj.Serial_Number__c) == '1') {
                        auditObj.Sent_to_MDM__c = ''; 
                        auditObj.Address_Type__c = 'Primary';
                    } else {
                        auditObj.Sent_to_MDM__c = 'N/A'; 
                        auditObj.Address_Type__c = 'Secondary';
                    }
                        
                        auditObj.Case__c = caseId;
                        auditObj.Address_Change__c = 'At '+ system.now().format() + ' S#' +  pISObj.Serial_Number__c + ' Inserted';
                        insert auditObj;
                    }
            } else {
                    PDV_EAF_Facility__c pISObjOld = [Select ZIP_CODE__c, STATE__c, PHONE__c, Name, Facility_ID__c, FAX_NUMBER__c, CITY__c, ADDRESS__c,Last_Verified_date__c,Case__c,Attn_To__c,
                                                    Names_Changes_Suggested__c,Suite__c,Floor__c,Phone_Extension__c,address_modified__c,Serial_Number__c from  
                                                    PDV_EAF_Facility__c where Id= :addressRecordId];
                    pISObjOld.CITY__c = pISObjOld.CITY__c == null ? '' : pISObjOld.CITY__c;
                    pISObjOld.ADDRESS__c = pISObjOld.ADDRESS__c == null ? '' : pISObjOld.ADDRESS__c;
                    pISObjOld.Floor__c = pISObjOld.Floor__c == null ? '' : pISObjOld.Floor__c;
                    pISObjOld.ZIP_CODE__c = pISObjOld.ZIP_CODE__c == null ? '' : pISObjOld.ZIP_CODE__c;
                    pISObjOld.Suite__c = pISObjOld.Suite__c == null ? '' : pISObjOld.Suite__c;                                 
                    PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();                                           
                    auditObj.EAF_Facility__c = pISObjOld.id;
                    auditObj.ADDRESS__c = pISObjOld.ADDRESS__c;
                    auditObj.CITY__c = pISObjOld.CITY__c;
                    auditObj.STATE__c = pISObjOld.STATE__c;
                    auditObj.ZIP_CODE__c = pISObjOld.ZIP_CODE__c; 
                    auditObj.Suite__c = pISObjOld.Suite__c;
                    auditObj.Floor__c = pISObjOld.Floor__c;
                    auditObj.PHONE__c = pISObjOld.PHONE__c;
                    auditObj.FAX_NUMBER__c = pISObjOld.FAX_NUMBER__c;
                    auditObj.Phone_Extension__c = pISObjOld.Phone_Extension__c;
                    auditObj.Attn_To__c = pISObjOld.Attn_To__c;
                    auditObj.Names_Changes_Suggested__c = pISObjOld.Names_Changes_Suggested__c;
                    if((newAddress.strCity != pISObjOld.CITY__c) || (newAddress.strStreetAddress != pISObjOld.ADDRESS__c) || (newAddress.strZipCode != pISObjOld.ZIP_CODE__c) || 
                                    (newAddress.strSuite != pISObjOld.Suite__c) || (newAddress.strFloor != pISObjOld.Floor__c)
                                    || (newAddress.strPhone != pISObjOld.PHONE__c) || (newAddress.strFAX != pISObjOld.FAX_NUMBER__c) || (newAddress.strstate != pISObjOld.STATE__c)) {
                            auditObj.address_modified__c = 'Yes';
                    } else {
                            auditObj.address_modified__c = 'No';
                    }
                    auditObj.Serial_Number__c = pISObjOld.Serial_Number__c != null ? String.valueOf(pISObjOld.Serial_Number__c) : null; //New Change  
                    auditObj.case__c = caseId;
                    
                    pISObjOld.Suite__c = pISObjOld.Suite__c == null ? pISObjOld.Suite__c = '' : pISObjOld.Suite__c;
                    pISObjOld.Floor__c = pISObjOld.Floor__c == null ? pISObjOld.Floor__c = '' : pISObjOld.Floor__c;
                    string strLog = '';
                    strLog = strLog + 'At ' + system.now().format() + ' S#' +  auditObj.Serial_Number__c + '<br/>';
                    if(newAddress.strCity != pISObjOld.CITY__c) {
                        strLog  = strLog + ' City ' + '<br/>' +
                                    'From ' + pISObjOld.CITY__c + '<br/>' +
                                    'To ' + newAddress.strCity + '<br/><br/>'; 
                    }
                    if(newAddress.strStreetAddress != pISObjOld.ADDRESS__c) {
                        strLog  = strLog + ' Street Address ' + '<br/> ' +
                                    'From ' + pISObjOld.ADDRESS__c + '<br/>' +
                                    'To ' + newAddress.strStreetAddress + '<br/><br/>';  
                    }
                    if(newAddress.strZipCode != pISObjOld.ZIP_CODE__c) {
                        strLog  = strLog + ' ZipCode ' +  '<br/> ' +
                                    'From ' + pISObjOld.ZIP_CODE__c + '<br/>' +
                                    'To ' + newAddress.strZipCode + '<br/><br/>'; 
                    }
                    if((newAddress.strSuite != pISObjOld.Suite__c) && (!String.isBlank(newAddress.strSuite) || !String.isBlank(pISObjOld.Suite__c))) {
                        strLog  = strLog + ' Suite ' +  '<br/> ' +
                                    'From ' + pISObjOld.Suite__c + '<br/>' +
                                    'To ' + newAddress.strSuite  + '<br/><br/>'; 
                    }
                    if((newAddress.strFloor != pISObjOld.Floor__c) && (!String.isBlank(newAddress.strFloor) || !String.isBlank(pISObjOld.Floor__c))) {
                        strLog  = strLog + ' Floor ' +  '<br/> ' +
                                    'From ' + pISObjOld.Floor__c + '<br/>' +
                                    'To ' + newAddress.strFloor + '<br/><br/>'; 
                    }
                    if((newAddress.strstate != pISObjOld.STATE__c)) {
                        strLog  = strLog + ' State ' +  '<br/> ' +
                                    'From ' + pISObjOld.STATE__c + '<br/>' +
                                    'To ' + newAddress.strstate + '<br/><br/>'; 
                    }
                    if((newAddress.strPhone != pISObjOld.PHONE__c) && (!String.isBlank(newAddress.strPhone) || !String.isBlank(pISObjOld.PHONE__c))) {
                        strLog  = strLog + ' Phone ' +  '<br/> ' +
                                    'From ' + pISObjOld.PHONE__c + '<br/>' +
                                    'To ' + newAddress.strPhone + '<br/><br/>'; 
                    }
                    if((newAddress.strFAX != pISObjOld.FAX_NUMBER__c) && (!String.isBlank(newAddress.strFAX) || !String.isBlank(pISObjOld.FAX_NUMBER__c))) {
                        strLog  = strLog + ' Fax ' +  '<br/> ' +
                                    'From ' + pISObjOld.FAX_NUMBER__c + '<br/>' +
                                    'To ' + newAddress.strFAX + '<br/><br/>'; 
                    }
                    if((newAddress.strAttenTo != pISObjOld.Attn_To__c) && (!String.isBlank(newAddress.strAttenTo) || !String.isBlank(pISObjOld.Attn_To__c))) {
                        strLog  = strLog + ' Attn To ' +  '<br/> ' +
                                    'From ' + pISObjOld.Attn_To__c + '<br/>' +
                                    'To ' + newAddress.strAttenTo + '<br/><br/>'; 
                    }
                    if((newAddress.strNameChangesSugg != pISObjOld.Names_Changes_Suggested__c) && (!String.isBlank(newAddress.strNameChangesSugg) || !String.isBlank(pISObjOld.Names_Changes_Suggested__c))) {
                        strLog  = strLog + ' Name Changes Suggestion ' +  '<br/> ' +
                                    'From ' + pISObjOld.Names_Changes_Suggested__c + '<br/>' +
                                    'To ' + newAddress.strNameChangesSugg + '<br/><br/>'; 
                    }
                    auditObj.Address_Change__c = strLog;
                    insert  auditObj;
                    

                    PDV_EAF_Facility__c pISObj = new PDV_EAF_Facility__c(id=addressRecordId);
                    pISObj.ADDRESS__c = newAddress.strStreetAddress; //mapAddress.get(addressRecordId).strStreetAddress;//newAddress.strStreetAddress;
                    pISObj.CITY__c = newAddress.strCity;
                    pISObj.STATE__c = newAddress.strstate;
                    pISObj.ZIP_CODE__c = newAddress.strZipCode;
                    pISObj.Suite__c = newAddress.strSuite;
                    pISObj.Floor__c = newAddress.strFloor;
                    pISObj.PHONE__c = newAddress.strPhone;
                    pISObj.FAX_NUMBER__c = newAddress.strFAX;
                    pISObj.Phone_Extension__c = newAddress.strPhoneExt;
                    pISObj.Last_Verified_Date__c = system.today();
                    pISObj.Attn_To__c = newAddress.strAttenTo;
                    pISObj.Names_Changes_Suggested__c = newAddress.strNameChangesSugg;
                    if((newAddress.strCity != pISObjOld.CITY__c) || (newAddress.strStreetAddress != pISObjOld.ADDRESS__c) || (newAddress.strZipCode != pISObjOld.ZIP_CODE__c) || 
                                    (newAddress.strSuite != pISObjOld.Suite__c) || (newAddress.strFloor != pISObjOld.Floor__c)
                                    || (newAddress.strPhone != pISObjOld.PHONE__c) || (newAddress.strFAX != pISObjOld.FAX_NUMBER__c) || (newAddress.strstate != pISObjOld.STATE__c) ) {
                            pISObj.address_modified__c = 'Yes';
                    } 
                    update pISObj;
            }
            getProviderInfo();
            getAddressValidation();
            addressRecordId = null;
            isAddressValidAllFields = true;
            //newAddress = new WrAddressValidation();
            isCreatingCase = true;
            isAddressValidated = true;
            fillCaseAddressHistory();
        } catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        return null;
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to validate selected address
    * @param 
    * @return void
    */
    public void validateAddress() {
        List<Contact_Validation_Summary__c> lstContactValSumm = new List<Contact_Validation_Summary__c>();
        List<PDV_EAF_Facility__c> lstPDVFacilty = new List<PDV_EAF_Facility__c>();
        List<PDV_EAF_Validation_Audit_Trail__c> pdvEAFAuditLst = new List<PDV_EAF_Validation_Audit_Trail__c>();
        List<Contact_Validation_Audit_Trail__c> contactAuditLst = new List<Contact_Validation_Audit_Trail__c>();
        
       // Map<Id,Contact_Validation_Audit_Trail__c> mapAuditRecords = new Map<Id,Contact_Validation_Audit_Trail__c>();
      //  Set<Id> setRecordIds = new Set<Id>();
        
      //  for(WrAddressValidation objwAdd : wrAddressValidationlist)
      //  setRecordIds.add(objwAdd.recordId);
    
      /**  for(Contact_Validation_Audit_Trail__c objAud:[select id,Secure_City__c,Secure_Floor__c,Secure_State__c,Secure_Street_Address__c,        Secure_Suite__c,Secure_Zip_Code__c from Contact_Validation_Audit_Trail__c where Provider_Information_Summary__c in:setRecordIds AND Sent_to_MDM__c = 'N/A']) **/
            
      //  mapAuditRecords.put(objAud.Provider_Information_Summary__c,objAud);
        
        
        for(WrAddressValidation wAdd : wrAddressValidationlist){
            if(wAdd.isSelected  == true) {
                if(prefix == '003') {
                    Contact_Validation_Summary__c pISObj = [select Serial_Number__c,Provider_ID__c,New_Street_Address__c,Secure_Suite__c,Secure_Floor__c,Secure_Street_Address__c,Secure_City__c,Secure_State__c,Secure_Zip_Code__c,Secure_FAX__c,Secure_Phone__c,Secure_Phone_Ext__c,
Contact_Id__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,Preferred_Communication_Method__c,Provider_FirstName__c,Provider_LastName__c,Provider_MiddleName__c,Address_Type__c,Attn_To__c,Names_Changes_Suggested__c from Contact_Validation_Summary__c where Id =:wAdd.recordId];
                    pISObj.Last_Verified_Date__c = system.now();
                    /** REQ 3611 : Update Summary record owner on address validation **/
                    pISObj.OwnerId = UserInfo.getUserId();
                    
                     // REQ 3670 Start- Populating the Validation Source Channel field with SFSA value and verifying the Address only modified    Changes
                        pISObj.Validation_Source_Channel__c = 'SFSA';
                        pISObj.Status__c = 'Validated';
                        
                    
                 //   Contact_Validation_Audit_Trail__c objAudit = mapAuditRecords.get(wAdd.recordId);
                    //REQ 3670 start - Address Changes Tracking 
                /**    if(objAudit!=null){
                    if(pISObj.Secure_City__c!=objAudit.Secure_City__c || pISObj.Secure_Floor__c!=objAudit.Secure_Floor__c || pISObj.Secure_State__c!=objAudit.Secure_State__c || pISObj.New_Street_Address__c!=objAudit.Secure_Street_Address__c || pISObj.Secure_Suite__c!=objAudit.Secure_Suite__c || pISObj.Secure_Zip_Code__c!=objAudit.Secure_Zip_Code__c )
                 
                     pISObj.Address_Only_Modified__c = true;    
                    } **/
                    
                    // REQ 3670 End
                    
                    lstContactValSumm.add(pISObj);
                    //Req-3696:10/26/2015  Updated Previous records Sent_to_MDM__c  to N/A
                    /*************************************************/
                    List<Contact_Validation_Audit_Trail__c> auditobjlist = New List<Contact_Validation_Audit_Trail__c>();
                    List<Contact_Validation_Audit_Trail__c> auditObjold = [select Serial_Number__c from Contact_Validation_Audit_Trail__c where Contact_Id__c =:pISObj.Contact_Id__c]; 
                    if(pISObj.Address_Type__c == 'Primary'){
                    for(Contact_Validation_Audit_Trail__c auditobjrec : auditObjold) {
                    auditobjrec.Sent_to_MDM__c = 'N/A';
                    auditobjlist.add(auditobjrec);
                    }
                    Update auditobjlist;
                    }

                    Contact_Validation_Audit_Trail__c auditObj = new Contact_Validation_Audit_Trail__c();                                           
                    auditObj.Provider_Information_Summary__c = wAdd.recordId;
                    auditObj.First_Name__c = pISObj.Provider_FirstName__c;
                    auditObj.Middle_Name__c = pISObj.Provider_MiddleName__c;
                    auditObj.Last_Name__c = pISObj.Provider_LastName__c;
                    auditObj.New_Street_Address__c = pISObj.New_Street_Address__c;
                    auditObj.Secure_Suite__c = pISObj.Secure_Suite__c;
                    auditObj.Secure_Floor__c = pISObj.Secure_Floor__c;
                    auditObj.Secure_Street_Address__c = pISObj.Secure_Street_Address__c;
                    auditObj.Secure_City__c = pISObj.Secure_City__c;
                    auditObj.Secure_State__c = pISObj.Secure_State__c;
                    auditObj.Secure_Zip_Code__c = pISObj.Secure_Zip_Code__c; 
                    auditObj.Secure_Phone__c = pISObj.Secure_Phone__c;
                    auditObj.Secure_FAX__c = pISObj.Secure_FAX__c;
                    auditObj.Secure_Phone_Ext__c = pISObj.Secure_Phone_Ext__c;
                    auditObj.Contact_Id__c = pISObj.Contact_Id__c;
                    auditObj.Email__c = pISObj.Email__c;
                    auditObj.Mobile_Phone__c = pISObj.Mobile_Phone__c;
                    /*Req-3696:Description : Date 15/10/2015 Provider Id inserted to the 'Contact Validation Audit Trail' Object */
                    auditObj.Provider_ID__c = pISObj.Provider_ID__c;
                    /*Description : Date 15/10/2015 Provider Id inserted to the 'Contact Validation Audit Trail' Object */
                    auditObj.Ok_to_Text__c = pISObj.Ok_to_Text__c;
                    auditObj.Serial_Number__c = pISObj.Serial_Number__c != null ? String.valueOf(pISObj.Serial_Number__c) : null;
                    auditObj.address_modified__c = 'No';
                    auditObj.Address_Change__c = 'At '+ system.now().format() + ' S#' +  pISObj.Serial_Number__c + ' Validated';
                    auditObj.Case__c = caseId;
                    auditObj.Preferred_Communication_Method__c = pISObj.Preferred_Communication_Method__c;
                    auditObj.Attn_To__c = pISObj.Attn_To__c;
                    auditObj.Names_Changes_Suggested__c = pISObj.Names_Changes_Suggested__c;
                    if(String.valueOf(pISObj.Serial_Number__c) == '1') {
                        auditObj.Sent_to_MDM__c = ''; 
                        auditObj.Address_Type__c = 'Primary';
                    } else {
                        auditObj.Sent_to_MDM__c = 'N/A'; 
                        auditObj.Address_Type__c = 'Secondary';
                    }
                    contactAuditLst.add(auditObj);                  
                    
                    /*************************************************/
                    
                } else {
                    PDV_EAF_Facility__c pISObj = [select Serial_Number__c from PDV_EAF_Facility__c where Id =:wAdd.recordId];
                    pISObj.Last_Verified_Date__c = system.today();
                    PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();                                           
                    auditObj.EAF_Facility__c = wAdd.recordId;
                    auditObj.Address_Change__c = 'At '+ system.now().format() + ' S#' +  pISObj.Serial_Number__c + ' Validated';
                    auditObj.Case__c = caseId;
                    pdvEAFAuditLst.add(auditObj);
                    lstPDVFacilty.add(pISObj); 
                }
            }
        }
        if(lstContactValSumm !=null && lstContactValSumm.size()>0) {
            update lstContactValSumm;
        } else if(lstPDVFacilty.size()>0) {
            update lstPDVFacilty;
        }
        if(pdvEAFAuditLst.size()>0) {
            insert pdvEAFAuditLst;
        }
        if(contactAuditLst.size()>0)  {
            insert contactAuditLst;
        }
        getProviderInfo();
        getAddressValidation();
        isCreatingCase = true;
        fillCaseAddressHistory();
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to create a new case
    * @param 
    * @return void
    */
    public boolean isCreatingCase {get;set;}
    public string strCaseContactPhoneNumber {get;set;}
    public void createCase() {
        try {
            isCreatingCase = true;
            caseObj = new Case();
            strCaseContactPhoneNumber = '';
            caseObj.subject = 'Test';
            caseObj.recordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Summary of Care').RecordTypeId;
            caseObj.origin = 'Outbound Call';
            caseObj.SOC_Document_Status__c = 'Not Sent';
            caseObj.Common_Subject_Lines__c = 'Validated Provider/ EAF';
            if(prefix == '003') {
                caseObj.Provider_Name__c =  contactInfo.Name;
                caseObj.Provider_Type__c =  'Provider';
                caseObj.Provider_Id_EAF_ID__c = contactInfo.Provider_ID__c;
                caseObj.contactId = providerId;
            } else {
                caseObj.Provider_Name__c =  faciltyInfo.Name;
                caseObj.Provider_Type__c =  'Facility';
                caseObj.Provider_Id_EAF_ID__c = faciltyInfo.Facility_ID__c;
            }
           
            insert caseObj;
            caseObj = [select OwnerId, casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                        status,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, Communication_Preference_Changed_To_Fax__c,
                        subject,description,CreatedBy.Name,owner.Name,
                        (Select ADDRESS__c, CITY__c, STATE__c, ZIP_CODE__c, PHONE__c, FAX_NUMBER__c, Suite__c, Floor__c, Address_Modified__c From EAF_Validation_Audit_Trails__r), 
                                (Select Secure_City__c, Secure_Fax__c, Secure_Phone__c, Secure_State__c, Secure_Street_Address__c, Secure_Zip_Code__c, Secure_Suite__c, Secure_Floor__c, 
                                Secure_Phone_Ext__c, Address_Modified__c From Provider_Validation_Updates__r)       
                        from case where Id = :caseObj.Id];
            if(caseObj.id != null && socId != null) {
                SOC_Queue__c socQueueRecord = [select id from SOC_Queue__c where id=:socId];
                caseId = caseObj.id;
                socQueueRecord.Associated_Case_Id__c = caseObj.Id;
                update socQueueRecord;
            }            
        } catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to update a new case
    * @param 
    * @return void
    */
    public PageReference updateCase() {
        caseStatus = '';
        //caseObj.Contact_Number__c = (!String.isblank(strCaseContactPhoneNumber) ? Integer.valueOf(strCaseContactPhoneNumber) : );
        boolean isCaseValidated =  true;
        if(String.isBlank(caseObj.Common_Subject_Lines__c) ||  caseObj.Common_Subject_Lines__c == '--None--') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Subject.'));
            isCaseValidated = false;
        }
        if(caseObj.Status != 'Cannot Reach' && String.isBlank(caseObj.PDV_Contact_Name__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Contact Name.'));
            isCaseValidated = false;
        }
        if(strCaseContactPhoneNumber == null || strCaseContactPhoneNumber == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Contact Number.'));
            isCaseValidated = false;
        } else if(strCaseContactPhoneNumber.isNumeric() || strCaseContactPhoneNumber.length() < 14 || strCaseContactPhoneNumber.length() < 14) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Contact Number is invalid. It must be in the form of (999) 999-9999.'));
            isCaseValidated = false;
        }
        if(String.isBlank(caseObj.Validated_or_not__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Contact Validated or not.'));
            isCaseValidated = false;
        }
        if(prefix == '003' && (String.isBlank(caseObj.Communication_Preference_Changed_To_Fax__c) || caseObj.Communication_Preference_Changed_To_Fax__c == 'None')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Change Communication Preference To Fax?'));
            isCaseValidated = false;
        }
        if(String.isBlank(caseObj.Status)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Status.'));
            isCaseValidated = false;
        } else if(caseObj.Status == 'Escalate To Meaningful Use' && String.isBlank(caseObj.PDV_Escalation_Reason__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Escalation Reason.'));
            isCaseValidated = false;
        }
        if(caseObj.Status != 'Closed' && caseObj.SOC_Document_Status__c == 'Sent') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Status must be closed once SOC Document Status is Sent.'));
            isCaseValidated = false;
        } 
        if(caseObj.Status == 'Escalate To Meaningful Use' && caseObj.SOC_Document_Status__c == 'Sent') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Case cannot be escalated once SOC Document Status is Sent.'));
            isCaseValidated = false;
        }
        if(prefix == '003' && (caseObj.Communication_Preference_Changed_To_Fax__c == 'Yes' && (caseObj.Status == 'New' || caseObj.Status == 'Cannot Reach'))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Communication Preference Changed to fax cannot be Yes  if status is New or Cannot Reach.'));
            isCaseValidated = false;
        }

        if(isCaseValidated == false) {
            return null;
        }
        SOC_Queue__c socQueueRecord;
        try {
            caseObj.subject =  caseObj.Common_Subject_Lines__c;
            List<UserRole> socAgentRole = [SELECT Id, Name FROM UserRole where Name = 'SOC Agents' limit 1];
            if(caseObj.Status == 'Escalate To Meaningful Use' && UserInfo.getUserRoleId() == socAgentRole[0].Id){
                //Escalate CR START
                //caseObj.ownerId = [select Id from Group where DeveloperName = 'Meaningful_Use_Team' and Type = 'Queue'].id;
                caseObj.ownerId = [select Id from Group where DeveloperName = 'Escalated_to_Supervisor' and Type = 'Queue'].id;
                //Escalate CR END
            }
            
            String specialChars = '(|)|^|@| |-|';   // in this string, write all the special chars you want to get ride of, pipe separated
            for(integer i=0; i<specialChars.split('|').size(); i++) {
                strCaseContactPhoneNumber = strCaseContactPhoneNumber.replace(specialChars.split('|')[i], '');
            }
           
            caseObj.Contact_Number__c =  Decimal.valueOf(strCaseContactPhoneNumber);
            //atul
            if(prefix == '003') {
                caseObj.contactId = providerId;
            } else {
                caseObj.EAF_Facility__c = providerId;
            }
            upsert caseObj;
            //atul
            caseObj = [select OwnerId, casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                        status,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, Communication_Preference_Changed_To_Fax__c,
                        subject,description,CreatedBy.Name,owner.Name,
                        (Select ADDRESS__c, CITY__c, STATE__c, ZIP_CODE__c, PHONE__c, FAX_NUMBER__c, Suite__c, Floor__c, Address_Modified__c From EAF_Validation_Audit_Trails__r), 
                                (Select Secure_City__c, Secure_Fax__c, Secure_Phone__c, Secure_State__c, Secure_Street_Address__c, Secure_Zip_Code__c, Secure_Suite__c, Secure_Floor__c, 
                                Secure_Phone_Ext__c, Address_Modified__c From Provider_Validation_Updates__r)       
                        from case where Id = :caseObj.Id];
            if(caseObj.id <> null){
                caseId  = caseObj.id;
                isCustInqSaved = true;
                if(!string.isBlank(socId)) {
                    socQueueRecord = [select id from SOC_Queue__c where id=:socId];
                }
                if(caseObj.Status == CASE_CLOSED_STATUS) {
                    if(caseObj.SOC_Document_Status__c == 'Sent')  {
                        socQueueRecord.Associated_Case_Id__c = caseObj.Id;
                        socQueueRecord.Status__c = SOC_SENT_STATUS;
                        socQueueRecord.Date_SOC_Documents_Sent__c = system.now();
                        update socQueueRecord;
                        //print
                        isPrintAddButton = true;
                    } else if(caseObj.SOC_Document_Status__c != 'Sent') {
                        socQueueRecord.Associated_Case_Id__c = null;
                        update socQueueRecord;
                    }
                    if(caseObj.Communication_Preference_Changed_To_Fax__c == 'Yes') {
                        if(prefix == '003') {
                            /*Contact contactObj = new Contact(Id=providerId);
                            contactObj.Preferred_Communication_Method__c = 'Fax';
                            contactObj.Is_Communication_Preference_changed__c = 'Yes'; 
                            update contactObj;*/
                            updateSummaryInfo();  
                        }
                    }
                } else if(caseObj.Status == 'Escalate To Meaningful Use') {
                    socQueueRecord.Associated_Case_Id__c = caseObj.Id;
                    socQueueRecord.Status__c = 'Escalated';
                    
                    //Escalate CR START
                    socQueueRecord.Escalated_To__c = 'Supervisor';
                    //Escalate CR END
                    //socQueueRecord.ownerId = '005Z0000002QRoM';
                    //socQueueRecord.ownerId = [select Id from Group where DeveloperName = 'Meaningful_Use_Team' and Type = 'Queue'].id;
                    update socQueueRecord;
                    /*Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    List<string> emailAddressLst = System.Label.SOC_Escaltion !=null ? System.Label.SOC_Escaltion.split('\n') : null;
                    if(emailAddressLst != null && emailAddressLst.size()>0) {
                        sendTo.addAll(emailAddressLst);
                    }
                    msg.setToAddresses(sendTo);
                    //msg.setToAddresses(new String[]{'ankit.h.garg@accenture.com'});
                    List<OrgWideEmailAddress> lstOrgWideEmailAddress = [select Id from OrgWideEmailAddress where DisplayName = 'Sutter Health'];
                    if(lstOrgWideEmailAddress !=null && lstOrgWideEmailAddress.size()>0) {
                        msg.setOrgWideEmailAddressId(lstOrgWideEmailAddress[0].id);
                    }
                    //msg.setSubject('Test');
                    //msg.setplainTextBody('Test body');
                    
                    
                    string subject = 'SOC Escalation: ' + caseObj.Provider_Name__c + ' -- ' + caseObj.Provider_Id_EAF_ID__c;
                    msg.setSubject(subject);
                    String Body = 'Hi,\n\n' +
                                  'The following case has been escalated to Meaningful Use.\n'+
                                  'Case No : ' + caseObj.CaseNumber +
                                  '\nProvider name: ' + (caseObj.Provider_Name__c !=  null ? caseObj.Provider_Name__c : ' ') +
                                  '\nProvider ID: ' + (caseObj.Provider_Id_EAF_ID__c != null ? caseObj.Provider_Id_EAF_ID__c : ' ') +
                                  '\nEscalated Reason: ' + (caseObj.PDV_Escalation_Reason__c !=  null ? caseObj.PDV_Escalation_Reason__c : ' ') +
                                  ' \nContacted Person Name: ' + (caseObj.PDV_Contact_Name__c != Null ? caseObj.PDV_Contact_Name__c : ' ') + '  ' + 
                                  ' \nContacted Number: ' + caseObj.Contact_Number__c  +
                                  ' \nEscalated Agent: ' + caseObj.CreatedBy.Name +
                                  ' \nCase Comments: ' + (caseObj.description !=  null ? caseObj.description : ' ') + 
                                  '\n\nThankyou.';
                    msg.setplainTextBody(Body);
                    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    mails.add(msg);
                    Messaging.sendEmail(mails);*/
                } else if(caseObj.Status == 'Cannot Reach') {
                    socQueueRecord.Associated_Case_Id__c = null;
                    update socQueueRecord;
                } else {
                    socQueueRecord.Associated_Case_Id__c = caseObj.Id;
                    update socQueueRecord;
                }
            }
            
            
            /*caseObj = [select casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                        status,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, Communication_Preference_Changed_To_Fax__c,
                        subject,description,CreatedBy.Name  
                        from case where Id = :caseObj.Id];*/
            caseStatus = caseObj.status;
            strCaseContactPhoneNumber = String.valueOf(caseObj.Contact_Number__c);
            getCaseLst();
            isAddressValidated = false;         
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        return null;
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to approve a case for escalation to MU Team
    * @param 
    * @return PageReference
    */
    //Escalate CR START
    public PageReference approveCase() {
        
        boolean isCaseValidated =  true;
        if(String.isBlank(caseObj.Common_Subject_Lines__c) ||  caseObj.Common_Subject_Lines__c == '--None--') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Subject.'));
            isCaseValidated = false;
        }
        if(caseObj.Status != 'Cannot Reach' && String.isBlank(caseObj.PDV_Contact_Name__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Contact Name.'));
            isCaseValidated = false;
        }
        if(strCaseContactPhoneNumber == null || strCaseContactPhoneNumber == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Contact Number.'));
            isCaseValidated = false;
        } else if(strCaseContactPhoneNumber.isNumeric() || strCaseContactPhoneNumber.length() < 14 || strCaseContactPhoneNumber.length() < 14) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Contact Number is invalid. It must be in the form of (999) 999-9999.'));
            isCaseValidated = false;
        }
        if(String.isBlank(caseObj.Validated_or_not__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Contact Validated or not.'));
            isCaseValidated = false;
        }
        if(prefix == '003' && (String.isBlank(caseObj.Communication_Preference_Changed_To_Fax__c) || caseObj.Communication_Preference_Changed_To_Fax__c == 'None')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Change Communication Preference To Fax?'));
            isCaseValidated = false;
        }
        if(String.isBlank(caseObj.Status)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Status.'));
            isCaseValidated = false;
        } else if(caseObj.Status == 'Escalate To Meaningful Use' && String.isBlank(caseObj.PDV_Escalation_Reason__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Escalation Reason.'));
            isCaseValidated = false;
        }
        if(caseObj.Status != 'Closed' && caseObj.SOC_Document_Status__c == 'Sent') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Status must be closed once SOC Document Status is Sent.'));
            isCaseValidated = false;
        } 
        if(caseObj.Status == 'Escalate To Meaningful Use' && caseObj.SOC_Document_Status__c == 'Sent') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Case cannot be escalated once SOC Document Status is Sent.'));
            isCaseValidated = false;
        }
        if(prefix == '003' && (caseObj.Communication_Preference_Changed_To_Fax__c == 'Yes' && (caseObj.Status == 'New' || caseObj.Status == 'Cannot Reach'))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Communication Preference Changed to fax cannot be Yes  if status is New or Cannot Reach.'));
            isCaseValidated = false;
        }

        if(isCaseValidated == false) {
            return null;
        }
        
        try{
            
            caseObj.ownerId = [select Id from Group where DeveloperName = 'Escalated_to_Meaningful_Team' and Type = 'Queue'].id;
            
            update caseObj;
            SOC_Queue__c socQueueRecord;
            
            if(!string.isBlank(socId)){
                socQueueRecord = [select id from SOC_Queue__c where id=:socId];
            }
            socQueueRecord.Escalated_To__c = 'MeaningfulUse';
            update socQueueRecord;
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            List<string> emailAddressLst = System.Label.SOC_Escaltion !=null ? System.Label.SOC_Escaltion.split('\n') : null;
            if(emailAddressLst != null && emailAddressLst.size()>0) {
                sendTo.addAll(emailAddressLst);
            }
            msg.setToAddresses(sendTo);
            //msg.setToAddresses(new String[]{'ankit.h.garg@accenture.com'});
            List<OrgWideEmailAddress> lstOrgWideEmailAddress = [select Id from OrgWideEmailAddress where DisplayName = 'Sutter Health'];
            if(lstOrgWideEmailAddress !=null && lstOrgWideEmailAddress.size()>0) {
                msg.setOrgWideEmailAddressId(lstOrgWideEmailAddress[0].id);
            }
            /*EmailTemplate templateId = [Select id from EmailTemplate where name = 'SOC Meaningful Use Escalation'];
            msg.setTemplateID(templateId.id); 
            msg.setTargetObjectId(providerId);*/
            //msg.setSubject('Test');
            //msg.setplainTextBody('Test body');
            
            
            string subject = 'SOC Escalation: ' + caseObj.Provider_Name__c + ' -- ' + caseObj.Provider_Id_EAF_ID__c;
            msg.setSubject(subject);
            String Body = 'Hi,\n\n' +
                          'The following case has been escalated to Meaningful Use.\n'+
                          'Case No : ' + caseObj.CaseNumber +
                          '\nProvider name: ' + (caseObj.Provider_Name__c !=  null ? caseObj.Provider_Name__c : ' ') +
                          '\nProvider ID: ' + (caseObj.Provider_Id_EAF_ID__c != null ? caseObj.Provider_Id_EAF_ID__c : ' ') +
                          '\nEscalated Reason: ' + (caseObj.PDV_Escalation_Reason__c !=  null ? caseObj.PDV_Escalation_Reason__c : ' ') +
                          ' \nContacted Person Name: ' + (caseObj.PDV_Contact_Name__c != Null ? caseObj.PDV_Contact_Name__c : ' ') + '  ' + 
                          ' \nContacted Number: ' + caseObj.Contact_Number__c  +
                          ' \nEscalated Agent: ' + caseObj.CreatedBy.Name +
                          ' \nCase Comments: ' + (caseObj.description !=  null ? caseObj.description : ' ') + 
                          '\n\nThankyou.';
            msg.setplainTextBody(Body);
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            mails.add(msg);
            Messaging.sendEmail(mails);
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        return null;
    }
    //Escalate CR END
    
    
    /**
    * @author IDC Team
    * @description -- this is used to reject the case which is then diverted to SOC Agents
    * @param 
    * @return PageReference
    */
    //Escalate CR START
    public PageReference rejectCase() {
        
        boolean isCaseValidated =  true;
        if(String.isBlank(caseObj.Common_Subject_Lines__c) ||  caseObj.Common_Subject_Lines__c == '--None--') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Subject.'));
            isCaseValidated = false;
        }
        if(caseObj.Status != 'Cannot Reach' && String.isBlank(caseObj.PDV_Contact_Name__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Contact Name.'));
            isCaseValidated = false;
        }
        if(strCaseContactPhoneNumber == null || strCaseContactPhoneNumber == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Contact Number.'));
            isCaseValidated = false;
        } else if(strCaseContactPhoneNumber.isNumeric() || strCaseContactPhoneNumber.length() < 14 || strCaseContactPhoneNumber.length() < 14) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Contact Number is invalid. It must be in the form of (999) 999-9999.'));
            isCaseValidated = false;
        }
        if(String.isBlank(caseObj.Validated_or_not__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Contact Validated or not.'));
            isCaseValidated = false;
        }
        if(prefix == '003' && (String.isBlank(caseObj.Communication_Preference_Changed_To_Fax__c) || caseObj.Communication_Preference_Changed_To_Fax__c == 'None')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Change Communication Preference To Fax?'));
            isCaseValidated = false;
        }
        if(String.isBlank(caseObj.Status)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Status.'));
            isCaseValidated = false;
        } else if(caseObj.Status == 'Escalate To Meaningful Use' && String.isBlank(caseObj.PDV_Escalation_Reason__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the Escalation Reason.'));
            isCaseValidated = false;
        }
        if(caseObj.Status != 'Closed' && caseObj.SOC_Document_Status__c == 'Sent') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Status must be closed once SOC Document Status is Sent.'));
            isCaseValidated = false;
        } 
        if(caseObj.Status == 'Escalate To Meaningful Use' && caseObj.SOC_Document_Status__c == 'Sent') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Case cannot be escalated once SOC Document Status is Sent.'));
            isCaseValidated = false;
        }
        if(prefix == '003' && (caseObj.Communication_Preference_Changed_To_Fax__c == 'Yes' && (caseObj.Status == 'New' || caseObj.Status == 'Cannot Reach'))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Communication Preference Changed to fax cannot be Yes  if status is New or Cannot Reach.'));
            isCaseValidated = false;
        }

        if(isCaseValidated == false) {
            return null;
        }
        
        try{
            
            caseObj.ownerId = caseObj.CreatedById;
            caseObj.Status = 'In Progress';
            update caseObj;
            
            SOC_Queue__c socQueueRecord;
            
            if(!string.isBlank(socId)){
                socQueueRecord = [select id from SOC_Queue__c where id=:socId];
            }
            socQueueRecord.Escalated_To__c = '';
            socQueueRecord.Status__c = 'Accepted';
            update socQueueRecord;
            
        }catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        return null;
    }
    //Escalate CR END
    
    /**
    * @author IDC Team
    * @description -- this is used to update address record on case closure
    * @param 
    * @return void
    */
    public void updateSummaryInfo() {
        try {
            if(!String.isBlank(providerId)) {
                /*Contact contObj = [Select (Select Preferred_Communication_Method__c, Address_Type__c From Summarys__r where Address_Type__c = 'Primary' limit 1), 
                                        (Select Preferred_Communication_Method__c, Address_Type__c From Contact_Validation_Audit_Trails__r where 
                                            Serial_Number__c = '1' and Sent_to_MDM__c = null) From Contact where Id =:providerId];*/
                Contact_Validation_Summary__c summaryObj = [Select Preferred_Communication_Method__c,
                                                            Secure_Street_Address__c,Secure_City__c,Secure_State__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                                                            Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c, 
                                                            New_Street_Address__c, (Select Preferred_Communication_Method__c, Address_Type__c, Serial_Number__c From Provider_Validation_Updates__r
                                                            where Serial_Number__c = '1' and Sent_to_MDM__c = null) 
                                                            From Contact_Validation_Summary__c where Contact_Id__c = :providerId and (Address_Type__c = 'Primary' OR Serial_Number__c = 1)  limit 1];
                summaryObj.Preferred_Communication_Method__c = 'Fax';
                update summaryObj;
                List<Contact_Validation_Audit_Trail__c> auditUpsert = new List<Contact_Validation_Audit_Trail__c>();
                for(Contact_Validation_Audit_Trail__c obj : summaryObj.Provider_Validation_Updates__r) {
                    obj.Sent_to_MDM__c = 'N/A';
                    auditUpsert.add(obj);
                }
                Contact_Validation_Audit_Trail__c auditObj = new Contact_Validation_Audit_Trail__c();                                           
                auditObj.Provider_Information_Summary__c = summaryObj.id;
                auditObj.New_Street_Address__c = summaryObj.New_Street_Address__c;
                auditObj.Secure_Suite__c = summaryObj.Secure_Suite__c;
                auditObj.Secure_Floor__c = summaryObj.Secure_Floor__c;
                string addressFormat2 = '';
                if(!String.isBlank(auditObj.New_Street_Address__c)) {
                    addressFormat2 =  auditObj.New_Street_Address__c; 
                }
                /*if(!string.isBlank(auditObj.Secure_Suite__c)) {
                    addressFormat2 = addressFormat2 + ' STE ' + summaryObj.Secure_Suite__c;
                }
                if(!string.isBlank(auditObj.Secure_Floor__c)) {
                    addressFormat2 = addressFormat2 + ' FL ' + summaryObj.Secure_Floor__c;
                }*/
                if(!string.isBlank(summaryObj.Secure_Suite__c)) {
                    if(!summaryObj.Secure_Suite__c.containsIgnoreCase('STE')) {
                        addressFormat2 = addressFormat2 + ' STE ' + summaryObj.Secure_Suite__c;
                    } else {
                        addressFormat2 = addressFormat2 + '  ' + summaryObj.Secure_Suite__c;
                    }
                }
                if(!string.isBlank(summaryObj.Secure_Floor__c)) {
                    if(!summaryObj.Secure_Floor__c.containsIgnoreCase('FL')) {
                        addressFormat2 = addressFormat2 + ' FL ' + summaryObj.Secure_Floor__c;
                    } else {
                        addressFormat2 = addressFormat2 + '  ' + summaryObj.Secure_Floor__c;
                    }
                }
                auditObj.Secure_Street_Address__c = addressFormat2;
                auditObj.Secure_City__c = summaryObj.Secure_City__c;
                auditObj.Secure_State__c = summaryObj.Secure_State__c;
                auditObj.Secure_Zip_Code__c = summaryObj.Secure_Zip_Code__c; 
                auditObj.Secure_Phone__c = summaryObj.Secure_Phone__c;
                auditObj.Secure_FAX__c = summaryObj.Secure_FAX__c;
                auditObj.Secure_Phone_Ext__c = summaryObj.Secure_Phone_Ext__c;
                auditObj.Contact_Id__c = providerId;
                auditObj.Email__c = summaryObj.Email__c;
                auditObj.Mobile_Phone__c = summaryObj.Mobile_Phone__c;
                auditObj.Ok_to_Text__c = summaryObj.Ok_to_Text__c;
                auditObj.Serial_Number__c = '1';
                auditObj.address_modified__c = 'No';
                auditObj.Sent_to_MDM__c = '';   //New Field
                auditObj.Preferred_Communication_Method__c = 'Fax';
                auditUpsert.add(auditObj);
                if(auditUpsert.size()>0) {
                    upsert auditUpsert;
                }                                                                       
            }
        } catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to update case from MU side
    * @param 
    * @return PageReference
    */
    public string caseMUStatus {get;set;}
    public string caseMUReason {get;set;}
    public PageReference updateCaseMU() { 
        try {
            boolean isCaseValidated =  true;
            if(String.isBlank(caseMUStatus) ||  caseMUStatus == '--None--' || caseMUStatus == 'None') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the MU Escalation Status.'));
                isCaseValidated = false;
            }
            if(String.isBlank(caseMUReason)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please fill the MU Comment.'));
                isCaseValidated = false;
            }
            if(isCaseValidated == false) {
                return null;
            }
            /*MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c = caseId;
            muObj.Escalation_Status__c = caseMUStatus;
            muObj.Status__c = 'Closed'; 
            muObj.Comments__c = caseMUReason; 
            insert muObj;
            */
            //Escalate CR START
            caseObj.Status = 'Closed';
            caseObj.MU_Comments__c = caseMUReason;
            caseObj.MU_Escalation_Status__c = caseMUStatus;
            update caseObj;
            //Escalate CR END
            
            SOC_Queue__c socQueueRecord = [select id,Associated_Case_Id__r.createdById,Associated_Case_Id__c from SOC_Queue__c where id=:socId];
            if(caseMUStatus == 'Send Documents To Provider') {
                   socQueueRecord.Status__c = 'Accepted';
                   if(socQueueRecord.Associated_Case_Id__c != null && socQueueRecord.Associated_Case_Id__r.createdById != null) {
                        socQueueRecord.ownerId = socQueueRecord.Associated_Case_Id__r.createdById;
                   }
                   socQueueRecord.Associated_Case_Id__c = null;
            } else if(caseMUStatus == 'Cannot send documents to Provider') {
                   socQueueRecord.Status__c = 'Cannot Send';
            }
            socQueueRecord.Escalated_To__c = 'MU Closed';
            update socQueueRecord;
            /*
            List<MU_Object__c> lstMU = [select Case__c,Comments__c,Escalation_Status__c,Status__c from MU_Object__c where Case__c =:caseId limit 1];
            if(lstMU != null && lstMU.size()>0) {
                caseMUStatus = lstMU[0].Escalation_Status__c;
                caseMUReason = lstMU[0].Comments__c;
                MUCaseStatus = lstMU[0].Status__c;
            }
            */
            caseObj = [select OwnerId, casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                        status,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, Communication_Preference_Changed_To_Fax__c,
                        subject,description,CreatedBy.Name, MU_Escalation_Status__c, MU_Comments__c,owner.Name,
                        (Select ADDRESS__c, CITY__c, STATE__c, ZIP_CODE__c, PHONE__c, FAX_NUMBER__c, Suite__c, Floor__c, Address_Modified__c From EAF_Validation_Audit_Trails__r), 
                                (Select Secure_City__c, Secure_Fax__c, Secure_Phone__c, Secure_State__c, Secure_Street_Address__c, Secure_Zip_Code__c, Secure_Suite__c, Secure_Floor__c, 
                                Secure_Phone_Ext__c, Address_Modified__c From Provider_Validation_Updates__r)       
                        from case where Id = :caseObj.Id];
            //Escalate CR START
            caseMUStatus = caseObj.MU_Escalation_Status__c;
            caseMUReason = caseObj.MU_Comments__c ;
            MUCaseStatus = caseObj.Status;
            caseStatus = caseObj.Status;
            //Escalate CR END
            strCaseContactPhoneNumber = String.valueOf(caseObj.Contact_Number__c);
            getCaseLst();
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        return null;
    }
    
    /**
    * @author IDC Team
    * @description -- this is used to fire on "Back To Case" button
    * @param 
    * @return PageReference
    */
    public PageReference backToCasesMU() {
        PageReference pgRef = new PageReference('/Meaningfuluse/SOCMeaningFul?backto=true');
        pgRef.setRedirect(true);
        return pgRef;
    }
   
    /**
    * @author IDC Team
    * @description -- this is used to cancel the case.
    * @param 
    * @return PageReference
    */
    public boolean isCancelCaseOk {get;set;} 
    public void cancelCase() {
        isCancelCaseOk = false;
        if((caseId == null || caseId == '') && isAddressValidated == true) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please save the Case before Cancel.'));
        } else {
            isCancelCaseOk = true;
        }
    }
    
     /**
    * @author IDC Team
    * @description -- this is used to hide div
    * @param 
    * @return PageReference
    */
    public void hideOverlayDivCall() {
        addressRecordId = null;
        newAddress = new WrAddressValidation();
        isAddressValidAllFields = true;
        isCreatingCase = true;
    }
    
    public boolean patterMatcherEmail(string value) {
        Pattern MyPattern = Pattern.compile('^[0-9a-zA-Z]+([0-9a-zA-Z]*[-._+])*[0-9a-zA-Z]+@[0-9a-zA-Z]+([-.][0-9a-zA-Z]+)*([0-9a-zA-Z]*[.])[a-zA-Z]{2,6}$');
        Matcher MyMatcher = MyPattern.matcher(value);
        return MyMatcher.matches();
    }
    
    public boolean patterMatcherStreetAddress(string value) {
        if(patterMatcherPOBoxStart(value) && prefix == '003'){
            return true;
        }
        else{
            Pattern MyPattern = Pattern.compile('[0-9]$');
            Matcher MyMatcher = MyPattern.matcher(value.substring(0,1));
            return MyMatcher.matches();
        }
    }
    
    public boolean patterMatcherPOBoxStart(string value) {
        //Pattern MyPattern = Pattern.compile('^(?:Post(?:al)? (?:Office )?|P[. ]?O\\.? )?Box\\b');
        Pattern MyPattern = Pattern.compile('^(?:Post(?:al)? (?:Office )?|P[. ]?O\\.? )?[Bb][Oo][Xx][\\w\\s*\\W]*\\b');
        Matcher MyMatcher = MyPattern.matcher(value.trim());
        return MyMatcher.matches(); 
    }
    
    public boolean patterMatcherPOBox(string value) {
        //Pattern MyPattern = Pattern.compile('([\\w\\s*\\W]*(P(OST)?.?\\s*((O(FF(ICE)?)?)?.?\\s*(B(IN|OX|.?))|B(IN|OX))+))[\\w\\s*\\W]*');
        Pattern MyPattern = Pattern.compile('^[\\w\\s*\\W]*(?:Post(?:al)? (?:Office )?|P[. ]?O\\.? )?[Bb][Oo][Xx][\\w\\s*\\W]*\\b');
        Matcher MyMatcher = MyPattern.matcher(value.trim());
        return MyMatcher.matches(); 
    }
    
    public boolean patterMatcherCareOf(string value) {
        if(value.containsIgnoreCase('Care Of') || value.containsIgnoreCase('C\\O') || value.containsIgnoreCase('D\\O') || value.containsIgnoreCase('S\\O')) {
            return true;
        }
        return false;
    }
    
    public boolean patterMatcherSUiteOrFloor(string value) {
        if(value.containsIgnoreCase(' Suite ') || value.containsIgnoreCase(' Floor ') || value.containsIgnoreCase(' STE ') || value.containsIgnoreCase(' FL ')) {
            return true;
        }
        return false;
    }
    
    //print
    public void printAddressMethod(){
        
        List<Contact_Validation_Summary__c> printSummaryRecordList = new List<Contact_Validation_Summary__c>();
        List<PDV_EAF_Facility__c> printFacilityRecordList = new List<PDV_EAF_Facility__c>();
        
        try{
            if(!wrAddressValidationlist.isEmpty()){
                for(WrAddressValidation wAdd : wrAddressValidationlist){
                    if(wAdd.isSelected == true) {
                        if(prefix == '003') {
                            Contact_Validation_Summary__c summaryRec = new Contact_Validation_Summary__c(id = wAdd.recordId);
                            summaryRec.Printed_Contact_Name__c  = contactInfo.Name;//wAdd.strStreetAddress;
                            summaryRec.Printed_Street_Address__c = wAdd.strStreetAddress;
                            summaryRec.Printed_Suite__c = wAdd.strSuite;
                            summaryRec.Printed_Floor__c = wAdd.strFloor;
                            summaryRec.Printed_City__c = wAdd.strCity;
                            summaryRec.Printed_State__c = wAdd.strstate;
                            summaryRec.Printed_Zip_Code__c = wAdd.strZipCode;
                            printSummaryRecordList.add(summaryRec);
                            printedAddressId = wAdd.recordId;
                        }else{
                            PDV_EAF_Facility__c facilityRec = new PDV_EAF_Facility__c(id = wAdd.recordId);
                            facilityRec.Printed_Name__c = faciltyInfo.Name;
                            facilityRec.Printed_Address__c = wAdd.strStreetAddress;
                            facilityRec.Printed_Suite__c = wAdd.strSuite;
                            facilityRec.Printed_Floor__c = wAdd.strFloor;
                            facilityRec.Printed_City__c = wAdd.strCity;
                            facilityRec.Printed_State__c = wAdd.strstate;
                            facilityRec.Printed_Zip_Code__c = wAdd.strZipCode;
                            printFacilityRecordList.add(facilityRec);
                            printedAddressId = wAdd.recordId;
                        }
                    }
                }
            }
            
            if(!printSummaryRecordList.isEmpty()){
                
                Database.update(printSummaryRecordList);
                updateSOCStatusToPrint();
            }
            if(!printFacilityRecordList.isEmpty()){
                
                Database.update(printFacilityRecordList);
                updateSOCStatusToPrint();
            }
            
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    //print
    public void updateSOCStatusToPrint(){
        
        SOC_Queue__c socRec = new SOC_Queue__c(id = socId);
        socRec.Status__c = SOC_STATUS_PRINT;
        socRec.Printed_Id__c = printedAddressId;
        update socRec;
        isViewAddress = true;
        isPrintAddButton = false;
    }
    
    public class WrAddressValidation {
        public string recordId {get;set;}
        public boolean isSelected {get;set;}
        public string strAddress {get;set;}
        public string strStreetAddress {get;set;}
        public string strSuite {get;set;}
        public string strFloor {get;set;}
        public string strPhone {get;set;}
        public string strFax {get;set;}
        public string strCity {get;set;}
        public string strstate {get;set;}
        public string strZipCode {get;set;}
        public string strPhoneExt {get;set;}
        public string straddressType {get;set;}
        public string lastValidatedDate {get;set;}
        public string isValidated {get;set;}
        public string lastmodifiedDate {get;set;}
        public string lastmodifiedBy {get;set;}
        public string strEmail {get;set;}
        public string strMobilePhone {get;set;}
        public boolean strOkToText {get;set;}
        public string strSnumber {get;set;} //New Change        
        public string strAddressModified {get;set;}
        public string strAttenTo {get;set;}
        public string strNameChangesSugg {get;set;}
        public string strFirstName {get; set;}
        public string strMiddleName {get; set;}
        public string strLastName {get; set;}
        
    }
    
    public class WrCase {
        public string caseId {get;set;}
        public string strStatus {get;set;}
        public string strSubject {get;set;}
        public string strCaseOrigin  {get;set;}
        public string strCaseSubject  {get;set;}
        public string strCaseContactNumber  {get;set;}
        public string strCaseContactName  {get;set;}
        public string strCaseEscaltionReason  {get;set;}
        public string strCaseNumber {get;set;}
    }
    
    public class WRAddressCaseHistory {
        public string auditId {get;set;}
        public string addressModified {get;set;}
        public string lastModifiedDate {get;set;}
        public string strAddress {get;set;}//New Change
        public string strAddressModifiedBy {get;set;}
    }
}