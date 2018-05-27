/**    
 *     Class Name  : HighRoads_CopyOppPlansToRFPANDSCN_Test
 *     Author      : IDC Offshore  
 *     Date        : 12/7/2016  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : This is a test class for SCN trigger helper class 'HighRoads_CopyOppPlansToRFPANDSCN'
 **/
@isTest
public class HighRoads_CopyOppPlansToRFPANDSCN_Test {
    // Method for creating test data and testing methods of HighRoads_CopyOppPlansToRFPANDSCN
    private testMethod static void  selectBenefitPlanOpportunityTest(){
        // Create 
          
        List<Benefit_Plan_Data_Filters__c> bpdfList = HighRoads_TestDataUtility.insertBenefitDataFiltersCS();
        insert bpdfList;
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegList;
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        List<SHP_Benefit_Grid__c> benefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        SHP_Benefit_Grid__c grid1 = new SHP_Benefit_Grid__c();
        grid1.Benefit_Plan_ID__c = 'XA16';
        grid1.Market_Segment__c = 'Large Group';
        grid1.SHP_Benefit_Plan_Year__c = String.valueOf(System.today().year());
        grid1.Plan_Status__c = 'Available for Sale - Approved';
        grid1.IsRider__c = true;
        grid1.Effective_Start__c = System.today();
        grid1.Effective_End__c = system.today()+360;
        benefitGrid.add(grid1);
        
        SHP_Benefit_Grid__c grid2 = new SHP_Benefit_Grid__c();
        grid2.Benefit_Plan_ID__c = 'XA18';
        grid2.Market_Segment__c = 'Large Group';
        grid2.SHP_Benefit_Plan_Year__c = String.valueOf(System.today().year());
        grid2.Plan_Status__c = 'Available for Sale - Approved';
        grid2.IsRider__c = true;
        grid2.Effective_Start__c = System.today();
        grid2.Effective_End__c = system.today()+360;
        benefitGrid.add(grid2);
        
        SHP_Benefit_Grid__c grid3 = new SHP_Benefit_Grid__c();
        grid3.Benefit_Plan_ID__c = 'XA19';
        grid3.Market_Segment__c = 'Large Group';
        grid3.SHP_Benefit_Plan_Year__c = String.valueOf(System.today().year());
        grid3.Plan_Status__c = 'Available for Sale - Approved';
        grid3.IsRider__c = true;
        grid3.Effective_Start__c = System.today();
        grid3.Effective_End__c = system.today()+360;
        benefitGrid.add(grid3);
        
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
                                                              
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        
        Benefit_Plan_Association__c medicalPlan = new Benefit_Plan_Association__c();
        medicalPlan.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medicalPlan.Opportunity__c = opp.Id;
        bpaList.add(medicalPlan);
        
        Benefit_Plan_Association__c riderPlan = new Benefit_Plan_Association__c();
        riderPlan.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        riderPlan.Raider_ID__c = benefitPlanMetadata[1].Id;
        riderPlan.Opportunity__c = opp.Id;
        bpaList.add(riderPlan);
        Insert bpaList;
        
        HighRoads_CopyOppPlansToRFPANDSCN.isRFPAfterInsert = true;
        Incumbent_Carrier__c rfp = new Incumbent_Carrier__c();
        rfp.RecordtypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('RFP Form').getRecordTypeId();
        rfp.Opportunity__c = opp.id;
        insert rfp;
        HighRoads_CopyOppPlansToRFPANDSCN.isRFPAfterInsert = true;
        RFP_IncumbentCarrierTriggerHelper.isAfterInsert = true;
        Incumbent_Carrier__c rfp1 = new Incumbent_Carrier__c();
        rfp1.RecordtypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('RFP Form').getRecordTypeId();
        rfp1.Opportunity__c = opp.id;
        insert rfp1;
        
        
        Proposal__c quote = new Proposal__c();
        quote.Opportunity_ID__c = opp.id;
        quote.RFP_Form__c = rfp.id;
        insert quote;
        
        HighRoads_CopyOppPlansToRFPANDSCN.isProposalAfterInsert = true;
        Proposal__c quote1 = new Proposal__c();
        quote1.Opportunity_ID__c = null;
        quote1.RFP_Form__c = rfp.id;
        insert quote1;
        
        Sold_Sign_Off__c sso = new Sold_Sign_Off__c();
        sso.Opportunity_ID__c = opp.id;
        sso.Quote__c = quote.id;
        sso.Stage__c = 'Draft';
        insert sso;
        
        HighRoads_CopyOppPlansToRFPANDSCN.isSSOAfterInsert = true;
        HighRoads_SoldSignOffTriggerHelper.isAfterInsert = true;
        Sold_Sign_Off__c sso1 = new Sold_Sign_Off__c();
        sso1.Opportunity_ID__c = null;
        sso1.Quote__c = quote.id;
        sso1.Stage__c = 'Draft';
        insert sso1;
         Test.StartTest();                    
        Employer_Group_Data__c scn = new Employer_Group_Data__c();
        scn.Sold_Sign_Off__c = sso.Id;
        scn.Opportunity__c = opp.Id;
        Insert scn;
        
        
        
        HighRoads_CopyOppPlansToRFPANDSCN.isSCNAfterInsert= true;        
        Employer_Group_Data__c scn1 = new Employer_Group_Data__c();
        scn1.Sold_Sign_Off__c = sso.Id;
        scn1.Opportunity__c = opp.Id;
        Insert scn1;
        
        HighRoads_CopyOppPlansToRFPANDSCN.isSCNAfterInsert= true;        
        Employer_Group_Data__c scn2 = new Employer_Group_Data__c();
        scn2.Sold_Sign_Off__c = null;
        scn2.Opportunity__c = opp.Id;
        Insert scn2;
                
        scn1.Stage__c = 'Approved';
        update scn1;
        
        Test.StopTest();
        
    }
}