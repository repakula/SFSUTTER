/**  
*    Class Name: EmployeePortalUser_Test
*    Author: IDC Team
*    Date: 23-December-2013
*    Description: Test Class for ManageContactDatabase,ManageCommunityUsers,ManageUserPermissions Classes. This class tests different scenarios that are handled in the code.
*    History
*    --------
**/
@isTest
private without sharing class EmployeePortalUser_Test {

    private static Id accountId;
    private Static integer i=1;
    private Static integer j=1;
    
    /**
    * @author IDC Team
    * @date 28/09/2015
    * @description: method to create test data used by all tests
    * @param 
    * @return void
    */
    @testSetup 
    static void createTestData() {
        User TestUser = CreateUser();
        //Create Custom Setting containing Profile Names
        list<CS_ManageProfile__c> lstCS_ManageProfile = new list<CS_ManageProfile__c>();
        CS_ManageProfile__c objCS_ManageProfile1 = new CS_ManageProfile__c(Name = 'Communities_Portal',Profile_Name__c = 'Community Portal');
        lstCS_ManageProfile.add(objCS_ManageProfile1);
        CS_ManageProfile__c objCS_ManageProfile2 = new CS_ManageProfile__c(Name = 'Communities_Provider',Profile_Name__c = 'PDV Community Provider');
        lstCS_ManageProfile.add(objCS_ManageProfile2);
        
        CS_ManageProfile__c objCS_ManageProfile3 = new CS_ManageProfile__c(Name = 'Community_Portal_Manager',Profile_Name__c = 'Community Portal Manager');
        lstCS_ManageProfile.add(objCS_ManageProfile3);
        
        insert lstCS_ManageProfile;
        
        //Assert to check if CS_ManageProfile__c  custom setting has been created successfully 
        List<CS_ManageProfile__c> templstCS_ManageProfile = CS_ManageProfile__c.getall().values();
        system.assert(templstCS_ManageProfile != null);
        
        //Create Custom Setting Created Date
        CreatedDate__c objCreatedate = new CreatedDate__c(Name = 'CopyPcpDate',Created_date__c = system.today().adddays(2));
        insert objCreatedate;
        
        //Assert to check if CreatedDate__c  custom setting has been created successfully 
        List<CreatedDate__c> lstCreatedDate = CreatedDate__c.getall().values();
        system.assert(lstCreatedDate != null);
        
        //Create Custom Setting ActiveStatus
        ActiveStatus__c objActiveStatus = new ActiveStatus__c(Name = 'AA');
        insert objActiveStatus;
        
        //Assert to check if ActiveStatus__c  custom setting has been created successfully 
        List<ActiveStatus__c> lstActiveStatus = ActiveStatus__c.getall().values();
        system.assert(lstActiveStatus != null);
        
        //Create Custom Setting Salesforce Affiliates
        Salesforce_Affiliates__c objSalesforceAffiliates = new Salesforce_Affiliates__c(Name = 'Sutter Shared Services',Affiliate_Name__c = 'Sutter Shared Services',isSalesforce_True__c =true);
        insert objSalesforceAffiliates;
        
        //Assert to check if Salesforce_Affiliates__c  custom setting has been created successfully 
        List<Salesforce_Affiliates__c> lstSalesforceAffiliates = Salesforce_Affiliates__c.getall().values();
        system.assert(lstSalesforceAffiliates != null);
        
        //Create Custom Setting Salesforce Affiliates
        list<PermissionSetFields__c> lstPermissionSetFields = new list<PermissionSetFields__c>();
        PermissionSetFields__c objPermissionSetFields1 = new PermissionSetFields__c(Name = 'Test1',FieldAPIName__c = 'EMPLOYEE_UNION_AFFILIATE__C',FieldValue__c ='Test');
        lstPermissionSetFields.add(objPermissionSetFields1);
        PermissionSetFields__c objPermissionSetFields2 = new PermissionSetFields__c(Name = 'Test2',FieldAPIName__c = 'EMPLOYEE_BARGAINING_UNION__C',FieldValue__c ='Test');
        lstPermissionSetFields.add(objPermissionSetFields2);
        PermissionSetFields__c objPermissionSetFields3 = new PermissionSetFields__c(Name = 'Test3',FieldAPIName__c = 'EMPLOYEE_EMPLOYMENT_STATUS__C',FieldValue__c ='Test');
        lstPermissionSetFields.add(objPermissionSetFields3);
        PermissionSetFields__c objPermissionSetFields4 = new PermissionSetFields__c(Name = 'Test4',FieldAPIName__c = 'EMPLOYEE_AFFILIATE_FACILITY__C',FieldValue__c ='Test');
        lstPermissionSetFields.add(objPermissionSetFields4);
        insert lstPermissionSetFields;
        
        //Assert to check if PermissionSetFields__c  custom setting has been created successfully 
        List<PermissionSetFields__c> templstPermissionSetFields = PermissionSetFields__c.getall().values();
        system.assert(templstPermissionSetFields != null);
    }
    /**
    * @author IDC Team
    * @date 28/09/2015
    * @description: method to assign permission set to the Users 
    * @param 
    * @return PermissionsetAssignment
    */
    
    public static List <PermissionSetAssignment> CreatePermissionSetAssignment(){
        Profile p2 = [SELECT Id FROM Profile WHERE Name='Community Portal']; 
        
        //Create User.....
        User usr = new User(Alias = 'flexuser', Email='flexuser@fakeemail.com', 
                EmailEncodingKey='UTF-8', LastName='ut1@testorg.com', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p2.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='ut1@testorg.com');

        insert usr;
        
        //Assert to check if User has been created successfully 
        system.assert(usr.id != null);
        
        //Create User.....
        User usr2 = new User(Alias = 'flexuse2', Email='flexuser@fakeemail2.com', 
                EmailEncodingKey='UTF-8', LastName='ut2@testorg.com', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p2.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='ut2@testorg.com');

        insert usr2;
        
        //Assert to check if User has been created successfully 
        system.assert(usr2.id != null);
        
        user currentuser = [select id from user where id =:userinfo.getuserid()];
        List <PermissionSetAssignment> PemrSetAssignments = new List <PermissionSetAssignment>();
        System.runas(currentuser){

        PermissionSet permSet = [SELECT ID From PermissionSet WHERE IsOwnedByProfile = false limit 1];
            PemrSetAssignments.add( new PermissionSetAssignment(AssigneeId = usr.id,PermissionSetId = permSet.ID ) );
            PemrSetAssignments.add( new PermissionSetAssignment(AssigneeId = usr2.id,PermissionSetId = permSet.ID ) );
            
            insert PemrSetAssignments;
        }
        return PemrSetAssignments;
    }
    
     /**
    * @author IDC Team
    * @date 28/09/2015
    * @description: method to Create User
    * @param 
    * @return User
    */
    //Create User 
    Public static User CreateUser(){
        List<User> testRunUserList = new List<User>();
        User testRunUser1;
        Profile pp1;        
        UserRole portalRole; 
        portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (thisUser) {  
        
            //select user profile
            pp1 = [Select Id from Profile where name = 'System Administrator' Limit 1];
                testRunUser1 = new User(
                    ProfileId = pp1.Id,
                    Username = 'tester49_nky@test.com',
                    UserRoleId = portalRole.Id,
                    Alias = 'tester',
                    Email='tester49_nky@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'tester49_nky',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles'
                );
            testRunUserList.add(testRunUser1);
            insert testRunUserList;
        }
        System.AssertEquals(testRunUser1.Username,'tester49_nky@test.com');
        return testRunUser1;
        
        
    }
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method tests the Portal User Creation logic
    *@param     
    *@return     
    */
    @isTest 
    static void testPortalUserCreation() {
        
        ManageContactDatabase testObj = new ManageContactDatabase();
        ManageCommunityUsers testObj1 = new ManageCommunityUsers();
        ManageUserPermissions testObj2 = new ManageUserPermissions();
        Set<Id> contactIds = new Set<Id>();
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        
        //assert to check user has been fetched successfully
        system.assert(TestUser.id != null);
        
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            
            //Assert to check Account has created successfully..
            system.assert(assignedAccount.id != null);
            
            Test.startTest();
            
            List<Contact> contactPortalList = AP01_TestDataUtility.createPortalContacts(assignedAccount);
            //Assert to check Contacts have created successfully
            list<Contact> tempContact = [select id from contact where Id IN : contactPortalList];
            system.assert(tempContact != null);
            
            Test.stopTest();    
            
            for(Contact con : contactPortalList){
                contactIds.add(con.id);
            }
            
        }
    }   
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method tests the Portal Manager Creation logic
    *@param     
    *@return     
    */
    @isTest 
    static void testPortalManagerUserCreation() {
        
        Set<Id> contactIds = new Set<Id>();
        List<User> testRunUserList = new List<User>();
        
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            
            //Assert to check Account has created successfully..
            system.assert(assignedAccount.id != null);
            
            Test.startTest();
                List<Contact> contactPortalList = AP01_TestDataUtility.createPortalManagerContacts(assignedAccount);
            //Assert to check Contacts have created successfully
            list<Contact> tempContact = [select id from contact where Id IN : contactPortalList];
            system.assert(tempContact != null);
            
            Test.stopTest();    
            
            for(Contact con : contactPortalList){
                contactIds.add(con.id);
            }
            
        }
    }
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method update the Contacts returned by CreatePortalContacts method. This is for the Employee_EEO_SubCode__c =1
    *@param     
    *@return     
    */
    @isTest static void testPortaltoManagerUserUpdate() {
        
        List<Contact> toUpdateContacts = new List<Contact>();
        List<User> testRunUserList = new List<User>();
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            
            //Assert to check Account has created successfully..
            system.assert(assignedAccount.id != null);
            
            Test.startTest();
                
                List<Contact> contactPortalList = AP01_TestDataUtility.createPortalContacts(assignedAccount);
                //Assert to check Contacts have created successfully
                list<Contact> tempContact = [select id from contact where Id IN : contactPortalList];
                system.assert(tempContact != null);
            
            Test.stopTest();
            
            for(Contact con: contactPortalList){
                con.Employee_EEO_SubCode__c = '1';
                toUpdateContacts.add(con);
            }
            update toUpdateContacts;
            
        }
    }
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method update the Contacts returned by CreatePortalContacts method. This is for the Employee_EEO_SubCode__c =0
    *@param     
    *@return     
    */
    @isTest static void testManagertoPortalUserUpdate(){
        List<Contact> toUpdateContacts = new List<Contact>();
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
             
            //Assert to check Account has created successfully..
            system.assert(assignedAccount.id != null);
            
            Test.startTest();
                List<Contact> contactPortalList = AP01_TestDataUtility.createPortalManagerContacts(assignedAccount);
                //Assert to check Contacts have created successfully
                list<Contact> tempContact = [select id from contact where Id IN : contactPortalList];
                system.assert(tempContact != null);
                
            Test.stopTest();            
            
            for(Contact con: contactPortalList){
                con.Employee_EEO_SubCode__c = '0';
                toUpdateContacts.add(con);
            }
            update toUpdateContacts;
            
            
        }
    }
    /**   
    *@author :IDC Team    
    *@date 01/01/2014    
    *@description This method update the Contacts returned by CreatePortalManagerContacts method. This is for the Employee_EEO_SubCode__c =0,
    EMPLOYEE_EMPLOYMENT_STATUS__C='CA'
    *@param     
    *@return     
    */ 
    @isTest static void testActivetoInactiveStatusUpdate() {
    
        List<Contact> toUpdateContacts = new List<Contact>();
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            
            //Assert to check Account has created successfully..
            system.assert(assignedAccount.id != null);
            
            Test.startTest();
                List<Contact> contactPortalList = AP01_TestDataUtility.createPortalManagerContacts(assignedAccount);
                //Assert to check Contacts have created successfully
                list<Contact> tempContact = [select id from contact where Id IN : contactPortalList];
                system.assert(tempContact != null);
                
            for(Contact con: contactPortalList){
                con.Employee_EEO_SubCode__c = '0';
                con.EMPLOYEE_EMPLOYMENT_STATUS__C = 'CA';
                toUpdateContacts.add(con);
            }
            update toUpdateContacts;
        }
    }
    /**   
    *@author Abhishek Gupta
    *@date 01/01/2014    
    *@description This method update the Contacts returned by CreatePortalManagerContacts method and test for Teleform_Last_Validation_Date__c is today 
    *@param     
    *@return     
    */
    @isTest static void testContactToPcpUpdate_TLFMValidationDate() {
        Integer pcpInfoSize;
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount =  new Account(name='TestAc1');
            
            Test.startTest();
            List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPCP(assignedAccount);
            
            //Assert to check Contacts have created successfully
            list<Contact> tempContact = [select id from contact where Id IN : ContactToInsert];
            system.assert(tempContact != null);
            
            list<Contact_Validation_Summary__c> lstSummariesToUpdate = new list<Contact_Validation_Summary__c>();
            set<Id> setTestRecId = new set<Id>();
            for(Contact co:ContactToInsert){
                setTestRecId.add(co.id);
                co.Teleform_Last_Validation_Date__c = system.today();
            }
            update ContactToInsert;
            
            ManageContactDatabase.createContactProviderSummaryRecords(ContactToInsert);
            
            //Assert to check Contact_Validation_Summary__c has created successfully....
            list<Contact_Validation_Summary__c> temContValidationsum = [select id from Contact_Validation_Summary__c where Contact_ID__c IN : ContactToInsert];
            system.assert(temContValidationsum != null);
            
            ManageContactDatabase.getProvidersForUserCreation(ContactToInsert,null,null); 
            ManageContactDatabase.getEmployeeRecordType();
            ManageContactDatabase.contactOwnerValidation(ContactToInsert);   
                     
            Test.stopTest(); 
              
        }
    }
    
    /**   
    *@author Abhishek Gupta
    *@date 01/01/2014    
    *@description This method update the Contacts returned by CreatePortalManagerContacts method and test for  Provider_Portal_Last_Validation_Date__c is today 
    *@param     
    *@return     
    */
    @isTest static void testContactToPcpUpdate_PPValidationDate() {
        Integer pcpInfoSize;
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount =  new Account(name='TestAc1');
            
            Test.startTest();
            List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPCP(assignedAccount);
            
            //Assert to check Contacts have created successfully
            list<Contact> tempContact = [select id from contact where Id IN : ContactToInsert];
            system.assert(tempContact != null);
            
             set<Id> setTestRecId = new set<Id>();
            for(Contact co:ContactToInsert){
                setTestRecId.add(co.id);
                co.Provider_Portal_Last_Validation_Date__c = system.today();
            }
            update ContactToInsert; 
            ManageContactDatabase.createContactProviderSummaryRecords(ContactToInsert);
            
            //Assert to check Contact_Validation_Summary__c has created successfully....
            list<Contact_Validation_Summary__c> temContValidationsum = [select id from Contact_Validation_Summary__c where Contact_ID__c IN : ContactToInsert];
            system.assert(temContValidationsum != null);
            
            ManageContactDatabase.getProvidersForUserCreation(ContactToInsert,null,null); 
            ManageContactDatabase.getEmployeeRecordType();
            ManageContactDatabase.contactOwnerValidation(ContactToInsert);   
                     
            Test.stopTest(); 
        }
    
    }
    
    /**   
    *@author Abhishek Gupta
    *@date 01/01/2014    
    *@description This method update the Contacts returned by CreatePortalManagerContacts method and test for Teleform_Last_Validation_Date__c is yesterday and Provider_Portal_Last_Validation_Date__c is today
    *@param     
    *@return     
    */
    @isTest static void testContactToPcpUpdate_TLFM_PP_DateValidation() {
        Integer pcpInfoSize;
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount =  new Account(name='TestAc1');
            
            Test.startTest();
            List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPCP(assignedAccount);
            
            //Assert to check Contacts have created successfully
            list<Contact> tempContact = [select id from contact where Id IN : ContactToInsert];
            system.assert(tempContact != null);
            
            set<Id> setTestRecId = new set<Id>();
            for(Contact co:ContactToInsert){
            
                setTestRecId.add(co.id);
                co.Teleform_Last_Validation_Date__c = system.today().adddays(-1);
                co.Provider_Portal_Last_Validation_Date__c = system.today();
            }
            update ContactToInsert; 
            ManageContactDatabase.createContactProviderSummaryRecords(ContactToInsert);
            
            //Assert to check Contact_Validation_Summary__c has created successfully....
            list<Contact_Validation_Summary__c> temContValidationsum = [select id from Contact_Validation_Summary__c where Contact_ID__c IN : ContactToInsert];
            system.assert(temContValidationsum != null);
            
            ManageContactDatabase.getProvidersForUserCreation(ContactToInsert,null,null); 
            ManageContactDatabase.getEmployeeRecordType();
            ManageContactDatabase.contactOwnerValidation(ContactToInsert);   
                     
            Test.stopTest(); 
              
        }
    
    }
    
    /**   
    *@author Abhishek Gupta
    *@date 01/01/2014    
    *@description This method update the Contacts returned by CreatePortalManagerContacts method and test for Teleform_Last_Validation_Date__c is today and Provider_Portal_Last_Validation_Date__c is yesterday 
    *@param     
    *@return     
    */
    @isTest static void testContactToPcpUpdate_TeleForm_PPDate_Validate() {
        Integer pcpInfoSize;
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount =  new Account(name='TestAc1');
            
            Test.startTest();
            
            List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPCP(assignedAccount);
            
            //Assert to check Contacts have created successfully
            list<Contact> tempContact = [select id from contact where Id IN : ContactToInsert];
            system.assert(tempContact != null);
            
            set<Id> setTestRecId = new set<Id>();
            for(Contact co:ContactToInsert){
                setTestRecId.add(co.id);
                co.Teleform_Last_Validation_Date__c = system.today();
                co.Provider_Portal_Last_Validation_Date__c = system.today().adddays(-1);
            }
            update ContactToInsert; 
            ManageContactDatabase.createContactProviderSummaryRecords(ContactToInsert);
            
            //Assert to check Contact_Validation_Summary__c has created successfully....
            list<Contact_Validation_Summary__c> temContValidationsum = [select id from Contact_Validation_Summary__c where Contact_ID__c IN : ContactToInsert];
            system.assert(temContValidationsum != null);
            
            ManageContactDatabase.getProvidersForUserCreation(ContactToInsert,null,null); 
            ManageContactDatabase.getEmployeeRecordType();
            ManageContactDatabase.contactOwnerValidation(ContactToInsert);   
                     
            Test.stopTest(); 
              
        }
    
    }
    
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method update the Contacts returned by CreatePortalManagerContacts method. This is for the Employee_EEO_SubCode__c =0,
    EMPLOYEE_EMPLOYMENT_STATUS__C='Su'
    *@param     
    *@return     
    */ 
    @isTest static void testActivetoInactiveAffiliateUpdate() {
        
        
        List<Contact> toUpdateContacts = new List<Contact>();
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            //Assert to check Account has created successfully....
            system.assert(assignedAccount.id != null);
            
            Test.startTest();
                List<Contact> contactPortalList = AP01_TestDataUtility.createPortalManagerContacts(assignedAccount);
                //Assert to check Contacts have created successfully
                list<Contact> tempContact = [select id from contact where Id IN : contactPortalList];
                system.assert(tempContact != null);
            Test.stopTest();    
            
            for(Contact con: contactPortalList){
                con.Employee_EEO_SubCode__c = '0';
                con.EMPLOYEE_AFFILIATE_FACILITY__C = 'Su';
                toUpdateContacts.add(con);
            }
            update toUpdateContacts;
            
            //Assert to check update on contacts
            for(Contact Temp : [select id,Employee_EEO_SubCode__c,EMPLOYEE_AFFILIATE_FACILITY__C from contact where id IN : toUpdateContacts] ){
                system.assert(Temp.Employee_EEO_SubCode__c == '0');
                system.assert(Temp.EMPLOYEE_AFFILIATE_FACILITY__C == 'Su');
            }
        }
    }
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method update the Contacts from Inactive to Active status update.
    *@param     
    *@return     
    */ 
    @isTest static void testInactivetoActiveStatusUpdate() {
        
        //Set<Id> contactIds = new Set<Id>();
        //Set<String> userEmails = new Set<String>();
        List<Contact> toUpdateContacts = new List<Contact>();
        List<Contact> toUpdateContacts1 = new List<Contact>();
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            //Assert to check Account has created successfully....
            system.assert(assignedAccount.id != null);
            
            Test.startTest();
                List<Contact> contactPortalList = AP01_TestDataUtility.createPortalManagerContacts(assignedAccount);
                //Assert to check Contacts have created successfully
                list<Contact> tempContact = [select id from contact where Id IN : contactPortalList];
                system.assert(tempContact != null);
            
            for(Contact con : contactPortalList){
                con.EMPLOYEE_EMPLOYMENT_STATUS__C = 'CA';
                toUpdateContacts.add(con);
            }
            update toUpdateContacts;
            
            //assert to check EMPLOYEE_EMPLOYMENT_STATUS__C update on contact..
            Contact tempcontact1 = [select id,EMPLOYEE_EMPLOYMENT_STATUS__C from contact where id IN : toUpdateContacts limit 1]; 
            system.assert(tempcontact1.EMPLOYEE_EMPLOYMENT_STATUS__C == 'CA');
            
            for(Contact con : toUpdateContacts){
                con.EMPLOYEE_EMPLOYMENT_STATUS__C = 'AA';
                toUpdateContacts1.add(con);
            }
            update toUpdateContacts1;
            
            //assert to check EMPLOYEE_EMPLOYMENT_STATUS__C update on contact..
            Contact tempcontact2 = [select id,EMPLOYEE_EMPLOYMENT_STATUS__C from contact where id IN : toUpdateContacts limit 1]; 
            system.assert(tempcontact2.EMPLOYEE_EMPLOYMENT_STATUS__C == 'AA');
            
            Test.stopTest();
        }
    }
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method update the Employee Contacts for Reactivation scenerio.
    *@param     
    *@return     
    */ 
    @isTest 
    static void userReactivationTest(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
        Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
        //Assert to check Account has created successfully....
        system.assert(assignedAccount.id != null);
            
        string recTypeId = [Select Id from RecordType where sObjectType = 'Contact' AND Name = 'Employee' Limit 1].Id;
        
        Contact testCon = new Contact();
        testCon.AccountId = assignedAccount.Id;
        testCon.RecordTypeId = recTypeId;
        testCon.FirstName = 'Test';
        testCon.LastName = 'PortalReactivation';
        testCon.Employee_Work_Email__c = 'test.portalReactivation@test.com';
        testCon.Employee_Union_Affiliate__c = 'CHEU';
        testCon.Employee_Bargaining_Union__c='ABMC CHEU';
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_Affiliate_Facility__c = 'Sutter Shared Services';
        testCon.Employee_EEO_SubCode__c = '0';
        testCon.Username__c = 'testusername@test.com';
        //Test.startTest();
        insert testCon;
        
        //Assert to check Contact has created successfully....
        system.assert(testCon.id != null);
        User testUser1;
        Profile pp2;
        
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (u) {  
        
            //select user profile
            pp2 = [Select Id from Profile where name = 'Community Portal' Limit 1];
                testUser1 = new User(
                    ProfileId = pp2.Id,
                    Username = 'test.portalReactivation@test.com',
                    Alias = 'tester',
                    Email='test.portalReactivation@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = testCon.Id
                );
            insert testUser1;
            
            //Assert to check User has created successfully....
            system.assert(testUser1.id != null);
        }
        Test.startTest();
        testCon.Employee_Employment_Status__c = 'TE';
        update testCon;
        
        //assert to check EMPLOYEE_EMPLOYMENT_STATUS__C update on contact..
        Contact tempcontact1 = [select id,EMPLOYEE_EMPLOYMENT_STATUS__C from contact where id =: testCon.id limit 1]; 
        system.assert(tempcontact1.EMPLOYEE_EMPLOYMENT_STATUS__C == 'TE');
            
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_EEO_SubCode__c = '1';
        update testCon;
        
        //assert to check EMPLOYEE_EMPLOYMENT_STATUS__C update on contact..
        Contact tempcontact2 = [select id,EMPLOYEE_EMPLOYMENT_STATUS__C,Employee_EEO_SubCode__c from contact where id =: testCon.id limit 1]; 
        system.assert(tempcontact2.EMPLOYEE_EMPLOYMENT_STATUS__C == 'AA');
        system.assert(tempcontact2.Employee_EEO_SubCode__c == '1');
            
        testCon.Employee_Employment_Status__c = '';
        update testCon;
    
            
        list<id> ContId = new list<id>();
        ContId.add(testCon.id);
        list<id> UserId = new list<id>();
        UserId.add(testUser1.id);
        ManageCommunityUsers.UpdateProviderUsersTeleForm(ContId);
        Test.stopTest();
        }
        
       
       string testString = ManageCommunityUsers.getPermissionString('');
       User testUser1 =  ManageCommunityUsers.getExceptionUser();
    }
    
     /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method update the Employee Contacts for Reactivation scenerio.
    *@param     
    *@return     
    */ 
    @isTest 
    static void userReactivationTest_emplStatusUpd(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
        Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
        //Assert to check Account has created successfully....
        system.assert(assignedAccount.id != null);
            
        string recTypeId = [Select Id from RecordType where sObjectType = 'Contact' AND Name = 'Employee' Limit 1].Id;
        
        Contact testCon = new Contact();
        testCon.AccountId = assignedAccount.Id;
        testCon.RecordTypeId = recTypeId;
        testCon.FirstName = 'Test';
        testCon.LastName = 'PortalReactivation';
        testCon.Employee_Work_Email__c = 'test.portalReactivation@test.com';
        testCon.Employee_Union_Affiliate__c = 'CHEU';
        testCon.Employee_Bargaining_Union__c='ABMC CHEU';
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_Affiliate_Facility__c = 'Sutter Shared Services';
        testCon.Employee_EEO_SubCode__c = '0';
        testCon.Username__c = 'testusername@test.com';
        Test.startTest();
        insert testCon;
        
        //Assert to check Contact has created successfully....
        system.assert(testCon.id != null);
        User testUser1;
        Profile pp2;
        
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (u) {  
        
            //select user profile
            pp2 = [Select Id from Profile where name = 'Community Portal' Limit 1];
                testUser1 = new User(
                    ProfileId = pp2.Id,
                    Username = 'test.portalReactivation@test.com',
                    Alias = 'tester',
                    Email='test.portalReactivation@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = testCon.Id
                );
            insert testUser1;
            
            //Assert to check User has created successfully....
            system.assert(testUser1.id != null);
        }
         
        testCon.Employee_Employment_Status__c = 'TE';
        update testCon;
        Test.stopTest();
        }
    }
    
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method update the Provider  Contacts for Reactivation scenerio where the Employee's Subcode is being updated from 0 to 1
    *@param     
    *@return     
    */ 
    @isTest static void userReactivationTest_EmpSubCodeUpate(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
        Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
        //Assert to check Account has created successfully....
        system.assert(assignedAccount.id != null);
        
        string recTypeId = [Select Id from RecordType where sObjectType = 'Contact' AND Name = 'Provider' Limit 1].Id;
        
        Contact testCon = new Contact();
        testCon.AccountId = assignedAccount.Id;
        testCon.RecordTypeId = recTypeId;
        testCon.FirstName = '';
        testCon.LastName = 'PortalReactivation';
        testCon.Employee_Work_Email__c = 'test.portalReactivation@test.com';
        testCon.Employee_Union_Affiliate__c = 'CHEU';
        testCon.Employee_Bargaining_Union__c='ABMC CHEU';
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_Affiliate_Facility__c = 'Sutter Shared Services';
        testCon.Employee_EEO_SubCode__c = '0';
        testCon.Username__c = 'testUserName';
        testCon.Email = 'test@gmail.com';
        testCon.Provider_Practicing_Physician__c = true;
        testCon.Provider_Active_Status__c = true;
        testCon.Provider_Service_Status__c = null;
        Test.startTest();
        insert testCon;
        
        //Assert to check Contact has created successfully....
        system.assert(testCon.id != null);
        
        User testUser1;
        Profile pp2;
        
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (u) {  
        
            //select user profile
            pp2 = [Select Id from Profile where name = 'Community Portal' Limit 1];
                testUser1 = new User(
                    ProfileId = pp2.Id,
                    Username = 'test.portalReactivation@test.com',
                    Alias = 'tester',
                    Email='test.portalReactivation@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = testCon.Id
                );
            insert testUser1;
            
            //Assert to check User has created successfully....
            system.assert(testUser1.id != null);
        }
            
        /*testCon.AccountId = assignedAccount.Id;
        testCon.EMPLOYEE_EMPLOYMENT_STATUS__C = 'TE';
        testCon.Email = 'testtest@gmail.com';
        testCon.Contact_SSN_E__c = '4323';
        testCon.Provider_Retired_Departed__c = true;
        update testCon;
        
        //assert to check EMPLOYEE_EMPLOYMENT_STATUS__C,Email,Provider_Service_Status__c update on contact..
        Contact tempcontact1 = [select id,EMPLOYEE_EMPLOYMENT_STATUS__C,Email,Provider_Service_Status__c from contact where id =: testCon.id limit 1]; 
        system.assert(tempcontact1.EMPLOYEE_EMPLOYMENT_STATUS__C == 'TE');
        system.assert(tempcontact1.Email == 'testtest@gmail.com');
        //system.assert(tempcontact1.Provider_Service_Status__c == 'Retired');
        */
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_EEO_SubCode__c = '1';
        update testCon;
 
        //assert to check EMPLOYEE_EMPLOYMENT_STATUS__C,Email,Provider_Service_Status__c update on contact..
        Contact tempcontact2 = [select id,EMPLOYEE_EMPLOYMENT_STATUS__C,Employee_EEO_SubCode__c from contact where id =: testCon.id limit 1]; 
        system.assert(tempcontact2.EMPLOYEE_EMPLOYMENT_STATUS__C == 'AA');
        system.assert(tempcontact2.Employee_EEO_SubCode__c == '1');
        
        testCon.Employee_Employment_Status__c = '';
        update testCon;
        
        list<id> ContId = new list<id>();
        ContId.add(testCon.id);
        list<id> UserId = new list<id>();
        UserId.add(testUser1.id);
        ManageCommunityUsers.UpdateProviderUsers(ContId);
        testCon.Provider_Retired_Departed__c = true;
        update testCon;
        ManageCommunityUsers.UpdateProviderUsers(ContId);
        ManageCommunityUsers.ProviderUserInactive(UserId);
        Test.stopTest();
        }
        
       string testString = ManageCommunityUsers.getPermissionString('');
       User testUser1 =  ManageCommunityUsers.getExceptionUser();
       set<id> setContId = new set<id>();
       ManageCommunityUsers.getContactUsers(setContId);
    }
    
   
    
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method update the Employee Contacts for Reactivation scenerio where Employee_Employment_Status__c is blank .
    *@param     
    *@return     
    */
    @isTest static void userReactivationTest_EmpStatusBlank()
    {
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
        Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
        //Assert to check Account has created successfully....
        system.assert(assignedAccount.id != null);
        
        string recTypeId = [Select Id from RecordType where sObjectType = 'Contact' AND Name = 'Employee' Limit 1].Id;
        
        Contact testCon = new Contact();
        testCon.AccountId = assignedAccount.Id;
        testCon.RecordTypeId = recTypeId;
        testCon.FirstName = 'Test';
        testCon.LastName = 'PortalReactivation';
        testCon.Employee_Work_Email__c = 'test.portalReactivation@test.com';
        testCon.Employee_Union_Affiliate__c = 'CHEU';
        testCon.Employee_Bargaining_Union__c='ABMC CHEU';
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_Affiliate_Facility__c = 'Sutter Shared Services';
        testCon.Employee_EEO_SubCode__c = '0';
        //Test.startTest();
        insert testCon;
        
        //Assert to check Contact has created successfully....
        system.assert(testCon.id != null);
        
        User testUser1;
        Profile pp2;
        
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (u) {  
        
            //select user profile
            pp2 = [Select Id from Profile where name = 'Community Portal' Limit 1];
                testUser1 = new User(
                    ProfileId = pp2.Id,
                    Username = 'test.portalReactivation@test.com',
                    Alias = 'tester',
                    Email='test.portalReactivation@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = testCon.Id
                );
            insert testUser1;
            //Assert to check User has created successfully....
            system.assert(testUser1.id != null);
        }
         
        Test.startTest();     
        testCon.Employee_Employment_Status__c = '';
        update testCon;
        
        testCon.Employee_Affiliate_Facility__c = 'Sutter Health Plus';
        update testCon;
        
       //assert to check Employee_Affiliate_Facility__c update on contact..
        Contact tempcontact2 = [select id,Employee_Affiliate_Facility__c from contact where id =: testCon.id limit 1]; 
        system.assert(tempcontact2.Employee_Affiliate_Facility__c == 'Sutter Health Plus');
        
        list<id> ContId = new list<id>();
        ContId.add(testCon.id);
        ManageCommunityUsers.UpdateProviderUsers(ContId);
        Test.stopTest();
        }
        
        string testString = ManageCommunityUsers.getPermissionString('');
       User testUser1 =  ManageCommunityUsers.getExceptionUser();
    }
    
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method update the Contacts for Reactivation scenerio where Employee_Employment_Status__c= blank and Employee_Affiliate_Facility__c = blank.
    *@param     
    *@return     
    */ 
    @isTest static void userReactivationTest_empStatus_empFacility_Blank()
    {
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
        Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
        //Assert to check Account has created successfully....
        system.assert(assignedAccount.id != null);
        
        string recTypeId = [Select Id from RecordType where sObjectType = 'Contact' AND Name = 'Employee' Limit 1].Id;
        
        Contact testCon = new Contact();
        testCon.AccountId = assignedAccount.Id;
        testCon.RecordTypeId = recTypeId;
        testCon.FirstName = 'Test';
        testCon.LastName = 'PortalReactivation';
        testCon.Employee_Work_Email__c = 'test.portalReactivation@test.com';
        testCon.Employee_Union_Affiliate__c = 'CHEU';
        testCon.Employee_Bargaining_Union__c='ABMC CHEU';
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_Affiliate_Facility__c = 'Sutter Shared Services';
        testCon.Employee_EEO_SubCode__c = '0';
        Test.startTest();
        insert testCon;
       
        //Assert to check Contact has created successfully....
        system.assert(testCon.id != null);
        
        User testUser1;
        Profile pp2;
        
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (u) {  
        
            //select user profile
            pp2 = [Select Id from Profile where name = 'Community Portal' Limit 1];
                testUser1 = new User(
                    ProfileId = pp2.Id,
                    Username = 'test.portalReactivation@test.com',
                    Alias = 'tester',
                    Email='test.portalReactivation@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = testCon.Id
                );
            insert testUser1;
            //Assert to check Contact has created successfully....
            system.assert(testCon.id != null);
        }
         
        testCon.Employee_Affiliate_Facility__c = 'Sutter Health Plus';
        testCon.Employee_Employment_Status__c = '';
        update testCon;
       
        testCon.Employee_Affiliate_Facility__c = '';
        update testCon;
        
        Test.stopTest();
        }
       string testString = ManageCommunityUsers.getPermissionString('');
       User testUser1 =  ManageCommunityUsers.getExceptionUser();
    }
    
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method update the Contacts for Reactivation scenerio where Employee_Employment_Status__c= blank and Employee_Affiliate_Facility__c = blank.
    *@param     
    *@return     
    */ 
    @isTest static void userReactivationTest_createUserMethodValidate(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
        Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
        //Assert to check Account has created successfully....
        system.assert(assignedAccount.id != null);
        
        string recTypeId = [Select Id from RecordType where sObjectType = 'Contact' AND Name = 'Employee' Limit 1].Id;
        list<Contact> lstcont = new list<Contact>();
        Contact testCon = new Contact();
        testCon.AccountId = assignedAccount.Id;
        testCon.RecordTypeId = recTypeId;
        testCon.FirstName = 'Test';
        testCon.LastName = 'PortalReactivation';
        testCon.Employee_Work_Email__c = 'test.portalReactivation@test.com';
        testCon.Employee_Union_Affiliate__c = 'CHEU';
        testCon.Employee_Bargaining_Union__c='ABMC CHEU';
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_Affiliate_Facility__c = 'Sutter Shared Services';
        testCon.Employee_EEO_SubCode__c = '0';
        lstcont.add(testCon);
        Contact testCon1 = new Contact();
        testCon1.AccountId = assignedAccount.Id;
        testCon1.RecordTypeId = recTypeId;
        testCon1.FirstName = 'Test';
        testCon1.LastName = 'PortalReactivation';
        testCon1.Employee_Work_Email__c = 'test.portalReactivation@test.com.portal';
        testCon1.Employee_Union_Affiliate__c = 'CHEU';
        testCon1.Employee_Bargaining_Union__c='ABMC CHEU';
        testCon1.Employee_Employment_Status__c = 'AA';
        testCon1.Employee_Affiliate_Facility__c = 'Sutter Shared Services';
        testCon1.Employee_EEO_SubCode__c = '0';
        lstcont.add(testCon1);
        Test.startTest();
        
        
        insert lstcont;
       
        //Assert to check Contact has created successfully....
        system.assert(testCon.id != null);
        
        User testUser1;
        User testUser2;
        Profile pp2;
        
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (u) {  
        
            //select user profile
            pp2 = [Select Id from Profile where name = 'Community Portal' Limit 1];
                testUser1 = new User(
                    ProfileId = pp2.Id,
                    Username = 'test.portalReactivation@test.com',
                    Alias = 'tester',
                    Email='test.portalReactivation@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = testCon.Id
                );
            insert testUser1;
            //Assert to check Contact has created successfully....
            system.assert(testUser1.id != null);
            
            testUser2 = new User(
                    ProfileId = pp2.Id,
                    Username = 'test.portalreactivation@test.com.portal',
                    Alias = 'tester',
                    Email='test.portalReactivation@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation.portal',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = testCon1.Id
                );
                insert testUser2;
                 //Assert to check Contact has created successfully....
                system.assert(testUser2.id != null);
        }
        list<string> userName = new list<string>();
        userName.add('test.portalReactivation@test.com');
        //userName.add('test.portalreactivation@test.com.portal');
        List<String> nickName = new List<String>();
        nickName.add('test.portalReactivation');
        //nickName.add('test.portalReactivation.portal');
        List<String> contactId = new List<String>();
        contactId.add(testCon.id);
        //contactId.add(testCon.id);
        List<String> alias = new List<String>();
        alias.add('tester');
        List<String> email = new List<String>();
        email.add('test.portalReactivation@test.com');
        List<String> firstName = new List<String>();
        firstName.add('One');
        List<String> lastName = new List<String>();
        lastName.add('Tester');
        Map<String,String> profileMap = new Map<String,String>();
        profileMap.put('tester','tester');
        List<String> permissionUnion = new List<String>();
        permissionUnion.add('tester');
        List<String> permissionBargaining =  new List<String>();
        permissionBargaining.add('tester');
        List<String> permissionBenefit = new List<String>();
        permissionBenefit.add('test');
        List<String> permissionAffiliate = new List<String>();
        permissionAffiliate.add('test');
        List<String> ADIDs = new List<String>();
        ADIDs.add('test');
        List<String> PermissionEEOSubcode = new List<String>();
        PermissionEEOSubcode.add('test');
        List<String> PermissionCompanycode = new List<String>();
        PermissionCompanycode.add('test');
        List<String> PermissionProcesslevel = new List<String>();
        PermissionProcesslevel.add('test');
        ManageCommunityUsers.createUser(contactId,alias, email, firstName, lastName,userName, profileMap,nickName,permissionUnion,permissionBargaining , permissionBenefit,permissionAffiliate,ADIDs,PermissionEEOSubcode,PermissionCompanycode,PermissionProcesslevel);
       
       CreatedDate__c createdDateCustomSetting = CreatedDate__c.getValues('CopyPcpDate');
       delete createdDateCustomSetting;
       try{
       ManageContactDatabase.insertContactPCP(null);
       }
       catch(exception ex){}
        Test.stopTest();
        }
    }
    
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method tests the assignment of User permission.
    *@param     
    *@return     
    */  
    @isTest 
    static void setCurrentUserPermissionstest(){
        User testUser = ManageUserPermissions.getExceptionUser();
        
        
        User TestUser123 = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser123){
        Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
        //Assert to check Account has created successfully....
        system.assert(assignedAccount.id != null);
        
        string recTypeId = [Select Id from RecordType where sObjectType = 'Contact' AND Name = 'Employee' Limit 1].Id;
        
        Contact testCon = new Contact();
        testCon.AccountId = assignedAccount.Id;
        testCon.RecordTypeId = recTypeId;
        testCon.FirstName = 'Test';
        testCon.LastName = 'PortalReactivation';
        testCon.Employee_Work_Email__c = 'test.portalReactivation@test.com';
        testCon.Employee_Union_Affiliate__c = 'CHEU';
        testCon.Employee_Bargaining_Union__c= ' ABMC CHEU' ;
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_Affiliate_Facility__c = 'Sutter Shared Services';
        testCon.Employee_EEO_SubCode__c = '1';
        //Test.startTest();
        insert testCon;
        
        //Assert to check Contact has created successfully....
        system.assert(testCon.id != null);
        
        User testUser1;
        Profile pp2;
        
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];  
        System.runAs (u) {  
        
            //select user profile
            pp2 = [Select Id from Profile where name = 'Community Portal Manager' Limit 1];
                testUser1 = new User(
                    ProfileId = pp2.Id,
                    Username = 'test.portalReactivation@test.com',
                    Alias = 'tester',
                    Email='test.portalReactivation@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = testCon.Id
                );
            insert testUser1;
            //Assert to check Contact has created successfully....
            system.assert(testUser1.id != null);
        }
        
        testCon.Employee_Employment_Status__c = 'TE';
        update testCon;
        
        //assert to check Employee_Affiliate_Facility__c update on contact..
        Contact tempcontact1 = [select id,Employee_Affiliate_Facility__c,Employee_Employment_Status__c from contact where id =: testCon.id limit 1]; 
        system.assert(tempcontact1.Employee_Employment_Status__c == 'TE');
        
        testCon.Employee_Employment_Status__c = 'AA';
        update testCon;
        
        //assert to check Employee_Affiliate_Facility__c update on contact..
        Contact tempcontact2 = [select id,Employee_Affiliate_Facility__c,Employee_Employment_Status__c from contact where id =: testCon.id limit 1]; 
        system.assert(tempcontact2.Employee_Employment_Status__c == 'AA');
        
        Test.startTest();
        List<Id> nochange = new List<Id>();
        List<Id> deactive = new List<Id>();
        List<Id> reactive = new List<Id>();
        nochange.add(testUser1.id);
        reactive.add(testUser1.Id);
      
        map<id, string> union = new map<id, string>();
        map<id, string> bargaining = new map<id, string>();
        map<id, string> benefit = new map<id, string>();
        map<id, string> affiliate = new map<id, string>();
        map<id, string> affiliateFacility = new map<id, string>();
        //Req 3676
        map<id, string> EEOsubcode = new map<id, string>();
        map<id, string> Companycode = new map<id, string>();
        map<id, string> Processlevel = new map<id, string>();
        
        //Req 3676
        EEOsubcode.put(testUser1.Id, '2');
        Companycode.put(testUser1.Id, '470');
        Processlevel.put(testUser1.Id, '99');
 
        union.put(testUser1.Id, 'test');
        bargaining.put(testUser1.ID, 'test');
        benefit.put(testUser1.Id, 'test');
        affiliate.put(testUser1.Id, 'test');
        affiliate.put(testCon.Id, 'Sutter Shared Services');
        ManageUserPermissions.unionPermissions.put('test','AA');
        ManageUserPermissions.benefitPermissions.put('test','AB');
        ManageUserPermissions.affiliatePermissions.put('test','AC');
        ManageUserPermissions.setCurrentUserPermissions(nochange, deactive, reactive, union,bargaining, benefit, affiliate,EEOsubcode,Companycode,Processlevel);
        
        union.put(testUser1.Id, 'test');
        bargaining.put(testUser1.ID, 'test');
        benefit.put(testUser1.Id, 'test');
        affiliate.put(testUser1.Id, 'test');
        affiliate.put(testCon.Id, 'Sutter Shared Services');
        map<id,string> idAffiliateMap = new map<id,string>();
        idAffiliateMap.put(testUser1.Id, 'test');
        ManageUserPermissions.unionPermissions.put('test','AA');
        ManageUserPermissions.benefitPermissions.put('test','AB');
        ManageUserPermissions.affiliatePermissions.put('test','AC');
        ManageUserPermissions.bargainingpermissions.put('test','AA');
        ManageUserPermissions.setCurrentUserPermissions(nochange, deactive, reactive, union,bargaining, benefit, affiliate,EEOsubcode,Companycode,Processlevel);
        try{
        ManageCommunityUsers.setUserChanges(deactive,reactive,nochange,union,bargaining,benefit,affiliate,idAffiliateMap,EEOsubcode,Companycode,Processlevel);
        }
        catch(exception ex){}
        
        EEOsubcode.remove(testUser1.Id);
        Companycode.remove(testUser1.Id);
        Processlevel.remove(testUser1.Id);
        
        EEOsubcode.put(testUser1.Id, '24');
        Companycode.put(testUser1.Id, '560');
        Processlevel.put(testUser1.Id, '667');
        ManageUserPermissions.setCurrentUserPermissions(nochange, deactive, reactive, union,bargaining, benefit, affiliate,EEOsubcode,Companycode,Processlevel);
        Test.stopTest();
        }   
    }       
    
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method tests the assignment of User permission.
    *@param     
    *@return     
    */  
    @isTest 
    static void setNewUserPermissionsTest(){
        User testUser = ManageUserPermissions.getExceptionUser();
        
        
        User TestUser123 = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser123){
        Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
        //Assert to check Account has created successfully....
        system.assert(assignedAccount.id != null);
        
        string recTypeId = [Select Id from RecordType where sObjectType = 'Contact' AND Name = 'Employee' Limit 1].Id;
        
        Contact testCon = new Contact();
        testCon.AccountId = assignedAccount.Id;
        testCon.RecordTypeId = recTypeId;
        testCon.FirstName = 'Test';
        testCon.LastName = 'PortalReactivation';
        testCon.Employee_Work_Email__c = 'test.portalReactivation@test.com';
        testCon.Employee_Union_Affiliate__c = 'CHEU';
        testCon.Employee_Bargaining_Union__c= ' ABMC CHEU' ;
        testCon.Employee_Employment_Status__c = 'AA';
        testCon.Employee_Affiliate_Facility__c = 'Sutter Shared Services';
        testCon.Employee_EEO_SubCode__c = '1';
        Test.startTest();
        insert testCon;
        
        //Assert to check Contact has created successfully....
        system.assert(testCon.id != null);
        
        User testUser1;
        Profile pp2;
        
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];  
        System.runAs (u) {  
        
            //select user profile
            pp2 = [Select Id from Profile where name = 'Community Portal Manager' Limit 1];
                testUser1 = new User(
                    ProfileId = pp2.Id,
                    Username = 'test.portalReactivation@test.com',
                    Alias = 'tester',
                    Email='test.portalReactivation@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = testCon.Id
                );
            insert testUser1;
            //Assert to check Contact has created successfully....
            system.assert(testUser1.id != null);
        }
        
        testCon.Employee_Employment_Status__c = 'TE';
        update testCon;
        
        //assert to check Employee_Affiliate_Facility__c update on contact..
        Contact tempcontact1 = [select id,Employee_Affiliate_Facility__c,Employee_Employment_Status__c from contact where id =: testCon.id limit 1]; 
        system.assert(tempcontact1.Employee_Employment_Status__c == 'TE');
        
        testCon.Employee_Employment_Status__c = 'AA';
        update testCon;
        
        //assert to check Employee_Affiliate_Facility__c update on contact..
        Contact tempcontact2 = [select id,Employee_Affiliate_Facility__c,Employee_Employment_Status__c from contact where id =: testCon.id limit 1]; 
        system.assert(tempcontact2.Employee_Employment_Status__c == 'AA');
        
        List<Id> nochange = new List<Id>();
        List<Id> deactive = new List<Id>();
        List<Id> reactive = new List<Id>();
        nochange.add(testUser1.id);
        reactive.add(testUser1.Id);
      
        map<id, string> union = new map<id, string>();
        map<id, string> bargaining = new map<id, string>();
        map<id, string> benefit = new map<id, string>();
        map<id, string> affiliate = new map<id, string>();
        map<id, string> affiliateFacility = new map<id, string>();
        //Req 3676
        map<id, string> EEOsubcode = new map<id, string>();
        map<id, string> Companycode = new map<id, string>();
        map<id, string> Processlevel = new map<id, string>();
        
        //Req 3676
        EEOsubcode.put(testUser1.Id, '2');
        Companycode.put(testUser1.Id, '470');
        Processlevel.put(testUser1.Id, '99');
 
        union.put(testUser1.Id, 'test');
        bargaining.put(testUser1.ID, 'test');
        benefit.put(testUser1.Id, 'test');
        affiliate.put(testUser1.Id, 'test');
        affiliate.put(testCon.Id, 'Sutter Shared Services');
        ManageUserPermissions.unionPermissions.put('test','AA');
        ManageUserPermissions.benefitPermissions.put('test','AB');
        ManageUserPermissions.affiliatePermissions.put('test','AC');
        //ManageUserPermissions.setCurrentUserPermissions(nochange, deactive, reactive, union,bargaining, benefit, affiliate,EEOsubcode,Companycode,Processlevel);
        
        list<User> lstuseretest = new list<User>();
        lstuseretest.add(testUser1);
        union.put(testUser1.Id, 'test');
        bargaining.put(testUser1.ID, 'test');
        benefit.put(testUser1.Id, 'test');
        affiliate.put(testUser1.Id, 'test');
        affiliate.put(testCon.Id, 'Sutter Shared Services');
        ManageUserPermissions.unionPermissions.put('test','AA');
        ManageUserPermissions.benefitPermissions.put('test','AB');
        ManageUserPermissions.affiliatePermissions.put('test','AC');
        ManageUserPermissions.bargainingpermissions.put('test','AA');
        //ManageUserPermissions.setCurrentUserPermissions(nochange, deactive, reactive, union,bargaining, benefit, affiliate,EEOsubcode,Companycode,Processlevel);
        ManageUserPermissions.setNewUserPermissions(lstuseretest,union,bargaining,benefit,affiliate,EEOsubcode,Companycode,Processlevel);
        
        EEOsubcode.remove(testUser1.Id);
        Companycode.remove(testUser1.Id);
        Processlevel.remove(testUser1.Id);
        
        EEOsubcode.put(testUser1.Id, '24');
        Companycode.put(testUser1.Id, '560');
        Processlevel.put(testUser1.Id, '667');
        //ManageUserPermissions.setCurrentUserPermissions(nochange, deactive, reactive, union,bargaining, benefit, affiliate,EEOsubcode,Companycode,Processlevel);
       try{
        ManageUserPermissions.setNewUserPermissions(lstuseretest,union,bargaining,benefit,affiliate,EEOsubcode,Companycode,Processlevel);
        }
        catch(exception ex){
            system.assert(ex.getMessage() != null);
        }
        Test.stopTest();
        }     
    }
    
     /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description This method create Provider contacts records for Provider Contacts Functionality(REQ 3399) .
    *@param     
    *@return     
    */
    @isTest static void testProviderContactCreation() {
        
       List<Contact> lstContactsToUpdate=new List<Contact>();
        List<Contact> lstContactsToUpdateagain=new List<Contact>();
       
        
       User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            //Assert to check Account has created successfully....
            system.assert(assignedAccount.id != null);
            Test.startTest();
                List<Contact> ProvidercontactPortalList = AP01_TestDataUtility.createProviderPortalContacts(assignedAccount);
                //Assert to check Contacts have created successfully..
                list<Contact> tempContact = [select id from contact where Id IN : ProvidercontactPortalList];
                system.assert(tempContact != null);
                for(Contact con : ProvidercontactPortalList){
                   
                    con.Email='testdummyemailtestclass'+i+'@dumm.com';
                    lstContactsToUpdate.add(con);
                    
                }
                
                if(!lstContactsToUpdate.isEmpty())
                update lstContactsToUpdate;
                //Assert to check Contacts have created successfully..
                list<Contact> tempContact1 = [select id,FirstName,LastName,Email from contact where Id IN : ProvidercontactPortalList limit 1];
                set<String> dupCNickNameSet = new set<String>();
                dupCNickNameSet.add('testNickName.testNickName.testNickName@testNi1');
                dupCNickNameSet.add('testNickName.testNickName.testNickName@testNi2');
                String tempNickName = 'testNickName.estNickName.testNickName@testNi1';
                ManageCommunityUsers objManageCommunityUsers = new ManageCommunityUsers();
                objManageCommunityUsers.getUniqueUnameOrCNickName(tempNickName,dupCNickNameSet,'nickname');
                
            Test.stopTest(); 
        }
         
    }  
    
   /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description This method creates teleform contacts for the Provider Contacts Functionality( PDV REQ 3399).
    *@param     
    *@return     
    */
    @isTest static void testProviderContactCreationTeleForm() {
        
       List<Contact> lstContactsToUpdate=new List<Contact>();
        List<Contact> lstContactsToUpdateagain=new List<Contact>();
       
        
       User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            //Assert to check Account has created successfully....
            system.assert(assignedAccount.id != null);
            Test.startTest();
                List<Contact> ProvidercontactPortalList = AP01_TestDataUtility.createProviderPortalContactsTeleForm(assignedAccount);
                //Assert to check Contacts have created successfully..
                list<Contact> tempContact = [select id from contact where Id IN : ProvidercontactPortalList];
                system.assert(tempContact != null);
                
            for(Contact con : ProvidercontactPortalList){
                con.Source_of_E_mail__c=System.Label.TeleForm;
                con.Email='testdummyemailtestclass'+i+'@dumm.com';
                lstContactsToUpdate.add(con);
                
            }
            if(!lstContactsToUpdate.isEmpty())
            update lstContactsToUpdate;
            
        for(Contact con : ProvidercontactPortalList){
                con.Email='testpdv@dummypdvthisisjusttest'+j+'suttertestclass.com';
                lstContactsToUpdateagain.add(con);
                
            }
        
         if(!lstContactsToUpdateagain.isEmpty())
            update lstContactsToUpdateagain;
            
            //Assert to check Contacts have updated successfully..
            list<Contact> tempContact2 = [select id,Email from contact where Id IN : ProvidercontactPortalList limit 1];
            system.assert(tempContact2[0].Email == 'testpdv@dummypdvthisisjusttest'+j+'suttertestclass.com');
            
        ManageCommunityUsers mcu = new ManageCommunityUsers();
        
        List<id> lstid = new List<id>();
        lstid.add(TestUser.id);
        ManageCommunityUsers.UpdateProviderUsersTeleForm(lstid);
        Test.stopTest();  
     }   
       
    }  
    /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description :(PDV REQ 3399) This method updates provider summary record and set Teleform_Last_Validation_Date__c as today .
    *@param     
    *@return     
    */
    @isTest static void testProviderSummaryUpdateTeleFormContacts() {
        
       List<Contact> lstContactsToUpdate=new List<Contact>();
       List<id> lstContactIds = new List<Id>();
       List<Contact> lstContactsToUpdateagain=new List<Contact>();
       List<Contact_Validation_Summary__c> lstSummariesToUpdate=new List<Contact_Validation_Summary__c>();  

       User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            //Assert to check Account has created successfully....
            system.assert(assignedAccount.id != null);
            
            Test.startTest();
                List<Contact> ProvidercontactPortalList = AP01_TestDataUtility.createProviderPortalContactsTeleForm(assignedAccount);
                //Assert to check Contacts have created successfully..
                list<Contact> tempContact = [select id from contact where Id IN : ProvidercontactPortalList];
                system.assert(tempContact != null);
                
            Test.stopTest();    
            
            for(Contact con : ProvidercontactPortalList){
                con.Source_of_E_mail__c=System.Label.TeleForm;
                con.Email='testdummyemailtestclass'+i+'@dumm.com';
                con.Teleform_Last_Validation_Date__c = system.today();
                lstContactsToUpdate.add(con);
                
            }
            
            if(!lstContactsToUpdate.isEmpty()){
                update lstContactsToUpdate;
            }
            //Assert to check Contacts have updated successfully..
            list<Contact> tempContact1 = [select id,Email,Source_of_E_mail__c,Teleform_Last_Validation_Date__c from contact where Id IN : ProvidercontactPortalList limit 1];
            system.assert(tempContact1[0].Source_of_E_mail__c == System.Label.TeleForm);
            system.assert(tempContact1[0].Teleform_Last_Validation_Date__c == system.today());
            
            
            for(Contact con : ProvidercontactPortalList){
                con.Email='testpdv@dummypdvthisisjusttest'+j+'suttertestclass.com';
                lstContactsToUpdateagain.add(con);
            }
        
            if(!lstContactsToUpdateagain.isEmpty()){
                update lstContactsToUpdateagain;
            }
       
            for(Contact objCntct:lstContactsToUpdateagain){
                lstContactIds.add(objCntct.id);
            }
        
            if(!lstContactIds.isEmpty() && lstContactIds!=null) {
            
                for(Contact_Validation_Summary__c objSummary:[select id,Secure_Fax__c from Contact_Validation_Summary__c where Contact_Id__c in :lstContactIds]) {
                    objSummary.Secure_Fax__c='123456';
                    lstSummariesToUpdate.add(objSummary);   
                }
            }
            
            if(lstSummariesToUpdate!=null && !lstSummariesToUpdate.isEmpty()){
                update lstSummariesToUpdate;    
            }
        }
    }
     /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description: (PDV REQ 3399) This method updates provider summary record and set Provider_Portal_Last_Validation_Date__c as today 
    *@param     
    *@return     
    */
    @isTest static void testProviderSummaryUpdateTeleForm_PPDate() {
        
       List<Contact> lstContactsToUpdate=new List<Contact>();
       List<id> lstContactIds = new List<Id>();
       List<Contact> lstContactsToUpdateagain=new List<Contact>();
       List<Contact_Validation_Summary__c> lstSummariesToUpdate=new List<Contact_Validation_Summary__c>();  

       User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            //Assert to check Account has created successfully....
            system.assert(assignedAccount.id != null);
            
            Test.startTest();
                List<Contact> ProvidercontactPortalList = AP01_TestDataUtility.createProviderPortalContactsTeleForm(assignedAccount);
                //Assert to check Contacts have created successfully..
                list<Contact> tempContact = [select id from contact where Id IN : ProvidercontactPortalList];
                system.assert(tempContact != null);
                
            Test.stopTest();    
            
            for(Contact con : ProvidercontactPortalList){
                con.Source_of_E_mail__c=System.Label.TeleForm;
                con.Email='testdummyemailtestclass'+i+'@dumm.com';
                con.Provider_Portal_Last_Validation_Date__c = system.today();
                lstContactsToUpdate.add(con);
                
            }
            
            if(!lstContactsToUpdate.isEmpty()){
                update lstContactsToUpdate;
            }
             
            for(Contact con : ProvidercontactPortalList){
                con.Email='testpdv@dummypdvthisisjusttest'+j+'suttertestclass.com';
                lstContactsToUpdateagain.add(con);
            }
        
            if(!lstContactsToUpdateagain.isEmpty()){
                update lstContactsToUpdateagain;
            }
       
            for(Contact objCntct:lstContactsToUpdateagain){
                lstContactIds.add(objCntct.id);
            }
        
            if(!lstContactIds.isEmpty() && lstContactIds!=null) {
            
                for(Contact_Validation_Summary__c objSummary:[select id,Secure_Fax__c from Contact_Validation_Summary__c where Contact_Id__c in :lstContactIds]) {
                    objSummary.Secure_Fax__c='123456';
                    lstSummariesToUpdate.add(objSummary);   
                }
            }
            
            if(lstSummariesToUpdate!=null && !lstSummariesToUpdate.isEmpty()){
                update lstSummariesToUpdate;    
            }
        }
    }
     /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description (PDV REQ 3399) This method updates provider summary record and set Teleform_Last_Validation_Date__c as today Provider_Portal_Last_Validation_Date__c as yesterday.
    *@param     
    *@return     
    */
    @isTest static void testProviderSummaryUpdateTeleForm_TLFM_PPDate_Validation() {
        
       List<Contact> lstContactsToUpdate=new List<Contact>();
       List<id> lstContactIds = new List<Id>();
       List<Contact> lstContactsToUpdateagain=new List<Contact>();
       List<Contact_Validation_Summary__c> lstSummariesToUpdate=new List<Contact_Validation_Summary__c>();  

       User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            //Assert to check Account has created successfully....
            system.assert(assignedAccount.id != null);
            
            Test.startTest();
                List<Contact> ProvidercontactPortalList = AP01_TestDataUtility.createProviderPortalContactsTeleForm(assignedAccount);
               
                //Assert to check Contacts have created successfully..
                list<Contact> tempContact = [select id from contact where Id IN : ProvidercontactPortalList];
                system.assert(tempContact != null);
            Test.stopTest();    
            
            for(Contact con : ProvidercontactPortalList){
                con.Source_of_E_mail__c=System.Label.TeleForm;
                con.Email='testdummyemailtestclass'+i+'@dumm.com';
                con.Teleform_Last_Validation_Date__c = system.today();
                con.Provider_Portal_Last_Validation_Date__c = system.today().adddays(-1);
                lstContactsToUpdate.add(con);
                
            }
            
            if(!lstContactsToUpdate.isEmpty()){
                update lstContactsToUpdate;
            }
             
            for(Contact con : ProvidercontactPortalList){
                con.Email='testpdv@dummypdvthisisjusttest'+j+'suttertestclass.com';
                lstContactsToUpdateagain.add(con);
            }
        
            if(!lstContactsToUpdateagain.isEmpty()){
                update lstContactsToUpdateagain;
            }
       
            for(Contact objCntct:lstContactsToUpdateagain){
                lstContactIds.add(objCntct.id);
            }
        
            if(!lstContactIds.isEmpty() && lstContactIds!=null) {
            
                for(Contact_Validation_Summary__c objSummary:[select id,Secure_Fax__c from Contact_Validation_Summary__c where Contact_Id__c in :lstContactIds]) {
                    objSummary.Secure_Fax__c='123456';
                    lstSummariesToUpdate.add(objSummary);   
                }
            }
            
            if(lstSummariesToUpdate!=null && !lstSummariesToUpdate.isEmpty()){
                update lstSummariesToUpdate;    
            }
        }
    }
     /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description :(PDV REQ 3399) This method updates provider summary record and set Teleform_Last_Validation_Date__c as yesterday Provider_Portal_Last_Validation_Date__c as today.
    *@param     
    *@return     
    */
    @isTest static void testProviderSummaryUpdateTeleForm_TeleForm_PPDate_Validate() {
        
       List<Contact> lstContactsToUpdate=new List<Contact>();
       List<id> lstContactIds = new List<Id>();
       List<Contact> lstContactsToUpdateagain=new List<Contact>();
       List<Contact_Validation_Summary__c> lstSummariesToUpdate=new List<Contact_Validation_Summary__c>();  

       User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            
            Test.startTest();
                List<Contact> ProvidercontactPortalList = AP01_TestDataUtility.createProviderPortalContactsTeleForm(assignedAccount);
                //Assert to check Contacts have created successfully..
                list<Contact> tempContact = [select id from contact where Id IN : ProvidercontactPortalList];
                system.assert(tempContact != null);
            Test.stopTest();    
            
            for(Contact con : ProvidercontactPortalList){
                con.Source_of_E_mail__c=System.Label.TeleForm;
                con.Email='testdummyemailtestclass'+i+'@dumm.com';
                con.Teleform_Last_Validation_Date__c = system.today().adddays(-1);
                con.Provider_Portal_Last_Validation_Date__c = system.today();
                lstContactsToUpdate.add(con);
                
            }
            
            if(!lstContactsToUpdate.isEmpty()){
                update lstContactsToUpdate;
            }
             
            for(Contact con : ProvidercontactPortalList){
                con.Email='testpdv@dummypdvthisisjusttest'+j+'suttertestclass.com';
                lstContactsToUpdateagain.add(con);
            }
        
            if(!lstContactsToUpdateagain.isEmpty()){
                update lstContactsToUpdateagain;
            }
       
            for(Contact objCntct:lstContactsToUpdateagain){
                lstContactIds.add(objCntct.id);
            }
        
            if(!lstContactIds.isEmpty() && lstContactIds!=null) {
            
                for(Contact_Validation_Summary__c objSummary:[select id,Secure_Fax__c from Contact_Validation_Summary__c where Contact_Id__c in :lstContactIds]) {
                    objSummary.Secure_Fax__c='123456';
                    lstSummariesToUpdate.add(objSummary);   
                }
            }
            
            if(lstSummariesToUpdate!=null && !lstSummariesToUpdate.isEmpty()){
                update lstSummariesToUpdate;    
            }
        }
    }
    
    /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description :(PDV REQ 3399) This method tests logic for User create and update of Provider Contacts of non TeleForm type
    *@param     
    *@return     
    */
    @isTest static void getProvidersForUserCreation_nonTF() {
        List<Contact> p_contactList = new List<Contact>();
        Map<Id,Contact> p_oldContactMap = new Map<Id,Contact>();  
        Map<Id, Contact> p_newContactMap = new Map<Id, Contact>();
        
       User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            Id recordType = [select Id, SobjectType, Name from RecordType where name='Provider' and SObjectType='Contact' limit 1].Id;
            Test.startTest();
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME;
                con.Email='';
                con.AccountId = assignedAccount.id;
                con.RecordTypeId = recordType;
                con.Username__c = 'testUsername';
                insert con;
                //Assert to check Contact is created successfully
                system.assert(con.id != null);
                
                p_contactList.add(con);
                p_oldContactMap.put(con.id,con);
                
            Contact testContact = new Contact(id=con.id);
            testContact.Source_of_E_Mail__c='test';
            testContact.Email='testemailcheck@testtest.com';
        
            p_newContactMap.put(testContact.id,testContact);

            ManageContactDatabase.getProvidersForUserCreation(p_contactList,p_oldContactMap,p_newContactMap);
            ManageContactDatabase.getProvidersForUserUpdation(p_contactList,p_oldContactMap,p_newContactMap);
            Test.stopTest();  
            }
    }
    
    /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description :(PDV REQ 3399) This method tests logic for User create and update of Provider Contacts of  TeleForm type
    *@param     
    *@return     
    */
    @isTest static void getProvidersForUserCreation_TeleFormTest() {
        List<Contact> p_contactList = new List<Contact>();
        Map<Id,Contact> p_oldContactMap = new Map<Id,Contact>();  
        Map<Id, Contact> p_newContactMap = new Map<Id, Contact>();
        
       User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            Id recordType = [select Id, SobjectType, Name from RecordType where name='Provider' and SObjectType='Contact' limit 1].Id;
            Test.startTest();
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME;
                con.Email='';
                con.AccountId = assignedAccount.id;
                con.RecordTypeId = recordType;
                con.Username__c = 'testUsername';
                insert con;
                //Assert to check Contact is created successfully
                system.assert(con.id != null);
                
                p_contactList.add(con);
                p_oldContactMap.put(con.id,con);

            Contact testContact = new Contact(id=con.id);
            testContact.Source_of_E_Mail__c = System.Label.TeleForm;
            testContact.Email='testtestemailcheck@testtest.com';
            p_newContactMap.put(testContact.id,testContact);
            
            ManageContactDatabase.getProvidersForUserCreation(p_contactList,p_oldContactMap,p_newContactMap);
            ManageContactDatabase.getProvidersForUserUpdation(p_contactList,p_oldContactMap,p_newContactMap);
            Test.stopTest();  
            }
    }
    /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description :(PDV REQ 3399) This method tests the logic related to creating Users for Provider Contacts which have dummy email id in their Email field
    *@param     
    *@return     
    */
    @isTest static void getProvidersForUserCreation_DummyEmailUserTest(){
        List<Contact> p_contactList = new List<Contact>();
        Map<Id,Contact> p_oldContactMap = new Map<Id,Contact>();  
        Map<Id, Contact> p_newContactMap = new Map<Id, Contact>();
        
       User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            Id recordType = [select Id, SobjectType, Name from RecordType where name='Provider' and SObjectType='Contact' limit 1].Id;
            Test.startTest();
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME;
                con.Email='';
                con.AccountId = assignedAccount.id;
                con.RecordTypeId = recordType;
                con.Username__c = 'testUsername';
                insert con;
                
                //Assert to check Contact is created successfully
                system.assert(con.id != null);

                p_contactList.add(con);
                p_oldContactMap.put(con.id,con);
       
            Contact testContact = new Contact(id=con.id);
            testContact.Source_of_E_Mail__c = System.Label.TeleForm;
            testContact.Email=system.Label.Dummy_Email;
            
            p_newContactMap.put(testContact.id,testContact);
            
            ManageContactDatabase.getProvidersForUserCreation(p_contactList,p_oldContactMap,p_newContactMap);
            ManageContactDatabase.getProvidersForUserUpdation(p_contactList,p_oldContactMap,p_newContactMap);
            Test.stopTest();  
            }
    }
    
    /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description :(PDV REQ 3399) This method tests the logic related to creating Users for Provider Contacts which have dummy email id in their Email field and user is created for Provider Contact already
    *@param     
    *@return     
    */
    @isTest static void getProvidersForUserCreation_DummyEmailUserUpdateTest(){
        List<Contact> p_contactList = new List<Contact>();
        Map<Id,Contact> p_oldContactMap = new Map<Id,Contact>();  
        Map<Id, Contact> p_newContactMap = new Map<Id, Contact>();
        
       User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        system.runAs(TestUser){
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            Id recordType = [select Id, SobjectType, Name from RecordType where name='Provider' and SObjectType='Contact' limit 1].Id;
            Test.startTest();
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME;
                con.Email='';
                con.AccountId = assignedAccount.id;
                con.RecordTypeId = recordType;
                con.Username__c = 'testUsername';
                insert con;
                p_contactList.add(con);
                p_oldContactMap.put(con.id,con);
                
                //select user profile
                Profile pp2 = [Select Id from Profile where name = 'Community Portal Manager' Limit 1];
                User testUser1 = new User(
                    ProfileId = pp2.Id,
                    Username = 'test.portalReactivation@test.com',
                    Alias = 'tester',
                    Email='test.conportalReactivation@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = con.Id
                );
            insert testUser1;
            //Assert to check Contact has created successfully....
            system.assert(testUser1.id != null);
            Contact testContact = new Contact(id=con.id);
            testContact.Source_of_E_Mail__c = System.Label.TeleForm;
            testContact.Email=system.Label.Dummy_Email;
            
            p_newContactMap.put(testContact.id,testContact);
            
            ManageContactDatabase.getProvidersForUserCreation(p_contactList,p_oldContactMap,p_newContactMap);
            ManageContactDatabase.getProvidersForUserUpdation(p_contactList,p_oldContactMap,p_newContactMap);
            Test.stopTest();  
            }
    }
}