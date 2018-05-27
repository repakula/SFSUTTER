/* 
     Class Name: SSOTrigger_Test 
     Author: IDC Offshore
     Date: 06-Dec-2016
     Description: Test class for SoldSignOff Trigger.
*/
@isTest
private class SSOTrigger_Test {
    private static Account acc;
    private static Opportunity opp;
    private static Incumbent_Carrier__c rfp;
    private static Proposal__c quote;
    private static Sold_Sign_Off__c sso;
    private static Rates__c rate;
    private static Rate_Card__c ratecard;
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
        opp.CloseDate = Date.Today()+30;
        opp.StageName = 'Pending Broker';
        insert opp;
        
        rfp = new Incumbent_Carrier__c();
        rfp.RecordtypeId = incRecordTypeId;
        rfp.Opportunity__c = opp.id;
        insert rfp;
        
        quote = new Proposal__c();
        quote.Opportunity_ID__c = opp.id;
        quote.RFP_Form__c = rfp.id;
        insert quote;
        
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
        bpm.Plan_Name__c = 'HE02-2016';
        insert bpm;
        
        bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.Version_Number__c = 1;
        bpa.Name = 'HE02-2016';
        bpa.Proposal__c = quote.id;
        insert bpa;
    }
    
    /* Test method to test if Plans in related Quote are Copied to SSO When SSO is inserted, Custom validations and creation of SCN when SSO is approved*/
    private static testMethod void testSSOApproval(){
        Test.startTest(); 
        setUpTestData();
            sso = new Sold_Sign_Off__c();
            sso.Opportunity_ID__c = opp.id;
            sso.Quote__c = quote.id;
            sso.Stage__c = 'Draft';
            sso.SSO_RSO_Due_Date__c = Date.today()+30;
            insert sso;
            
            rate = new Rates__c();
            rate.Sold_Sign_Off__c = sso.id;
            rate.Tier_2_EE__c = '12';
            rate.Plan_Name__c = 'HE02-2016'; 
            insert rate;
        
            ratecard = new Rate_Card__c();
            insert ratecard;
        
            bpa.SSO_Rate_Card__c = ratecard.id;
            update bpa;
        
            rate.Rate_Card_ID__c = ratecard.id;
            update rate;
            
            try{
                sso.Stage__c = 'Submitted to Underwriting';
                update sso;
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.HR215_SSOAttachmentMandatoryBeforeSubmitting) ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
        
            Blob b = Blob.valueOf('test data');
            Attachment attachment = new Attachment(); 
            attachment.ParentId = sso.id; 
            attachment.Name = 'Test Attachment for Parent'; 
            attachment.Body = b;   
            insert(attachment);
        
            sso.Stage__c = 'Submitted to Underwriting';
            update sso;
        
            try{
                sso.Stage__c = 'Approved by Underwriting';
                update sso;
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.HR190_SCNForClosedWonOpp) ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
            
            opp.StageName = 'Closed Won';
            update opp;
        	HighRoads_SoldSignOffTriggerHelper.isBeforeUpdate = true;
        	HighRoads_DocGenRequest.isOpportunityAfterUpdate = true;
            sso.Stage__c = 'Approved by Underwriting';
            update sso;
        
        
        Test.stopTest();
    }
}