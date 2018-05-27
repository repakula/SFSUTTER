/* 
     Class Name: HighRoads_AutoCreateRecords_Test 
     Author: IDC Offshore
     Date: 06-Dec-2016
     Description: Test class for HighRoads_AutoCreateRecordsOnApproval
*/
@isTest
private class HighRoads_AutoCreateRecords_Test {
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Verify the Proposal creation on RFP Approval
    * @return void        
    **/
    private testMethod static void createProposalOnRFPApproval(){
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        String accountId = acc.Id;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        opp.StageName = 'Closed Won';
        opp.RFP_Due_Date__c = System.today()+30;
        opp.Additional_Buy_Ups__c = 'Slice';
        opp.Plan_Effective_Date__c = System.today();
        opp.NTE_Offered__c = 16;
        opp.of_Subscribers__c = 15;
        Insert opp;
        Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        rfpObj.No_of_Quotes_Requested__c = 12;
        rfpObj.Strategy_Statement__c = 'Test';
        rfpObj.Special_Instuctions__c = 'Test';
        rfpObj.Tiered_Rates__c = '12';
        rfpObj.Reason_for_Market_Check__c = 'Test';
        
        Insert rfpObj;
        
        Incumbent_Carrier__c updatedRFP = [select id,stage__c from Incumbent_Carrier__c where id=:rfpObj.Id];
        updatedRFP.Stage__c = 'Submitted to Underwriting';
        update updatedRFP;
        RFP_IncumbentCarrierTriggerHelper.isAfterUpdate = true;
        updatedRFP.Stage__c = 'Approved by Underwriting';
        update updatedRFP;
    }
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Verify the Sold Sign Off creation on Proposal Approval
    * @return void        
    **/
    private testMethod static void createSSOOnQuoteApproval(){
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        String accountId = acc.Id;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        opp.StageName = 'Closed Won';
        opp.RFP_Due_Date__c = System.today()+30;
        opp.Additional_Buy_Ups__c = 'Slice';
        opp.Plan_Effective_Date__c = System.today();
        opp.NTE_Offered__c = 16;
        opp.of_Subscribers__c = 15;
        Insert opp;
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
        Proposal__c updateQuote = [select id,stage__c from Proposal__c where id=:quote.Id];
        updateQuote.Stage__c = 'Submitted to Sales';
        update updateQuote;
        HighRoads_ProposalTriggerHelper.isBeforeUpdate = true;
        updateQuote.Stage__c = 'Approved by Sales';
        update updateQuote;
    }
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Verify the Sold Case Notification creation on Sold Sign Off Approval
    * @return void        
    **/
    private testMethod static void createSCNonSSOApproval(){
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
        
        Test.startTest();
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
        Test.stopTest();
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
        
        
        Sold_Sign_Off__c updateSSO = [select id,stage__c from Sold_Sign_Off__c where id=:sso.Id];
        
        updateSSO.Stage__c = 'Submitted to Underwriting';
        update updateSSO;
        HighRoads_SoldSignOffTriggerHelper.isBeforeUpdate = true;
        updateSSO.Stage__c = 'Approved by Underwriting';
        update updateSSO;
        
    }
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Verify the the metadata record update
    * @return void        
    **/
    private testMethod static void metadatarecordUpdate(){
         Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
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
        
        HighRoads_CreateBenefitPlanHelper.isAfterUpdate = true;
        updateCBP.Cost_Share__c = '123';
        update updateCBP;
    }
}