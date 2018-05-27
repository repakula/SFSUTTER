/* 
     Class Name: CreateBenefitPlanInMetadata_Test 
     Author: IDC Offshore
     Date: 06-Dec-2016
     Description: Test class for CreateBenefitPlanInMetadata Trigger.
*/
@isTest
private class CreateBenefitPlanInMetadata_Test {
	private static testMethod void testCustomBenefitPlanAproval(){  
        Test.StartTest();
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        
        List<SHP_Benefit_Grid__c> SHPBenefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        insert SHPBenefitGrid;
        
        Account acc = HighRoads_TestDataUtility.insertAccount();
        insert acc;
        
        Custom_Benefit_Plan__c cplan = new Custom_Benefit_Plan__c();
        cplan.Name = 'Test Custom Plan';
        cplan.Benefit_Grid__c = SHPBenefitGrid[0].id;
        cplan.Plan_Related_to_Account__c = acc.id;
        insert cplan;
        
        cplan.Plan_Status__c = 'Soft Approved';
        update cplan;
        
        cplan.Inpatient__c = '20$';
        update cplan;
        
        cplan.Plan_Status__c = 'Available for Sale - Approved';
        update cplan;
        
      	Test.StopTest();
    }
}