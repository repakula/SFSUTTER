/**
 * Class Name  : RFP_IncumbentCarrierTriggerHelper
 * Description : 1 To create/update the Benefit Plan Association with RFP Form details
 * 				 2.To create a quote on RFP approval.
 * 				 3.To check the mandatory fields before submitting for approval 
 * Created By  : IDC offshore
 * Created Date : 12/8/2016
 **/
public class RFP_IncumbentCarrierTriggerHelper {
	public static boolean isAfterInsert = true;
    public static boolean isAfterUpdate = true;
    public static boolean isBeforeUpdate = true;
    /**
     * Method Name : copyPlansToProposal
     * Description : 1. Copy the plans from Opportunity while creating 
					 2. Updating the opportunity when rfp is created.
     * Parameters  : List<Incumbent_Carrier__c> newList
     * Return type : void
     * 
     **/
    public void copyPlansToProposal(List<Incumbent_Carrier__c> newList){
        Map<ID,ID> oppRFPMap = new Map<ID,ID>();
        List<Opportunity> rfpCreatedOppList = new List<Opportunity>();
        Id rfpRecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        for(Incumbent_Carrier__c rfp : newList){
            if(rfp.recordTypeId == rfpRecordTypeId){
                oppRFPMap.put(rfp.Opportunity__c,rfp.id);
                Opportunity opp = new Opportunity(id=rfp.Opportunity__c);
                opp.Is_Child_Record_Created__c = true;
                rfpCreatedOppList.add(opp);
            }
        }
        if(!oppRFPMap.isEmpty() && HighRoads_CopyOppPlansToRFPANDSCN.isRFPAfterInsert){
            HighRoads_CopyOppPlansToRFPANDSCN rfp = new HighRoads_CopyOppPlansToRFPANDSCN();
            rfp.copyOppPlansToRFP(oppRFPMap);
            HighRoads_CopyOppPlansToRFPANDSCN.isRFPAfterInsert = false;
        }
        
        if(rfpCreatedOppList != NULL && !rfpCreatedOppList.isEmpty()){
            Update rfpCreatedOppList;
        }
    }
    /**
     * Method Name : checkMandatoryFieldsforApproval
     * Description : 1. Check the mandatory fields while submitting for approval 
       				 2. Updating is child record creation field when rfp is approved.
     * Parameters  : Map<ID,Incumbent_Carrier__c> newMap,Map<ID,Incumbent_Carrier__c> oldMap
     * Return type : void
     * 
     **/
    public void checkMandatoryFieldsforApproval(Map<ID,Incumbent_Carrier__c> newMap,Map<ID,Incumbent_Carrier__c> oldMap){
        Id rfpRecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        for(Incumbent_Carrier__c rfp : newMap.values()){
            if(rfp.recordTypeId == rfpRecordTypeId && oldMap.get(rfp.id).Stage__c != newMap.get(rfp.id).Stage__c &&
               rfp.Stage__c.equalsIgnoreCase(System.Label.HR75_ApprovedbyUnderwriting)){
                   rfp.Is_Child_Record_Created__c = true;
               }
            if(rfp.recordTypeId == rfpRecordTypeId && oldMap.get(rfp.id).Stage__c != newMap.get(rfp.id).Stage__c &&
               rfp.Stage__c.equalsIgnoreCase(System.Label.HR85_Submitted_to_Underwriting)){
                   if( String.isBlank(String.valueOf(rfp.No_of_Quotes_Requested__c) )){
                       rfp.addError(System.Label.HR183_NoOfQuotesMandatory);
                   }else if(String.isBlank(rfp.Reason_for_Market_Check__c )){
                       rfp.addError(System.Label.HR184_ReasonForMarketMandatory);
                       
                   }else if(String.isBlank(rfp.Tiered_Rates__c)){
                       rfp.addError(System.Label.HR185_TieredRatesMandatory);
                      
                   }else if(String.isBlank(rfp.Strategy_Statement__c)){
                       rfp.addError(System.Label.HR186_StrategyStatementMandatory);
                      
                   }else if(String.isBlank(rfp.Special_Instuctions__c)){
                       rfp.addError(System.Label.HR187_SepcialInstructionsMandatory);
                   } 
            }
        }
    }
    /**
     * Method Name : createProposalOnApproval
     * Description : 1. To create quote on approval of RFP 
	 *				 2. Calling helper method to create Proposal on approval of RFP
     * Parameters  : Map<ID,Incumbent_Carrier__c> newMap,Map<ID,Incumbent_Carrier__c> oldMap
     * Return type : void
     * 
     **/
    public void createProposalOnApproval(Map<ID,Incumbent_Carrier__c> newMap,Map<ID,Incumbent_Carrier__c> oldMap){
        Id rfpRecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        Set<ID> rfpIds = new Set<ID>();
        for(Incumbent_Carrier__c rfp : newMap.values()){
            if(rfp.recordTypeId == rfpRecordTypeId && oldMap.get(rfp.id).Stage__c != newMap.get(rfp.id).Stage__c &&
               rfp.Stage__c.equalsIgnoreCase(System.Label.HR75_ApprovedbyUnderwriting)){
                   rfpIds.add(rfp.Id);
               }     
        }
        if(!rfpIds.isEmpty()){
            HighRoads_AutoCreateRecordsOnApproval createQuoteObj = new HighRoads_AutoCreateRecordsOnApproval();
            createQuoteObj.createQuote(rfpIds);
        }
    }
}