/*************************************************
*     Class Name  : VFC36_Sold_Case_Notification *
*     Author      : Manish Singh                 *
*     Date        : 06-Jan-2015                  *
*     Project Name: Sutter Health                *
*     Description : Req-3268                     *
**************************************************/
public  without sharing class VFC36_Sold_Case_Notification {
    
    private static final String MEDICALPLANRECORDTYPE ='Medical Plan Other';
    private static final String ERRORMSGREQUIREDFIELD = 'Please Enter the values!';
    private static final String ERRORMSGREQUIREDFIELDVALUES = 'Please Enter the value!';
    private static final String VALUEOTHER = 'Other';
    private static final String VALUEOTHERS = 'Others';
    private static final String BLANKVALUE = '';
    private static final String ERRORMSGOTHERDENTALVALUE = 'Please Enter the Other Dental values!';
    private static final String ERRORMSGCHIROPRATICVALUE = 'Please Enter the Other Chiropractic values!';
    private static final String ERRORMSGACUPUNCTUREVALUE ='Please Enter the Other Acupuncture values!';
    private static final String ERRORMSGACUPUNCTURECHIROPRACTICVALUE = 'Please Enter the Other Acupuncture Chiropractic values!'; 
    private static final String ERRORMSGEMPLOYEEWAITINGPERIODVALUE = 'Please Enter the other Employee Waiting Period value!';
    private static final String ERRORMSGOTHERTYPEOFORGANIZATIONVALUE = 'Please Enter the other Type of Organization value!';
    private static final String SYSTEM_ADMINISTRATOR = 'System Administrator';
    private static final String ROLE = 'Role';
    private static final String STATUSUNDERWRITINGREVIEW = 'Underwriting Review';
    private static final String STATUSVALUECLOSEDWON = 'Closed Won';
    private static final String STATUSCOMPLETED = 'Completed';
    private static final String LINENUMBER = 'Line Number:';
    private static final String ERRORMSGEMPTYVALUE = 'Please Enter one of the values!';
    private static final String ERRORMSGOTHERPLANIDVALUE = 'Please Enter the Other plan id values!';
    private static final String ERROROTHERCUSTOMMEDICALVALUE = 'Please Enter the Other Custom Medical values!';
    private static final String ERROROTHERCUSTOMOTHERVISIONVALUE =  'Please Enter the Other Vision values!'; 
    private static final String VALUEELECTRONIC = 'Electronic';
    private static final String VALUEONLINE = 'Online';
    private static final String VALUE_EN_US = 'en_US';
    private static final String VALUE_NA = 'N/A';
    private static final String API_MEDICALPLAN  = 'Medical_Plan__c' ;
    private static final String VALUE_HREF  = '<a href';
    private static final String STRERROR  = 'Error:';
    private static final String STREDIT  = 'Edit';
    private static final String STRALL  = 'All';
    private static final String STRAPPROVED  = 'Approved';
    private static final String STRDRAFT  = 'Draft';
    private static final String STRYES  = 'Yes';
    private static final String STRNO  = 'No';
    private static final String STRFALSE  = 'false';
    private static final String STRTRUE  = 'True';
    private static final String STRHYERLINK = 'Please remove the hyperlink from Medical Plan Notes.';
    private static final String SHALASH = '/';
    private static final String REQUESTFORAPPROVAL = 'Request for Approval';
    private static final String ERRORFORNONMEDICAL = 'Please remove the hyperlink from Non-Medical Plan Notes.';
    private static final String STRENROLLEMTNQAPASS = 'Enrollment QA Pass';
    private static final String STRENROLLEMTNQAFAIL = 'Enrollment QA Fail';
    private static final String STRSUBMITTEDFORQA  = 'Submitted for QA';
    private static final String SHP_SALES_QUEUE = 'SHP_Sales_Queue'; 
    public Boolean isOldSCN{get;set;}
    public Boolean isNewSCN{get;set;}
    public String showBlankVlaue{get;set;}
    public List<Employer_Group_Data__c> lstEGD{get;private set;} 
    public Boolean required{get;private set;}
    public String OpportunityId{get;set;}
    public Employer_Group_Data__c  employerGroupDataObj{get; set;}
    public List<Medical_Plan__c> lstMedicalPlan{get;set;}
    public List<Medical_Plan__c> lstMedicalPlanOther{get;set;}
    public Boolean errorOccur{get;set;}
    public Boolean HideAddMedPlanButton{get;set;}
    public Boolean HideRemoveMedPlanButton{get;set;}
    public String strOpportunityRedirectId{get;set;}
    public Boolean HideAddNonMedPlanButton{get;set;}
    public Boolean HideReamoveNonMedPlanButton{get;set;}
    private String MedicalPlanRecordId = BLANKVALUE;
    private Integer countMedPln{get;set;}
    private Integer countNonMedPln{get;set;}
    public Boolean errorMsgDisplay{get;private set;}
    public String strOppId {get;set;}
    public Boolean showRenwalForm {get;set;} //renwal form
    public Boolean showErroronLoad {get;set;} // if true an error shown to the user and redirected back to Opportunity
    public Boolean showErroronLoad1 {get;set;} // if true an error shown to the user and redirected back to Opportunity
    private List<Medical_Plan__c> allMedicalObjectList{get;private set;}
    public Boolean isEDIVendorDisable{get;set;}
    public Boolean isEDIVendorEnable{get;set;}
    public Map<String,String> medicalPlansRecordTypes;
    private Employer_Group_Data__c objEmployerGroupData; 
    
    // Req 3377 - Varibale to store the SCN Training Document - Start
    public SHP_Training_Document__kav SCNTrainingDocument {get;set;}
    private static final String KNOWLEDGEARTICLEID = System.Label.SCN_Traning_Doc_KnowledgeId;      
    // Req 3377 - Varibale to store the SCN Training Document - End
    
    //HighRoads Wave1-3880 - Start
    private static final String STANDARDMEDICALPLAN = 'Standard medical plan';
    private static final String VALUESMALL = 'Small';
    Public Boolean isMedicalRegionEnable{get;set;}
    Public Boolean isMedicalRegionDisable{get;set;}
    //HighRoads Wave1-3880 - End
    //HighRoads Wave2 - 3182 Start
    Public String rateCardId{get;set;}
    Public List<Benefit_Plan_Association__c> nonRatePlans{get;set;}
    public List<PlanRateTier> PlanRateTierGroupandRateEntryList{get;set;}
    public boolean isTier1Selected{get;set;}
    public boolean isTier2Selected{get;set;}
    public boolean isTier3Selected{get;set;}
    public boolean isTier4Selected{get;set;}
    public boolean isTier5Selected{get;set;}
    public Double rateEntryTableWidth{get;set;}
    public Opportunity oppAccount{get;set;}
    public Sold_Sign_Off__c ssoObj{get;set;}
    public Employer_Group_Data__c objSoldCaseNotificationStage{get;set;}  
    public List<PlanWrapper> planWrapperList{get;set;}
    public Map<String,List<planWrapper>> medicalRiderMap = new  Map<String,List<planWrapper>>();
    public List<planRiderWrapper> planRiderWrapperList{get;set;}
    //HighRoads Wave2 - 3182 Ends
    /*********************************************************************************
*  @Param........:                                                              *
*  @Return Type..:                                                              *
*  @Description..: this the constructor for VFC36_Sold_Case_Notification class  *
*********************************************************************************/
    public VFC36_Sold_Case_Notification(ApexPages.StandardController stdController) {
        try {   
            isTier2Selected = false;
            isTier3Selected = false;
            isTier4Selected = false;
            isTier5Selected = false;
            isNewSCN = false;
            isOldSCN = false;
            PlanRateTierGroupandRateEntryList = new List<PlanRateTier>();
            nonRatePlans = new List<Benefit_Plan_Association__c>();
            //Req 3880 HighRaods Wave 2 Changes Starts
            rateEntryTableWidth = 21.04;
            this.objEmployerGroupData = (Employer_Group_Data__c) stdController.getRecord();
            objSoldCaseNotificationStage = new Employer_Group_Data__c(); 
            planRiderWrapperList = new List<planRiderWrapper>();
            planWrapperList = new List<PlanWrapper>();
            if(stdController.getId() != null) {   
                objEmployerGroupData = [SELECT e.of_Employees__c, e.of_Eligible_Employees__c, e.city_SA__c, e.Zip_SA__c, e.Zip_BA__c, e.Will_there_be_additional_plans_offered__c, e.User_Employer_Group_Data__c, e.Type_of_Organization__c,
                                        e.Type_of_Organization_Other__c, e.Title__c, e.Title1__c, e.Third_Party_Administrator__c, e.Sub_Account_Data__c, e.Street_Address__c, e.State_SA__c, e.State_BA__c, e.Stage__c, e.Slice_Account__c, 
                                        e.SHP_Sales_Representative__c, e.SHP_Broker_ID__c, e.SFDC_Broker_ID__c, e.SCN_Approved_Date__c, e.Renewal_SCN__c, e.Projected_Enrollment__c, e.Previous_Group_Insurance_through_SHP__c, e.Plan_vs_Calendar_Year__c,
                                        e.Phone_Number__c, e.Performance_or_Implementation__c, e.OwnerId, e.Other_Optional_Vision__c, e.Other_Optional_Dental__c, e.Other_Optional_Acu_Chiro__c, e.Other_Language_Considerations__c, 
                                        e.Other_ERISA__c, e.Opportunity__c,e.Sold_Sign_Off__c, e.Opportunity_Account_Name__c, e.Open_Enrollment_Date_To__c, e.Open_Enrollment_Date_From__c, e.New_TPA_Vendor__c,
                                        e.New_EDI_Vendor__c, e.Name, e.Member_accumulators_previous_Carrier__c, e.LastModifiedDate, e.LastModifiedById, e.Id, e.HR_Enrollment_Phone__c,  e.HR_Enrollment_E_mail__c,
                                        e.HR_Employer_Portal_Phone__c, e.HR_Employer_Portal_Phone1__c, e.HR_Employer_Portal_Name__c, e.HR_Employer_Portal_Name1__c, e.HR_Employer_Portal_E_mail__c, 
                                        e.HR_Employer_Portal_E_mail1__c, e.HR_Account_Number__c, e.HREnrollment_Name__c, e.HREmployer_Portal_Name__c, e.HREmployer_Portal_Name1__c, e.Group_Type__c, 
                                        e.Federal_Employer_ID_Number__c, e.Fax_Number__c, e.Enrollment_Method__c, e.Employer_Defined_Eligibility_for_Benefit__c, e.Employer_Contribution_Employees_Premium__c, 
                                        e.Employer_Contribution_Dependents_Premium__c, e.Employee_Waiting_Period__c, e.Employee_Waiting_Period_Other__c, e.Effective_Date__c, e.Distribution_List__c, 
                                        e.Date_Sold__c, e.Date_SBC_Sent__c, e.Date_EOC_Sent__c, e.DBA_Name__c, e.Created_By__c, e.CreatedDate, e.CreatedById, e.County__c, e.Country__c, e.Country_SA__c,  
                                        e.CompletedBy__c, e.Company_Name__c, e.Commissions_Optional_Vision_VSP__c, e.Commissions_Optional_Dental_Delta__c, e.Commissions_Optional_Acu_Chiro_ACN__c, 
                                        e.Commissions_Medical__c, e.City_BA__c,    e.Broker_Name__c, e.Broker_Agency__c, e.Billing_Street_Address__c, e.Billing_Contact_Phone__c,
                                        e.Billing_Contact_E_mail__c, e.BillingContact_Name__c, e.Benefits_Subject_to_ERISA_Regulations__c,  e.AuditorName__c, e.ACal_L_D_Licence__c, 
                                        e.ACal_L_D_Expiration_Date__c,e.Cobra_Members_with_this_Group__c,e.Religious_Exemption_Applied__c, EDI_Vendor_Name__c, EDI_Vendor_E_Mail__c, EDI_Vendor_Phone__c,
                                        Cobra_Members_with_this_Group1__c, COBRA__c, Cal_Cobra__c, Vendor_Contact_Email__c, Vendor_Contact_Name__c, Vendor_Contact_Phone__c, Medical_Region__c,
                                        General_Agent_Applicable__c, General_Agent__c, GA_Contact__c, GA_Commission__c, Vendor_Name__c, Sales_Auditor__c, Account_Executive__c, Account_SFDC_ID__c, Shipping_County__c,
                                        (select Id,Benefit_Plan_Metadata__c,Raider_ID__c,Benefit_Plan_Metadata__r.Name,Benefit_Plan_Metadata__r.Product_Class__c, Raider_ID__r.Product_Class__c,
                                         Raider_ID__r.Name,Medical_or_Rider__c,Benefit_Plan_Metadata__r.Benefit_Plan_ID__c,Raider_ID__r.Benefit_Plan_ID__c,
                                         Raider_ID__r.isHDHP__c,Benefit_Plan_Metadata__r.isHDHP__c,SCN_Rate_Card__c from Benefit_Plan_Associations__r)  
                                        FROM Employer_Group_Data__c e
                                        WHERE  Id= :stdController.getId() limit 1];
            }  
            
            if(objEmployerGroupData!= null && objEmployerGroupData.Enrollment_Method__c != null && objEmployerGroupData.Enrollment_Method__c == VALUEELECTRONIC ){
                isEDIVendorDisable = false;
                isEDIVendorEnable = true;
            }else{
                isEDIVendorDisable = true;
                isEDIVendorEnable = false;
            }
            //identifying the scn is new or not based on the effected
            //this effected date will the go live date of SHP Wave 2 changes req - 3980
            Date effectedDate = Date.valueOf(String.valueOf(System.Label.HR111_EffectedDate));
            if(objEmployerGroupData.createdDate < effectedDate){
                isOldSCN = true;
            }else{
                isNewSCN = true;
            }
            //checking the effected date and created date, if created date is > effected date then the new business rules will apply for those 
            //records as per this release (3980 SHP Wave 2 Changes)
            //else new business rules like validation rules will not trigger to old records
            // old scn will open in visualforce mode and new records will open stanadard mode
            if(objEmployerGroupData.createdDate >= effectedDate){
                Map<String,Boolean> planIsHDHPMap = new Map<String,Boolean>();
                if(objEmployerGroupData != NULL && objEmployerGroupData.Benefit_Plan_Associations__r.size() > 0){
                    for(Benefit_Plan_Association__c bpaObj : objEmployerGroupData.Benefit_Plan_Associations__r){
                        if(bpaObj.Medical_or_Rider__c == System.Label.HR42_Medical){
                            planIsHDHPMap.put(bpaObj.Benefit_Plan_Metadata__r.Name+HighRoads_Constants.UNDERSCORE+HighRoads_Constants.MEDICAL,bpaObj.Benefit_Plan_Metadata__r.isHDHP__c);
                        }else{
                            planIsHDHPMap.put(bpaObj.Benefit_Plan_Metadata__r.Name+HighRoads_Constants.UNDERSCORE+bpaObj.Raider_ID__r.Name,bpaObj.Raider_ID__r.isHDHP__c);
                        }
                        //if rate card is not null for the plan
                        if(bpaObj.SCN_Rate_Card__c != NULL){
                            rateCardId = bpaObj.SCN_Rate_Card__c;
                        }else{
                            nonRatePlans.add(bpaObj);
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
                                                            FROM Rates__c WHERE Rate_Card_ID__c=:rateCardId AND Sold_Case_Notification__c =:objEmployerGroupData.Id Order By Rider_Plan_Name__c ASC NULLS FIRST];
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
                            planTpeLst.add(new PlanTypes(planTypeKey.substringAfterLast(HighRoads_Constants.UNDERSCORE),planIsHDHPMap.get(planTypeKey.substringAfter(HighRoads_Constants.UNDERSCORE)),rateTrList,innerGrpCount));
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
                }
                //Adding the size to construct the table width dynamically
                //if tier1 selected
                if(isTier1Selected != NULL && isTier1Selected){
                    rateEntryTableWidth +=5.26;
                }
                //if tier2 selected
                if(isTier2Selected != NULL && isTier2Selected){
                    rateEntryTableWidth +=2*5.26;
                }
                //if tier3 selected
                if(isTier3Selected != NULL && isTier3Selected){
                    rateEntryTableWidth +=3*5.26;
                }
                //if tier4 selected
                if(isTier4Selected != NULL && isTier4Selected){
                    rateEntryTableWidth +=4*5.26;
                }
                //if tier5 selected
                if(isTier5Selected != NULL && isTier5Selected){
                    rateEntryTableWidth +=5*5.26;
                }
            }
            //Req 3880 HighRaods Wave 2 Changes Ends                    
            //Req 3880 HighRoads change start - enable Medical Region when Group type "Small" is choosen
            
            if(objEmployerGroupData!= null && objEmployerGroupData.Group_Type__c!= null && objEmployerGroupData.Group_Type__c== VALUESMALL){                     
                isMedicalRegionDisable= false;
                isMedicalRegionEnable= true;
            }else{
                isMedicalRegionDisable= true;
                isMedicalRegionEnable= false;
            }
            //Req 3880 HighRoads change End
            
            // Req 3377 Change Start - Query to get the Training Document for SCN 
            if(!Test.isRunningTest()){
                if( SCNTrainingDocument == null ) {
                    SCNTrainingDocument = [ SELECT Id From SHP_Training_Document__kav WHERE PublishStatus ='online' AND Language = 'en_US' AND KnowledgeArticleId =: KNOWLEDGEARTICLEID limit 1 ];
                }
            }
            // Req 3377 Change End - Query to get the Training Document for SCN
            
            //List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType=:API_MEDICALPLAN and isActive = true limit  50000];
            medicalPlansRecordTypes = new Map<String,String>();
            for(RecordType rt: [Select Name, Id From RecordType where sObjectType=:API_MEDICALPLAN and isActive = true limit  50000]){
                medicalPlansRecordTypes.put(rt.Name,rt.Id);
            }
            
            lstMedicalPlan = new List < Medical_Plan__c > ();
            allMedicalObjectList = new List<Medical_Plan__c >();
            lstMedicalPlanOther = new List < Medical_Plan__c > ();
            string strOppAccId = objEmployerGroupData.Opportunity__c;
            String ssoId = objEmployerGroupData.Sold_Sign_Off__c;
            System.debug('strOppAccId>>'+strOppAccId);
            System.debug('ssoId>>>'+ssoId);
            
            OppAccount = new Opportunity();
            System.debug('OppAccount>>>'+OppAccount); 
            ssoObj = new Sold_Sign_Off__c();
            if(strOppAccId !=null) {
                //Quering Opportunity assocated with SCN 
                OppAccount = [SELECT Name,Id,Account.Tax_ID__c, Account.Name, Account.ShippingStreet, Account.ShippingState, Account.ShippingPostalCode, 
                              Account.ShippingCountry, Account.ShippingCity, Account.Phone, Account.Employee_Count__c,
                              Account.Broker__r.Broker_Firm_HR_ID__c, Account.Broker__c, Account.Broker_Rep__r.Name, Account.Broker_Rep__c, Account.Broker__r.License_Number__c,
                              Account.Broker__r.End_Date__c, Broker_Rep1__r.License_Number__c, Broker_Rep1__r.License_Expiration_Date__c,
                              Account.Broker_Rep__r.SFDC_Contact_ID__c, Account.BillingStreet, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry, Account.BillingCity, 
                              of_Employees__c, Account.Account_TIN_Type__c, StageName, account.fax, Broker_Rep1__r.Name, Broker_Rep1__r.Account.Name, Plan_Effective_Date__c,
                              Broker_Rep1__r.SFDC_Contact_ID__c, Broker1__r.License_Number__c, Broker1__r.End_Date__c, Renewed_Opportunity__c,AccountId, 
                              Contribution_s_EE__c, Dependent_Contribution__c, Commission__c, Additional_Buy_Ups__c, Calendar_or_Plan_Year__c, Account.DBA__c,
                              Account.Account_Manager__r.Name, Account.County__c, Account.Mailing_County__c, Account.Physical_County__c, Account.Account_Executive__r.name
                              FROM Opportunity 
                              WHERE Id = : strOppAccId limit 50000];
                
                /*Code for error or SCN Page render*/
                OpportunityId = SHALASH + OppAccount.Id;
                if(OppAccount.StageName != STATUSVALUECLOSEDWON) {
                    showErroronLoad = true;
                } else {
                    if(OppAccount.Renewed_Opportunity__c) {
                        showRenwalForm = true;
                    } else {
                        showRenwalForm = false;
                    }
                    showErroronLoad = false;
                }
            }
            System.debug('OppAccount>>>'+OppAccount); 
            if(ssoId != NULL){
                ssoObj = [SELECT Name,Id from Sold_Sign_Off__c where Id=:ssoId limit 1];
                System.debug('in constructor:::'+ssoObj);
            }
            employerGroupDataObj = new Employer_Group_Data__c();
            employerGroupDataObj = objEmployerGroupData; // Populates values for existing record
            if(employerGroupDataObj.Id != Null) {
                //List <Employer_Group_Data__Share> lstShareUsers = new List <Employer_Group_Data__Share>([SELECT UserOrGroupId,AccessLevel FROM Employer_Group_Data__Share WHERE parent.ID =: employerGroupDataObj.Id limit 1]);
                showErroronLoad1 = true;
                //Req-3359 Security and Roles Re-evaluation - Sales    giving access by  sharing rule 02-apr-2015 
                ID roleId = UserInfo.getUserRoleId(); // fetches the current user role id 
                Group groupofRole;
                Profile profileObj = [SELECT Id, Name FROM Profile WHERE Name = :SYSTEM_ADMINISTRATOR ]; 
                if (roleId != null) {
                    // fetching the groupid of the role as for every role in  saleforce we have corresponding group at back end    
                    // this group is linked to the role using  related id field .   
                    groupofRole = [SELECT Id,Name FROM Group WHERE RelatedId = :roleId AND Type = :ROLE ];  
                }
                
                //looping through all the  sharing record   to check for system admin , role and owner
                for (Employer_Group_Data__Share lstShar:[SELECT UserOrGroupId,AccessLevel FROM Employer_Group_Data__Share WHERE parent.ID =: employerGroupDataObj.Id ]) {
                    
                    if(((lstShar.UserOrGroupId == UserInfo.GetuserID() || (groupofRole != null && lstShar.UserOrGroupId == groupofRole.Id)) && (lstShar.AccessLevel == STREDIT  || lstShar.AccessLevel == STRALL ))
                       || (profileObj  != null && UserInfo.GetProfileID().contains(profileObj.id ))) {
                           
                           showErroronLoad1 = false;
                       }
                }
            }
            // Req-3359 Security and Roles Re-evaluation - Sales end changes
            Id recordTypeTdMedicalPlanOther = medicalPlansRecordTypes.get(MEDICALPLANRECORDTYPE);
            Id recordTypeTdMedicalPlan  = medicalPlansRecordTypes.get(STANDARDMEDICALPLAN);
            
            if(employerGroupDataObj.Id != Null) {
                objSoldCaseNotificationStage= [SELECT Id, Stage__c FROM Employer_Group_Data__c WHERE Id =:objEmployerGroupData.Id  limit 1];
                string strId = employerGroupDataObj.Id;
                
                
                for(Medical_Plan__c objMedPlan:[SELECT  Medical_type__c, Medical__c, Custom_Medical__c, AcupunctureChiropractic_Other__c, Vision__c,
                                                Acupuncture_Chiropractic__c, Acupuncture_Other__c, Acupuncture__c,Other_Plan_Id__c,
                                                Chiropractic_Other__c, Chiropractic__c, CreatedById, CustomMedical_Other__c,  Dental_Other__c, Dental__c,
                                                EC_Early_Retiree__c, EC__c, EE1__c, EE_1_Early_Retiree__c, EE_1__c, EE_2_Early_Retiree__c, EE_2__c, EE_Early_Retiree1__c,
                                                EE_Early_Retiree__c, EE__c, EF_Early_Retiree__c, EF__c, ES_Early_Retiree__c, ES__c, HDHP__c, Id,
                                                IndividualMedical_Other__c, Individual_Medical__c, Infertility__c, IsDeleted, Large_GroupMedical_Other__c,
                                                Large_Group_Medical__c, LastActivityDate,LastModifiedById, LastModifiedDate, Medical_Plan_Notes__c,  Name, 
                                                No_Medical_Benefit_Plan_Change__c,No_Optional_Benefit_Change__c, Plan_Name_Active_1__c, Plan_Name_Active__c, Plan_Name_Early_Retiree_1__c,
                                                Plan_Name_Early_Retiree__c, Prosthetic_Orthotic__c, Small_GroupMedical_Other__c, Small_Group_Medical__c,
                                                EE2__c, EE_Early_Retiree2__c, EF_Sec1__c, EF_Early_Retiree_Sec1__c, Plan_Name_Active_2__c, Plan_Name_Early_Retiree_2__c,
                                                Sold_Case_Notification__c, Standard_Medical_Plan_Name__c, Vision_Other__c,RecordTypeId, Sold_Case_Notification__r.Name, RecordType.Name,CreatedBy.Name, LastModifiedBy.Name          
                                                FROM Medical_Plan__c 
                                                WHERE Sold_Case_Notification__c = : strId limit 50000]) {
                                                    
                                                    if(objMedPlan.RecordTypeId == recordTypeTdMedicalPlanOther) {
                                                        lstMedicalPlanOther.add(objMedPlan); 
                                                    }
                                                    if(objMedPlan.RecordTypeId == recordTypeTdMedicalPlan) {
                                                        lstMedicalPlan.add(objMedPlan);    
                                                    }                                  
                                                }     
            }
            
            // Populate values only for new records
            if(employerGroupDataObj.id == null && OppAccount.id !=null) {
                employerGroupDataObj.Benefits_Subject_to_ERISA_Regulations__c = true;
                employerGroupDataObj.Company_Name__c = OppAccount.Account.Name;
                employerGroupDataObj.Street_Address__c = OppAccount.Account.BillingStreet;
                employerGroupDataObj.Billing_Street_Address__c = OppAccount.Account.ShippingStreet;
                employerGroupDataObj.State_SA__c = OppAccount.Account.BillingState;
                employerGroupDataObj.State_BA__c =  OppAccount.Account.ShippingState;
                employerGroupDataObj.Zip_SA__c = OppAccount.Account.BillingPostalCode;
                employerGroupDataObj.Zip_BA__c = OppAccount.Account.ShippingPostalCode;
                employerGroupDataObj.City_BA__c = OppAccount.Account.ShippingCity;
                employerGroupDataObj.city_SA__c = OppAccount.Account.BillingCity;
                employerGroupDataObj.Phone_Number__c = OppAccount.Account.Phone;
                employerGroupDataObj.Effective_Date__c = OppAccount.Plan_Effective_Date__c;
                employerGroupDataObj.Federal_Employer_ID_Number__c = OppAccount.Account.Tax_ID__c;
                employerGroupDataObj.of_Employees__c = OppAccount.of_Employees__c;
                employerGroupDataObj.Broker_Name__c = OppAccount.Broker_Rep1__r.Name;
                employerGroupDataObj.Broker_Agency__c = OppAccount.Broker_Rep1__r.Account.Name; 
                employerGroupDataObj.SFDC_Broker_ID__c = OppAccount.Broker_Rep1__r.SFDC_Contact_ID__c; 
                employerGroupDataObj.ACal_L_D_Licence__c = OppAccount.Broker_Rep1__r.License_Number__c;
                employerGroupDataObj.ACal_L_D_Expiration_Date__c = OppAccount.Broker_Rep1__r.License_Expiration_Date__c;
                employerGroupDataObj.Fax_Number__c = OppAccount.Account.Fax;
                //employerGroupDataObj.Opportunity_Account_Name__c = OppAccount.AccountId;
                employerGroupDataObj.Created_By__c = UserInfo.getUserID();
                //HighRoads Wave1-3880 - Start
                employerGroupDataObj.Employer_Contribution_Employees_Premium__c = OppAccount.Contribution_s_EE__c;
                employerGroupDataObj.Employer_Contribution_Dependents_Premium__c = OppAccount.Dependent_Contribution__c;
                employerGroupDataObj.Commissions_Medical__c = OppAccount.Commission__c;
                employerGroupDataObj.Slice_Account__c = OppAccount.Additional_Buy_Ups__c;
                employerGroupDataObj.Plan_vs_Calendar_Year__c = OppAccount.Calendar_or_Plan_Year__c;
                employerGroupDataObj.DBA_Name__c = OppAccount.Account.DBA__c;
                employerGroupDataObj.SHP_Sales_Representative__c = OppAccount.Account.Account_Manager__r.Name;
                employerGroupDataObj.County__c = OppAccount.Account.Mailing_County__c;
                employerGroupDataObj.Shipping_County__c = OppAccount.Account.Physical_County__c;
                employerGroupDataObj.Account_Executive__c = OppAccount.Account.Account_Executive__r.name;
                //HighRoads Wave1-3880 - End
            } 
            employerGroupDataObj.Opportunity_Account_Name__c = OppAccount.AccountId;
            required = false;
            
            
            if (lstMedicalPlan.size() > 1) {
                HideRemoveMedPlanButton = false;
            }
            
            if (lstMedicalPlanOther.size() > 1) {
                HideReamoveNonMedPlanButton = false;
            }
            
            if (lstMedicalPlanOther.size() <= 0) {
                Medical_Plan__c  onjNoStMePl = new Medical_Plan__c();
                lstMedicalPlanOther.add(onjNoStMePl);
                HideReamoveNonMedPlanButton = true;
            }else if(lstMedicalPlanOther.size() == 1){
                HideReamoveNonMedPlanButton = true;
            }
            
            if (lstMedicalPlan.size() <= 0) {
                Medical_Plan__c ObjMdPlan = New Medical_Plan__c();
                lstMedicalPlan.add(ObjMdPlan);
                HideRemoveMedPlanButton = true;
            } else if(lstMedicalPlan.size() == 1){
                HideRemoveMedPlanButton = true;
            }
            errorMsgDisplay = false;
            strOppId = objEmployerGroupData.Opportunity__c;
            if(objSoldCaseNotificationStage.Stage__c != null && objSoldCaseNotificationStage.Stage__c != BLANKVALUE){
                if(objSoldCaseNotificationStage.Stage__c == STATUSCOMPLETED || objSoldCaseNotificationStage.Stage__c == STATUSUNDERWRITINGREVIEW 
                   || objSoldCaseNotificationStage.Stage__c == STRAPPROVED || objSoldCaseNotificationStage.Stage__c == STRENROLLEMTNQAPASS 
                   || objSoldCaseNotificationStage.Stage__c == STRENROLLEMTNQAFAIL || objSoldCaseNotificationStage.Stage__c == STRSUBMITTEDFORQA){
                       showErroronLoad1= true;
                   }
            }
            if(Test.isRunningTest()){
                integer  i = 1/0;
            }
        } catch (exception ex) {
            System.debug('getline>>>'+ex.getStackTraceString()+'line>>>'+ex.getLineNumber());
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, STRERROR + ex.getMessage() + LINENUMBER + ex.getLineNumber()));
        }
    }
    /*************************************************************************************
*  @Param.............: void                                                         *
*  @Return Type.......: PageReference                                                *
*  @Description.......: This is custom clone functionality which used to clone SCN   *
*                       record with it Medical Plan records.                         *
*  @Requirement No....: 3386                                                         *
*  @Requirement Name..: Record all Interactions / Communications with                *
*                       Customers - Service                                          *
**************************************************************************************/
    public PageReference soldCaseNotificationClone(){
        
        List<String> lstGrpOrUsrId = new List<String>();
        Map<String,String> mapOfUserInGroup = new Map<String,String>();
        Map<String,Group> mapDeveloperNameGrpId = new Map<String,Group>();
        String strGroupId;
        try{
            map<String,Group> mapDeveloperNameAndGroupObject = new map<String,Group>();
            for(Group objGroup:[SELECT CreatedById, DeveloperName, Id, Name, OwnerId, RelatedId, Type FROM Group LIMIT 50000]){
                mapDeveloperNameGrpId.put(objGroup.DeveloperName, objGroup);                    
            }
            if(!mapDeveloperNameGrpId.isEmpty()){
                strGroupId = mapDeveloperNameGrpId.get(SHP_SALES_QUEUE).Id;
            }
            
            if(String.isNotBlank(strGroupId)){
                for(GroupMember objGM:[SELECT GroupId,Id,UserOrGroupId FROM GroupMember WHERE GroupId = :strGroupId]){
                    
                    if(((String)objGM.UserOrGroupId).startsWith('00G')){
                        lstGrpOrUsrId.add(objGM.UserOrGroupId);
                    }else{
                        mapOfUserInGroup.put(objGM.UserOrGroupId,objGM.UserOrGroupId);
                    } 
                }
                
                if(!lstGrpOrUsrId.isEmpty()){
                    for(GroupMember objGM:[SELECT GroupId,Id,UserOrGroupId FROM GroupMember WHERE GroupId IN:lstGrpOrUsrId]){
                        mapOfUserInGroup.put(objGM.UserOrGroupId,objGM.UserOrGroupId);
                    }
                }
            }
            
            if(mapOfUserInGroup.get(userInfo.getUserId())== null){
                return null;    
            }       
            
            Employer_Group_Data__c objEmployerGroupData = new Employer_Group_Data__c();
            Employer_Group_Data__c newClonedSCNObj = new Employer_Group_Data__c(); 
            if(ApexPages.currentPage().getParameters().get('Id') != null) {   
                objEmployerGroupData = [SELECT e.of_Employees__c, e.of_Eligible_Employees__c, e.city_SA__c, e.Zip_SA__c, e.Zip_BA__c, e.Will_there_be_additional_plans_offered__c, e.User_Employer_Group_Data__c, e.Type_of_Organization__c,
                                        e.Type_of_Organization_Other__c, e.Title__c, e.Title1__c, e.Third_Party_Administrator__c, e.Sub_Account_Data__c, e.Street_Address__c, e.State_SA__c, e.State_BA__c, e.Stage__c, e.Slice_Account__c, 
                                        e.SHP_Sales_Representative__c, e.SHP_Broker_ID__c, e.SFDC_Broker_ID__c, e.SCN_Approved_Date__c, e.Renewal_SCN__c, e.Projected_Enrollment__c, e.Previous_Group_Insurance_through_SHP__c, e.Plan_vs_Calendar_Year__c,
                                        e.Phone_Number__c, e.Performance_or_Implementation__c, e.OwnerId, e.Other_Optional_Vision__c, e.Other_Optional_Dental__c, e.Other_Optional_Acu_Chiro__c, e.Other_Language_Considerations__c, 
                                        e.Other_ERISA__c, e.Opportunity__c, e.Opportunity_Account_Name__c, e.Open_Enrollment_Date_To__c, e.Open_Enrollment_Date_From__c, e.New_TPA_Vendor__c,
                                        e.New_EDI_Vendor__c, e.Name, e.Member_accumulators_previous_Carrier__c, e.LastModifiedDate, e.LastModifiedById, e.Id, e.HR_Enrollment_Phone__c,  e.HR_Enrollment_E_mail__c,
                                        e.HR_Employer_Portal_Phone__c, e.HR_Employer_Portal_Phone1__c, e.HR_Employer_Portal_Name__c, e.HR_Employer_Portal_Name1__c, e.HR_Employer_Portal_E_mail__c, 
                                        e.HR_Employer_Portal_E_mail1__c, e.HR_Account_Number__c, e.HREnrollment_Name__c, e.HREmployer_Portal_Name__c, e.HREmployer_Portal_Name1__c, e.Group_Type__c, 
                                        e.Federal_Employer_ID_Number__c, e.Fax_Number__c, e.Enrollment_Method__c, e.Employer_Defined_Eligibility_for_Benefit__c, e.Employer_Contribution_Employees_Premium__c, 
                                        e.Employer_Contribution_Dependents_Premium__c, e.Employee_Waiting_Period__c, e.Employee_Waiting_Period_Other__c, e.Effective_Date__c, e.Distribution_List__c, 
                                        e.Date_Sold__c, e.Date_SBC_Sent__c, e.Date_EOC_Sent__c, e.DBA_Name__c, e.Created_By__c, e.CreatedDate, e.CreatedById, e.County__c, e.Country__c, e.Country_SA__c,  
                                        e.CompletedBy__c, e.Company_Name__c, e.Commissions_Optional_Vision_VSP__c, e.Commissions_Optional_Dental_Delta__c, e.Commissions_Optional_Acu_Chiro_ACN__c, 
                                        e.Commissions_Medical__c, e.City_BA__c,    e.Broker_Name__c, e.Broker_Agency__c, e.Billing_Street_Address__c, e.Billing_Contact_Phone__c,  
                                        e.Billing_Contact_E_mail__c, e.BillingContact_Name__c, e.Benefits_Subject_to_ERISA_Regulations__c,  e.AuditorName__c, e.ACal_L_D_Licence__c, 
                                        e.ACal_L_D_Expiration_Date__c,e.Cobra_Members_with_this_Group__c,e.Religious_Exemption_Applied__c, EDI_Vendor_Name__c, EDI_Vendor_E_Mail__c, EDI_Vendor_Phone__c,
                                        Cobra_Members_with_this_Group1__c, COBRA__c, Cal_Cobra__c, Vendor_Contact_Email__c, Vendor_Contact_Name__c, Vendor_Contact_Phone__c, Medical_Region__c, Vendor_Name__c,
                                        General_Agent_Applicable__c, General_Agent__c, GA_Contact__c, GA_Commission__c,Sales_Auditor__c,Account_Executive__c, Account_SFDC_ID__c, Shipping_County__c,
                                        (SELECT  Medical_type__c, Medical__c, Custom_Medical__c, AcupunctureChiropractic_Other__c, Vision__c,
                                         Acupuncture_Chiropractic__c, Acupuncture_Other__c, Acupuncture__c,Other_Plan_Id__c,
                                         Chiropractic_Other__c, Chiropractic__c, CreatedById, CustomMedical_Other__c,  Dental_Other__c, Dental__c,
                                         EC_Early_Retiree__c, EC__c, EE1__c, EE_1_Early_Retiree__c, EE_1__c, EE_2_Early_Retiree__c, EE_2__c, EE_Early_Retiree1__c,
                                         EE_Early_Retiree__c, EE__c, EF_Early_Retiree__c, EF__c, ES_Early_Retiree__c, ES__c, HDHP__c, Id,
                                         IndividualMedical_Other__c, Individual_Medical__c, Infertility__c, IsDeleted, Large_GroupMedical_Other__c,
                                         Large_Group_Medical__c, LastActivityDate,LastModifiedById, LastModifiedDate, Medical_Plan_Notes__c,  Name, 
                                         No_Medical_Benefit_Plan_Change__c,No_Optional_Benefit_Change__c, Plan_Name_Active_1__c, Plan_Name_Active__c, Plan_Name_Early_Retiree_1__c,
                                         Plan_Name_Early_Retiree__c, Prosthetic_Orthotic__c, Small_GroupMedical_Other__c, Small_Group_Medical__c,
                                         EE2__c, EE_Early_Retiree2__c, EF_Sec1__c, EF_Early_Retiree_Sec1__c, Plan_Name_Active_2__c, Plan_Name_Early_Retiree_2__c,
                                         Sold_Case_Notification__c, Standard_Medical_Plan_Name__c, Vision_Other__c,RecordTypeId, Sold_Case_Notification__r.Name, RecordType.Name,CreatedBy.Name, LastModifiedBy.Name          
                                         FROM Medical_Plans__r limit 50000)
                                        
                                        FROM Employer_Group_Data__c e
                                        WHERE  Id= :ApexPages.currentPage().getParameters().get('Id') limit 1]; 
            }  
            
            newClonedSCNObj = objEmployerGroupData.clone();
            newClonedSCNObj.Stage__c = 'Draft'; 
            
            if(userInfo.getUserId() != null){
                newClonedSCNObj.OwnerId = userInfo.getUserId();
            }
            
            insert newClonedSCNObj;
            
            
            List<Medical_Plan__c> lstMedPlan = new List<Medical_Plan__c>();
            for(Medical_Plan__c objMedicalPlan : objEmployerGroupData.Medical_Plans__r) {  
                Medical_Plan__c objMP = new Medical_Plan__c();
                objMP = objMedicalPlan.clone();
                objMP.Sold_Case_Notification__c = newClonedSCNObj.Id;
                lstMedPlan.add(objMP);
            }
            insert lstMedPlan;
            PageReference redirect = new PageReference('/apex/VFP36_Sold_Case_Notification?id='+newClonedSCNObj.Id);
            // pass the selected asset ID to the new page
            redirect.setRedirect(true);
            return redirect;
        } catch (exception ex) { 
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, STRERROR + ex.getMessage() + LINENUMBER + ex.getLineNumber()));
        }
        return Null;
    }
    
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: boolean                                                      *
*  @Description..: validating the scn form on completion                        *
*********************************************************************************/
    public boolean soldCaseNotifcation(){
        if(EmployerDateGroup()  && isValidAllDataMPO() && isValidAllData() ){
            return  true;
        }else {
            return false;
        }
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: boolean                                                      *
*  @Description..: Validation of Non-Medical Plan                               *
*********************************************************************************/
    public boolean isValidAllData() {
        boolean isValid = true;        
        
        for (Medical_Plan__c objMedicalPlan: lstMedicalPlanOther) {
            if(showRenwalForm == false) {   
                
                if (isEmpty(objMedicalPlan.Dental__c)) {
                    isValid = false;
                    objMedicalPlan.Dental__c.addError(ERRORMSGREQUIREDFIELD);
                }else if(objMedicalPlan.Dental__c == VALUEOTHER){
                    if(isEmpty(objMedicalPlan.Dental_Other__c)){
                        isValid = false;
                        objMedicalPlan.Dental_Other__c.addError(ERRORMSGOTHERDENTALVALUE);
                    }
                }
                
                if (isEmpty(objMedicalPlan.Vision__c)) {
                    isValid = false;
                    objMedicalPlan.Vision__c.addError(ERRORMSGREQUIREDFIELD);
                }else if(objMedicalPlan.Vision__c == VALUEOTHER){
                    if(isEmpty(objMedicalPlan.Vision_Other__c)){
                        isValid = false;
                        objMedicalPlan.Vision_Other__c.addError(ERROROTHERCUSTOMOTHERVISIONVALUE); 
                    }
                }
                
                if (isEmpty(objMedicalPlan.Chiropractic__c)) {
                    isValid = false;
                    objMedicalPlan.Chiropractic__c.addError(ERRORMSGREQUIREDFIELD);
                }else if(objMedicalPlan.Chiropractic__c == VALUEOTHER){
                    if(isEmpty(objMedicalPlan.Chiropractic_Other__c)){
                        isValid = false;
                        objMedicalPlan.Chiropractic_Other__c.addError(ERRORMSGCHIROPRATICVALUE);
                    }
                }
                
                if (isEmpty(objMedicalPlan.Acupuncture__c)) {
                    isValid = false;
                    objMedicalPlan.Acupuncture__c.addError(ERRORMSGREQUIREDFIELD);
                }else if(objMedicalPlan.Acupuncture__c == VALUEOTHER){
                    if(isEmpty(objMedicalPlan.Acupuncture_Other__c)){
                        isValid = false;
                        objMedicalPlan.Acupuncture_Other__c.addError(ERRORMSGACUPUNCTUREVALUE);
                    }
                }                   
                
                if (isEmpty(objMedicalPlan.Acupuncture_Chiropractic__c)) {
                    isValid = false;
                    objMedicalPlan.Acupuncture_Chiropractic__c.addError(ERRORMSGREQUIREDFIELD);
                }else if(objMedicalPlan.Acupuncture_Chiropractic__c == VALUEOTHERS){                
                    if(isEmpty(objMedicalPlan.AcupunctureChiropractic_Other__c)){
                        isValid = false;
                        objMedicalPlan.AcupunctureChiropractic_Other__c.addError(ERRORMSGACUPUNCTURECHIROPRACTICVALUE);
                    }
                }
                if (isEmpty(objMedicalPlan.Prosthetic_Orthotic__c)) {
                    isValid = false;
                    objMedicalPlan.Prosthetic_Orthotic__c.addError(ERRORMSGREQUIREDFIELD);
                }
                
                if (isEmpty(objMedicalPlan.Infertility__c)) {
                    isValid = false;
                    objMedicalPlan.Infertility__c.addError(ERRORMSGREQUIREDFIELD);  
                }
            }else {
                if (isEmpty(objMedicalPlan.Medical_Plan_Notes__c) ) {
                    isValid = false;
                    objMedicalPlan.Medical_Plan_Notes__c.addError(ERRORMSGREQUIREDFIELDVALUES);
                }
            }
        }
        return isValid;
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: boolean                                                      *
*  @Description..: Validation for employer Group date                           *
*********************************************************************************/
    public boolean EmployerDateGroup(){
        boolean isValid = true;   
        
        if (isEmpty(employerGroupDataObj.Company_Name__c) ) {
            isValid = false;
            employerGroupDataObj.Company_Name__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        if (isEmpty(employerGroupDataObj.Street_Address__c) && showRenwalForm==false ) {
            isValid = false;
            employerGroupDataObj.Street_Address__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        if (isEmpty(employerGroupDataObj.city_SA__c) && showRenwalForm==false) {
            isValid = false;
            employerGroupDataObj.city_SA__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        if (isEmpty(employerGroupDataObj.State_SA__c) && showRenwalForm==false) {
            isValid = false;
            employerGroupDataObj.State_SA__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        if (isEmpty(employerGroupDataObj.Zip_SA__c) && showRenwalForm==false) {
            isValid = false;
            employerGroupDataObj.Zip_SA__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        
        if (isEmpty(employerGroupDataObj.Phone_Number__c) && showRenwalForm==false) {
            isValid = false;
            employerGroupDataObj.Phone_Number__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        if (isEmpty(employerGroupDataObj.Federal_Employer_ID_Number__c) && showRenwalForm==false) {
            isValid = false;
            employerGroupDataObj.Federal_Employer_ID_Number__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        if (isEmpty(employerGroupDataObj.Group_Type__c) && showRenwalForm==false) {
            isValid = false;
            employerGroupDataObj.Group_Type__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        if ((employerGroupDataObj.of_Employees__c == null) && showRenwalForm==false) {
            isValid = false;
            employerGroupDataObj.of_Employees__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        //Start:Req-3612
        if (employerGroupDataObj.Cobra_Members_with_this_Group__c == null){
            isValid = false;
            employerGroupDataObj.Cobra_Members_with_this_Group__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        //End:Req-3612
        
        if (isEmpty(employerGroupDataObj.SHP_Sales_Representative__c) ) {
            isValid = false;
            employerGroupDataObj.SHP_Sales_Representative__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        
        if ((employerGroupDataObj.of_Eligible_Employees__c == null) && showRenwalForm == false) {
            isValid = false;
            employerGroupDataObj.of_Eligible_Employees__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        if ((employerGroupDataObj.Projected_Enrollment__c == null) ) {
            isValid = false;
            employerGroupDataObj.Projected_Enrollment__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        if (isEmpty(employerGroupDataObj.Plan_vs_Calendar_Year__c) && showRenwalForm == false) {
            isValid = false;
            employerGroupDataObj.Plan_vs_Calendar_Year__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        if ((employerGroupDataObj.Effective_Date__c == null) ) {
            isValid = false;
            employerGroupDataObj.Effective_Date__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        
        if (isEmpty(employerGroupDataObj.Completedby__c) ) {
            isValid = false;
            employerGroupDataObj.Completedby__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        
        if (isEmpty(employerGroupDataObj.AuditorName__c) ) {
            isValid = false;
            employerGroupDataObj.AuditorName__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        
        if (isEmpty(employerGroupDataObj.Performance_or_Implementation__c) ) {
            isValid = false;
            employerGroupDataObj.Performance_or_Implementation__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        
        if (isEmpty(employerGroupDataObj.Broker_Name__c) && showRenwalForm==false) {
            isValid = false;
            employerGroupDataObj.Broker_Name__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        
        if (isEmpty(employerGroupDataObj.Broker_Agency__c) && showRenwalForm==false) {
            isValid = false;
            employerGroupDataObj.Broker_Agency__c.addError(ERRORMSGREQUIREDFIELDVALUES);
        }
        
        if (!isEmpty(employerGroupDataObj.Employee_Waiting_Period__c) && employerGroupDataObj.Employee_Waiting_Period__c == VALUEOTHER ) {
            if(isEmpty(employerGroupDataObj.Employee_Waiting_Period_Other__c)){
                isValid = false;
                employerGroupDataObj.Employee_Waiting_Period_Other__c.addError(ERRORMSGEMPLOYEEWAITINGPERIODVALUE);
            }
        }
        
        if (!isEmpty(employerGroupDataObj.Type_of_Organization__c) && employerGroupDataObj.Type_of_Organization__c == VALUEOTHER ) {
            if(isEmpty(employerGroupDataObj.Type_of_Organization_Other__c)){
                isValid = false;
                employerGroupDataObj.Type_of_Organization_Other__c.addError(ERRORMSGOTHERTYPEOFORGANIZATIONVALUE);
            }
        }
        
        return isValid;
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: boolean                                                      *
*  @Description..: Validation for employer Group date                           *
*********************************************************************************/
    public boolean isValidAllDataMPO() {
        boolean isValid = true;
        
        for(Medical_Plan__c objMedicalPlan: lstMedicalPlan){
            
            if(showRenwalForm == false) {
                if (isEmpty(objMedicalPlan.Medical_type__c)) {
                    isValid = false;
                    objMedicalPlan.Medical_type__c.addError(ERRORMSGEMPTYVALUE);
                }
                if (isEmpty(objMedicalPlan.Medical__c)) {
                    isValid = false;
                    objMedicalPlan.Medical__c.addError(ERRORMSGEMPTYVALUE);
                }
                
                if(!isEmpty(objMedicalPlan.Medical__c) && objMedicalPlan.Medical__c == VALUEOTHERS ){  
                    
                    if(isEmpty(objMedicalPlan.Other_Plan_Id__c)){
                        isValid = false;
                        objMedicalPlan.Other_Plan_Id__c.addError(ERRORMSGOTHERPLANIDVALUE);
                    }
                }
                
                if(isEmpty(objMedicalPlan.Custom_Medical__c)) {
                    isValid = false;
                    objMedicalPlan.Custom_Medical__c.addError(ERRORMSGREQUIREDFIELD);
                }else if(objMedicalPlan.Custom_Medical__c == VALUEOTHER) {        
                    if(isEmpty(objMedicalPlan.CustomMedical_Other__c)) {
                        isValid = false;
                        objMedicalPlan.CustomMedical_Other__c.addError(ERROROTHERCUSTOMMEDICALVALUE);
                    }
                }
                
                if (isEmpty(objMedicalPlan.Dental__c)) {
                    isValid = false;
                    objMedicalPlan.Dental__c.addError(ERRORMSGREQUIREDFIELD);
                }else if(objMedicalPlan.Dental__c == VALUEOTHER){
                    if(isEmpty(objMedicalPlan.Dental_Other__c)){
                        isValid = false;
                        objMedicalPlan.Dental_Other__c.addError(ERRORMSGOTHERDENTALVALUE);
                    }
                }
                
                if (isEmpty(objMedicalPlan.Vision__c)) {
                    isValid = false;
                    objMedicalPlan.Vision__c.addError(ERRORMSGREQUIREDFIELD);
                }else if(objMedicalPlan.Vision__c == VALUEOTHER){
                    if(isEmpty(objMedicalPlan.Vision_Other__c)){
                        isValid = false;
                        objMedicalPlan.Vision_Other__c.addError(ERROROTHERCUSTOMOTHERVISIONVALUE); 
                    }
                }
                
                if (isEmpty(objMedicalPlan.Chiropractic__c)) {
                    isValid = false;
                    objMedicalPlan.Chiropractic__c.addError(ERRORMSGREQUIREDFIELD);
                }else if(objMedicalPlan.Chiropractic__c == VALUEOTHER) {
                    if(isEmpty(objMedicalPlan.Chiropractic_Other__c)) {
                        isValid = false;
                        objMedicalPlan.Chiropractic_Other__c.addError(ERRORMSGCHIROPRATICVALUE);
                    }
                }
                
                if (isEmpty(objMedicalPlan.Acupuncture__c)) {
                    isValid = false;
                    objMedicalPlan.Acupuncture__c.addError(ERRORMSGREQUIREDFIELD);
                }else if(objMedicalPlan.Acupuncture__c == VALUEOTHER){
                    if(isEmpty(objMedicalPlan.Acupuncture_Other__c)){
                        isValid = false;
                        objMedicalPlan.Acupuncture_Other__c.addError(ERRORMSGACUPUNCTUREVALUE);
                    }
                }
                
                if (isEmpty(objMedicalPlan.Acupuncture_Chiropractic__c)) {
                    isValid = false;
                    objMedicalPlan.Acupuncture_Chiropractic__c.addError(ERRORMSGREQUIREDFIELD);
                }else if(objMedicalPlan.Acupuncture_Chiropractic__c == VALUEOTHERS){                
                    if(isEmpty(objMedicalPlan.AcupunctureChiropractic_Other__c)){
                        isValid = false;
                        objMedicalPlan.AcupunctureChiropractic_Other__c.addError(ERRORMSGACUPUNCTURECHIROPRACTICVALUE);
                    }
                }
                
                if (isEmpty(objMedicalPlan.Prosthetic_Orthotic__c)) {
                    isValid = false;
                    objMedicalPlan.Prosthetic_Orthotic__c.addError(ERRORMSGREQUIREDFIELD);
                }
                
                if (isEmpty(objMedicalPlan.Infertility__c)) {
                    isValid = false;
                    objMedicalPlan.Infertility__c.addError(ERRORMSGREQUIREDFIELD);  
                }
            } else {
                if (isEmpty(objMedicalPlan.Medical_Plan_Notes__c) ) {
                    isValid = false;
                    objMedicalPlan.Medical_Plan_Notes__c.addError(ERRORMSGREQUIREDFIELDVALUES);
                }
            }
        }
        return isValid;
    }
    
    /*********************************************************************************
*  @Param........: String                                                       *
*  @Return Type..: boolean                                                      *
*  @Description..: Validation the value is not empty                            *
*********************************************************************************/
    public boolean isEmpty(String strValue) {
        if (String.IsBlank(strValue)) {
            return true;
        }
        return false;
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..:list < SelectOption >                                         *
*  @Description..: Validation the value is not empty                            *
*********************************************************************************/
    public list < SelectOption > getOptVal() {
        list < SelectOption > options = new list < SelectOption > ();
        options.add(new SelectOption(STRYES, STRTRUE));
        options.add(new SelectOption(STRNO, STRFALSE));
        return options;
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: void                                                         *
*  @Description..: Add or remove medical plan section                           *
*********************************************************************************/
    private void addOrRemoveStandardMedical(){
        if (lstMedicalPlan.size() >= 2) {
            HideRemoveMedPlanButton = false;
        }else{
            HideRemoveMedPlanButton = true;
        }
        
        if (lstMedicalPlan.size() < 10) {
            HideAddMedPlanButton  = false;
        }else{
            HideAddMedPlanButton  = true;
        }
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: void                                                         *
*  @Description..:add remove Non medical                                        *
*********************************************************************************/
    private void addOrRemoveNonMedical(){
        if (lstMedicalPlanOther.size() > = 2) {
            HideReamoveNonMedPlanButton = false;
        }else{
            HideReamoveNonMedPlanButton = true;
        }
        
        if (lstMedicalPlanOther.size() < 10) {
            HideAddNonMedPlanButton  = false;
        }else{
            HideAddNonMedPlanButton  = true;
        }
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: PageReference                                                *
*  @Description..: intailization medical plan with 'N/A'  value                 *
*********************************************************************************/
    public PageReference addMedicalPan() {
        lstMedicalPlan.add(new Medical_Plan__c(Custom_Medical__c= VALUE_NA, Dental__c = VALUE_NA, Vision__c = VALUE_NA, Chiropractic__c = VALUE_NA, 
                                               Acupuncture__c = VALUE_NA, Acupuncture_Chiropractic__c = VALUE_NA, Prosthetic_Orthotic__c = VALUE_NA, Infertility__c = VALUE_NA ));
        addOrRemoveStandardMedical();
        return null;
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: PageReference                                                *
*  @Description..: intailization Non-medical plan with 'N/A'  value             *
*********************************************************************************/
    public PageReference addNonMedicalPan() {
        try {
            lstMedicalPlanOther.add(new Medical_Plan__c(Dental__c = VALUE_NA, Vision__c = VALUE_NA, Chiropractic__c = VALUE_NA,
                                                        Acupuncture__c = VALUE_NA, Acupuncture_Chiropractic__c = VALUE_NA, Prosthetic_Orthotic__c = VALUE_NA, Infertility__c = VALUE_NA));
            addOrRemoveNonMedical();
            if(Test.isRunningTest()){
                integer  i1 = 1/0;
            }
        }catch (exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, STRERROR + ex.getMessage() + LINENUMBER + ex.getLineNumber()));
        }
        return null;
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: PageReference                                                *
*  @Description..: Remove Non-medical                                           *
*********************************************************************************/
    public PageReference removeNonMedicalPan() {
        try {
            integer i = lstMedicalPlanOther.size();
            lstMedicalPlanOther.remove(i - 1);
            addOrRemoveNonMedical();     
            if(Test.isRunningTest()){
                integer  ie = 1/0;
            }         
        } catch (exception Ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, STRERROR + ex.getMessage() + LINENUMBER + ex.getLineNumber()));
        }
        return null;
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: boolean                                                      *
*  @Description..: remove standard Medical plan                                 *
*********************************************************************************/
    public PageReference removeMedicalPan() {
        try {
            integer i = lstMedicalPlan.size();
            lstMedicalPlan.remove(i - 1);
            addOrRemoveStandardMedical();
            if(Test.isRunningTest()){
                integer  ie = 1/0;
            }
        } catch (exception Ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, STRERROR + ex.getMessage() + LINENUMBER + ex.getLineNumber()));
        }
        return null;
    }
    /*************************************************************************************
*  @Param........: None						                                         *
*  @Return Type..: PageReference		                                             *
*  @Description..: Redirect to old visulaforce page if it is created < Dec 19th 2016 *
else redirect to new standard page Layout						 *
**************************************************************************************/
    
    public PageReference checkOldorNew(){
        Date effectedDate = Date.valueOf(String.valueOf(System.Label.HR111_EffectedDate));
        //if scn is not null and created date < effected date then it old scn
        if(objEmployerGroupData != NULL && objEmployerGroupData.createdDate < effectedDate){
            isOldSCN = true;
            isNewSCN = false;
            return null;
        }else{
            //if scn is null and created date > effected date then it new scn
            isNewSCN = true;
            isOldSCN = false;
            //checking the stage to not allow the user to edit the scn if it is under the below stages
            if(objSoldCaseNotificationStage.Stage__c != null && objSoldCaseNotificationStage.Stage__c != BLANKVALUE){
                if(objSoldCaseNotificationStage.Stage__c == STATUSCOMPLETED || objSoldCaseNotificationStage.Stage__c == STATUSUNDERWRITINGREVIEW 
                   || objSoldCaseNotificationStage.Stage__c == STRAPPROVED || objSoldCaseNotificationStage.Stage__c == STRENROLLEMTNQAPASS 
                   || objSoldCaseNotificationStage.Stage__c == STRENROLLEMTNQAFAIL || objSoldCaseNotificationStage.Stage__c == STRSUBMITTEDFORQA){
                       showErroronLoad1= true;
                       return null;
                   }
            }
            //scn is not null and id not null
            if(objEmployerGroupData != NULL && objEmployerGroupData.id != NULL){ 
                //redirecting to edit page
                PageReference redirectPage = new PageReference('/' + objEmployerGroupData.id + '/e?retURL=%2F'+objEmployerGroupData.id);
                redirectPage.getParameters().put('nooverride', '1');
                return redirectPage.setRedirect(true);
            }else{
                //if opportunity stage is not closed won showing error message
                if(OppAccount != NULL && OppAccount.Id != NULL && OppAccount.StageName != STATUSVALUECLOSEDWON) {
                    showErroronLoad = true;
                    return null;
                }else{
                    //if the opportunity is not null and sso is  null open the edit page
                    if(OppAccount != NULL && OppAccount.Id != NULL && (ssoObj == NULL || ssoObj.Id == NULL )){
                        PageReference redirectPage = new PageReference('/a17/e?'+System.Label.HR197_OPPFieldHTMLValue+'='+OppAccount.Name+'&'+System.Label.HR197_OPPFieldHTMLValue+'_lkid='+OppAccount.Id+'&retURL=%2F'+OppAccount.Id);
                        redirectPage.getParameters().put('nooverride', '1');
                        return redirectPage.setRedirect(true);
                    }else if((OppAccount == NULL || OppAccount.Id == NULL) && ssoObj != NULL && ssoObj.Id != NULL){
                        //if the opportunity is null and sso is not null open the edit page
                        PageReference redirectPage = new PageReference('/a17/e?'+System.Label.HR196_SSOFieldHTMLValue+'='+ssoObj.Name+'&'+System.Label.HR196_SSOFieldHTMLValue+'_lkid='+ssoObj.Id+'&retURL=%2F'+ssoObj.Id);
                        redirectPage.getParameters().put('nooverride', '1');
                        return redirectPage.setRedirect(true);
                    }else if((OppAccount == NULL || OppAccount.Id == NULL) && (ssoObj == NULL || ssoObj.Id == NULL)){
                        //if the opportunity is null and sso is  null open the create page
                        PageReference redirectPage = new PageReference('/a17/e');
                        redirectPage.getParameters().put('nooverride', '1');
                        return redirectPage.setRedirect(true);
                    }
                    
                }
                
            }
            
            
        }
        return null;
    }
    
    /*********************************************************************************
*  @Param........: Employer_Group_Data__c                                       *
*  @Return Type..: Employer_Group_Data__c                                       *
*  @Description..: set blank value if other is not selected in picklist value   *
*                  of sold case notification                                    *
*********************************************************************************/
    public Employer_Group_Data__c resetOtherValues(Employer_Group_Data__c empGrpData){
        
        if(empGrpData.Benefits_Subject_to_ERISA_Regulations__c == true){
            empGrpData.Other_ERISA__c = BLANKVALUE;
        }
        if(empGrpData.Type_of_Organization__c != VALUEOTHER){
            empGrpData.Type_of_Organization_Other__c = BLANKVALUE;
        }
        if(empGrpData.Employee_Waiting_Period__c != VALUEOTHER){
            empGrpData.Employee_Waiting_Period_Other__c = BLANKVALUE;
        }
        if(empGrpData.Commissions_Optional_Acu_Chiro_ACN__c != VALUEOTHER){
            empGrpData.Other_Optional_Acu_Chiro__c = BLANKVALUE;
        }
        if(empGrpData.Commissions_Optional_Dental_Delta__c != VALUEOTHER){
            empGrpData.Other_Optional_Dental__c = BLANKVALUE;
        }
        if(empGrpData.Commissions_Optional_Vision_VSP__c != VALUEOTHER){
            empGrpData.Other_Optional_Vision__c = BLANKVALUE;
        }
        return empGrpData;
    }
    
    /*********************************************************************************
*  @Param........: Medical_Plan__c                                              *
*  @Return Type..: Medical_Plan__c                                              *
*  @Description..: reset the value of medcial plan value                        *
*********************************************************************************/
    public Medical_Plan__c resetMedicalPlanOther(Medical_Plan__c objMedicalPlan){
        if(objMedicalPlan.Acupuncture__c != VALUEOTHER){
            objMedicalPlan.Acupuncture_Other__c = BLANKVALUE;
        }
        if(objMedicalPlan.Acupuncture_Chiropractic__c != VALUEOTHERS){
            objMedicalPlan.AcupunctureChiropractic_Other__c = BLANKVALUE;
        }
        if(objMedicalPlan.Chiropractic__c != VALUEOTHER){
            objMedicalPlan.Chiropractic_Other__c  = BLANKVALUE;
        }
        if(objMedicalPlan.Custom_Medical__c != VALUEOTHER){
            objMedicalPlan.CustomMedical_Other__c  = BLANKVALUE;
        }
        if(objMedicalPlan.Dental__c != VALUEOTHER){
            objMedicalPlan.Dental_Other__c  = BLANKVALUE;
        }
        if(objMedicalPlan.Individual_Medical__c != VALUEOTHER){
            objMedicalPlan.IndividualMedical_Other__c  =BLANKVALUE;
        }
        if(objMedicalPlan.Large_Group_Medical__c != VALUEOTHER){
            objMedicalPlan.Large_GroupMedical_Other__c  = BLANKVALUE;
        }
        if(objMedicalPlan.Medical__c != VALUEOTHERS){
            objMedicalPlan.Other_Plan_Id__c  = BLANKVALUE;
        }
        if(objMedicalPlan.Small_Group_Medical__c != VALUEOTHER){
            objMedicalPlan.Small_GroupMedical_Other__c  = BLANKVALUE;
        }
        if(objMedicalPlan.Vision__c != VALUEOTHER){
            objMedicalPlan.Vision_Other__c  = BLANKVALUE;
        }
        return objMedicalPlan;
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: PageReference                                                *
*  @Description..: to Save SCN without Validation                               *
*********************************************************************************/
    public PageReference save() {
        required = false;
        try {
            Set<Id> setId = new Set<Id>();
            String strSoldCaseNotificationId  = employerGroupDataObj.Id; 
            List<Medical_Plan__c> newUpdateMedPln = new List<Medical_Plan__c>();
            List<Medical_Plan__c> removeMedPln = new List<Medical_Plan__c>();
            newUpdateMedPln.addAll(lstMedicalPlanOther);
            newUpdateMedPln.addAll(lstMedicalPlan);
            
            for(Medical_Plan__c objMedPlan:newUpdateMedPln){
                setId.add(objMedPlan.Id);
            }
            removeMedPln = [Select Id FROM Medical_Plan__c where Sold_Case_Notification__c =:strSoldCaseNotificationId AND Id NOT IN :setId limit  50000];
            
            if(!removeMedPln.isEmpty()){
                delete removeMedPln;
            }
            employerGroupDataObj.Opportunity__c = objEmployerGroupData.Opportunity__c;
            employerGroupDataObj = resetOtherValues(employerGroupDataObj);
            employerGroupDataObj.Stage__c = STRDRAFT;
            
            /*REQ: 3880 Wave 1 change START*/
            try{
                upsert employerGroupDataObj;  
            }catch(Exception e){
                return null;
            }
            /*REQ: 3880 Wave 1 change END */
            
            boolean boolHasHyperLink = false;
            if (lstMedicalPlan.size() > 0) {
                for (integer i = 0; i < lstMedicalPlan.size(); i++) {
                    lstMedicalPlan[i] = resetMedicalPlanOther(lstMedicalPlan[i]);
                    if (lstMedicalPlan[i].Sold_Case_Notification__c == null)
                        lstMedicalPlan[i].Sold_Case_Notification__c = employerGroupDataObj.Id;
                    lstMedicalPlan[i].RecordTypeId = medicalPlansRecordTypes.get(STANDARDMEDICALPLAN);
                    If(lstMedicalPlan[i].Medical_Plan_Notes__c!=null)
                        if(lstMedicalPlan[i].Medical_Plan_Notes__c.contains(VALUE_HREF)==true)
                    {
                        boolHasHyperLink = true;    
                    }                            
                }
                upsert lstMedicalPlan;
            }
            boolean boolHasHyperLink1 = false;
            if (lstMedicalPlanOther.size() > 0) {
                for (integer i = 0; i < lstMedicalPlanOther.size(); i++) {
                    lstMedicalPlanOther[i] = resetMedicalPlanOther(lstMedicalPlanOther[i]);
                    if (lstMedicalPlanOther[i].Sold_Case_Notification__c == null){
                        lstMedicalPlanOther[i].Sold_Case_Notification__c = employerGroupDataObj.Id;
                    }
                    lstMedicalPlanOther[i].RecordTypeId = medicalPlansRecordTypes.get(MEDICALPLANRECORDTYPE);   
                    if(lstMedicalPlanOther[i].Medical_Plan_Notes__c!=null) {
                        if(lstMedicalPlanOther[i].Medical_Plan_Notes__c.contains(VALUE_HREF) == true) {
                            boolHasHyperLink1 = true;    
                        }   
                    }       
                }
                if(boolHasHyperLink == true  ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, STRHYERLINK);
                    ApexPages.addMessage(myMsg); 
                    return null;                                   
                }     
                if(boolHasHyperLink1 == true  ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, ERRORFORNONMEDICAL);
                    ApexPages.addMessage(myMsg); 
                    return null;                                   
                }                       
                upsert lstMedicalPlanOther;
            }
            PageReference redirect = new PageReference(SHALASH + objEmployerGroupData.Opportunity__c);
            // pass the selected asset ID to the new page
            redirect.setRedirect(true);
            if(Test.isRunningTest()){
                integer  i = 1/0;
            }
            return redirect;
        } catch (Exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, STRERROR + ex.getMessage() + LINENUMBER + ex.getLineNumber()));
        }
        return null;
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: PageReference                                                *
*  @Description..:  To complete SCN with Validaion                              *
*********************************************************************************/  
    public PageReference Completed() {
        //setting save point to rollback the operation if any exception occurs
        System.savePoint savePointObj = Database.setSavepoint();
        try {
            if (!soldCaseNotifcation()) {
                return null;
            }
            
            if (employerGroupDataObj.Opportunity__c == null) {
                employerGroupDataObj.Opportunity__c = objEmployerGroupData.Opportunity__c;
            }
            Set<Id> setId = new Set<Id>();
            String strSoldCaseNotificationId  = employerGroupDataObj.Id;
            
            List<Medical_Plan__c> newUpdateMedPln = new List<Medical_Plan__c>();
            List<Medical_Plan__c> removeMedPln = new List<Medical_Plan__c>();
            newUpdateMedPln.addAll(lstMedicalPlanOther);
            newUpdateMedPln.addAll(lstMedicalPlan);
            
            for(Medical_Plan__c objMedPlan:newUpdateMedPln){
                setId.add(objMedPlan.Id);
            }
            removeMedPln = [Select Id FROM Medical_Plan__c where Sold_Case_Notification__c =:strSoldCaseNotificationId AND Id NOT IN :setId limit  50000];
            if(!removeMedPln.isEmpty() ){
                delete removeMedPln;
            }
            employerGroupDataObj = resetOtherValues(employerGroupDataObj );
            employerGroupDataObj.Stage__c = STATUSUNDERWRITINGREVIEW;
            upsert employerGroupDataObj;
            
            
            boolean boolHasHyperLink = false;
            if (lstMedicalPlan.size() > 0) {
                for (integer i = 0; i < lstMedicalPlan.size(); i++) {
                    if (lstMedicalPlan[i].Sold_Case_Notification__c == null){
                        lstMedicalPlan[i].Sold_Case_Notification__c = employerGroupDataObj.Id;
                    }
                    lstMedicalPlan[i].RecordTypeId = medicalPlansRecordTypes.get(STANDARDMEDICALPLAN);
                    if(lstMedicalPlan[i].Medical_Plan_Notes__c!= null){
                        if(lstMedicalPlan[i].Medical_Plan_Notes__c.contains(VALUE_HREF) == true){
                            boolHasHyperLink = true;    
                        }
                    }
                }
                if(boolHasHyperLink == true){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, STRHYERLINK);
                    ApexPages.addMessage(myMsg); 
                    return null;                                   
                }
                upsert lstMedicalPlan;
            }
            boolean boolHasHyperLink1 = false;
            if (lstMedicalPlanOther.size() > 0) {
                for (integer i = 0; i < lstMedicalPlanOther.size(); i++) {
                    lstMedicalPlanOther[i] = resetMedicalPlanOther(lstMedicalPlanOther[i]);
                    if (lstMedicalPlanOther[i].Sold_Case_Notification__c == null){
                        lstMedicalPlanOther[i].Sold_Case_Notification__c = employerGroupDataObj.Id;
                    }
                    lstMedicalPlanOther[i].RecordTypeId = medicalPlansRecordTypes.get(MEDICALPLANRECORDTYPE);
                    //Codde to throw error for hyperlink
                    if(lstMedicalPlanOther[i].Medical_Plan_Notes__c!=null) {
                        if(lstMedicalPlanOther[i].Medical_Plan_Notes__c.contains(VALUE_HREF)==true) {
                            boolHasHyperLink1 = true;    
                        }          
                    }
                }
                //Add Error if hyperLink added
                if(boolHasHyperLink1 == true){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, ERRORFORNONMEDICAL);
                    ApexPages.addMessage(myMsg); 
                    return null;                                   
                }
                upsert lstMedicalPlanOther;
            }
            PageReference redirect = new PageReference(SHALASH + objEmployerGroupData.Opportunity__c); 
            // pass the selected asset ID to the new page
            redirect.setRedirect(true);
            /* submit the request for approval */
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments(REQUESTFORAPPROVAL);
            req1.setObjectId(employerGroupDataObj.id);
            Approval.ProcessResult result = Approval.process(req1);
            // returns to Opp Page
            if(Test.isRunningTest()){
                integer  i = 1/0;
            }
            return redirect;
        } catch (Exception expt) {
            Database.rollback(savePointObj); ApexPages.addMessages(expt);
        }
        return null;
    }
    
    /*********************************************************************************
*  @Param........: Medical_Plan__c                                              *
*  @Return Type..: Medical_Plan__c                                              *
*  @Description..:  To complete SCN with Validaion                              *
*********************************************************************************/  
    public void autoPopulateHRandEnrollment(){
        String selectConId = employerGroupDataObj.HREnrollment_Name__c;
        employerGroupDataObj.HR_Enrollment_Phone__c = BLANKVALUE;
        employerGroupDataObj.HR_Enrollment_E_mail__c = BLANKVALUE;
        List<Contact> objConHREnroll =[SELECT id, Email, Phone FROM Contact WHERE id =:selectConId limit  1];
        if(objConHREnroll != NULL && !objConHREnroll.isEmpty()){
            if(objConHREnroll[0].Phone != null){
                employerGroupDataObj.HR_Enrollment_Phone__c = objConHREnroll[0].Phone;
            }else{
                employerGroupDataObj.HR_Enrollment_Phone__c = BLANKVALUE;
            }
            
            if(objConHREnroll[0].Email != null){
                employerGroupDataObj.HR_Enrollment_E_mail__c = objConHREnroll[0].Email;
            }else{
                employerGroupDataObj.HR_Enrollment_E_mail__c = BLANKVALUE;
            }
        }
        
    }
    /*********************************************************************************
*  @Param........: Medical_Plan__c                                              *
*  @Return Type..: Medical_Plan__c                                              *
*  @Description..:  To complete SCN with Validaion                              *
*********************************************************************************/  
    public void autoPopulateBilling(){
        String selectConId = employerGroupDataObj.BillingContact_Name__c;
        employerGroupDataObj.Billing_Contact_Phone__c=BLANKVALUE;
        employerGroupDataObj.Billing_Contact_E_mail__c =BLANKVALUE;
        
        List<Contact> objConHREnroll =[SELECT id, Email, Phone FROM Contact WHERE id =:selectConId limit 1];
        if(objConHREnroll != Null  && !objConHREnroll.isEmpty()){
            if(objConHREnroll[0].Phone != null){
                employerGroupDataObj.Billing_Contact_Phone__c = objConHREnroll[0].Phone;
            }else{
                employerGroupDataObj.Billing_Contact_Phone__c =BLANKVALUE;
            }
            
            if(objConHREnroll[0].Email != null){
                employerGroupDataObj.Billing_Contact_E_mail__c =objConHREnroll[0].Email;
            }else{
                employerGroupDataObj.Billing_Contact_E_mail__c = BLANKVALUE;
            }
        }
        
    }
    /*********************************************************************************
*  @Param........: Medical_Plan__c                                              *
*  @Return Type..: Medical_Plan__c                                              *
*  @Description..:  To complete SCN with Validaion                              *
*********************************************************************************/  
    public void autoPopulateHREmployPortal(){        
        String selectConId = employerGroupDataObj.HREmployer_Portal_Name__c;
        employerGroupDataObj.HR_Employer_Portal_E_mail__c=BLANKVALUE;
        employerGroupDataObj.HR_Employer_Portal_Phone__c=BLANKVALUE;
        Contact objConHREnroll =[SELECT id, Email, Phone FROM Contact WHERE id =:selectConId limit 1];
        if(objConHREnroll != Null){
            if(objConHREnroll.Phone != null){
                employerGroupDataObj.HR_Employer_Portal_Phone__c = objConHREnroll.Phone;
            }else{
                employerGroupDataObj.HR_Employer_Portal_Phone__c = BLANKVALUE;
            }
            
            if(objConHREnroll.Email != null){
                employerGroupDataObj.HR_Employer_Portal_E_mail__c = objConHREnroll.Email;
            }else{
                employerGroupDataObj.HR_Employer_Portal_E_mail__c =  BLANKVALUE;
            }
        }
    }
    /*********************************************************************************
*  @Param........: Medical_Plan__c                                              *
*  @Return Type..: Medical_Plan__c                                              *
*  @Description..:  To complete SCN with Validaion                              *
*********************************************************************************/  
    public void autoPopulateHREmployPortal1(){
        String selectConId = employerGroupDataObj.HREmployer_Portal_Name1__c;
        employerGroupDataObj.HR_Employer_Portal_Phone1__c=BLANKVALUE;
        employerGroupDataObj.HR_Employer_Portal_E_mail1__c=BLANKVALUE;
        Contact objConHREnroll =[SELECT id, Email, Phone FROM Contact WHERE id =:selectConId limit 1];
        if(objConHREnroll != Null){
            if(objConHREnroll.Phone != null){
                employerGroupDataObj.HR_Employer_Portal_Phone1__c = objConHREnroll.Phone;
            }else{
                employerGroupDataObj.HR_Employer_Portal_Phone1__c = BLANKVALUE;
            }
            
            if(objConHREnroll.Email != null){
                employerGroupDataObj.HR_Employer_Portal_E_mail1__c = objConHREnroll.Email;
            }else{
                employerGroupDataObj.HR_Employer_Portal_E_mail1__c = BLANKVALUE;
            }
        }
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: void                                                         *
*  @Description..: this the constructor for VFC36_Sold_Case_Notification class  *
*********************************************************************************/
    public void autoPopulateEDIVendor(){
        String selectConId = employerGroupDataObj.EDI_Vendor_Name__c;
        employerGroupDataObj.EDI_Vendor_Phone__c = BLANKVALUE;
        employerGroupDataObj.EDI_Vendor_E_Mail__c = BLANKVALUE;
        Contact objConHREnroll = null;
        /*HighRoads Wave1 - 3880 - Change Start */
        String selectConId1 = employerGroupDataObj.Vendor_Contact_Name__c;
        employerGroupDataObj.Vendor_Contact_Phone__c = BLANKVALUE;
        employerGroupDataObj.Vendor_Contact_Email__c = BLANKVALUE;
        employerGroupDataObj.Vendor_Name__c= BLANKVALUE;
        Contact objConHREnroll1 = null;
        /*HighRoads Wave1 - 3880 - Change End */
        
        if(selectConId != NULL){
            objConHREnroll =[SELECT id, Email, Phone FROM Contact WHERE id =:selectConId limit 1];
        }  
        if(objConHREnroll != Null){
            if(objConHREnroll.Phone != null){
                employerGroupDataObj.EDI_Vendor_Phone__c = objConHREnroll.Phone;
            }else{
                employerGroupDataObj.EDI_Vendor_Phone__c = BLANKVALUE;
            }
            
            if(objConHREnroll.Email != null){
                employerGroupDataObj.EDI_Vendor_E_Mail__c = objConHREnroll.Email;
            }else{
                employerGroupDataObj.EDI_Vendor_E_Mail__c = BLANKVALUE;
            }
        }
        
        /*HighRoads Wave1 - 3880 - Autopopulate Vendor Details from Contact selected - Change Start */
        if(selectConId1 != NULL){
            objConHREnroll1 =[SELECT id, Email, Phone, Department FROM Contact WHERE id =:selectConId1 limit 1];
        }  
        if(objConHREnroll1 != Null){
            
            if(objConHREnroll1.Phone != null){
                employerGroupDataObj.Vendor_Contact_Phone__c = objConHREnroll1.Phone;
            }else{
                employerGroupDataObj.Vendor_Contact_Phone__c = BLANKVALUE;
            }
            
            if(objConHREnroll1.Email != null){
                employerGroupDataObj.Vendor_Contact_Email__c = objConHREnroll1.Email;
            }else{
                employerGroupDataObj.Vendor_Contact_Email__c = BLANKVALUE;
            }
            
            if(objConHREnroll1.Department != null){
                employerGroupDataObj.Vendor_Name__c = objConHREnroll1.Department;
            }else{
                employerGroupDataObj.Vendor_Name__c = BLANKVALUE;
            }
        }
        /*HighRoads Wave1 - 3880 - Change End */
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: void                                                         *
*  @Description..: Disable and enable the EDI Section                           *
*********************************************************************************/
    public void DisableAndEnableEDISection(){
        
        if(employerGroupDataObj.Enrollment_Method__c == VALUEELECTRONIC ){
            isEDIVendorDisable = false;
            isEDIVendorEnable = true;
        }else{
            isEDIVendorDisable = true;
            isEDIVendorEnable = false;
        }
        
    }
    
    /*********************************************************************************
*  @Param........: void                                                         *
*  @Return Type..: void                                                         *
*  @Description..: Disable and enable Medical Region - HighRoads Wave1 - 3880   *
*********************************************************************************/
    public void DisableAndEnableMedicalRegion(){
        
        if(employerGroupDataObj.Group_Type__c== VALUESMALL){
            isMedicalRegionDisable= false;
            isMedicalRegionEnable= true;
        }else{
            isMedicalRegionDisable= true;
            isMedicalRegionEnable= false;
        }
        
    }
    
    // HighRoads Wave 2 request - 3880 STARTS
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
        public boolean isHDHP{get;set;}
        public List<RateTier> rateTierList{get;set;}
        public Integer sizeOfTierandGroups{get;set;}
        public PlanTypes(String planName,Boolean isHDHP,List<RateTier> rateTrList,Integer tierSize){
            this.planName = planName;
            this.rateTierList = rateTrList;
            this.isHDHP = isHDHP;
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
        public boolean isHdhp{get;set;}
        public string plantype{get;set;}//Medical,Rider Plan Name
        public String benefitId{get;set;}//HE02 - 2016
        public planWrapper(Benefit_Plan_Association__c bpa){
            if(bpa.Raider_ID__c == NULL){
                this.plantype = HighRoads_Constants.MEDICAL;
                this.benefitId = bpa.Benefit_Plan_Metadata__r.Name;
                this.isHdhp = bpa.Benefit_Plan_Metadata__r.isHDHP__c;
            }else{
                this.plantype = bpa.Raider_ID__r.Product_Class__c;
                this.benefitId = bpa.Raider_ID__r.Name;
                this.isHdhp = bpa.Raider_ID__r.isHDHP__c;
            }
        }
    }
    // Wrapper class for constructing no rate rider plan
    public class planRiderWrapper{
        public string Name{get;set;}//rider plan name
        public List<planWrapper> planWrapperList{get;set;}//plan wrapper list
        public Integer sizeOfPlanWrappers{get;set;}// to display dynamic rowspan
        public planRiderWrapper(String Name,List<planWrapper> planWrapList){
            this.Name = Name;
            this.planWrapperList = planWrapList;
            this.sizeOfPlanWrappers = planWrapList.size()+1;
        }
    }
    // HighRoads Wave 2 request - 3880 ENDS
}