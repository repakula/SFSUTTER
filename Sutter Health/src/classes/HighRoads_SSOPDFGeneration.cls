/*******************************************************************************************************************
     Class Name : HighRoads_SSOPDFGeneration
     Author     : IDC Offshore
     Date       : 6/22/2016
     Description: This controller class is used to populate the data in SSO pdf file.
     History:
     VERSION    AUTHOR              DATE        DETAIL
     1.0        IDC-Offshore      6/22/2016     This is controller class for HighRoads_SSOPDFGeneration page, is used
												to popualte sso pdf data
*******************************************************************************************************************/
public class HighRoads_SSOPDFGeneration {
    public Sold_Sign_Off__c soldSignOff{get;set;}
    Public String rateCardId{get;set;}
    Public List<Benefit_Plan_Association__c> nonRatePlans{get;set;}
    public List<PlanRateTier> PlanRateTierGroupandRateEntryList{get;set;}
    //to check the tier1 is selected
    public boolean isTier1Selected{get;set;}
    //to check the tier2 is selected
    public boolean isTier2Selected{get;set;}
    //to check the tier3 is selected
    public boolean isTier3Selected{get;set;}
    //to check the tier4 is selected
    public boolean isTier4Selected{get;set;}
    //to check the tier5 is selected
    public boolean isTier5Selected{get;set;}
    //to dynamically display the width in pdf page
    public Double rateEntryTableWidth{get;set;}
    //wrapper list used to construct the plans which do not have the rates
    public List<PlanWrapper> planWrapperList{get;set;}
    //map to construct the medical and associated riders which do not have rates
    public Map<String,List<planWrapper>> medicalRiderMap = new  Map<String,List<planWrapper>>();
    public List<planRiderWrapper> planRiderWrapperList{get;set;}
	//Constructor
    public HighRoads_SSOPDFGeneration(ApexPages.StandardController controller){
        this.soldSignOff = (Sold_Sign_Off__c)controller.getRecord();
        isTier1Selected = false;
        isTier2Selected = false;
        isTier3Selected = false;
        isTier4Selected = false;
        isTier5Selected = false;
        planRiderWrapperList = new List<planRiderWrapper>();
        planWrapperList = new List<PlanWrapper>();
    }
    //Method which is calling from page
    public void generatePDF(){
        //default width for Plan Name, Plan Type,Tier Type,Group Name
        rateEntryTableWidth = 21.04;
        //list to store the no rate plans
        nonRatePlans = new List<Benefit_Plan_Association__c>();
        //wrapper list to construct all the plans, riders, tiers, groups , rates
        PlanRateTierGroupandRateEntryList = new List<PlanRateTier>();
        		//fetching the plans for the reocrd
        		Sold_Sign_Off__c ssoObj = [select id,(select Id,Benefit_Plan_Metadata__c,Raider_ID__c,Benefit_Plan_Metadata__r.Name,Benefit_Plan_Metadata__r.Product_Class__c, Raider_ID__r.Product_Class__c,
                                         Raider_ID__r.Name,Medical_or_Rider__c,Benefit_Plan_Metadata__r.Benefit_Plan_ID__c,Raider_ID__r.Benefit_Plan_ID__c,SSO_Rate_Card__c from Benefit_Plan_Associations__r) from Sold_Sign_Off__c 
                                         where id=:soldSignOff.Id];
        		//if plans are exists
                if(ssoObj != NULL && ssoObj.Benefit_Plan_Associations__r.size() > 0){
                    for(Benefit_Plan_Association__c bpaObj : ssoObj.Benefit_Plan_Associations__r){
                        //if rate card is not null for the plan
                        if(bpaObj.SSO_Rate_Card__c != NULL){
                            rateCardId = bpaObj.SSO_Rate_Card__c;
                        }else{
                            //taking the plans to map to render them in different tabl in pdf page
                            //condition for medical plans
                            if(bpaObj.Medical_or_Rider__c == System.Label.HR42_Medical){
                                if(medicalRiderMap.containsKey(bpaObj.Benefit_Plan_Metadata__r.Name)){
                                    List<planWrapper> mapValues = medicalRiderMap.get(bpaObj.Benefit_Plan_Metadata__r.Name);
                                    mapValues.add(new planWrapper(bpaObj));
                                    
                                    medicalRiderMap.put(bpaObj.Benefit_Plan_Metadata__r.Name, mapValues);   
                                }else{
                                    List<planWrapper> mapValues = new List<planWrapper>();
                                    mapValues.add(new planWrapper(bpaObj));
                                    medicalRiderMap.put(bpaObj.Benefit_Plan_Metadata__r.Name, mapValues);
                                }
                            }
                            //condition for rider plans
                            else if(bpaObj.Medical_or_Rider__c == System.Label.HR43_Rider){
                                if(medicalRiderMap.containsKey(bpaObj.Benefit_Plan_Metadata__r.Name)){
                                    List<planWrapper> mapValues = medicalRiderMap.get(bpaObj.Benefit_Plan_Metadata__r.Name);
                                    mapValues.add(new planWrapper(bpaObj));
                                    medicalRiderMap.put(bpaObj.Benefit_Plan_Metadata__r.Name, mapValues);   
                                }else{
                                    List<planWrapper> mapValues = new List<planWrapper>();
                                    mapValues.add(new planWrapper(bpaObj));
                                    medicalRiderMap.put(bpaObj.Benefit_Plan_Metadata__r.Name, mapValues);
                                }
                            }
                        }
                        }
                    }
        			//constructing the no rate plans wrapper list to render them in the pdf page
                    for(String medicalPlan : medicalRiderMap.keySet()){
                        planRiderWrapperList.add(new planRiderWrapper(medicalPlan,medicalRiderMap.get(medicalPlan)));
                    }
        			//constructing the wrapper class to display plan,plan type,tier type,group type,rates in pdf page
                    if(rateCardId != NULL){
                        //fetching all existing rates
                        List<Rates__c> existingratesList = [SELECT ID,Group_Type__c,Group_Alias_Name__c ,Plan_Name__c,Rider_Plan_Name__c,Plan_Type_Tier_Group__c,Rate_Card_ID__c,Tier_1_Composite__c,
                                     Tier_2_EE__c,Tier_2_EF__c,Tier_3_EE__c,Tier_3_EE1__c,Tier_3_EE2__c,Tier_4_EC__c,Tier_4_EE__c,Medical_Plan_Rider_Plan__c,
                                     Tier_4_EF__c,Tier_4_ES__c,Tier_5_EC__c,Tier_5_ECH__c,Tier_5_EE__c,Tier_5_EF__c,Tier_5_ES__c,Tier_Type__c
                                     FROM Rates__c WHERE Rate_Card_ID__c=:rateCardId AND Sold_Sign_Off__c =:soldSignOff.Id Order By createddate];
                        Map<String,List<Rates__c>> planRateListMap = new Map<String,List<Rates__c>>();
                        //constructing map for each medical plan
                        for(Rates__c rateObj : existingratesList){
                            if(planRateListMap.containsKey(rateObj.plan_name__c)){
                                List<Rates__c> existingRateList = planRateListMap.get(rateObj.plan_name__c);
                                existingRateList.add(rateObj);
                                planRateListMap.put(rateObj.plan_name__c, existingRateList);
                            }else{
                                List<Rates__c> newRateList = new List<Rates__c>();
                                newRateList.add(rateObj);
                                planRateListMap.put(rateObj.plan_name__c, newRateList);
                            }
                        }
                        //map for consctructing the groups
                        Map<String,List<RateGroups>> tierMap = new Map<String,List<RateGroups>>();
                        //count to dynamically display the colspan in html table in the pdf page
                        Integer countOfAllGroups = 0;
                        //adding the rate value to ratelist based on the tier selected
                        for(String planName : planRateListMap.keySet()){
                            //looping through each medical plan
                            for(Rates__c rateObj : planRateListMap.get(planName)){
                                countOfAllGroups=countOfAllGroups+1;
                                //list to constuct the groups based on the selected tiers
                                List<RateGroups> rateGrpList = new List<RateGroups>();
                                List<String> ratesList = new List<String>();
                                if(rateObj.Tier_Type__c == HighRoads_Constants.TIER_1){
                                    isTier1Selected = true;
                                    ratesList.add(rateObj.Tier_1_Composite__c);
                                }else if(rateObj.Tier_Type__c == HighRoads_Constants.TIER_2){
                                    isTier2Selected = true;
                                    ratesList.add(rateObj.Tier_2_EE__c);
                                    ratesList.add(rateObj.Tier_2_EF__c);
                                }else if(rateObj.Tier_Type__c == HighRoads_Constants.TIER_3){
                                    isTier3Selected = true;
                                    ratesList.add(rateObj.Tier_3_EE__c);
                                    ratesList.add(rateObj.Tier_3_EE1__c);
                                    ratesList.add(rateObj.Tier_3_EE2__c);
                                }else if(rateObj.Tier_Type__c == HighRoads_Constants.TIER_4){
                                    isTier4Selected = true;
                                    ratesList.add(rateObj.Tier_4_EE__c);
                                    ratesList.add(rateObj.Tier_4_ES__c);
                                    ratesList.add(rateObj.Tier_4_EC__c);
                                    ratesList.add(rateObj.Tier_4_EF__c);
                                }else if(rateObj.Tier_Type__c == HighRoads_Constants.TIER_5){
                                    isTier5Selected = true;
                                    ratesList.add(rateObj.Tier_5_EE__c);
                                    ratesList.add(rateObj.Tier_5_ES__c);
                                    ratesList.add(rateObj.Tier_5_EC__c);
                                    ratesList.add(rateObj.Tier_5_ECH__c);
                                    ratesList.add(rateObj.Tier_5_EF__c);
                                }
                                //populating group name based on the alias name
                                //if user added new groups like other1 - 10 then adding alias name to display the actual name of the group in pdf page
                                String groupName = rateObj.Group_Alias_Name__c != NULL ? rateObj.Group_Alias_Name__c : rateObj.Group_Type__c;
                                //adding the group list for each group
                                rateGrpList.add(new RateGroups(groupName,ratesList,rateObj.Tier_Type__c));
                                //constructing the tiermap using the unique key (for each rate this is unique) and group list
                                if(tierMap.containsKey(rateObj.Plan_Type_Tier_Group__c.subStringBeforeLast(HighRoads_Constants.UNDERSCORE))){
                                    List<RateGroups> groupList = tierMap.get(rateObj.Plan_Type_Tier_Group__c.subStringBeforeLast(HighRoads_Constants.UNDERSCORE));
                                    groupList.addAll(rateGrpList);
                                    tierMap.put(rateObj.Plan_Type_Tier_Group__c.subStringBeforeLast(HighRoads_Constants.UNDERSCORE), groupList);
                                }else{
                                    List<RateGroups> groupList = new List<RateGroups>();
                                    groupList.addAll(rateGrpList);
                                    tierMap.put(rateObj.Plan_Type_Tier_Group__c.subStringBeforeLast(HighRoads_Constants.UNDERSCORE), groupList);
                                }
                            }
                        }
                        //constructing the map for each group for each plan
                        //to render the rates based on the groups, calculating the size of the groups for dynamic colspan
                        Map<String,List<RateTier>> rateTierMap = new Map<String,List<RateTier>>();
                        for(String rateGrpKey : tierMap.keySet()){
                            List<RateTier> rateTierList = new List<RateTier>();
                            List<RateGroups> rateGrpList = tierMap.get(rateGrpKey);
                            rateTierList.add(new RateTier(rateGrpKey.substringAfterLast(HighRoads_Constants.UNDERSCORE),rateGrpList,rateGrpList.size()+1));
                            if(rateTierMap.containsKey(rateGrpKey.substringBeforeLast(HighRoads_Constants.UNDERSCORE))){
                                List<RateTier> rateTrList = rateTierMap.get(rateGrpKey.substringBeforeLast(HighRoads_Constants.UNDERSCORE));
                                rateTrList.addAll(rateTierList);
                                rateTierMap.put(rateGrpKey.substringBeforeLast(HighRoads_Constants.UNDERSCORE), rateTrList);
                            }else{
                                List<RateTier> rateTrList = new List<RateTier>();
                                rateTrList.addAll(rateTierList);
                                rateTierMap.put(rateGrpKey.substringBeforeLast(HighRoads_Constants.UNDERSCORE), rateTrList);
                            }
                        }
                        //construct the map for medical plan and plan types
                        //if medical plan is HE02 -2016 then the plan type is Medical
                        //and associate riders will be displayed under the Medical Plan Type
                        //the count of plan types will be calcualted and used for dynamic rowspan
                        Map<String,List<PlanTypes>> planTypeMap = new Map<String,List<PlanTypes>>();
                        for(String planTypeKey : rateTierMap.keySet()){
                            List<PlanTypes> planTpeLst = new List<PlanTypes>();
                            List<RateTier> rateTrList = rateTierMap.get(planTypeKey);
                            Integer innerGrpCount = 0;
                            for(RateTier rateTierObj : rateTrList){
                                innerGrpCount+=rateTierObj.sizeOfGroups;
                            }
                            planTpeLst.add(new PlanTypes(planTypeKey.substringAfterLast(HighRoads_Constants.UNDERSCORE),rateTrList,innerGrpCount));
                            if(planTypeMap.containsKey(planTypeKey.substringBeforeLast(HighRoads_Constants.UNDERSCORE))){
                                List<PlanTypes> planTypeList = planTypeMap.get(planTypeKey.substringBeforeLast(HighRoads_Constants.UNDERSCORE));
                                planTypeList.addAll(planTpeLst);
                                planTypeMap.put(planTypeKey.substringBeforeLast(HighRoads_Constants.UNDERSCORE), planTypeList);
                            }else{
                                List<PlanTypes> planTypeList = new List<PlanTypes>();
                                planTypeList.addAll(planTpeLst);
                                planTypeMap.put(planTypeKey.substringBeforeLast(HighRoads_Constants.UNDERSCORE), planTypeList);
                            }
                        }
                        //constructing the final wrapper list which will render in pdf page in Sold Plans with Rates section
                        for(String planKey : planTypeMap.keySet()){
                            List<PlanTypes> planTpeLst = planTypeMap.get(planKey);
                            Integer innerGroupCount = 0;
                            
                            for(PlanTypes ptObj : planTpeLst){
                                innerGroupCount+=ptObj.sizeOfTierandGroups;
                            }
                            PlanRateTierGroupandRateEntryList.add(new PlanRateTier(planKey.substringAfterLast(HighRoads_Constants.UNDERSCORE),planTypeMap.get(planKey),innerGroupCount));
                        }
                    }
        //Adding the size to construct the table dynamically
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
	   // Wrapper class for constructing plan and rate table
	   // main wrapper class to display the medical plan name and plan types,tiers,groups,rates
	   // calculating the size of the plans and tiers,groups for dynamic rowspan
       public class PlanRateTier{
           public string medicalPlanName{get;set;}
           public List<PlanTypes> planTypeList{get;set;}
           public Integer sizeOfTotalTiersGroups{get;set;}
           public PlanRateTier(String medPlanName,List<PlanTypes> plantypes,Integer sizeOfTiers){
               this.medicalPlanName = medPlanName;
               this.planTypeList = plantypes;
               this.sizeOfTotalTiersGroups = sizeOfTiers;
           }
       }
	   // Wrapper class for constructing plan and rate table
	   // calculating the size based on the tierandgroups
	   // which will be used for dynamic rowspan
       public class PlanTypes{
           public string planName{get;set;}
           public List<RateTier> rateTierList{get;set;}
           public Integer sizeOfTierandGroups{get;set;}
           public PlanTypes(String planName,List<RateTier> rateTrList,Integer tierSize){
               this.planName = planName;
               this.rateTierList = rateTrList;
               this.sizeOfTierandGroups = tierSize;
           }
       }
	   // Wrapper class for constructing plan and rate table
	   // this wrapper class is used to display the groups with dynamic rowspan for tiers
       public class RateTier{
           public string tierName{get;set;}
           public List<RateGroups> groupList{get;set;}
           public Integer sizeOfGroups{get;set;}
           public RateTier(String tierName,List<RateGroups> groupList,Integer groupSize){
               this.tierName = tierName;
               this.groupList = groupList;
               this.sizeOfGroups = groupSize;
           }
       }
	   // Wrapper class for constructing plan and rate table
	   // to set the group and rates for the existing plans
       public class RateGroups{
           public string groupName{get;set;}
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
           public RateGroups(String groupName,List<String> ratesList,String tierName){
               this.groupName =  groupName;
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
	// Wrapper class for constructing no rate plans table 
    public class planWrapper{
        public string plantype{get;set;}
        public String benefitId{get;set;}
        public planWrapper(Benefit_Plan_Association__c bpa){
            if(bpa.Raider_ID__c == NULL){
                this.plantype = HighRoads_Constants.MEDICAL;
                this.benefitId = bpa.Benefit_Plan_Metadata__r.Name;
            }else{
                this.plantype = bpa.Raider_ID__r.Product_Class__c;
                this.benefitId = bpa.Raider_ID__r.Name;
            }
        }
    }
    // Wrapper class for constructing no rate rider plan
    public class planRiderWrapper{
        public string Name{get;set;}
        public List<planWrapper> planWrapperList{get;set;}
        public Integer sizeOfPlanWrappers{get;set;}
        public planRiderWrapper(String Name,List<planWrapper> planWrapList){
            this.Name = Name;
            this.planWrapperList = planWrapList;
            this.sizeOfPlanWrappers = planWrapList.size()+1;
        }
    }
   
}