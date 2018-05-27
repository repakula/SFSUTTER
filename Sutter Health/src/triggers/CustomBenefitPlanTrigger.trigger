/********************************************************************************************************************
    Trigger Name: CreateBenefitPlanInMetadata
    Author: IDC Offshore
    Date: 26-Sep-2016
    Description: To create record in Benefit Plan Metadata once the Benefit Plan QA team approves the custom benefit plan
    			 Updating the Benefit Plan Metadata record whenever the Custom Benefit Plan is Updated.
				 Updating the summary of changes in Custom Benefit Plan Record whenever data is changed in record.
    History:
    VERSION    AUTHOR              DATE       DETAIL 
    1.0        IDC-Offshore      26-9-2016    To create record in Benefit Plan Metadata once 
                                               the Benefit Plan QA team approves the custom benefit plan as part of 3880 request.
***********************************************************************************************************************/
trigger CustomBenefitPlanTrigger on Custom_Benefit_Plan__c (before insert,after update,before update) {
    //To update the custom benefit plan details based on the selected benefit metadata
    if(Trigger.isInsert && Trigger.isBefore){
        new HighRoads_CreateBenefitPlanHelper().updateCustomPlanRecord(Trigger.New);
    }
    //To insert the record in Benefit Plan Metadata object based on the custom benefit plan status i.e. soft approved
    if(Trigger.isUpdate && Trigger.isAfter){
        Set<ID> customPlanIds = new Set<ID>();
        Set<ID> updatedCustomPlanIds = new Set<ID>();
        Set<ID> softApprovedIds = new Set<ID>();
        for(Custom_Benefit_Plan__c customPlan : Trigger.New){
            //Checking the old and new value
            //Checking the plan status - if the plan status is approved from QA team then adding to set and 
            //calling helper method to create Benefit Plan Metadata record.
            if(Trigger.newMap.get(customPlan.id).plan_status__c != Trigger.oldMap.get(customPlan.id).plan_status__c
               && customPlan.plan_status__c == System.Label.HR81_CustomBenefitPlan_Approval){
                 customPlanIds.add(customPlan.id);
             }
            // If the custom benefit plan is final approved, taking the id into updatedCustomPlanIds set which will be passed to
            // helper method to update Benefit Plan Metadata record.
            if(Trigger.newMap.get(customPlan.id).plan_status__c != Trigger.oldMap.get(customPlan.id).plan_status__c
             && customPlan.plan_status__c == System.Label.HR110_ApprovedForSale){
                 updatedCustomPlanIds.add(customPlan.id);
             }
            // If the custom benefit plan is final approved, taking the id into updatedCustomPlanIds set which will be passed to
            // helper method to update Benefit Plan Metadata record when the custom benefit plan is soft approved.
            if(Trigger.newMap.get(customPlan.id).plan_status__c == Trigger.oldMap.get(customPlan.id).plan_status__c && 
               customPlan.Plan_Status__c == System.Label.HR81_CustomBenefitPlan_Approval){
                softApprovedIds.add(customPlan.id);
            }
    }
        //to avoid recursion 
        if(HighRoads_CreateBenefitPlanHelper.isAfterUpdate ){
            //customPlanIds is not empty - calling helper method to create benefit plan metadata records.
            if(!customPlanIds.isEmpty()){
                new HighRoads_CreateBenefitPlanHelper().createMetadataRecord(customPlanIds);
            }
            //updatedCustomPlanIds is not empty - calling helper method to update benefit plan metadata records.
            if(!updatedCustomPlanIds.isEmpty()){
                new HighRoads_CreateBenefitPlanHelper().updateMetadataRecord(updatedCustomPlanIds);
            }
            //softApprovedIds is not empty - calling helper method to update benefit plan metadata records.
            if(!softApprovedIds.isEmpty()){
            	new HighRoads_CreateBenefitPlanHelper().updateMetadataRecord(softApprovedIds);
            }
            HighRoads_CreateBenefitPlanHelper.isAfterUpdate = false;
        }
    	 
    }
    // Helper method - to update summary of changes
    if(Trigger.isBefore && Trigger.isUpdate){
        if(HighRoads_CreateBenefitPlanHelper.isBeforeUpdate){
            HighRoads_CreateBenefitPlanHelper helperObj = new HighRoads_CreateBenefitPlanHelper();
            helperObj.updateSummaryOfChanges(Trigger.New, Trigger.OldMap);
            HighRoads_CreateBenefitPlanHelper.isBeforeUpdate = false;
        }
    }
}