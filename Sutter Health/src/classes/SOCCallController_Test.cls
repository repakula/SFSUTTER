/**    
*     Class Name  : SOCCallController_Test
*     Author      : IDC Offshore  
*     Date        : 28/09/2015 
*     Project Name: CRM - SFT - Sutter Health  
*     Description : Test Class for SOCCallController Class. This class validate  functionality of SOCCallController class's all methods. 
**/
@isTest
private class SOCCallController_Test{
    /**
    * @author IDC Team
    * @date 28/09/2015
    * @description :method to create test data used by all tests 
    * @param 
    * @return void
    */
    @testSetup 
    static void createTestData() {
        User TestUser = CreateUser();
        //create Account
        Account acc =  SOCCallController_Test.createAccount();
        insert acc;
        
        //Assert to check if Account record has been created successfully 
        system.assert(acc.id != null);
        
        //Create Provider 
        Contact provider  = SOCCallController_Test.createProvider();
        provider.AccountId = acc.Id;
        database.insert(provider,false);
        
        //Assert to check if Contact record has been created successfully 
        system.assert(provider.id != null);
        
        //Create Custom Setting containing Profile Names
        list<CS_ManageProfile__c> lstCS_ManageProfile = new list<CS_ManageProfile__c>();
        CS_ManageProfile__c objCS_ManageProfile1 = new CS_ManageProfile__c(Name = 'Communities_Portal',Profile_Name__c = 'Community Portal');
        lstCS_ManageProfile.add(objCS_ManageProfile1);
        CS_ManageProfile__c objCS_ManageProfile2 = new CS_ManageProfile__c(Name = 'Communities_Provider',Profile_Name__c = 'PDV Community Provider');
        lstCS_ManageProfile.add(objCS_ManageProfile2);
        
        CS_ManageProfile__c objCS_ManageProfile3 = new CS_ManageProfile__c(Name = 'Community_Portal_Manager',Profile_Name__c = 'Community Portal Manager');
        lstCS_ManageProfile.add(objCS_ManageProfile3);
        
        insert lstCS_ManageProfile;

        //Assert to check if CS_ManageProfile__c Custom Setting record has been created successfully 
        list<CS_ManageProfile__c> templstCS_ManageProfile = CS_ManageProfile__c.getAll().values();
        system.assert(templstCS_ManageProfile != null);
        
        // Create Case
        Case socCase = SOCCallController_Test.createCase();
        socCase.ContactId = provider.Id;
        database.insert(socCase,false);
        
        //Assert to check if Case record has been created successfully 
        system.assert(socCase.id != null);
        
        //Create Facility
        PDV_EAF_Facility__c facility  = SOCCallController_Test.createFacility();
        facility.Case__c = socCase.Id;
        facility.Last_Verified_Date__c = system.today();
        database.insert(facility,false);
        
        
        //Assert to check if PDV_EAF_Facility__c record has been created successfully 
        system.assert(facility.id != null);
        
        // create SOC_Queue__c
        SOC_Queue__c socQueue  = SOCCallController_Test.createSOCQueue();
        socQueue.Associated_Case_Id__c = socCase.Id;
        socQueue.Facility_Id__c = facility.Id;
        socQueue.Provider_Facility_ID__c = provider.Id;
        socQueue.Printed_Id__c = 'Test PrintedId';
        socQueue.status__c = 'Sent';
        database.insert(socQueue,false); 
        
        //Assert to check if SOC_Queue__c record has been created successfully 
        system.assert(socQueue.id != null);
        
        //insert a test User 
        User testRunUser1;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            UserRole portalRole = [Select Id From UserRole Where Name = 'SOC Agents' Limit 1];  
            //select user profile
            Profile pp1 = [Select Id from Profile where name = 'System Administrator' Limit 1];
            testRunUser1 = new User(
                ProfileId = pp1.Id,
                Username = 'tester4999_nky@test.com',
                UserRoleId = portalRole.Id,
                Alias = 'tester',
                Email='tester49_nky888@test.com',
                EmailEncodingKey='UTF-8',
                Firstname='One',
                Lastname='Tester',
                CommunityNickname = 'tester49899888_nky',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Los_Angeles'
            );
            insert testRunUser1;
        }
        // assert to check user is created successfully
        System.AssertEquals(testRunUser1.Username,'tester4999_nky@test.com');
        
    }
        
    /**
    * @author IDC Team
    * @date 28/09/2015
    * @description :method to create test user 
    * @param 
    * @return user
    */
    Public static User CreateUser(){
        User testRunUser1;
         User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
        UserRole portalRole = [Select Id From UserRole Where Name = 'MU Agent' Limit 1]; 
        //select user profile
        Profile pp1 = [Select Id from Profile where name = 'System Administrator' Limit 1];
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
        insert testRunUser1;
        }
        System.AssertEquals(testRunUser1.Username,'tester49_nky@test.com');
        return testRunUser1;
    }
    
    
    /**
    * @author IDC Team
    * @date 28/09/2015
    * @description :method to create SOC_Queue__c object record 
    * @param 
    * @return SocQueue
    */
    public static SOC_Queue__c createSOCQueue(){
        SOC_Queue__c socQueue = new SOC_Queue__c(Name = 'Test SOC' );
        socQueue.status__c = 'Accepted'; 
        return socQueue;
    }
    /**
    * @author IDC Team
    * @date 28/09/2015
    * @description :method to create Provider type contact
    * @param 
    * @return Provider contact
    */
    
    public static Contact createProvider(){
        RecordType recTypecont = [select Id from RecordType where Name = 'Provider' and sObjectType = 'Contact'];
        
        Contact provider = new Contact();
        provider.FirstName ='Test';
        provider.LastName = 'Provider';
        provider.RecordTypeId = recTypecont.Id;
        provider.email= 'test@test.com';
        provider.Provider_Title__c ='';
        provider.MobilePhone ='';
        provider.Provider_Correspondence_Address__c='testing';
        provider.Provider_Correspondence_City__c='testing';
        provider.Provider_Correspondence_State__c ='testing';
        provider.Provider_Correspondence_PostalCode__c='12345';
        provider.Provider_Correspondence_Phone__c='1234567890';
        provider.Provider_Correspondence_Fax_Number__c='1234567890';
        provider.Contact_External_ID1__c ='123456';
        provider.Provider_Practicing_Physician__c = true;
        provider.Provider_Active_Status__c = true;
        provider.Provider_Active_Status_Date__c = system.today();
        
        return provider;
    }
    /**
    * @author IDC Team
    * @date 28/09/2015
    * @description :method to Create PDV_EAF_Facility__c  record
    * @param 
    * @return PDV_EAF_Facility__c record
    */
    public static PDV_EAF_Facility__c createFacility(){
        PDV_EAF_Facility__c facility = new PDV_EAF_Facility__c();
        facility.Name = 'Test Facility';
        facility.CITY__c = 'FOLSOM';
        facility.ADDRESS__c ='1200 CREEKSIDE DR';
        facility.ZIP_CODE__c ='95630';
        facility.Suite__c  = '123 Suite';
        facility.Floor__c = '3 Floor';
        facility.STATE__c = 'Test State';
        facility.Attn_To__c = 'Test AttnTo';
        facility.Names_Changes_Suggested__c = 'test Change';
        
        return facility;
    }
    /**
    * @author IDC Team
    * @date 28/09/2015
    * @description :method to SOC case  record
    * @param 
    * @return SOC case 
    */
    public static Case createCase(){
        RecordType recType = [select Id from RecordType where DeveloperName = 'Summary_of_Care' and sObjectType = 'Case'];
        
        Case socCase = new Case();
        socCase.RecordTypeId = recType.Id;
        socCase.subject = 'Test Case';
        socCase.description =  'Test Case';
        socCase.Provider_Name__c = 'Test Provider';
        socCase.Provider_Type__c = 'Provider';   //Facility and Provider
        socCase.PDV_Contact_Name__c = 'Test Provider';
        socCase.Contact_Number__c = Integer.valueOf('1234567890');
        
        return socCase;
    }
    /**
    * @author IDC Team
    * @date 28/09/2015
    * @description :method to create test Account
    * @param 
    * @return account 
    */
    public static Account createAccount(){
        Account acc = new Account(Name='Test Account Name');
        acc.RecordTypeId = [Select Id from RecordType Where Name = 'S3 Employee' AND sObjectType ='Account'].Id;
        
        return acc;
    }
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate setAddressParam,saveUpdatedAddress,validateAddress,deleteAddress,createNewAddress,updateSOCStatus.updateCase,updateCaseMU,updateSummaryInfo methods for Closed case and document status is sent in SOCCallController class
    * @return void             
    */ 
    static testMethod void providerInfoValidationTest() {
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];

            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id,Provider_Facility_ID__c from SOC_Queue__c where Name = 'Test SOC'];
            
            Contact_Validation_Summary__c summaryObj = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id];
            summaryObj.Mobile_Phone__c = '(999) 999-9999';
            summaryObj.Secure_FAX__c  = '(999) 999-9999';
            summaryObj.Secure_Zip_Code__c = '12345';
            summaryObj.Secure_City__c = 'Test City';
            summaryObj.New_Street_Address__c = '123 Test';
            summaryObj.Secure_Phone__c = '(999) 999-9999';
            summaryObj.Secure_Suite__c = 'STE';
            summaryObj.Secure_Floor__c = 'FL';
            summaryObj.Contact_Id__c = provider.Id;
            
            update summaryObj;
            
            //Assert check
            System.AssertEquals(summaryObj.Secure_City__c,'Test City');
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            //Assert check to validate MU_Object__c is created successfully...
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            SOCCallController  SOC = new SOCCallController(controller);
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            String summaryId = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id].ID;
            soc.addressRecordId = summaryObj.id;
            soc.checkAllparameters();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.createCase();
            soc.fillContactName();
            soc.hideOverlayDivCall();
            
            //populate validate page data
            soc.saveUpdatedAddress();
            soc.newAddress.strStreetAddress ='1200 CREEKSIDE DR';
            soc.newAddress.strPhone='(999) 999-9999';
            soc.phoneCheck = true;
            soc.newAddress.strFax ='12345678999999';
            soc.faxCheck = true;
            soc.newAddress.strCity = 'FOLSOM';
            soc.newAddress.strZipcode ='95630';
            soc.newAddress.strMobilePhone = '(999) 999-9999';
            soc.newAddress.strPhone = '(999) 999-9999';
            soc.newAddress.strFax  = '(999) 999-9999';
            soc.newAddress.strSuite  = '123 Suite';
            soc.newAddress.strFloor = '3 Floor';
            soc.saveUpdatedAddress();
            
            soc.phoneCheck = false;
            soc.faxCheck = false;
            soc.addressRecordId = summaryObj.id;
            soc.setAddressParam();
            soc.saveUpdatedAddress();
            
            Contact_Validation_Audit_Trail__c auditObj = new Contact_Validation_Audit_Trail__c();
            auditObj.Address_Type__c = 'Primary';
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.Provider_Information_Summary__c = summaryObj.id;
            auditObj.Contact_Id__c  = provider.Id;
            insert auditObj;
            
            soc.phoneCheck = false;
            soc.faxCheck = false;
            soc.addressRecordId = summaryObj.id;
            soc.setAddressParam();
            soc.saveUpdatedAddress();
            soc.wrAddressValidationlist[0].isSelected = true; 
            soc.validateAddress();
            
            soc.wrAddressValidationlist[0].isSelected = true;
            soc.prefix = '004';
            soc.addressRecordId = summaryObj.id;
            soc.deleteAddress();
            soc.createNewAddress();
            soc.updateSOCStatus();
            soc.updateCase();
            soc.caseObj.Common_Subject_Lines__c = '';
            soc.caseObj.Validated_or_not__c = 'Yes';
            soc.caseObj.SOC_Document_Status__c = 'Not Sent';
            soc.caseObj.Communication_Preference_Changed_To_Fax__c = 'Yes';
            soc.caseObj.PDV_Contact_Name__c = 'Test';
            soc.strCaseContactPhoneNumber = '9811001100';
            soc.updateCase();
            soc.updateCaseMU();
            soc.updateSummaryInfo();
            
            summaryObj.Mobile_Phone__c = '(999) 999-9999';
            summaryObj.Secure_FAX__c  = '(999) 999-9999';
            summaryObj.Secure_Zip_Code__c = '12345';
            summaryObj.Secure_City__c = 'Test City';
            summaryObj.New_Street_Address__c = '123 Test';
            summaryObj.Secure_Phone__c = '(999) 999-9999';
            summaryObj.Secure_Suite__c = 'test';
            summaryObj.Secure_Floor__c = 'test';
            update summaryObj;
            soc.updateSummaryInfo();
            soc.cancelCase();
            SOC.backToCasesMU();
            soc.wrAddressValidationlist[0].isSelected = true;
            SOC.printAddressMethod();
            SOC.updateSOCStatusToPrint();
            SOC.approveCase();
            SOC.rejectCase();
            SOC.updateCase();
            SOC.strCaseContactPhoneNumber = '(999) 999-9999';
            soc.caseObj.Communication_Preference_Changed_To_Fax__c = 'No';
            SOC.approveCase();
            SOC.rejectCase();
            SOC.updateCase();
            SOC.prefix = '003';
            SOC.caseObj.Communication_Preference_Changed_To_Fax__c = '';
            SOC.caseObj.Status = '';
            SOC.rejectCase();
            SOC.approveCase();
            SOC.updateCase();
            SOC.caseObj.PDV_Escalation_Reason__c = '';
            SOC.caseObj.Status = 'Escalate To Meaningful Use';
            SOC.caseObj.SOC_Document_Status__c = 'Sent';
            
            SOC.rejectCase();
            SOC.approveCase();
            SOC.updateCase();
            SOC.caseObj.Status = 'testCannot Reach';
            SOC.caseObj.PDV_Contact_Name__c = '';
            SOC.strCaseContactPhoneNumber = '';
            SOC.caseObj.Validated_or_not__c = '';
            SOC.rejectCase();
            SOC.approveCase();
            SOC.updateCase();
            SOC.strCaseContactPhoneNumber = '123456';
            SOC.rejectCase();
            SOC.approveCase();
            SOC.updateCase();
            SOC.caseMUReason = 'Test';
            SOC.caseMUStatus = 'Test1';
            soc.updateCaseMU();
            Test.stopTest();
        }
    }
    
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate setAddressParam,saveUpdatedAddress,validateAddress,deleteAddress,createNewAddress,updateSOCStatus.updateCase,updateCaseMU,updateSummaryInfo methods of SOCCallController class.
    * @return void             
    */ 
    static testMethod void providerInformationValidationTest() {
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];

            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
            facility.Serial_Number__c = 2;
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id,Provider_Facility_ID__c from SOC_Queue__c where Name = 'Test SOC'];
            
            Contact_Validation_Summary__c summaryObj = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id];
            summaryObj.Mobile_Phone__c = '(999) 999-9999';
            summaryObj.Secure_FAX__c  = '(999) 999-9999';
            summaryObj.Secure_Zip_Code__c = '12345';
            summaryObj.Secure_City__c = 'Test City';
            summaryObj.New_Street_Address__c = '123 Test';
            summaryObj.Secure_Phone__c = '(999) 999-9999';
            summaryObj.Secure_Suite__c = 'STE';
            summaryObj.Secure_Floor__c = 'FL';
            summaryObj.Contact_Id__c = provider.Id;
            
            update summaryObj;
            
            //Assert check
            System.AssertEquals(summaryObj.Secure_City__c,'Test City');
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            //Assert check to validate MU_Object__c is created successfully...
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            SOCCallController  SOC = new SOCCallController(controller);
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            String summaryId = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id].ID;
            soc.addressRecordId = summaryObj.id;
            soc.checkAllparameters();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.createCase();
            soc.fillContactName();
            soc.hideOverlayDivCall();
            
            //populate validate page data
            soc.saveUpdatedAddress();
            soc.newAddress.strStreetAddress ='1200 Brookfield DR';
            soc.newAddress.strPhone='(999) 989-9999';
            soc.phoneCheck = true;
            soc.newAddress.strFax ='(987) 456-1230';
            soc.faxCheck = true;
            soc.newAddress.strCity = 'FOLSOM1';
            soc.newAddress.strZipcode ='95630';
            soc.newAddress.strMobilePhone = '(999) 999-9999';
            soc.newAddress.strPhone = '(999) 999-9999';
            soc.newAddress.strFax  = '(999) 999-9999';
            soc.newAddress.strSuite  = '123 Suite';
            soc.newAddress.strFloor = '3 Floor';
            soc.saveUpdatedAddress();
            
            soc.phoneCheck = false;
            soc.faxCheck = false;
            soc.addressRecordId = summaryObj.id;
            soc.setAddressParam();
            soc.saveUpdatedAddress();
            
            Contact_Validation_Audit_Trail__c auditObj = new Contact_Validation_Audit_Trail__c();
            auditObj.Address_Type__c = 'Primary';
            auditObj.Serial_Number__c = '2';
            auditObj.Case__c = socCase.id;
            auditObj.Provider_Information_Summary__c = summaryObj.id;
            auditObj.Contact_Id__c  = provider.Id;
            insert auditObj;
            
            soc.phoneCheck = false;
            soc.faxCheck = false;
            soc.addressRecordId = summaryObj.id;
            soc.setAddressParam();
            soc.saveUpdatedAddress();
            soc.wrAddressValidationlist[0].isSelected = true; 
           // soc.validateAddress();
            
            soc.wrAddressValidationlist[0].isSelected = true;
            soc.prefix = '004';
            soc.addressRecordId = summaryObj.id;
            soc.deleteAddress();
            soc.createNewAddress();
            soc.updateSOCStatus();
            soc.updateCase();
            soc.caseObj.Common_Subject_Lines__c = '';
            soc.caseObj.Validated_or_not__c = 'Yes';
            soc.caseObj.SOC_Document_Status__c = 'Not Sent';
            soc.caseObj.Communication_Preference_Changed_To_Fax__c = 'Yes';
            soc.caseObj.PDV_Contact_Name__c = 'Test';
            soc.strCaseContactPhoneNumber = '9811001100';
            soc.updateCase();
            soc.updateCaseMU();
            soc.updateSummaryInfo();
            
            summaryObj.Mobile_Phone__c = '(999) 989-9999';
            summaryObj.Secure_FAX__c  = '(999) 989-9999';
            summaryObj.Secure_Zip_Code__c = '12345';
            summaryObj.Secure_City__c = 'Test City2';
            summaryObj.New_Street_Address__c = '124 Test';
            summaryObj.Secure_Phone__c = '(999) 999-9999';
            summaryObj.Secure_Suite__c = 'test1';
            summaryObj.Secure_Floor__c = 'test1';
            update summaryObj;
            soc.updateSummaryInfo();
            soc.cancelCase();
            SOC.backToCasesMU();
            soc.wrAddressValidationlist[0].isSelected = true;
            SOC.printAddressMethod();
            SOC.updateSOCStatusToPrint();
            SOC.approveCase();
            SOC.rejectCase();
            SOC.updateCase();
            soc.getAddressValidation();
            
            
            SOC.strCaseContactPhoneNumber = '(999) 999-9999';
            soc.caseObj.Communication_Preference_Changed_To_Fax__c = 'Yes';
            SOC.approveCase();
            SOC.rejectCase();
            SOC.updateCase();
            SOC.prefix = '003';
            SOC.caseObj.Communication_Preference_Changed_To_Fax__c = 'Yes';
            SOC.caseObj.Status = '';
            SOC.rejectCase();
            SOC.approveCase();
            SOC.updateCase();
            SOC.caseObj.PDV_Escalation_Reason__c = '';
            SOC.caseObj.Status = 'Closed';
            SOC.caseObj.SOC_Document_Status__c = 'Sent';
            
            soc.saveUpdatedAddress();
            SOC.rejectCase();
            SOC.approveCase();
            SOC.updateCase();
            SOC.caseObj.Status = 'Cannot Reach';
            SOC.caseObj.PDV_Contact_Name__c = '';
            SOC.strCaseContactPhoneNumber = '';
            SOC.caseObj.Validated_or_not__c = '';
            SOC.rejectCase();
            SOC.approveCase();
            SOC.updateCase();
            SOC.strCaseContactPhoneNumber = '123456';
            SOC.rejectCase();
            SOC.approveCase();
            SOC.updateCase();
            SOC.caseMUReason = 'Test';
            SOC.caseMUStatus = 'Test1';
            soc.updateCaseMU();
            Test.stopTest();
        }
    }
    
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate various cases of address(like email,mobile ,street address ) and cover various scenerios of saveUpdatedAddress,fillContactName,createCase,acceptSOCCall,createSOCCall,checkAllparameters methods of SOCCallController class.
    * @return void             
    */ 
    static testMethod void providerAddressValidationTest() {
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id,Provider_Facility_ID__c from SOC_Queue__c where Name = 'Test SOC'];
            
            Contact_Validation_Summary__c summaryObj = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id];
            summaryObj.Mobile_Phone__c = '(999) 999-9999';
            summaryObj.Secure_FAX__c  = '(999) 999-9999';
            summaryObj.Secure_Zip_Code__c = '12345';
            summaryObj.Secure_City__c = 'Test City'; 
            summaryObj.New_Street_Address__c = '123 Test';
            summaryObj.Secure_Phone__c = '(999) 999-9999';
            summaryObj.Secure_Suite__c = 'STE';
            summaryObj.Secure_Floor__c = 'FL';
            summaryObj.Contact_Id__c = provider.Id;
            
            update summaryObj;
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            SOCCallController  SOC = new SOCCallController(controller);
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            String summaryId = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id].ID;
            soc.addressRecordId = summaryObj.id;
            soc.checkAllparameters();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.createCase();
            soc.fillContactName();
            soc.hideOverlayDivCall();
            
            //populate validate page data
            soc.saveUpdatedAddress();
            soc.newAddress.strStreetAddress ='1200 CREEKSIDE DR';
            soc.newAddress.strPhone='(999) 999-9999';
            soc.phoneCheck = true;
            soc.newAddress.strFax ='12345678999999';
            soc.faxCheck = true;
            soc.newAddress.strCity = 'FOLSOM';
            soc.newAddress.strZipcode ='95630';
            soc.newAddress.strMobilePhone = '(999) 999-9999';
            soc.newAddress.strPhone = '(999) 999-9999';
            soc.newAddress.strFax  = '(999) 999-9999';
            soc.newAddress.strSuite  = '123 Suite';
            soc.newAddress.strFloor = '3 Floor';
            soc.prefix = '003';
            soc.saveUpdatedAddress();
            soc.prefix = '004';
            soc.saveUpdatedAddress();
            soc.newAddress.strEmail = 'test$%^^&test.com';
            soc.newAddress.strMobilePhone = '123456';
            soc.newAddress.strStreetAddress ='$%#$%^^&';
            soc.newAddress.strAddressType ='Primary';
            soc.prefix = '003';
            soc.saveUpdatedAddress();
            soc.prefix = '004';
            soc.saveUpdatedAddress();
            soc.newAddress.strStreetAddress ='1200 Post Office CREEKSIDE DR';
            soc.prefix = '004';
            soc.saveUpdatedAddress();
            soc.newAddress.strStreetAddress ='1200 C\\O CREEKSIDE DR';
            soc.saveUpdatedAddress();
            soc.newAddress.strStreetAddress ='1200 Suite CREEKSIDE DR';
            soc.saveUpdatedAddress();
            soc.newAddress.strStreetAddress ='1200 P O BOX CREEKSIDE DR';
            soc.prefix = '004';
            soc.newAddress.strPhone = '12345';
            soc.newAddress.strFax = '12345';
            soc.newAddress.strState = 'None';
            soc.newAddress.strPhoneExt = 'RRRERZ';
            soc.newAddress.strSuite = 'P O Box';
            soc.newAddress.strFloor = 'P O Box';
            soc.saveUpdatedAddress();
            soc.prefix = '004';
            soc.newAddress.strSuite = 'C\\O test';
            soc.newAddress.strFloor = 'C\\O test';
            soc.saveUpdatedAddress();
            
            Test.stopTest();
        }
    } 
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate  negative cases of saveUpdatedAddress,fillContactName,createCase,acceptSOCCall,createSOCCall,checkAllparameters methods of SOCCallController class.
    * @return void             
    */ 
    static testMethod void providerInfoValidationTest_Negative(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id,Provider_Facility_ID__c from SOC_Queue__c where Name = 'Test SOC'];
            
            Contact_Validation_Summary__c summaryObj = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id];
            summaryObj.Mobile_Phone__c = '(999) 999-9999';
            summaryObj.Secure_FAX__c  = '(999) 999-9999';
            summaryObj.Secure_Zip_Code__c = '12345';
            summaryObj.Secure_City__c = 'Test City'; 
            summaryObj.New_Street_Address__c = '123 Test';
            summaryObj.Secure_Phone__c = '(999) 999-9999';
            summaryObj.Secure_Suite__c = 'STE';
            summaryObj.Secure_Floor__c = 'FL';
            summaryObj.Contact_Id__c = provider.Id;
            
            update summaryObj;
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            //Assert check to validate MU_Object__c is created successfully...
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            SOCCallController  SOC = new SOCCallController(controller);
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            String summaryId = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id].ID;
            soc.addressRecordId = summaryObj.id;
            soc.checkAllparameters();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.createCase();
            soc.fillContactName();
            soc.hideOverlayDivCall();
            
            //populate validate page data
            soc.addressRecordId = facility.id;
            soc.newAddress.strStreetAddress ='1200 CREEKSIDE DR';
            soc.newAddress.strPhone='(999) 999-9999';
            soc.phoneCheck = true;
            soc.newAddress.strFax ='12345678999999';
            soc.faxCheck = true;
            soc.newAddress.strCity = 'FOLSOM';
            soc.newAddress.strZipcode ='95630';
            soc.newAddress.strMobilePhone = '(999) 999-9999';
            soc.newAddress.strPhone = '(999) 999-9999';
            soc.newAddress.strFax  = '(999) 999-9999';
            soc.newAddress.strSuite  = '123 Suite';
            soc.newAddress.strFloor = '3 Floor';
            soc.prefix = '004';
            soc.saveUpdatedAddress();
            Test.stopTest();
        }
    }
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate various negative cases of address(like fax,floor ,address ) and cover various scenerios of saveUpdatedAddress,fillContactName,createCase,acceptSOCCall,createSOCCall,checkAllparameters methods of SOCCallController class..
    * @return void             
    */ 
    static testMethod void providerAddressValidationTest_Negative() {
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id,Provider_Facility_ID__c from SOC_Queue__c where Name = 'Test SOC'];
            
            Contact_Validation_Summary__c summaryObj = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id];
            summaryObj.Mobile_Phone__c = '(999) 999-9999';
            summaryObj.Secure_FAX__c  = '(999) 999-9999';
            summaryObj.Secure_Zip_Code__c = '12345';
            summaryObj.Secure_City__c = 'Test City'; 
            summaryObj.New_Street_Address__c = '123 Test';
            summaryObj.Secure_Phone__c = '(999) 999-9999';
            summaryObj.Secure_Suite__c = 'STE';
            summaryObj.Secure_Floor__c = 'FL';
            summaryObj.Contact_Id__c = provider.Id;
            
            update summaryObj;
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            SOCCallController  SOC = new SOCCallController(controller);
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            String summaryId = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id].ID;
            soc.addressRecordId = summaryObj.id;
            soc.checkAllparameters();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.createCase();
            soc.fillContactName();
            soc.hideOverlayDivCall();
            
            //populate validate page data
            soc.addressRecordId = facility.id;
            soc.newAddress.strStreetAddress ='1111 Test Address';
            soc.phoneCheck = true;
            soc.newAddress.strFax ='12345678999999';
            soc.newAddress.strZipcode ='123495630';
            soc.newAddress.strMobilePhone = '(999) 999-9999';
            soc.newAddress.strPhone = '(999) 999-9999';
            soc.newAddress.strFax  = '(999) 999-9999';
            soc.newAddress.strSuite  = '2345123 test Suite';
            soc.newAddress.strFloor = '10 test Floor';
            soc.prefix = '004';
            soc.newAddress.strCity = 'Noida Test';
            soc.newAddress.strstate = 'Uttar pardesh';
            soc.newAddress.strAttenTo = 'STRAttenTo';
            soc.newAddress.strNameChangesSugg = 'trNameChangesSugg';
            soc.saveUpdatedAddress();
            Test.stopTest();
        }
    }
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate various nagative cases address(like fax,suite ,floor) to cover saveUpdatedAddress,fillContactName,createCase,acceptSOCCall,createSOCCall,checkAllparameters methods of SOCCallController class for provider only.
    * @return void             
    */
    static testMethod void providerAddressValidation_NegativeTest() {
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];

            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id,Provider_Facility_ID__c from SOC_Queue__c where Name = 'Test SOC'];
            
            Contact_Validation_Summary__c summaryObj = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id];
            //Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c(); 
            summaryObj.Mobile_Phone__c = '(999) 999-9999';
            summaryObj.Secure_FAX__c  = '(999) 999-9999';
            summaryObj.Secure_Zip_Code__c = '12345';
            summaryObj.Secure_City__c = 'Test City';
            summaryObj.New_Street_Address__c = '123 Test';
            summaryObj.Secure_Phone__c = '(999) 999-9999';
            summaryObj.Secure_Suite__c = 'STE';
            summaryObj.Secure_Floor__c = 'FL';
            summaryObj.Contact_Id__c = provider.Id;
            summaryObj.Secure_State__c = 'Test sec State';
            summaryObj.Email__c = 'testEmail@test.com';
            summaryObj.Attn_To__c = 'Test Attn';
            summaryObj.Names_Changes_Suggested__c = 'Test Changes';
            
            update summaryObj;
           
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            //PageReference pageRef = Page.SOCCall;
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            SOCCallController  SOC = new SOCCallController(controller);
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            String summaryId = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id].ID;
            soc.addressRecordId = summaryObj.id;
            soc.checkAllparameters();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.createCase();
            soc.fillContactName();
            soc.hideOverlayDivCall();
            
            //populate validate page data
            soc.addressRecordId = summaryObj.id;
            soc.newAddress.strStreetAddress ='1200 CREEKSIDE DR';
            soc.newAddress.strPhone='(734) 999-9999';
            soc.phoneCheck = true;
            soc.newAddress.strFax ='12345678999999';
            soc.faxCheck = true;
            soc.newAddress.strCity = 'FOLSOM';
            soc.newAddress.strZipcode ='95630';
            soc.newAddress.strSuite  = '123 Suite';
            soc.newAddress.strFloor = '3 Floor';
            soc.newAddress.strstate = 'STRState';
            soc.newAddress.strEmail = 'strEmail@email.com';
            soc.newAddress.strAttenTo = 'strAttenTo';
            soc.newAddress.strNameChangesSugg = 'strNameChangesSugg';
            soc.saveUpdatedAddress();
            Test.stopTest();
        }
    }
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate various nagative cases  of address(like fax,suite ,floor) to cover saveUpdatedAddress,fillContactName,createCase,acceptSOCCall,createSOCCall,checkAllparameters methods of SOCCallController class for provider only.
    * @return void             
    */
    static testMethod void providerTest_AddressValidation_Negative() {
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];

            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id,Provider_Facility_ID__c from SOC_Queue__c where Name = 'Test SOC'];
            
            Contact_Validation_Summary__c summaryObj = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id];
            //Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c(); 
            summaryObj.Mobile_Phone__c = '(999) 999-9999';
            summaryObj.Secure_FAX__c  = '(999) 999-9999';
            summaryObj.Secure_Zip_Code__c = '12345';
            summaryObj.Secure_City__c = 'Test City';
            summaryObj.New_Street_Address__c = '123 Test';
            summaryObj.Secure_Phone__c = '(999) 999-9999';
            summaryObj.Secure_Suite__c = 'STE';
            summaryObj.Secure_Floor__c = 'FL';
            summaryObj.Serial_Number__c = 2;
            summaryObj.Contact_Id__c = provider.Id;
            summaryObj.Secure_State__c = 'Test sec State';
            summaryObj.Email__c = 'testEmail@test.com';
            summaryObj.Attn_To__c = 'Test Attn';
            summaryObj.Names_Changes_Suggested__c = 'Test Changes';
            
            update summaryObj;
           
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            //PageReference pageRef = Page.SOCCall;
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            SOCCallController  SOC = new SOCCallController(controller);
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            String summaryId = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id].ID;
            soc.addressRecordId = summaryObj.id;
            soc.checkAllparameters();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.createCase();
            soc.fillContactName();
            soc.hideOverlayDivCall();
            
            Contact_Validation_Audit_Trail__c auditObj = new Contact_Validation_Audit_Trail__c();
            auditObj.Address_Type__c = 'Primary';
            auditObj.Serial_Number__c = '2';
            auditObj.Case__c = socCase.id;
            auditObj.Provider_Information_Summary__c = summaryObj.id;
            auditObj.Contact_Id__c  = provider.Id;
            insert auditObj;
            
            //populate validate page data
            soc.addressRecordId = summaryObj.id;
            soc.newAddress.strStreetAddress ='1200 CREEKSIDE DR';
            soc.newAddress.strPhone='(734) 999-9999';
            soc.phoneCheck = true;
            soc.newAddress.strFax ='12345678999999';
            soc.faxCheck = true;
            soc.newAddress.strCity = 'FOLSOM';
            soc.newAddress.strZipcode ='95630';
            soc.newAddress.strSuite  = '123 Suite';
            soc.newAddress.strFloor = '3 Floor';
            soc.newAddress.strstate = 'STRState';
            soc.newAddress.strEmail = 'strEmail@email.com';
            soc.newAddress.strAttenTo = 'strAttenTo';
            soc.newAddress.strNameChangesSugg = 'strNameChangesSugg';
            soc.saveUpdatedAddress();
            Test.stopTest();
           
        }
    }
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate positive cases of address to cover various scenarios of saveUpdatedAddress,fillContactName,createCase,acceptSOCCall,createSOCCall,checkAllparameters methods of SOCCallController class for facility only.
    * @return void             
    */
    static testMethod void facilityTestMethod_Positive(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        system.runAs(TestUser){
           //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
           
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id from SOC_Queue__c where Name = 'Test SOC'];
            
            PDV_EAF_Facility__c summaryObj = [SELECT Id from PDV_EAF_Facility__c where Id =: facility.Id];
            summaryObj.FAX_NUMBER__c  = '(999) 999-9999';
            summaryObj.ZIP_CODE__c = '12345';
            summaryObj.CITY__c = 'Test City';
            summaryObj.ADDRESS__c = '123 Test';
            summaryObj.PHONE__c = '(999) 999-9999';
            update summaryObj;
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            //Assert check to validate MU_Object__c is created successfully...
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
         
            SOCCallController  SOC = new SOCCallController(controller);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',facility.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            
            soc.addressRecordId = facility.Id;
            soc.checkAllparameters();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.createCase();
            soc.fillContactName();
            soc.hideOverlayDivCall();
            Boolean istest = soc.patterMatcherSUiteOrFloor(' Suite ');
            Boolean istest1 = soc.patterMatcherSUiteOrFloor('Test');
            Boolean istest2 = soc.patterMatcherCareOf('Care Of');
            Boolean istest3 = soc.patterMatcherCareOf('Test');
            Boolean istest4 = soc.patterMatcherPOBox('Test');
            Boolean istest5 = soc.patterMatcherPOBoxStart('Test');
            soc.prefix = '003';
            Boolean istest6 = soc.patterMatcherStreetAddress('Test');
            Boolean istest7 = soc.patterMatcherEmail('Test');
            soc.cancelCase();
            PageReference page = soc.backToCasesMU();
            
            soc.phoneCheck = false;
            soc.faxCheck = false;
            soc.addressRecordId = summaryObj.id;
            soc.saveUpdatedAddress();
            soc.wrAddressValidationlist[0].isSelected = true; 
            soc.validateAddress();
            soc.createNewAddress();
            
            soc.updateSOCStatus();
            soc.updateCase();
            soc.caseMUStatus = 'Send Documents To Provider';
            soc.caseMUReason = 'test';
            soc.updateCaseMU();
            soc.caseMUStatus = 'Cannot send documents to Provider';
            soc.caseMUReason = 'test';
            soc.updateCaseMU();
            soc.cancelCase();
            soc.wrAddressValidationlist[0].isSelected = true;
            SOC.printAddressMethod(); 
            SOC.updateSOCStatusToPrint();
            SOC.caseObj.Status = 'Cannot Reach';
            SOC.caseObj.PDV_Contact_Name__c = 'Test';
            SOC.strCaseContactPhoneNumber = 'R32R32R32R32R32R32R32R32R32R32R32R32';
            SOC.caseObj.Validated_or_not__c = 'test';
            SOC.caseObj.SOC_Document_Status__c = 'test';
            SOC.rejectCase();
            Test.stopTest();
        }
    }
    
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate positive cases of address to cover various scenarios of saveUpdatedAddress,fillContactName,createCase,acceptSOCCall,createSOCCall,checkAllparameters methods of SOCCallController class when prefix ==4 for facility only.
    * @return void             
    */
    static testMethod void facilityTestForPrefix_Positive(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        system.runAs(TestUser){
           //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
           
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id from SOC_Queue__c where Name = 'Test SOC'];
            
            PDV_EAF_Facility__c summaryObj = [SELECT Id from PDV_EAF_Facility__c where Id =: facility.Id];
            summaryObj.FAX_NUMBER__c  = '(999) 999-9999';
            summaryObj.ZIP_CODE__c = '12345';
            summaryObj.CITY__c = 'Test City';
            summaryObj.ADDRESS__c = '123 Test';
            summaryObj.PHONE__c = '(999) 999-9999';
            update summaryObj;
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            //Assert check to validate MU_Object__c is created successfully...
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
         
            SOCCallController  SOC = new SOCCallController(controller);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',facility.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            try{
            soc.addressRecordId = facility.Id;
            soc.checkAllparameters();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.createCase();
            soc.fillContactName();
            soc.hideOverlayDivCall();
            Boolean istest = soc.patterMatcherSUiteOrFloor(' Suite ');
            Boolean istest1 = soc.patterMatcherSUiteOrFloor('Test');
            Boolean istest2 = soc.patterMatcherCareOf('Care Of');
            Boolean istest3 = soc.patterMatcherCareOf('Test');
            Boolean istest4 = soc.patterMatcherPOBox('Test');
            Boolean istest5 = soc.patterMatcherPOBoxStart('Test');
            soc.prefix = '004';
            Boolean istest6 = soc.patterMatcherStreetAddress('Test');
            Boolean istest7 = soc.patterMatcherEmail('Test');
            soc.cancelCase();
            PageReference page = soc.backToCasesMU();
            
            soc.phoneCheck = false;
            soc.faxCheck = false;
            soc.addressRecordId = summaryObj.id;
            soc.saveUpdatedAddress();
            soc.wrAddressValidationlist[0].isSelected = true; 
            soc.getAddressValidation();
            soc.validateAddress();
            }catch(Exception ex){}
            Test.stopTest();
        }
    }
    
    
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate various  nagative cases of address to cover various scenarios of saveUpdatedAddress,fillContactName,createCase,acceptSOCCall,createSOCCall,checkAllparameters methods of SOCCallController class for provider only.
    * @return void             
    */
    static testMethod void facilityTestMethod_Negative(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        system.runAs(TestUser){
           //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
           
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];

            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id from SOC_Queue__c where Name = 'Test SOC'];
            
            PDV_EAF_Facility__c summaryObj = [SELECT Id from PDV_EAF_Facility__c where Id =: facility.Id];
            summaryObj.FAX_NUMBER__c  = '(999) 999-9999';
            summaryObj.ZIP_CODE__c = '12345';
            summaryObj.CITY__c = 'Test City';
            summaryObj.ADDRESS__c = '123 Test';
            summaryObj.PHONE__c = '(999) 999-9999';
            update summaryObj;
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            //Assert check to validate MU_Object__c is created successfully...
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
         
            SOCCallController  SOC = new SOCCallController(controller);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            
            
            ApexPages.currentPage().getParameters().put('providerId',facility.Id);
            
            Test.startTest();
            soc.caseId = socCase.id;
            soc.prefix = '004';
            soc.getAddressValidation();
            soc.prefix = '004';
            soc.wrAddressValidationlist[0].isSelected = true;
            soc.getAddressValidation();
            SOC.printAddressMethod(); 
            Test.stopTest();
        }
    }
    
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate various  nagative cases of address to cover various scenarios of saveUpdatedAddress,fillContactName,createCase,acceptSOCCall,createSOCCall,checkAllparameters methods of SOCCallController class for provider only.
    * @return void             
    */
    static testMethod void facilityTestMethod_NegativeScenario(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        system.runAs(TestUser){
           //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
           
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];

            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id from SOC_Queue__c where Name = 'Test SOC'];
            
            PDV_EAF_Facility__c summaryObj = [SELECT Id from PDV_EAF_Facility__c where Id =: facility.Id];
            summaryObj.FAX_NUMBER__c  = '(999) 999-9999';
            summaryObj.ZIP_CODE__c = '12345';
            summaryObj.CITY__c = 'Test City';
            summaryObj.ADDRESS__c = '123 Test';
            summaryObj.PHONE__c = '(999) 999-9999';
            update summaryObj;
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            //Assert check to validate MU_Object__c is created successfully...
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
         
            SOCCallController  SOC = new SOCCallController(controller);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
 
            ApexPages.currentPage().getParameters().put('providerId',facility.Id);
            
            Test.startTest();
            soc.caseId = socCase.id;
            soc.providerId = facility.Id;
            soc.prefix = '004';
            soc.getProviderInfo();
            soc.getAddressValidation();
            soc.wrAddressValidationlist[0].isSelected = true;
            soc.validateAddress();
            Test.stopTest();
        }
    }
    
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate cases saveUpdatedAddress,fillContactName,createCase,acceptSOCCall,createSOCCall,checkAllparameters methods of SOCCallController class for provider only.
    * @return void             
    */
    static testMethod void facilityTest_ValidateCases(){
        
         User testRunUser1 = [select id from User where Username = 'tester4999_nky@test.com'];
         
         // Assert to check User is fetched successfully
        System.assert(testRunUser1.id!=null);
        
        system.runAs(testRunUser1){
           //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
           
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id from SOC_Queue__c where Name = 'Test SOC'];
            
            PDV_EAF_Facility__c summaryObj = [SELECT Id from PDV_EAF_Facility__c where Id =: facility.Id];
            summaryObj.FAX_NUMBER__c  = '(999) 999-9999';
            summaryObj.ZIP_CODE__c = '12345';
            summaryObj.CITY__c = 'Test City';
            summaryObj.ADDRESS__c = '123 Test';
            summaryObj.PHONE__c = '(999) 999-9999';
            summaryObj.address_modified__c = 'No';
            update summaryObj;
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            //Assert check to validate PDV_EAF_Validation_Audit_Trail__c is created successfully...
            system.assert(auditObj.id != null);
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            
            //Assert check to validate MU_Object__c is created successfully...
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
         
            SOCCallController  SOC = new SOCCallController(controller);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',facility.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            SOC.caseObj.Status = 'Cannot Reach';
            SOC.caseObj.PDV_Contact_Name__c = 'Test';
            SOC.strCaseContactPhoneNumber ='(999) 999-9999';
            SOC.caseObj.Validated_or_not__c = 'test';
            SOC.caseObj.SOC_Document_Status__c = 'test';
            SOC.caseObj.Common_Subject_Lines__c = 'test';
            SOC.prefix = '004';
            SOC.rejectCase();
            SOC.approveCase();
            SOC.updateCase();
            Test.stopTest();
        }
    }
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate cases checkAllparameters and updateCase methods of SOCCallController class for provider only.
    * @return void             
    */
    static testMethod void CasesValidationTestMethod(){
         User testRunUser1 = [select id from User where Username = 'tester4999_nky@test.com'];
        
        //Assert to check to validate user has created successfully....
        system.assert(testRunUser1.id != null);
        
        system.runAs(testRunUser1){
           //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
           
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id from SOC_Queue__c where Name = 'Test SOC'];
            
            PDV_EAF_Facility__c summaryObj = [SELECT Id from PDV_EAF_Facility__c where Id =: facility.Id];
            summaryObj.FAX_NUMBER__c  = '(999) 999-9999';
            summaryObj.ZIP_CODE__c = '12345';
            summaryObj.CITY__c = 'Test City';
            summaryObj.ADDRESS__c = '123 Test';
            summaryObj.PHONE__c = '(999) 999-9999';
            update summaryObj;
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            
            //Assert to check to validate PDV_EAF_Validation_Audit_Trail__c has created successfully....
            system.assert(auditObj.id != null);
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            
            //Assert to check to validate MU_Object__c has created successfully....
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
         
            SOCCallController  SOC = new SOCCallController(controller);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            SOC.caseObj.Status = 'Cannot Reach';
            SOC.caseObj.PDV_Contact_Name__c = 'Test';
            SOC.strCaseContactPhoneNumber ='(999) 999-9999';
            SOC.caseObj.Validated_or_not__c = 'test';
            SOC.caseObj.SOC_Document_Status__c = 'test';
            SOC.caseObj.Common_Subject_Lines__c = 'test';
            SOC.prefix = '003';
            SOC.caseObj.Status = 'Escalate To Meaningful Use';
            SOC.caseObj.PDV_Escalation_Reason__c = 'test';
            SOC.caseObj.Communication_Preference_Changed_To_Fax__c = 'test';
            List<UserRole> socAgentRole = [SELECT Id, Name FROM UserRole where Name = 'SOC Agents' limit 1];
            system.assertEquals(SOC.caseObj.Status,'Escalate To Meaningful Use');
            system.assertEquals(UserInfo.getUserRoleId(),socAgentRole[0].Id);
            SOC.updateCase();
            Test.stopTest();
        }
    }
    
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate cases checkAllparameters and updateCase methods of SOCCallController class for provider only.
       when Case is Closed and SOC Document Status is sent .
    * @return void             
    */
    static testMethod void ClosedCaseValidationTest(){
       
         User testRunUser1 = [select id from User where Username = 'tester4999_nky@test.com'];
        
        //Assert to check to validate user has created successfully....
        system.assert(testRunUser1.id != null);
        
        system.runAs(testRunUser1){
           //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
           
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id from SOC_Queue__c where Name = 'Test SOC'];
            
            PDV_EAF_Facility__c summaryObj = [SELECT Id from PDV_EAF_Facility__c where Id =: facility.Id];
            summaryObj.FAX_NUMBER__c  = '(999) 999-9999';
            summaryObj.ZIP_CODE__c = '12345';
            summaryObj.CITY__c = 'Test City';
            summaryObj.ADDRESS__c = '123 Test';
            summaryObj.PHONE__c = '(999) 999-9999';
            update summaryObj;
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            
            //Assert to check to validate PDV_EAF_Validation_Audit_Trail__c has created successfully....
            system.assert(auditObj.id != null);
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            
            //Assert to check to validate MU_Object__c has created successfully....
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
         
            SOCCallController  SOC = new SOCCallController(controller);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            
            //check all parameters test
            Test.startTest();
            SOC.caseObj.Status = 'Cannot Reach';
            SOC.caseObj.PDV_Contact_Name__c = 'Test';
            SOC.strCaseContactPhoneNumber ='(999) 999-9999';
            SOC.caseObj.Validated_or_not__c = 'test';
            SOC.caseObj.SOC_Document_Status__c = 'Sent';
            SOC.caseObj.Common_Subject_Lines__c = 'test';
            SOC.prefix = '003';
            SOC.caseObj.Status = 'Closed';
            SOC.caseObj.PDV_Escalation_Reason__c = 'test';
            SOC.caseObj.Communication_Preference_Changed_To_Fax__c = 'Yes';
            List<UserRole> socAgentRole = [SELECT Id, Name FROM UserRole where Name = 'SOC Agents' limit 1];
            system.assertEquals(SOC.caseObj.Status,'Closed');
            system.assertEquals(UserInfo.getUserRoleId(),socAgentRole[0].Id);
            SOC.updateCase();
            Test.stopTest();
        }
    }
     /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is for negative testing to validate cases checkAllparameters and updateCase methods of SOCCallController class for provider only.when case is closed without sending SOC documents 
    * @return void             
    */
    static testMethod void CaseValidationTest_Negative(){
       
         User testRunUser1 = [select id from User where Username = 'tester4999_nky@test.com'];
        
        //Assert to check to validate user has created successfully....
        system.assert(testRunUser1.id != null);
        
        system.runAs(testRunUser1){
           //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
           
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id from SOC_Queue__c where Name = 'Test SOC'];
            
            PDV_EAF_Facility__c summaryObj = [SELECT Id from PDV_EAF_Facility__c where Id =: facility.Id];
            summaryObj.FAX_NUMBER__c  = '(999) 999-9999';
            summaryObj.ZIP_CODE__c = '12345';
            summaryObj.CITY__c = 'Test City';
            summaryObj.ADDRESS__c = '123 Test';
            summaryObj.PHONE__c = '(999) 999-9999';
            update summaryObj;
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            
            //Assert to check to validate PDV_EAF_Validation_Audit_Trail__c has created successfully....
            system.assert(auditObj.id != null);
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            
            //Assert to check to validate MU_Object__c has created successfully....
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
         
            SOCCallController  SOC = new SOCCallController(controller);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            SOC.updateCase();
            //check all parameters test
            Test.startTest();
            SOC.caseObj.Status = 'Cannot Reach';
            SOC.caseObj.PDV_Contact_Name__c = 'Test';
            SOC.strCaseContactPhoneNumber ='(999) 999-9999';
            SOC.caseObj.Validated_or_not__c = 'test';
            SOC.caseObj.SOC_Document_Status__c = 'test';
            SOC.caseObj.Common_Subject_Lines__c = 'test';
            SOC.prefix = '003';
            SOC.caseObj.Status = 'Closed';
            SOC.caseObj.PDV_Escalation_Reason__c = 'test';
            SOC.caseObj.Communication_Preference_Changed_To_Fax__c = 'Yes';
            List<UserRole> socAgentRole = [SELECT Id, Name FROM UserRole where Name = 'SOC Agents' limit 1];
            system.assertEquals(SOC.caseObj.Status,'Closed');
            system.assertEquals(UserInfo.getUserRoleId(),socAgentRole[0].Id);
            SOC.updateCase();
            Test.stopTest();
        }
    }
     /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is for negative testing to validate cases checkAllparameters and updateCase methods of SOCCallController class for provider only.when status is cannot reach 
    * @return void             
    */
    static testMethod void CaseValidationTesTForStatus_NotReach(){
       
         User testRunUser1 = [select id from User where Username = 'tester4999_nky@test.com'];
        
        //Assert to check to validate user has created successfully....
        system.assert(testRunUser1.id != null);
        
        system.runAs(testRunUser1){
           //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
           
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id from SOC_Queue__c where Name = 'Test SOC'];
            
            PDV_EAF_Facility__c summaryObj = [SELECT Id from PDV_EAF_Facility__c where Id =: facility.Id];
            summaryObj.FAX_NUMBER__c  = '(999) 999-9999';
            summaryObj.ZIP_CODE__c = '12345';
            summaryObj.CITY__c = 'Test City';
            summaryObj.ADDRESS__c = '123 Test';
            summaryObj.PHONE__c = '(999) 999-9999';
            update summaryObj;
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            
            //Assert to check to validate PDV_EAF_Validation_Audit_Trail__c has created successfully....
            system.assert(auditObj.id != null);
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            
            //Assert to check to validate MU_Object__c has created successfully....
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
         
            SOCCallController  SOC = new SOCCallController(controller);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            SOC.updateCase();
            //check all parameters test
            Test.startTest();
            
            SOC.caseObj.PDV_Contact_Name__c = 'Test';
            SOC.strCaseContactPhoneNumber ='(999) 999-9999';
            SOC.caseObj.Validated_or_not__c = 'test';
            SOC.caseObj.SOC_Document_Status__c = 'test';
            SOC.caseObj.Common_Subject_Lines__c = 'test';
            SOC.prefix = '003';
            SOC.caseObj.Status = 'Cannot Reach';
            SOC.caseObj.PDV_Escalation_Reason__c = 'test';
            SOC.caseObj.Communication_Preference_Changed_To_Fax__c = 'Yes';
            List<UserRole> socAgentRole = [SELECT Id, Name FROM UserRole where Name = 'SOC Agents' limit 1];
            system.assertEquals(SOC.caseObj.Status,'Cannot Reach');
            system.assertEquals(UserInfo.getUserRoleId(),socAgentRole[0].Id);
            SOC.updateCase();
            Test.stopTest();
        }
    }
     /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is for negative testing to validate cases checkAllparameters and updateCase methods of SOCCallController class for provider only.case has no status
    * @return void             
    */
    static testMethod void CaseValidationTestForNoStatus(){
       
         User testRunUser1 = [select id from User where Username = 'tester4999_nky@test.com'];
        
        //Assert to check to validate user has created successfully....
        system.assert(testRunUser1.id != null);
        
        system.runAs(testRunUser1){
           //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
           
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id from SOC_Queue__c where Name = 'Test SOC'];
            
            PDV_EAF_Facility__c summaryObj = [SELECT Id from PDV_EAF_Facility__c where Id =: facility.Id];
            summaryObj.FAX_NUMBER__c  = '(999) 999-9999';
            summaryObj.ZIP_CODE__c = '12345';
            summaryObj.CITY__c = 'Test City';
            summaryObj.ADDRESS__c = '123 Test';
            summaryObj.PHONE__c = '(999) 999-9999';
            update summaryObj;
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            
            //Assert to check to validate PDV_EAF_Validation_Audit_Trail__c has created successfully....
            system.assert(auditObj.id != null);
            
            MU_Object__c muObj = new MU_Object__c();
            muObj.Case__c =  socCase.id;
            insert  muObj;
            
            //Assert to check to validate MU_Object__c has created successfully....
            system.assert(muObj.id != null);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
         
            SOCCallController  SOC = new SOCCallController(controller);
            
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);
            
            soc.checkAllparameters();
            ApexPages.currentPage().getParameters().put('providerId',provider.Id);
            soc.checkAllparameters();
            SOC.updateCase();
            //check all parameters test
            Test.startTest();
            
            SOC.caseObj.PDV_Contact_Name__c = 'Test';
            SOC.strCaseContactPhoneNumber ='(999) 999-9999';
            SOC.caseObj.Validated_or_not__c = 'test';
            SOC.caseObj.SOC_Document_Status__c = 'test';
            SOC.caseObj.Common_Subject_Lines__c = 'test';
            SOC.prefix = '003';
            SOC.caseObj.PDV_Escalation_Reason__c = 'test';
            SOC.caseObj.Communication_Preference_Changed_To_Fax__c = 'Yes';
            List<UserRole> socAgentRole = [SELECT Id, Name FROM UserRole where Name = 'SOC Agents' limit 1];
            
            system.assertEquals(UserInfo.getUserRoleId(),socAgentRole[0].Id);
            SOC.updateCase();
            Test.stopTest();
        }
    }
    
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate cases checkAllparameters fillCaseAddressHistory,createSOCCall,acceptSOCCall,fillContactName,acceptAssociatedCase and updateSOCStatus methods of SOCCallController class for provider only.
    * @return void             
    */
    static testMethod void checkAllparametersForCaseValideTest(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
            socCase.EAF_Facility__c = facility.id;
            update socCase;
            
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = SOCCallController_Test.createSOCQueue();
            socQueue.Associated_Case_Id__c = socCase.Id;
            socQueue.Facility_Id__c = facility.Id;
            socQueue.Printed_Id__c = 'Test PrintedId';
            socQueue.status__c = 'Sent';
            database.insert(socQueue,false);
            
            //Assert to check to validate SOC_Queue__c has created successfully....
            system.assert(socQueue.id != null);
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            
            //Assert to check to validate PDV_EAF_Validation_Audit_Trail__c has created successfully....
            system.assert(auditObj.id != null);
            
            //PageReference pageRef = Page.SOCCall;
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            
            
            ApexPages.currentPage().getParameters().put('providerId','');
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);

            SOCCallController  SOC = new SOCCallController(controller);
            
            //check all parameters test
            Test.startTest();
            soc.checkAllparameters();
            soc.caseId = socCase.id;
            soc.prefix = '';
            soc.fillCaseAddressHistory();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.fillContactName();
            soc.acceptAssociatedCase();
            soc.getCaseLst();
            soc.isCreatingCase = false;
            soc.wrAddressValidationlist[0].isValidated = 'yes';
            soc.updateSOCStatus();
            SOC.updateCase();
            Test.stopTest();
        }
    }
    
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to update facility, audit obj address and validate various cases in checkAllparameters fillCaseAddressHistory,createSOCCall,acceptSOCCall,fillContactName,acceptAssociatedCase and updateSOCStatus methods of SOCCallController class for provider only.
    * @return void             
    */
    static testMethod void checkparametersWithProviderForCaseValidateTest(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
            socCase.EAF_Facility__c = facility.id;
            update socCase;
            
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = SOCCallController_Test.createSOCQueue();
            socQueue.Associated_Case_Id__c = socCase.Id;
            socQueue.Facility_Id__c = facility.Id;
            socQueue.Printed_Id__c = 'Test PrintedId';
            socQueue.status__c = 'Sent';
            database.insert(socQueue,false);
            
            //Assert to check to validate SOC_Queue__c has created successfully....
            system.assert(socQueue.id != null);
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            
            //Assert to check to validate PDV_EAF_Validation_Audit_Trail__c has created successfully....
            system.assert(auditObj.id != null);
            
            facility.address_modified__c = 'Yes';
            update facility;
            
            auditObj.address_modified__c = 'Yes';
            update auditObj;
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            
            
            ApexPages.currentPage().getParameters().put('providerId','');
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);

            SOCCallController  SOC = new SOCCallController(controller);
            
            //check all parameters test
            Test.startTest();
            soc.checkAllparameters();
            soc.caseId = socCase.id;
            soc.prefix = '';
            soc.fillCaseAddressHistory();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.fillContactName();
            soc.acceptAssociatedCase();
            soc.getCaseLst();
            soc.isCreatingCase = false;
            soc.wrAddressValidationlist[0].isValidated = 'yes';
            soc.updateSOCStatus();
            Test.stopTest();
        }
    }

    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to update facility, audit obj without modifying address details and validate various cases in checkAllparameters fillCaseAddressHistory,createSOCCall,acceptSOCCall,fillContactName,acceptAssociatedCase and updateSOCStatus methods of SOCCallController class for provider only.
    * @return void             
    */
    static testMethod void checkParametersWithProvider_CaseValidateTest(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
            socCase.EAF_Facility__c = facility.id;
            update socCase;
            
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = SOCCallController_Test.createSOCQueue();
            socQueue.Associated_Case_Id__c = socCase.Id;
            socQueue.Facility_Id__c = facility.Id;
            socQueue.Printed_Id__c = 'Test PrintedId';
            socQueue.status__c = 'Sent';
            database.insert(socQueue,false);
            
            PDV_EAF_Validation_Audit_Trail__c auditObj = new PDV_EAF_Validation_Audit_Trail__c();
            auditObj.Serial_Number__c = '1';
            auditObj.Case__c = socCase.id;
            auditObj.EAF_Facility__c = facility.Id;
            insert auditObj;
            facility.address_modified__c = 'No';
            update facility;
            auditObj.address_modified__c = 'No';
            update auditObj;
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            
            
            ApexPages.currentPage().getParameters().put('providerId','');
            ApexPages.currentPage().getParameters().put('socId',socQueue.id);
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);

            SOCCallController  SOC = new SOCCallController(controller);
            
            //check all parameters test
            Test.startTest();
            soc.checkAllparameters();
            soc.caseId = socCase.id;
            soc.prefix = '';
            soc.fillCaseAddressHistory();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.fillContactName();
            soc.acceptAssociatedCase();
            soc.getCaseLst();
            soc.isCreatingCase = false;
            soc.wrAddressValidationlist[0].isValidated = 'yes';
            soc.updateSOCStatus();
            Test.stopTest();
        }
    }
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using to update SOC Queue, Contact_Validation_Summary__c obj  details and validate various cases in checkAllparameters fillCaseAddressHistory,createSOCCall,acceptSOCCall,fillContactName,acceptAssociatedCase and updateSOCStatus methods of SOCCallController class for provider only.
    * @return void             
    */
    static testMethod void checkAllparametersWithoutSOCTest(){
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
         
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = [select id from SOC_Queue__c where Name = 'Test SOC'];
            Contact_Validation_Summary__c summaryObj = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id];
            //Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c(); 
            summaryObj.Mobile_Phone__c = '(999) 999-9999';
            summaryObj.Secure_FAX__c  = '(999) 999-9999';
            summaryObj.Secure_Zip_Code__c = '12345';
            summaryObj.Secure_City__c = 'Test City';
            summaryObj.New_Street_Address__c = '123 Test';
            summaryObj.Secure_Phone__c = '(999) 999-9999';
            summaryObj.Secure_Suite__c = 'STE';
            summaryObj.Secure_Floor__c = 'FL';
            summaryObj.Contact_Id__c = provider.Id;
            summaryObj.address_modified__c = 'yes';
            update summaryObj;
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            
            
            ApexPages.currentPage().getParameters().put('providerId',provider.id);
            ApexPages.currentPage().getParameters().put('socId','');
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);

            SOCCallController  soc = new SOCCallController(controller);
            
            //check all parameters test
            Test.startTest();
            soc.checkAllparameters();
            soc.addressRecordId = [SELECT Id from Contact_Validation_Summary__c where Contact_Id__c =: provider.Id].ID;
            soc.checkAllparameters();
            soc.createSOCCall();
            soc.acceptSOCCall();
            soc.getAddressValidation();
            summaryObj.address_modified__c = 'No';
            update summaryObj;
            soc.getAddressValidation();
            soc.wrAddressValidationlist[0].isSelected = true;
            soc.prefix = '004';
            soc.createCase();
            soc.updateSummaryInfo();
            
            //populate validate page data
            soc.newAddress.strStreetAddress ='1200 CREEKSIDE DR';
            soc.newAddress.strPhone='(999) 999-9999';
            soc.phoneCheck = true;
            soc.newAddress.strFax ='12345678999999';
            soc.faxCheck = true;
            soc.newAddress.strCity = 'FOLSOM';
            soc.newAddress.strZipcode ='95630';
                
            //make update call
            soc.saveUpdatedAddress();
            soc.updateSOCStatus();
            soc.setAddressParam();
            soc.fillContactName();
            soc.getProviderInfo();
            soc.getCaseLst();
            soc.cancelCase();
            soc.hideOverlayDivCall();
            soc.checkAllparameters();
            soc.deleteAddress();
            Test.stopTest();
        }
    }
    /**             
    * @author IDC Team             
    * @date 28/09/2015            
    * @description:this method is using  to validate cases checkAllparameters methods of SOCCallController class for facility only.
    * @return void             
    */
    static testMethod void checkAllparametersWithNoProviderANDFacility() 
    {
        User TestUser = [select id from User where Username = 'tester49_nky@test.com'];
        //Assert to check User has been fetched successfully
        System.assert(TestUser!=null);
        system.runAs(TestUser){
            //create Account
            Account acc =  [select id from Account where Name = 'Test Account Name'];
            //Create Provider 
            Contact provider  = [select id from Contact where FirstName ='Test' and LastName = 'Provider'];
            // Create Case
            Case socCase = [select id from case where PDV_Contact_Name__c = 'Test Provider'];
        
            //Create Facility
            PDV_EAF_Facility__c facility  = [select id from PDV_EAF_Facility__c where Name = 'Test Facility'];
            
            // create SOC_Queue__c
            SOC_Queue__c socQueue  = SOCCallController_Test.createSOCQueue();
            socQueue.Associated_Case_Id__c = socCase.Id;
            socQueue.Printed_Id__c = 'Test PrintedId';
            socQueue.status__c = 'Sent';
            database.insert(socQueue,false);
            
            PageReference pageRef = new PageReference('/apex/SOCCall');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(socQueue);
            ApexPages.currentPage().getParameters().put('providerId','');
            ApexPages.currentPage().getParameters().put('socId','');
            ApexPages.currentPage().getParameters().put('caseId',socCase.id);

            SOCCallController  SOC = new SOCCallController(controller);
            
            //check all parameters test
            Test.startTest();
            soc.checkAllparameters();
            Test.stopTest();
        }
    }

    
}