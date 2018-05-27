/******************************************************************************************************************* 
Class Name : HighRoads_CreateDeleteRatesForPlans 
Author	    : IDC Offshore
Date       : 10/3/2016
Description: This is a helper class for BenefitPlanAssociation trigger.
Used to create or delete rates based on the plan selection / de selection.
History:
VERSION    AUTHOR              DATE        DETAIL 
1.0        IDC-Offshore      10/3/2016     This is used to insert / delete rates if user enters/removes plan(s)
*******************************************************************************************************************/
public class HighRoads_CreateDeleteRatesForPlans {
    public static boolean isAfterUpdateDeleteRates = true;
    public static boolean isAfterUpdateCreateRates = true;
    public static boolean isAfterInsertCreateRates = true;
    Savepoint sp;//to roll back the transation if it fails
    Set<String> tobedeletedRates = new Set<String>();
    /**
* Method Name : deleteRates
* Parameters  : Set<String> unselectedPlans,String objectType - name of the object from where user has 
* 											 un selects a plan.
* Description : This method will be called when user un selects a plan at any stage(RFP,Quote,SSO or SCN)
* Return type : void
**/
    public void deleteRates(Set<String> unselectedPlans,String objectType){
        
        //map to store the RateCardId for the particular object like Opportunity,RFP,Proposal,Sold Sign Off,Sold Case Notifiaction
        //Key contains the Rate Card Id and Values contains the rates to be deleted from that rate card.
        Map<String,Set<String>> ratesForRateCardMap = new Map<String,Set<String>>();
        //Selecting the benefit plans which are un selected from for any of the object. like Opportunity,RFP,Proposal,Sold Sign Off,Sold Case Notifiaction
        //fetching all the rate card ids for the plans this is generic method. Based on the objecttype in condition the rate card will be taken.
        List<Benefit_Plan_Association__c> bpaList = [SELECT ID,Opportunity_Rate_Card__c,RFP_Rate_Card__c,Quote_Rate_Card__c,
                                                     SSO_Rate_Card__c,SCN_Rate_Card__c,Benefit_Plan_Metadata__r.Name,Benefit_Plan_Metadata__c,
                                                     Raider_ID__r.Name,Raider_ID__c FROM Benefit_Plan_Association__c 
                                                     where ID IN:unselectedPlans];
        
        String rateCardId = HighRoads_Constants.BLANK_VALUE;
        //If the objectType is Opportunity, assign the plan rate card to rateCardId variable
        //We are taking the first record rate card id as the rate card is same for all plans on that parent record.
        //It means, if opportunity contains 5 plans and when they enter rates for those plans, the rate card is same for all plans
        //Plan un selection is not bulk. Plans will be un selected using the Edit plan selection button on each record.
        if(objectType.equalsIgnoreCase(HighRoads_Constants.OPPOBJNAME)){
            rateCardId = bpaList[0].Opportunity_Rate_Card__c;
        }else if(objectType.equalsIgnoreCase(HighRoads_Constants.RFPOBJNAME)){
            rateCardId = bpaList[0].RFP_Rate_Card__c;
        }else if(objectType.equalsIgnoreCase(HighRoads_Constants.QUOTEOBJNAME)){
            rateCardId = bpaList[0].Quote_Rate_Card__c;
        }else if(objectType.equalsIgnoreCase(HighRoads_Constants.SSOOBJNAME)){
            rateCardId = bpaList[0].SSO_Rate_Card__c;
        }
        //loop through the un selected bpa list to delete the rates
        if(bpaList != NULL && !bpaList.isEmpty()){
            for(Benefit_Plan_Association__c bpaObj : bpaList){
                //if the benefit plan is Medical then Rider Id will be Null
                if(bpaObj.Raider_ID__c == NULL){
                    if(ratesForRateCardMap.containsKey(rateCardId)){
                        //fetching the rates which need to be deleted from the map
                        Set<String> existedRates = ratesForRateCardMap.get(rateCardId);
                        //adding the unique identifier to existing rates which need to be deleted.
                        existedRates.add(bpaObj.Benefit_Plan_Metadata__r.Name+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.MEDICAL);
                        //storing the ratecardid and rates which need to be deleted in the map
                        ratesForRateCardMap.put(rateCardId, existedRates);
                    }else{
                        //If the unique is not found the map at first time
                        Set<String> rates = new Set<String>();
                        //adding the unique key to set of rates
                        rates.add(bpaObj.Benefit_Plan_Metadata__r.Name+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.MEDICAL);
                        //storing the ratecardId and rates in the map for the first time
                        ratesForRateCardMap.put(rateCardId, rates);
                    }
                }
                //If the Rider Id is not null on benefit plan association record then it is rider
                else{
                    if(ratesForRateCardMap.containsKey(rateCardId)){
                        //fetching the rates which need to be deleted from the map
                        Set<String> existedRates = ratesForRateCardMap.get(rateCardId);
                        //adding the unique identifier to existing rates which need to be deleted.
                        existedRates.add(bpaObj.Benefit_Plan_Metadata__r.Name+HighRoads_Constants.UNDERSCORE+bpaObj.Raider_ID__r.Name);
                        //storing the ratecardid and rates which need to be deleted in the map
                        ratesForRateCardMap.put(rateCardId, existedRates);
                    }else{
                        //If the unique is not found the map at first time
                        Set<String> existedRates = new Set<String>();
                        //adding the unique key to set of rates
                        existedRates.add(bpaObj.Benefit_Plan_Metadata__r.Name+HighRoads_Constants.UNDERSCORE+bpaObj.Raider_ID__r.Name);
                        //storing the ratecardId and rates in the map for the first time
                        ratesForRateCardMap.put(rateCardId, existedRates);
                    }
                }
            }
        }
        
        //Creating new set to store the map values which need to be deleted for that rate card.
        Set<String> rateRecordsSet = new Set<String>();
        for(Set<String> rateSet : ratesForRateCardMap.values()){
            rateRecordsSet.addAll(rateSet);
        }
        //fetching the rates which need to be deleted
        List<Rates__c> deleteRateList = [SELECT ID FROM Rates__c WHERE Rate_Card_ID__c IN :ratesForRateCardMap.keySet() 
                                         AND Medical_Plan_Rider_Plan__c IN :rateRecordsSet LIMIT 10000];
        //checking the deleteRatelist is empty or null
        if(deleteRateList != NULL && !deleteRateList.isEmpty()){
            
            try
            {
                sp = Database.setSavepoint();
                Delete deleteRateList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}  
        }
        
    }
    
    /**
* Method Name : checkDeselectedPlans
* Parameters  : Set<String> unSelectedPlansinChild - this set contains the set of unselected plans in 
* 				 child stages(Opportunity--> RFP/Opportunity --> SCN, RFP --> Quote,Quote-->SSO,SSO-->SCN)
* Description : To create new rates in child object as they are copied from parent by excluding the unselected plans in new rate card.
* Return type : void 
**/
    public void checkDeselectedPlans(Set<String> unSelectedPlansinChild){
        //checking the input param is null or empty
        if(unSelectedPlansinChild != NULL && !unSelectedPlansinChild.isEmpty()){
            //Fetching all un selected plans in the child objects
            List<Benefit_Plan_Association__c> deselectedBenefitPlans = [select id,Benefit_Plan_Metadata__c,Raider_ID__c,
                                                                        Benefit_Plan_Metadata__r.Name,Raider_ID__r.Name from 
                                                                        Benefit_Plan_Association__c where id IN :unSelectedPlansinChild LIMIT 10000];
            
            //Checking the null for deseleted benefit plans
            if(deselectedBenefitPlans != NULL && !deselectedBenefitPlans.isEmpty()){
                //loop through the deselected plans at child
                for(Benefit_Plan_Association__c bpaObj : deselectedBenefitPlans){
                    //Checking whether the plan rider or medical
                    if(bpaObj.Raider_ID__c == NULL){
                        //Additing to set to delete the rates for the unselected plans
                        tobedeletedRates.add(bpaObj.Benefit_Plan_Metadata__r.Name+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.MEDICAL);
                    }else{
                        //Additing to set to delete the rates for the unselected plans
                        tobedeletedRates.add(bpaObj.Benefit_Plan_Metadata__r.Name+HighRoads_Constants.UNDERSCORE+bpaObj.Raider_ID__r.Name); 
                    }
                }
            }
        }
        
    }
    
    /**
* Method Name : createRates
* Parameters  : Set<String> newPlanParentIds,String objectType,Set<String> unSelectedPlansinChild
* Description : To create new rates in if they change plans at each stage comparing with parent.
* Return type : void 
**/
    public void createRates(Set<String> newPlanParentIds,String objectType,Set<String> unSelectedPlansinChild){
        try{
            sp = Database.setSavepoint();
            //boolean flag is used to check the rate card is changed from parent to child.
            //If the isRateCardChanged changed flag is true, it means, the child record plans are changed and rate card is also changed.
            //If the isRateCardChanged is true - we are not doing anything
            //if the isRateCardChanged is false - it means, the parent and child had the same rate card earlier and now the plans are changed in child record.
            //If the isRateCardChanged is false and parent rate card id/child rate card is same and the rate card is not null
            //Then inserting new rate card and rates for the child.
            Boolean isRateCardChanged = false;
            //to store old rate card id
            String oldRateCardId = HighRoads_Constants.BLANK_VALUE;
            //it will store the current benefit plans parent id i.e opportunity/rfp/proposal/sold sign off/sold case notification
            String planParentId = HighRoads_Constants.BLANK_VALUE;
            
            //This boolean flag is used to check the parent is exists on the benefit plan association record. 
            //Ex: Plans are associated to Opportunity and Rates are entered in opportunity stage.
            //When the RFP is created, all the plans and rates will be carried to RFP stage from Opportunity.
            //When they carried to RFP stage, benefit plan association record will contain the Opportunity lookup and RFP lookup.
            //Same time, Rate records will also have opportunity lookup and rfp form lookup. Because they need to see the rates for the plans.
            //If the Opportunity lookup is exists on benefit plan association record then we are marking this flag to true. 
            //When this flag is true, is used to update the old rate records RFP Form to null if any plan is selected/unselected at RFP stage 
            //and inserting new rate card and rates for RFP Form and updating the RFP Rate Card Id in benefit plan association record
            //To make RFP Form lookup on old rates we are checking this flag.
            Boolean isParentExists = false;
            List<Benefit_Plan_Association__c> updateRateCardList = new List<Benefit_Plan_Association__c>();
            //Check if the object type is RFP
            if(objectType.equalsIgnoreCase(HighRoads_Constants.RFPOBJNAME)){
                List<Incumbent_Carrier__c> rfpList = [SELECT ID,(SELECT ID,Opportunity_Rate_Card__c,RFP_Rate_Card__c,Opportunity__c from Benefit_Plan_Associations__r WHERE RFP_Rate_Card__c != NULL)
                                                      FROM Incumbent_Carrier__c WHERE ID IN: newPlanParentIds LIMIT 10000];
                
                for(Incumbent_Carrier__c rfpObj : rfpList){
                    planParentId = rfpObj.Id;
                    if(rfpObj.Benefit_Plan_Associations__r != NULL && rfpObj.Benefit_Plan_Associations__r.size() > 0){
                        for(Benefit_Plan_Association__c bpaObj : rfpObj.Benefit_Plan_Associations__r){
                            if(bpaObj.Opportunity__c != NULL && !isParentExists){
                                //if benefit plan association records contains the opprotunity
                                isParentExists = true;
                            }
                            if(bpaObj.Opportunity_Rate_Card__c != NULL || bpaObj.RFP_Rate_Card__c != NULL){
                                if(bpaObj.Opportunity_Rate_Card__c != bpaObj.RFP_Rate_Card__c){
                                    //If the rate card is not same for parent and child
                                    isRateCardChanged = true;
                                    break;
                                }else{
                                    //if rate card is same for parent and child
                                    oldRateCardId = bpaObj.Opportunity_Rate_Card__c;
                                    break;
                                }
                            }
                        }
                    }
                }
                //If rate card is not changed and old rate card is not null then create new rates for the child
                //and update the existing rates with null for the record lookup reference
                if(!isRateCardChanged && oldRateCardId != NULL && oldRateCardId != ''){
                    //list to store the new rates
                    List<Rates__c> newRatesToInsertList = new List<Rates__c>();
                    // fetching the existing rates for the old rate card
                    // The same rates will be inserted for the record and it is based on the plan selection / deselection
                    // If plan is selected, the  same set of rates will be inserted and updated the rate card id in benefit plan association records
                    // If the plan is un selected, the same set of rates will be inserted expect the rates for the plan(s) which is un selected
                    List<Rates__c> existingRateList = returnExistingRates(oldRateCardId);
                    //If unselected plans are not null calling the checkDesectedPlans method
                    //which will populate tobedeletedrates set. Which can be removed for that plan
                    //This set will be pass only when the rate card same and plan is un selected in child
                    if(unSelectedPlansinChild != NULL && !unSelectedPlansinChild.isEmpty()){
                        checkDeselectedPlans(unSelectedPlansinChild);
                    }
                    System.debug('oldratecardId'+oldRateCardId);
                    //creating new rate card record
                    Rate_Card__c rcObj = new Rate_Card__c();
                    insert rcObj;
                    System.debug('rcObj'+rcObj.Id);
                    //updating the benefit plan association records with new rate card id for RFP
                    for(Incumbent_Carrier__c rfpObj : rfpList){
                        if(rfpObj.Benefit_Plan_Associations__r != NULL && rfpObj.Benefit_Plan_Associations__r.size() > 0){
                            for(Benefit_Plan_Association__c bpaObj : rfpObj.Benefit_Plan_Associations__r){
                                bpaObj.RFP_Rate_Card__c = rcObj.Id;
                                updateRateCardList.add(bpaObj);
                            }           
                        }
                    }
                    //udpating the benefit plan association records with new rate card details
                    if(!updateRateCardList.isEmpty()){
                        Update updateRateCardList;
                    }
                    System.debug('updateRateCardList'+updateRateCardList);
                    //Looping through the existing rates -
                    //If the plan is unselected, it will be there in the tobedeletedRates set.
                    //If the plan is selected it will not be added to that set.
                    //If that set not contains the unique id then we are creating new rates(cloning) and updating rate unique key -Plan_Type_Tier_Group__c
                    //Associating the new rates with RFP Form
                    for(Rates__c rateObj : existingRateList){
                        if(!tobedeletedRates.contains(rateObj.Medical_Plan_Rider_Plan__c)){
                            Rates__c newRateObj = rateObj.clone(false,true);
                            newRateObj.Plan_Type_Tier_Group__c = rateObj.Plan_Type_Tier_Group__c.replace(rateObj.Plan_Type_Tier_Group__c.subStringBefore('_'),planParentId);
                            newRateObj.Rate_Card_ID__c = rcObj.Id;
                            newRateObj.RFP_Form__c = planParentId;
                            newRatesToInsertList.add(newRateObj);
                        }
                    }
                    //If newRates to insert list is not null and empty
                    //then inserting the list and if isParentExists is true, then we  are updating the old rates RFP Form lookup to null as we have 
                    //created the new rates for RFP
                    if(newRatesToInsertList != NULL && !newRatesToInsertList.isEmpty()){
                        Database.insert(newRatesToInsertList);
                        System.debug('newRatesToInsertList'+newRatesToInsertList);
                        if(isParentExists){
                            for(Rates__c rateObj : existingRateList){
                                rateObj.RFP_Form__c = NULL;
                            }
                            update existingRateList;
                        }
                    }
                }
            }
            //Check if the object type is Quote
            if(objectType.equalsIgnoreCase(HighRoads_Constants.QUOTEOBJNAME)){
                List<Proposal__c> quoteList = [SELECT ID,(SELECT ID,RFP_Rate_Card__c,Quote_Rate_Card__c,RFP_Form__c from Benefit_Plan_Associations__r WHERE Quote_Rate_Card__c != NULL)
                                               FROM Proposal__c WHERE ID IN: newPlanParentIds LIMIT 10000];
                for(Proposal__c quoteObj : quoteList){
                    planParentId = quoteObj.Id;
                    if(quoteObj.Benefit_Plan_Associations__r != NULL && quoteObj.Benefit_Plan_Associations__r.size() > 0){
                        for(Benefit_Plan_Association__c bpaObj : quoteObj.Benefit_Plan_Associations__r){
                            if(bpaObj.RFP_Form__c != NULL && !isParentExists){
                                //if benefit plan association records contains the RFP Form
                                isParentExists = true;
                            }
                            if(bpaObj.RFP_Rate_Card__c != NULL || bpaObj.Quote_Rate_Card__c != NULL){
                                if(bpaObj.RFP_Rate_Card__c != bpaObj.Quote_Rate_Card__c){
                                    //If the rate card is not same for parent and child
                                    isRateCardChanged = true;
                                    break;
                                }else{
                                    //if rate card is same for parent and child
                                    oldRateCardId = bpaObj.RFP_Rate_Card__c;
                                    break;
                                }
                            }
                        }   
                    }
                }
                //If rate card is not changed and old rate card is not null then create new rates for the child
                //and update the existing rates with null for the record lookup reference
                if(!isRateCardChanged && oldRateCardId != NULL && oldRateCardId != ''){
                    //If unselected plans are not null calling the checkDesectedPlans method
                    //which will populate tobedeletedrates set. Which can be removed for that plan
                    //This set will be pass only when the rate card same and plan is un selected in child
                    if(unSelectedPlansinChild != NULL && !unSelectedPlansinChild.isEmpty()){
                        checkDeselectedPlans(unSelectedPlansinChild);
                    }
                    
                    //creating new rate card record
                    Rate_Card__c rcObj = new Rate_Card__c();
                    insert rcObj;
                    //list to store the new rates
                    List<Rates__c> newRatesToInsertList = new List<Rates__c>();
                    // fetching the existing rates for the old rate card
                    // The same rates will be inserted for the record and it is based on the plan selection / deselection
                    // If plan is selected, the  same set of rates will be inserted and updated the rate card id in benefit plan association records
                    // If the plan is un selected, the same set of rates will be inserted expect the rates for the plan(s) which is un selected
                    List<Rates__c> existingRateList = returnExistingRates(oldRateCardId);
                    //updating the benefit plan association records with new rate card id for Proposal
                    for(Proposal__c quoteObj : quoteList){
                        if(quoteObj.Benefit_Plan_Associations__r != NULL && quoteObj.Benefit_Plan_Associations__r.size() > 0){
                            for(Benefit_Plan_Association__c bpaObj : quoteObj.Benefit_Plan_Associations__r){
                                bpaObj.Quote_Rate_Card__c = rcObj.Id;
                                updateRateCardList.add(bpaObj);
                            }
                        }                
                    }
                    //udpating the benefit plan association records with new rate card details
                    if(!updateRateCardList.isEmpty()){
                        Update updateRateCardList;
                    }
                    //Looping through the existing rates -
                    //If the plan is unselected, it will be there in the tobedeletedRates set.
                    //If the plan is selected it will not be added to that set.
                    //If that set not contains the unique id then we are creating new rates(cloning) and updating rate unique key -Plan_Type_Tier_Group__c
                    //Associating the new rates with Proposal
                    for(Rates__c rateObj : existingRateList){
                        if(!tobedeletedRates.contains(rateObj.Medical_Plan_Rider_Plan__c)){
                            Rates__c newRateObj = rateObj.clone(false,true);
                            newRateObj.Plan_Type_Tier_Group__c = rateObj.Plan_Type_Tier_Group__c.replace(rateObj.Plan_Type_Tier_Group__c.subStringBefore('_'),planParentId);
                            newRateObj.Rate_Card_ID__c = rcObj.Id;
                            newRateObj.Quote__c = planParentId;
                            newRatesToInsertList.add(newRateObj);
                        }
                    }
                    //If newRates to insert list is not null and empty
                    //then inserting the list and if isParentExists is true, then we  are updating the old rates Proposal lookup to null as we have 
                    //created the new rates for Proposal
                    if(!newRatesToInsertList.isEmpty()){
                        Database.insert(newRatesToInsertList);
                        if(isParentExists){
                            for(Rates__c rateObj : existingRateList){
                                rateObj.Quote__c = NULL;
                            }
                            update existingRateList;
                        }
                    }
                    
                }
            }
            //Check if the object type is SSO
            if(objectType.equalsIgnoreCase(HighRoads_Constants.SSOOBJNAME)){
                List<Sold_Sign_Off__c> ssoList = [SELECT ID,(SELECT ID,Quote_Rate_Card__c,SSO_Rate_Card__c,Proposal__c from Benefit_Plan_Associations__r WHERE SSO_Rate_Card__c != NULL)
                                                  FROM Sold_Sign_Off__c WHERE ID IN: newPlanParentIds LIMIT 10000];
                for(Sold_Sign_Off__c ssoObj : ssoList){
                    planParentId = ssoObj.Id;
                    if(ssoObj.Benefit_Plan_Associations__r != NULL && ssoObj.Benefit_Plan_Associations__r.size() > 0){
                        for(Benefit_Plan_Association__c bpaObj : ssoObj.Benefit_Plan_Associations__r){
                            if(bpaObj.Proposal__c != NULL && !isParentExists){
                                //if benefit plan association records contains the opprotunity
                                isParentExists = true;
                            }
                            if(bpaObj.Quote_Rate_Card__c != NULL || bpaObj.SSO_Rate_Card__c != NULL){
                                if(bpaObj.Quote_Rate_Card__c != bpaObj.SSO_Rate_Card__c){
                                    //If the rate card is not same for parent and child
                                    isRateCardChanged = true;
                                    break;
                                }else{
                                    //if rate card is same for parent and child
                                    oldRateCardId = bpaObj.Quote_Rate_Card__c;
                                    break;
                                }
                            }
                        }
                    }
                }
                
                //If rate card is not changed and old rate card is not null then create new rates for the child
                //and update the existing rates with null for the record lookup reference
                if(!isRateCardChanged && oldRateCardId != NULL && oldRateCardId != ''){
                    //If unselected plans are not null calling the checkDesectedPlans method
                    //which will populate tobedeletedrates set. Which can be removed for that plan
                    //This set will be pass only when the rate card same and plan is un selected in child
                    if(unSelectedPlansinChild != NULL && !unSelectedPlansinChild.isEmpty()){
                        checkDeselectedPlans(unSelectedPlansinChild);
                    }
                    //creating new rate card record
                    Rate_Card__c rcObj = new Rate_Card__c();
                    insert rcObj;
                    //list to store the new rates
                    List<Rates__c> newRatesToInsertList = new List<Rates__c>();
                    // fetching the existing rates for the old rate card
                    // The same rates will be inserted for the record and it is based on the plan selection / deselection
                    // If plan is selected, the  same set of rates will be inserted and updated the rate card id in benefit plan association records
                    // If the plan is un selected, the same set of rates will be inserted expect the rates for the plan(s) which is un selected
                    List<Rates__c> existingRateList = returnExistingRates(oldRateCardId);
                    //updating the benefit plan association records with new rate card id for Sold Sign Off
                    for(Sold_Sign_Off__c ssoObj : ssoList){
                        if(ssoObj.Benefit_Plan_Associations__r != NULL && ssoObj.Benefit_Plan_Associations__r.size() > 0){
                            for(Benefit_Plan_Association__c bpaObj : ssoObj.Benefit_Plan_Associations__r){
                                bpaObj.SSO_Rate_Card__c = rcObj.Id;
                                updateRateCardList.add(bpaObj);
                            }        
                        }
                    }
                    //udpating the benefit plan association records with new rate card details
                    if(!updateRateCardList.isEmpty()){
                        Update updateRateCardList;
                    }
                    //Looping through the existing rates -
                    //If the plan is unselected, it will be there in the tobedeletedRates set.
                    //If the plan is selected it will not be added to that set.
                    //If that set not contains the unique id then we are creating new rates(cloning) and updating rate unique key -Plan_Type_Tier_Group__c
                    //Associating the new rates with Sold Sign Off
                    for(Rates__c rateObj : existingRateList){
                        if(!tobedeletedRates.contains(rateObj.Medical_Plan_Rider_Plan__c)){
                            Rates__c newRateObj = rateObj.clone(false,true);
                            newRateObj.Plan_Type_Tier_Group__c = rateObj.Plan_Type_Tier_Group__c.replace(rateObj.Plan_Type_Tier_Group__c.subStringBefore('_'),planParentId);
                            newRateObj.Rate_Card_ID__c = rcObj.Id;
                            newRateObj.Sold_Sign_Off__c = planParentId;
                            newRatesToInsertList.add(newRateObj);
                        }
                    }
                    //If newRates to insert list is not null and empty
                    //then inserting the list and if isParentExists is true, then we  are updating the old rates Sold Sign off lookup to null as we have 
                    //created the new rates for Sold Sign Off
                    if(!newRatesToInsertList.isEmpty()){
                        Database.insert(newRatesToInsertList);
                        if(isParentExists){
                            for(Rates__c rateObj : existingRateList){
                                rateObj.Sold_Sign_Off__c = NULL;
                            }
                            update existingRateList;
                        }
                    }
                    
                }
            }
            
        }catch(Exception ex){ Database.rollback(sp);System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}

    }
    /**
* Method Name : returnExistingRates
* Descrption  : Utility method which will return the existing rates for the input ratecardid
* Return type : List<Rates>
* Parameters  : ID oldRateCardId
*/
    private List<Rates__c> returnExistingRates(ID oldRateCardId){
        return [SELECT ID,Group_Type__c,Group_Alias_Name__c,Plan_Name__c,Medical_Plan_Rider_Plan__c,Plan_Type_Tier_Group__c,Rate_Card_ID__c,
                Rider_Plan_Name__c,Tier_Type__c,Tier_1_Composite__c,Sold_Case_Notification__c,
                Tier_2_EE__c,Tier_2_EF__c,Tier_3_EE__c,Tier_3_EE1__c,Tier_3_EE2__c,Tier_4_EC__c,Tier_4_EE__c,
                Tier_4_EF__c,Tier_4_ES__c,Tier_5_EC__c,Tier_5_ECH__c,Tier_5_EE__c,Tier_5_EF__c,Tier_5_ES__c
                FROM Rates__c where Rate_Card_ID__c =:oldRateCardId];
    }
}