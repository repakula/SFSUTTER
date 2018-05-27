/* 
     Class Name: SHP_UpdateBenefitGridAuditMetadata_Test 
     Author: IDC Offshore
     Date: 07-Dec-2016
     Description: Test class for SHP_UpdateBenefitGridAuditandMetadata Apex class.
     
     Version    Author         Date              Description
       1        Deloitte      13-4-2017       Increased test class coverage
*/

@isTest
private class SHP_UpdateBenefitGridAuditMetadata_Test {
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Test method for portfolio data insertion, check the equal no of benefit plan metadata records have been created.
    *                Test method for portfolio data updation.
    * @return void        
    **/
    private testMethod static void  portfolioDataInsertionUpdation(){
        /* Inserting the benefit plan data filter custom setting */
        List<Benefit_Plan_Data_Filters__c> bpdfList = HighRoads_TestDataUtility.insertBenefitDataFiltersCS();
        insert bpdfList;
        
        /* Inserting the market segment mapping custom setting */
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegList;
        
        /* loading the grid to metadata mapping custom setting from static resource */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        
        SHP_Benefit_Grid__c grid = new SHP_Benefit_Grid__c();
        grid.Benefit_Plan_ID__c = 'HE02';
        grid.Market_Segment__c = 'Large Group';
        grid.SHP_Benefit_Plan_Year__c = String.valueOf(System.today().year());
        grid.Plan_Name__c = 'HE02 - 2016';
        grid.Plan_Status__c = 'Available for Sale - Approved';
        grid.Effective_Start__c = Date.parse('1/1/2016');
        grid.Effective_End__c = Date.parse('12/31/2016');
        grid.Tech_Date_Time__c = '11123016';
        grid.Plan_Type__c = 'Medical';
        grid.c01_For_any_one_Member_in_a_Family__c = '$100';
        grid.c01_For_an_entire_Family__c = '$100';
        grid.Version_Number__c = 1;
        grid.SHP_Benefit_Plan_Year__c = '2016';
        insert grid;
        
        SHP_Benefit_Grid__c grid1 = new SHP_Benefit_Grid__c();
        grid1.Benefit_Plan_ID__c = 'HE02';
        grid1.Market_Segment__c = 'Large Group';
        grid1.SHP_Benefit_Plan_Year__c = String.valueOf(System.today().year());
        grid1.Plan_Name__c = 'HE02 - 2016';
        grid1.Plan_Status__c = 'Available for Sale - Approved';
        grid1.Effective_Start__c = Date.parse('1/1/2016');
        grid1.Effective_End__c = Date.parse('12/31/2016');
        grid1.Tech_Date_Time__c = '11123016';
        grid1.Plan_Type__c = 'Custom';
        grid1.IsHDHP__c = true;
        grid1.c01_For_any_one_Member_in_a_Family__c = '$100';
        grid1.c01_For_an_entire_Family__c = '$100';
        grid1.Version_Number__c = 1;
        grid1.SHP_Benefit_Plan_Year__c = '2016';
        grid1.EndNote01__c = 'test';
        insert grid1;
        
        
        SHP_UpdateBenefitGridAuditandMetadata.isAfterUpdate = true;
        grid.c01_For_an_entire_Family__c = '$120';
        grid.c01_For_any_one_Member_in_a_Family__c = '$120';
        grid.Tech_Date_Time__c = '11122016';
        grid.EndNote01__c = 'test\r\ntest';
        update grid;
        
        SHP_UpdateBenefitGridAuditandMetadata.isAfterUpdate = true;
        grid.c01_For_an_entire_Family__c = '$130';
        grid.c01_For_any_one_Member_in_a_Family__c = '$130';
        grid.C03_For_an_entire_Family__c = '123';
        grid.EndNote01__c = 'test\ntest';
        grid.Tech_Date_Time__c = '11122016';
        update grid;

        List<Benefit_Grid_Audit__c> auditList = [select id,Tech_Date_Time__c from Benefit_Grid_Audit__c where Benefit_Grid__c =:grid.Id];
        auditList[0].tech_date_time__c = '12122016';
        update auditList;
        
        SHP_UpdateBenefitGridAuditandMetadata.isAfterUpdate = true;
        grid.c01_For_an_entire_Family__c = '$140';
        grid.c01_For_any_one_Member_in_a_Family__c = '$140';
        grid.C03_For_an_entire_Family__c = '1235';
        grid.Tech_Date_Time__c = '11122016';
        grid.EndNote01__c = 'test\r\ntest';
        update grid;
        
    }
    
    /**        
    * @author IDC Team        
    * @date 07/Dec/2016       
    * @description : Test method for portfolio data insertion, check the equal no of benefit plan metadata records have been created.
    *                Test method for portfolio data updation.
    * @return void        
    **/
    private testMethod static void  portfolioDataInsertionUpdation1(){
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
        SHP_UpdateBenefitGridAuditandMetadata.isAfterUpdate = true;
        List<SHP_Benefit_Grid__c> updateList = new List<SHP_Benefit_Grid__c>();
        for(SHP_Benefit_Grid__c gridobj : benefitGrid){
            gridobj.C01_For_any_one_Member_in_a_Family__c = '$120';
            gridobj.C01_For_an_entire_Family__c = '$120';
            gridobj.Tech_Date_Time__c = 'ddmmyyyy';
            updateList.add(gridobj);
        }
        
        update updateList;
        updateList.clear();
        SHP_UpdateBenefitGridAuditandMetadata.isAfterUpdate = true;
        for(SHP_Benefit_Grid__c gridobj : benefitGrid){
            gridobj.C01_For_any_one_Member_in_a_Family__c = '$130';
            gridobj.C01_For_an_entire_Family__c = '$130';
            gridobj.Tech_Date_Time__c = 'ddmmyyyy';
            updateList.add(gridobj);
        }
        
        update updateList;
        
        updateList.clear();
        SHP_UpdateBenefitGridAuditandMetadata.isAfterUpdate = true;
        for(SHP_Benefit_Grid__c gridobj : benefitGrid){
            gridobj.C01_For_any_one_Member_in_a_Family__c = '$120';
            gridobj.C01_For_an_entire_Family__c = '$120';
            gridobj.Tech_Date_Time__c = 'mmddyyyy';
            updateList.add(gridobj);
        }
        
        update updateList;
        
        updateList.clear();
        SHP_UpdateBenefitGridAuditandMetadata.isAfterUpdate = true;
        for(SHP_Benefit_Grid__c gridobj : benefitGrid){
            gridobj.C01_For_any_one_Member_in_a_Family__c = '$130';
            gridobj.C01_For_an_entire_Family__c = '$130';
            gridobj.Tech_Date_Time__c = 'mmddyyyy';
            updateList.add(gridobj);
        }
        
        update updateList;
        updateList.clear();
        SHP_UpdateBenefitGridAuditandMetadata.isAfterUpdate = true;
        for(SHP_Benefit_Grid__c gridobj : benefitGrid){
            gridobj.C01_For_any_one_Member_in_a_Family__c = '$140';
            gridobj.C01_For_an_entire_Family__c = '$140';
            gridobj.Tech_Date_Time__c = '';
            updateList.add(gridobj);
        }
        
        update updateList;
        updateList.clear();
        SHP_UpdateBenefitGridAuditandMetadata.isAfterUpdate = true;
        for(SHP_Benefit_Grid__c gridobj : benefitGrid){
            gridobj.C01_For_any_one_Member_in_a_Family__c = '$130';
            gridobj.C01_For_an_entire_Family__c = '$130';
            gridobj.Tech_Date_Time__c = 'mmddyyyy';
            updateList.add(gridobj);
        }
        
        update updateList;
        
    }
}