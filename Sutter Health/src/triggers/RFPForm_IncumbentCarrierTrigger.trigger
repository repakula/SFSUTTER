/**
 * Trigger Name : RFPForm_IncumbentCarrierTrigger
 * Created Date : 11/16/2016
 * Description  : 1. To create/update the Benefit Plan Association with RFP Form details
 * 				  2. To create a quote on RFP approval.
 * 				  3. To check the mandatory fields before submitting for approval 
 * Req No 		: 3890 SHP Wave 2 Changes
 **/
trigger RFPForm_IncumbentCarrierTrigger on Incumbent_Carrier__c (After Insert,Before Update,After update) {
    /* Copy the plans from Opportunity while creating 
	   updating the opportunity when rfp is created. */
    if(Trigger.isInsert && Trigger.isAfter){
        if(RFP_IncumbentCarrierTriggerHelper.isAfterInsert){
            RFP_IncumbentCarrierTriggerHelper rfpFormHelperObj = new RFP_IncumbentCarrierTriggerHelper();
            rfpFormHelperObj.copyPlansToProposal(Trigger.New);
            RFP_IncumbentCarrierTriggerHelper.isAfterInsert = false;
        }
        
    }
    /* Check the mandatory fields while submitting for approval 
       Updating is child record creation field when rfp is approved.*/
    if(Trigger.isUpdate && Trigger.isBefore){
        if(RFP_IncumbentCarrierTriggerHelper.isBeforeUpdate){
            RFP_IncumbentCarrierTriggerHelper rfpFormHelperObj = new RFP_IncumbentCarrierTriggerHelper();
            rfpFormHelperObj.checkMandatoryFieldsforApproval(Trigger.NewMap,Trigger.OldMap);
            RFP_IncumbentCarrierTriggerHelper.isBeforeUpdate = false;
        }
    }
    /* To create quote on approval of RFP 
		Calling helper method to create Proposal on approval of RFP*/
    if(Trigger.isUpdate && Trigger.isAfter){
        if(RFP_IncumbentCarrierTriggerHelper.isAfterUpdate){
            RFP_IncumbentCarrierTriggerHelper rfpFormHelperObj = new RFP_IncumbentCarrierTriggerHelper();
            rfpFormHelperObj.createProposalOnApproval(Trigger.NewMap,Trigger.OldMap);
            RFP_IncumbentCarrierTriggerHelper.isAfterUpdate = false;
        }
        
    }
    
}