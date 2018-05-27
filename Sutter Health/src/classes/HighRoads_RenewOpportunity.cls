/**    
*     Class Name  : HighRoads_RenewOpportunity
*     Author      : IDC Offshore  
*     Date        : 17-Oct-2016  
*     Project Name: CRM - SFT - Sutter Health  
*     Description : This controller class is for HighRoads_RenewOpportunity visualforce page.
Is used to renew the opportunity when user clicks on the Renew Opportunity button from Account.
It will check the below conditions while renewing the opportunity
1. It will check for the benefit plans in the account for the current year.
2. Checks the renewal plans in the Benefit Plan Metadata based on the Last Year Plan ID field.
3. Associates next year plans to the renewal opportunity and throws a warning message if there is no matching renewal plan for existing plans
4. Rates will also be copied on renewal opportunity.
**/
public class HighRoads_RenewOpportunity {
    public ID accId{get;set;}
    public boolean isExists{get;set;} // boolean variable is used to check the open opportunities exists for that account or not.
    public boolean renewalPlanNotExists{get;set;}//boolean variable is used to check the renewal plans are exists for existing plans or not.
    public boolean oppCreated{get;set;} //boolean variable is used to give success message when the opportunity is created
    public boolean isErrorOccured{get;set;} //boolean variable is used to render the error message to user if anything occurs/
    Integer DateLimit = Integer.valueOf(System.Label.Number_of_Days); // 120 days of limit
    List<Benefit_Plan_Association__c> currentYearPlans{get;set;}
    Set<String> oldBenefitPlans = new Set<String>();
    Set<ID> archivedContacts = new Set<ID>(); // Set of archived contacts, used to query the archived contacts to skip any errors while creating / updating opportunities
    Opportunity newOppObj{get;set;}
    SystemException__c systemException = new SystemException__c();
    //This map contains the sold case notfication and its related rate card id for the benefit plan associations
    Map<String,String> scnRateCardMap = new Map<String,String>();
    Map<String,String> rateCardScnMap = new Map<String,String>();
    Map<String,String> oldNewBenefitMetadataNameMap = new Map<String,String>();
    Map<String,String> oldNewBenefitMetadataNameIDMap = new Map<String,String>();
    Map<String,Benefit_Plan_Metadata__c> oldNewBenefitMetadataIDMap = new Map<String,Benefit_Plan_Metadata__c>();
    List<Rates__c> newRatesList = new List<Rates__c>();
    List<Benefit_Plan_Association__c> renewalPlanUpdateList = new List<Benefit_Plan_Association__c>();
    List<Benefit_Plan_Association__c> renewalPlanList = new List<Benefit_Plan_Association__c>();
    String benefitYear = HighRoads_Constants.BLANK_VALUE;
    
    //constructor
    public HighRoads_RenewOpportunity(){
        isExists = false;
        renewalPlanNotExists = false;
        oppCreated = false;
        isErrorOccured = false;
        newOppObj = new Opportunity();
        this.accId = ApexPages.currentPage().getParameters().get(HighRoads_Constants.SFDCID);
    }
    /**
* Method Name : isOpportunityExists
* Parameters  : None
* Return Type : PageReference
* Description : This method will be called at the time of page load, checks are there any open opportunities exists for the account or not
* 				 If there is any open opportunity for that account, it will throw a warning message to user to continue the new renewal opportunity or not.
**/
    public PageReference isOpportunityExists(){
        //fetching the open opportunities for the account
        List<Opportunity> openOppList = [select id from Opportunity where stagename not in (:System.Label.CL_35_SM_ClosedWon,:System.Label.HR120_CLosed_Lost,:System.Label.HR121_Closed_Duplicate) 
                                         AND accountId = :accId LIMIT 10000];
        //Checking the open opportunity list is null or empty or size greather than zero or not
        if(openOppList != NULL && !openOppList.isEmpty() && openOppList.size() > 0){
            //Making isExists flag to true, based on this flag, error message will be rendered to user
            isExists = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.HR119_OpenOppExists));
            return null;
        }else{
            //If there is no open opportunities for the account calling the renewOpportunity method
            return renewOpportunity();
        }
    }
    
    /**
* Method Name : redirectToOpp
* Parameters  : None
* Return Type : PageReference
* Description : This method will be called when user clicks on OK button after opportunity creation.
* 				 This will be redirected to newly created opportunity page.
**/
    public PageReference redirectToOpp(){
        if(newOppObj != NULL && newOppObj.Id != NULL){
            return new PageReference('/'+newOppObj.Id);
        }
        return null;
    }
    /**
* Method Name : renewOpportunity
* Parameters  : None
* Return Type : PageReference
* Description : This method will be called at the time of page load, if there is no open opportunity this method will be called on page load.
* 				 If there is any open opportunity, if user continues for the renewal opporutnity creation after warning message
**/
    public PageReference renewOpportunity(){
        //to roll back the transation if it fails
    	System.Savepoint savePointObj = Database.setSavepoint();
        try{
            //Fetching the data from Account and Beenfit Plan Association
            //Broker,Broker Rep are used to check whether the existing Broker Rep is archived or not.
            Account accObj = [select id,Name,Employer_Next_Renewal_Date__c,
                              Broker__c,Broker_Rep__c,SHP_Active_Members__c,(select plan_year__c from Benefit_Plan_Associations__r order by createddate desc limit 1)
                              from Account where id =:accId LIMIT 1];
            //Getting the next year 
            if(accObj.Benefit_Plan_Associations__r != NULL && accObj.Benefit_Plan_Associations__r.size() > 0){
                List<Benefit_Plan_Association__c> existingPlan = accObj.Benefit_Plan_Associations__r;
                benefitYear = String.valueOf(Integer.valueOf(existingPlan[0].plan_year__c) + 1);
            }
            //Adding the Broker Rep to archivedContacts set to check the Broker Rep is archived or not
            archivedContacts.add(accObj.Broker_Rep__c);
            //Query to fetch all the archived contacts
            Map<String,Contact> archivedConMap = new Map<String,Contact>([select ID,Archive__c from Contact where ID IN:archivedContacts and Archive__c = true]);
            //If any archive contact is found, then giving error message to user that need to be changed.
            if(archivedConMap != NULL && !archivedConMap.isEmpty()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR203_ArchivedContactExists));
                isErrorOccured = true;
                return null;
            }
            // If benefit plan year found in the associated plans then renewing the plans for the opportunity
            // else will execute and creates opportunity if there is no benefit plans
            if(benefitYear != NULL && benefitYear != ''){
                //Fetching currrent year based on the benefit plan year
                String currentYear = String.valueOf(Integer.valueOf(benefitYear) - 1);
                //fetching the current year existing plans for the account.
                currentYearPlans = [Select Id,Name,Benefit_Plan_Metadata__c,Raider_ID__c,Benefit_Plan_Metadata__r.Name,Raider_ID__r.Name,
                                    Sold_Case_Notification__c,SCN_Rate_Card__c FROM Benefit_Plan_Association__c where Plan_Year__c = :currentYear and Account__c =:accId];
                
                if(currentYearPlans != NULL && currentYearPlans.size() > 0){
                    for(Benefit_Plan_Association__c bpaObj : currentYearPlans){
                        if(bpaObj.Raider_ID__c == NULL){
                            // taking into oldBenefitPlans set to get the new metadata ids based on the previous year plan ids
                            oldBenefitPlans.add(bpaObj.Benefit_Plan_Metadata__r.Name.subStringBefore(HighRoads_Constants.HYPHEN).trim());
                        }else{
                            oldBenefitPlans.add(bpaObj.Raider_ID__r.Name.subStringBefore(HighRoads_Constants.HYPHEN).trim());
                        }
                        // taking into oppRateCardMap, which will be used to populate the new rate card id and to fetch the rate cards and rates using this map
                        if(bpaObj.SCN_Rate_Card__c != NULL){
                            scnRateCardMap.put(bpaObj.Sold_Case_Notification__c, bpaObj.SCN_Rate_Card__c);
                            rateCardScnMap.put(bpaObj.SCN_Rate_Card__c, bpaObj.Sold_Case_Notification__c);
                        }
                    }
                    
                    //Fetchting new metadata plans based on the previous year plan ids
                    if(oldBenefitPlans != NULL && !oldBenefitPlans.isEmpty()){
                        
                        List<Benefit_Plan_Metadata__c> newBenefitPlanMetadataList = [select id,Name,EOC__c ,SBC__c ,BCM__c ,Ancillary_EOC__c ,Ancillary_SOB__c ,
                                                                                     Ancillary_GSA__c,Version_Number__c,Previous_Year_Plan_ID__c 
                                                                                     FROM Benefit_Plan_Metadata__c WHERE Previous_Year_Plan_ID__c 
                                                                                     IN :oldBenefitPlans AND Plan_Year__c = :benefitYear];
                        //constructing the maps for old and new plan ids and name of the plans
                        if(newBenefitPlanMetadataList != NULL){
                            for(Benefit_Plan_Metadata__c metaDataObj : newBenefitPlanMetadataList){
                                oldNewBenefitMetadataNameIDMap.put(metaDataObj.Previous_Year_Plan_ID__c, metaDataObj.Id);
                                oldNewBenefitMetadataNameMap.put(metaDataObj.Previous_Year_Plan_ID__c, metaDataObj.Name);
                                oldNewBenefitMetadataIDMap.put(metaDataObj.Id,metaDataObj);
                            }
                        }
                    }
                    //calling assignFieldData method to populate the data in new opportunity object based on the input parameters
                    newOppObj = assignFieldData(accObj,newOppObj,archivedConMap);
                    //constructing string to render the message to user if there is no renewal plan for the current plans
                    String notFoundRenewalPlans = System.Label.HR124_RenewalPlansNotExists;
                    //set to not add duplicate plans while rendering them to user
                    Set<String> renewalPlanNotExistsSet = new Set<String>();
                    for(Benefit_Plan_Association__c oldBpaObj : currentYearPlans){
                        //checking for the medical plan
                        if(oldBpaObj.Raider_ID__c == NULL){
                            if(oldNewBenefitMetadataNameMap.get(oldBpaObj.Benefit_Plan_Metadata__r.Name.subStringBefore(HighRoads_Constants.HYPHEN).trim()) == NULL && !renewalPlanNotExistsSet.contains(oldBpaObj.Benefit_Plan_Metadata__r.Name)) {
                                notFoundRenewalPlans+= HighRoads_Constants.NEW_LINE_HTML+oldBpaObj.Benefit_Plan_Metadata__r.Name;
                                renewalPlanNotExists = true;
                                renewalPlanNotExistsSet.add(oldBpaObj.Benefit_Plan_Metadata__r.Name);
                            }
                        }else{
                            //checking for rider plan
                            if(oldBpaObj.Raider_ID__r.Name != NULL && oldNewBenefitMetadataNameMap.get(oldBpaObj.Raider_ID__r.Name.subStringBefore(HighRoads_Constants.HYPHEN).trim()) == NULL && !renewalPlanNotExistsSet.contains(oldBpaObj.Raider_ID__r.Name)){
                                notFoundRenewalPlans+= HighRoads_Constants.NEW_LINE_HTML+oldBpaObj.Raider_ID__r.Name;
                                renewalPlanNotExists = true;
                                renewalPlanNotExistsSet.add(oldBpaObj.Raider_ID__r.Name);
                            }
                        }
                    }
                    //throwing error message to user if the renewalPlanNotExists true
                    if(renewalPlanNotExists){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,notFoundRenewalPlans));
                        return null;
                    }else{
                        //calling method to create Opportunity and rates if all plans are found for renewal
                        createOppandRates();
                    }
                }else{
                    //creating only opportunity of the current year plans are empty
                    newOppObj = assignFieldData(accObj,newOppObj,archivedConMap);
                    Insert newOppObj;
                }
            }else{
                //creating only opportunity without plans if the account does not contain any plan
                newOppObj = assignFieldData(accObj,newOppObj,archivedConMap);
                Insert newOppObj;
            }
            //to render opportunity creation message to user.
            if(newOppObj.Id != NULL){
                oppCreated = true;
                isExists = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.Label.HR123_OppCreated));
            }
        }catch(Exception ex){ ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR122_ErrorinRenewalOpportunity));Database.rollback(savePointObj); isErrorOccured = true;System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        return null;
    }
    /**
* Method Name : createOppandRates
* Parameters  : None
* Return Type : PageReference
* Description : This method will be called from renewOpportunity when,
* 				 1. If there are all renewal plans are exists in the Metadata object.
* 				 2. When user clicks on Continue button after warning message (If renewal plans are not exists/open opportunity exists for that account) 
**/
    public void createOppandRates(){
        System.Savepoint savePointObj = Database.setSavepoint();
        try{
            //Insert the new Opportunities List 
            Insert newOppObj;
            //renewedPlans set to store renewed plans for renewal opportunity 
            Set<String> renewedPlans = new Set<String>();
            //looping the current year plans to fetch the renewal plan and populate the data in benefit plan association records.
            for(Benefit_Plan_Association__c oldBpaObj : currentYearPlans){
                Benefit_Plan_Association__c newBpaObj = new Benefit_Plan_Association__c();
                //If only Medical Plans are available in renewal, then only renew the plans (Medical and Rider)
                //If medical plan is not available in renewal plans then the corresponding rider plans are not renewing even though they exists
                //This is manual activity for sales users if there is no plan is renewed
                if(oldNewBenefitMetadataNameMap.get(oldBpaObj.Benefit_Plan_Metadata__r.Name.subStringBefore(HighRoads_Constants.HYPHEN).trim()) != NULL ){
                    //Creating the medical plans for renewed opportunity
                    if(oldBpaObj.Raider_ID__c == NULL && !renewedPlans.contains(oldBpaObj.Benefit_Plan_Metadata__r.Name)){
                        newBpaObj.Name = oldNewBenefitMetadataNameMap.get(oldBpaObj.Benefit_Plan_Metadata__r.Name.subStringBefore(HighRoads_Constants.HYPHEN).trim());
                        newBpaObj.Benefit_Plan_Metadata__c = oldNewBenefitMetadataNameIDMap.get(oldBpaObj.Benefit_Plan_Metadata__r.Name.subStringBefore(HighRoads_Constants.HYPHEN).trim());
                        newBpaObj.EOC__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Benefit_Plan_Metadata__c).EOC__c;
                        newBpaObj.BCM__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Benefit_Plan_Metadata__c).BCM__c;
                        newBpaObj.Ancillary_EOC__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Benefit_Plan_Metadata__c).Ancillary_EOC__c;
                        newBpaObj.Ancillary_SOB__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Benefit_Plan_Metadata__c).Ancillary_SOB__c;
                        newBpaObj.Ancillary_GSA__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Benefit_Plan_Metadata__c).Ancillary_GSA__c;
                        newBpaObj.Version_Number__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Benefit_Plan_Metadata__c).Version_Number__c;
                        newBpaObj.Opportunity__c = newOppObj.Id;
                        renewalPlanList.add(newBpaObj); 
                        renewedPlans.add(oldBpaObj.Benefit_Plan_Metadata__r.Name);
                    }else{
                        //creating the rider plans for renewed opportunity
                        if(oldBpaObj.Raider_ID__r.Name != NULL && oldNewBenefitMetadataNameMap.get(oldBpaObj.Raider_ID__r.Name.subStringBefore(HighRoads_Constants.HYPHEN).trim()) != NULL && !renewedPlans.contains(oldBpaObj.Raider_ID__r.Name)){
                            newBpaObj.Name = oldNewBenefitMetadataNameMap.get(oldBpaObj.Benefit_Plan_Metadata__r.Name.subStringBefore(HighRoads_Constants.HYPHEN).trim());
                            newBpaObj.Benefit_Plan_Metadata__c = oldNewBenefitMetadataNameIDMap.get(oldBpaObj.Benefit_Plan_Metadata__r.Name.subStringBefore(HighRoads_Constants.HYPHEN).trim());
                            newBpaObj.Raider_ID__c = oldNewBenefitMetadataNameIDMap.get(oldBpaObj.Raider_ID__r.Name.subStringBefore(HighRoads_Constants.HYPHEN).trim());
                            newBpaObj.EOC__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Raider_ID__c).EOC__c;
                            newBpaObj.BCM__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Raider_ID__c).BCM__c;
                            newBpaObj.Ancillary_EOC__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Raider_ID__c).Ancillary_EOC__c;
                            newBpaObj.Ancillary_SOB__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Raider_ID__c).Ancillary_SOB__c;
                            newBpaObj.Ancillary_GSA__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Raider_ID__c).Ancillary_GSA__c;
                            newBpaObj.Version_Number__c = oldNewBenefitMetadataIDMap.get(newBpaObj.Raider_ID__c).Version_Number__c;
                            newBpaObj.Opportunity__c = newOppObj.Id;
                            renewalPlanList.add(newBpaObj);  
                            renewedPlans.add(oldBpaObj.Raider_ID__r.Name);
                        }
                    } 
                }
                
            }
            //Inserting the renewal plans if they are not empty
            if(renewalPlanList != NULL && !renewalPlanList.isEmpty()){
                Insert renewalPlanList;
            }
            //Creating rate cards and rates based on the old plan rate cards/rates
            if(scnRateCardMap != NULL && !scnRateCardMap.isEmpty()){
                //fetching the rates from the corresponding rate cards
                //only SCN rate card rates will be taken as the plans will be associated to account only when SCN is approved
                List<Rate_Card__c> rateCardList = [SELECT ID,Name,(Select Group_Alias_Name__c,Group_Type__c,Plan_Name__c,Medical_Plan_Rider_Plan__c,
                                                                   Plan_Type_Tier_Group__c,Rate_Card_ID__c,Rider_Plan_Name__c,Tier_1_Composite__c,
                                                                   Tier_2_EE__c,Tier_2_EF__c,Tier_3_EE__c,Tier_3_EE1__c,Tier_3_EE2__c,Tier_4_EC__c,
                                                                   Tier_4_EE__c,Tier_4_EF__c,Tier_4_ES__c,Tier_5_EC__c,Tier_5_ECH__c,Tier_5_EE__c,
                                                                   Tier_5_EF__c,Tier_5_ES__c,Tier_Type__c from Rates__r) FROM Rate_Card__c 
                                                   where ID IN:scnRateCardMap.values() order by createddate desc];
                //reatesMap is used to store the unique and rate record
                Map<String,Rates__c> ratesMap = new Map<String,Rates__c>();
                //creating rates if the rateCardList is not emtpy and not null
                if(rateCardList != NULL && !rateCardList.isEmpty()){
                    //Creating new rate card to associate all the rates with this rate card
                    //this rate card id will be populated in Rates and Renewed plans (Opportunity Rate Card)
                    Rate_Card__c newRcObj = new Rate_Card__c();
                    Insert newRcObj;
                    //looping through the ratecards and rates
                    for(Rate_Card__c oldRcObj : rateCardList){
                        for(Rates__c rateObj : oldRcObj.Rates__r){
                            Rates__c newRateObj = rateObj.clone(false,true);
                            newRateObj.Rate_Card_ID__c = newRcObj.Id;
                            //Plan_Type_Tier_Group__c is unique for each record, this is combination of 4 fields separated with UNDERSCORE
                            //1. Parent Record Id (Opportunity/RFP/Proposal/Sold Sign Off/Sold Case Notification)
                            //2. Medical or Rider Plan field on the Rate Object (which describes the rate belongs to medical plan or rider plan)
                            //   if it is a Medical then "{Medical Plan Name}_Medical" will be populated in this field
                            //   if it is a rider plan then "{Medical Plan Name}_{Rider Plan Name}" will be populated
                            //3. Tier Type - the user selected Tier
                            //4. Group Type - the user selected group
                            String[] planTypeTokens = rateObj.Plan_Type_Tier_Group__c.split(HighRoads_Constants.UNDERSCORE);
                            //Fetching the first token from the above string array - which is a record id
                            //This record Id will be populated with newly created record id i.e. opportunity
                            String recordId = planTypeTokens[0].replace(rateObj.Plan_Type_Tier_Group__c.subStringBefore(HighRoads_Constants.UNDERSCORE),newOppObj.Id);
                            //Populating other fields in new rate record.
                            if(oldNewBenefitMetadataNameMap.get(rateObj.Plan_Name__c.subStringBefore(HighRoads_Constants.HYPHEN).trim()) != NULL){
                                //replacing the old plan name with new plan name
                                String planName = planTypeTokens[1].replace(rateObj.Plan_Name__c,oldNewBenefitMetadataNameMap.get(rateObj.Plan_Name__c.subStringBefore(HighRoads_Constants.HYPHEN).trim()));
                                String medicalorRider = HighRoads_Constants.BLANK_VALUE;
                                //populating the medicalorRider variable based on the plan - if it is Medical then it will be Medical
                                //If it is rider then it will be populated with Rider Plan Name
                                if(planTypeTokens[2] == HighRoads_Constants.MEDICAL){
                                    medicalorRider = HighRoads_Constants.MEDICAL;
                                }else{
                                    medicalorrider = oldNewBenefitMetadataNameMap.get(planTypeTokens[2].subStringBefore(HighRoads_Constants.HYPHEN).trim());
                                    if(medicalorrider != NULL){
                                        newRateObj.Rider_Plan_Name__c = medicalorrider;
                                    }
                                }
                                //Forming unique with all 4 fields
                                newRateObj.Plan_Type_Tier_Group__c = recordId+HighRoads_Constants.UNDERSCORE+planName+HighRoads_Constants.UNDERSCORE+medicalorRider+HighRoads_Constants.UNDERSCORE+planTypeTokens[3]+HighRoads_Constants.UNDERSCORE+planTypeTokens[4];
                                newRateObj.Plan_Name__c = planName;
                                newRateObj.Medical_Plan_Rider_Plan__c = planName+HighRoads_Constants.UNDERSCORE+medicalorRider;
                                newRateObj.Opportunity__c = newOppObj.Id;
                                if(!ratesMap.containsKey(newRateObj.Plan_Type_Tier_Group__c)){
                                    ratesMap.put(newRateObj.Plan_Type_Tier_Group__c, newRateObj);
                                }
                            }
                        }
                    }
                    //If rates map not null and not empty, inserting adding the values to new list
                    //inserting the rates
                    if(ratesMap != NULL && !ratesMap.isEmpty()){
                        newRatesList.addAll(ratesMap.values());
                        Insert newRatesList;
                    }
                    //Updating the Opportunity Rate Card Id for the renewed Plans
                    for(Benefit_Plan_Association__c newBenefitPlanObj : renewalPlanList){
                        newBenefitPlanObj.Opportunity_Rate_Card__c = newRcObj.Id;
                        renewalPlanUpdateList.add(newBenefitPlanObj);
                    }
                    if(renewalPlanUpdateList != NULL && !renewalPlanUpdateList.isEmpty()){
                        Update renewalPlanUpdateList;
                    }
                }
            }
        }catch(Exception ex){
            //rollback the operation if any exception occurs during Opportunity creation/Plan Association/Rate Creation
            //inserting the exception message in System Exception object
            Database.rollback(savePointObj);systemException.ExceptionMessage__c = ex.getMessage();Database.Insert(systemException);
            //Giving message to user that some error occured during the renewal opportunity
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR122_ErrorinRenewalOpportunity));isErrorOccured = true;return;
        }
        //Giving a success message if opportunity is created succesfully
        if(newOppObj.Id != NULL){
            oppCreated = true;
            isExists = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.Label.HR123_OppCreated));
        }
    }
    /**
* Method Name : assignFieldData
* Parameters  : Account accObj,Opportunity newOppObj,Map<String,Contact> archivedConMap
* Return type : Opportunity
* Description : This method is used to assign the data from account and return the opportunity
**/
    public Opportunity assignFieldData(Account accObj,Opportunity newOppObj,Map<String,Contact> archivedConMap){
        newOppObj.name = accObj.Name;
        newOppObj.AccountId = accObj.Id;
        newOppObj.StageName = System.Label.Renewed_Opportunity_Stage;
        newOppObj.CloseDate = Date.today() + DateLimit;
        newOppObj.Current_Status__c = System.Label.Renewed_Opportunity_Current_Status;
        newOppObj.Description = System.Label.Renewed_Opportunity_Description +HighRoads_Constants.SINGLE_SPACE+accObj.Name;
        newOppObj.Renewed_Opportunity__c = true;
        newOppObj.Broker1__c = accObj.Broker__c;
        //un populating the Broker Rep if it is archived
        newOppObj.Broker_Rep1__c = !archivedConMap.containsKey(accObj.Broker_Rep__c) ? accObj.Broker_Rep__c : null;
        newOppObj.Actual_of_Members__c = accObj.SHP_Active_Members__c != NULL ? Decimal.valueOf(accObj.SHP_Active_Members__c) : NULL;
        newOppObj.Type = HighRoads_Constants.EXISTING_BUSINESS;
        return newOppObj;
    }
    
}