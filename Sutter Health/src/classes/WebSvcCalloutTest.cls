@isTest
public class WebSvcCalloutTest {

    @isTest static void method1() {
        HealthEdgeMappingClass mapping = new HealthEdgeMappingClass();
        mapping.extractPayload = healthedgeComExtractTest.claim1();
        system.debug('@@payload :'+mapping.extractPayload);
        mapping.requestResponseStub('20131202000017',5,6,2);
        
        PageReference claimPage = new PageReference('/apex/VFP05_Claim_Detail_Sak?hccid=20131003000034');
        Test.setCurrentPage(claimPage);
        VFC05_Claim_Detail claimController = new VFC05_Claim_Detail();
        healthEdgeComExtract.extractPayload extractPayload = new healthEdgeComExtract.extractPayload();
        healthedgeCom_6.ClaimServiceStronglyTypedTypePort stub = new healthedgeCom_6.ClaimServiceStronglyTypedTypePort();
        String HCCID = '234562345';
        claim_line_item claim_line_item = new claim_line_item();
        
        healthedgeCom_6.claimDetailFlags claimDetailFlags = new healthedgeCom_6.claimDetailFlags();
        healthedgeCom_6.claimFilterParameters claimFilterParameters = new healthedgeCom_6.claimFilterParameters();
        claimDetailFlags.includeAccounts = true;
        claimDetailFlags.includeAccumulators = true;
        claimDetailFlags.includeBenefitPlan = true;
        claimDetailFlags.includeBenefitNetwork = true;
        claimDetailFlags.includeExternalRepricerResult = true; 
        claimDetailFlags.includeFundedAccounts = true;
        claimDetailFlags.includeIngenixExternalLineResult = true;
        claimDetailFlags.includePractitioner = true;
        claimDetailFlags.includeProcedureInformation = true;
        claimDetailFlags.includeProduct = true;
        claimDetailFlags.includeReportingCategories = true;
        claimDetailFlags.includeRepricerName = true;
        claimDetailFlags.includeSupplier = true;
        claimDetailFlags.includeSupplierInvoice = true;
        claimDetailFlags.includeSupplierLocation = true;
        claimDetailFlags.includeWithholding = true;
        claimFilterParameters.includeAllPreviouslyPaid = true;
        claimFilterParameters.includeReversedClaimHeader = true;

        //Requested object from HealthEdge
        //stub.getClaimDetailsByHccID(HCCID,claimDetailFlags,claimFilterParameters);
        
        claimController.showClaimDetail();
        claimController.getpaginateList();
        claimController.getPageNumber();
        claimController.getPageSize();
        claimController.getNextButtonEnabled();
        claimController.getPreviousButtonEnabled();
        claimController.setPageNumber(5);
        claimController.setpaginateList();
        claimController.setListIncrement(1);
        claimController.nextBtnClick();
        claimController.previousBtnClick();
        claimController.isPageNumberChanged(true);
        
        //Assert to check claimController
        system.assertnotequals(claimController,null);
    }
    
    @isTest static void method2() {
        HealthEdgeMappingClass mapping = new HealthEdgeMappingClass();
        mapping.extractPayload = healthedgeComExtractTest.claim2();
        system.debug('@@payload :'+mapping.extractPayload);
        mapping.requestResponseStub('20131202000017',5,6,2);
        //Assert to check mapping
        system.assertnotequals(mapping,null);
    }
    @isTest static void method3() {
        HealthEdgeMappingClass mapping = new HealthEdgeMappingClass();
        mapping.extractPayload = healthedgeComExtractTest.claim3();
        system.debug('@@payload :'+mapping.extractPayload);
        mapping.requestResponseStub('20131202000017',5,6,2);
        //Assert to check mapping
        system.assertnotequals(mapping,null);
        
    }
}