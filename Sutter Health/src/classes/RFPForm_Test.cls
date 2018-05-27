/* 
     Class Name: RFPForm_Test 
     Author: IDC Offshore
     Date: 06-Dec-2016
     Description: Test class for RFPForm Trigger.
*/
@isTest
private class RFPForm_Test {
    private static Account acc;
    private static Opportunity opp;
    private static Incumbent_Carrier__c rfp;
    private static Benefit_Plan_Association__c bpa;
    private static Benefit_Plan_Metadata__c bpm;
    private static SHP_Benefit_Grid__c grid;
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
	private static Id incRecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('RFP Form').getRecordTypeId();
    private static Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHP Sales Opportunity').getRecordTypeId();
	
    /*Method to Set up Test data*/
    private static testMethod void setUpTestData(){
        
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg;
        
        acc = new Account();
        acc.Name = 'TestAcc1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Labor and Trust';
        insert acc;
        
        opp = new Opportunity();
        opp.Name = 'TestOpp1';
        opp.RecordTypeId = oppRecordTypeId;
        opp.AccountId = acc.id;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today();
        opp.StageName = 'Pending Broker';
        insert opp;
        
        grid = new SHP_Benefit_Grid__c();
        grid.Benefit_Plan_ID__c = 'HE02';
        grid.Market_Segment__c = 'Large Group';
        grid.SHP_Benefit_Plan_Year__c = '2016';
        grid.Plan_Name__c = 'HE02-2016';
        insert grid;
        
        bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = Date.today();
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Benefit_Plan_ID__c = 'HE02';
        bpm.Benefit_Grid__c = grid.id;
        insert bpm;
        
        bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.Version_Number__c = 1;
        bpa.Opportunity__c = opp.id;
        insert bpa;
    }
    
    /* Test method to test if Plans in related Opportunity are Copied to RFP When RFP is inserted, 
	System throws exceptions when  mandatory Fields are not Entered during RFP Submission
	& Quote Creation after RFP is approved*/
    private static testMethod void testRFPSubmissionApproval(){
    	Test.startTest(); 
        setUpTestData();
        
            rfp = new Incumbent_Carrier__c();
            rfp.RecordtypeId = incRecordTypeId;
            rfp.Opportunity__c = opp.id;
        	rfp.Stage__c = 'Draft';
            insert rfp;
        	
            try{
            	rfp.Reason_for_Market_Check__c = '';
                rfp.Stage__c = 'Submitted to Underwriting';
                
                RFP_IncumbentCarrierTriggerHelper.isBeforeUpdate = true;
        		update rfp;
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('Please enter # Of Quotes Requested before Submitting for approval') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
        
        	try{
            	rfp.No_of_Quotes_Requested__c = 12;
                rfp.Stage__c = 'Submitted to Underwriting';
                RFP_IncumbentCarrierTriggerHelper.isBeforeUpdate = true;
        		update rfp;
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('Please enter Reason for Market Check before Submitting for approval') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
        
        	try{
            	rfp.Reason_for_Market_Check__c = 'Test Reason';
                rfp.Stage__c = 'Submitted to Underwriting';
                RFP_IncumbentCarrierTriggerHelper.isBeforeUpdate = true;
        		update rfp;
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('Please enter Tiered Rates before Submitting for approval') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
        
        	try{
            	rfp.Tiered_Rates__c = '23';
                rfp.Stage__c = 'Submitted to Underwriting';
                RFP_IncumbentCarrierTriggerHelper.isBeforeUpdate = true;
        		update rfp;
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('Please provide Strategy Statement before Submitting for approval') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
        	
        	try{
            	rfp.Strategy_Statement__c = 'Test Statement';
                rfp.Stage__c = 'Submitted to Underwriting';
                RFP_IncumbentCarrierTriggerHelper.isBeforeUpdate = true;
        		update rfp;
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('Please provide Special Instructions before Submitting for approval') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
        	RFP_IncumbentCarrierTriggerHelper.isBeforeUpdate = true;
        	rfp.Special_Instuctions__c = 'Test Instructions';
        	rfp.Stage__c = 'Submitted to Underwriting';
        	update rfp;
        	RFP_IncumbentCarrierTriggerHelper.isBeforeUpdate = true;
        	RFP_IncumbentCarrierTriggerHelper.isAfterUpdate = true;
            rfp.Stage__c = 'Approved by Underwriting';
        	update rfp;
        
        Test.stopTest();
    }
}