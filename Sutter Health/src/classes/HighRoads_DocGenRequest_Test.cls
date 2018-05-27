/* 
     Class Name: HighRoads_DocGenRequest_Test 
     Author: IDC Offshore
     Date: 01-Dec-2016
     Description: Test class for HighRoads_DocGenRequest Controller.
*/
@isTest
private class HighRoads_DocGenRequest_Test {
    
    private static Document_Generation_Request__c dgr;
    private static Document_Benefit_Plan__c dbp;
    private static Account acc,acc1;
    private static Opportunity opp,opp1;
    private static Employer_Group_Data__c scn;
    private static Benefit_Plan_Association__c bpa,bpa1,bpa2,bpa3,bpa4,bpa5,bpa6;
    private static Benefit_Plan_Metadata__c bpm,bpm1,bpm2,bpm4;
    private static Incumbent_Carrier__c rfp;
    private static Proposal__c quote;
    private static Sold_Sign_Off__c sso;
    private static SHP_Benefit_Grid__c grid,grid1,grid2,grid3;
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
    private static Id incRecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('RFP Form').getRecordTypeId();
    private static Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHP Sales Opportunity').getRecordTypeId();
    public static testMethod void testController(){
        
        Profile profile = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        User user = new User(Alias = 'test', Email='test.user@sutter.com.dev',
              EmailEncodingKey='ISO-8859-1', LastName='Account Manager',LanguageLocaleKey='en_US',
              LocaleSidKey='en_US', ProfileId = profile .Id,TimeZoneSidKey='America/Los_Angeles',
              UserName='test.user@sutter.com.dev');
        insert user; 
        
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg1 = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg1;
        
        acc = new Account();
        acc.Name = 'Test Account1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Labor and Trust';
        insert acc;
        
        acc1 = new Account();
        acc1.Name = 'Test Account1';
        acc1.RecordTypeId = accRecordTypeId;
        acc1.NumberOfEmployees = 50;
        acc1.Industry = 'Hospitaity';
        acc1.Employer_Type__c = 'Small Mid-Market Group (51 - 100)';
        insert acc1;
        
        opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordTypeId;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today()+30;
        opp.StageName = 'Closed Won';
        opp.Renewed_Opportunity__c = false;
        insert opp;
        
        opp1 = new Opportunity();
        opp1.Name = 'Test Opp1';
        opp1.RecordTypeId = oppRecordTypeId;
        opp1.AccountId = acc1.id;
        opp1.type = 'New Business';
        opp1.CloseDate = Date.Today()+40;
        opp1.StageName = 'Pending AE';
        opp1.Renewed_Opportunity__c = false;
        insert opp1;
        
        grid = new SHP_Benefit_Grid__c();
        grid.Benefit_Plan_ID__c = 'HE02';
        grid.Market_Segment__c = 'Large Group';
        grid.SHP_Benefit_Plan_Year__c = '2016';
        grid.Plan_Name__c = 'HE02-2016';
        insert grid;
        
        grid1 = new SHP_Benefit_Grid__c();
        grid1.Benefit_Plan_ID__c = 'XA02';
        grid1.Market_Segment__c = 'Large Group';
        grid1.SHP_Benefit_Plan_Year__c = '2016';
        insert grid1;
        
        grid3 = new SHP_Benefit_Grid__c();
        grid3.Benefit_Plan_ID__c = 'XA03';
        grid3.Market_Segment__c = 'Large Group';
        grid3.SHP_Benefit_Plan_Year__c = '2016';
        insert grid3;
        
        grid2 = new SHP_Benefit_Grid__c();
        grid2.Benefit_Plan_ID__c = 'ML02';
        grid2.Market_Segment__c = 'Large Group';
        grid2.SHP_Benefit_Plan_Year__c = '2016';
        insert grid2;
        
        bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = Date.today();
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Ancillary_EOC__c = false;
        bpm.Ancillary_GSA__c = false;
        bpm.Ancillary_SOB__c = false;
        bpm.EOC__c = true;
        bpm.BCM__c = true;
        bpm.SBC__c = true;
        bpm.Benefit_Plan_ID__c = 'HE02';
        bpm.Benefit_Grid__c = grid.id;
        insert bpm;
        
        bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = Date.today();
        bpm1.Market_Segment__c = 'Large Group';
        bpm1.Plan_Type__c = 'Standard';
        bpm1.Ancillary_EOC__c = true;
        bpm1.Ancillary_GSA__c = true;
        bpm1.Ancillary_SOB__c = true;
        bpm1.EOC__c = true;
        bpm1.BCM__c = true;
        bpm1.SBC__c = true;
        bpm1.Benefit_Plan_ID__c = 'XA02';
        bpm1.Benefit_Grid__c = grid1.id;
        insert bpm1;
        
        bpm4 = new Benefit_Plan_Metadata__c();
        bpm4.Name = 'XA03';
        bpm4.Medical_OR_Rider__c = 'Rider';
        bpm4.Product_Class__c = 'Acupuncture and Chiro';
        bpm4.Effective_Date__c = Date.today();
        bpm4.Market_Segment__c = 'Large Group';
        bpm4.Plan_Type__c = 'Standard';
        bpm4.Ancillary_EOC__c = true;
        bpm4.Ancillary_GSA__c = true;
        bpm4.Ancillary_SOB__c = true;
        bpm4.EOC__c = true;
        bpm4.BCM__c = true;
        bpm4.SBC__c = true;
        bpm4.Benefit_Plan_ID__c = 'XA03';
        bpm4.Benefit_Grid__c = grid1.id;
        insert bpm4;
        
        bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Effective_Date__c = Date.today();
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Custom';
        bpm2.Ancillary_EOC__c = true;
        bpm2.Ancillary_GSA__c = true;
        bpm2.Ancillary_SOB__c = true;
        bpm2.EOC__c = false;
        bpm2.BCM__c = false;
        bpm2.SBC__c = false;
        bpm2.Benefit_Plan_ID__c = 'ML02';
        bpm2.Benefit_Grid__c = grid2.id;
        insert bpm2;
        
        rfp = new Incumbent_Carrier__c();
        rfp.RecordtypeId = incRecordTypeId;
        rfp.Opportunity__c = opp.id;
        insert rfp;
        
        opp.StageName = 'Closed Won';
        update opp;
        
        quote = new Proposal__c();
        quote.Opportunity_ID__c = opp.id;
        quote.RFP_Form__c = rfp.id;
        insert quote;
        
        sso = new Sold_Sign_Off__c();
        sso.Opportunity_ID__c = opp.id;
        sso.Quote__c = quote.id;
        sso.SSO_RSO_Due_Date__c = Date.today()+60;
        sso.Stage__c = 'Draft';
        insert sso;
        Rate_Card__c ratecard = new Rate_Card__c();
        insert ratecard;
        
        bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.Name = bpm.Name;
        bpa.SSO_Benefit_Version__c = 1;
        bpa.Sold_Sign_Off__c = sso.id;
        bpa.SSO_Rate_Card__c = ratecard.Id;
        insert bpa;
        
        
        bpa1 = new Benefit_Plan_Association__c();
        bpa1.Name = bpm.Name;
        bpa1.Benefit_Plan_Metadata__c = bpm.id;
        bpa1.Raider_ID__c = bpm1.id;
        bpa1.SSO_Benefit_Version__c = 1;
        bpa1.Sold_Sign_Off__c = sso.id;
        bpa1.SSO_Rate_Card__c = ratecard.Id;
        insert bpa1;
        
        Benefit_Plan_Association__c bpa7 = new Benefit_Plan_Association__c();
        bpa7.Benefit_Plan_Metadata__c = bpm.id;
        bpa7.Name = bpm.Name;
        bpa7.Raider_ID__c = bpm4.id;
        bpa7.Version_Number__c = 1;
        bpa7.Sold_Sign_Off__c = sso.id;
        bpa7.SSO_Rate_Card__c = ratecard.Id;
        insert bpa7;
        
        bpa2 = new Benefit_Plan_Association__c();
        bpa2.Name = bpm2.Name;
        bpa2.Benefit_Plan_Metadata__c = bpm2.id;
        bpa2.Sold_Sign_Off__c = sso.id;
        bpa2.SSO_Rate_Card__c = ratecard.Id;
        bpa2.SSO_Benefit_Version__c = 1;
        insert bpa2;
        
        bpa3 = new Benefit_Plan_Association__c();
        bpa3.Benefit_Plan_Metadata__c = bpm.id;
        bpa3.Version_Number__c = 1;
        bpa3.Opportunity__c = opp1.id;
        insert bpa3;
        
        bpa4 = new Benefit_Plan_Association__c();
        bpa4.Benefit_Plan_Metadata__c = bpm.id;
        bpa4.Raider_ID__c = bpm1.id;
        bpa4.Version_Number__c = 1;
        bpa4.Opportunity__c = opp1.id;
        insert bpa4;
        
        bpa6 = new Benefit_Plan_Association__c();
        bpa6.Benefit_Plan_Metadata__c = bpm.id;
        bpa6.Raider_ID__c = bpm4.id;
        bpa6.Version_Number__c = 1;
        bpa6.Opportunity__c = opp1.id;
        insert bpa6;
        
        bpa5 = new Benefit_Plan_Association__c();
        bpa5.Benefit_Plan_Metadata__c = bpm2.id;
        bpa5.Version_Number__c = 1;
        bpa5.Opportunity__c = opp1.id;
        insert bpa5;
            
        
        /* Inserting Rarte for Plans */
        Rates__c rate = new Rates__c();
        rate.Rate_Card_ID__c = ratecard.id;
        rate.Sold_Sign_Off__c = sso.id;
        rate.Tier_2_EE__c = '12';
        rate.Tier_Type__c = 'Tier 1';
        rate.Group_Type__c = 'Active';
        rate.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_Medical';
        rate.Plan_Type_Tier_Group__c = opp.id+'_HE02 - 2016_Medical_Tier 1_Active';
        rate.Plan_Name__c = 'HE02 - 2016'; 
        insert rate;
        
        Rates__c rateRider = new Rates__c();
        rateRider.Rate_Card_ID__c = ratecard.id;
        rateRider.Sold_Sign_Off__c = sso.id;
        rateRider.Tier_2_EE__c = '12';
        rateRider.Tier_Type__c = 'Tier 1';
        rateRider.Group_Type__c = 'Active';
        rateRider.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_XA02 - 2016';
        rateRider.Plan_Type_Tier_Group__c = opp.id+'_HE02 - 2016_XA02 - 2016_Tier 1_Active';
        rateRider.Plan_Name__c = 'XA02 - 2016'; 
        insert rateRider;
        
        Rates__c rate2 = new Rates__c();
        rate2.Rate_Card_ID__c = ratecard.id;
        rate2.Sold_Sign_Off__c = sso.id;
        rate2.Tier_2_EE__c = '12';
        rate2.Tier_Type__c = 'Tier 1';
        rate2.Group_Type__c = 'Active';
        rate2.Medical_Plan_Rider_Plan__c = 'ML02 - 2016_Medical';
        rate2.Plan_Type_Tier_Group__c = sso.id+'_ML02 - 2016_Medical_Tier 1_Active';
        rate2.Plan_Name__c = 'ML02 - 2016'; 
        insert rate2;
        
        Rates__c rateRider2 = new Rates__c();
        rateRider2.Rate_Card_ID__c = ratecard.id;
        rateRider2.Sold_Sign_Off__c = sso.id;
        rateRider2.Tier_2_EE__c = '12';
        rateRider2.Tier_Type__c = 'Tier 1';
        rateRider2.Group_Type__c = 'Active';
        rateRider2.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_XA03 - 2016';
        rateRider2.Plan_Type_Tier_Group__c = sso.id+'_HE02 - 2016_XA03 - 2016_Tier 1_Active';
        rateRider2.Plan_Name__c = 'XA03 - 2016'; 
        insert rateRider2;
        Attachment att = new Attachment();
        att.ParentId = sso.id;
        att.Name = 'test doc';
        att.Body = blob.valueOf('test');
        insert att;

        Test.startTest();
        	List<Benefit_Plan_Association__c> bapList1 = [select id,name from benefit_plan_Association__c where sold_sign_Off__c =:sso.Id];
        system.debug('bapList1:::'+bapList1);
        	sso.Stage__c = 'Submitted to Underwriting';
            update sso;
        
            sso.Stage__c = 'Approved by Underwriting';
            update sso;
        	Document_Generation_Request__c dgrObjTest = new Document_Generation_Request__c();
        	dgrObjTest.Sold_Sign_Off__c = sso.Id;
        	Insert dgrObjTest;
        	Document_Benefit_Plan__c dbpObj = new Document_Benefit_Plan__c();
        	dbpObj.Name = 'HE02 - 2016';
        	dbpObj.Document_Generation_Request__c = dgrObjTest.Id;
        	insert dbpObj;
        	Document_Benefit_Plan__c dbpObj1 = new Document_Benefit_Plan__c();
        	dbpObj1.Name = 'HE02 - 2016';
        	dbpObj1.Rider_Plan_Name__c = 'XA02 - 2016';
        	dbpObj1.Document_Generation_Request__c = dgrObjTest.Id;
        	insert dbpObj1;
        	//Document_Generation_Request__c dgrObj = [select id from Document_Generation_Request__c where sold_sign_off__c =:sso.Id];
        	Test.setCurrentPage(Page.HighRoads_DocGenRequestExport);
        	Apexpages.standardcontroller sc1 = new Apexpages.standardcontroller(dgrObjTest);
            HighRoads_DocGenRequest vfcont1 = new HighRoads_DocGenRequest(sc1);
        	
            opp1.StageName = 'Closed Won';
            HighRoads_DocGenRequest.isOpportunityAfterUpdate = true;
            update opp1;
            List<Benefit_Plan_Association__c> bpaList = [select id from Benefit_Plan_Association__c where opportunity__c = :opp1.Id];
    
            Set<ID> updatedIds = new Set<ID>();
            updatedIds.add(sso.Id);
            Set<ID> oppIds = new Set<ID>();
            oppIds.add(opp1.Id);
            
            Document_Generation_Request__c docgenReq = new Document_Generation_Request__c();
            for(Document_Generation_Request__c docgenReqObj : [select id from Document_Generation_Request__c where Opportunity__c =:opp1.Id]){
                docgenReq = docgenReqObj;
            }
        	List<Document_Benefit_Plan__c> docBenefitPlan = [select id from Document_Benefit_Plan__c where Document_Generation_Request__c=:docgenReq.Id];
        
        	Document_Generation_Request__c dgr1 = new Document_Generation_Request__c();
            dgr1.Opportunity__c = opp1.id;
            dgr1.has_Custom_Plans__c = false;
            insert dgr1;
        
            Test.setCurrentPage(Page.HighRoads_DocGenRequest);
            System.runAs(User){
               HighRoads_DocGenRequest.insertDocGenRequests(updatedIds);
               HighRoads_DocGenRequest.insertDocGenRequestsOpp(oppIds);               
            }

        	Apexpages.standardcontroller sc = new Apexpages.standardcontroller(dgr1);
            HighRoads_DocGenRequest vfcont = new HighRoads_DocGenRequest(sc);
        	vfcont.exportFiles();
        
        Test.stopTest();
    }
}