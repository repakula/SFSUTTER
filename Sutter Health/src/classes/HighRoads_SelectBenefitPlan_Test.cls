/**********************************************************************
Class Name   : HighRoads_SelectBenefitPlan_Test
Date Created : 07-12-2016
Created By   : IDC Offshore
Description  : Test class
Version          Name                    Date                  Details
2.0        Deloitte Offshore          16-03-2017      Increased the test coverage
**********************************************************************/
@isTest
public class HighRoads_SelectBenefitPlan_Test {
    
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : retrieve existing benefit plans and adding more plans at opportunity level
    * @return void        
    **/
    private testMethod static void  retrieveExistingandAddBenefitPlanOpportunity(){
        /* Inserting the benefit plan data filter custom setting */
        List<Benefit_Plan_Data_Filters__c> bpdfList = HighRoads_TestDataUtility.insertBenefitDataFiltersCS();
        insert bpdfList;
        
        /* Inserting the market segment mapping custom setting */
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegList;
        
        /* loading the grid to metadata mapping custom setting from static resource */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        
        /*Inserting the benefit grid data */
        List<SHP_Benefit_Grid__c> benefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        insert benefitGrid;
        
        /*verifying the grid data successfully inserted or not */
        System.assertEquals(4, benefitGrid.size());
        
        /* Fetching benefit plan metadata from Benenefit Plan Metadata object */
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
        
        /*verifying the equal no.of metadata records have been created */
        System.assertEquals(benefitGrid.size(), benefitPlanMetadata.size());
        
        /*Inserting SHP Sales Employer Account */
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        /*Verifying the account has been created successfully or not */
        System.assertNotEquals(acc.Id, NULL);
        
        /*inserting the SHP Sales Opportunity */
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        /*Verifying the opportunity inserted successfully */
        System.assertNotEquals(opp.Id, NULL);

        /* Inserting the Metadata */
        List<Benefit_Plan_Metadata__c> bpmList = new List<Benefit_Plan_Metadata__c>();
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Ancillary_EOC__c = false;
        bpm.Ancillary_GSA__c = false;
        bpm.Ancillary_SOB__c = false;
        bpm.EOC__c = true;
        bpm.BCM__c = true;
        bpm.SBC__c = true;
        bpm.Benefit_Plan_ID__c = 'HE02';
        bpm.Plan_Status__c = 'Available for Sale - Approved';
        bpm.Plan_Year__c = '2016';
        bpmList.add(bpm);
        
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02 - 2016';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = Date.parse('1/1/2016');
        bpm1.End_Date__c = Date.parse('12/31/2016');
        bpm1.Market_Segment__c = 'Large Group';
        bpm1.Plan_Type__c = 'Standard';
        bpm1.Ancillary_EOC__c = true;
        bpm1.Ancillary_GSA__c = true;
        bpm1.Ancillary_SOB__c = true;
        bpm1.EOC__c = true;
        bpm1.BCM__c = true;
        bpm1.SBC__c = true;
        bpm1.Benefit_Plan_ID__c = 'XA02';
        bpm1.Plan_Status__c = 'Available for Sale - Approved';
        bpm1.Plan_Year__c = '2016';
        bpmList.add(bpm1);
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Effective_Date__c = Date.parse('1/1/2016');
        bpm2.End_Date__c = Date.parse('12/31/2016');
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Standard';
        bpm2.Ancillary_EOC__c = true;
        bpm2.Ancillary_GSA__c = true;
        bpm2.Ancillary_SOB__c = true;
        bpm2.EOC__c = false;
        bpm2.BCM__c = false;
        bpm2.SBC__c = false;
        bpm2.Benefit_Plan_ID__c = 'ML02';
        bpm2.Plan_Status__c = 'Available for Sale - Approved';
        bpm2.Plan_Year__c = '2016';
        bpmList.add(bpm2);
        
        Benefit_Plan_Metadata__c bpm3 = new Benefit_Plan_Metadata__c();
        bpm3.Name = 'XA16 - 2016';
        bpm3.Medical_OR_Rider__c = 'Rider';
        bpm3.Product_Class__c = 'Acupuncture and Chiro';
        bpm3.Effective_Date__c = Date.parse('1/1/2016');
        bpm3.End_Date__c = Date.parse('12/31/2016');
        bpm3.Market_Segment__c = 'Large Group';
        bpm3.Plan_Type__c = 'Standard';
        bpm3.Ancillary_EOC__c = true;
        bpm3.Ancillary_GSA__c = true;
        bpm3.Ancillary_SOB__c = true;
        bpm3.EOC__c = true;
        bpm3.BCM__c = true;
        bpm3.SBC__c = true;
        bpm3.Benefit_Plan_ID__c = 'XA16';
        bpm3.Plan_Status__c = 'Available for Sale - Approved';
        bpm3.Plan_Year__c = '2016';
        bpmList.add(bpm3);
        
        Benefit_Plan_Metadata__c bpm4 = new Benefit_Plan_Metadata__c();
        bpm4.Name = 'XA17 - 2016';
        bpm4.Medical_OR_Rider__c = 'Rider';
        bpm4.Product_Class__c = 'Acupuncture and Chiro';
        bpm4.Effective_Date__c = Date.parse('1/1/2016');
        bpm4.End_Date__c = Date.parse('12/31/2016');
        bpm4.Market_Segment__c = 'Large Group';
        bpm4.Plan_Type__c = 'Standard';
        bpm4.Ancillary_EOC__c = true;
        bpm4.Ancillary_GSA__c = true;
        bpm4.Ancillary_SOB__c = true;
        bpm4.EOC__c = true;
        bpm4.BCM__c = true;
        bpm4.SBC__c = true;
        bpm4.Benefit_Plan_ID__c = 'XA17';
        bpm4.Plan_Status__c = 'Available for Sale - Approved';
        bpm4.Plan_Year__c = '2016';
        bpmList.add(bpm4);
        
        Benefit_Plan_Metadata__c bpm5 = new Benefit_Plan_Metadata__c();
        bpm5.Name = 'AA01 - 2016';
        bpm5.Medical_OR_Rider__c = 'Rider';
        bpm5.Product_Class__c = 'Acupuncture and Chiro';
        bpm5.Effective_Date__c = Date.parse('1/1/2016');
        bpm5.End_Date__c = Date.parse('12/31/2016');
        bpm5.Market_Segment__c = 'Large Group';
        bpm5.Plan_Type__c = 'Standard';
        bpm5.Ancillary_EOC__c = true;
        bpm5.Ancillary_GSA__c = true;
        bpm5.Ancillary_SOB__c = true;
        bpm5.EOC__c = true;
        bpm5.BCM__c = true;
        bpm5.SBC__c = true;
        bpm5.Benefit_Plan_ID__c = 'AA01';
        bpm5.Plan_Status__c = 'Available for Sale - Approved';
        bpm5.Plan_Year__c = '2016';
        bpmList.add(bpm5);
        
        Insert bpmList;
        
        /*Inserting the Benefit Plan Association for Opportunity */
        /* Inserting the benefit plan association records */
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Name = bpmList[0].Name;
        bpa.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa.Opportunity__c = opp.Id;
        bpaList.add(bpa);
        
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Name = bpmList[0].Name;
        bpa1.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa1.Raider_ID__c = bpmList[1].Id;
        bpa1.Opportunity__c = opp.Id;
        bpaList.add(bpa1);
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Name = bpmList[0].Name;
        bpa2.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa2.Raider_ID__c = bpmList[3].Id;
        bpa2.Opportunity__c = opp.Id;
        bpaList.add(bpa2);
        
        Benefit_Plan_Association__c bpa3 = new Benefit_Plan_Association__c();
        bpa3.Name = bpmList[2].Name;
        bpa3.Benefit_Plan_Metadata__c = bpmList[2].Id;
        bpa3.Opportunity__c = opp.Id;
        bpaList.add(bpa3);
        
        Insert bpaList;
        
        Test.startTest();
        /* Opening the Edit Plan Selection Page */
        Test.setCurrentPage(Page.HighRoads_SelectBenefitPlan);
        /* Setting Page Parameters */
        ApexPages.currentPage().getParameters().put(System.Label.HR44_OppId, opp.id);
        ApexPages.currentPage().getParameters().put(HighRoads_Constants.ACCOUNTID, opp.accountid);
        ApexPages.currentPage().getParameters().put(HighRoads_Constants.EMPLOYER_TYPE, opp.Employer_Type__c);
        HighRoads_SelectBenefitPlan selectBenefitPlanObj = new HighRoads_SelectBenefitPlan();
        
        //  Fills the list from test class
        selectBenefitPlanObj.retrievePlanList = new List<HighRoads_SelectBenefitPlan.RetrievePlanWrapper>();
        selectBenefitPlanObj.riderPlanList = new List<HighRoads_SelectBenefitPlan.RiderPlanWrapper>();
        for(Benefit_Plan_Metadata__c BPMRecord : (List<Benefit_Plan_Metadata__c>)database.query(HighRoads_Constants.MEDICAL_PLAN_QUERY+opp.accountId+HighRoads_Constants.MEDICAL_PLAN_QUERY_1)) {
            selectBenefitPlanObj.retrievePlanList.add(new HighRoads_SelectBenefitPlan.RetrievePlanWrapper(BPMRecord,true,false));
        }
        
        for(Benefit_Plan_Metadata__c BPMRecord : [SELECT ID,Name,EOC__c ,SBC__c ,BCM__c ,Ancillary_EOC__c ,Ancillary_SOB__c ,Ancillary_GSA__c,Version_Number__c,
                                                     Plan_Name__c,Benefit_Plan_ID__c,Visit_Limit__c,Rider_Cost_Share__c,Product_Class__c,isCustom__c,Plan_Type__c
                                                     FROM Benefit_Plan_Metadata__c WHERE Medical_OR_Rider__c = :System.Label.HR43_Rider Order by Benefit_Plan_ID__c ]) {
            selectBenefitPlanObj.riderPlanList.add(new HighRoads_SelectBenefitPlan.RiderPlanWrapper(BPMRecord,false));
        }
        
        selectBenefitPlanObj.selectedPlanId = bpmList[2].Id;
        
        selectBenefitPlanObj.redirectToRiders();
        
        List<HighRoads_SelectBenefitPlan.RetrievePlanWrapper> retrievePlanList = selectBenefitPlanObj.retrievePlanList;
        if(retrievePlanList.size() > 0)
            retrievePlanList[0].isSelected = false;
        
        if(selectBenefitPlanObj.retrievePlanList != null && selectBenefitPlanObj.retrievePlanList.size() >= 1) {
            selectBenefitPlanObj.retrievePlanList[1].isSelected = true;
            /*Selecting rider plans for other medical plan */
            if(selectBenefitPlanObj.riderPlanPageList != null && selectBenefitPlanObj.riderPlanPageList.size() > 0) {
                for(HighRoads_SelectBenefitPlan.RiderPlanWrapper rpw : selectBenefitPlanObj.riderPlanPageList[0].riderList){
                    rpw.associate = true;
                }
            }
        }
        
        system.debug('================'+selectBenefitPlanObj.retrievePlanList);
        selectBenefitPlanObj.associateRiders();
        
        selectBenefitPlanObj.associatePlans();
        Test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : retrieve existing benefit plans at opportunity level
    * @return void        
    **/
    private testMethod static void  retrieveExistingBenefitPlanOpportunity(){
        /* Inserting the benefit plan data filter custom setting */
        List<Benefit_Plan_Data_Filters__c> bpdfList = HighRoads_TestDataUtility.insertBenefitDataFiltersCS();
        insert bpdfList;
        
        /* Inserting the market segment mapping custom setting */
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegList;
        
        /* loading the grid to metadata mapping custom setting from static resource */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        
        /*Inserting the benefit grid data */
        List<SHP_Benefit_Grid__c> benefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        insert benefitGrid;
        
        /*verifying the grid data successfully inserted or not */
        System.assertEquals(4, benefitGrid.size());
        
        /* Fetching benefit plan metadata from Benenefit Plan Metadata object */
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
        
        /*verifying the equal no.of metadata records have been created */
        System.assertEquals(benefitGrid.size(), benefitPlanMetadata.size());
        
        /*Inserting SHP Sales Employer Account */
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        /*Verifying the account has been created successfully or not */
        System.assertNotEquals(acc.Id, NULL);
        
        /*inserting the SHP Sales Opportunity */
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        /*Verifying the opportunity inserted successfully */
        System.assertNotEquals(opp.Id, NULL);

        /* Inserting the Metadata */
        List<Benefit_Plan_Metadata__c> bpmList = new List<Benefit_Plan_Metadata__c>();
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Ancillary_EOC__c = false;
        bpm.Ancillary_GSA__c = false;
        bpm.Ancillary_SOB__c = false;
        bpm.EOC__c = true;
        bpm.BCM__c = true;
        bpm.SBC__c = true;
        bpm.Benefit_Plan_ID__c = 'HE02';
        bpm.Plan_Status__c = 'Available for Sale - Approved';
        bpm.Plan_Year__c = '2016';
        bpmList.add(bpm);
        
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02 - 2016';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = Date.parse('1/1/2016');
        bpm1.End_Date__c = Date.parse('12/31/2016');
        bpm1.Market_Segment__c = 'Large Group';
        bpm1.Plan_Type__c = 'Standard';
        bpm1.Ancillary_EOC__c = true;
        bpm1.Ancillary_GSA__c = true;
        bpm1.Ancillary_SOB__c = true;
        bpm1.EOC__c = true;
        bpm1.BCM__c = true;
        bpm1.SBC__c = true;
        bpm1.Benefit_Plan_ID__c = 'XA02';
        bpm1.Plan_Status__c = 'Available for Sale - Approved';
        bpm1.Plan_Year__c = '2016';
        bpmList.add(bpm1);
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Effective_Date__c = Date.parse('1/1/2016');
        bpm2.End_Date__c = Date.parse('12/31/2016');
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Custom';
        bpm2.Ancillary_EOC__c = true;
        bpm2.Ancillary_GSA__c = true;
        bpm2.Ancillary_SOB__c = true;
        bpm2.EOC__c = false;
        bpm2.BCM__c = false;
        bpm2.SBC__c = false;
        bpm2.Benefit_Plan_ID__c = 'ML02';
        bpm2.Plan_Status__c = 'Available for Sale - Approved';
        bpm2.Plan_Year__c = '2016';
        bpmList.add(bpm2);
        
        Benefit_Plan_Metadata__c bpm3 = new Benefit_Plan_Metadata__c();
        bpm3.Name = 'XA16 - 2016';
        bpm3.Medical_OR_Rider__c = 'Rider';
        bpm3.Product_Class__c = 'Acupuncture and Chiro';
        bpm3.Effective_Date__c = Date.parse('1/1/2016');
        bpm3.End_Date__c = Date.parse('12/31/2016');
        bpm3.Market_Segment__c = 'Large Group';
        bpm3.Plan_Type__c = 'Standard';
        bpm3.Ancillary_EOC__c = true;
        bpm3.Ancillary_GSA__c = true;
        bpm3.Ancillary_SOB__c = true;
        bpm3.EOC__c = true;
        bpm3.BCM__c = true;
        bpm3.SBC__c = true;
        bpm3.Benefit_Plan_ID__c = 'XA16';
        bpm3.Plan_Status__c = 'Available for Sale - Approved';
        bpm3.Plan_Year__c = '2016';
        bpmList.add(bpm3);
        
        Insert bpmList;
        
        /*Inserting the Benefit Plan Association for Opportunity */
        /* Inserting the benefit plan association records */
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Name = bpmList[0].Name;
        bpa.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa.Opportunity__c = opp.Id;
        bpaList.add(bpa);
        
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Name = bpmList[0].Name;
        bpa1.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa1.Raider_ID__c = bpmList[1].Id;
        bpa1.Opportunity__c = opp.Id;
        bpaList.add(bpa1);
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Name = bpmList[0].Name;
        bpa2.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa2.Raider_ID__c = bpmList[3].Id;
        bpa2.Opportunity__c = opp.Id;
        bpaList.add(bpa2);
        
        Benefit_Plan_Association__c bpa3 = new Benefit_Plan_Association__c();
        bpa3.Name = bpmList[2].Name;
        bpa3.Benefit_Plan_Metadata__c = bpmList[2].Id;
        bpa3.Opportunity__c = opp.Id;
        bpaList.add(bpa3);
        
        Insert bpaList;
        
        Test.startTest();
        /* Loading the plan selection page */
        Test.setCurrentPage(Page.HighRoads_SelectBenefitPlan);
        /*Setting page parameters */
        ApexPages.currentPage().getParameters().put('oppId',opp.id);
        ApexPages.currentPage().getParameters().put('AccountId',opp.accountid);
        ApexPages.currentPage().getParameters().put('employerType',opp.Employer_Type__c);
        HighRoads_SelectBenefitPlan selectBenefitPlanObj = new HighRoads_SelectBenefitPlan();
        selectBenefitPlanObj.selectedPlanId = bpmList[0].Id;
        for(HighRoads_SelectBenefitPlan.RetrievePlanWrapper rpw : selectBenefitPlanObj.retrievePlanList){
            rpw.isSelected = true;
        }
        selectBenefitPlanObj.redirectToRiders();
        for(HighRoads_SelectBenefitPlan.RetrievePlanWrapper rpw : selectBenefitPlanObj.retrievePlanList){
            for(HighRoads_SelectBenefitPlan.RiderPlanPageWrapper riderPagePlan : selectBenefitPlanObj.riderPlanPageList){
                for(HighRoads_SelectBenefitPlan.RiderPlanWrapper riderPlan : riderPagePlan.riderList){
                    riderPlan.associate = true;
                }
            }
        }
        selectBenefitPlanObj.associateRiders();
        selectBenefitPlanObj.associatePlans();
        Test.stopTest();
    }
    
    static testMethod void testRiderPalns() {
        /* Inserting the benefit plan data filter custom setting */
        List<Benefit_Plan_Data_Filters__c> bpdfList = HighRoads_TestDataUtility.insertBenefitDataFiltersCS();
        insert bpdfList;
        
        /* Inserting the market segment mapping custom setting */
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegList;
        
        /* loading the grid to metadata mapping custom setting from static resource */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        
        /*Inserting the benefit grid data */
        List<SHP_Benefit_Grid__c> benefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        insert benefitGrid;
        
        /*verifying the grid data successfully inserted or not */
        System.assertEquals(4, benefitGrid.size());
        
        /* Fetching benefit plan metadata from Benenefit Plan Metadata object */
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
        
        /*verifying the equal no.of metadata records have been created */
        System.assertEquals(benefitGrid.size(), benefitPlanMetadata.size());
        
        /*Inserting SHP Sales Employer Account */
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        /*Verifying the account has been created successfully or not */
        System.assertNotEquals(acc.Id, NULL);
        
        /*inserting the SHP Sales Opportunity */
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        /*Verifying the opportunity inserted successfully */
        System.assertNotEquals(opp.Id, NULL);

        /* Inserting the Metadata */
        List<Benefit_Plan_Metadata__c> bpmList = new List<Benefit_Plan_Metadata__c>();
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Ancillary_EOC__c = false;
        bpm.Ancillary_GSA__c = false;
        bpm.Ancillary_SOB__c = false;
        bpm.EOC__c = true;
        bpm.BCM__c = true;
        bpm.SBC__c = true;
        bpm.Benefit_Plan_ID__c = 'HE02';
        bpm.Plan_Status__c = 'Available for Sale - Approved';
        bpm.Plan_Year__c = '2016';
        bpmList.add(bpm);
        
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02 - 2016';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = Date.parse('1/1/2016');
        bpm1.End_Date__c = Date.parse('12/31/2016');
        bpm1.Market_Segment__c = 'Large Group';
        bpm1.Plan_Type__c = 'Standard';
        bpm1.Ancillary_EOC__c = true;
        bpm1.Ancillary_GSA__c = true;
        bpm1.Ancillary_SOB__c = true;
        bpm1.EOC__c = true;
        bpm1.BCM__c = true;
        bpm1.SBC__c = true;
        bpm1.Benefit_Plan_ID__c = 'XA02';
        bpm1.Plan_Status__c = 'Available for Sale - Approved';
        bpm1.Plan_Year__c = '2016';
        bpmList.add(bpm1);
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Effective_Date__c = Date.parse('1/1/2016');
        bpm2.End_Date__c = Date.parse('12/31/2016');
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Custom';
        bpm2.Ancillary_EOC__c = true;
        bpm2.Ancillary_GSA__c = true;
        bpm2.Ancillary_SOB__c = true;
        bpm2.EOC__c = false;
        bpm2.BCM__c = false;
        bpm2.SBC__c = false;
        bpm2.Benefit_Plan_ID__c = 'ML02';
        bpm2.Plan_Status__c = 'Available for Sale - Approved';
        bpm2.Plan_Year__c = '2016';
        bpmList.add(bpm2);
        
        Benefit_Plan_Metadata__c bpm3 = new Benefit_Plan_Metadata__c();
        bpm3.Name = 'XA16 - 2016';
        bpm3.Medical_OR_Rider__c = 'Rider';
        bpm3.Product_Class__c = 'Acupuncture and Chiro';
        bpm3.Effective_Date__c = Date.parse('1/1/2016');
        bpm3.End_Date__c = Date.parse('12/31/2016');
        bpm3.Market_Segment__c = 'Large Group';
        bpm3.Plan_Type__c = 'Standard';
        bpm3.Ancillary_EOC__c = true;
        bpm3.Ancillary_GSA__c = true;
        bpm3.Ancillary_SOB__c = true;
        bpm3.EOC__c = true;
        bpm3.BCM__c = true;
        bpm3.SBC__c = true;
        bpm3.Benefit_Plan_ID__c = 'XA16';
        bpm3.Plan_Status__c = 'Available for Sale - Approved';
        bpm3.Plan_Year__c = '2016';
        bpmList.add(bpm3);
        
        Insert bpmList;
        
        /*Inserting the Benefit Plan Association for Opportunity */
        /* Inserting the benefit plan association records */
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Name = bpmList[0].Name;
        bpa.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa.Opportunity__c = opp.Id;
        bpaList.add(bpa);
        
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Name = bpmList[0].Name;
        bpa1.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa1.Raider_ID__c = bpmList[1].Id;
        bpa1.Opportunity__c = opp.Id;
        bpaList.add(bpa1);
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Name = bpmList[0].Name;
        bpa2.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa2.Raider_ID__c = bpmList[3].Id;
        bpa2.Opportunity__c = opp.Id;
        bpaList.add(bpa2);
        
        Benefit_Plan_Association__c bpa3 = new Benefit_Plan_Association__c(); 
        bpa3.Name = bpmList[2].Name;
        bpa3.Benefit_Plan_Metadata__c = bpmList[2].Id;
        bpa3.Opportunity__c = opp.Id;
        bpaList.add(bpa3);
        
        Insert bpaList;
        
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
        
        //  Sets the page context which we are testing
        Test.setCurrentPage(Page.HighRoads_SelectBenefitPlan);
        
        //  Data queried before it's use. 
        opp = [Select Id, AccountId, Employer_Type__c From Opportunity limit 1];
        
        //  Sets page parameters
        ApexPages.currentPage().getParameters().put(System.Label.HR44_OppId, opp.id);
        ApexPages.currentPage().getParameters().put(HighRoads_Constants.ACCOUNTID, opp.accountid);
        ApexPages.currentPage().getParameters().put(HighRoads_Constants.EMPLOYER_TYPE, opp.Employer_Type__c);
        
        //  instance of the class(which we are testing from here)
        HighRoads_SelectBenefitPlan selectBenefitPlanObj = new HighRoads_SelectBenefitPlan();
        
        //  Fills the list from test class
        selectBenefitPlanObj.retrievePlanList = new List<HighRoads_SelectBenefitPlan.RetrievePlanWrapper>();
        selectBenefitPlanObj.riderPlanList = new List<HighRoads_SelectBenefitPlan.RiderPlanWrapper>();
        for(Benefit_Plan_Metadata__c BPMRecord : (List<Benefit_Plan_Metadata__c>)database.query(HighRoads_Constants.MEDICAL_PLAN_QUERY+opp.accountId+HighRoads_Constants.MEDICAL_PLAN_QUERY_1)) {
            selectBenefitPlanObj.retrievePlanList.add(new HighRoads_SelectBenefitPlan.RetrievePlanWrapper(BPMRecord,true,false));
        }
        
        for(Benefit_Plan_Metadata__c BPMRecord : [SELECT ID,Name,EOC__c ,SBC__c ,BCM__c ,Ancillary_EOC__c ,Ancillary_SOB__c ,Ancillary_GSA__c,Version_Number__c,
                                                     Plan_Name__c,Benefit_Plan_ID__c,Visit_Limit__c,Rider_Cost_Share__c,Product_Class__c,isCustom__c,Plan_Type__c
                                                     FROM Benefit_Plan_Metadata__c WHERE Medical_OR_Rider__c = :System.Label.HR43_Rider Order by Benefit_Plan_ID__c ]) {
            selectBenefitPlanObj.riderPlanList.add(new HighRoads_SelectBenefitPlan.RiderPlanWrapper(BPMRecord,false));
        }
        
        selectBenefitPlanObj.backFromRider();
        selectBenefitPlanObj.backFromMedical();
        selectBenefitPlanObj.collapseAll();
        selectBenefitPlanObj.expandAll();
        selectBenefitPlanObj.getShow();
        selectBenefitPlanObj.checkSelectedValues(); 
        selectBenefitPlanObj.oppId = null;
        selectBenefitPlanObj.rfpId = rfpObj.Id;
        selectBenefitPlanObj.retrievePlansforSearch();
        selectBenefitPlanObj.rfpId = null;
        selectBenefitPlanObj.quoteId = quote.Id;
        selectBenefitPlanObj.retrievePlansforSearch();
        selectBenefitPlanObj.quoteId = null;
        selectBenefitPlanObj.ssoId = sso.Id;
        selectBenefitPlanObj.retrievePlansforSearch();
        selectBenefitPlanObj.searchElement = System.Label.HR49_Custom;
        selectBenefitPlanObj.retrievePlansforSearch();
        selectBenefitPlanObj.searchPlanName = '12345';
        selectBenefitPlanObj.sortPlans();
        selectBenefitPlanObj.getSearchPlans();
        selectBenefitPlanObj.retrievePlansforSearch();
        selectBenefitPlanObj.populateRiderData(bpaList[0], new HighRoads_SelectBenefitPlan.RiderPlanWrapper(bpmList[0], false), new HighRoads_SelectBenefitPlan.RetrievePlanWrapper(bpmList[0], true, false));
        selectBenefitPlanObj.populateParentandVersion(bpaList[0], rfpObj.Id, selectBenefitPlanObj.riderPlanList[0], selectBenefitPlanObj.retrievePlanList[0], 'rider');
        selectBenefitPlanObj.populateParentandVersion(bpaList[0], quote.Id, selectBenefitPlanObj.riderPlanList[0], selectBenefitPlanObj.retrievePlanList[0], 'rider');
        selectBenefitPlanObj.populateParentandVersion(bpaList[0], sso.Id, selectBenefitPlanObj.riderPlanList[0], selectBenefitPlanObj.retrievePlanList[0], 'rider');
    }
}