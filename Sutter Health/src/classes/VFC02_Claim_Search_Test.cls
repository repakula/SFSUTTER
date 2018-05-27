/**  
*     Class Name  : VFC02_Claim_Search_Test
*     Author      : IDC Offshore
*     Date        : 29-Dec-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description : Test Class for VFC02_Claim_Search Class. This class tests for different scenarios that are handled in the code
**/
@isTest
private class VFC02_Claim_Search_Test {
	
	/**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method to test scenario where Member Id is passed to the page and the Case is not closed, SearchClaim, associateMultiple Claims, 
    * setClaimLink, openAssociatedClaimDetail, showDetailClose
    * @param 
    * @return 
    */
    static testMethod void testClaimSearchforMember() {
        
        Case custInt = AP01_TestDataUtility.createCase();
        String caseId = custInt.id;
        
        AP01_TestDataUtility.createClaimHeaderList();
        Claim_Header__c claimOne = AP01_TestDataUtility.createClaimHeader();
        String claimId = claimOne.id;
        
        List<Customer_Inquiry_Claim_Association__c> associationList = AP01_TestDataUtility.custIntClaimAssList(caseId, claimId);
        String parameters = AP01_TestDataTokens.CLAIM_SEARCH_PARAMETERS + caseId;
        Pagereference ref = new Pagereference(AP01_TestDataTokens.CLAIM_SEARCH_PAGE_REFERENCE + parameters);
        Test.setCurrentPage(ref); 
        
        VFC02_Claim_Search claimCtrl = new VFC02_Claim_Search(); 
        
        system.assertEquals(claimCtrl.claimMemberID, AP01_TestDataTokens.CLAIM_MEMBER_ID_FIELD); 
        system.assertEquals(claimCtrl.isClosed, false);
        
        claimCtrl.associateClaimWrapperList[0].isSelected = true;
        claimCtrl.claimID = AP01_TestDataTokens.CLAIM_ID;
        
        claimCtrl.SearchClaim();
        system.assertEquals(claimCtrl.claimResults.size(), 4);
        
        claimCtrl.claimWrapperList[0].isSelected = true;
        
        system.assertEquals(claimCtrl.associateClaimWrapperList.size(), 1);
        
        claimCtrl.associateMultipleClaim();
        system.assertEquals(claimCtrl.associateClaimWrapperList.size(), 2);
        
        claimCtrl.setClaimLink();
        system.assertEquals(claimCtrl.showTab, 'tab3');
        
        claimCtrl.openAssociatedClaimDetail();
        system.assertEquals(claimCtrl.showTab, 'tab4');
        
        claimCtrl.showDetailClose();
        system.assertEquals(claimCtrl.showTab, 'tab1');
        
        claimCtrl.claimLinkId = claimId;
    }
    
    /**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method to test scenario where Member Id is passed to the page and to link Single claim to the Interaction Log
    * @param 
    * @return 
    */
    static testMethod void testClaimSearch_SingleAssociation() {
        
        Case custInt = AP01_TestDataUtility.createCase();
        String caseId = custInt.id;
        
        Claim_Header__c claimOne = AP01_TestDataUtility.createClaimHeader();
        String claimId = claimOne.id;
        
        String parameters = AP01_TestDataTokens.CLAIM_SEARCH_PARAMETERS + caseId;
        Pagereference ref = new Pagereference(AP01_TestDataTokens.CLAIM_SEARCH_PAGE_REFERENCE + parameters);
        Test.setCurrentPage(ref); 
        
        VFC02_Claim_Search claimCtrl = new VFC02_Claim_Search(); 
        
        system.assertEquals(claimCtrl.claimMemberID, AP01_TestDataTokens.CLAIM_MEMBER_ID_FIELD);
        system.assertEquals(claimCtrl.isClosed, false);
        
        claimCtrl.claimLinkId = claimId;
        system.assertEquals(claimCtrl.associateClaimWrapperList.size(), 0);
        
        claimCtrl.SearchClaim();
        
        claimCtrl.associateSingleClaim();
        system.assertEquals(claimCtrl.associateClaimWrapperList.size(), 1);
    }

    /**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method to test scenario where Member Id is passed to the page and Claim trying to associate is already associated to the interaction log
    * @param 
    * @return 
    */
    static testMethod void testClaimSearch_SingleAssociationAlready() {
        
        Case custInt = AP01_TestDataUtility.createCase();
        String caseId = custInt.id;
        
        Claim_Header__c claimOne = AP01_TestDataUtility.createClaimHeader();
        String claimId = claimOne.id;
        
        List<Customer_Inquiry_Claim_Association__c> associationList = AP01_TestDataUtility.custIntClaimAssList(caseId, claimId);
        String parameters = AP01_TestDataTokens.CLAIM_SEARCH_PARAMETERS + caseId;
        Pagereference ref = new Pagereference(AP01_TestDataTokens.CLAIM_SEARCH_PAGE_REFERENCE + parameters);
        Test.setCurrentPage(ref); 
        
        VFC02_Claim_Search claimCtrl = new VFC02_Claim_Search(); 
        
        system.assertEquals(claimCtrl.claimMemberID, AP01_TestDataTokens.CLAIM_MEMBER_ID_FIELD);
        system.assertEquals(claimCtrl.isClosed, false);
        
        claimCtrl.claimLinkId = claimId;
        system.assertEquals(claimCtrl.associateClaimWrapperList.size(), 1);
        
        claimCtrl.SearchClaim();
        
        claimCtrl.associateSingleClaim();
        system.assertEquals(claimCtrl.alreadyMessage, true);
        system.assertEquals(claimCtrl.associateClaimWrapperList.size(), 1);
    }

    /**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method to test Dissociate Claims functionality from the interaction log
    * @param 
    * @return 
    */
    static testMethod void testDissociateClaims() {
        
        Case custInt = AP01_TestDataUtility.createCase();
        String caseId = custInt.id;
        
        AP01_TestDataUtility.createClaimHeaderList();
        Claim_Header__c claimOne = AP01_TestDataUtility.createClaimHeader();
        String claimId = claimOne.id;
        
        Claim_Header__c claimTwo = AP01_TestDataUtility.createClaimHeader();
        String claimId_1 = claimTwo.id;
        
        List<Customer_Inquiry_Claim_Association__c> associationList = AP01_TestDataUtility.custIntClaimAssList(caseId, claimId);
        List<Customer_Inquiry_Claim_Association__c> associationList_1 = AP01_TestDataUtility.custIntClaimAssList(caseId, claimId_1);      
        
        String parameters = AP01_TestDataTokens.CLAIM_SEARCH_PARAMETERS + caseId;
        Pagereference ref = new Pagereference(AP01_TestDataTokens.CLAIM_SEARCH_PAGE_REFERENCE + parameters);
        Test.setCurrentPage(ref); 
        
        VFC02_Claim_Search claimCtrl = new VFC02_Claim_Search(); 
        
        system.assertEquals(claimCtrl.claimMemberID, AP01_TestDataTokens.CLAIM_MEMBER_ID_FIELD); 
        system.assertEquals(claimCtrl.isClosed, false);
        
        claimCtrl.associateClaimWrapperList[0].isSelected = true;
        system.assertEquals(claimCtrl.associateClaimWrapperList.size(), 2);
        
        claimCtrl.dissociateClaims();
        system.assertEquals(claimCtrl.associateClaimWrapperList.size(), 1);
    }
    
    /**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method to test the scenario where providerId is passed to the Class and SearchClaim method
    * @param 
    * @return 
    */
    static testMethod void testClaimSearchforProvider() {
        
        Claim_Header__c claimTwo = AP01_TestDataUtility.createClaimHeader();
        Case custInt = AP01_TestDataUtility.createCase();
        String caseId = custInt.id;
        String parameters = 'memberId=&providerId=S0001234-01&caseStatus=false&custId=' + caseId;
        Pagereference ref = new Pagereference('/apex/VFP02_Claim_Search?' + parameters);
        Test.setCurrentPage(ref);
        
        AP01_TestDataUtility.createClaimHeaderList();
        
        VFC02_Claim_Search claimCtrl = new VFC02_Claim_Search();
        
        system.assertEquals(claimCtrl.claimProviderID, 'S0001234-01');
        system.assertEquals(claimCtrl.isClosed, false);
        
        claimCtrl.SearchClaim();
        system.assertEquals(claimCtrl.claimResults.size(), 4);
        
    }
    
    /**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method that tests the scenario where Interaction log is closed
    * @param 
    * @return 
    */
    static testMethod void testClaimSearchforIsClosed() {
        
        Case custInt = AP01_TestDataUtility.createCase();
        String caseId = custInt.id;
        String parameters = 'memberId=&providerId=123456&caseStatus=true&custId=' + caseId;
        Pagereference ref = new Pagereference('/apex/VFP02_Claim_Search?' + parameters);
        Test.setCurrentPage(ref);
        
        AP01_TestDataUtility.createClaimHeaderList();
        
        VFC02_Claim_Search claimCtrl = new VFC02_Claim_Search();
        
        system.assertEquals(claimCtrl.claimProviderID, '123456');
        system.assertEquals(claimCtrl.isClosed, true);
        
    }

    /**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method to test claim search positive scenario to return search result
    * @param 
    * @return 
    */
    static testMethod void claimSearchPositiveResults(){
        Claim_Header__c clHead = new Claim_Header__c ();
        clHead.Name = '000123-01';
        clHead.SHPClaimHdr_Claim_HCC_ID__c = 'C0001234-01';
        clHead.SHPClaimHdr_Member_HCC_ID__c = 'M0001234-01';
        clHead.ClaimMemberIdField__c = '000123401';
        clHead.SHPClaimHdr_Supplier_HCC_ID__c = 'S0001234-01';
        clHead.SHPClaimHdr_Claim_DoS_Start__c = system.today();
        insert clHead;
        
        VFC02_Claim_Search controller = new VFC02_Claim_Search();
        
        controller.claimID = 'C0001234-01';
        controller.claimMemberID = '0001234010';
        controller.claimProviderID = 'S0001234-01';
        controller.claimSearchStartDate.SearchDate__c = system.today() - 7;
        controller.claimSearchEndDate.SearchDate__c = system.today() + 7;
        controller.getClaimSearchStartDate();
        controller.getClaimSearchEndDate();
    	controller.SearchClaim();
    	
    	system.assertEquals(controller.claimResults.size(), 1);
    }
    
    /**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method to test claim search negative scenario where no search result is returned
    * @param 
    * @return 
    */
    static testMethod void claimSearchNegativeResults(){
        Claim_Header__c clHead = new Claim_Header__c ();
        clHead.Name = '000123-01';
        clHead.SHPClaimHdr_Claim_HCC_ID__c = 'C0001234-01';
        clHead.SHPClaimHdr_Member_HCC_ID__c = 'M0001234-01';
        clHead.SHPClaimHdr_Supplier_HCC_ID__c = 'S0001234-01';
        clHead.SHPClaimHdr_Claim_DoS_Start__c = system.today();
        insert clHead;
        
        VFC02_Claim_Search controller = new VFC02_Claim_Search();
        
        controller.claimID = 'C0001234-02';
        controller.claimMemberID = '000123401';
        controller.claimProviderID = 'S0001234-01';
        controller.claimSearchStartDate.SearchDate__c = system.today() - 7;
        controller.claimSearchEndDate.SearchDate__c = system.today() - 14;
        controller.getClaimSearchStartDate();
        controller.getClaimSearchEndDate();
    	controller.SearchClaim();    
    	
    	system.assertEquals(controller.claimResults.size(), 0);
    }
    
    /**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method to test claim search negative scenario where end date is null and no search results are returned
    * @param 
    * @return 
    */
    static testMethod void claimSearchNegativeResults_EndDateNull() {
        Claim_Header__c clHead = new Claim_Header__c ();
        clHead.Name = '000123-01';
        clHead.SHPClaimHdr_Claim_HCC_ID__c = 'C0001234-01';
        clHead.SHPClaimHdr_Member_HCC_ID__c = 'M0001234-01';
        clHead.SHPClaimHdr_Supplier_HCC_ID__c = 'S0001234-01';
        clHead.SHPClaimHdr_Claim_DoS_Start__c = system.today();
        insert clHead;
        
        VFC02_Claim_Search controller = new VFC02_Claim_Search();
        
        controller.claimID = 'C0001234-01';
        controller.claimMemberID = '000123401';
        controller.claimProviderID = 'S0001234-01';
        controller.claimSearchStartDate.SearchDate__c = system.today() - 7;
        controller.getClaimSearchStartDate();
        controller.getClaimSearchEndDate();
    	controller.SearchClaim();    
    	
    	system.assertEquals(controller.claimResults.size(), 0);
    	
    }
    
    /**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method to test claim search negative scenario when search is done only on Member Id
    * @param
    * @return 
    */
    static testMethod void claimSearchNegativeResultsOnMemberId(){
        Claim_Header__c clHead = new Claim_Header__c ();
        clHead.Name = '000123-01';
        clHead.SHPClaimHdr_Claim_HCC_ID__c = 'C0001234-01';
        clHead.SHPClaimHdr_Member_HCC_ID__c = 'M0001234-01';
        clHead.SHPClaimHdr_Supplier_HCC_ID__c = 'S0001234-01';
        clHead.SHPClaimHdr_Claim_DoS_Start__c = system.today();
        insert clHead;
        
        VFC02_Claim_Search controller = new VFC02_Claim_Search();
        
        controller.claimMemberID = '000123401';
        controller.SearchClaim();  
        
        system.assertEquals(controller.claimResults.size(), 0);  
    	
    }
    
    /**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method for Search Claim negative scenario when MemberId is not passed and no results are returned
    * @param 
    * @return 
    */
    static testMethod void claimSearchNegativeNullMemberId() {
        
        Claim_Header__c clHead = new Claim_Header__c ();
        clHead.Name = '000123-01';
        clHead.ClaimMemberIdField__c = '1234567890';
        insert clHead;
        
        Case custInt = AP01_TestDataUtility.createCase();
        String caseId = custInt.id;
        String parameters = 'memberId=&providerId=&caseStatus=false&custId=' + caseId;
        Pagereference ref = new Pagereference('/apex/VFP02_Claim_Search?' + parameters);
        Test.setCurrentPage(ref);
        
        VFC02_Claim_Search claimCtrl = new VFC02_Claim_Search();
        
        
        system.assertEquals(claimCtrl.claimMemberID, null);
        system.assertEquals(claimCtrl.isClosed, false);
        
        claimCtrl.SearchClaim();
        
        system.assertEquals(claimCtrl.claimResults.size(), 0);
    }
    
    /**
    * @author IDC Team
    * @date 29/12/2013
    * @description Method when invalid custId is passed
    * @param 
    * @return 
    */
    static testMethod void constructorNegative() {
        
        String parameters = '/apex/VFP02_Claim_Search?memberId=%%&providerId=&caseStatus=false&custId=123';
        Pagereference ref = new Pagereference(parameters);
        Test.setCurrentPage(ref); 
        
        VFC02_Claim_Search claimCtrl = new VFC02_Claim_Search();
        
        system.assertEquals(claimCtrl.custId, null);
        system.assertEquals(claimCtrl.associateClaimWrapperList.size(), 0);
    }
   
}