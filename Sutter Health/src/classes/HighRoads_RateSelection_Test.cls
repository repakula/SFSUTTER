/**********************************************************************
Class Name   : HighRoads_RateSelection_Test
Date Created : 07-12-2016
Created By   : IDC Offshore
Description  : Test class
**********************************************************************/
@isTest
private class HighRoads_RateSelection_Test {
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Rate Insertion at opportunity level
    * @return void        
    **/
    private testMethod static void  rateSelectionOpportunity(){
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
        
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        Benefit_Plan_Association__c medical = new Benefit_Plan_Association__c();
        medical.Name = benefitPlanMetadata[0].Name;
        medical.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medical.Opportunity__c = opp.Id;
        bpaList.add(medical);
        
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
        List<HighRoads_RateSelection.RateTiers> rateTierObjList = rateSelecObj.planRateTierList[0].tierList;
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList){
            rateTier.tier1 = true;
            rateTier.tier2 = true;
            rateTier.tier3 = true;
            rateTier.tier4 = true;
            rateTier.tier5 = true;
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
    }
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Rate Insertion at RFP level
    * @return void        
    **/
    private testMethod static void  rateSelectionRFP(){
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
        
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        Benefit_Plan_Association__c medical = new Benefit_Plan_Association__c();
        medical.Name = benefitPlanMetadata[0].Name;
        medical.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medical.Opportunity__c = opp.Id;
        bpaList.add(medical);
        
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
        List<HighRoads_RateSelection.RateTiers> rateTierObjList = rateSelecObj.planRateTierList[0].tierList;
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList){
            rateTier.tier1 = true;
            rateTier.tier2 = true;
            rateTier.tier3 = true;
            rateTier.tier4 = true;
            rateTier.tier5 = true;
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
        rateSelecObj.other8= 'OTH8';
        rateSelecObj.addGroup();
        rateSelecObj.other9 = 'OTH9';
        rateSelecObj.addGroup();
        rateSelecObj.other10 = 'OTH10';
        rateSelecObj.cancel();
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
        Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',rfpObj.id);
        HighRoads_RateSelection rateSelecObj1 = new HighRoads_RateSelection();
        Benefit_Plan_Association__c rider2 = new Benefit_Plan_Association__c();
        rider2.Name = benefitPlanMetadata[0].Name;
        rider2.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        rider2.Raider_ID__c = benefitPlanMetadata[3].Id;
        rider2.RFP_Form__c = rfpObj.Id;
        insert rider2;
        
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',rfpObj.id);
        HighRoads_RateSelection rateSelecObj2 = new HighRoads_RateSelection();
        Test.stopTest();

    }
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Rate Insertion at Proposal(Quote) level
    * @return void        
    **/
    private testMethod static void  rateSelectionQuote(){
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
        
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        Benefit_Plan_Association__c medical = new Benefit_Plan_Association__c();
        medical.Name = benefitPlanMetadata[0].Name;
        medical.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medical.Opportunity__c = opp.Id;
        bpaList.add(medical);
        
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
        List<HighRoads_RateSelection.RateTiers> rateTierObjList = rateSelecObj.planRateTierList[0].tierList;
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList){
            rateTier.tier1 = true;
            rateTier.tier2 = true;
            rateTier.tier3 = true;
            rateTier.tier4 = true;
            rateTier.tier5 = true;
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
        rateSelecObj.other8= 'OTH8';
        rateSelecObj.addGroup();
        rateSelecObj.other9 = 'OTH9';
        rateSelecObj.addGroup();
        rateSelecObj.other10 = 'OTH10';
        rateSelecObj.cancel();
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

        Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        
        Proposal__c quote = new Proposal__c();
        quote.RFP_Form__c = rfpObj.Id;
        quote.Opportunity_ID__c = opp.Id;
        Insert quote;
        
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',quote.id);
        HighRoads_RateSelection rateSelecObj1 = new HighRoads_RateSelection();
        Benefit_Plan_Association__c rider2 = new Benefit_Plan_Association__c();
        rider2.Name = benefitPlanMetadata[0].Name;
        rider2.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        rider2.Raider_ID__c = benefitPlanMetadata[3].Id;
        rider2.Proposal__c = quote.Id;
        insert rider2;
        
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',quote.id);
        HighRoads_RateSelection rateSelecObj2 = new HighRoads_RateSelection();
        
        Test.stopTest();
    }
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Rate Insertion at SoldSignOff level
    * @return void        
    **/
    private testMethod static void  rateSelectionSoldSignOff(){
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
        
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        Benefit_Plan_Association__c medical = new Benefit_Plan_Association__c();
        medical.Name = benefitPlanMetadata[0].Name;
        medical.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medical.Opportunity__c = opp.Id;
        bpaList.add(medical);
        
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
        List<HighRoads_RateSelection.RateTiers> rateTierObjList = rateSelecObj.planRateTierList[0].tierList;
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList){
            rateTier.tier1 = true;
            rateTier.tier2 = true;
            rateTier.tier3 = true;
            rateTier.tier4 = true;
            rateTier.tier5 = true;
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
        rateSelecObj.other8= 'OTH8';
        rateSelecObj.addGroup();
        rateSelecObj.other9 = 'OTH9';
        rateSelecObj.addGroup();
        rateSelecObj.other10 = 'OTH10';
        rateSelecObj.cancel();
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
		Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        
        Proposal__c quote = new Proposal__c();
        quote.RFP_Form__c = rfpObj.Id;
        quote.Opportunity_ID__c = opp.Id;
        Insert quote;
        
        Sold_Sign_Off__c sso = new Sold_Sign_Off__c();
        sso.Quote__c = quote.Id;
        sso.Opportunity_ID__c = opp.Id;
        Insert sso;
        
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',sso.id);
        HighRoads_RateSelection rateSelecObj1 = new HighRoads_RateSelection();
        Benefit_Plan_Association__c rider2 = new Benefit_Plan_Association__c();
        rider2.Name = benefitPlanMetadata[0].Name;
        rider2.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        rider2.Raider_ID__c = benefitPlanMetadata[3].Id;
        rider2.Sold_Sign_Off__c = sso.Id;
        insert rider2;
        
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',sso.id);
        HighRoads_RateSelection rateSelecObj2 = new HighRoads_RateSelection();
        Test.stopTest();
    }
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Rate Insertion at SoldCaseNotification level when the Sold Case Notification creation from Sold Sign Off
    * @return void        
    **/
    private testMethod static void  rateSelectionSCNFromSoldSignOff(){
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
        
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        Benefit_Plan_Association__c medical = new Benefit_Plan_Association__c();
        medical.Name = benefitPlanMetadata[0].Name;
        medical.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medical.Opportunity__c = opp.Id;
        bpaList.add(medical);
        
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
        List<HighRoads_RateSelection.RateTiers> rateTierObjList = rateSelecObj.planRateTierList[0].tierList;
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList){
            rateTier.tier1 = true;
            rateTier.tier2 = true;
            rateTier.tier3 = true;
            rateTier.tier4 = true;
            rateTier.tier5 = true;
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
        rateSelecObj.other8= 'OTH8';
        rateSelecObj.addGroup();
        rateSelecObj.other9 = 'OTH9';
        rateSelecObj.addGroup();
        rateSelecObj.other10 = 'OTH10';
        rateSelecObj.cancel();
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
                            rateEntry.tier1Composite = '130';
                        }
                        else if('Tier 2'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier2EE = '130';
                            rateEntry.tier2EF = '130';
                        }else if('Tier 3'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier3EE = '130';
                            rateEntry.tier3E1 = '130';
                            rateEntry.tier3E2 = '130';
                        }else if('Tier 4'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier4EE = '130';
                            rateEntry.tier4EC = '130';
                            rateEntry.tier4ES = '130';
                            rateEntry.tier4EF = '130';
                        }else if('Tier 5'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier5EE = '130';
                            rateEntry.tier5EC = '130';
                            rateEntry.tier5ES = '130';
                            rateEntry.tier5EF = '130';
                            rateEntry.tier5ECH = '130';
                        }
                    }
                }
            }
        }
        
        rateSelecObj.saveRates();
		Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        
        Proposal__c quote = new Proposal__c();
        quote.RFP_Form__c = rfpObj.Id;
        quote.Opportunity_ID__c = opp.Id;
        Insert quote;
        
        Sold_Sign_Off__c sso = new Sold_Sign_Off__c();
        sso.Quote__c = quote.Id;
        sso.Opportunity_ID__c = opp.Id;
        Insert sso;
		
		Employer_Group_Data__c scn = new Employer_Group_Data__c();
        scn.Sold_Sign_Off__c = sso.Id;
        scn.Opportunity__c = opp.Id;
        Insert scn;        
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',scn.id);
        HighRoads_RateSelection rateSelecObj1 = new HighRoads_RateSelection();
        Benefit_Plan_Association__c rider2 = new Benefit_Plan_Association__c();
        rider2.Name = benefitPlanMetadata[0].Name;
        rider2.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        rider2.Raider_ID__c = benefitPlanMetadata[3].Id;
        rider2.Sold_Case_Notification__c = scn.Id;
        insert rider2;
        
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',scn.id);
        HighRoads_RateSelection rateSelecObj2 = new HighRoads_RateSelection();
        Test.stopTest();
    }
     /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Rate Insertion at SoldCaseNotification level when the Sold Case Notification creation from Opportunity
    * @return void        
    **/
    private testMethod static void  rateSelectionSCNFromOpp(){
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
        
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        acc.Employer_Type__c = 'Small Group (1 - 50)';
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        Benefit_Plan_Association__c medical = new Benefit_Plan_Association__c();
        medical.Name = benefitPlanMetadata[0].Name;
        medical.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medical.Opportunity__c = opp.Id;
        bpaList.add(medical);
        
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
        List<HighRoads_RateSelection.RateTiers> rateTierObjList = rateSelecObj.planRateTierList[0].tierList;
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList){
            rateTier.tier1 = true;
            rateTier.tier2 = true;
            rateTier.tier3 = true;
            rateTier.tier4 = true;
            rateTier.tier5 = true;
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
        rateSelecObj.other8= 'OTH8';
        rateSelecObj.addGroup();
        rateSelecObj.other9 = 'OTH9';
        rateSelecObj.addGroup();
        rateSelecObj.other10 = 'OTH10';
        rateSelecObj.cancel();
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
        HighRoads_OpporutnityHelper.isOpportunityAfterUpdate = true;
        opp.StageName = 'Closed Won';
        update opp;
        Employer_Group_Data__c scn= [select id from Employer_Group_Data__c where opportunity__c = :opp.Id];
        ApexPages.currentPage().getParameters().put('recordId',scn.id);
        HighRoads_RateSelection rateSelecObj1 = new HighRoads_RateSelection();
        Benefit_Plan_Association__c rider2 = new Benefit_Plan_Association__c();
        rider2.Name = benefitPlanMetadata[0].Name;
        rider2.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        rider2.Raider_ID__c = benefitPlanMetadata[3].Id;
        rider2.Sold_Case_Notification__c = scn.Id;
        insert rider2;
        
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',scn.id);
        HighRoads_RateSelection rateSelecObj2 = new HighRoads_RateSelection();
        Test.stopTest();
    }
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Checking the opportunity without plan and clicked on rates
    * @return void        
    **/
    private testMethod static void  withoutplanrateSelectionOpportunity(){
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
        
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        
        Test.startTest();
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',opp.id);
        HighRoads_RateSelection rateSelecObj = new HighRoads_RateSelection();
        
        Test.stopTest();
    }
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Checking if tiers are un selected, deleting the old rates
    * @return void        
    **/
    private testMethod static void  changeTiersinOpportunity(){
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
        
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        Benefit_Plan_Association__c medical = new Benefit_Plan_Association__c();
        medical.Name = benefitPlanMetadata[0].Name;
        medical.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medical.Opportunity__c = opp.Id;
        bpaList.add(medical);
        
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
        List<HighRoads_RateSelection.RateTiers> rateTierObjList = rateSelecObj.planRateTierList[0].tierList;
        
        rateSelecObj.panel1Next();
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList){
            rateTier.tier1 = true;
            
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
        List<HighRoads_RateSelection.RateTiers> rateTierObjList1 = rateSelecObj1.planRateTierList[0].tierList;
        try{
            rateSelecObj1.panel1Next();
        }catch(Exception e){}
        
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList1){
            rateTier.tier2 = true;
            rateTier.tier3 = true;
            rateTier.tier4 = true;
            rateTier.tier5 = true;
            rateTier.tier1 = false;
        }
        rateSelecObj1.panel1Next();
        
        List<HighRoads_RateSelection.PlanRateTier> planRateTierList1 = rateSelecObj1.planRateTierGroupList;
        List<HighRoads_RateSelection.PlanGroups> planGroups1 = planRateTierList1[0].plangroupList;
        for(HighRoads_RateSelection.PlanGroups planGroup : planGroups1){
            for(HighRoads_RateSelection.RateGroups rateGrpObj : planGroup.rateGrpList){
                rateGrpObj.active = true;
                rateGrpObj.earlyRetiree = false;
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
        rateSelecObj1.panel2Next();
        for(HighRoads_RateSelection.PlanRateTier saveRateTable : rateSelecObj1.PlanRateTierGroupandRateEntryList){
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
        rateSelecObj1.saveRates();
        HighRoads_RateSelection rateSelecObj2 = new HighRoads_RateSelection();
        List<HighRoads_RateSelection.RateTiers> rateTierObjList2 = rateSelecObj2.planRateTierList[0].tierList;
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList2){
            rateTier.tier2 = false;
            rateTier.tier3 = false;
            rateTier.tier4 = false;
            rateTier.tier5 = false;
            rateTier.tier1 = true;
        }
        rateSelecObj2.panel1Next();
        rateSelecObj2.panel2previous();
        rateSelecObj2.panel1Next();
        List<HighRoads_RateSelection.PlanRateTier> planRateTierList2 = rateSelecObj2.planRateTierGroupList;
        List<HighRoads_RateSelection.PlanGroups> planGroups2 = planRateTierList2[0].plangroupList;
        try{
            for(HighRoads_RateSelection.PlanGroups planGroup : planGroups2){
            for(HighRoads_RateSelection.RateGroups rateGrpObj : planGroup.rateGrpList){
                rateGrpObj.active = false;
                rateGrpObj.earlyRetiree = false;
                rateGrpObj.other1 = false;
                rateGrpObj.other2 = false;
                rateGrpObj.other3 = false;
                rateGrpObj.other4 = false;
                rateGrpObj.other5 = false;
                rateGrpObj.other6 = false;
                rateGrpObj.other7 = false;
                rateGrpObj.other8 = false;
                rateGrpObj.other9 = false;
                rateGrpObj.other10 = false;
            }
        }
         	rateSelecObj2.panel2Next();
        }catch(Exception e){}
        for(HighRoads_RateSelection.PlanGroups planGroup : planGroups2){
            for(HighRoads_RateSelection.RateGroups rateGrpObj : planGroup.rateGrpList){
                rateGrpObj.active = true;
                rateGrpObj.earlyRetiree = false;
                rateGrpObj.other1 = false;
                rateGrpObj.other2 = false;
                rateGrpObj.other3 = false;
                rateGrpObj.other4 = false;
                rateGrpObj.other5 = false;
                rateGrpObj.other6 = false;
                rateGrpObj.other7 = false;
                rateGrpObj.other8 = false;
                rateGrpObj.other9 = false;
                rateGrpObj.other10 = false;
            }
        }
        rateSelecObj2.panel2Next();
        rateSelecObj2.panel3previous();
        rateSelecObj2.panel2Next();
        for(HighRoads_RateSelection.PlanRateTier saveRateTable : rateSelecObj2.PlanRateTierGroupandRateEntryList){
            for(HighRoads_RateSelection.PlanTierandRateEntry planTierRate : saveRateTable.planTierandRateEntryList){
                for(HighRoads_RateSelection.TierandRateEntry tierType : planTierRate.tierRateEntryList){
                    for(HighRoads_RateSelection.RateEntry rateEntry : tierType.rateEntryList){
                        if('Tier 1'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier1Composite = '120';
                        }
                        
                    }
                }
            }
        }
        Test.stopTest();
    }
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Test method for changing the rates at RFP level.
    * @return void        
    **/
    private testMethod static void  changeRatesInRFP(){
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
        
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        Benefit_Plan_Association__c medical = new Benefit_Plan_Association__c();
        medical.Name = benefitPlanMetadata[0].Name;
        medical.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medical.Opportunity__c = opp.Id;
        bpaList.add(medical);
        
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
        List<HighRoads_RateSelection.RateTiers> rateTierObjList = rateSelecObj.planRateTierList[0].tierList;
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList){
            rateTier.tier1 = true;
            rateTier.tier2 = true;
            rateTier.tier3 = true;
            rateTier.tier4 = true;
            rateTier.tier5 = true;
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
        rateSelecObj.other8= 'OTH8';
        rateSelecObj.addGroup();
        rateSelecObj.other9 = 'OTH9';
        rateSelecObj.addGroup();
        rateSelecObj.other10 = 'OTH10';
        rateSelecObj.cancel();
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
        Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',rfpObj.id);
        HighRoads_RateSelection rateSelecObj1 = new HighRoads_RateSelection();
        List<HighRoads_RateSelection.RateTiers> rateTierObjList1 = rateSelecObj1.planRateTierList[0].tierList;
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList1){
            rateTier.tier1 = true;
            rateTier.tier2 = true;
            rateTier.tier3 = true;
            rateTier.tier4 = true;
            rateTier.tier5 = true;
        }
        rateSelecObj1.panel1Next();
        rateSelecObj1.addGroup();
        rateSelecObj1.other1 = 'OTH1';
        rateSelecObj1.addGroup();
        rateSelecObj1.other2 = 'OTH2';
        rateSelecObj1.addGroup();
        rateSelecObj1.other3 = 'OTH3';
        rateSelecObj1.addGroup();
        rateSelecObj1.other4 = 'OTH4';
        rateSelecObj1.addGroup();
        rateSelecObj1.other5 = 'OTH5';
        rateSelecObj1.addGroup();
        rateSelecObj1.other6 = 'OTH6';
        rateSelecObj1.addGroup();
        rateSelecObj1.other7 = 'OTH7';
        rateSelecObj1.addGroup();
        rateSelecObj1.other8= 'OTH8';
        rateSelecObj1.addGroup();
        rateSelecObj1.other9 = 'OTH9';
        rateSelecObj1.addGroup();
        rateSelecObj1.other10 = 'OTH10';
        rateSelecObj1.cancel();
        List<HighRoads_RateSelection.PlanRateTier> planRateTierList1 = rateSelecObj1.planRateTierGroupList;
        List<HighRoads_RateSelection.PlanGroups> planGroups1 = planRateTierList1[0].plangroupList;
        for(HighRoads_RateSelection.PlanGroups planGroup : planGroups1){
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
        rateSelecObj1.panel2Next();
        for(HighRoads_RateSelection.PlanRateTier saveRateTable : rateSelecObj1.PlanRateTierGroupandRateEntryList){
            for(HighRoads_RateSelection.PlanTierandRateEntry planTierRate : saveRateTable.planTierandRateEntryList){
                for(HighRoads_RateSelection.TierandRateEntry tierType : planTierRate.tierRateEntryList){
                    for(HighRoads_RateSelection.RateEntry rateEntry : tierType.rateEntryList){
                        if('Tier 1'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier1Composite = '130';
                        }
                        else if('Tier 2'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier2EE = '130';
                            rateEntry.tier2EF = '130';
                        }else if('Tier 3'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier3EE = '130';
                            rateEntry.tier3E1 = '130';
                            rateEntry.tier3E2 = '130';
                        }else if('Tier 4'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier4EE = '130';
                            rateEntry.tier4EC = '130';
                            rateEntry.tier4ES = '130';
                            rateEntry.tier4EF = '130';
                        }else if('Tier 5'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier5EE = '130';
                            rateEntry.tier5EC = '130';
                            rateEntry.tier5ES = '130';
                            rateEntry.tier5EF = '130';
                            rateEntry.tier5ECH = '130';
                        }
                    }
                }
            }
        }
        
        rateSelecObj1.saveRates();
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',rfpObj.id);
        HighRoads_RateSelection rateSelecObj2 = new HighRoads_RateSelection();
        Test.stopTest();

    }
}