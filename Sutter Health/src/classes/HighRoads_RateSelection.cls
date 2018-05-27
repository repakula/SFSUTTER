/******************************************************************************************************************* 
Class Name : HighRoads_RateSelection 
Author     : IDC Offshore
Date       : 9/27/2016
Description: This controller class is used to enter the rates for all plans selected at each stage.
History:
VERSION    AUTHOR              DATE        DETAIL 
1.0        IDC-Offshore      9/27/2016     This is controller class for HighRoads_RateSelection page.
Is used to input the rates and render the rates from data base.
It will support to add 10 new Groups excluding Active and Early Retirees
10 new groups are defined with Other key word from Other1 to Other10
It will create a new rate card and rates if they change Tier/Group/Rate Value in the
Child stages(Opportunity--> RFP/Opportunity --> SCN, RFP --> Quote,Quote-->SSO,SSO-->SCN)
*******************************************************************************************************************/
public class HighRoads_RateSelection {
    //Class level properties
    public ID recordId{get;set;}
    //variable is used to store the rate card id
    public String rateCardId{get;set;}
    //variable is used for rendering the output panel
    public boolean panel1next{get;set;}
    //variable is used for rendering the output panel
    public boolean panel2next{get;set;}
    //variable is used for rendering the output panel
    public boolean panel2previous{get;set;}
    //variable is used for rendering the output panel
    public boolean panel3previous{get;set;}
    //variable is used for identifying whether the plans are existing before opening the rates
    public boolean isPlansExists{get;set;}
    //variable is used to check the parent rate card and child rate card is same or not
    public boolean isRateCardSame{get;set;}
    //variable is used whether the user clicked on the add group button
    public boolean addGroupClicked{get;set;}
    /* other 1 to 10 are used to identify how many new groups added while entering rates*/
    public boolean isOther10Selected{get;set;}
    public boolean isOther1Selected{get;set;}
    public boolean isOther2Selected{get;set;}
    public boolean isOther3Selected{get;set;}
    public boolean isOther4Selected{get;set;}
    public boolean isOther5Selected{get;set;}
    public boolean isOther6Selected{get;set;}
    public boolean isOther7Selected{get;set;}
    public boolean isOther8Selected{get;set;}
    public boolean isOther9Selected{get;set;}
    public boolean isTier1Selected{get;set;}
    public boolean isTier2Selected{get;set;}
    public boolean isTier3Selected{get;set;}
    public boolean isTier4Selected{get;set;}
    public boolean isTier5Selected{get;set;}
    /* variable is used to identify any dental plans are exists */
    public boolean isDentalExists{get;set;}
    /* variable is used to render error message to user if they do not enter rates for all plans */
    public boolean isRateErrorFound{get;set;}
    /* variable is used to check the plans are exists for the record before entering rates */
    public boolean isPlansFound{get;set;}
    /* Name of the object Like Opportunity/RFP/Proposal/Sold Sign Off/Sold Case Notification */
    public String objectName{get;set;}
    /* Other 1 -10 string variables are used to set the group names */
    public String other1{get;set;}
    public String other2{get;set;}
    public String other3{get;set;}
    public String other4{get;set;}
    public String other5{get;set;}
    public String other6{get;set;}
    public String other7{get;set;}
    public String other8{get;set;}
    public String other9{get;set;}
    public String other10{get;set;}
    /* variable is used to dynamically construct the width of the html table */
    public Double rateEntryTableWidth{get;set;}
    /* variable is used to dynamically display the colspan of the html table */
    public Integer groupColspan{get;set;}
    /* set is used to store the number of groups selected while entering rates */
    public Set<String> groupCount = new Set<String>();
    /* list is used to construct the wrapper list which is used to show the rate entry panel */
    public List<RateEntry> rateEntryList{get;set;}
    /* list is used to construct the wrapper class which is used to render the row span group selection panel */
    public List<PlanGroups> planGroupList{get;set;}
    /* list is used to construct the wrapper class which is used to rates output panel */
    public List<RateGroups> rateGroupList{get;set;}
    /* list is used to construct the wrapper class which is used to rendr the tiers for the existing plans when already rates entered */
    public List<RateTiers> rateTierList{get;set;}
    /* list is used to fetch the benefit plan association records for parent record */
    public List<Benefit_Plan_Association__c> bpaList{get;set;}
    /* list for fetching the existing rates */
    public List<Rates__c> existingratesList{get;set;}
    /* Set to store the existing rate groups */
    public Set<String> existingRateGroup{get;set;}
    /* map used to store the Medical plan and its associated rider plans */
    public Map<String,Set<String>> medicalRiderMap{get;set;}
    /* map used to store the existing tier type for each plan */
    public Map<String,Set<String>> existingTiersMap = new Map<String,Set<String>>();
    /* set is used to store the deleted tiers which were selected earlier for that particular plan  */
    public Set<String> deleteTierSet = new Set<String>();
    /* set is used to store the deleted groups which were selected earlier for that particular plan  */
    public Set<String> deleteGroupSet = new Set<String>();
    /* set is used to store the added tiers which were not selected earlier for that particular plan */
    public Set<String> addedTierSet = new Set<String>();
    /* set is used to store the added groups which were not selected earlier for that particular plan */
    public Set<String> addedGroupSet = new Set<String>();
    /* map is used to store the tier selection from the existing for each plan */
    public Map<String,String> planTypeRateTierMap = new Map<String,String>();
    /* map is used to store the tier and group selection from the existing for each plan */
    public Map<String,List<String>> planTypeRateTierGroupMap = new Map<String,List<String>>();
    /* set is used to store dental plans if exists */
    public Set<String> dentalPlanSet = new Set<String>();
    /* main wrapper class list which is used in tier selection panel */
    public List<PlanRateTier> planRateTierList{get;set;}
    /* main wrapper class list which is used in group selection panel */
    public List<PlanRateTier> planRateTierGroupList{get;set;}
    /* main wrapper class list which is used in rate selection panel */
    public List<PlanRateTier> PlanRateTierGroupandRateEntryList{get;set;}
    
    
    /** Constructor to get the rates for existing plans and adding new plans where they dont have rates into other list
*  and rendering the table
**/
    public HighRoads_RateSelection(){
        recordId = ApexPages.currentpage().getparameters().get(HighRoads_Constants.RECORD_ID);
        panel1next = true;
        panel2next = false;
        panel2previous = false;
        panel3previous = false;
        isPlansExists = false;
        isRateCardSame = false;
        addGroupClicked = false;
        isOther10Selected = false;
        isOther1Selected = false;
        isOther2Selected = false;
        isOther3Selected = false;
        isOther4Selected = false;
        isOther5Selected = false;
        isOther6Selected = false;
        isOther7Selected = false;
        isOther8Selected = false;
        isOther9Selected = false;
        isDentalExists = false;
        isPlansFound = false;
        /* standard groups Active , Early Retiree is setting */
        groupCount.add(HighRoads_Constants.ACTIVE_GROUP_NAME);
        groupCount.add(HighRoads_Constants.EARLY_RETIREE_GROUP_NAME);
        retrieveExistingRates(recordId);
    }
    /**
* Method Name : retrieveExistingRates
* Parameters  : ID - recordId of the Opportunity/RFP/Quote/SSO/SCN
* Description : To retrieve the existing rates from rate object for the corresponding parent.
* Return type : void
**/
    public void retrieveExistingRates(ID recId){
        /* fetching the object based on the record id */
        objectName = recId.getSObjectType().getDescribe().getName();
        /* list object creation */
        bpaList = new List<Benefit_Plan_Association__c>();
        existingratesList = new List<Rates__c>();
        medicalRiderMap = new Map<String,Set<String>>();
        planRateTierList = new List<PlanRateTier>();
        existingRateGroup = new Set<String>();
        /* map is used to store the each tier for each plan from existing rates */
        Map<String,String> medicalPlanTierMap = new Map<String,String>();
        /* list is used to store the plans if they have not selected rates for the plans */
        List<Benefit_Plan_Association__c> noRateCardPlansList = new List<Benefit_Plan_Association__c>();
        /* This condition will execute if the user clicks on Select Rates button from Opportunity */
        if(HighRoads_Constants.OPPOBJNAME.equalsIgnoreCase(objectName)){
            /* fetching all the associated plans at opportunity level */
            bpaList = [SELECT ID,Name,Raider_ID__c,Product_Class__c,Benefit_Plan_Metadata__c,Benefit_Plan_Metadata__r.Name,Raider_ID__r.Name,
                       Opportunity_Rate_Card__c 
                       FROM Benefit_Plan_Association__c WHERE Opportunity__c=:recId];
            /* if list is not null then making boolean variable to true to not render the error message to user */
            if(bpaList != NULL && !bpaList.isEmpty()){
                isPlansFound = true;
                //looping through the benefit plan association records
                for(Benefit_Plan_Association__c bpaObj : bpaList){
                    // taking rate card Id if the rate card is not null
                    if(bpaObj.Opportunity_Rate_Card__c != NULL){
                        rateCardId = bpaObj.Opportunity_Rate_Card__c;
                    }
                    //taking into noRateCardPlansList - these plans will be shown in rates with empty tiers
                    else{
                        noRateCardPlansList.add(bpaObj);
                    }
                    //If the plan product class is dental then taking into dentalPlanSet and making isDentalExists 
                    //to true to show the message to users on rate entry screen
                    if(HighRoads_Constants.DENTAL.equalsIgnoreCase(bpaObj.Product_Class__c)){
                        isDentalExists = true;
                        dentalPlanSet.add(bpaObj.Raider_ID__r.Name);
                    }
                }
            }
        }
        /* This condition will execute if the user clicks on Select Rates button from RFP Object */
        if(HighRoads_Constants.INCUMBENT_CARRIER_API_NAME.equalsIgnoreCase(objectName)){
            /* fetching all the associated plans at RFP level */
            bpaList = [SELECT ID,Name,Raider_ID__c,Product_Class__c,Benefit_Plan_Metadata__c,Benefit_Plan_Metadata__r.Name,Raider_ID__r.Name,
                       Opportunity_Rate_Card__c,RFP_Rate_Card__c 
                       FROM Benefit_Plan_Association__c WHERE RFP_Form__c=:recId];
            /* if list is not null then making boolean variable to true to not render the error message to user */
            if(bpaList != NULL && !bpaList.isEmpty()){
                isPlansFound = true;
                //looping through the benefit plan association records
                for(Benefit_Plan_Association__c bpaObj : bpaList){
                    // Comparing the ratecards for parent and child to check the rate card is same or not */
                    if(bpaObj.Opportunity_Rate_Card__c != NULL && bpaObj.RFP_Rate_Card__c != NULL && 
                       bpaObj.Opportunity_Rate_Card__c == bpaObj.RFP_Rate_Card__c){
                           //if rate card is same assigning the RFP Rate Card id to rateCardId 
                           rateCardId = bpaObj.RFP_Rate_Card__c;
                           //making isRateCardSame to true - this is used when user selects any additional tier/group/rate changed 
                           //then we will create a new rate card and assing it to all plans RFP Rate Card
                           isRateCardSame = true;
                       }else if(bpaObj.Opportunity_Rate_Card__c != NULL && bpaObj.RFP_Rate_Card__c != NULL && 
                                bpaObj.Opportunity_Rate_Card__c != bpaObj.RFP_Rate_Card__c){
                                    rateCardId = bpaObj.RFP_Rate_Card__c;
                                    //if parent and child rate card is not same
                                    isRateCardSame = false;
                                }else if(bpaObj.Opportunity_Rate_Card__c == NULL && bpaObj.RFP_Rate_Card__c != NULL){
                                    rateCardId = bpaObj.RFP_Rate_Card__c;
                                    //in parent they have not entered the rates but in child they have entered the rates
                                    isRateCardSame = false;
                                }else{
                                    //If no rate card exists for the plan
                                    noRateCardPlansList.add(bpaObj);
                                }
                    //If the plan product class is dental then taking into dentalPlanSet and making isDentalExists 
                    //to true to show the message to users on rate entry screen
                    if(HighRoads_Constants.DENTAL.equalsIgnoreCase(bpaObj.Product_Class__c)){
                        isDentalExists = true;
                        dentalPlanSet.add(bpaObj.Raider_ID__r.Name);
                    }
                    
                }
            }
            
        }
        /* This condition will execute if the user clicks on Select Rates button from Proposal Object */
        if(HighRoads_Constants.PROPOSAL_API_NAME.equalsIgnoreCase(objectName)){
            /* fetching all the associated plans at Proposal level */
            bpaList = [SELECT ID,Name,Raider_ID__c,Product_Class__c,Benefit_Plan_Metadata__c,Benefit_Plan_Metadata__r.Name,Raider_ID__r.Name,
                       RFP_Rate_Card__c,Quote_Rate_Card__c 
                       FROM Benefit_Plan_Association__c WHERE Proposal__c=:recId];
            /* if list is not null then making boolean variable to true to not render the error message to user */
            if(bpaList != NULL && !bpaList.isEmpty()){
                isPlansFound = true;
                //looping through the benefit plan association records
                for(Benefit_Plan_Association__c bpaObj : bpaList){
                    // Comparing the ratecards for parent and child to check the rate card is same or not 
                    if(bpaObj.RFP_Rate_Card__c != NULL && bpaObj.Quote_Rate_Card__c != NULL && 
                       bpaObj.RFP_Rate_Card__c == bpaObj.Quote_Rate_Card__c){
                           //if rate card is same assigning the Proposal Rate Card id to rateCardId 
                           rateCardId = bpaObj.Quote_Rate_Card__c;
                           //making isRateCardSame to true - this is used when user selects any additional tier/group/rate changed 
                           //then we will create a new rate card and assing it to all plans Proposal Rate Card
                           isRateCardSame = true;
                       }else if(bpaObj.RFP_Rate_Card__c != NULL && bpaObj.Quote_Rate_Card__c != NULL && 
                                bpaObj.RFP_Rate_Card__c != bpaObj.Quote_Rate_Card__c){
                                    rateCardId = bpaObj.Quote_Rate_Card__c;
                                    //if parent and child rate card is not same
                                    isRateCardSame = false;
                                }else if(bpaObj.RFP_Rate_Card__c == NULL && bpaObj.Quote_Rate_Card__c != NULL){
                                    rateCardId = bpaObj.Quote_Rate_Card__c;
                                    //in parent they have not entered the rates but in child they have entered the rates
                                    isRateCardSame = false;
                                }else{
                                    //If no rate card exists for the plan
                                    noRateCardPlansList.add(bpaObj);
                                }
                    //If the plan product class is dental then taking into dentalPlanSet and making isDentalExists 
                    //to true to show the message to users on rate entry screen
                    if(HighRoads_Constants.DENTAL.equalsIgnoreCase(bpaObj.Product_Class__c)){
                        isDentalExists = true;
                        dentalPlanSet.add(bpaObj.Raider_ID__r.Name);
                    }
                }
            }
            
        }
        /* This condition will execute if the user clicks on Select Rates button from Sold Sign Off Object */
        if(HighRoads_Constants.SSO_API_NAME.equalsIgnoreCase(objectName)){
            /* fetching all the associated plans at Sold Sign Off level */
            bpaList = [SELECT ID,Name,Raider_ID__c,Product_Class__c,Benefit_Plan_Metadata__c,Benefit_Plan_Metadata__r.Name,Raider_ID__r.Name,
                       Quote_Rate_Card__c,SSO_Rate_Card__c 
                       FROM Benefit_Plan_Association__c WHERE Sold_Sign_Off__c=:recId];
            /* if list is not null then making boolean variable to true to not render the error message to user */
            if(bpaList != NULL && !bpaList.isEmpty()){
                isPlansFound = true;
                //looping through the benefit plan association records
                for(Benefit_Plan_Association__c bpaObj : bpaList){
                    // Comparing the ratecards for parent and child to check the rate card is same or not 
                    if(bpaObj.Quote_Rate_Card__c != NULL && bpaObj.SSO_Rate_Card__c != NULL && 
                       bpaObj.Quote_Rate_Card__c == bpaObj.SSO_Rate_Card__c){
                           //if rate card is same assigning the SSO Rate Card id to rateCardId 
                           rateCardId = bpaObj.SSO_Rate_Card__c;
                           //making isRateCardSame to true - this is used when user selects any additional tier/group/rate changed 
                           //then we will create a new rate card and assing it to all plans SSO Rate Card
                           isRateCardSame = true;
                       }else if(bpaObj.Quote_Rate_Card__c != NULL && bpaObj.SSO_Rate_Card__c != NULL && 
                                bpaObj.Quote_Rate_Card__c != bpaObj.SSO_Rate_Card__c){
                                    rateCardId = bpaObj.SSO_Rate_Card__c;
                                    //if parent and child rate card is not same
                                    isRateCardSame = false;
                                }else if(bpaObj.Quote_Rate_Card__c == NULL && bpaObj.SSO_Rate_Card__c != NULL){
                                    rateCardId = bpaObj.SSO_Rate_Card__c;
                                    //in parent they have not entered the rates but in child they have entered the rates
                                    isRateCardSame = false;
                                }else{
                                    //If no rate card exists for the plan
                                    noRateCardPlansList.add(bpaObj);
                                }
                    //If the plan product class is dental then taking into dentalPlanSet and making isDentalExists 
                    //to true to show the message to users on rate entry screen
                    if(HighRoads_Constants.DENTAL.equalsIgnoreCase(bpaObj.Product_Class__c)){
                        isDentalExists = true;
                        dentalPlanSet.add(bpaObj.Raider_ID__r.Name);
                    }
                }
            }
            
        }
        /* This condition will execute if the user clicks on Select Rates button from SCN Object 
        *  SCN can be inserted from either Opportunity for small group accounts or SSO for Large group accounts
        */
        if(HighRoads_Constants.EMPLOYER_GROUP_DATA_API_NAME.equalsIgnoreCase(objectName)){
            /* fetching all the associated plans at SCN level */
            bpaList = [SELECT ID,Name,Raider_ID__c,Product_Class__c,Benefit_Plan_Metadata__c,Benefit_Plan_Metadata__r.Name,Raider_ID__r.Name,
                       Opportunity_Rate_Card__c,SSO_Rate_Card__c,SCN_Rate_Card__c 
                       FROM Benefit_Plan_Association__c WHERE Sold_Case_Notification__c=:recId];
            /* if list is not null then making boolean variable to true to not render the error message to user */
            if(bpaList != NULL && !bpaList.isEmpty()){
                isPlansFound = true;
                //looping through the benefit plan association records
                for(Benefit_Plan_Association__c bpaObj : bpaList){
                    // Comparing the ratecards for parent and child to check the rate card is same or not */
                    if(bpaObj.SSO_Rate_Card__c != NULL && bpaObj.SCN_Rate_Card__c != NULL && 
                       bpaObj.SSO_Rate_Card__c == bpaObj.SCN_Rate_Card__c){
                           //if rate card is same assigning the SCN Rate Card id to rateCardId 
                           rateCardId = bpaObj.SCN_Rate_Card__c;
                           //making isRateCardSame to true - this is used when user selects any additional tier/group/rate changed 
                           //then we will create a new rate card and assing it to all plans SCN Rate Card
                           isRateCardSame = true;
                       }else if(bpaObj.SSO_Rate_Card__c != NULL && bpaObj.SCN_Rate_Card__c != NULL && 
                                bpaObj.SSO_Rate_Card__c != bpaObj.SCN_Rate_Card__c){
                                    rateCardId = bpaObj.SCN_Rate_Card__c;
                                    isRateCardSame = false;
                                }else if(bpaObj.SSO_Rate_Card__c == NULL && bpaObj.Opportunity_Rate_Card__c != NULL && bpaObj.SCN_Rate_Card__c != NULL && 
                                         bpaObj.Opportunity_Rate_Card__c == bpaObj.SCN_Rate_Card__c){
                                             rateCardId = bpaObj.SCN_Rate_Card__c;
                                             //if parent and child rate card is not same
                                             isRateCardSame = true;
                                         }else if(bpaObj.SSO_Rate_Card__c == NULL && bpaObj.Opportunity_Rate_Card__c != NULL && bpaObj.SCN_Rate_Card__c != NULL && 
                                                  bpaObj.Opportunity_Rate_Card__c != bpaObj.SCN_Rate_Card__c){
                                                      //If SSO Rate Card is null and Opportunity Rate Card is Not NULL
                                                      rateCardId = bpaObj.SCN_Rate_Card__c;
                                                      isRateCardSame = false;
                                                  }else if(bpaObj.SSO_Rate_Card__c == NULL && bpaObj.Opportunity_Rate_Card__c == NULL && bpaObj.SCN_Rate_Card__c != NULL){
                                                      rateCardId = bpaObj.SCN_Rate_Card__c;
                                                      isRateCardSame = false;
                                                  }else{
                                                      noRateCardPlansList.add(bpaObj);
                                                  }
                    //If the plan product class is dental then taking into dentalPlanSet and making isDentalExists 
                    //to true to show the message to users on rate entry screen
                    if(HighRoads_Constants.DENTAL.equalsIgnoreCase(bpaObj.Product_Class__c)){
                        isDentalExists = true;
                        dentalPlanSet.add(bpaObj.Raider_ID__r.Name);
                    }
                }
            }
        }
        /* if no plans found and user click on the select rates button 
         * rendering error message to user */
        if(!isPlansFound){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.Label.HR114_NoPlansForRates));
            return;
        }
        /* if the plan list is not empty */
        if(!bpaList.isEmpty()){
            //making this flag to true if plans exists
            isPlansExists = true;
            /* if rate card is not null then fetching all the rates for that rate card and constructing wrapper list */
            if(rateCardId != NULL && rateCardId != HighRoads_Constants.BLANK_VALUE){
                // querying the existing rates for the rate card
                existingratesList = [SELECT ID,Group_Type__c,Group_Alias_Name__c ,Plan_Name__c,Rider_Plan_Name__c,Plan_Type_Tier_Group__c,Rate_Card_ID__c,Tier_1_Composite__c,
                                     Tier_2_EE__c,Tier_2_EF__c,Tier_3_EE__c,Tier_3_EE1__c,Tier_3_EE2__c,Tier_4_EC__c,Tier_4_EE__c,Medical_Plan_Rider_Plan__c,
                                     Tier_4_EF__c,Tier_4_ES__c,Tier_5_EC__c,Tier_5_ECH__c,Tier_5_EE__c,Tier_5_EF__c,Tier_5_ES__c,Tier_Type__c
                                     FROM Rates__c WHERE Rate_Card_ID__c=:rateCardId Order By createddate];
                // looping through the existing rate list
                for(Rates__c rateObj : existingratesList){
                    //adding the unique key to set
                    existingRateGroup.add(rateObj.Plan_Type_Tier_Group__c);
                    //constructing medicalRiderPlanMap to store the medical plan and its associated rider plans
                    if(medicalRiderMap.containsKey(rateObj.Plan_Name__c)){
                        Set<String> mapValues = medicalRiderMap.get(rateObj.Plan_Name__c);
                        if(rateObj.Rider_Plan_Name__c != NULL && rateObj.Rider_Plan_Name__c != HighRoads_Constants.BLANK_VALUE){
                            mapValues.add(rateObj.Rider_Plan_Name__c) ;
                        }
                        medicalRiderMap.put(rateObj.Plan_Name__c, mapValues);
                    }else{
                        Set<String> mapValues = new Set<String>();
                        if(rateObj.Rider_Plan_Name__c != NULL){
                            mapValues.add(rateObj.Rider_Plan_Name__c);
                        }
                        medicalRiderMap.put(rateObj.Plan_Name__c, mapValues);
                    }
                    //constructing the existingTiersMap to store Medical Plan and Rider Plan selected tiers from rate record
                    if(existingTiersMap.containsKey(rateObj.Medical_Plan_Rider_Plan__c)){
                        Set<String> mapValues = existingTiersMap.get(rateObj.Medical_Plan_Rider_Plan__c);
                        mapValues.add(rateObj.Tier_Type__c) ;
                        existingTiersMap.put(rateObj.Medical_Plan_Rider_Plan__c, mapValues);
                    }else{
                        Set<String> mapValues = new Set<String>();
                        mapValues.add(rateObj.Tier_Type__c) ;
                        existingTiersMap.put(rateObj.Medical_Plan_Rider_Plan__c, mapValues);
                    }
                    //constructing medicalPlanTierMap map to store the Medical Plan or Rider Plan tiers with Comma Separation
                    //for Medical Medical_Plan_Rider_Plan__c ex: HE02 - 2016_Medical 
                    //for rider Medical_Plan_Rider_Plan__c ex: HE02 - 2016_XA02 - 2016
                    //Tiers will be stored in map lie (HE02 - 2016_Medical, tier 1,tier 2, etc..)
                    medicalPlanTierMap.put(rateObj.Medical_Plan_Rider_Plan__c,medicalPlanTierMap.get(rateObj.Medical_Plan_Rider_Plan__c)+HighRoads_Constants.COMMA+rateObj.Tier_Type__c);
                    planTypeRateTierMap.put(rateObj.Medical_Plan_Rider_Plan__c+HighRoads_Constants.UNDERSCORE+rateObj.Tier_Type__c,planTypeRateTierMap.get(rateObj.Medical_Plan_Rider_Plan__c+HighRoads_Constants.UNDERSCORE+rateObj.Tier_Type__c)+HighRoads_Constants.COMMA+rateObj.Group_Type__c);
                    
                    //Order of pushing the data into list , the order should be used in while populating the data in panel3
                    List<String> rateValuesList = new List<String>();
                    // Populating the Group Name to other1 - 10 which users have entered earlier while entering the rates
                    // adding the group name to group count set which will be used in colspan in group selection panel
                    if(rateObj.Group_Type__c != NULL && rateObj.Group_Type__c != HighRoads_Constants.BLANK_VALUE && rateObj.Group_Type__c.equalsIgnoreCase(HighRoads_Constants.OTHER_1)){
                        isOther1Selected = true;
                        other1 = rateObj.Group_Alias_Name__c;
                        groupCount.add(HighRoads_Constants.OTHER_1);
                    }else if(rateObj.Group_Type__c != NULL && rateObj.Group_Type__c != HighRoads_Constants.BLANK_VALUE && rateObj.Group_Type__c.equalsIgnoreCase(HighRoads_Constants.OTHER_2)){
                        isOther2Selected = true;
                        other2 = rateObj.Group_Alias_Name__c;
                        groupCount.add(HighRoads_Constants.OTHER_2);
                    }else if(rateObj.Group_Type__c != NULL && rateObj.Group_Type__c != HighRoads_Constants.BLANK_VALUE && rateObj.Group_Type__c.equalsIgnoreCase(HighRoads_Constants.OTHER_3)){
                        isOther3Selected = true;
                        other3 = rateObj.Group_Alias_Name__c;
                        groupCount.add(HighRoads_Constants.OTHER_3);
                    }else if(rateObj.Group_Type__c != NULL && rateObj.Group_Type__c != HighRoads_Constants.BLANK_VALUE && rateObj.Group_Type__c.equalsIgnoreCase(HighRoads_Constants.OTHER_4)){
                        isOther4Selected = true;
                        other4 = rateObj.Group_Alias_Name__c;
                        groupCount.add(HighRoads_Constants.OTHER_4);
                    }else if(rateObj.Group_Type__c != NULL && rateObj.Group_Type__c != HighRoads_Constants.BLANK_VALUE && rateObj.Group_Type__c.equalsIgnoreCase(HighRoads_Constants.OTHER_5)){
                        isOther5Selected = true;
                        other5 = rateObj.Group_Alias_Name__c;
                        groupCount.add(HighRoads_Constants.OTHER_5);
                    }else if(rateObj.Group_Type__c != NULL && rateObj.Group_Type__c != HighRoads_Constants.BLANK_VALUE && rateObj.Group_Type__c.equalsIgnoreCase(HighRoads_Constants.OTHER_6)){
                        isOther1Selected = true;
                        other6 = rateObj.Group_Alias_Name__c;
                        groupCount.add(HighRoads_Constants.OTHER_6);
                    }else if(rateObj.Group_Type__c != NULL && rateObj.Group_Type__c != HighRoads_Constants.BLANK_VALUE && rateObj.Group_Type__c.equalsIgnoreCase(HighRoads_Constants.OTHER_7)){
                        isOther7Selected = true;
                        other7 = rateObj.Group_Alias_Name__c;
                        groupCount.add(HighRoads_Constants.OTHER_7);
                    }else if(rateObj.Group_Type__c != NULL && rateObj.Group_Type__c != HighRoads_Constants.BLANK_VALUE && rateObj.Group_Type__c.equalsIgnoreCase(HighRoads_Constants.OTHER_8)){
                        isOther8Selected = true;
                        other8 = rateObj.Group_Alias_Name__c;
                        groupCount.add(HighRoads_Constants.OTHER_8);
                    }else if(rateObj.Group_Type__c != NULL && rateObj.Group_Type__c != HighRoads_Constants.BLANK_VALUE && rateObj.Group_Type__c.equalsIgnoreCase(HighRoads_Constants.OTHER_9)){
                        isOther9Selected = true;
                        other9 = rateObj.Group_Alias_Name__c;
                        groupCount.add(HighRoads_Constants.OTHER_9);
                    }else if(rateObj.Group_Type__c != NULL && rateObj.Group_Type__c != HighRoads_Constants.BLANK_VALUE && rateObj.Group_Type__c.equalsIgnoreCase(HighRoads_Constants.OTHER_10)){
                        isOther10Selected = true;
                        other10 = rateObj.Group_Alias_Name__c;
                        groupCount.add(HighRoads_Constants.OTHER_10);
                    }
                    
                    // constructing the unique key using medicalriderplan and tiertype and grouptype which will be used to capture the rate values
                    // and render them to user in rate entry screen 
                    String planTypeTierNamaeGroupName = rateObj.Medical_Plan_Rider_Plan__c+HighRoads_Constants.UNDERSCORE+rateObj.Tier_Type__c+HighRoads_Constants.UNDERSCORE+rateObj.Group_Type__c;
                    // capturing tier 1 rates 
                    if(rateObj.Tier_Type__c == HighRoads_Constants.TIER_1){
                        rateValuesList.add(rateObj.Tier_1_Composite__c);
                        planTypeRateTierGroupMap.put(planTypeTierNamaeGroupName, rateValuesList);
                    }
                    // capturing tier 2 rates 
                    else if(rateObj.Tier_Type__c == HighRoads_Constants.TIER_2){
                        rateValuesList.add(rateObj.Tier_2_EE__c);
                        rateValuesList.add(rateObj.Tier_2_EF__c);
                        planTypeRateTierGroupMap.put(planTypeTierNamaeGroupName, rateValuesList);
                    }
                    // capturing tier 3 rates 
                    else if(rateObj.Tier_Type__c == HighRoads_Constants.TIER_3){
                        rateValuesList.add(rateObj.Tier_3_EE__c);
                        rateValuesList.add(rateObj.Tier_3_EE1__c);
                        rateValuesList.add(rateObj.Tier_3_EE2__c);
                        planTypeRateTierGroupMap.put(planTypeTierNamaeGroupName, rateValuesList);
                    }
                    // capturing tier 4 rates 
                    else if(rateObj.Tier_Type__c == HighRoads_Constants.TIER_4){
                        rateValuesList.add(rateObj.Tier_4_EE__c);
                        rateValuesList.add(rateObj.Tier_4_ES__c);
                        rateValuesList.add(rateObj.Tier_4_EC__c);
                        rateValuesList.add(rateObj.Tier_4_EF__c);
                        planTypeRateTierGroupMap.put(planTypeTierNamaeGroupName, rateValuesList);
                    }
                    // capturing tier 5 rates 
                    else if(rateObj.Tier_Type__c == HighRoads_Constants.TIER_5){
                        rateValuesList.add(rateObj.Tier_5_EE__c);
                        rateValuesList.add(rateObj.Tier_5_ES__c);
                        rateValuesList.add(rateObj.Tier_5_EC__c);
                        rateValuesList.add(rateObj.Tier_5_ECH__c);
                        rateValuesList.add(rateObj.Tier_5_EF__c);
                        planTypeRateTierGroupMap.put(planTypeTierNamaeGroupName, rateValuesList);
                    }
                }
                //The below for loop is used to add the plans which dont have rate card
                //constructing the map with Medical Plan and its rider plans which do not have rate card
                for(Benefit_Plan_Association__c bpaObj : noRateCardPlansList){
                    if(medicalRiderMap.containsKey(bpaObj.Benefit_Plan_Metadata__r.Name)){
                        Set<String> mapValues = medicalRiderMap.get(bpaObj.Benefit_Plan_Metadata__r.Name);
                        if(bpaObj.Raider_ID__c != NULL){
                            mapValues.add(bpaObj.Raider_ID__r.Name) ;
                        }
                        medicalRiderMap.put(bpaObj.Benefit_Plan_Metadata__r.Name, mapValues);
                    }else{
                        Set<String> mapValues = new Set<String>();
                        if(bpaObj.Raider_ID__c != NULL){
                            mapValues.add(bpaObj.Raider_ID__r.Name);
                        }
                        medicalRiderMap.put(bpaObj.Benefit_Plan_Metadata__r.Name, mapValues);
                    }
                }
                // construcint the planRateTierList (wrapper list) which will render in tier selection screen
                // for each medical and rider plan and tiers
                for(String medicalPlan : medicalRiderMap.keySet()){
                    rateTierList = new List<RateTiers>();
                    rateTierList.add(new RateTiers(medicalPlan,true,medicalPlanTierMap.get(medicalPlan+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.MEDICAL)));
                    for(String riderPlan : medicalRiderMap.get(medicalPlan)){
                        rateTierList.add(new RateTiers(riderPlan,false,medicalPlanTierMap.get(medicalPlan+HighRoads_Constants.UNDERSCORE+riderPlan)));
                    }
                    planRateTierList.add(new PlanRateTier(medicalPlan,rateTierList));
                }
            }else{
                //The below for loop is used to add the plans which dont have rate card
                //constructing the map with Medical Plan and its rider plans which do not have rate card
                for(Benefit_Plan_Association__c bpaObj : bpaList){
                    if(medicalRiderMap.containsKey(bpaObj.Benefit_Plan_Metadata__r.Name)){
                        Set<String> mapValues = medicalRiderMap.get(bpaObj.Benefit_Plan_Metadata__r.Name);
                        if(bpaObj.Raider_ID__c != NULL){
                            mapValues.add(bpaObj.Raider_ID__r.Name) ;
                        }
                        medicalRiderMap.put(bpaObj.Benefit_Plan_Metadata__r.Name, mapValues);
                    }else{
                        Set<String> mapValues = new Set<String>();
                        if(bpaObj.Raider_ID__c != NULL){
                            mapValues.add(bpaObj.Raider_ID__r.Name);
                        }
                        medicalRiderMap.put(bpaObj.Benefit_Plan_Metadata__r.Name, mapValues);
                    }
                }
                // construcint the planRateTierList (wrapper list) which will render in tier selection screen
                // for each medical and rider plan and tiers
                for(String medicalPlan : medicalRiderMap.keySet()){
                    rateTierList = new List<RateTiers>();
                    rateTierList.add(new RateTiers(medicalPlan,true,null));
                    for(String riderPlan : medicalRiderMap.get(medicalPlan)){
                        rateTierList.add(new RateTiers(riderPlan,false,null));
                    }
                    planRateTierList.add(new PlanRateTier(medicalPlan,rateTierList));
                }
                
            }
        }
        
        
        
    }
    /**
* Method Name : cancel
* Parameters  : None
* Description : Window will be closed when cancel button is clicked on Cancel  button.
* Return type : PageReference 
**/
    public PageReference cancel(){
        return new PageReference(highRoads_Constants.WINDOW_CLOSE);
    }
    /**
* Method Name : panel1Next
* Parameters  : None
* Description : When Tier selection is completed and user clicks on Next button, panel1Next will be called and redirected to Group Selection screen
* Return type : void 
**/
    public void panel1Next(){
        //default width setting for group selection screen
        // i.e. Medical Plan Name,Rider Plan Name, Tier Type, Group Type columns
        rateEntryTableWidth = 21.04;
        //making the tier fields to false
        isTier1Selected = false;
        isTier2Selected = false;
        isTier3Selected = false;
        isTier4Selected = false;
        isTier5Selected = false;
        //setting false to not render the button in next screen
        panel1next = false;
        //setting true to render this button in next screen
        panel2next = true;    
        //groupcolspan is used to display the colspan dynamically for the selected groups earlier
        groupColspan = groupCount.size();
		//constructing the map to store the Medical Plan ex : HE02 - 2016_Medical
		// HE02 - 2016_XA02 - 2016 for rider
		// and rategroups which user select the groups in group selection screen
        Map<String,List<RateGroups>> planGroupsMap = new Map<String,List<RateGroups>>();
        // constructing the map to store the no.of group count for each medical plan 
        // which will be used to display the dynamic row span in group selection screen
        Map<String,Integer> totalRateTiersCountMap = new Map<String,Integer>();
        //wrapper list which need to be render in group selection screen
        planRateTierGroupList = new List<PlanRateTier>();
        // looping through the selected plan
        for(PlanRateTier planRateTierObj : planRateTierList){
            //setting initial tier count to 0
            Integer tierCount = 0;
            //looping the selected tier list for each plan
            for(RateTiers rateTierObj :  planRateTierObj.tierList){
                String medicalPlanRiderPlanName = planRateTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+rateTierObj.planName;
                // if user not selected any tier for any of the plan
                // throwing error message to user to select at least one tier before going furthur
                if(!rateTierObj.tier1 && !rateTierObj.tier2 && !rateTierObj.tier3 && !rateTierObj.tier4 && !rateTierObj.tier5){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR115_SelectTier+planRateTierObj.medicalPlanName+System.Label.HR116_ANDType+rateTierObj.planName));
                    panel1next = true;
                    panel2next = false;
                    return;
                }
                //Construting the wrapper list - to render the groups for the current selected tiers/earlier selected groups
                rateGroupList = new List<RateGroups>();
                //if tier 1 is selected for the plan
                if(rateTierObj.tier1){
                    isTier1Selected = true;
                    //constructing the group list for the selected tier
                    rateGroupList.add(new RateGroups(HighRoads_Constants.TIER_1,planTypeRateTierMap.get(medicalPlanRiderPlanName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.TIER_1),rateCardId == NULL ? true : false));
                    //Incrementing the tier count which will be used for dynamcic row span in html table
                    tierCount+=1;
                    // adding the tier to addedtierset
                    // if they select any new tier which is not selected earlier while entering the rates
                    if(existingTiersMap != NULL && !existingTiersMap.isEmpty() && existingTiersMap.get(medicalPlanRiderPlanName) != NULL && !existingTiersMap.get(medicalPlanRiderPlanName).contains(HighRoads_Constants.TIER_1)){
                        addedTierSet.add(medicalPlanRiderPlanName+HighRoads_Constants.SYMBOL_ASH+HighRoads_Constants.TIER_1);
                    }
                }
                //if tier 2 is selected for the plan
                if(rateTierObj.tier2){
                    isTier2Selected = true;
                    //constructing the group list for the selected tier
                    rateGroupList.add(new RateGroups(HighRoads_Constants.TIER_2,planTypeRateTierMap.get(medicalPlanRiderPlanName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.TIER_2),rateCardId == NULL ? true : false));
                    //Incrementing the tier count which will be used for dynamcic row span in html table
                    tierCount+=1;
                    // adding the tier to addedtierset
                    // if they select any new tier which is not selected earlier while entering the rates
                    if(existingTiersMap != NULL && !existingTiersMap.isEmpty() && existingTiersMap.get(medicalPlanRiderPlanName) != NULL && !existingTiersMap.get(medicalPlanRiderPlanName).contains(HighRoads_Constants.TIER_2)){
                        addedTierSet.add(medicalPlanRiderPlanName+HighRoads_Constants.SYMBOL_ASH+HighRoads_Constants.TIER_2);
                    }
                }
                //if tier 3 is selected for the plan
                if(rateTierObj.tier3){
                    //constructing the group list for the selected tier
                    isTier3Selected = true;
                    //constructing the group list for the selected tier
                    rateGroupList.add(new RateGroups(HighRoads_Constants.TIER_3,planTypeRateTierMap.get(medicalPlanRiderPlanName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.TIER_3),rateCardId == NULL ? true : false));
                    //Incrementing the tier count which will be used for dynamcic row span in html table
                    tierCount+=1;
                    // adding the tier to addedtierset
                    // if they select any new tier which is not selected earlier while entering the rates
                    if(existingTiersMap != NULL && !existingTiersMap.isEmpty() && existingTiersMap.get(medicalPlanRiderPlanName) != NULL && !existingTiersMap.get(medicalPlanRiderPlanName).contains(HighRoads_Constants.TIER_3)){
                        addedTierSet.add(medicalPlanRiderPlanName+HighRoads_Constants.SYMBOL_ASH+HighRoads_Constants.TIER_3);
                    }
                }
                //if tier 4 is selected for the plan
                if(rateTierObj.tier4){
                    //constructing the group list for the selected tier
                    isTier4Selected = true;
                    //constructing the group list for the selected tier
                    rateGroupList.add(new RateGroups(HighRoads_Constants.TIER_4,planTypeRateTierMap.get(medicalPlanRiderPlanName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.TIER_4),rateCardId == NULL ? true : false));
                    //Incrementing the tier count which will be used for dynamcic row span in html table
                    tierCount+=1;
                    // adding the tier to addedtierset
                    // if they select any new tier which is not selected earlier while entering the rates
                    if(existingTiersMap != NULL && !existingTiersMap.isEmpty() && existingTiersMap.get(medicalPlanRiderPlanName) != NULL && !existingTiersMap.get(medicalPlanRiderPlanName).contains(HighRoads_Constants.TIER_4)){
                        addedTierSet.add(medicalPlanRiderPlanName+HighRoads_Constants.SYMBOL_ASH+HighRoads_Constants.TIER_4);
                    }
                }
                //if tier 5 is selected for the plan
                if(rateTierObj.tier5){
                    //constructing the group list for the selected tier
                    isTier5Selected = true;
                    //constructing the group list for the selected tier
                    rateGroupList.add(new RateGroups(HighRoads_Constants.TIER_5,planTypeRateTierMap.get(medicalPlanRiderPlanName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.TIER_5),rateCardId == NULL ? true : false));
                    //Incrementing the tier count which will be used for dynamcic row span in html table
                    tierCount+=1;
                    // adding the tier to addedtierset
                    // if they select any new tier which is not selected earlier while entering the rates
                    if(existingTiersMap != NULL && !existingTiersMap.isEmpty() && existingTiersMap.get(medicalPlanRiderPlanName) != NULL && !existingTiersMap.get(medicalPlanRiderPlanName).contains(HighRoads_Constants.TIER_5)){
                        addedTierSet.add(medicalPlanRiderPlanName+HighRoads_Constants.SYMBOL_ASH+HighRoads_Constants.TIER_5);
                    }
                }
                //checking if the tier 1 is not selected but it may be selected earlier and now it is un selected
                //adding that plan and its tier to delete tier set
                if(!rateTierObj.tier1){
                    if(existingTiersMap != NULL && !existingTiersMap.isEmpty() && existingTiersMap.get(medicalPlanRiderPlanName) != NULL && existingTiersMap.get(medicalPlanRiderPlanName).contains(HighRoads_Constants.TIER_1)){
                        deleteTierSet.add(medicalPlanRiderPlanName+HighRoads_Constants.SYMBOL_ASH+HighRoads_Constants.TIER_1);
                    }
                }
                //checking if the tier 2 is not selected but it may be selected earlier and now it is un selected
                //adding that plan and its tier to delete tier set
                if(!rateTierObj.tier2){
                    if(existingTiersMap != NULL && !existingTiersMap.isEmpty() && existingTiersMap.get(medicalPlanRiderPlanName) != NULL && existingTiersMap.get(medicalPlanRiderPlanName).contains(HighRoads_Constants.TIER_2)){
                        deleteTierSet.add(medicalPlanRiderPlanName+HighRoads_Constants.SYMBOL_ASH+HighRoads_Constants.TIER_2);
                    }
                }
                //checking if the tier 3 is not selected but it may be selected earlier and now it is un selected
                //adding that plan and its tier to delete tier set
                if(!rateTierObj.tier3){
                    if(existingTiersMap != NULL && !existingTiersMap.isEmpty() && existingTiersMap.get(medicalPlanRiderPlanName) != NULL && existingTiersMap.get(medicalPlanRiderPlanName).contains(HighRoads_Constants.TIER_3)){
                        deleteTierSet.add(medicalPlanRiderPlanName+HighRoads_Constants.SYMBOL_ASH+HighRoads_Constants.TIER_3);
                    }
                }
                //checking if the tier 4 is not selected but it may be selected earlier and now it is un selected
                //adding that plan and its tier to delete tier set
                if(!rateTierObj.tier4){
                    if(existingTiersMap != NULL && !existingTiersMap.isEmpty() && existingTiersMap.get(medicalPlanRiderPlanName) != NULL && existingTiersMap.get(medicalPlanRiderPlanName).contains(HighRoads_Constants.TIER_4)){
                        deleteTierSet.add(medicalPlanRiderPlanName+HighRoads_Constants.SYMBOL_ASH+HighRoads_Constants.TIER_4);
                    }
                }
                //checking if the tier 5 is not selected but it may be selected earlier and now it is un selected
                //adding that plan and its tier to delete tier set
                if(!rateTierObj.tier5){
                    if(existingTiersMap != NULL && !existingTiersMap.isEmpty() && existingTiersMap.get(medicalPlanRiderPlanName) != NULL && existingTiersMap.get(medicalPlanRiderPlanName).contains(HighRoads_Constants.TIER_5)){
                        deleteTierSet.add(medicalPlanRiderPlanName+HighRoads_Constants.SYMBOL_ASH+HighRoads_Constants.TIER_5);
                    }
                }
                //cosntrucing map for each plan with earlier/current selected group list for Medical and Rider Plans
                String medPlanName = planRateTierObj.medicalPlanName+HighRoads_Constants.SYMBOL_ASH+rateTierObj.planName;
                if(planGroupsMap.containsKey(medPlanName)){
                    List<RateGroups> rateGrpList = planGroupsMap.get(medPlanName);
                    rateGrpList.addAll(rateGroupList);
                    planGroupsMap.put(medPlanName, rateGrpList);
                }else{
                    List<RateGroups> rateGrpList = new List<RateGroups>();
                    rateGrpList.addAll(rateGroupList);
                    planGroupsMap.put(medPlanName, rateGrpList);
                }
            }
            //construcrting tiercount map for each plan
            totalRateTiersCountMap.put(planRateTierObj.medicalPlanName, tierCount);
        }
        //construcitng the map for Medical Plans using the above constructed Meidcal and Rider Plans map
        //which will be used to construct the main wrapper list which will render in group selection screen
        Map<String,List<PlanGroups>> planGroupMap = new Map<String,List<PlanGroups>>();
        //looping the MedicalandRiderPlan rategroup(planGroupsMap)
        for(String planGroupMapKey : planGroupsMap.keySet()){
            //fetching the rateGroupList for that MedicalRiderPlan
            List<RateGroups> rateGrpList = planGroupsMap.get(planGroupMapKey);
            //constructing the plangrouplist
            planGroupList = new List<PlanGroups>();
            //constructing the wrapper class for each plan individually Medical Plan and Rider Plan
            //for Medical plan it should like (Medical , rateGroupList);
            //for rider plan it should like (XA02 -2016,rateGroupList);
            planGroupList.add(new PlanGroups(planGroupMapKey.subStringAfterLast(HighRoads_Constants.SYMBOL_ASH),rateGrpList));
            //constructing the planGroupMap to store the Medical Plan ex: HE02 - 2016 and its related all plan grouplist
            if(planGroupMap.containsKey(planGroupMapKey.subStringBeforeLast(HighRoads_Constants.SYMBOL_ASH))){
                List<PlanGroups> planGrpList = planGroupMap.get(planGroupMapKey.subStringBeforeLast(HighRoads_Constants.SYMBOL_ASH));
                planGrpList.addAll(planGroupList);
                planGroupMap.put(planGroupMapKey.subStringBeforeLast(HighRoads_Constants.SYMBOL_ASH), planGrpList);
            }else{
                List<PlanGroups> planGrpList = new List<PlanGroups>();
                planGrpList.addAll(planGroupList);
                planGroupMap.put(planGroupMapKey.subStringBeforeLast(HighRoads_Constants.SYMBOL_ASH), planGrpList);
            }
        }
        //constructing final wrapper list to display in group selection screen
        for(String planGroupMapKey : planGroupMap.keySet()){
            planRateTierGroupList.add(new PlanRateTier(planGroupMapKey,planGroupMap.get(planGroupMapKey),totalRateTiersCountMap.get(planGroupMapKey)));
        }
        // adding the fixed size to rateEntryTableWidth which will be used in dynamical width in html table
        if(isTier1Selected){
            rateEntryTableWidth +=5.26;
        }
        if(isTier2Selected){
            rateEntryTableWidth +=2*5.26;
        }
        if(isTier3Selected){
            rateEntryTableWidth +=3*5.26;
        }
        if(isTier4Selected){
            rateEntryTableWidth +=4*5.26;
        }
        if(isTier5Selected){
            rateEntryTableWidth +=5*5.26;
        }
    }
    /**
* Method Name : addGroup
* Parameters  : None
* Description : When user clicks on the AddGroup button from group selection panel
				User can add upto 10 new groups excluding Active and Early Retiree
* Return type : void 
**/
    public void addGroup(){
        //if user click on the add group button
        //populating isOther1Selected boolean variable to true
        //incase of opening the rates which have already entered earlier and other1 is not selcted
        if(!isOther1Selected){
            //adding other1 value to group count
            groupCount.add(HighRoads_Constants.OTHER_1);
            isOther1Selected = true;
            //groupcolspan which will be used for dynamic colspan
            groupColspan = groupCount.size();
            return;
        }
        //if user click on the add group button
        //populating isOther2Selected boolean variable to true
        //incase of opening the rates which have already entered earlier and other2 is not selcted
        if(!isOther2Selected){
            //adding other2 value to group count
            groupCount.add(HighRoads_Constants.OTHER_2);
            isOther2Selected = true;
            //groupcolspan which will be used for dynamic colspan
            groupColspan = groupCount.size();
            return;
        }
        //if user click on the add group button
        //populating isOther3Selected boolean variable to true
        //incase of opening the rates which have already entered earlier and other3 is not selcted
        if(!isOther3Selected){
            //adding other3 value to group count
            groupCount.add(HighRoads_Constants.OTHER_3);
            isOther3Selected = true;
            //groupcolspan which will be used for dynamic colspan
            groupColspan = groupCount.size();
            return;
        }
        //if user click on the add group button
        //populating isOther4Selected boolean variable to true
        //incase of opening the rates which have already entered earlier and other4 is not selcted
        if(!isOther4Selected){
             //adding other4 value to group count
            groupCount.add(HighRoads_Constants.OTHER_4);
            //groupcolspan which will be used for dynamic colspan
            isOther4Selected = true;
            groupColspan = groupCount.size();
            return;
        }
        //if user click on the add group button
        //populating isOther5Selected boolean variable to true
        //incase of opening the rates which have already entered earlier and other5 is not selcted
        if(!isOther5Selected){
            //adding other5 value to group count
            groupCount.add(HighRoads_Constants.OTHER_5);
            isOther5Selected = true;
            //groupcolspan which will be used for dynamic colspan
            groupColspan = groupCount.size();
            return;
        }
        //if user click on the add group button
        //populating isOther6Selected boolean variable to true
        //incase of opening the rates which have already entered earlier and other6 is not selcted
        if(!isOther6Selected){
            //adding other6 value to group count
            groupCount.add(HighRoads_Constants.OTHER_6);
            isOther6Selected = true;
            //groupcolspan which will be used for dynamic colspan
            groupColspan = groupCount.size();
            return;
        }
        //if user click on the add group button
        //populating isOther7Selected boolean variable to true
        //incase of opening the rates which have already entered earlier and other7 is not selcted
        if(!isOther7Selected){
            //adding other7 value to group count
            groupCount.add(HighRoads_Constants.OTHER_7);
            isOther7Selected = true;
            //groupcolspan which will be used for dynamic colspan
            groupColspan = groupCount.size();
            return;
        }
        //if user click on the add group button
        //populating isOther8Selected boolean variable to true
        //incase of opening the rates which have already entered earlier and other8 is not selcted
        if(!isOther8Selected){
            //adding other8 value to group count
            groupCount.add(HighRoads_Constants.OTHER_8);
            isOther8Selected = true;
            //groupcolspan which will be used for dynamic colspan
            groupColspan = groupCount.size();
            return;
        }
        //if user click on the add group button
        //populating isOther9Selected boolean variable to true
        //incase of opening the rates which have already entered earlier and other9 is not selcted
        if(!isOther9Selected){
            //adding other9 value to group count
            groupCount.add(HighRoads_Constants.OTHER_9);
            isOther9Selected = true;
            //groupcolspan which will be used for dynamic colspan
            groupColspan = groupCount.size();
            return;
        }
        //if user click on the add group button
        //populating isOther10Selected boolean variable to true
        //incase of opening the rates which have already entered earlier and other10 is not selcted
        if(!isOther10Selected){
            //adding other10 value to group count
            groupCount.add(HighRoads_Constants.OTHER_10);
            isOther10Selected = true;
            //groupcolspan which will be used for dynamic colspan
            groupColspan = groupCount.size();
            return;
        }
    }
    /**
* Method Name : panel2Next
* Parameters  : None
* Description : When user clicks on Next button on Group selection page.
				Which will alert the user if they dont select any of the gorup
* Return type : void 
**/
    public void panel2Next(){
        /* if user clicked on add group but not enter the name
         * throwing error message to user to enter the group name */
        if((isOther1Selected && (other1 == NULL || other1 == HighRoads_Constants.BLANK_VALUE)) || (isOther2Selected && (other2 == NULL || other2 == HighRoads_Constants.BLANK_VALUE)) || (isOther3Selected && (other3 == NULL || other3 == HighRoads_Constants.BLANK_VALUE)) ||
           (isOther4Selected && (other4 == NULL || other4 == HighRoads_Constants.BLANK_VALUE)) || (isOther5Selected && (other5 == NULL || other5 == HighRoads_Constants.BLANK_VALUE)) || (isOther6Selected && (other6 == NULL || other6 == HighRoads_Constants.BLANK_VALUE)) ||
           (isOther7Selected && (other7 == NULL || other7 == HighRoads_Constants.BLANK_VALUE)) || (isOther8Selected && (other8 == NULL || other8 == HighRoads_Constants.BLANK_VALUE)) || (isOther9Selected && (other9 == NULL || other9 == HighRoads_Constants.BLANK_VALUE)) || (isOther10Selected && (other10 == NULL || other10 == HighRoads_Constants.BLANK_VALUE))){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Group Name'));
               panel2next = true;
               panel3previous = false;
               return;
           }
        panel2next = false;
        panel3previous = true;
        //final wrapper list to render in rate entry screen
        PlanRateTierGroupandRateEntryList = new List<PlanRateTier>();
        
        // looping through the plan group selected list
        for(PlanRateTier planTierObj : planRateTierGroupList){
			//setting the group count which will be used to display the colspan dynamically
            Integer totalGroupCount = 0;
			//setting the tier count which will be used to display the colspan dynamically
            Integer tierCount = 0;
			//List to store the total number of tiers and groups 
			// which will be used to construct the final wrapper list for rate entry screen
            List<PlanTierandRateEntry> innerPlanTierRateEntryList = new List<PlanTierandRateEntry>();
			// looping through the tier - group list
            for(PlanGroups planGroupObj : planTierObj.plangroupList){
				// construcitng the list for tier - number of groups selected for that tier
				// which will be used in dynamic colspan
                List<TierandRateEntry> tierRateList = new List<TierandRateEntry>();
				// counting the groupcount which will be used to display dynamic colspan
                Integer innerGroupCount = 0;
				//looping through groups selected in the ealier screen
                for(RateGroups rateGrpObj : planGroupObj.rateGrpList){
					//forming the unique key upto Tier for the plan
                    String planTypeTierName = planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planGroupObj.planName+HighRoads_Constants.UNDERSCORE+rateGrpObj.tierName;
					//if user dont select any of the gruop - throwing error message
                    if(!rateGrpObj.active && !rateGrpObj.earlyRetiree && !rateGrpObj.other1 && !rateGrpObj.other2
                       && !rateGrpObj.other3 && !rateGrpObj.other4 && !rateGrpObj.other5 && !rateGrpObj.other6 && !rateGrpObj.other7
                       && !rateGrpObj.other8 && !rateGrpObj.other9 && !rateGrpObj.other10){
                           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR117_SelectGroup+planTierObj.medicalPlanName+System.Label.HR116_ANDType+planGroupObj.planName+System.Label.HR118_ANDTier+rateGrpObj.tierName));
                           panel2next = true;
                           panel3previous = false;
                           return;
                       }
					//constructing the rate entry list for each group selected in the previous section
                    rateEntryList = new List<RateEntry>();
					//if user selected Active Group
                    if(rateGrpObj.active){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(HighRoads_Constants.ACTIVE_GROUP_NAME,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.ACTIVE_GROUP_NAME),rateGrpObj.tierName,HighRoads_Constants.BLANK_VALUE));
                        //dynamically construting the group count which will be used for displaying the colspan dynamically
						totalGroupCount+=1;
						//checking the existing group set contains the active group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.ACTIVE_GROUP_NAME)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.ACTIVE_GROUP_NAME);
                        }
                    }
					//if user selected Early Ritiree Group
                    if(rateGrpObj.earlyRetiree){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(HighRoads_Constants.EARLY_RETIREE_GROUP_NAME,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.EARLY_RETIREE_GROUP_NAME),rateGrpObj.tierName,HighRoads_Constants.BLANK_VALUE));
                        //dynamically construting the group count which will be used for displaying the colspan dynamically
						totalGroupCount+=1;
						//checking the existing group set contains the Early Retiree group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.EARLY_RETIREE_GROUP_NAME)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.EARLY_RETIREE_GROUP_NAME);
                        }
                    }
                    //if user selected Other1
                    if(rateGrpObj.other1 != NULL && rateGrpObj.other1){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(other1,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_1),rateGrpObj.tierName,HighRoads_Constants.OTHER_1));
                        //dynamically construting the group count which will be used for displaying the colspan dynamically
						totalGroupCount+=1;
						//checking the existing group set contains the Other1 group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_1)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_1);
                        }
                    }
					//if user selected Other2
                    if(rateGrpObj.other2 != NULL && rateGrpObj.other2){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(other2,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_2),rateGrpObj.tierName,HighRoads_Constants.OTHER_2));
						//dynamically construting the group count which will be used for displaying the colspan dynamically
                        totalGroupCount+=1;
						//checking the existing group set contains the Other2 group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_2)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_2);
                        }
                    }
					//if user selected Other3
                    if(rateGrpObj.other3 != NULL && rateGrpObj.other3){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(other3,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_3),rateGrpObj.tierName,HighRoads_Constants.OTHER_3));
						//dynamically construting the group count which will be used for displaying the colspan dynamically
                        totalGroupCount+=1;
						//checking the existing group set contains the Other3 group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_3)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_3);
                        }
                    }
					//if user selected Other4
                    if(rateGrpObj.other4 != NULL && rateGrpObj.other4){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(other4,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_4),rateGrpObj.tierName,HighRoads_Constants.OTHER_4));
						//dynamically construting the group count which will be used for displaying the colspan dynamically
                        totalGroupCount+=1;
						//checking the existing group set contains the Other4 group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_4)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_4);
                        }
                    }
					//if user selected Other5
                    if(rateGrpObj.other5 != NULL && rateGrpObj.other5){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(other5,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_5),rateGrpObj.tierName,HighRoads_Constants.OTHER_5));
						//dynamically construting the group count which will be used for displaying the colspan dynamically
                        totalGroupCount+=1;
						//checking the existing group set contains the Other5 group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_5)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_5);
                        }
                    }
					//if user selected Other6
                    if(rateGrpObj.other6 != NULL && rateGrpObj.other6){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(other6,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_6),rateGrpObj.tierName,HighRoads_Constants.OTHER_6));
						//dynamically construting the group count which will be used for displaying the colspan dynamically
                        totalGroupCount+=1;
						//checking the existing group set contains the Other6 group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_6)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_6);
                        }
                    }
					//if user selected Other7
                    if(rateGrpObj.other7 != NULL && rateGrpObj.other7){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(other7,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_7),rateGrpObj.tierName,HighRoads_Constants.OTHER_7));
						//dynamically construting the group count which will be used for displaying the colspan dynamically
                        totalGroupCount+=1;
						//checking the existing group set contains the Other7 group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_7)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_7);
                        }
                    }
					//if user selected Other8
                    if(rateGrpObj.other8 != NULL && rateGrpObj.other8){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(other8,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_8),rateGrpObj.tierName,HighRoads_Constants.OTHER_8));
						//dynamically construting the group count which will be used for displaying the colspan dynamically
                        totalGroupCount+=1;
						//checking the existing group set contains the Other8 group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_8)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_8);
                        }
                    }
					//if user selected Other9
                    if(rateGrpObj.other9 != NULL && rateGrpObj.other9){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(other9,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_9),rateGrpObj.tierName,HighRoads_Constants.OTHER_9));
						//dynamically construting the group count which will be used for displaying the colspan dynamically
                        totalGroupCount+=1;
						//checking the existing group set contains the Other9 group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_9)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_9);
                        }
                    }
					//if user selected Other10
                    if(rateGrpObj.other10 != NULL && rateGrpObj.other10){
						//constructing rate entry list which will render in rate entry screen
                        rateEntryList.add(new RateEntry(other10,planTypeRateTierGroupMap.get(planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_10),rateGrpObj.tierName,HighRoads_Constants.BLANK_VALUE));
						//dynamically construting the group count which will be used for displaying the colspan dynamically
                        totalGroupCount+=1;
						//checking the existing group set contains the Other10 group else adding it to newly added group set
                        if(!existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_10)){
                            addedGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_10);
                        }
                    }
					//Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(!rateGrpObj.active){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.ACTIVE_GROUP_NAME)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.ACTIVE_GROUP_NAME);
                        }
                    }
					//Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(!rateGrpObj.earlyRetiree){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.EARLY_RETIREE_GROUP_NAME)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.EARLY_RETIREE_GROUP_NAME);
                        }
                    }
                    //Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(rateGrpObj.other1 != NULL && !rateGrpObj.other1){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_1)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_1);
                        }
                    }
					//Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(rateGrpObj.other2 != NULL && !rateGrpObj.other2){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_2)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_2);
                        }
                    }
					//Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(rateGrpObj.other3 != NULL && !rateGrpObj.other3){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_3)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_3);
                        }
                    }
					//Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(rateGrpObj.other4 != NULL && !rateGrpObj.other4){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_4)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_4);
                        }
                    }
					//Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(rateGrpObj.other5 != NULL && !rateGrpObj.other5){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_5)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_5);
                        }
                    }
					//Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(rateGrpObj.other6 != NULL && !rateGrpObj.other6){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_6)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_6);
                        }
                    }
					//Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(rateGrpObj.other7 != NULL && !rateGrpObj.other7){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_7)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_7);
                        }
                    }
					//Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(rateGrpObj.other8 != NULL && !rateGrpObj.other8){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_8)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_8);
                        }
                    }
					//Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(rateGrpObj.other9 != NULL && !rateGrpObj.other9){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_9)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_9);
                        }
                    }
                    //Checkign the group not selected but it has ealier or not
					// if selected earlier and not selected now, adding it to deletegroupset to delete the rates for this group
                    if(rateGrpObj.other10 != NULL && !rateGrpObj.other10){
                        if(existingRateGroup.contains(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_10)){
                            deleteGroupSet.add(recordId+HighRoads_Constants.UNDERSCORE+planTypeTierName+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.OTHER_10);
                        }
                    }
					//adding to tierRateslist based on the tierName and grouplist
                    tierRateList.add(new TierandRateEntry(rateGrpObj.tierName,rateEntryList));
                }
				//calculating the group count to render the colspan dynamically
                for(TierandRateEntry treObj : tierRateList){
                    innerGroupCount+=treObj.sizeOfGroups;
                }
				//calculating tier count to render the group colspan dynamically
                tierCount+=tierRateList.size();
				//constructing the innerPlanTierRateEntry list which includes Rider Plan,Tier,Group,Rates for that plan
				// if dental plan exists - it will be used to render a message to user on dental plans
                if(!HighRoads_Constants.MEDICAL.equalsIgnoreCase(planGroupObj.planName) && dentalPlanSet.contains(planGroupObj.planName)){
                    innerPlanTierRateEntryList.add(new PlanTierandRateEntry(planGroupObj.planName,true,tierRateList,innerGroupCount));
                }
				//constructing the innerPlanTierRateEntry list which includes Rider Plan,Tier,Group,Rates for that plan
				else{
                    innerPlanTierRateEntryList.add(new PlanTierandRateEntry(planGroupObj.planName,false,tierRateList,innerGroupCount));
                }
                
            }
			//construcitng the final rate entry wrapper list
            PlanRateTierGroupandRateEntryList.add(new PlanRateTier(planTierObj.medicalPlanName,innerPlanTierRateEntryList,totalGroupCount+tierCount));
        }
    }
    
    /**
* Method Name : panel2Previous
* Parameters  : None
* Description : When user clicks on previous button on Group selection page.
* Return type : void 
**/
    public void panel2Previous(){
        panel2next = false;
        panel2previous = true;
        panel1next = true;
        
    }
    /**
* Method Name : panel3Previous
* Parameters  : None
* Description : When user clicks on previous button on rate entry screen.
* Return type : void 
**/
    public void panel3Previous(){
        panel2next = true;
        panel2previous = true;
        panel1next = false;
        panel3previous = false;
    }
    /**
* Method Name : saveRates
* Parameters  : None
* Description : When user clicks on save button on rate entry screen.
* Return type : void 
**/
    public void saveRates(){
        Rate_Card__c rateCardObj;
        Boolean isRateChanged = false;
        isRateErrorFound = false; 
        List<Rates__c> ratesList = new List<Rates__c>();
		//checking for any of the tier is selected/unselected
		// checking for any of the group is selected/unselected
		// checking for any rate has been changed.
		// if any of the above parameters changed/added/removed then create new rate card when the parent and child rate cards are same.
        if(planTypeRateTierGroupMap != NULL && !planTypeRateTierGroupMap.isEmpty()){
            for(PlanRateTier planTierObj : PlanRateTierGroupandRateEntryList){
                for(PlanTierandRateEntry planTierRateObj : planTierObj.planTierandRateEntryList){
                    for(TierandRateEntry tierRateEntryObj : planTierRateObj.tierRateEntryList){
                        for(RateEntry rateEntryObj : tierRateEntryObj.rateEntryList){
							//checking the rates have been changed for Tier 1
                            if(tierRateEntryObj.tierName == HighRoads_Constants.TIER_1){
                                if(planTypeRateTierGroupMap != NULL && !planTypeRateTierGroupMap.isEmpty() &&
                                   planTypeRateTierGroupMap.get(planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupName) != NULL){
                                       List<String> rateValueList = planTypeRateTierGroupMap.get(planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupName);
                                       if(rateValueList[0] != rateEntryObj.tier1Composite){
                                           isRateChanged = true;
                                       }
                                   }
                            }
							//checking the rates have been changed for Tier 2
                            if(tierRateEntryObj.tierName == HighRoads_Constants.TIER_2){
                                if(planTypeRateTierGroupMap != NULL && !planTypeRateTierGroupMap.isEmpty() &&
                                   planTypeRateTierGroupMap.get(planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupName) != NULL){
                                       List<String> rateValueList = planTypeRateTierGroupMap.get(planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupName);
                                       if(rateValueList[0] != rateEntryObj.tier2EE){
                                           isRateChanged = true;
                                       }
                                       if(rateValueList[1] != rateEntryObj.tier2EF){
                                           isRateChanged = true;
                                       }
                                   }
                            }
							//checking the rates have been changed for Tier 3
                            if(tierRateEntryObj.tierName == HighRoads_Constants.TIER_3){
                                if(planTypeRateTierGroupMap != NULL && !planTypeRateTierGroupMap.isEmpty() &&
                                   planTypeRateTierGroupMap.get(planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupName) != NULL){
                                       List<String> rateValueList = planTypeRateTierGroupMap.get(planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupName);
                                       if(rateValueList[0] != rateEntryObj.tier3EE){
                                           isRateChanged = true;
                                       }
                                       if(rateValueList[1] != rateEntryObj.tier3E1){
                                           isRateChanged = true;
                                       }
                                       if(rateValueList[1] != rateEntryObj.tier3E2){
                                           isRateChanged = true;
                                       }
                                   }
                            }
							//checking the rates have been changed for Tier 4
                            if(tierRateEntryObj.tierName == HighRoads_Constants.TIER_4){
                                if(planTypeRateTierGroupMap != NULL && !planTypeRateTierGroupMap.isEmpty() &&
                                   planTypeRateTierGroupMap.get(planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupName) != NULL){
                                       List<String> rateValueList = planTypeRateTierGroupMap.get(planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupName);
                                       if(rateValueList[0] != rateEntryObj.tier4EE){
                                           isRateChanged = true;
                                       }
                                       if(rateValueList[1] != rateEntryObj.tier4EC){
                                           isRateChanged = true;
                                       }
                                       if(rateValueList[2] != rateEntryObj.tier4ES){
                                           isRateChanged = true;
                                       }
                                       if(rateValueList[3] != rateEntryObj.tier4EF){
                                           isRateChanged = true;
                                       }
                                   }
                            }
							//checking the rates have been changed for Tier 5
                            if(tierRateEntryObj.tierName == HighRoads_Constants.TIER_5){
                                if(planTypeRateTierGroupMap != NULL && !planTypeRateTierGroupMap.isEmpty() &&
                                   planTypeRateTierGroupMap.get(planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupName) != NULL){
                                       List<String> rateValueList = planTypeRateTierGroupMap.get(planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupName);
                                       if(rateValueList[0] != rateEntryObj.tier5EE){
                                           isRateChanged = true;
                                       }
                                       if(rateValueList[1] != rateEntryObj.tier5EC){
                                           isRateChanged = true;
                                       }
                                       if(rateValueList[2] != rateEntryObj.tier5ES){
                                           isRateChanged = true;
                                       }
                                       if(rateValueList[3] != rateEntryObj.tier5EF){
                                           isRateChanged = true;
                                       }
                                       if(rateValueList[4] != rateEntryObj.tier5ECH){
                                           isRateChanged = true;
                                       }
                                   }
                            }
                            
                        }
                    }
                }
            }
        }
        //checking user has selecte/unselected the tiers
        if((deleteTierSet != NULL && !deleteTierSet.isEmpty() && isRateCardSame ) || 
           (deleteGroupSet != NULL && !deleteGroupSet.isEmpty() && isRateCardSame) ||
           (addedTierSet != NULL && !addedTierSet.isEmpty() && isRateCardSame ) || 
           (addedGroupSet != NULL && !addedGroupSet.isEmpty() && isRateCardSame) ||
           (isRateChanged && isRateCardSame)){
               rateCardObj = new Rate_Card__c();
               insert rateCardObj;
               rateCardId = rateCardObj.Id;
           }else{
               if(rateCardId == NULL){
                   rateCardObj = new Rate_Card__c();
                   insert rateCardObj;
                   rateCardId = rateCardObj.Id;
               }else{
                   rateCardObj = new Rate_Card__c(Id=rateCardId);
               }
           }
		//saving the rates for the plans
        for(PlanRateTier planTierObj : PlanRateTierGroupandRateEntryList){
            for(PlanTierandRateEntry planTierRateObj : planTierObj.planTierandRateEntryList){
                for(TierandRateEntry tierRateEntryObj : planTierRateObj.tierRateEntryList){
                    for(RateEntry rateEntryObj : tierRateEntryObj.rateEntryList){
                        System.debug('tierRateEntryObj.tierName'+tierRateEntryObj.tierName);
                        Rates__c rateObj = new Rates__c();
                        rateObj.Rate_Card_ID__c = rateCardId;
                        rateObj.Plan_Name__c = planTierObj.medicalPlanName;
						// setting value for group alias name and group name which will be used to find out actual names for other 1 -10
                        if(rateEntryObj.groupAliasName != NULL && rateEntryObj.groupAliasName != HighRoads_Constants.BLANK_VALUE){
                            rateObj.Group_Type__c = rateEntryObj.groupAliasName;
                            rateObj.Group_Alias_Name__c = rateEntryObj.groupName;
                            rateObj.Plan_Type_Tier_Group__c = recordId+HighRoads_Constants.UNDERSCORE+planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupAliasName;
                        }else{
                            rateObj.Group_Type__c = rateEntryObj.groupName;
                            rateObj.Plan_Type_Tier_Group__c = recordId+HighRoads_Constants.UNDERSCORE+planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName+HighRoads_Constants.UNDERSCORE+tierRateEntryObj.tierName+HighRoads_Constants.UNDERSCORE+rateEntryObj.groupName;
                        }
						// setting the tier type
                        rateObj.Tier_Type__c = tierRateEntryObj.tierName;
						// checking the plan is dental or not
						// if plan is not dental then user need to enter the rates else throw error message to user to enter the rates
                        if(!planTierRateObj.isDental){
							// setting tier 1 values
                            if(HighRoads_Constants.TIER_1.equalsIgnoreCase(tierRateEntryObj.tierName)){
								// if user dont give rate value throwing error message
                                if(rateEntryObj.tier1Composite == NULL || rateEntryObj.tier1Composite == HighRoads_Constants.BLANK_VALUE){
                                    isRateErrorFound = true;
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR119_EnterRatesforAllPlans));
                                    return;
                                }else{
                                    rateObj.Tier_1_Composite__c = rateEntryObj.tier1Composite;
                                }
                            }
							// setting tier 2 values
							else if(HighRoads_Constants.TIER_2.equalsIgnoreCase(tierRateEntryObj.tierName)){
								// if user dont give rate value throwing error message
                                if(rateEntryObj.tier2EE == NULL || rateEntryObj.tier2EE == HighRoads_Constants.BLANK_VALUE || rateEntryObj.tier2EF == NULL || rateEntryObj.tier2EF == HighRoads_Constants.BLANK_VALUE){
                                    isRateErrorFound = true;
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR119_EnterRatesforAllPlans));
                                    
                                    return;
                                }else{
                                    rateObj.Tier_2_EE__c = rateEntryObj.tier2EE;
                                    rateObj.Tier_2_EF__c = rateEntryObj.tier2EF;
                                }
                            }
							// setting tier 3 values
							else if(HighRoads_Constants.TIER_3.equalsIgnoreCase(tierRateEntryObj.tierName)){
								// if user dont give rate value throwing error message
                                if(rateEntryObj.tier3EE == NULL || rateEntryObj.tier3EE == HighRoads_Constants.BLANK_VALUE || 
                                   rateEntryObj.tier3E1 == NULL || rateEntryObj.tier3E1 == HighRoads_Constants.BLANK_VALUE || 
                                   rateEntryObj.tier3E2 == NULL || rateEntryObj.tier3E2 == HighRoads_Constants.BLANK_VALUE){
                                       isRateErrorFound = true;
                                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR119_EnterRatesforAllPlans));
                                       
                                       return;
                                   }else{
                                       rateObj.Tier_3_EE__c = rateEntryObj.tier3EE;
                                       rateObj.Tier_3_EE1__c = rateEntryObj.tier3E1;
                                       rateObj.Tier_3_EE2__c = rateEntryObj.tier3E2;
                                   }
                            }
							// setting tier 4 values
							else if(HighRoads_Constants.TIER_4.equalsIgnoreCase(tierRateEntryObj.tierName)){
								// if user dont give rate value throwing error message
                                if(rateEntryObj.tier4EE == NULL || rateEntryObj.tier4EE == HighRoads_Constants.BLANK_VALUE || 
                                   rateEntryObj.tier4EC == NULL || rateEntryObj.tier4EC == HighRoads_Constants.BLANK_VALUE || 
                                   rateEntryObj.tier4ES == NULL || rateEntryObj.tier4ES == HighRoads_Constants.BLANK_VALUE ||
                                   rateEntryObj.tier4EF == NULL || rateEntryObj.tier4EF == HighRoads_Constants.BLANK_VALUE){
                                       isRateErrorFound = true;
                                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR119_EnterRatesforAllPlans));
                                       
                                       return;
                                   }else{
                                       rateObj.Tier_4_EE__c = rateEntryObj.tier4EE;
                                       rateObj.Tier_4_EC__c = rateEntryObj.tier4EC;
                                       rateObj.Tier_4_ES__c = rateEntryObj.tier4ES;
                                       rateObj.Tier_4_EF__c = rateEntryObj.tier4EF;
                                   }
                            }
							// setting tier 5 values
							else if(HighRoads_Constants.TIER_5.equalsIgnoreCase(tierRateEntryObj.tierName)){
								// if user dont give rate value throwing error message
                                if(rateEntryObj.tier5EE == NULL || rateEntryObj.tier5EE == HighRoads_Constants.BLANK_VALUE || 
                                   rateEntryObj.tier5EC == NULL || rateEntryObj.tier5EC == HighRoads_Constants.BLANK_VALUE || 
                                   rateEntryObj.tier5ES == NULL || rateEntryObj.tier5ES == HighRoads_Constants.BLANK_VALUE ||
                                   rateEntryObj.tier5EF == NULL || rateEntryObj.tier5EF == HighRoads_Constants.BLANK_VALUE ||
                                   rateEntryObj.tier5ECH == NULL || rateEntryObj.tier5ECH == HighRoads_Constants.BLANK_VALUE){
                                       isRateErrorFound = true;
                                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR119_EnterRatesforAllPlans));
                                       
                                       return;
                                   }else{
                                       rateObj.Tier_5_EE__c = rateEntryObj.tier5EE;
                                       rateObj.Tier_5_EC__c = rateEntryObj.tier5EC;
                                       rateObj.Tier_5_ES__c = rateEntryObj.tier5ES;
                                       rateObj.Tier_5_EF__c = rateEntryObj.tier5EF;
                                       rateObj.Tier_5_ECH__c = rateEntryObj.tier5ECH;
                                   }
                            }
                        }
						//skip rate entry for dental plans
						else{
                            rateObj.Tier_1_Composite__c = rateEntryObj.tier1Composite;
                            rateObj.Tier_2_EE__c = rateEntryObj.tier2EE;
                            rateObj.Tier_2_EF__c = rateEntryObj.tier2EF;
                            rateObj.Tier_3_EE__c = rateEntryObj.tier3EE;
                            rateObj.Tier_3_EE1__c = rateEntryObj.tier3E1;
                            rateObj.Tier_3_EE2__c = rateEntryObj.tier3E2;
                            rateObj.Tier_4_EE__c = rateEntryObj.tier4EE;
                            rateObj.Tier_4_EC__c = rateEntryObj.tier4EC;
                            rateObj.Tier_4_ES__c = rateEntryObj.tier4ES;
                            rateObj.Tier_4_EF__c = rateEntryObj.tier4EF;
                            rateObj.Tier_5_EE__c = rateEntryObj.tier5EE;
                            rateObj.Tier_5_EC__c = rateEntryObj.tier5EC;
                            rateObj.Tier_5_ES__c = rateEntryObj.tier5ES;
                            rateObj.Tier_5_EF__c = rateEntryObj.tier5EF;
                            rateObj.Tier_5_ECH__c = rateEntryObj.tier5ECH;
                        }
                        
                        rateObj.Rider_Plan_Name__c = planTierRateObj.planName != HighRoads_Constants.MEDICAL ? planTierRateObj.planName : HighRoads_Constants.BLANK_VALUE; 
                        rateObj.Medical_Plan_Rider_Plan__c = planTierObj.medicalPlanName+HighRoads_Constants.UNDERSCORE+planTierRateObj.planName;
                        
                        ratesList.add(rateObj);
                    }
                }
            }
        }
		//updatingthe rate card id for the plans
        for(Benefit_Plan_Association__c bpaObj : bpaList){
            if(HighRoads_Constants.OPPOBJNAME.equalsIgnoreCase(objectName)){
                bpaObj.Opportunity_Rate_Card__c = rateCardObj.Id;
            }else if(HighRoads_Constants.INCUMBENT_CARRIER_API_NAME.equalsIgnoreCase(objectName)){
                bpaObj.RFP_Rate_Card__c = rateCardObj.Id;
            }else if(HighRoads_Constants.PROPOSAL_API_NAME.equalsIgnoreCase(objectName)){
                bpaObj.Quote_Rate_Card__c = rateCardObj.Id;
            }else if(HighRoads_Constants.SSO_API_NAME.equalsIgnoreCase(objectName)){
                bpaObj.SSO_Rate_Card__c = rateCardObj.Id;
            }else if(HighRoads_Constants.EMPLOYER_GROUP_DATA_API_NAME.equalsIgnoreCase(objectName)){
                bpaObj.SCN_Rate_Card__c = rateCardObj.Id;
            }
            
        }
        update bpaList;
        //populate the parent id
        if(HighRoads_Constants.OPPOBJNAME.equalsIgnoreCase(objectName)){
            populateParentId(recordId,HighRoads_Constants.OPP_API_NAME,ratesList);
        }else if(HighRoads_Constants.INCUMBENT_CARRIER_API_NAME.equalsIgnoreCase(objectName)){
            populateParentId(recordId,HighRoads_Constants.RFP_API_NAME,ratesList);
        }else if(HighRoads_Constants.PROPOSAL_API_NAME.equalsIgnoreCase(objectName)){
            populateParentId(recordId,HighRoads_Constants.QUOTE_API_NAME,ratesList);
        }else if(HighRoads_Constants.SSO_API_NAME.equalsIgnoreCase(objectName)){
            populateParentId(recordId,HighRoads_Constants.SSO_API_NAME,ratesList);
        }else if(HighRoads_Constants.EMPLOYER_GROUP_DATA_API_NAME.equalsIgnoreCase(objectName)){
            populateParentId(recordId,HighRoads_Constants.SCN_API_NAME,ratesList);
        }
        //upserting the rates
        if(!ratesList.isEmpty()){
            upsert ratesList Plan_Type_Tier_Group__c;
        }
        
        List<Rates__c> deleteRatesList = new List<Rates__c>();
        List<Rates__c> updateRatesList = new List<Rates__c>();
        for(Rates__c existingRateObj : existingratesList){
            String keyForTier = existingRateObj.Medical_Plan_Rider_Plan__c+HighRoads_Constants.SYMBOL_ASH+existingRateObj.Tier_Type__c;
            if(deleteTierSet.contains(keyForTier)){
                deleteRatesList.add(existingRateObj);
            }
            if(deleteGroupSet.contains(existingRateObj.Plan_Type_Tier_Group__c)){
                deleteRatesList.add(existingRateObj);
            }
        }
		//delete any rates user has unselected
        if(!deleteRatesList.isEmpty()){
            Delete deleteRatesList;
        }
		//if user added any tier/group/rate changed then we are creaing the new rate card so remove the association from the old rates
        if(((addedTierSet != NULL && !addedTierSet.isEmpty()) || (addedGroupSet != NULL && !addedGroupSet.isEmpty())) && isRateCardSame){
            for(Rates__c existingRateObj : existingratesList){
                if(HighRoads_Constants.OPPOBJNAME.equalsIgnoreCase(objectName)){
                    existingRateObj.put(HighRoads_Constants.OPP_API_NAME,null);
                }else if(HighRoads_Constants.INCUMBENT_CARRIER_API_NAME.equalsIgnoreCase(objectName)){
                    existingRateObj.put(HighRoads_Constants.RFP_API_NAME,null);
                }else if(HighRoads_Constants.PROPOSAL_API_NAME.equalsIgnoreCase(objectName)){
                    existingRateObj.put(HighRoads_Constants.QUOTE_API_NAME,null);
                }else if(HighRoads_Constants.SSO_API_NAME.equalsIgnoreCase(objectName)){
                    existingRateObj.put(HighRoads_Constants.SSO_API_NAME,null);
                }else if(HighRoads_Constants.EMPLOYER_GROUP_DATA_API_NAME.equalsIgnoreCase(objectName)){
                    existingRateObj.put(HighRoads_Constants.SCN_API_NAME,null);
                }
                updateRatesList.add(existingRateObj);
            }
            if(updateRatesList != NULL && !updateRatesList.isEmpty()){
                update updateRatesList;
            }
        }
    }
    /**
* Method Name : populateParentId
* Parameters  : ID recId,String objectName,List<Rates__c> ratesList
* Description : This method will be called from saveRates method to populate the Parent Id like Opportunity,RFP,Quote,SSO or SCN
* Return Type : void
**/
    public void populateParentId(ID recId,String objectName,List<Rates__c> ratesList){
        for(Rates__c rateObj : ratesList){
            rateObj.put(objectName,recId);
        }
    }
    /**
* Class Name  : PlanRateTier
* Description : This is the wrapper class to construct all Tiers , Groups and Rates
**/
    public class PlanRateTier{
        public string medicalPlanName{get;set;}
        public Integer sizeOfTierList{get;set;}
        public Integer sizeOfTotalTiers{get;set;}
        public Integer sizeOfTotalTiersGroups{get;set;}
        public List<RateTiers> tierList{get;set;}
        public List<PlanGroups> plangroupList{get;set;}
        public List<PlanTierandRateEntry> planTierandRateEntryList{get;set;}
        public PlanRateTier(String medPlanName,List<RateTiers> rateTierList){
            this.medicalPlanName = medPlanName;
            this.tierList = rateTierList;
            this.sizeOfTierList = rateTierList.size()+1;
        }
        public PlanRateTier(String medPlanName,List<PlanGroups> planGroupList,Integer totalTiers){
            this.medicalPlanName = medPlanName;
            this.plangroupList = planGroupList;
            this.sizeOfTotalTiers = totalTiers+planGroupList.size();
        }
        public PlanRateTier(String medPlanName,List<PlanTierandRateEntry> planTierRateEntryList,Integer totalTiersGroups){
            this.medicalPlanName = medPlanName;
            this.planTierandRateEntryList = planTierRateEntryList;
            this.sizeOfTotalTiersGroups = totalTiersGroups;
        }
    }
    /**
* Class Name  : RateTiers
* Description : This is the wrapper class to construct Rates for the each tier
**/
    public class RateTiers{
        public boolean tier1{get;set;}
        public boolean tier2{get;set;}
        public boolean tier3{get;set;}
        public boolean tier4{get;set;}
        public boolean tier5{get;set;}
        public String planName{get;set;}
        public RateTiers(String planName,boolean isMedical,String tierType){
            if(tierType == NULL || tierType == HighRoads_Constants.BLANK_VALUE){
                this.tier1 = false;
                this.tier2 = false;
                this.tier3 = false;
                this.tier4 = false;
                this.tier5 = false;
            }else{
                if(tierType.containsIgnoreCase(HighRoads_Constants.TIER_1)){
                    this.tier1 = true;
                }if(tierType.containsIgnoreCase(HighRoads_Constants.TIER_2)){
                    this.tier2 = true;
                }if(tierType.containsIgnoreCase(HighRoads_Constants.TIER_3)){
                    this.tier3 = true;
                }if(tierType.containsIgnoreCase(HighRoads_Constants.TIER_4)){
                    this.tier4 = true;
                }if(tierType.containsIgnoreCase(HighRoads_Constants.TIER_5)){
                    this.tier5 = true;
                }
                
            }
            if(isMedical){
                this.planName = HighRoads_Constants.MEDICAL;
            }else{
                this.planName = planName;
            }
        }
    }
    /**
* Class Name  : RateGroups
* Description : This is the wrapper class to construct Rates for the each group
**/
    public class RateGroups{
        public boolean active{get;set;}
        public boolean earlyRetiree{get;set;}
        public boolean teachers{get;set;}
        public boolean workers{get;set;}
        public boolean other10{get;set;}
        public boolean other1{get;set;}
        public boolean other2{get;set;}
        public boolean other3{get;set;}
        public boolean other4{get;set;}
        public boolean other5{get;set;}
        public boolean other6{get;set;}
        public boolean other7{get;set;}
        public boolean other8{get;set;}
        public boolean other9{get;set;}
        public string tierName{get;set;}
        public RateGroups(String tierName,String groupName,boolean isRateCardNull){
            if(groupName == NULL || groupName == HighRoads_Constants.BLANK_VALUE){
                if(isRateCardNull){
                    this.active = true;
                }else{
                    this.active = false;
                }
                
                this.earlyRetiree = false;
                this.workers = false;
                this.teachers = false;
                this.other1 = false;
                this.other2 = false;
                this.other3 = false;
                this.other4 = false;
                this.other5 = false;
                this.other6 = false;
                this.other7 = false;
                this.other8 = false;
                this.other9 = false;
                this.other10 = false;
            }else{
                if(groupName.containsIgnoreCase(HighRoads_Constants.ACTIVE_GROUP_NAME)){
                    this.active = true;
                }if(groupName.containsIgnoreCase(HighRoads_Constants.EARLY_RETIREE_GROUP_NAME)){
                    this.earlyRetiree = true;
                }if(groupName.containsIgnoreCase(HighRoads_Constants.OTHER_1)){
                    this.other1 = true;
                }if(groupName.containsIgnoreCase(HighRoads_Constants.OTHER_2)){
                    this.other2 = true;
                }if(groupName.containsIgnoreCase(HighRoads_Constants.OTHER_3)){
                    this.other3 = true;
                }if(groupName.containsIgnoreCase(HighRoads_Constants.OTHER_4)){
                    this.other4 = true;
                }if(groupName.containsIgnoreCase(HighRoads_Constants.OTHER_5)){
                    this.other5 = true;
                }if(groupName.containsIgnoreCase(HighRoads_Constants.OTHER_6)){
                    this.other6 = true;
                }if(groupName.containsIgnoreCase(HighRoads_Constants.OTHER_7)){
                    this.other7 = true;
                }if(groupName.containsIgnoreCase(HighRoads_Constants.OTHER_8)){
                    this.other8 = true;
                }if(groupName.containsIgnoreCase(HighRoads_Constants.OTHER_9)){
                    this.other9 = true;
                }if(groupName.containsIgnoreCase(HighRoads_Constants.OTHER_10)){
                    this.other10 = true;
                }
            }
            this.tierName = tierName;
        }
        
    }
    /**
* Class Name  : PlanGroups
* Description : This is the wrapper class to construct groups for each plan to render in row span
**/
    public class PlanGroups{
        public String planName{get;set;}
        public Integer sizeOfTiers{get;set;}
        public List<RateGroups> rateGrpList{get;set;}
        public PlanGroups(String planName , List<RateGroups> rateGrpList){
            this.planName = planName;
            this.rateGrpList = rateGrpList;
            this.sizeOfTiers = rateGrpList.size()+1;
        }
    }
    /**
* Class Name  : RateEntry
* Description : This is the wrapper class to construct rates for each group
**/
    public class RateEntry{
        public String tier1Composite{get;set;}
        public String tier2EE{get;set;}
        public String tier2EF{get;set;}
        public String tier3EE{get;set;}
        public String tier3E1{get;set;}
        public String tier3E2{get;set;}
        public String tier4EE{get;set;}
        public String tier4EC{get;set;}
        public String tier4ES{get;set;}
        public String tier4EF{get;set;}
        public String tier5EE{get;set;}
        public String tier5EC{get;set;}
        public String tier5ES{get;set;}
        public String tier5EF{get;set;}
        public String tier5ECH{get;set;}
        public String groupName{get;set;}
        public String groupAliasName{get;set;}
        public RateEntry(String grpName,List<String> ratesList,String tierName,String aliasName){
            this.groupName = grpName;
            if(aliasName != HighRoads_Constants.BLANK_VALUE && aliasName != NULL){
                this.groupAliasName = aliasName;
            }
            if(tierName.equalsIgnoreCase(HighRoads_Constants.TIER_1)){
                if(ratesList != NULL && !ratesList.isEmpty()){
                    this.tier1Composite = ratesList[0];
                }
            }
            if(tierName.equalsIgnoreCase(HighRoads_Constants.TIER_2)){
                if(ratesList != NULL && !ratesList.isEmpty()){
                    this.tier2EE = ratesList[0];
                    this.tier2EF = ratesList[1];
                }
            }else if(tierName.equalsIgnoreCase(HighRoads_Constants.TIER_3)){
                if(ratesList != NULL && !ratesList.isEmpty()){
                    this.tier3EE = ratesList[0];
                    this.tier3E1 = ratesList[1];
                    this.tier3E2 = ratesList[2];
                }
            }else if(tierName.equalsIgnoreCase(HighRoads_Constants.TIER_4)){
                if(ratesList != NULL && !ratesList.isEmpty()){
                    this.tier4EE = ratesList[0];
                    this.tier4ES = ratesList[1];
                    this.tier4EC = ratesList[2];
                    this.tier4EF = ratesList[3];
                }
            }else if(tierName.equalsIgnoreCase(HighRoads_Constants.TIER_5)){
                if(ratesList != NULL && !ratesList.isEmpty()){
                    this.tier5EE = ratesList[0];
                    this.tier5ES = ratesList[1];
                    this.tier5EC = ratesList[2];
                    this.tier5ECH = ratesList[3];
                    this.tier5EF = ratesList[4];
                }
            }
        }
    }
    /**
* Class Name  : TierandRateEntry
* Description : Constructing rate list for each tier
**/
    public class TierandRateEntry{
        public String tierName{get;set;}
        public List<RateEntry> rateEntryList{get;set;}
        public Integer sizeOfGroups{get;set;}
        public TierandRateEntry(String tierName,List<RateEntry> rateEntList){
            this.tierName = tierName;
            this.rateEntryList = rateEntList;
            this.sizeOfGroups = rateEntList.size()+1;
        }
    }
    /**
* Class Name  : PlanTierandRateEntry
* Description : Constructing rate list for each plan with TierandRateEntry
**/
    public class PlanTierandRateEntry{
        public String planName{get;set;}
        public boolean isDental{get;set;}
        public List<TierandRateEntry> tierRateEntryList{get;set;}
        public Integer sizeOfTierandGroups{get;set;}
        public PlanTierandRateEntry(String planName,boolean isDental,List<TierandRateEntry> tierRateEntryList,Integer sizeOfPlanTiers){
            this.planName = planName;
            this.tierRateEntryList = tierRateEntryList;
            this.sizeOfTierandGroups = sizeOfPlanTiers;
            this.isDental = isDental;
        }
    }  
}