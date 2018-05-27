/**
 * Class Name  : HighRoads_ProposalTriggerHelper
 * Description : 1. To create a Sold Sign Off on Proposal approval.
 *               2. To check the mandatory fields before approving the Proposal these fields are required while creating the Sold Sign Off.
 *               3. To check the atleast one attachment exists for the Proposal before submtting for approval
 *               4. To Create one more proposal if the existing proposal is rejected.
 * Created Date: 12/8/2016
 * Created By  : IDC offshore
 **/
public class HighRoads_ProposalTriggerHelper {
    //to avoid recursion
    public static boolean isBeforeUpdate = true;
    public static boolean isAfterUpdate = true;
    /**
     * Method Name : checkMandatoryBeforeSubmit
     * Description : To check the mandatory fields before approving the Proposal these fields are required while creating the Sold Sign Off.
     *               To check the atleast one attachment exists for the Proposal before submtting for approval
     *               To Create one more proposal if the existing proposal is rejected.
     *               To create a Sold Sign Off on Proposal approval.
     * Parameters  : Map<ID,Proposal__c> newMap,Map<ID,Proposal__c> oldMap
     * Return type : void
     **/
    public void checkMandatoryBeforeSubmit(Map<ID,Proposal__c> newMap,Map<ID,Proposal__c> oldMap){
        Set<ID> submittedQuotes = new Set<ID>();
        Map<ID,ID> attachmentQuoteMap = new Map<ID,ID>();
        Set<ID> rejectedQuoteRFPIds = new Set<ID>();
        Set<ID> approvedQuoteIds = new Set<ID>();
        //Fecting all the attachments for the proposals
        for(Attachment attObj : [select id,ParentId from Attachment where ParentId IN :newMap.keySet()]){
            attachmentQuoteMap.put(attObj.ParentId, attObj.Id);
        }
        
        for(Proposal__c quote : newMap.Values()){
            if(oldMap.get(quote.id).Stage__c != newMap.get(quote.id).Stage__c &&
               quote.Stage__c.equalsIgnoreCase(System.Label.HR76_ApprovedbySales)){
                   if(quote.Opportunity_Stage__c == System.Label.CL_35_SM_ClosedWon){
                       approvedQuoteIds.add(quote.Id);
                   }else{
                       quote.addError(System.Label.HR189_OppClosedWonORNot);
                   }
                   quote.Is_Child_Record_Created__c = true;
               }else if(oldMap.get(quote.id).Stage__c != newMap.get(quote.id).Stage__c &&
               quote.Stage__c.equalsIgnoreCase(System.Label.HR213_SubmittedtoSales)){
                   //If there no attachment for the proposal, throwing error message to add the attachmetns
                   if(attachmentQuoteMap.get(quote.Id) == NULL){
                       newMap.get(quote.Id).addError(System.Label.HR214_QuoteAttachmentMandatoryBeforeSubmitting);
                   }
               }else if(oldMap.get(quote.id).Stage__c != newMap.get(quote.id).Stage__c &&
                        quote.Stage__c.equalsIgnoreCase(System.Label.HR191_RejectedBySales)){
                            rejectedQuoteRFPIds.add(quote.RFP_Form__c);
                }
        }
        
        for(Proposal__c quote : [select ID,Opportunity_ID__r.RFP_Due_Date__c,Opportunity_ID__r.of_Subscribers__c , 
                                 Opportunity_ID__r.Additional_Buy_Ups__c , Opportunity_ID__r.Plan_Effective_Date__c ,
                                 Opportunity_ID__r.NTE_Offered__c,Stage__c from Proposal__c where id IN:newMap.keySet() ]){
                                     if(quote.Opportunity_ID__r.RFP_Due_Date__c == NULL){
                                         newMap.get(quote.Id).addError(System.Label.HR206_RFPDueDateMandatory);
                                     }else if(quote.Opportunity_ID__r.of_Subscribers__c == NULL){
                                         newMap.get(quote.Id).addError(System.Label.HR205_NoOfSubscribersMandatory,false);
                                     }else if(quote.Opportunity_ID__r.Additional_Buy_Ups__c == NULL){
                                         newMap.get(quote.Id).addError(System.Label.HR207_ProposalScenarioMandatory);
                                     }else if(quote.Opportunity_ID__r.Plan_Effective_Date__c == NULL){
                                         newMap.get(quote.Id).addError(System.Label.HR208_PlanEffectiveDateMandatory);
                                     }
                                     //else if(quote.Opportunity_ID__r.NTE_Offered__c == NULL){
                                       //  newMap.get(quote.Id).addError(System.Label.HR209_NTEOfferedMandatory);
                                     //}
        }
        //To create a Sold Sign Off on Proposal approval.
        if(!approvedQuoteIds.isEmpty() && HighRoads_AutoCreateRecordsOnApproval.isQuoteAfterUpdate){
            HighRoads_AutoCreateRecordsOnApproval createSSOObj = new HighRoads_AutoCreateRecordsOnApproval();
            createSSOObj.createSSO(approvedQuoteIds);
            HighRoads_AutoCreateRecordsOnApproval.isQuoteAfterUpdate = false;
        }
        //To Create one more proposal if the existing proposal is rejected.
        if(!rejectedQuoteRFPIds.isEmpty() && HighRoads_AutoCreateRecordsOnApproval.isQuoteAfterUpdateRejected){
            HighRoads_AutoCreateRecordsOnApproval createQuoteObj = new HighRoads_AutoCreateRecordsOnApproval();
            createQuoteObj.createQuote(rejectedQuoteRFPIds);
            HighRoads_AutoCreateRecordsOnApproval.isQuoteAfterUpdateRejected = false;
        }
    }
}