/* 
     Class Name: VFC45_SHP_RFPForm 
     Author: IDC Offshore
     Date: 23-Feb-2016
     Description: Controller for VFP45_SHP_RFPForm visualforce page to create new Incumbent Carrier of RFPForm record type.
     
     History:
     VERSION    AUTHOR              DATE        DETAIL 
     1.0        Prerna Chandak      14-4-2016    To display associated incumbent carrier records when a PDF is generated from RFP Form.
     1.1        Prerna Chandak      18-4-2016    To display "Submit for Underwriter Review" button to SHP Sales Group users only.
     1.2        Prerna Chandak      21-4-2016    Not to display Current Offerings section when there are no related incumbent carrier records when PDF is generated.
     1.3        Prerna Chandak      22-4-2016    Method to get the count of incumbent carrier records related to particular RFP Form.
     1.4        Bhaskar Bellapu     12-10-2016   Req 3980 SHP Wave 2 Changes - New RFP Form changes
                                                 1. User should not create before filling all required data in RFP
                                                 2. New RFP Form form formulas for current values and renewal values
                                                 3. Display the Incumbent carrier horizontally instead of vertically.
     2.0        Deloitte          16-03-2017   SHP07  Update RFP Formulas               
     2.1        Deloitte          21-03-2017   SHP20  SHP_SA_Subs_minus_Valid_Waiver__c was a number field and it's now made to a formula field
     3.0        Deloitte          19-04-2017   SHP26  Rejection reason
     4.0        Deloitte          03-05-2017   SHP44  Added filters to see if any of Current Tier valus is being BLANK or ZERO and adding a page message, if any such found.

*/
public with sharing class VFC45_SHP_RFPForm 
{
    private static final String STRERROR  = 'Error:';
    private static final String LINENUMBER = 'Line Number:';
    public Incumbent_Carrier__c RFPForm{get;set;}
    public List<RFPFormWrapper>RelatedIncumbentCarrierList{get;set;}
    public List<RFPFormWrapper>AllIncumbentCarrierList{get;set;}
    public List<RFPFormListWrapper>rfpListFormList{get;set;}
    public List<RFPFormWrapper>rfpFormList{get;set;}
    public List<RFPFormWrapper>rfpFormList_1{get;set;}
    private integer IncubentCarrierlist_size=4; 
    public Opportunity RelatedOpportunity{get;set;}
    public boolean isMember{get;set;}
    private integer counter=0;  //keeps track of the offset
    public integer total_size; //used to show user the total size of the list
    public static String INCUMBENTRECTYPE = System.Label.SHP_RFP_60;
    public static String REGEXDATE = System.Label.SHP_RFP_61;
    public static String REGEXZIP = System.Label.SHP_RFP_62;
    public static String HEADER = 'Record Id, Name \n';
    public static String SUBJECTLINE = System.Label.SHP_RFP_64;
    public static String SUBJECTBODY = System.Label.SHP_RFP_65;
    public static String SUCCESSMSG = System.Label.SHP_RFP_66;
    public static String ERRMSG = System.Label.SHP_RFP_67;
    public static String WARNINGMSG = System.Label.SHP_RFP_68;
    public static String NOFILEMSG = System.Label.SHP_RFP_69;
    public static String RECORDLOCKED = System.Label.SHP_RFP_70;
    public static String RECORDSUBMITTED = System.Label.SHP_RFP_71;
    public static String SUCCESSSTATUS = System.Label.SHP_RFP_72;
    public static String ERRORSTATUS = System.Label.SHP_RFP_73;
    public Integer totalCount{get;set;}
    public boolean mandatoryFieldsAreNotFilled{get;set;}
    public string nameFile{get;set;} 
    public boolean isSmallGroup{get;set;}
    public boolean isIndividualAccount{get;set;}
    public Blob contentFile{get;set;}
    public boolean isUnderwritingUser{get;set;}
    public Boolean ReadOnly {get;set;}
    public Boolean CheckCurrentTier {get;set;}
    String[] filelines = new String[]{};   //to store all records separated by \n in csv file
    List<Census__c> censusDataToUpload;
    // Req 3880 Wave 2 Implementation
    public ApexPages.StandardController controller;

    public VFC45_SHP_RFPForm(ApexPages.StandardController stdController) 
    {
        this.controller = stdController;
        mandatoryFieldsAreNotFilled = false;
        isSmallGroup = false;
        isIndividualAccount = false;
        isUnderwritingUser = ReadOnly = CheckCurrentTier = false;
        String IncumbentCarrierRecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(INCUMBENTRECTYPE).getRecordTypeId();
        Date effectedDate = Date.valueOf(String.valueOf(System.Label.HR111_EffectedDate));
        Date created_date = null; 
        Map<String,SF_P2A_Market_Segments_Mapping__c> marketSegment = SF_P2A_Market_Segments_Mapping__c.getAll();
        try
        {    
            if( ApexPages.currentPage().getParameters().containsKey(System.Label.SHP_RFP_74) )
            {
                String RecId = ApexPages.currentPage().getParameters().get(System.Label.SHP_RFP_74);
               
                RFPForm = new Incumbent_Carrier__c( Id=RecId );
                //Getting all field values from Incumbent Carrier object of Incumbent Carrier record type.
                RFPForm = [SELECT Id,createdDate,Opportunity__c,Reject_Reason__c,RecordTypeId,Account_Executive_n__c,Employer_Name_n__c,ER_City_n__c,
                           Total_EE_s_n__c,DBA_if_any_n__c,ER_Zip_Code_n__c,CreatedBy.Name,Valid_Waivers_n__c,
                           Reason_for_Market_Check__c,RFP_Type__c,No_of_Quotes_Requested__c,Out_of_Area_EE_s_n__c,Stage__c,T_R_or_Slice_n__c,Custom_Plan__c,
                           Total_Enrolled_n__c,Quote_Effective_Date_n__c,Participation__c,BrokerageFirm_n__c,
                           Broker__c,Quote_Due_Date_n__c,Strategy_Statement__c,Special_Instuctions__c,
                           General_Agent__c, GA_Contact__c, GA_Commission__c,Tiered_Rates__c,General_Agent_Applicable__c,Opportunity__r.Renewed_Opportunity__c  
                           FROM Incumbent_Carrier__c 
                           WHERE Id = :RecId limit 10000];
            }
            else 
            {
                RFPForm = new Incumbent_Carrier__c();
                RFPForm.Opportunity__c = ApexPages.currentPage().getParameters().get(System.Label.SHP_RFP_87);
                RFPForm.recordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(Label.SHP_RFPFORM_Record_Type).getRecordTypeId();
                created_date = system.today();
            }
            
            if(RFPForm.Opportunity__c != null) 
            {
               //Getting values of fields from Opportunity.
               //SHP20
               RelatedOpportunity = [SELECT Id,Name,Renewed_Opportunity__c,Employer_Type__c,Account.SIC_Code__c,Account.Name,Out_of_Area__c,
                                     RFP_Due_Date__c,Account.BillingCity,Account.DBA__c,Account.BillingPostalCode,Broker_of_Record__c,Slicing_with_Carrier_Name__c ,
                                     Broker_Rep1__r.Name,Contribution_s_EE__c,Full_Time_Employees__c,Waived__c,Total_Enrolled__c,Account_RecordType_Name__c,
                                     Additional_Buy_Ups__c,Dependent_Contribution__c,Plan_Effective_Date__c,Group_Renewal_Date__c,
                                     Rate_Tier__c,Broker1__r.Name,Strategic_Broker__c,Commission__c,Total_SHP_SA_Subs_with_Valid_Waivers__c,
                                     Total_Subs_in_SHP_Service_Areas_SA__c,SHP_SA_Subs_minus_Valid_Waiver__c,
                                     Account.Account_Executive__r.FirstName,Account.Account_Executive__r.LastName   
                                     FROM Opportunity 
                                     WHERE Id = :RFPForm.Opportunity__c limit 1];
                //checking the effected date and created date, if created date is > effected date then the new business rules will apply for those 
                //records as per this release (3980 SHP Wave 2 Changes)
                //else new business rules like validation rules will not trigger to old records
                if(created_date >= effectedDate){
                    //fetching the list of group members, which will be used to check the current logged in user is related to underwriter group or not
                    //if belongs to underwriter, then underwriting reject reason field will be rendered else not rendered
                    List<Group> grpList = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE developername =:System.Label.SHP_RFP_96];
                    for(Group grpObj : grpList){
                        for (GroupMember grpMem : grpObj.groupMembers) {
                            if(grpMem.userOrGroupId == UserInfo.getUserId()){
                                isUnderwritingUser = true;
                                break;
                            }
                        }
                    }
                    //checkingg the account employer type is not exists in the custom setting
                    //if the account is not belongs to large group, not allowing the user to create RFP for Small Group and Indivual accounts
                    if(RelatedOpportunity.Employer_Type__c != NULL && marketSegment.get(RelatedOpportunity.Employer_Type__c) == NULL ){
                        mandatoryFieldsAreNotFilled = true;
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.HR235_EmployerTypeNotFound));
                    }
                    //checkingg the account employer type
                    //if the account is not belongs to large group, not allowing the user to create RFP for Small Group and Indivual accounts
                    if(RelatedOpportunity.Employer_Type__c != NULL && marketSegment.get(RelatedOpportunity.Employer_Type__c) != NULL && marketSegment.get(RelatedOpportunity.Employer_Type__c).P2A_Market_Segment__c.equalsIgnoreCase(System.Label.HR01_MarketSegment_SG)){
                        isSmallGroup = true;
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'RFP Can not be created for Small Group'));
                    }
                    //checkingg the account employer type
                    //if the account is not belongs to large group, not allowing the user to create RFP for Small Group and Indivual accounts
                    if(RelatedOpportunity.Account_RecordType_Name__c == System.Label.HR80_SHPSalesIndividual){
                        isIndividualAccount = true;
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'RFP Can not be created for Individual Account'));
                    }
                    //checking the mandatory fields need to be filled before creating the RFP
                    //as per business requirement, if field is empty throw the error message to user to enter the particular field value
                    //checking condition the account is not small group and individual
                    if(RelatedOpportunity.Employer_Type__c != NULL && !isSmallGroup && !isIndividualAccount){
                        /* If SIC Code is null */
                        if(RelatedOpportunity.Account.SIC_Code__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR94_SICCodeMandatory));
                        }
                        /* If Account Billing City is null */
                        else if(RelatedOpportunity.Account.BillingCity == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR95_ERCityMandatory));
                        }
                        /* If Slicing with Carrier Name is null */
                        else if(RelatedOpportunity.Slicing_with_Carrier_Name__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR96_SlicingWithCNameMandatory));
                        }
                        /* If Account Executive name is null */
                        else if(RelatedOpportunity.Account.Account_Executive__r.FirstName == NULL && RelatedOpportunity.Account.Account_Executive__r.LastName == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR97_AccountExecutiveMandatory));
                        }
                        /* If Out of Area is null */
                        else if(RelatedOpportunity.Out_of_Area__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR98_OutofAreaEEMandatory));
                        }
                        /* If RFP Due Date is null */
                        else if(RelatedOpportunity.RFP_Due_Date__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR88_RFPDueDateMandatory));
                        }
                        /* If Broker Rep is null */
                        else if(RelatedOpportunity.Broker_Rep1__r.Name == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR99_BrokerRepMandatory));
                        }
                        /* If Contributions EE is null */
                        else if(RelatedOpportunity.Contribution_s_EE__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR100_ContributionsEEMandatory));
                        }
                        /* If Full Time Employees is null */
                        else if(RelatedOpportunity.Full_Time_Employees__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR101_FulltimeEmployeesMandatory));
                        }
                        /* If Waived is null */
                        else if(RelatedOpportunity.Waived__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR102_WaivedMandatory));
                        }
                        /* If Proposal Scenario is null */
                        else if(RelatedOpportunity.Additional_Buy_Ups__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR90_ProposalScenarioMandatory));
                        }/* If Dependent Contribution is null */
                        else if(RelatedOpportunity.Dependent_Contribution__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR104_DependentContributionMandatory));
                        }
                        /* If Plan Effective is null */
                        else if(RelatedOpportunity.Plan_Effective_Date__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR91_PlanEffectiveDateMandatory));
                        }
                        /* If Total subs in shp servie area SA is null */
                        else if(RelatedOpportunity.Total_Subs_in_SHP_Service_Areas_SA__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR106_TotalSubsinSHPSAreaMandatory));
                        }
                        //SHP20
                        /* If SHP SA Subs minus valid waiver is null */
                        else if(RelatedOpportunity.SHP_SA_Subs_minus_Valid_Waiver__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR107_SHPSASubsminusValidWaiverMandatory));
                        }
                         /*If SHP Participation is null
                        else if(RelatedOpportunity.SHP_Participation__c == NULL){
                            mandatoryFieldsAreNotFilled = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.HR108_SHPParticipationMandatory));
                            
                        }*/
                    } 
                }
        
                //Getting the count of number of records return from above query(records of Incumbent carrier rec type)
                total_size = [SELECT COUNT() 
                              FROM Incumbent_Carrier__c 
                              WHERE Opportunity__c = :RelatedOpportunity.Id AND RecordTypeId =:IncumbentCarrierRecordTypeId limit 10000];
            }
            if(RelatedOpportunity.Renewed_Opportunity__c == true)
            {
                RFPForm.Renewed_RFP_Form__c = true;
                RFPForm.Reason_for_Market_Check__c = RFPForm.Reason_for_Market_Check__c == NULL ? System.Label.HR211_Renewal : RFPForm.Reason_for_Market_Check__c;
            }else{
                RFPForm.Reason_for_Market_Check__c = RFPForm.Reason_for_Market_Check__c == NULL ? System.Label.HR212_NewBusiness : RFPForm.Reason_for_Market_Check__c;
            }
            if(RFPForm == NULL) 
            {  
                RFPForm.Custom_Plan__c = System.Label.SHP_RFP_95;
            }
            if( RelatedOpportunity != null ) 
            {
                AllIncumbentCarrierList = new List<RFPFormWrapper>(); 
                for(Incumbent_Carrier__c RFP: [SELECT Id,Name,Incumbent_Carrier__c,BrokerageFirm_n__c,Broker__c,Product__c,Deductible__c,
                                               OOPM__c,DOV__c,Specialist_OV__c,IP__c,ER__c,RX__c,SHP_Plans_to_Quote__c,SHP_Plans_to_Quote__r.Name,
                                               Other_Competitive_Carrier__c,EE__c,EF__c,EC__c,ECH__c,ES__c,Ratioes_To_Quote__c,
                                               EE_Renewal__c,Opportunity__r.Total_Subs_in_SHP_Service_Areas_SA__c,
                                               ES_Renewal__c,EC_Renewal__c,ECH_Renewal__c,EF_Renewal__c,Change__c,Opportunity__r.SHP_SA_Subs_minus_Valid_Waiver__c  //SHP20
                                               FROM Incumbent_Carrier__c 
                                               WHERE Opportunity__c = :RelatedOpportunity.Id AND RecordTypeId = :IncumbentCarrierRecordTypeId 
                                               ORDER BY CreatedDate ASC limit 10000])
                    {
                        RFPFormWrapper RFPObject = new RFPFormWrapper( RFP );
                        AllIncumbentCarrierList.add(RFPObject);
                    }
                if( AllIncumbentCarrierList!= null && !AllIncumbentCarrierList.isEmpty())
                {
                     for( Integer i=0 ; i<AllIncumbentCarrierList.size(); i++ ) 
                     {
                        AllIncumbentCarrierList[i].PlanName = System.Label.SHP_RFP_94 +(i+1);
                     }
                }
            }

            if( AllIncumbentCarrierList != null && !AllIncumbentCarrierList.isEmpty()) 
            {
                searchRelatedIncumbentCarriers();
            }
            
           
            
        }catch( Exception codeException ) {
          Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,STRERROR + codeException.getMessage() + LINENUMBER + codeException.getLineNumber()));
        }
        
        try{
         List <GroupMember> GroupMem1 = [SELECT Id, group.id, group.name, group.type 
                       FROM GroupMember 
                       where UserOrGroupId=:userinfo.getuserid() and group.developername=: System.Label.SHP_RFP_96 limit 10000];
       
        isMember = false;
        if(GroupMem1.size()>0){
                         
         isMember = true;
         
         }
         else{
         
         isMember = false;
        
         }
        }
        catch( Exception codeException ){
               ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, ERRMSG  +codeException.getMessage());
               ApexPages.addMessage(errormsg);
             
             } 
      
    }
/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 26-Oct-2016                                                 *  
*   @description .: to render the rfp types based on the opportunity renewed    *
          or not                             *
*   @param........: none                                                        *    
*   @return ......: List<SelectOption>                                          *
*********************************************************************************/
  public List<SelectOption> getRFPTypes() {

        List<SelectOption> options = new List<SelectOption>();
        if(RelatedOpportunity.Renewed_Opportunity__c){
            options.add(new SelectOption(System.Label.HR236_RFR_Status_Quo,System.Label.HR236_RFR_Status_Quo));
            options.add(new SelectOption(System.Label.HR237_RFR_Change_Renewal,System.Label.HR237_RFR_Change_Renewal));
        }else{
            options.add(new SelectOption(System.Label.HR238_RFP_NewBusiness,System.Label.HR238_RFP_NewBusiness));
        }
        return options;

    }
/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: To fetch all the realted Incumbent Carrier records.         *
*   @param........:                                                             *    
*   @return ......:                                                             *
*********************************************************************************/  
    public void searchRelatedIncumbentCarriers() {
    
        RelatedIncumbentCarrierList = new List<RFPFormWrapper>();
        if((counter + IncubentCarrierlist_size-1) < total_size ) 
        {
            for( Integer RFPCount = counter ; RFPCount <= (counter + IncubentCarrierlist_size-1) ; RFPCount++ )
            {
                RelatedIncumbentCarrierList.add(AllIncumbentCarrierList[RFPCount]);   
            }
        }
        else 
        {
            for( Integer RFPCount = counter ; RFPCount <= total_size-1 ; RFPCount++ ) {
                RelatedIncumbentCarrierList.add(AllIncumbentCarrierList[RFPCount]);
                 
            }
        }
    }
    //wrapper class to construct the incumbent carrier in the internal visualforce page
    //@SHP7 Updated RFP Formulas
    public class RFPFormWrapper 
    {
        public Incumbent_Carrier__c RFPFormRec {get;set;}
        public String PlanName{get;set;}
        /*rate values addition 3980 STARTS */
        public Double ratioes_to_Quote{get;set;}
        public Double ratioes_to_Quote2{get;set;}
        public Double ratioes_to_Quote3{get;set;}
        public Double ratioes_to_Quote4{get;set;}
        public Double ratioes_to_Quote5{get;set;}
        //public Integer percentChange{get;set;}
        public Decimal topCurrent{get;set;}
        public Decimal topRenewal{get;set;}
        /*rate values addition 3980 ENDS */
        public RFPFormWrapper( Incumbent_Carrier__c RFPForm) 
        {
            this.RFPFormRec = RFPForm;
            List<Decimal> currentValues = new List<Decimal>();
            List<Decimal> renewalValues = new List<Decimal>();
            //Req 3880 wave 2 changes
            //Calculating the ratios to quote values based on the new RFP Form
            //the formulas have been given by business
            if(RFPForm.EE__c != NULL && Double.valueOf(RFPForm.EE__c) != 0 && RFPForm.EC__c != NULL && Double.valueOf(RFPForm.EC__c) != 0){
                this.ratioes_to_Quote = Math.round((Decimal.valueOf((Double.valueOf(RFPForm.EE__c) / Double.valueOf(RFPForm.EC__c))))*100) / 100.0;
                //this.ratioes_to_Quote = Integer.valueOf((Decimal.valueOf(RFPForm.EE__c) / Decimal.valueOf(RFPForm.EC__c)).round(system.RoundingMode.UP));
            }
            if(RFPForm.EC__c != NULL && Double.valueOf(RFPForm.EC__c) != 0  && RFPForm.ES__c != NULL && Double.valueOf(RFPForm.ES__c) != 0  ){
                this.ratioes_to_Quote2 = Math.round((Decimal.valueOf((Double.valueOf(RFPForm.ES__c) / Double.valueOf(RFPForm.EC__c))))*100) /100.0;
            }
            if(RFPForm.EC__c != NULL  && Double.valueOf(RFPForm.EC__c) != 0  ){
                this.ratioes_to_Quote3 = Math.round((Decimal.valueOf((Double.valueOf(RFPForm.EC__c) / Double.valueOf(RFPForm.EC__c))))*100) / 100.0;
            }
            if(RFPForm.EC__c != NULL  && Double.valueOf(RFPForm.EC__c) != 0  && RFPForm.EF__c != NULL && Double.valueOf(RFPForm.EF__c) != 0 ){
                this.ratioes_to_Quote4 = Math.round((Decimal.valueOf((Double.valueOf(RFPForm.EF__c) / Double.valueOf(RFPForm.EC__c)))) * 100) / 100.0;
            }
            if(RFPForm.EC__c != NULL   && Double.valueOf(RFPForm.EC__c) != 0 && RFPForm.ECH__c != NULL  && Double.valueOf(RFPForm.ECH__c) != 0 ){
                this.ratioes_to_Quote5 = Math.round((Decimal.valueOf(Double.valueOf(RFPForm.ECH__c) / Double.valueOf(RFPForm.EC__c))) * 100) / 100.0;
            }
            //adding all current rate values to list to calculate the top current value
            if(RFPForm.EC__c != NULL && Double.valueOf(RFPForm.EC__c) != 0)
            currentValues.add(Decimal.valueOf(RFPForm.EC__c));
            if(RFPForm.EE__c != NULL && Double.valueOf(RFPForm.EE__c) != 0)
            currentValues.add(Decimal.valueOf(RFPForm.EE__c));
            if(RFPForm.EF__c != NULL && Double.valueOf(RFPForm.EF__c) != 0)
            currentValues.add(Decimal.valueOf(RFPForm.EF__c));
            if(RFPForm.ES__c != NULL && Double.valueOf(RFPForm.ES__c) != 0)
            currentValues.add(Decimal.valueOf(RFPForm.ES__c));
            if(RFPForm.ECH__c != NULL && Double.valueOf(RFPForm.ECH__c) != 0)
            currentValues.add(Decimal.valueOf(RFPForm.ECH__c));
            //adding all renewal rate values to list to calculate the top renewal value
            if(RFPForm.EC_Renewal__c != NULL && Double.valueOf(RFPForm.EC_Renewal__c) != 0)
            renewalValues.add(Decimal.valueOf(RFPForm.EC_Renewal__c));
            if(RFPForm.EE_Renewal__c != NULL && Double.valueOf(RFPForm.EE_Renewal__c) != 0)
            renewalValues.add(Decimal.valueOf(RFPForm.EE_Renewal__c));
            if(RFPForm.EF_Renewal__c != NULL && Double.valueOf(RFPForm.EF_Renewal__c) != 0)
            renewalValues.add(Decimal.valueOf(RFPForm.EF_Renewal__c));
            if(RFPForm.ES_Renewal__c != NULL && Double.valueOf(RFPForm.ES_Renewal__c) != 0)
            renewalValues.add(Decimal.valueOf(RFPForm.ES_Renewal__c));
            if(RFPForm.ECH_Renewal__c != NULL && Double.valueOf(RFPForm.ECH_Renewal__c) != 0)
            renewalValues.add(Decimal.valueOf(RFPForm.ECH_Renewal__c));
             
            if(RFPForm.EC__c != NULL && Double.valueOf(RFPForm.EC__c) > 0 && RFPForm.EC_Renewal__c != NULL)
            {
                Double Change = ((Double.valueOf(RFPForm.EC_Renewal__c) / Double.valueOf(RFPForm.EC__c))-1);
                if(Double.valueOf(RFPForm.EC__c) ==1 ){
                  RFPFormRec.Change__c = String.valueOf(Change *100);
                }else{
                 Change = (Math.round((Change*100)*100)/100.0);
                RFPFormRec.Change__c = String.valueOf(Change); 
                }
            }
        }
    }
  
        
    public class RFPFormListWrapper 
    {
        public List<RFPFormWrapper>rfpFormList{get;set;}
        public String PlanName{get;set;}
        public RFPFormListWrapper(List<RFPFormWrapper> RFPForm) 
        {
            this.rfpFormList= RFPForm;
        }
    }
    
    public Integer getInccarrierCount(){
    String IncumbentCarrierRecTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(INCUMBENTRECTYPE).getRecordTypeId();
    totalCount = [select count() FROM Incumbent_Carrier__c WHERE Opportunity__c = :RelatedOpportunity.Id AND RecordTypeId = :IncumbentCarrierRecTypeId];
    return totalCount;
    }

/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 11-April-2016 (May Release)                                               *  
*   @description .: To fetch realted Incumbent Carrier records and display them in PDF.         *
*   @param........:                                                             *    
*   @return ......: List of records of Incumbent Carrier record type.                                                          *
*********************************************************************************/  
    public List<RFPFormListWrapper> getIncumbentCarrierDataList(){
        Integer incCount = getInccarrierCount();
        if(incCount > 0){
            rfpListFormList= new List<RFPFormListWrapper>();
            rfpFormList = new List<RFPFormWrapper>();
            String IncumbentCarrierRecTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(INCUMBENTRECTYPE).getRecordTypeId();
            for(Incumbent_Carrier__c RFPList: [SELECT Id,Name,Incumbent_Carrier__c,BrokerageFirm_n__c,Broker__c,Product__c,
                                               Deductible__c,OOPM__c,DOV__c,Specialist_OV__c,IP__c,ER__c,RX__c,SHP_Plans_to_Quote__c,SHP_Plans_to_Quote__r.Name,
                                               Other_Competitive_Carrier__c,EE__c,EF__c,EC__c,ECH__c,ES__c,Ratioes_To_Quote__c,
                                               Opportunity__r.Total_Subs_in_SHP_Service_Areas_SA__c,
                                               EE_Renewal__c,ES_Renewal__c,EC_Renewal__c,ECH_Renewal__c,EF_Renewal__c,Change__c,SHP_SA_Subs_minus_Valid_Waiver__c
                                               ,Opportunity__r.SHP_SA_Subs_minus_Valid_Waiver__c     //SHP20
                                               FROM Incumbent_Carrier__c 
                                               WHERE Opportunity__c = :RelatedOpportunity.Id AND RecordTypeId = :IncumbentCarrierRecTypeId 
                                               ORDER BY CreatedDate ASC
                                               limit 10000])
                         {
                           
                            RFPFormWrapper RFPObj = new RFPFormWrapper( RFPList);
                            rfpFormList.add(RFPObj );
                                                   
                         }
                        for( Integer i=0 ; i<rfpFormList.size(); i++ ) 
                         {
                                rfpFormList[i].PlanName = System.Label.SHP_RFP_94+(i+1);
                         }
             
       
            rfpFormList_1=new List<RFPFormWrapper>();
            RFPFormListWrapper rfpListWrapper = new RFPFormListWrapper(rfpFormList_1);
             
            for(Integer i=0;i<rfpFormList.size();i++)
             {
                Integer result = math.mod(i, 4);
    
                if((result==0 && i!=0))
                {
                 rfpListWrapper = new RFPFormListWrapper(rfpFormList_1);
                 rfpListFormList.add(rfpListWrapper);
                 rfpFormList_1=new List<RFPFormWrapper>();
                 rfpFormList_1.add(rfpFormList[i]);
    
                }
    
                else
               {
                 rfpFormList_1.add(rfpFormList[i]);
                }
    
             
             }
             
            rfpListWrapper = new RFPFormListWrapper(rfpFormList_1);
            rfpListFormList.add(rfpListWrapper);
            return rfpListFormList;
        }
        else
        return null;
    }

    
/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: The begining of pagination functionality                    *
*   @param........:                                                             *    
*   @return ......: null                                                        *
*********************************************************************************/     
    public PageReference First()  
    { 
        counter = 0;
        RelatedIncumbentCarrierList.clear();
        searchRelatedIncumbentCarriers();
        return null;
    }

/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: Previous button functionality                               *
*   @param........:                                                             *    
*   @return ......: null                                                        *
*********************************************************************************/ 
    public PageReference Previous()  
    {
        counter -= IncubentCarrierlist_size;
        RelatedIncumbentCarrierList.clear();
        searchRelatedIncumbentCarriers();
        return null;
    }

/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: Next button functionality                                   *
*   @param........:                                                             *    
*   @return ......: null                                                        *
*********************************************************************************/ 
    public PageReference Next()     
    { 
        counter += IncubentCarrierlist_size;
        RelatedIncumbentCarrierList.clear();
        searchRelatedIncumbentCarriers();
        return null;
    }


/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: Last button functionality                                   *
*   @param........:                                                             *    
*   @return ......: null                                                        *
*********************************************************************************/    
    public PageReference Last()   
    { 
        Integer checkValue = math.mod(total_size, IncubentCarrierlist_size);
        if( checkValue == 0 ) 
        {
            counter = ((total_size/IncubentCarrierlist_size)-1)*IncubentCarrierlist_size;
        }
        else 
        {
            counter = total_size - checkValue;
        }
        RelatedIncumbentCarrierList.clear();
        searchRelatedIncumbentCarriers();
        return null;
    }
    
/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: This will disable the previous and beginning buttons        *
*   @param........:                                                             *    
*   @return ......: true                                                        *
*********************************************************************************/ 
   public Boolean getDisablePrevious() 
   { 
        if (counter>0){ 
         return false;
        } 
        else {
         return true;
        }
   }
   
/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: This will disable the next and end buttons                  *
*   @param........:                                                             *    
*   @return ......: true                                                        *
*********************************************************************************/
   public Boolean getDisableNext() 
   { 
        if (counter + IncubentCarrierlist_size < total_size){ 
         return false; 
        }
        else {
         return true;
        }
   }

/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: To get the total number of Incumbent Carrier records on oppty*
*   @param........:                                                             *    
*   @return ......: size of list having Incumbent carrier records.              *
*********************************************************************************/   
   public Integer getTotal_size() 
   {
        return total_size;
   }

/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: To get page number                                          *
*   @param........:                                                             *    
*   @return ......: page count                                                        *
*********************************************************************************/ 
   public Integer getPageNumber()
   {
        return counter/IncubentCarrierlist_size + 1;   
      
   }

/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: To get total number of pages                                *
*   @param........:                                                             *    
*   @return ......: no. of pages.                                                        *
*********************************************************************************/  
   public Integer getTotalPages() 
   {
       if(total_size != 0){
           if (math.mod(total_size, IncubentCarrierlist_size) > 0) 
           {
               return total_size/IncubentCarrierlist_size+ 1;
           } 
           else 
           {
               return (total_size/IncubentCarrierlist_size);
           }
       }else{
           return 0;
       }
       
   }
   

    /********************************************************************************
    *   @author ......: IDC Team                                                    *  
    *   @date ........: 23-Feb-2016                                                 *  
    *   @description .: To save the new RFPForm record and redirect to the record detail page                                *
    *   @param........:                                                             *    
    *   @return ......: RFP Detail page                                                       *
    *********************************************************************************/ 
    public pageReference saveForm()
    {
        CheckCurrentTier = CheckCurrentTier ? false : false;
        List<Incumbent_Carrier__c> IncumbentCarriersToUpdate = new List<Incumbent_Carrier__c>();
        try
        {
            UserRole uRoleObj = [SELECT Id, Name, DeveloperName FROM UserRole WHERE Id IN (SELECT UserRoleId FROM User WHERE Id =:UserInfo.getUserId()) LIMIT 1];
            if(uRoleObj.Name.equalsIgnoreCase(System.Label.HR137_AccountExecutiveRole))
            {
                if( String.isBlank(String.valueOf(RFPForm.No_of_Quotes_Requested__c) ))
                {
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.HR183_NoOfQuotesMandatory);ApexPages.addMessage(errormsg);return null;
                }
                else if(String.isBlank(RFPForm.Reason_for_Market_Check__c ))
                {
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.HR184_ReasonForMarketMandatory);ApexPages.addMessage(errormsg);return null;
                }
                else if(String.isBlank(RFPForm.Tiered_Rates__c))
                {
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.HR185_TieredRatesMandatory);ApexPages.addMessage(errormsg);return null;
                }
                else if(String.isBlank(RFPForm.Strategy_Statement__c))
                {
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.HR186_StrategyStatementMandatory);ApexPages.addMessage(errormsg);return null;
                }
                else if(String.isBlank(RFPForm.Special_Instuctions__c))
                {
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.HR187_SepcialInstructionsMandatory);ApexPages.addMessage(errormsg);return null;
                }
            }
            
            Savepoint SP = Database.setSavepoint();
            Database.UpsertResult SR = Database.upsert(RFPForm);
            if(SR.isSuccess())
            {
                if( AllIncumbentCarrierList != null && !AllIncumbentCarrierList.isEmpty())
                {
                    for (RFPFormWrapper wrappedForm :AllIncumbentCarrierList)
                    {
                        if(isCurrentTierBlank(wrappedForm.RFPFormRec, 'EC__c', 'EC_Renewal__c')) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,HighRoads_Constants.SHP_CURRENTTIER1_BLANKMSG + '(Deductible)');
                            ApexPages.addMessage(errormsg);
                            RFPForm.Id = null;
                            Database.rollback(sp);
                            return null;   
                        }
                        else if(isCurrentTierZero(wrappedForm.RFPFormRec, 'EC__c', 'EC_Renewal__c')) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,HighRoads_Constants.SHP_CURRENTTIER1_ZEROMSG + '(Deductible)');
                            ApexPages.addMessage(errormsg);
                            RFPForm.Id = null;
                            Database.rollback(sp);
                            return null;
                        }
                        else if(isCurrentTierBlank(wrappedForm.RFPFormRec, 'EE__c', 'EE_Renewal__c')) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,HighRoads_Constants.SHP_CURRENTTIER1_BLANKMSG + '(OOPM)');
                            ApexPages.addMessage(errormsg);
                            RFPForm.Id = null;
                            Database.rollback(sp);
                            return null;   
                        }
                        else if(isCurrentTierZero(wrappedForm.RFPFormRec, 'EE__c', 'EE_Renewal__c')) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,HighRoads_Constants.SHP_CURRENTTIER1_ZEROMSG + '(OOPM)');
                            ApexPages.addMessage(errormsg);
                            RFPForm.Id = null;
                            Database.rollback(sp);
                            return null;
                        }
                        else if(isCurrentTierBlank(wrappedForm.RFPFormRec, 'EF__c', 'EF_Renewal__c')) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,HighRoads_Constants.SHP_CURRENTTIER1_BLANKMSG + '(DOV)');
                            ApexPages.addMessage(errormsg);
                            RFPForm.Id = null;
                            Database.rollback(sp);
                            return null;   
                        }
                        else if(isCurrentTierZero(wrappedForm.RFPFormRec, 'EF__c', 'EF_Renewal__c')) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,HighRoads_Constants.SHP_CURRENTTIER1_ZEROMSG + '(DOV)');
                            ApexPages.addMessage(errormsg);
                            RFPForm.Id = null;
                            Database.rollback(sp);
                            return null;
                        }
                        else if(isCurrentTierBlank(wrappedForm.RFPFormRec, 'ES__c', 'ES_Renewal__c')) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,HighRoads_Constants.SHP_CURRENTTIER1_BLANKMSG + '(Specialist OV)');
                            ApexPages.addMessage(errormsg);
                            RFPForm.Id = null;
                            Database.rollback(sp);
                            return null;   
                        }
                        else if(isCurrentTierZero(wrappedForm.RFPFormRec, 'ES__c', 'ES_Renewal__c')) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,HighRoads_Constants.SHP_CURRENTTIER1_ZEROMSG + '(Specialist OV)');
                            ApexPages.addMessage(errormsg);
                            RFPForm.Id = null;
                            Database.rollback(sp);
                            return null;
                        }
                        else if(isCurrentTierBlank(wrappedForm.RFPFormRec, 'ECH__c', 'ECH_Renewal__c')) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,HighRoads_Constants.SHP_CURRENTTIER1_BLANKMSG + '(IP)');
                            ApexPages.addMessage(errormsg);
                            RFPForm.Id = null;
                            Database.rollback(sp);
                            return null;   
                        }
                        else if(isCurrentTierZero(wrappedForm.RFPFormRec, 'ECH__c', 'ECH_Renewal__c')) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,HighRoads_Constants.SHP_CURRENTTIER1_ZEROMSG + '(IP)');
                            ApexPages.addMessage(errormsg);
                            RFPForm.Id = null;
                            Database.rollback(sp);
                            return null;
                        }
                        else {
                            IncumbentCarriersToUpdate.add(wrappedForm.RFPFormRec);
                        }
                    }
                    if(!CheckCurrentTier && !IncumbentCarriersToUpdate.isEmpty())
                    {
                        Database.update(IncumbentCarriersToUpdate);
                        return new pageReference(System.Label.SHP_RFP_82+RFPForm.id);
                    }
                    else
                    {
                        Database.rollback(sp);
                    }
                }
            }
            return null;
        }
        catch(Exception codeException)
        {
            //ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,RECORDLOCKED);
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,codeException.getMessage() + 'at line: ' + codeException.getLinenumber());
            ApexPages.addMessage(errormsg);
            return null;
        }
    }
    
/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: To construct the URL of documents folder to download the template.                               *
*   @param........:                                                             *    
*   @return ......: URL to the template stored in documents                                                        *
*********************************************************************************/   
   public String getDocumentLogoUrl()
    {  
        List<Document> lstDocument = [Select Id,Name,LastModifiedById from Document 
                                      where Name =:Label.SHP_Data_Upload_Template limit 1];
        string strOrgId = UserInfo.getOrganizationId();
        string strDocUrl = System.Label.SHP_RFP_75+ApexPages.currentPage().getHeaders().get(System.Label.SHP_RFP_76)+ System.Label.SHP_RFP_77+lstDocument[0].Id+System.Label.SHP_RFP_78 + strOrgId;
        return strDocUrl ;
       
    }
   
 
/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: This function reads the CSV file and inserts records into the Census object. *
*   @param........:                                                             *    
*   @return ......: null                                                        *
*********************************************************************************/ 
    public Pagereference ReadFile()
    {
        //Convert the uploaded file which is in BLOB format into a string
        if(contentFile == null)
        {
            return null;
        }
        else
        { 
            if( contentFile.size() >= 400000)
            {
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, WARNINGMSG);ApexPages.addMessage(errormsg);return null;
            }
            
            nameFile = blobToString( contentFile,System.Label.SHP_RFP_93);
            Pattern DatePattern = Pattern.compile(REGEXDATE);
            Pattern ZipPattern = Pattern.compile(REGEXZIP);
                
            //Now sepatate every row of the excel file
            filelines = nameFile.split(System.Label.SHP_RFP_79);
            if(filelines.size() >= 10000)
            {
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, WARNINGMSG);ApexPages.addMessage(errormsg);return null;
            }
                 
            //Iterate through every line and create a Account record for each row
            censusDataToUpload = new List<Census__c>();
            
            Set<String> zipCodes = new Set<String>();
            for (Integer i=1;i<filelines.size();i++)
            {
                String[] inputvalues = new String[]{}; //List of string to store al values sperated by comma
                inputvalues = filelines[i].split(System.Label.SHP_RFP_92);
                zipCodes.add(inputvalues[3]);
            }
             //To get the data from Master Zip Code table. (Added as part of May Release Req-3830)
            List<Zip_Code_Master__c> zipCodeList = [Select Region__c, County__c, Zip_code__c from Zip_Code_Master__c 
                                                            where Zip_code__c IN :zipCodes limit 10000];
                                                            
            Map<String,Zip_Code_Master__c> zipCodesMap = new Map<String,Zip_Code_Master__c> ();
            for(Zip_Code_Master__c zcm :  zipCodeList){
              zipCodesMap.put(zcm.Zip_code__c , zcm);
            }                                        
            
            for (Integer i=1;i<filelines.size();i++)
                {
                    String[] inputvalues = new String[]{}; //List of string to store al values sperated by comma
                    inputvalues = filelines[i].split(System.Label.SHP_RFP_92);
                    Census__c census = new Census__c();
                    census.Opportunity__c = RelatedOpportunity.Id;
                    census.Gender__c = inputvalues[0];
                    
                    Matcher DateMatcher;
                    Matcher ZipMatcher;
                    boolean isValidDate = false;
                    boolean isValidZip = false;
                    boolean isBothValid;
                    boolean isBothInvalid;
                    try{
                    DateMatcher = DatePattern.matcher(inputvalues[1]);
                    if(!String.isEmpty(inputvalues[1])) 
                    {
                        
                        if(DateMatcher.Matches() && Date.parse(inputvalues[1]) < Date.Today()) 
                            {
                            
                                census.DOB__c = Date.parse(inputvalues[1]);
                                isValidDate = true;
                            }
                        else 
                            {
                                census.Format_Match_Boolean__c = true;
                                census.Status__c = ERRORSTATUS;   //CR in March Release
                                isValidDate = false;
                            }
                    }
                    else 
                    {
                        census.Format_Match_Boolean__c = true;
                        census.Status__c = ERRORSTATUS;   //CR in March Release
                        isValidDate = false;
                    }
                     }catch(Exception e){census.Format_Match_Boolean__c = true;census.Status__c = ERRORSTATUS;  }//CR in March Release
                    ZipMatcher = ZipPattern.matcher(inputvalues[3]);
                    if(!String.isEmpty(inputvalues[3])) 
                    {
                       
                        if( ZipMatcher.Matches()) 
                        {
                            census.Employee_Zip__c = inputvalues[3];
                            isValidZip = true;
                           
                        }
                        else 
                        {
                            census.Format_Match_Boolean__c = true;
                            census.Status__c = ERRORSTATUS;
                            isValidZip = false;
                        }
                    }
                    else
                    {
                        census.Format_Match_Boolean__c = true;
                        census.Status__c = ERRORSTATUS;
                        isValidZip = false;
                        
                      
                    }      
                    
                    census.Tier__c = inputvalues[2]; 
                    census.Plan__c = inputvalues[4];
                    
                    Zip_Code_Master__c  zm =  zipCodesMap.get(census.Employee_Zip__c);
                    if(zm == NULL)
                        {
                            
                            census.Region__c = Label.SHP_Region_Value;
                            census.County__c = Label.SHP_Region_Value;
                        }
                    else{
                                
                                census.Region__c = zm.Region__c;
                                census.County__c = zm.County__c;
                        }//End of Req-3830
                   
                    
                    if(isValidDate== false && isValidZip == false){
                        census.Error_Message__c = System.Label.SHP_RFP_97;
                    }else if(isValidDate== true && isValidZip == false){
                        census.Error_Message__c = System.Label.SHP_RFP_98;
                    }else if(isValidDate== false && isValidZip == true){
                        census.Error_Message__c = System.Label.SHP_RFP_99;
                    }else if(isValidDate== true && isValidZip == true){
                        census.Error_Message__c = '';
                        census.Status__c = SUCCESSSTATUS; 
                    }
                    
                    if( !String.isEmpty(inputvalues[1]) || !String.isEmpty(inputvalues[2]) || !String.isEmpty(inputvalues[3]) || !String.isEmpty(inputvalues[4]) ) 
                    {   
                            
                        censusDataToUpload.add(census);
                    }
                }
        
       }
               
    try{
               
        Database.insert(censusDataToUpload);
        string csvDataToSend = HEADER;
        List<Census__c > censusData;
        if( censusDataToUpload != null  && !censusDataToUpload.isEmpty() ) 
         {
            
            censusData = [ Select Id , Name FROM Census__c 
            WHERE Id IN :censusDataToUpload AND Format_Match_Boolean__c =:true limit 10000];
            for(Integer i=0; i<censusData.size();i++) 
            {
               string recordString = censusData[i].id+','+censusData[i].Name+ '\n';
               csvDataToSend = csvDataToSend + recordString;   
            }
          }
          
           if(censusData != null && !censusData.isEmpty() ){
           List<Opportunity> Owners =[Select Owner.Email FROM Opportunity where Id=:RelatedOpportunity.Id limit 10000];   
           List<String> ownerlist = new List<String>();
           for(Opportunity oppty : Owners)
            {
            ownerlist.add(oppty.owner.email);
            }  
            
           Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
           blob csvBlob = Blob.valueOf(csvDataToSend);
           string csvname= System.Label.SHP_RFP_80;
           csvAttc.setFileName(csvname);
           csvAttc.setBody(csvBlob);
           
           Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
           
           String subject = SUBJECTLINE;
           email.setSubject(subject);
           email.setToAddresses( ownerlist );
           email.setPlainTextBody(SUBJECTBODY );
           email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
           Messaging.SendEmailResult [] resultEmail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
          } 
            
        }catch (Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, ERRMSG  +e.getMessage());
            ApexPages.addMessage(errormsg);
        }    
         
         PageReference pageRef = ApexPages.currentPage();
         pageRef.setRedirect(true);
         return pageRef;
    }


/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: This function convers the input CSV file in BLOB format into a string*
*   @param........:                                                             *    
*   @return ......: converted string                                                        *
*********************************************************************************/
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode(System.Label.SHP_RFP_81 + String.join(bytes, System.Label.SHP_RFP_81), inCharset);
    }


/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: This function redirects User to the Cesus Upload page   *
*   @param........:                                                             *    
*   @return ......: page url.                                                        *
*********************************************************************************/    
    public pageReference getRedirectToCensusPage() {
        
        PageReference newCensusPage;
        newCensusPage = Page.VFP48_SHP_UploadCensusData;
        newCensusPage.getParameters().put(System.Label.SHP_RFP_87,RelatedOpportunity.Id);
        newCensusPage.getParameters().put(System.Label.SHP_RFP_86,RFPForm.recordTypeId);
        newCensusPage.setRedirect(true);
        return newCensusPage;
    }
   
/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .:  This function redirects the user to Opportunity detail page.*
*   @param........:                                                             *    
*   @return ......: page url.                                                        *
*********************************************************************************/   
  public PageReference RedirectToOpportunity() {
     
      PageReference newPage;
      if(RFPForm.id != null){
      newPage = new PageReference(System.Label.SHP_RFP_82 + RFPForm.Id );
      newPage.getParameters().put( System.Label.SHP_RFP_84, RFPForm.Id);
      newPage.getParameters().put(System.Label.SHP_RFP_83, System.Label.SHP_RFP_85);
      }
      else{
      newPage = new PageReference(System.Label.SHP_RFP_82 + RelatedOpportunity.Id );
      newPage.getParameters().put( System.Label.SHP_RFP_84, RelatedOpportunity.Id);
      newPage.getParameters().put(System.Label.SHP_RFP_83, System.Label.SHP_RFP_85);
      }
      return newPage.setredirect(true);
   }
    /********************************************************************************
    *   @author ......: Deloitte                                                    *  
    *   @date ........: 19-Apr-2016                                                 *  
    *   @description .: to render the Rejection Reason based Values                 *
    *   @User Story   : @SHP26 Rejection Reason Void Starts                         *
    *   @param........: none                                                        *    
    *   @return ......: List<SelectOption>                                          *
    *********************************************************************************/
    public List<SelectOption> getRejectionTypes() {

        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(System.Label.SHP_RFP_100_None,System.Label.SHP_RFP_100_None));
            options.add(new SelectOption(System.Label.SHP_RFP_101_Void,System.Label.SHP_RFP_101_Void));
        
        return options;

    }
    
    /********************************************************************************
    *   @author ......: Deloitte                                                    *  
    *   @date ........: 04-May-2017                                                 *  
    *   @description .: Returns true, if Current Tier is blank but Renewal has value*
    *   @User Story   : SHP44                                                       *
    *   @param........: Incumbent_Carrier__c RFPFormRec                             * 
                        String currentTierFieldAPI                                  *
                        String RenewalFieldAPI                                      *    
    *   @return ......: Boolean                                                     *
    *********************************************************************************/
    public Boolean isCurrentTierZero(Incumbent_Carrier__c RFPFormRec, String currentTierFieldAPI, String RenewalFieldAPI) {
        if(RFPFormRec.get(currentTierFieldAPI) != '' && RFPFormRec.get(currentTierFieldAPI) != null && Double.valueOf(RFPFormRec.get(currentTierFieldAPI)) == 0 && RFPFormRec.get(RenewalFieldAPI) != '' && RFPFormRec.get(RenewalFieldAPI) != null && Double.valueOf(RFPFormRec.get(RenewalFieldAPI)) != 0)
            return true;
        else
            return false;
    }
    
    /*********************************************************************************
    *   @author ......: Deloitte                                                     *  
    *   @date ........: 04-May-2017                                                  *  
    *   @description .: Returns true, if Current Tier is zero but Renewal has a value*
    *   @User Story   : SHP44                                                        *
    *   @param........: Incumbent_Carrier__c RFPFormRec                              * 
                        String currentTierFieldAPI                                   *
                        String RenewalFieldAPI                                       *    
    *   @return ......: Boolean                                                      *
    **********************************************************************************/
    public Boolean isCurrentTierBlank(Incumbent_Carrier__c RFPFormRec, String currentTierFieldAPI, String RenewalFieldAPI) {
        if((RFPFormRec.get(currentTierFieldAPI) == '' || RFPFormRec.get(currentTierFieldAPI) == null) && RFPFormRec.get(RenewalFieldAPI) != '' && RFPFormRec.get(RenewalFieldAPI) != null && Double.valueOf(RFPFormRec.get(RenewalFieldAPI)) != 0)
            return true;
        else
            return false;
    }
}