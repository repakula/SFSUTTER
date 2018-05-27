/**********************************************************************
 Name: VFC05_Claim_Detail_Test
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for VFC05_Claim_Detail class
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  1/2/2014 Development complete   This class is defined to test VFC05_Claim_Detail class
 2.0      IDC Offshore  12/21/2015  Class Optimsation   Incorporated changes to implement best test practices in the test class.
 ***********************************************************************/

@isTest
public class VFC05_Claim_Detail_Test{

    /*******************************************************************
     Purpose: This Test Method is used to test the mappings of claimDetailFlags and claimFilterParameters for HealthEdgeMappingClass for claim
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
     static testmethod void claim_Detail_MappingTest() {
        
        Test.startTest();
        /** Instantiating the  HealthEdgeMappingClass and using it to intialize values to be used in the test method **/
        HealthEdgeMappingClass mapping = new HealthEdgeMappingClass();
        mapping.extractPayload = healthedgeComExtractTest.claim1();
       
        mapping.requestResponseStub(AP01_TestDataTokens.REQUEST_RESPONSE_STUB,5,6,2);
        
        PageReference claimPage = new PageReference(AP01_TestDataTokens.CLAIM_DETAIL_REFERENCE);
        Test.setCurrentPage(claimPage);
        VFC05_Claim_Detail claimController = new VFC05_Claim_Detail();
        healthEdgeComExtract.extractPayload extractPayload = new healthEdgeComExtract.extractPayload();
        healthedgeCom_6.ClaimServiceStronglyTypedTypePort stub = new healthedgeCom_6.ClaimServiceStronglyTypedTypePort();
        String HCCID = AP01_TestDataTokens.HCC_ID;
        claim_line_item claim_line_item = new claim_line_item();
        
        /** Setting the value of various flags related to Claim Detail **/
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

        claimController.showClaimDetail();
               
        /*********************************************************************** 
        Verifying the values of HCCID from the controller
        Expected Result: value should be as it is mentioned in AP01_TestDataTokens
        Actual Result: value should be as it is mentioned in AP01_TestDataTokens
        **********************************************************************/
        system.assertEquals(claimController.HCCID, AP01_TestDataTokens.HCCID);
        
        claimController.getpaginateList();
        
        /*********************************************************************** 
        Verifying the values of paginateList from the controller
        Expected Result: value should be 0
        Actual Result: value should be 0
        **********************************************************************/
        system.assertEquals(claimController.getpaginateList().size(), 0);
        claimController.getPageNumber();
        claimController.getPageSize();
     
        claimController.getPreviousButtonEnabled();
        claimController.setPageNumber(5);
        
        claimController.setpaginateList();
        claimController.setListIncrement(1);
        
        claimController.previousBtnClick();
        claimController.isPageNumberChanged(true);
        
        /*********************************************************************** 
        Verifying the values of isPageNumberChanged from the controller
        Expected Result: value should be 4
        Actual Result: value should be 4
       **********************************************************************/
        system.assertEquals(claimController.isPageNumberChanged(true), 4);
        
        claimController.isPageNumberChanged(false);
        
       /*********************************************************************** 
        Verifying the values of isPageNumberChanged from the controller
        Expected Result: value should be 4
        Actual Result: value should be 4
       **********************************************************************/
        
        system.assertEquals(claimController.isPageNumberChanged(false), 4);
        
        Test.stopTest();
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test the request response for test data set claim2 received by the stub for any particular claim. 
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
       static testmethod void claim_Detail_RequestResponseDataSetTest() {
           
        Test.startTest();   
        HealthEdgeMappingClass mapping = new HealthEdgeMappingClass();
        mapping.extractPayload = healthedgeComExtractTest.claim2();
        
        /*********************************************************************** 
        Verifying the value of mapping object
        Expected Result: value is not null
        Actual Result: value is not null
       **********************************************************************/
        system.assertnotequals(mapping,null);
        
        Test.stopTest();
        
        mapping.requestResponseStub(AP01_TestDataTokens.REQUEST_RESPONSE_STUB,5,6,2);
    }
    
    /*******************************************************************
     Purpose: This method tests the negative test case scenario where no data is passed to the mapping class
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
     static testmethod void claim_Detail_NegativeTest() {
        
        Test.startTest();   
        HealthEdgeMappingClass mapping = new HealthEdgeMappingClass();
        
        /*********************************************************************** 
        Verifying the value of mapping object
        Expected Result: value is not null
        Actual Result: value is not null
       **********************************************************************/
        system.assertnotequals(mapping,null);
        Test.stopTest();   
        
        mapping.requestResponseStub(AP01_TestDataTokens.REQUEST_RESPONSE_STUB,5,6,2);
    }
        
    /*******************************************************************
     Purpose: This Test Method is used to test the request response for test data set claim3 received by the stub for any particular claim.
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testmethod void claim_Detail_ReqResponseTest() {
        
        Test.startTest();   
        HealthEdgeMappingClass mapping = new HealthEdgeMappingClass();
        mapping.extractPayload = healthedgeComExtractTest.claim3();
       
       /*********************************************************************** 
        Verifying the value of mapping object
        Expected Result: value is not null
        Actual Result: value is not null
       **********************************************************************/
        system.assertnotequals(mapping,null);
        Test.stopTest();   
       
        mapping.requestResponseStub(AP01_TestDataTokens.REQUEST_RESPONSE_STUB,5,6,2);
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test the mappings of claimDetailFlags and claimFilterParameters for HealthEdgeMappingClass for claim1
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/     
    
    static testmethod void claim_Detail_HealthMappingsTest() {
       
        Test.startTest();
        HealthEdgeMappingClass mapping = new HealthEdgeMappingClass();
        mapping.extractPayload = healthedgeComExtractTest.claim2();
       
        mapping.requestResponseStub(AP01_TestDataTokens.REQUEST_RESPONSE_STUB,5,6,2);
        
        PageReference claimPage = new PageReference(AP01_TestDataTokens.CLAIM_DETAIL_REFERENCE);
        Test.setCurrentPage(claimPage);
        VFC05_Claim_Detail claimController = new VFC05_Claim_Detail();
        healthEdgeComExtract.extractPayload extractPayload = new healthEdgeComExtract.extractPayload();
        healthedgeCom_6.ClaimServiceStronglyTypedTypePort stub = new healthedgeCom_6.ClaimServiceStronglyTypedTypePort();
        String HCCID = AP01_TestDataTokens.HCC_ID;
        claim_line_item claim_line_item = new claim_line_item();
        List<claim_line_item > lst_claim_line_item = new List<claim_line_item>();
        lst_claim_line_item.add(claim_line_item);
        lst_claim_line_item.add(claim_line_item);
        claimController.claim_line_item = claim_line_item;
        claimController.claimOne = claim_line_item;
        claimController.claimline = claim_line_item;
        
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

        claimController.showClaimDetail();
        
       /*********************************************************************** 
        Verifying the value of HCCID 
        Expected Result: value is as mentioned in AP01_TestDataTokens.
        Actual Result: value is as mentioned in AP01_TestDataTokens.
       **********************************************************************/
        
        system.assertEquals(claimController.HCCID, AP01_TestDataTokens.HCCID);
        
        claimController.getpaginateList();
        claimController.getPageNumber();
        claimController.getPageSize();
        mapping.TotalClaimLineItemList = lst_claim_line_item;
        claimController.getNextButtonEnabled();
        claimController.setpaginateList();
        
       /*********************************************************************** 
        Verifying the size of paginateList
        Expected Result: size  is 0.
        Actual Result: size is 0.
       **********************************************************************/
        system.assertEquals(claimController.getpaginateList().size(), 0);
        
        claimController.setPageNumber(0);
        claimController.setpaginateList();
        claimController.setListIncrement(1);
        claimController.nextBtnClick();
        claimController.setPageNumber(-1);
        claimController.getNextButtonEnabled();
        claimController.getPreviousButtonEnabled();
        claimController.nextBtnClick();
        claimController.previousBtnClick();
        claimController.isPageNumberChanged(true);
        
        claimController.isPageNumberChanged(false);
        
        mapping.paginateClaim(1, 1, 1);
        
        Test.stopTest();
    }
    
   
}