/**
@Author      : IDC Offshore
@name        : UniversalProviderController 
@CreateDate  : 13/05/2016 (DD/MM/YYYY)
@Description : Class for Provider portal login, validate provider information, portal password change and FAQ.
@Version     : 1.0
@reference   : NA
*/
global class UniversalProviderController {
    global String username {get; set;}
    global String password {get; set;}
    global list<String> divsList{get;set;}
    public string section{get;set;}
    public providerInfoStruct providerInfo{get;set;}
    public List<Contact_Validation_Summary__c> summaryObjList{get;set;}
    public Contact_Validation_Summary__c summaryObj{get;set;}
    public String articleContent{get;set;}
    public string logInMsg{get;set;}
    private id userId;
    public id contactId{get;set;}
    private dateTime lmDate;
    global User userObj{get;set;}
    private contact contObj;
    public boolean isAddressValidAllFields {get;set;}
    private string generalErrMsg;
    public string logoutURL{get;set;}
    public string logoutRetURL{get;set;}
    public String firstValue = '';
    public String firstLabel = '';
    public wrapperFAQ faqObj {get; set;}
    public boolean faqLink {get; set;}
    private Integer refreshCount = 1;
    public Map<String, String> sumObjOld{get;set;}
    public Map<String, String> sumObjNew{get;set;}
    public String sumObjComparetable{get;set;}
    public Boolean providerSearchFlag{get;set;}
    public Boolean providerFlag{get;set;}
    global String oldpassword {get; set;}
    global String newPassword {get; set;}
    global String confirmPassword {get; set;}
    //Address Related Variables Starts
    public Provider_Address__c primaryAddrObj{get;set;}
    public List<Provider_Address__c> SecondaryAddrList{get;set;}
    public Provider_Address__c address{get;set;}
    public List<PDI_Address_Verification.addressAD> verifiedAddressList{get;set;}
    public List<PDI_Email_Address_Verification.wrapEmailVerification> emailStatusList{get;set;}
    public List<Provider_Address__c> suggestedAddressList{get;set;}
    public Map<String, Provider_Address__c> tempsecondaryAddrMap{get;set;}
    public List<Provider_Address__c> providerAddressList{get;set;}
    public boolean isAddressDoctorValidFields {get;set;}
    public boolean addressline2ErrorFlag {get;set;}
    public Map<Integer, String> statusMap{get;set;}
    public Map<String, String> resultStatusMap{get;set;}
    public Set<String> processCodes{get;set;}
    public Set<String> correctAddrCodeSet{get;set;}
    public Set<String> verifiedAddrCodeSet{get;set;}
    public Map<String,String> addressNotProcessedStatusMap{get;set;}
    public Map<String,String> addressWebserviceStatusMap{get;set;}
    public Boolean byPassAddressVerificationFlag{get;set;} // Added on 21/12/2016 to Override the Address Verification
    public String manualByPassFlag{get;set;}
    public Boolean editAddrmode{get;set;}
    public Boolean reordermode{get;set;}
    public Boolean showNewButtonFlag{get;set;}
    public Boolean suggestedAddressFlag{get;set;}
    public String selectedRecord{get;set;}
    public Boolean showReorderBtnFlag{get;set;}
    public String emailVerifyErrorMsg{get;set;}
    public Map<String,String> emailStatusCodesMap{get;set;}
    public List<Provider_Address__c> providerAddressVerfiyList{get;set;}
    //Address Related Variables Ends
    // Constant Variables Starts
    public static final String strSpace = ' ';
    public static final String formString = 'form';
    public static final String providerLogin = '/providers/UniversalProviderLogin';
    public static final String providerHome_Constant = '/apex/UniversalProviderLogin';
    public static final String providerFAQ_Constant = '/apex/UFAQ';
    public static final String providerProfile_Constant = '/apex/UniversalValidateProvider';
    public static final String providerChangePassword_Constant = '/apex/ProviderChangePassword';
    public static final String homeTable1 = '<div class="col-md-4 col-sm-4 service-box service-icon-left-more"><div class="service-icon"><i class="fa ';
    public static final String homeTable3 = ' fa-4x icon-large"></i></div><div class="service-content"><h4>';
    public static final String homeTable4 = '</h4><p>';
    public static final String homeTable5 = '</p></div></div>';
    public static final String section_Constant = 'section';
    public static final String form_Constant = 'form';
    public static final String error_Constant = 'error';
    public static final String loggedInAs_Constant = 'Logged in as ';
    //public static final String providerProfileId_Constant = '00eG0000001MgBW';
    //public static final String AdminAsstProfileId_Constant = '00eq0000000HulJAAS';
    public static final String providerSearch_Constant = 'ProviderSearchFlag';
    public static final String addressLine1Label = '<b>Address Line 1 : </b>';
    public static final String addressLine2Label = '<b>Address Line 2 : </b>';
    public static final String cityLabel =         '<b>City           : </b>';
    public static final String stateLabel =        '<b>State          : </b>';
    public static final String zipCodeLabel =      '<b>ZipCode        : </b>';
    public static final String securePhoneLabel =  '<b>SecurePhone    : </b>';
    public static final String phoneExtensionLabel='<b>PhoneExt       : </b>';
    public static final String faxLabel =          '<b>Fax            : </b>';
    public static final String addressTypeLabel =  '<b>Address Type   : </b>';
    public static final String addressStatusLabel ='<b>Address Status : </b>';
    public static final String compareTableHeader = '<table class=\"table table-bordered table-striped table-condensed\" id=\"mytable\">'+
                '<tr><thead style=\"background-color: lightseagreen; color: white; font-size: larger;\">'+
                '<th>Field Names</th><th>Old Details</th><th>New Details</th></thead></tr>';
    // Constant Variables Ends    
    
   /**
    * @author       :   IDC Offshore
    * @date         :   13/05/2016
    * @description  :   Constructor
    * @param        :   N/A
    * @return       :   N/A
    */
    public UniversalProviderController()
    {
        showReorderBtnFlag = false;
        addressline2ErrorFlag = false;
        manualByPassFlag = Label.CL619_PDIControlByPassAddressCheckBox;
        // PDI-Wave1 Description: Retrieve the static data from PDIPortalHomePage__c custom settings
		// and dynamically building the div's to display data in provider portal home page.
		divsList = new list<String>();
        Map<String, PDIPortalHomePage__c> pdiContent = PDIPortalHomePage__c.getAll();
        for(String pdikey: pdiContent.keySet()){
            String div = null;
            String header = pdikey.substringAfter('.');
            div = homeTable1 + pdiContent.get(pdikey).Icon__c + homeTable3 + header + homeTable4 + pdiContent.get(pdikey).DataValue1__c;
            if(String.isNotBlank(pdiContent.get(pdikey).DataValue2__c)){
                div +=  pdiContent.get(pdikey).DataValue2__c + homeTable5;
            }else{
                div += homeTable5;
            }
            divsList.add(div);  
        }
        
        // Description: Implements the logic to retrieve and split the article body from FAQ Knowledge article.
        faqLink = true;
        FAQ__kav faq = new FAQ__kav();
        if(!Test.isRunningTest()){
            faq = [SELECT Id, Article_Body__c, ArticleNumber,  ArticleType, Functional_Area__c, Keywords__c, KnowledgeArticleId, Language,  Original_Author__c, PublishStatus, SourceId, Sub_Function__c, Summary, Title, UrlName, Version__c, VersionNumber, IsVisibleInApp, IsVisibleInPkb, IsVisibleInCsp, IsVisibleInPrm FROM FAQ__kav WHERE PublishStatus = 'Online' AND language = 'en_US' AND Title =:Label.CL252_PDI_Article_Title];
            articleContent = faq.Article_Body__c;
            faqObj = new wrapperFAQ(articleContent);
        }
        
        // Description: Retreives the Provider Information summary data to display in Profile page.
        section = ApexPages.currentPage().getParameters().get(section_Constant);
        if(section == null || section == ''){
            section = form_Constant; 
        }
        userId = UserInfo.getUserId();
        userObj = [select id, contactId, profileId, Email from User WHERE IsActive = true and Id =:userId LIMIT 1];
        contactId = userObj.contactId;
        
        providerInfo = new providerInfoStruct();        
        
        if(contactId == null){
            section = error_Constant;  
        }    
        generalErrMsg = Label.CL367_PDI_errorMsg;
        logoutURL = Label.CL368_PDI_logOutURL;
        logoutRetURL = Label.CL369_PDI_logoutRetURL;
        logInMsg = loggedInAs_Constant + UserInfo.getName() + ' (' + UserInfo.getUserName() +')';
        
        //Form or Success Section Starts
        if(section.equalsIgnoreCase(form_Constant) || section.equalsIgnoreCase(section_Constant)) {
            PDIProviderSearch__c flag = PDIProviderSearch__c.getInstance(providerSearch_Constant);
            providerSearchFlag = flag.Value__c;
            
            if(Label.CL579_PDI_ProviderProfileId.equals(userObj.profileId)){
                summaryObj = new Contact_Validation_Summary__c();
                contactId = userObj.contactId;
                summaryObj = providerProfileData(contactId);
            }else if(Label.CL578_PDI_AdminAsstProfileId.equals(userObj.profileId)){
                providerFlag = false;
                summaryObjList = [SELECT id,Provider_Name__c, Provider_Title__c, Provider_ID__c, Provider_NPI_F__c, Provider_License_Number__c, Status__c
                                  , Contact_Id__c, Last_Verified_Date__c, owner.name
                                  FROM Contact_Validation_Summary__c WHERE Admin_Assistant_Email__c =: userObj.Email  
                                  and Admin_Assistant_Approval_Status__c =: Label.CL580_PDI_AdminAsst_Approved and PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name LIMIT 500]; 
            }
        }
        //Form or Success Section Ends    
    }
    
   /*
    * @author       :   IDC Offshore
    * @date         :   13/05/2016
    * @description  :   Inner Class replicating the data Structure of Provider Information to be updated 
    * @param        :   N/A
    * @return       :   N/A
    */   
    public class providerInfoStruct {
        public string name{get;set;}
        public string sc_address{get;set;}
        public string lastModifiedDate{get;set;}
        public string oldEmail;
       /*
        * ProviderInfoStruct Constructor
        */
        public providerInfoStruct() {
            oldEmail = '';
        }
    }
    
    /*
    * @author       :   IDC Offshore
    * @date         :   11/10/2016
    * @description  :   This method is used to retrieve selected provider profile information. 
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference retrieveProviderProfile(){
        try{
            if(contactId != null){
                summaryObj = new Contact_Validation_Summary__c();
                summaryObj = providerProfileData(contactId);
            }else{
                section = error_Constant; 
            }
            return null;
        }catch(Exception classException)  {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
    }
    
   /*
    * @author       :   IDC Offshore
    * @date         :   27/09/2016
    * @description  :   This method is used to retrieve provider summary information based on contactId 
    * @param        :   N/A
    * @return       :   N/A
    */
    public Contact_Validation_Summary__c providerProfileData(String conId){
        
        providerFlag = true;
        Contact_Validation_Summary__c summaryInfo = new Contact_Validation_Summary__c();
        
        summaryInfo = [SELECT id, Email__c, Mobile_Phone__c, Provider_Name__c, Provider_Title__c, Is_Resigned_Provider_refer__c
                       , Profile_Pic__c, Speciality__c, Department__c, Hospital_Affiliations__c, Medical_Affiliations__c
                       , Medical_Education__c, Website_Address__c, Online_Services__c, Spoken_Languages__c, Provider_FullName__c
                       , Internship__c, Professional_Ineterests__c, Residency__c, Board_Certifications__c
                       , Community_Activities__c, Publications__c, Personal_Interests__c, Additional_Information__c
                       , Philosophy_of_Care__c, Contact_Id__c, Provider_ID__c, Last_Verified_Date__c, Preferred_Communication_Method__c
                       , ok_to_text__c, Provider_NPI_F__c, Communication_Preferences_HIM__c, Admin_Assistant__c, Admin_Assistant_Title__c 
                       , Admin_Assistant_Email__c, Admin_Assistant_Phone__c, Retired_Departed__c, Resigned_From_Sutter__c, Practicing_Physician__c
                       , Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                       FROM Contact_Validation_Summary__c WHERE Contact_Id__c = :conId  and PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name limit 1];
        
        if(String.isNotBlank(summaryInfo.Mobile_Phone__c))
        {
            summaryInfo.Mobile_Phone__c = UniversalProviderHelper.FormatPhone(summaryInfo.Mobile_Phone__c);
        }
        if(String.isNotBlank(summaryInfo.Admin_Assistant_Phone__c))
        {
            summaryInfo.Admin_Assistant_Phone__c = UniversalProviderHelper.FormatPhone(summaryInfo.Admin_Assistant_Phone__c);
        }
        if(summaryInfo.Last_Verified_Date__c != null)
        {
            providerInfo.lastModifiedDate = summaryInfo.Last_Verified_Date__c.format('MMMM dd, yyyy  hh:mm a');
        }
        if(section.equalsIgnoreCase(formString)) {                         
            if(summaryInfo.Provider_Name__c != null && !String.isBlank(summaryInfo.Provider_Name__c)){   
                providerInfo.name = summaryInfo.Provider_Name__c;
            }
            if(summaryInfo.Provider_Title__c != null && !String.isBlank(summaryInfo.Provider_Title__c)){  
                providerInfo.name = providerInfo.name + ', ' + summaryInfo.Provider_Title__c;
            }
            if(summaryInfo.Email__c != null && !String.isBlank(summaryInfo.Email__c)){  
                providerInfo.oldEmail = summaryInfo.Email__c;
            }
        }
        //To retrieve primary and Secondary Address Details of the Contact.
        retriveAddressDetails();
        return summaryInfo;
    }
    
    /*
    * @author       :   IDC Offshore
    * @date         :   29/04/2016
    * @description  :   Implements Provider's Authentication Logic 
    * @param        :   N/A
    * @return       :   N/A
    */   
    global PageReference login() { 
        String startURL = Label.CL370_PDI_startUrl;
        return Site.login(username, password, startURL);
        
    }
    
   /*
    * @author       :   IDC Offshore
    * @date         :   13/11/2014
    * @description  :   Check if the User is authenticated
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference ifUserAuthenticated() {
        try{
            if(refreshCount == 1){
                PageReference prObj;
                
                if(!userInfo.getUsertype().equalsIgnoreCase(Label.CL360_PDI_CspLitePortal)) {
                    prObj = new PageReference(providerLogin);
                    prObj.setRedirect(true);
                    return prObj;   
                } else {
                    if(section.equalsIgnoreCase(formString)) {
                        summaryObj.Provider_last_Login_Date__c = datetime.now();
                        summaryObj.Tech_Success_Email__c = false;
                        summaryObj.Address_Summary__c = null;
                        update summaryObj;
                        refreshCount = refreshCount + 1;
                    }
                    return null;
                }
            }else{
                return null;
            }
        } catch(Exception classException)  {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
    }
   /*
    * @author       :   IDC Offshore
    * @date         :   16/05/2016
    * @description  :   Redirects to Home page logic
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference redirectoHome()
    {
        try{
            PageReference pr = new PageReference(providerHome_Constant);
            pr.setRedirect(false);
            return pr;
        }catch(Exception classException)  {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        
    }
   /*
    * @author       :   IDC Offshore
    * @date         :   16/05/2016
    * @description  :   Redirects to profile page logic
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference redirectoValidateProvider()
    {
        try{
            PageReference pr = new PageReference(providerProfile_Constant);
            pr.setRedirect(false);
            return pr;
        }catch(Exception classException)  {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        
    }
   /*
    * @author       :   IDC Offshore
    * @date         :   16/05/2016
    * @description  :   Redirects to FAQ page logic
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference redirectoFAQ()
    {
        try{
            PageReference pr = new PageReference(providerFAQ_Constant);
            pr.setRedirect(false);
            return pr;
        }catch(Exception classException)  {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
    }
   /*
    * @author       :   IDC Offshore
    * @date         :   16/05/2016
    * @description  :   Redirects to change password page logic
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference redirectoChangePassword()
    {
        try{
            PageReference pr = new PageReference(providerChangePassword_Constant);
            pr.setRedirect(false);
            return pr;
        }catch(Exception classException)  {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
    }
   /*
    * @author       :   IDC Offshore
    * @date         :   16/05/2016
    * @description  :   Redirects to List of Providers Page
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference redirectoProviderList()
    {
        try{
            providerFlag = false;
            //section = form_Constant;
            PageReference pr = new PageReference(providerProfile_Constant);
            pr.setRedirect(true);
            return pr;
        }catch(Exception classException)  {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        
    }
   /*
    * @author       :   IDC Offshore
    * @date         :   16/05/2016
    * @description  :   Implements Provider's Change Password Logic
    * @param        :   N/A
    * @return       :   PageReference
    */
    global PageReference changePortalUserPassword() {
        return Site.changePassword(newPassword, confirmPassword, oldpassword);
    }
   
   /*
    * @description  :   This method is used to return to Admin Assistant Provider List Page
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference cancelProvider(){
        providerFlag = false;
        return null;
    }
    /*
    * @author       :   IDC Offshore
    * @date         :   07/11/2014
    * @description  :   Saves the updated Record
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference save() {
        List<Provider_Address__c> providerOldAddrList = new List<Provider_Address__c>();
        List<Provider_Address__c> providerNewAddrList = new List<Provider_Address__c>();
        sumObjOld = new Map<String, String>();
        sumObjNew = new Map<String, String>();
        String status = '';
        String okToText = '';
        String mobileNo;
        String providerStatus = '';
        String oktoText1 = '';
        Set<String> serialNumberSet = new Set<String>();
        emailVerifyErrorMsg = '';
        emailStatusCodesMap = new Map<String,String>();
        Savepoint sp;
        try{
            isAddressValidAllFields = true;
            // Email Verification Service Details 
            for (PDIEmailStatusCodes__c emailStatus : PDIEmailStatusCodes__c.getAll().values()){
                emailStatusCodesMap.put(emailStatus.Name, emailStatus.Value__c);
            }
            
            if(summaryObj.Mobile_Phone__c != null && !String.isBlank(summaryObj.Mobile_Phone__c)) {
                mobileNo = summaryObj.Mobile_Phone__c;
                summaryObj.Mobile_Phone__c = summaryObj.Mobile_Phone__c.replaceAll('-','').replaceAll(' ','').replaceAll('\\(','').replaceAll('\\)','');
            }
            if(string.isBlank(summaryObj.Email__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL265_PDI_BlankEmail));
                isAddressValidAllFields = false;
            }
            if(summaryObj.Ok_to_Text__c == true && summaryObj.Mobile_Phone__c == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL266_PDI_BlankMobile));
                isAddressValidAllFields = false;
            }
            if(summaryObj.Mobile_Phone__c != null && (summaryObj.Mobile_Phone__c.length() < 10 || summaryObj.Mobile_Phone__c.length() > 10 || !summaryObj.Mobile_Phone__c.isNumeric())) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL267_PDI_InvalidMobile));
                isAddressValidAllFields = false;
            }
            if(summaryObj.Practicing_Physician__c == false && summaryObj.Retired_Departed__c == false 
               && summaryObj.Resigned_From_Sutter__c == false)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL268_PDI_ProviderStatusEmpty));
                isAddressValidAllFields = false;
            }else if(summaryObj.Practicing_Physician__c == true ||(summaryObj.Resigned_From_Sutter__c == true && summaryObj.Is_Resigned_Provider_refer__c == true))
            {
                if(summaryObj.Admin_Assistant_Email__c != null && !String.isBlank(summaryObj.Admin_Assistant_Email__c) && !AP01_TestDataUtility.isEmailValid(summaryObj.Admin_Assistant_Email__c)){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL353_PDI_AdminEmailRequired));
                    isAddressValidAllFields = false;
                }
                if(primaryAddrObj == null || primaryAddrObj.Address_Line1__c == NULL || String.isBlank(primaryAddrObj.Address_Line1__c)){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL541_PDI_PrimaryAddressReq));
                    isAddressValidAllFields = false; 
                }
                if(primaryAddrObj.Address_Line1__c != null && string.isBlank(primaryAddrObj.Secure_Phone__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL272_PDI_BlankPhone));
                    isAddressValidAllFields = false;
                }
                if(primaryAddrObj.Address_Line1__c != null && string.isBlank(primaryAddrObj.Secure_Fax__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL274_PDI_BlankFax));
                    isAddressValidAllFields = false;
                }
                // Added Tech_Bypass_Address_Verification__c condition check in below condition 
                // on 21/12/2016 to Override the Address Verification validation check
                if(primaryAddrObj.Tech_Bypass_Address_Verification__c == false && primaryAddrObj.Address_Line1__c != null && (primaryAddrObj.Provider_Address_AD_Status__c == null || processCodes.contains(primaryAddrObj.Provider_Address_AD_Status__c))){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL542_PDI_PrimaryAddressInvalid));
                    isAddressValidAllFields = false; 
                }
                //Address Count with out delete address
                Integer secAddressCounter = 0;
                if(!SecondaryAddrList.isEmpty()){
                    for(Provider_Address__c addr : SecondaryAddrList){
                        if(addr.Serial_Number__c != null && String.isNotBlank(addr.Serial_Number__c)){
                            secAddressCounter++;
                        }
                    }
                }
                if(!SecondaryAddrList.isEmpty()){
                    for(Provider_Address__c addr : SecondaryAddrList){
                        // Added Tech_Bypass_Address_Verification__c condition check in below condition 
                        // on 21/12/2016 to Override the Secondary Address Verification validation check
                        if(addr.Tech_Bypass_Address_Verification__c == false && addr.Serial_Number__c != null && String.isNotBlank(addr.Serial_Number__c)){
                            if(addr.Provider_Address_AD_Status__c == null || processCodes.contains(addr.Provider_Address_AD_Status__c)){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL562_PDISecAddSerNumber + addr.Serial_Number__c + Label.CL563_PDIPleaseCorrect));
                                isAddressValidAllFields = false; 
                            }  
                        }
                        if(String.isNotBlank(addr.Serial_Number__c)){
                            String serialNum = addr.Serial_Number__c;
                            if(serialNum.isNumeric()){
                                if(addr.Serial_Number__c != '0'){
                                    if(Integer.valueOf(addr.Serial_Number__c) <= secAddressCounter){
                                        if(!serialNumberSet.contains(addr.Serial_Number__c)){
                                            serialNumberSet.add(addr.Serial_Number__c);
                                        }else{
                                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL543_PDI_SecondaryAddrMsg));
                                            isAddressValidAllFields = false;
                                        }
                                    }else{
                                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL554_PDI_InvalidSerialNumber));
                                        isAddressValidAllFields = false;
                                    }
                                }else{
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL544_PDI_SecondaryAddrMsg2));
                                    isAddressValidAllFields = false;
                                }
                            }else{
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL545_PDI_SecondaryAddressNumeric));
                                isAddressValidAllFields = false;
                            }
                        }
                    }
                }
            }
            //Email Verification Logic Starts
            emailStatusList = new List<PDI_Email_Address_Verification.wrapEmailVerification>();
            //PDI Wave2: Added By Pass Email Verfication logic
            PDIByPassEmailVerification__c ByPassEmailList = PDIByPassEmailVerification__c.getInstance('ByPassEmailVerification');
            if(ByPassEmailList.ByPassInPortal__c != true){
                if(summaryObj.Email__c != null && String.isNotBlank(summaryObj.Email__c)){
                    emailStatusList = PDI_Email_Address_Verification.emailAddressWebService(summaryObj.Email__c, null);
                    if(!emailStatusList.isEmpty()){
                        assignEmailVerificationDetails(emailStatusList);
                        if(emailVerifyErrorMsg != null && String.isNotBlank(emailVerifyErrorMsg)){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, emailVerifyErrorMsg));
                            isAddressValidAllFields = false;
                        }else{
                            if(emailStatusCodesMap.containsKey(summaryObj.Email_Status_Number__c)){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL546_PDI_EmailErrorMsg + '('+ summaryObj.Email_Status_Description__c +')'));
                                isAddressValidAllFields = false;
                            }
                        } 
                    }
                }
                //Email Verification Logic Ends
                //Admin Assistant Email Verification Logic Starts
                if(!Label.CL578_PDI_AdminAsstProfileId.equals(userObj.profileId)){
                    if(summaryObj.Admin_Assistant_Email__c != null && String.isNotBlank(summaryObj.Admin_Assistant_Email__c)){
                        emailStatusList = PDI_Email_Address_Verification.emailAddressWebService(summaryObj.Admin_Assistant_Email__c, null);
                        if(!emailStatusList.isEmpty()){
                            assignEmailVerificationDetails(emailStatusList);
                            if(emailVerifyErrorMsg != null && String.isNotBlank(emailVerifyErrorMsg)){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, emailVerifyErrorMsg));
                                isAddressValidAllFields = false;
                            }else{
                                if(emailStatusCodesMap.containsKey(summaryObj.Email_Status_Number__c)){
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL546_PDI_AsstEmailErrorMsg + '('+ summaryObj.Email_Status_Description__c +')'));
                                    isAddressValidAllFields = false;
                                }
                            } 
                        }
                    }
                }
                //Admin Assistant Email Verification Logic Ends
            }
            //PDI Wave2: Added By Pass Email Verfication logic ended
            if(!isAddressValidAllFields){
                return null;
            }
            
            Contact_Validation_Summary__c pISObjOld = [select id, Contact_Id__c, Practicing_Physician__c, Resigned_From_Sutter__c, Retired_Departed__c,
                                                       Email__c, Speciality__c, Department__c, Mobile_Phone__c, Ok_to_Text__c, Gender__c,
                                                       Preferred_Communication_Method__c, Communication_Preferences_HIM__c, Medical_Education__c, Website_Address__c, 
                                                       Hospital_Affiliations__c, Medical_Affiliations__c, Internship__c, Residency__c, Spoken_Languages__c, Community_Activities__c,
                                                       Personal_Interests__c, Professional_Ineterests__c, Online_Services__c, Board_Certifications__c, Publications__c, 
                                                       Additional_Information__c, Philosophy_of_Care__c, Admin_Assistant_Title__c, Admin_Assistant__c, Admin_Assistant_Email__c,
                                                       Admin_Assistant_Phone__c, Delegate_Phone_Ext__c, PDI_Campaign__c, Provider_Access_Type__c, Provider_Type__c,
                                                       Provider_FirstName__c, Provider_MiddleName__c, Provider_LastName__c,Serial_Number__c,Provider_Title__c,
                                                       Deficiency_Provider__c, Provider_ID__c, Provider_NPI_F__c from Contact_Validation_Summary__c where 
                                                       PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name and Contact_Id__c = :contactId limit 1];
            
            //Retrieving old address details of contact
            providerOldAddrList = [SELECT id, Name, Serial_Number__c, Address_Line1__c, Address_Line_2__c, Address_Type__c, City__c, County__c, State__c, Suite__c, Floor__c,
                                           Secondary_Address_Only__c, Not_to_Send_to_EPIC__c, Patient_Facing__c, Only_for_Lab_Results__c, Zip_Code__c, Secure_Phone__c,
                                           Secure_Phone_Ext__c, Secure_Fax__c, Direct_Address__c, Address_Status__c, Address_Unique_Identifier__c
                                           FROM Provider_Address__c WHERE Contact_Id__c = :contactId AND EPIC_Address_Status__c != :Label.CL471_PDI_EPICAddressInactive 
                                           AND PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name AND Address_Status__c != :Label.CL472_PDI_AddressDelete ORDER BY Serial_Number__c ASC];
            /**** Assigning old summary values to sumObjOld Map Starts ****/
            if(pISObjOld.Practicing_Physician__c == true){
                status = Label.CL243_PDI_Practicing;
            }else if(pISObjOld.Resigned_From_Sutter__c == true){
                status = Label.CL245_PDI_Resign;
            }else if(pISObjOld.Retired_Departed__c == true){
                status = Label.CL244_PDI_Retired;
            }
            if(pISObjOld.Ok_to_Text__c == true){
                okToText = Label.CL261_PDI_Yes;
            }else{  
                okToText = Label.CL262_PDI_No;
            }
            sumObjOld.put(Label.CL305_PDI_ProviderStatus, status);
            sumObjOld.put(Label.CL294_PDI_Log_Email, (pISObjOld.Email__c != null) ? pISObjOld.Email__c : '');
            sumObjOld.put(Label.CL295_PDI_Log_Mobile, (pISObjOld.Mobile_Phone__c !=null) ? pISObjOld.Mobile_Phone__c : '');
            sumObjOld.put(Label.CL306_PDI_OktoText, okToText);
            if(providerSearchFlag == true){
                sumObjOld.put(Label.CL426_PDI_Log_speciality, (pISObjOld.Speciality__c != null) ? pISObjOld.Speciality__c : '');
                sumObjOld.put(Label.CL428_PDI_Log_Department, (pISObjOld.Department__c != null) ? pISObjOld.Department__c : '');
                sumObjOld.put(Label.CL430_PDI_Log_Medical_Education, (pISObjOld.Medical_Education__c != null) ? pISObjOld.Medical_Education__c : '');
                sumObjOld.put(Label.CL432_PDI_Log_Website_Address, (pISObjOld.Website_Address__c != null) ? pISObjOld.Website_Address__c : '');
                sumObjOld.put(Label.CL429_PDI_Log_Hospital_Affiliations, (pISObjOld.Hospital_Affiliations__c != null) ? pISObjOld.Hospital_Affiliations__c : '');
                sumObjOld.put(Label.CL430_PDI_Log_Medical_Affiliations, (pISObjOld.Medical_Affiliations__c != null) ? pISObjOld.Medical_Affiliations__c : '');
                sumObjOld.put(Label.CL433_PDI_Log_Internship, (pISObjOld.Internship__c != null) ? pISObjOld.Internship__c : '');
                sumObjOld.put(Label.CL434_PDI_Log_Residency, (pISObjOld.Residency__c != null) ? pISObjOld.Residency__c : '');
                sumObjOld.put(Label.CL435_PDI_Log_Spoken_Languages, (pISObjOld.Spoken_Languages__c != null) ? pISObjOld.Spoken_Languages__c : '');
                sumObjOld.put(Label.CL436_PDI_Log_Community_Activities, (pISObjOld.Community_Activities__c != null) ? pISObjOld.Community_Activities__c : '');
                sumObjOld.put(Label.CL437_PDI_Log_Personal_Interests, (pISObjOld.Personal_Interests__c != null) ? pISObjOld.Personal_Interests__c : '');
                sumObjOld.put(Label.CL439_PDI_Log_Professional_Interests, (pISObjOld.Professional_Ineterests__c != null) ? pISObjOld.Professional_Ineterests__c : '');
                sumObjOld.put(Label.CL440_PDI_Log_Online_Services, (pISObjOld.Online_Services__c != null) ? pISObjOld.Online_Services__c : '');
                sumObjOld.put(Label.CL441_PDI_Log_Board_Certifications, (pISObjOld.Board_Certifications__c != null) ? pISObjOld.Board_Certifications__c : '');
                sumObjOld.put(Label.CL443_PDI_Log_Publications, (pISObjOld.Publications__c != null) ? pISObjOld.Publications__c : '');
                sumObjOld.put(Label.CL442_PDI_Log_Additional_Information, (pISObjOld.Additional_Information__c != null) ? pISObjOld.Additional_Information__c : '');
                sumObjOld.put(Label.CL438_PDI_Log_Philosophy_of_Care, (pISObjOld.Philosophy_of_Care__c != null) ? pISObjOld.Philosophy_of_Care__c : ''); 
            }
            sumObjOld.put(Label.CL299_PDI_Log_AdminTitle, (pISObjOld.Admin_Assistant_Title__c !=null) ? pISObjOld.Admin_Assistant_Title__c : '');
            sumObjOld.put(Label.CL300_PDI_Log_AdminName, (pISObjOld.Admin_Assistant__c !=null) ? pISObjOld.Admin_Assistant__c : '');
            sumObjOld.put(Label.CL301_PDI_Log_AdminEmail, (pISObjOld.Admin_Assistant_Email__c !=null) ? pISObjOld.Admin_Assistant_Email__c : '');
            sumObjOld.put(Label.CL302_PDI_Log_AdminPhone, (pISObjOld.Admin_Assistant_Phone__c !=null) ? pISObjOld.Admin_Assistant_Phone__c : '');
            /**** Assigning old summary values to sumObjOld Map Ends ****/
            
            /**** Prepare Provider Address list to save in Provider_Address table  starts ****/
            providerAddressList = new List<Provider_Address__c>();
            if(primaryAddrObj != null){
                if(primaryAddrObj.Id != null && primaryAddrObj.EPIC_Address_Status__c != null && Label.CL474_PDI_NewAddress.equalsIgnoreCase(primaryAddrObj.Address_Status__c)){
                    primaryAddrObj.Address_Status__c = Label.CL473_PDI_ModifiedAddress;
                }
                primaryAddrObj.Tech_Find_suggestAddress__c = true;
                providerAddressList.add(primaryAddrObj);
            }
            if(!SecondaryAddrList.isEmpty()){
                for(Provider_Address__c addr : SecondaryAddrList){
                    if(addr.Id != null && addr.EPIC_Address_Status__c != null && Label.CL474_PDI_NewAddress.equalsIgnoreCase(addr.Address_Status__c)){
                        addr.Address_Status__c = Label.CL473_PDI_ModifiedAddress;
                    }
                    addr.Tech_Find_suggestAddress__c = true;
                    providerAddressList.add(addr);
                }
            }
            providerAddressVerfiyList = new List<Provider_Address__c>();
            if(!providerAddressList.isEmpty()){
                for(Provider_Address__c addressVerify : providerAddressList){
                    providerAddressVerfiyList.add(addressVerify);
                }
                if(!providerAddressVerfiyList.isEmpty()){
                    providerAddressList = PDI_Address_Verification.bulkAddressVerificationWebservice(providerAddressVerfiyList);
                }
            } 
            sp = Database.setSavepoint();
            if(!providerAddressList.isEmpty()){
                upsert providerAddressList;
            }
            List<String> addressIdList = new List<String>();
            for(Provider_Address__c newAddr : providerAddressList){
                addressIdList.add(newAddr.Id);
            }
            
            /**** Prepare Provider Address list to save in Provider_Address table  Ends ****/
            //Retrieving  newly added provider address list by contact Id
            providerNewAddrList = [SELECT id, Name, Serial_Number__c, Address_Line1__c, Address_Line_2__c, Address_Type__c, City__c, State__c, Suite__c, Floor__c,County__c,
                                   Patient_Facing__c,Zip_Code__c, Secure_Phone__c, Secure_Phone_Ext__c, Secure_Fax__c, Direct_Address__c, 
                                   Address_Status__c, Address_Unique_Identifier__c
                                   FROM Provider_Address__c WHERE Id IN :addressIdList ORDER BY Serial_Number__c ASC];
            
            UniversalProviderHelper.saveProviderInfo(pISObjOld, providerOldAddrList, providerNewAddrList, contactId, summaryObj, providerSearchFlag);
            
            summaryObj.Mobile_Phone__c = mobileNo;
            summaryObj.Validation_Source_Channel__c = Label.CL372_PDI_ValidationSourceChannel;
            summaryObj.Status__c = Label.CL187_PDI_Validated_Status;
            summaryObj.Tech_Validation_Status__c = Label.CL575_PDI_EmailCampaignText;
            summaryObj.Last_Verified_Date__c  = System.now();
            summaryObj.OwnerId = UserInfo.getUserId();
            summaryObj.Tech_is_Contact_Updated__c = false; //Used to control isChanged flags update through contact update
            summaryObj.Tech_Success_Email__c = true;
            String addressSummary = '';
            if(!providerNewAddrList.isEmpty()){
                addressSummary += Label.CL586_PDI_Table_Tag;
                for(Provider_Address__c provAddressObj : providerNewAddrList){
                    if(provAddressObj.Address_Line1__c != null){
                        if(Label.CL359_PDI_secondaryAddress.equalsIgnoreCase(provAddressObj.Address_Type__c)){
                            if(provAddressObj.Serial_Number__c != null && String.isNotBlank(provAddressObj.Serial_Number__c)){
                                addressSummary += Label.CL589_PDI_TR_Open + Label.CL591_PDI_Td_Top + Label.CL567_PDISecondaryAddressText + strSpace + Label.CL282_PDI_S_hash + strSpace + provAddressObj.Serial_Number__c + Label.CL588_PDI_TD_Close;
                            }else{
                               addressSummary += Label.CL589_PDI_TR_Open + Label.CL591_PDI_Td_Top + Label.CL600_PDI_DeletedSecondaryAddress + strSpace + Label.CL588_PDI_TD_Close; 
                            }
                        }else {
                            addressSummary += Label.CL589_PDI_TR_Open + Label.CL591_PDI_Td_Top + Label.CL566_PDIPrimaryAddressText + strSpace + Label.CL588_PDI_TD_Close;  
                        }
                        addressSummary +=  Label.CL587_PDI_TD_Open + addressLine1Label + provAddressObj.Address_Line1__c + Label.CL283_PDI_singleBreak + addressLine2Label + provAddressObj.Address_Line_2__c + Label.CL283_PDI_singleBreak
                            + cityLabel + provAddressObj.City__c + Label.CL283_PDI_singleBreak + stateLabel + provAddressObj.State__c + Label.CL283_PDI_singleBreak + zipCodeLabel + provAddressObj.Zip_Code__c + Label.CL283_PDI_singleBreak + securePhoneLabel + provAddressObj.Secure_Phone__c + Label.CL283_PDI_singleBreak
                            + phoneExtensionLabel + provAddressObj.Secure_Phone_Ext__c + Label.CL283_PDI_singleBreak + faxLabel + provAddressObj.Secure_Fax__c + Label.CL283_PDI_singleBreak + addressStatusLabel + provAddressObj.Address_Status__c + Label.CL284_doubleBreak + Label.CL588_PDI_TD_Close + Label.CL590_PDI_TR_Close;
                    }
                }
                addressSummary += Label.CL592_PDI_Table_End;
            }
            summaryObj.Address_Summary__c = addressSummary;
            /*@Description:Updating the User record, in case if user updates his E-Mail ID */
            if(summaryObj.Email__c != providerInfo.oldEmail) {
                userObj.email = summaryObj.Email__c;
                update userObj;
            }
            update summaryObj;
            
            /**** Capturing new summary values for comparision in portal Starts ****/
            if(summaryObj.Practicing_Physician__c == true){
                providerStatus = Label.CL243_PDI_Practicing;
            }else if(summaryObj.Resigned_From_Sutter__c == true){
                providerStatus = Label.CL245_PDI_Resign;
            }else if(summaryObj.Retired_Departed__c == true){
                providerStatus = Label.CL244_PDI_Retired;
            }
            if(summaryObj.Ok_to_Text__c == true){
                oktoText1 = Label.CL261_PDI_Yes;
            }else{
                oktoText1 = Label.CL262_PDI_No;
            }
            sumObjNew.put(Label.CL305_PDI_ProviderStatus, providerStatus);
            sumObjNew.put(Label.CL294_PDI_Log_Email, (summaryObj.Email__c != null) ? summaryObj.Email__c : '');
            sumObjNew.put(Label.CL295_PDI_Log_Mobile, (summaryObj.Mobile_Phone__c !=null) ? summaryObj.Mobile_Phone__c : '');
            sumObjNew.put(Label.CL306_PDI_OktoText, oktoText1);
            if(providerSearchFlag == true){
                sumObjNew.put(Label.CL426_PDI_Log_speciality, (summaryObj.Speciality__c != null) ? summaryObj.Speciality__c : '');
                sumObjNew.put(Label.CL428_PDI_Log_Department, (summaryObj.Department__c != null) ? summaryObj.Department__c : '');
                sumObjNew.put(Label.CL430_PDI_Log_Medical_Education, (summaryObj.Medical_Education__c != null) ? summaryObj.Medical_Education__c : '');
                sumObjNew.put(Label.CL432_PDI_Log_Website_Address, (summaryObj.Website_Address__c != null) ? summaryObj.Website_Address__c : '');
                sumObjNew.put(Label.CL429_PDI_Log_Hospital_Affiliations, (summaryObj.Hospital_Affiliations__c != null) ? summaryObj.Hospital_Affiliations__c : '');
                sumObjNew.put(Label.CL430_PDI_Log_Medical_Affiliations, (summaryObj.Medical_Affiliations__c != null) ? summaryObj.Medical_Affiliations__c : '');
                sumObjNew.put(Label.CL433_PDI_Log_Internship, (summaryObj.Internship__c != null) ? summaryObj.Internship__c : '');
                sumObjNew.put(Label.CL434_PDI_Log_Residency, (summaryObj.Residency__c != null) ? summaryObj.Residency__c : '');
                sumObjNew.put(Label.CL435_PDI_Log_Spoken_Languages, (summaryObj.Spoken_Languages__c != null) ? summaryObj.Spoken_Languages__c : '');
                sumObjNew.put(Label.CL436_PDI_Log_Community_Activities, (summaryObj.Community_Activities__c != null) ? summaryObj.Community_Activities__c : '');
                sumObjNew.put(Label.CL437_PDI_Log_Personal_Interests, (summaryObj.Personal_Interests__c != null) ? summaryObj.Personal_Interests__c : '');
                sumObjNew.put(Label.CL439_PDI_Log_Professional_Interests, (summaryObj.Professional_Ineterests__c != null) ? summaryObj.Professional_Ineterests__c : '');
                sumObjNew.put(Label.CL440_PDI_Log_Online_Services, (summaryObj.Online_Services__c != null) ? summaryObj.Online_Services__c : '');
                sumObjNew.put(Label.CL441_PDI_Log_Board_Certifications, (summaryObj.Board_Certifications__c != null) ? summaryObj.Board_Certifications__c : '');
                sumObjNew.put(Label.CL443_PDI_Log_Publications, (summaryObj.Publications__c != null) ? summaryObj.Publications__c : '');
                sumObjNew.put(Label.CL442_PDI_Log_Additional_Information, (summaryObj.Additional_Information__c != null) ? summaryObj.Additional_Information__c : '');
                sumObjNew.put(Label.CL438_PDI_Log_Philosophy_of_Care, (summaryObj.Philosophy_of_Care__c != null) ? summaryObj.Philosophy_of_Care__c : '');
            }
            sumObjNew.put(Label.CL299_PDI_Log_AdminTitle, (summaryObj.Admin_Assistant_Title__c !=null) ? summaryObj.Admin_Assistant_Title__c : '');
            sumObjNew.put(Label.CL300_PDI_Log_AdminName, (summaryObj.Admin_Assistant__c !=null) ? summaryObj.Admin_Assistant__c : '');
            sumObjNew.put(Label.CL301_PDI_Log_AdminEmail, (summaryObj.Admin_Assistant_Email__c !=null) ? summaryObj.Admin_Assistant_Email__c : '');
            sumObjNew.put(Label.CL302_PDI_Log_AdminPhone, (summaryObj.Admin_Assistant_Phone__c !=null) ? summaryObj.Admin_Assistant_Phone__c : '');
            /**** Capturing new summary values for comparision in portal Ends ****/
            Map<String, Provider_Address__c> oldAddressMap = new Map<String, Provider_Address__c>();
            Map<String, String> addrFieldNameMap = new Map<String, String>();
            addrFieldNameMap.put('address_line1__c', addressLine1Label);
            addrFieldNameMap.put('address_line_2__c', addressLine2Label);
            addrFieldNameMap.put('city__c', cityLabel);
            addrFieldNameMap.put('state__c', stateLabel);
            addrFieldNameMap.put('zip_code__c', zipCodeLabel);
            addrFieldNameMap.put('secure_phone__c', securePhoneLabel);
            addrFieldNameMap.put('secure_phone_ext__c', phoneExtensionLabel);
            addrFieldNameMap.put('secure_fax__c', faxLabel);
            addrFieldNameMap.put('address_type__c', addressTypeLabel);
            addrFieldNameMap.put('Address_Status__c', addressStatusLabel);
            
            for(Provider_Address__c oldAddress : providerOldAddrList){
                oldAddressMap.put(oldAddress.Id, oldAddress);
            }
            
            
            //Dynamic Summary Comparision table logic
            String tablediv = '';
            String tablediv0 = '';
            String tablediv1 = '';
            String tablediv2 = '';
            String tablediv3 = '';
            tablediv = compareTableHeader;
            String addressLine1 = '';
            String addressLine2 = '';
            String city = '';
            String state = '';
            String zipCode = '';
            String securePhone = '';
            String phoneExtension = '';
            String fax = '';
            String addressType = '';
            String addressStatus = '';
            for(Provider_Address__c newAddress : providerNewAddrList){
                if(newAddress != null){
                    Provider_Address__c oldAddr = new Provider_Address__c();
                    if(oldAddressMap.containsKey(newAddress.Id)){
                        oldAddr = oldAddressMap.get(newAddress.Id);
                    }
                    addressLine1 = oldAddr.Address_Line1__c != null ? oldAddr.Address_Line1__c : '';
                    addressLine2 = oldAddr.address_line_2__c != null ? oldAddr.address_line_2__c : '';
                    city = oldAddr.City__c != null ? oldAddr.City__c : '';
                    state = oldAddr.State__c != null ? oldAddr.State__c : '';
                    zipCode = oldAddr.Zip_Code__c != null ? oldAddr.Zip_Code__c : '';
                    securePhone = oldAddr.Secure_Phone__c != null ? oldAddr.Secure_Phone__c : '';
                    phoneExtension = oldAddr.Secure_Phone_Ext__c != null ? oldAddr.Secure_Phone_Ext__c : '';
                    fax = oldAddr.Secure_Fax__c != null ? oldAddr.Secure_Fax__c : '';
                    addressType = oldAddr.Address_Type__c != null ? oldAddr.Address_Type__c : '';
                    addressStatus = oldAddr.Address_Status__c != null ? oldAddr.Address_Status__c : '';
                    
                    if(newAddress.Serial_Number__c == '0'){
                        tablediv0 = Label.CL593_PDI_PrimaryAddrRow;
                    }else{
                        if(!String.isBlank(newAddress.Serial_Number__c)){
                            tablediv0 = Label.CL594_PDI_SecondaryAddrRow + newAddress.Serial_Number__c + Label.CL595_PDI_thtd; 
                        }else{
                            tablediv0 = Label.CL596_PDI_DeletedSecondaryAddr; 
                        }
                        
                    }
                    tablediv0 += addressLine1Label +addressLine1 + '<br/>' + addressLine2Label +addressLine2 + '<br/>' + cityLabel + city + '<br/>' 
                        + stateLabel + state + '<br/>' + zipCodeLabel + zipCode + '<br/>' + securePhoneLabel + securePhone + '<br/>'
                        + phoneExtensionLabel + phoneExtension + '<br/>' + faxLabel + fax + '<br/>' + addressTypeLabel + addressType + '<br/>' + addressStatusLabel + addressStatus + '<br/>'
                        + Label.CL588_PDI_TD_Close + Label.CL587_PDI_TD_Open;
                    
                    for(String fieldName : addrFieldNameMap.keySet()){
                        String addressVal = '';
                        if(newAddress.get(fieldName)!=oldAddr.get(fieldName))
                        {
                            addressVal = String.valueOf(newAddress.get(fieldName)) != null ? String.valueOf(newAddress.get(fieldName)) : '';
                            tablediv0 += '<span style=\"color:blue; font-weight: 600;\">' + addrFieldNameMap.get(fieldName) + addressVal + '</span>' + '<br/>';
                        }else{
                            addressVal = String.valueOf(newAddress.get(fieldName)) != null ? String.valueOf(newAddress.get(fieldName)) : '';
                            tablediv0 += addrFieldNameMap.get(fieldName) + addressVal + '<br/>';
                        }
                    }
                    tablediv0 += Label.CL588_PDI_TD_Close + Label.CL590_PDI_TR_Close;
                    tablediv3 += tablediv0; 
                }
            }
            for(String summaryKey: sumObjNew.keySet()){
                tablediv2 = '<tr><th scope=\"row\">'+summaryKey +'</th><td>'+
                    sumObjOld.get(summaryKey)+'</td>';
                if(sumObjOld.get(summaryKey) != sumObjNew.get(summaryKey)){
                    tablediv2 += '<td style=\"color:blue; font-weight: 600;\">'+sumObjNew.get(summaryKey)+ '</td></tr>';
                }else{
                    tablediv2 += '<td>'+sumObjNew.get(summaryKey)+'</td></tr>';
                }
                
                tablediv1 += tablediv2;
            }
            sumObjComparetable = tablediv + tablediv1 + tablediv3 + '</table>';
            section = 'success';
        }catch(DMLException ex) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        } catch(Exception classException) { 
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;
    }
    /*
    * @description  :   This method is used to verify the email address.
    * @param        :   N/A
    * @return       :   void
    */
    private void assignEmailVerificationDetails(List<PDI_Email_Address_Verification.wrapEmailVerification> emailStatusList){
        
        for(PDI_Email_Address_Verification.wrapEmailVerification emailStat : emailStatusList){
            if(emailStat != null){
                if(!String.isBlank(emailStat.errorMessage)){
                    emailVerifyErrorMsg = emailStat.errorMessage;
                }else{
                    summaryObj.Email_Status_Number__c = emailStat.statusNumber;
                    summaryObj.Email_Status_Description__c = emailStat.statusDescription;
                    summaryObj.Email_Hygiene_Result__c = emailStat.hygeineResult; 
                }
            }
        }
    }
    // Address Related Code Starts
    
    /*
    * @description  :   This method is used to retrieve Address Details of the contact
    * @param        :   N/A
    * @return       :   void
    */
    public void retriveAddressDetails(){
        SecondaryAddrList = new List<Provider_Address__c>();   
        primaryAddrObj = new Provider_Address__c();
        statusMap = new Map<Integer, String>();
        resultStatusMap = new Map<String, String>();
        processCodes = new Set<String>();
        correctAddrCodeSet = new Set<String>();
        verifiedAddrCodeSet = new Set<String>();
        addressNotProcessedStatusMap = new Map<String, String>();
        addressWebserviceStatusMap = new Map<String, String>();
        List<Provider_Address__c>  addrObjList = new List<Provider_Address__c>();
        List<Provider_Address__c> tempSecAddressActiveList = new List<Provider_Address__c>();
        try{
            editAddrmode = false;
            reordermode = false;
            // Added Tech_Bypass_Address_Verification__c in query on 21/12/2016 to Override the Address Verification
            addrObjList = [SELECT Serial_Number__c, id, Address_Line1__c, Address_Line_2__c, Address_Type__c, City__c, State__c, County__c, Country__c, Suite__c, Floor__c,
                           Address_Process_Status__c, Address_Mailability_Score__c, Address_Result_Percentage__c, Patient_Facing__c, Address_Unique_Identifier__c,
                           Contact_Id__c, Summary_Id__c, AD_Address_Verification_Status__c, AD_Element_Result_status__c, Zip_Code__c, Secure_Phone__c,
                           Secure_Phone_Ext__c, Secure_Fax__c, Direct_Address__c, Address_Status__c, Address_Validated__c, Decline_Phone__c, Decline_Fax__c,
                           Tech_Is_Address_Updated__c, PDI_Campaign__c, Provider_Address_AD_Status__c, EPIC_Address_Status__c, EPIC_Address_Inactive_Status_Date__c,
                           Tech_Is_Address_Verified__c, Tech_Bypass_Address_Verification__c
                           FROM Provider_Address__c WHERE Contact_Id__c = :contactId AND EPIC_Address_Status__c != :Label.CL471_PDI_EPICAddressInactive 
                           AND PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name AND Address_Status__c != :Label.CL472_PDI_AddressDelete ORDER BY Serial_Number__c ASC];
            Integer secAddressActiveCounter = 0;
            if(!addrObjList.isEmpty()){
                for(Provider_Address__c addrObj1 : addrObjList)
                {
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(addrObj1.Address_Type__c))
                    {
                        primaryAddrObj=addrObj1;
                        if(String.isNotBlank(addrObj1.Secure_Phone__c))
                        {
                            primaryAddrObj.Secure_Phone__c = UniversalProviderHelper.FormatPhone(addrObj1.Secure_Phone__c);
                        }
                        if(String.isNotBlank(addrObj1.Secure_Fax__c)){
                            primaryAddrObj.Secure_Fax__c = UniversalProviderHelper.FormatPhone(addrObj1.Secure_Fax__c);
                        }
                    }
                    else
                    {
                        if(String.isNotBlank(addrObj1.Secure_Phone__c))
                        {
                            addrObj1.Secure_Phone__c = UniversalProviderHelper.FormatPhone(addrObj1.Secure_Phone__c);
                        }
                        if(String.isNotBlank(addrObj1.Secure_Fax__c)){
                            addrObj1.Secure_Fax__c = UniversalProviderHelper.FormatPhone(addrObj1.Secure_Fax__c);
                        }
                        tempSecAddressActiveList.add(addrObj1);
                        secAddressActiveCounter++;
                    }
                }
            }
            Integer maxSerailNumber = 0;
            if(!tempSecAddressActiveList.isEmpty()){
                for(Provider_Address__c secAddr : tempSecAddressActiveList){
                    maxSerailNumber = Integer.valueOf(secAddr.Serial_Number__c);
                }
            }
            if(!tempSecAddressActiveList.isEmpty()){
                if(maxSerailNumber != secAddressActiveCounter){
                    Integer activeSerialNumber = 0;
                    for(Provider_Address__c secAddr : tempSecAddressActiveList){
                        activeSerialNumber = activeSerialNumber + 1;
                        secAddr.Serial_Number__c =  String.valueOf(activeSerialNumber); 
                        SecondaryAddrList.add(secAddr);
                    }
                }else{
                    SecondaryAddrList = tempSecAddressActiveList.clone();
                }
            }
            // New Button Display Logic Starts
            if(primaryAddrObj == null && SecondaryAddrList.isEmpty()){
                showNewButtonFlag = true;
            }else if(primaryAddrObj != null && SecondaryAddrList.isEmpty()){
                showNewButtonFlag = true;
            }else{
                showNewButtonFlag = showNewButton(SecondaryAddrList);
            }
            // New Button Display Logic Ends
            if(reordermode == false){
                showReorderBtnFlag = showReorderButton(SecondaryAddrList);
            }
            // Address Doctor Each element status map Starts 
            for (PDIAddressElementStatus__c eleStatus : PDIAddressElementStatus__c.getAll().values()){
                statusMap.put(Integer.valueOf(eleStatus.Name), eleStatus.Value__c);
            }
            // Address Doctor Each element status result map Ends
            // Address Doctor valid or Invalid result map Starts
            for (PDIResultStatusCodes__c eleStatus : PDIResultStatusCodes__c.getAll().values()){
                resultStatusMap.put(eleStatus.Name, eleStatus.value__c);
            }
            // Address Doctor valid or Invalid result map Ends 
            // Address Doctor Correct Address Code Set Starts
            for (PDIADCorrectAddressCodes__c addrCodes : PDIADCorrectAddressCodes__c.getAll().values()){
                correctAddrCodeSet.add(addrCodes.Name);
            }
            // Address Doctor Correct Address Code Set Ends
            // Address Doctor Verified Address Codes Set Starts
            for (PDIADVerificationCodes__c verifiedCode : PDIADVerificationCodes__c.getAll().values()){
                verifiedAddrCodeSet.add(verifiedCode.Name);
            }
            // Address Doctor Verified Address Codes Set Ends
            // Address Doctor InCorrect Address Codes Set Starts
            for (PDIADErrorCodes__c processErrCode : PDIADErrorCodes__c.getAll().values()){
                processCodes.add(processErrCode.Name);
            }
            // Address Doctor Incorrect Address Codes Set Ends
            for (PDIADNotProcessedCodes__c notProcessed : PDIADNotProcessedCodes__c.getAll().values()){
                addressNotProcessedStatusMap.put(notProcessed.Name, notProcessed.Code__c);
            }
            for (PDIADWebServiceStatusCodes__c status : PDIADWebServiceStatusCodes__c.getAll().values()){
                addressWebserviceStatusMap.put(status.Name, status.Code__c);
            }
            // Added on 21/12/2016 to Override the Address Verification Custom Setting Code Starts
            PDI_Bypass_AddressVerification__c flag = PDI_Bypass_AddressVerification__c.getInstance('BypassAddressVerificationFlag');
            byPassAddressVerificationFlag = flag.byPassValue__c;
            
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
        }
    }
    /*
    * @description  :   This method is used to display new button based on SecondaryAddrList size
    * @param        :   N/A
    * @return       :   void
    */
    private Boolean showNewButton(List<Provider_Address__c> SecondaryAddrList){
        List<Provider_Address__c> tempSecAddrList = new List<Provider_Address__c>();
        Boolean showNewBtn = false;
        if(!SecondaryAddrList.isEmpty()){
            for(Provider_Address__c addressObj : SecondaryAddrList){
                if(!Label.CL472_PDI_AddressDelete.equalsIgnoreCase(addressObj.Address_Status__c)){
                    tempSecAddrList.add(addressObj);
                }
            }
        }
        if(!tempSecAddrList.isEmpty()) { // && tempSecAddrList.size() < 4){
            showNewBtn = true;
        }
        return showNewBtn;
    }
    /*
    * @description  :   This method is used to display reorder button based on SecondaryAddrList size
    * @param        :   N/A
    * @return       :   void
    */
    private Boolean showReorderButton(List<Provider_Address__c> SecondaryAddrList){
        Boolean reorderBtn = false;
        if(!SecondaryAddrList.isEmpty() && SecondaryAddrList.size() > 1){
            reorderBtn = true;
        }else{
            reorderBtn = false;
        }
        return reorderBtn;
    }
    /*
    * @description  :   This method is used to make serail number as editable
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference reorderAddress(){
        reordermode = true;
        showReorderBtnFlag = false;
        return null;
    }
   /*
    * @description  :   This method is used to cancel re ordering the secondary addresses
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference cancelReorder(){
        reordermode = false;
        showReorderBtnFlag = true;
        return null;
    }
    /*
    * @description  :   This method is used assign primary or secondary address values to address obj
    * @param        :   addressObj
    * @return       :   Provider_Address__c
    */
    private Provider_Address__c assignAddress(Provider_Address__c addressObj){
        Provider_Address__c addrObj1 = new Provider_Address__c();
        
        addrObj1.id = addressObj.Id;
        addrObj1.Contact_Id__c = addressObj.Contact_Id__c;
        addrObj1.Summary_Id__c = addressObj.Summary_Id__c;
        addrObj1.Address_Unique_Identifier__c = addressObj.Address_Unique_Identifier__c;
        addrObj1.Tech_Is_Address_Updated__c = addressObj.Tech_Is_Address_Updated__c;
        addrObj1.PDI_Campaign__c = addressObj.PDI_Campaign__c;
        //Address Details
        addrObj1.Address_Type__c = addressObj.Address_Type__c;
        addrObj1.Address_Line1__c = addressObj.Address_Line1__c;
        addrObj1.Address_Line_2__c = addressObj.Address_Line_2__c;
        addrObj1.City__c = addressObj.City__c;
        addrObj1.State__c = addressObj.State__c;
        addrObj1.Zip_Code__c = addressObj.Zip_Code__c;
        addrObj1.County__c = addressObj.County__c;
        addrObj1.Suite__c = addressObj.Suite__c;
        addrObj1.Floor__c = addressObj.Floor__c;
        addrObj1.Country__c = addressObj.Country__c;
        addrObj1.Serial_Number__c = addressObj.Serial_Number__c;
        addrObj1.Direct_Address__c = addressObj.Direct_Address__c;
        addrObj1.Secure_Phone__c = addressObj.Secure_Phone__c;
        addrObj1.Secure_Phone_Ext__c = addressObj.Secure_Phone_Ext__c;
        addrObj1.Secure_Fax__c = addressObj.Secure_Fax__c;
        addrObj1.Decline_Phone__c = addressObj.Decline_Phone__c;
        addrObj1.Decline_Fax__c = addressObj.Decline_Fax__c;
        addrObj1.Tech_Is_Address_Verified__c = addressObj.Tech_Is_Address_Verified__c;
        // Added on 21/12/2016 to Override the Address Verification Starts
        if(byPassAddressVerificationFlag == true){
            addrObj1.Tech_Bypass_Address_Verification__c = true;
        }else{
            addrObj1.Tech_Bypass_Address_Verification__c = addressObj.Tech_Bypass_Address_Verification__c;
        }
        // Added on 21/12/2016 to Override the Address Verification Ends
        //Adress Doctor verification fields        
        addrObj1.Provider_Address_AD_Status__c = addressObj.Provider_Address_AD_Status__c;
        addrObj1.Address_Mailability_Score__c = addressObj.Address_Mailability_Score__c;
        addrObj1.Address_Result_Percentage__c = addressObj.Address_Result_Percentage__c;
        addrObj1.AD_Address_Verification_Status__c = addressObj.AD_Address_Verification_Status__c;
        addrObj1.AD_Element_Result_status__c = null;
        addrObj1.Address_Status__c = addressObj.Address_Status__c;
        
        //EPIC verification fields   
        addrObj1.Address_Process_Status__c = addressObj.Address_Process_Status__c;
        addrObj1.EPIC_Address_Status__c = addressObj.EPIC_Address_Status__c;
        addrObj1.EPIC_Address_Inactive_Status_Date__c = addressObj.EPIC_Address_Inactive_Status_Date__c;
        addrObj1.Patient_Facing__c = addressObj.Patient_Facing__c;
        
        return addrObj1;
    }
    /*
    * @description  :   This method is used create New Address
    * @param        :   N/A
    * @return       :   void
    */
    public PageReference newAddress(){
        address = new Provider_Address__c();
        Integer lastAddrSerialNumber = 0;
        try{
            suggestedAddressFlag = false;
            selectedRecord = null;
            if(!SecondaryAddrList.isEmpty()){
                for(Provider_Address__c secAddr : SecondaryAddrList){
                    if(secAddr.Serial_Number__c != null && String.isNotBlank(secAddr.Serial_Number__c)){
                        lastAddrSerialNumber = Integer.valueOf(secAddr.Serial_Number__c);
                    }
                }
                lastAddrSerialNumber += 1;
                address.Serial_Number__c = String.valueOf(lastAddrSerialNumber);
            }else{
                address.Serial_Number__c = '1';
            }
            address.Contact_Id__c = contactId;
            address.Summary_Id__c = summaryObj.Id;
            address.Address_Status__c = Label.CL474_PDI_NewAddress;
            address.Address_Type__c = Label.CL359_PDI_secondaryAddress;
            address.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            // Added on 21/12/2016 to Override the Address Verification Starts
            if(byPassAddressVerificationFlag == true){
                address.Tech_Bypass_Address_Verification__c = true;
            }else{
                address.Tech_Bypass_Address_Verification__c = false;
            }
            // Added on 21/12/2016 to Override the Address Verification Ends
            editAddrmode = true;
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;
    }
   /*
    * @description  :   This method is used Edit Address
    * @param        :   N/A
    * @return       :   void
    */
    public PageReference getselectedAddress(){
        address = new Provider_Address__c();
        try{
            suggestedAddressFlag = false;
            selectedRecord = null;
            String addressId = Apexpages.currentPage().getParameters().get('addressId');
            String serialNumber = Apexpages.currentPage().getParameters().get('serialnumber');
            editAddrmode = true;
            if(addressId != null && String.isNotBlank(addressId)){
                if(addressId.equalsIgnoreCase(primaryAddrObj.Id)){
                    address = assignAddress(primaryAddrObj);
                    if(primaryAddrObj.EPIC_Address_Status__c != null){
                        address.Address_Status__c = Label.CL473_PDI_ModifiedAddress;
                    }else{
                        address.Address_Status__c = Label.CL474_PDI_NewAddress;
                    }
                }else{
                    for(Provider_Address__c secondaryAddr : SecondaryAddrList){
                        if(addressId.equalsIgnoreCase(secondaryAddr.Id)){
                            address = assignAddress(secondaryAddr);
                            if(secondaryAddr.EPIC_Address_Status__c != null){
                                address.Address_Status__c = Label.CL473_PDI_ModifiedAddress;
                            }else{
                                address.Address_Status__c = Label.CL474_PDI_NewAddress;
                            }
                        }
                    }
                }
            }else{
                if(serialNumber != null){
                    if(serialNumber.equalsIgnoreCase(primaryAddrObj.Serial_Number__c)){
                        address = assignAddress(primaryAddrObj);
                        address.Address_Status__c = Label.CL474_PDI_NewAddress;
                    }else{
                        for(Provider_Address__c secondaryAddr : SecondaryAddrList){
                            if(serialNumber.equalsIgnoreCase(secondaryAddr.Serial_Number__c)){
                                address = assignAddress(secondaryAddr);
                                address.Address_Status__c = Label.CL474_PDI_NewAddress;
                            }
                        }
                    }
                }
            }
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;    
    }
    /*
    * @description  :   This method is used delete Address
    * @param        :   N/A
    * @return       :   void
    */
    public PageReference deleteAddress(){
        List<Provider_Address__c> secondaryAddrDeleteList;
        Integer addrCounter = 0;
        try{
            String serialNumber = Apexpages.currentPage().getParameters().get('serialNumber');
            if(serialNumber != null || String.isNotBlank(serialNumber)){
                secondaryAddrDeleteList = new List<Provider_Address__c>();
                if(!SecondaryAddrList.isEmpty()){
                    for(Provider_Address__c secondaryAddr : SecondaryAddrList){
                        if(String.isNotBlank(secondaryAddr.Serial_Number__c)){
                            if(serialNumber.equalsIgnoreCase(secondaryAddr.Serial_Number__c)){
                                secondaryAddr.Address_Status__c = Label.CL472_PDI_AddressDelete;
                                secondaryAddr.Serial_Number__c = '';
                            }
                            if(secondaryAddr.Serial_Number__c != null && String.isNotBlank(secondaryAddr.Serial_Number__c)){
                                if(serialNumber < secondaryAddr.Serial_Number__c){
                                    Integer serNumber= Integer.valueOf(secondaryAddr.Serial_Number__c) - 1;
                                    secondaryAddr.Serial_Number__c =  String.valueOf(serNumber);
                                }
                                addrCounter++;
                            }
                            secondaryAddrDeleteList.add(secondaryAddr);
                        }
                    }
                    if(tempsecondaryAddrMap != null && !tempsecondaryAddrMap.isEmpty() && tempsecondaryAddrMap.containsKey(serialNumber)){
                         tempsecondaryAddrMap.remove(serialNumber);
                    }
                    /*if(addrCounter < SecondaryAddrList.size()){
                    showNewButtonFlag = true;
                    }else{
                    showNewButtonFlag = false;
                    }*/
                }
                if(!secondaryAddrDeleteList.isEmpty()){
                    SecondaryAddrList = new List<Provider_Address__c>();
                    SecondaryAddrList = secondaryAddrDeleteList.clone();
                }else{
                    SecondaryAddrList = new List<Provider_Address__c>();
                }
            }
            if(addrCounter > 1 && reordermode == false){
                showReorderBtnFlag = true;
            }else{
                showReorderBtnFlag = false;
            }
            editAddrmode = false;
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;
    }
    /*
    * @description  :   This method is used to return Address Readonly page.
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference cancelAddress(){
        if(suggestedAddressFlag == true){
            editAddrmode = true;
            suggestedAddressFlag = false;
            addressline2ErrorFlag = false;
            selectedRecord = null;
        }else{
            selectedRecord = null;
            editAddrmode = false;
            addressline2ErrorFlag = false;
        }
        return null;
    }
    /*
    * @description  :   This method is used to invoke Address doctor service and display suggested Addresses.
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference findSuggestedAddress(){
        isAddressValidAllFields = true;
        isAddressDoctorValidFields = true;
        addressline2ErrorFlag = false;
        suggestedAddressList = new List<Provider_Address__c>();
        selectedRecord = null;
        try{
            if(summaryObj.Practicing_Physician__c == true ||(summaryObj.Resigned_From_Sutter__c == true && summaryObj.Is_Resigned_Provider_refer__c == true))
            { 
                if(string.isBlank(address.Address_Line1__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL269_PDI_BlankAddress));
                    isAddressValidAllFields = false;
                }else if(patterMatcherCareOf(address.Address_Line1__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL271_PDI_streetAddressPattern));
                    isAddressValidAllFields = false;
                }
                if(string.isBlank(address.City__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL276_PDI_BlankCity));
                    isAddressValidAllFields = false;
                }
                if(address.State__c == null || String.isBlank(address.State__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL278_PDI_BlankState));
                    isAddressValidAllFields = false;
                }
                if(string.isBlank(address.Zip_Code__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL277_PDI_BlankZipCode));
                    isAddressValidAllFields = false;
                }
                if(string.isBlank(address.Secure_Phone__c) && address.Address_Type__c.equalsIgnoreCase(Label.CL303_PDIPrimary) && address.Decline_Phone__c == false) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL272_PDI_BlankPhone));
                    isAddressValidAllFields = false;
                } else if(!string.isBlank(address.Secure_Phone__c)) {
                    if(!string.isBlank(address.Secure_Phone__c) && (address.Secure_Phone__c.length() < 14 || address.Secure_Phone__c.length() > 14)) {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL273_PDI_InvalidPhone));
                        isAddressValidAllFields = false;
                    }
                }
                if(!String.isBlank(address.Secure_Phone_Ext__c) && !address.Secure_Phone_Ext__c.isNumeric()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL279_PDI_NumericExt));
                    isAddressValidAllFields = false;
                }
                if(string.isBlank(address.Secure_Fax__c) && address.Address_Type__c.equalsIgnoreCase(Label.CL303_PDIPrimary) && address.Decline_Fax__c == false) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL274_PDI_BlankFax));
                    isAddressValidAllFields = false;
                } else if(!string.isBlank(address.Secure_Fax__c) && (address.Secure_Fax__c.length() < 14 || address.Secure_Fax__c.length() > 14)) {
                    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL275_PDI_InvalidFax));
                    isAddressValidAllFields = false;
                }
            }
            if(!isAddressValidAllFields){
                editAddrmode = true;
                return null;
            }else{
                editAddrmode = true;
            }
            // Added on 21/12/2016 to Override the Address Verification Starts. If Tech_Bypass_Address_Verification is false, it will verify the 
            // Address and display the suggested Address. Otherwise it will goes to else block and calls the saveProviderAddressDetails method
            // to save the Address details, without verification
            if(address.Tech_Bypass_Address_Verification__c == false){  
                if(suggestedAddressFlag == false){
                    verifiedAddressList = new List<PDI_Address_Verification.addressAD>();
                    verifiedAddressList = PDI_Address_Verification.checkProviderAddress(address);
                    if(!verifiedAddressList.isEmpty()){
                        for(PDI_Address_Verification.addressAD adAddress : verifiedAddressList){
                            if(adAddress.errorStatus != null && !String.isBlank(adAddress.errorStatus)){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg + adAddress.errorStatus));
                                isAddressValidAllFields = false;
                                suggestedAddressFlag = false;
                                return null;
                            }else{
                                if(adAddress.addressProcessStatus != null && addressNotProcessedStatusMap.containsKey(adAddress.addressProcessStatus)){
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg + addressNotProcessedStatusMap.get(adAddress.addressProcessStatus)));
                                    isAddressValidAllFields = false;
                                    suggestedAddressFlag = false;
                                    return null;
                                }else if(adAddress.addressProcessStatus != null && addressWebserviceStatusMap.containsKey(adAddress.addressProcessStatus)){
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg + addressWebserviceStatusMap.get(adAddress.addressProcessStatus)));
                                    isAddressValidAllFields = false;
                                    suggestedAddressFlag = false;
                                    return null;
                                }else{
                                    if(adAddress.addressProcessStatus != null && !processCodes.contains(adAddress.addressProcessStatus))
                                    {
                                        if(adAddress.elementResultStatus != null){
                                            String[] responseEleStatusStr = adAddress.elementResultStatus.split('');
                                            for(Integer key : statusMap.keySet()){
                                                if(responseEleStatusStr.get(key) == '3' || responseEleStatusStr.get(key) == '4'){
                                                    String addrValue = statusMap.get(key);
                                                    if(!Label.CL558_PDISubBuildingText.equalsIgnoreCase(addrValue.substring(0, addrValue.length()-1))){
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL559_PDIAddressContainsText + strSpace + addrValue.substring(0, addrValue.length()-1) + Label.CL560_PDICorrectItText));
                                                        isAddressDoctorValidFields = false;
                                                        isAddressValidAllFields = false;
                                                    }
                                                }
                                            } 
                                        }
                                        if(!isAddressDoctorValidFields){
                                            editAddrmode = true;
                                            return null;
                                        }else{
                                            editAddrmode = true;
                                        }
                                        for(Provider_Address__c addrObj : adAddress.verifiedProvAddressList){
                                            suggestedAddressList.add(addrObj);
                                        }
                                        if(!suggestedAddressList.isEmpty()){
                                            suggestedAddressFlag = true;
                                        }   
                                    }else{
                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL548_PDI_ADErrorMessage));
                                        isAddressValidAllFields = false;
                                        suggestedAddressFlag = false;
                                        return null;
                                    } 
                                }
                            }
                        }
                    }
                }
            }else{  // Added on 21/12/2016 to Override the Address Verification Starts
               saveProviderAddressDetails(address); 
            }
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;
    }
    /*
    * @description  :   This method is used to map suggested Address and prepare final address list.
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference saveAddress(){
        isAddressDoctorValidFields = true;
        addressline2ErrorFlag = false;
        String elementResult = '';
        try{
            if(suggestedAddressFlag == true){
                if(!suggestedAddressList.isEmpty()){
                    for(Provider_Address__c addr : suggestedAddressList){
                        if(addr.Formatted_Address__c == selectedRecord){
                            verifiedAddressList = new List<PDI_Address_Verification.addressAD>();
                            verifiedAddressList = PDI_Address_Verification.checkProviderAddress(addr);
                            if(!verifiedAddressList.isEmpty()){
                                for(PDI_Address_Verification.addressAD adAddress : verifiedAddressList){
                                    if(adAddress.errorStatus != null && !String.isBlank(adAddress.errorStatus)){
                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg + adAddress.errorStatus));
                                        isAddressValidAllFields = false;
                                        suggestedAddressFlag = false;
                                        return null;
                                    }else{
                                        if(adAddress.addressProcessStatus != null && addressNotProcessedStatusMap.containsKey(adAddress.addressProcessStatus)){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg + addressNotProcessedStatusMap.get(adAddress.addressProcessStatus)));
                                            isAddressValidAllFields = false;
                                            suggestedAddressFlag = false;
                                            return null;
                                        }else if(adAddress.addressProcessStatus != null && addressWebserviceStatusMap.containsKey(adAddress.addressProcessStatus)){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL547_PDI_ADServiceMsg + addressWebserviceStatusMap.get(adAddress.addressProcessStatus)));
                                            isAddressValidAllFields = false;
                                            suggestedAddressFlag = false;
                                            return null;
                                        }else{
                                            if(adAddress.addressProcessStatus != null && !processCodes.contains(adAddress.addressProcessStatus))
                                            {
                                                if(adAddress.elementResultStatus != null){
                                                    String[] responseEleStatusStr = adAddress.elementResultStatus.split('');
                                                    for(Integer key : statusMap.keySet()){
                                                        if(responseEleStatusStr.get(key) != '0'){
                                                            String addrValue = statusMap.get(key);
                                                            elementResult += '<b>'+ addrValue + ':</b>&nbsp;&nbsp;'+ resultStatusMap.get(responseEleStatusStr.get(key)) + Label.CL283_PDI_singleBreak ;
                                                        }
                                                        if(responseEleStatusStr.get(key) == '3' || responseEleStatusStr.get(key) == '4'){
                                                            String addrValue = statusMap.get(key);
                                                            if(Label.CL527_PDI_Resp_SubBuilding.equalsIgnoreCase(addrValue.substring(0, addrValue.length()-1))){
                                                                isAddressDoctorValidFields = false;
                                                                addressline2ErrorFlag = true;
                                                            }else {
                                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL559_PDIAddressContainsText + addrValue.substring(0, addrValue.length()-1) + Label.CL560_PDICorrectItText));
                                                                isAddressDoctorValidFields = false;
                                                                isAddressValidAllFields = false;
                                                            }
                                                        }
                                                    } 
                                                }
                                                for(Provider_Address__c addrObj : adAddress.verifiedProvAddressList){
                                                    address.Address_Line1__c = addrObj.Address_Line1__c;
                                                    address.Address_Line_2__c = addrObj.Address_Line_2__c;
                                                    address.City__c = addrObj.City__c;
                                                    address.State__c = addrObj.State__c;
                                                    address.Zip_Code__c = addrObj.Zip_Code__c;
                                                    address.County__c = addrObj.County__c;
                                                    address.Provider_Address_AD_Status__c = addrObj.Provider_Address_AD_Status__c;
                                                    address.Address_Mailability_Score__c = addrObj.Address_Mailability_Score__c;
                                                    address.Address_Result_Percentage__c = addrObj.Address_Result_Percentage__c;
                                                    address.AD_Element_Result_status__c = elementResult;
                                                    address.Tech_Is_Address_Verified__c = true;
                                                    address.Tech_Bypass_Address_Verification__c = address.Tech_Bypass_Address_Verification__c; // Added on 21/12/2016 to Override the Address Verification
                                                }
                                                if(!isAddressDoctorValidFields){
                                                    editAddrmode = true;
                                                    suggestedAddressFlag = false;
                                                    return null;
                                                }else{
                                                    editAddrmode = false;
                                                    selectedRecord = '';
                                                }
                                            }else{
                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL548_PDI_ADErrorMessage));
                                                suggestedAddressFlag = false;
                                                return null;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // Added on 21/12/2016 to Override the Address Verification Starts. Calls the saveProviderAddressDetails method to Save the address
            // information once after verification.
            saveProviderAddressDetails(address); 
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;
    }
    
   /*
    * @description  :   This method is used prepare the provider address primary and secondary address lists.
    * @param        :   address
    * @return       :   PageReference
    */
    public void saveProviderAddressDetails(Provider_Address__c address){
        List<Provider_Address__c> secAddrList = new List<Provider_Address__c>();
        suggestedAddressFlag = false;
        editAddrmode = false;
        if(address.Provider_Address_AD_Status__c != null){
            if(correctAddrCodeSet.contains(address.Provider_Address_AD_Status__c)){
                address.AD_Address_Verification_Status__c = Label.CL475_PDI_ADCorrect;
            }else if(verifiedAddrCodeSet.contains(address.Provider_Address_AD_Status__c)){
                address.AD_Address_Verification_Status__c = Label.CL476_PDI_AD_Verified;
            }else if(processCodes.contains(address.Provider_Address_AD_Status__c)){
                address.AD_Address_Verification_Status__c = Label.CL477_PDI_AD_InCorrect;
            }
        }
        if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
            address.Serial_Number__c = '0';
            address.Tech_Is_Address_Updated__c = true;
            primaryAddrObj = address;
        }else{
            if(address.Id == null){
                if(tempsecondaryAddrMap != null && tempsecondaryAddrMap.containsKey(address.Serial_Number__c)){
                    for(Provider_Address__c secaddr : SecondaryAddrList){
                        if(address.Serial_Number__c == secaddr.Serial_Number__c){
                            secaddr.Address_Line1__c = address.Address_Line1__c;
                            secaddr.Address_Line_2__c = address.Address_Line_2__c;
                            secaddr.City__c = address.City__c;
                            secaddr.State__c = address.State__c;
                            secaddr.County__c = address.County__c;
                            secaddr.Zip_Code__c = address.Zip_Code__c;
                            secaddr.Secure_Phone__c = address.Secure_Phone__c;
                            secaddr.Secure_Fax__c = address.Secure_Fax__c;
                            secaddr.Provider_Address_AD_Status__c = address.Provider_Address_AD_Status__c;
                            secaddr.Address_Mailability_Score__c = address.Address_Mailability_Score__c;
                            secaddr.Address_Result_Percentage__c = address.Address_Result_Percentage__c;
                            secaddr.AD_Element_Result_status__c = address.AD_Element_Result_status__c;
                            secaddr.AD_Address_Verification_Status__c = address.AD_Address_Verification_Status__c;
                            secaddr.Tech_Is_Address_Verified__c = address.Tech_Is_Address_Verified__c;
                            secaddr.Tech_Is_Address_Updated__c = true;
                            secaddr.Tech_Bypass_Address_Verification__c = address.Tech_Bypass_Address_Verification__c; // Added on 21/12/2016 to Override the Address Verification
                        }
                        secAddrList.add(secaddr);
                    }
                }else{
                    SecondaryAddrList.add(address); 
                }
            }else{
                for(Provider_Address__c secaddr : SecondaryAddrList){
                    if(address.Id == secaddr.Id){
                        secaddr.Address_Line1__c = address.Address_Line1__c;
                        secaddr.Address_Line_2__c = address.Address_Line_2__c;
                        secaddr.City__c = address.City__c;
                        secaddr.State__c = address.State__c;
                        secaddr.County__c = address.County__c;
                        secaddr.Zip_Code__c = address.Zip_Code__c;
                        secaddr.Secure_Phone__c = address.Secure_Phone__c;
                        secaddr.Secure_Fax__c = address.Secure_Fax__c;
                        secaddr.Provider_Address_AD_Status__c = address.Provider_Address_AD_Status__c;
                        secaddr.Address_Mailability_Score__c = address.Address_Mailability_Score__c;
                        secaddr.Address_Result_Percentage__c = address.Address_Result_Percentage__c;
                        secaddr.AD_Address_Verification_Status__c = address.AD_Address_Verification_Status__c;
                        secaddr.AD_Element_Result_status__c = address.AD_Element_Result_status__c;
                        secaddr.Tech_Is_Address_Verified__c = address.Tech_Is_Address_Verified__c;
                        secaddr.Tech_Is_Address_Updated__c = true;
                        secaddr.Tech_Bypass_Address_Verification__c = address.Tech_Bypass_Address_Verification__c; // Added on 21/12/2016 to Override the Address Verification
                    }
                    secAddrList.add(secaddr);
                }
            }
            if(!secAddrList.isEmpty()){
                SecondaryAddrList = new List<Provider_Address__c>();
                SecondaryAddrList = secAddrList.clone();
            }
        }
        tempsecondaryAddrMap = new Map<String, Provider_Address__c>();
        if(!SecondaryAddrList.isEmpty()){
            for(Provider_Address__c secaddr : SecondaryAddrList){
                tempsecondaryAddrMap.put(secaddr.Serial_Number__c, secaddr);
            }
        }
        if(reordermode == false){
            showReorderBtnFlag = showReorderButton(SecondaryAddrList);
        }
        if(primaryAddrObj == null && SecondaryAddrList.isEmpty()){
            showNewButtonFlag = true;
        }else if(primaryAddrObj != null && SecondaryAddrList.isEmpty()){
            showNewButtonFlag = true;
        }else{
            showNewButtonFlag = showNewButton(SecondaryAddrList);
        }
    }
    /*
    * @description  :   This method is used to Convert the secondary address as primary address.
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference convertAddress(){
        Provider_Address__c dummyprimaryAddr = new Provider_Address__c();
        List<Provider_Address__c> secAddrList = new List<Provider_Address__c>();
        String changedSerialNumber = null;
        try{
            String addressSerialNumber = Apexpages.currentPage().getParameters().get('serNumber');
            if(addressSerialNumber != null && String.isNotBlank(addressSerialNumber)){
                if(!SecondaryAddrList.isEmpty()){
                    for(Provider_Address__c provAddress : SecondaryAddrList){
                        if(addressSerialNumber.equalsIgnoreCase(provAddress.Serial_Number__c)){
                            changedSerialNumber = provAddress.Serial_Number__c;
                            dummyprimaryAddr = provAddress;
                            dummyprimaryAddr.Address_Type__c = Label.CL303_PDIPrimary;
                            dummyprimaryAddr.Serial_Number__c = '0';
                            if(primaryAddrObj.Address_Line1__c != null){
                                primaryAddrObj.Serial_Number__c = changedSerialNumber;
                                primaryAddrObj.Address_Type__c = Label.CL359_PDI_secondaryAddress;
                                secAddrList.add(primaryAddrObj);  
                            }
                        }else{
                            secAddrList.add(provAddress);
                        }
                    }
                    SecondaryAddrList = new List<Provider_Address__c>();
                    if(!secAddrList.isEmpty()){
                        if(primaryAddrObj.Address_Line1__c == null){
                            for(Provider_Address__c objAddr : secAddrList){
                                if(Integer.valueOf(changedSerialNumber) < Integer.valueOf(objAddr.Serial_Number__c)){
                                    Integer serNumber= Integer.valueOf(objAddr.Serial_Number__c) - 1;
                                    objAddr.Serial_Number__c = String.valueOf(serNumber);
                                }
                                SecondaryAddrList.add(objAddr);
                            }
                        }else{
                            SecondaryAddrList = secAddrList.clone();
                        }
                    }else{
                        if(tempsecondaryAddrMap != null && tempsecondaryAddrMap.containsKey(changedSerialNumber)){
                            tempsecondaryAddrMap.remove(changedSerialNumber);
                        }
                    }
                }
                if(changedSerialNumber != null){
                    primaryAddrObj = dummyprimaryAddr;
                }
                editAddrmode = false;
            }
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
            return null;
        }
        return null;
    }
    // Address Related Code Ends
   /**
    * @author      : IDC Team Offshore
    * @description : This method is used to check the entered Care Of against a particular Regular Expression
    * @param       : String
    * @return      : Boolean
    */
    public boolean patterMatcherCareOf(string value) {
        if(value.containsIgnoreCase('Care Of') || value.containsIgnoreCase('C\\O') || value.containsIgnoreCase('D\\O') || value.containsIgnoreCase('S\\O')) {
            return true;
        }
        return false;
    }
   /*
    * @author       :   IDC Offshore
    * @date         :   16/05/2016
    * @description  :   FAQ Wrapper Class Starts
    * @param        :   N/A
    * @return       :   PageReference
    */
    public class wrapperFAQ{
        public String section1{get;set;}
        public String s1Q1{get;set;}
        public String s1Q2{get;set;}
        public String s1Q3{get;set;}
        public String s1Q4{get;set;}
        public String s1Q5{get;set;}
        public String s1Q6{get;set;}
        public String s1Q1A1{get;set;}
        public String s1Q2A2{get;set;}
        public String s1Q3A3{get;set;}
        public String s1Q4A4{get;set;}
        public String s1Q5A5{get;set;}
        public String s1Q6A6{get;set;}
        public String section2{get;set;}
        public String s2Q1{get;set;}
        public String s2Q2{get;set;}
        public String s2Q3{get;set;}
        public String s2Q4{get;set;}
        public String s2Q5{get;set;}
        public String s2Q1A1{get;set;}
        public String s2Q2A2{get;set;}
        public String s2Q3A3{get;set;}
        public String s2Q4A4{get;set;}
        public String s2Q5A5{get;set;}
        public String section3{get;set;}
        public String s3Q1{get;set;}
        public String s3Q2{get;set;}
        public String s3Q3{get;set;}
        public String s3Q4{get;set;}
        public String s3Q5{get;set;}
        public String s3Q6{get;set;}
        public String s3Q7{get;set;}
        public String s3Q1A1{get;set;}
        public String s3Q2A2{get;set;}
        public String s3Q3A3{get;set;}
        public String s3Q4A4{get;set;}
        public String s3Q5A5{get;set;}
        public String s3Q6A6{get;set;}
        public String s3Q7A7{get;set;}
        public String section4{get;set;}
        public String s4Q1{get;set;}
        public String s4Q2{get;set;}
        public String s4Q3{get;set;}
        public String s4Q4{get;set;}
        public String s4Q5{get;set;}
        public String s4Q1A1{get;set;}
        public String s4Q2A2{get;set;}
        public String s4Q3A3{get;set;}
        public String s4Q4A4{get;set;}
        public String s4Q5A5{get;set;}
        
       /*
        * @author       :   IDC Offshore
        * @date         :   16/05/2016
        * @description  :   FAQ Constructor
        * @param        :   N/A
        * @return       :   N/A
        */
        public wrapperFAQ(String article){
            
            section1 = article.substringAfter(Label.CL307_PDI_FAQSection1).substringBefore(Label.CL311_PDI_bslashu);
            s1Q1 = article.substringAfter(Label.CL314_PDI_FAQS1Q1).substringBefore(Label.CL312_PDI_FAQLiUL);
            s1Q1A1 = article.substringAfter(Label.CL315_PDI_FAQS1Q1A1).substringBefore(Label.CL313_PDI_FAQBreak);
            s1Q2 = article.substringAfter(Label.CL316_PDI_FAQS1Q2).substringBefore(Label.CL312_PDI_FAQLiUL);
            s1Q2A2 = article.substringAfter(Label.CL317_PDI_FAQS1Q2A2).substringBefore(Label.CL313_PDI_FAQBreak);
            s1Q3 = article.substringAfter(Label.CL340_PDI_FAQS1Q3).substringBefore(Label.CL312_PDI_FAQLiUL);
            s1Q3A3 = article.substringAfter(Label.CL341_PDI_FAQS1Q3A3).substringBefore(Label.CL313_PDI_FAQBreak);
            s1Q4 = article.substringAfter(Label.CL342_PDI_FAQS1Q4).substringBefore(Label.CL312_PDI_FAQLiUL);
            s1Q4A4 = article.substringAfter(Label.CL342_PDI_FAQS1Q4A4).substringBefore(Label.CL313_PDI_FAQBreak);
            s1Q5 = article.substringAfter(Label.CL603_PDI_FAQS1Q5).substringBefore(Label.CL312_PDI_FAQLiUL);
            s1Q5A5 = article.substringAfter(Label.CL604_PDI_FAQS1Q5A5).substringBefore(Label.CL313_PDI_FAQBreak);
            s1Q6 = article.substringAfter(Label.CL605_PDI_FAQS1Q6).substringBefore(Label.CL312_PDI_FAQLiUL);
            s1Q6A6 = article.substringAfter(Label.CL606_PDI_FAQS1Q6A6).substringBefore(Label.CL313_PDI_FAQBreak);
            
            section2 = article.substringAfter(Label.CL308_PDI_FAQSection2).substringBefore(Label.CL311_PDI_bslashu);
            s2Q1 = article.substringAfter(Label.CL318_PDI_FAQS2Q1).substringBefore(Label.CL312_PDI_FAQLiUL);
            s2Q1A1 = article.substringAfter(Label.CL319_PDI_FAQS2Q1A1).substringBefore(Label.CL313_PDI_FAQBreak);
            s2Q2 = article.substringAfter(Label.CL320_PDI_FAQS2Q2).substringBefore(Label.CL312_PDI_FAQLiUL);
            s2Q2A2 = article.substringAfter(Label.CL321_PDI_FAQS2Q2A2).substringBefore(Label.CL313_PDI_FAQBreak);
            s2Q3 = article.substringAfter(Label.CL322_PDI_FAQS2Q3).substringBefore(Label.CL312_PDI_FAQLiUL);
            s2Q3A3 = article.substringAfter(Label.CL323_PDI_FAQS2Q3A3).substringBefore(Label.CL313_PDI_FAQBreak);
            s2Q4 = article.substringAfter(Label.CL607_PDI_FAQS2Q4).substringBefore(Label.CL312_PDI_FAQLiUL);
            s2Q4A4 = article.substringAfter(Label.CL608_PDI_FAQS2Q4A4).substringBefore(Label.CL313_PDI_FAQBreak);
            s2Q5 = article.substringAfter(Label.CL609_PDI_FAQS2Q5).substringBefore(Label.CL312_PDI_FAQLiUL);
            s2Q5A5 = article.substringAfter(Label.CL610_PDI_FAQS2Q5A5).substringBefore(Label.CL313_PDI_FAQBreak);
            
            section3 = article.substringAfter(Label.CL309_PDI_FAQSection3).substringBefore(Label.CL311_PDI_bslashu);
            s3Q1 = article.substringAfter(Label.CL324_PDI_FAQS3Q1).substringBefore(Label.CL312_PDI_FAQLiUL);
            s3Q1A1 = article.substringAfter(Label.CL325_PDI_FAQS3Q1A1).substringBefore(Label.CL313_PDI_FAQBreak);
            s3Q2 = article.substringAfter(Label.CL326_PDI_FAQS3Q2).substringBefore(Label.CL312_PDI_FAQLiUL);
            s3Q2A2 = article.substringAfter(Label.CL326_PDI_FAQS3Q2A2).substringBefore(Label.CL313_PDI_FAQBreak);
            s3Q3 = article.substringAfter(Label.CL327_PDI_FAQS3Q3).substringBefore(Label.CL312_PDI_FAQLiUL);
            s3Q3A3 = article.substringAfter(Label.CL328_PDI_FAQS3Q3A3).substringBefore(Label.CL313_PDI_FAQBreak);
            s3Q4 = article.substringAfter(Label.CL329_PDI_FAQS3Q4).substringBefore(Label.CL312_PDI_FAQLiUL);
            s3Q4A4 = article.substringAfter(Label.CL330_PDI_FAQS3Q4A4).substringBefore(Label.CL313_PDI_FAQBreak);
            s3Q5 = article.substringAfter(Label.CL331_PDI_FAQS3Q5).substringBefore(Label.CL312_PDI_FAQLiUL);
            s3Q5A5 = article.substringAfter(Label.CL332_PDI_FAQS3Q5A5).substringBefore(Label.CL313_PDI_FAQBreak);
            s3Q6 = article.substringAfter(Label.CL611_PDI_FAQS3Q6).substringBefore(Label.CL312_PDI_FAQLiUL);
            s3Q6A6 = article.substringAfter(Label.CL611_PDI_FAQS3Q6A6).substringBefore(Label.CL313_PDI_FAQBreak);
            s3Q7 = article.substringAfter(Label.CL612_PDI_FAQS3Q7).substringBefore(Label.CL312_PDI_FAQLiUL);
            s3Q7A7 = article.substringAfter(Label.CL613_PDI_FAQS3Q7A7).substringBefore(Label.CL313_PDI_FAQBreak);
            
            section4 = article.substringAfter(Label.CL310_PDI_FAQSection4).substringBefore(Label.CL311_PDI_bslashu);
            s4Q1 = article.substringAfter(Label.CL333_PDI_FAQS4Q1).substringBefore(Label.CL312_PDI_FAQLiUL);
            s4Q1A1 = article.substringAfter(Label.CL335_PDI_FAQS4Q1A1).substringBefore(Label.CL313_PDI_FAQBreak);
            s4Q2 = article.substringAfter(Label.CL336_PDI_FAQS4Q2).substringBefore(Label.CL312_PDI_FAQLiUL);
            s4Q2A2 = article.substringAfter(Label.CL337_PDI_FAQS4Q2A2).substringBefore(Label.CL313_PDI_FAQBreak);
            s4Q3 = article.substringAfter(Label.CL338_PDI_FAQS4Q3).substringBefore(Label.CL312_PDI_FAQLiUL);
            s4Q3A3 = article.substringAfter(Label.CL339_PDI_FAQS4Q3A3).substringBefore(Label.CL313_PDI_FAQBreak);
            s4Q4 = article.substringAfter(Label.CL614_PDI_FAQS4Q4).substringBefore(Label.CL312_PDI_FAQLiUL);
            s4Q4A4 = article.substringAfter(Label.CL615_PDI_FAQS4Q4A4).substringBefore(Label.CL313_PDI_FAQBreak);
            s4Q5 = article.substringAfter(Label.CL616_PDI_FAQS4Q5).substringBefore(Label.CL312_PDI_FAQLiUL);
            s4Q5A5 = article.substringAfter(Label.CL617_PDI_FAQS4Q5A5).substringBefore(Label.CL313_PDI_FAQBreak);
        }
    }//FAQ Wrapper Class Ends
    
}