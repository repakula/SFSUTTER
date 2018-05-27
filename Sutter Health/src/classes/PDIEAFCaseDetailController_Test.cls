/*****************************************************
Class Name: PDIEAFCaseDetailController_Test
Created By: Nagarjuna Kaipu
Created Date: 15/11/2016
Description: test class for PDIEAFCaseDetailController class
******************************************************/
@isTest
public class PDIEAFCaseDetailController_Test {
    //Merhod to test the case insertion along with address log history
    static testmethod void test_Facility_Case_Detail() {
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        User PDIUser = Util01_PDIUtilTestData.PDITestUser2();
        PDV_EAF_Facility__c eafFac = Util01_PDIUtilTestData.createEAFFacility();
        PDV_EAF_Validation_Audit_Trail__c eafAudit = Util01_PDIUtilTestData.createEAFAudit();
        Case eafCase =  Util01_PDIUtilTestData.facilityInquiryCase();
        Test.startTest();
        System.runAs(PDIUser){
            insert eafCase;
            eafFac.Case__c = eafCase.Id;
            insert eafFac;
            eafAudit.EAF_Facility__c = eafFac.Id;
            eafAudit.Case__c = eafCase.Id;
            insert eafAudit;
            PageReference pageRef = Page.PDIEAFCaseDetail;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('caseId', eafCase.id);
            PDIEAFCaseDetailController objCtlr = new PDIEAFCaseDetailController();
            //Checking audit history insertion related to case
            system.assertEquals(objCtlr.auditChangeHistory.size()>0, true);
        }
        Test.stopTest();
    }
}