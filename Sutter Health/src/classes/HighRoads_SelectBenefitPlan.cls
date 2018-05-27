/*******************************************************************************************************************
Class Name : HighRoads_SelectBenefitPlan
Author     : IDC Offshore
Date       : 6/22/2016
Description: This controller class is used to select the benefit plans at Opportunity/RFP/Quote/SSO stages.

History:
VERSION    AUTHOR              DATE        DETAIL
1.0        IDC-Offshore        6/22/2016    This is controller class for HighRoads_SelectBenefitPlans and HighRoads_SelectBenefitPlanRiders page.
												is used to select the plans (Medical and Riders) at each stage except SCN
2.0        Deloitte            2/17/2017    SHP10 SHPRiderHDHP
3.0        Deloitte            3/07/2017    SHP15 Corrected query for Custom and Standard Plans
*******************************************************************************************************************/
public with sharing class HighRoads_SelectBenefitPlan {
    public List<RetrievePlanWrapper> retrievePlanList {get;set;}//list  to capture all the medical plans and associated rider plans
    public List<RiderPlanWrapper> riderPlanList{get;set;}//list to capture the new rider plans
    public List<RiderPlanWrapper> selectedriderPlanList{get;set;}//list to capture the existing rider plans
    public List<RiderPlanPageWrapper> riderPlanPageList{get;set;}//list to construct the wrapper to render it based on the product class in rider selection screen
    // variable to render all the plans in expand all mode
    String show = System.Label.HR47_True;
    //record id of the parent
    public string recordId{get;set;}
    public String oppId{get;set;}//page url parameter
    public String rfpId{get;set;}//page url parameter
    public String scnId{get;set;}//page url parameter
    public String quoteId{get;set;}//page url parameter
    public String ssoId{get;set;}//page url parameter
    public String searchElement{get; set;}//variable is used to bind the drop down value when user changes ex. standard / custom/ standardandcustom/not actively marketed
    public String selectedPlanId{get;set;}//to bind the medical plan id when user clicks on associate riders button
    public String selectedPlanName{get;set;}//used to bind the plan id when user clicks on change riders button
    public String searchPlanName{get;set;}// used to bind the searched plan name in the custom search on plan selection screen
    public boolean isSelectedAtleastOne = false;//used to find out whether the user selected atleast one plan or not
    public boolean isChiroAcuselected = false;//used to find out whether the user user selection chiroandacu rider plan while associating the riders
    public boolean isChiroSelected = false;//used to find out whether the user selected chiro plan
    public boolean isAcuSelected = false;//used to find out whether the user selected acu plan
    Map<String,Boolean> acuChiroMap{get;set;}//map used to store plan and whether that plan has acuchiromap rider earlier
    Map<String,Boolean> acuMap {get;set;}//map used to store plan and whether that plan has acu rider earlier
    Map<String,Boolean> chiroMap{get;set;}//map used to store plan and whether that plan has chiro rider earlier
    List<Benefit_Plan_Association__c> associatedRiderList{get;set;}//list to store the associated riders
    List<Benefit_Plan_Association__c> associatedPlanList{get;set;}//list to store the associated plans
    //map to store the medical plan and list of riderplanpagewrapper 
    //riderplanpagewrapper contains the rider plans based on the product class (Dental,Acu,Chiro,AcuChiro etc..)
    Map<String,List<RiderPlanPageWrapper>> riderPageMap = new Map<String,List<RiderPlanPageWrapper>>();
    //set to store the selected plan ids for the parent
    Set<String> selectedPlanIds{get;set;}
    //map to store the selected plan id and rider id
    //which will be used to check atleast one plan is selected
    Map<String,String> planRiderMap{get;set;}
    //map to store the existing medical and multiple riders 
    Map<String,Set<String>> riderExistingPageMap = new Map<String,Set<String>>();
    public string wherePart{get;set;}
    //instead of calling existing plans query, loading all the existing plans for standard , custom, not actively marketed etc.. 
    //setting this boolean value to true once the plans are loaded, when user changes the drop down value in plan selection scree
    //returning the old list to render the plans based on the selected plan
    public boolean isLoadedFirstTime = false;
    //page url paramter
    public string accountId{get;set;}
    //page url parameter
    public string employerType{get;set;}
    //constructor
    public HighRoads_SelectBenefitPlan (){
        oppId = ApexPages.currentpage().getparameters().get(System.Label.HR44_OppId);
        rfpId = ApexPages.currentpage().getparameters().get(System.Label.HR45_RfpId);
        scnId = ApexPages.currentpage().getparameters().get(System.Label.HR62_scnId);
        quoteId = ApexPages.currentpage().getparameters().get(HighRoads_Constants.QUOTE_ID);
        ssoId = ApexPages.currentpage().getparameters().get(HighRoads_Constants.SSO_ID);
        accountId = ApexPages.currentpage().getparameters().get(HighRoads_Constants.ACCOUNTID);
        employerType = ApexPages.currentpage().getparameters().get(HighRoads_Constants.EMPLOYER_TYPE);
        retrievePlanList = new List<RetrievePlanWrapper>();
        selectedPlanIds = new Set<String>();
        planRiderMap = new Map<String,String>();
        selectedriderPlanList  = new List<RiderPlanWrapper>();
        searchElement = System.Label.HR48_Standard;
        //calling the method to retrieve the existing plans
        retrievePlansforSearch();
    }
    /**
    * Method Name : getShow
    * Parameters  : none
    * Return type : string
    * Description : Is used in  Riders display page
    **/
    public String getShow() {
        return show;
    }
    
    /**
    * Method Name : checkSelectedValues
    * Parameters  : none
    * Return type : void
    * Description : Method is called when user selects the Medical Plan check box .
                    When this method called, selected plan will be true and when user clicks on the Sected Plans value in 
                    drop down then we are rendering this selected plan. This will not saved into database until user clicks on associate plans button
    **/
    public void checkSelectedValues(){
        for(RetrievePlanWrapper rpw : retrievePlanList){
            if(rpw.isSelected){
                rpw.isSelected = true;
            }else{
                rpw.isSelected = false;
            }
        }
    }
    
    /**
    * Method Name : retrievePlansforSearch
    * Parameters  : none
    * Return type : void
    * Description : Method is used to find the exisitng plans and new plans for selected Search Filter (Standara/Custom/Standard-Custom/Not Active)
    **/
    public void retrievePlansforSearch(){
        //searchElement = System.Label.HR49_Custom;
        //check the parent record is not null
        if(oppId != NULL){   
            //Calling the method to retrieve the existing plans
            retrieveExistingPlans(oppId,HighRoads_Constants.OPP_API_NAME);
            //setting the record id which will be used in calling some common code logic
            recordId = oppId;
            //calling the dynamic where part construction method
            wherePart = constructWherePart(oppId);
        }else if(rfpId != NULL){
            //Calling the method to retrieve the existing plans
            retrieveExistingPlans(rfpId,HighRoads_Constants.RFP_API_NAME);
            //setting the record id which will be used in calling some common code logic
            recordId = rfpId;
            //calling the dynamic where part construction method
            wherePart = constructWherePart(rfpId);
        }else if(quoteId != NULL){
            //Calling the method to retrieve the existing plans
            retrieveExistingPlans(quoteId,HighRoads_Constants.PROPOSAL_API_NAME);
            //setting the record id which will be used in calling some common code logic
            recordId = quoteId;
            //calling the dynamic where part construction method
            wherePart = constructWherePart(quoteId);
        }else if(ssoId != NULL){
            //Calling the method to retrieve the existing plans
            retrieveExistingPlans(ssoId,HighRoads_Constants.SSO_API_NAME);
            //setting the record id which will be used in calling some common code logic
            recordId = ssoId;
            //calling the dynamic where part construction method
            wherePart = constructWherePart(ssoId);
        }
        //Querying all the standard and custom plans from Benefit Plan Metadata
        //@SHP15
            String medicalPlanQueryBoth = HighRoads_Constants.MEDICAL_PLAN_QUERY+accountId+HighRoads_Constants.MEDICAL_PLAN_QUERY_1;
            medicalPlanQueryBoth = medicalPlanQueryBoth + HighRoads_Constants.AND_CONDITION_WITH_SPACE+wherePart+HighRoads_Constants.MEDICAL_PLAN_QEURY_2;
                   
        //checking plans are added to the medical plan wrapper list
        //first time only loading all the plans for that plan year and market segment
        //setting existing selected plan as true and other plans as false
        if(!isLoadedFirstTime){
            for(Benefit_Plan_Metadata__c metaData : Database.query(medicalPlanQueryBoth)){
                if(planRiderMap.containsKey(metaData.Id)){
                    retrievePlanList.add(new RetrievePlanWrapper(metaData,true,false));
                }else{
                    retrievePlanList.add(new RetrievePlanWrapper(metaData,false,false));
                }
            }
            //list to add existing rider plans
            List<String> existingRiders = new List<String>();
            for(Set<String> rider : riderExistingPageMap.values()){
                existingRiders.addAll(rider);
            }
            //Querying the existing riders
            for(Benefit_Plan_Metadata__c metaData : [SELECT ID,Name,EOC__c ,SBC__c ,BCM__c ,Ancillary_EOC__c ,Ancillary_SOB__c ,Ancillary_GSA__c,Version_Number__c,
                                                     Plan_Name__c,Benefit_Plan_ID__c,Visit_Limit__c,Rider_Cost_Share__c,Product_Class__c,isCustom__c,Plan_Type__c
                                                     FROM Benefit_Plan_Metadata__c WHERE Medical_OR_Rider__c = :System.Label.HR43_Rider AND
                                                     ID IN :existingRiders Order by Benefit_Plan_ID__c ])
            {
                //constructing the wrapper list for the existing rider plans with selected flag
                selectedriderPlanList.add(new RiderPlanWrapper(metaData,true));
            }
            //construcing the medical plan and associated rider plan map
            Map<String,List<RiderPlanWrapper>> riderPlanMapp = new Map<String,List<RiderPlanWrapper>>();
            for(RetrievePlanWrapper rpw : retrievePlanList){
                for(RiderPlanWrapper rider : selectedriderPlanList){
                    if(riderExistingPageMap.containsKey(rpw.plan) && riderExistingPageMap.get(rpw.plan).contains(rider.riderId) )
                    {
                        rpw.planWithRiderList.add(rider);
                    }
                }
                
            }
            isLoadedFirstTime = true;
        }
        //throwing error message if no plans (new/existing) for the plan year/market segment
        //user need to change/enter the plan year or market segment
        if(retrievePlanList == NULL || retrievePlanList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.Label.HR125_NoPlansForMarketSegment));
        }
    }
    
    /**
    * Method Name : sortPlans
    * Parameters  : none
    * Return type : PageReference
    * Description : Method is used to filter the plans based on the search term in the search box. Matching plans will be rendered at top and rest follows.
    **/
    public PageReference sortPlans(){
        //search element value which has given by user in plan selection screen
        searchElement = System.Label.HR48_Standard+System.Label.HR49_Custom;
        //variable to set to true if matching plans found
        //will be false if no matching plan found
        //based on the flag, info message will be shown to user when they perform search using the custom search option in plan seleciton screen
        boolean isMatchingFound = false;
        //checking the search value is < 3 characters
        //if yes, throwing error message to user to enter atleast 3 characters to perform custom search
        if(searchPlanName.length() < 3){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,HighRoads_Constants.SEARCH_INPUT_LENGTH_MSG));
        }else{
            //forming first list and second list as we are not hitting the data base again to retrieve the plans based on the custom search value
            //in first list, all the matching plans will be added
            //in second list, all the un matching plans will be added
            //final list will be constructed based on these two list so that user will see the matching plans first others next
            List<RetrievePlanWrapper> firstList = new List<RetrievePlanWrapper>();
            List<RetrievePlanWrapper> secondList = new List<RetrievePlanWrapper>();
            for(RetrievePlanWrapper rpw : retrievePlanList){
                String rpwPlanName = rpw.planId.toUpperCase();
                String searchPlan = searchPlanName.toUpperCase();
                if(rpwPlanName.contains(searchPlan)){
                    firstList.add(rpw);
                    isMatchingFound = true;
                }else{
                    secondList.add(rpw);
                }
            }
            //clearing all the existing values to add the first list and second list to retrieve plan list
            retrievePlanList.clear();
            retrievePlanList.addAll(firstList);
            retrievePlanList.addAll(secondList);
        }
        //to show info message
        if(!isMatchingFound){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.Label.HR126_NoPlansFound));
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.Label.HR127_SearchResultsonTop));
        }
        return null;
    }  
    
    /**
    * Method Name : getSearchPlans
    * Parameters  : none
    * Return type : List<SelectOption>
    * Description : To display values in the filter dropdown
    **/
    public List<SelectOption> getSearchPlans() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(System.Label.HR48_Standard,System.Label.HR50_StandardOnly));
        options.add(new SelectOption(System.Label.HR49_Custom,System.Label.HR51_CustomOnly));
        options.add(new SelectOption(System.Label.HR128_SelectedPlans,System.Label.HR129_Selected_Plans));
        options.add(new SelectOption(System.Label.HR130_NotActivelyMarketed,System.Label.HR131_Not_Actively_Marketed));
        return options;
    }
    
    /**
    * Method Name : getSearchPlans
    * Parameters  : ID of the record
    * Return type : String
    * Description : To construct the dynamic where condition based on the custom setting filter values
    **/
    public String constructWherePart(ID recID){
        //constructing where part to add this where part in dynamic query
        //this where part will be constructed based on the custom setting Beneit Plan Data Filters
        String wherePart='';
        //getting objectname based on the record id
        String objectName = recId.getSObjectType().getDescribe().getName();
        //retrieving the custom setting vallues
        List<Benefit_Plan_Data_Filters__c> filterList = Benefit_Plan_Data_Filters__c.getAll().values();
        //forming dynamic query
        String dynaQuery = HighRoads_Constants.WHERE_PART_QUERY;
        //forming the Reference Field API, this field should exists in the object where plan selection is happening
        //adding all those fields to string with comma separation which will be used in dynamic query to pull data
        for(Benefit_Plan_Data_Filters__c filter : filterList){
            if(filter.Reference_Field_API__c != NULL){
                dynaQuery += filter.Reference_Field_API__c+HighRoads_Constants.COMMA;
            }
        }
        //to remove the comma at the end
        dynaQuery = dynaQuery.removeEnd(HighRoads_Constants.COMMA);
        dynaQuery = dynaQuery+HighRoads_Constants.FROM_KEY_WORD+objectName+HighRoads_Constants.WHERE_PART_QUERY_1;
        //running the dynamica query to pull the above field data
        sObject sObj = Database.query(dynaQuery);
        //map to set the field and its value from the object
        Map<String,String> fieldValMap = new Map<String,String>();
        for(Benefit_Plan_Data_Filters__c filter1 : filterList){
            if(filter1.Reference_Field_API__c != NULL){
                fieldValMap.put((String)filter1.Reference_Field_API__c, (String)sObj.get(filter1.Reference_Field_API__c));
            }
        }
        //consctruing actual where part once the values retrieve from the parent
        for(Benefit_Plan_Data_Filters__c filter2 : filterList){
            //condition to check the operator in custom setting is = and field value (hard code value) is null
            if(filter2.Operator__c == HighRoads_Constants.EQUALS_SYMBOL && filter2.Field_Value__c != NULL){
                wherePart+= filter2.Name +HighRoads_Constants.SINGLE_SPACE+ filter2.Operator__c +HighRoads_Constants.SINGLE_SPACE+ HighRoads_Constants.BACK_SLASH+filter2.Field_Value__c+HighRoads_Constants.BACK_SLASH+HighRoads_Constants.SINGLE_SPACE+HighRoads_Constants.AND_CONDITION_WITH_SPACE;
            }
            //condition to check the operator in custom setting is = and field value is hard coded value is not null
            else if(filter2.Operator__c == HighRoads_Constants.EQUALS_SYMBOL && filter2.Field_Value__c == NULL && filter2.Reference_Field_API__c != NULL){
                wherePart+= filter2.Name +HighRoads_Constants.SINGLE_SPACE+ filter2.Operator__c +HighRoads_Constants.SINGLE_SPACE+HighRoads_Constants.BACK_SLASH+ fieldValMap.get(filter2.Reference_Field_API__c) +HighRoads_Constants.BACK_SLASH+HighRoads_Constants.SINGLE_SPACE+ HighRoads_Constants.AND_CONDITION_WITH_SPACE;
            }
            //if the operator is INCLUDES key word, then constructing the where part as per INCLUDES key word
            else if(filter2.Operator__c == HighRoads_Constants.INCLUDES_KEY_WORD && filter2.Field_Value__c == NULL && filter2.Reference_Field_API__c != NULL){
                //If the account record type name is SHP Sales Individual, that will not have market segment
                //hence setting the market segment manually to Individual to pull the plans from metadata
                if(sObj.get(HighRoads_Constants.ACC_REC_TYPE_API) == System.Label.HR80_SHPSalesIndividual && filter2.Reference_Field_API__c == HighRoads_Constants.EMPLOYER_TYPE_API){
                    String marketSegments = System.Label.HR03_MarketSegment_IND;
                    wherePart+= filter2.Name +HighRoads_Constants.SINGLE_SPACE+ filter2.Operator__c +HighRoads_Constants.SINGLE_SPACE+HighRoads_Constants.LEFT_BRACKET+HighRoads_Constants.BACK_SLASH+marketSegments+HighRoads_Constants.BACK_SLASH+HighRoads_Constants.NA_IN_QUERY+HighRoads_Constants.SINGLE_SPACE+HighRoads_Constants.AND_CONDITION_WITH_SPACE;
                }
                //If the account record type is SHP Sales Employer / SHP Sales Employer Read Only
                //pulling the market segment value from P2A Market Segment Mapping custom setting based on the Employer Type field on account
                else if(sObj.get(HighRoads_Constants.ACC_REC_TYPE_API) == System.Label.HR53_AccountRecordTypeName && filter2.Reference_Field_API__c == HighRoads_Constants.EMPLOYER_TYPE_API){
                    SF_P2A_Market_Segments_Mapping__c marketSegment = SF_P2A_Market_Segments_Mapping__c.getInstance(fieldValMap.get(filter2.Reference_Field_API__c));
                    wherePart+= filter2.Name +HighRoads_Constants.SINGLE_SPACE+ filter2.Operator__c +HighRoads_Constants.SINGLE_SPACE+HighRoads_Constants.LEFT_BRACKET+HighRoads_Constants.BACK_SLASH+marketSegment.P2A_Market_Segment__c+HighRoads_Constants.BACK_SLASH+HighRoads_Constants.NA_IN_QUERY+HighRoads_Constants.SINGLE_SPACE+HighRoads_Constants.AND_CONDITION_WITH_SPACE;
                }
                //if includes key word is used for any other field, constructing the where part according to that
                else{
                    wherePart+= filter2.Name +HighRoads_Constants.SINGLE_SPACE+ filter2.Operator__c +HighRoads_Constants.SINGLE_SPACE+HighRoads_Constants.LEFT_BRACKET+HighRoads_Constants.BACK_SLASH+ fieldValMap.get(filter2.Reference_Field_API__c) +HighRoads_Constants.BACK_SLASH+HighRoads_Constants.RIGHT_BRACKET+HighRoads_Constants.SINGLE_SPACE+HighRoads_Constants.AND_CONDITION_WITH_SPACE;
                }
            }
            //where part construction for IN keyword based on the hard coded value in field value
            else if(filter2.Operator__c == HighRoads_Constants.IN_KEY_WORD && filter2.Field_Value__c != NULL && filter2.Reference_Field_API__c == NULL){
                String[] fieldValues = filter2.Field_Value__c.split(HighRoads_Constants.COMMA);
                wherePart+= filter2.Name +HighRoads_Constants.SINGLE_SPACE+ filter2.Operator__c +HighRoads_Constants.SINGLE_SPACE+HighRoads_Constants.LEFT_BRACKET;
                String values = HighRoads_Constants.BLANK_VALUE;
                for(String fieldValue : fieldValues){
                    values +=HighRoads_Constants.BACK_SLASH+fieldValue+HighRoads_Constants.BACK_SLASH+HighRoads_Constants.COMMA;
                }
                values = values.substringBeforeLast(HighRoads_Constants.COMMA);
                wherePart+= values+HighRoads_Constants.RIGHT_BRACKET+HighRoads_Constants.SINGLE_SPACE+HighRoads_Constants.AND_CONDITION_WITH_SPACE;
            }
        }
        //forming the where part by removing any extra words or spaces in the string
        wherePart = wherePart.substringBeforeLast(HighRoads_Constants.AND_CONDITION_WITH_SPACE.trim());
        
        return wherePart;
    }
    
    /**
    * Method Name : retrieveExistingPlans
    * Parameters  : ID recordId,String relationShipName
    * Return type : void
    * Description : To retrieve the existing plans and construct the wrapper class object
    **/
    public void retrieveExistingPlans(ID recordId,String relationShipName){
        //this method will be called when the page is loaded
        //query to pull the existing medical plans for the parent
        String medicalPlanQuery = HighRoads_Constants.EXISTING_PLAN_QUERY+relationShipName+HighRoads_Constants.EQUALS_SYMBOL+HighRoads_Constants.BACK_SLASH+recordId+HighRoads_Constants.BACK_SLASH+HighRoads_Constants.AND_CONDITION_WITH_SPACE+HighRoads_Constants.EXISTING_PLAN_QUERY_1;
        //query to pull the existing rider plan for the parent
        String riderPlanQuery = HighRoads_Constants.EXISTING_PLAN_QUERY+relationShipName+HighRoads_Constants.EQUALS_SYMBOL+HighRoads_Constants.BACK_SLASH+recordId+HighRoads_Constants.BACK_SLASH+HighRoads_Constants.AND_CONDITION_WITH_SPACE+HighRoads_Constants.EXISTING_PLAN_QUERY_2;
        //construcitng the map to identify the plan is existing plan or not
        for(Benefit_Plan_Association__c bpa : Database.query(medicalPlanQuery)){
            planRiderMap.put(bpa.Benefit_Plan_Metadata__c,bpa.Raider_ID__c); 
        }
        //constructing map for each plan and associated riders
        for(Benefit_Plan_Association__c bpa : Database.query(riderPlanQuery)){
            if(riderExistingPageMap.containsKey(bpa.Benefit_Plan_Metadata__c))   {
                Set<String> riders = new Set<String>();
                riders = riderExistingPageMap.get(bpa.Benefit_Plan_Metadata__c);
                riders.add(bpa.Raider_ID__c);
                riderExistingPageMap.put(bpa.Benefit_Plan_Metadata__c,riders);
            }else{
                Set<String> riders = new Set<String>();
                riders.add(bpa.Raider_ID__c);
                riderExistingPageMap.put(bpa.Benefit_Plan_Metadata__c,riders);
            }
        }
    }
    
    /**
    * Method Name : associatePlans
    * Parameters  : none
    * Return type : void
    * Description : When user clicks on the associate plans button, this method will be called.
    *                                                         Associates all the selected plans/riders for that record.
    **/
    public void associatePlans(){
        //setting save point to rollback the operation if any exception occurs
        System.savePoint savePointObj = Database.setSavepoint();
        try{
            associatedPlanList = new List<Benefit_Plan_Association__c>();
            associatedRiderList = new List<Benefit_Plan_Association__c>();
            //set to store the deselected plans ids
            Set<ID> deselectedPlanIds = new Set<ID>();
            //map to store the medical plan and deselected the plan associated riders
            Map<String,Set<String>> deselectedRiderMap = new Map<String,Set<String>>();
            //list to add the plans which need to be deleted
            List<Benefit_Plan_Association__c> deletePlanAssociation = new List<Benefit_Plan_Association__c>();
            //looping through the medical plans and associated riders while associating the plans
            for(RetrievePlanWrapper rpw : retrievePlanList){
                //checking the plan is selected
                if(rpw.isSelected){
                    //if plan is selected setting atleastone plan is selected flag to true
                    //if this flag is false and user clicks on the associate plans, error will throw to user to select atleast one plan
                    isSelectedAtleastOne = true;
                    //checking the plan is not existing plan, this map constructed during the page load
                    if(!planRiderMap.containsKey(rpw.plan)){
                        //setting the values again because, the values may change in metadata whenever the grid updated
                        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
                        bpa.Benefit_Plan_Metadata__c = rpw.plan;
                        bpa.Name = rpw.planId;
                        bpa.EOC__c = rpw.eoc;
                        bpa.SBC__c = rpw.sbc;
                        bpa.BCM__c = rpw.bcm;
                        bpa.Ancillary_EOC__c = rpw.ancillayeoc;
                        bpa.Ancillary_SOB__c = rpw.ancillaysob;
                        bpa.Ancillary_GSA__c = rpw.ancillaygsa;
                        //calling utility method to populate the version for the plan
                        bpa = populateParentandVersion(bpa,recordId,null,rpw,HighRoads_Constants.MEDICAL);
                        //adding the plan to associatedplanlist to insert
                        associatedPlanList.add(bpa);
                        //checking rider plans for the medical plans are not null
                        if(rpw.planWithRiderList != NULL){
                            //looping through the rider plans for the medical plan
                            for(RiderPlanWrapper riderPlan : rpw.planWithRiderList){
                                Benefit_Plan_Association__c riderbpa = new Benefit_Plan_Association__c();
                                //calling the utility methods to populate rider plan data
                                riderbpa = populateRiderData(riderbpa,riderPlan,rpw);
                                riderbpa = populateParentandVersion(riderbpa,recordId,riderPlan,null,HighRoads_Constants.RIDER);
                                //adding the rider to associatedriders list to insert
                                associatedPlanList.add(riderbpa);
                            }
                        }
                    }
                    //check for the existing plan, user has added/removed any plan
                    else if(planRiderMap.containsKey(rpw.plan)){
                        //fetching the existing rider plans using the map which has constructed on page load
                        Set<String> existingRiderPlans = riderExistingPageMap.get(rpw.plan);
                        //list to store the existing rider plan list
                        List<String> existingRiderPlanList = new List<String>();
                        if(existingRiderPlans != NULL){
                            existingRiderPlanList.addAll(existingRiderPlans);
                        }
                        //for the particular existing plan, riders were exists earlier but now user has removed all the riders
                        if(existingRiderPlans != NULL && rpw.planWithRiderList == NULL){
                            //storing those plans into deselectedridermap
                            deselectedRiderMap.put(rpw.plan, riderExistingPageMap.get(rpw.plan));
                            
                        }
                        //existing rider plans are not null, but checking the condition to identify whether user has added/removed some of the plans
                        else if(existingRiderPlans != NULL && rpw.planWithRiderList != NULL){
                            //set to store the current selected plans including existing plans
                            Set<String> currentSelectedPlans = new Set<String>();
                            
                            for(RiderPlanWrapper riderPlan : rpw.planWithRiderList){
                                currentSelectedPlans.add(riderPlan.riderId);
                                
                            }
                            //checking the existing plan is not part of the current selected plan
                            //if the existing rider plan is not part of the current selected list
                            //storing those plans in the set to deassociate them from the parent
                            for(String existingRiderPlan : existingRiderPlanList){
                                if(!currentSelectedPlans.contains(existingRiderPlan)){
                                    if(deselectedRiderMap.containsKey(rpw.plan)){
                                        Set<String> existingRider = deselectedRiderMap.get(rpw.plan);
                                        existingRider.add(existingRiderPlan);
                                        deselectedRiderMap.put(rpw.plan, existingRider);
                                    }else{
                                        Set<String> existingRider = new Set<String>();
                                        existingRider.add(existingRiderPlan);
                                        deselectedRiderMap.put(rpw.plan, existingRider);
                                    }
                                }
                                
                            }
                            //adding the riders to medical plan which are newly selected
                            for(RiderPlanWrapper riderPlan : rpw.planWithRiderList){
                                if(riderPlan.associate && !existingRiderPlans.contains(riderPlan.riderId)){
                                    Benefit_Plan_Association__c riderbpa = new Benefit_Plan_Association__c();
                                    riderbpa = populateRiderData(riderbpa,riderPlan,rpw);
                                    riderbpa = populateParentandVersion(riderbpa,recordId,riderPlan,null,HighRoads_Constants.RIDER);
                                    associatedPlanList.add(riderbpa);
                                }
                            }
                            
                        }
                        //if existing rider plans are null and currently user selected new rider plans for medical plan
                        else if(existingRiderPlans == NULL && rpw.planWithRiderList != NULL){
                            for(RiderPlanWrapper riderPlan : rpw.planWithRiderList){
                                Benefit_Plan_Association__c riderbpa = new Benefit_Plan_Association__c();
                                //populating the rider plan data calling utility methods
                                riderbpa = populateRiderData(riderbpa,riderPlan,rpw); 
                                riderbpa = populateParentandVersion(riderbpa,recordId,riderPlan,null,HighRoads_Constants.RIDER);                        
                                associatedPlanList.add(riderbpa);
                            }
                        }
                    }
                }
                //medical is selected earlier but now deselected
                //adding those plans to list to deassociate them from parent
                if(planRiderMap.containsKey(rpw.plan) && !rpw.isSelected){
                    deselectedPlanIds.add(rpw.plan);
                }
            }
            //if deselected medical plan are not empty, removing the association for that plan from parent
            if(!deselectedPlanIds.isEmpty()){
                List<Benefit_Plan_Association__c> deassociatePlanList = [select id,Opportunity__c,RFP_Form__c,Sold_Case_Notification__c,Proposal__c,Sold_Sign_Off__c from Benefit_Plan_Association__c
                                                                         where Benefit_Plan_Metadata__c IN :deselectedPlanIds];
                if(recordId != NULL){
                    for(Benefit_Plan_Association__c planAssociation : deassociatePlanList){
                        //if the plan seletion is for opportunity
                        if(recordId == planAssociation.Opportunity__c){
                            deletePlanAssociation = removeAssociationFromParent(deletePlanAssociation,planAssociation,HighRoads_Constants.OPP_API_NAME);
                        }
                        //if the plan seletion is for RFP
                        else if(recordId == planAssociation.RFP_Form__c){
                            deletePlanAssociation = removeAssociationFromParent(deletePlanAssociation,planAssociation,HighRoads_Constants.RFP_API_NAME);
                        }
                        //if the plan seletion is for Proposal
                        else if(recordId == planAssociation.Proposal__c){
                            deletePlanAssociation = removeAssociationFromParent(deletePlanAssociation,planAssociation,HighRoads_Constants.PROPOSAL_API_NAME);
                        }
                        //if the plan seletion is for Sold Sign off
                        else if(recordId == planAssociation.Sold_Sign_Off__c){
                            deletePlanAssociation = removeAssociationFromParent(deletePlanAssociation,planAssociation,HighRoads_Constants.SSO_API_NAME);
                        }
                    }
                }
            }
            //checking the deselected rider map is empty
            if(!deselectedRiderMap.isEmpty()){
                List<String> riderPlans = new List<String>();
                for(Set<String> stringList : deselectedRiderMap.values()){
                    for(String innerString : stringList){
                        riderPlans.add(innerString);
                    }
                }
                //querying the deselected rider plans
                List<Benefit_Plan_Association__c> deassociatePlanList = [select id,Opportunity__c,RFP_Form__c,Sold_Case_Notification__c,Proposal__c,
                                                                         Sold_Sign_Off__c,Benefit_Plan_Metadata__c,Raider_ID__c
                                                                         from Benefit_Plan_Association__c
                                                                         where Benefit_Plan_Metadata__c IN :deselectedRiderMap.keySet()
                                                                         AND Raider_ID__c IN :riderPlans];
                //deassociting the plan from parent by calling the utility method
                if(recordId != NULL){
                    for(Benefit_Plan_Association__c planAssociation : deassociatePlanList){
                        //if the plan seletion is for opportunity
                        if(recordId == planAssociation.Opportunity__c && deselectedRiderMap.get(planAssociation.Benefit_Plan_Metadata__c).contains(planAssociation.Raider_ID__c)) {
                            deletePlanAssociation = removeAssociationFromParent(deletePlanAssociation,planAssociation,HighRoads_Constants.OPP_API_NAME);
                        }
                        //if the plan seletion is for RFP
                        else if(recordId == planAssociation.RFP_Form__c && deselectedRiderMap.get(planAssociation.Benefit_Plan_Metadata__c).contains(planAssociation.Raider_ID__c)){
                            deletePlanAssociation = removeAssociationFromParent(deletePlanAssociation,planAssociation,HighRoads_Constants.RFP_API_NAME);
                        }
                        //if the plan seletion is for Proposal
                        else if(recordId == planAssociation.Proposal__c && deselectedRiderMap.get(planAssociation.Benefit_Plan_Metadata__c).contains(planAssociation.Raider_ID__c)){
                            deletePlanAssociation = removeAssociationFromParent(deletePlanAssociation,planAssociation,HighRoads_Constants.PROPOSAL_API_NAME);
                        }
                        ////if the plan seletion is for Sold Sign Off
                        else if(recordId == planAssociation.Sold_Sign_Off__c && deselectedRiderMap.get(planAssociation.Benefit_Plan_Metadata__c).contains(planAssociation.Raider_ID__c)){
                            deletePlanAssociation = removeAssociationFromParent(deletePlanAssociation,planAssociation,HighRoads_Constants.SSO_API_NAME);
                        }
                    }
                }
            }
            //updating the plans
            if(!deletePlanAssociation.isEmpty()){
                update deletePlanAssociation;
            }
            //throwing erro message if no plan selected
            if(!isSelectedAtleastOne && planRiderMap.isEmpty()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR132_SelectAtleastOnePlan));
                return;
            }
            
            //inserting newly associated plans
            if(!associatedPlanList.isEmpty()){
                Insert associatedPlanList;
            }
            //inserting newly associated rider plans
            if(!associatedRiderList.isEmpty()){
                Insert associatedRiderList;
            }
        }catch(DMLException ex){ Database.rollback(savePointObj); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        
    }
    /**
    * Method Name : removeAssociationFromParent
    * Parameters  : List<Benefit_Plan_Association__c> deletePlanAssociation,Benefit_Plan_Association__c planAssociation,String fieldAPI
    * Return type : List<Benefit_Plan_Association__c>
    * Description : Helper method to remove association from parent like opportunity,rfp,proposal, sold sign off
    **/
    public List<Benefit_Plan_Association__c> removeAssociationFromParent(List<Benefit_Plan_Association__c> deletePlanAssociation,Benefit_Plan_Association__c planAssociation,String fieldAPI){
        planAssociation.put(fieldAPI,NULL);
        deletePlanAssociation.add(planAssociation); 
        return deletePlanAssociation;
    }
    /**
    * Method Name : redirectToRiders
    * Parameters  : none
    * Return type : PageReference
    * Description : When user clicks on the associate riders button, it will redirected to rider selection page.
    **/
    public PageReference redirectToRiders()
    {
        //if user not selected the check but clicked on the associateriders button
        //throwing error message to user to select the checkbo
        for(RetrievePlanWrapper rpw : retrievePlanList){
            if(rpw.plan == selectedPlanId && !rpw.isSelected){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR133_SelectCheckboxToRiderAsso));
                return null;
            }
        }
        //adding all product family values to list, to display the rider plans based on this
        //either HMO,HMO - Plus, HDHP
        List<String> productFamily = new List<String>();
        //checking the selected plan is hdhp or ot
        Benefit_Plan_Metadata__c bpm = [select isHDHP__c, isHMO__c from Benefit_Plan_Metadata__c where id=:selectedPlanId LIMIT 1];
        //if this plan already contains any selected riders
        if(!riderPageMap.containsKey(selectedPlanId) ){
            //list to store existing rider plans
            List<RiderPlanWrapper> existingriderPlanList  = new List<RiderPlanWrapper>();
            //set to store exisitng rider ids
            Set<String> existingRiderIds = new Set<String>();
            if(riderExistingPageMap.containsKey(selectedPlanId)){
                for(String riders : riderExistingPageMap.get(selectedPlanId)){
                    existingRiderIds.add(riders);
                }
            }
            //constructing the dynamic query for riders from data base which are not already selected
            String notExistingRiderQuery = HighRoads_Constants.NOT_EXISTING_PLAN_QUERY+accountId + HighRoads_Constants.NOT_EXISTING_PLAN_QEURY_1;
            if(bpm != NULL){
                if(bpm.isHDHP__c)
                {
                    //adding condition based on the HDHP or not
                    notExistingRiderQuery+= +HighRoads_Constants.NOT_EXISTING_PLAN_QEURY_HDHP + HighRoads_Constants.EQUALS_TRUE+HighRoads_Constants.COMMA;
                }
                if(bpm.isHMO__c)
                {
                    //adding condition based on the HMO
                    notExistingRiderQuery = notExistingRiderQuery.removeEnd(HighRoads_Constants.COMMA);
                    notExistingRiderQuery+= +HighRoads_Constants.NOT_EXISTING_PLAN_QEURY_HMO + HighRoads_Constants.EQUALS_TRUE+HighRoads_Constants.COMMA;
                }
                if(!bpm.isHDHP__c && !bpm.isHMO__c){
                    notExistingRiderQuery+= +HighRoads_Constants.NOT_EXISTING_PLAN_QEURY_HDHP + HighRoads_Constants.EQUALS_FALSE;
                    notExistingRiderQuery+= +HighRoads_Constants.NOT_EXISTING_PLAN_QEURY_HMO + HighRoads_Constants.EQUALS_FALSE+HighRoads_Constants.COMMA;
                }
            }
            //final not exising rider query
            notExistingRiderQuery = notExistingRiderQuery.removeEnd(HighRoads_Constants.COMMA)+HighRoads_Constants.AND_CONDITION_WITH_SPACE+wherePart+HighRoads_Constants.MEDICAL_PLAN_QEURY_2;
            //adding existing riders as selected in rider plan selection screen
            system.debug(bpm);
            system.debug(notExistingRiderQuery);
            if(planRiderMap.containsKey(selectedPlanId)){
                for(Benefit_Plan_Metadata__c metaData : [SELECT ID,Name,EOC__c ,SBC__c ,BCM__c ,Ancillary_EOC__c ,Ancillary_SOB__c ,Ancillary_GSA__c,Version_Number__c,Plan_Name__c,Benefit_Plan_ID__c,IsCustom__C,Visit_Limit__c,Rider_Cost_Share__c,Product_Class__c
                                                         FROM Benefit_Plan_Metadata__c WHERE Medical_OR_Rider__c = :System.Label.HR43_Rider AND
                                                         ID IN :existingRiderIds Order by Plan_Name__c]){
                                                             existingriderPlanList.add(new RiderPlanWrapper(metaData,true));
                                                         }
            }
            //list to add new rider plans
            riderPlanList  = new List<RiderPlanWrapper>();
            //list to display the riders based on the product class (Dental,Acu,Chiro etc..)
            riderPlanPageList = new List<RiderPlanPageWrapper>();
            //map to store medical plan and rider plans to select
            Map<String,List<RiderPlanWrapper>> riderPlanMap = new Map<String,List<RiderPlanWrapper>>();
            if(!existingriderPlanList.isEmpty()){
                riderPlanList.addAll(existingriderPlanList);
                for(Benefit_Plan_Metadata__c metaData : Database.query(notExistingRiderQuery)){     
                    riderPlanList.add(new RiderPlanWrapper(metaData,false));
                }
            }else{
                for(Benefit_Plan_Metadata__c metaData : Database.query(notExistingRiderQuery)){     
                    riderPlanList.add(new RiderPlanWrapper(metaData,false));
                }
            }
            //construcitng the rider plan map to display them based on the product class
            for(Integer i=0;i<riderPlanList.size();i++){
                if(riderPlanMap.containsKey(riderPlanList[i].productClass)){
                    List<RiderPlanWrapper> rpwList = new List<RiderPlanWrapper>();
                    rpwList=riderPlanMap.get(riderPlanList[i].productClass);
                    rpwList.add(riderPlanList[i]);
                    riderPlanMap.put(riderPlanList[i].productClass,rpwList);
                }else{ 
                    List<RiderPlanWrapper> rpwList = New List<RiderPlanWrapper>();
                    rpwList.add(riderPlanList[i]);
                    riderPlanMap.put(riderPlanList[i].productClass,rpwList);
                }
            }
            List<String> keyGetValues = New List<String>();
            keyGetValues.addall(riderPlanMap.keySet());
            //adding the values to riderplanpagelist which will be rendered in the rider plan selection screen
            for(integer i=0;i<keyGetValues.size();i++)
            {
                RiderPlanPageWrapper rider = New RiderPlanPageWrapper();
                rider.productClass = keyGetValues[i];
                rider.riderList = riderPlanMap.get(keyGetValues[i]);
                riderPlanPageList.add(rider);
            }
            riderPageMap.put(selectedPlanId, riderPlanPageList);
        }else{
            riderPlanPageList = riderPageMap.get(selectedPlanId);
        }
        
        PageReference pageRef = page.HighRoads_SelectBenefitPlanRiders;
        pageRef.getParameters().put(System.Label.HR44_OppId, oppId);
        pageRef.getParameters().put(System.Label.HR45_RfpId, rfpId);
        pageRef.getParameters().put(HighRoads_Constants.QUOTE_ID, quoteId);
        pageRef.getParameters().put(HighRoads_Constants.SSO_ID, ssoId);
        pageRef.getParameters().put(System.Label.HR62_scnId, scnId);
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    /**
    * Method Name : associateRiders
    * Parameters  : none
    * Return type : PageReference
    * Description : When user clicks on the associate button, it will associate the selected riders with the particular plan.
    **/
    public PageReference associateRiders()
    {
        //boolean value to identify atleast one rider is selected or not
        boolean isSelectedAtleastOne = false;
        //intializing the acuchiromap 
        acuChiroMap = new Map<String,Boolean>();
        //intializing the acumap 
        acuMap = new Map<String,Boolean>();
        //intializing the chiromap 
        chiroMap = new Map<String,Boolean>();
        //map to set medical plan and list of rider plans selected
        Map<String,List<RiderPlanWrapper>> constructMap = new Map<String,List<RiderPlanWrapper>>();
        for(Integer i=0;i<riderPlanPageList.size();i++){
            for(RiderPlanWrapper rpw : riderPlanPageList[i].riderList){
                if(rpw.associate){
                    
                    isSelectedAtleastOne = true;
                    if(constructMap.containsKey(selectedPlanId)){
                        List<RiderPlanWrapper> rpwList = new List<RiderPlanWrapper>();
                        rpwList=constructMap.get(selectedPlanId);
                        rpwList.add(rpw);
                        constructMap.put(selectedPlanId,rpwList);
                        selectedPlanIds.add(selectedPlanId);
                    }else{
                        List<RiderPlanWrapper> rpwList = New List<RiderPlanWrapper>();
                        rpwList.add(rpw);
                        constructMap.put(selectedPlanId,rpwList);
                        selectedPlanIds.add(selectedPlanId);
                    }
                }
            }
        }
        //setting the rider plans to medical plan
        for(RetrievePlanWrapper rpw : retrievePlanList){
            if(constructMap.containsKey(rpw.plan)){
                rpw.planWithRiderList = constructMap.get(rpw.plan);
            }else if(rpw.plan == selectedPlanId && constructMap.isEmpty()){
                rpw.planWithRiderList = null;
            }
        }
        //boolean value is used to identify the user has selected acu/chiro plan along with acuchiro plan
        //this should not be selected - if user selected, throwing the error message
        Boolean multipleSelected = false;
        for(RetrievePlanWrapper rpw : retrievePlanList){
            if(rpw.planWithRiderList != NULL){
                for(RiderPlanWrapper rider : rpw.planWithRiderList){
                    if(rider.productClass.equalsIgnoreCase(System.Label.HR82_ChiroAcu)){
                        acuChiroMap.put(rpw.Plan, true);
                    }else if(rider.productClass.equalsIgnoreCase(System.Label.HR83_Chiro)){
                        chiroMap.put(rpw.Plan, true);
                    }else if(rider.productClass.equalsIgnoreCase(System.Label.HR84_Acu)){
                        acuMap.put(rpw.Plan, true);
                    }
                }
            }
            //checking the plan contains acu/chiro along with acuchiro plan earlier
            if(acuChiroMap.containsKey(rpw.plan) && acuChiroMap.get(rpw.plan) && ((chiroMap.containsKey(rpw.plan) && chiroMap.get(rpw.plan)) || (acuMap.containsKey(rpw.plan) && acuMap.get(rpw.plan)))){
                multipleSelected = true;
                break;
            }
        }
        //if no plan is selected, throwing error message
        if(!isSelectedAtleastOne && riderExistingPageMap.values().isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR134_SelectAtleastOneRider));
            return null;
        }
        //if user selected both plans acu/chiro along with acuchiro plan
        if(multipleSelected){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR135_DonotSelectAcuChiroWithAcuorChiro));
            return null;
        }
        //setting pageref parameters
        PageReference pageRef = page.HighRoads_SelectBenefitPlan;
        pageRef.getParameters().put(System.Label.HR44_OppId, oppId);
        pageRef.getParameters().put(System.Label.HR45_RfpId, rfpId);
        pageRef.getParameters().put(HighRoads_Constants.QUOTE_ID, quoteId);
        pageRef.getParameters().put(HighRoads_Constants.SSO_ID, ssoId);
        pageRef.getParameters().put(System.Label.HR62_scnId, scnId);
        pageRef.setRedirect(false);
        
        return pageRef;
    }
    
    /**
    * Method Name : backFromRider
    * Parameters  : none
    * Return type : PageReference
    * Description : When user clicks on the back button on Rider Selection page.
    **/
    public PageReference backFromRider(){
        PageReference pageRef = page.HighRoads_SelectBenefitPlan;
        pageRef.getParameters().put(System.Label.HR44_OppId, oppId);
        pageRef.getParameters().put(System.Label.HR45_RfpId, rfpId);
        pageRef.getParameters().put(HighRoads_Constants.QUOTE_ID, quoteId);
        pageRef.getParameters().put(HighRoads_Constants.SSO_ID, ssoId);
        pageRef.getParameters().put(System.Label.HR62_scnId, scnId);
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    /**
    * Method Name : backFromMedical
    * Parameters  : none
    * Return type : PageReference
    * Description : When user clicks on the back button on Plan Selection page.
    **/
    public PageReference backFromMedical(){
        return new PageReference(HighRoads_Constants.WINDOW_CLOSE);
    }
    
    /**
    * Method Name : collapseAll
    * Parameters  : none
    * Return type : void
    * Description : When user clicks on collapse all link on riders selection page.
    **/
    public void collapseAll() {
        show = System.Label.HR46_None;
    }
    
    /**
    * Method Name : expandAll
    * Parameters  : none
    * Return type : void
    * Description : When user clicks on the expand all link on riders selection page
    **/
    public void expandAll() {
        show = System.Label.HR47_True;
    }
    
    /**
    * Method Name : populateRiderData
    * Parameters  : Benefit_Plan_Association__c riderbpa,RiderPlanWrapper riderPlan,RetrievePlanWrapper rpw
    * Return type : Benefit_Plan_Association__c
    * Description : used to populate the rider plan data and return to original method
    **/
    public Benefit_Plan_Association__c populateRiderData(Benefit_Plan_Association__c riderbpa,RiderPlanWrapper riderPlan,RetrievePlanWrapper rpw){
        riderbpa.Name = rpw.planId;
        riderbpa.Benefit_Plan_Metadata__c = rpw.plan;
        riderbpa.Raider_ID__c  = riderPlan.riderId;
        riderbpa.EOC__c = riderPlan.eoc;
        riderbpa.SBC__c = riderPlan.sbc;
        riderbpa.BCM__c = riderPlan.bcm;
        riderbpa.Ancillary_EOC__c = riderPlan.ancillayeoc;
        riderbpa.Ancillary_SOB__c = riderPlan.ancillaysob;
        riderbpa.Ancillary_GSA__c = riderPlan.ancillaygsa;
        
        return riderbpa;
    }
    /**
    * Method Name : populateParentandVersion
    * Parameters  : Benefit_Plan_Association__c bpa,ID recordId,RiderPlanWrapper riderPlan,
                    RetrievePlanWrapper rpw,String riderOrMedical
    * Return type : Benefit_Plan_Association__c
    * Description : used to populate the rider plan data and return to original method
    **/
    public Benefit_Plan_Association__c populateParentandVersion(Benefit_Plan_Association__c bpa,ID recordId,RiderPlanWrapper riderPlan,RetrievePlanWrapper rpw,String riderOrMedical){
        String objectName = recordId.getSObjectType().getDescribe().getName();
        //populating the parent and version number - Opportunity
        if(objectName.equalsIgnoreCase(HighRoads_Constants.OPPOBJNAME)){
            bpa.Opportunity__c = recordId;
            bpa.Version_Number__c = riderOrMedical.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? rpw.versionNumber : riderPlan.versionNumber;
        }
        //populating the parent and version number - RFP
        else if(objectName.equalsIgnoreCase(HighRoads_Constants.INCUMBENT_CARRIER_API_NAME)){
            bpa.RFP_Form__c = recordId;
            bpa.RFP_Benefit_Version__c = riderOrMedical.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? rpw.versionNumber : riderPlan.versionNumber;
        }
        ////populating the parent and version number - Proposal
        else if(objectName.equalsIgnoreCase(HighRoads_Constants.PROPOSAL_API_NAME)){
            bpa.Proposal__c = recordId;
            bpa.Quote_Benefit_Version__c = riderOrMedical.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? rpw.versionNumber : riderPlan.versionNumber;
        }
        //populating the parent and version number - Sold sign off
        else if(objectName.equalsIgnoreCase(HighRoads_Constants.SSO_API_NAME)){
            bpa.Sold_Sign_Off__c= recordId;
            bpa.SSO_Benefit_Version__c = riderOrMedical.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? rpw.versionNumber : riderPlan.versionNumber;
        }
        
        return bpa;
    }
    /**
    * Wrapper Class Name : RetrievePlanWrapper
    * Description        : To display the plans and associate riders in the plan selection page and rider selection page.
    **/
    public class RetrievePlanWrapper
    {
        public Id plan{get;set;}
        public string planId{get;set;}
        public string planName{get;set;}
        public string deductible{get;set;}
        public string familydeductible{get;set;}
        public string indfamilydeductible{get;set;}
        public string dov{get;set;}
        public string inpatient{get;set;}
        public string emergencyRoom{get;set;}
        public string officeVisit{get;set;}
        public string outOfPocketMaximum{get;set;}
        public string familyoopm{get;set;}
        public string indfamilyoopm{get;set;}
        public string rxInddeductible{get;set;}
        public string familyrxdeductible{get;set;}
        public string indfamilyrxdeductible{get;set;}
        public string outPatient{get;set;}
        public string product{get;set;}
        public string rxTier1{get;set;}
        public string rxTier2{get;set;}
        public string rxTier3{get;set;}
        public string rxTier4{get;set;}
        public string specialistOfficeVisit{get;set;}
        public boolean isCustom{get;set;}
        public boolean isHdhp{get;set;}
        public boolean isHmo{get;set;}
        public boolean isSelected{get;set;}
        public string planType{get;set;}
        public string productType{get;set;}
        public string benefitGridId{get;set;}
        public boolean isActivelyMarketed{get;set;}
        public boolean eoc{get;set;}
        public boolean sbc{get;set;}
        public boolean bcm{get;set;}
        public boolean ancillayeoc{get;set;}
        public boolean ancillaysob{get;set;}
        public boolean ancillaygsa{get;set;}
        public Decimal versionNumber{get;set;}
        public List<RiderPlanWrapper> planWithRiderList{get;set;}
        public RetrievePlanWrapper(Benefit_Plan_Metadata__c metaData,boolean selected,boolean iscustomPlanExists){
            this.planId = metaData.Name;
            this.planName = metaData.Plan_Name__c;
            this.deductible = metaData.Deductible__c;
            this.familydeductible = metaData.Family_Deductible__c;
            this.indfamilydeductible = metaData.Ind_Family_Deductible__c;
            this.dov = metaData.DOV__c;
            this.inpatient = metaData.Inpatient__c;
            this.emergencyRoom = metaData.Emergency_Room__c;
            this.officeVisit = metaData.Office_Visit__c;
            this.outOfPocketMaximum = metaData.Out_of_Pocket_Maximum__c;
            this.familyoopm = metaData.Family_OOPM__c;
            this.indfamilyoopm = metaData.Ind_Family_OOPM__c;
            this.outPatient = metaData.Outpatient__c;
            this.product = metaData.Product__c;
            this.rxTier1 = metaData.RX_Tier_1__c;
            this.rxTier2 = metaData.RX_Tier_2__c;
            this.rxTier3 = metaData.RX_Tier_3__c;
            this.rxTier4 = metaData.RX_Tier_4__c;
            this.specialistOfficeVisit = metaData.Specialist_Office_Visit__c;
            this.isSelected = selected;
            this.plan = metaData.Id;
            this.isCustom = metaData.IsCustom__c;
            this.isHdhp = metaData.isHDHP__c;
            this.isHmo = metaData.isHMO__c;
            this.planWithRiderList = new List<RiderPlanWrapper>();
            this.planType = metaData.Plan_Type__c;
            this.productType = metaData.Product_Types__c;
            this.benefitGridId = metaData.Benefit_Grid__c;
            this.isActivelyMarketed = metaData.IsActivelyMarketed__c;
            this.rxInddeductible = metaData.Rx_Deductible_Individual__c;
            this.familyrxdeductible = metaData.Rx_Deductible_Family__c;
            this.indfamilyrxdeductible = metaData.Rx_Deductible_Ind_Family__c;
            this.eoc = metaData.EOC__c;
            this.sbc = metaData.SBC__c;
            this.bcm = metaData.BCM__c;
            this.ancillayeoc = metaData.Ancillary_EOC__c;
            this.ancillaysob = metaData.Ancillary_SOB__c;
            this.ancillaygsa = metaData.Ancillary_GSA__c;
            this.versionNumber = metaData.Version_Number__c;
            
        }
    }
    
    /**
* Wrapper Class Name : RiderPlanPageWrapper
* Description        : To display the rider plans based on the Product Class
**/
    public class RiderPlanPageWrapper
    {
        
        public string productClass{get;set;}
        public List<RiderPlanWrapper> riderList {get;set;}
    }
    
    /**
    * Wrapper Class Name : RiderPlanWrapper
    * Description        : To display the rider plans for medical plans
    **/
    public class RiderPlanWrapper
    {
        public string riderId{get;set;}
        public string planId{get;set;}
        public string planName{get;set;}
        public string visitLimit{get;set;}
        public string costShare{get;set;}
        public string productClass{get;set;}
        public boolean associate{get;set;}
        public boolean eoc{get;set;}
        public boolean sbc{get;set;}
        public boolean bcm{get;set;}
        public boolean ancillayeoc{get;set;}
        public boolean ancillaysob{get;set;}
        public boolean ancillaygsa{get;set;}
        public Decimal versionNumber{get;set;}
        public RiderPlanWrapper(Benefit_Plan_Metadata__c metaData,boolean associate){
            this.riderId = metaData.Id;
            this.planId = metaData.Name.substringBefore(HighRoads_Constants.HYPHEN);
            this.planName = metaData.Plan_Name__c;
            this.costShare = metaData.Rider_Cost_Share__c;
            this.visitLimit = metaData.Visit_Limit__c;
            this.productClass = metaData.Product_Class__c;
            this.associate = associate;
            this.eoc = metaData.EOC__c;
            this.sbc = metaData.SBC__c;
            this.bcm = metaData.BCM__c;
            this.ancillayeoc = metaData.Ancillary_EOC__c;
            this.ancillaysob = metaData.Ancillary_SOB__c;
            this.ancillaygsa = metaData.Ancillary_GSA__c;
            this.versionNumber = metaData.Version_Number__c;
        }
    }
}