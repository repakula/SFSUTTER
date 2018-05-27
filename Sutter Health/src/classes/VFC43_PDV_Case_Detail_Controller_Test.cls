/**  
*    Class Name: VFC43_PDV_Case_Detail_Controller_Test
*    Author: IDC Offshore
*    Date: 8-July-2015
*    Description:  Test class for VFC43_PDV_Case_Detail_Controller Controller
*    History
*    --------
**/
@isTest
class VFC43_PDV_Case_Detail_Controller_Test {

	static testmethod void test_PDV_Case_Detail() {
		
		User socUser = AP01_TestDataUtility.createSOCUser();
		
		System.runAs(socUser){
			
			Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
			Contact assignedContact = AP01_TestDataUtility.employeeContact(assignedAccount);
	
			Case objCase = AP01_TestDataUtility.employeeInquiryCase(assignedContact);
	
			Contact_Validation_Audit_Trail__c objAudit = AP01_TestDataUtility.getValidationAudit(objCase);
			
			PageReference pageRef = Page.VFP43_PDV_Case_Detail;
			Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('caseId', objCase.id);
			VFC43_PDV_Case_Detail_Controller objCtlr = new VFC43_PDV_Case_Detail_Controller();
			
			system.assertEquals(objCtlr.lstCaseAddressHistory.size()>0, true);
		}
	}
}