/**
 * Trigger Name : ProposalTrigger
 * Created Date : 11/16/2016
 * Description  : 1. To create/update the Benefit Plan Association with Proposal details
 * 				  2. To create a Sold Sign Off on Proposal approval.
 * 				  3. To check the mandatory fields before approving the Proposal these fields are required while creating the Sold Sign Off.
 * 				  4. To check the atleast one attachment exists for the Proposal before submtting for approval
 * 				  5. To Create one more proposal if the existing proposal is rejected.
 * Req No 		: 3890 SHP Wave 2 Changes
 **/
trigger ProposalTrigger on Proposal__c (after insert,before update) {
     /* Copy the plans from RFP while creating */
    if(Trigger.isInsert && Trigger.isAfter){
        Map<ID,ID> rfpProposalMap = new Map<ID,ID>();
        for(Proposal__c proposal : Trigger.New){
            rfpProposalMap.put(proposal.RFP_Form__c,proposal.id);
        }
        if(!rfpProposalMap.isEmpty() && HighRoads_CopyOppPlansToRFPANDSCN.isProposalAfterInsert){
            HighRoads_CopyOppPlansToRFPANDSCN rfp = new HighRoads_CopyOppPlansToRFPANDSCN();
            rfp.copyRFPPlansToProposal(rfpProposalMap);
            HighRoads_CopyOppPlansToRFPANDSCN.isProposalAfterInsert = false;
        }
        
    }
    /* check mandatory fields before approving the Proposal */
    if(Trigger.isUpdate && Trigger.isBefore){
        if(HighRoads_ProposalTriggerHelper.isBeforeUpdate){
            HighRoads_ProposalTriggerHelper proposalHelperObj = new HighRoads_ProposalTriggerHelper();
            proposalHelperObj.checkMandatoryBeforeSubmit(Trigger.NewMap, Trigger.OldMap);
            HighRoads_ProposalTriggerHelper.isBeforeUpdate = false;
        }
        
    }
}