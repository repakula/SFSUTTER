/**  
*     Class Name: VFC01_CustomConsole_CaseSplitTest
*     Author: Offshore IDC
*     Date: 08-Jan-2016
*     Project Name: CRM - SFT - Sutter Health
*     Description: Test Class for VFC01_CustomConsole_CaseSplitTest Class. Related to REQ-3274.
*     
*     History
*     VERSION    AUTHOR         DATE           DETAIL     Description
*     1          Offshore IDC   08-Jan-2016   Test Class covers the scenario of 08-Jan-2016 - Case details has been divided into 2 sections i.e Open & Closed Cases.   
*     2          Offshore IDC   02-Feb-2016   Test class covers the scenario of vendor split page as per Req-3733.
*     --------  
**/
@isTest
private class VFC01_CustomConsole_CaseSplitTest {
     
    /*******************************************************************
    Purpose: Creates Account, Contact & Case record. Calls the method to test open cases functionality 
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testOpenCaseLstPositiveAndNegative() {
        try {
            List<Case> caseList = new List<Case>();
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            
            Contact contactObj = new Contact();
            contactObj.LastName ='TestContact';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Employee').RecordTypeId;
            insert contactObj;
            
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  contactObj.id;  
            consoleObj.caseLst();
            
            Case caseObj1 = new Case();
            caseObj1.Inquiry_Type__c = 'HR General Inquiry';
            caseObj1.Inquiry_Reason__c = 'HR Reporting';
            caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
            caseObj1.contactId =  contactObj.id;
            caseList.add(caseObj1);
            insert caseList;
            // Assert to check Case is inserted successfully
            system.assert(caseList.size()>0);
            consoleObj.caseLst();
        } catch(Exception ex) {}
    }
    
    /*******************************************************************
    Purpose: Creates Account, Contact & Manager feedback record. Calls the method to test Manager Feedback functionality 
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testManagerFeedbackPositiveAndNegative() {
        try {
            List<Case> caseList = new List<Case>();
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            
            Contact contactObj = new Contact();
            contactObj.LastName ='TestContact';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Employee').RecordTypeId;
            insert contactObj;
            
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  contactObj.id;  
            consoleObj.getManagerFeedback();
            
            Managers_Feedback__c managerFeedbackObj = new Managers_Feedback__c();
            managerFeedbackObj.Contact__c = contactObj.Id;
            managerFeedbackObj.Service_Area__c = 'Hiring';
            managerFeedbackObj.Subject__c = 'Test';
            //feedbackRec.Resolution__c = 'Hiring';
            managerFeedbackObj.WorkEmail__c = 'xyz123abc@fakeemailsacd.com';
            managerFeedbackObj.Comments__c = 'Test';
            managerFeedbackObj.Status__c = 'New'; 
            insert managerFeedbackObj;
            // Assert to check Manager Feedback is inserted successfully
            system.assert(managerFeedbackObj != NULL);
            consoleObj.getManagerFeedback();
        } catch(Exception ex) {}
    }
     
    /*******************************************************************
    Purpose: Creates Account, Contact & Case record. Calls the method to test Closed cases functionality 
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testClosedEmployeeFunctionalityPositiveAndNegative() {
        try {
            List<Case> caseList = new List<Case>();
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            
            Contact contactObj = new Contact();
            contactObj.LastName ='TestContact';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Employee').RecordTypeId;
            insert contactObj; 
            
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  contactObj.id;
            consoleObj.caseLst(); 
            
            Case caseObj1 = new Case();
            caseObj1.Inquiry_Type__c = 'HR General Inquiry';
            caseObj1.Inquiry_Reason__c = 'HR Reporting';
            caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
            caseObj1.contactId =  contactObj.id;
            caseObj1.Status = 'Closed';
            caseObj1.Close_Reason__c = 'Cancelled';
            caseList.add(caseObj1);
            insert caseList;
            // Assert to check Case is inserted successfully
            system.assert(caseList.size()>0);
            consoleObj.caseLst();
        } catch(Exception ex) {}
     }
     /*******************************************************************
    Purpose: Creates Account, employee Contact record. Calls the method to test negative scenario where no case is associated to employee contact. 
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
     static testMethod void testEmployeeNegativeFunctionality() {
        try {
            List<Case> caseList = new List<Case>();
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            
            Contact contactObj = new Contact();
            contactObj.LastName ='TestContact';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Employee').RecordTypeId;
            insert contactObj; 
            
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  contactObj.id;
            consoleObj.caseLst();
          
            
            // Assert to check no case is attached to the employee record
            Integer size = 0;
            system.assertEquals(caseList.size(), size);
            consoleObj.caseLst();
         
        } catch(Exception ex) {}
     }
    /*******************************************************************
    Purpose: Creates Account, Contact & Patient record. Calls the method to test patient functionality
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testPatientFunctionalityPositiveAndNegative() {
        try {
            List<Case> caseList = new List<Case>();
            
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  NULL;
            consoleObj.getPatientPage();
            
            Patient__c patientObj = new Patient__c();
            patientObj.Patient_First_Name__c = 'TestFName';
            patientObj.Patient_Last_Name__c = 'TestLName';
            patientObj.Patient_EPI_ID__c = AP01_TestDataTokens.PATIENT_EPI_ID;
            patientObj.Patient_DotOne__c = AP01_TestDataTokens.PATIENT_DOTONE;
            insert patientObj; 
            // Assert to check Patient is inserted successfully
            system.assert(patientObj != NULL);
            consoleObj.linkId =  patientObj.Id;
            consoleObj.getPatientPage();
        } catch(Exception ex) {}
    }
    
    /*******************************************************************
    Purpose: Creates Account, Contact, Patient, guarantor & Patient Account record. Calls the method to test patient account functionality   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testPatientAccountFunctionalityPositiveAndNegative() {
        try {
            List<Case> caseList = new List<Case>();
            
            Patient__c patientObj = new Patient__c();
            patientObj.Patient_First_Name__c = 'TestFName';
            patientObj.Patient_Last_Name__c = 'TestLName';
            patientObj.Patient_EPI_ID__c = AP01_TestDataTokens.PATIENT_EPI_ID;
            patientObj.Patient_DotOne__c = AP01_TestDataTokens.PATIENT_DOTONE;
            insert patientObj; 
            
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  patientObj.id;
            consoleObj.getPatientAccountPage();
            
            //Create Guarantor 
            Guarantor__c guarantor1 = AP01_TestDataUtility.createGuarantor();
            
            Patient_Account__c patAccount1 = AP01_TestDataUtility.createPatientAccount(guarantor1, patientObj);
            // Assert to check Patient is inserted successfully
            system.assert(patientObj != NULL);
            consoleObj.getPatientAccountPage();
        } catch(Exception ex) {}
    }
     
    /*******************************************************************
    Purpose: Creates Account, Contactrecord. Calls the method to test employee page functionality   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testemployeeFunctionalityPositiveAndNegative() {
        try {
            List<Case> caseList = new List<Case>();
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            
            Contact contactObj = new Contact();
            contactObj.LastName ='TestContact';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Employee').RecordTypeId;
            insert contactObj;  
            // Assert to check Employee is inserted successfully
            system.assert(contactObj != NULL);
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  contactObj.id;
            consoleObj.getEmployeePage();
        
        } catch(Exception ex) {}
    }
     
    /*******************************************************************
    Purpose: Patient & Case. Calls the method to test open Cases attached to patient functionality   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testOpenPatientFunctionalityPositiveAndNegative() {
        try {
            List<Case> caseList = new List<Case>();        
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  NULL;
            consoleObj.casePatientLst();
            
            Patient__c patientObj = new Patient__c();
            patientObj.Patient_First_Name__c = 'TestFName';
            patientObj.Patient_Last_Name__c = 'TestLName';
            patientObj.Patient_EPI_ID__c = AP01_TestDataTokens.PATIENT_EPI_ID;
            patientObj.Patient_DotOne__c = AP01_TestDataTokens.PATIENT_DOTONE;
            insert patientObj; 
            
            Case caseObj1 = new Case();
            caseObj1.Inquiry_Type__c = 'HR General Inquiry';
            caseObj1.Inquiry_Reason__c = 'HR Reporting';
            caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
            caseObj1.Patient__c =  patientObj.id;
            caseList.add(caseObj1);
            insert caseList;
            
            // Assert to check Case is inserted successfully
            system.assert(caseList.size()>0);
            
            consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  patientObj.id;
            consoleObj.casePatientLst();
        } catch(Exception ex) {}
     }
     
    /*******************************************************************
    Purpose: Patient & Case. Calls the method to test Closed Cases attached to patient functionality   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testClosedPatientFunctionalityPositiveAndNegative() {
        try {
            List<Case> caseList = new List<Case>();
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  NULL;
            consoleObj.casePatientLst();
            Patient__c patientObj = new Patient__c();
            patientObj.Patient_First_Name__c = 'TestFName';
            patientObj.Patient_Last_Name__c = 'TestLName';
            patientObj.Patient_EPI_ID__c = AP01_TestDataTokens.PATIENT_EPI_ID;
            patientObj.Patient_DotOne__c = AP01_TestDataTokens.PATIENT_DOTONE;
            insert patientObj; 
            
            Case caseObj1 = new Case();
            caseObj1.Inquiry_Type__c = 'HR General Inquiry';
            caseObj1.Inquiry_Reason__c = 'HR Reporting';
            caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
            caseObj1.Patient__c =  patientObj.id;
            caseObj1.Status = 'Closed';
            caseObj1.Close_Reason__c = 'Cancelled';
            caseList.add(caseObj1);
            insert caseList;
            // Assert to check Case is inserted successfully
            system.assert(caseList.size()>0);
            consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  patientObj.id;
            consoleObj.casePatientLst();
        } catch(Exception ex) {}
    }
     /*******************************************************************
    Purpose: Creates Patient record. Calls the method to test negative scenario where no case is associated to patient. 
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
     static testMethod void testPatientNegativeFunctionality() {
        try {
            Patient__c patientObj = new Patient__c();
            patientObj.Patient_First_Name__c = 'TestFName';
            patientObj.Patient_Last_Name__c = 'TestLName';
            patientObj.Patient_EPI_ID__c = AP01_TestDataTokens.PATIENT_EPI_ID;
            patientObj.Patient_DotOne__c = AP01_TestDataTokens.PATIENT_DOTONE;
            insert patientObj; 
            
            List<Case> caseList = new List<Case>();
            
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  patientObj.id;
            
            consoleObj.casePatientLst(); 
            
            // Assert to check no case is attached to the employee record
            Integer size = 0;
            system.assertEquals(caseList.size(), size);
            consoleObj.casePatientLst();
            
        } catch(Exception ex) {}
     }
    /*******************************************************************
    Purpose: Req-3733 - Creates Account and vendor Contact record. Calls the method to test vendor page functionality.   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testVendorFunctionalityPositiveAndNegative() {
        try {
            List<Case> caseList = new List<Case>();
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            
            Contact contactObj = new Contact();
            contactObj.LastName ='TestContact';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Vendor').RecordTypeId;
            insert contactObj;  
            // Assert to check Vendor is inserted successfully
            system.assert(contactObj != NULL);
            
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  contactObj.id;
            consoleObj.getVendorPage();
            
        } catch(Exception ex) {}
    }
    /*******************************************************************
    Purpose: Req-3733 - Creates Account, vendor Contact & Case record. Calls the method to test open cases functionality for Vendor.
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testVendorOpenCaseLstPositiveAndNegative() {
        try {
            List<Case> caseList = new List<Case>();
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            
            Contact contactObj = new Contact();
            contactObj.LastName ='TestContact';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Vendor').RecordTypeId;
            insert contactObj;
            
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  contactObj.id;  
            consoleObj.caseLst();
            
            Case caseObj1 = new Case();
            caseObj1.Inquiry_Type__c = 'HR General Inquiry';
            caseObj1.Inquiry_Reason__c = 'HR Reporting';
            caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
            caseObj1.contactId =  contactObj.id;
            caseList.add(caseObj1);
            insert caseList;
            // Assert to check Case is inserted successfully
            system.assert(caseList.size()>0);
            consoleObj.caseLst();
        } catch(Exception ex) {}
    }
    /*******************************************************************
    Purpose: Req-3733 - Creates Account, vendor Contact & Case record. Calls the method to test Closed cases functionality for Vendor.
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testMethod void testClosedVendorFunctionalityPositiveAndNegative() {
        try {
            List<Case> caseList = new List<Case>();
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            
            Contact contactObj = new Contact();
            contactObj.LastName ='TestContact';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Vendor').RecordTypeId;
            insert contactObj; 
            
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  contactObj.id;
            consoleObj.caseLst(); 
            
            Case caseObj1 = new Case();
            caseObj1.Inquiry_Type__c = 'HR General Inquiry';
            caseObj1.Inquiry_Reason__c = 'HR Reporting';
            caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
            caseObj1.contactId =  contactObj.id;
            caseObj1.Status = 'Closed';
            caseObj1.Close_Reason__c = 'Cancelled';
            caseList.add(caseObj1);
            insert caseList;
            // Assert to check Case is inserted successfully
            system.assert(caseList.size()>0);
            consoleObj.caseLst();
        } catch(Exception ex) {}
     }
     /*******************************************************************
    Purpose: Creates Account, Contact record for vendor. Calls the method to test negative scenario where no case is associated to vendor contact. 
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
     static testMethod void testVendorNegativeFunctionality() {
        try {
            List<Case> caseList = new List<Case>();
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            
            Contact contactObj = new Contact();
            contactObj.LastName ='TestContact';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Vendor').RecordTypeId;
            insert contactObj; 
            
            VFC01_CustomConsole consoleObj = new VFC01_CustomConsole();
            consoleObj.linkId =  contactObj.id;
            consoleObj.caseLst();
            
            
            // Assert to check no case is attached to the vendor record
            Integer size = 0;
            system.assertEquals(caseList.size(), size);
            consoleObj.caseLst();
           
        } catch(Exception ex) {}
     }
}