/* 
Class Name: HighRoads_CreateBenefitPlanHelper_Test 
     Author: Deloitte
     Date: 19-4-2017
     Description: Test class for HighRoads_CreateBenefitPlanHelper Apex class and setGridOfbenefitPlan Trigger.
*/
@isTest
public class HighRoads_CreateBenefitPlanHelper_Test {
   private testMethod static void customplanrecordUpdate(){
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
        
        List<custom_Benefit_Plan__c> cbpList = new List<custom_Benefit_Plan__c>();
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
        cbp.Plan_Status__c = 'New';
        cbp.Plan_Year__c = string.valueOf(system.today().year());
        cbp.Plan_Related_to_Account__c = acc.Id;
        cbp.Benefit_Grid__c = benefitGrid[0].Id;
        cbp.Remarks__c = 'test';
        cbp.IsActivelyMarketed__c = false;
       
        cbpList.add(cbp);
        //insert cbp;
        custom_Benefit_Plan__c cbp2 = new custom_Benefit_Plan__c();
        cbp2.Name = 'HE03 - Custom - 2016';
        cbp2.Medical_OR_Rider__c = 'Medical';
        cbp2.Product_Class__c = 'Medical';
        cbp2.Effective_Date__c = System.today();
        cbp2.End_Date__c = system.today()+360;
        cbp2.Market_Segment__c = 'Large Group';
        cbp2.Plan_Type__c = 'Custom';
        cbp2.Ancillary_EOC__c = false;
        cbp2.Ancillary_GSA__c = false;
        cbp2.Ancillary_SOB__c = false;
        cbp2.EOC__c = true;
        cbp2.BCM__c = true;
        cbp2.SBC__c = true;
        cbp2.IsCustom__c = true;
        cbp2.Benefit_Plan_ID__c = 'HE02 - Custom';
        cbp2.Plan_Status__c = 'New';
        cbp2.Plan_Year__c = string.valueOf(system.today().year());
        cbp2.Plan_Related_to_Account__c = acc.Id;
        cbp2.Benefit_Grid__c = benefitGrid[0].Id;
        cbp2.Remarks__c = 'test';
        cbp2.IsActivelyMarketed__c = false;
       
        cbpList.add(cbp2);
        insert cbp2;
        //List<Benefit_Plan_Metadata__c> bpObj = new List<Benefit_Plan_Metadata__c>();
        //insert bpObj;
        //List<Benefit_Plan_Metadata__c> benefitMetdataList = [select Id,Custom_Benefit_Plan_ID__c from Benefit_Plan_Metadata__c where Custom_Benefit_Plan_ID__c IN :cbp.Id];
        List<Custom_Benefit_Plan__c> customPlanList = new List<Custom_Benefit_Plan__c>() ;
        HighRoads_CreateBenefitPlanHelper hcbp = new HighRoads_CreateBenefitPlanHelper();
        hcbp.updateCustomPlanRecord(customPlanList);
        Map<Id, custom_Benefit_Plan__c> cbpMap = new Map<Id, custom_Benefit_Plan__c>(); 
            for(custom_Benefit_Plan__c cbp1 : [Select Id From custom_Benefit_Plan__c]){
                cbpMap.put(cbp1.Id, cbp1);
            }
        hcbp.updateSummaryOfChanges(customPlanList, cbpMap);
        insert customPlanList;
        Set<ID> updatedCustomPlanIds = new Set<ID>();
        Set<ID> customPlanIds = new Set<ID>();
        Set<ID> approvedCustomPlanIds = new Set<ID>();
        for(custom_Benefit_Plan__c cpId : cbpList){
            updatedCustomPlanIds.add(cpId.Id);
            customPlanIds.add(cpId.Id);
            approvedCustomPlanIds.add(cpId.Id);
        }
        hcbp.updateMetadataRecord(updatedCustomPlanIds);
        hcbp.createMetadataRecord(approvedCustomPlanIds);
        
        update benefitGrid;
    }
}