@isTest

    /**  
*    Class Name: TestSOCCaseDetail
*    Author: IDC Offshore
*    Date: 17-April-2015
*    Description:  Test class for SOCCaseDetail Controller
*    History
*    --------
**/
    
    
    
    class TestSOCCaseDetail {

    static testmethod void testSOCDetail() {


    Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            Contact assignedContact = AP01_TestDataUtility.employeeContact(assignedAccount);
            // Assert to check Contact is created successfully
            system.assert(assignedContact.id!=null);
            
            Case objCase = AP01_TestDataUtility.employeeInquiryCase(assignedContact);
            // Assert to check Case is created successfully
            system.assert(objCase.id!=null);
            
            Contact_Validation_Audit_Trail__c objAudit = AP01_TestDataUtility.getValidationAudit(objCase);
           // Assert to check Contact_Validation_Audit_Trail__c is created successfully
            system.assert(objAudit.id!=null);
            
            PageReference pageRef = Page.SOCCaseDetail;
         Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('caseId', objCase.id);
          
            SOCCaseDetail objCtlr= new SOCCaseDetail();
    }

    static testmethod void testSOCDetailEAF() {
    
            Case objCase = AP01_TestDataUtility.CreateCase();
            // Assert to check Case is created successfully
            system.assert(objCase.id!=null);
            PDV_EAF_Validation_Audit_Trail__c objAudit = AP01_TestDataUtility.getValidationAuditEAF(objCase);
            //Assert to check PDV_EAF_Validation_Audit_Trail__c is created successfully
            system.assert(objAudit.id!=null);
            
            
            PageReference pageRef = Page.SOCCaseDetail;
         Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('caseId', objCase.id);
          
            SOCCaseDetail objCtlr= new SOCCaseDetail();
    }


    }