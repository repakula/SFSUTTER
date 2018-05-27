/* 
     Class Name: BenefitPlanAssociationTrigger_Test 
     Author: IDC Offshore
     Date: 06-Dec-2016
     Description: Test class for BenefitPlanAssociationTrigger Trigger.
*/
@isTest
private class BenefitPlanAssociationTrigger_Test {
    
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
    private static Id incRecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('RFP Form').getRecordTypeId();
    private static Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHP Sales Opportunity').getRecordTypeId(); 
    
    
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Test method for benefit Plan Creattion and rates entering at Opportunity stage
    * 				 Test coverage for delete rates if plans are un selected.
    * @return void        
    **/
    private static testMethod void testBPAUpdationOpportunity(){  
        Test.StartTest();
        /*inserting grid metadata mapping custom setting data */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        /*inserting SF_P2A_Market_Segments_Mapping__c custom setting data */
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg1 = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg1;
        
        /*Inserting medical Plan */
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Benefit_Plan_ID__c = 'HE02 - 2016';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Plan_Year__c = '2016';
        insert bpm;
        /*Checking the medical plan is succesfully inserted */
        System.assertNotEquals(bpm.Id, NULL);
        
        /*Inserting medical Plan */
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02 - 2016';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Standard';
        bpm2.Benefit_Plan_ID__c = 'ML02 - 2016';
        bpm2.Effective_Date__c = Date.parse('1/1/2016');
        bpm2.End_Date__c = Date.parse('12/31/2016');
        bpm2.Plan_Year__c = '2016';
        insert bpm2;
        /*Checking the medical plan is succesfully inserted */
        System.assertNotEquals(bpm2.Id, NULL);
        
        /*Inserting medical Plan */
        Benefit_Plan_Metadata__c bpm3 = new Benefit_Plan_Metadata__c();
        bpm3.Name = 'ML03 - 2016';
        bpm3.Medical_OR_Rider__c = 'Medical';
        bpm3.Product_Class__c = 'Medical';
        bpm3.Market_Segment__c = 'Large Group';
        bpm3.Plan_Type__c = 'Standard';
        bpm3.Benefit_Plan_ID__c = 'ML03 - 2016';
        bpm3.Effective_Date__c = Date.parse('1/1/2016');
        bpm3.End_Date__c = Date.parse('12/31/2016');
        bpm3.Plan_Year__c = '2016';
        insert bpm3;
        /*Checking the medical plan is succesfully inserted */
        System.assertNotEquals(bpm3.Id, NULL);
        
        /*Inserting Rider Plan */
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02 - 2016';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = Date.parse('1/1/2016');
        bpm1.End_Date__c = Date.parse('12/31/2016');
        bpm1.Market_Segment__c = 'Large Group';
        bpm1.Plan_Type__c = 'Standard';
        bpm1.Benefit_Plan_ID__c = 'XA02';
        bpm1.Plan_Status__c = 'Available for Sale - Approved';
        bpm1.Plan_Year__c = '2016';
        Insert bpm1;
        /*Checking the medical plan is succesfully inserted */
        System.assertNotEquals(bpm1.Id, NULL);
        
        /*Inserting Rider Plan */
        Benefit_Plan_Metadata__c bpm4 = new Benefit_Plan_Metadata__c();
        bpm4.Name = 'XA03 - 2016';
        bpm4.Medical_OR_Rider__c = 'Rider';
        bpm4.Product_Class__c = 'Acupuncture and Chiro';
        bpm4.Effective_Date__c = Date.parse('1/1/2016');
        bpm4.End_Date__c = Date.parse('12/31/2016');
        bpm4.Market_Segment__c = 'Large Group';
        bpm4.Plan_Type__c = 'Standard';
        bpm4.Benefit_Plan_ID__c = 'XA03';
        bpm4.Plan_Status__c = 'Available for Sale - Approved';
        bpm4.Plan_Year__c = '2016';
        Insert bpm4;
        /*Checking the medical plan is succesfully inserted */
        System.assertNotEquals(bpm4.Id, NULL);
        
        Account acc = new Account();
        acc.Name = 'Test Account1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Labor and Trust';
        insert acc;
        /*Checking the Account is succesfully inserted */
        System.assertNotEquals(Account.Id, NULL);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordTypeId;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today()+30;
        opp.StageName = 'Closed Won';
        opp.Renewed_Opportunity__c = false;
        opp.Plan_Effective_Date__c = Date.parse('1/1/2016');
        insert opp;
        /*Checking the Opportunity is successfully created */
        System.assertNotEquals(opp.Id, NULL);
        
        /*Associating the Benefit Plans to Opportunity record */
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.Version_Number__c = 1;
        bpa.Opportunity__c = opp.id;
        insert bpa;
        
        /*Inserting Rider plan at Opportunity stage to check the rate card is changing or not */
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Benefit_Plan_Metadata__c = bpm.id;
        bpa1.Raider_ID__c = bpm1.Id;
        bpa1.Version_Number__c = 1;
        bpa1.Opportunity__c = opp.id;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterInsert = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterInsertCreateRates = true;
        insert bpa1;
        
        /*Associating the Benefit Plans to Opportunity record */
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Benefit_Plan_Metadata__c = bpm2.id;
        bpa2.Version_Number__c = 1;
        bpa2.Opportunity__c = opp.id;
        insert bpa2;
        
        /*Associating the Benefit Plans to Opportunity record */
        Benefit_Plan_Association__c bpa3 = new Benefit_Plan_Association__c();
        bpa3.Benefit_Plan_Metadata__c = bpm2.id;
        bpa3.Raider_ID__c = bpm1.Id;
        bpa3.Version_Number__c = 1;
        bpa3.Opportunity__c = opp.id;
        insert bpa3;
        
        /*Associating the Benefit Plans to Opportunity record */
        Benefit_Plan_Association__c bpa4 = new Benefit_Plan_Association__c();
        bpa4.Benefit_Plan_Metadata__c = bpm3.id;
        bpa4.Version_Number__c = 1;
        bpa4.Opportunity__c = opp.id;
        insert bpa4;
        
        /*Associating the Benefit Plans to Opportunity record */
        Benefit_Plan_Association__c bpa5 = new Benefit_Plan_Association__c();
        bpa5.Benefit_Plan_Metadata__c = bpm2.id;
        bpa5.Raider_ID__c = bpm4.Id;
        bpa5.Version_Number__c = 1;
        bpa5.Opportunity__c = opp.id;
        insert bpa5;
        
        /*Inserting rate card and rate for the above plan */
        Rate_Card__c ratecard = new Rate_Card__c();
        insert ratecard;
        /* Inserting Rarte for Plans */
        Rates__c rate = new Rates__c();
        rate.Rate_Card_ID__c = ratecard.id;
        rate.Opportunity__c = opp.id;
        rate.Tier_2_EE__c = '12';
        rate.Tier_Type__c = 'Tier 1';
        rate.Group_Type__c = 'Active';
        rate.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_Medical';
        rate.Plan_Type_Tier_Group__c = opp.id+'_HE02 - 2016_Medical_Tier 1_Active';
        rate.Plan_Name__c = 'HE02 - 2016'; 
        insert rate;
        
        Rates__c rateRider = new Rates__c();
        rateRider.Rate_Card_ID__c = ratecard.id;
        rateRider.Opportunity__c = opp.id;
        rateRider.Tier_2_EE__c = '12';
        rateRider.Tier_Type__c = 'Tier 1';
        rateRider.Group_Type__c = 'Active';
        rateRider.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_XA02 - 2016';
        rateRider.Plan_Type_Tier_Group__c = opp.id+'_HE02 - 2016_XA02 - 2016_Tier 1_Active';
        rateRider.Plan_Name__c = 'XA02 - 2016'; 
        insert rateRider;
        
        Rates__c rateML02 = new Rates__c();
        rateML02.Rate_Card_ID__c = ratecard.id;
        rateML02.Opportunity__c = opp.id;
        rateML02.Tier_2_EE__c = '12';
        rateML02.Tier_Type__c = 'Tier 1';
        rateML02.Group_Type__c = 'Active';
        rateML02.Medical_Plan_Rider_Plan__c = 'ML02 - 2016_Medical';
        rateML02.Plan_Type_Tier_Group__c = opp.id+'_ML02 - 2016_Medical_Tier 1_Active';
        rateML02.Plan_Name__c = 'ML02 - 2016'; 
        insert rateML02;
        
        Rates__c rateML03 = new Rates__c();
        rateML03.Rate_Card_ID__c = ratecard.id;
        rateML03.Opportunity__c = opp.id;
        rateML03.Tier_2_EE__c = '12';
        rateML03.Tier_Type__c = 'Tier 1';
        rateML03.Group_Type__c = 'Active';
        rateML03.Medical_Plan_Rider_Plan__c = 'ML03 - 2016_Medical';
        rateML03.Plan_Type_Tier_Group__c = opp.id+'_ML03 - 2016_Medical_Tier 1_Active';
        rateML03.Plan_Name__c = 'ML03 - 2016'; 
        insert rateML03;
        
        Rates__c rateXA02 = new Rates__c();
        rateXA02.Rate_Card_ID__c = ratecard.id;
        rateXA02.Opportunity__c = opp.id;
        rateXA02.Tier_2_EE__c = '12';
        rateXA02.Tier_Type__c = 'Tier 1';
        rateXA02.Group_Type__c = 'Active';
        rateXA02.Medical_Plan_Rider_Plan__c = 'ML03 - 2016_XA02 -2016';
        rateXA02.Plan_Type_Tier_Group__c = opp.id+'_ML03 - 2016_XA02 -2016_Tier 1_Active';
        rateXA02.Plan_Name__c = 'ML03 - 2016'; 
        insert rateXA02;
        
        Rates__c rateXA03 = new Rates__c();
        rateXA03.Rate_Card_ID__c = ratecard.id;
        rateXA03.Opportunity__c = opp.id;
        rateXA03.Tier_2_EE__c = '12';
        rateXA03.Tier_Type__c = 'Tier 1';
        rateXA03.Group_Type__c = 'Active';
        rateXA03.Medical_Plan_Rider_Plan__c = 'ML03 - 2016_XA03 -2016';
        rateXA03.Plan_Type_Tier_Group__c = opp.id+'_ML03 - 2016_XA03 -2016_Tier 1_Active';
        rateXA03.Plan_Name__c = 'ML03 - 2016'; 
        insert rateXA03;
        
        List<Benefit_Plan_Association__c> oppBPAList = new List<Benefit_Plan_Association__c>();
        bpa.Opportunity_Rate_Card__c = ratecard.id; 
        bpa1.Opportunity_Rate_Card__c = ratecard.id; 
        bpa2.Opportunity_Rate_Card__c = ratecard.id; 
        bpa3.Opportunity_Rate_Card__c = ratecard.id; 
        bpa4.Opportunity_Rate_Card__c = ratecard.id; 
        bpa5.Opportunity_Rate_Card__c = ratecard.id; 
        oppBPAList.add(bpa);
        oppBPAList.add(bpa1);
        oppBPAList.add(bpa2);
        oppBPAList.add(bpa3);
        oppBPAList.add(bpa4);
        oppBPAList.add(bpa5);
        update oppBPAList; 
        oppBPAList.clear();
        /* Unselecting multiple Plans from Opportunity */  
        bpa1.Opportunity__c = NULL;
        oppBPAList.add(bpa1);
        bpa2.Opportunity__c = NULL;
        oppBPAList.add(bpa2);
        bpa3.Opportunity__c = NULL;
        oppBPAList.add(bpa3);
        bpa4.Opportunity__c = NULL;
        oppBPAList.add(bpa4);
        bpa5.Opportunity__c = NULL;
        oppBPAList.add(bpa5);
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterUpdate = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateDeleteRates = true;
        update oppBPAList;
        
        oppBPAList.clear();
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterUpdate = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateDeleteRates = true;
        bpa.Opportunity__c = NULL;
        update bpa;
        Test.StopTest();
    }
    
    
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Test method for benefit Plan Creattion and rates entering at RFP stage
    * @return void        
    **/
    private static testMethod void testBPAUpdationRFP(){  
        Test.StartTest();
         /*inserting grid metadata mapping custom setting data */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        /*inserting SF_P2A_Market_Segments_Mapping__c custom setting data */
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg1 = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg1;
        
        /*Inserting medical Plan */
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Benefit_Plan_ID__c = 'HE02 - 2016';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Plan_Year__c = '2016';
        insert bpm;
        
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
        
        Insert bpm1;
        
        Account acc = new Account();
        acc.Name = 'Test Account1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Labor and Trust';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordTypeId;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today()+30;
        opp.StageName = 'Closed Won';
        opp.Renewed_Opportunity__c = false;
        opp.Plan_Effective_Date__c = Date.parse('1/1/2016');
        insert opp;
         /*Associating the Benefit Plans to RFP record */
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.Version_Number__c = 1;
        bpa.Opportunity__c = opp.id;
        insert bpa;
        /*Inserting rate card and rate for the above plan */
        Rate_Card__c ratecard = new Rate_Card__c();
        insert ratecard;
        
        Rates__c rate = new Rates__c();
        rate.Rate_Card_ID__c = ratecard.id;
        rate.Opportunity__c = opp.id;
        rate.Tier_2_EE__c = '12';
        rate.Tier_Type__c = 'Tier 1';
        rate.Group_Type__c = 'Active';
        rate.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_Medical';
        rate.Plan_Type_Tier_Group__c = opp.id+'_HE02 - 2016_Medical_Tier 1_Active';
        rate.Plan_Name__c = 'HE02 - 2016'; 
        insert rate;
        
        bpa.Opportunity_Rate_Card__c = ratecard.id; 
        update bpa;
        
        Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        
        System.assertNotEquals(rfpObj.Id, NULL);
        /*Checking the plan is copied to RFP or not */
        List<Benefit_Plan_Association__c> bpaList = [select id,Opportunity_Rate_Card__c from Benefit_Plan_Association__c where RFP_Form__c =:rfpObj.Id];
        
        System.assertEquals(1, bpaList.size());
        
        /*Checking the opportunity rate card */
        system.assertEquals(rateCard.Id, bpaList[0].Opportunity_Rate_Card__c);
        
        /*Inserting one more plan at RFP stage to check the rate card is changing or not */
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Benefit_Plan_Metadata__c = bpm.id;
        bpa1.Raider_ID__c = bpm1.Id;
        bpa1.Version_Number__c = 1;
        bpa1.RFP_Form__c = rfpObj.id;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterInsert = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterInsertCreateRates = true;
        
        insert bpa1;
        
        /*Checking the bpa is Inserted succesfully for RFP */
        System.assertNotEquals(bpa1.Id, NULL);
        
        Test.StopTest();
    }
    
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Test method for benefit Plan Creattion and rates entering at RFP stage
    * @return void        
    **/
    private static testMethod void testBPAUpdationRFPUnSelectParentPlan(){  
        Test.StartTest();
         /*inserting grid metadata mapping custom setting data */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        /*inserting SF_P2A_Market_Segments_Mapping__c custom setting data */
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg1 = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg1;
        
        /*Inserting medical Plan */
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Benefit_Plan_ID__c = 'HE02 - 2016';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Plan_Year__c = '2016';
        insert bpm;
        
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
        
        Insert bpm1;
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02 - 2016';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Standard';
        bpm2.Benefit_Plan_ID__c = 'ML02 - 2016';
        bpm2.Effective_Date__c = Date.parse('1/1/2016');
        bpm2.End_Date__c = Date.parse('12/31/2016');
        bpm2.Plan_Year__c = '2016';
        insert bpm2;
        
        Account acc = new Account();
        acc.Name = 'Test Account1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Labor and Trust';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordTypeId;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today()+30;
        opp.StageName = 'Closed Won';
        opp.Renewed_Opportunity__c = false;
        opp.Plan_Effective_Date__c = Date.parse('1/1/2016');
        insert opp;
         /*Associating the Benefit Plans to RFP record */
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.Version_Number__c = 1;
        bpa.Opportunity__c = opp.id;
        insert bpa;
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Benefit_Plan_Metadata__c = bpm2.id;
        bpa2.Version_Number__c = 1;
        bpa2.Opportunity__c = opp.id;
        insert bpa2;
        
        /*Inserting rate card and rate for the above plan */
        Rate_Card__c ratecard = new Rate_Card__c();
        insert ratecard;
        
        Rates__c rate = new Rates__c();
        rate.Rate_Card_ID__c = ratecard.id;
        rate.Opportunity__c = opp.id;
        rate.Tier_2_EE__c = '12';
        rate.Tier_Type__c = 'Tier 1';
        rate.Group_Type__c = 'Active';
        rate.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_Medical';
        rate.Plan_Type_Tier_Group__c = opp.id+'_HE02 - 2016_Medical_Tier 1_Active';
        rate.Plan_Name__c = 'HE02 - 2016'; 
        insert rate;
        
        bpa.Opportunity_Rate_Card__c = ratecard.id; 
        bpa2.Opportunity_Rate_Card__c = ratecard.id;
        update bpa;
        update bpa2;
        
        Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        
        System.assertNotEquals(rfpObj.Id, NULL);
        /*Checking the plan is copied to RFP or not */
        List<Benefit_Plan_Association__c> bpaList = [select id,RFP_Form__c,RFP_Rate_Card__c from Benefit_Plan_Association__c where RFP_Form__c =:rfpObj.Id];
        
        System.assertEquals(2, bpaList.size());
        
        /*Checking the opportunity rate card */
        system.assertEquals(rateCard.Id, bpaList[0].RFP_Rate_Card__c);
        
        /*Un selecting the parent plan in child */
        bpaList[0].RFP_Form__c = NULL;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateCreateRates = true;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterUpdate = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateDeleteRates = true;
        update bpaList[0];
        
        Test.StopTest();
    }
    
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Test method for selecting new benefit plan after changing the rate card
    * 				 and rates entering at RFP stage
    * @return void        
    **/
    private static testMethod void testBPAUpdationRFPSelectNewPlan(){  
        Test.StartTest();
         /*inserting grid metadata mapping custom setting data */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        /*inserting SF_P2A_Market_Segments_Mapping__c custom setting data */
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg1 = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg1;
        
        /*Inserting medical Plan */
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Benefit_Plan_ID__c = 'HE02 - 2016';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Plan_Year__c = '2016';
        insert bpm;
        
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
        
        Insert bpm1;
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02 - 2016';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Standard';
        bpm2.Benefit_Plan_ID__c = 'ML02 - 2016';
        bpm2.Effective_Date__c = Date.parse('1/1/2016');
        bpm2.End_Date__c = Date.parse('12/31/2016');
        bpm2.Plan_Year__c = '2016';
        insert bpm2;
        
        Account acc = new Account();
        acc.Name = 'Test Account1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Labor and Trust';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordTypeId;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today()+30;
        opp.StageName = 'Closed Won';
        opp.Renewed_Opportunity__c = false;
        opp.Plan_Effective_Date__c = Date.parse('1/1/2016');
        insert opp;
         /*Associating the Benefit Plans to RFP record */
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.Version_Number__c = 1;
        bpa.Opportunity__c = opp.id;
        insert bpa;
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Benefit_Plan_Metadata__c = bpm2.id;
        bpa2.Version_Number__c = 1;
        bpa2.Opportunity__c = opp.id;
        insert bpa2;
        
        /*Inserting rate card and rate for the above plan */
        Rate_Card__c ratecard = new Rate_Card__c();
        insert ratecard;
        
        Rates__c rate = new Rates__c();
        rate.Rate_Card_ID__c = ratecard.id;
        rate.Opportunity__c = opp.id;
        rate.Tier_2_EE__c = '12';
        rate.Tier_Type__c = 'Tier 1';
        rate.Group_Type__c = 'Active';
        rate.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_Medical';
        rate.Plan_Type_Tier_Group__c = opp.id+'_HE02 - 2016_Medical_Tier 1_Active';
        rate.Plan_Name__c = 'HE02 - 2016'; 
        insert rate;
        
        bpa.Opportunity_Rate_Card__c = ratecard.id; 
        bpa2.Opportunity_Rate_Card__c = ratecard.id;
        update bpa;
        update bpa2;
        
        Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        
        System.assertNotEquals(rfpObj.Id, NULL);
        /*Checking the plan is copied to RFP or not */
        List<Benefit_Plan_Association__c> bpaList = [select id,RFP_Form__c,RFP_Rate_Card__c from Benefit_Plan_Association__c where RFP_Form__c =:rfpObj.Id];
        
        System.assertEquals(2, bpaList.size());
        
        /*Checking the opportunity rate card */
        system.assertEquals(rateCard.Id, bpaList[0].RFP_Rate_Card__c);
        
        
        /*Un selecting the parent plan in child */
        bpaList[0].RFP_Form__c = NULL;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateCreateRates = true;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterUpdate = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateDeleteRates = true;
        update bpaList[0];
        
        /*Check the rate card is changed for rfp object plans */
        List<Benefit_Plan_Association__c> updatedbpaList = [select id,RFP_Form__c,RFP_Rate_Card__c,Opportunity_Rate_Card__c from Benefit_Plan_Association__c where RFP_Form__c =:rfpObj.Id];
        system.assertNotEquals(updatedbpaList[0].Opportunity_Rate_Card__c,updatedbpaList[0].RFP_Rate_Card__c);
        
        /*Inserting new plan at RFP stage */
        Benefit_Plan_Association__c bpa3 = new Benefit_Plan_Association__c();
        bpa3.Benefit_Plan_Metadata__c = bpm.id;
        bpa3.Version_Number__c = 1;
        bpa3.RFP_Form__c = rfpObj.id;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterInsert = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterInsertCreateRates = true;
        insert bpa3;
        
        updatedbpaList[0].RFP_Form__c = NULL;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateCreateRates = true;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterUpdate = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateDeleteRates = true;
        update updatedbpaList[0];
        
        Test.StopTest();
    }
    
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Test method for benefit Plan Creattion and rates entering at Quote stage
    * @return void        
    **/
    private static testMethod void testBPAUpdationQuote(){  
        Test.StartTest();
         /*inserting grid metadata mapping custom setting data */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        /*inserting SF_P2A_Market_Segments_Mapping__c custom setting data */
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg1 = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg1;
        
        /*Inserting medical Plan */
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Benefit_Plan_ID__c = 'HE02 - 2016';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Plan_Year__c = '2016';
        insert bpm;
        
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
        
        Insert bpm1;
        
        Account acc = new Account();
        acc.Name = 'Test Account1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Labor and Trust';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordTypeId;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today()+30;
        opp.StageName = 'Closed Won';
        opp.Renewed_Opportunity__c = false;
        opp.Plan_Effective_Date__c = Date.parse('1/1/2016');
        insert opp;
         /*Associating the Benefit Plans to RFP record */
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.Version_Number__c = 1;
        bpa.Opportunity__c = opp.id;
        insert bpa;
        /*Inserting rate card and rate for the above plan */
        Rate_Card__c ratecard = new Rate_Card__c();
        insert ratecard;
        
        Rates__c rate = new Rates__c();
        rate.Rate_Card_ID__c = ratecard.id;
        rate.Opportunity__c = opp.id;
        rate.Tier_2_EE__c = '12';
        rate.Tier_Type__c = 'Tier 1';
        rate.Group_Type__c = 'Active';
        rate.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_Medical';
        rate.Plan_Type_Tier_Group__c = opp.id+'_HE02 - 2016_Medical_Tier 1_Active';
        rate.Plan_Name__c = 'HE02 - 2016'; 
        insert rate;
        
        bpa.Opportunity_Rate_Card__c = ratecard.id; 
        update bpa;
        
        Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        
        Proposal__c quote = new Proposal__c();
        quote.RFP_Form__c = rfpObj.Id;
        quote.Opportunity_ID__c = opp.Id;
        Insert quote;
        
        System.assertNotEquals(quote.Id, NULL);
        /*Checking the plan is copied to Quote or not */
        List<Benefit_Plan_Association__c> bpaList = [select id,Quote_Rate_Card__c from Benefit_Plan_Association__c where Proposal__c =:quote.Id];
        
        System.assertEquals(1, bpaList.size());
        
        /*Checking the Quote rate card */
        system.assertEquals(rateCard.Id, bpaList[0].Quote_Rate_Card__c);
        
        /*Inserting one more plan at Quote stage to check the rate card is changing or not */
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Benefit_Plan_Metadata__c = bpm.id;
        bpa1.Raider_ID__c = bpm1.Id;
        bpa1.Version_Number__c = 1;
        bpa1.Proposal__c = quote.id;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterInsert = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterInsertCreateRates = true;
        insert bpa1;
        
        /*Checking the bpa is inserted succesfully for Quote */
        System.assertNotEquals(bpa1.Id, NULL);
        
        Test.StopTest();
    }
    
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Test method for selecting new benefit plan after changing the rate card
    * 				 and rates entering at Proposal stage
    * @return void        
    **/
    private static testMethod void testBPAUpdationQuoteSelectNewPlan(){  
        Test.StartTest();
         /*inserting grid metadata mapping custom setting data */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        /*inserting SF_P2A_Market_Segments_Mapping__c custom setting data */
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg1 = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg1;
        
        /*Inserting medical Plan */
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Benefit_Plan_ID__c = 'HE02 - 2016';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Plan_Year__c = '2016';
        insert bpm;
        
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
        
        Insert bpm1;
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02 - 2016';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Standard';
        bpm2.Benefit_Plan_ID__c = 'ML02 - 2016';
        bpm2.Effective_Date__c = Date.parse('1/1/2016');
        bpm2.End_Date__c = Date.parse('12/31/2016');
        bpm2.Plan_Year__c = '2016';
        insert bpm2;
        
        Account acc = new Account();
        acc.Name = 'Test Account1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Labor and Trust';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordTypeId;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today()+30;
        opp.StageName = 'Closed Won';
        opp.Renewed_Opportunity__c = false;
        opp.Plan_Effective_Date__c = Date.parse('1/1/2016');
        insert opp;
         /*Associating the Benefit Plans to RFP record */
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.Version_Number__c = 1;
        bpa.Opportunity__c = opp.id;
        insert bpa;
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Benefit_Plan_Metadata__c = bpm2.id;
        bpa2.Version_Number__c = 1;
        bpa2.Opportunity__c = opp.id;
        insert bpa2;
        
        /*Inserting rate card and rate for the above plan */
        Rate_Card__c ratecard = new Rate_Card__c();
        insert ratecard;
        
        Rates__c rate = new Rates__c();
        rate.Rate_Card_ID__c = ratecard.id;
        rate.Opportunity__c = opp.id;
        rate.Tier_2_EE__c = '12';
        rate.Tier_Type__c = 'Tier 1';
        rate.Group_Type__c = 'Active';
        rate.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_Medical';
        rate.Plan_Type_Tier_Group__c = opp.id+'_HE02 - 2016_Medical_Tier 1_Active';
        rate.Plan_Name__c = 'HE02 - 2016'; 
        insert rate;
        
        bpa.Opportunity_Rate_Card__c = ratecard.id; 
        bpa2.Opportunity_Rate_Card__c = ratecard.id;
        update bpa;
        update bpa2;
        
        Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        
        Proposal__c quote = new Proposal__c();
        quote.RFP_Form__c = rfpObj.Id;
        quote.Opportunity_ID__c = opp.Id;
        Insert quote;
        
        System.assertNotEquals(quote.Id, NULL);
        /*Checking the plan is copied to Quote or not */
        List<Benefit_Plan_Association__c> bpaList = [select id,Quote_Rate_Card__c from Benefit_Plan_Association__c where RFP_Form__c =:rfpObj.Id];
        
        System.assertEquals(2, bpaList.size());
        
        /*Checking the opportunity rate card */
        system.assertEquals(rateCard.Id, bpaList[0].Quote_Rate_Card__c);
        
        
        /*Un selecting the parent plan in child */
        bpaList[0].Proposal__c = NULL;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateCreateRates = true;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterUpdate = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateDeleteRates = true;
        update bpaList[0];
        
        /*Check the rate card is changed for Quote object plans */
        List<Benefit_Plan_Association__c> updatedbpaList = [select id,Quote_Rate_Card__c,RFP_Rate_Card__c from Benefit_Plan_Association__c where Proposal__c =:quote.Id];
        system.assertNotEquals(updatedbpaList[0].RFP_Rate_Card__c,updatedbpaList[0].Quote_Rate_Card__c);
        
        /*Inserting new plan at Quote stage */
        Benefit_Plan_Association__c bpa3 = new Benefit_Plan_Association__c();
        bpa3.Benefit_Plan_Metadata__c = bpm.id;
        bpa3.Version_Number__c = 1;
        bpa3.Proposal__c = quote.id;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterInsert = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterInsertCreateRates = true;
        insert bpa3;
        
        updatedbpaList[0].Proposal__c = NULL;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateCreateRates = true;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterUpdate = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateDeleteRates = true;
        update updatedbpaList[0];
        
        Test.StopTest();
    }
    
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Test method for benefit Plan Creattion and rates entering at Sold Sign Off stage
    * @return void        
    **/
    private static testMethod void testBPAUpdationSSO(){  
        Test.StartTest();
         /*inserting grid metadata mapping custom setting data */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        /*inserting SF_P2A_Market_Segments_Mapping__c custom setting data */
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg1 = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg1;
        
        /*Inserting medical Plan */
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Benefit_Plan_ID__c = 'HE02 - 2016';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Plan_Year__c = '2016';
        insert bpm;
        
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
        
        Insert bpm1;
        
        Account acc = new Account();
        acc.Name = 'Test Account1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Labor and Trust';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordTypeId;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today()+30;
        opp.StageName = 'Closed Won';
        opp.Renewed_Opportunity__c = false;
        opp.Plan_Effective_Date__c = Date.parse('1/1/2016');
        insert opp;
         /*Associating the Benefit Plans to RFP record */
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.Version_Number__c = 1;
        bpa.Opportunity__c = opp.id;
        insert bpa;
        /*Inserting rate card and rate for the above plan */
        Rate_Card__c ratecard = new Rate_Card__c();
        insert ratecard;
        
        Rates__c rate = new Rates__c();
        rate.Rate_Card_ID__c = ratecard.id;
        rate.Opportunity__c = opp.id;
        rate.Tier_2_EE__c = '12';
        rate.Tier_Type__c = 'Tier 1';
        rate.Group_Type__c = 'Active';
        rate.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_Medical';
        rate.Plan_Type_Tier_Group__c = opp.id+'_HE02 - 2016_Medical_Tier 1_Active';
        rate.Plan_Name__c = 'HE02 - 2016'; 
        insert rate;
        
        bpa.Opportunity_Rate_Card__c = ratecard.id; 
        update bpa;
        
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
        
        System.assertNotEquals(sso.Id, NULL);
        /*Checking the plan is copied to Sold Sign Off or not */
        List<Benefit_Plan_Association__c> bpaList = [select id,SSO_Rate_Card__c from Benefit_Plan_Association__c where Sold_Sign_Off__c =:sso.Id];
        
        System.assertEquals(1, bpaList.size());
        
        /*Checking the Sold Sign Off rate card */
        system.assertEquals(rateCard.Id, bpaList[0].SSO_Rate_Card__c);
        
        /*Inserting one more plan at Sold Sign Off stage to check the rate card is changing or not */
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Benefit_Plan_Metadata__c = bpm.id;
        bpa1.Raider_ID__c = bpm1.Id;
        bpa1.Version_Number__c = 1;
        bpa1.Sold_Sign_Off__c = sso.id;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterInsert = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterInsertCreateRates = true;
        insert bpa1;
        
        /*Checking the bpa is inserted succesfully for Sold Sign Off */
        System.assertNotEquals(bpa1.Id, NULL);
        
        Test.StopTest();
    }
    
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Test method for selecting new benefit plan after changing the rate card
    * 				 and rates entering at Sold Sign Off stage
    * @return void        
    **/
    private static testMethod void testBPAUpdationSSOSelectNewPlan(){  
        Test.StartTest();
         /*inserting grid metadata mapping custom setting data */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        /*inserting SF_P2A_Market_Segments_Mapping__c custom setting data */
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg1 = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg1;
        
        /*Inserting medical Plan */
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Benefit_Plan_ID__c = 'HE02 - 2016';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Plan_Year__c = '2016';
        insert bpm;
        
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
        
        Insert bpm1;
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02 - 2016';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Standard';
        bpm2.Benefit_Plan_ID__c = 'ML02 - 2016';
        bpm2.Effective_Date__c = Date.parse('1/1/2016');
        bpm2.End_Date__c = Date.parse('12/31/2016');
        bpm2.Plan_Year__c = '2016';
        insert bpm2;
        
        Account acc = new Account();
        acc.Name = 'Test Account1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Labor and Trust';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordTypeId;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today()+30;
        opp.StageName = 'Closed Won';
        opp.Renewed_Opportunity__c = false;
        opp.Plan_Effective_Date__c = Date.parse('1/1/2016');
        insert opp;
         /*Associating the Benefit Plans to RFP record */
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.Version_Number__c = 1;
        bpa.Opportunity__c = opp.id;
        insert bpa;
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Benefit_Plan_Metadata__c = bpm2.id;
        bpa2.Version_Number__c = 1;
        bpa2.Opportunity__c = opp.id;
        insert bpa2;
        
        /*Inserting rate card and rate for the above plan */
        Rate_Card__c ratecard = new Rate_Card__c();
        insert ratecard;
        
        Rates__c rate = new Rates__c();
        rate.Rate_Card_ID__c = ratecard.id;
        rate.Opportunity__c = opp.id;
        rate.Tier_2_EE__c = '12';
        rate.Tier_Type__c = 'Tier 1';
        rate.Group_Type__c = 'Active';
        rate.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_Medical';
        rate.Plan_Type_Tier_Group__c = opp.id+'_HE02 - 2016_Medical_Tier 1_Active';
        rate.Plan_Name__c = 'HE02 - 2016'; 
        insert rate;
        
        bpa.Opportunity_Rate_Card__c = ratecard.id; 
        bpa2.Opportunity_Rate_Card__c = ratecard.id;
        update bpa;
        update bpa2;
        
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
        
        System.assertNotEquals(sso.Id, NULL);
        /*Checking the plan is copied to SSO or not */
        List<Benefit_Plan_Association__c> bpaList = [select id,SSO_Rate_Card__c from Benefit_Plan_Association__c where Sold_Sign_Off__c =:sso.Id];
        
        System.assertEquals(2, bpaList.size());
        
        /*Checking the SSO rate card */
        system.assertEquals(rateCard.Id, bpaList[0].SSO_Rate_Card__c);
        
        
        /*Un selecting the parent plan in child */
        bpaList[0].Sold_Sign_Off__c = NULL;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateCreateRates = true;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterUpdate = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateDeleteRates = true;
        update bpaList[0];
        
        /*Check the rate card is changed for Quote object plans */
        List<Benefit_Plan_Association__c> updatedbpaList = [select id,Quote_Rate_Card__c,SSO_Rate_Card__c from Benefit_Plan_Association__c where Sold_Sign_Off__c =:sso.Id];
        system.assertNotEquals(updatedbpaList[0].SSO_Rate_Card__c,updatedbpaList[0].Quote_Rate_Card__c);
        
        /*Inserting new plan at Quote stage */
        Benefit_Plan_Association__c bpa3 = new Benefit_Plan_Association__c();
        bpa3.Benefit_Plan_Metadata__c = bpm.id;
        bpa3.Version_Number__c = 1;
        bpa3.Sold_Sign_Off__c = sso.id;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterInsert = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterInsertCreateRates = true;
        insert bpa3;
        
        updatedbpaList[0].Sold_Sign_Off__c = NULL;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateCreateRates = true;
        HighRoads_BenefitPlanAssociationHelper.isBPAAfterUpdate = true;
        HighRoads_CreateDeleteRatesForPlans.isAfterUpdateDeleteRates = true;
        update updatedbpaList[0];
        Test.StopTest();
    }
    
}