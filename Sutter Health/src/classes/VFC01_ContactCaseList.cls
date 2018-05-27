/**********************************************************************
Name: VFC01_ContactCaseList()

======================================================
======================================================
Purpose:
VFC01_ContactCaseList Class. Functionality Related to REQ-3274. Utilility methods to fetch information from Case & Patient object.
======================================================
======================================================
History
-------
VERSION         AUTHOR          DATE            DETAIL                   Description
1.0             Sandeep         27-Dec-2015     Initial                  Initial
2.0             Shivangi        02-Feb-2016     Req-3733                 Scenarios related to vendor contact information retrieval are added as per Req-3733.
3.0             Shivangi        18-Feb-2016     Req-3733 & 3274          Updated the query for open and closed cases for patient and employee/vendor as part of code review comments implementation.
***********************************************************************/

public with sharing class VFC01_ContactCaseList {
    
    // Instance Variable
    public string sortingField {get; set;}
    public string sortingDirection {get; set;}
    public List<Case> AllCaseList = new List<Case>(); 
    
     /*******************************************************************  
     Purpose: Get List of all cases of contact searched  
     Parameters: [string]  
     Returns: List<Case>
     Throws [Exceptions]: [NA]  
    ********************************************************************/ 
    public List<Case> collectContactCases(String linkId) {
        try {
            User currentuser = [Select Id,Name,Email from User where Id=:userinfo.getuserId()];
            if(String.IsBlank(sortingField)) {
                sortingField =  'CreatedDate';
            }
            if(String.IsBlank(sortingDirection)) {
                sortingDirection =  'DESC';
            }
            //Querying all the cases on basis of contact searched
            string selectQuery = 'select id, parent.CaseNumber, CaseNumber, Status, CreatedDate,Created_Date_DaylightSaving__c, ClosedDate, Closed_Date_DaylightSaving__c,Customer_Inquiry_Type__c, Function__c, Sub_Function__c, Isclosed, Customer_Intent__c, Customer_Sub_Intents__c, ' + 
                                    'Team__c,Owner.Name from case where ContactID = \'' + linkId + '\' order by ' + SortingField + ' ' +SortingDirection+ '  limit 1000 ';
            
            AllCaseList = Database.query(selectQuery);
            return AllCaseList;
        } 
        catch(Exception ex) {
            return null;
        } 
        
    }
    
    /*******************************************************************  
     Purpose: Get List of all cases of patient/patient account searched  
     Parameters: [string]  
     Returns: List<Case>
     Throws [Exceptions]: [NA]  
    ********************************************************************/ 
    public List<Case> collectPatientCases(String linkId) {
        try {
            User currentuser = [Select Id,Name,Email from User where Id=:userinfo.getuserId()];
            if(String.IsBlank(sortingField)) {
                sortingField =  'CreatedDate';
            }
            if(String.IsBlank(sortingDirection)) {
                sortingDirection =  'DESC';
            }
            //Querying all the cases on basis of patient/patient account searched
            string selectQuery = 'select id, CaseNumber, Parent.CaseNumber, Status, CreatedDate,Created_Date_DaylightSaving__c, ClosedDate,Closed_Date_DaylightSaving__c, Customer_Inquiry_Type__c, Function__c, Sub_Function__c, Customer_Intent__c, Customer_Sub_Intents__c, ' +
                                    ' Team__c, Patient_Account__r.Name, Owner.Name from case where ' +
                                    ' Patient__c = \'' + linkId + '\' order by ' + SortingField + ' ' +SortingDirection+ '  limit 1000 ';
            
            AllCaseList = Database.query(selectQuery);
            return AllCaseList;
        } 
        catch(Exception ex) {
            return null;
        } 
        
    }
    
    
    
    /*******************************************************************  
        Purpose: This function is used to return patient information 
        Parameters: [string]  
        Returns: Patient__c
        Throws [Exceptions]: [NA]  
    ********************************************************************/ 
    public patient__c getPatientPage(string linkId) {
        Patient__c patientObj = null;
        try {
           // Querying Patient Object   
           patientObj = [select Name, Patient_DotOne__c, Patient_EMPI__c, Patient_SHMRN__c, Patient_City__c, Patient_DOB__c, Patient_EPI_ID__c, 
                            Patient_First_Name__c, Patient_Gender__c, Patient_Phone_Home__c, Patient_Last_Name__c, Patient_Middle_Name__c, Patient_Phone_Mobile__c, 
                            Patient_Phone_Other__c, Patient_SSN_E__c, Patient_State__c, Patient_Street__c, Patient_Phone_Work__c, Patient_Zip__c from Patient__c where ID = :linkId];
       } catch(Exception ex) {}
        return patientObj;
    } 
    
    /**********************************************************************************  
        Purpose: Req-3274 - This function is used to return patient account information 
        Parameters: [string]  
        Returns: List<Patient_Account__c>
        Throws [Exceptions]: [NA]  
    **********************************************************************************/ 
    public List<patient_account__c> getPatientAccountPage(string linkId) {
        List<patient_account__c> patientAccountLst = new List<patient_account__c>();
        try {
            // Querying Patient Account Object
            for (Patient_Account__c Pac : [SELECT Name, Patient_DotOne_Lookup__r.Name, Guarantor_ID_Lookup__r.Name, Guarantor_ID__c, Patient_Account_Service_Location__c, Patient_Account_Admission_Date__c 
                                            FROM Patient_Account__c where Patient_DotOne_Lookup__c = :linkId limit 100]) {
                patientAccountLst.add(Pac);
            }
        } catch(Exception ex) {}
        return patientAccountLst;
    }
    
     /**********************************************************************************  
        Purpose: Req-3274 - This function is used to return Manager Feedback information 
        Parameters: [string]  
        Returns: List<Managers_Feedback__c>
        Throws [Exceptions]: [NA]  
    **********************************************************************************/ 
    public List<Managers_Feedback__c> getManagerFeedback(string linkId) {
        List<Managers_Feedback__c> managerFeedbackLst = new List<Managers_Feedback__c>();
        try {
            // Querying Manager Feedback Object
            for (Managers_Feedback__c ManagerFeedbk : [SELECT id, Name, CreatedDate, Owner.Name, Owner.FirstName, Owner.LastName, Service_Area__c, Status__c, Resolution__c, CreatedBy.Name, Closed_Date__c
                                            FROM Managers_Feedback__c where Contact__c = :linkId limit 100]) {
                managerFeedbackLst.add(ManagerFeedbk);
            }
        } catch(Exception ex) {}
        return managerFeedbackLst;
    }
    
    /*******************************************************************  
        Purpose: This function is used to return Employee information 
        Parameters: [string]  
        Returns: Contact
        Throws [Exceptions]: [NA]  
    ********************************************************************/ 
     public Contact getEmployeePage(string linkId) {
        Contact contactObj = null;
        try {
            
            contactObj = [select Name, Employee_Region__c, Employee_Email__c, Owner.Name, LastName, Employee_ADID__c, Contact_Middle_Name__c, Employee_Company__c, Employee_Process_Level__c, RecordType.Name, FirstName, Employee_ID__c, Employee_Work_Email__c, Account.Name, 
                            MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode, Employee_Supervisor_Name__c, Employee_Executive_Status__c, 
                            Employee_Union_Affiliate__c, Employee_Bargaining_Union__c, Employee_Employment_Status__c, 
                            Employee_EEO_SubCode__c, Title, Employee_Affiliate_Facility__c, Employee_Job_Code__c, 
                            Employee_Job_Code_Description__c, Employee_Department__c, Birthdate, Phone,
                            (SELECT Id, Status FROM Cases where Status != 'Closed') from contact where ID = :linkId]; 
        } catch(Exception ex){} 
        return contactObj;
    } 
    
    /****************************************************************************  
        Purpose: This function is used to return Vendor information for Req-3733 
        Parameters: [string]  
        Returns: Contact
        Throws [Exceptions]: [NA]  
    *****************************************************************************/ 
    public Contact getVendorPage(string linkId) {
        Contact contactObj = null;
        try {   //Querying Vendor Fields                
            contactObj = [select Name, Owner.Name, Contact_Middle_Name__c, Account.Name, Mailing_County__c, Other_County__c, Title, Vendor_ID__c, Phone, MobilePhone, 
                           Email, ReportsTo.Name, Vendor_TaxID__c,   Contact_SSN_E__c, Contact_External_ID1__c,  Contact_External_ID2__c, MailingStreet, MailingCity, 
                           MailingState, MailingCountry, MailingPostalCode, Fax, HomePhone, OtherPhone, AssistantName, AssistantPhone, LeadSource, LastCURequestDate, 
                           LastCUUpdateDate, Birthdate, Department, Description, OtherStreet, OtherPostalCode, OtherCity, OtherCountry, OtherState,
                            (SELECT Id, Status FROM Cases where Status != 'Closed') from contact where ID = :linkId]; 
        } catch(Exception ex){} 
        return contactObj;
    }     
    
}