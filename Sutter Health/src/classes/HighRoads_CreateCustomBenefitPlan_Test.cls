/**********************************************************************
Name: HighRoads_CreateCustomBenefitPlan_Test
Purpose: Test Class for HighRoads_RenewOpportunity Class

History
-------
VERSION         AUTHOR          DATE        DETAIL                  Description
1.0             offshore IDC    28-Nov-2016 INITIAL DEVELOPMENT     Test class covers the scenario of Renew opportunity.   
***********************************************************************/

@isTest 
private class HighRoads_CreateCustomBenefitPlan_Test{    
    
    /*******************************************************************
    Purpose: Custom Benefit plan controller.
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
     static testMethod void testInsertPlan() {
         Test.StartTest();
         /* loading the grid to metadata mapping custom setting from static resource */
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');

        List<SHP_Benefit_Grid__c> SHPBenefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        insert SHPBenefitGrid;
        
        List<Benefit_Plan_Metadata__c> BenefitPlanMetadata = HighRoads_TestDataUtility.insertBenefitPlanMetadata();
        insert benefitPlanMetadata; 
        
        Account acc = HighRoads_TestDataUtility.insertAccount();
        insert acc;
        Custom_Benefit_Plan__c customBenefitPlan = new Custom_Benefit_Plan__c(Name = 'AA04 - 2016 Custom',Benefit_Grid__c = SHPBenefitGrid[0].Id);
        
        //insert customBenefitPlan;
        PageReference pageRef = Page.HighRoads_CreateCustomPlan;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', acc.id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(customBenefitPlan);        
        HighRoads_CreateCustomBenefitPlan objCreateCustomBenefitPlan = new HighRoads_CreateCustomBenefitPlan(controller);
        objCreateCustomBenefitPlan.customPlanName = 'AA04 - 2016 Custom';
        
        PageReference p = objCreateCustomBenefitPlan.insertPlan();
        System.Assert(p != NULL);
        Test.StopTest();
     }
}