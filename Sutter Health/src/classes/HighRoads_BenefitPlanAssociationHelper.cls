/** Class Name   : HighRoads_BenefitPlanAssociationHelper
 *  Description  : Helper class for Benefit Plan Association trigger.
 * 				   Used to create/delete rates for the selected/unselected plans
 *  Created Date : 12/08/2016
 *  Created By   : IDC Offshore
 * 	Req No 	     : 3980
 **/
public class HighRoads_BenefitPlanAssociationHelper {
    //to avoid recursion
	public static boolean isBPAAfterUpdate = true;
    public static boolean isBPAAfterInsert = true;
    /** Method Name : createOrDeleteRates
     *  Parameters  : Map<ID,Benefit_Plan_Association__c> newMap,Map<ID,Benefit_Plan_Association__c> oldMap
     *  Description :   1. To Delete the rates for a benefit plan from Rates object when the plan is removed from Opportunity/RFP/Quote/SSO/SCN.
                        2. To Create new Rate Card in the below stages whenever a Benefit Plan is Added/Removed comparing with Parent object.
                        (If Opportunity contains ML01 -> Rate Card -> RC-01 
                        When RFP is created  ML01 -> Rate Card -> RC-01, if any plan is selected/removed at RFP new rate card will be created
                        ML01 -> Ml02 -> RC-02 to keep track of the rates in each stage and each plan.
                        It will apply for all objects like from Opportunity -> RFP, RFP-> Quote , Quote -> SSO, SSO -> SCN or Opportunity -> SCN for small group)
		Return type : void
     **/
     
    public void createOrDeleteRates(Map<ID,Benefit_Plan_Association__c> newMap,Map<ID,Benefit_Plan_Association__c> oldMap){
        //The set of records in rates will be deleted based on the unselected plans values
        Set<String> unSelectedPlans = new Set<String>(); //Set used to capture the unselected plan ids in child but that plan is in the parent
        Set<String> unSelectedPlansinChild = new Set<String>(); //Set used to capture the unselected plans in the child only.
        Set<String> createRateCardPlans = new Set<String>(); // Set used to capture the unselected plans to create new rate card and rates when ever the parent and child rate cards are same.
        String objectType = HighRoads_Constants.BLANK_VALUE;
        for(Benefit_Plan_Association__c bpaObj : newMap.values()){
            //Comparing the Parent and Child rate cards are same and any plan is removed from the child
            if(newMap.get(bpaObj.id).Opportunity__c != oldMap.get(bpaObj.id).Opportunity__c && 
               bpaObj.Opportunity__c == NULL && bpaObj.Opportunity_Rate_Card__c != NULL){
                   objectType = HighRoads_Constants.OPPOBJNAME;
                   unSelectedPlans.add(bpaObj.Id);
               }else if(newMap.get(bpaObj.id).RFP_Form__c != oldMap.get(bpaObj.id).RFP_Form__c && 
                        bpaObj.RFP_Form__c == NULL && bpaObj.RFP_Rate_Card__c != NULL){
                            objectType = HighRoads_Constants.RFPOBJNAME;
                            if(bpaObj.Opportunity_Rate_Card__c != bpaObj.RFP_Rate_Card__c){
                                unSelectedPlans.add(bpaObj.Id);
                            }else{
                                createRateCardPlans.add(oldMap.get(bpaObj.id).RFP_Form__c);
                                unSelectedPlansinChild.add(bpaObj.Id);
                            }
                        }else if(newMap.get(bpaObj.id).Proposal__c != oldMap.get(bpaObj.id).Proposal__c && 
                                 bpaObj.Proposal__c == NULL && bpaObj.Quote_Rate_Card__c != NULL ){
                                     objectType = HighRoads_Constants.QUOTEOBJNAME;
                                     if(bpaObj.RFP_Rate_Card__c != bpaObj.Quote_Rate_Card__c){
                                         unSelectedPlans.add(bpaObj.Id);
                                     }else{
                                         createRateCardPlans.add(oldMap.get(bpaObj.id).Proposal__c);
                                         unSelectedPlansinChild.add(bpaObj.Id);
                                     }
                                     
                                 }else if(newMap.get(bpaObj.id).Sold_Sign_Off__c != oldMap.get(bpaObj.id).Sold_Sign_Off__c && 
                                          bpaObj.Sold_Sign_Off__c == NULL && bpaObj.SSO_Rate_Card__c != NULL ){
                                              objectType = HighRoads_Constants.SSOOBJNAME;
                                              if(bpaObj.Quote_Rate_Card__c != bpaObj.SSO_Rate_Card__c){
                                                  unSelectedPlans.add(bpaObj.Id);
                                              }else{
                                                  createRateCardPlans.add(oldMap.get(bpaObj.id).Sold_Sign_Off__c);
                                                  unSelectedPlansinChild.add(bpaObj.Id);
                                              }
                                          }else if(newMap.get(bpaObj.id).Sold_Case_Notification__c != oldMap.get(bpaObj.id).Sold_Case_Notification__c && 
                                                   bpaObj.Sold_Case_Notification__c == NULL && bpaObj.SCN_Rate_Card__c != NULL ){
                                                       objectType = HighRoads_Constants.SCNOBJNAME;
                                                       if(bpaObj.SSO_Rate_Card__c != bpaObj.SCN_Rate_Card__c 
                                                          && bpaObj.Opportunity_Rate_Card__c != bpaObj.SCN_Rate_Card__c){
                                                              unSelectedPlans.add(bpaObj.Id);
                                                          }else{
                                                              createRateCardPlans.add(oldMap.get(bpaObj.id).Sold_Case_Notification__c);
                                                              unSelectedPlansinChild.add(bpaObj.Id);
                                                          }
                                                   }
        }   
        if(unSelectedPlans != NULL && !unSelectedPlans.isEmpty() && HighRoads_CreateDeleteRatesForPlans.isAfterUpdateDeleteRates){
            HighRoads_CreateDeleteRatesForPlans deleteRateObj = new HighRoads_CreateDeleteRatesForPlans();
            deleteRateObj.deleteRates(unSelectedPlans,objectType);
            HighRoads_CreateDeleteRatesForPlans.isAfterUpdateDeleteRates = false;
        }
        if(createRateCardPlans != NULL && !createRateCardPlans.isEmpty() && HighRoads_CreateDeleteRatesForPlans.isAfterUpdateCreateRates){
            HighRoads_CreateDeleteRatesForPlans createRateObj = new HighRoads_CreateDeleteRatesForPlans();
            createRateObj.createRates(createRateCardPlans, objectType,unSelectedPlansinChild);
            HighRoads_CreateDeleteRatesForPlans.isAfterUpdateCreateRates = false;
        }
    }
    
    /**
     * Method Name : createRatesforNewPlans
     * Description : Block of code to handle the new plan insertion
                     If the plan is not selected at parent but selected child level
                     then create new rate card for child assign to all plans in child as the new plan is inserted
	 * Return type  : void
	 * Parameters  : List<Benefit_Plan_Association__c> newList
	**/
    public void createRatesforNewPlans(List<Benefit_Plan_Association__c> newList){
        Set<String> newPlanParentIds = new Set<String>();
        String objectType = HighRoads_Constants.BLANK_VALUE;
        for(Benefit_Plan_Association__c bpaObj : newList){
            if(bpaObj.RFP_Form__c != NULL ){
                newPlanParentIds.add(bpaObj.RFP_Form__c);
                objectType = HighRoads_Constants.RFPOBJNAME;
            }else if(bpaObj.Proposal__c != NULL){
                newPlanParentIds.add(bpaObj.Proposal__c);
                objectType = HighRoads_Constants.QUOTEOBJNAME;
            }else if(bpaObj.Sold_Sign_Off__c != NULL){
                newPlanParentIds.add(bpaObj.Sold_Sign_Off__c);
                objectType = HighRoads_Constants.SSOOBJNAME;
            }else if(bpaObj.Sold_Case_Notification__c != NULL){
                newPlanParentIds.add(bpaObj.Sold_Case_Notification__c);
                objectType = HighRoads_Constants.SCNOBJNAME;
            }
        }
        if(newPlanParentIds != NULL && !newPlanParentIds.isEmpty() && HighRoads_CreateDeleteRatesForPlans.isAfterInsertCreateRates){
            HighRoads_CreateDeleteRatesForPlans createRateObj = new HighRoads_CreateDeleteRatesForPlans();
            createRateObj.createRates(newPlanParentIds, objectType,null);
            HighRoads_CreateDeleteRatesForPlans.isAfterInsertCreateRates = false;
        }

    }
}