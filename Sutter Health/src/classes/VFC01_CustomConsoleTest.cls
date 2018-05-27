/**  
    *     Class Name  : VFC01_CustomConsoleTest
    *     Date        : 27-Sept-2013
    *     Project Name: CRM - SFT - Sutter Health
    *     Description : Test Class for VFC01_CustomConsole Class. This class tests for different scenarios that are handled in the code
    **/
    @isTest
    private class VFC01_CustomConsoleTest{

    private static final String PAGEREFERENCE_SAVEANDNEW = '/apex/VFP01_CustomConsole?CALLID=123567789&DEV=1234&DNISTC=EMPL&CALLDT=20141211051806&TRANF=NO';
    private static final String PAGEREFERENCE_SAVEANDNEW_CALLDT_NEG = '/apex/VFP01_CustomConsole?CALLID=123567789&DEV=1234&DNISTC=EMPL&CALLDT=201412110518&TRANF=NO';
    private static final String REQUESTOR_NAME = 'Test Requestor Name';
    private static final String REQUESTOR_TYPE = 'Broker';
    private static final String REQUESTOR_NUMBER = '123456';
    private static final String REQUESTOR_EMAIL = 'test@sutteremail.com';
    private static final String CALL_BACK = '9876543219';
    private static final String SHP_PROFILE_NAME = 'SHP Agent';
    private static final String SHP_ROLE_NAME = 'SHP Agent';
    private static final String CONT_RT_MEMBER = 'Member';
    private static final string CONTACT_RT_SHP_PROVIDER = 'SHP Provider';
    private static final string REASON_CLINICAL = 'Clinical';
    private static final string OOA_MEDICAL = 'Out of Area – Medical';
    private static final string VFC_URL_STR1 = '/apex/VFP01_CustomConsole?CALLID=';
    private static final string VFC_URL_STR2 = '&DEV=87667676&DNISTC=SHPM&CALLDT=&TRANF=NO';
    private static final string MEMBER_ID = '12345678';
    private static final string NAME_STR = 'Test';
    private static final string MEMBER_CONTACT_NUM = '616-643-7555';
    private static final string PROVIDER_NPI = '111123';
    private static final string CONTACT_RT_MEMBER = 'Member';


   /**
    * @author IDC Team
    * @date 28/09/2015
    * @description: method to create custom settings,Account,Contact,Article,Guarantor and Patient test data that using in all test Methods. 
    * @param 
    * @return void
    */
     @testSetup 
     static void createTestData() {
        
        //@description This method create test data for Customer Interaction-Field Set custom setting.
        list<Customer_Interaction_Field_Set__c> lstCustInterFieldset  = AP01_TestDataUtility.createPATINQCustomerInteractionFieldSet();
        insert lstCustInterFieldset;
        
        //@description This method create test data for Contact Field custom setting.
        list<Contact_Fields__c> lstContactFields  = AP01_TestDataUtility.createContactFieldSet();
        insert lstContactFields;
        
        //@description This method create test data for Profile Based Search custom setting.
        list<Profile_Based_Search__c> lstProfileBasedSearch  = AP01_TestDataUtility.createProfileSearchBasedSet();
        insert lstProfileBasedSearch;
        
        //Create Account
        Account acc = AP01_TestDataUtility.createAccount();
        
        //Assert to validate ACCOUNT has created successfully..
        system.assert(acc.id != null);
        
        //Create Contact
        Contact cont = AP01_TestDataUtility.createContact(acc);
        
        //Assert to validate Contact has created successfully..
        system.assert(cont.id != null);
        
        //Create list of Contacts
        List<Contact> conList = AP01_TestDataUtility.createContactList(acc);
        
        //Assert to validate Contact list has created successfully..
        system.assert(conList[0].id != null);
        
        //Create FAQ__kav
        AP01_TestDataUtility.CreateFAQ_kav();
        
        //Create Guarantor 
        Guarantor__c guarantor1 = AP01_TestDataUtility.createGuarantor();
        
        
        //Assert to validate guarantor1 has created successfully..
        system.assert(guarantor1.id != null);
        
        //Create Patient
        Patient__c patient = AP01_TestDataUtility.createPatient();
        
        //Assert to validate Patient__c has created successfully..
        system.assert(patient.id != null);
     }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description: method to create test data for SHP User.
    * @param 
    * @return user
    */
    public static User createSHP_OOA_OON_User(){
    
        Id profileID = [Select Id from Profile where Name =:SHP_PROFILE_NAME].Id;
        Id roleId = [SELECT Id FROM UserRole where Name =: SHP_ROLE_NAME].Id;
        User usr = new User();
        usr.LastName = AP01_TestDataTokens.USER_LAST_NAME;
        usr.Username = AP01_TestDataTokens.USER_NAME;
        usr.Email = AP01_TestDataTokens.USER_EMAIL;
        usr.Alias = AP01_TestDataTokens.ALIAS;
        usr.CommunityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME ;
        usr.TimeZoneSidKey = AP01_TestDataTokens.TIME_ZONES_ID_KEY;
        usr.LocaleSidKey = AP01_TestDataTokens.LOCALE_SID_KEY;
        usr.EmailEncodingKey = AP01_TestDataTokens.EMAIL_ENCODING_KEYS;
        usr.LanguageLocaleKey = AP01_TestDataTokens.LANGUAGE_LOCALE_KEY;
        usr.profileid = profileID;
        usr.UserRoleId = roleId;
        usr.isActive = true;
        
        Database.insert(usr);
        
        //Assert to validate User has created successfully..
        system.assert(usr.id != null);
        
        return usr;
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description: method to create test data for Adhoc Issue.
    * @param 
    * @return user
    */
    public static Adhoc_Issue__c createAdocIssue(){
        Adhoc_Issue__c objAdhocIssue = new Adhoc_Issue__c(Name = 'Test AdhocIssue',Status__c = 'Active');
        Database.insert(objAdhocIssue);
        
        //Assert to validate Adhoc_Issue__c has created successfully..
        system.assert(objAdhocIssue.id != null);
        
        return objAdhocIssue;
    }
    /**
    * @author IDC Team
    * @date 09/12/2014
    * @description: method to validate Employee Search for Save and New functionality.
    * @param 
    * @return void
    */
    static testMethod void testConsoleSearchforEmployee_SaveandNew() {
        
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        Patient__c patient = [select id,Name from Patient__c where Name =: AP01_TestDataTokens.PATIENT_NAME];
        Guarantor__c guarantor = [select id from Guarantor__c where name =: AP01_TestDataTokens.GURANTOR_NAME];
        
        PageReference consolePage1 = new PageReference(PAGEREFERENCE_SAVEANDNEW);
        Test.setCurrentPage(consolePage1);
        
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        String searches = 'Employee';
        consoleController.ProfileName = 'SHP MEP';
        consoleController.fieldLabels = 'Test FieldLabels';
        Test.startTest();
        consoleController.getCustomerInteraction();
        consoleController.contactVerification();
        
        consoleController.custInteraction.Requestor_Name__c = REQUESTOR_NAME;
        consoleController.custInteraction.Requestor_Type__c = REQUESTOR_TYPE;
        consoleController.custInteraction.Requestor_Number__c = REQUESTOR_NUMBER;
        consoleController.custInteraction.Requestor_Email__c = REQUESTOR_EMAIL;
        consoleController.custInteraction.Preferred_Callback_Number__c = CALL_BACK;
        consoleController.custInteraction.Patient__c = patient.id;
        consoleController.custInteraction.Guarantor__c = guarantor.id;
        
        system.assertEquals(consoleController.showDetailCase, false);
        
        consoleController.saveAndNew();
        
        system.assertEquals(consoleController.showDetailCase, true);
        
        system.assertEquals(consoleController.caseNew <> null, true);
        system.assertEquals(consoleController.caseNew.DEV__c , '1234'); 
        
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=1234567898765&TRANF=NO');
        Test.setCurrentPage(consolePage2);
        
        Test.stopTest();
        
    }
    
    /**
    * @author IDC Team
    * @date 09/12/2014
    * @description: method to validate Employee Search for Save and catch exception in saveAndNew method.
    * @param 
    * @return void
    */
    
    static testMethod void testConsoleSearchforEmployee_SaveandNew_CatchException() {
        VFC01_CustomConsole consoleController1 = new VFC01_CustomConsole();
        consoleController1.saveAndNew();
        
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        Patient__c patient = [select id,Name from Patient__c where Name =: AP01_TestDataTokens.PATIENT_NAME];
        Guarantor__c guarantor = [select id from Guarantor__c where name =: AP01_TestDataTokens.GURANTOR_NAME];
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=1234567898765&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        String searches = 'Employee';
        consoleController.ProfileName = 'SHP MEP';
        consoleController.fieldLabels = 'Test FieldLabels';
        Test.startTest();
        consoleController.getCustomerInteraction();
        consoleController.contactVerification();
        
        consoleController.custInteraction.Requestor_Name__c = REQUESTOR_NAME;
        consoleController.custInteraction.Requestor_Type__c = REQUESTOR_TYPE;
        consoleController.custInteraction.Requestor_Number__c = REQUESTOR_NUMBER;
        consoleController.custInteraction.Requestor_Email__c = REQUESTOR_EMAIL;
        consoleController.custInteraction.Preferred_Callback_Number__c = CALL_BACK;
        consoleController.custInteraction.Patient__c = patient.id;
        consoleController.custInteraction.Guarantor__c = guarantor.id;
        consoleController.adhocType = 'test Adhoctype';
        consoleController.custInteraction.Subject = 'test Subject';
        
        system.assertEquals(consoleController.showDetailCase, false);
        
        consoleController.saveAndNew();
        
        //system.assertEquals(consoleController.showDetailCase, true);
        
        system.assertEquals(consoleController.caseNew <> null, true);
        system.assertEquals(consoleController.caseNew.DEV__c , '1234'); 
        Test.stopTest();
        
    }
    
    /**
    * @author IDC Team
    * @date 09/12/2014
    * @description: method to validate contactVerification and contactVerificationForUnverified methods functionality for various scenarios.
    * @param 
    * @return void
    */
    static testMethod void testcontactVerification(){
        Patient__c patient = [select id,Name from Patient__c where Name =: AP01_TestDataTokens.PATIENT_NAME];
        Guarantor__c guarantor = [select id from Guarantor__c where name =: AP01_TestDataTokens.GURANTOR_NAME];
        Patient_Account__c patAccount1 = AP01_TestDataUtility.createPatientAccount(guarantor, patient);
        
        Case cust = new Case();
        Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: system.label.CL12_S3PatientInteractionLog].id;
        //@description This method create test data for Adhoc Issue.
        Adhoc_Issue__c objAdhocIssue = createAdocIssue();
        cust.Adhoc_Issue__c = objAdhocIssue.id;
        cust.recordtypeId = rtId;
        cust.Patient__c = patient.id;
        cust.CALLID__c = '123456789';
        cust.DNISTYPECODE__c = 'PatInq';
        cust.subject = 'test';
        cust.Customer_Intent__c = 'Adhoc Issue';
        insert cust;
        //Assert to check case is created successfully
        system.assert(cust.id != null);
        
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage2);
        VFC01_CustomConsole consoleController2 = new VFC01_CustomConsole();
        consoleController2.ProfileName = 'SHP MEP';
        Test.startTest();
        consoleController2.contactVerification();
        consoleController2.patAcc = 'testpatAcc';
        consoleController2.contactVerificationForUnverified();
        consoleController2.patAcc = '';
        consoleController2.contactVerificationForUnverified();
        consoleController2.linkId = '';
        consoleController2.contactVerificationForUnverified();
        Test.stopTest();
        
    }

    /**
    * @author IDC Team
    * @date 02/01/2014
    * @description This method tests for Edit button method
    * @param 
    * @return void
    */
    @isTest static void testConsoleIL_DNISTCMember() {
        
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        
        Case cust = new Case();
        Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: system.label.CL13_SHPInteractionLog].id;
        //@description This method create test data for Adhoc Issue.
        Adhoc_Issue__c objAdhocIssue = createAdocIssue();
        cust.Adhoc_Issue__c = objAdhocIssue.id;
        cust.recordtypeId = rtId;
        cust.contactId = cont.id;
        cust.CALLID__c = '123456789';
        cust.DNISTYPECODE__c = 'SHPP';
        cust.subject = 'test';
        cust.Customer_Intent__c = 'Adhoc Issue';
        insert cust;
        
        Test.StartTest();
        PageReference consolePage = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPP&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage);
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        consoleController.EditButton();
        
        system.assertEquals(consoleController.showEditCase, true);
        Test.StopTest();
    }
    
   /**
    * @author IDC Team
    * @date 29/09/2013
    * @description: method to validate for Supplier and Broker Search for single search result functinality.
    * @param 
    * @return void
    */
    static testMethod void testConsoleSupplierSearchforSingle() {
        
        Test.StartTest();
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPP&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        //@description This method tests for Supplier Search for single search result
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        RecordType recType = [select Id from RecordType where Name = 'SHP Provider' and sObjectType = 'Contact'];
        
        cont.RecordTypeId = recType.id;
        update cont;
        VFC01_CustomConsole consoleController2 = new VFC01_CustomConsole();
        consoleController2.supplierName = 'Test';
        consoleController2.supplierTIN = '7676';
        consoleController2.supplierNPI = '4343';
        consoleController2.SearchSupplier();
        system.assertEquals(consoleController2.supplierResults.size(), 1);
        
        //@description This method tests for Broker Search for multiple search result
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPB&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage2);
        
        List<Contact> contList = [select id,RecordTypeId from contact limit 3];
        
        RecordType recType1 = [select Id from RecordType where Name = 'SHP Sales Broker Contact Read Only' and sObjectType = 'Contact'];
        
        List<Contact> conListToUpdate = new List<Contact>();
        for(Contact con : contList){
            con.RecordTypeId = recType1.id;
            conListToUpdate.add(con);
        }
        update conListToUpdate;
        
        VFC01_CustomConsole consoleController1 = new VFC01_CustomConsole();
        
        consoleController1.brokerAgentFirstName = 'Test';
        consoleController1.brokerAgentLastName = 'Test';
        consoleController1.brokerFirmName = 'TEST ACCOUNT';
        consoleController1.brokerID = '545412';
        consoleController1.brokerFirmTelephoneNumber = '616-643-7666';
        consoleController1.SearchBroker();
        
        system.assertEquals(consoleController1.brokerResults.size(), 0);  
        Test.StopTest();  
    }
    
    /**
    * @author IDC Team
    * @date 29/09/2013
    * @description: method to validate Employer,Provider Search for multiple search result functinality.
    * @param 
    * @return void
    */
    static testMethod void testConsoleEmployerSearchforList() {
        
        Test.StartTest();
        PageReference consolePage3 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPE&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage3);
        List<Contact> contList1 = [select id,RecordTypeId from contact limit 3];
        RecordType recType2 = [select Id from RecordType where Name = 'SHP Sales Employer Contact Read Only' and sObjectType = 'Contact'];
        
        List<Contact> conListToUpdate1 = new List<Contact>();
        for(Contact con : contList1){
            con.RecordTypeId = recType2.id;
            conListToUpdate1.add(con);
        }
        update conListToUpdate1;
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        consoleController.employerContactFirstName = 'Test';
        consoleController.employerContactLastName = 'Test';
        consoleController.employerName = 'Test Account';
        consoleController.employerTaxID = '0001';
        consoleController.SearchEmployer();
        
        system.assertEquals(consoleController.employerResults.size(), 3);
        
        //@description This method tests for Provider Search for multiple search result
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPP&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        Account acc1 = AP01_TestDataUtility.createAccount();
        List<Contact> contList2 = [select id,RecordTypeId from contact limit 3];
        RecordType recType = [select Id from RecordType where Name = 'Provider' and sObjectType = 'Contact'];
        
        List<Contact> conListToUpdate = new List<Contact>();
        for(Contact con : contList2){
            con.RecordTypeId = recType.id;
            conListToUpdate.add(con);
        }
        update conListToUpdate;
        
        VFC01_CustomConsole consoleController1 = new VFC01_CustomConsole();
        
        consoleController1.providerFirstName = 'Test';
        consoleController1.providerLastName = 'Test';
        consoleController1.providerNPI = '111123';
        consoleController1.getMemberDOB();
        consoleController1.SearchProvider();
        
        system.assertEquals(consoleController1.providerResults.size(), 3);
        Test.StopTest();
    }
    
    /**
    * @author IDC Team
    * @date 29/09/2013
    * @description This method tests for Vendor and Patient Search for multiple search result
    * @param 
    * @return void
    */
    static testMethod void testConsoleVendorSearchforList() {
        
        Test.StartTest();
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=VEND&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        Account acc1 = AP01_TestDataUtility.createAccount();
        List<Contact> contList = [select id,RecordTypeId from contact limit 3];
        RecordType recType = [select Id from RecordType where Name = 'Vendor' and sObjectType = 'Contact'];
        
        List<Contact> conListToUpdate = new List<Contact>();
        for(Contact con : contList){
            con.RecordTypeId = recType.id;
            conListToUpdate.add(con);
        }
        update conListToUpdate;
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        consoleController.vendorID = '3131';
        consoleController.vendorName = 'Test';
        consoleController.vendorTaxID = '090912';
        consoleController.SearchVendor();
        
        system.assertEquals(consoleController.vendorResults.size(), 3);
        
        //@description This method tests for Patient Search for multiple search result
        
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage2);
        
        List<Patient__c>  patientList = AP01_TestDataUtility.createPatientList();
        
        VFC01_CustomConsole consoleController1 = new VFC01_CustomConsole();
        
        consoleController1.patientFirstName = 'Test_Patient_FirstName';
        consoleController1.patientLastName = 'Test_Patient_LastName';
        consoleController1.patientMRN = '123';
        consoleController1.SearchPatient();
        
        system.assertEquals(consoleController1.patientResults.size(), 4);
        Test.StopTest();
    }
    
    /**
    * @author IDC Team
    * @date 29/09/2013
    * @description:Method to validate Patient Account,Guarantor Search for multiple search result functinality.
    * @param 
    * @return void
    */
    static testMethod void testConsolePatientAccountSearchforList() {
        
        Test.StartTest();
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        Patient__c patient = [select id,Name from Patient__c where Name =: AP01_TestDataTokens.PATIENT_NAME];
        Guarantor__c guarantor = [select id from Guarantor__c where name =: AP01_TestDataTokens.GURANTOR_NAME];
        List<Patient_Account__c> patientAccList = AP01_TestDataUtility.createPatientAccountList(guarantor, patient);
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        consoleController.patientAccountNumber = '1234';
        consoleController.patientMRN = '123';
        consoleController.SearchPatientAccount();
        
        system.assertEquals(consoleController.patientAccountResults.size(), 3);
        
        //@description This method tests for Guarantor Search for multiple search result
        
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage2);
        
        List<Guarantor__c> guarantorList = AP01_TestDataUtility.createGuarantorList();
        
        VFC01_CustomConsole consoleController1 = new VFC01_CustomConsole();
        
        consoleController1.guarantorName = 'Guarantor';
        consoleController1.SearchGuarantor();
        
        //system.assertEquals(consoleController1.guarantorResults.size(), 3);
        Test.StopTest();
    }
    /**
    * @author IDC Team
    * @date 29/07/2015
    * @description This test method creates a OOA/OON SR with Member and tests the logic accordingly
    * @param N/A
    * @return void
    */
    static testMethod void createOOA_OON_SR_withMember_Test() {
        
        User ooa_oonUser = createSHP_OOA_OON_User();
        
        String callIDStr = String.valueOf(system.now());
        
        System.runAs(ooa_oonUser){
            
            PageReference consolePage = new PageReference(VFC_URL_STR1 + callIDStr + VFC_URL_STR2);
            Test.setCurrentPage(consolePage);
            
            Account acc1 = AP01_TestDataUtility.createAccount();
            //Assert to check Account is created successfully
            system.assert(acc1.id != null);
            Contact cont = AP01_TestDataUtility.createContact(acc1);
            //Assert to check Account is created successfully
            system.assert(cont.id != null);
            
            cont.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONT_RT_MEMBER).RecordTypeId;
            update cont;
            
            VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
            
            consoleController.memberID = MEMBER_ID;
            consoleController.memberFirstName = NAME_STR;
            consoleController.memberLastName = NAME_STR;
            consoleController.memberContactNumber = MEMBER_CONTACT_NUM;
            consoleController.memberDOB.SearchDate__c = system.today();
            consoleController.SearchMember();
            
            consoleController.memberDOB.SearchDate__c = Null;
            consoleController.SearchMember();
            Test.startTest();                
            consoleController.contactVerification();
            
            //consoleController.custInteraction.Reason__c = REASON_CLINICAL;
            //consoleController.custInteraction.Secondary_Reason__c = OOA_MEDICAL;
            consoleController.custInteraction.Reason__c = 'Member Grievance'; 
            consoleController.custInteraction.Secondary_Reason__c = 'Exempt';
            
            try{
            consoleController.saveSHP();
            }
            catch(exception ex){}
            Test.stopTest();
        }
        
    }
    /**
    * @author IDC Team
    * @date 29/07/2015
    * @description This test method creates a OOA/OON SR with Provider and tests the logic accordingly
    * @param N/A
    * @return void
    */
    static testMethod void createOOA_OON_SR_withProvider_Test() {
        
        User ooa_oonUser = createSHP_OOA_OON_User();
        
        String callIDStr = String.valueOf(system.now());
        
        System.runAs(ooa_oonUser){
            
            PageReference consolePage = new PageReference(VFC_URL_STR1 + callIDStr + VFC_URL_STR2);
            Test.setCurrentPage(consolePage);
            
            Account acc1 = AP01_TestDataUtility.createAccount();
            //Assert to check Account is created successfully
            system.assert(acc1.id != null);
            
            Contact cont = AP01_TestDataUtility.createContact(acc1);
            //Assert to check Account is created successfully
            system.assert(cont.id != null);
            
            cont.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT_SHP_PROVIDER).RecordTypeId;
            update cont;
            
            VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
            
            consoleController.providerFirstName = NAME_STR;
            consoleController.providerLastName = NAME_STR;
            consoleController.providerNPI = PROVIDER_NPI;
            consoleController.SearchProvider();
                            
            consoleController.contactVerification();
            
            consoleController.custInteraction.Reason__c = REASON_CLINICAL;
            //consoleController.custInteraction.Secondary_Reason__c = OOA_MEDICAL;
            consoleController.custInteraction.Secondary_Reason__c = 'ED Notification';
            consoleController.custInteraction.ContactId = cont.id;
            Test.startTest();
            //consoleController.saveSHP();
            Test.stopTest();
        }
        
    }
    
    /**
    * @author IDC Team
    * @date 29/07/2015
    * @description This test method creates a OOA/OON SR with Provider and tests the logic accordingly
    * @param N/A
    * @return void
    */
    static testMethod void create_OOA_OON_SR_withProvider_Test() {
        
        User ooa_oonUser = createSHP_OOA_OON_User();
        
        String callIDStr = String.valueOf(system.now());
        
        System.runAs(ooa_oonUser){
            
            PageReference consolePage = new PageReference(VFC_URL_STR1 + callIDStr + VFC_URL_STR2);
            Test.setCurrentPage(consolePage);
            
            Account acc1 = AP01_TestDataUtility.createAccount();
            //Assert to check Account is created successfully
            system.assert(acc1.id != null);
            
            Contact cont = AP01_TestDataUtility.createContact(acc1);
            //Assert to check Account is created successfully
            system.assert(cont.id != null);
            
            cont.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT_MEMBER).RecordTypeId;
            update cont;
            
            VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
            consoleController.linkId = cont.id;
            consoleController.setContactLink();
            consoleController.providerFirstName = NAME_STR;
            consoleController.providerLastName = NAME_STR;
            consoleController.providerNPI = PROVIDER_NPI;
            consoleController.SearchProvider();
            Test.startTest();                
            consoleController.contactVerification();
            
            consoleController.custInteraction.Reason__c = REASON_CLINICAL;
            //consoleController.custInteraction.Secondary_Reason__c = OOA_MEDICAL;
            consoleController.custInteraction.Secondary_Reason__c = 'ED Notification';
            consoleController.custInteraction.ContactId = cont.id;
            
            //consoleController.saveSHP();
            Test.stopTest();
        }
        
    }
    
    
    /**
    * @author IDC Team
    * @date 29/07/2015
    * @description This test method creates a Benefit Plan Coverage record and tests logic for searching Dependent Correspondence Members
    * @param N/A
    * @return void
    */
    static testMethod void testsearchResultCorrespondenceMemberDependent() {
        
        User ooa_oonUser = createSHP_OOA_OON_User();
        
        String callIDStr = String.valueOf(system.now());
        
        System.runAs(ooa_oonUser){
            
            PageReference consolePage = new PageReference(VFC_URL_STR1 + callIDStr + VFC_URL_STR2);
            Test.setCurrentPage(consolePage);
            Account acc1 = AP01_TestDataUtility.createAccount();
            //Assert to check Account is created successfully
            system.assert(acc1.id != null);
            
            Contact cont = AP01_TestDataUtility.createContact(acc1);
            //Assert to check Account is created successfully
            system.assert(cont.id != null);
            
            list<Benefit_Plan_Coverage__c> bnfPlnCov = AP01_TestDataUtility.benefitPlanCoverage(cont);
            //Assert to check Benefit_Plan_Coverage__c is created successfully
            system.assert(bnfPlnCov[0].id != null);
            
            for(Benefit_Plan_Coverage__c tempbnfPlnCov : bnfPlnCov){
            tempbnfPlnCov.Employer_Account__c = acc1.id;
            }
            update bnfPlnCov;
            
            List <Correspondence_Letter__c> corr = AP01_TestDataUtility.correspondenceMember(cont);
            for(Correspondence_Letter__c temCor : corr){
            temCor.SHP_Employer_Group__c = acc1.id;
            temCor.SHP_Correspondence_Entity_Recipient_HCC__c = '1234';
            }
            update corr;
            
            cont.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT_MEMBER).RecordTypeId;
            update cont;
            try{
            VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
            
            Test.startTest();
            consoleController.contactdetailssection(cont.id);
            consoleController.SizeBenefitPlanCoverageEmployer();
            consoleController.getnxtBenefitPlanCoverageAccount();
            consoleController.searchResultCorrespondenceMemberDependent();
            
            }
            //To hanle exception catch block
            catch(exception ex){
                system.assert(ex.getMessage() != null);
            }
            Test.stopTest();
        }
        
    }
    
    /**
    * @author IDC Team
    * @date 29/07/2015
    * @description This test method creates a OOA/OON SR with Member and tests the logic completely
    * @param N/A
    * @return void
    */
    static testMethod void createOOA_OON_SR_with_Member_Test() {
        
        User ooa_oonUser = createSHP_OOA_OON_User();
        
        String callIDStr = String.valueOf(system.now());
        
        System.runAs(ooa_oonUser){
            
            PageReference consolePage = new PageReference(VFC_URL_STR1 + callIDStr + VFC_URL_STR2);
            Test.setCurrentPage(consolePage);
            Account acc1 = AP01_TestDataUtility.createAccount();
            //Assert to check Account is created successfully
            system.assert(acc1.id != null);

            Contact cont1 = AP01_TestDataUtility.createContact(acc1);
            //Assert to check Account is created successfully
            system.assert(cont1.id != null);
  
            Contact cont2 = AP01_TestDataUtility.createContact(acc1);
            //Assert to check Account is created successfully
            system.assert(cont2.id != null);
            Test.startTest();
            String RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONT_RT_MEMBER).RecordTypeId;
            cont1.RecordTypeId = RecordTypeId;
            update cont1;
            
            cont2.RecordTypeId = RecordTypeId;
            update cont2;
            VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
            
            consoleController.memberID = MEMBER_ID;
            consoleController.memberFirstName = NAME_STR;
            consoleController.memberLastName = NAME_STR;
            consoleController.memberContactNumber = MEMBER_CONTACT_NUM;
            consoleController.memberDOB.SearchDate__c = system.today();
            
            consoleController.SearchMember();
            consoleController.memberID = 'test*';
            consoleController.getMemberSearchQuery();
            consoleController.contactVerification();
            
            //consoleController.custInteraction.Reason__c = REASON_CLINICAL;
            //consoleController.custInteraction.Secondary_Reason__c = OOA_MEDICAL;
            consoleController.custInteraction.Reason__c = 'Member Grievance'; 
            consoleController.custInteraction.Secondary_Reason__c = 'Exempt';
            
            try{
            consoleController.saveSHP();
            }
            catch(exception ex){}
            Test.stopTest();
        }
        
    }
    
    /**
    * @author IDC Team
    * @date 29/09/2013
    * @description: Method validate Employee Search for single search result functionality through Console.
    * @param 
    * @return void
    */
    static testMethod void testConsoleEmpSearchforSingle() {
        Test.startTest();
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        //Assert to check Account is created successfully
        system.assert(cont.id != null);
        
        RecordType recType = [select Id from RecordType where Name = 'Employee' and sObjectType = 'Contact'];
        cont.RecordTypeId = recType.id;
        update cont;
        
        Test.stopTest();
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=EMPL&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        consoleController.employeeFirstName = 'Test';
        consoleController.employeeLastName = 'Test';
        consoleController.employeeAffiliate = 'Sutter Shared Services';
        consoleController.SearchEmployee();
    }
    
    /**
    * @author IDC Team
    * @date 29/09/2013
    * @description:This method tests for Supplier Search for multiple search result
    * @param 
    * @return void
    */
    static testMethod void testConsoleSupplierSearchforList() {
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPP&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
       
        List<Contact> contList = [select id,RecordTypeId from contact limit 3];
        RecordType recType = [select Id from RecordType where Name = 'SHP Provider' and sObjectType = 'Contact'];
        
        List<Contact> conListToUpdate = new List<Contact>();
        for(Contact con : contList){
            con.RecordTypeId = recType.id;
            conListToUpdate.add(con);
        }
        update conListToUpdate;
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        
        consoleController.supplierName = 'Test';
        consoleController.supplierTIN = '7676';
        consoleController.supplierNPI = '4343';
        consoleController.SearchSupplier();
        
        system.assertEquals(consoleController.supplierResults.size(), 3);
    }
    
   /**
    * @author IDC Team
    * @date 29/09/2013
    * @description This method tests for Employer Search for multiple search result
    * @param 
    * @return void
    */
    static testMethod void testConsoleEmployerSearchforSingle() {
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPE&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        Account acc1 = AP01_TestDataUtility.createAccount();
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        RecordType recType = [select Id from RecordType where Name = 'SHP Sales Employer Contact Read Only' and sObjectType = 'Contact'];
        cont.RecordTypeId = recType.id;
        update cont;
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        consoleController.employerContactFirstName = 'Test';
        consoleController.employerContactLastName = 'Test';
        consoleController.employerName = 'Test Account';
        consoleController.employerTaxID = '0001';
        consoleController.SearchEmployer();
        
        system.assertEquals(consoleController.employerResults.size(), 1);
    }
    
    /**
    * @author IDC Team
    * @date 29/09/2013
    * @description This method tests for Provider Search for single search result
    * @param 
    * @return void
    */
    static testMethod void testConsoleProviderSearchforSingle() {
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPP&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
     
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        RecordType recType = [select Id from RecordType where Name = 'Provider' and sObjectType = 'Contact'];
        cont.RecordTypeId = recType.id;
        update cont;
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        consoleController.providerFirstName = 'Test';
        consoleController.providerLastName = 'Test';
        consoleController.providerNPI = '111123';
        consoleController.SearchProvider();
        
        System.assertEquals(consoleController.providerResults.size(), 1);
    }
    
    /**
    * @author IDC Team
    * @date 29/09/2013
    * @description This method tests for Vendor Search for single search result
    * @param 
    * @return void
    */
    static testMethod void testConsoleVendorSearchforSingle() {
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=VEND&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        RecordType recType = [select Id from RecordType where Name = 'Vendor' and sObjectType = 'Contact'];
        cont.RecordTypeId = recType.id;
        update cont;
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        consoleController.vendorID = '3131';
        consoleController.vendorName = 'Test';
        consoleController.vendorTaxID = '090912';
        consoleController.SearchVendor();
        
        system.assertEquals(consoleController.vendorResults.size(), 1);
    }
    
    /**
    * @author IDC Team
    * @date 29/09/2013
    * @description This method tests for Patient Search for single search result
    * @param 
    * @return void
    */
    static testMethod void testConsolePatientSearchforSingle() {
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);

        Patient__c patient = [select id,Name from Patient__c where Name =: AP01_TestDataTokens.PATIENT_NAME];
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        consoleController.patientFirstName = 'Test_Patient_FirstName';
        consoleController.patientLastName = 'Test_Patient_LastName';
        consoleController.patientMRN = '123';
        consoleController.SearchPatient();
        
        system.assertEquals(consoleController.patientResults.size(), 1);
    }
    /**
    * @author IDC Team
    * @date 29/09/2013
    * @description This method tests for Patient Account Search for single search result
    * @param 
    * @return void
    */
    static testMethod void testConsolePatientAccountSearchforSingle() {
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        Patient__c patient = [select id,Name from Patient__c where Name =: AP01_TestDataTokens.PATIENT_NAME];
        Guarantor__c guarantor = [select id from Guarantor__c where name =: AP01_TestDataTokens.GURANTOR_NAME];
        Patient_Account__c patientAcc = AP01_TestDataUtility.createPatientAccount(guarantor, patient);
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        consoleController.patientAccountNumber = '1234';
        consoleController.patientMRN = '123';
        consoleController.SearchPatientAccount();
        
        system.assertEquals(consoleController.patientAccountResults.size(), 1);
    }
        
        
        /**
        * @author IDC Team
        * @date 27/09/2013
        * @description This method test for Scenario where DNISTC = EMPL. Employee Search for positive scenario i.e. search results are returned, 
        * edit method, getDataCategoryGroupInfo, scenario where Subject is assigned a value, etc
        * @param 
        * @return void
        */
        static testMethod void testConsole_EmpSearchForPositiveTest() {
            PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=EMPL&CALLDT=12345678987654&TRANF=NO');
            Test.setCurrentPage(consolePage1);
            test.StartTest();
            //Account acc1 = AP01_TestDataUtility.createAccount();
            List<Contact> conList = [select id,RecordTypeId from contact limit 1];
            RecordType recTypecont = [select Id from RecordType where Name = 'Employee' and sObjectType = 'Contact'];
            
            List<Contact> conListToUpdate = new List<Contact>();
            for(Contact con : conList){
                con.RecordTypeId = recTypecont.id;
                conListToUpdate.add(con);
            }
            update conListToUpdate;
            VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
            consoleController.SearchEmployee();
            
            Patient__c patient = [select id,Name from Patient__c where Name =: AP01_TestDataTokens.PATIENT_NAME];
            Guarantor__c guarantor = [select id from Guarantor__c where name =: AP01_TestDataTokens.GURANTOR_NAME];
            Patient_Account__c patAccount1 = AP01_TestDataUtility.createPatientAccount(guarantor, patient);
            
            Case custInteractionOpen1 = new Case();
            custInteractionOpen1.Subject = 'Test';
            RecordType recType = [select id,name from recordType where sobjectType='Case' AND name='S3 Interaction Log' limit 1];
            custInteractionOpen1.RecordTypeID = recType.ID;
            //@description This method create test data for Adhoc Issue.
            Adhoc_Issue__c objAdhocIssue = createAdocIssue();
            custInteractionOpen1.Adhoc_Issue__c = objAdhocIssue.id;
            custInteractionOpen1.Customer_Intent__c = 'Adhoc Issue';
            insert custInteractionOpen1;
            test.stopTest();
            VFC01_CustomConsole consoleController1 = new VFC01_CustomConsole();
            consoleController1.searchString = 'Test';
            
            DataCategoryGroupInfo[] dataCategoryGroupInfo = DataCategoryUtil.getInstance().getAllCategoryGroups();
             
            consoleController1.refreshSearchResult();
            /** @Description: assert to check the current page number **/
            System.assertEquals(consoleController1.getCurrentPageNumber(),1.0);
            consoleController1.next();
            
            consoleController1.previous();
            /** @Description: assert to check if previous page is available **/
            System.assertEquals(consoleController1.getPrevRequired(),false);
            /** @Description: assert to check if next page is available **/
            System.assertEquals(consoleController1.getNextRequired(),false);
            consoleController1.custInteraction.Reason__c = System.Label.Public_Action;
            consoleController1.custInteraction.Secondary_Reason__c = System.Label.Media_Threat;
            consoleController1.saveCustInteraction();
            consoleController1.contactVerification();
            consoleController1.contactVerificationForUnverified();
            consoleController1.showS3 = false;
            consoleController1.contactVerificationForUnverified();
            
            List<KnowledgeArticleVersion> knowArtList = [SELECT Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById FROM KnowledgeArticleVersion WHERE (PublishStatus = 'online' and Language = 'en_US') limit 1];
            String knowArtId;
            if(!knowArtList.isEmpty()){
                knowArtId = knowArtList[0].id;
            }
            
            List<SelectOption> searchType = consoleController1.searchTypes;
            
            consoleController1.getDataCategoryGroupInfo();
            /** @Description: System.assertEquals to check if the  getDataCategoryGroupInfo() and dataCategoryGroupInfo size are same or not **/
            System.assertEquals(consoleController1.getDataCategoryGroupInfo().size(),dataCategoryGroupInfo.size());
            consoleController1.searchString = 'test';
            consoleController1.selectedCheckbox = knowArtId + ',' + knowArtId;
            
            consoleController1.EditButton();
            
            consoleController1.employeeFirstName = 'Test';
            consoleController1.employeeLastName = 'Test';
            consoleController1.employeeAffiliate = 'Sutter Shared Services';
            
            consoleController1.SearchEmployee();
            /** @Description: assert statement compare **/
            //system.assertEquals(consoleController1.employeeResults.size(), 3);
            consoleController1.attach();
            try{
                consoleController1.sendMail();
            }
            //handle exception catch block
            catch(exception ex){
                //assert to check exception 
                system.assert(ex.getMessage() != null);
            }
            
            consoleController1.setContactLink();
            
            System.assertEquals(consoleController1.showDetailTab, true);
            consoleController1.getcategoryKeyword();
            consoleController1.isValidDaterange(Date.today(),date.today()+1);
            
            system.assertEquals(consoleController1.isValidDaterange(Date.today(),date.today()+1), true);
            
            Profile p = [SELECT Id FROM Profile WHERE Name='S3 Credentialing Verification Agent']; 
            User u = new User(Alias = 'standt', Email='standarduser@testmethod.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testmethod.com');
            
            List<selectOption> searchTypeTest = new List<selectOption>();
            searchTypeTest.add(new SelectOption('Employee', 'Employee'));
            searchTypeTest.add(new SelectOption('Provider', 'Provider'));
            searchTypeTest.add(new SelectOption('Vendor', 'Vendor'));
            searchTypeTest.add(new SelectOption('Patient', 'Patient'));
            searchTypeTest.add(new SelectOption('Patient Account', 'Patient Account'));
                
            System.runAs(u){
                List<SelectOption> sssSearch = consoleController1.sssSearchTypes;
                List<SelectOption> adhocTypes1 = consoleController1.adhocTypes;
                //system.assertEquals(sssSearch, searchTypeTest);
            }
        }
        
    /**
    * @author IDC Team
    * @date 02/01/2013
    * @description This method test for scenario where Subject and searchString are blank. It also test the method isValidDaterange method else condition
    * @param 
    * @return void
    */
    static testMethod void testConsoleSubjectBlank() {
        
        List<KnowledgeArticleVersion> knowArtList = [SELECT Id, title, UrlName,KnowledgeArticleId, LastPublishedDate,LastModifiedById FROM KnowledgeArticleVersion WHERE (PublishStatus = 'online' and Language = 'en_US') limit 1];
        String knowArtId;
        if(!knowArtList.isEmpty()){
            knowArtId = knowArtList[0].id;
        }
        Case custInteractionOpen1 = new Case();
        custInteractionOpen1.Subject = 'Test';
        RecordType recType = [select id,name from recordType where sobjectType='Case' AND name=: system.label.CL12_S3PatientInteractionLog limit 1];
        custInteractionOpen1.RecordTypeID = recType.ID;
        //@description This method create test data for Adhoc Issue.
        Adhoc_Issue__c objAdhocIssue = createAdocIssue();
        custInteractionOpen1.Adhoc_Issue__c = objAdhocIssue.id;
        custInteractionOpen1.Customer_Intent__c = 'Adhoc Issue';
        custInteractionOpen1.Secondary_Reason__c = System.Label.Legal_Threat;
        custInteractionOpen1.Subject = 'test subject';
        insert custInteractionOpen1;
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=EMPL&CALLDT=1234567898765&EXITPATH=MANUAL&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        VFC01_CustomConsole consoleController1 = new VFC01_CustomConsole();
        
        consoleController1.getcategoryKeyword();
        consoleController1.isValidDaterange(Date.today()+1,date.today());
        consoleController1.custInteraction.Reason__c = System.Label.Public_Action;
        consoleController1.custInteraction.Secondary_Reason__c = System.Label.Legal_Threat;
        consoleController1.saveCustInteraction();
        system.assertEquals(consoleController1.isValidDaterange(Date.today()+1,date.today()), false);
    }
        
    /**
    * @author IDC Team
    * @date 02/01/2013
    * @description:Method validate different scenario in VFC01_CustomConsole class constructor like getCustomerInteraction,getContact and getFieldlist methods functinality.
    * @param 
    * @return void
    */      

    static TestMethod void testConstructor_VFC01_CustomConsole(){
        PageReference consolePage1 = new PageReference(PAGEREFERENCE_SAVEANDNEW);
        Test.setCurrentPage(consolePage1);
        VFC01_CustomConsole consoleController1 = new VFC01_CustomConsole();
        Test.StartTest();
        Patient__c patient = [select id,Name from Patient__c where Name =: AP01_TestDataTokens.PATIENT_NAME];
        Case cust = new Case();
        Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: system.label.CL12_S3PatientInteractionLog].id;
        //@description This method create test data for Adhoc Issue.
        Adhoc_Issue__c objAdhocIssue = createAdocIssue();
        cust.Adhoc_Issue__c = objAdhocIssue.id;
        cust.recordtypeId = rtId;
        cust.Patient__c = patient.id;
        cust.CALLID__c = '123456789';
        cust.DNISTYPECODE__c = 'PatInq';
        cust.subject = 'test';
        cust.Customer_Intent__c = 'Adhoc Issue';
        insert cust;
        
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage2);
        VFC01_CustomConsole consoleController2 = new VFC01_CustomConsole();
        
        Account acc1 = AP01_TestDataUtility.createAccount();
        
        Contact con = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL08_Member).RecordTypeId);
        system.debug('@@@@ record ' +con.RecordTypeId);
        con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
        con.LastName = AP01_TestDataTokens.CONTACT_L_NAME ;
        con.AccountId = acc1.id;
        con.Phone = AP01_TestDataTokens.PHONE;
        con.BirthDate = system.today();
        con.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
        con.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
        con.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
        con.Member_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID;
        con.Vendor_ID__c = '1234';
        con.MemberIdField__c = '1234';
        
            
        insert con;
        
        PageReference consolePage3 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPM&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage3);
        VFC01_CustomConsole consoleController3 = new VFC01_CustomConsole();
        consoleController3.redirectToNewPage(); 
        Test.StopTest();
        PageReference consolePage4 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPE&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage4);
        VFC01_CustomConsole consoleController4 = new VFC01_CustomConsole(); 
     }
      
     /**
    * @author IDC Team
    * @date 02/01/2013
    * @description:Method to validate contactVerification and VFC01_CustomConsole class contructor for different scenario.
    * @param 
    * @return void
    */ 
     
     static TestMethod void testConstructorVFC01_CustomConsole_ContactVerify(){
        Account acc1 = AP01_TestDataUtility.createAccount();
        //Assert to check Account is created successfully
        system.assert(acc1.id != null);
        
        acc1.Broker_Firm_HCC_ID__c = '1234';
        update acc1;
        list<Contact> lstCont = new list<Contact>();
        
        Contact con1 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL09_SHPProvider).RecordTypeId);
        system.debug('@@@@ record ' +con1.RecordTypeId);
        con1.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
        con1.LastName = AP01_TestDataTokens.CONTACT_L_NAME ;
        con1.AccountId = acc1.id;
        con1.Phone = AP01_TestDataTokens.PHONE;
        con1.BirthDate = system.today();
        con1.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
        con1.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
        con1.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
        con1.Member_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID;
        con1.Supplier_NPI__c = '1234';
        con1.SHP_Provider_Type__c = 'Practitioner';
        lstCont.add(con1);
        
        Contact con2 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL10_SHPBroker).RecordTypeId);
        system.debug('@@@@ record ' +con2.RecordTypeId);
        con2.FirstName = 'ConactTest1' ;
        con2.LastName = 'test' ;
        con2.AccountId = acc1.id;
        con2.Phone = AP01_TestDataTokens.PHONE;
        con2.BirthDate = system.today();
        con2.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
        con2.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
        con2.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
        
        lstCont.add(con2);
        
        Contact con3 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL10_SHPBroker).RecordTypeId);
        system.debug('@@@@ record ' +con3.RecordTypeId);
        con3.FirstName = 'Test';
        con3.LastName = 'Contact1';
        con3.AccountId = acc1.id;
        con3.Phone = AP01_TestDataTokens.PHONE;
        con3.BirthDate = system.today();
        con3.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
        con3.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
        con3.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
        lstCont.add(con3);
        
        Contact con4 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL11_SHPEmployer).RecordTypeId);
        system.debug('@@@@ record ' +con4.RecordTypeId);
        con4.FirstName = 'Test244454';
        con4.LastName = 'Contact1f677';
        con4.AccountId = acc1.id;
        con4.Phone = AP01_TestDataTokens.PHONE;
        con4.BirthDate = system.today();
        con4.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
        con4.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
        con4.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
        lstCont.add(con4);
        
        Contact con5 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL11_SHPEmployer).RecordTypeId);
        system.debug('@@@@ record ' +con5.RecordTypeId);
        con5.FirstName = 'Testggf45656';
        con5.LastName = 'Contact1345';
        con5.AccountId = acc1.id;
        con5.Phone = AP01_TestDataTokens.PHONE;
        con5.BirthDate = system.today();
        con5.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
        con5.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
        con5.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
        lstCont.add(con5);
      
        insert lstCont; 
        //Assert to check Contacts are created successfully
        system.assert(lstCont[0].id != null);
        Test.StartTest();
        PageReference consolePage6 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPP&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage6);
        VFC01_CustomConsole consoleController6 = new VFC01_CustomConsole();
        consoleController6.contactVerification();
        
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPB&&TRANF=NO');
        Test.setCurrentPage(consolePage2);
        VFC01_CustomConsole consoleController5 = new VFC01_CustomConsole();
        consoleController5.contactVerification();
        consoleController5.linkId = con5.id;
        consoleController5.setContactLink();
        acc1.SHP_Group_ID__c = '1234';
        update acc1; 
        
        PageReference consolePage3 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPE&CALLDT=12345678987654&TRANF=Yes');
        Test.setCurrentPage(consolePage3);
        VFC01_CustomConsole consoleController3 = new VFC01_CustomConsole();
        consoleController3.contactVerification();
        Test.StopTest();
     }
     
     /**
    * @author IDC Team
    * @date 02/01/2013
    * @description: Method to validate setContactLink method and VFC01_CustomConsole class contructor for different scenario.
    * @param 
    * @return void
    */ 
     
     static TestMethod void test_setContactLink_ConstructorVFC01_CustomConsole(){
        Account acc2 = AP01_TestDataUtility.createAccount();
        acc2.Broker_Firm_HCC_ID__c = '1234';
        update acc2;
        list<Contact> lstCont = new list<Contact>();
        Contact con2 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL10_SHPBroker).RecordTypeId);
        system.debug('@@@@ record ' +con2.RecordTypeId);
        con2.FirstName = 'Test1' ;
        con2.LastName = 'Contact1' ;
        con2.AccountId = acc2.id;
        con2.Phone = AP01_TestDataTokens.PHONE;
        con2.BirthDate = system.today();
        con2.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
        con2.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
        con2.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
        con2.Member_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID;
        lstCont.add(con2);
        
        Contact con3 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL09_SHPProvider).RecordTypeId);
        system.debug('@@@@ record ' +con3.RecordTypeId);
        con3.FirstName = AP01_TestDataTokens.CONTACT_F_NAME;
        con3.LastName = AP01_TestDataTokens.CONTACT_L_NAME ;
        con3.AccountId = acc2.id;
        con3.Phone = AP01_TestDataTokens.PHONE;
        con3.BirthDate = system.today();
        con3.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
        con3.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
        con3.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
        con3.SHP_Provider_Type__c = 'Practitioner';
        lstCont.add(con3);
        
        Contact con5 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL11_SHPEmployer).RecordTypeId);
        system.debug('@@@@ record ' +con5.RecordTypeId);
        con5.FirstName = 'Testggf45656';
        con5.LastName = 'Contact1345';
        con5.AccountId = acc2.id;
        con5.Phone = AP01_TestDataTokens.PHONE;
        con5.BirthDate = system.today();
        con5.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
        con5.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
        con5.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
        lstCont.add(con5);
      
        insert lstCont; 
        //Assert to check Contacts are  created successfully
        system.assert(lstCont[0].id != null);
        Test.StartTest();
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPB&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage2);
        VFC01_CustomConsole consoleController5 = new VFC01_CustomConsole();
        
        acc2.SHP_Group_ID__c = '1234';
        update acc2;
        consoleController5.linkId = con2.id;
        consoleController5.setContactLink();
        PageReference consolePage3 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPE&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage3);
        VFC01_CustomConsole consoleController3 = new VFC01_CustomConsole();
        Test.StopTest();

     }
     
     /**
    * @author IDC Team
    * @date 02/01/2013
    * @description: Method to validate setContactLink and VFC01_CustomConsole class contructor for different scenario.
    * @param 
    * @return void
    */ 
     
     static TestMethod void testConstructor_VFC01_CustomConsole_setContactLink(){
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=CV&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        VFC01_CustomConsole consoleController1 = new VFC01_CustomConsole();
        
        Account acc1 = AP01_TestDataUtility.createAccount();
        //Assert to check Account is created successfully
        system.assert(acc1.id != null);
        
        Contact con = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL07_Vendor).RecordTypeId);
        system.debug('@@@@ record ' +con.RecordTypeId);
        con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
        con.LastName = AP01_TestDataTokens.CONTACT_L_NAME ;
        con.AccountId = acc1.id;
        con.Phone = AP01_TestDataTokens.PHONE;
        con.BirthDate = system.today();
        con.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
        con.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
        con.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
        con.Member_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID;
        con.Vendor_ID__c = '1234';
            
        insert con;
        //Assert to check Account is created successfully
        system.assert(con.id != null);
        
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=Vend&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage2);
        VFC01_CustomConsole consoleController2 = new VFC01_CustomConsole();
        consoleController2.redirectToNewPage();
        
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        Case cust = new Case();
        Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: system.label.CL03_S3InteractionLog].id;
        //@description This method create test data for Adhoc Issue.
        Adhoc_Issue__c objAdhocIssue = createAdocIssue();
        cust.Adhoc_Issue__c = objAdhocIssue.id;
        cust.recordtypeId = rtId;
        cust.contactId = cont.id;
        cust.CALLID__c = '123456789';
        cust.DNISTYPECODE__c = 'PatInq';
        cust.subject = 'test';
        cust.Customer_Intent__c = 'Adhoc Issue';
        insert cust;
        //Assert to check Case is created successfully
        system.assert(cust.id != null);
        
        PageReference consolePage3 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage3);
        
        VFC01_CustomConsole consoleController3 = new VFC01_CustomConsole();
        consoleController3.sendMail();
        
     }
     
      /**
    * @author IDC Team
    * @date 02/01/2013
    * @description: Method to validate setContactLink and VFC01_CustomConsole class contructor for different scenario.
    * @param 
    * @return void
    */ 
     
     static TestMethod void ConstructorVFC01_CustomConsole_setContactLinkTest(){
        Account acc1 = AP01_TestDataUtility.createAccount();
        
        Contact con = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL08_Member).RecordTypeId);
        system.debug('@@@@ record ' +con.RecordTypeId);
        con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
        con.LastName = AP01_TestDataTokens.CONTACT_L_NAME ;
        con.AccountId = acc1.id;
        con.Phone = AP01_TestDataTokens.PHONE;
        con.BirthDate = system.today();
        con.Employee_Affiliate_Facility__c =AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
        con.MemberIdField__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
        con.Member_Group_Affiliation__c= AP01_TestDataTokens.CONTACT_F_NAME;
        con.Member_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID;
        con.Vendor_ID__c = '1234';
        Test.startTest();    
        insert con;
        //Assert to check Contact is created successfully
        system.assert(con.id != null);
        
        Case cust = new Case();
        Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: system.label.CL03_S3InteractionLog].id;
        //@description This method create test data for Adhoc Issue.
        Adhoc_Issue__c objAdhocIssue = createAdocIssue();
        cust.Adhoc_Issue__c = objAdhocIssue.id;
        cust.recordtypeId = rtId;
        cust.contactId = con.id;
        cust.CALLID__c = '123456789';
        cust.DNISTYPECODE__c = 'PatInq';
        cust.subject = 'test';
        cust.Customer_Intent__c = 'Adhoc Issue';
        insert cust;
        //Assert to check Case is created successfully
        system.assert(cust.id != null);
        
        PageReference consolePage3 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage3);
        VFC01_CustomConsole consoleController3 = new VFC01_CustomConsole();
        
        Id RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(system.label.CL09_SHPProvider).RecordTypeId;
        con.RecordTypeId = RecordTypeId;
        con.SHP_Provider_Type__c = 'Practitioner';
        update con;

        PageReference consolePage4 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage4);
        VFC01_CustomConsole consoleController4 = new VFC01_CustomConsole();
        Test.stopTest();
     }
    
     /**
    * @author IDC Team
    * @date 29/09/2013
    * @description Method to validate default search for searches = Employee,Patient Account,patient,Provider,Vendor
    * @param 
    * @return void
    */
    static testMethod void testConsoleSearchforEmplPatientProviderAndVendor() {
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=EMPL&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
                        
        VFC01_CustomConsole consoleController1 = new VFC01_CustomConsole();
        String searches = 'Employee';
        consoleController1.setValidRecordType();
        system.assertEquals(consoleController1.searches, searches);
        
        //@description This method tests for default search for searches1 = patient
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=12356789&DEV=1234&DNISTC=patinq&CALLDT=1245678987654&TRANF=NO');
        Test.setCurrentPage(consolePage2);                     
        VFC01_CustomConsole consoleController2 = new VFC01_CustomConsole();
        String searches1 = 'Patient Account';
        consoleController2.setValidRecordType();
        system.assertEquals(consoleController2.searches, searches1);
        
        //@description This method tests for default search for searches = Provider
        PageReference consolePage4 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123567789&DEV=1234&DNISTC=SHPP&CALLDT=1245678987654&TRANF=NO');
        Test.setCurrentPage(consolePage4);          
        VFC01_CustomConsole consoleController4 = new VFC01_CustomConsole();
        String searches3 = 'Provider';
        consoleController4.setValidRecordType();
        system.assertEquals(consoleController4.searches, searches3);
        
        //@description This method tests for for default search for searches = Vendor
        PageReference consolePage5 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123567789&DEV=1234&DNISTC=VEND&CALLDT=1245678987654&TRANF=NO');
        Test.setCurrentPage(consolePage5);      
        VFC01_CustomConsole consoleController5 = new VFC01_CustomConsole();
        String searches4 = 'Vendor';
        consoleController5.setValidRecordType();
        system.assertEquals(consoleController5.searches, searches4);
        
        //@description This method tests for Claim Search functinality for searches = patient
        
        PageReference consolePage6 = new PageReference('/apex/VFP01_CustomConsole?CALLID=12356789&DEV=1234&DNISTC=patinq&CALLDT=1245678987654&TRANF=NO');
        Test.setCurrentPage(consolePage6);
                        
        VFC01_CustomConsole consoleController6 = new VFC01_CustomConsole();
        String searches5 = 'patient';
        consoleController6.searches = system.label.CL27_Patient;
        consoleController6.setValidRecordType();
    }
    
    /**
    * @author IDC Team
    * @date 18/03/2015
    * @description: Method to validate exception catch block of SizeCustomerInquiries method.
    * @param 
    * @return void
    */   

   static testMethod void MemberOLTPTest() {
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
       
        Test.startTest();
        try{
            consoleController.SizeCustomerInquiries();
        }
        catch(exception ex){system.assert(ex.getMessage() != null);}
        test.stoptest();
    }
    
    /**
    * @author IDC Team
    * @date 18/03/2015
    * @description: Method to validate Sizecorrespondence method of the controller
    * @param 
    * @return void
    */   
    
    static testMethod void testMemberOLTP_Sizecorrespondence() {
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
       
        Test.startTest();
        try{
            consoleController.Sizecorrespondence();
        }
        catch(exception ex){system.assert(ex.getMessage() != null);}
        test.stoptest();
    }
    
    /**
    * @author IDC Team
    * @date 18/03/2015
    * @description: Method to validate exception SizeClaimHeader method of the controller
    * @param 
    * @return void
    */
    
    static testMethod void testMemberOLTP_SizeClaimHeader() {
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
       
        Test.startTest();
        try{
            consoleController.SizeClaimHeader();        
        }
        catch(exception ex){system.assert(ex.getMessage() != null);}
        test.stoptest();
    }
    
    /**
    * @author IDC Team
    * @date 18/03/2015
    * @description: Method to validate exception in sizeCorrespondenceMember method of the controller
    * @param 
    * @return void
    */
    
    
    static testMethod void testMemberOLTP_sizeCorrespondenceMember() {
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
       
        Test.startTest();
        try{
            
            consoleController.sizeCorrespondenceMember();
        }
        catch(exception ex){system.assert(ex.getMessage() != null);}
        test.stoptest();
    }
    
    /**
    * @author IDC Team
    * @date 18/03/2015
    * @description: Method to validate SizeBenefitPlanCoverage method of the controller
    * @param 
    * @return void
    */
    
    static testMethod void testMemberOLTP_SizeBenefitPlanCoverage() {
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
       
        Test.startTest();
        try{
            
            consoleController.SizeBenefitPlanCoverage();
        }
        catch(exception ex){system.assert(ex.getMessage() != null);}
        test.stoptest();
    }
    
    /**
    * @author IDC Team
    * @date 18/03/2015
    * @description: Method to validate SizePCP,SizeClaimHeader,SizeCustomerInquiries,SizeBenefitPlanCoverage,SizeBenefitPlanCoverageEmployer,searchResultBenefitPlanCoverageEmployer,searchResultBenefitPlanCoverageEmployer various functinality for different scenarios.
    * @param 
    * @return void
    */
    static testMethod void testMemberOLTP() {
        Test.StartTest();
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        
        List <PCP_Information__c> pcp1 = AP01_TestDataUtility.createPCP(cont);
        list<Benefit_Plan_Coverage__c> bnfPlnCov = AP01_TestDataUtility.benefitPlanCoverage(cont);
        case cse = AP01_TestDataUtility.employeeInquiryCase(cont);
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();       
        
        consoleController.contactdetailssection(cont.id);
        consoleController.SizePCP();  
        consoleController.SizeClaimHeader();
        consoleController.SizeCustomerInquiries();
        consoleController.SizeBenefitPlanCoverage();
        consoleController.SizeBenefitPlanCoverageEmployer();
        consoleController.searchResultBenefitPlanCoverageEmployer();
        consoleController.getprvBenefitPlanCoverageAccount();
        consoleController.getnxtBenefitPlanCoverageAccount();
        consoleController.searchResultPCP();
        consoleController.searchResultBenefitPlanCoverage();
        consoleController.searchResultClaimHeader();
        consoleController.searchResultCustomerInquiries();
        consoleController.getprvPCP();
        
        //consoleController.counterPCP = 1;
        consoleController.getprvPCP();
        system.assertEquals(consoleController.checkPCP, true);
        //consoleController.recNumPCP = 10;
        consoleController.getnxtPCP();
       //consoleController.recNumPCP = 12;
        consoleController.getnxtPCP();
        //consoleController.counterPCP = 8;
        //consoleController.limitsPCP  = 9;
        consoleController.getnxtPCP();
        consoleController.getprvBenefitPlanCoverage();
        //consoleController.counterBenefitPlanCoverage = 1;
        consoleController.getprvBenefitPlanCoverage();
       // consoleController.recNumBenefitPlanCoverage = 4;
        consoleController.getnxtBenefitPlanCoverage();

        consoleController.getnxtBenefitPlanCoverage();
        consoleController.searchResultBenefitPlanCoverageDetails(4);
        consoleController.nextbtnBenefitPlanCoverageDetails();
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.getprvClaimHeader();

        consoleController.getprvClaimHeader();
        consoleController.getnxtClaimHeader();
        consoleController.getnxtCustomerInquiries();
        consoleController.getprvCustomerInquiries();

        consoleController.getprvCustomerInquiries();
        
        Test.StopTest();
    }

    /**
    * @author IDC Team
    * @date 12/08/2016
    * @description: Implemented this method for testMemberOLTP method to extend functionality and bypass the exception.
    * @param 
    * @return void
    */
    static testMethod void testMemberOLTPExt() {
        
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        
        List <PCP_Information__c> pcp1 = AP01_TestDataUtility.createPCP(cont);
        list<Benefit_Plan_Coverage__c> bnfPlnCov = AP01_TestDataUtility.benefitPlanCoverage(cont);
        case cse = AP01_TestDataUtility.employeeInquiryCase(cont);
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole(); 
        
        consoleController.contactdetailssection(cont.id);
        consoleController.SizePCP();  
        consoleController.SizeClaimHeader();
        consoleController.SizeCustomerInquiries();
        consoleController.SizeBenefitPlanCoverage();
        consoleController.SizeBenefitPlanCoverageEmployer();
        consoleController.searchResultBenefitPlanCoverageEmployer();
        consoleController.getprvBenefitPlanCoverageAccount();
        consoleController.getnxtBenefitPlanCoverageAccount();
        consoleController.searchResultPCP();
        consoleController.searchResultBenefitPlanCoverage();
        consoleController.searchResultClaimHeader();
        consoleController.searchResultCustomerInquiries();
        consoleController.getprvPCP();      
        Test.startTest();
        consoleController.benefitPlanCoverageDetailTableNo = 1;
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.benefitPlanCoverageDetailTableNo = 2;
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.benefitPlanCoverageDetailTableNo = 3;
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.benefitPlanCoverageDetailTableNo = 4;
        consoleController.prvbtnBenefitPlanCoverageDetails();

        consoleController.benefitPlanCoverageDetailTableNo = 1;
        consoleController.nextbtnBenefitPlanCoverageDetails();
        consoleController.benefitPlanCoverageDetailTableNo = 2;
        consoleController.nextbtnBenefitPlanCoverageDetails();
        consoleController.benefitPlanCoverageDetailTableNo = 3;
        consoleController.nextbtnBenefitPlanCoverageDetails();
        consoleController.benefitPlanCoverageDetailTableNo = 4;
        consoleController.nextbtnBenefitPlanCoverageDetails();

        consoleController.benefitPlanCoverageDetailTableNo = 1;
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.benefitPlanCoverageDetailTableNo = 2;
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.benefitPlanCoverageDetailTableNo = 3;
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.benefitPlanCoverageDetailTableNo = 4;
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.getnxtBenefitPlanCoverage();

        consoleController.getnxtClaimHeader();

        consoleController.getnxtClaimHeader();

        consoleController.getnxtCustomerInquiries(); 

        consoleController.getnxtCustomerInquiries();
        consoleController.tabid ='pcptab';
        consoleController.prvbtn();
        consoleController.fstbtn();
        consoleController.endbtn();
        consoleController.nextbtn();
        consoleController.tabid ='custInq';
        consoleController.prvbtn();
        consoleController.fstbtn();
        consoleController.endbtn();
        consoleController.nextbtn();
        consoleController.tabid ='claimTab';
        consoleController.prvbtn();
        consoleController.fstbtn();
        consoleController.endbtn();
        consoleController.nextbtn();
        consoleController.tabid ='benefitTab';
        consoleController.prvbtn();
        consoleController.fstbtn();
        consoleController.endbtn();
        consoleController.nextbtn();
        consoleController.tabid ='BenefittabAccount';
        consoleController.prvbtn();
        consoleController.fstbtn();
        consoleController.endbtn();
        consoleController.nextbtn();
        
        consoleController.tabid = system.label.CL_157_Correspondence;
        consoleController.prvbtn();
        consoleController.fstbtn();
        consoleController.endbtn();
        consoleController.nextbtn();
        consoleController.Sizecorrespondence();
        consoleController.searchCorrespondence();
        consoleController.getnxtCorrespondence();
        consoleController.getprvCorrespondence();
        consoleController.message = 'Test Message';
        consoleController.SearchGuarantor();
        consoleController.SearchPatientAccount();
        consoleController.SearchPatient();
        consoleController.SearchVendor();
        consoleController.SearchProvider();
        consoleController.SearchEmployer();
        consoleController.recNumPCP = 22;
        consoleController.counterPCP = 10;
        consoleController.limitsPCP =  5;
        consoleController.getprvPCP();
        consoleController.getnxtPCP();
        consoleController.recNumPCP = 22;
        consoleController.counterPCP = 20;
        consoleController.limitsPCP =  5;
        consoleController.getprvPCP();
        consoleController.getnxtPCP();

         Test.stopTest();
    }
    
    /**
    * @author IDC Team
    * @date 18/03/2015
    * @description: Method to validate prvbtnBenefitPlanCoverageDetails method.
    * @return void
    */
    static testMethod void testMemberOLTP_prvbtnBenefitPlanCoverageDetails() {
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        //Assert to check Contact is created successfully
        system.assert(cont.id != null);
        
        List <PCP_Information__c> pcp1 = AP01_TestDataUtility.createPCP(cont);
        list<Benefit_Plan_Coverage__c> bnfPlnCov = AP01_TestDataUtility.benefitPlanCoverage(cont);
        //case cse = AP01_TestDataUtility.employeeInquiryCase(cont);
        Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: label.CL13_SHPInteractionLog].id;
        list<case> Templstcase = new list<case>();
        for(Integer i=0;i<12;i++){
        Case intLog = new Case();
        intLog.recordtypeId = rtId;
        intLog.contactId = cont.id;
        intLog.CALLID__c = '123456789';
        intLog.DNISTYPECODE__c = 'SHPP';
        intLog.subject = 'test';
        Templstcase.add(intLog);
        }
        insert Templstcase;
        //Assert to check cases are created successfully
        system.assert(Templstcase[0].id != null);
        //create test Contact data for Claim header custom console.
          List<Claim_Header__c> clmHdrLst = new List<Claim_Header__c>();
            for(integer i=0; i<12;i++){ 
                Claim_Header__c clmHdr = new   Claim_Header__c ();
               clmHdr.SHPClaimHdr_Claim_HCC_ID__c = AP01_TestDataTokens.CONTACT_F_NAME ;
               
               clmHdr.SHPClaimHdr_Member_Lookup__c = cont.id;
               clmHdr.ClaimMemberIdField__c = AP01_TestDataTokens.CLAIM_MEMBER_ID_FIELD;
               clmHdr.SHPClaimHdr_Supplier_HCC_ID__c = AP01_TestDataTokens.VENDOR_TaxID;
               clmHdr.SHPClaimHdr_Claim_DoS_Start__c = system.today(); 
               clmHdr.SHPClaimHdr_Member_HCC_ID__c = 'test';//AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
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
            
            //insert Correspondence Letter as a test Data. 
            Correspondence_Letter__c CorrespondenceLetter = new Correspondence_Letter__c(Status__c = 'Mail Sent',
                                                                                     Selected_Template_Name__c = 'Broker Email Template Test',
                                                                                     To_Contact_List__c = 'Test contact;') ;

            insert CorrespondenceLetter;
            
            /*Id SelectedtemplateId = [Select Id FROM EmailTemplate WHERE Name = 'Broker Email Template Test' limit 1].Id;
            CorrespondenceLetter.Selected_Template__c = SelectedtemplateId;
            update CorrespondenceLetter;*/
            List<CorrespondenceContactAssociation__c> AssociationObjectListToInsert = new List <CorrespondenceContactAssociation__c>();

                for (Integer i=0; i< 12; i++ ) {
                    CorrespondenceContactAssociation__c JunctionAssociationObj = new CorrespondenceContactAssociation__c(Contact__c = cont.Id,
                                                                                                                     Correspondence_Letter__c = CorrespondenceLetter.Id,
                                                                                                                     Status__c = 'Ready For Email Sent');
                                                                                                                    //Selected_Template__c = SelectedtemplateId);
                    AssociationObjectListToInsert.add(JunctionAssociationObj);
                }

            if( !AssociationObjectListToInsert.isEmpty()) {
                insert AssociationObjectListToInsert;
            }
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
       
        Test.startTest();
        consoleController.contactdetailssection(cont.id);
        consoleController.SizePCP();  
        consoleController.SizeClaimHeader();
        consoleController.SizeCustomerInquiries();
        consoleController.SizeBenefitPlanCoverage();
        consoleController.SizeBenefitPlanCoverageEmployer();
        consoleController.searchResultBenefitPlanCoverageEmployer();
        consoleController.getprvBenefitPlanCoverageAccount();
        consoleController.getnxtBenefitPlanCoverageAccount();
        consoleController.searchResultPCP();
        consoleController.searchResultBenefitPlanCoverage();
        consoleController.searchResultClaimHeader();
        consoleController.searchResultCustomerInquiries();
        consoleController.getprvPCP();
        //consoleController.counterPCP = 1;
        consoleController.getprvPCP();
        system.assertEquals(consoleController.checkPCP, true);
        //consoleController.recNumPCP = 10;
        consoleController.getnxtPCP();
       //consoleController.recNumPCP = 12;
        consoleController.getnxtPCP();
        //consoleController.counterPCP = 8;
        //consoleController.limitsPCP  = 9;
        consoleController.getnxtPCP();
        consoleController.getprvBenefitPlanCoverage();
        //consoleController.counterBenefitPlanCoverage = 1;
        consoleController.getprvBenefitPlanCoverage();
       // consoleController.recNumBenefitPlanCoverage = 4;
        consoleController.getnxtBenefitPlanCoverage();

        consoleController.getnxtBenefitPlanCoverage();
        consoleController.searchResultBenefitPlanCoverageDetails(14);
        consoleController.nextbtnBenefitPlanCoverageDetails();
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.getprvClaimHeader();

        consoleController.getprvClaimHeader();
        consoleController.getnxtClaimHeader();
        consoleController.getnxtCustomerInquiries();
        consoleController.getprvCustomerInquiries();

        consoleController.getprvCustomerInquiries();

        consoleController.benefitPlanCoverageDetailTableNo = 1;
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.searchResultBenefitPlanCoverageDetails(14);
        consoleController.benefitPlanCoverageDetailTableNo = 2;
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.searchResultBenefitPlanCoverageDetails(14);
        consoleController.benefitPlanCoverageDetailTableNo = 3;
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.searchResultBenefitPlanCoverageDetails(14);
        consoleController.benefitPlanCoverageDetailTableNo = 4;
        consoleController.prvbtnBenefitPlanCoverageDetails();
        consoleController.Sizecorrespondence();
        consoleController.getnxtCorrespondence();
    }
    
    
    /**
    * @author IDC Team
    * @date 18/03/2015
    * @description This method tests member correspondence , dependent correspondence and employer correspondence 
    * @ Req no 3378 Member employer correspondence
    * @param 
    * @return void
    */
    static testMethod void testCorrespondence() {
        Contact cont = [select id,AccountId from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        List <Correspondence_Letter__c> corr = AP01_TestDataUtility.correspondenceMember(cont);
        for(Correspondence_Letter__c temCor : corr){
        temCor.SHP_Employer_Group__c = cont.AccountId;
        temCor.SHP_Correspondence_Entity_Recipient_HCC__c = '1234';
        }
        update corr;
        case cse = AP01_TestDataUtility.employeeInquiryCase(cont);
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
         Test.startTest();
         consoleController.contactdetailssection(cont.id);
        consoleController.tabid = system.label.CL165_Correspondence_Member_Dependent;
        consoleController.prvbtn();
        consoleController.fstbtn();
        consoleController.endbtn();
        consoleController.nextbtn();
        consoleController.sizeCorrespondenceMemberDependent();
        consoleController.getprvCorrespondenceMemberDependent();
        consoleController.getnxtCorrespondenceMemberDependent();
        consoleController.tabid = system.label.CL163_Correspondence_Member;
        consoleController.prvbtn();
        consoleController.fstbtn();
        consoleController.endbtn();
        consoleController.nextbtn();
        consoleController.sizeCorrespondenceMember();
        consoleController.searchResultCorrespondenceMember();
        consoleController.getprvCorrespondenceMember();
        consoleController.getnxtCorrespondenceMember();
        consoleController.tabid = system.label.CL164_Correspondence_Employer;
        consoleController.prvbtn();
        consoleController.fstbtn();
        consoleController.endbtn();
        consoleController.nextbtn();
        consoleController.sizeCorrespondenceEmployer();
        consoleController.searchResultCorrespondenceEmployer();
        consoleController.getprvCorrespondenceEmployer();
        consoleController.getnxtCorrespondenceEmployer();
        
        consoleController.recNumcorrespondenceMember = 22;
        consoleController.countercorrespondenceMember = 10;
        consoleController.limitscorrespondenceMember =  5;
        consoleController.getprvCorrespondenceMember();
        consoleController.getnxtCorrespondenceMember();
        
        consoleController.recNumcorrespondenceMemberDependent = 22;
        consoleController.countercorrespondenceMemberDependent = 10;
        consoleController.limitscorrespondenceMemberDependent =  5;
        consoleController.getprvCorrespondenceMemberDependent();
        consoleController.getnxtCorrespondenceMemberDependent();
        
        consoleController.recNumcorrespondenceEmployer = 22;
        consoleController.countercorrespondenceEmployer = 10;
        consoleController.limitscorrespondenceEmployer =  5;
        consoleController.getprvCorrespondenceEmployer();
        consoleController.getnxtCorrespondenceEmployer();
        
        consoleController.recNumcorrespondenceMember = 22;
        consoleController.countercorrespondenceMember = 20;
        consoleController.limitscorrespondenceMember =  5;
        consoleController.getprvCorrespondenceMember();
        consoleController.getnxtCorrespondenceMember();
        
        consoleController.recNumcorrespondenceMemberDependent = 22;
        consoleController.countercorrespondenceMemberDependent = 20;
        consoleController.limitscorrespondenceMemberDependent =  5;
        consoleController.getprvCorrespondenceMemberDependent();
        consoleController.getnxtCorrespondenceMemberDependent();
        
        consoleController.recNumcorrespondenceEmployer = 22;
        consoleController.countercorrespondenceEmployer = 20;
        consoleController.limitscorrespondenceEmployer =  5;
        consoleController.getprvCorrespondenceEmployer();
        consoleController.getnxtCorrespondenceEmployer();
        consoleController.countercorrespondenceMember = 0;
        consoleController.getprvCorrespondenceMember();
        consoleController.countercorrespondenceMemberDependent = 0;
        consoleController.getprvCorrespondenceMemberDependent();
         consoleController.countercorrespondenceEmployer = 0;
         consoleController.getprvCorrespondenceEmployer();
         Test.stopTest();
         system.assertnotequals(cont.id , null);
    }
    /**
    * @author IDC Team
    * @date 29/09/2013
    * @description This method tests for Broker Search for multiple search result
    * @param 
    * @return void
    */
    static testMethod void testConsoleBrokerSearchforList() {
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPB&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        Account acc1 = AP01_TestDataUtility.createAccount();
        //Assert to check Account is created successfully
        system.assert(acc1.id != null);
        
        List<Contact> contList = AP01_TestDataUtility.createContactList(acc1);
        //Assert to check contacts are created successfully
        system.assert(contList[0].id != null);
        RecordType recType = [select Id from RecordType where Name = 'SHP Sales Broker Contact Read Only' and sObjectType = 'Contact'];
        
        List<Contact> conListToUpdate = new List<Contact>();
        for(Contact con : contList){
            con.RecordTypeId = recType.id;
            conListToUpdate.add(con);
        }
        update conListToUpdate;
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        consoleController.brokerAgentFirstName = 'Test';
        consoleController.brokerAgentLastName = 'Test';
        consoleController.brokerFirmName = 'TEST ACCOUNT';
        consoleController.brokerID = '545412';
        consoleController.brokerFirmTelephoneNumber = '616-643-7666';
        consoleController.SearchBroker();
        
        system.assertEquals(consoleController.brokerResults.size(), 0);
        try{
        list<string> lstString  = consoleController.getFieldList('Test Field');
        }
        catch(exception ex){}
    }
    /**
    * @author IDC Team
    * @date 29/09/2013
    * @description This method tests for Broker Search for single search result
    * @param 
    * @return void
    */
    static testMethod void testConsoleBrokerSearchforSingle() {
        
        PageReference consolePage1 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPB&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage1);
        
        Account acc1 = AP01_TestDataUtility.createAccount();
        Contact cont = AP01_TestDataUtility.createContact(acc1);
        
        RecordType recType = [select Id from RecordType where Name = 'SHP Sales Broker Contact Read Only' and sObjectType = 'Contact'];
        cont.RecordTypeId = recType.id;
        update cont;
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        
        consoleController.brokerAgentFirstName = 'Test';
        consoleController.brokerAgentLastName = 'Test';
        consoleController.brokerFirmName = 'TEST ACCOUNT';
      //Commented in release 12 consoleController.brokerID = acc1.Broker_firm_HCC_Id__c;
        consoleController.brokerFirmTelephoneNumber = '616-643-7555';
        consoleController.SearchBroker();
        
        system.assertEquals(consoleController.brokerResults.size(), 1);
    }
    
    /**
    * @author IDC Team
    * @date 02/01/2014
    * @description This method test for scenario when interaction log status = Closed
    * @param 
    * @return void
    */
    //@isTest 
   /*static testMethod void testConsoleIL_Closed() {
        try{
        Account acc = AP01_TestDataUtility.createAccount();
        Contact cont = AP01_TestDataUtility.createContact(acc);
        
        Case cust = new Case();
        Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: label.CL13_SHPInteractionLog].id;
        cust.recordtypeId = rtId;
        cust.contactId = cont.id;
        cust.CALLID__c = '123456789';
        cust.DNISTYPECODE__c = 'SHPP';
        cust.subject = 'test';
        //cust.Status = label.CL05_Closed;
        insert cust;
        cust.Status = system.label.CL05_Closed;
        update cust;
        PageReference consolePage = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=SHPP&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage);
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        Test.startTest();
        consoleController.contactVerification();
        consoleController.contactVerificationForUnverified();
        consoleController.saveCustInteraction();
        Test.stopTest();
        system.assertEquals(consoleController.isClosed, true);
        }
        catch(exception ex){}
    }/*
    
    /**
    * @author IDC Team
    * @date 09/12/2014
    * @description: This method tests contactVerification and contactVerificationForUnverified methods different scenarios.
    * @param 
    * @return void
    */
    static testMethod void testcontactVerification_contactVerificationForUnverified(){
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        RecordType recType = [select Id from RecordType where Name = :system.label.CL08_Member and sObjectType = 'Contact'];
        cont.RecordTypeId = recType.id;
        update cont;
        Patient__c patient = [select id,Name from Patient__c where Name =: AP01_TestDataTokens.PATIENT_NAME];
        Guarantor__c guarantor = [select id from Guarantor__c where name =: AP01_TestDataTokens.GURANTOR_NAME];
        Patient_Account__c patAccount1 = AP01_TestDataUtility.createPatientAccount(guarantor, patient);
        
        Case cust = new Case();
        Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: system.label.CL13_SHPInteractionLog].id;
        //@description This method create test data for Adhoc Issue.
        Adhoc_Issue__c objAdhocIssue = createAdocIssue();
        cust.Adhoc_Issue__c = objAdhocIssue.id;
        cust.recordtypeId = rtId;
        cust.contactId = cont.id;
        cust.Patient__c = patient.id;
        cust.CALLID__c = '123456789';
        cust.DNISTYPECODE__c = 'PatInq';
        cust.subject = 'test';
        cust.Customer_Intent__c = 'Adhoc Issue';
        insert cust;
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage2);
        VFC01_CustomConsole consoleController2 = new VFC01_CustomConsole();
        consoleController2.ProfileName = 'SHP MEP';
        Test.startTest();
        consoleController2.contactVerification();
        consoleController2.patAcc = 'testpatAcc';
        consoleController2.contactVerificationForUnverified();
        consoleController2.patAcc = '';
        consoleController2.contactVerificationForUnverified();
        Test.stopTest();
        
    }
    /**
    * @author IDC Team
    * @date 09/12/2014
    * @description: This method tests contactVerification and contactVerificationForUnverified methods different scenarios.
    * @param 
    * @return void
    */
    static testMethod void testcontactVerification_Unverified(){
        Contact cont = [select id from contact where FirstName =: AP01_TestDataTokens.CONTACT_F_NAME and LastName =: AP01_TestDataTokens.CONTACT_L_NAME limit 1];
        RecordType recType = [select Id from RecordType where Name = :system.label.CL09_SHPProvider and sObjectType = 'Contact'];
        cont.RecordTypeId = recType.id;
        cont.SHP_Provider_Type__c = 'Practitioner';
        update cont;
        Patient__c patient = [select id,Name from Patient__c where Name =: AP01_TestDataTokens.PATIENT_NAME];
        Guarantor__c guarantor = [select id from Guarantor__c where name =: AP01_TestDataTokens.GURANTOR_NAME];
        Patient_Account__c patAccount1 = AP01_TestDataUtility.createPatientAccount(guarantor, patient);
        
        Case cust = new Case();
        //Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: system.label.CL13_SHPInteractionLog].id;
        Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: system.label.CL12_S3PatientInteractionLog].id;
        //@description This method create test data for Adhoc Issue.
        Adhoc_Issue__c objAdhocIssue = createAdocIssue();
        cust.Adhoc_Issue__c = objAdhocIssue.id;
        cust.recordtypeId = rtId;
        cust.contactId = cont.id;
        cust.Patient__c = patient.id;
        cust.CALLID__c = '123456789';
        cust.DNISTYPECODE__c = 'PatInq';
        cust.subject = 'test';
        cust.Customer_Intent__c = 'Adhoc Issue';
        insert cust;
        
        //Assert to check Case is created successfully
        system.assert(cust.id != null);
        
        PageReference consolePage2 = new PageReference('/apex/VFP01_CustomConsole?CALLID=123456789&DEV=1234&DNISTC=PatInq&CALLDT=12345678987654&TRANF=NO');
        Test.setCurrentPage(consolePage2);
        VFC01_CustomConsole consoleController2 = new VFC01_CustomConsole();
        consoleController2.ProfileName = 'SHP MEP';
        Test.startTest();
        consoleController2.contactVerification();
        consoleController2.patAcc = 'testpatAcc';
        consoleController2.contactVerificationForUnverified();
        consoleController2.patAcc = '';
        consoleController2.contactVerificationForUnverified();
        Test.stopTest();
        
    }
    /**         
    * @author IDC Team      
    * @date 12/07/2016      
    * @description: This method tests Benefit Plan Scenarios of Req-3182.       
    * @param        
    * @return void      
    */      
    static testMethod void testHighRoadsMethods(){      
        Test.StartTest();   
        
        Account accEmployer = HighRoads_TestDataUtility.insertAccount();        
        insert accEmployer; 
        
        Account accSubscriber = new Account();
        accSubscriber.Name = 'Test Account1';
        accSubscriber.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Subscriber').getRecordTypeId();
        accSubscriber.NumberOfEmployees = 50;
        accSubscriber.Industry = 'Hospitaity';
        accSubscriber.Employer_Type__c = 'Large Group (251-1000)';
        insert accSubscriber;
        
        Contact con = new Contact();        
        con.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Sales Employer Contact').RecordTypeId;     
        con.LastName = 'BPA User';      
        con.AccountId = accEmployer.Id;     
        con.Phone = '1234567890';       
        con.EMail = 'test@sutter.com';              
        insert con;     
        
        List<Benefit_Plan_Data_Filters__c> bpdfList = HighRoads_TestDataUtility.insertBenefitDataFiltersCS();       
        insert bpdfList;        
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();      
        insert marketSegList;       
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');     
        List<SHP_Benefit_Grid__c> benefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();      
        insert benefitGrid;     
        List<Benefit_Plan_Metadata__c> benefitPlanMetadata = [SELECT ID,Benefit_Grid__c,EOC__c ,SBC__c ,BCM__c ,        
                                                              Ancillary_EOC__c ,Ancillary_SOB__c,Ancillary_GSA__c,      
                                                              Version_Number__c,IsActivelyMarketed__c,Plan_Year__c,Market_Segment__c,       
                                                              Plan_Related_to_Account__c,Name,Plan_Name__c,Plan_Status__c,      
                                                              Deductible__c,Family_Deductible__c,Ind_Family_Deductible__c,      
                                                              DOV__c,Inpatient__c,Emergency_Room__c,Medical_OR_Rider__c,            
                                                              IsCustom__c,IsHDHP__c,Office_Visit__c,Out_of_Pocket_Maximum__c,       
                                                              Family_OOPM__c,Ind_Family_OOPM__c,Product_Family__c,      
                                                              Outpatient__c,Product__c,RX_Tier_1__c,RX_Tier_2__c,RX_Tier_3__c,      
                                                              RX_Tier_4__c,Rx_Deductible_Family__c,Rx_Deductible_Ind_Family__c,     
                                                              Rx_Deductible_Individual__c,Specialist_Office_Visit__c,Benefit_Plan_ID__c,        
                                                              Visit_Limit__c,Rider_Cost_Share__c,Product_Class__c,      
                                                              Plan_Type__c,Product_Types__c FROM Benefit_Plan_Metadata__c];     
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();                                                            
        Benefit_Plan_Association__c medicalPlan = new Benefit_Plan_Association__c();        
        medicalPlan.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        bpaList.add(medicalPlan);       
        
        Benefit_Plan_Association__c riderPlan = new Benefit_Plan_Association__c();      
        riderPlan.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;     
        riderPlan.Raider_ID__c = benefitPlanMetadata[1].Id;     
        bpaList.add(riderPlan);     
        
        Insert bpaList;   
        
        VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
        consoleController.searchResultBenefitPlanAssociationEmployer();
        consoleController.searchResultDocumentGenerationEmployer();
        consoleController.SizeDocumentGenerationEmployer();
        consoleController.getprvBenefitPlanAssociationAccount();
        consoleController.getprvDocumentGenerationAccount();
        consoleController.getnxtBenefitPlanAssociationAccount();
        consoleController.getnxtDocumentGenerationAccount();
        consoleController.getprvDocumentGeneration();
        consoleController.getnxtBenefitPlanAssociation();
        consoleController.getnxtDocumentGeneration();
        Test.StopTest();        
    }    
    
 }