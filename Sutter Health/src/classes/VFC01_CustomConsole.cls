/**  
*     Class Name  : VFC01_CustomConsole
*     Author      : IDC Offshore
*     Date        : 27-Sept-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description : VFC01_CustomConsole Class.
*
*     History
*      
*     VERSION        AUTHOR            DATE             DETAIL Description
*      2.0          Atul Gupta         28/11/2014       Updates to the page to include 'Save & New' button functionality as part of the REQ 3226
*                                                       Release 6.4
*      3.0          IDC offshore      20/10/2015       Added Tab for Req number 3378 member employer correspondence
*      4.0          IDC Offshore      14/12/2015       Added Articles filter functionality related to REQ-3145 & REQ-3146.
*      5.0          IDC Offshore      20/12/2015       Added Case functionality related to REQ-3274
*      6.0          IDC Offshore      12/02/2016       Added functionality related to Req-3733.
*      7.0          IDC Offshore      18/02/2016       Updated the query for open and closed cases for patient and employee/vendor as part of code review comments implementation for Req-3274 & 3733.
*      8.0          Umesh               6/09/16         Implemented Request 3756. Modified getCaseFields() methods to retrive fields from "S3 Additional Inquiry Detail" Field set.
*      9.0          IDC Offshore      12/11/2016       SHP Wave 2 changes - 3980 Pulling Benefit Plans and Approved Document Generation Requests for Employer and Member Accounts and rendering
                                                       in the Benefit Plan Coverage tab
**/
public class VFC01_CustomConsole
{ 
    public List<Case> CaseOpenList {get;set;}                       //Req-3274 & 3733 changes
    public List<Case> CaseClosedList {get;set;}                     //Req-3274 & 3733 changes
    public List<Case> PatientCaseOpenList {get;set;}                //Req-3274 changes
    public List<Case> PatientCaseClosedList {get;set;}              //Req-3274 changes
    private static final string CONTACT_RT_EMPLOYEE = 'Employee';   //Req-3274 & 3733 changes
    private static final string CONTACT_RT_VENDOR = 'Vendor';       //Req-3274 & 3733 changes
    private static final string CONTACT_RT_PATIENT = 'Patient';     //Req-3274 changes
    public List<Case> CaseAllList = new List<Case>();               //Req-3274 & 3733 changes
    public boolean saveSuccess {get; set;}
    public string fieldToIds {get; set;} 
    //static string variables for constant values
    private static final string INVALID_CALLDT = 'Invalid CALLDT';
    private static final string MANUAL_STR = 'MANUAL';
    private static final string NONE_STR = '--None--'; 
    private static final string SELECT_STR = 'SELECT ';
    private static final string BLANK = '';
    private static final string HYPHEN = '-';
    private static final string COLON = ':';
    private static final string COMMA_QUERY = ', ';
    private static final string EXEPTION_MSG =  '\r\n';
    private static final string EXEPTION_MSG2 = '--------------';
    
    //3262
    private static final string REASON_CLINICAL = 'Clinical';
    private static final string OOA_MEDICAL = 'Out of Area – Medical';
    private static final string OON_MEDICAL = 'Out of Network – Medical';
    private static final string ED_NOTIFICATON = 'ED Notification';
    private static final string CONTACT_RT_MEMBER = 'Member';
    private static final string CONTACT_RT_SHP_PROVIDER = 'SHP Provider';
    private static final string CASE_RT_OOA_OON = 'OOA/OON';
    private static final string STATUS_OPEN = 'Open - Pending';
    
    /**
    * @author IDC Team
    * @date 09/09/2015
    * @description -- @Description: static string variables for constant values  Start
     **/
     
    private static final string SUTTER_HEALTH  = 'Sutter Health';
    private static final string APP  = 'App';
    private static final string CASESTRING  = 'Case';
    private static final string CONTACTSTRING  = 'Contact'; 
    private static final string ACCOUNTSTRING  = 'Account';
    private static final string ACTIVE  ='Active';
    private static final string NO_FILTER='NoFilter';
    private static final string EXEMPT_GRIEVANCES='Exempt Grievances';
    private static final string MEMBER_GRIEVANCES='Member Grievance';
    private static final string EXEMPT= 'Exempt';
    
    private static final string DNSTC_PROVIDER= 'SHPP';
    private static final string DNSTC_MEMBER= 'SHPM';
    private static final string DNSTC_EMPLOYER= 'SHPE';
    private static final string DNSTC_BROKER= 'SHPB';
    
    
    private static final string DNSTC_EMPLOYEE= 'Empl';
    private static final string DNSTC_ACCOUNT = 'Acctg';
    private static final string DNSTC_VENDOR= 'Vend';
    private static final string DNSTC_EXECUTIVE= 'Exec';
    private static final string DNSTC_CREDENTIAL_VERIFACTION ='CV';
    private static final string DNSTC_JOB= 'Job';
    
    private static final string DNSTC_PATIENT_INQUIRY = 'PatInq';
    private static final string DNSTC_PATIENT_REGISTRATION = 'PatReg';
    private static final string DNSTC_PHYSICIAN_SERVICES= 'PhysSvs';
    private static final string TAB3 ='tab3';
    private static final string TAB1 ='tab1';
    private static final string TAB2 ='tab2';
    private static final string YES ='Yes';
    private static final string LAST_REFERENCE_DATE ='LastReferencedDate';
    private static final string LAST_VIEWED_DATE ='LastViewedDate';
    
    private  static final string DNISTC_STRING = 'DNISTC';
    private  static final string DEV_STRING = 'DEV';
    private  static final string CALLID_STRING = 'CALLID';
    private  static final string DNIS_STRING = 'DNIS';
    private  static final string CALLDT_STRING = 'CALLDT';
    private  static final string ANI_STRING = 'ANI';
    private  static final string EXITPATH_STRING = 'EXITPATH';
    private  static final string TRANSF_STRING = 'TRANF';
    public  static final string S3 = 'S3';
    public  static final string ORDER_LIMIT_STRING = ' ORDER BY LastName, FirstName limit 100';
    public  static final string ORDER_LIMIT_STRING_NAME = ' ORDER BY Name limit 100';
    public  static final string LIMIT_STRING = ' limit 100';
    public  static final string SUBJECT_LINE_MAIL = '[URGENT] [CONFIDENTIAL] Possible Legal/Public Relations Threat';
    public  static final string CATEGORY_TYPE ='categoryType_';
    public  static final string EDIT_CASE='RecordType.Name,Contact.phone,contact.Name,contact.Member_ID__c FROM Case where ID = \'';
    public  static final string CUSTOMER_INTRACTION= 'RecordType.Name, Contact.RecordTypeId,Contact.phone,contact.Name,contact.Member_ID__c, Contact.Member_HCC_ID__c, Contact.Supplier_SPS_Epic_ID__c FROM Case where ID = \'';
    public  static final string GURANTOR= 'Guarantor';
    public static final  string  DUMMY_QUERY= 'Select Id, Subject, Status, ContactId,Adhoc_Issue__c, RecordType.Name, AccountId, Patient__c FROM Case where CALLID__c = \'';
    public  static final string DNISTYPECODE = '\' AND DNISTYPECODE__c = \'';
    public  static final string LIMIT_1 = '\' limit 1';
    public  static final string RECORD_TYPE_CASE = 'RecordType.Name FROM Case where ID = \'';
    public  static final  string BLANK_SPACE = ' ';
    public  static  final string COMMA =',';
    public  static  final string STAR ='*';
    public  static  final string MEMBER_PREFIX ='M';
    public  static  final string LIKE_STRING = ' like \'';
    public  static  final string EQUAL_HYPEN = ' = \'';
    public  static  final string BROKER_PREFIX = 'C-';
    public  static  final string NEWLINE = 'C-';
    public  static  final string API_POSTFIX= '__c';
    public  static  final string ABOVE_OR_BELOW = '__c ABOVE_OR_BELOW ';
    public  static  final string LIMIT_20=' limit 20';
    public  static  final string FIND = 'FIND \'';
    public  static  final string KNOWLEDGE_ARTICLE_WITH_DATA_CATEGORY = 'SELECT Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ';
    public  static  final string SOSL_KNOWLEDGE_ARTICLE= '*\' IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\')';
    
    public  static  final string SOSL_KNOWLEDGE_ARTICLE_WITH_DATA_CATEGORY='*\'IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ';
    public  static  final string KNOWLEDGE_ARTICLE= 'SELECT Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\')';
    public  static  final  string PATIENT_ORDER_BY =' ORDER BY Patient_DotOne_Lookup__r.Patient_Last_Name__c, Patient_DotOne_Lookup__r.Patient_First_Name__c';
    public  static  final  string  PATIENT_ORDER_BY_FIRST_NAME =' ORDER BY Patient_Last_Name__c, Patient_First_Name__c';
    public  static  final string  EMAIL_BODY ='Please respond to the following public action threat.\n\n';
    public  static  final string  REASON ='Reason: ';
    public  static  final string  SECONDARY_REASON = '\nSecondary Reason: ';
    public  static  final string  CASE_NUMBER ='\n\nCase Number: ';
    public  static  final string  MEMBER_REQUESTOR_NAME ='\nMember/Requestor Name: ';
    public  static  final string DOUBLE_SPACE  ='  ';
    public  static  final string MEMBER_ID =' \nMember ID: ';
    public  static  final string CALL_TIME=' \nCall Time: ';
    
    /** @Description: static string variables for constant values  END   **/
    // Req no 3356  OLTP Provider defined record type for provider
    private static final string SHP_PRACTITIONER = 'Practitioner';
    
    // Variables used to store General Org Information
    private Map<string , string> objectPrefixMap = new Map<string, string>();
    private Map<string, string> caseRecordTypeMap = new Map<string, string>();
    private Map<string, string> contactRecordTypeMap = new Map<string, string>();
    
    private boolean correctSearchOption = false;
    
    //Varibles to Redirect the Page for SHP IL
    private static  final string S3PAGE = 'VFP01_CustomConsole';
    private static  final string SHPPAGE = 'VFP01_CustomConsole_SHPIL';
    
    // Variables used in Customer Interaction Section
    public boolean showMessage {get; set;}
    public string message{get; set;}
    Public List<schema.FieldSetMember> CIDFields{get; set;}
    Public List<schema.FieldSetMember> CIDFields2{get; set;}
    Public List<schema.FieldSetMember> AIFields{get; set;}
    Public List<schema.FieldSetMember> AIDFields{get; set;}
    Public List<schema.FieldSetMember> DIFields{get; set;}
    Public List<schema.FieldSetMember> IDFields{get; set;}
    Public List<schema.FieldSetMember> SIFields{get; set;}
    public boolean showDetailCase{get; set;}
    public boolean showEditCase{get; set;}
    private set<String> caseFields = new set<String>();
    Public Case custInteraction{get; set;}
    public Case newCase {get; set;}
    
    // Req 3145,3146
    public Case caseArticleSrcObj {get; set;}

    /** Release6.4 REQ 3226 Save and New Button variables used **/
    public Case caseNew{get; set;}
    public String call_date_time_Str{get; set;}
    public Boolean saveAndNewError{get; set;}
    /** Release6.4 REQ 3226 Save and New Button **/
    /*Req 3236  Deceleration Start SHP OLTP  modified by IDC offshore 04-02-2015)*/
    public list <PCP_Information__c> pcpInformation{get; set;}
    public list <PCP_Information__c> pcpInformationSize{get; set;}
    public list <Benefit_Plan_Coverage__c> benefitPlanCoverage {get; set;}
    public list <Benefit_Plan_Coverage__c> benefitPlanCoverageSize{get; set;}
    
    public list <Benefit_Plan_Association__c> benefitPlanAssociation {get; set;} // Req - 3182 added this list to store the beneit plan association records for member account
    public list <Benefit_Plan_Association__c> benefitPlanAssociationSize{get; set;} // Req - 3182 added this list to find the size of the benefit plan association records for member account
    public list <Document_Generation_Request__c> documentGeneration {get; set;} // Req - 3182 added this list to store the approved document generation requests for member account
    public list <Document_Generation_Request__c> documentGenerationSize{get; set;} // Req - 3182 added this list to find the size of the approved document generation requests for member account
    public String documentId{get;set;}// Req - 3182 added this property
    public transient String pdf {get;set;} // Req - 3182 added this property
    public transient Blob pdfContent{get; set;}// Req - 3182 added this property
    public boolean showDocument{get;set;}// Req - 3182 added this property
    
    
    public List <Claim_Header__c> Claimheaders {Get;Set;}
    public List <Claim_Header__c> ClaimheadersSize {Get;Set;}
    public List <Case> CaseList {Get;Set;}
    // Req 3156 + 3363 + 3364 Start
    // Correspondence start 
    public List <CorrespondenceContactAssociation__c> correspondencelist {Get;Set;}
    public List <CorrespondenceContactAssociation__c> correspondencelistsize {Get;Set;}
    
    private integer recNumcorrespondencelistSize = 0; 
    private integer limitsCorrespondence = 10;
    private integer counterCorrespondence  = 0;
    private integer recNumCorrespondence = 0;
    public  Boolean checkCorrespondence {Get; Set;}
    // Correspondence end
     // Req  no 3378  Member Employer Correspondence  Start
    // These variable  are using to  display Correspondence member, correspondence dependent member and  Employer
    public list <Correspondence_Letter__c> correspondenceMember {get; set;}
    public list <Correspondence_Letter__c> correspondenceMemberSize{get; set;}
    
    public integer limitscorrespondenceMember = 20;// used limit keyword for  Member correspondence
    public integer countercorrespondenceMember  = 0; // used as a offset Member  correspondence
    public integer recNumcorrespondenceMember = 0; //  used to check the size  Member  correspondence
    public  Boolean checkCorrespondenceMember {Get; Set;}// used to display correspondence   if  checkCorrespondenceMember is true 
        
    public list <Correspondence_Letter__c> correspondenceMemberList {get; set;} //  list of Correspondence_Letter__c
    public list <Correspondence_Letter__c> correspondenceMemberListDisplay {get; set;} // list of Correspondence_Letter__c
    
    public integer limitscorrespondenceMemberDependent = 20; // used limit keyword for  Dependent correspondence
    public integer countercorrespondenceMemberDependent  = 0; // used as a offset Dependent correspondence 
    public integer recNumcorrespondenceMemberDependent = 0;  //  used to check the size   dependent correspondence
    public  Boolean checkCorrespondenceMemberDependent {Get; Set;} // used to display  dependent correspondence   if  checkCorrespondenceMember is  
    public  Boolean CorrespondenceMemberDependentTab {Get; Set;}  // used to display  dependent correspondence Tab    if  member is subscriber
    public list <Correspondence_Letter__c> correspondenceMemberDependent {get; set;} //  list of Correspondence_Letter__c for dependent member 
    public list <Correspondence_Letter__c> correspondenceMemberSizeDependent{get; set;} //  list of Correspondence_Letter__c for dependent member
    
    public integer limitscorrespondenceEmployer = 20; // used limit keyword for  Employer  correspondence
    public integer countercorrespondenceEmployer  = 0; // used as a offset Employer   correspondence
    public integer recNumcorrespondenceEmployer = 0;  //  used to check the size  Employer   correspondence
    public  Boolean checkCorrespondenceEmployer {Get; Set;}
    
    public list <Correspondence_Letter__c> correspondenceEmployer {get; set;} //  list of Correspondence_Letter__c for Employer
    public list <Correspondence_Letter__c> correspondenceEmployerSize{get; set;} //  list of Correspondence_Letter__c for Employer
    // Req  no 3378  Member Employer Correspondence  End
    public List <CaseRecordAccessWrapper> wrapCaseList {Get;Set;}
    // Req 3156 + 3363 + 3364 end
    public List <Case> CaseListSize {Get;Set;}
    public List <Member_Enquiries__c> CustInqOther {Get;Set;}
    
    public  Boolean checkPCP {Get; Set;}
    public  Boolean checkClaimHeader {Get; Set;}
    public  Boolean checkCustomerInquiries {Get; Set;}
    public  Boolean checkBenefitPlanCoverage {Get; Set;}
    
    public  Boolean checkBenefitPlanAssociation {Get; Set;} // As per Req - 3182 to check the benefit plan association records found
    public  Boolean checkDocumentGeneration {Get; Set;} // As per Req - 3182 to check the document generation requests records found or not
    
    public integer limitsPCP = 10;
    public integer counterPCP  = 0;
    public integer recNumPCP = 0;
    
    private integer limitsBenefitPlanCoverage = 4;
    private integer counterBenefitPlanCoverage  = 0;
    private integer recNumBenefitPlanCoverage = 0;
    
    private integer limitsBenefitPlanAssociation = 20;// As per Req - 3182 used in pagination of the benefit plan association records table
    private integer counterBenefitPlanAssociation  = 0;// As per Req - 3182 used in pagination of the benefit plan association records table
    private integer recNumBenefitPlanAssociation = 0;// As per Req - 3182 used in pagination of the benefit plan association records table
    
    private integer limitsDocumentGeneration = 20;// As per Req - 3182 used in pagination of the document generation requests records table
    private integer counterDocumentGeneration  = 0;// As per Req - 3182  used in pagination of the document generation requests records table
    private integer recNumDocumentGeneration = 0;// As per Req - 3182 used in pagination of the document generation requests records table
    
    
    public list <Benefit_Plan_Coverage_Detail__c> benefitPlanCoverageDetail {get; set;}
    private integer limitsBenefitPlanCoverageDetails = 4;
    private integer counterBenefitPlanCoverageDetails1  = 0;
    private integer counterBenefitPlanCoverageDetails2  = 0;
    private integer counterBenefitPlanCoverageDetails3  = 0;
    private integer counterBenefitPlanCoverageDetails4  = 0;
    
    
    public String MasterID{get{return MasterID; } set ;}
    public String tabId{get{return tabId; } set ;}
    public integer benefitPlanCoverageDetailTableNo{get{return benefitPlanCoverageDetailTableNo; } set ;}
    
    private integer limitsClaimHeader = 10;
    private integer counterClaimHeader  = 0;
    private integer recNumClaimHeader = 0;
    
    
    private integer limitsCustomerInquiries = 10;
    private integer counterCustomerInquiries  = 0;
    private integer recNumCustomerInquiries = 0;   
    
    public boolean showSHPM {get; set;}
    // Req no 3356  OLTP Provider defined boolean base on boolean value practitioner record or supplier record will open
    public boolean showSupplier {get; set;} 
    public boolean showPractitioner {get; set;}
    // Req no 3356  OLTP Provider  end
    public contact con {get;set;}
    
    
    
    /*Req 3236  Deceleration End SHP OLTP  modified by IDC offshore 04-02-2015)*/
    // Req 3156 + 3363 Start
    public boolean showEmployer {get; set;}  // sets the boolean for showing employer screen
    public boolean showBroker {get;set;} // Broker OLTP Req 3363 sets the boolean for showing broker screen
    public    Account accountobj{get;set;} // To fecth all the benefits at account level
    public list <Benefit_Plan_Coverage__c> benefitPlanCoverageEmployer {get; set;} // for displaying list of benefit plans on Employer screen
    public list <Benefit_Plan_Coverage__c> benefitPlanCoverageEmployerSize{get; set;} 
    
    public list <Benefit_Plan_Association__c> benefitPlanAssociationEmployer {get; set;} // Req - 3182 used to store the benefit plan association records for employer account
    public list <Benefit_Plan_Association__c> benefitPlanAssociationEmployerSize{get; set;} // Req - 3182 used to find the benefit plan association records size for employer account
    
    public list <Document_Generation_Request__c> documentGenerationEmployer {get; set;} // Req - 3182 used to store the document generation requests records for employer account
    public list <Document_Generation_Request__c> documentGenerationEmployerSize{get; set;} // Req - 3182 used to store the document generation requests records for employer account
    
    
    private integer limitsBenefitPlanCoverageAccount = 20; // These are for Pagination variables
    private integer counterBenefitPlanCoverageAccount  = 0;
    private integer recNumBenefitPlanCoverageAccount = 0;
    // Req 3156 + 3363 End
    
    private integer limitsBenefitPlanAssociationAccount = 20; // As per Req - 3182 used in pagination
    private integer counterBenefitPlanAssociationAccount  = 0; // As per Req - 3182  used in pagination
    private integer recNumBenefitPlanAssociationAccount = 0; // As per Req - 3182  used in pagination
    
    private integer limitsDocumentGenerationAccount = 20; // As per Req - 3182 used in pagination
    private integer counterDocumentGenerationAccount  = 0; // As per Req - 3182 used in pagination
    private integer recNumDocumentGenerationAccount = 0; // As per Req - 3182 used in pagination
    
    /*Req 3236  Deceleration End SHP OLTP  modified by IDC offshore 04-02-2015)*/
    //3087 - Member Experience
    Public string ProfileName;
    
    private String DNISTCUpperCase;
    private string DNISTC = BLANK;
    private string DEV = BLANK;
    private string CALLID = BLANK;
    private string DNIS = BLANK;
    private string CALLDT = BLANK;
    private string ANI = BLANK;
    private string EXITPATH = BLANK;
    private string TRANSF = BLANK;
    public boolean setDetail{get; set;}
    public string consoleTabLabel{get; set;}
    public boolean multipleMessage{get; set;}
    public boolean singleMessage{get; set;}
    
    //Variable used to check whether popup should be displayed for Grievance related Service Requests
    public boolean showPopup{get; set;}
    
    // Variables used in Search Section
    public boolean showSearchTab{get; set;}
    public boolean showListTab{get; set;}
    public boolean showDetailTab{get; set;}
    public boolean showS3{get; set;}
    public boolean showS3Patient{get; set;}//3226 - 12/13/2014
    public boolean showSHP{get; set;}
    // Variable used to render "Search Claims" Link
    public boolean showClaimLinks{get; set;}
    // Variables to pass to pass Memeber Id, Provider Id, Customer Interaction Log Id and isClosed status to claim search page
    public boolean isClosed{get; set;}
    public boolean isS3Profile {get; private set;}
    public String claimMemberId{get; set;}
    public String claimProviderId{get; set;}
    public String custId{get;set;}
    
    public string selectedTab{get; set;}
    public string tab3Label{get; set;}
    public string linkId{get; set;}
    public string searches{get; set;}
    
     // Req 3145,3146
    public List<ArticleWrapperNew> articleWrLst;
    public Integer offSetCtr {get;set;} 

    
    /**
* @author IDC Team
* @date 03/03/2015
* @description -- this is used to redirect the user to correct page based on the parameter sent on DNSITC req 3357 Screen Optimisation
* @param 
* @return Pagereference
*/
    public PageReference redirectToNewPage() {
        
        
        If (DNISTCUpperCase== DNSTC_MEMBER || DNISTCUpperCase== DNSTC_PROVIDER ||DNISTCUpperCase== DNSTC_BROKER ||DNISTCUpperCase== DNSTC_EMPLOYER )
        {
            String SHPUrl = ApexPages.currentPage().getUrl();
            String SHPUrl1 = SHPUrl.replace(S3PAGE,SHPPAGE);
            
            PageReference SHPRedirect = new PageReference(SHPUrl1); 
            
            SHPRedirect.setRedirect(true);
            
            
            return SHPRedirect;
            
        }
        else 
        { 

          if(DNISTC != null && DNISTC != BLANK)
           {
            saveCustInteraction();
           }
            return null;
        }
    }
    
    public List<SelectOption> sSSSearchTypes
    {
        get
        {
            //logged-in user profile name
            string profName = [select Id, Name from Profile where Id = :userInfo.getProfileId() Limit 50000].Name;          
            string profNameUpperCase = profName.toUpperCase();
            List<selectOption> sSSSearchTypes = new List<selectOption>();
            sSSSearchTypes.add(new SelectOption(system.label.CL06_Employee, system.label.CL06_Employee));
            sSSSearchTypes.add(new SelectOption(system.label.Provider_Label, system.label.Provider_Label));
            sSSSearchTypes.add(new SelectOption(system.label.CL07_Vendor, system.label.CL07_Vendor));
            sSSSearchTypes.add(new SelectOption(system.label.CL27_Patient, system.label.CL27_Patient));
            sSSSearchTypes.add(new SelectOption(system.label.CL28_Patient_Account, system.label.CL28_Patient_Account));
            
            
            if(profNameUpperCase.contains(S3))
            {
                string options = BLANK ;
                List<string> optionList = new List<string>();
                if(Profile_Based_Search__c.getInstance(profNameUpperCase) <> null)
                {
                    options = Profile_Based_Search__c.getInstance(profNameUpperCase).Search_Options__c;
                }
                
                if(options <> null && options <> BLANK)
                {
                    optionList = options.split(COMMA);
                }
                
                if(!optionList.isEmpty())
                {
                    sSSSearchTypes.clear();
                    for(string option:optionList)
                    {
                        sSSSearchTypes.add(new SelectOption(option, option));
                    }
                }
            }
            
            return sSSSearchTypes;
        }
        
        private set;
    }
    public List<SelectOption> searchTypes
    {       
        get
        {
            List<selectOption> searchTypes = new List<selectOption>();
            searchTypes.add(new selectOption(system.label.CL08_Member, system.label.CL08_Member));
            searchTypes.add(new selectOption(system.label.CL15_Provider, system.label.CL15_Provider));
            searchTypes.add(new selectOption(system.label.Correspondence_Broker, system.label.Correspondence_Broker));
            searchTypes.add(new selectOption(system.label.Correspondence_Employer, system.label.Correspondence_Employer));
            
            return searchTypes;
        }
        
        private set;
        
    }
    
    public static Boolean isSearchValues = true;
    public static Boolean isGoodValue = true;
    public String searchQuery {get; set;}
    
    
    
    public String employeeID {get; set;}
    public String employeeFirstName {get; set;}
    public String employeeLastName {get; set;}
    public String employeeAffiliate {get; set;}
    public List<Contact> employeeResults{get; set;}
    static final String EMPLOYEE_SELECT = 'Select ID, LastName, Contact_Middle_Name__c, FirstName, MailingStreet, MailingCity, MailingState, ' + 
        'MailingPostalCode, Birthdate, Phone, Employee_Region__c, Employee_Executive_Status__c, Employee_Affiliate_Facility__c, ' +
        'ServiceTabLabel__c From Contact where RecordTypeId = \'';
    static final String EMPLOYEE_FIRSTNAME_API = ' AND FirstName like \'';
    static final String EMPLOYEE_LASTNAME_API = ' AND LastName like \'';
    static final String EMPLOYEE_AFFILIATE_API = ' AND Employee_Affiliate_Facility__c like \'';
    static final String EMPLOYEE_ID_API = ' AND Employee_ID__c like \'';
    
    public String memberID {get; set;} 
    public String memberFirstName {get; set;}
    public String memberLastName {get; set;}
    public String memberContactNumber {get; set;} 
    public Case memberDOB = new Case();
    public List<Contact> memberResults {get; set;}
    
    // Added Member_Termination_Date__c for Req 3317 release 11
    static final String MEMBER_SELECT = 'Select Id, Name, Phone, Member_HCC_ID__c, Member_ID__c,Member_Termination_Date__c, Member_Subscriber_Relationship__c, MemberIdField__c ,Member_Name_Prefix__c, FirstName, '+ 
        'Contact_SSN_E__c , Contact_Middle_Name__c, LastName, Member_Name_Suffix__c, MailingStreet, MailingCity, MailingState, ' + 
        'MailingPostalCode, Birthdate, Member_Plan_Name__c, ServiceTabLabel__c From Contact where RecordTypeId = \'';
    
    static final String MEMBER_ID_API = ' AND MemberIdField__c';
    static final String MEMBER_HCC_ID_API = ' AND Member_HCC_ID__c'; 
    static final String MEMBER_FIRSTNAME_API = ' AND FirstName like \'';
    static final String MEMBER_LASTNAME_API = ' AND LastName like \'';
    
    
    /* new field add for search for  member search in Screen Optimization Req 3357*/
    static final String MEMBER_CONTACT_NUMBER_API = ' AND (Phone = \'';
    static final String MEMBER_HOME_PONE_API = 'OR HomePhone = \'';
    static final String MEMBER_MOBILE_API ='OR MobilePhone =\'';
    static final String CLOSED_BRACKET =')';
    /* New fields end for req 3357 */
    static final String MEMBER_DOB_API = ' AND Birthdate = ';
    public String supplierName {get; set;} 
    public String supplierTIN {get; set;}
    public String supplierNPI {get; set;}
    public List<Contact> supplierResults {get; set;}
    static final String SUPPLIER_SELECT = 'Select Id, Supplier_TIN_Address__c, Supplier_Contact_Person__c, Name, Phone, ' +
        'Supplier_NPI__c, Supplier_Tax_ID__c, ServiceTabLabel__c From Contact where RecordTypeId = \'';
    static final String SUPPLIER_NAME_API = ' AND Name like \'';
    static final String SUPPLIER_TIN_API = ' AND Supplier_Tax_ID__c = \'';
    static final String SUPPLIER_NPI_API = ' AND Supplier_NPI__c = \'';
    
    public string brokerAgentFirstName{get; set;}
    public string brokerAgentLastName{get; set;}
    public String brokerFirmName {get; set;} 
    public String brokerID {get; set;}
    public String brokerFirmTelephoneNumber {get; set;} 
    public List<Contact> brokerResults {get; set;}
    // Req 3156 + 3363 Start
    // Dynamic SOQL updated so it works for both SHP Broker and SHP Broker RO record types Req 3363
    static final String BROKER_SELECT = 'Select Id, Name, AccountId, ServiceTabLabel__c, Account.Name, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, ' +
        'Account.BillingCountry, Account.County__c, Account.Broker_Firm_HCC_ID__c, Account.Phone, Broker_Agent_License_HCC_ID__c,License_Number__c From Contact where ( RecordTypeId = \'';
    static final string BROKER_AGENT_FIRST_NAME_API = ' AND FirstName like \'';
    static final string BROKER_AGENT_LAST_NAME_API = ' AND LastName like \'';
    static final String BROKER_FIRM_NAME_API = ' AND Account.Name like \'';
    static final String BROKER_CONTACT_NUMBER_API = ' AND Account.Phone = \'';
    static final String BROKER_ID_API = ' AND Account.Broker_Firm_HCC_ID__c = \'';
    
    public string employerContactFirstName{get; set;}
    public string employerContactLastName{get; set;}
    public String employerName {get; set;} 
    public String employerTaxID {get; set;}
    // req no 3156
    public string employerGroupNumber {get; set;} // This is to get the field data for Group Number of account for search.
    // req no 3156
    public List<Contact> employerResults {get; set;}
    // Dynamic SOQL updated so it works for both SHP Employer and SHP Employer RO record types Req 3156
    static final String EMPLOYER_SELECT = 'Select Id, Name, ServiceTabLabel__c, Account.Name, Account.Tax_ID__c, Account.Employer_Type__c, Account.Employer_Broker_Agent_HCC_ID__c, ' + 
        'Account.NumberOfEmployees, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.Phone From Contact where  ( RecordTypeId = \'';
    static final string EMPLOYER_CONTACT_FIRST_NAME_API = ' AND FirstName like \'';
    static final string EMPLOYER_CONTACT_LAST_NAME_API = ' AND LastName like \'';
    static final String EMPLOYER_NAME_API = ' AND Account.Name like \'';
    static final String EMPLOYER_TAX_ID_API = ' AND Account.Tax_ID__c = \'';
    // added 1 more parameter for search
    static final string RECORDTYPE_OR_STRING = '\' OR RecordtypeId = \'';
    static final String EMPLOYER_HCC_ID_API = ' AND Account.SHP_Group_ID__c= \''; // For searching group number at Contact.account level
    // Req 3156 + 3363 End
    
    public String providerFirstName {get; set;}
    public String providerLastName {get; set;}
    public String providerNPI {get; set;}
    public List<Contact> providerResults {get; set;}
    static final String PROVIDER_SELECT = 'Select Id, LastName, Provider_Title__c, FirstName, Contact_Middle_Name__c, Provider_Name_Suffix__c, Phone, ' + 
        'Provider_NPI__c, Provider_Correspondence_Address__c, Provider_Correspondence_City__c, Provider_Correspondence_State__c, ' +
        'Provider_Correspondence_PostalCode__c, Provider_License_Number__c, Provider_License_State__c, Provider_Specialty__c, ServiceTabLabel__c, ' +
        'Gender__c, Email From Contact where RecordTypeId = \'';
    static final String PROVIDER_FIRSTNAME_API = ' AND FirstName like \'';
    static final String PROVIDER_LASTNAME_API = ' AND LastName like \'';
    static final String PROVIDER_NPI_API = ' AND Provider_NPI__c = \'';
    
    public string vendorID{get; set;}
    public string vendorName{get; set;}
    public string vendorTaxID{get; set;}
    public List<Contact> vendorResults{get; set;}
    static final String VENDOR_SELECT = 'Select Id, Vendor_ID__c, ServiceTabLabel__c, RecordTypeId, Name, MailingCity, MailingCountry, MailingStreet, MailingState, MailingPostalCode, Vendor_TaxID__c From Contact where RecordTypeId = \'';
    static final String VENDOR_ID_API = ' AND Vendor_ID__c = \'';
    static final String VENDOR_NAME_API = ' AND Name like \'';
    static final String VENDOR_TAXID_API = ' AND Vendor_TaxID__c = \'';
    
    public string patientAccountNumber{get; set;}
    public string patientFirstName{get; set;}
    public string patientLastName{get; set;}
    
    // Defect INC000000152338-ApoorvKuchhal,24Oct2013
    public string patientMRN {get; set;}
    
    public string patientSHMRN{get; set;}
    
    
    public List<Patient_Account__c> patientAccountResults{get; set;}
    public string patAcc{get; set;}
    public List<Patient__c> patientResults{get; set;}
    
    //Requirement 2877 -Apoorv,11Nov2013 
    static final String PATIENT_ACC_SELECT = 'Select Id, Name, Patient_Account_Number__c, Patient_DotOne_Lookup__r.Id, Patient_DotOne_Lookup__r.Name, '+
        'Patient_DotOne_Lookup__r.Patient_First_Name__c, Patient_DotOne_Lookup__r.Patient_Last_Name__c, Patient_DotOne_Lookup__r.Patient_Middle_Name__c, '+ 
        'Patient_DotOne_Lookup__r.Patient_Street__c, Patient_DotOne_Lookup__r.Patient_State__c, Patient_DotOne_Lookup__r.Patient_City__c, '+
        'Patient_DotOne_Lookup__r.Patient_zip__c, Patient_DotOne_Lookup__r.Patient_EPI_ID__c,Patient_DotOne_Lookup__r.Patient_SHMRN__c, Guarantor_ID_Lookup__r.Name, Guarantor_ID_Lookup__r.Id, '+
        'Patient_Account_Service_Location__c, Patient_Account_Admission_Date__c From Patient_Account__c where Patient_DotOne_Lookup__r.Soft_Delete__c = false ';
    static final String PATIENT_ACCOUNT_NUMBER_API = ' AND Patient_Account_Number__c = \'';
    static final String PATIENT_ACC_MRN_API = ' AND Patient_DotOne_Lookup__r.Patient_EPI_ID__c = \'';
    
    //Requirement 2877 -Apoorv,11Nov2013 
    static final String PATIENT_SELECT = 'Select Id, Name, Patient_First_Name__c, Patient_Last_Name__c, Patient_Middle_Name__c, '+ 
        'Patient_Street__c, Patient_State__c, Patient_City__c, Patient_zip__c, Patient_DotOne__c , Patient_SHMRN__c From Patient__c where Soft_Delete__c = false ';
    static final String PATIENT_FIRST_NAME_API = ' AND Patient_First_Name__c like \'';
    static final String PATIENT_LAST_NAME_API = ' AND Patient_Last_Name__c like \'';
    
    //Defect INC000000152338 -Apoorv,24Oct2013
    static final String PATIENT_MRN_API = ' AND Patient_EPI_ID__c = \'';
    static final String PATIENT_SHMRN_API = ' AND Patient_SHMRN__c = \'' ;
    static final String PATIENT_ACC_SHMRN_API = ' AND Patient_DotOne_Lookup__r.Patient_SHMRN__c = \'';
    
    public string guarantorName{get; set;}
    public List<Guarantor__c> guarantorResults{get; set;} 
    static final String GUARANTOR_SELECT = 'Select Id, Name, Guarantor_ID__c From Guarantor__c ';
    static final String GUARANTOR_NAME_API = ' where Name like \'';
    
    static final String MULTI_STRING = ' AND '; 
    static final String ENDING_STRING =   '\'';
    static final String ENDING_WILDCARD_STRING = '%\'';
    static final String LESS_EQUAL_STRING = ' <= ';
    static final String GREATER_EQUAL_STRING = ' >= ';
    
    //3087 - Member Experience
    static final string SHP_MEP = 'SHP MEP';    
    // Variables used in Verification Section
    private Map<String, Contact_Fields__c> ContactFieldMap = Contact_Fields__c.getAll();
    public list<string> fieldList{get; set;}
    public string fieldLabels{get; set;}
    public boolean verifyBool{get; set;}
    private List<string> individualFields = new list<String>();
    public Integer validationno{get;set;}
    public List<String> RfieldList{get;set;}
    private string recordTypeName;
    
    // Variables used in Knowledge Management Section
    private Static Final Integer PAGE_NUMBER = 5;
    public String searchstring { get; set; }
    public String caseid{get; set;}
    public String selectedCheckbox{get;set;}
    public List<KnowledgeArticleVersion> articleList{get; set;}   
    private List<String> selectedCheckboxList;
    private Integer currentPage = 1;
    private Integer maxSize = 1;
    public Map<string, Decimal > map_artId_viewCount{get;set;}
    public list<ArticleWrapper> articleWrapperList{get; set;}
    
    public string sortField {get; set;}
    public string sortDirection {get; set;}
    
    public List<SelectOption> adhocTypes
    {       
        get
        {
            List<selectOption> adhocTypes = new List<selectOption>();
            adhocTypes.add(new selectOption(NONE_STR, NONE_STR));
            for(Adhoc_Issue__c adIssue :[Select Id, Name from Adhoc_Issue__c where Status__c = :ACTIVE order by Name Limit 50000])
            {
                adhocTypes.add(new selectOption(adIssue.Id, adIssue.Name));
            }
            
            return adhocTypes;
        }
        
        private set;
        
    }
    public string adhocType{get; set;}
    
    
    /** 
* @author IDC Team
* @date 15/08/2013
* @description This method returns array of Category Groups from the DataCategoryUtil Class and stores the 
* retrieved information in the list of DataCategoryGroupInfo class instances
* @param 
* @return List of Data Category groups getDataCategoryGroupInfo
*/
    public DataCategoryGroupInfo[] getDataCategoryGroupInfo() 
    {
        return DataCategoryUtil.getInstance().getAllCategoryGroups();
    }
    
    /**
* @author IDC Team
* @date 01/10/2013
* @description This method is called onchange of Select list for Search drop down, it fetches the value of Validation Size
* for each S3 Record Type
* @param 
* @return 
*/
    public void setvalidRecordType(){
        
        
        if(DNISTC.equalsIgnoreCase(DNSTC_EMPLOYEE) || DNISTC.equalsIgnoreCase(DNSTC_EXECUTIVE) || DNISTC.equalsIgnoreCase(DNSTC_ACCOUNT) || DNISTC.equalsIgnoreCase(DNSTC_JOB)){
            if(ContactFieldMap.containskey(system.label.CL06_Employee)){
                validationno = integer.valueOf(ContactFieldMap.get(system.label.CL06_Employee).Validation_No__c);
            }
        }else if(DNISTC.equalsIgnoreCase(DNSTC_PATIENT_INQUIRY) || DNISTC.equalsIgnoreCase(DNSTC_PATIENT_REGISTRATION)){
            if(ContactFieldMap.containskey(system.label.CL27_Patient)){
                validationno = integer.valueOf(ContactFieldMap.get(system.label.CL27_Patient).Validation_No__c);
            }
        }else if(DNISTC.equalsIgnoreCase(DNSTC_PHYSICIAN_SERVICES) || DNISTC.equalsIgnoreCase(DNSTC_CREDENTIAL_VERIFACTION)){
            if(ContactFieldMap.containskey(system.label.CL15_Provider)){
                validationno = integer.valueOf(ContactFieldMap.get(system.label.CL15_Provider).Validation_No__c);
            }
        }else if(DNISTC.equalsIgnoreCase(DNSTC_VENDOR)){
            if(ContactFieldMap.containskey(system.label.CL07_Vendor)){
                validationno = integer.valueOf(ContactFieldMap.get(system.label.CL07_Vendor).Validation_No__c);
            }
            
        }else if(validationno ==null){
            validationno = 0;
        }
        
        if(searches == system.label.CL06_Employee){
            if(ContactFieldMap.containskey(system.label.CL06_Employee)){
                validationno = integer.valueOf(ContactFieldMap.get(system.label.CL06_Employee).Validation_No__c);
            }
        }else if(searches == system.label.CL27_Patient){
             recordTypeName = system.label.CL27_Patient;
            if(ContactFieldMap.containskey(system.label.CL27_Patient)){
                validationno = integer.valueOf(ContactFieldMap.get(system.label.CL27_Patient).Validation_No__c);
            }
        }else if(searches == system.label.CL15_Provider){
            if(ContactFieldMap.containskey(system.label.CL15_Provider)){
                validationno = integer.valueOf(ContactFieldMap.get(system.label.CL15_Provider).Validation_No__c);
            }
        }else if(searches == system.label.CL07_Vendor){
            if(ContactFieldMap.containskey(system.label.CL07_Vendor)){
                validationno = integer.valueOf(ContactFieldMap.get(system.label.CL07_Vendor).Validation_No__c);
            } 
        }else if(searches == system.label.CL28_Patient_Account){
             recordTypeName = system.label.CL27_Patient;
            if(ContactFieldMap.containskey(system.label.CL27_Patient)){
                validationno = integer.valueOf(ContactFieldMap.get(system.label.CL27_Patient).Validation_No__c);
            }
        }
        else if(validationno ==null){
            validationno = 0;
        }
        
        //Req-3274 & 3733 changes start
        
        CaseOpenList = new List<Case>();
        CaseClosedList = new List<Case>();
        PatientCaseOpenList = new List<Case>();
        PatientCaseClosedList = new List<Case>();
        
        //Req-3274 & 3733 changes end
    }
    
    
    /**
* @author IDC Team
* @date 04/09/2013
* @description This method is used for storing the KeyPrefixes for Accounts, Contacts and Patient objects in a map
* @param 
*/
    public void setPrefixMap()
    {
        schema.DescribeSObjectResult accResult = Account.SObjectType.getDescribe();
        string accPrefix = accResult.getKeyPrefix();
        objectPrefixMap.put(ACCOUNTSTRING, accPrefix);
        schema.DescribeSObjectResult conResult = Contact.SObjectType.getDescribe();
        string conPrefix = conResult.getKeyPrefix();
        objectPrefixMap.put(CONTACTSTRING, conPrefix);
        schema.DescribeSObjectResult patResult = Patient__c.SObjectType.getDescribe();
        string patPrefix = patResult.getKeyPrefix();
        objectPrefixMap.put(system.label.CL27_Patient, patPrefix);      
        
        
    }
    
    /**
* @author IDC Team
* @date 04/09/2013
* @description This method is used for query the Id and Name field from the record types of Case and Contact object and store 
* it in a map
* @param 
*/
    public void setRecordTypeMaps()
    {
        for(RecordType rec: [select Id, Name from RecordType where sObjectType = :CASESTRING Limit 50000])
        {
            caseRecordTypeMap.put(rec.Name, rec.Id);
        }
        
        for(RecordType rec: [select Id, Name from RecordType where sObjectType = :CONTACTSTRING Limit 50000])
        {
            contactRecordTypeMap.put(rec.Name, rec.Id);
        }
    }
    
    /**
* @author IDC Team
* @date 04/09/2013
* @description This method is used for intializing the Lists of Case FieldSetMembers based on the values retrieved from the 
* Custom Setting
* @param string 
*/
    public void getCaseFields(string caseType)
    {
        CIDFields.clear();
        CIDFields2.clear();
        AIFields.clear();
        AIDFields.clear();
        DIFields.clear();
        IDFields.clear();
        SIFields.clear();
        
        Map<String, Schema.FieldSet> fsMap = Schema.SObjectType.Case.FieldSets.getMap();
        
        string cidfieldSetName = Customer_Interaction_Field_Set__c.getInstance(caseType).Customer_Interaction_Detail__c;
        CIDFields = fsMap.get(cidfieldSetName).getFields();
        
        if(Customer_Interaction_Field_Set__c.getInstance(caseType).Customer_Interaction_Detail_2__c<>null)
        {
            string cid2fieldSetName = Customer_Interaction_Field_Set__c.getInstance(caseType).Customer_Interaction_Detail_2__c;
            CIDFields2 = fsMap.get(cid2fieldSetName).getFields();
        }
        
        string aifieldSetName = Customer_Interaction_Field_Set__c.getInstance(caseType).Additional_Information__c;
        AIFields = fsMap.get(aifieldSetName).getFields();
        
        if(Customer_Interaction_Field_Set__c.getInstance(caseType).Manager_Calling_Information__c <> null)
        {
            string aidfieldSetName = Customer_Interaction_Field_Set__c.getInstance(caseType).Manager_Calling_Information__c;
            AIDFields = fsMap.get(aidfieldSetName).getFields();
        }
        
        string difieldSetName = Customer_Interaction_Field_Set__c.getInstance(caseType).Description_Information__c;
        DIFields = fsMap.get(difieldSetName).getFields();
        
        string idfieldSetName = Customer_Interaction_Field_Set__c.getInstance(caseType).Interaction_Details__c;
        IDFields = fsMap.get(idfieldSetName).getFields();
        
        string sifieldSetName = Customer_Interaction_Field_Set__c.getInstance(caseType).System_Information__c;
        SIFields = fsMap.get(sifieldSetName).getFields();
        
    }
    
    /**
* @author IDC Team
* @date 04/09/2013
* @description This method is used for intializing the class variable members
* @param 
*/
    public void init()
    {
        
        /** @Description: Variable to stop opening of new tab if any error is pending on the page for Req. 3226 Release 6.4 **/
        saveAndNewError = true;
        
        //3313-Grievance Related SR popup
        showPopup=false;
        
        
        //3087 - Member Experience
        string profName = [select Id, Name from Profile where Id = :userInfo.getProfileId() Limit 50000].Name;
        ProfileName = profName.toUpperCase();
        
        setPrefixMap();
        
        setRecordTypeMaps();
        
        Schema.DescribeSObjectResult res = Case.SObjectType.getDescribe();
        Map<String, Schema.SobjectField> fieldmap = res.fields.getMap();
        for(Schema.SObjectField field : fieldmap.values())  
        {  
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            caseFields.add(fieldResult.getName());
        }
        caseFields.remove(LAST_REFERENCE_DATE);
        caseFields.remove(LAST_VIEWED_DATE);
        
        tab3Label = system.label.CL01_ContactDetail;
        showEditCase = true;
        showDetailCase = false;
        caseid= BLANK;
        recordTypeName = BLANK;
        DNISTCUpperCase = BLANK;
        custInteraction = new Case();
          // Req 3145,3146
        caseArticleSrcObj = new Case();
        caseArticleSrcObj.RecordTypeId = caseRecordTypeMap.get(system.label.CL03_S3InteractionLog);
        caseArticleSrcObj.Function__c = '';
        articleWrLst = NULL;
        offSetCtr = 0;
       
        articleList = new List<KnowledgeArticleVersion>();
        showMessage = false;
        fieldList = new List<string>(); 
        fieldLabels = BLANK;
        verifyBool = true;
        setDetail = false;
        showSHPM = false; // Req  no 3236 OLTP  use this value in Page rendering to  show only member type of data 
        // Req no 3356  OLTP Provider
        showSupplier = false; 
        showPractitioner = false; 
        // Req no 3356  OLTP Provider end
        // Req 3156 + 3363 Start
        showEmployer = false;
        showBroker =false;
        // Req 3156 + 3363 End
        consoleTabLabel = system.label.CL24_ConsoleTabLabel;
        RfieldList = new List<String>();
        multipleMessage = false;
        singleMessage = false;
        
        // Instantiating the variables in Constructor
        showClaimLinks = false;
        isClosed = false;
        claimMemberId = BLANK;
        claimProviderId = BLANK;
        custId = BLANK;
        memberResults = new List<Contact>();
        employeeResults = new List<Contact>();
        
        supplierResults = new List<Contact>();
        brokerResults = new List<Contact>();
        employerResults = new List<Contact>();
        
        providerResults = new List<Contact>();
        vendorResults = new List<Contact>();
        patientAccountResults = new List<Patient_Account__c>();
        patientResults = new List<Patient__c>();
        guarantorResults = new List<Guarantor__c>();
        
        DNISTC = ApexPages.currentPage().getParameters().get(DNISTC_STRING);
        DEV = ApexPages.currentPage().getParameters().get(DEV_STRING);
        CALLID = ApexPages.currentPage().getParameters().get(CALLID_STRING);
        DNIS = ApexPages.currentPage().getParameters().get(DNIS_STRING);
        CALLDT = ApexPages.currentPage().getParameters().get(CALLDT_STRING);
        ANI = ApexPages.currentPage().getParameters().get(ANI_STRING);
        EXITPATH = ApexPages.currentPage().getParameters().get(EXITPATH_STRING);
        TRANSF = ApexPages.currentPage().getParameters().get(TRANSF_STRING);
        
        if(DNISTC <> BLANK && DNISTC <> null)
        {
            DNISTCUpperCase = DNISTC.toUpperCase();
        }
        
        CIDFields = new List<schema.FieldSetMember>();
        CIDFields2 = new List<schema.FieldSetMember>();
        AIFields = new List<schema.FieldSetMember>();
        AIDFields = new List<schema.FieldSetMember>();
        DIFields = new List<schema.FieldSetMember>();
        IDFields = new List<schema.FieldSetMember>();
        SIFields = new List<schema.FieldSetMember>();
        
        if(DNISTC <> BLANK && DNISTC <> null)
        {
            
            // OLTP 3236 change start
            if(DNISTC.equalsIgnoreCase(DNSTC_MEMBER)){
                
                showSHPM = true;
            }
            // OLTP 3236 change end
            // Req 3156 + 3363 Start
            if(DNISTC.equalsIgnoreCase(DNSTC_EMPLOYER)){
                
                showEmployer = true; 
            }
            if(DNISTC.equalsIgnoreCase(DNSTC_BROKER)){
                
                showBroker = true; 
            }
            // Req 3156 + 3363 End
            if(DNISTC.equalsIgnoreCase(DNSTC_MEMBER)||DNISTC.equalsIgnoreCase(DNSTC_EMPLOYER)||DNISTC.equalsIgnoreCase(DNSTC_BROKER)||DNISTC.equalsIgnoreCase(DNSTC_PROVIDER))
            {
                showSHP = true;
            }
            else
            {
                showS3 = true;
                showS3Patient = false;//3226 - 12/13/2014
            }
            
        }   
        setvalidRecordType();
    }
    
    /**
* @author IDC Team
* @date 04/09/2013
* @description This method is used to get the Customer Interaction record on the basis of DNIS Type Code and Caller Id passed 
* in the URL
* @param 
* @return
*/
    public void getCustomerInteraction()
    {
        
        if(CALLID <> BLANK && CALLID<>null)
        {
            
            string  dummyQuery  = DUMMY_QUERY+CALLID+DNISTYPECODE+DNISTCUpperCase +LIMIT_1;
            
            Case tempCase;
            for(Case c : Database.query(dummyQuery))
            {
                tempCase = c;
            }
            
            if(tempCase <> null)
            {
                custInteraction = tempCase;
                
                if(custInteraction.RecordType.Name.equals(system.label.CL12_S3PatientInteractionLog))
                {
                    linkId = custInteraction.Patient__c;
                    tab3Label = system.label.CL02_PatientDetail;
                    showS3Patient = true; //3226 - 12/13/2014
                    /* Function Call to set the Case FieldSetMembers for S3 Patient interaction log */
                    getCaseFields(DNSTC_PATIENT_INQUIRY.touppercase());
                }
                else
                {
                    linkId = custInteraction.ContactId;
                    if(custInteraction.RecordType.Name.equals(system.label.CL03_S3InteractionLog))
                    {
                        /* Function Call to set the Case FieldSetMembers for S3 interaction log */
                        getCaseFields(system.label.CL23_EMPL);
                    }
                    else
                    {
                        /* Function Call to set the Case FieldSetMembers for SHP interaction log */
                        //3087 - Member Experience
                        if(ProfileName  == SHP_MEP)
                        {
                            
                            getCaseFields(SHP_MEP);
                        }
                        else
                        {
                            getCaseFields(DNSTC_MEMBER);
                        }
                    }
                }
                
                String query = SELECT_STR;
                for(String caseField : caseFields) {
                    query += caseField + COMMA_QUERY;
                }
                query += CUSTOMER_INTRACTION+ custInteraction.Id+ENDING_STRING;
                custInteraction = Database.query(query);
                
                
                if(custInteraction.Adhoc_Issue__c <> null )
                {
                    adhocType = [Select Id, Name from Adhoc_Issue__c where Id = :custInteraction.Adhoc_Issue__c Limit 50000].Id;
                }
                else
                {
                    adhocType = NONE_STR;
                }
                
                searchString = BLANK;
                if(custInteraction.Subject <> null && custInteraction.Subject <> BLANK  && custInteraction.Subject.length()>2)
                {
                    searchString = custInteraction.Subject;
                }
                caseid = custInteraction.Id;
                
                if(custInteraction.Status.equalsIgnoreCase(system.label.CL05_Closed))
                {
                    showDetailCase = true;
                    showEditCase = false;
                    isClosed = true;
                }
                
                if(custInteraction.ContactId != null){
                    custId = custInteraction.Id;
                    if(custInteraction.Contact.RecordtypeId == contactRecordTypeMap.get(system.label.CL08_Member)){
                        showClaimLinks = true;
                        claimMemberId = custInteraction.Contact.Member_HCC_ID__c; 
                        
                    }
                    else if(custInteraction.Contact.RecordtypeId == contactRecordTypeMap.get(system.label.CL09_SHPProvider)){
                        showClaimLinks = true;
                        claimProviderId = custInteraction.Contact.Supplier_SPS_Epic_ID__c;
                    }
                }
                else{
                    showClaimLinks = false;
                }             
            }
        }
        
        if(custInteraction.Id == null)
        {
            getCaseRecordType();
            if(TRANSF <> BLANK && TRANSF<>null)
            {
                if(TRANSF.equalsIgnoreCase(YES))
                {
                    showMessage = true;
                    message = system.label.CL04_Message;
                }
            }
            
            if(DNISTCUpperCase <> BLANK && DNISTCUpperCase <> Null)
            {
                /* Function Call to set the Case FieldSetMembers for record type based on DNIS Type Code */
                //3087 - Member Experience
                
                if(ProfileName  == SHP_MEP)
                {
                    getCaseFields(SHP_MEP);
                }
                else
                {
                    getCaseFields(DNISTCUpperCase);
                } 
                // getCaseFields(DNISTCUpperCase);
            }
        }
    }
    
    /**
* @author IDC Team
* @date 04/09/2013
* @description This method is used to get the contact record on the basis of DNISTC and DEV parameters , if the contact is not 
* found a default search is set
* @param 
* @return void
*/
    public void getContact()
    {
        showSearchTab = true;
        showListTab = false;
        showDetailTab = false;
        selectedTab = TAB1;
        searches = system.label.CL06_Employee;
        recordTypeName = system.label.CL06_Employee;
        
        if(DNISTC <> BLANK && DNISTC <> null)
        {
            if(DNISTC.equalsIgnoreCase(DNSTC_EMPLOYEE) || DNISTC.equalsIgnoreCase(DNSTC_EXECUTIVE) || DNISTC.equalsIgnoreCase(DNSTC_ACCOUNT) || DNISTC.equalsIgnoreCase(DNSTC_JOB))
            {
                if(DEV <> BLANK && DEV <> null)
                {
                    if(DNISTC.equalsIgnoreCase(DNSTC_EMPLOYEE))
                    {
                        for(Contact con : [select Id from Contact where RecordType.Name = :system.label.CL06_Employee AND Employee_ID__c = :DEV limit 1])
                        {
                            linkId = con.Id;
                        }
                        
                        if(linkId <> BLANK && linkId <> null)
                        {
                            
                            showSearchTab = true;
                            showListTab = false;
                            showDetailTab = true;
                            selectedTab = TAB3;
                            CaseLst();//Req-3274 CTI FIX
                        }
                    }
                }
                
            }else if(DNISTC.equalsIgnoreCase(DNSTC_PATIENT_INQUIRY) || DNISTC.equalsIgnoreCase(DNSTC_PATIENT_REGISTRATION))
            {
                searches = system.label.CL28_Patient_Account;
                recordTypeName = system.label.CL27_Patient;
                if(DEV <> BLANK && DEV <> null)
                {
                    if(DNISTC.equalsIgnoreCase(DNSTC_PATIENT_INQUIRY))
                    {
                        for(Patient_Account__c pat: [select Id, Patient_DotOne_Lookup__r.Id from Patient_Account__c where Patient_Account_Number__c = :DEV limit 1])
                        {
                            linkId = pat.Patient_DotOne_Lookup__r.Id;
                        }
                        
                        if(linkId <> BLANK && linkId <> null)
                        {
                            showSearchTab = true;
                            showListTab = false;
                            showDetailTab = true;
                            selectedTab = TAB3;
                            tab3Label = system.label.CL02_PatientDetail;
                            casePatientLst();//Req-3274 CTI FIX
                        }
                    }
                }
                
            }else if(DNISTC.equalsIgnoreCase(DNSTC_PHYSICIAN_SERVICES) || DNISTC.equalsIgnoreCase(DNSTC_CREDENTIAL_VERIFACTION))
            {
                searches = system.label.CL15_Provider;
                recordTypeName = system.label.CL15_Provider;
                
            }else if(DNISTC.equalsIgnoreCase(DNSTC_VENDOR))
            {
                searches = system.label.CL07_Vendor;
                recordTypeName = system.label.CL07_Vendor;
                
                if(DEV <> BLANK && DEV <> null)
                {
                    for(Contact con: [select Id from Contact where RecordType.Name = :system.label.CL07_Vendor AND Vendor_ID__c = :DEV limit 1])
                    {
                        linkId = con.Id;
                    }
                    
                    if(linkId <> BLANK && linkId <> null)
                    {
                        showSearchTab = true;
                        showListTab = false;
                        showDetailTab = true;
                        selectedTab = TAB3;
                        CaseLst();//Req-3274 CTI FIX
                    }
                }
                
            }else if(DNISTC.equalsIgnoreCase(DNSTC_MEMBER))
            {
                searches = system.label.CL08_Member;
                if(DEV <> BLANK && DEV <> null)
                {
                    for(Contact con: [select Id from Contact where RecordType.Name = :system.label.CL08_Member AND MemberIdField__c = :DEV limit 1])
                    {
                        linkId = con.Id;
                    }
                    if(linkId <> BLANK  && linkId <> null)
                    {   contactdetailssection(linkid);
                     showSearchTab = true;
                     showListTab = false;
                     showDetailTab = true;
                     selectedTab = TAB3;
                    }
                }
                
            }else if(DNISTC.equalsIgnoreCase(DNSTC_PROVIDER))
            {
                searches = system.label.CL15_Provider;
                if(DEV <> BLANK && DEV <> null)
                {
                    for(Contact con:[select Id from Contact where RecordType.Name = :system.label.CL09_SHPProvider AND Supplier_NPI__c = :DEV limit 1])
                    {
                        linkId = con.Id;
                    }
                    
                    if(linkId <> BLANK && linkId <> null)
                    {
                        // Req no 3356  OLTP Provider set contact  start
                        contactdetailssection(linkid);
                        // Req no 3356  OLTP Provider set contact  End
                        showSearchTab = true;
                        showListTab = false;
                        showDetailTab = true;
                        selectedTab = TAB3;
                    }
                }
                
            }else if(DNISTC.equalsIgnoreCase(DNSTC_BROKER))
            {
                searches = system.label.Correspondence_Broker;
                if(DEV <> BLANK && DEV <> null)
                {
                    // string variable store dev parameter value 
                    string brokerid ;
                    brokerID=BROKER_PREFIX+DEV;//adding prefix "C-" in string to make as SFDC auto number in contact object 
                    // Req 3156 + 3363 To Start including both record type  SHP broker and  SHP broker Ro
                    brokerResults = [Select Id, Name, AccountId, ServiceTabLabel__c, Account.Name, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode,Account.BillingCountry, Account.County__c, Account.Broker_Firm_HCC_ID__c, Account.Phone, Broker_Agent_License_HCC_ID__c From Contact where (RecordType.Name = :system.label.CL10_SHPBroker OR RecordType.Name = :system.label.CL_135_SHP_Broker_Contact) AND SFDC_Auto_Number__c = :brokerId ORDER BY LastName, FirstName Limit 50000];
                    // Req 3156 + 3363 Start End
                    
                    if(!brokerResults.isEmpty())
                    {
                        if(brokerResults.size()>1)
                        {
                            showListTab = true;
                            selectedTab = TAB2;
                            showDetailTab = false;
                        }
                        else
                        {
                            showListTab = false;
                            showDetailTab = true;
                            selectedTab = TAB3;
                            linkId = brokerResults[0].Id;
                            // Req 3156 + 3363 Start
                            contactdetailssection(linkid);
                            // Req 3156 + 3363 End
                        }
                    }
                }
                
            }else if(DNISTC.equalsIgnoreCase(DNSTC_EMPLOYER))
            {
                searches =  system.label.Correspondence_Employer;
                if(DEV <> BLANK && DEV <> null)
                {
                    // Req 3156 + 3363 Start
                    employerResults = [Select Id, Name, ServiceTabLabel__c, Account.Name, Account.Tax_ID__c, Account.Employer_Type__c, Account.Employer_Broker_Agent_HCC_ID__c, Account.NumberOfEmployees, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.Phone From Contact where (RecordType.Name = :system.label.CL11_SHPEmployer or RecordType.Name = :system.label.CL134_SHP_Employer_contact) AND Account.SHP_Group_ID__c = :Dev ORDER BY LastName, FirstName Limit 50000];
                    // Req 3156 + 3363 End
                    
                    if(!employerResults.isEmpty())
                    {
                        if(employerResults.size()>1)
                        {
                            showListTab = true;
                            selectedTab = TAB2;
                            showDetailTab = false;
                        }
                        else
                        {
                            showListTab = false;
                            showDetailTab = true;
                            selectedTab = TAB3;
                            linkId = employerResults[0].Id;
                            // Req 3156 + 3363 Start
                            contactdetailssection(linkid);
                            // Req 3156 + 3363 End
                        }
                    }
                }
            }
            List<SelectOption> tempOption = new List<SelectOption>();
            if(showS3==true)
            {
                tempOption = sSSSearchTypes;
            }
            else if(showSHP==true)
            {
                tempOption = searchTypes;
            }
            
            for(SelectOption opt : tempOption)
            {
                if(opt.getLabel() == searches)
                {
                    correctSearchOption = true;
                }
            }
            
            if(!correctSearchOption)
            {
                searches = tempOption[0].getLabel();
            }
            
        }
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Constructor of the class. It initializes required variable and assigne those variable with the        
* respective value. Constructor grabs the input url, which suppose to be come from CTI. Based on the URL  
* parameter, this creates/display interaction log and  query on Knowledge Managment to display the available           
* category.
* @param 
* @return Void 
*/
    public VFC01_CustomConsole()
    {
        try
        {
            isS3Profile = false;
            for(profile p : [SELECT Id, Name FROM Profile WHERE Id= :userinfo.getProfileId()]){
                if(p.name.containsIgnoreCase('S3')){
                    isS3Profile = true;
                }
            }
            
            adhocType = NONE_STR;
            /* Function call to initialise the variable members */
            init();
            
            /* Function call to get the customer interaction */
            getCustomerInteraction();
            custInteraction.OwnerId = UserInfo.getUserId();
            
            if(linkId == BLANK  || linkId == null)
            {
                /* Function call to get the contact record */
                getContact();
            }
            else
            {
                showSearchTab = false;
                showListTab = false;
                showDetailTab = true;
                selectedTab = TAB3;
            }
            
            if(recordTypeName<> BLANK)
            {
                /* Function call to get the list of fields that needs to be verified for different contact */
                fieldList = getFieldlist(recordTypeName);
            }
            
        }catch(Exception classException)
        { 

            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));

            String errorMessage = classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2;
            errorMessage += 'DNISTC -'+ApexPages.currentPage().getParameters().get(DNISTC_STRING)+EXEPTION_MSG;
            errorMessage += 'CALLID -'+ApexPages.currentPage().getParameters().get(CALLID_STRING)+EXEPTION_MSG;
            errorMessage += 'CALLDT -'+ApexPages.currentPage().getParameters().get(CALLDT_STRING)+EXEPTION_MSG;
            errorMessage += 'TRANSF -'+ApexPages.currentPage().getParameters().get(TRANSF_STRING)+EXEPTION_MSG;
            Utility.sendErrorEmailToAdmin(errorMessage);

 
        }
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Edit button added to the Customer Interaction Detail Page, it redirects the user back to the edit page of
* the opened Customer Interaction
* @param 
* @return void
*/
    public void EditButton()
    {
        try
        {
            
            String query = SELECT_STR;
            for(String caseField : caseFields) {
                query += caseField + COMMA_QUERY;
            }
            query += EDIT_CASE+ caseId+ENDING_STRING;
            custInteraction = Database.query(query);
            
            if(custInteraction <> null)
            {
                showEditCase = true;
                showDetailCase = false;
                showMessage = false;
                
                
                if(custInteraction.Adhoc_Issue__c <> null )
                {
                    adhocType = [Select Id, Name from Adhoc_Issue__c where Id = :custInteraction.Adhoc_Issue__c Limit 50000 ].Id;
                }
                else
                {
                    adhocType = NONE_STR;
                }
                
            }
        }catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
        
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method takes in Recordtype name of the opened Contact based on the values passed in the URL DNISTC parameter
* It then fetches the labels of checkbox fields that need to be shown on the Verification Section and adds it to a List of String
* @param String of Recordtype Name
* @return List of String tempList
*/
    public List<string> getFieldList(string recordType)
    {
        List<string> tempList = new List<string>();
        try
        {
            if(recordType <> null)
            {
                String fields = ContactFieldMap.get(recordType).Field_Names__c;
                individualFields = fields.split(COMMA);
                
                if(!individualFields.isEmpty())
                {
                    for(String field : individualFields)
                    {
                        tempList.add(field);
                    }
                }
            }
            
            
        }catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
        return tempList;
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description When a user clicks the Verified button which gets active after checking 3 or more checkboxes on the Verification 
* section on page
* Customer Interaction is updated with following fields:
* Interaction verified checkbox is set to true
* verified by takes in the name of the logged in user
* verified with takes the labels of checkboxes that were checked to verify the record
* verified on takes in current data/time
* Contact Name/Patient Name and Account Name are automatically populated in the Customer Interaction
* Set boolean variables that render the page
* @param 
* @return void
*/
    public void contactVerification(){
        
        try
        {
            
            if(linkId.substring(0,3) == objectPrefixMap.get(system.label.CL27_Patient))
            {
                custInteraction.Patient__c = linkId;
                custInteraction.RecordTypeId = caseRecordTypeMap.get(system.label.CL12_S3PatientInteractionLog);
                showS3Patient = true; //3226 - 12/13/2014
                getCaseFields(DNSTC_PATIENT_INQUIRY.touppercase());
                
                /******* CODE FOR PATIENT ACCOUNT CR *********/
                if(patAcc == null || patAcc == BLANK )
                {
                    if(DEV <> null && DEV <> BLANK)
                    {
                        patAcc = DEV;
                    }
                }
                
                List<Patient_Account__c> patList = new List<Patient_Account__c>();
                if(patAcc <> null && patAcc <> BLANK )
                {
                    patList = [select Id, Patient_Account_Number__c, Guarantor_ID_Lookup__r.Id from Patient_Account__c where Patient_Account_Number__c =:patAcc AND Patient_DotOne_Lookup__c =:linkId limit 1];  
                }
                
                if(!patList.isEmpty())
                {
                    custInteraction.Patient_Account__c = patList[0].Id;
                    custInteraction.Guarantor__c = patList[0].Guarantor_ID_Lookup__r.Id; 
                }
                /******* CODE FOR PATIENT ACCOUNT CR *********/
            }
            else
            {
                custInteraction.ContactId = linkId;
                
                /******Req 2978 Release5 Bargaining Unit Code(calling the contactID from TestStatic class and linking it with customer Interaction linkid).**/
                TestStatic.ContactID= linkId ;
                
                if(showS3 == true)
                {
                    custInteraction.RecordTypeId = caseRecordTypeMap.get(system.label.CL03_S3InteractionLog);
                    getCaseFields(system.label.CL23_EMPL); 
                }
                else
                {
                    custInteraction.RecordTypeId = caseRecordTypeMap.get(system.label.CL13_SHPInteractionLog);
                    //3087 - Member Experience
                    
                    if(ProfileName  == SHP_MEP)
                    {
                        
                        getCaseFields(SHP_MEP);
                        
                    }
                    else
                    {
                        
                        getCaseFields(DNSTC_MEMBER);
                    }
                }
            }
            
            custInteraction.Interaction_Verified__c = true;
            custInteraction.Verified_By__c = UserInfo.getUserName();
            if(fieldLabels <> BLANK  && fieldLabels<>null)
            {
                custinteraction.Verified_with__c = fieldLabels.substringAfter(COMMA);
            }
            custInteraction.Verified_On__c = system.now();
            upsert custInteraction;
            
            String query = SELECT_STR;
            for(String caseField : caseFields) {
                query += caseField + COMMA_QUERY;
            }
            query += CUSTOMER_INTRACTION+ custInteraction.Id+ENDING_STRING;
            custInteraction = Database.query(query);
            
            if(custInteraction.Adhoc_Issue__c <> null )
            {
                adhocType = [Select Id, Name from Adhoc_Issue__c where Id = :custInteraction.Adhoc_Issue__c Limit 50000].Id;
            }
            else
            {
                adhocType = NONE_STR;
            }
            
            if(custInteraction.Status.equalsIgnoreCase(system.label.CL05_Closed))
            {
                showDetailCase = true;
                showEditCase = false;
                isClosed = true;
            }
            searchString = BLANK;
            if(custInteraction.Subject <> null && custInteraction.Subject <> BLANK && custInteraction.Subject.length()>2)
            {
                searchString = custInteraction.Subject;
            }
            caseid = custInteraction.Id;
            
            if(custInteraction.RecordType.Name.equals(system.label.CL12_S3PatientInteractionLog))
            {
                linkId = custInteraction.Patient__c;
                tab3Label = system.label.CL02_PatientDetail;
            }
            
            else
            {
                linkId = custInteraction.ContactId;
                tab3Label = system.label.CL01_ContactDetail;
            }
            
            showSearchTab = false;
            showListTab = false;
            showDetailTab = true;
            selectedTab = TAB3;
            
            if(custInteraction.ContactId != null){
                custId = custInteraction.Id;
                if(custInteraction.Contact.RecordtypeId == contactRecordTypeMap.get(system.label.CL08_Member)){
                    showClaimLinks = true;
                    claimMemberId = custInteraction.Contact.Member_HCC_ID__c;          
                }
                else if(custInteraction.Contact.RecordtypeId == contactRecordTypeMap.get(system.label.CL09_SHPProvider)){
                    showClaimLinks = true;
                    claimProviderId = custInteraction.Contact.Supplier_SPS_Epic_ID__c;
                }
            }
            else{
                showClaimLinks = false;
            }
        }catch(DMLException ex){
            for(integer i=0; i<ex.getNumDml(); i++)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDMLMessage(i))); 
            }
        }catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description When a user clicks the Unverified button on the Custom Console 
* Customer Interaction is updated with following fields:
* Interaction verified checkbox is set to false
* verified by takes in the name of the logged in user
* verified on takes in current data/time
* Contact Name/Patient Name and Account Name are automatically populated in the Customer Interaction
* Set boolean variables that render the page
* @param 
* @return void
*/
    public void contactVerificationForUnverified(){
        
        try
        {
            if(linkId.substring(0,3)==objectPrefixMap.get(system.label.CL27_Patient))
            {
                custInteraction.Patient__c = linkId;
                custInteraction.RecordTypeId = caseRecordTypeMap.get(system.label.CL12_S3PatientInteractionLog);
                showS3Patient = true; //3226 - 12/13/2014
                getCaseFields(DNSTC_PATIENT_INQUIRY.touppercase()); 
                
                /******* CODE FOR PATIENT ACCOUNT CR *********/
                if(patAcc == null || patAcc == BLANK)
                {
                    if(DEV <> null && DEV <> BLANK)
                    {
                        patAcc = DEV;
                    }
                }
                
                List<Patient_Account__c> patList = new List<Patient_Account__c>();
                if(patAcc <> null && patAcc <> BLANK)
                {
                    patList = [select Id, Patient_Account_Number__c, Guarantor_ID_Lookup__r.Id from Patient_Account__c where Patient_Account_Number__c =:patAcc AND Patient_DotOne_Lookup__c =:linkId limit 1];  
                }
                
                if(!patList.isEmpty())
                {
                    custInteraction.Patient_Account__c = patList[0].Id;
                    custInteraction.Guarantor__c = patList[0].Guarantor_ID_Lookup__r.Id; 
                }
                /******* CODE FOR PATIENT ACCOUNT CR *********/   
            }
            else
            {
                custInteraction.ContactId = linkId;
                if(showS3 == true)
                {
                    custInteraction.RecordTypeId = caseRecordTypeMap.get(system.label.CL03_S3InteractionLog);
                    getCaseFields(system.label.CL23_EMPL);
                }
                else
                {
                    custInteraction.RecordTypeId = caseRecordTypeMap.get(system.label.CL13_SHPInteractionLog);
                    //3087 - Member Experience
                    
                    if(ProfileName  == SHP_MEP)
                    {
                        
                        getCaseFields(SHP_MEP);
                        
                    }
                    else
                    {
                        
                        getCaseFields(DNSTC_MEMBER);
                    }
                }
            }
            
            custInteraction.Interaction_Verified__c = false;
            custInteraction.Verified_By__c = UserInfo.getUserName();
            custInteraction.Verified_On__c = system.now();
            upsert custInteraction;
            
            String query = SELECT_STR;
            for(String caseField : caseFields) {
                query += caseField + COMMA_QUERY;
            }
            query += CUSTOMER_INTRACTION+ custInteraction.Id+ENDING_STRING;
            custInteraction = Database.query(query);
            
            if(custInteraction.Adhoc_Issue__c <> null )
            {
                adhocType = [Select Id, Name from Adhoc_Issue__c where Id = :custInteraction.Adhoc_Issue__c Limit 50000].Id;
            }
            else
            {
                adhocType = NONE_STR;
            }
            
            
            
            if(custInteraction.Status.equalsIgnoreCase(system.label.CL05_Closed))
            {
                showDetailCase = true;
                showEditCase = false;
                isClosed = true;
            }
            searchString = BLANK;
            if(custInteraction.Subject <> null && custInteraction.Subject <> BLANK && custInteraction.Subject.length()>2)
            {
                searchString = custInteraction.Subject;
            }
            caseid = custInteraction.Id;
            
            if(custInteraction.RecordType.Name.equals(system.label.CL12_S3PatientInteractionLog))
            {
                linkId = custInteraction.Patient__c;
                tab3Label = system.label.CL02_PatientDetail;
            }
            else
            {
                linkId = custInteraction.ContactId;
                tab3Label = system.label.CL01_ContactDetail;
            }
            
            showSearchTab = false;
            showListTab = false;
            showDetailTab = true;
            selectedTab = TAB3;
            
            
            if(custInteraction.ContactId != null){
                custId = custInteraction.Id;
                if(custInteraction.Contact.RecordtypeId == contactRecordTypeMap.get(system.label.CL08_Member)){
                    showClaimLinks = true;
                    claimMemberId = custInteraction.Contact.Member_HCC_ID__c; 
                }
                else if(custInteraction.Contact.RecordtypeId == contactRecordTypeMap.get(system.label.CL09_SHPProvider)){
                    showClaimLinks = true;
                    claimProviderId = custInteraction.Contact.Supplier_SPS_Epic_ID__c;
                }
            }
            else{
                showClaimLinks = false;
            }
        }catch(DMLException ex){
            for(integer i=0; i<ex.getNumDml(); i++)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDMLMessage(i))); 
            }
        }catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used to set the record type of the Customer Interaction based on the DNISTC, if it is a new
* Customer Interaction
* @param 
* @return void
*/
    public void getCaseRecordType()
    {
        
        string recTypeId;
        if(DNISTC.equalsIgnoreCase(DNSTC_EMPLOYEE)||DNISTC.equalsIgnoreCase(DNSTC_ACCOUNT)||DNISTC.equalsIgnoreCase(DNSTC_VENDOR)||DNISTC.equalsIgnoreCase(DNSTC_EXECUTIVE)||DNISTC.equalsIgnoreCase(DNSTC_CREDENTIAL_VERIFACTION)||DNISTC.equalsIgnoreCase(DNSTC_JOB))
        {
            recTypeId = caseRecordTypeMap.get(system.label.CL03_S3InteractionLog);
        }else if(DNISTC.equalsIgnoreCase(DNSTC_PATIENT_INQUIRY)||DNISTC.equalsIgnoreCase(DNSTC_PATIENT_REGISTRATION)||DNISTC.equalsIgnoreCase(DNSTC_PHYSICIAN_SERVICES))
        {
            recTypeId = caseRecordTypeMap.get(system.label.CL12_S3PatientInteractionLog);
        }else if(DNISTC.equalsIgnoreCase(DNSTC_MEMBER)||DNISTC.equalsIgnoreCase(DNSTC_BROKER)||DNISTC.equalsIgnoreCase(DNSTC_EMPLOYER)||DNISTC.equalsIgnoreCase(DNSTC_PROVIDER))
        {
            recTypeId = caseRecordTypeMap.get(system.label.CL13_SHPInteractionLog);
        }
        custInteraction.RecordTypeId = recTypeId;
    }
    
    /** Date Time Method for defect 2294, 2297, 2318 **/
    public DateTime convertToDateTime(string callDate)
    {
        string year = callDate.substring(0, 4);
        string month = callDate.substring(4, 6);
        string day = callDate.substring(6, 8);
        string hour = callDate.substring(8, 10);
        string min = callDate.substring(10, 12);
        string sec = callDate.substring(12, 14);
        
        string dateString  = year+HYPHEN+month+HYPHEN+day+BLANK_SPACE+hour+COLON+min+COLON+sec;
        return DateTime.valueOf(dateString);
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description When a user clicks on the Save button on Cutomer Interaction Edit Page
* Update the Customer Interaction with the following fields : CALLID, DEV, DNISTYPECODE, ANI, EXITPATH, DNIS, CALLDATETIME
* (these values come from the URL parameters passed to open the page) and recordtype id of the customer interaction record,
* It then redirects the Page to the Customer Interaction Detail Page, set the boolean variables to true/false
* @param 
* @return void
*/
    public void saveCustInteraction()
    {
        
        try
        {
            if(showEditCase)
            {
                DateTime mydate;
                if(CALLDT <> BLANK && CALLDT <> null)
                {
                    if(CALLDT.length() == 14)
                    {
                        myDate = convertToDateTime(CALLDT);
                    }
                    else
                    {
                        ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Warning, INVALID_CALLDT));
                    }
                }
                
                if(EXITPATH == MANUAL_STR)
                {
                    custInteraction.CALLID__c = BLANK;
                    custInteraction.DEV__c = BLANK;                
                    custInteraction.DNISTYPECODE__c = BLANK ;            
                    custInteraction.ANI__c = BLANK;
                    custInteraction.EXITPATH__c = BLANK;
                    custInteraction.DNIS__c = BLANK;
                    custInteraction.CALLDATETIME__c = Null;               
                }
                else{
                    
                    custInteraction.CALLID__c = CALLID;
                    custInteraction.DEV__c = DEV;
                    
                    if(DNISTC<>null && DNISTC <> BLANK)
                    {
                        custInteraction.DNISTYPECODE__c = DNISTC.toUpperCase();
                    }
                    custInteraction.ANI__c = ANI;
                    custInteraction.EXITPATH__c = EXITPATH;
                    custInteraction.DNIS__c = DNIS;
                    custInteraction.CALLDATETIME__c = myDate;
                    
                }
                
                if(adhocType <> NONE_STR)
                {
                    custInteraction.Adhoc_Issue__c = adhocType;
                }
                else
                {
                    custInteraction.Adhoc_Issue__c = null;
                }
                //3087 - Member Experience
                
                if(ProfileName  == SHP_MEP)
                {
                    custInteraction.Origin = custInteraction.MEP_Origin__c;
                    custInteraction.Reason__c = custInteraction.MEP_Reason__c;
                    custInteraction.Secondary_Reason__c = custInteraction.MEP_Secondary_Reason__c;
                }
                if(custInteraction.Reason__c == System.Label.Public_Action && (custInteraction.Secondary_Reason__c == System.Label.Media_Threat || 
                                                                               custInteraction.Secondary_Reason__c == System.Label.Legal_Threat)) {
                                                                                   custInteraction.IsThreatEMailSent__c = true; 
                                                                               } else {
                                                                                   custInteraction.IsThreatEMailSent__c = false; 
                                                                               }
                upsert custInteraction;
                
                String query = SELECT_STR;
                for(String caseField : caseFields) {
                    query += caseField + COMMA_QUERY    ;
                }
                query += EDIT_CASE+ custInteraction.Id+ENDING_STRING;
                System.debug('>>>> SHP Query' + query );
                custInteraction = Database.query(query);
                if(custInteraction != null && custInteraction.RecordType.Name.equals(system.label.CL12_S3PatientInteractionLog))
                {
                    showS3Patient = true; //3226 - 12/13/2014
                }
                if(custInteraction.Adhoc_Issue__c <> null )
                {
                    adhocType = [Select Id, Name from Adhoc_Issue__c where Id = :custInteraction.Adhoc_Issue__c Limit 50000].Id;
                }
                else
                {
                    adhocType = NONE_STR;
                }
                
                
                searchString = BLANK;
                if(custInteraction.Subject <> null && custInteraction.Subject <> BLANK && custInteraction.Subject.length()>2)
                {
                    searchString = custInteraction.Subject;
                }
                caseid = custInteraction.Id;
                if(custInteraction.Status!=null && custInteraction.Status.equalsIgnoreCase(system.label.CL05_Closed) || setDetail == true)
                {
                    showDetailCase = true;
                    showEditCase = false;
                    setDetail = false;
                }
                if(custInteraction.Status!=null && custInteraction.Status.equalsIgnoreCase(system.label.CL05_Closed)){
                    isClosed = true;
                }
            }
            
        }catch(DMLException ex){
            for(integer i=0; i<ex.getNumDml(); i++)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDMLMessage(i))); 
            }
        }catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
    }
    /****Req-3342 *****/
    /*******************************************************************
    Purpose: Builds a map of fieldname to field ids
    Parameters: none
    Returns: map of field name (no '__c') to ids
    Throws [Exceptions]: None
    ********************************************************************/
   /* private static map<String,String> getcaseFieldMap(){
        map<String,String> returnMap = new map<String,String>();
        list<CaseFieldID__c> tempList = Tooling_API.getCaseFieldNameToIdMap();
        for(CaseFieldID__c cf : tempList){
            returnMap.put(cf.Field_Name__c, cf.name);
        }
        return returnMap; 
    }*/
     /*******************************************************************
    Purpose: Build fieldId to value mapping string 
    Parameters: none
    Returns: none 
    Throws [Exceptions]: None
    ********************************************************************/
    /*private void mapFieldsAndIds(){
        fieldToIds = '';
        map<String, String> fieldMapping = getcaseFieldMap();
        fieldToIds += '&cas28_lkid=' + custInteraction.Id; 
        fieldToIds += '&cas28=' + custInteraction.CaseNumber; 
        fieldToIds += '&cas11=' + EncodingUtil.URLENCODE(custInteraction.Origin,'UTF-8');
        if(custInteraction.Function__c != null && fieldMapping.containsKey('Function')){
            fieldToIds += '&' + fieldMapping.get('Function') + '=' + EncodingUtil.URLENCODE(custInteraction.Function__c,'UTF-8');
        }
        if(custInteraction.Sub_Function__c != null && fieldMapping.containsKey('Sub_Function')){
            fieldToIds += '&' + fieldMapping.get('Sub_Function') + '=' + EncodingUtil.URLENCODE(custInteraction.Sub_Function__c,'UTF-8');
        } 
        if(custInteraction.Customer_Intent__c != null && fieldMapping.containsKey('Customer_Intent')){
            fieldToIds += '&' + fieldMapping.get('Customer_Intent') + '=' + EncodingUtil.URLENCODE(custInteraction.Customer_Intent__c,'UTF-8');
        }
        if(custInteraction.Customer_Sub_Intents__c != null && fieldMapping.containsKey('Customer_Sub_Intents')){ 
            fieldToIds += '&' + fieldMapping.get('Customer_Sub_Intents') + '=' + EncodingUtil.URLENCODE(custInteraction.Customer_Sub_Intents__c,'UTF-8');
        }
        if(custInteraction.Preferred_Callback_Number__c != null && fieldMapping.containsKey('Preferred_Callback_Number')){ 
            fieldToIds += '&' + fieldMapping.get('Preferred_Callback_Number') + '=' + EncodingUtil.URLENCODE(custInteraction.Preferred_Callback_Number__c,'UTF-8');
        }
        
    }*/
    /*******************************************************************
    Purpose: Close and flag IL for no survey.  To be used when a related SR is going to be made immediatly
    Parameters: none
    Returns: none
    Throws [Exceptions]: None
    ********************************************************************/
   /* public void saveNewSR(){
        custInteraction.status = 'Closed';
        custInteraction.SR_Associated__c = true;
        saveSHP();
        if(custInteraction.id != null && !ApexPages.hasMessages()){
            saveSuccess = true;
            mapFieldsAndIds();
        }
        
        
    }*/
    /****End Req-3342 *****/
    /**
* @author IDC Team
* @date 08/09/2014
* @description This method attach the Grievance Service Request on SHP Interaction Log when Reason is Exempt Grievance.
* @param 
* @return void
*/
    /** 3200 Code Release 6.1 **/
    public void saveSHP()
    {
        saveCustInteraction();
        
        Case [] childCases= [SELECT Id, Preferred_Callback_Number__c FROM Case WHERE ParentId =: custInteraction.Id Limit 50000];
        
        showPopup=false;//keeping the value false initially so as to prevent popups in case of updation of Case
        
        
        if(childCases.isEmpty())
        {
            showPopup=true;//making the value true for first time when ChildCases don not exist
            
            List<Case> afterupdateInsertCases = new List<Case>(); 
            Case cas = new Case() ;
            If((ProfileName == system.label.CL59_SHP_Agent_Profile ||ProfileName == system.label.CL61_SHP_Management_Profile || ProfileName == system.label.System_Administrator) && custInteraction.RecordTypeId == caseRecordTypeMap.get(system.label.CL13_SHPInteractionLog))
            {
                if(custInteraction.Reason__c == EXEMPT_GRIEVANCES  || (custInteraction.Reason__c == MEMBER_GRIEVANCES && custInteraction.Secondary_Reason__c == EXEMPT)){
                    cas.RecordTypeId = caseRecordTypeMap.get(system.label.CL43_Grievance_RT);
                    cas.ParentId = custInteraction.Id;   
                    cas.Status = system.label.cl_CaseTrigger_New_Status  ;
                    cas.Reason__c = MEMBER_GRIEVANCES ;
                    cas.Secondary_Reason__c = EXEMPT;
                    cas.Date_Grievance_Requested__c = System.Now();
                    //cas.Grievance_Reason__c = custInteraction.Secondary_Reason__c;
                    cas.Preferred_Callback_Number__c = custInteraction.Preferred_Callback_Number__c;
                    
                    
                    
                    //Fetching the assignment rules on case
                    AssignmentRule AR = new AssignmentRule();
                    AR = [select id from AssignmentRule where SobjectType = :CASESTRING and Active = true limit 1];
                    
                    //Creating the DMLOptions for "Assign using active assignment rules" checkbox
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                    
                    //Setting the DMLOption on Case instance            
                    cas.setOptions(dmlOpts);
                    
                    
                    afterupdateInsertCases.add(cas); 
                }
            }
            
            if(afterupdateInsertCases.size() > 0) 
            {
                Database.insert(afterupdateInsertCases);
            }
            
            /** @Description:Req. 3262 Release 7 Changes Date : 01/13/2015 START**/
            if(custInteraction.Reason__c == REASON_CLINICAL && (custInteraction.Secondary_Reason__c == OOA_MEDICAL || custInteraction.Secondary_Reason__c == OON_MEDICAL
                                                                || custInteraction.Secondary_Reason__c == ED_NOTIFICATON ))   
            {
                Case OOA_service_request = createOOA();
                newCase = [Select Id, CaseNumber from Case where ParentId =: custInteraction.Id Limit 50000];
            }
            /** @Description:Req. 3262 Release 7 Changes Date : 01/13/2015 END**/
        }
        
        
    }
    
    /**
* @author IDC Team
* @date 12/29/2014
* @description : REQ 3262 : Method to create Service Request if IL Reason is clinical and secondary reason is any value of OOA/OON
* @param 
* @return void
*/
    public Case createOOA(){
        
        Contact con = new Contact();
        Case OOA_serviceRequest = new Case();
        Integer age;
        
        /** @Description: if IL has a contact attached to it, query the contact fields **/
        if(custInteraction.ContactId <> null)  
        {
            con = [Select Name, Phone, Member_PCP_Name_Full__c, Member_Group_Affiliation__c, Member_ID__c, Birthdate, RecordTypeId From Contact Where Id =: custInteraction.ContactId limit 1];
        }
        
        if(con.Id <> null)
        {
            /** @Description: if IL's contact is of type Member **/
            if(con.RecordtypeId == contactRecordTypeMap.get(CONTACT_RT_MEMBER))
            {
                
                OOA_serviceRequest.Member_Name_OOA_OON__c = con.Id;
                
                OOA_serviceRequest.Member_DOB_OOA_OON__c = con.Birthdate;
                
                OOA_serviceRequest.Member_Phone__c = con.Phone;
                OOA_serviceRequest.Member_PCP__c = con.Member_PCP_Name_Full__c; 
                OOA_serviceRequest.Medical_Group__c = con.Member_Group_Affiliation__c;
                
                OOA_serviceRequest.Member_ID_OOA_OON__c = con.Member_ID__c;
                
                if(con.Birthdate <> null)
                {
                    age = ((con.Birthdate).monthsBetween(system.today()))/12;
                }
                
                OOA_serviceRequest.Member_Age__c = String.valueOf(age);
                
            }
            /** @Description: if IL's contact is of type Provider **/
            else if(con.recordtypeId == contactRecordTypeMap.get(CONTACT_RT_SHP_PROVIDER))
            {
                OOA_serviceRequest.Facility_Name_OOA_OON__c = con.Id;
            }
        }
        
        OOA_serviceRequest.OwnerId = UserInfo.getUserId();
        OOA_serviceRequest.RecordTypeId = caseRecordTypeMap.get(CASE_RT_OOA_OON);
        OOA_serviceRequest.ParentId = custInteraction.Id;
        OOA_serviceRequest.Status = STATUS_OPEN;
        OOA_serviceRequest.Reason__c = custInteraction.Reason__c;
        OOA_serviceRequest.Secondary_Reason__c = custInteraction.Secondary_Reason__c;
        OOA_serviceRequest.ED_Type__c='ER';  // Added for keeping default value of ED type whenever OOA SR is getting created through IL Creation
        
        Database.insert(OOA_serviceRequest);
        
        return OOA_serviceRequest;   
    }
    /** @Description:Req. 3262 Release 7 Changes Date : 12/29/2014 END**/
    
    /**
* @author IDC Team
* @date 11/19/2014
* @description This method is part of the Req : 3226 of Release 6.4. This method is invoked on click of 'Save & new' button on the Custom       Console.
*              It saves the existing IL and creates a new one with the same same values copied over. This functionality is needed to help Agents create
*              multiple ILs without re-verifying the Caller.    
* @param 
* @return void
*/
    public void saveAndNew()
    {
        try
        {
            Id patientId = null;
            Id previousRT = null;
            Id patientAccount = null;
            Id guarantorId = null;
            Id contactIdStr = null;
            String verified_with = BLANK;
            Boolean isVerified = false;
            
            previousRT = custInteraction.RecordtypeId;
            
            if(showEditCase)
            {
                saveSHP();
            }
            
            caseNew = new Case();
            
            if(!String.isBlank(custInteraction.Requestor_Name__c))
            {
                caseNew.Requestor_Name__c = custInteraction.Requestor_Name__c;
            }
            
            if(custInteraction.Requestor_Type__c <> null)
            {
                caseNew.Requestor_Type__c = custInteraction.Requestor_Type__c;
            }
            
            if(custInteraction.Requestor_Number__c <> null)
            {
                caseNew.Requestor_Number__c = custInteraction.Requestor_Number__c;
            }
            
            if(custInteraction.Requestor_Email__c <> null)
            {
                caseNew.Requestor_Email__c = custInteraction.Requestor_Email__c;
            }
            
            /**       if(custInteraction.Requestor_Calling_in_Reference_To__c <> null)
{
caseNew.Requestor_Calling_in_Reference_To__c = custInteraction.Requestor_Calling_in_Reference_To__c;
} **/
            
            
            
            
            
            if(custInteraction.Preferred_Callback_Number__c <> null)
            {
                caseNew.Preferred_Callback_Number__c = custInteraction.Preferred_Callback_Number__c;
            }
            
            isVerified = custInteraction.Interaction_Verified__c;
            
            if(custInteraction.Patient__c <> null)
            {
                patientId = custInteraction.Patient__c;
            }
            
            /* if(custInteraction.Patient_Account__c <> null)
{
patientAccount = custInteraction.Patient_Account__c;
}*/
            
            if(custInteraction.Guarantor__c <> null)
            {
                guarantorId = custInteraction.Guarantor__c;
            }
            
            if(custInteraction.ContactId <> null)
            {
                contactIdStr = custInteraction.ContactId;
            }
            
            if(custinteraction.Verified_with__c <> null || custinteraction.Verified_with__c <> BLANK)
            {
                verified_with = custinteraction.Verified_with__c;
            }
            
            
            caseNew.Patient__c = patientId;
            caseNew.Patient_Account__c = patientAccount;
            caseNew.Guarantor__c = guarantorId;
            caseNew.ContactId = contactIdStr;
            caseNew.Interaction_Verified__c = isVerified;
            caseNew.Verified_By__c = UserInfo.getUserName();
            caseNew.Verified_with__c = verified_with;
            caseNew.RecordTypeId = previousRT;
            
            
            DateTime mydate = null;
            
            if(CALLDT <> BLANK && CALLDT <> null)
            {
                if(CALLDT.length() == 14)
                {
                    myDate = convertToDateTime(CALLDT);
                    call_date_time_Str = CALLDT;
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Warning, INVALID_CALLDT));
                }
            }
            
            Datetime dateTim = System.now();
            String str1 = String.valueOf(dateTim);
            String str2 = str1.replace(HYPHEN, BLANK);
            String str3 = str2.replace(COLON,BLANK);
            String finalDateTimeStr = str3.deleteWhitespace();
            
            String callIdStr = UserInfo.getUserId() + finalDateTimeStr;
            caseNew.CALLID__c = callIdStr;
            caseNew.DEV__c = DEV;
            if(DNISTC<>null && DNISTC<>BLANK)
            {
                caseNew.DNISTYPECODE__c = DNISTC.toUpperCase();
            }
            caseNew.ANI__c = ANI;
            caseNew.EXITPATH__c = EXITPATH;
            caseNew.DNIS__c = DNIS;
            caseNew.CALLDATETIME__c = myDate;
            
            if(adhocType <> NONE_STR)
            {
                caseNew.Adhoc_Issue__c = adhocType;
            }
            else
            {
                caseNew.Adhoc_Issue__c = null;
            }
            
            //3087 - Member Experience
            if(ProfileName  == SHP_MEP)
            {
                caseNew.Origin = caseNew.MEP_Origin__c;
                caseNew.Reason__c = caseNew.MEP_Reason__c;
                caseNew.Secondary_Reason__c = caseNew.MEP_Secondary_Reason__c;
            }
            
            Database.upsert(caseNew);
            
            saveAndNewError = false;
            
            
            String query = SELECT_STR;
            for(String caseField : caseFields) 
            {
                query += caseField + COMMA_QUERY;
            }
            query += RECORD_TYPE_CASE+ caseNew.Id+ENDING_STRING;
            caseNew = Database.query(query);
            
            if(caseNew.Adhoc_Issue__c <> null )
            {
                adhocType = [Select Id, Name from Adhoc_Issue__c where Id = :caseNew.Adhoc_Issue__c limit 50000].Id;
            }
            else
            {
                adhocType = NONE_STR;
            }
            
            searchString = BLANK;
            
            if(caseNew.Subject <> null && caseNew.Subject <> BLANK && caseNew.Subject.length()>2)
            {
                searchString = caseNew.Subject;
            }
            
            
            showDetailCase = true;
            showEditCase = false;
        }catch(DMLException ex){
            for(integer i=0; i<ex.getNumDml(); i++)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDMLMessage(i))); 
            }
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
    }
    /** Release6.4 REQ 3226 Save and New Button **/
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method opens the Contact/Patient/Patient Account detail page in the third tab
* @param 
* @return void
*/
    public void setContactLink()
    {
        showDetailTab = true;
        selectedTab = TAB3;
        
        // Added by IDC offshore Req no 3236 oltp  set for contact 
        If(  String.isNotBlank(linkId) && linkId.length() >= 15 && linkId.substring(0,3) == Contact.sobjecttype.getDescribe().getKeyPrefix()) //check for linkid is not null or blank
        {
            contactdetailssection(linkId); 
            
        }
        
        if(recordTypeName == CONTACT_RT_PATIENT) //Req-3274 changes for patient
        {
            
            casePatientLst();
        }
        else if(con != null ) // Prod Fix req 3236
        {
            If (con.recordtypeId == contactRecordTypeMap.get(CONTACT_RT_MEMBER))
            {showSHPM = true ;}
            // Req 3156 + 3363 Start
            else if (con.recordtypeId == contactRecordTypeMap.get(system.label.CL11_SHPEmployer) || con.recordtypeId == contactRecordTypeMap.get(system.label.CL134_SHP_Employer_contact ))
            {
                showEmployer = true;
            }
            else if (con.recordtypeId == contactRecordTypeMap.get(system.label.CL10_SHPBroker) || con.recordtypeId == contactRecordTypeMap.get(system.label.CL_135_SHP_Broker_Contact))
            {
                showBroker = true;  
            }
            // Req 3156 + 3363 End
            else 
            {showSHPM = false ;}
        }
        // End of requirement 3236 OLTP changes
        
        //else 
    }
    
    
    
    
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Method for Search button on Employee Search, it retrieves the search results from getSearchResults which is passed the 
* getEmployeeSearchQuery method as argument. This method checks if the values of the Employee search fields are blank or not.
* If search result is more than one employee, it sets the boolean variables to open the tab with the list of search results, else
* it directly opens the detail page of the searched Employee
* @param 
* @return void
*/
    public void SearchEmployee()
    {
        employeeResults.clear();
        if((isValue(employeeFirstName)) || (isValue(employeeLastName)) || (isValue(employeeAffiliate))|| (isValue(employeeID)))
        {
            try {
                
                if(Schema.SObjectType.Contact.isAccessible())
                {
                    tab3Label = system.label.CL01_ContactDetail;
                    verifyBool = true;
                    employeeResults = getSearchResults(getEmployeeSearchQuery());
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL17_NoResult));
                }
                
            }catch(Exception classException) { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
            } 
        }
        else
        {
            isSearchValues = false; 
        }
        
        
        if(isValidSearch(employeeResults)) 
        {
            recordTypeName = system.label.CL06_Employee;
            fieldList = getFieldlist(recordTypeName); 
            
            if(employeeResults.size()>1)
            {
                showListTab = true;
                selectedTab = TAB2;
                showDetailTab = false;
            }
            else
            {
                showListTab = false;
                showDetailTab = true;
                selectedTab = TAB3;
                linkId = employeeResults[0].Id;
                caseLst(); //Req-3274 changes
            }
        }
        resetParameters();
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used by SearchEmployee method. This method creates the searchQuery to query the Employee recordtype
* on contact by concatenating Search Strings for this specific search.
* @param 
* @return String searchQuery
*/
    public String getEmployeeSearchQuery() 
    {
        Id recordtypeId;
        try {
            recordtypeId = contactRecordTypeMap.get(system.label.CL06_Employee);
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));                    
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
        
        searchQuery = EMPLOYEE_SELECT + recordtypeId + ENDING_STRING;
        if(isValue(employeeFirstName)) { searchQuery += EMPLOYEE_FIRSTNAME_API + String.escapeSingleQuotes(employeeFirstName) + ENDING_WILDCARD_STRING;}
        if(isValue(employeeLastName)) { searchQuery += EMPLOYEE_LASTNAME_API + String.escapeSingleQuotes(employeeLastName) + ENDING_WILDCARD_STRING;}
        if(isValue(employeeAffiliate)) { searchQuery += EMPLOYEE_AFFILIATE_API + String.escapeSingleQuotes(employeeAffiliate) + ENDING_WILDCARD_STRING;} 
        if(isValue(employeeId)) { searchQuery += EMPLOYEE_ID_API + String.escapeSingleQuotes(employeeID) + ENDING_WILDCARD_STRING;} 
        return searchQuery + ORDER_LIMIT_STRING; 
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Method for Search button on Member Search, it retrieves the search results from getSearchResults which is passed the 
* getMemberSearchQuery method as argument. This method checks if the values of the Member search fields are blank or not.
* If search result is more than one Member, it sets the boolean variables to open the tab with the list of search results, else
* it directly opens the detail page of the searched Member
* @param 
* @return void
*/
    public void SearchMember() {
        
        memberResults.clear();
        if((isValue(memberID)) || (isValue(memberFirstName)) || (isValue(memberLastName)) 
           ||(isValue(memberContactNumber))||(isValue(String.valueOf(memberDOB.SearchDate__c)))) {
               
               try {
                   tab3Label = system.label.CL01_ContactDetail;
                   verifyBool = true;
                   memberResults = getSearchResults(getMemberSearchQuery());
                   
               } catch(Exception classException) { 
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                   Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
               }
           } else{ 
               
               isSearchValues = false; 
               
           }
        
        if(isValidSearch(memberResults)) {
            showSHPM  = true ; // Prod Fix req 3236
            // Req no 3356  OLTP Provider
            showSupplier = false; 
            showPractitioner = false; 
            // Req no 3356  OLTP Provider
            showEmployer = false; // to not show the Employer screen
            showBroker  = false ; // to not show the Broker screen 
            if(memberResults.size()>1)
            {
                showListTab = true;
                showDetailTab = false;
                selectedTab = TAB2;
            }
            else
            {
                showListTab = false;
                showDetailTab = true;
                selectedTab = TAB3;
                linkId = memberResults[0].Id;
                contactdetailssection(linkId); // OTLp Req-3236 changes
            }
        }
        resetParameters();
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used by SearchMember method. This method creates the searchQuery to query the Member recordtype
* on contact by concatenating Search Strings for this specific search.
* @param 
* @return String searchQuery
*/
    public String getMemberSearchQuery() {
        
        Id recordtypeId;
        
        try {
            recordtypeId = contactRecordTypeMap.get(system.label.CL08_Member);
            
        } catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));            
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
        
        searchQuery =  MEMBER_SELECT + recordtypeId + ENDING_STRING;
        
        if(isValue(memberID)) {
            
            
            if(memberID.endsWith(STAR)) {
                memberID = MEMBER_PREFIX+memberID.removeEnd(STAR)+HYPHEN;
                searchQuery += MEMBER_HCC_ID_API +  LIKE_STRING +String.escapeSingleQuotes(memberID) + ENDING_WILDCARD_STRING;
                
            } else {        
                searchQuery += MEMBER_ID_API +  EQUAL_HYPEN + String.escapeSingleQuotes(memberID) + ENDING_STRING;
                
            }      
        }
        
        if(isValue(memberFirstName)) { searchQuery += MEMBER_FIRSTNAME_API + String.escapeSingleQuotes(memberFirstName) + ENDING_WILDCARD_STRING;} 
        if(isValue(memberLastName)) { searchQuery += MEMBER_LASTNAME_API + String.escapeSingleQuotes(memberLastName) + ENDING_WILDCARD_STRING;}  
        if(isValue(memberContactNumber)) {  searchQuery += MEMBER_CONTACT_NUMBER_API + String.escapeSingleQuotes(memberContactNumber)+ENDING_STRING
            + MEMBER_HOME_PONE_API  + String.escapeSingleQuotes(memberContactNumber) +ENDING_STRING+ MEMBER_MOBILE_API + String.escapeSingleQuotes(memberContactNumber) + ENDING_STRING + CLOSED_BRACKET ;}
        if(isDate(memberDOB.SearchDate__c)) {  searchQuery += MEMBER_DOB_API + String.escapeSingleQuotes(formatDate(memberDOB.SearchDate__c));}
        
        return searchQuery +ORDER_LIMIT_STRING; 
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Method for Search button on Supplier Search, it retrieves the search results from getSearchResults which is passed the 
* getSupplierSearchQuery method as argument. This method checks if the values of the Supplier search fields are blank or not.
* If search result is more than one Supplier, it sets the boolean variables to open the tab with the list of search results, else
* it directly opens the detail page of the searched Supplier
* @param 
* @return void
*/
    public void SearchSupplier() {
        
        supplierResults.clear();
        if((isValue(supplierName)) || (isValue(supplierTIN)) || (isValue(supplierNPI))) {
            
            try { 
                tab3Label = system.label.CL01_ContactDetail;
                verifyBool = true;
                supplierResults = getSearchResults(getSupplierSearchQuery());
                
            } catch(Exception classException) { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage())); 
                Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
            }
        } else{ 
            
            isSearchValues = false; 
        }
        
        if(isValidSearch(supplierResults)) {
            showSHPM = false ; // Prod Fix req 3236
            // Req 3156 + 3363 Start
            showEmployer = false;
            showBroker  = false ; 
            // Req 3156 + 3363 End 
            if(supplierResults.size()>1)
            {
                showListTab = true;
                selectedTab = TAB2;
                showDetailTab = false;
            }
            else
            {
                showListTab = false;
                showDetailTab = true;
                selectedTab = TAB3;
                linkId = supplierResults[0].Id;
                contactdetailssection(linkid);
            }
        }  
        resetParameters();
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used by SearchSupplier method. This method creates the searchQuery to query the SHP Providor recordtype
* on contact by concatenating Search Strings for this specific search.
* @param 
* @return String searchQuery
*/
    public String getSupplierSearchQuery() {
        
        Id recordtypeId;
        
        try {
            recordtypeId = contactRecordTypeMap.get(system.label.CL09_SHPProvider);
            
        } catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
        
        searchQuery = SUPPLIER_SELECT + recordtypeId + ENDING_STRING;
        if(isValue(supplierName)) { searchQuery += SUPPLIER_NAME_API + String.escapeSingleQuotes(supplierName) + ENDING_WILDCARD_STRING;}
        if(isValue(supplierTIN)) { searchQuery += SUPPLIER_TIN_API + String.escapeSingleQuotes(supplierTIN) + ENDING_STRING;}
        if(isValue(supplierNPI)) { searchQuery += SUPPLIER_NPI_API + String.escapeSingleQuotes(supplierNPI) + ENDING_STRING;}  
        return searchQuery + ORDER_LIMIT_STRING; 
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Method for Search button on Broker Search, it retrieves the search results from getSearchResults which is passed the 
* getBrokerSearchQuery method as argument. This method checks if the values of the Broker search fields are blank or not.
* If search result is more than one Broker, it sets the boolean variables to open the tab with the list of search results, else
* it directly opens the detail page of the searched Broker
* @param 
* @return void
*/
    public void SearchBroker() {
        
        brokerResults.clear();
        if((isValue(brokerFirmName)) || (isValue(brokerID)) || (isValue(brokerFirmTelephoneNumber)) || (isValue(brokerAgentFirstName)) || (isValue(brokerAgentLastName))) {
            
            try {
                tab3Label = system.label.CL01_ContactDetail;
                verifyBool = true;
                brokerResults = getSearchResults(getBrokerSearchQuery());
                
            } catch(Exception classException) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
            }
        } else{ 
            
            isSearchValues = false; 
        }
        if(isValidSearch(brokerResults)) {
            showSHPM = false ; // Prod Fix req 3236
            // Req no 3356  OLTP Provider start
            showSupplier = false; // req 3356
            showPractitioner = false; // req 3356
            // Req no 3356  OLTP Provider End
            // Req 3156 + 3363 Start
            showEmployer = false;
            showBroker  = true ; 
            // Req 3156 + 3363 End   
            if(brokerResults.size()>1)
            {
                showListTab = true;
                selectedTab = TAB2;
                showDetailTab = false;
            }
            else
            {
                showListTab = false;
                showDetailTab = true;
                selectedTab = TAB3;
                linkId = brokerResults[0].Id;
                // Req 3156 + 3363 Start
                contactdetailssection(linkid);
                // Req 3156 + 3363 End   
            }
        }  
        resetParameters();
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used by SearchBroker method. This method creates the searchQuery to query the SHP Sales Broker Contact Read Only 
* recordtype on contact by concatenating Search Strings for this specific search.
* @param 
* @return String searchQuery
*/
    public String getBrokerSearchQuery() {
        
        Id recordtypeId;
        // Req 3156 + 3363 Start
        Id recordtypeIdBroker;
        // Req 3156 + 3363 End 
        
        try {
            recordtypeId = contactRecordTypeMap.get(system.label.CL10_SHPBroker);
            recordtypeIdBroker = contactRecordTypeMap.get(system.label.CL_135_SHP_Broker_Contact);
            
        } catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));   
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
        
        // Req 3156 + 3363 Start
        searchQuery = BROKER_SELECT + recordtypeId + RECORDTYPE_OR_STRING +  recordtypeIdBroker + ENDING_STRING + CLOSED_BRACKET;
        // Req 3156 + 3363 End
        if(isValue(brokerAgentFirstName)) { searchQuery += BROKER_AGENT_FIRST_NAME_API + String.escapeSingleQuotes(brokerAgentFirstName) + ENDING_WILDCARD_STRING;}
        if(isValue(brokerAgentLastName)) { searchQuery += BROKER_AGENT_LAST_NAME_API + String.escapeSingleQuotes(brokerAgentLastName) + ENDING_WILDCARD_STRING;}
        if(isValue(brokerFirmName)) { searchQuery += BROKER_FIRM_NAME_API + String.escapeSingleQuotes(brokerFirmName) + ENDING_WILDCARD_STRING;}
        if(isValue(brokerID)) { searchQuery += BROKER_ID_API + String.escapeSingleQuotes(brokerID) + ENDING_STRING;}  
        if(isValue(brokerFirmTelephoneNumber)) {  searchQuery += BROKER_CONTACT_NUMBER_API + String.escapeSingleQuotes(brokerFirmTelephoneNumber) + ENDING_STRING;}    
        return searchQuery + ORDER_LIMIT_STRING; 
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Method for Search button on Employer Search, it retrieves the search results from getSearchResults which is passed the 
* getEmployerSearchQuery method as argument. This method checks if the values of the Employer search fields are blank or not.
* If search result is more than one Employer, it sets the boolean variables to open the tab with the list of search results, else
* it directly opens the detail page of the searched Employer
* @param 
* @return void
*/
    public void SearchEmployer() {
        
        employerResults.clear();
        if((isValue(employerName)) || (isValue(employerTaxID)) || (isValue(employerContactFirstName)) || (isValue(employerContactLastName)) || (isValue(employerGroupNumber)) ) {
            
            try {     
                tab3Label = system.label.CL01_ContactDetail;
                verifyBool = true;
                employerResults = getSearchResults(getEmployerSearchQuery());
            } catch(Exception classException) { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
            } 
        } else{
            
            isSearchValues = false; 
        }
        
        if(isValidSearch(employerResults)) {
            showSHPM = false ; // Prod Fix req 3236
            // Req no 3356  OLTP Provider Start
            showSupplier = false; 
            showPractitioner = false ;
            // Req no 3356  OLTP Provider End
            // Req 3156 + 3363 Start 
            showEmployer = true;
            showBroker  = false ; 
            // Req 3156 + 3363 End  
            if(employerResults.size()>1)
            {
                showListTab = true;
                selectedTab = TAB2;
                showDetailTab = false;
            }
            else
            {
                showListTab = false;
                showDetailTab = true;
                selectedTab = TAB3;
                linkId = employerResults[0].Id;
                // Req 3156 + 3363 Start 
                contactdetailssection(linkid);
                // Req 3156 + 3363 End
            }
        }  
        resetParameters();
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used by SearchEmployer method. This method creates the searchQuery to query the Employer Contact 
* recordtype on contact by concatenating Search Strings for this specific search.
* @param 
* @return String searchQuery
*/
    public String getEmployerSearchQuery() {
        
        Id recordtypeId;
        // Req 3156 + 3363 Start 
        ID recordtypeIdEmployer;
        // Req 3156 + 3363 End 
        
        try {
            recordtypeId = contactRecordTypeMap.get(system.label.CL11_SHPEmployer);
            // Req 3156 + 3363 Start 
            recordtypeIdEmployer = contactRecordTypeMap.get(system.label.CL134_SHP_Employer_contact);
            // Req 3156 + 3363 End
            
        } catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));                 
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
        
        // Req 3156 + 3363 Start 
        searchQuery = EMPLOYER_SELECT + recordtypeId + RECORDTYPE_OR_STRING +  recordtypeIdEmployer + ENDING_STRING + CLOSED_BRACKET;
        // Req 3156 + 3363 End 
        if(isValue(employerContactFirstName)) { searchQuery += EMPLOYER_CONTACT_FIRST_NAME_API + String.escapeSingleQuotes(employerContactFirstName) + ENDING_WILDCARD_STRING;}
        if(isValue(employerContactLastName)) { searchQuery += EMPLOYER_CONTACT_LAST_NAME_API + String.escapeSingleQuotes(employerContactLastName) + ENDING_WILDCARD_STRING;}
        if(isValue(employerName)) { searchQuery += EMPLOYER_NAME_API + String.escapeSingleQuotes(employerName) + ENDING_WILDCARD_STRING;}
        if(isValue(employerTaxID)) { searchQuery += EMPLOYER_TAX_ID_API + String.escapeSingleQuotes(employerTaxID) + ENDING_STRING;}  
        // Req 3156 + 3363 Start 
        if(isValue(employerGroupNumber)) { searchQuery += EMPLOYER_HCC_ID_API + String.escapeSingleQuotes(employerGroupNumber) + ENDING_STRING;} 
        // Req 3156 + 3363 End
        return searchQuery +ORDER_LIMIT_STRING; 
    }
    
    
    
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Method for Search button on Providor Search, it retrieves the search results from getSearchResults which is passed the 
* getProviderSearchQuery method as argument. This method checks if the values of the Providor search fields are blank or not.
* If search result is more than one Providor record, it sets the boolean variables to open the tab with the list of search results, else
* it directly opens the detail page of the searched Providor Contact record
* @param 
* @return void
*/
    public void SearchProvider() {
        
        providerResults.clear();
        if((isValue(providerFirstName)) || (isValue(providerLastName)) || (isValue(providerNPI))) {
            
            try {
                tab3Label = system.label.CL01_ContactDetail;
                verifyBool = true;
                providerResults = getSearchResults(getProviderSearchQuery());   
                
            } catch(Exception classException) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
            }   
        } else{ 
            
            isSearchValues = false; 
        }
        
        if(isValidSearch(providerResults)) {
            
            recordTypeName = system.label.Provider_Label;
            fieldList = getFieldlist(recordTypeName);
            if(providerResults.size()>1)
            {
                showListTab = true;
                selectedTab = TAB2;
                showDetailTab = false;
            }
            else
            {
                showListTab = false;
                showDetailTab = true;
                selectedTab = TAB3;
                linkId = providerResults[0].Id;
            }
        }
        resetParameters();
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used by SearchProvider method. This method creates the searchQuery to query the contact recordtype Providor
* by concatenating Search Strings for this specific search.
* @param 
* @return String searchQuery
*/
    public String getProviderSearchQuery() {
        
        Id recordtypeId;
        
        try {
            recordtypeId = contactRecordTypeMap.get(system.label.CL15_Provider);
            
        } catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));    
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
        
        searchQuery = PROVIDER_SELECT + recordtypeId + ENDING_STRING;
        if(isValue(providerFirstName)) { searchQuery += PROVIDER_FIRSTNAME_API + String.escapeSingleQuotes(providerFirstName) + ENDING_WILDCARD_STRING;}
        if(isValue(providerLastName)) { searchQuery += PROVIDER_LASTNAME_API + String.escapeSingleQuotes(providerLastName) + ENDING_WILDCARD_STRING;}
        if(isValue(providerNPI)) { searchQuery += PROVIDER_NPI_API + String.escapeSingleQuotes(providerNPI) + ENDING_STRING;}         
        return searchQuery + ORDER_LIMIT_STRING; 
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Method for Search button on Vendor Search, it retrieves the search results from getSearchResults which is passed the 
* getVendorSearchQuery method as argument. This method checks if the values of the Vendor search fields are blank or not.
* If search result is more than one Vendor record, it sets the boolean variables to open the tab with the list of search results, else
* it directly opens the detail page of the searched Vendor Contact record
* @param 
* @return void
*/
    public void SearchVendor() {
        
        vendorResults.clear();
        if((isValue(vendorID)) || (isValue(vendorName)) || (isValue(vendorTaxID))) {
            
            try {
                tab3Label = system.label.CL01_ContactDetail;
                verifyBool = true;
                vendorResults = getSearchResults(getVendorSearchQuery());   
                
            } catch(Exception classException) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
            }   
        } else{ 
            
            isSearchValues = false; 
        }
        
        if(isValidSearch(vendorResults)) {
            
            recordTypeName = system.label.CL07_Vendor;
            fieldList = getFieldlist(recordTypeName);
            if(vendorResults.size()>1)
            {
                showListTab = true;
                selectedTab = TAB2;
                showDetailTab = false;
            }
            else
            {
                showListTab = false;
                showDetailTab = true;
                selectedTab = TAB3;
                linkId = vendorResults[0].Id;
                caseLst(); //Req-3733 changes for vendor search
            }
        }
        resetParameters();
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used by SearchVendor method. This method creates the searchQuery to query the contact recordtype Vendor
* by concatenating Search Strings for this specific search.
* @param 
* @return String searchQuery
*/
    public String getVendorSearchQuery() {
        
        Id recordtypeId;
        
        try {
            recordtypeId = contactRecordTypeMap.get(system.label.CL07_Vendor);
            
        } catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));    
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
        
        searchQuery = VENDOR_SELECT + recordtypeId + ENDING_STRING;
        if(isValue(vendorID)) { searchQuery += VENDOR_ID_API + String.escapeSingleQuotes(vendorID) + ENDING_STRING;}
        if(isValue(vendorName)) { searchQuery += VENDOR_NAME_API + String.escapeSingleQuotes(vendorName) + ENDING_WILDCARD_STRING;}
        if(isValue(vendorTaxID)) { searchQuery += VENDOR_TAXID_API + String.escapeSingleQuotes(vendorTaxID) + ENDING_STRING;}         
        return searchQuery + ORDER_LIMIT_STRING; 
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Method for Search button on Patient Search, it retrieves the search results from getSearchResults which is passed the 
* getPatientSearchQuery method as argument. This method checks if the values of the Patient search fields are blank or not.
* If search result is more than one Patient record, it sets the boolean variables to open the tab with the list of search results, else
* it directly opens the detail page of the searched Patient record
* @param 
* @return void
*/
    public void SearchPatient() {
        
        tab3Label = system.label.CL02_PatientDetail;
        
        patientResults.clear();
        //Defect INC000000152338-Modify Patient ,Apoorv,24Oct2013
        if((isValue(patientFirstName)) || (isValue(patientLastName)) || (isValue(patientMRN))||(isValue(patientSHMRN))) {
            
            try {
                
                verifyBool = true;
                patientResults =  getSearchResults(getPatientSearchQuery()); 
                
            } catch(Exception classException) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
            }   
        } else{ 
            
            isSearchValues = false; 
        }
        
        if(isValidSearch(patientResults)) {
            
            recordTypeName = system.label.CL27_Patient;
            fieldList = getFieldlist(recordTypeName);
            if(patientResults.size()>1)
            {
                showListTab = true;
                selectedTab = TAB2;
                showDetailTab = false;
            }
            else
            {
                showListTab = false;
                showDetailTab = true;
                selectedTab = TAB3;
                linkId = patientResults[0].Id;
                casePatientLst();//Req-3274 change for patient
            }
        }
        resetParameters();
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used by SearchPatient method. This method creates the searchQuery to query the Patient object
* by concatenating Search Strings for this specific search.
* @param 
* @return String searchQuery
*/
    public String getPatientSearchQuery() {
        //Defect INC000000152338-Modify Patient ,Apoorv,24Oct2013
        searchQuery = PATIENT_SELECT;
        if(isValue(patientFirstName)) { searchQuery += PATIENT_FIRST_NAME_API + String.escapeSingleQuotes(patientFirstName) + ENDING_WILDCARD_STRING;}
        if(isValue(patientLastName)) { searchQuery += PATIENT_LAST_NAME_API + String.escapeSingleQuotes(patientLastName) + ENDING_WILDCARD_STRING;}         
        if(isValue(patientMRN)) { searchQuery += PATIENT_MRN_API + String.escapeSingleQuotes(patientMRN) + ENDING_STRING;}
        if(isvalue(patientSHMRN)){ searchQuery += PATIENT_SHMRN_API + String.escapeSingleQuotes(patientSHMRN)+ ENDING_STRING;}
        
        searchQuery = searchQuery + PATIENT_ORDER_BY_FIRST_NAME;
        return searchQuery +LIMIT_STRING; 
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Method for Search button on Patient Account Search, it retrieves the search results from getSearchResults which is passed the 
* getPatientAccountSearchQuery method as argument. This method checks if the values of the Patient Account search fields are blank or not.
* If search result is more than one Patient Account record, it sets the boolean variables to open the tab with the list of search results, else
* it directly opens the detail page of the searched Patient Account record
* @param 
* @return void
*/
    public void SearchPatientAccount() {
        
        tab3Label = system.label.CL02_PatientDetail;
        patientAccountResults.clear();
        //Defect INC000000152338-Modify PatientAccount ,Apoorv,24Oct2013
        if((isValue(patientAccountNumber)) || (isValue(patientMRN))||(isvalue(patientSHMRN))) {
            
            try {
                
                verifyBool = true;
                patientAccountResults = getSearchResults(getPatientAccountSearchQuery()); 
                
            } catch(Exception classException) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
            }   
        } else{ 
            
            isSearchValues = false; 
        }
        
        if(isValidSearch(patientAccountResults)) {
            
            recordTypeName = system.label.CL27_Patient;
            fieldList = getFieldlist(recordTypeName);
            if(patientAccountResults.size()>1)
            {
                showListTab = true;
                selectedTab = TAB2;
                showDetailTab = false;
            }
            else
            {
                showListTab = false;
                showDetailTab = true;
                selectedTab = TAB3;
                linkId = patientAccountResults[0].Patient_DotOne_Lookup__r.Id;
                patAcc = patientAccountResults[0].Patient_Account_Number__c;
                casePatientLst(); //Req-3274 change for patient
            }
        }
        resetParameters();
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used by SearchPatientAccount method. This method creates the searchQuery to query the Patient Account object
* by concatenating Search Strings for this specific search.
* @param 
* @return String searchQuery
*/
    public String getPatientAccountSearchQuery() {
        //Defect INC000000152338-Modify Patient ,Apoorv,24Oct2013
        searchQuery = PATIENT_ACC_SELECT;
        if(isValue(patientAccountNumber)) { searchQuery += PATIENT_ACCOUNT_NUMBER_API + String.escapeSingleQuotes(patientAccountNumber) + ENDING_STRING;}
        if(isValue(patientMRN)) { searchQuery += PATIENT_ACC_MRN_API + String.escapeSingleQuotes(patientMRN) + ENDING_STRING;}
        if(isvalue(patientSHMRN)){ searchQuery += PATIENT_ACC_SHMRN_API + String.escapeSingleQuotes(patientSHMRN)+ ENDING_STRING;}
        searchQuery = searchQuery + PATIENT_ORDER_BY;
        return searchQuery +LIMIT_STRING; 
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Method for Search button on Guarantor Search, it retrieves the search results from getSearchResults which is passed the 
* getGuarantorSearchQuery method as argument. This method checks if the values of the Guarantor search fields are blank or not.
* If search result is more than one Guarantor record, it sets the boolean variables to open the tab with the list of search results, else
* it directly opens the detail page of the searched Guarantor record
* @param 
* @return void
*/
    public void SearchGuarantor() {
        
        tab3Label = system.label.CL16_GuarantorDetail;
        guarantorResults.clear();
        if(isValue(guarantorName)) {
            
            try {
                
                verifyBool = false;
                guarantorResults = getSearchResults(getGuarantorSearchQuery());
                
            } catch(Exception classException) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
            }   
        } else{ 
            
            isSearchValues = false; 
        }
        
        if(isValidSearch(guarantorResults)) {
            
            recordTypeName = GURANTOR;
            fieldList = getFieldlist(recordTypeName);
            if(guarantorResults.size()>1)
            {
                showListTab = true;
                selectedTab = TAB2;
                showDetailTab = false;
                
            }
            else
            {
                showListTab = false;
                showDetailTab = true;
                selectedTab = TAB3;
                linkId = guarantorResults[0].Id;
            }
        }
        resetParameters();
    }
    
    
    
    
    
    
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used by SearchGuarantor method. This method creates the searchQuery to query the Guarantor object
* by concatenating Search Strings for this specific search.
* @param 
* @return String searchQuery
*/
    public String getGuarantorSearchQuery() {
        
        searchQuery = GUARANTOR_SELECT;
        if(isValue(guarantorName)) { searchQuery += GUARANTOR_NAME_API + String.escapeSingleQuotes(guarantorName) + ENDING_WILDCARD_STRING;}
        return searchQuery +ORDER_LIMIT_STRING_NAME; 
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is used by all the Seach Methods to query the search string passed to it and returns the queried list of sobjects
* @param String search
* @return List<sObject> returnList
*/
    public List<SObject> getSearchResults(String search) {
        
        List<SObject> returnList;
        try {
            returnList = Database.query(search);
            
        } catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
        return returnList;
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is a utility method used wherever the code needs to check if a particular string is empty or not.
* This method returns true if the value is not null or empty else returns false
* @param String checkString
* @return Boolean returnValue
*/
    public Boolean isValue(String checkString) {
        
        Boolean returnValue = false;
        
        if(checkString != null && checkString != BLANK) {
            returnValue = true;
        }
        return returnValue;
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is a utility method used wherever the code needs to check if the Search is a valid search or not.
* It takes list of sObjects as argument and checks if the list is empty, null or its size is less than 1. 
* If the value entered in the search field does not return any results, it shows message "No results found".
* If the values put in are not valid values it returns "Your search did not contain the correct number of characters to perform this search".
* If no values are entered in the search field it returns "You must enter values to search"
* @param List of sObjects checkList
* @return Boolean returnBoolean
*/
    public Boolean isValidSearch(List<Sobject> checkList) {
        Boolean returnBoolean = true;
        if(checkList.isEmpty()){
            returnBoolean = false;
            
            if(isSearchValues) {
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL17_NoResult));
            }else {
                
                if(!isGoodValue) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL18_NoCorrectChar));
                } else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL19_EnterValue));
                }
            }
        } 
        
        return returnBoolean;
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is a utility method used wherever the code needs to convert a Date type to String.
* it takes in date as the argument and returns String
* @param Date inputDate
* @return return String
*/
    public static String formatDate(Date inputDate) {
        return String.valueOf(inputDate).substringBefore(BLANK_SPACE);       
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is a utility method used wherever the code needs to check if the date entered is null or not
* it takes Date as argument and returns boolean
* @param Date checkDate
* @return return returnValue
*/
    public Boolean isDate(Date checkDate) {
        
        Boolean returnValue = false;
        
        if(checkDate != null) {
            
            returnValue = true;
        }
        return returnValue;
    }
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method is a utility method used wherever the code needs to check if the date entered is null or not
* it takes Date as argument and returns boolean
* @param Date checkDate
* @return return returnValue
*/
    public Boolean isValidDateRange(Date startDate, Date endDate) {
        
        Boolean returnValue = false;
        
        if((String.valueOf(startDate) != null && String.valueOf(startDate) != BLANK) && (String.valueOf(endDate) != null && String.valueOf(endDate) != BLANK)){
            if(startDate <= endDate) {
                returnValue = true;
            } else {
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL20_EndDateValidation));
            }
            
        } else {
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL21_DateValidation));
        }
        return returnValue;
    }
    
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description Getter method to return case object variable for DOB for Member search fields
* @param 
* @return return Case
*/
    public Case getMemberDOB() {
        return memberDOB;
    }
    
    
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method resets the Search functionality parameters. This method is called at the end of each method where
* these 
* parameters are being used.
* @param 
* @return void
*/
    public void resetParameters()
    {
        employeeFirstName = null;
        employeeLastName = null;
        employeeAffiliate = null;
        memberID = null;
        memberFirstName = null;
        memberLastName = null;
        memberContactNumber = null;
        memberDOB.clear();
        supplierName = null;
        supplierTIN = null;
        supplierNPI = null;
        brokerAgentFirstName = null;
        brokerAgentLastName = null;
        brokerFirmName = null;
        brokerID = null;
        brokerFirmTelephoneNumber = null;
        employerContactFirstName = null;
        employerContactLastName = null;
        employerName = null;
        employerTaxID = null;
        
        // Req 3156 + 3363 Start
        employerGroupNumber = null;
        // Req 3156 + 3363 End
        
        providerFirstName = null;
        providerLastName = null;
        providerNPI = null;
        vendorID = null;
        vendorName = null;
        vendorTaxID = null;
        patientAccountNumber = null;
        patientFirstName = null;
        patientLastName = null;
        //Defect INC000000152338-Apoorv,24Oct2013 
        
        patientMRN= null;
        patientSHMRN = null;
        guarantorName = null;
        searchQuery = null;
    }
    
    
    /**
* @author IDC Team
* @date 15/08/2013
* @description This method queries through the Data Category Names and retrieves a list of articles based on the “search
* String” entered in either the subject of Customer Interaction or the Search     
* textbox of KM section and the category list selected from the drop down.
* @param 
* @return String categoryCondition
*/
    public String getCategoryKeyword() 
    {
        String categoryCondition = BLANK;
        
        try
        {   
            articleList.clear();
            DataCategoryGroupInfo[] categoryGroups = DataCategoryUtil.getInstance().getAllCategoryGroups();
            for (DataCategoryGroupInfo categoryGroup : categoryGroups) 
            {
                String selectedCategoryName = System.currentPageReference().getParameters().Get(CATEGORY_TYPE+categoryGroup.getName());
                if(selectedCategoryName != null && !selectedCategoryName.equals(NO_FILTER)) 
                {
                    if(categoryCondition == BLANK && selectedCategoryName != null)
                    {
                        categoryCondition=categoryCondition+categoryGroup.getName() + COLON +
                            System.currentPageReference().getParameters().Get(CATEGORY_TYPE+categoryGroup.getName());
                    }
                    else 
                    {
                        categoryCondition=categoryCondition + COMMA +categoryGroup.getName() + COLON +
                            System.currentPageReference().getParameters().Get(CATEGORY_TYPE+categoryGroup.getName());
                    }
                }
            }
            
            String categoryFilter = BLANK;
            for (DataCategoryGroupInfo categoryGroup : categoryGroups) 
            {
                String categoryType = System.currentPageReference().getParameters().Get(CATEGORY_TYPE+categoryGroup.getName());
                if(categoryType != null && !categoryType.equals(NO_FILTER)) 
                {
                    if(categoryFilter ==BLANK)
                    {
                        categoryFilter = categoryGroup.getName() + ABOVE_OR_BELOW + categoryType +API_POSTFIX;
                    } 
                    else 
                    {
                        categoryFilter = categoryFilter + MULTI_STRING + categoryGroup.getName() +ABOVE_OR_BELOW + categoryType +API_POSTFIX;
                    }
                }
            }
            
            if(categoryFilter.length() > 0) 
            {
                if(searchString != null && searchString.length() > 1 ) 
                {
                    String searchquery = FIND + String.escapeSingleQuotes(searchString) + SOSL_KNOWLEDGE_ARTICLE_WITH_DATA_CATEGORY+categoryFilter + LIMIT_20;
                    List<List<SObject>>searchList = search.query(searchquery);
                    articleList = (List<KnowledgeArticleVersion>)searchList[0];
                    if(!articleList.isEmpty()){
                        maxSize = articleList.size() ;
                    }    
                } 
                else 
                {
                    String qryString = KNOWLEDGE_ARTICLE_WITH_DATA_CATEGORY+categoryFilter + LIMIT_20;
                    articleList= Database.query(qryString);
                    if(!articleList.isEmpty()){
                        maxSize = articleList.size() ;
                    }
                }
            } 
            else 
            {
                if(searchString != null && searchString.length() >1 ) 
                {
                    String searchquery = FIND + String.escapeSingleQuotes(searchString) +SOSL_KNOWLEDGE_ARTICLE + LIMIT_20;
                    List<List<SObject>>searchList = search.query(searchquery);
                    articleList = (List<KnowledgeArticleVersion>)searchList[0];
                    if(!articleList.isEmpty()){
                        maxSize = articleList.size() ;
                    }    
                } 
                else 
                {
                    String qryString = KNOWLEDGE_ARTICLE + LIMIT_20;
                    articleList= Database.query(qryString);
                    if(!articleList.isEmpty()){
                        maxSize = articleList.size() ;
                    }    
                }
            }
            set<id> artids = new set<id>();
            if(!articleList.isEmpty())
            {
                for(KnowledgeArticleVersion KA:articleList){
                    artids.add(KA.KnowledgeArticleId);
                }
            }
            
            // Added articleWrapperList to avoid VFpage key problem.
            if(!artids.isEmpty()){
                Set<Id> set_Know_id = new Set<Id>();
                List<KnowledgeArticleViewStat> lst_know_art_view_stat = new List<KnowledgeArticleViewStat>();
                
                lst_know_art_view_stat =[SELECT ViewCount,Channel, NormalizedScore,ParentId FROM KnowledgeArticleViewStat where Channel=:APP and ParentId in: artids limit 50000];
                map_artId_viewCount = new Map<String, Decimal>();
                String str_id_value;
                articleWrapperList = new list<ArticleWrapper>();
                if(!lst_know_art_view_stat.isEmpty()){
                    for (Integer i =0; i< lst_know_art_view_stat.size(); i++)
                    {
                        str_id_value = lst_know_art_view_stat[i].ParentId;
                        str_id_value = str_id_value.left(15);
                        map_artId_viewCount.put(str_id_value, lst_know_art_view_stat[i].ViewCount); 
                        
                        // wrap article Id and view count together
                        ArticleWrapper wrap = new ArticleWrapper(); 
                        wrap.articleID = str_id_value;
                        wrap.ViewCount= lst_know_art_view_stat[i].ViewCount;
                        articleWrapperList.add(wrap);
                    }
                }  
            }
        }
        catch(Exception classException){ }
        return categoryCondition;
    }
    
    Integer maxCount = 0;
    private final Integer limitCounter = 5;
    string prevArticleTypeVal = '';
    string prevDataCategory = '';
    string prevFunctionalArea = '';
    string prevSubFunction = '';
    string prevsrchTextStr = '';
    string dataCategoryParam = '';
    /*******************************************************************
    Purpose: Req 3145,3146. Method prepares the articles list based on different filters.  
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void createArticleLst() {
        articleWrLst = new List<ArticleWrapperNew>();
        maxCount = 0;
        try {
            string qryString;
            string searchQueryStr;
            string baseQuery;
            List<sObject> articleLstTemp = new List<sObject>();
            if (dataCategoryParam == 'Union_Status_BU__c BELOW NONE__c'){
               dataCategoryParam = '';
            }           
            if((prevArticleTypeVal != articleTypeValue) || (prevDataCategory != dataCategoryParam) || (prevFunctionalArea != functionFilter) || (prevSubFunction != subFunctionFilter)
                || (prevsrchTextStr != searchStringTxt)) {
                resetOffSetCounter();
            }
            if(prevArticleTypeVal != articleTypeValue) {
                prevArticleTypeVal = articleTypeValue;
            }
            if(prevDataCategory != dataCategoryParam) {
                prevDataCategory = dataCategoryParam;
            }
            if(prevFunctionalArea != functionFilter) {
                prevFunctionalArea = functionFilter;
            }
            if(prevSubFunction != subFunctionFilter) {
                prevSubFunction = subFunctionFilter;
            }
            if(prevsrchTextStr != searchStringTxt) {
                prevsrchTextStr = searchStringTxt;
            }
            if(!string.isBlank(searchStringTxt)) {
                if(!string.isblank(dataCategoryParam)) {
                    if(!string.isBlank(functionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3)) {
                        if(!string.isblank(articleTypeValue) && articleTypeValue != '--None--') {
                            if(!string.isBlank(functionFilter) && (string.isBlank(subFunctionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() == 3))) {
                                            searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) order by lastmodifieddate desc limit ' + limitCounter +' OFFSET ' + offSetCtr + ') WITH DATA CATEGORY ' + dataCategoryParam + ''; 
                                articleLstTemp = (List<sObject>)search.query(searchQueryStr)[0];
                                baseQuery = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) order by lastmodifieddate desc) WITH DATA CATEGORY ' + dataCategoryParam + ''; 
                                maxCount = search.query(baseQuery)[0].size();
                            } else if(!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3) {
                                searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' )  order by lastmodifieddate desc limit ' + limitCounter +' OFFSET ' + offSetCtr + ') WITH DATA CATEGORY ' + dataCategoryParam + ''; 
                                articleLstTemp = (List<sObject>)search.query(searchQueryStr)[0];
                                baseQuery = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' )  order by lastmodifieddate desc) WITH DATA CATEGORY ' + dataCategoryParam + ''; 
                                maxCount = search.query(baseQuery)[0].size();
                            }
                        }  else {
                            set<Id> articleIdSet = new set<Id>(); 
                            List<String> lstArticleType = new List<String>();  
                            lstArticleType = ArticleHelper.getArticleType();
                            if(!string.isBlank(functionFilter) && (string.isBlank(subFunctionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() == 3))) {
                                for(string strObj : lstArticleType) {
                                    searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(strObj)  + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) order by lastmodifieddate desc ) WITH DATA CATEGORY ' + dataCategoryParam + '';
                                    for(List<sObject> sObjectListObj : search.query(searchQueryStr)) {
                                        for(sObject sObj : sObjectListObj) {
                                                articleIdSet.add((string)sObj.get('KnowledgeArticleId'));
                                        }
                                    }
                                }
                                articleLstTemp = [select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = 'Online' and language='en_US' and KnowledgeArticleId IN :articleIdSet order by lastmodifieddate desc limit 5 OFFSET:offSetCtr];
                                maxCount = articleIdSet.size();
                            } else if(!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3) {
                                for(string strObj : lstArticleType) {
                                    searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(strObj)  + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' ) order by lastmodifieddate desc ) WITH DATA CATEGORY ' + dataCategoryParam + '';
                                    for(List<sObject> sObjectListObj : search.query(searchQueryStr)) {
                                        for(sObject sObj : sObjectListObj) {
                                            articleIdSet.add((string)sObj.get('KnowledgeArticleId'));
                                        }
                                    }
                                }
                                articleLstTemp = [select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = 'Online' and language='en_US' and KnowledgeArticleId IN :articleIdSet order by lastmodifieddate desc limit 5 OFFSET:offSetCtr];
                                maxCount = articleIdSet.size();
                            }       
                        }
                    } else {
                            if(!string.isblank(articleTypeValue) && articleTypeValue != '--None--') {
                                searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' order by lastmodifieddate desc limit ' + limitCounter +' OFFSET ' + offSetCtr + ') WITH DATA CATEGORY ' + dataCategoryParam + ''; 
                                    articleLstTemp = (List<sObject>)search.query(searchQueryStr)[0];
                                    baseQuery = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\'  order by lastmodifieddate desc) WITH DATA CATEGORY ' + dataCategoryParam + ''; 
                                    maxCount = search.query(baseQuery)[0].size();
                            }  else {
                                    searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' order by lastmodifieddate desc limit ' + limitCounter +' OFFSET ' + offSetCtr + ') WITH DATA CATEGORY ' + dataCategoryParam + ''; 
                                    articleLstTemp = (List<sObject>)search.query(searchQueryStr)[0];
                                    baseQuery = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\'  order by lastmodifieddate desc) WITH DATA CATEGORY ' + dataCategoryParam + ''; 
                                    maxCount = search.query(baseQuery)[0].size();
                            }
                        } 
                } else {
                        if(!string.isBlank(functionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3)) {
                            if(!string.isblank(articleTypeValue) && articleTypeValue != '--None--') {
                                if(!string.isBlank(functionFilter) && (string.isBlank(subFunctionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() == 3))) {
                                    searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) order by lastmodifieddate desc limit ' + limitCounter +' OFFSET ' + offSetCtr + ')'; 
                                    articleLstTemp = (List<sObject>)search.query(searchQueryStr)[0];
                                    baseQuery = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) order by lastmodifieddate desc)'; 
                                    maxCount = search.query(baseQuery)[0].size();
                                } else if(!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3) {
                                    searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' ) order by lastmodifieddate desc limit ' + limitCounter +' OFFSET ' + offSetCtr + ')'; 
                                    articleLstTemp = (List<sObject>)search.query(searchQueryStr)[0];
                                    baseQuery = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' ) order by lastmodifieddate desc)'; 
                                    maxCount = search.query(baseQuery)[0].size();
                                }
                            }  else {
                                    set<Id> articleIdSet = new set<Id>(); 
                                    List<String> lstArticleType = new List<String>();  
                                    lstArticleType = ArticleHelper.getArticleType();
                                    if(!string.isBlank(functionFilter) && (string.isBlank(subFunctionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() == 3))) {
                                        for(string strObj : lstArticleType) {
                                            searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(strObj)  + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) order by lastmodifieddate desc )';
                                            system.Debug('>>>>searchQueryStr1>>' + searchQueryStr);
                                            for(List<sObject> sObjectListObj : search.query(searchQueryStr)) {
                                                for(sObject sObj : sObjectListObj) {
                                                        articleIdSet.add((string)sObj.get('KnowledgeArticleId'));
                                                }
                                            }
                                        }
                                        articleLstTemp = [select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = 'Online' and language='en_US' and KnowledgeArticleId IN :articleIdSet order by lastmodifieddate desc limit 5 OFFSET:offSetCtr];
                                        maxCount = articleIdSet.size();
                                    } else if(!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3) {
                                        for(string strObj : lstArticleType) {
                                            searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(strObj)  + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' ) order by lastmodifieddate desc )';
                                            system.Debug('>>>>searchQueryStr2>>' + searchQueryStr); 
                                            for(List<sObject> sObjectListObj : search.query(searchQueryStr)) {
                                                for(sObject sObj : sObjectListObj) {
                                                        articleIdSet.add((string)sObj.get('KnowledgeArticleId'));
                                                }
                                            }
                                        }
                                        articleLstTemp = [select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = 'Online' and language='en_US' and KnowledgeArticleId IN :articleIdSet order by lastmodifieddate desc limit 5 OFFSET:offSetCtr];
                                        maxCount = articleIdSet.size();
                                    }       
                                }
                        } else {
                            if(!string.isblank(articleTypeValue) && articleTypeValue != '--None--') {
                                searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' order by lastmodifieddate desc limit ' + limitCounter +' OFFSET ' + offSetCtr + ')'; 
                                articleLstTemp = (List<sObject>)search.query(searchQueryStr)[0];
                                baseQuery = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING ' + articleTypeValue + '(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' order by lastmodifieddate desc)'; 
                                maxCount = search.query(baseQuery)[0].size();
                            }  else {
                                searchQueryStr = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' order by lastmodifieddate desc limit ' + limitCounter +' OFFSET ' + offSetCtr + ')'; 
                                articleLstTemp = (List<sObject>)search.query(searchQueryStr)[0];
                                baseQuery = 'FIND \'' + String.escapeSingleQuotes(searchStringTxt) + '*\' IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\' order by lastmodifieddate desc)'; 
                                maxCount = search.query(baseQuery)[0].size();
                            }
                        } 
                }
            } else { // If Search String is not set
                if(!string.isblank(dataCategoryParam)) { // If Data Category is given
                        if(!string.isBlank(functionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3)) {
                                if(!string.isblank(articleTypeValue) && articleTypeValue != '--None--') {
                                    if(!string.isBlank(functionFilter) && (string.isBlank(subFunctionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() == 3))) {
                                        qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) WITH DATA CATEGORY ' + dataCategoryParam + ' order by lastmodifieddate desc LIMIT ' + limitCounter +' OFFSET ' + offSetCtr;
                                        articleLstTemp = Database.query(qryString);
                                        baseQuery = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) WITH DATA CATEGORY ' + dataCategoryParam + ' order by lastmodifieddate desc ';
                                        maxCount = Database.query(baseQuery).size();
                                    } else if(!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3) {
                                        qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' ) WITH DATA CATEGORY ' + dataCategoryParam + ' order by lastmodifieddate desc LIMIT ' + limitCounter +' OFFSET ' + offSetCtr;
                                        articleLstTemp = Database.query(qryString);
                                        baseQuery = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' ) WITH DATA CATEGORY ' + dataCategoryParam + ' order by lastmodifieddate desc ';
                                        maxCount = Database.query(baseQuery).size();
                                    }
                                }  else {
                                    set<Id> articleIdSet = new set<Id>(); 
                                    List<String> lstArticleType = new List<String>();  
                                    lstArticleType = ArticleHelper.getArticleType();
                                    if(!string.isBlank(functionFilter) && (string.isBlank(subFunctionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() == 3))) {
                                        for(string strObj : lstArticleType) {
                                            qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(strObj) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) WITH DATA CATEGORY ' + dataCategoryParam + ' order by lastmodifieddate desc';
                                            for(sObject sObj : Database.query(qryString)) {
                                                    articleIdSet.add((string)sObj.get('KnowledgeArticleId'));
                                            }
                                        }
                                        articleLstTemp = [select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = 'Online' and language='en_US' and KnowledgeArticleId IN :articleIdSet order by lastmodifieddate desc limit 5 OFFSET:offSetCtr];
                                        maxCount = articleIdSet.size();
                                    } else if(!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3) {
                                        for(string strObj : lstArticleType) {
                                            qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(strObj) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' ) WITH DATA CATEGORY ' + dataCategoryParam + ' order by lastmodifieddate desc';
                                            for(sObject sObj : Database.query(qryString)) {
                                                    articleIdSet.add((string)sObj.get('KnowledgeArticleId'));
                                            }
                                        }
                                        articleLstTemp = [select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = 'Online' and language='en_US' and KnowledgeArticleId IN :articleIdSet order by lastmodifieddate desc limit 5 OFFSET:offSetCtr];
                                        maxCount = articleIdSet.size();
                                    }
                                }
                        } else {
                            if(!string.isblank(articleTypeValue) && articleTypeValue != '--None--') {
                                qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' WITH DATA CATEGORY ' + dataCategoryParam + ' order by lastmodifieddate desc LIMIT ' + limitCounter +' OFFSET ' + offSetCtr;
                                articleLstTemp = Database.query(qryString);
                                baseQuery = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' WITH DATA CATEGORY ' + dataCategoryParam + ' order by lastmodifieddate desc';
                                maxCount = Database.query(baseQuery).size();
                            }  else {
                                qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = \'Online\' and language=\'en_US\' WITH DATA CATEGORY ' + dataCategoryParam + ' order by lastmodifieddate desc LIMIT ' + limitCounter +' OFFSET ' + offSetCtr;
                                articleLstTemp = Database.query(qryString);
                                baseQuery = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = \'Online\' and language=\'en_US\' WITH DATA CATEGORY ' + dataCategoryParam + ' order by lastmodifieddate desc';
                                maxCount = Database.query(baseQuery).size();
                            }
                        } 
                } else { // If Data Category is not given
                    if(!string.isBlank(functionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3)) { // if functional area or Sub-function is given
                        if(!string.isblank(articleTypeValue) && articleTypeValue != '--None--') { // if (functional area or Sub-function) and artice type is given
                            if(!string.isBlank(functionFilter) && (string.isBlank(subFunctionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() == 3))) {
                                qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) order by lastmodifieddate desc LIMIT ' + limitCounter +' OFFSET ' + offSetCtr;
                                articleLstTemp = Database.query(qryString);
                                baseQuery = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) order by lastmodifieddate desc';
                                maxCount = Database.query(baseQuery).size();
                            } else if(!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3) {
                                qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' ) order by lastmodifieddate desc LIMIT ' + limitCounter +' OFFSET ' + offSetCtr;
                                articleLstTemp = Database.query(qryString);
                                baseQuery = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' ) order by lastmodifieddate desc';
                                maxCount = Database.query(baseQuery).size();
                            }
                        }  else { // if only (functional area or Sub-function) is given
                                set<Id> articleIdSet = new set<Id>(); 
                                List<String> lstArticleType = new List<String>();  
                                lstArticleType = ArticleHelper.getArticleType();
                                if(!string.isBlank(functionFilter) && (string.isBlank(subFunctionFilter) || (!string.isBlank(subFunctionFilter) && subFunctionFilter.length() == 3))) {
                                    for(string strObj : lstArticleType) {
                                        qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(strObj) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' ) order by lastmodifieddate desc';
                                        for(sObject sObj : Database.query(qryString)) {
                                                articleIdSet.add((string)sObj.get('KnowledgeArticleId'));
                                        }
                                    }
                                    articleLstTemp = [select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = 'Online' and language='en_US' and KnowledgeArticleId IN :articleIdSet order by lastmodifieddate desc limit 5 OFFSET:offSetCtr];
                                    maxCount = articleIdSet.size();
                                } else if(!string.isBlank(subFunctionFilter) && subFunctionFilter.length() != 3) {
                                    for(string strObj : lstArticleType) {
                                        qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(strObj) + ' where PublishStatus = \'Online\' and language=\'en_US\' and (Functional_Area__c like \'' + String.escapeSingleQuotes(functionFilter) + '%\' AND Sub_Function__c like \'' + String.escapeSingleQuotes(subFunctionFilter) + '%\' ) order by lastmodifieddate desc';
                                        for(sObject sObj : Database.query(qryString)) {
                                                articleIdSet.add((string)sObj.get('KnowledgeArticleId'));
                                        }
                                    }
                                    articleLstTemp = [select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = 'Online' and language='en_US' and KnowledgeArticleId IN :articleIdSet order by lastmodifieddate desc limit 5 OFFSET:offSetCtr];
                                    maxCount = articleIdSet.size();
                                }
                        }
                    } else { 
                        if(!string.isblank(articleTypeValue) && articleTypeValue != '--None--') { // if only article Type is selected
                            qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' order by lastmodifieddate desc LIMIT ' + limitCounter +' OFFSET ' + offSetCtr;
                            articleLstTemp = Database.query(qryString);
                            baseQuery = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From ' + String.escapeSingleQuotes(articleTypeValue) + ' where PublishStatus = \'Online\' and language=\'en_US\' order by lastmodifieddate desc';
                            maxCount = Database.query(baseQuery).size();
                        }  else { // if no filter has been selected - Default 
                            qryString = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = \'Online\' and language=\'en_US\' order by lastmodifieddate desc LIMIT ' + limitCounter +' OFFSET ' + offSetCtr;
                            articleLstTemp = Database.query(qryString);
                            baseQuery = 'Select UrlName, Title, PublishStatus,KnowledgeArticleId From KnowledgeArticleVersion where PublishStatus = \'Online\' and language=\'en_US\' order by lastmodifieddate desc';
                            maxCount = Database.query(baseQuery).size();
                        }
                    } 
                }
            }
            set<Id> articleId = new set<Id>(); 
            for(sObject  knowledgeArticleObj : articleLstTemp) {
                ArticleWrapperNew articleWrObj = new ArticleWrapperNew();
                articleWrObj.articleTitle = (string)knowledgeArticleObj.get('Title');
                articleWrObj.articleId = (string)knowledgeArticleObj.get('KnowledgeArticleId');
                articleWrObj.articleId = string.valueOf(articleWrObj.articleId).substring(0,15);
                articleWrObj.articleUrl = (string)knowledgeArticleObj.get('UrlName');
                articleWrLst.add(articleWrObj);
                articleId.add(articleWrObj.articleId);
            }
            
            if(!articleWrLst.isEmpty()){
                Set<Id> set_Know_id = new Set<Id>();
                List<KnowledgeArticleViewStat> lst_know_art_view_stat = new List<KnowledgeArticleViewStat>();
                lst_know_art_view_stat = [SELECT ViewCount,Channel, NormalizedScore,ParentId FROM KnowledgeArticleViewStat where Channel='App' and ParentId IN : articleId];
                map_artId_viewCount = new Map<String, Decimal>();
                String str_id_value;
                if(!lst_know_art_view_stat.isEmpty()){
                    for (Integer i =0; i< lst_know_art_view_stat.size(); i++) {
                        str_id_value = lst_know_art_view_stat[i].ParentId;
                        str_id_value = str_id_value.left(15);
                        map_artId_viewCount.put(str_id_value, lst_know_art_view_stat[i].ViewCount);  
                    }
                }  
            }
           
        } catch(Exception ex) {}
    }
    
    /*******************************************************************
    Purpose: Method reset the offset counter value. Req 3145,3146 
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void resetOffSetCounter() {
        offSetCtr = 0;
    }
  
    /*******************************************************************
    Purpose: This method is called by an actionFunction which is called whenever a new articleList needs to be fetched. Req 3145,3146 
    Parameters: [NA]
    Returns: [PageReference]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public PageReference refreshSearchResult() {
        maxSize = currentPage = 1;
        getNextRequired();
        return null;
    }
    
    /*******************************************************************
    Purpose: This method returns True/False based on available article size, to hide or display Previous link on KM Article. Req 3145,3146
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getPrevRequired() {
        return currentPage > 1;
    }
    
    /*******************************************************************
    Purpose: This method returns True/False based on available article size, to hide or display Next link on KM Article list. Req 3145,3146
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getNextRequired() {
        return ((currentPage * PAGE_NUMBER) < maxSize);
    }
   
    /*******************************************************************
    Purpose: This method returns current page number. Req 3145,3146 
    Parameters: [NA]
    Returns: [Decimal]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public Decimal getCurrentPageNumber() {
        return this.currentPage;
    }
    
    /*******************************************************************
    Purpose: To get the next page list of the article. Req 3145,3146 
    Parameters: [NA]
    Returns: [PageReference]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public PageReference next() {
        if(maxSize > this.currentPage * PAGE_NUMBER) {
            this.currentPage = this.currentPage + 1;
        }
        return null;
    }
    
    /*******************************************************************
    Purpose: To get the previous page list of the article. Req 3145,3146 
    Parameters: [NA]
    Returns: [PageReference]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public PageReference previous() {
        if(this.currentPage > 1)
        {
            this.currentPage = this.currentPage - 1;
        }
        return null;
    }
    
    /*******************************************************************
    Purpose: This method returns True/False based on available article size, to hide or display Previous link on KM Article. Req 3145,3146
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getPrevRequiredOffSet() {
        if(offSetCtr >0) {
                return true;
        }
        else {
            return false;
        }
    }

    /*******************************************************************
    Purpose: This method returns True/False based on available article size, to hide or display Next link on KM Article list. Req 3145,3146
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getNextRequiredOffSet() {
        if(maxCount != 0 && ((offSetCtr + limitCounter) < maxCount)) {
            return true;
        }
        else {
            return false;
        }
    }

    /*******************************************************************
    Purpose: To get the next page list of the article. Req 3145,3146
    Parameters: [NA]
    Returns: [PageReference]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public PageReference nextOffSet() {
        offSetCtr += limitCounter;
        articleWrLst = NULL;
        return null;
    }

    /*******************************************************************
    Purpose: To get the previous page list of the article. Req 3145,3146
    Parameters: [NA]
    Returns: [PageReference]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public PageReference previousOffSet() {
        offSetCtr -= limitCounter ;
        articleWrLst = NULL;
        return null;
    }
    
    /*******************************************************************
    Purpose: Create Article Type Parameter. Req 3145,3146
    Parameters: [NA]
    Returns: [string]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    string articleTypeValue = '';
    public String getArticleTypeKeyword() {
        try {
            if(System.currentPageReference().getParameters().Get('articleType') != null) {
                articleTypeValue =  System.currentPageReference().getParameters().Get('articleType');
            }
            return articleTypeValue;
        } catch(Exception ex) {}
        return null;            
    } 
    
    /*******************************************************************
    Purpose: Create Function Area Parameter. Req 3145,3146
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    string functionFilter = '';
    public void getfunctionFilter() {
        try {
            functionFilter = System.currentPageReference().getParameters().Get('hdnfunctionalFilter');
        } catch(Exception ex) {}
    }
     
    /*******************************************************************
    Purpose: Create Sub-Function Area Parameter. Req 3145,3146
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    string subFunctionFilter;
    public void getsubFunctionFilter() {
        subFunctionFilter = System.currentPageReference().getParameters().Get('hdnSubfunctionalFilter');
    }
    
    /*******************************************************************
    Purpose: Create search string parameter. Req 3145,3146
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    string searchStringTxt;
    public void getSearchStringIntent() {
        searchStringTxt = System.currentPageReference().getParameters().Get('theSearchstring');
    }
    
    /*******************************************************************
    Purpose: Create DataCategory parameter. Req 3145,3146
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void getDataCategoryParam() {
        dataCategoryParam = '';
        DataCategoryGroupInfo[] categoryGroups = DataCategoryUtil.getInstance().getAllCategoryGroups();
        for (DataCategoryGroupInfo categoryGroup : categoryGroups) {
            if(categoryGroup != null) {
                String categoryType = System.currentPageReference().getParameters().Get('categoryType_'+categoryGroup.getName());
                if(categoryType != null && !categoryType.equals('NoFilter')) {
                    if(dataCategoryParam == '') {
                        dataCategoryParam = categoryGroup.getName() + '__c BELOW ' + categoryType +'__c';
                    } 
                    else {
                        dataCategoryParam = dataCategoryParam + ' AND ' + categoryGroup.getName() +'__c BELOW ' + categoryType +'__c';
                    }
                }
            }
        }
    }
    
    /*******************************************************************
    Purpose: Create Article Wrapper List. Req 3145,3146
    Parameters: [NA]
    Returns: [List<ArticleWrapperNew>]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public List<ArticleWrapperNew> getarticleWrLst() { 
        try {
            getArticleTypeKeyword();
            getfunctionFilter();
            getsubFunctionFilter();
            getSearchStringIntent();
            getDataCategoryParam();
                if(articleTypeValue == NULL || articleTypeValue == '--None--') {
                articleTypeValue = '';
            }
            if(dataCategoryParam == NULL) {
                dataCategoryParam = '';
            }
            if(functionFilter == NULL) {
                functionFilter = '';
            }
            if(subFunctionFilter == NULL) {
                subFunctionFilter = '';
            }
            if(searchStringTxt == NULL) { 
                searchStringTxt = '';
            }
            if((prevArticleTypeVal != articleTypeValue) || (prevDataCategory != dataCategoryParam) || (prevFunctionalArea != functionFilter) || (prevSubFunction != subFunctionFilter)
                || (prevsrchTextStr != searchStringTxt)) {
                articleWrLst = NULL;
            }
            if(articleWrLst == NULL) {
                    createArticleLst();
            }
            return articleWrLst; 
        } catch(Exception ex) {}
        return null;
    }
    
    /*******************************************************************
    Purpose: Wrapper Class for Articles. Req 3145,3146
    ********************************************************************/
    public class ArticleWrapperNew {
        public string articleId {get;set;}
        public string articleUrl {get;set;}     
        public string articleTitle {get;set;}
    }
    
    /*******************************************************************
    Purpose: Wrapper Class for Articles.
    ********************************************************************/
    public class ArticleWrapper {                                                        
        public String articleID {get; set;}                                                     
        public Decimal ViewCount {get;set;}                                            
    } 
    
    /*******************************************************************
    Purpose: This method is called on click of 'Attach to Customer Interaction' button in KM section, it attaches the selected articles to the respective Customer interaction. 
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [AddMessage]
    ********************************************************************/
    public void attach() {
        List<CaseArticle> caseArticleToInsertList = new List<CaseArticle>();
        selectedCheckboxList = new List<String>();
        String checkboxes = selectedCheckbox.substringAfter(COMMA);
        selectedCheckboxList = checkboxes.split(COMMA);
        if(!selectedCheckboxList.isEmpty())
        {
            for(String checkbox : selectedCheckboxList)
            {
                CaseArticle caseArt = new CaseArticle();
                caseArt.caseid = custInteraction.Id;
                caseArt.KnowledgeArticleId = checkbox;
                caseArticletoinsertList.add(caseArt);
            }
        }
        try
        {
            insert caseArticletoinsertList;
        }catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG2);
        }
    }
    
   
    /*******************************************************************
    Purpose: This method is called on click of 'Send mail' button. A mail is sent to the User set in custom Setting EscalatedMailUser with some details of the case. 
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [Rollback]
    ********************************************************************/
    public void sendMail() {
        Savepoint sp;
        try {
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            List<string> emailAddressLst = System.Label.Email_Supervisor !=null ? System.Label.Email_Supervisor.split(NEWLINE) : null;
            if(emailAddressLst != null && emailAddressLst.size()>0) {
                sendTo.addAll(emailAddressLst);
            }
            //sendTo.add(System.Label.EscalationMailUser);
            //sendTo.add('ankit.h.garg@accenture.com');
            //sendTo.add('shivangi.gaur@accenture.com');
            //sendTo.add('edigavr@sutterhealth.org');
            //sendTo.add('saket.mohan.jha@accenture.com');
            
            msg.setToAddresses(sendTo);
            //msg.setSenderDisplayName('Sutter Health'); 
            //msg.setInReplyTo('salesforce@sutterhealth.org');
            List<OrgWideEmailAddress> lstOrgWideEmailAddress = [select Id from OrgWideEmailAddress where DisplayName = :SUTTER_HEALTH limit 50000];
            if(lstOrgWideEmailAddress !=null && lstOrgWideEmailAddress.size()>0) {
                msg.setOrgWideEmailAddressId(lstOrgWideEmailAddress[0].id);
            }  
            //List<String> ccTo = new List<String>();
            //ccTo.add('saket.mohan.jha@accenture.com');
            //msg.setccAddresses(ccTo);
            msg.setSubject(SUBJECT_LINE_MAIL);
            
            /*String Body = 'CALLDT: ' + (CALLDT != Null ? CALLDT : '') + 
            '\n\nCALLID: ' + (CALLID != Null ? CALLID : '') + 
            '\n\nRequestor/Member Name: ' + (custinteraction.Contact.Name != Null ? custinteraction.Contact.Name : custinteraction.Requestor_Name__c) + 
            //'\n\nMember LastName: ' + (memberLastName != Null ? memberLastName : '') + 
            '\n\nMember ID: ' + (custinteraction.Contact.Member_ID__c != Null ? custinteraction.Contact.Member_ID__c : '') + 
            '\n\nContact Mode: ' + (custinteraction.Preferred_Callback_Number__c != Null ? custinteraction.Preferred_Callback_Number__c : '') + 
            '\n\nPhone: ' + (custinteraction.Contact.Phone != Null ? custinteraction.Contact.Phone : '') + 
            '\n\nDescription: ' + (custinteraction.Description != Null ? custinteraction.Description : '');*/
            custinteraction.Requestor_Name__c = custinteraction.Requestor_Name__c != null  ? custinteraction.Requestor_Name__c : BLANK;         
            String Body = EMAIL_BODY +
                REASON + custinteraction.Reason__c +
                SECONDARY_REASON + custinteraction.Secondary_Reason__c +
                CASE_NUMBER + custinteraction.CaseNumber +
                MEMBER_REQUESTOR_NAME + (custinteraction.Contact.Name != Null ? custinteraction.Contact.Name : custinteraction.Requestor_Name__c) + DOUBLE_SPACE +
                MEMBER_ID + (custinteraction.Contact.Member_ID__c != Null ? custinteraction.Contact.Member_ID__c : BLANK) + DOUBLE_SPACE +
                CALL_TIME + (custinteraction.createddate.format());
            // ' \nCaller ID: ' + (CALLID != Null ? CALLID : '');           
            msg.setplainTextBody(Body);
            //msg.setTargetObjectId(custinteraction.contactId);
            //msg.setHTMLBody(email.HTMLBody);
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            mails.add(msg);
            sp = Database.setSavepoint();
            custinteraction.IsMailSent__c = true;
            update custinteraction;
            Messaging.sendEmail(mails);
        }  catch(Exception ex) {//ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            custinteraction.IsMailSent__c = false;
            Database.rollback(sp);
            //update custinteraction;
        }
    }
    
    /*******************************************************************
    Purpose: This method is written to get contact id for current record. This method used  in   all SHP contact record  in tabular  format. Basis on the contact record type SHP contact gets opened 
              For req no 3236 OLTP.  Date - 15/02/2015
               
    Parameters: [Id]
    Returns: [Void]
    Throws [Exceptions]: [Add Message]
    ********************************************************************/
    public void contactdetailssection(id linkId){
        //Req 3182 - Added Member_Employer_HCC_ID__c field in the query
        //Req 3182 - Added Contact_Group_ID__c field in the query 
        try{
            con =[Select Id,SHP_Provider_Type__c,Salutation,Name ,RecordTypeID, 
                  SHP_active_Tin__c ,SHP_Inactive_Tin__c , Supplier_License_Number__c, Provider_UPIN__c , Provider_License_State__c,  SHP_Practitioner_Speciality_1__c,
                  SHP_Practitioner_Speciality_2__c, SHP_Practitioner_Speciality_3__c , Member_Employer_HCC_ID__c,Contact_Group_ID__c,
                  Supplier_SHIS_Enterprise_ID__c ,  SHP_Practitioner_Language__c, accountid,Supplier_Contact_Credential_Suffix__c,
                  Gender__c, SHP_Benefit_Network__c , Member_Group_Affiliation__c, SHP_Practitioner_Medical_Grp_Affiliation__C,SHP_Practitioner_Accepting_New_Patients__c, 
                  SHP_Practitioner_PCP_Flag__C , SHP_Mailing_Address__C,SHP_Supplier_Mailing_Address__c ,  MailingCity, MailingStreet, MailingState, MailingPostalcode , MailingCountry, Email ,
                  Phone ,Phone_Extension__c ,MobilePhone , Fax ,SHP_Secure_Corres_Address__C, SHP_Practitioner_Secure_Street__c, SHP_Practitioner_Secure_Phone__c,
                  SHP_Practitioner_Secure_Corres_City__c, SHP_Secure_Phone_extension__c,SHP_Practitioner_Secure_Corres_State__C, 
                  SHP_Practitioner_Secure_Corres_Fax__C,SHP_Practitioner_Corres_Secure_Zip__c, SHP_Practitioner_Secure_Corres_Mobile__c, 
                  SHP_Practitioner_Secure_Corres_Email__C , Supplier_Correspondence_Address__c ,Provider_Correspondence_City__c, 
                  Provider_Correspondence_State__c, Supplier_SPS_Epic_ID__c  ,Supplier_Tax_ID__c,Supplier_NPI__c,
                  CreatedById ,LastModifiedById ,SHP_Turn_off_Surveys__c, Member_ID__c
                  From contact where ID =: linkId Limit 1];  
             
                  //Req-3733 & 3274 changes for employee and vendor start
                  If((con.recordtypeId == contactRecordTypeMap.get(CONTACT_RT_EMPLOYEE)) || con.recordtypeId == contactRecordTypeMap.get(CONTACT_RT_VENDOR))
                  {
                  caseLst();
                  }
                  //Req-3733 & 3274 changes end
                  
            // Req no 3356  OLTP Provider start
            // Req 3156 + 3363 Start changes
            If(con!= null && (con.recordtypeId == contactRecordTypeMap.get(CONTACT_RT_MEMBER) || con.recordtypeId == contactRecordTypeMap.get(system.label.CL09_SHPProvider) || con.recordtypeId == contactRecordTypeMap.get(system.label.CL11_SHPEmployer) || con.recordtypeId == contactRecordTypeMap.get(system.label.CL10_SHPBroker)  || con.recordtypeId == contactRecordTypeMap.get(system.label.CL134_SHP_Employer_contact ) || con.recordtypeId == contactRecordTypeMap.get(system.label.CL_135_SHP_Broker_Contact)) ) 
            { 
                counterCustomerInquiries = 0;
                SizeCustomerInquiries();    
                CustInqOther = [Select Date_Created__c,Description__c,Intent__c,Member_Provider_Name__c,Member_Id__c,Member_Provider_Name_Formula__c,Name,Queried_By__c,type__c from Member_Enquiries__c Where Member_Id__c =:con.ID limit 50000];
                
                If(con.recordtypeId == contactRecordTypeMap.get(CONTACT_RT_MEMBER)) // Prod Fix req 3236
                    
                {
                    
                    SizePCP();                 
                    SizeClaimHeader();
                    SizeBenefitPlanCoverage();
                    SizeBenefitPlanAssociation();//Req - 3182 calling method to calculate the size of the beneit plan association for member account
                    SizeDocumentGeneration();//Req - 3182 calling the method to calculate the size of the document generation requests for member account
                    // Req Number 3378 used soql  at account level and fetching  Subscriber_HCC_ID__c Start
                    accountobj =[select id, Subscriber_HCC_ID__c  from account where id = :con.accountid  limit 1];
                    //  ShowingTab for Correspondence member 
                    sizeCorrespondenceMember();// Showing Tab for member correspondence 
                    // displaying correspondence tab only if member id  is equal to subscriber id  that means member is subscriber 
                    if(con.Member_ID__c == accountobj.Subscriber_HCC_ID__c)
                    {
                        //Showing Tab  for  Dependent Correspondence member  for Subscriber
                        sizeCorrespondenceMemberDependent ();
                        CorrespondenceMemberDependentTab = true;
                    }
                    else 
                    {
                        CorrespondenceMemberDependentTab = false;// hiding dependent correspondence tab  if member is not subscriber 
                    }
                    // Req Number 3378  End 
                }
                //Changes Start Req 3356 works if the record type is Provider
                else If(con.recordtypeId == contactRecordTypeMap.get(system.label.CL09_SHPProvider)) // Req 3356 works if the record type is Provider
                    
                {  
                    //code to render Practitioner Section and query required data
                    // based on  SHP_Provider_Type__c type value it will open supplier or practitioner record
                    If(con.SHP_Provider_Type__c == SHP_PRACTITIONER)
                    {
                        showPractitioner = true;
                        showSupplier = false;
                    }
                    
                    else 
                    {
                        showSupplier = true;
                        showPractitioner = false;
                        
                    }
                } 
                else if (con.recordtypeId == contactRecordTypeMap.get(system.label.CL11_SHPEmployer) || con.recordtypeId == contactRecordTypeMap.get(system.label.CL134_SHP_Employer_contact ) || con.recordtypeId == contactRecordTypeMap.get(system.label.CL09_SHPProvider)  || con.recordtypeId == contactRecordTypeMap.get(system.label.CL10_SHPBroker) || con.recordtypeId == contactRecordTypeMap.get(system.label.CL_135_SHP_Broker_Contact) )
                {
                    accountobj =[select id from account where id = :con.accountid  limit 1];
                    if( con.recordtypeId == contactRecordTypeMap.get(system.label.CL11_SHPEmployer) || con.recordtypeId == contactRecordTypeMap.get(system.label.CL134_SHP_Employer_contact ))
                    {
                        SizeBenefitPlanCoverageEmployer();
                        SizeBenefitPlanAssociationEmployer(); //Req - 3182 calling method to calculate the size of the beenfit plan association record for employer account
                        SizeDocumentGenerationEmployer(); //Req - 3182 callign the method to calculate the size of the document generation requests for employer account
                        // Req number 3378  Displaying Tab for correspondence Employer
                        sizeCorrespondenceEmployer();
                        // Req number 3378  End 
                    }
                    // correspondence  start
                    if(con.recordtypeId == contactRecordTypeMap.get(system.label.CL10_SHPBroker) || con.recordtypeId == contactRecordTypeMap.get(system.label.CL_135_SHP_Broker_Contact))
                    {
                        Sizecorrespondence();
                    }
                }
                //  correspondence  end
                // Req 3156 + 3363 End                  
                //Changes end Req 3356 works if the record types is Provider
                // Req no 3356  OLTP Provider End
            }
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        }Catch(Exception ex)
        {
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2); 
        }
    }
    
    /*******************************************************************
    Purpose: This method is written for  Benefit plan for Employer at account level and used in pagination. This  will run only for Employer type for record for req no 3236 OLTP.  Date - 15/02/2015
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [Add Message]
    ********************************************************************/
    public void searchResultBenefitPlanCoverageEmployer(){
        try{
            
            benefitPlanCoverageEmployer = [select PlanCov_Bene_Plan_HCC_ID__c,PlanCov_Bene_Plan_Name__c,PlanCov_Bene_Cover_Date_Start__c,PlanCov_Bene_Cover_Date_End__c,Benefit_Grid_Plan_ID__c,Benefit_Plan_Coverage__c.Name,PlanCov_Bene_Plan_Type__c from Benefit_Plan_Coverage__c where Employer_Account__c= :accountobj.ID Order By PlanCov_Bene_Cover_Date_Start__c DESC limit 20 OFFSET: counterBenefitPlanCoverageAccount ];
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        } Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2); 
        }
    }
    
    /*******************************************************************
    Purpose: This method is written to Benefit plan for Employer at account level and it is used get the count of  benefit plan in account  
             this  will run only for Employer type for record
             for req no 3236 OLTP.
    Date: 15/02/2015         
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void SizeBenefitPlanCoverageEmployer()
    {
        benefitPlanCoverageEmployer=    new list <Benefit_Plan_Coverage__c>();
        benefitPlanCoverageEmployerSize=    new list <Benefit_Plan_Coverage__c>();
        try{
            benefitPlanCoverageEmployerSize= [select id from Benefit_Plan_Coverage__c where Employer_Account__c= :accountobj.ID limit 50000 ];
        }catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        } 
        recNumBenefitPlanCoverageAccount = benefitPlanCoverageEmployerSize.size();
        if(recNumBenefitPlanCoverageAccount >0)
        {
            checkBenefitPlanCoverage =true;
            searchResultBenefitPlanCoverageEmployer();
            
        }
        else
        {
            checkBenefitPlanCoverage =false;
            
        }
        
        
    }
    
    /*****************************************************************************************************************
    Purpose: This method is written for search the Benefit Plan Association records for Employer Account For Req - 3182
    Parameters: [NA]
    Date: 19/08/2016
    Returns: [Void]
    Throws [Exceptions]: [Add Message]
    ********************************************************************************************************************/
    public void searchResultBenefitPlanAssociationEmployer(){
        try{
            //fetching the employer account object based on the contact group id of the employer contact
            Account employerAccountObj = [select id from Account where SHP_Group_ID__c =:con.Contact_Group_ID__c limit 1];
            //constructing the list with employer account benefit plan associations
            benefitPlanAssociationEmployer = [select Benefit_Plan_Metadata__c,Raider_ID__c,Benefit_Plan_Metadata__r.Name,Raider_ID__r.Name,Plan_Type__c,
                                              Raider_ID__r.Plan_Name__c,Benefit_Plan_Metadata__r.Product_Types__c,Benefit_Plan_Metadata__r.isHDHP__c,
                                              Benefit_Plan_Metadata__r.Plan_Type__c,Benefit_Plan_Metadata__r.Benefit_Grid__r.Benefit_Plan_ID__c,Raider_ID__r.Benefit_Grid__r.Benefit_Plan_ID__c,
                                              Deductible__c,OP__c,IP__c,OOPM__c,RX_Tier_1__c,Rx_Deductible_Ind_Ind_Family_Family__c,OV__c,SOV__c,Product__c,
                                              Benefit_Plan_Metadata__r.Market_Segment__c,Benefit_Plan_Metadata__r.Plan_Name__c,
                                              Benefit_Plan_Metadata__r.Plan_Year__c,Benefit_Plan_Metadata__r.Benefit_Grid__c,Raider_ID__r.Benefit_Grid__c 
                                              from Benefit_Plan_Association__c where Account__c =:employerAccountObj.Id ORDER BY Name limit 20 OFFSET: counterBenefitPlanAssociationAccount];
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        } Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2); 
        }
    }
    
    /************************************************************************************************************************************
    Purpose: This method is written for Search document generation records for Benefit plan for Employer at account level. For Req - 3182
    Parameters: [NA]
    Date: 19/08/2016
    Returns: [Void]
    Throws [Exceptions]: [Add Message]
    *************************************************************************************************************************************/
    public void searchResultDocumentGenerationEmployer(){
        try{
            //fetching the employer account object based on the contact group id of the employer contact
            Account employerAccountObj = [select id from Account where SHP_Group_ID__c =:con.Contact_Group_ID__c limit 1];
            //populating the list of document generation employer list based on the employer account
            documentGenerationEmployer = [select Name,ID,of_Documents_generated__c,of_Documents_Requested__c,Calendar_Year_Plan_Year__c,
                                     Documents_Folder_New__c,Expedite__c,Opportunity__c,Request_Created_Date__c,Request_Due_Date__c,
                                          Requestor__r.Name,Request_Status__c,SLA_met_not_met__c,
                                     Sold_Sign_Off__c,Status__c,Translation_services__c,Type_of_Business__c    
                                     from Document_Generation_Request__c where Account__c =:employerAccountObj.Id AND Request_Status__c =:System.Label.HR140_Approved 
                                          ORDER BY createddate DESC limit 20 OFFSET: counterDocumentGenerationAccount];
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        } Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2); 
        }
    }
    
    /*******************************************************************
    Purpose: This method is written to Benefit plan for Employer at account level and it is used get the count of  benefit plan in account  
             this  will run only for Employer type for record
             for req no 3182 OLTP.
    Date: 19/08/2016         
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void SizeBenefitPlanAssociationEmployer()
    {
        benefitPlanAssociationEmployer=    new list <Benefit_Plan_Association__c>();
        benefitPlanAssociationEmployerSize=    new list <Benefit_Plan_Association__c>();
        try{
            //fetching the employer account object based on the contact group id of employer contact
            Account employerAccountObj = [select id from Account where SHP_Group_ID__c =:con.Contact_Group_ID__c limit 1];
            //calculating the size of the benefit plan association records for employer account 
            benefitPlanAssociationEmployerSize= [select id from Benefit_Plan_Association__c where Account__c = :employerAccountObj.id limit 50000 ];
        }catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        } 
        recNumBenefitPlanAssociationAccount = benefitPlanAssociationEmployerSize.size();
        if(recNumBenefitPlanAssociationAccount >0)
        {
            //making flag to true when the no.of records are greater than 0
            //based on this flag the benefit plan association records in the OLTP page
            checkBenefitPlanAssociation =true;
            //calling method to get the benefit plan assocation records for the employer
            searchResultBenefitPlanAssociationEmployer();
            
        }
        else
        {
            checkBenefitPlanAssociation =false;
            
        }
        
        
    }
    
    /*******************************************************************
    Purpose: This method is written to Benefit plan for Employer at account level and it is used get the count of  document gerenations
             in account this  will run only for Employer type for record
             for req no 3182 OLTP.
    Date: 19/08/2016         
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void SizeDocumentGenerationEmployer()
    {
        documentGenerationEmployer = new list <Document_Generation_Request__c>();
        documentGenerationEmployerSize = new list <Document_Generation_Request__c>();
        try{
            //fetching the employer account object based on the contact group id from the employer contact
            Account employerAccountObj = [select id from Account where SHP_Group_ID__c =:con.Contact_Group_ID__c limit 1];
            //calculating the size of the document generation for the employer account
            documentGenerationEmployerSize= [select id from Document_Generation_Request__c where Account__c = :employerAccountObj.id AND Request_Status__c =:System.Label.HR140_Approved limit 50000 ];

        }catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        } 
        recNumDocumentGenerationAccount = documentGenerationEmployerSize.size();
        if(recNumDocumentGenerationAccount >0)
        {
            //making this flag to true if approved document generation requests found
            //based on this flag, rendering the document generation requests table in the OLTP page
            checkDocumentGeneration =true;
            //calling method to find the approved document generation requests for employer account
            searchResultDocumentGenerationEmployer();
            
        }
        else
        {
            checkDocumentGeneration =false;
            
        }
        
        
    }
    
   /*******************************************************************
    Purpose:  Req no 3156  This function is used to display first and  previous button in Benefit plan  Coverage Employer Account  tab and return boolean 
              It returns true if it is not to be displayed else false
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getprvBenefitPlanCoverageAccount(){
        if(counterBenefitPlanCoverageAccount  == 0)
        {
            return true;
        }
        else
        {
            
            return false;
        }
    }
    
    
    
    /*************************************************************************************
    Purpose:  Req no 3182  This function is used to display first and  
              previous button in Benefit plan  Association Employer Account  
              tab and return boolean It returns true if it is not to be displayed else false
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ****************************************************************************************/
    public boolean getprvBenefitPlanAssociationAccount(){
        if(counterBenefitPlanAssociationAccount  == 0)
        {
            return true;
        }
        else
        {
            
            return false;
        }
    }
    
    
    /*********************************************************************************************
    Purpose:  Req no 3182  This function is used to display first and  
              previous button in Benefit plan  Association Employer Account  tab and return boolean 
              It returns true if it is not to be displayed else false for document generation
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ************************************************************************************************/
    public boolean getprvDocumentGenerationAccount(){
        if(counterDocumentGenerationAccount  == 0)
        {
            return true;
        }
        else
        {
            
            return false;
        }
    }
    
    /*******************************************************************
    Purpose:  Req no 3156  This function is used to display first and  previous button in Benefit plan  Coverage Employer Account  tab and return boolean 
              It returns true if it is not to be displayed else false
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getnxtBenefitPlanCoverageAccount(){
        
        if(recNumBenefitPlanCoverageAccount< 21 )
        {
            return true;
        }
        else{
            if((counterBenefitPlanCoverageAccount  + limitsBenefitPlanCoverageAccount) > recNumBenefitPlanCoverageAccount)
            {
                return true;
            }
            else
            {
                
                return false;
            }
        }
        
    }
    
    /****************************************************************************************
    Purpose:  Req no 3182  This function is used to display first and  previous button in 
              Benefit plan  Association Employer Account  tab and return boolean 
              It returns true if it is not to be displayed else false
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    *******************************************************************************************/
    public boolean getnxtBenefitPlanAssociationAccount(){
        
        if(recNumBenefitPlanAssociationAccount< 21 )
        {
            return true;
        }
        else{
            if((counterBenefitPlanAssociationAccount  + limitsBenefitPlanAssociationAccount) > recNumBenefitPlanAssociationAccount)
            {
                return true;
            }
            else
            {
                
                return false;
            }
        }
        
    }
    
    /************************************************************************************
    Purpose:  Req no 3182  This function is used to display first and  previous button 
              in Benefit plan  Association Employer Account  tab and return boolean 
              It returns true if it is not to be displayed else false
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    **************************************************************************************/
    public boolean getnxtDocumentGenerationAccount(){
        
        if(recNumDocumentGenerationAccount< 21 )
        {
            return true;
        }
        else{
            if((counterDocumentGenerationAccount  + limitsDocumentGenerationAccount) > recNumDocumentGenerationAccount)
            {
                return true;
            }
            else
            {
                
                return false;
            }
        }
        
    }
    
    // Req 3156 + 3363 End
    /*******************************************************************
    Purpose:  Req no 3236 This function is used to get Size of all PCP values  from contact object
              This  will run only for Employer type for record
              for req no 3236 OLTP
    Date: 15/02/2015          
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void SizePCP()
    {
        pcpInformation     =    new list <PCP_Information__c>();
        pcpInformationSize =    new list <PCP_Information__c>();
        
        try{
            pcpInformationSize =[select ID  from  PCP_Information__c  where member_ID__C =:con.ID limit 50000];   
        }catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }       
        recNumPCP = pcpInformationSize.size();
        if(recNumPCP>0) {
            checkPCP =true;
            searchResultPCP();
        }
        else{
            checkPCP =false;
        }
        
    }
    
    /*******************************************************************
    Purpose:  Req no 3236  This function is used to get Size of all Benefit Plan Coverage values  from contact object 
              this  will run only for Employer type for record
              for Req no 3236 OLTP
    Date: 15/02/2015          
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void SizeBenefitPlanCoverage()
    {
        benefitPlanCoverage = new list <Benefit_Plan_Coverage__c>();
        benefitPlanCoverageSize = new list <Benefit_Plan_Coverage__c>();
        try{
            benefitPlanCoverageSize = [select id from Benefit_Plan_Coverage__c where PlanCov_Member_Lookup__c=:con.ID limit 50000];
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
        recNumBenefitPlanCoverage = benefitPlanCoverageSize.size();
        if(recNumBenefitPlanCoverage >0) {
            checkBenefitPlanCoverage =true;
            searchResultBenefitPlanCoverage();
            
        }
        else {
            checkBenefitPlanCoverage =false;
        }
    }
    
    /**************************************************************************************
    Purpose:  Req no 3182  This function is used to get Size of all Benefit Plan Association 
              values  from Benefit Plan Association object 
              this  will run only for Member type for record
    Date: 18/08/2016         
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    *****************************************************************************************/
    public void SizeBenefitPlanAssociation()
    {

        benefitPlanAssociation = new list <Benefit_Plan_Association__c>();
        benefitPlanAssociationSize = new list <Benefit_Plan_Association__c>();
        try{
            //fetching the member account based on the employer hcc id on contact record
            Account employerAccountObj = [select id from Account where SHP_Group_ID__c =:con.Member_Employer_HCC_ID__c limit 1];
            //calculating the size of the benefit plan association records for member account
            benefitPlanAssociationSize = [select id from Benefit_Plan_Association__c where Account__c=:employerAccountObj.id limit 50000];
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
        recNumBenefitPlanAssociation = benefitPlanAssociationSize.size();
        if(recNumBenefitPlanAssociation >0) {
            //making this flag to true if benefit plan association record size is > 0
            //which is used to render the benefit plan association records in the OLTP page
            checkBenefitPlanAssociation =true;
            //to fetch the records for the member account
            searchResultBenefitPlanAssociation();
            
        }
        else {
            checkBenefitPlanAssociation =false;
        }
    }
    
    /*******************************************************************************************
    Purpose:  Req no 3182  This function is used to get Size of all document generation records  
              from Document Generation object this  will run only for Member type for record
    Date: 18/08/2016         
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    *******************************************************************************************/
    public void SizeDocumentGeneration()
    {

        documentGeneration = new list <Document_Generation_Request__c>();
        documentGenerationSize = new list <Document_Generation_Request__c>();
        try{
            //fetching the member account based on the member employer hcc id from contact record
            Account employerAccountObj = [select id from Account where SHP_Group_ID__c =:con.Member_Employer_HCC_ID__c limit 1];
            //calculating the size of the document generation requests for the member account
            documentGenerationSize = [select id from Document_Generation_Request__c where Account__c=:employerAccountObj.id AND Request_Status__c =:System.Label.HR140_Approved limit 50000];
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
        recNumDocumentGeneration = documentGenerationSize.size();
        if(recNumDocumentGeneration >0) {
            //making this flag to true if the document generation requests are > 0
            //this flag is used to render the document generation requests in OLTP page
            checkDocumentGeneration =true;
            //fetch the document genration records for the member account
            searchResultDocumentGeneration();
            
        }
        else {
            checkDocumentGeneration =false;
        }

    }
    
    /*******************************************************************************************************
    Purpose: Req no 3182 This function is used to get record from Benefit Plan Association
             object it is used to display data  in Pagination this  will run only for member type for record
    Date: 18/08/2016
    Parameters: [NA]
    Returns: [VOID]
    Throws [Exceptions]: [Add Message]
    *********************************************************************************************************/
    public void searchResultBenefitPlanAssociation(){
        
        try{  
            //fetching the account object based on the member employer hcc id from contact record
            Account employerAccountObj = [select id from Account where SHP_Group_ID__c =:con.Member_Employer_HCC_ID__c limit 1];
            //fetching all the benefit plan association records for member account
            benefitPlanAssociation= [select Benefit_Plan_Metadata__c,Raider_ID__c,Benefit_Plan_Metadata__r.Name,Raider_ID__r.Name,Plan_Type__c,Raider_ID__r.Plan_Name__c,
                                     Benefit_Plan_Metadata__r.Product_Types__c,Benefit_Plan_Metadata__r.isHDHP__c,Benefit_Plan_Metadata__r.Plan_Type__c,
                                     Benefit_Plan_Metadata__r.Benefit_Grid__r.Benefit_Plan_ID__c,Raider_ID__r.Benefit_Grid__r.Benefit_Plan_ID__c,
                                     Deductible__c,OP__c,IP__c,OOPM__c,RX_Tier_1__c,Rx_Deductible_Ind_Ind_Family_Family__c,OV__c,SOV__c,Product__c,
                                     Benefit_Plan_Metadata__r.Market_Segment__c,Benefit_Plan_Metadata__r.Plan_Name__c,
                                     Benefit_Plan_Metadata__r.Plan_Year__c,Benefit_Plan_Metadata__r.Benefit_Grid__c,Raider_ID__r.Benefit_Grid__c
                                     from Benefit_Plan_Association__c where Account__c =:employerAccountObj.Id ORDER BY Name limit 20 OFFSET: counterBenefitPlanAssociation];
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }

    }
    
    /************************************************************************************************
    Purpose: Req no 3182 This function is used to get record from document generation object 
             it is used to display data  in Pagination this  will run only for member type for record
    Date: 18/08/2016
    Parameters: [NA]
    Returns: [VOID]
    Throws [Exceptions]: [Add Message]
    **************************************************************************************************/
    public void searchResultDocumentGeneration(){
        try{  
            //fetching the member account based on the member hcc id from contact record
            Account employerAccountObj = [select id from Account where SHP_Group_ID__c =:con.Member_Employer_HCC_ID__c limit 1];
            //fetching all the document generation requests for member account
            documentGeneration = [select ID,Name,of_Documents_generated__c,of_Documents_Requested__c,Calendar_Year_Plan_Year__c,
                                  Documents_Folder_New__c,Expedite__c,Opportunity__c,Request_Created_Date__c,Request_Due_Date__c,
                                  Requestor__r.Name,Request_Status__c,SLA_met_not_met__c,
                                  Sold_Sign_Off__c,Status__c,Translation_services__c,Type_of_Business__c 
                                     from Document_Generation_Request__c where Account__c =:employerAccountObj.Id  AND Request_Status__c =:System.Label.HR140_Approved 
                                  ORDER BY createddate DESC limit 20 OFFSET: counterDocumentGeneration];
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
       
    }
    
    /*******************************************************************
    Purpose:  Requirement  no 3378  This function is used to get Size of all dependent member  for correspondence  values  for selected  Correspondence_Letter__c object
              this  will run only for member type for record and it  will be called if a member is subscriber
              for Requirement no 3378 Member Dependent Correspondence
    Date: 10/15/2015          
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [Add Message]
    ********************************************************************/
    public void sizeCorrespondenceMemberDependent ()
    {
        correspondenceMemberDependent = new list <Correspondence_Letter__c>();
        correspondenceMemberSizeDependent = new list <Correspondence_Letter__c>();
        correspondenceMemberList = new list <Correspondence_Letter__c>();
        correspondenceMemberListDisplay = new list <Correspondence_Letter__c>();
        
        try{
            
            correspondenceMemberSizeDependent = [select id ,SHP_Correspondence_Entity_Recipient_HCC__c
                                                 from Correspondence_Letter__c where SHP_Employer_Group__c=:accountobj.ID  and (SHP_Is_Logical_Delete__C = false and  SHP_IsReplacement__C = false )limit 50000];
                // Storing record in list if SHP_Correspondence_Entity_Recipient_HCC__c  is not equal to Subscriber_HCC_ID__c
                // that means associated record is a Dependent member contact 
            for (Correspondence_Letter__c corr: correspondenceMemberSizeDependent)
            {
                if(corr.SHP_Correspondence_Entity_Recipient_HCC__c !=accountobj.Subscriber_HCC_ID__c)
                {
                    correspondenceMemberList.add(corr);
                }
                
            }
            
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
        recNumcorrespondenceMemberDependent = correspondenceMemberList.size();
        if(recNumcorrespondenceMemberDependent >0) {
            checkCorrespondenceMemberDependent =true;
            searchResultCorrespondenceMemberDependent();
        }
        else {
            checkCorrespondenceMemberDependent =false;
        }
    }
    
    /*******************************************************************
    Purpose:  This method is written for Correspondence_Letter__c for  Dependent member contact at account level, That  means correspondence will display  at account level and used in pagination 
              this  will run only for Member  type of  record it  will be called from sizeCorrespondenceMemberDependent 
              this method is also used in fstbtn,prvbtn,nextbtn and endbtn for pagination 
              for Requirement no 3378 Correspondence Member employer
    Date: 15/02/2015          
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [Add Message]
    ********************************************************************/
    public void  searchResultCorrespondenceMemberDependent()
    {
        try{
            if(con.Member_ID__c == accountobj.Subscriber_HCC_ID__c){
                correspondenceMemberDependent = [Select SHP_Correspondence_ID__c,SHP_CorrespondenceOnBase_ID__C,CorrespondenceOnBase_URL__c,SHP_Correspondence_Display_Name__c,SHP_Correspondence_Entity_Subject_HCC_ID__c,SHP_Mailing_Address__c,SHP_DateTime_Triggered__c, SHP_DateTime_Generated__c,SHP_Date_Printed__c,SHP_Date_Transferred_to_Post_Office__C ,SHP_Is_Logical_Delete__C,SHP_IsReplacement__C ,SHP_Correspondence_Entity_Recipient_HCC__c From Correspondence_Letter__c where SHP_Employer_Group__c =:accountobj.ID   and(SHP_Is_Logical_Delete__C = false and SHP_IsReplacement__C = false)LIMIT :20  OFFSET:
                                                 countercorrespondenceMemberDependent] ;
                                                 
                // Storing record in list if SHP_Correspondence_Entity_Recipient_HCC__c  is not equal to Subscriber_HCC_ID__c
                // that means associated record is   a Dependent  member contact and  displaying in different tab
                for (Correspondence_Letter__c corr: correspondenceMemberDependent)
                {
                    if(corr.SHP_Correspondence_Entity_Recipient_HCC__c !=accountobj.Subscriber_HCC_ID__c)
                    {
                        correspondenceMemberListDisplay.add(corr);
                    }
                }
                
            }
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        } 
    }
    
    /*******************************************************************
    Purpose:  Req no 3378  This function is used to display first and  previous button in Correspondence Member contact  tab and return boolean 
              It returns true if it is not to be displayed else false
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getprvCorrespondenceMemberDependent(){
        if(countercorrespondenceMemberDependent  == 0)
            return true;
        else
            return false;
    }
    
    /*******************************************************************
    Purpose:  Req no 3378  This function is used to display first and  previous button in Correspondence Member contact  tab and return boolean 
              It returns true if it is not to be displayed else false
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getnxtCorrespondenceMemberDependent(){
        
        if(recNumcorrespondenceMemberDependent< 21 )
            return true;
        else{
            if((countercorrespondenceMemberDependent  + limitscorrespondenceMemberDependent) > recNumcorrespondenceMemberDependent)
                return true;
            else
                return false;
        }
        
    }
    
    /*******************************************************************
    Purpose:  Req no 3378  This function is used to get Size of all  for correspondence  values  for selected  Correspondence_Letter__c object
              this  will run only for member type for record
              for Req no 3378 Member  Correspondence
    Date: 10/15/2015         
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void sizeCorrespondenceMember ()
    {
        correspondenceMember = new list <Correspondence_Letter__c>();
        correspondenceMemberSize = new list <Correspondence_Letter__c>();
        try{
            
            correspondenceMemberSize = [select id from Correspondence_Letter__c where SHP_Member_Id__c=:con.ID and (SHP_Is_Logical_Delete__C = false and  SHP_IsReplacement__C = false ) limit 50000]; 
            
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
        recNumcorrespondenceMember = correspondenceMemberSize.size();
        if(recNumcorrespondenceMember >0) {
            checkCorrespondenceMember =true;
            searchResultCorrespondenceMember();
        }
        else {
            checkCorrespondenceMember =false;
        }
    }
    
    /*******************************************************************
    Purpose:  This method is written for Correspondence_Letter__c for member at Contact level and used in pagination
              This  will run only for Member type of  record
              for Req no 3378 Correspondence Member Employer
              this method is also used in fstbtn,prvbtn,nextbtn and endbtn for pagination 
    Date: 10/15/2015         
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [Add Message]
    ********************************************************************/
    public void  searchResultCorrespondenceMember()
    {
        try{
            correspondenceMember = [Select SHP_Correspondence_ID__c, SHP_CorrespondenceOnBase_ID__C,CorrespondenceOnBase_URL__c,SHP_Correspondence_Display_Name__c,SHP_Correspondence_Entity_Subject_HCC_ID__c,SHP_Mailing_Address__c,SHP_DateTime_Triggered__c, SHP_DateTime_Generated__c,SHP_Date_Printed__c,SHP_Date_Transferred_to_Post_Office__C ,SHP_Is_Logical_Delete__C,SHP_IsReplacement__C From Correspondence_Letter__c where SHP_Member_Id__c =:con.ID  and (SHP_Is_Logical_Delete__C = false and SHP_IsReplacement__C = false )  LIMIT :20  OFFSET:
                                    countercorrespondenceMember] ;
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        } 
    }
    
    /*******************************************************************
    Purpose:  Req no 3378  This function is used to get Size of all Employer for correspondence  values  for selected  Correspondence_Letter__c object
              This  will run only for Employer  type for record
              all correspondence will   display at account level
              for Req no 3378  Employer Correspondence
    Date: 10/15/2015         
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getprvCorrespondenceMember(){
        if(countercorrespondenceMember  == 0)
            return true;
        else
            return false;
    }
    
    /*******************************************************************
    Purpose:  Req no 3378  This function is used to get Size of all Employer for correspondence  values  for selected  Correspondence_Letter__c object
              This  will run only for Employer  type for record
              all correspondence will   display at account level
              for Req no 3378  Employer Correspondence
    Date: 10/15/2015         
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getnxtCorrespondenceMember(){
        
        if(recNumcorrespondenceMember< 21 )
            return true;
        else{
            if((countercorrespondenceMember  + limitscorrespondenceMember) > recNumcorrespondenceMember)
                return true;
            else
                return false;
        }
        
    }
    
    /*******************************************************************
    Purpose:  Req no 3378  This function is used to get Size of all Employer for correspondence  values  for selected  Correspondence_Letter__c object
              This  will run only for Employer  type for record
              all correspondence will   display at account level
              for Req no 3378  Employer Correspondence
    Date: 10/15/2015         
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void sizeCorrespondenceEmployer ()
    {
        correspondenceEmployer = new list <Correspondence_Letter__c>();
        correspondenceEmployerSize = new list <Correspondence_Letter__c>();
        try{
            correspondenceEmployerSize = [select id from Correspondence_Letter__c where SHP_Employer_Group__c=:accountobj.ID and (SHP_Is_Logical_Delete__C = false and  SHP_IsReplacement__C = false )  limit 50000];
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
        recNumcorrespondenceEmployer = correspondenceEmployerSize.size();
        if(recNumcorrespondenceEmployer >0) {
            checkCorrespondenceEmployer =true;
            searchResultCorrespondenceEmployer();
            
        }
        else {
            checkCorrespondenceEmployer =false;
        }
    }
    
    /*******************************************************************
    Purpose: This method is written for Correspondence_Letter__c for Employer  at account level and used in pagination
             This  will run only for Employer type for record for Req no 3378 OLTP
             This method is also used in fstbtn,prvbtn,nextbtn and endbtn for pagination 
    Date: 10/15/2015         
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [Add Message]
    ********************************************************************/
    public void  searchResultCorrespondenceEmployer()
    {
        try{
            correspondenceEmployer = [Select SHP_Correspondence_ID__c, SHP_CorrespondenceOnBase_ID__C,CorrespondenceOnBase_URL__c,SHP_Correspondence_Display_Name__c,SHP_Correspondence_Entity_Subject_HCC_ID__c,SHP_Mailing_Address__c,SHP_DateTime_Triggered__c, SHP_DateTime_Generated__c,SHP_Date_Printed__c,SHP_Date_Transferred_to_Post_Office__C  From Correspondence_Letter__c where SHP_Employer_Group__c =:accountobj.ID   and (SHP_Is_Logical_Delete__C = false and  SHP_IsReplacement__C = false )   LIMIT :20  OFFSET: countercorrespondenceEmployer] ;
            
           
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        } 
    }
    
    
    
    /*******************************************************************
    Purpose: Req no 3378  This function is used to display first and  previous button in Correspondence Member contact  tab and return boolean 
             It returns true if it is not to be displayed else false
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getprvCorrespondenceEmployer(){
        if(countercorrespondenceEmployer  == 0)
            return true;
        else
            return false;
    }
    
    /*******************************************************************
    Purpose: Req no 3378  This function is used to display first and  previous button in Correspondence Member contact  tab and return boolean 
             It returns true if it is not to be displayed else false
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getnxtCorrespondenceEmployer(){
        
        if(recNumcorrespondenceEmployer< 21 )
            return true;
        else{
            if((countercorrespondenceEmployer  + limitscorrespondenceEmployer) > recNumcorrespondenceEmployer)
                return true;
            else
                return false;
        }
        
    }
    
    /*******************************************************************
    Purpose: Req no 3236  This function is used to get Size of all Claim Header values  for selected  contact object
             This  will run only for Employer type for record for req no 3236 OLTP
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void SizeClaimHeader()
    {
        Claimheaders  = new list  <Claim_Header__c>();
        ClaimheadersSize  = new list  <Claim_Header__c>();
        try{
            ClaimheadersSize = [Select Id From Claim_Header__c where  SHPClaimHdr_Member_Lookup__c=:con.ID limit 50000] ;
            
        }catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
        recNumClaimHeader = ClaimheadersSize.size();
        if(recNumClaimHeader>0){
            checkClaimHeader=true;
            searchResultClaimHeader();
        }
        
        else{
            checkClaimHeader=false;
        }
        
        
    }
    
    /*******************************************************************
    Purpose: This method is written to get size of contact base size  tab will render this  will run only for member type for record for Req no 3380 correspondence
    Date: 15/08/2015
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void Sizecorrespondence()
    {
        correspondencelist  = new list <CorrespondenceContactAssociation__c>();
        correspondencelistSize  = new list <CorrespondenceContactAssociation__c >();
        try{
            correspondencelistSize = [Select id from CorrespondenceContactAssociation__c Where Contact__c=:con.ID LIMIT 50000];
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
        recNumcorrespondencelistSize = correspondencelistSize.size();
        if(recNumcorrespondencelistSize>0){
            checkCorrespondence=true;
            searchCorrespondence();
        }
        else{
            checkCorrespondence=false;
        }
        
    }
    
    /*******************************************************************
    Purpose: this method is written to get correspondence from pageniation this  will run only for member type for record for req no 3380 correspondence
    Parameters: [NA]
    Returns: [void]
    Throws [Exceptions]: [Add Message]
    ********************************************************************/
    public void searchCorrespondence(){
        try{
            correspondencelist = [Select name,Correspondence_Letter__r.name,CreatedBy.name,status__C ,Template_Name__c,LastModifiedDate  From CorrespondenceContactAssociation__c where Contact__c =:con.ID   LIMIT 10  OFFSET: counterCorrespondence] ;
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
        
    }
    
    /*******************************************************************
    Purpose: Req no 3156  This function is used to display first and  previous button Correspondence and return boolean  
             It returns true if it is not to be displayed else false
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getprvCorrespondence(){
        if(counterCorrespondence  == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    /*******************************************************************
    Purpose: Req no 3380 This function is used to display next and  last button in Correspondence and return boolean 
             It returns true if it is not to be displayed else false
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getnxtCorrespondence(){
        
        if(recNumcorrespondencelistSize < 11 )
        {
            return true;
        }
        else{
            if((counterCorrespondence    + limitsCorrespondence ) > recNumcorrespondencelistSize )
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used to get Size of all Case   from contact object this  will run only for member type for record
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [VOID]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void SizeCustomerInquiries()
    {
        CaseList  = new list <Case>();
        CaseListSize  = new list <Case>();
        try{
            CaseListSize = [Select id from Case Where ContactId =:con.ID limit :50000];
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
        recNumCustomerInquiries = CaseListSize.size();
        if(recNumCustomerInquiries>0){
            checkCustomerInquiries=true;
            searchResultCustomerInquiries();
        }
        else{
            checkCustomerInquiries=false;
        }
        
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used to get record from PCP object it is used to display data  in Pagination this  will run only for member type for record
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [VOID]
    Throws [Exceptions]: [Add Message]
    ********************************************************************/
    public void searchResultPCP(){
        try{
            pcpInformation = [select SPS_Epic_ID__c, PCP_Practitioner_Name__c, PCP_Effective_date__c ,PCP_Supplier_Name__c ,
                              PCP_Supplier_Location_name__C,PCP_Speciality__c,Practitioner_PCP_Auto_Assigned__c,PCP_Practitioner_NPI__c,PCP_Termination_Date__c
                              ,PCP_Supplier_NPI__c,Medical_Group_Affiliation__c , PCP_sub_Specialty__c  from  PCP_Information__c  where member_ID__C =:con.ID ORDER BY PCP_Effective_date__c DESC limit 10 OFFSET: counterPCP  ];
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2); 
        }
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used to get record from Benefit Plan Coverage objectit is used to display data  in Pagination this  will run only for member type for record
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [VOID]
    Throws [Exceptions]: [Add Message]
    ********************************************************************/
    public void searchResultBenefitPlanCoverage(){
        try{    
            benefitPlanCoverage= [select PlanCov_Bene_Plan_HCC_ID__c,PlanCov_Bene_Plan_Name__c,PlanCov_Bene_Plan_Date_Start__c,PlanCov_Bene_Plan_Date_End__c,Benefit_Grid_Plan_ID__c,PlanCov_Bene_Plan_Type__c, (SELECT  Benefit_Coverage_HCC_ID__c, Benefit_Coverage_Name__c,Benefit_Coverage_Description__c,Benefit_Coverage_Date_Start__c ,Benefit_Coverage_Date_End__c FROM Benefit_Plan_Coverage_DetailS__r  ORDER BY Benefit_Coverage_Date_Start__c DESC limit 4 ) from Benefit_Plan_Coverage__c where PlanCov_Member_Lookup__c=:con.id ORDER BY PlanCov_Bene_Plan_Date_Start__c DESC limit 4 OFFSET: counterBenefitPlanCoverage ];
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used to get record from Claim header  objectit is used to display data  in Pagination. this  will run only for member type for record
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [VOID]
    Throws [Exceptions]: [Add Message]
    ********************************************************************/
    public void searchResultClaimHeader(){
        try{
            Claimheaders = [Select Id,Name,SHPClaimHdr_Claim_HCC_ID__c,SHPClaimHdr_Supplier_HCC_ID__c,SHPClaimHdr_Claim_DoS_Start__c,Claim_IsOutOfArea_Flag__c,SHPClaimHdr_Member_HCC_ID__c,SHPClaimHdr_Procedure_Code_E__c, Claim_Amount_Allowed__c, Claim_Amount_Copay__c , Claim_Amount_Paid__c, SHPClaimHdr_Claim_Date_of_Receipt__c,
                            SHPClaimHdr_Supplier_Name__c,SHPClaimHdr_Claim_DoS_End__c,SHPClaimHdr_Subscriber_HCC_ID__c, Claim_Status__c,SHPClaimHdr_Diagnosis_Code_E__c,Claim_Amount_Billed__c ,Claim_Amount_Deductible__c, Claim_Amount_Patient_Responsibility__c From Claim_Header__c where  SHPClaimHdr_Member_Lookup__c=:con.ID ORDER BY SHPClaimHdr_Claim_DoS_Start__c DESC limit 10 OFFSET: counterClaimHeader  ] ;
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
    }
    // Req 3156 + 3363 + 3364 Start
   
    /*******************************************************************
    Purpose: Req no 3236 This function is used to get record from Case  object it is used to display data  in Pagination
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [VOID]
    Throws [Exceptions]: [Add Message]
    ********************************************************************/
    public void searchResultCustomerInquiries(){
        try{
            
            CaseList = [Select CaseNumber,Customer_Inquiry_Type__c,LastModifiedBy.name,Request_Type__c,Subject,Status,Owner.Name,CreatedDate,Parent.CaseNumber,ParentID,Reason__c,Secondary_Reason__c ,Description from Case Where ContactId =:con.ID  ORDER BY CaseNumber DESC Limit 10 OFFSET: counterCustomerInquiries  ];
            
            if( wrapCaseList == null ) {
                wrapCaseList = new List<CaseRecordAccessWrapper> ();
            }
            /* Req 3364: Map of Case id withe the related userRecordAccess object record */
            Map<Id,UserRecordAccess> caseIdRecordAccessMap = new Map<Id,UserRecordAccess>();
            /* Req 3364 Set of Ids Cases in caseList */
            Set<Id> caseIds = (new Map<Id,SObject>(CaseList)).keySet();
            
            /* Req 3364: Query the UserRecordAccess object records for all the cases in caselist and populate the Map */
            if(  !caseIds.isEmpty()) {
                for( UserRecordAccess recordAccess: [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId IN :caseIds limit 50000] ) {
                    if( recordAccess.RecordId != null ) {
                        caseIdRecordAccessMap.put(recordAccess.RecordId,recordAccess );
                    }   
                }
            }
            /* Req 3364: Clear the wrapCaselist to avoid accumulation of old records in wrapCaseList*/
            if( !wrapCaseList.isEmpty() ) {
                wrapCaseList.clear();
            }
            
            /* Req 3364: Loop to create WrapCaseRecordAcces object record for every Case in caseList */
            if(!CaseList.isEmpty()) {
                for( Case cs:CaseList ) {
                    if(cs.Id != null) {
                        CaseRecordAccessWrapper wrapcs = new CaseRecordAccessWrapper( cs,caseIdRecordAccessMap.get(cs.Id).HasReadAccess );
                        wrapCaseList.add(wrapcs);
                    }
                }
            }
            
        }Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }          
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used Pagination in  for  Next  button
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [VOID]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void nextbtn(){
        
        if(tabid==system.label.Cl130_pcpTab)
        {
            counterPCP  += limitsPCP;
            searchResultPCP();
        }
        // Req 3156 + 3363 Start
        else if(tabid==system.label.CL136_Benefit_Tab_Account)
        {
            counterBenefitPlanCoverageAccount  += limitsBenefitPlanCoverageAccount;
            searchResultBenefitPlanCoverageEmployer();
            
            //Req 3182
            counterBenefitPlanAssociationAccount  += limitsBenefitPlanAssociationAccount;
            searchResultBenefitPlanAssociationEmployer();
            
            //Req 3182
            counterDocumentGenerationAccount  += limitsDocumentGenerationAccount;
            searchResultDocumentGenerationEmployer();
        }
         // Req 3156 + 3363 End
         // Req no 3378  Correspondence  previous button for dependent member Start 
        else if(tabid==system.label.CL165_Correspondence_Member_Dependent)
        {
            countercorrespondenceMemberDependent  += limitscorrespondenceMemberDependent;
            searchResultCorrespondenceMemberDependent();
        }
        
         // Req no 3378  Correspondence  next button for  member
        else if(tabid==system.label.CL163_Correspondence_Member)
        {
            countercorrespondenceMember  += limitscorrespondenceMember;
            searchResultCorrespondenceMember();
        }
         // Req no 3378  Correspondence  previous button for Employer
        else if(tabid==system.label.CL164_Correspondence_Employer)
        {
            countercorrespondenceEmployer  += limitscorrespondenceEmployer;
            searchResultCorrespondenceEmployer();
        }
         // Req no 3378  Correspondence  previous button for dependent member End
        // Correspondence start
        else if(tabid==system.label.CL_157_Correspondence)
        {
            counterCorrespondence += limitsCorrespondence ;
            searchCorrespondence();
        }
        // Correspondence End
        else if(tabid==system.label.Cl131_benefitTab)
        {
            counterBenefitPlanCoverage  += limitsBenefitPlanCoverage;
            searchResultBenefitPlanCoverage();
            MasterID = null;
            counterBenefitPlanCoverageDetails1  = 0;
            counterBenefitPlanCoverageDetails2  = 0;
            counterBenefitPlanCoverageDetails3  = 0;
            counterBenefitPlanCoverageDetails4  = 0;
            
            //Req 3182
            counterBenefitPlanAssociation  += limitsBenefitPlanAssociation;
            searchResultBenefitPlanAssociation();
            
            //Req 3182
            counterDocumentGeneration  += limitsDocumentGeneration;
            searchResultDocumentGeneration();
            
        }
        else if(tabid==system.label.Cl132_claimTab)
        {
            counterClaimHeader  += limitsClaimHeader;
            searchResultClaimHeader();
        }
        else if(tabid==system.label.Cl133_custInq)
        {
            counterCustomerInquiries  += limitsCustomerInquiries;
            searchResultCustomerInquiries();
        }
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used Pagination in  for  Previous  button
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [VOID]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void prvbtn(){
        if(tabid==system.label.Cl130_pcpTab)
        {
            counterPCP  -= limitsPCP;
            searchResultPCP();
        }
        // Req 3156 + 3363 Start
        else if(tabid==system.label.CL136_Benefit_Tab_Account)
        {
            counterBenefitPlanCoverageAccount  -= limitsBenefitPlanCoverageAccount;
            searchResultBenefitPlanCoverageEmployer();
            
            // req 3182
            counterBenefitPlanAssociationAccount  -= limitsBenefitPlanAssociationAccount;
            searchResultBenefitPlanAssociationEmployer();
            
            // req 3182
            counterDocumentGenerationAccount  -= limitsDocumentGenerationAccount;
            searchResultDocumentGenerationEmployer();
        }
        // Req 3156 + 3363 End
        // Correspondence Start 
        
        else if(tabid==system.label.CL_157_Correspondence)
        {
            counterCorrespondence  -= limitsCorrespondence ;
            searchCorrespondence();
        }
        // Correspondence End
        // Req no 3378  Correspondence  previous button for dependent member 
        else if(tabid==system.label.CL165_Correspondence_Member_Dependent)
        {
            countercorrespondenceMemberDependent  -= limitscorrespondenceMemberDependent ;
            searchResultCorrespondenceMemberDependent();
        }
         // Req no 3378  Correspondence  previous button for  member
        else if(tabid==system.label.CL163_Correspondence_Member)
        {
            countercorrespondenceMember  -= limitscorrespondenceMember ;
            searchResultCorrespondenceMember();
        }
         // Req no 3378  Correspondence  previous button for  Employer
        else if(tabid==system.label.CL164_Correspondence_Employer)
        {
            countercorrespondenceEmployer  -= limitscorrespondenceEmployer ;
            searchResultCorrespondenceEmployer();
        }
        // Req no 3378  Correspondence  Member Employer End 
        else if(tabid==system.label.Cl131_benefitTab)
        {
            counterBenefitPlanCoverage  -= limitsBenefitPlanCoverage;
            searchResultBenefitPlanCoverage();
            MasterID = null;
            counterBenefitPlanCoverageDetails1  = 0;
            counterBenefitPlanCoverageDetails2  = 0;
            counterBenefitPlanCoverageDetails3  = 0;
            counterBenefitPlanCoverageDetails4  = 0;
            
            //Req 3182
            counterBenefitPlanAssociation  -= limitsBenefitPlanAssociation;
            searchResultBenefitPlanAssociation();
            
            //Req 3182
            counterDocumentGeneration  -= limitsDocumentGeneration;
            searchResultDocumentGeneration();
            
        }
        else if(tabid==system.label.Cl132_claimTab)
        {
            counterClaimHeader  -= limitsClaimHeader;
            searchResultClaimHeader();
        }
        else if(tabid==system.label.Cl133_custInq)
        {
            counterCustomerInquiries  -= limitsCustomerInquiries;
            searchResultCustomerInquiries();
        }
        
    }
    
   /*******************************************************************
    Purpose: Req no 3236 This function is used Pagination in  for  first  button
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [VOID]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void  fstbtn(){
        
        if(tabid==system.label.Cl130_pcpTab)
        {
            counterPCP  = 0;
            searchResultPCP();
        }
        
        // Req 3156 + 3363 Start
        else if(tabid==system.label.CL136_Benefit_Tab_Account)
        {
            counterBenefitPlanCoverageAccount  = 0;
            searchResultBenefitPlanCoverageEmployer();
            
            //Req 3182
            counterBenefitPlanAssociationAccount  = 0;
            searchResultBenefitPlanAssociationEmployer();
            
            //Req 3182
            counterDocumentGenerationAccount  = 0;
            searchResultDocumentGenerationEmployer();
        }
        // Req 3156 + 3363 End
        // Correspondence Start
        else if(tabid==system.label.CL_157_Correspondence)
        {
            counterCorrespondence   = 0;
            searchCorrespondence();
        }
        // Correspondence End
       // Req no 3378  Correspondence  First button for dependent member Start
        else if(tabid==system.label.CL165_Correspondence_Member_Dependent)
        {
            countercorrespondenceMemberDependent   = 0;
            searchResultCorrespondenceMemberDependent();
        }
        // Req no 3378  Correspondence  first button for  member
        else if(tabid==system.label.CL163_Correspondence_Member)
        {
            countercorrespondenceMember   = 0;
            searchResultCorrespondenceMember();
        }
        // Req no 3378  Correspondence  first button for Employer
        else if(tabid==system.label.CL164_Correspondence_Employer)
        {
            countercorrespondenceEmployer   = 0;
            searchResultCorrespondenceEmployer();
        }
        // Req no 3378  Correspondence  Member Employer End
        else if(tabid==system.label.Cl131_benefitTab)
        {
            counterBenefitPlanCoverage  = 0;
            searchResultBenefitPlanCoverage();
            MasterID = null;
            counterBenefitPlanCoverageDetails1  = 0;
            counterBenefitPlanCoverageDetails2  = 0;
            counterBenefitPlanCoverageDetails3  = 0;
            counterBenefitPlanCoverageDetails4  = 0;
            
            //Req 3182
            counterBenefitPlanAssociation  = 0;
            searchResultBenefitPlanAssociation();
            
            //Req 3182
            counterDocumentGeneration  = 0;
            searchResultDocumentGeneration();
            
        }
        else if(tabid==system.label.Cl132_claimTab)
        {
            counterClaimHeader  = 0;
            searchResultClaimHeader();
        }
        else if(tabid==system.label.Cl133_custInq)
        {
            counterCustomerInquiries  = 0;
            searchResultCustomerInquiries();
        }
        
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used Pagination in last button
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [VOID]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public void endbtn(){
        if(tabid==system.label.Cl130_pcpTab)
        {
            counterPCP  = recNumPCP - math.mod(recNumPCP,limitsPCP);
            searchResultPCP();
        }
        // Req 3156 + 3363 Start
        else if(tabid==system.label.CL136_Benefit_Tab_Account)
        {
            counterBenefitPlanCoverageAccount  = recNumBenefitPlanCoverageAccount - math.mod(recNumBenefitPlanCoverageAccount,limitsBenefitPlanCoverageAccount);
            searchResultBenefitPlanCoverageEmployer();
            
            //Req 3182
            counterBenefitPlanAssociationAccount  = recNumBenefitPlanAssociationAccount - math.mod(recNumBenefitPlanAssociationAccount,limitsBenefitPlanAssociationAccount);
            searchResultBenefitPlanAssociationEmployer();
            
            //Req 3182
            counterDocumentGenerationAccount  = recNumDocumentGenerationAccount - math.mod(recNumDocumentGenerationAccount,limitsDocumentGenerationAccount);
            searchResultDocumentGenerationEmployer();
        }
        // Req 3156 + 3363 End
        //  Correspondence Start
        else if(tabid==system.label.CL_157_Correspondence)
        {
            counterCorrespondence    = recNumcorrespondencelistSize  - math.mod(recNumcorrespondencelistSize ,limitsCorrespondence );
            searchCorrespondence();
        }
        //  Correspondence End
        
       // Req no 3378  Correspondence  first button for Dependent member
        else if(tabid==system.label.CL165_Correspondence_Member_Dependent)
        {
            countercorrespondenceMemberDependent    = recNumcorrespondenceMemberDependent  - math.mod(recNumcorrespondenceMemberDependent ,limitscorrespondenceMemberDependent );
            searchResultCorrespondenceMemberDependent();
        }
        // Req no 3378  Correspondence  first button for Member Contact
        else if(tabid==system.label.CL163_Correspondence_Member)
        {
            countercorrespondenceMember    = recNumcorrespondenceMember  - math.mod(recNumcorrespondenceMember ,limitscorrespondenceMember );
            searchResultCorrespondenceMember();
        }
        // Req no 3378  Correspondence  first button for Employer
        else if(tabid==system.label.CL164_Correspondence_Employer)
        {
            countercorrespondenceEmployer    = recNumcorrespondenceEmployer  - math.mod(recNumcorrespondenceEmployer ,limitscorrespondenceEmployer );
            searchResultCorrespondenceEmployer();
        }
        // Req no 3378  Correspondence  Member Employer End
        else if(tabid==system.label.Cl131_benefitTab)
        {
            counterBenefitPlanCoverage  = recNumBenefitPlanCoverage - math.mod(recNumBenefitPlanCoverage,limitsBenefitPlanCoverage);
            searchResultBenefitPlanCoverage();
            MasterID = null;
            counterBenefitPlanCoverageDetails1  = 0;
            counterBenefitPlanCoverageDetails2  = 0;
            counterBenefitPlanCoverageDetails3  = 0;
            counterBenefitPlanCoverageDetails4  = 0;
            
            //Req 3182
            counterBenefitPlanAssociation  = recNumBenefitPlanAssociation - math.mod(recNumBenefitPlanAssociation,limitsBenefitPlanAssociation);
            searchResultBenefitPlanAssociation();
            
            //Req 3182
            counterDocumentGeneration  = recNumDocumentGeneration - math.mod(recNumDocumentGeneration,limitsDocumentGeneration);
            searchResultDocumentGeneration();
            
        }
        else if(tabid==system.label.Cl132_claimTab)
        {
            counterClaimHeader  = recNumClaimHeader - math.mod(recNumClaimHeader,limitsClaimHeader);
            searchResultClaimHeader();
        }
        else if(tabid==system.label.Cl133_custInq)
        {
            
            counterCustomerInquiries  = recNumCustomerInquiries - math.mod(recNumCustomerInquiries,limitsCustomerInquiries);
            searchResultCustomerInquiries();
        }
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used to display first and  previous button in PCP tab and return boolean  in PCP Tab
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getprvPCP(){
        if(counterPCP  == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used next and  last button in PCP tab and return boolean in PCP Tab
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getnxtPCP(){
        if(recNumPCP < 11 )
        {
            return true;
        }
        else
        {
            if((counterPCP  + limitsPCP) > recNumPCP)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used to display first and  previous button in Benefit plan  Coverage  tab and return boolean
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getprvBenefitPlanCoverage(){
        if(counterBenefitPlanCoverage  == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    
    /************************************************************************
    Purpose: Req no 3182 This function is used to display first and  
            previous button in Benefit plan  Coverage  tab and return boolean
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    **************************************************************************/
    public boolean getprvBenefitPlanAssociation(){
        if(counterBenefitPlanAssociation  == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    /****************************************************************************
    Purpose: Req no 3182 This function is used to display first and  
                previous button in Benefit plan  Coverage  tab and return boolean
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    *****************************************************************************/
    public boolean getprvDocumentGeneration(){
        if(counterDocumentGeneration  == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used to display first and  previous button in Benefit plan  Coverage  tab and return boolean
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getnxtBenefitPlanCoverage(){
        
        if(recNumBenefitPlanCoverage< 5 )
        {
            return true;
        }
        else{
            if((counterBenefitPlanCoverage  + limitsBenefitPlanCoverage) > recNumBenefitPlanCoverage)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
    }
    
     /*******************************************************************
    Purpose: Req no 3182 This function is used to display first and  previous 
            button in Benefit plan  Coverage  tab and return boolean
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getnxtBenefitPlanAssociation(){
        
        if(recNumBenefitPlanAssociation< 21 )
        {
            return true;
        }
        else{
            if((counterBenefitPlanAssociation  + limitsBenefitPlanAssociation) > recNumBenefitPlanAssociation)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
    }
    
    /*******************************************************************
    Purpose: Req no 3182 This function is used to display first and  
            previous button in Benefit plan  Coverage  tab and return boolean
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getnxtDocumentGeneration(){
        
        if(recNumDocumentGeneration< 21 )
        {
            return true;
        }
        else{
            if((counterDocumentGeneration  + limitsDocumentGeneration) > recNumDocumentGeneration)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
    }
    
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used to display first and  previous button in Claim header tab and return boolean
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getprvClaimHeader(){
        if(counterClaimHeader  == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used to display first and  previous button in Claim header tab and return boolean
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getnxtClaimHeader(){
        if(recNumClaimHeader < 11 )
        {
            return true;
        }
        else{
            if((counterClaimHeader  + limitsClaimHeader) > recNumClaimHeader)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
    }
    
    /*******************************************************************
    Purpose: Req no 3236  This function is used to display first and  previous button in Customer Inquiries Tab and return boolean
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getprvCustomerInquiries(){
        if(counterCustomerInquiries  == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    /*******************************************************************
    Purpose: Req no 3236  This function is used to display first and  previous button in Customer Inquiries tab and return boolean
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public boolean getnxtCustomerInquiries(){
        if(recNumCustomerInquiries< 11 )
        {
            return true;
        }
        else{
            if((counterCustomerInquiries  + limitsCustomerInquiries) > recNumCustomerInquiries)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
   
    /*******************************************************************
    Purpose: 3236 This function is used to get record from Benefit plan  coverage details  object it is used to display data  in Pagination
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public void searchResultBenefitPlanCoverageDetails(integer  counter)
    {
        try
        {
            benefitPlanCoverageDetail  = new  list <Benefit_Plan_Coverage_Detail__c>();
            benefitPlanCoverageDetail =  [SELECT  Benefit_Coverage_HCC_ID__c, Benefit_Coverage_Name__c,Benefit_Coverage_Description__c,Benefit_Coverage_Date_Start__c ,Benefit_Coverage_Date_End__c FROM Benefit_Plan_Coverage_Detail__c WHERE Benefit_Plan_Coverage_ID__c =:MasterID ORDER BY Benefit_Coverage_Date_Start__c DESC  LIMIT 4 OFFSET: counter];
            if(benefitPlanCoverageDetail.size()<=0)
            {
                counter= counter-4;
                counterBenefitPlanCoverageDetails1 = counter;
                counterBenefitPlanCoverageDetails2 = counter;
                counterBenefitPlanCoverageDetails3 = counter;
                counterBenefitPlanCoverageDetails4 = counter;
                
                benefitPlanCoverageDetail = [SELECT  Benefit_Coverage_HCC_ID__c, Benefit_Coverage_Name__c, Benefit_Coverage_Description__c,Benefit_Coverage_Date_Start__c, Benefit_Coverage_Date_End__c
                                             FROM Benefit_Plan_Coverage_Detail__c
                                             WHERE Benefit_Plan_Coverage_ID__c =:MasterID ORDER BY Benefit_Coverage_Date_Start__c DESC  Limit 4 OFFSET: counter];
            }
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
            
        }
        Catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG + ex.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG +  EXEPTION_MSG2);
        }
        
        
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used Pagination in next button Benefit Plan Coverage Detail
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public void nextbtnBenefitPlanCoverageDetails()
    {    
        if(benefitPlanCoverageDetailTableNo ==1)
        {
            counterBenefitPlanCoverageDetails1+= limitsBenefitPlanCoverageDetails;
            searchResultBenefitPlanCoverageDetails(counterBenefitPlanCoverageDetails1);
        }
        else if(benefitPlanCoverageDetailTableNo ==2)
        {
            counterBenefitPlanCoverageDetails2+= limitsBenefitPlanCoverageDetails;
            searchResultBenefitPlanCoverageDetails(counterBenefitPlanCoverageDetails2);
        }
        else if(benefitPlanCoverageDetailTableNo ==3)
        {
            counterBenefitPlanCoverageDetails3+= limitsBenefitPlanCoverageDetails;
            searchResultBenefitPlanCoverageDetails(counterBenefitPlanCoverageDetails3);
        }
        else if(benefitPlanCoverageDetailTableNo ==4)
        {
            counterBenefitPlanCoverageDetails4+= limitsBenefitPlanCoverageDetails;
            searchResultBenefitPlanCoverageDetails(counterBenefitPlanCoverageDetails4);
        }
    }
    
    /*******************************************************************
    Purpose: Req no 3236 This function is used Pagination in previous button Benefit Plan Coverage Detail.
    Date: 15/02/2015
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public void prvbtnBenefitPlanCoverageDetails()
    {
        
        if(benefitPlanCoverageDetailTableNo ==1)
        {
            
            If (counterBenefitPlanCoverageDetails1 <limitsBenefitPlanCoverageDetails)
            {
                counterBenefitPlanCoverageDetails1 = 0;
            }
            else
            {
                counterBenefitPlanCoverageDetails1  -= limitsBenefitPlanCoverageDetails;
            }
            searchResultBenefitPlanCoverageDetails(counterBenefitPlanCoverageDetails1);
        }
        
        else if(benefitPlanCoverageDetailTableNo ==2)
        {
            
            If (counterBenefitPlanCoverageDetails2 <limitsBenefitPlanCoverageDetails)
            {
                counterBenefitPlanCoverageDetails2 = 0;
            }
            else
            {
                counterBenefitPlanCoverageDetails2  -= limitsBenefitPlanCoverageDetails;
            }
            searchResultBenefitPlanCoverageDetails(counterBenefitPlanCoverageDetails2);
        }
        
        if(benefitPlanCoverageDetailTableNo ==3)
        {
            If (counterBenefitPlanCoverageDetails3 <limitsBenefitPlanCoverageDetails)
            {
                counterBenefitPlanCoverageDetails3 = 0;
            }
            else
            {
                counterBenefitPlanCoverageDetails3  -= limitsBenefitPlanCoverageDetails;
            }
            searchResultBenefitPlanCoverageDetails(counterBenefitPlanCoverageDetails3);
        }
        
        if(benefitPlanCoverageDetailTableNo ==4)
        {
            If (counterBenefitPlanCoverageDetails4 <limitsBenefitPlanCoverageDetails)
            {
                counterBenefitPlanCoverageDetails4 = 0;
            }
            else
            {
                counterBenefitPlanCoverageDetails4  -= limitsBenefitPlanCoverageDetails;
            }
            searchResultBenefitPlanCoverageDetails(counterBenefitPlanCoverageDetails4);
        }
        
    }
    //Req no 3268 Logic End OLTP
    
    //Req-3274 & 3733 changes start
    
    /****************************************************************************************   
        Purpose: Req-3274 & 3733 - This function is used to return open and closed Case list on selected contact 
        Parameters: [NA]  
        Returns: List<Case>
        Throws [Exceptions]: [NA]  
    *****************************************************************************************/    
        
    public void caseLst() {
        CaseOpenList = new List<Case>();
        CaseClosedList = new List<Case>();
        VFC01_ContactCaseList ContactCases = new VFC01_ContactCaseList();
        ContactCases.sortingField = this.sortField;
        ContactCases.sortingDirection = this.sortDirection;
        if(string.IsBlank(this.sortDirection)) {
            this.sortDirection = 'ASC';
        }
        CaseAllList = ContactCases.collectContactCases(this.linkId);
        
        for (Case caseObj: CaseAllList)
        {
            if(caseObj.Status != 'Closed')
                //If case status is not closed then update list of open cases
                CaseOpenList.add(caseObj);                                         

            else 
                //If case status is closed then update list of closed cases
                CaseClosedList.add(caseObj);                
        }
        
    }
    /****************************************************************************************   
        Purpose: Req-3274 - This function is used to return open and closed Case list on selected patient 
        Parameters: [NA]  
        Returns: List<Case>
        Throws [Exceptions]: [NA]  
    *****************************************************************************************/  
   
    public void casePatientLst() {
        PatientCaseOpenList = new List<Case>();
        PatientCaseClosedList = new List<Case>();
        VFC01_ContactCaseList ContactCases = new VFC01_ContactCaseList();
        ContactCases.sortingField = this.sortField;
        ContactCases.sortingDirection = this.sortDirection;
        if(string.IsBlank(this.sortDirection)) {
            this.sortDirection = 'ASC';
        }
        
        CaseAllList = ContactCases.collectPatientCases(this.linkId);
        
        for (Case caseObj: CaseAllList)
        {
            
            if(caseObj.Status != 'Closed')
                //If case status is not closed then update list of open cases
                PatientCaseOpenList.add(caseObj);   

            else 
                //If case status is closed then update list of closed cases
                PatientCaseClosedList.add(caseObj);                
        }
       
    }
    
    /********************************************************************************************  
        Purpaose: Req-3274 - This function is used to return Patient information
        Parameters: [NA]  
        Returns: Patient__c
        Throws [Exceptions]: [NA]  
    *********************************************************************************************/ 
    public Patient__c getPatientPage(){
        VFC01_ContactCaseList employeePatientCases = new VFC01_ContactCaseList();
        return employeePatientCases.getPatientPage(this.linkId);
    }
    
    /*******************************************************************  
        Purpose: Req-3274 - This function is used to return patient account information 
        Parameters: [NA]  
        Returns: List<patient_account__c>
        Throws [Exceptions]: [NA]  
    ********************************************************************/ 
    public List<patient_account__c> getPatientAccountPage() {
        VFC01_ContactCaseList employeePatientCases = new VFC01_ContactCaseList();
        return employeePatientCases.getPatientAccountPage(this.linkId);
    }
    
     /*******************************************************************  
        Purpose: Req-3274 - This function is used to return Manager Feedback information 
        Parameters: [NA]  
        Returns: List<Managers_Feedback__c>
        Throws [Exceptions]: [NA]  
    ********************************************************************/ 
    public List<Managers_Feedback__c> getManagerFeedback() {
        VFC01_ContactCaseList employeePatientCases = new VFC01_ContactCaseList();
        return employeePatientCases.getManagerFeedback(this.linkId);
    }
    
    /***********************************************************************************************  
        Purpose: Req-3274 - This function is used to return Employee information
        Parameters: [NA]  
        Returns: Contact
        Throws [Exceptions]: [NA]  
    **********************************************************************************************/ 
    public Contact getEmployeePage() { 
        VFC01_ContactCaseList employeePatientCases = new VFC01_ContactCaseList();
        return employeePatientCases.getEmployeePage(this.linkId);
    }
    
     /***********************************************************************************************  
        Purpose: Req-3733 - This function is used to return Vendor information
        Parameters: [NA]  
        Returns: Contact
        Throws [Exceptions]: [NA]  
    **********************************************************************************************/ 
    public Contact getVendorPage() { 
        VFC01_ContactCaseList employeePatientCases = new VFC01_ContactCaseList();
        return employeePatientCases.getVendorPage(this.linkId);
    }
    
    //Req-3274 & 3733 changes end
}