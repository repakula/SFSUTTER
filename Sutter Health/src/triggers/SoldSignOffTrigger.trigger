/**
 * Trigger Name : SoldSignOffTrigger
 * Created Date : 11/16/2016
 * Description  : 1. To create/update the Benefit Plan Association with Sold Sign Off details
 *                2. To create a Sold Case Notification on Sold Sign Off approval.
 *                3. Checking the rates for sold sign off before submitting for approval. If the rates are not available for any of the 
 *                  the plan before submitting for approval, error will be thrown.
 *                4. Checking atleast one attachment is there or not for Sold Sign Off before submitting for approval.
 * Req No       : 3890 SHP Wave 2 Changes
 **/
trigger SoldSignOffTrigger on Sold_Sign_Off__c (after insert,before update) {
     /* Copy the plans from Quote while creating */   
    if(Trigger.isInsert && Trigger.isAfter){
        if(HighRoads_SoldSignOffTriggerHelper.isAfterInsert){
            HighRoads_SoldSignOffTriggerHelper soldSignOffHelperObj = new HighRoads_SoldSignOffTriggerHelper();
            soldSignOffHelperObj.copyPlansFromProposal(Trigger.New);
            HighRoads_SoldSignOffTriggerHelper.isAfterInsert = false;
        }
    } 
    /* Check the rates and attachment before submitting for appval */   
    if(Trigger.isUpdate && Trigger.isBefore){
        if(HighRoads_SoldSignOffTriggerHelper.isBeforeUpdate){
            HighRoads_SoldSignOffTriggerHelper soldSignOffHelperObj = new HighRoads_SoldSignOffTriggerHelper();
            soldSignOffHelperObj.checkRates_CreateDGR(Trigger.NewMap,Trigger.OldMap);
            HighRoads_SoldSignOffTriggerHelper.isBeforeUpdate = false;
        }
    }
     
}