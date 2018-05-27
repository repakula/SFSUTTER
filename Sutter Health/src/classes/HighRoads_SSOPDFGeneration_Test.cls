@isTest
private class HighRoads_SSOPDFGeneration_Test {
    private testMethod static void ssoPDFGenerationWithAllRates(){
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
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sso);
        HighRoads_SSOPDFGeneration ssoObj = new HighRoads_SSOPDFGeneration(sc);
        
        PageReference pageRef = Page.HighRoads_SSOPDFGeneration;
        pageRef.getParameters().put('id', String.valueOf(sso.Id));
        Test.setCurrentPage(pageRef);
        
        ssoObj.generatePDF();
        Test.stopTest();
    }
    
    private testMethod static void ssoPDFGenerationWithoutRates(){
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
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sso);
        HighRoads_SSOPDFGeneration ssoObj = new HighRoads_SSOPDFGeneration(sc);
        
        PageReference pageRef = Page.HighRoads_SSOPDFGeneration;
        pageRef.getParameters().put('id', String.valueOf(sso.Id));
        Test.setCurrentPage(pageRef);
        
        ssoObj.generatePDF();
        
        Test.stopTest();
    }
}