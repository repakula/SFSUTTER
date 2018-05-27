/**    
*     Class Name  : HighRoads_CopyOppPlansToRFPANDSCN
*     Author      : IDC Offshore  
*     Date        : 7/7/2016  
*     Project Name: CRM - SFT - Sutter Health  
*     Description : This class will be used in RFP_IncumbentCarrier,ProposalTrigger,SoldSignOff,updateSCN triggers
* 					 When they are created. The below operations will be performed when the above records are created.
1. When RFP is created from an Opportunity --> Updating all the associated benefit plan ids with RFP Form ID.
2. If user is trying to create one more RFP for same opportunity, check the opportunity associated benefit plan contains RFP or not.
As first RFP is already created, inserting the new plan with RFP Form details instead of update.
3. When Proposal is created from an RFP --> Updating all the associated benefit plan ids with Proposal ID.
4. If user is trying to create one more Proposal for same RFP, check the RFP associated benefit plan contains Proposal or not.
As first Proposal is already created, inserting the new plan with Proposal Form details instead of update.
5. When Sold Sign off is created from an Proposal --> Updating all the associated benefit plan ids with Sold Sign Off ID.
6. If user is trying to create one more Sold Sign off for same Proposal, check the Proposal associated benefit plan contains Sold Sign off or not.
As first Sold Sign off is already created, inserting the new plan with Sold Sign off Form details instead of update.
7. When SCN is created from an Opportunity/Sold Sign Off --> Updating all the associated benefit plan ids with SCN ID.
8. If user is trying to create one more SCN for same opportunity/sold sign off, check the opportunity/sold sign off associated benefit plan contains SCN or not.
As first SCN is already created, inserting the new plan with SCN Form details instead of update.
9. Associating the benefit plans with Account once the SCN is approved.
**/
public class HighRoads_CopyOppPlansToRFPANDSCN{
    //Boolean variables for recursion protection
    public static boolean isRFPAfterInsert = true;
    public static boolean isProposalAfterInsert = true;
    public static boolean isSSOAfterInsert = true;
    public static boolean isSCNAfterInsert = true;
    public static boolean isSCNAfterUpdate = true;
    
    //Update list is used to update the id in benefit plan record which is carried from the parent object 
    //Like Opportunity -> RFP,RFP->Proposal,Proposal ->Sold Sign Off , Sold Sign Off -> SCN / Opportunity -> SCN
    List<Benefit_Plan_Association__c> updateBenefitPlanList = new List<Benefit_Plan_Association__c>();
    //Insert list is used to insert the new records for the current object, this plan is not exists in the parent
    //When plan is not exists in parent those plans are added to this list
    List<Benefit_Plan_Association__c> insertBenefitPlanList = new List<Benefit_Plan_Association__c>();
    //the below map is used to store the parent id and its rate card which will be used to update the rate card in the child plan records
    public Map<String,String> parentAndRateCardMap = new Map<String,String>();
    Savepoint sp;//to roll back the transation if it fails
    /**
* Method Name : copyOppPlansToRFP
* Parameters  : Map<ID,ID> oppRFPMap
* Return Type : Void
* Description : This method is called from RFPTrigger once RFP is created.
* 				 Used to copy the Opportunity benefit plans to RFP including rates
**/
    public void copyOppPlansToRFP(Map<ID,ID> oppRFPMap){
        
        //fetching the plans from Opportunity to update the RFP ID - The updation will happen when the first RFP is created
        //If user creates one more RFP for same Opportunity, new benefit plans will be inserted instead of update as already first rfp is updated in the old plans
        for(Benefit_Plan_Association__c benefitPlan : [select id,Opportunity_Rate_Card__c,RFP_Rate_Card__c,RFP_Benefit_Version__c,
                                                       Name,Opportunity__c,RFP_Form__c,Benefit_Plan_Metadata__c,Raider_ID__c,
                                                       Benefit_Plan_Metadata__r.Version_Number__c,Raider_ID__r.Version_Number__c
                                                       from Benefit_Plan_Association__c 
                                                       where Opportunity__c in :oppRFPMap.keySet() LIMIT 10000]){
                                                           Benefit_Plan_Association__c newPlan = new Benefit_Plan_Association__c();
                                                           //Checking the RFP Form is null or not in the benefit plan, if it is null then the 
                                                           //Benefit Plan will be updated with RFP Form
                                                           if(benefitPlan.RFP_Form__c == NULL){
                                                               benefitPlan.RFP_Form__c = oppRFPMap.get(benefitPlan.Opportunity__c);
                                                               benefitPlan.RFP_Rate_Card__c = benefitPlan.Opportunity_Rate_Card__c;
                                                               benefitPlan.RFP_Benefit_Version__c = benefitPlan.Raider_ID__c == NULL ? benefitPlan.Benefit_Plan_Metadata__r.Version_Number__c : benefitPlan.Raider_ID__r.Version_Number__c;
                                                               updateBenefitPlanList.add(benefitPlan);
                                                               //this map is used to store the rate card to update the rates with RFP Form Details.
                                                               parentAndRateCardMap.put(benefitPlan.RFP_Rate_Card__c,oppRFPMap.get(benefitPlan.Opportunity__c));
                                                           }
                                                           //Checking the RFP Form is null or not in the benefit plan, if the existing benefit plan
                                                           //contains any RFP Form ID then inserting new benefit plans and associating them only with this RFP
                                                           else{
                                                               newPlan.Name =  benefitPlan.name;
                                                               newPlan.Benefit_Plan_Metadata__c =  benefitPlan.Benefit_Plan_Metadata__c;
                                                               newPlan.Raider_ID__c =  benefitPlan.Raider_ID__c;
                                                               newPlan.RFP_Form__c = oppRFPMap.get(benefitPlan.Opportunity__c);
                                                               newPlan.Opportunity_Rate_Card__c = benefitPlan.Opportunity_Rate_Card__c;
                                                               newPlan.RFP_Rate_Card__c = benefitPlan.Opportunity_Rate_Card__c;
                                                               newPlan.RFP_Benefit_Version__c = benefitPlan.Raider_ID__c == NULL ? benefitPlan.Benefit_Plan_Metadata__r.Version_Number__c : benefitPlan.Raider_ID__r.Version_Number__c;
                                                               insertBenefitPlanList.add(newPlan);
                                                           }
                                                           
                                                       }
        //Update the benefit plans if the list is not empty
        if(!updateBenefitPlanList.isEmpty()){
            try
            {
                sp = Database.setSavepoint();
                update updateBenefitPlanList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        }
        //Inserting the benefit plans if the list is not empty
        if(!insertBenefitPlanList.isEmpty()){
            try
            {
                sp = Database.setSavepoint();
                insert insertBenefitPlanList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        }
        //If RFP Rate card is not null then calling method to update rates with the RFP Form details
        //So that the rates will be associated with the RFP
        if(parentAndRateCardMap != NULL && !parentAndRateCardMap.isEmpty()){
            updateRates(parentAndRateCardMap,HighRoads_Constants.RFP_API_NAME);
        }
        
    }
    
    /**
* Method Name : copyRFPPlansToProposal
* Parameters  : Map<ID,ID> proposalMap
* Return Type : Void
* Description : This method is called from Quote Trigger once Quote is created.
* 				 Used to copy the RFP benefit plans to Quote including rates
**/
    public void copyRFPPlansToProposal(Map<ID,ID> proposalMap){
        
        //fetching the plans from RFP to update the Proposal ID - The updation will happen when the first Proposal is created
        //If user creates one more Proposal for same RFP, new benefit plans will be inserted instead of update as already first Proposal is updated in the old plans
        for(Benefit_Plan_Association__c benefitPlan : [select id,Name,RFP_Form__c,RFP_Rate_Card__c,Quote_Rate_Card__c,Quote_Benefit_Version__c,
                                                       Benefit_Plan_Metadata__r.Version_Number__c,Raider_ID__r.Version_Number__c,
                                                       Proposal__c,Benefit_Plan_Metadata__c,Raider_ID__c from Benefit_Plan_Association__c 
                                                       where RFP_Form__c in :proposalMap.keySet() LIMIT 1000]){
                                                           Benefit_Plan_Association__c newPlan = new Benefit_Plan_Association__c();
                                                           //Checking the Proposal  is null or not in the benefit plan, if it is null then the 
                                                           //Benefit Plan will be updated with Proposal
                                                           if(benefitPlan.Proposal__c == NULL){
                                                               benefitPlan.Proposal__c = proposalMap.get(benefitPlan.RFP_Form__c);
                                                               benefitPlan.Quote_Rate_Card__c = benefitPlan.RFP_Rate_Card__c;
                                                               benefitPlan.Quote_Benefit_Version__c = benefitPlan.Raider_ID__c == NULL ? benefitPlan.Benefit_Plan_Metadata__r.Version_Number__c : benefitPlan.Raider_ID__r.Version_Number__c;
                                                               updateBenefitPlanList.add(benefitPlan);
                                                               //this map is used to store the rate card to update the rates with Proposal Details.
                                                               parentAndRateCardMap.put(benefitPlan.Quote_Rate_Card__c,benefitPlan.Proposal__c);
                                                           }
                                                           //Checking the Proposal is null or not in the benefit plan, if the existing benefit plan
                                                           //contains any Proposal ID then inserting new benefit plans and associating them only with this Proposal
                                                           else{
                                                               newPlan.Name =  benefitPlan.name;
                                                               newPlan.Benefit_Plan_Metadata__c =  benefitPlan.Benefit_Plan_Metadata__c;
                                                               newPlan.Raider_ID__c =  benefitPlan.Raider_ID__c;
                                                               newPlan.Proposal__c = proposalMap.get(benefitPlan.RFP_Form__c);
                                                               newPlan.RFP_Rate_Card__c = benefitPlan.RFP_Rate_Card__c;
                                                               newPlan.Quote_Rate_Card__c = benefitPlan.RFP_Rate_Card__c;
                                                               newPlan.Quote_Benefit_Version__c = benefitPlan.Raider_ID__c == NULL ? benefitPlan.Benefit_Plan_Metadata__r.Version_Number__c : benefitPlan.Raider_ID__r.Version_Number__c;
                                                               insertBenefitPlanList.add(newPlan);
                                                           }
                                                           
                                                       }
        //Update the benefit plans if the list is not empty
        if(!updateBenefitPlanList.isEmpty()){
            try
            {
                sp = Database.setSavepoint(); 
                update updateBenefitPlanList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        }
        //Inserting the benefit plans if the list is not empty
        if(!insertBenefitPlanList.isEmpty()){
            try
            {
                sp = Database.setSavepoint(); 
                insert insertBenefitPlanList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        }
        //If Proposal Rate card is not null then calling method to update rates with the Proposal Form details
        //So that the rates will be associated with the Proposal
        if(parentAndRateCardMap != NULL && !parentAndRateCardMap.isEmpty()){
            updateRates(parentAndRateCardMap,HighRoads_Constants.QUOTE_API_NAME);
        }
        
    }
    
    /**
* Method Name : copyProposalPlansToSSO
* Parameters  : Map<ID,ID> ssoMap
* Return Type : Void
* Description : This method is called from SSO Trigger once SSO is created.
* 				 Used to copy the Quote benefit plans to SSO including rates
**/
    
    public void copyProposalPlansToSSO(Map<ID,ID> ssoMap){
        
        //fetching the plans from Proposal to update the Sold Sign Off ID - The updation will happen when the first Sold Sign Off is created
        //If user creates one more Sold Sign Off for same Proposal, new benefit plans will be inserted instead of update as already first Sold Sign Off is updated in the old plans
        for(Benefit_Plan_Association__c benefitPlan : [select id,Name,Sold_Sign_Off__c,Proposal__c,Benefit_Plan_Metadata__c,Raider_ID__c ,SSO_Benefit_Version__c,
                                                       SSO_Rate_Card__c,Quote_Rate_Card__c,Benefit_Plan_Metadata__r.Version_Number__c,Raider_ID__r.Version_Number__c 
                                                       from Benefit_Plan_Association__c where Proposal__c in :ssoMap.keySet() LIMIT 10000]){
                                                           Benefit_Plan_Association__c newPlan = new Benefit_Plan_Association__c();
                                                           //Checking the Sold Sign Off is null or not in the benefit plan, if it is null then the 
                                                           //Benefit Plan will be updated with Sold Sign Off
                                                           if(benefitPlan.Sold_Sign_Off__c == NULL){
                                                               benefitPlan.Sold_Sign_Off__c = ssoMap.get(benefitPlan.Proposal__c);
                                                               benefitPlan.SSO_Rate_Card__c = benefitPlan.Quote_Rate_Card__c;
                                                               benefitPlan.SSO_Benefit_Version__c = benefitPlan.Raider_ID__c == NULL ? benefitPlan.Benefit_Plan_Metadata__r.Version_Number__c : benefitPlan.Raider_ID__r.Version_Number__c;
                                                               updateBenefitPlanList.add(benefitPlan);
                                                               //this map is used to store the rate card to update the rates with Sold Sign Off Details.
                                                               parentAndRateCardMap.put(benefitPlan.SSO_Rate_Card__c,benefitPlan.Sold_Sign_Off__c);
                                                           }
                                                           //Checking the Sold Sign Off is null or not in the benefit plan, if the existing benefit plan
                                                           //contains any Sold Sign Off ID then inserting new benefit plans and associating them only with this Sold Sign off
                                                           else{
                                                               newPlan.Name =  benefitPlan.name;
                                                               newPlan.Benefit_Plan_Metadata__c =  benefitPlan.Benefit_Plan_Metadata__c;
                                                               newPlan.Raider_ID__c =  benefitPlan.Raider_ID__c;
                                                               newPlan.Sold_Sign_Off__c = ssoMap.get(benefitPlan.Proposal__c);
                                                               newPlan.Quote_Rate_Card__c = benefitPlan.Quote_Rate_Card__c;
                                                               newPlan.SSO_Rate_Card__c = benefitPlan.Quote_Rate_Card__c;
                                                               newPlan.SSO_Benefit_Version__c = benefitPlan.Raider_ID__c == NULL ? benefitPlan.Benefit_Plan_Metadata__r.Version_Number__c : benefitPlan.Raider_ID__r.Version_Number__c;
                                                               insertBenefitPlanList.add(newPlan);
                                                           }
                                                       }
        //Update the benefit plans if the list is not empty
        if(!updateBenefitPlanList.isEmpty()){
            try
            {
                sp = Database.setSavepoint();
                update updateBenefitPlanList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        }
        //Inserting the benefit plans if the list is not empty
        if(!insertBenefitPlanList.isEmpty()){
            try
            {
                sp = Database.setSavepoint();
                insert insertBenefitPlanList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        }
        //If RFP Rate card is not null then calling method to update rates with the RFP Form details
        //So that the rates will be associated with the RFP
        if(parentAndRateCardMap != NULL && !parentAndRateCardMap.isEmpty()){
            updateRates(parentAndRateCardMap,HighRoads_Constants.SSO_API_NAME);
        }
        
    }
    /**
* Method Name : copyOppPlansToSCN
* Parameters  : Map<ID,ID> ssoSCNMap, Map<ID,ID> oppSCNMap
* Return Type : Void
* Description : This method is called from updateSCN Trigger once SCN is created.
* 				 1. Used to copy the SSO benefit plans to SCN including rates if it is created from SSO (Large Groups)
* 				 2. Used to copy the Opportunity benefit plans to SCN including rates if it is created from Opportunity (Small Groups)
**/
    public void copyOppPlansToSCN(Map<ID,ID> ssoSCNMap, Map<ID,ID> oppSCNMap){
        
        //Checking the ssoSCNMap is null or empty, as Sold Case Notification can be created from either Sold Sign Off or Opportunity
        if(ssoSCNMap != NULL && !ssoSCNMap.isEmpty()){
            //fetching the plans from Sold Sign Off to update the SCN ID - The updation will happen when the first SCN is created
            //If user creates one more SCN for same Sold Sign Off, new benefit plans will be inserted instead of update as already first SCN is updated in the old plans
            List<Benefit_Plan_Association__c> benefitPlanList = [select id,name,Benefit_Plan_Metadata__c,Raider_ID__c,Sold_Case_Notification__c ,
                                                                 Opportunity_Rate_Card__c,SSO_Rate_Card__c,SCN_Rate_Card__c ,Sold_Sign_Off__c,SCN_Benefit_Version__c,
                                                                 Benefit_Plan_Metadata__r.Version_Number__c,Raider_ID__r.Version_Number__c 
                                                                 from Benefit_Plan_Association__c 
                                                                 where Sold_Sign_Off__c in :ssoSCNMap.keySet() LIMIT 10000];
            if(!benefitPlanList.isEmpty()){
                for(Benefit_Plan_Association__c benefitPlan : benefitPlanList){
                    Benefit_Plan_Association__c newPlan = new Benefit_Plan_Association__c();
                    //Checking the SCN is null or not in the benefit plan, if it is null then the 
                    //Benefit Plan will be updated with SCN
                    if(benefitPlan.Sold_Case_Notification__c == NULL){
                        benefitPlan.Sold_Case_Notification__c = ssoSCNMap.get(benefitPlan.Sold_Sign_Off__c);
                        benefitPlan.SCN_Rate_Card__c = benefitPlan.SSO_Rate_Card__c;
                        benefitPlan.SCN_Benefit_Version__c = benefitPlan.Raider_ID__c == NULL ? benefitPlan.Benefit_Plan_Metadata__r.Version_Number__c : benefitPlan.Raider_ID__r.Version_Number__c;
                        updateBenefitPlanList.add(benefitPlan);
                        //this map is used to store the rate card to update the rates with Sold Case Notification Details.
                        parentAndRateCardMap.put(benefitPlan.SCN_Rate_Card__c,benefitPlan.Sold_Case_Notification__c);
                    }
                    //Checking the SCN is null or not in the benefit plan, if the existing benefit plan
                    //contains any SCN ID then inserting new benefit plans and associating them only with this SCN
                    else{
                        newPlan.Name =  benefitPlan.name;
                        newPlan.Benefit_Plan_Metadata__c =  benefitPlan.Benefit_Plan_Metadata__c;
                        newPlan.Raider_ID__c =  benefitPlan.Raider_ID__c;
                        newPlan.Sold_Case_Notification__c = ssoSCNMap.get(benefitPlan.Sold_Sign_Off__c);
                        newPlan.SSO_Rate_Card__c = benefitPlan.SSO_Rate_Card__c;
                        newPlan.SCN_Rate_Card__c = benefitPlan.SSO_Rate_Card__c;
                        newPlan.SCN_Benefit_Version__c = benefitPlan.Raider_ID__c == NULL ? benefitPlan.Benefit_Plan_Metadata__r.Version_Number__c : benefitPlan.Raider_ID__r.Version_Number__c;
                        insertBenefitPlanList.add(newPlan); 
                    }
                }
            }
        }
        //This else condition will work only when ssoSCN map is emtpy
        else{
            //fetching the plans from Opportunity to update the SCN ID - The updation will happen when the first SCN is created
            //If user creates one more SCN for same Opportunity, new benefit plans will be inserted instead of update as already first SCN is updated in the old plans
            List<Benefit_Plan_Association__c> scnBenefitPlanList = [select id,Name,Benefit_Plan_Metadata__c,Raider_ID__c,Opportunity__c,SCN_Benefit_Version__c,
                                                                    Benefit_Plan_Metadata__r.Version_Number__c,Raider_ID__r.Version_Number__c, 
                                                                    Sold_Case_Notification__c,Opportunity_Rate_Card__c,SSO_Rate_Card__c,SCN_Rate_Card__c 
                                                                    from Benefit_Plan_Association__c 
                                                                    where Opportunity__c in :oppSCNMap.keySet() LIMIT 10000];
            if(!scnBenefitPlanList.isEmpty()){
                for(Benefit_Plan_Association__c benefitPlan : scnBenefitPlanList){
                    Benefit_Plan_Association__c newPlan = new Benefit_Plan_Association__c();
                    //Checking the SCN is null or not in the benefit plan, if it is null then the 
                    //Benefit Plan will be updated with SCN
                    if(benefitPlan.Sold_Case_Notification__c == NULL){
                        benefitPlan.Sold_Case_Notification__c = oppSCNMap.get(benefitPlan.Opportunity__c);
                        benefitPlan.SCN_Rate_Card__c = benefitPlan.Opportunity_Rate_Card__c;
                        benefitPlan.SCN_Benefit_Version__c = benefitPlan.Raider_ID__c == NULL ? benefitPlan.Benefit_Plan_Metadata__r.Version_Number__c : benefitPlan.Raider_ID__r.Version_Number__c;
                        updateBenefitPlanList.add(benefitPlan);
                        //this map is used to store the rate card to update the rates with SCN Details.
                        parentAndRateCardMap.put(benefitPlan.SCN_Rate_Card__c,benefitPlan.Sold_Case_Notification__c);
                    }else{
                        newPlan.Name =  benefitPlan.name;
                        newPlan.Benefit_Plan_Metadata__c =  benefitPlan.Benefit_Plan_Metadata__c;
                        newPlan.Raider_ID__c =  benefitPlan.Raider_ID__c;
                        newPlan.Sold_Case_Notification__c = oppSCNMap.get(benefitPlan.Opportunity__c);
                        newPlan.Opportunity_Rate_Card__c = benefitPlan.Opportunity_Rate_Card__c;
                        newPlan.SCN_Rate_Card__c = benefitPlan.Opportunity_Rate_Card__c;
                        newPlan.SCN_Benefit_Version__c = benefitPlan.Raider_ID__c == NULL ? benefitPlan.Benefit_Plan_Metadata__r.Version_Number__c : benefitPlan.Raider_ID__r.Version_Number__c;
                        
                        insertBenefitPlanList.add(newPlan); 
                    }
                }
            }
            
        }
        //Update the benefit plans if the list is not empty
        if(!updateBenefitPlanList.isEmpty()){
            try
            {
                sp = Database.setSavepoint();
                update updateBenefitPlanList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        }
        //Inserting the benefit plans if the list is not empty
        if(!insertBenefitPlanList.isEmpty()){
            try
            {
                sp = Database.setSavepoint();
                insert insertBenefitPlanList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        }
        //If SCN Rate card is not null then calling method to update rates with the SCN details
        //So that the rates will be associated with the SCN
        if(parentAndRateCardMap != NULL && !parentAndRateCardMap.isEmpty()){
            updateRates(parentAndRateCardMap,HighRoads_Constants.SCN_API_NAME);
        }
        
    }
    /**
* Method Name : updateAccountIdonBPA
* Parameters  : Set<ID>
* Return Type : Void
* Description : This method is called from SCN Trigger when SCN is approved.
* 				 Used to copy the approved SCN benefit plans to Account
**/
    public void updateAccountIdonBPA(Set<ID> scnIds){
        
        //Fetching all the associated plans for the SCN to associate the Benefit Plan with Account
        List<Employer_Group_Data__c> scnList = [select id,Sold_Sign_Off__r.Quote__r.RFP_Form__r.Opportunity__r.AccountId,Opportunity__r.AccountId,
                                                (select id,Account__c from Benefit_Plan_Associations__r) from Employer_Group_Data__c where id in:scnIds LIMIT 10000];
        
        for(Employer_Group_Data__c scn : scnList){
            for(Benefit_Plan_Association__c bpa : scn.Benefit_Plan_Associations__r){
                if(scn.Sold_Sign_Off__r.Quote__r.RFP_Form__r.Opportunity__r.AccountId != NULL){
                    //populating the account from sold sign off -- This will happen for Large group Accounts
                    bpa.Account__c = scn.Sold_Sign_Off__r.Quote__r.RFP_Form__r.Opportunity__r.AccountId;
                }else if(scn.Opportunity__r.AccountId != NULL){
                    //populating the account from opportunity -- this will happen for Small Group accounts
                    bpa.Account__c = scn.Opportunity__r.AccountId;
                }
                updateBenefitPlanList.add(bpa);
            }
        }
        if(!updateBenefitPlanList.isEmpty()){
            try
            {
                sp = Database.setSavepoint();  
                update updateBenefitPlanList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        }
        
    }
    
    
    /**
* Method Name : updateRates
* Parameters  : Map<String,String> parentAndRateCardMap,String sobjName
* Return Type : Void
* Description : This method is called when the plans are copying from parent to child
* 				 to update the RateCard details.
**/
    public void updateRates(Map<String,String> parentAndRateCardMap,String sobjName){
        
        List<Rates__c> rateList = [ select id,Sold_Case_Notification__c,Rate_Card_ID__c from Rates__c where Rate_Card_ID__c IN :parentAndRateCardMap.keySet() AND Rate_Card_ID__c != NULL];
        for(Rates__c rateObj : rateList){
            rateObj.put(sobjName,parentAndRateCardMap.get(rateObj.Rate_Card_Id__c));
        }
        if(rateList != NULL && !rateList.isEmpty()){
            try
            {
                sp = Database.setSavepoint();    
                update rateList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        }
        
    }
}