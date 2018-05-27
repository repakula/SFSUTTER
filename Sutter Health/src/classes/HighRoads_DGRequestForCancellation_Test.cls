/* 
     Class Name: HighRoads_DGRequestForCancellation_Test 
     Author: IDC Offshore
     Date: 01-Dec-2016
     Description: Test class for HighRoads_DGRequestForCancellation_Test class.
VERSION    AUTHOR              DATE        DETAIL
1.0        Deloitte          19/04/2017    Improved Test Coverage
*/
@isTest
public class HighRoads_DGRequestForCancellation_Test {
    
    /*
     * Method Name : testCancellationSSO
     * Description : testmethod for sso Document Generation Request Cancellation
     * */
     
    private testMethod static void testCancellationSSO()
    {
       string pId;
       
       
       
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        
        List<Benefit_Plan_Data_Filters__c> bpdfList = HighRoads_TestDataUtility.insertBenefitDataFiltersCS();
        insert bpdfList;
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegList;
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        List<SHP_Benefit_Grid__c> benefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        
        insert benefitGrid;
        
        List<Benefit_Plan_Metadata__c> benefitPlanMetadata = [SELECT ID,Benefit_Grid__c,EOC__c ,SBC__c ,BCM__c ,
                                                              Ancillary_EOC__c ,Ancillary_SOB__c,Ancillary_GSA__c,
                                                              Version_Number__c,IsActivelyMarketed__c,Plan_Year__c,Market_Segment__c,
                                                              Plan_Related_to_Account__c,Name,Plan_Name__c,Plan_Status__c,
                                                              Deductible__c,Family_Deductible__c,Ind_Family_Deductible__c,
                                                              DOV__c,Inpatient__c,Emergency_Room__c,Medical_OR_Rider__c,    
                                                              IsCustom__c,IsHDHP__c,Office_Visit__c,Out_of_Pocket_Maximum__c,
                                                              Family_OOPM__c,Ind_Family_OOPM__c,Product_Family__c,
                                                              Outpatient__c,Product__c,RX_Tier_1__c,RX_Tier_2__c,RX_Tier_3__c,
                                                              RX_Tier_4__c,Rx_Deductible_Family__c,Rx_Deductible_Ind_Family__c,
                                                              Rx_Deductible_Individual__c,Specialist_Office_Visit__c,Benefit_Plan_ID__c,
                                                              Visit_Limit__c,Rider_Cost_Share__c,Product_Class__c,
                                                              Plan_Type__c,Product_Types__c FROM Benefit_Plan_Metadata__c];
        
        custom_Benefit_Plan__c cbp = new custom_Benefit_Plan__c();
        cbp.Name = 'HE02 - Custom - 2016';
        cbp.Medical_OR_Rider__c = 'Medical';
        cbp.Product_Class__c = 'Medical';
        cbp.Effective_Date__c = System.today();
        cbp.End_Date__c = system.today()+360;
        cbp.Market_Segment__c = 'Large Group';
        cbp.Plan_Type__c = 'Custom';
        cbp.Ancillary_EOC__c = false;
        cbp.Ancillary_GSA__c = false;
        cbp.Ancillary_SOB__c = false;
        cbp.EOC__c = true;
        cbp.BCM__c = true;
        cbp.SBC__c = true;
        cbp.IsCustom__c = true;
        cbp.Benefit_Plan_ID__c = 'HE02 - Custom';
        cbp.Plan_Status__c = 'Draft';
        cbp.Plan_Year__c = string.valueOf(system.today().year());
        cbp.Plan_Related_to_Account__c = acc.Id;
        cbp.Benefit_Grid__c = benefitGrid[0].Id;
        cbp.Remarks__c = 'test';
        insert cbp;
        
        custom_Benefit_Plan__c updateCBP = [select id,Plan_Status__c from custom_Benefit_Plan__c where id=:cbp.id];
        updateCBP.Plan_Status__c = 'Soft Approved';
        update updateCBP;
       
        
        Benefit_Plan_Metadata__c bpm = [select id,Name from Benefit_Plan_Metadata__c where Custom_Benefit_Plan_ID__c =:cbp.Id];
                
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        
        Benefit_Plan_Association__c medical = new Benefit_Plan_Association__c();
        medical.Name = benefitPlanMetadata[0].Name;
        medical.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medical.Opportunity__c = opp.Id;
        bpaList.add(medical);
        
        Benefit_Plan_Association__c cusmedical = new Benefit_Plan_Association__c();
        cusmedical.Name = bpm.Name;
        cusmedical.Benefit_Plan_Metadata__c = bpm.Id;
        cusmedical.Opportunity__c = opp.Id;
        bpaList.add(cusmedical);
        
        Benefit_Plan_Association__c rider1 = new Benefit_Plan_Association__c();
        rider1.Name = benefitPlanMetadata[0].Name;
        rider1.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        rider1.Raider_ID__c = benefitPlanMetadata[1].Id;
        rider1.Opportunity__c = opp.Id;
        bpaList.add(rider1);
        
        Insert bpaList;
        
        
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',opp.id);
        HighRoads_RateSelection rateSelecObj = new HighRoads_RateSelection();
        
        for(HighRoads_RateSelection.PlanRateTier planTier : rateSelecObj.planRateTierList){
            for(HighRoads_RateSelection.RateTiers rateTier : planTier.tierList){
                rateTier.tier1 = true;
                rateTier.tier2 = true;
                rateTier.tier3 = true;
                rateTier.tier4 = true;
                rateTier.tier5 = true;
            }
        }
            
        rateSelecObj.panel1Next();
        rateSelecObj.addGroup();
        rateSelecObj.other1 = 'OTH1';
        rateSelecObj.addGroup();
        rateSelecObj.other2 = 'OTH2';
        rateSelecObj.addGroup();
        rateSelecObj.other3 = 'OTH3';
        rateSelecObj.addGroup();
        rateSelecObj.other4 = 'OTH4';
        rateSelecObj.addGroup();
        rateSelecObj.other5 = 'OTH5';
        rateSelecObj.addGroup();
        rateSelecObj.other6 = 'OTH6';
        rateSelecObj.addGroup();
        rateSelecObj.other7 = 'OTH7';
        rateSelecObj.addGroup();
        rateSelecObj.other8 = 'OTH8';
        rateSelecObj.addGroup();
        rateSelecObj.other9 = 'OTH9';
        rateSelecObj.addGroup();
        rateSelecObj.other10 = 'OTH10';
        
        List<HighRoads_RateSelection.PlanRateTier> planRateTierList = rateSelecObj.planRateTierGroupList;
        List<HighRoads_RateSelection.PlanGroups> planGroups = planRateTierList[0].plangroupList;
        for(HighRoads_RateSelection.PlanGroups planGroup : planGroups){
            for(HighRoads_RateSelection.RateGroups rateGrpObj : planGroup.rateGrpList){
                rateGrpObj.active = true;
                rateGrpObj.earlyRetiree = true;
                rateGrpObj.other1 = true;
                rateGrpObj.other2 = true;
                rateGrpObj.other3 = true;
                rateGrpObj.other4 = true;
                rateGrpObj.other5 = true;
                rateGrpObj.other6 = true;
                rateGrpObj.other7 = true;
                rateGrpObj.other8 = true;
                rateGrpObj.other9 = true;
                rateGrpObj.other10 = true;
            }
        }
        rateSelecObj.panel2Next();
        for(HighRoads_RateSelection.PlanRateTier saveRateTable : rateSelecObj.PlanRateTierGroupandRateEntryList){
            for(HighRoads_RateSelection.PlanTierandRateEntry planTierRate : saveRateTable.planTierandRateEntryList){
                for(HighRoads_RateSelection.TierandRateEntry tierType : planTierRate.tierRateEntryList){
                    for(HighRoads_RateSelection.RateEntry rateEntry : tierType.rateEntryList){
                        if('Tier 1'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier1Composite = '120';
                        }
                        else if('Tier 2'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier2EE = '120';
                            rateEntry.tier2EF = '120';
                        }else if('Tier 3'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier3EE = '120';
                            rateEntry.tier3E1 = '120';
                            rateEntry.tier3E2 = '120';
                        }else if('Tier 4'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier4EE = '120';
                            rateEntry.tier4EC = '120';
                            rateEntry.tier4ES = '120';
                            rateEntry.tier4EF = '120';
                        }else if('Tier 5'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier5EE = '120';
                            rateEntry.tier5EC = '120';
                            rateEntry.tier5ES = '120';
                            rateEntry.tier5EF = '120';
                            rateEntry.tier5ECH = '120';
                        }
                    }
                }
            }
        }
        
        rateSelecObj.saveRates();
        HighRoads_RateSelection rateSelecObj1 = new HighRoads_RateSelection();

        Opportunity updateOpp = [select id,stagename from opportunity where id=:opp.Id];
        updateOpp.StageName = 'Closed Won';
        update updateOpp;
        
        Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        rfpObj.No_of_Quotes_Requested__c = 12;
        rfpObj.Strategy_Statement__c = 'Test';
        rfpObj.Special_Instuctions__c = 'Test';
        rfpObj.Tiered_Rates__c = '12';
        rfpObj.Reason_for_Market_Check__c = 'Test';
        Insert rfpObj;
        
        Proposal__c quote = new Proposal__c();
        quote.RFP_Form__c = rfpObj.Id;
        quote.Opportunity_ID__c = opp.Id;
        Insert quote;
        
        Attachment att = new Attachment();
        att.Name = 'Test Attachment';
        att.ParentId = quote.Id;
        att.Body = Blob.valueOf('test attachment body');
        Insert att;
        
        Sold_Sign_Off__c sso = new Sold_Sign_Off__c();
        sso.Quote__c = quote.Id;
        sso.Opportunity_ID__c = opp.Id;
        sso.SSO_RSO_Due_Date__c = system.today()+10;
        Insert sso;
        
        Attachment att1 = new Attachment();
        att1.Name = 'Test Attachment';
        att1.ParentId = sso.Id;
        att1.Body = Blob.valueOf('test attachment body');
        Insert att1;
        
        Test.startTest();
        
        Sold_Sign_Off__c updateSSO = [select id,stage__c from Sold_Sign_Off__c where id=:sso.Id];
        
        updateSSO.Stage__c = 'Submitted to Underwriting';
        update updateSSO;
        HighRoads_SoldSignOffTriggerHelper.isBeforeUpdate = true;
        updateSSO.Stage__c = 'Approved by Underwriting';
        update updateSSO;
        
        insert new Document_Generation_Request__c(  Opportunity__c =  updateOpp.id, Status__c = System.label.HR141_Draft, 
                                                    Request_Status__c = System.label.HR141_Draft, has_Custom_Plans__c = true, 
                                                    Expedite__c = false, sold_sign_off__c = updateSSO.Id);
                                                    
        Document_Generation_Request__c dgr = [select Id,OwnerId,Sold_Sign_Off__c,Opportunity__c,Request_Status__c,Status_Before_Cancellation__c
                                                    from Document_Generation_Request__c where sold_sign_off__c =:updateSSO.Id LIMIT 1];
        
        list<Profile> p = [SELECT Id FROM Profile WHERE Name IN ('SHP Benefit Plan Administration') limit 1];
        User u;
        if(!p.isEmpty())
        {
            u = new User(alias = 'al', email='test.user@sutter.com.dev', 
                          emailencodingkey='UTF-8', lastname='lname', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US', profileid = p.get(0).ID,
                          timezonesidkey='America/Los_Angeles', 
                          username='test.user@sutter.com.dev');
            insert u;
            system.runAs(u)
            {
                HighRoads_DGRequestForCancellation.cancelDocGenRequest(dgr.Id);
            }
        }
        
        dgr.OwnerId = UserInfo.getUserId();
        dgr.Request_Status__c = System.Label.HR221_RequestCancelled;
        dgr.Sold_Sign_Off__c = null;
        dgr.Request_Status__c = System.Label.HR221_RequestCancelled;
        update dgr;
        
        HighRoads_DGRequestForCancellation.cancelDocGenRequest(dgr.Id);

        system.runAs(u)
        {
            HighRoads_DGRequestForCancellation.cancelDocGenRequest(dgr.Id);
        }
        Test.stopTest();
        
    }
    
    
    /*
     * Method Name : testRequestCancellationOpp
     * Description : testmethod for Opportunity Document Generation Request Cancellation
     * */
     public static testMethod void testRequestCancellationOpp(){
        
        SHP_Benefit_Grid__c grid = new SHP_Benefit_Grid__c();
        grid.Benefit_Plan_ID__c = 'HE02';
        grid.Market_Segment__c = 'Large Group';
        grid.SHP_Benefit_Plan_Year__c = '2016';
        grid.Plan_Name__c = 'HE02-2016';
        insert grid;
        
       SHP_Benefit_Grid__c grid1 = new SHP_Benefit_Grid__c();
        grid1.Benefit_Plan_ID__c = 'XA02';
        grid1.Market_Segment__c = 'Large Group';
        grid1.SHP_Benefit_Plan_Year__c = '2016';
        insert grid1;
        
       SHP_Benefit_Grid__c grid3 = new SHP_Benefit_Grid__c();
        grid3.Benefit_Plan_ID__c = 'XA03';
        grid3.Market_Segment__c = 'Large Group';
        grid3.SHP_Benefit_Plan_Year__c = '2016';
        insert grid3;
        
       SHP_Benefit_Grid__c grid2 = new SHP_Benefit_Grid__c();
        grid2.Benefit_Plan_ID__c = 'ML02';
        grid2.Market_Segment__c = 'Large Group';
        grid2.SHP_Benefit_Plan_Year__c = '2016';
        insert grid2;
        
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
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
        
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
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
        
        Benefit_Plan_Metadata__c bpm4 = new Benefit_Plan_Metadata__c();
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
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
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
        
         
       Profile p = [SELECT Id FROM Profile WHERE Name IN ( 'SHP Sales')];
          
        User u = new User(alias = 'al', email='test.user@sutter.com.dev', 
                          emailencodingkey='UTF-8', lastname='lname', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US', profileid = p.Id,
                          timezonesidkey='America/Los_Angeles', 
                          username='test.user@sutter.com.dev');
        insert u; 
        
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg1 = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg1;   
        System.runAs(u){
       Account acc1 = new Account();
        acc1.Name = 'Test Account1';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
        acc1.NumberOfEmployees = 50;
        acc1.Industry = 'Hospitaity';
        acc1.Employer_Type__c = 'Small Mid-Market Group (51 - 100)';
        insert acc1;
        
       
       Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opp1';
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHP Sales Opportunity').getRecordTypeId();
        opp1.AccountId = acc1.id;
        opp1.type = 'New Business';
        opp1.CloseDate = Date.Today()+40;
        opp1.StageName = 'Pending AE';
        opp1.Renewed_Opportunity__c = false;
        insert opp1;

        Benefit_Plan_Association__c bpa3 = new Benefit_Plan_Association__c();
        bpa3.Benefit_Plan_Metadata__c = bpm.id;
        bpa3.Version_Number__c = 1;
        bpa3.Opportunity__c = opp1.id;
        insert bpa3;
        
       Benefit_Plan_Association__c bpa4 = new Benefit_Plan_Association__c();
        bpa4.Benefit_Plan_Metadata__c = bpm.id;
        bpa4.Raider_ID__c = bpm1.id;
        bpa4.Version_Number__c = 1;
        bpa4.Opportunity__c = opp1.id;
        insert bpa4;
        
      Benefit_Plan_Association__c  bpa6 = new Benefit_Plan_Association__c();
        bpa6.Benefit_Plan_Metadata__c = bpm.id;
        bpa6.Raider_ID__c = bpm4.id;
        bpa6.Version_Number__c = 1;
        bpa6.Opportunity__c = opp1.id;
        insert bpa6;
        
      Benefit_Plan_Association__c  bpa5 = new Benefit_Plan_Association__c();
        bpa5.Benefit_Plan_Metadata__c = bpm2.id;
        bpa5.Version_Number__c = 1;
        bpa5.Opportunity__c = opp1.id;
        insert bpa5;
        
        Test.startTest();
          
            opp1.StageName = 'Closed Won';
            HighRoads_DocGenRequest.isOpportunityAfterUpdate = true;
            update opp1;
            
            //Document_Generation_Request__c docgenReq = [select id from Document_Generation_Request__c where Opportunity__c =:opp1.Id];
            Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
            rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
            rfpObj.Opportunity__c = opp1.Id;
            rfpObj.No_of_Quotes_Requested__c = 12;
            rfpObj.Strategy_Statement__c = 'Test';
            rfpObj.Special_Instuctions__c = 'Test';
            rfpObj.Tiered_Rates__c = '12';
            rfpObj.Reason_for_Market_Check__c = 'Test';
            Insert rfpObj;
            
            Proposal__c quote = new Proposal__c();
            quote.RFP_Form__c = rfpObj.Id;
            quote.Opportunity_ID__c = opp1.Id;
            Insert quote;
        
            Sold_Sign_Off__c sso = new Sold_Sign_Off__c();
            sso.Quote__c = quote.Id;
            sso.Opportunity_ID__c = opp1.Id;
            sso.SSO_RSO_Due_Date__c = system.today()+10;
            Insert sso;
        
          Document_Generation_Request__c dgr1 = new Document_Generation_Request__c();
            dgr1.Opportunity__c = opp1.id;
            dgr1.has_Custom_Plans__c = false;
            dgr1.Sold_Sign_Off__c  = sso.ID;
            insert dgr1;
          HighRoads_DGRequestForCancellation.cancelDocGenRequest(dgr1.Id); 
            
            dgr1.Sold_Sign_Off__c = null;
            dgr1.OwnerId = UserInfo.getUserId();
            dgr1.Request_Status__c = System.Label.HR221_RequestCancelled;
            update dgr1;
            
            HighRoads_DGRequestForCancellation.cancelDocGenRequest(dgr1.Id); 
            
            Test.stopTest();
            }
    }
}