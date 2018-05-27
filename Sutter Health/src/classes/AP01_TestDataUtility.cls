/**  
*    Class Name: AP01_TestDataUtility
*    Author: Saket
*    Date: 20-November-2013
*    Description:  An apex page controller that exposes the common methods used in Test Classes.
*    History
*    --------
**/
public class AP01_TestDataUtility {

    public static List<Case> testCases = new List<Case>();
    public static List<Case> testGrievanceCases = new List<Case>();
    public static List<Case> testCVCases = new List<Case>();
    public static Account testAccount = new Account(Name = AP01_TestDataTokens.CONTACT_ACCOUNT);
    public static Contact testContact = new Contact();
    public static List<Task> testTasks = new List<Task>();
    public static List<Case> testSRs = new List<Case>();
    public static User s3Agent;
    public static Profile s3Profile;
    public static UserRole portalRole; 
    public static boolean OwnerFlagManageCase = false;     // This varible is defined to stop the Recursion of trigger.
    public static boolean runOnce = true;
    
    public static User shpAgent;
    public static Profile shpProfile;
    
    
    public static final Integer NUMBER_OF_CASES= 30;
    public static ID employeeRecordId;
    public static Boolean isFirstCall = false;
    public static Id accountId;
    public static Id cvRecordType;
    public static Id grievanceRecordType;
    public static Id shpGroup;
    public static Id s3Group;
    public static Id emplInquiryRecordType;
    public static id grievanceSRRecordType;
    
    /**
    * @author IDC team
    * @date 07/8/2015
    * @description This method creates Created Date custom setting record
    * @param 
    * @return 
    */
    public static CreatedDate__c insertCreatedDateCustSetting(){
        
        CreatedDate__c createdDate = new CreatedDate__c();
        createdDate.Name = 'CopyPcpDate';
        createdDate.Created_date__c = system.today();
        insert createdDate;
        
        return createdDate;
    }
    
    /**
    * @author IDC team
    * @date 07/8/2015
    * @description This method creates validated provider contacts
    * @param 
    * @return 
    */
    public static List<Contact> create_Validated_Contact(){
        
        List<Contact> conList = new List<Contact>();
        
        for(Integer i=0; i<5; i++){
        
            Contact con = new Contact();
            con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
            con.Firstname = 'Test';
            con.LastName = 'LastNameP' + i;
            con.Provider_NPI__c = '1234';
            con.Provider_ID__c = '098765';
            con.Provider_Active_Status__c = true;
            con.Provider_Active_Status_Date__c = system.today();
            con.Provider_Practicing_Physician__c = true;
            con.Provider_Type__c = 'External';
            con.Provider_Portal_Last_Validation_Date__c = system.today();
            con.MobilePhone = '(565) 765-7688';
            con.Provider_Correspondence_Fax_Number__c = '(565) 765-7688';
            con.Provider_Correspondence_Phone__c = '(565) 765-7688';
            conList.add(con);
        }
        
        insert conList;
        return conList;
    }
    
    /**
    * @author IDC team
    * @date 06/10/2015
    * @description This method creates validated provider contacts with phone number
    * @param 
    * @return 
    * @Req-3694 
    */
    public static List<Contact> create_Provider_Validated_Contact(){
        
        List<Contact> conList = new List<Contact>();
        
        for(Integer i=0; i<5; i++){
        
            Contact con = new Contact();
            con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
            con.Firstname = 'Test';
            con.LastName = 'LastNameP' + i;
            con.Provider_NPI__c = '1234';
            con.Provider_ID__c = '098765';
            con.provider_correspondence_Phone__c = '(564) 895-6321';
            con.Provider_Portal_Last_Validation_Date__c = system.today();
            conList.add(con);
        }
        
        insert conList;
        return conList;
    }
   
    /*******************************************************************
    Purpose: This method create S3 Human Resources Agent Profile User.
    Parameters: [NA]
    Returns: ['S3 Human Resources Agent' type user]
    Throws [Exceptions]: [If the Agent try to Edit any other field of Case.]
    Requirement: 3708
    ********************************************************************/ 
    
    public static User createS3HRUser(){
        
        Id profileId = [SELECT Id FROM Profile WHERE Name='S3 Human Resources Agent'].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='S3 Tier 1 HR Agent'].Id;
        
        User s3HRUser = new User(Alias = 'standt', Email='s3user@testmethod.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole,
        TimeZoneSidKey='America/Los_Angeles', UserName='s3user@testmethod.com');
        
        insert s3HRUser;
        return s3HRUser;
    }       
    
    /**
    * @author IDC team
    * @date 07/8/2015
    * @description This method creates non validated provider contacts
    * @param 
    * @return 
    */
    public static List<Contact> create_Non_Validated_Contact(){
        
        List<Contact> conList = new List<Contact>();
        
        for(Integer i=0; i<5; i++){
        
            Contact con = new Contact();
            con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
            con.Firstname = 'Test';
            con.LastName = 'LastNameP' + i;
            con.Provider_NPI__c = '1234';
            con.Provider_ID__c = '098765';
            conList.add(con);
        }
        
        insert conList;
        return conList;
    }
    
    /**
    * @author IDC team
    * @date 07/8/2015
    * @description This method create SOC Profile User
    * @param 
    * @return 
    */
    public static User createSOCUser(){
        
        Id profileId = [SELECT Id FROM Profile WHERE Name='PDI'].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='SOC Agents'].Id;
        
        User socUser = new User(Alias = 'standt', Email='standarduser@testmethod.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole,
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testmethod.com');
        
        insert socUser;
        return socUser;
    }
    
    /**
    * @author Nagarjuna Kaipu
    * @date 08/04/2016
    * @description This method will create PDI Profile User
    * @param 
    * @return 
    */
    public static User PDITestUser(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='Account Executive'].Id;
        User PDIUser = new User(Alias = 'RunAs', Email='PDIRunAsUser@test.com', 
                                LastName='RunAsTest', ProfileId = profileId, UserName='PDIRunAsUser@test.com', 
                                EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert PDIUser;
        return PDIUser;
    }
    
   /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for Account.
    * @param 
    * @return 
    */
    public static Account createAccount(){
    
            Account acc = new Account();
            acc.Broker_Firm_HCC_ID__c = AP01_TestDataTokens.BROKER_FIRM_HCC_ID;
            acc.Name = AP01_TestDataTokens.ACCOUNT_NAME;
            acc.Phone = AP01_TestDataTokens.PHONE;
            acc.Tax_ID__c = AP01_TestDataTokens.TAX_ID;
            acc.Account_TIN_Type__c = AP01_TestDataTokens.ACCOUNT_TIN_TYPE;
            
        insert acc;
        
        return acc;
    }
    
    /**
    * @author Atul
    * @date 01/27/2014
    * @description This method create test data for SHP Sales Employer Account.
    * @param 
    * @return 
    */
    public static Account createSalesEmployerAccount(){
    
        Account acc = new Account();
        acc.RecordTypeId = getSalesEmployerRecordTypeId();
        acc.Name = AP01_TestDataTokens.ACCOUNT_NAME;
        
        insert acc;
        return acc;
    }
    
    /**
    * @author Atul
    * @date 01/27/2014
    * @description This method create test data for Employee Distribution.
    * @param 
    * @return 
    */
    public static Account_Employee_Distribution__c createEmpDist(Account acc){
    
        Account_Employee_Distribution__c empDist = new Account_Employee_Distribution__c();
        
        empDist.Account__c = acc.id;
        empDist.Region__c = 'SSR';
        empDist.County__c = 'El Dorado';
        empDist.County_Percent__c = 2;
        
        insert empDist;
        return empDist;
    }
    
    /**
    * @author Atul
    * @date 01/27/2014
    * @description get Sales Employer Account RecordTypeId
    * @param 
    * @return 
    */
    public static Id getSalesEmployerRecordTypeId(){
        Id recordType = [select Id, SobjectType, Name from RecordType where name='SHP Sales Employer' and SObjectType='Account' limit 1].Id;
        return recordType;
    }
    
     /**
    * @author Abhijeet
    * @date 09/04/2015
    * @description This method create test data for record type.
    * @param 
    * @return ID
    */
    public static Id getProviderRecordTypeId() {
        Id recordType = [select Id, SobjectType, Name from RecordType where name='Provider' and SObjectType='Contact' limit 1].Id;
        return recordType;
    }
    

    
    
    /**
    * @author Atul Gupta
    * @date 02/21/2014
    * @description This is a utility method to create a 'Employee' type Contact
    * @param Account 
    * @return Contact
    */
    public static Contact employeeContact(Account acc)
    {
        Contact con = new Contact();
        con.AccountId = acc.id;
        con.LastName =  AP01_TestDataTokens.CONTACT_L_NAME;
        con.RecordTypeId = getRecordTypeId();
        
        insert con;
        
        return con;
    }
    
    /**
    * @author Atul Gupta
    * @date 02/21/2014
    * @description This method is to create a Case of type 'Employee Inquiry'
    * @param Contact
    * @return Case
    */
    public static Case employeeInquiryCase(Contact con)
    {
        Case empCase = new Case();
        empCase.RecordTypeId = getEmployeeInquiryRecordTypeId();
        empCase.ContactId = con.id;
        insert empCase;
        
        return empCase;
    }
    
    /**
    * @author Atul Gupta
    * @date 02/21/2014
    * @description This method is to create a public Case comment
    * @param Case
    * @return CaseComment
    */
    public static CaseComment employeeInquiryCaseComment(Case empInqCase)
    {
        CaseComment comment = new CaseComment();
        comment.ParentId = empInqCase.id;
        comment.IsPublished = true;
        
        insert comment;
        
        return comment;
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for Account.
    * @param 
    * @return 
    */
    public static Account createAccountOwnerValidation(){
    
            Account acc = new Account();
            acc.Broker_Firm_HCC_ID__c = AP01_TestDataTokens.BROKER_FIRM_HCC_ID;
            acc.Name = AP01_TestDataTokens.ACCOUNT_NAME;
            
        insert acc;
        
        return acc;
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for Contact.
    * @param Account object
    * @return Contact
    */
    public static Contact createContactOwnerValidation(Account account){
        
        Contact con = new Contact();
        con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME;
        con.LastName =  AP01_TestDataTokens.CONTACT_L_NAME;
        con.AccountId = account.id;
              
                
        insert con;
        
        return con;
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for portal account.
    * @param 
    * @return Account
    */
    
    public static Account createPortalAccount(){
    
            Account acc = new Account();
            acc.Name = AP01_TestDataTokens.PORTAL_ACCOUNT_NAME;
            
        insert acc;
        
        return acc;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for list of contact.
    * @param 
    * @return Account
    */
    
    public static List<Contact> createContactList(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
            for(integer i=0; i<3;i++){
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME ;
                con.AccountId = account.id;
                con.Employee_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID ;
                con.Phone = AP01_TestDataTokens.PHONE;
                con.BirthDate = system.today();
                con.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
                
                con.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
                con.Member_HCC_ID__c = AP01_TestDataTokens.MEMBER_HCC_ID ;
                
                con.Supplier_Tax_ID__c = AP01_TestDataTokens.SUPPLIER_Tax_ID;
                con.Supplier_NPI__c = AP01_TestDataTokens.SUPPLIER_NPI;
                
                con.Provider_NPI__c = AP01_TestDataTokens.PROVIDER_NPI ;
                
                con.Vendor_ID__c = AP01_TestDataTokens.VENDOR_ID;
                con.Vendor_TaxID__c = AP01_TestDataTokens.VENDOR_TaxID;
                
                conListToAdd.add(con);
            }
        insert conListToAdd;
        
        return conListToAdd;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for list of contact.
    * @param Account
    * @return List of contact
    */
    public static List<Contact> createPortalContacts(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
        Id recordTypeCon = getRecordTypeId();
            for(integer i=0; i<5;i++){
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME + i;
                con.AccountId = account.id;
                con.Employee_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID + i;
                con.Employee_Work_Email__c = 'test' + i + '@sutterhealth.org';
                con.RecordTypeId = recordTypeCon;
                con.EMPLOYEE_UNION_AFFILIATE__C = AP01_TestDataTokens.EMPLOYEE_UNION_AFFILIATE;
                con.EMPLOYEE_AFFILIATE_FACILITY__C = AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
                con.EMPLOYEE_EMPLOYMENT_STATUS__C = AP01_TestDataTokens.EMPLOYEE_EMPLOYMENT_STATUS ;
                con.Employee_EEO_SubCode__c = AP01_TestDataTokens.EMPLOYEE_EEO_SUBCODE;
                conListToAdd.add(con);
            }
        insert conListToAdd;
        
        return conListToAdd;
    }
    
    /**
    * @author Abhijeet
    * @date 09/04/2015
    * @description This method create test data for list of contact of Provider RecordType for Req 3399 PDV.
    * @param Account
    * @return List of contact
    */
    public static List<Contact> createProviderPortalContacts(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
        Id recordTypeCon = getProviderRecordTypeId();
            for(integer i=0; i<5;i++){
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME + i;
                con.AccountId = account.id;
                con.Email='testnondummy@test'+i+'.com';
                con.RecordTypeId = recordTypeCon;
                con.Provider_Practicing_Physician__c = true;
                con.Provider_Active_Status__c = true;
                con.Provider_Active_Status_Date__c = system.today();
                con.Employee_ADID__c = null;
                conListToAdd.add(con);
            }
        insert conListToAdd;
        
        return conListToAdd;
    }
    
    public static Contact createProviderContactSummaryUpd(Account account){
    
        Id recordTypeCon = getProviderRecordTypeId();
    
        Contact objContact = new Contact();
        objContact.lastname ='test lastname';
        objContact.Email = 'testabc@ertyui.com';
        objContact.Accountid=account.id;
        
        insert objContact;
                    
        Contact_Validation_Summary__c objSumm = new Contact_Validation_Summary__c();
        objSumm.name='test';
        objSumm.Contact_Id__c = objContact.id;
        insert objSumm;
        
        return objContact;
    }
    
    
    
    /**
    * @author Abhijeet
    * @date 09/04/2015
    * @description This method create test data for list of contact of Provider RecordType for Req 3399 PDV.
    * @param Account
    * @return List of contact
    */
    public static List<Contact> createProviderPortalContactsTeleForm(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
        Id recordTypeCon = getProviderRecordTypeId();
            for(integer i=0; i<5;i++){
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME + i;
                con.Source_of_E_Mail__c=System.Label.TeleForm;
                con.Email='testemailcheck@testtest'+(i+1)+'.com';
                con.AccountId = account.id;
                con.RecordTypeId = recordTypeCon;
                conListToAdd.add(con);
            }
        insert conListToAdd;
        
        return conListToAdd;
    }

    /**
    * @author Abhijeet
    * @date 
    * @description This method create test data for list of contact of Provider RecordType for Req 3399 PDV.
    * @param Account
    * @return List of contact
    */
    public static List<Contact> createProviderPortalContactsNONTeleForm(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
        Id recordTypeCon = getProviderRecordTypeId();
            for(integer i=0; i<105;i++){
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME + i;
                con.Source_of_E_Mail__c=System.Label.TeleForm;
                con.Email='testemailcheck@testtest'+(i+1)+'.com';
                con.AccountId = account.id;
                con.RecordTypeId = recordTypeCon;
                conListToAdd.add(con);
            }
        
        return conListToAdd;
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for list of portal manager contact.
    * @param Account
    * @return List of contact
    */
    public static List<Contact> createPortalManagerContacts(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
        Id recordTypeCon = getRecordTypeId();
            for(integer i=0; i<5;i++){
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME  + i;
                con.AccountId = account.id;
                con.Employee_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID + i;
                con.Employee_Work_Email__c = 'test' + i + '@sutterhealth.org';
                con.RecordTypeId = recordTypeCon;
                con.EMPLOYEE_UNION_AFFILIATE__C = AP01_TestDataTokens.EMPLOYEE_UNION_AFFILIATE;
                con.EMPLOYEE_AFFILIATE_FACILITY__C = AP01_TestDataTokens.EMPLOYEE_EMPLOYMENT_STATUS ;
                con.EMPLOYEE_EMPLOYMENT_STATUS__C = AP01_TestDataTokens.EMPLOYEE_EEO_SUBCODE ;
                con.Employee_EEO_SubCode__c = '1';
                conListToAdd.add(con);
            }
        insert conListToAdd;
        
        return conListToAdd;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for record type.
    * @param 
    * @return ID
    */
    public static Id getRecordTypeId() {
        Id recordType = [select Id, SobjectType, Name from RecordType where name='Employee' and SObjectType='Contact' limit 1].Id;
        return recordType;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for contact.
    * @param Account
    * @return contact
    */
    public static Contact createContact(Account account){
    
            
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME;
                con.AccountId = account.id;
                con.Employee_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Phone = AP01_TestDataTokens.PHONE;
                con.BirthDate = system.today();
                con.Vendor_ID__c = AP01_TestDataTokens.VENDOR_ID;
                con.Employee_Affiliate_Facility__c = AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY;
                
                con.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD;
                con.Member_HCC_ID__c = AP01_TestDataTokens.MEMBER_HCC_ID;
                
                con.Supplier_Tax_ID__c = AP01_TestDataTokens.SUPPLIER_Tax_ID;
                con.Supplier_NPI__c = AP01_TestDataTokens.SUPPLIER_NPI;
                
                con.Provider_NPI__c = AP01_TestDataTokens.PROVIDER_NPI;
                
                con.Vendor_ID__c = AP01_TestDataTokens.VENDOR_ID;
                con.Vendor_TaxID__c = AP01_TestDataTokens.VENDOR_TaxID;
                
        insert con;
        
        return con;
    }
    
    
   /**
    * @author Abhishek
    * @date 08/17/2015
    * @description This method create test Contact data for PQI .
    * @param Account
    * @return Contact List
    */
    public static List<Contact> createContactListForPQI(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
         PCP_Information__c objPCPInfo = new PCP_Information__c();
            for(integer i=0; i<5;i++){
                Contact con = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(AP01_TestDataTokens.MEMBER).RecordTypeId);
                 //lstPCPInfo = objContact.PCP_Informations__r;
                system.debug('@@@@ record ' +con.RecordTypeId);
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME ;
                con.AccountId = account.id;
                con.Phone = AP01_TestDataTokens.PHONE;
                con.BirthDate = system.today();
                con.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
                con.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
                con.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
                con.Member_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID  + i;
                //con.PCP_Informations__r[0].PCP_Practitioner_Name__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY;
                //con.recordTypeID = 'member';
                conListToAdd.add(con);
            }
        insert conListToAdd;
        
        return conListToAdd;
    }
    
    /**
    * @author Abhishek
    * @date 08/17/2015
    * @description This method create test Contact data for PQI .
    * @param Account
    * @return Contact List
    */
    public static List<Contact> createContactListForPQINegative(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
         PCP_Information__c objPCPInfo = new PCP_Information__c();
            for(integer i=0; i<5;i++){
                Contact con = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(AP01_TestDataTokens.MEMBER).RecordTypeId);
                 //lstPCPInfo = objContact.PCP_Informations__r;
                system.debug('@@@@ record ' +con.RecordTypeId);
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME ;
                con.AccountId = account.id;
                con.Phone = AP01_TestDataTokens.PHONE;
                con.BirthDate = null;
                con.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
                con.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
                con.Member_Group_Affiliation__c= null;
                con.Member_ID__c = null;
                //con.PCP_Informations__r[0].PCP_Practitioner_Name__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY;
                //con.recordTypeID = 'member';
                conListToAdd.add(con);
            }
        insert conListToAdd;
        
        return conListToAdd;
    }
    
    
    
     /**
    * @author Abhishek
    * @date 08/17/2015
    * @description This method create test data for User for PQI.
    * @param 
    * @return user
    */
    public static User createUserPQI(){
    
    String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.id;
        system.debug('!!!usrProfileName ' +usrProfileName );
        User usr = new User();
        usr.LastName = AP01_TestDataTokens.USER_LAST_NAME;  
        usr.Username = AP01_TestDataTokens.USER_NAME;
        usr.Email= AP01_TestDataTokens.USER_EMAIL;
        usr.Alias =AP01_TestDataTokens.ALIAS;
        usr.CommunityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME ;
        usr.TimeZoneSidKey=AP01_TestDataTokens.TIME_ZONES_ID_KEY;
        usr.LocaleSidKey=AP01_TestDataTokens.LOCALE_SID_KEY;
        usr.EmailEncodingKey=AP01_TestDataTokens.EMAIL_ENCODING_KEYS;
        usr.LanguageLocaleKey=AP01_TestDataTokens.LANGUAGE_LOCALE_KEY;
        usr.profileid= usrProfileName ;
        usr.isActive = true;
              
        insert usr;
        return usr;  
    }
    
    
    
    
    /**
    * @author Sushant
    * @date 03/19/2015
    * @description This method create test Contact data for PCP Information Update Trigger.
    * @param Account
    * @return Contact List
    */
    public static List<Contact> createContactListForPCP(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
            for(integer i=0; i<5;i++){
                Contact con = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(AP01_TestDataTokens.MEMBER).RecordTypeId);
                system.debug('@@@@ record ' +con.RecordTypeId);
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME ;
                con.AccountId = account.id;
                con.Employee_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID ;
                con.Phone = AP01_TestDataTokens.PHONE;
                con.BirthDate = system.today();
                con.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
                con.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
                con.Member_HCC_ID__c = AP01_TestDataTokens.MEMBER_HCC_ID ;
                con.Supplier_Tax_ID__c = AP01_TestDataTokens.SUPPLIER_Tax_ID;
                con.Supplier_NPI__c = AP01_TestDataTokens.SUPPLIER_NPI;
                con.Provider_NPI__c = AP01_TestDataTokens.PROVIDER_NPI ;
                con.Vendor_ID__c = AP01_TestDataTokens.VENDOR_ID;
                con.Vendor_TaxID__c = AP01_TestDataTokens.VENDOR_TaxID;
                con.Member_PCP_Practitioner_HR_ID__c= AP01_TestDataTokens.CONT_EMPLOYEE_ID  + i;
                con.Member_PCP_NPI__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_s_PCP_Name_Practice__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_PCP_Name_First__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_PCP_Name_Middle__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_PCP_Name_Last__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Supplier_NPI__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_Effective_Date__c = system.today();
                con.Member_PCP_Supplier_Location_HR_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_PCP_Supplier_Location_Name__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_PCP_Specialty_HR_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_PCP_Specialty_HCC_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_PCP_Specialty_Name__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_PCP_Specialty_Sub_HR_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_PCP_Specialty_Sub_HCC_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_PCP_Specialty_Sub_Name__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                con.Member_HR_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                
                //con.recordTypeID = 'member';
                conListToAdd.add(con);
            }
        insert conListToAdd;
        
        return conListToAdd;
    }
    
    
        /**
    * @author Abhishek gupta
    * @date 03/19/2015
    * @description This method create test Contact data for PCP Information custom console.
    * @param contact
    * @return  List
    */
    
      public static List<PCP_Information__c> createPCP(contact con ){
    
        List<PCP_Information__c> pcpList = new List<PCP_Information__c>();
            for(integer i=0; i<100;i++){ 
                PCP_Information__c pcp = new   PCP_Information__c ();
                pcp.Medical_Group_Affiliation__c = AP01_TestDataTokens.CONTACT_F_NAME ;
                pcp.Member_ID__c = con.id;
                pcp.PCP_Effective_date__c = system.today();
                pcp.PCP_Member_HR_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID + i ;
                pcp.PCP_Practitioner_First_Name__c=AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
                pcp.PCP_Practitioner_HR_ID__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
                pcp.PCP_Practitioner_Last_Name__c = AP01_TestDataTokens.MEMBER_HCC_ID ;
                pcp.PCP_Practitioner_Middle_Name__c = AP01_TestDataTokens.SUPPLIER_Tax_ID;
                pcp.PCP_Practitioner_Name__c = AP01_TestDataTokens.SUPPLIER_NPI;
                pcp.PCP_Speciality__c = AP01_TestDataTokens.VENDOR_ID;
                pcp.PCP_Specialty_HCC_ID__c= AP01_TestDataTokens.VENDOR_TaxID;
                pcp.PCP_Specialty_HR_ID__c= AP01_TestDataTokens.CONT_EMPLOYEE_ID ;
                pcp.PCP_Specialty_Sub_HCC_ID__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                pcp.PCP_Specialty_Sub_HR_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                pcp.PCP_sub_Specialty__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                pcp.PCP_Supplier_Location_HR_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                pcp.PCP_Supplier_Location_name__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                pcp.PCP_Supplier_Name__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                pcp.PCP_Supplier_NPI__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                pcp.PCP_Termination_Date__c=system.today();
                pcp.SPS_Epic_ID__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
                pcpList.add(pcp);
            }
        insert pcpList;
        
        return pcpList;
    }
    
    
    /**
    * @author Abhishek gupta
    * @date 03/19/2015
    * @description This method create test Contact data for Claim header custom console.
    * @param contact
    * @return  List
    */
    
    public static List<Claim_Header__c> claimHeader(contact con ){
       List<Claim_Header__c> clmHdrLst = new List<Claim_Header__c>();
            for(integer i=0; i<100;i++){ 
                Claim_Header__c clmHdr = new   Claim_Header__c ();
               clmHdr.SHPClaimHdr_Claim_HCC_ID__c = AP01_TestDataTokens.CONTACT_F_NAME ;
               
               clmHdr.SHPClaimHdr_Member_Lookup__c = con.id;
               clmHdr.ClaimMemberIdField__c = AP01_TestDataTokens.CLAIM_MEMBER_ID_FIELD;
               clmHdr.SHPClaimHdr_Supplier_HCC_ID__c = AP01_TestDataTokens.VENDOR_TaxID;
               clmHdr.SHPClaimHdr_Claim_DoS_Start__c = system.today(); 
               clmHdr.SHPClaimHdr_Member_HCC_ID__c=AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
               clmHdr.SHPClaimHdr_Procedure_Code_E__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
               clmHdr.Claim_Amount_Allowed__c = AP01_TestDataTokens.amount ;
               clmHdr.Claim_Amount_Copay__c = AP01_TestDataTokens.amount;
               clmHdr.Claim_Amount_Paid__c= AP01_TestDataTokens.amount;
               clmHdr.SHPClaimHdr_Claim_Date_of_Receipt__c = system.today();
               clmHdr.SHPClaimHdr_Supplier_Name__c= AP01_TestDataTokens.VENDOR_TaxID;
               clmHdr.SHPClaimHdr_Claim_DoS_End__c= system.today(); 
               clmHdr.SHPClaimHdr_Subscriber_HCC_ID__c=AP01_TestDataTokens.MEMBER_ID_FIELD ;
               clmHdr.Claim_Amount_Billed__c =AP01_TestDataTokens.amount;
               clmHdr.Claim_Amount_Deductible__c=AP01_TestDataTokens.amount;
               clmHdr.Claim_Amount_Patient_Responsibility__c  = AP01_TestDataTokens.amount;
              
               clmHdrLst.add(clmHdr);
            }
        insert clmHdrLst;
        
        return clmHdrLst;
    }
    
    
 /**
    * @author Abhishek gupta
    * @date 03/19/2015
    * @description This method create test Contact data for Benefit plan coverage custom console.
    * @param contact
    * @return  List
    */
    
     public static List<Benefit_Plan_Coverage__c> benefitPlanCoverage(contact con ){
       List<Benefit_Plan_Coverage__c> benPlnCovLst = new List<Benefit_Plan_Coverage__c>();
            for(integer i=0; i<100;i++){ 
                Benefit_Plan_Coverage__c benPlnCov = new  Benefit_Plan_Coverage__c ();
                             
               benPlnCov.PlanCov_Member_Lookup__c = con.id;
               benPlnCov.PlanCov_Bene_Plan_HCC_ID__c = AP01_TestDataTokens.VENDOR_TaxID;
               benPlnCov.PlanCov_Bene_Plan_Name__c = AP01_TestDataTokens.VENDOR_TaxID; 
               benPlnCov.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
               benPlnCov.PlanCov_Bene_Plan_Date_End__c = system.today(); 
               benPlnCov.PlanCov_Bene_Plan_Type__c = AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY  ;
               
              
               benPlnCovLst.add(benPlnCov);
            }
        insert benPlnCovLst;
        
        return benPlnCovLst;
    }

    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for list of Guarantor.
    * @param 
    * @return List of Guarantor
    */
    public static List<Guarantor__c> createGuarantorList(){
    
        List<Guarantor__c> guarantorList = new List<Guarantor__c>();
            for(integer i=0; i<3;i++){
                Guarantor__c guarantor = new Guarantor__c();
                guarantor.Name= AP01_TestDataTokens.GURANTOR_NAME;
                guarantorList.add(guarantor);
            }
        insert guarantorList;
        
        return guarantorList;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for Guarantor.
    * @param 
    * @return Guarantor
    */
    public static Guarantor__c createGuarantor(){
    
            Guarantor__c guarantor = new Guarantor__c();
            guarantor.Name=AP01_TestDataTokens.GURANTOR_NAME;
        
        insert guarantor;
        
        return guarantor;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for list of Patient.
    * @param 
    * @return List of Patient
    */
    public static List<Patient__c> createPatientList(){
        
        List<Patient__c> patientList = new List<Patient__c>();
        
        for(integer i=0; i<3;i++){
            Patient__c patient = new Patient__c();
            patient.Name = AP01_TestDataTokens.PATIENT_NAME ;
            patient.Patient_First_Name__c = AP01_TestDataTokens.PATIENT_FIRST_NAME ;
            patient.Patient_Last_Name__c = AP01_TestDataTokens.PATIENT_LAST_NAME ;
            patient.Patient_EPI_ID__c = AP01_TestDataTokens.PATIENT_EPI_ID;
            patient.Patient_DotOne__c = AP01_TestDataTokens.PATIENT_DOTONE +i;
            patientList.add(patient);
        }
        insert patientList;
        
        return patientList;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for Patient.
    * @param 
    * @return Patient
    */
    public static Patient__c createPatient(){
    
            Patient__c patient = new Patient__c();
            patient.Name = AP01_TestDataTokens.PATIENT_NAME;
            patient.Patient_First_Name__c = AP01_TestDataTokens.PATIENT_FIRST_NAME;
            patient.Patient_Last_Name__c = AP01_TestDataTokens.PATIENT_LAST_NAME;
            patient.Patient_EPI_ID__c = AP01_TestDataTokens.PATIENT_EPI_ID;
            patient.Patient_DotOne__c = AP01_TestDataTokens.PATIENT_DOTONE;
        
        insert patient;
        
        return patient;
    }
    
    /**
    * @author Kamendra Singh
    * @date 24/09/2015
    * @description This method create test data for Customer Interaction-Field Set custom setting.
    * @param 
    * @return 
    */
    public static list<Customer_Interaction_Field_Set__c> createPATINQCustomerInteractionFieldSet(){//PATINQ,EMPL,SHP MEP,SHPM,SHPP,SHPB,SHPE
            list<Customer_Interaction_Field_Set__c> lstCustInterFieldset = new list<Customer_Interaction_Field_Set__c>();
            
            //ACCTG Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig1 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig1);
            supportConfig1.Name = 'ACCTG';
            supportConfig1.Additional_Information__c = 'S3_Interaction_Log_AI';
            supportConfig1.Closed_Section__c = 'S3_Interaction_Log_Close';
            supportConfig1.Customer_Interaction_Detail__c = 'S3_Interaction_Log_CID';
            supportConfig1.Customer_Interaction_Detail_2__c = 'S3_Interaction_Log_CID_2';
            supportConfig1.Description_Information__c = 'S3_Interaction_Log_DI';
            supportConfig1.Field_Set_Name__c = 'S3_Interaction_Log';
            supportConfig1.Interaction_Details__c = 'S3_Interaction_Log_ID';
            supportConfig1.Related_Lists__c = 'CaseArticles;Cases;CaseMilestones;OpenActivities;CaseComments;Histories;ActivityHistories';
            supportConfig1.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig1);
            
            //EMPL Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig2 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig2);
            supportConfig2.Name = 'EMPL';
            supportConfig2.Additional_Information__c = 'S3_Interaction_Log_AI';
            supportConfig2.Closed_Section__c = 'S3_Interaction_Log_Close';
            supportConfig2.Customer_Interaction_Detail__c = 'S3_Interaction_Log_CID';
            supportConfig2.Customer_Interaction_Detail_2__c = 'S3_Interaction_Log_CID_2';
            supportConfig2.Description_Information__c = 'S3_Interaction_Log_DI';
            supportConfig2.Field_Set_Name__c = 'S3_Interaction_Log';
            supportConfig2.Interaction_Details__c = 'S3_Interaction_Log_ID';
            supportConfig2.Related_Lists__c = 'CaseArticles;Cases;CaseMilestones;OpenActivities;CaseComments;Histories;ActivityHistories';
            supportConfig2.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig2);
            
            //EXEC Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig3 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig3);
            supportConfig3.Name = 'EXEC';
            supportConfig3.Additional_Information__c = 'S3_Interaction_Log_AI';
            supportConfig3.Closed_Section__c = 'S3_Interaction_Log_Close';
            supportConfig3.Customer_Interaction_Detail__c = 'S3_Interaction_Log_CID';
            supportConfig3.Customer_Interaction_Detail_2__c = 'S3_Interaction_Log_CID_2';
            supportConfig3.Description_Information__c = 'S3_Interaction_Log_DI';
            supportConfig3.Field_Set_Name__c = 'S3_Interaction_Log';
            supportConfig3.Interaction_Details__c = 'S3_Interaction_Log_ID';
            supportConfig3.Related_Lists__c = 'CaseArticles;Cases;CaseMilestones;OpenActivities;CaseComments;Histories;ActivityHistories';
            supportConfig3.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig3);
            
            //JOB Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig4 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig4);
            supportConfig4.Name = 'JOB';
            supportConfig4.Additional_Information__c = 'S3_Interaction_Log_AI';
            supportConfig4.Closed_Section__c = 'S3_Interaction_Log_Close';
            supportConfig4.Customer_Interaction_Detail__c = 'S3_Interaction_Log_CID';
            supportConfig4.Customer_Interaction_Detail_2__c = 'S3_Interaction_Log_CID_2';
            supportConfig4.Description_Information__c = 'S3_Interaction_Log_DI';
            supportConfig4.Field_Set_Name__c = 'S3_Interaction_Log';
            supportConfig4.Interaction_Details__c = 'S3_Interaction_Log_ID';
            supportConfig4.Related_Lists__c = 'CaseArticles;Cases;CaseMilestones;OpenActivities;CaseComments;Histories;ActivityHistories';
            supportConfig4.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig4);
            
            //PATINQ Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig5 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig5);
            supportConfig5.Name = 'PATINQ';
            supportConfig5.Additional_Information__c = 'S3_Patient_Interaction_Log_AI';
            supportConfig5.Closed_Section__c = 'S3_Interaction_Log_Close';
            supportConfig5.Customer_Interaction_Detail__c = 'S3_Patient_Interaction_Log_CID';
            supportConfig5.Customer_Interaction_Detail_2__c = 'S3_Patient_Interaction_Log_CID_2';
            supportConfig5.Description_Information__c = 'S3_Interaction_Log_DI';
            supportConfig5.Field_Set_Name__c = 'S3_Patient_Interaction_Log';
            supportConfig5.Interaction_Details__c = 'S3_Patient_Interaction_Log_ID';
            supportConfig5.Related_Lists__c = 'CaseArticles;Cases;Histories';
            supportConfig5.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig5);
            
            //PATREG Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig6 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig6);
            supportConfig6.Name = 'PATREG';
            supportConfig6.Additional_Information__c = 'S3_Patient_Interaction_Log_AI';
            supportConfig6.Closed_Section__c = 'S3_Interaction_Log_Close';
            supportConfig6.Customer_Interaction_Detail__c = 'S3_Patient_Interaction_Log_CID';
            supportConfig6.Customer_Interaction_Detail_2__c = 'S3_Patient_Interaction_Log_CID_2';
            supportConfig6.Description_Information__c = 'S3_Interaction_Log_DI';
            supportConfig6.Field_Set_Name__c = 'S3_Patient_Interaction_Log';
            supportConfig6.Interaction_Details__c = 'S3_Patient_Interaction_Log_ID';
            supportConfig6.Related_Lists__c = 'CaseArticles;Cases;Histories';
            supportConfig6.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig6);
            
            //SHP MEP Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig7 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig7);
            supportConfig7.Name = 'SHP MEP';
            supportConfig7.Additional_Information__c = 'SHP_Interaction_Log_AI';
            supportConfig7.Closed_Section__c = 'SHP_Interaction_Log_Close';
            supportConfig7.Customer_Interaction_Detail__c = 'SHP_MEP_IL_CID';
            supportConfig7.Customer_Interaction_Detail_2__c = '';
            supportConfig7.Description_Information__c = 'SHP_Interaction_Log_DI';
            supportConfig7.Field_Set_Name__c = 'SHP_Interaction_Log';
            supportConfig7.Interaction_Details__c = 'S3_Interaction_Log_ID';
            supportConfig7.Related_Lists__c = 'CaseArticles;Cases;CaseComments;Histories';
            supportConfig7.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig7);
            
            //SHPB Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig8 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig8);
            supportConfig8.Name = 'SHPB';
            supportConfig8.Additional_Information__c = 'SHP_Interaction_Log_AI';
            supportConfig8.Closed_Section__c = 'SHP_Interaction_Log_Close';
            supportConfig8.Customer_Interaction_Detail__c = 'SHP_Interaction_Log_CID';
            supportConfig8.Customer_Interaction_Detail_2__c = '';
            supportConfig8.Description_Information__c = 'SHP_Interaction_Log_DI';
            supportConfig8.Field_Set_Name__c = 'SHP_Interaction_Log';
            supportConfig8.Interaction_Details__c = 'S3_Interaction_Log_ID';
            supportConfig8.Related_Lists__c = 'CaseArticles;Cases;CaseComments;Histories';
            supportConfig8.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig8);
            
            //SHPE Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig9 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig9);
            supportConfig9.Name = 'SHPE';
            supportConfig9.Additional_Information__c = 'SHP_Interaction_Log_AI';
            supportConfig9.Closed_Section__c = 'SHP_Interaction_Log_Close';
            supportConfig9.Customer_Interaction_Detail__c = 'SHP_Interaction_Log_CID';
            supportConfig9.Customer_Interaction_Detail_2__c = '';
            supportConfig9.Description_Information__c = 'SHP_Interaction_Log_DI';
            supportConfig9.Field_Set_Name__c = 'SHP_Interaction_Log';
            supportConfig9.Interaction_Details__c = 'S3_Interaction_Log_ID';
            supportConfig9.Related_Lists__c = 'CaseArticles;Cases;CaseComments;Histories';
            supportConfig9.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig9);
            
            //SHPM Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig10 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig10);
            supportConfig10.Name = 'SHPM';
            supportConfig10.Additional_Information__c = 'SHP_Interaction_Log_AI';
            supportConfig10.Closed_Section__c = 'SHP_Interaction_Log_Close';
            supportConfig10.Customer_Interaction_Detail__c = 'SHP_Interaction_Log_CID';
            supportConfig10.Customer_Interaction_Detail_2__c = '';
            supportConfig10.Description_Information__c = 'SHP_Interaction_Log_DI';
            supportConfig10.Field_Set_Name__c = 'SHP_Interaction_Log';
            supportConfig10.Interaction_Details__c = 'S3_Interaction_Log_ID';
            supportConfig10.Related_Lists__c = 'CaseArticles;Cases;CaseComments;Histories';
            supportConfig10.System_Information__c = 'SHP_Interaction_Log_SI';
            lstCustInterFieldset.add(supportConfig10);
            
            //SHPP Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig11 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig11);
            supportConfig11.Name = 'SHPP';
            supportConfig11.Additional_Information__c = 'SHP_Interaction_Log_AI';
            supportConfig11.Closed_Section__c = 'SHP_Interaction_Log_Close';
            supportConfig11.Customer_Interaction_Detail__c = 'SHP_Interaction_Log_CID';
            supportConfig11.Customer_Interaction_Detail_2__c = '';
            supportConfig11.Description_Information__c = 'SHP_Interaction_Log_DI';
            supportConfig11.Field_Set_Name__c = 'SHP_Interaction_Log';
            supportConfig11.Interaction_Details__c = 'S3_Interaction_Log_ID';
            supportConfig11.Related_Lists__c = 'CaseArticles;Cases;CaseComments;Histories';
            supportConfig11.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig11);
            
            //VEND Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig12 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig12);
            supportConfig12.Name = 'VEND';
            supportConfig12.Additional_Information__c = 'S3_Interaction_Log_AI';
            supportConfig12.Closed_Section__c = 'S3_Interaction_Log_Close';
            supportConfig12.Customer_Interaction_Detail__c = 'S3_Interaction_Log_CID';
            supportConfig12.Customer_Interaction_Detail_2__c = 'S3_Interaction_Log_CID_2';
            supportConfig12.Description_Information__c = 'S3_Interaction_Log_DI';
            supportConfig12.Field_Set_Name__c = 'S3_Interaction_Log';
            supportConfig12.Interaction_Details__c = 'S3_Interaction_Log_ID';
            supportConfig12.Related_Lists__c = 'CaseArticles;Cases;CaseMilestones;OpenActivities;CaseComments;Histories;ActivityHistories';
            supportConfig12.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig12);
            
            //CV Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig13 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig13);
            supportConfig13.Name = 'CV';
            supportConfig13.Additional_Information__c = 'S3_Interaction_Log_AI';
            supportConfig13.Closed_Section__c = 'S3_Interaction_Log_Close';
            supportConfig13.Customer_Interaction_Detail__c = 'S3_Interaction_Log_CID';
            supportConfig13.Customer_Interaction_Detail_2__c = 'S3_Interaction_Log_CID_2';
            supportConfig13.Description_Information__c = 'S3_Interaction_Log_DI';
            supportConfig13.Field_Set_Name__c = 'S3_Interaction_Log';
            supportConfig13.Interaction_Details__c = 'S3_Interaction_Log_ID';
            supportConfig13.Related_Lists__c = 'CaseArticles;Cases;CaseMilestones;OpenActivities;CaseComments;Histories;ActivityHistories';
            supportConfig13.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig13);
            
            //PHYSSVS Customer Interaction-Field Set
            
            Customer_Interaction_Field_Set__c supportConfig14 = Customer_Interaction_Field_Set__c.getOrgDefaults();
            system.debug('Custom Setting Before: ' + supportConfig14);
            supportConfig14.Name = 'PHYSSVS';
            supportConfig14.Additional_Information__c = 'S3_Patient_Interaction_Log_AI';
            supportConfig14.Closed_Section__c = 'S3_Interaction_Log_Close';
            supportConfig14.Customer_Interaction_Detail__c = 'S3_Patient_Interaction_Log_CID';
            supportConfig14.Customer_Interaction_Detail_2__c = 'S3_Patient_Interaction_Log_CID_2';
            supportConfig14.Description_Information__c = 'S3_Interaction_Log_DI';
            supportConfig14.Field_Set_Name__c = 'S3_Patient_Interaction_Log';
            supportConfig14.Interaction_Details__c = 'S3_Patient_Interaction_Log_ID';
            supportConfig14.Related_Lists__c = 'CaseArticles;Cases;Histories';
            supportConfig14.System_Information__c = 'System_Information';
            lstCustInterFieldset.add(supportConfig14);
            
            return lstCustInterFieldset;
    }
    
    /**
    * @author Kamendra Singh
    * @date 29/09/2015
    * @description This method create test data for Contact Fields custom setting.
    * @param 
    * @return 
    */
    public static list<Contact_Fields__c> createContactFieldSet(){
        list<Contact_Fields__c> lstContactFields = new list<Contact_Fields__c>();
        
        //Employee Contact field Set
        
        Contact_Fields__c objContactFields1 = Contact_Fields__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objContactFields1);
        objContactFields1.Name = 'Employee';
        objContactFields1.Field_Names__c = 'Employee ID, Home Address, DOB, Manager Name';
        objContactFields1.Validation_No__c = 3;
        lstContactFields.add(objContactFields1);
        
        //Guarantor Contact field Set
        
        Contact_Fields__c objContactFields2 = Contact_Fields__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objContactFields2);
        objContactFields2.Name = 'Guarantor';
        objContactFields2.Field_Names__c = 'Name, DOB, Account Number, Medical Record Number, Location/Date of Service(Optional)';
        objContactFields2.Validation_No__c = 3;
        lstContactFields.add(objContactFields2);
        
        //Patient Contact field Set
        
        Contact_Fields__c objContactFields3 = Contact_Fields__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objContactFields3);
        objContactFields3.Name = 'Patient';
        objContactFields3.Field_Names__c = 'Patient Name, Home Address, Last 4 Patient SSN, DOB, Patient Account Number, Medical Record Number';
        objContactFields3.Validation_No__c = 3;
        lstContactFields.add(objContactFields3);
        
        //Provider Contact field Set
        
        Contact_Fields__c objContactFields4 = Contact_Fields__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objContactFields4);
        objContactFields4.Name = 'Provider';
        objContactFields4.Field_Names__c = 'Provider Name, Address, License, Speciality, Phone';
        objContactFields4.Validation_No__c = 3;
        lstContactFields.add(objContactFields4);
        
        //Vendor Contact field Set
        
        Contact_Fields__c objContactFields5 = Contact_Fields__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objContactFields5);
        objContactFields5.Name = 'Vendor';
        objContactFields5.Field_Names__c = 'Vendor Name, Vendor Tax ID(not applicable for all Vendors), Vendor Number';
        objContactFields5.Validation_No__c = 3;
        lstContactFields.add(objContactFields5);
        
        return lstContactFields;
    }
    /**
    * @author Kamendra Singh
    * @date 30/09/2015
    * @description This method create test data for Profile Based Search custom setting.
    * @param 
    * @return 
    */
    public static list<Profile_Based_Search__c> createProfileSearchBasedSet(){
        list<Profile_Based_Search__c> lstProfileBasedSearch = new list<Profile_Based_Search__c>();
        
        //S3 CALL CENTER LEAD Profile Based Search
        
        Profile_Based_Search__c objProfileBasedSearch1 = Profile_Based_Search__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objProfileBasedSearch1);
        objProfileBasedSearch1.Name = 'S3 CALL CENTER LEAD';
        objProfileBasedSearch1.Search_Options__c = 'Employee,Vendor,Provider,Patient,Patient Account';
        lstProfileBasedSearch.add(objProfileBasedSearch1);
        
        //S3 CREDENTIALING VERIFICATION AGENT Profile Based Search
        
        Profile_Based_Search__c objProfileBasedSearch2 = Profile_Based_Search__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objProfileBasedSearch2);
        objProfileBasedSearch2.Name = 'S3 CREDENTIALING VERIFICATION AGENT';
        objProfileBasedSearch2.Search_Options__c = 'Employee,Provider';
        lstProfileBasedSearch.add(objProfileBasedSearch2);
        
        //S3 FINANCE ACCOUNTING AGENT Profile Based Search
        
        Profile_Based_Search__c objProfileBasedSearch3 = Profile_Based_Search__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objProfileBasedSearch3);
        objProfileBasedSearch3.Name = 'S3 FINANCE ACCOUNTING AGENT';
        objProfileBasedSearch3.Search_Options__c = 'Employee';
        lstProfileBasedSearch.add(objProfileBasedSearch3);
        
        //S3 FINANCE ACCOUNTS PAYABLE AGENT Profile Based Search
        
        Profile_Based_Search__c objProfileBasedSearch4 = Profile_Based_Search__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objProfileBasedSearch4);
        objProfileBasedSearch4.Name = 'S3 FINANCE ACCOUNTS PAYABLE AGENT';
        objProfileBasedSearch4.Search_Options__c = 'Employee,Vendor';
        lstProfileBasedSearch.add(objProfileBasedSearch4);
        
        //S3 FINANCE PAYROLL AGENT Profile Based Search
        
        Profile_Based_Search__c objProfileBasedSearch5 = Profile_Based_Search__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objProfileBasedSearch5);
        objProfileBasedSearch5.Name = 'S3 FINANCE PAYROLL AGENT';
        objProfileBasedSearch5.Search_Options__c = 'Employee';
        lstProfileBasedSearch.add(objProfileBasedSearch5);
        
        //S3 HUMAN RESOURCES AGENT Profile Based Search
        
        Profile_Based_Search__c objProfileBasedSearch6 = Profile_Based_Search__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objProfileBasedSearch6);
        objProfileBasedSearch6.Name = 'S3 HUMAN RESOURCES AGENT';
        objProfileBasedSearch6.Search_Options__c = 'Employee';
        lstProfileBasedSearch.add(objProfileBasedSearch6);
        
        //S3 REVENUE CYCLE AGENT Profile Based Search
        
        Profile_Based_Search__c objProfileBasedSearch7 = Profile_Based_Search__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objProfileBasedSearch7);
        objProfileBasedSearch7.Name = 'S3 REVENUE CYCLE AGENT';
        objProfileBasedSearch7.Search_Options__c = 'Patient,Patient Account,Provider';
        lstProfileBasedSearch.add(objProfileBasedSearch7);
        
        //S3 SUPPLY CHAIN AGENT Profile Based Search
        
        Profile_Based_Search__c objProfileBasedSearch8 = Profile_Based_Search__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objProfileBasedSearch8);
        objProfileBasedSearch8.Name = 'S3 SUPPLY CHAIN AGENT';
        objProfileBasedSearch8.Search_Options__c = 'Employee,Vendor';
        lstProfileBasedSearch.add(objProfileBasedSearch8);
        
        //SHP AGENT Profile Based Search
        
        Profile_Based_Search__c objProfileBasedSearch9 = Profile_Based_Search__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objProfileBasedSearch9);
        objProfileBasedSearch9.Name = 'SHP AGENT';
        objProfileBasedSearch9.Search_Options__c = 'Broker,Employer,Member,Provider';
        lstProfileBasedSearch.add(objProfileBasedSearch9);
        
        return lstProfileBasedSearch;
    }
    
    /**
    * @author Kamendra Singh
    * @date 24/09/2015
    * @description This method create FAQ_kav
    * @param 
    * @return 
    */
    public static void CreateFAQ_kav(){
        FAQ__kav tempFAQkav = new FAQ__kav(
            Title = 'test apex',
            Summary = 'test from apex',
            URLName = 'testUniqueUrlName'
        );
 
        insert tempFAQkav;
        //retrieve master article Id created on FAQ__kav record insertion
        //in order to get the KnowledgeArticleId
        tempFAQkav = [SELECT KnowledgeArticleId FROM FAQ__kav WHERE Id = :tempFAQkav.Id]; 
        //publish it
        KbManagement.PublishingService.publishArticle(tempFAQkav.KnowledgeArticleId, true);
    } 


    /**
    * @author Saddam 
    * @date 05/10/2015
    * @description This method create test data for CS_ManageProfile custom setting.
    * @param 
    * @return : Manageprofile list 
    */
    public static list<CS_ManageProfile__c> createManageprofileSet(){
        list<CS_ManageProfile__c> lstManageProfile = new list<CS_ManageProfile__c>();
        
        //Community Portal CS_ManageProfile
        
        CS_ManageProfile__c objManageProfile = CS_ManageProfile__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objManageProfile);
        objManageProfile.Name = 'Communities_Portal';
        objManageProfile.Profile_Name__c = 'Community Portal';
        lstManageProfile.add(objManageProfile);
        
        //Communities_Provider CS_ManageProfile
        
        CS_ManageProfile__c objManageProfile1 = CS_ManageProfile__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objManageProfile1);
        objManageProfile1.Name = 'Communities_Provider';
        objManageProfile1.Profile_Name__c = 'PDV Community Provider';
        lstManageProfile.add(objManageProfile1);
        
        
        //Community_Portal_Manager CS_ManageProfile
        
        CS_ManageProfile__c objManageProfile2 = CS_ManageProfile__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objManageProfile2);
        objManageProfile2.Name = 'Community_Portal_Manager';
        objManageProfile2.Profile_Name__c = 'Community Portal Manager';
        lstManageProfile.add(objManageProfile2);
        
        return lstManageProfile;
    }
    /**
    * @author Saddam 
    * @date 05/10/2015
    * @description This method create test data for Access Token Setting custom setting.
    * @param 
    * @return : AccessTokenSetting list 
    */
    public static list<AccessTokenSetting__c> createAccessTokenSettingSet(){
        list<AccessTokenSetting__c> lstAccessTokenSetting = new list<AccessTokenSetting__c>();
        
        //Community Portal AccessTokenSetting
        
        AccessTokenSetting__c objAccessTokenSetting = AccessTokenSetting__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objAccessTokenSetting);
        objAccessTokenSetting.Name = 'Administrator';
        objAccessTokenSetting.Username__c = 'hernanf3@sutterhealth.org';
        objAccessTokenSetting.Password__c = 'UGEkJHdvcmQ3';
        
        lstAccessTokenSetting.add(objAccessTokenSetting);
        
        return lstAccessTokenSetting;
    }

        
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for List of Patient Account .
    * @param guarantor ,patient
    * @return Patient Account List
    */
    public static List<Patient_Account__c> createPatientAccountList(Guarantor__c guarantor, Patient__c patient){
    
        List<Patient_Account__c> patientList = new List<Patient_Account__c>();
            for(integer i=0; i<3;i++){
                Patient_Account__c patAccount = new Patient_Account__c();
                patAccount.Patient_Account_Number__c = AP01_TestDataTokens.PATIENT_ACCOUNT_NUMBER;
                patAccount.Guarantor_ID_Lookup__c = guarantor.id;
                patAccount.Patient_DotOne_Lookup__c = patient.id;
                patientList.add(patAccount);
            }
        insert patientList;
        
        return patientList;
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for Patient Account .
    * @param guarantor ,patient
    * @return Patient Account
    */
    public static Patient_Account__c createPatientAccount(Guarantor__c guarantor, Patient__c patient){
    
            Patient_Account__c patAccount = new Patient_Account__c();
            patAccount.Patient_Account_Number__c = AP01_TestDataTokens.PATIENT_ACCOUNT_NUMBER;
            patAccount.Guarantor_ID_Lookup__c = guarantor.id;
            patAccount.Patient_DotOne_Lookup__c = patient.id;
        insert patAccount;
        
        return patAccount;
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for claim header .
    * @param 
    * @return claim header
    */
    public static Claim_Header__c createClaimHeader(){
        
        Claim_Header__c claimHeader = new Claim_Header__c();
        claimHeader.SHPClaimHdr_Claim_HCC_ID__c = AP01_TestDataTokens.SHPCLAIMHDR_CLAIM_HCC_ID ;
            claimHeader.ClaimMemberIdField__c = AP01_TestDataTokens.CLAIM_MEMBER_ID_FIELD ;
            claimHeader.SHPClaimHdr_Supplier_HCC_ID__c = AP01_TestDataTokens.SHPCLAIMHDR_SUPPLIER_HCC_ID;
            claimHeader.SHPClaimHdr_Claim_DoS_Start__c = system.today() - 7;
            claimHeader.SHPClaimHdr_Claim_DoS_End__c = system.today() + 7;
            claimHeader.SHPClaimHdr_Member_HCC_ID__c = AP01_TestDataTokens.CLAIM_MEMBER_ID_FIELD;
            claimHeader.SHPClaimHdr_Supplier_Epic_ID__c = AP01_TestDataTokens.SHPCLAIMHDR_SUPPLIER_HCC_ID;
        insert claimHeader;
        return claimHeader;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for claim header list.
    * @param 
    * @return claim header list
    */
    public static List<Claim_Header__c> createClaimHeaderList(){
        
        List<Claim_Header__c> claimHeaderList = new List<Claim_Header__c>();
        
            
        for(integer i=0; i<3;i++){
            Claim_Header__c claimHeader = new Claim_Header__c();
            claimHeader.SHPClaimHdr_Claim_HCC_ID__c = AP01_TestDataTokens.SHPCLAIMHDR_CLAIM_HCC_ID ;
            claimHeader.ClaimMemberIdField__c = AP01_TestDataTokens.CLAIM_MEMBER_ID_FIELD;
            claimHeader.SHPClaimHdr_Supplier_HCC_ID__c = AP01_TestDataTokens.SHPCLAIMHDR_SUPPLIER_HCC_ID;
            claimHeader.SHPClaimHdr_Claim_DoS_Start__c = system.today() - 7;
            claimHeader.SHPClaimHdr_Claim_DoS_End__c = system.today() + 7;
            claimHeader.SHPClaimHdr_Member_HCC_ID__c = AP01_TestDataTokens.CLAIM_MEMBER_ID_FIELD;
            claimHeader.SHPClaimHdr_Supplier_Epic_ID__c = AP01_TestDataTokens.SHPCLAIMHDR_SUPPLIER_HCC_ID;
            claimHeaderList.add(claimHeader);
        }
        insert claimHeaderList;
        return claimHeaderList;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for case.
    * @param 
    * @return claim header list
    */
    public static Case createCase(){
        
        Case  caseItem = new Case();
        caseItem.SearchDate__c = Date.today();             
        insert caseItem;
        return caseItem;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for Customer Inquiry Claim Association.
    * @param customer inquery Id,claim Id
    * @return Customer Inquiry Claim Association
    */
    public static List<Customer_Inquiry_Claim_Association__c> custIntClaimAssList(String custId, String claimId){
        
        List<Customer_Inquiry_Claim_Association__c> associationList = new List<Customer_Inquiry_Claim_Association__c>();
        for(integer i=0; i<5; i++){
            Customer_Inquiry_Claim_Association__c custIntAss = new Customer_Inquiry_Claim_Association__c();
            custIntAss.Claim__c = claimId;
            custIntAss.Customer_Inquiry__c = custId;
            associationList.add(custIntAss); 
        }
        insert associationList;
        return associationList;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for User.
    * @param 
    * @return user
    */
    public static User createUser(){
    
    String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.id;
        system.debug('!!!usrProfileName ' +usrProfileName );
        User usr = new User();
        usr.LastName = AP01_TestDataTokens.USER_LAST_NAME;  
        usr.Username = AP01_TestDataTokens.USER_NAME;
        usr.Email= AP01_TestDataTokens.USER_EMAIL;
        usr.Alias =AP01_TestDataTokens.ALIAS;
        usr.CommunityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME ;
        usr.TimeZoneSidKey=AP01_TestDataTokens.TIME_ZONES_ID_KEY;
        usr.LocaleSidKey=AP01_TestDataTokens.LOCALE_SID_KEY;
        usr.EmailEncodingKey=AP01_TestDataTokens.EMAIL_ENCODING_KEYS;
        usr.LanguageLocaleKey=AP01_TestDataTokens.LANGUAGE_LOCALE_KEY;
        usr.profileid= usrProfileName ;
        usr.isActive = true;
              
        //insert usr;
        return usr;  
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description This method create test data for Entitlement.
    * @param 
    * @return list of Entitlement
    */
    public static List<Entitlement> createEntitlement(){
    
    List<Entitlement>  ent = [select Id from Entitlement where Name = :system.label.CL39_PDREntitlement limit 1];
    
    return ent;
    
    }
    /**
    * @author Atul
    * @date 01/08/2014
    * @description This method is called by VFC01_CustomConsoleTest to convert string to DateTime format
    * @param 
    * @return DateTime
    */
    public static DateTime convertToDateTime(string callDate){
            
        string year = callDate.substring(0, 4);
        string month = callDate.substring(4, 6);
        string day = callDate.substring(6, 8);
        string hour = callDate.substring(8, 10);
        string min = callDate.substring(10, 12);
        string sec = callDate.substring(12, 14);
        
        string dateString  = year+'-'+month+'-'+day+' '+hour+':'+min+':'+sec;
        return DateTime.valueOf(dateString);
    }
    
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method prepares the User where the Profile Name is 'S3 Finance Accounting Agent' .
    * @param 
    * @return 
    */
    public static void prepareUsers() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];  
        System.runAs (thisUser) {  
            portalRole = [Select Id From UserRole Where PortalType = :AP01_TestDataTokens.PORTAL_TYPE Limit 1];
            s3Profile = [Select Id from Profile where name =: AP01_TestDataTokens.S3_PROFILE_NAME Limit 1];
                    
 
                
            s3Agent = new User(
                    ProfileId = s3Profile.Id,
                    Username = AP01_TestDataTokens.USER_NAME,
                    UserRoleId = portalRole.Id,
                    Alias =  AP01_TestDataTokens.ALIAS,
                    Email= AP01_TestDataTokens.EMAIL,
                    EmailEncodingKey=AP01_TestDataTokens.EMAIL_ENCODING_KEYS,
                    Firstname=AP01_TestDataTokens.FIRST_NAME,
                    Lastname=AP01_TestDataTokens.LAST_NAME,
                    CommunityNickname =AP01_TestDataTokens.COMMUNITY_NICK_NAME,
                    LanguageLocaleKey=AP01_TestDataTokens.LANGUAGE_LOCALE_KEY,
                    LocaleSidKey=AP01_TestDataTokens.LOCALE_SID_KEY,
                    TimeZoneSidKey=AP01_TestDataTokens.TIME_ZONES_ID_KEY
                ); 
                
            insert s3Agent;
        }
    }
    
     /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method prepares the Test Data.
    * @param 
    * @return 
    */
    public static void prepareTestData(Integer numberOfCases) {
    
        //testAccount.Name = AP01_TestDataTokens.CONTACT_ACCOUNT;
        system.debug('@@test account :'+testAccount);
        insert testAccount;
        id grievanceRecordType1 = getGrievanceRecordTypeId();
        
        testContact.AccountId = testAccount.Id;
        testContact.RecordTypeId = getMemRecordTypeId();
        testContact.FirstName = AP01_TestDataTokens.CONTACT_FIRST_NAME;
        testContact.LastName = AP01_TestDataTokens.CONTACT_LAST_NAME;
        testContact.Phone = AP01_TestDataTokens.CONTACT_PHONE;
        testContact.BirthDate = date.parse(AP01_TestDataTokens.CONTACT_BIRTH_DATE);
        testContact.EMPLOYEE_UNION_AFFILIATE__C = AP01_TestDataTokens.CONTACT_EMPLOYEE_UNION_AFFILIATE;
        testContact.EMPLOYEE_AFFILIATE_FACILITY__C = AP01_TestDataTokens.CONTACT_EMPLOYEE_AFFILIATE_FACILITY;
        testContact.EMPLOYEE_EMPLOYMENT_STATUS__C = AP01_TestDataTokens.CONTACT_EMPLOYEE_EMPLOYMENT_STATUS;
        testContact.Employee_Work_Email__c = AP01_TestDataTokens.CONTACT_EMPLOYEE_WORK_EMAIL;
        testContact.MailingStreet =  AP01_TestDataTokens.CONTACT_MAILING_STREET;
        testContact.MailingCity =  AP01_TestDataTokens.CONTACT_MAILING_CITY;
        testContact.MailingState = AP01_TestDataTokens.CONTACT_MAILING_STATE;
        testContact.MailingPostalCode = AP01_TestDataTokens.CONTACT_MAILING_POSTAL_CODE;
        testContact.Member_HCC_ID__c = AP01_TestDataTokens.CONTACT_MEMBER_HCC_ID;
        testContact.MemberIdField__c = AP01_TestDataTokens.CONTACT_MEMBER_ID_FIELD;
        
        insert testContact;
        
        Guarantor__c testGaurantor = new Guarantor__c(name = AP01_TestDataTokens.TEST_GUARANTOR);
        
        insert testGaurantor;
        
        Patient__c testPatient = new Patient__c(name=AP01_TestDataTokens.TEST_PATIENT_NAME,Patient_DotOne__c = AP01_TestDataTokens.PATIENT_DOT_ONE);
        
        insert testPatient;
        
        Patient_Account__c testPatientAccount = new Patient_Account__c(name = AP01_TestDataTokens.TEST_PATIENT_ACCOUNT);
        
        insert testPatientAccount;
        
        for(Integer i = 0; i < numberOfCases; i++) {
            Case loopCase = new Case();
            loopCase.RecordTypeId = grievanceRecordType1;
            loopCase.Patient__c = testPatient.Id;
            loopCase.Patient_Account__c = testPatientAccount.Id;
            loopCase.Guarantor__c = testGaurantor.Id;
            loopCase.Origin = AP01_TestDataTokens.CASE_ORIGIN;
            loopCase.Contact_Region__c = AP01_TestDataTokens.CASE_CONTACT_REGION;
            
            
            if(math.mod(i+2, 2) == 0) {
                loopCase.Grievance_Web_Form_Member_ID__c = AP01_TestDataTokens.CASE_GRIEVANCE_WEB_FORM_MEMBER_ID1;
            } else {
                loopCase.Grievance_Web_Form_Member_ID__c = AP01_TestDataTokens.CASE_GRIEVANCE_WEB_FORM_MEMBER_ID2;
            }

            testGrievanceCases.add(loopCase);
        }
        
        /* insert testGrievanceCases;
        for(Integer i = 0; i < numberOfCases; i++) {
            Case loopCase = new Case();
            loopCase.RecordTypeId = grievanceRecordType1;
            testCases.add(loopCase);
        }
        
         upsert testCases; */
    }
    
     /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to to fetch the RecordType records where Name=Member and Object is 'Contact'
    * @param 
    * @return 
    */
    public static Id getMemRecordTypeId() {
        Id recordType = [select Id, SobjectType, Name from RecordType where name=:AP01_TestDataTokens.MEMBER and SObjectType=:AP01_TestDataTokens.CONTACT limit 1].Id;
        return recordType;
    }
     /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to to fetch the RecordType records where Name=Grievance Web Form Interaction Log and Object is 'Case'
    * @param 
    * @return 
    */
    public static Id getGrievanceRecordTypeId() {
        if(grievanceRecordType == null) {
            grievanceRecordType = [select Id, SobjectType, Name from RecordType where name=:AP01_TestDataTokens.GRIEVANCE_RECORD_TYPE and SObjectType=:AP01_TestDataTokens.S3_CASE limit 1].Id;
        }
        return grievanceRecordType;
    }
      /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to to fetch the Group records where Name=SHP Enrollment and Object is 'Queue'
    * @param 
    * @return 
    */
    public static Id getSHPGroup() {
        
        if(shpGroup == null) {
            shpGroup = [select Id, Name from Group where name=:AP01_TestDataTokens.GROUP_SHP_ENROLLMENT and Type=:AP01_TestDataTokens.QUEUE limit 1].Id;
        }
        return shpGroup;
    }
     /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to to fetch the Group records where Name=[Tier 1] HR Benefits and Object is 'Queue'
    * @param 
    * @return 
    */
    public static Id getS3Group() {
        
        if(s3Group == null) {
            s3Group = [select Id, Name from Group where name=:AP01_TestDataTokens.GROUP_TIER1_HR_BENEFITS and Type=:AP01_TestDataTokens.QUEUE limit 1].Id;
        }
        return s3Group;
    }
     /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to to fetch the Record Type where Name=CV - Address Change Request and Object is 'Case'
    * @param 
    * @return 
    */
    public static Id getCVRecordTypeId() {
        
        if(cvRecordType == null) {
            cvRecordType = [select Id, SobjectType, Name from RecordType where name=:AP01_TestDataTokens.RECORD_TYPE_CV_ADDRESS_CHANGE_REQUEST and SObjectType=:AP01_TestDataTokens.S3_CASE limit 1].Id;
        }
        return cvRecordType;
    }
   /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to to query the Portal User
    * for each SHP  Record Type
    * @param 
    * @return 
    */
    public static List<User> getUsers() {
    
        List<User> tempList = new List<User>();
        tempList = [select Id, Username, ContactId from User where Username =: AP01_TestDataTokens.PORTAL_USER_NAME];
        System.assert(tempList.size() == 1, 'Failed to query the Portal User');
        return tempList;
    } 
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to to set the Case owner
    * for each SHP  Record Type
    * @param 
    * @return 
    */
    public static void setSHPOwnerhipCase() {
        for(Case loopCase : testCases) {
            loopCase.OwnerId = getSHPGroup();
        }
    
    }
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to set the Case owner
    * for each S3 Record Type
    * @param 
    * @return 
    */
    public static void setS3OwnerhipCase() {
        for(Case loopCase : testCases) {
            loopCase.OwnerId = getS3Group();            
        }
    
    }

   /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to insert the Tasks List related to case.
    * for each S3 Record Type
    * @param 
    * @return 
    */
    public static void setTaskLookupCase() {
                
        for(Integer i = 0; i < testCases.size(); i++){
          
            Task loopTask = new Task();
            loopTask.WhatId = testCases[i].Id;
            testTasks.add(loopTask);
        }
      insert testTasks;
    }
    
       /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to Set the Case Status as Closed.
    * for each S3 Record Type
    * @param 
    * @return 
    */
    public static void setCasesToClosed() {
        
        for(Case loopCase : testCases) {
            loopCase.status = AP01_TestDataTokens.CASE_CLOSED_STATUS;
        }
           
    }
   
      /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method to set the  Case satus as new.
    * for each S3 Record Type
    * @param 
    * @return 
    */
    public static void setCasesUnclosedClosed() {
        
        for(Case loopCase : testCases) {
            loopCase.status = AP01_TestDataTokens.CASE_NEW_STATUS;
        }    
    }
    //
      /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method to set the  Deleted Tasks Status as Closed.
    * for each S3 Record Type
    * @param 
    * @return 
    */
    public static void setTasksToClosed() {
        set<Id> caseIds = new set<Id>();
        List<Task> deleteTasks = new List<Task>();
        
        for(Case loopCase : testCases) {  
            caseIds.add(loopCase.Id);
        }
        
        deleteTasks = [select Id, WhatId From Task Where WhatId IN :caseIds];
            
        for(Task loopTask : deleteTasks) {
            loopTask.status = AP01_TestDataTokens.CASE_CLOSED_STATUS;        
        }
        update deleteTasks;
    }
    // 
      /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method to set the Case status as Closed
    * for each S3 Record Type
    * @param 
    * @return 
    */
    public static List<Case> getGrievanceSrs() {
        
        for(Case loopCase : testCases) {
            loopCase.status = AP01_TestDataTokens.CASE_CLOSED_STATUS;
        }

        return testCases;
    
    }
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method to set the Case status as Closed and setting the Close Reason for it.
    * for each S3 Record Type
    * @param 
    * @return 
    */
    public static void setSRClosed() {
        set<Id> caseIds = new set<Id>();
        List<Case> closeCases = new List<Case>();
        
        for(Case loopCase : testCases) {
            caseIds.add(loopCase.Id);
        }
        
        closeCases = [select Id, ParentId From Case Where ParentId IN :caseIds];
            
        for(Case loopCase : closeCases) {
            loopCase.status = AP01_TestDataTokens.CASE_CLOSED_STATUS;    
            loopCase.Close_Reason__c = AP01_TestDataTokens.CASE_CLOSED_REASON;  
        }
        update closeCases;
    }
    
    ////
    
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method prepares the User where the Profile Name is 'SHP Agent' .
    * @param 
    * @return 
    */
    public static void prepareSHPUsers() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];  
        System.runAs (thisUser) {  
            portalRole = [Select Id From UserRole Where PortalType =: AP01_TestDataTokens.PORTAL_TYPE Limit 1];
            shpProfile = [Select Id from Profile where name =: AP01_TestDataTokens.SHP_PROFILE_NAME Limit 1];
    
                    
            shpAgent = new User(
                    ProfileId = shpProfile.Id,
                    Username = AP01_TestDataTokens.USER_NAME,
                    UserRoleId = portalRole.Id,
                    Alias = AP01_TestDataTokens.ALIAS,
                    Email=AP01_TestDataTokens.EMAIL,
                    EmailEncodingKey=AP01_TestDataTokens.EMAIL_ENCODING_KEYS,
                    Firstname=AP01_TestDataTokens.FIRST_NAME,
                    Lastname=AP01_TestDataTokens.LAST_NAME,
                    CommunityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME,
                    LanguageLocaleKey=AP01_TestDataTokens.LANGUAGE_LOCALE_KEY,
                    LocaleSidKey=AP01_TestDataTokens.LOCALE_SID_KEY,
                    TimeZoneSidKey=AP01_TestDataTokens.TIME_ZONES_ID_KEY
                );
           
            
            insert shpAgent;
            
        }
    }
       /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method prepares the Test Data.
    * @param 
    * @return 
    */
    private static void prepareSHPTestData(Integer numberOfCases) {
    
        testAccount.Name = AP01_TestDataTokens.CONTACT_ACCOUNT;
        insert testAccount;
        
        testContact.AccountId = testAccount.Id;
        testContact.RecordTypeId = getMemRecordTypeId();
        testContact.FirstName = AP01_TestDataTokens.CONTACT_FIRST_NAME;
        testContact.LastName = AP01_TestDataTokens.CONTACT_LAST_NAME;
        testContact.Phone = AP01_TestDataTokens.CONTACT_PHONE;
        testContact.BirthDate = date.parse(AP01_TestDataTokens.CONTACT_BIRTH_DATE);
        testContact.EMPLOYEE_UNION_AFFILIATE__C = AP01_TestDataTokens.CONTACT_EMPLOYEE_UNION_AFFILIATE;
        testContact.EMPLOYEE_AFFILIATE_FACILITY__C = AP01_TestDataTokens.CONTACT_EMPLOYEE_AFFILIATE_FACILITY;
        testContact.EMPLOYEE_EMPLOYMENT_STATUS__C = AP01_TestDataTokens.CONTACT_EMPLOYEE_EMPLOYMENT_STATUS;
        testContact.Employee_Work_Email__c = AP01_TestDataTokens.CONTACT_EMPLOYEE_WORK_EMAIL;
        testContact.MailingStreet = AP01_TestDataTokens.CONTACT_MAILING_STREET;
        testContact.MailingCity = AP01_TestDataTokens.CONTACT_MAILING_CITY;
        testContact.MailingState = AP01_TestDataTokens.CONTACT_MAILING_STATE;
        testContact.MailingPostalCode = AP01_TestDataTokens.CONTACT_MAILING_POSTAL_CODE;
        testContact.Member_HCC_ID__c = AP01_TestDataTokens.CONTACT_MEMBER_HCC_ID;
        testContact.MemberIdField__c = AP01_TestDataTokens.CONTACT_MEMBER_ID_FIELD;
        
        insert testContact;
        
        Guarantor__c testGaurantor = new Guarantor__c(name = AP01_TestDataTokens.TEST_GUARANTOR);
        
        insert testGaurantor;
        
        Patient__c testPatient = new Patient__c(name=AP01_TestDataTokens.TEST_PATIENT_NAME,Patient_DotOne__c = AP01_TestDataTokens.PATIENT_DOT_ONE);
        
        insert testPatient;
        
        Patient_Account__c testPatientAccount = new Patient_Account__c(name = AP01_TestDataTokens.TEST_PATIENT_ACCOUNT);
        
        insert testPatientAccount;
        
        CaseMilestone testCaseMilstone = new CaseMilestone();
               
        for(Integer i = 0; i < numberOfCases; i++) {
            Case loopCase = new Case();
            loopCase.RecordTypeId = getGrievanceRecordTypeId();
            loopCase.Patient__c = testPatient.Id;
            loopCase.Patient_Account__c = testPatientAccount.Id;
            loopCase.Guarantor__c = testGaurantor.Id;
            loopCase.Origin =AP01_TestDataTokens.CASE_ORIGIN;
            loopCase.Contact_Region__c = AP01_TestDataTokens.CASE_CONTACT_REGION;
            
            
            if(math.mod(i+2, 2) == 0) {
                loopCase.Grievance_Web_Form_Member_ID__c = AP01_TestDataTokens.CASE_GRIEVANCE_WEB_FORM_MEMBER_ID1;
            } else {
                loopCase.Grievance_Web_Form_Member_ID__c = AP01_TestDataTokens.CASE_GRIEVANCE_WEB_FORM_MEMBER_ID2;
            }

            testCases.add(loopCase);
        }
        
        insert testGrievanceCases;

        for(Integer i = 0; i < numberOfCases; i++) {
            Case loopCase = new Case();
            loopCase.RecordTypeId = getCVRecordTypeId();
            testCases.add(loopCase);
        }
        
        upsert testCases;
    }
       /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to to fetch the RecordType records where Name=Member and Object is 'Contact'
    * @param 
    * @return 
    */
    private static Id getSHPMemRecordTypeId() {
        Id recordType = [select Id, SobjectType, Name from RecordType where name=:AP01_TestDataTokens.MEMBER and SObjectType=:AP01_TestDataTokens.CONTACT limit 1].Id;
        return recordType;
    }
       /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to to fetch the RecordType records where Name=Grievance Web Form Interaction Log and Object is 'Case'
    * @param 
    * @return 
    */
    private static Id getSHPGrievanceRecordTypeId() {
        if(grievanceRecordType == null) {
            grievanceRecordType = [select Id, SobjectType, Name from RecordType where name=:AP01_TestDataTokens.GRIEVANCE_RECORD_TYPE and SObjectType=:AP01_TestDataTokens.S3_CASE limit 1].Id;
        }
        return grievanceRecordType;
    }
    
   
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to to fetch the RecordType records where Name=CV - Address Change Request and Object is 'Case'
    * @param 
    * @return 
    */
    private static Id getSHPCVRecordTypeId() {
        
        if(cvRecordType == null) {
            cvRecordType = [select Id, SobjectType, Name from RecordType where name=:AP01_TestDataTokens.RECORD_TYPE_CV_ADDRESS_CHANGE_REQUEST and SObjectType=:AP01_TestDataTokens.S3_CASE limit 1].Id;
        }
        return cvRecordType;
    }
   /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to to query the Portal User
    * for each SHP  Record Type
    * @param 
    * @return 
    */
    public static List<User> getSHPUsers() {
    
        List<User> tempList = new List<User>();
        tempList = [select Id, Username, ContactId from User where Username = : AP01_TestDataTokens.PORTAL_USER_NAME];
        System.assert(tempList.size() == 1, 'Failed to query the Portal User');
        return tempList;
    } 
    
   
     /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to insert the Tasks List related to case.
    * for each S3 Record Type
    * @param 
    * @return 
    */
    private static void setSHPTaskLookupCase() {
                
        for(Integer i = 0; i < testCases.size(); i++){
          
            Task loopTask = new Task();
            loopTask.WhatId = testCases[i].Id;
            testTasks.add(loopTask);
        }
      insert testTasks;
    }
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This Method to Set the Case Status as Closed.
    * for each S3 Record Type
    * @param 
    * @return 
    */
    private static void setSHPCasesToClosed() {
        
        for(Case loopCase : testCases) {
            loopCase.status = AP01_TestDataTokens.CASE_CLOSED_STATUS;
        }    
    }
     /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method to set the  Case satus as new.
    * for each S3 Record Type
    * @param 
    * @return 
    */
    private static void setSHPCasesUnclosedClosed() {
        
        for(Case loopCase : testCases) {
            loopCase.status = AP01_TestDataTokens.CASE_NEW_STATUS;
        }    
    }
      /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method to set the  Deleted Tasks Status as Closed.
    * for each S3 Record Type
    * @param 
    * @return 
    */
    private static void setSHPTasksToClosed() {
        set<Id> caseIds = new set<Id>();
        List<Task> deleteTasks = new List<Task>();
        
        for(Case loopCase : testCases) {  
            caseIds.add(loopCase.Id);
        }
        
        deleteTasks = [select Id, WhatId From Task Where WhatId IN :caseIds];
            
        for(Task loopTask : deleteTasks) {
            loopTask.status = AP01_TestDataTokens.CASE_CLOSED_STATUS;        
        }
        update deleteTasks;
    }
      /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method to set the Case status as Closed
    * for each S3 Record Type
    * @param 
    * @return 
    */
    private static List<Case> getSHPGrievanceSrs() {
        
        for(Case loopCase : testCases) {
            loopCase.status = AP01_TestDataTokens.CASE_CLOSED_STATUS;
        }

        return testCases;
    
    }
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method to set the Case status as Closed and setting the Close Reason for it.
    * for each S3 Record Type
    * @param 
    * @return 
    */
    private static void setSHPSRClosed() {
        set<Id> caseIds = new set<Id>();
        List<Case> closeCases = new List<Case>();
        
        for(Case loopCase : testCases) {
            caseIds.add(loopCase.Id);
        }
        
        closeCases = [select Id, ParentId From Case Where ParentId IN :caseIds];
            
        for(Case loopCase : closeCases) {
            loopCase.status = AP01_TestDataTokens.CASE_CLOSED_STATUS;    
            loopCase.Close_Reason__c = AP01_TestDataTokens.CASE_CLOSED_REASON;    
        }
        update closeCases;
    }

    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description return testCases created
    * @param 
    * @return 
    */
    public static List<Case> returnTestCases() {
        
        return testCases;
    }
    
    /**
    * @author Atul Gupta
    * @date 02/21/2014
    * @description This method will return the Employee Inquiry RecordType of Case Object
    * @param 
    * @return 
    */
    private static Id getEmployeeInquiryRecordTypeId() {
        
        if(emplInquiryRecordType == null) {
            emplInquiryRecordType = [select Id, SobjectType, Name from RecordType where name=:AP01_TestDataTokens.EMP_INQUIRY_RT_NAME and SObjectType=:AP01_TestDataTokens.S3_CASE limit 1].Id;
        }
        return emplInquiryRecordType;
    }
    
    /**
    * @author Atul Gupta
    * @date 03/18/2013
    * @description This Method to to fetch the RecordType records where Name=Grievance and Object is 'Case'
    * @param 
    * @return 
    */
    public static Id getGrievanceSRRecordTypeId() {
        if(grievanceSRRecordType == null) {
            grievanceSRRecordType = [select Id, SobjectType, Name from RecordType where name=:AP01_TestDataTokens.GRIEVANCE_SR_RECORDTYPE and SObjectType=:AP01_TestDataTokens.S3_CASE limit 1].Id;
        }
        return grievanceSRRecordType;
    }
    
    /**
    * @author Atul Gupta
    * @date 01/18/2013
    * @description This method prepares the User where the Profile Name is 'SHP Agent'
    * @param 
    * @return 
    */
    public static User createSHPUser() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];  
        System.runAs (thisUser) {  
            portalRole = [Select Id From UserRole Where PortalType =: AP01_TestDataTokens.PORTAL_TYPE Limit 1];
            shpProfile = [Select Id from Profile where name =: AP01_TestDataTokens.SHP_PROFILE_NAME Limit 1];
    
                    
            shpAgent = new User(
                    ProfileId = shpProfile.Id,
                    Username = AP01_TestDataTokens.USER_NAME,
                    UserRoleId = portalRole.Id,
                    Alias = AP01_TestDataTokens.ALIAS,
                    Email=AP01_TestDataTokens.EMAIL,
                    EmailEncodingKey=AP01_TestDataTokens.EMAIL_ENCODING_KEYS,
                    Firstname=AP01_TestDataTokens.FIRST_NAME,
                    Lastname=AP01_TestDataTokens.LAST_NAME,
                    CommunityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME,
                    LanguageLocaleKey=AP01_TestDataTokens.LANGUAGE_LOCALE_KEY,
                    LocaleSidKey=AP01_TestDataTokens.LOCALE_SID_KEY,
                    TimeZoneSidKey=AP01_TestDataTokens.TIME_ZONES_ID_KEY
                );
           
            
            insert shpAgent;
            
        }
        return shpAgent;
    }
    
    /**
    * @author Atul Gupta
    * @date 03/18/2014
    * @description This method will create and return a SHP Interaction Log
    * @param 
    * @return 
    */
    public static Case createShpInteractionLog()
    {
        Account acc = createAccount();
        Contact cont = createContact(acc);
        
        Case intLog = new Case();
        Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: label.CL13_SHPInteractionLog].id;
        intLog.recordtypeId = rtId;
        intLog.contactId = cont.id;
        intLog.CALLID__c = '123456789';
        intLog.DNISTYPECODE__c = 'SHPP';
        intLog.subject = 'test';
        insert intLog;
        
        return intLog;
    }
    
    /**
    * @author Atul Gupta
    * @date 03/18/2014
    * @description This method will return a list of Non Expedited Cases
    * @param 
    * @return 
    */
    public static List<Case> createNonExpeditedCases(Integer noOfCases, Id parentId)
    {
        List<Case> nonExpCaseList = new List<Case>();
        Id grievanceRT = getGrievanceSRRecordTypeId();
        
        for(integer i=0; i<noOfCases; i++)
        {
            Case grievanceSR = new Case();
            grievanceSR.RecordTypeId = grievanceRT;
            grievanceSR.Date_of_Incident__c = system.today();
            grievanceSR.Date_Grievance_Requested__c = system.now();
            grievanceSR.Origin = AP01_TestDataTokens.ORIGIN;
            grievanceSR.Reason__c = AP01_TestDataTokens.CASE_REASON;
            grievanceSR.Secondary_Reason__c = AP01_TestDataTokens.CASE_SECONDARY_REASON_NON_EXP;
            grievanceSR.Status = AP01_TestDataTokens.CASE_NEW_STATUS;
            grievanceSR.Grievance_Issue_Description__c = AP01_TestDataTokens.ISSUE_DESCRIPTION;
            grievanceSR.ParentId = parentId;
            
            nonExpCaseList.add(grievanceSR);
        }
        insert nonExpCaseList;
        return nonExpCaseList;
    }
    
    /**
    * @author Atul Gupta
    * @date 03/18/2014
    * @description This method will return a list of Expedited Cases
    * @param 
    * @return 
    */
    public static List<Case> createExpeditedCases(Integer noOfCases, Id parentId)
    {
        List<Case> expCaseList = new List<Case>();
        Id grievanceRT = getGrievanceSRRecordTypeId();
        
        for(integer i=0; i<noOfCases; i++)
        {
            Case grievanceSR = new Case();
            grievanceSR.RecordTypeId = grievanceRT;
            grievanceSR.Date_of_Incident__c = system.today();
            grievanceSR.Date_Grievance_Requested__c = system.now();
            grievanceSR.Origin = AP01_TestDataTokens.ORIGIN;
            grievanceSR.Reason__c = AP01_TestDataTokens.CASE_REASON;
            grievanceSR.Secondary_Reason__c = AP01_TestDataTokens.CASE_SECONDARY_REASON_EXP;
            grievanceSR.Status = AP01_TestDataTokens.CASE_NEW_STATUS;
            grievanceSR.Grievance_Issue_Description__c = AP01_TestDataTokens.ISSUE_DESCRIPTION;
            grievanceSR.ParentId = parentId;
            
            expCaseList.add(grievanceSR);
        }
        insert expCaseList;
        return expCaseList;
    }
    
    /**
    * @author       :   Shakti Mehtani
    * @date         :   10/11/2014
    * @description  :   Checks if the E-Mail is valid
    * @param 
    * @return 
    */
    public static boolean isEmailValid(String p_email) {
        if(!Pattern.matches('[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,}', p_email))    return false;
        else return true;
    }
    
    public static Contact_Validation_Audit_Trail__c getValidationAudit(Case objCase){
        
    Contact_Validation_Audit_Trail__c objAudit = new Contact_Validation_Audit_Trail__c();
        objAudit .Case__c=objCase.id;
        insert objAudit;
         return objAudit;
        
        
        
    }
    @future
    public static void createGroupMembers(String tempObjUser) {
        
         // start new context via system.runAs() for the same user for test code only
         
          Group g1 = [SELECT DeveloperName,Email,Id,Name,OwnerId,RelatedId,Type FROM Group WHERE DeveloperName = 'SHP_Sales_Queue'];
         
        
          //QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');    
          //insert q1;
          GroupMember GM = new GroupMember(GroupId = g1.id, UserOrGroupId = tempObjUser);
          insert GM;
                     
          
    }
    
    public static PDV_EAF_Validation_Audit_Trail__c getValidationAuditEAF(Case objCase){
        
    PDV_EAF_Validation_Audit_Trail__c objAuditEAF = new PDV_EAF_Validation_Audit_Trail__c();
        objAuditEAF.Case__c=objCase.id;
        insert objAuditEAF;
         return objAuditEAF;
        
        
        
    }
    
  /**
    * @author Abhishek gupta
    * @date 11/03/2015
    * @description This method create test Correspondence data for Member correspondence custom console.
    * @param contact
    * @return  List
    */
    
     public static List<Correspondence_Letter__c> correspondenceMember(contact con ){
       List<Correspondence_Letter__c> corrMemberLst = new List<Correspondence_Letter__c>();
            for(integer i=0; i<100;i++){ 
                Correspondence_Letter__c corrMember = new  Correspondence_Letter__c ();
               corrMember.SHP_Member_Id__c = con.id;
               corrMember.SHP_OnBaseID__c = '123' + i ; 
               corrMember.SHP_Correspondence_Entity_Recipient_HCC__c= '123';
               corrMember.SHP_Is_Logical_Delete__C = false;
               corrMember.SHP_IsReplacement__C = false;



               corrMemberLst.add(corrMember);
            }
        insert corrMemberLst;
        
        return corrMemberLst;
    }
    
    /**
    * @author IDC team
    * @date 07/8/2015
    * @description This method creates validated provider contacts
    * @param 
    * @return 
    */
    public static Contact create_Validated_Provider_Contact(){
        
        Contact con = new Contact();
            con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
            con.Firstname = 'TestP';
            con.LastName = 'LastNameP';
            con.Provider_NPI__c = '1234';
            con.Provider_ID__c = '098765';
            con.Provider_Active_Status__c = true;
            con.Provider_Active_Status_Date__c = system.today();
            con.Provider_Practicing_Physician__c = true;
            con.Email = 'testcontact@email.com';
            con.Provider_Type__c = 'External';
            con.Provider_Portal_Last_Validation_Date__c = system.today();
            con.Provider_Admin_Assistant__c = 'test User';
            con.Preferred_Communication_Method__c = 'In Basket';
            con.Provider_Communication_Preferences_HIM__c = 'InBasket-Letter';
            con.Provider_Correspondence_City__c = 'testcity';
            con.Provider_Correspondence_State__c = 'CA';
            con.Provider_Correspondence_PostalCode__c = '56789';
            con.Provider_Correspondence_Phone__c = '3456789123';
            con.Provider_Correspondence_Fax_Number__c = '3456789123';
            
        return con;
    }
    
    public static CS_ManageProfile__c createManageProfileCustSetting(){
        CS_ManageProfile__c csprofile = new CS_ManageProfile__c();
        csprofile.Name = 'Communities_Provider';
        csprofile.Profile_Name__c = 'PDV Community Provider';
        insert csprofile;
        
        return csprofile;
    }
    
    public static PDIPortalHomePage__c createPDIPortalHomePageCustSetting(){
        PDIPortalHomePage__c portalHomePage = new PDIPortalHomePage__c();
        portalHomePage.Name = '1.Sutter Network of Care';
        portalHomePage.DataValue1__c = 'testdata1';
        portalHomePage.DataValue2__c = 'testdata2';
        portalHomePage.Icon__c = 'fa fa-plus';
        insert portalHomePage;
        
    return portalHomePage;
    }
        
}