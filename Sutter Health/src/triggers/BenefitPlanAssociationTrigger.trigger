/**
* trigger Name  : BenefitPlanAssociationTrigger
* Description   : This trigger is common for all Sales Cycle objects like Opportunity,RFP,Quote,SSO,SCN. Used in the below scenarios.
                    1. To Delete the rates for a benefit plan from Rates object when the plan is removed from Opportunity/RFP/Quote/SSO/SCN.
                    2. To Create new Rate Card in the below stages whenever a Benefit Plan is Added/Removed comparing with Parent object.
                    (If Opportunity contains ML01 -> Rate Card -> RC-01 
                    When RFP is created  ML01 -> Rate Card -> RC-01, if any plan is selected/removed at RFP new rate card will be created
                    ML01 -> Ml02 -> RC-02 to keep track of the rates in each stage and each plan.
                    It will apply for all objects like from Opportunity -> RFP, RFP-> Quote , Quote -> SSO, SSO -> SCN or Opportunity -> SCN for small group)
* Created Date : 12/8/2016
* Created By   : IDC Offshore
* Req No 	   : 3980
**/
trigger BenefitPlanAssociationTrigger on Benefit_Plan_Association__c (after insert,after update) {
    //If any benefit plan is removed, calling helper class to delete rates for that plan.
    if(Trigger.isAfter && Trigger.isUpdate){   
        if(HighRoads_BenefitPlanAssociationHelper.isBPAAfterUpdate){
            HighRoads_BenefitPlanAssociationHelper associationObj = new HighRoads_BenefitPlanAssociationHelper();
            associationObj.createOrDeleteRates(Trigger.NewMap, Trigger.OldMap);
                HighRoads_BenefitPlanAssociationHelper.isBPAAfterUpdate = false;
        }
    }
    //If any benefit plan is created, calling helper class to create rate cards and update them with parent
    if(Trigger.isAfter && Trigger.isInsert){
        if(HighRoads_BenefitPlanAssociationHelper.isBPAAfterInsert){
            HighRoads_BenefitPlanAssociationHelper associationObj = new HighRoads_BenefitPlanAssociationHelper();
            associationObj.createRatesforNewPlans(Trigger.New);
                HighRoads_BenefitPlanAssociationHelper.isBPAAfterInsert = false;
        }
    }
}