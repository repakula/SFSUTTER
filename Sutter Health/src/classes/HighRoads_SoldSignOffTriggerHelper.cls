/**
 * Class Name  : HighRoads_SoldSignOffTriggerHelper
 * Description : 1. To create/update the Benefit Plan Association with Sold Sign Off details
 *               2. To create a Sold Case Notification on Sold Sign Off approval.
 *               3. Checking the rates for sold sign off before submitting for approval. If the rates are not available for any of the 
 *                  the plan before submitting for approval, error will be thrown.
 *               4. Checking atleast one attachment is there or not for Sold Sign Off before submitting for approval.
 * Created Date: 12/8/2016
 * Created By  : IDC offshore
 **/
public class HighRoads_SoldSignOffTriggerHelper {
    public static boolean isAfterInsert = true;
    public static boolean isBeforeUpdate = true;
    /**
     * Method Name : copyPlansFromProposal
     * Description : To create/update the Benefit Plan Association with Sold Sign Off details
     * Return type : void
     * Parameters  : List<Sold_Sign_Off__c> newList
     * 
     **/
    public void copyPlansFromProposal(List<Sold_Sign_Off__c> newList){
        Map<ID,ID> proposalSSOMap = new Map<ID,ID>();
        for(Sold_Sign_Off__c ssoObj : newList){
            proposalSSOMap.put(ssoObj.Quote__c,ssoObj.id);
        }
        if(!proposalSSOMap.isEmpty() && HighRoads_CopyOppPlansToRFPANDSCN.isSSOAfterInsert){
            HighRoads_CopyOppPlansToRFPANDSCN ssoObj = new HighRoads_CopyOppPlansToRFPANDSCN();
            ssoObj.copyProposalPlansToSSO(proposalSSOMap);
            HighRoads_CopyOppPlansToRFPANDSCN.isSSOAfterInsert = false;
        }
    }
    /**
     * Method Name : checkRates_CreateDGR
     * Description : 1. To create a Sold Case Notification on Sold Sign Off approval.
     *               2. Checking the rates for sold sign off before submitting for approval. If the rates are not available for any of the 
     *                  the plan before submitting for approval, error will be thrown.
     *               3. Checking atleast one attachment is there or not for Sold Sign Off before submitting for approval.
     * Return type : void
     * Parameters  : List<Sold_Sign_Off__c> newList
     * 
     **/
    public void checkRates_CreateDGR(Map<ID,Sold_Sign_Off__c> newMap,Map<ID,Sold_Sign_Off__c> oldMap){
        Set<ID> docGenReqSSOIds = new Set<ID>(); // set to store the ids to create document generation request
        Set<ID> oppClosedWonSSOIds = new Set<ID>(); // set to store the ids to create sold case notification
        Map<String,SF_P2A_Market_Segments_Mapping__c> groups = SF_P2A_Market_Segments_Mapping__c.getAll();
        Map<ID,ID> attachmentSSOMap = new Map<ID,ID>();
        Map<ID,Sold_Sign_Off__c> ssoIDMap = new Map<ID,Sold_Sign_Off__c>();
        for(Attachment attObj : [select id,ParentId from Attachment where ParentId IN :newMap.keySet()]){
            attachmentSSOMap.put(attObj.ParentId, attObj.Id);
        }
        for(Sold_Sign_Off__c ssoObj : newMap.values()){
            SF_P2A_Market_Segments_Mapping__c grp = groups.get(ssoObj.Employer_Type__c);
            
            if(oldMap.get(ssoObj.id).Stage__c != newMap.get(ssoObj.id).Stage__c &&
               ssoObj.Stage__c.equalsIgnoreCase(System.Label.HR75_ApprovedbyUnderwriting)){
                   if(ssoObj.Opportunity_Stage_Name__c.equalsIgnoreCase(System.Label.HR79_ClosedWon)){
                       oppClosedWonSSOIds.add(ssoObj.Id);
                       ssoObj.Approved_Date__c = System.now().addMinutes(-58);
                   }else{
                       ssoObj.addError(System.Label.HR190_SCNForClosedWonOpp);
                   }
                   ssoObj.Is_Child_Record_Created__c = true;
                   if(grp != NULL && System.label.HR02_MarketSegment_LG.equalsIgnoreCase(grp.P2A_Market_Segment__c)){
                       docGenReqSSOIds.add(ssoObj.Id); 
                   }
               }
            if(oldMap.get(ssoObj.id).Stage__c != newMap.get(ssoObj.id).Stage__c &&
               ssoObj.Stage__c.equalsIgnoreCase(System.Label.HR75_ApprovedbyUnderwriting)){
                   ssoIDMap.put(ssoObj.Id,ssoObj);
                   if(attachmentSSOMap.get(ssoObj.Id) == NULL){
                       ssoObj.addError(System.Label.HR215_SSOAttachmentMandatoryBeforeSubmitting);
                   }
               }
        }
        if(HighRoads_DocGenRequest.isOpportunityAfterUpdate && !docGenReqSSOIds.isEmpty()){
            HighRoads_DocGenRequest.insertDocGenRequests(docGenReqSSOIds);
            HighRoads_DocGenRequest.isOpportunityAfterUpdate = false;
        }
        
        if(ssoIDMap != NULL && !ssoIDMap.isEmpty()){
            HighRoads_AutoCreateRecordsOnApproval checkRatesForPlanObj = new HighRoads_AutoCreateRecordsOnApproval();
            checkRatesForPlanObj.checkAllRatesForSSO(ssoIDMap);
        }
        if(!oppClosedWonSSOIds.isEmpty()){
            HighRoads_AutoCreateRecordsOnApproval createSCNObj = new HighRoads_AutoCreateRecordsOnApproval();
            createSCNObj.createSCN(oppClosedWonSSOIds);
        }
    }
}