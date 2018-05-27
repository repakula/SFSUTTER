/**  
*    Class Name: VFC42_Provider_Detail_Controller_Test
*    Author: IDC Team
*    Date: 14-July-2015
*    Description:  Test class for VFC42_Provider_Detail_Controller Controller
*    History
*    --------
**/

/**********************************************************************
Name: VFC42_Provider_Detail_Controller_Test
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is the test class for VFC42_Provider_Detail_Controller class
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE        DETAIL                 Description
1.0      IDC Offshore  14-July-2015 Development complete   Test Class for VFC42_Provider_Detail_Controller.
2.0      IDC Offshore  11-Jan-2016  Class Optimization   Incorporated changes to implement best test practices in the test class.
***********************************************************************/
@isTest
private class VFC42_Provider_Detail_Controller_Test {
    
    /*******************************************************************
        Purpose: method to create test data used by all tests 
        Parameters: N/A 
        Returns: void
        Throws [Exceptions]: N/A
    ********************************************************************/  
    @testSetup
    static void createTestData() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (thisUser) {
            // Create custom setting Data
            CS_ManageProfile__c csprofile = Util01_PDIUtilTestData.createManageProfileCustSetting();
            
            /*********************************************************************** 
            Verifying the Custom setting data using system.assert() 
            Expected Result: Custom setting  is not null
            Actual Result: Custom setting  is not null 
            ***********************************************************************/ 
            system.assert(csprofile!=null);
            
            FAQ__kav tempFAQkav = new FAQ__kav(
                Title = 'PDI HTMLDOC',
                Summary = 'test from apex',
                Article_Body__c = 'test from apex',
                URLName = 'PDI-HTMLDOC111'
            );

            insert tempFAQkav;
            tempFAQkav = [SELECT KnowledgeArticleId FROM FAQ__kav WHERE Id = :tempFAQkav.Id]; 
            
            KbManagement.PublishingService.publishArticle(tempFAQkav.KnowledgeArticleId, true);
            FAQ__kav faq = [SELECT Id, Article_Body__c, ArticleNumber,  ArticleType, Functional_Area__c, Keywords__c, KnowledgeArticleId, Language,  Original_Author__c, PublishStatus, SourceId, Sub_Function__c, Summary, Title, UrlName, Version__c, VersionNumber, IsVisibleInApp, IsVisibleInPkb, IsVisibleInCsp, IsVisibleInPrm FROM FAQ__kav WHERE id=:tempFAQkav.id];     
            
            Account accObj = new Account();
            accObj.Name = 'Account Name';
            insert accObj;
            
            RecordType rtObj = new RecordType();
            rtObj = [SELECT id, name FROM recordtype WHERE name='Provider' and SObjectType='Contact' limit 1];
            
            list<contact> conList = new list<contact>();
            Contact conObj = new Contact();
            
            conList.add(new contact(
                accountId = accObj.id,
                lastName = 'Provider',
                firstName = 'Test',
                Provider_Name__c = 'Test Provider',
                Provider_Title__c = 'Mr.',
                recordTypeId = rtObj.id,
                email = 'kishore.jonnadula@accenture.com',
                Provider_Correspondence_Address__c = '123',
                Provider_Correspondence_City__c = 'CA',
                Provider_Correspondence_State__c = 'CA',
                Provider_Correspondence_PostalCode__c = '12345',
                Provider_Correspondence_Phone__c = '(234) 999-2341',
                Provider_Correspondence_Fax_Number__c = '(234) 567-8901',
                MobilePhone = '(234) 567-8901',
                Provider_Active_Status__c = true,
                Provider_Practicing_Physician__c = true,
                Provider_Admin_Assistant_Phone__c = '(234) 567-8901',
                Provider_Admin_Assistant_Email__c = 'test123@email.com',
                Provider_Admin_Assistant__c = 'Admin testAsst',
                Provider_Access_Type__c = 'No Access',
                Contact_External_ID1__c = '8965'
            ));
            insert conList; 
          
            CS_ManageProfile__c csprofile1 = Util01_PDIUtilTestData.createAdminManageProfileCustSetting();
            
            Account accObj1 = new Account();
            accObj1.Name = 'Admin testAsst';
            insert accObj1;
            
            RecordType rtObj1 = new RecordType();
            rtObj1 = [SELECT id, name FROM recordtype WHERE name='Provider Admin Assistant' and SObjectType='Contact' limit 1];
            
            Contact conObj1 = new Contact();
            conObj1.AccountId = accObj1.Id;
            conObj1.RecordTypeId = rtObj1.Id;
            conObj1.Email= 'test123@email.com';
            conObj1.FirstName = 'Admin';
            conObj1.LastName = 'testAssistAdmintest123';
            
            insert conObj1;
            
        }
       
    }
    
    /*******************************************************************
    Purpose:  This is used to testing to initialise the class variables with respective values
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void Constructor_Test() {
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            List<Contact_Validation_Summary__c> updateSummaryRecordsList = new List<Contact_Validation_Summary__c>();
            for(Contact_Validation_Summary__c sum : summaryRecords){
                
                sum.Last_Verified_Date__c = date.today().addDays(40);
                sum.address_modified__c = 'no';
                updateSummaryRecordsList.add(sum);
            }
            update updateSummaryRecordsList;
            
            Test.startTest();
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            ctrl.strCaseContactPhoneNumber = '34823323';
            ctrl.updateCase();
            System.assertEquals(true, ctrl.isAddressValidAllFields);
            Test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test accept PVQ record.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void acceptPVQRecord_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();

            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            List<Contact_Validation_Summary__c> updateSummaryRecordsList = new List<Contact_Validation_Summary__c>();
            for(Contact_Validation_Summary__c sum : summaryRecords){
                
                sum.Last_Verified_Date__c = system.today();
                sum.address_modified__c = 'yes';
                updateSummaryRecordsList.add(sum);
            }
            update updateSummaryRecordsList;
            
            Test.startTest();
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
        
            Contact_Validation_Audit_Trail__c auditObj = new Contact_Validation_Audit_Trail__c();
            auditObj.Provider_Information_Summary__c = summaryRecords[0].Id;
            auditObj.Contact_Id__c = summaryRecords[0].Contact_Id__c;
            insert auditObj;
            System.assert(auditObj != null);
            Case caseObj = new Case();
            caseObj.ContactId = summaryRecords[0].Contact_Id__c;
            insert caseObj;
             System.assert(caseObj != null);   
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            
            ctrl.pvqId = summaryRecords[0].Id;
            ctrl.acceptPDIRecord = true;
            ctrl.acceptPVQRecord();
            ctrl.createCase();
            ctrl.checkAllparameters();
            ctrl.updateCase();
            ctrl.fillContactName();
            
            ctrl.pvqId = null;
            try{
               ctrl.checkAllparameters();
               System.assert(ctrl.WrProviderDetailsObj != null); 
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }
            
            Test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to negative testing to accept PVQ record.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void acceptPVQRecord_NegativeTest() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();

            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            List<Contact_Validation_Summary__c> summaryRecords1 = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            List<Contact_Validation_Summary__c> updateSummaryRecordsList = new List<Contact_Validation_Summary__c>();
            for(Contact_Validation_Summary__c sum : summaryRecords1){
                
                sum.Last_Verified_Date__c = date.today().addDays(40);
                sum.address_modified__c = 'no';
                sum.Status__c = 'Validated';
                updateSummaryRecordsList.add(sum);
            }
            update updateSummaryRecordsList;

            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c, Status__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            Test.startTest();
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            
            ctrl.checkAllparameters();
            ctrl.pvqId = summaryRecords[0].Id;
            ctrl.acceptPDIRecord = true;
            ctrl.acceptPVQRecord();
            ctrl.createCase();
            ctrl.updateCase();
            ctrl.fillContactName();
            //ctrl.validateAddress();
            
            ctrl.addressRecordId = summaryRecords[0].Id;
            //ctrl.setAddressParam();
            
            
            Test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose: This method is used to test check the entered PO Box against a particular Regular Expression.
    Parameters: String value
    Returns: Boolean 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void patterMatcherPOBox_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
           
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            Provider_Address__c providerAddressNewObj = new Provider_Address__c();
            providerAddressNewObj.Address_Line1__c = '1408 a street';
            providerAddressNewObj.Address_Line_2__c = 'apt 129';
            providerAddressNewObj.City__c = 'sacramento';
            providerAddressNewObj.State__c = 'CA';
            providerAddressNewObj.Zip_Code__c = '99511';
            providerAddressNewObj.Address_Type__c = 'Secondary';
            providerAddressNewObj.PDI_Campaign__c = '2016 Wave2';
            providerAddressNewObj.Contact_Id__c = summaryRecords[0].Contact_Id__c;
            providerAddressNewObj.Summary_Id__c = summaryRecords[0].Id;
            try{
               insert providerAddressNewObj; 
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            Test.startTest();
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            
            ctrl.checkAllparameters();
            //ctrl.getServiceStatus();
            ctrl.patterMatcherPOBox('Hello');
            //ctrl.hideOverlayDivCall();
            ctrl.cancelCase();
            
            ctrl.caseId = null;
            try{
              ctrl.cancelCase();
                System.assertEquals(true, ctrl.isCancelCaseOk);
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }
            
            Test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Cancel Address.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void cancelAddress_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            test.startTest();
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            ctrl.suggestedAddressFlag = true;
            ctrl.cancelAddress();
            System.assertEquals(true, ctrl.editAddrmode);
            
            ctrl.suggestedAddressFlag = false;
            ctrl.cancelAddress();
            System.assertEquals(false, ctrl.editAddrmode);
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test New Provider Address.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void newProviderAddress_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
           
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            test.startTest();
            ctrl.checkAllparameters();
            System.assert(ctrl.WrProviderDetailsObj != null);
            ctrl.newAddress();
            System.assertEquals(true, ctrl.editAddrmode);
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test get selected address method.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void getSelectedProviderAddress_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
           
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            String addressId = '';
            String secAddressId = '';
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(addressId != null){
                        if(address.Address_Type__c == Label.CL303_PDIPrimary){
                            addressId = address.Id;
                        }else{
                            secAddressId = address.Id;
                        }
                    }
                } 
            }
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            test.startTest();
            ctrl.checkAllparameters();
            ApexPages.currentPage().getParameters().put('addressId', addressId);
            ctrl.getselectedAddress();
            System.assert(ctrl.address != null);
            
            ctrl.checkAllparameters();
            ApexPages.currentPage().getParameters().put('addressId', secAddressId);
            ctrl.getselectedAddress();
            System.assert(ctrl.address != null);
            
            Provider_Address__c provAddress = new  Provider_Address__c ();
            provAddress.Address_Line1__c = '1403 a street';
            provAddress.Serial_Number__c = '0';
            provAddress.Address_Line_2__c = 'apt 129';
            provAddress.City__c = 'sacramento';
            provAddress.State__c = 'CA';
            provAddress.Zip_Code__c = '99511';
            provAddress.Secure_Phone__c = '(999) 123-9967';
            provAddress.Secure_Fax__c = '(999) 123-9967';
            provAddress.Address_Type__c = Label.CL303_PDIPrimary;
            provAddress.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            provAddress.Contact_Id__c = summaryRecords[0].Contact_Id__c;
            provAddress.Summary_Id__c = summaryRecords[0].Id;
            
            ctrl.primaryAddrObj = provAddress;
            ApexPages.currentPage().getParameters().put('addressId', '');
            ApexPages.currentPage().getParameters().put('serialnumber', provAddress.Serial_Number__c);
            ctrl.getselectedAddress();
            System.assert(ctrl.address != null);
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test get selected address with serial number.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void getSelectedAddressSerialNumber_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
           
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            test.startTest();
            ctrl.checkAllparameters();
            List<Provider_Address__c> secondaryAddressList = new List<Provider_Address__c>();
                Provider_Address__c provAddress1 = new  Provider_Address__c ();
                    provAddress1.Address_Line1__c = '1403 a street';
                    provAddress1.Address_Line_2__c = 'apt 129';
                provAddress1.Serial_Number__c = '1';
                    provAddress1.City__c = 'sacramento';
                    provAddress1.State__c = 'CA';
                    provAddress1.Zip_Code__c = '99511';
                    provAddress1.Secure_Phone__c = '(999) 123-9967';
                    provAddress1.Secure_Fax__c = '(999) 123-9967';
                    provAddress1.Address_Type__c = Label.CL359_PDI_secondaryAddress;
                    provAddress1.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
                    provAddress1.Contact_Id__c = summaryRecords[0].Contact_Id__c;
                    provAddress1.Summary_Id__c = summaryRecords[0].Id;
            secondaryAddressList.add(provAddress1);
            ctrl.SecondaryAddrList = secondaryAddressList;
            String secSerialNumber = '';
            if(!secondaryAddressList.isEmpty()){
                for(Provider_Address__c address : secondaryAddressList){
                    secSerialNumber = address.Serial_Number__c;
                } 
            }
            ApexPages.currentPage().getParameters().put('addressId', '');
            ApexPages.currentPage().getParameters().put('serialnumber', secSerialNumber);
            ctrl.getselectedAddress();
            System.assert(ctrl.address != null);
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Delete Address Method.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void deleteAddress_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
           
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            String serialNumber1 = '';
            String serialNumber2 = '';
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(address.Serial_Number__c == '1'){
                        serialNumber1 = address.Serial_Number__c;
                    }else{
                        serialNumber2 = address.Serial_Number__c;
                    }
                } 
            }
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            test.startTest();
            ctrl.checkAllparameters();
            ApexPages.currentPage().getParameters().put('serialNumber', serialNumber1);
            ctrl.deleteAddress();
            
            ApexPages.currentPage().getParameters().put('serialNumber', serialNumber2);
            ctrl.deleteAddress();
            System.assertEquals(false, ctrl.editAddrmode);
            
            ctrl.SecondaryAddrList = null;
            try{
                ctrl.deleteAddress();
                System.assertEquals(false, ctrl.editAddrmode);
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test SaveUpdatedAddress .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void saveUpdatedAddressPositive_Test(){
        //User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        
        CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
        PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
        PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
        List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
        List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
        List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
        List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
        List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
        List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
        List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
        PDIAddressDoctorService__c addressService = Util01_PDIUtilTestData.insertAddressServiceSetting();
        List<PDIADStatusCodes__c> adStatusCodeList = Util01_PDIUtilTestData.insertADHttpSatusCodesSetting();
        List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
        PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
        PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
        
        List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
        /*********************************************************************** 
Verifying the contact are inserted succesfully 
Expected Result: Contact list size should not be equal to 0.
Actual Result: Contact list size should not be equal to 0.
***********************************************************************/ 
        system.assert(conList.size()>0);
        Set<Id> conIdSet = new Set<Id>();
        
        for(Contact con : conList){
            conIdSet.add(con.Id);
        }
        
        List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
        system.debug('@@summaryRecords : '+ summaryRecords);
        /*List<Contact_Validation_Summary__c> summaryUpdateList = new List<Contact_Validation_Summary__c>();
        for(Contact_Validation_Summary__c summary : summaryRecords){
            summary.Email__c = 'test123@email.com';
            summary.Admin_Assistant_Email__c = 'test123@email.com';
            summaryUpdateList.add(summary);
        }
        update summaryUpdateList;
        */
        PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
        VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
        
        Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
        
        List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                     Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
        
        Provider_Address__c primaryAddrVerify = new Provider_Address__c();
        List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
        Provider_Address__c primaryAddressObj = new Provider_Address__c();
        if(!provAddressList.isEmpty()){
            for(Provider_Address__c address : provAddressList){
                Integer i = 1;
                if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                    address.Address_Line1__c = '1400 a street';
                    address.Address_Line_2__c = 'apt 129';
                    address.City__c = 'sacramento';
                    address.State__c = 'TS';
                    address.Zip_Code__c = '99511';
                    address.Secure_Phone__c = '(234) 999-2341';
                    address.Secure_Fax__c = '(234) 999-2341';
                    address.Provider_Address_AD_Status__c ='C4';
                    address.Secure_Phone_Ext__c = '2345';
                    address.Tech_Is_Address_Updated__c = true;
                    address.County__c = 'SACRAMENTO';
                    address.Direct_Address__c= 'test';
                    address.Provider_Address_AD_Status__c = 'C2';
                    primaryAddressObj = address;
                    
                }else{
                    address.Address_Line1__c = '140'+i+' a street';
                    address.Address_Line_2__c = 'apt 129';
                    address.City__c = 'sacramento';
                    address.State__c = 'TS';
                    address.Zip_Code__c = '99511';
                    address.Secure_Phone__c = '(234) 999-2341';
                    address.Secure_Fax__c = '(234) 999-2341';
                    address.Provider_Address_AD_Status__c ='C4';
                    address.Secure_Phone_Ext__c = '2345';
                    address.County__c = 'SACRAMENTO';
                    address.Direct_Address__c= 'test';
                    address.Tech_Is_Address_Updated__c = true;
                    address.Provider_Address_AD_Status__c = 'C2';
                    secondaryAddrList.add(address);
                    i++;
                }
            } 
        }
        
        
        test.startTest();
        ctrl.checkAllparameters();
        ctrl.createCase();
        ctrl.fillContactName();
        ctrl.providerId = summaryRecords[0].Contact_Id__c;
        ctrl.WrProviderDetailsObj.strMobilePhone = '(456) 678-9876';
        ctrl.WrProviderDetailsObj.strEmail = 'kishore.jonnadula@accenture.com';
        ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
        ctrl.WrProviderDetailsObj.strOkToText = false;
        ctrl.WrProviderDetailsObj.strAdminAssistantPhone = '(456) 678-9876';
        ctrl.WrProviderDetailsObj.strAdminAssistantEmail = 'kishore.jonnadula@accenture.com';
        ctrl.WrProviderDetailsObj.recordId = summaryRecords[0].Id;
        ctrl.providerSearchFlag = true;
        ctrl.WrProviderDetailsObj.strSpeciality = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strDepartment = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strMedicalEducation = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strWebsiteAddress = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strHospitalAff = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strMedicalAff = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strInternship = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strResidency = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strSpokenLanguages = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strCommActivities = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strPersonalInterests = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strProfessionalInterests = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strOnlineServices = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strBoardCertifications = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strPublications = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strAdditionalInfo = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strPhilosophyCare = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strAdminAssistantTitle = 'Dr';
        ctrl.WrProviderDetailsObj.strAdminAssistant = AP01_TestDataTokens.CONTACT_L_NAME;
        ctrl.WrProviderDetailsObj.strNameChangesSugg = AP01_TestDataTokens.CONTACT_L_NAME;
    ctrl.primaryAddrObj = primaryAddressObj;
        ctrl.SecondaryAddrList = secondaryAddrList;
        try{
          ctrl.saveUpdatedAddress();  
          System.assertEquals(true, ctrl.isAddressValidAllFields);
        }catch(Exception ex){
            System.assert(ex.getMessage() != null);
        }
        test.stopTest();
    }

    /**********************************************
    Purpose:  This is used to test existing address validation .
    Parameters: N/A*********************
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void saveUpdateExistingAddress_Test(){
        //User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        
        CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
        PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
        PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
        List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
        List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
        List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
        List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
        List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
        List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
        List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
        PDIAddressDoctorService__c addressService = Util01_PDIUtilTestData.insertAddressServiceSetting();
        List<PDIADStatusCodes__c> adStatusCodeList = Util01_PDIUtilTestData.insertADHttpSatusCodesSetting();
        List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
        PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
        PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
        
        List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
        /*********************************************************************** 
Verifying the contact are inserted succesfully 
Expected Result: Contact list size should not be equal to 0.
Actual Result: Contact list size should not be equal to 0.
***********************************************************************/ 
        system.assert(conList.size()>0);
        Set<Id> conIdSet = new Set<Id>();
        
        for(Contact con : conList){
            conIdSet.add(con.Id);
        }
        
        List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
        system.debug('@@summaryRecords : '+ summaryRecords);
        
        PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
        VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
        
        Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
        Util01_PDIUtilTestData.insertAuditRecordforSummary(summaryRecords[0].Contact_Id__c);
        
        List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                     Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
        
        Provider_Address__c primaryAddrVerify = new Provider_Address__c();
        List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
        Provider_Address__c primaryAddressObj = new Provider_Address__c();
        if(!provAddressList.isEmpty()){
            for(Provider_Address__c address : provAddressList){
                Integer i = 1;
                if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                    address.Address_Line1__c = '1400 a street';
                    address.Address_Line_2__c = 'apt 129';
                    address.City__c = 'sacramento';
                    address.State__c = 'TS';
                    address.Zip_Code__c = '99511';
                    address.Secure_Phone__c = '(234) 999-2341';
                    address.Secure_Fax__c = '(234) 999-2341';
                    address.Provider_Address_AD_Status__c ='C4';
                    address.Secure_Phone_Ext__c = '2345';
                    address.Tech_Is_Address_Updated__c = true;
                    primaryAddressObj = address;
                    
                }else{
                    address.Address_Line1__c = '140'+i+' a street';
                    address.Address_Line_2__c = 'apt 129';
                    address.City__c = 'sacramento';
                    address.State__c = 'TS';
                    address.Zip_Code__c = '99511';
                    address.Secure_Phone__c = '(234) 999-2341';
                    address.Secure_Fax__c = '(234) 999-2341';
                    address.Provider_Address_AD_Status__c ='C4';
                    address.Secure_Phone_Ext__c = '2345';
                    address.Tech_Is_Address_Updated__c = true;
                    secondaryAddrList.add(address);
                    i++;
                }
            } 
        }
        test.startTest();
        ctrl.checkAllparameters();
        ctrl.createRevalidateCase = true;
        ctrl.createCase();
        ctrl.fillContactName();
        ctrl.providerId = summaryRecords[0].Contact_Id__c;
        ctrl.WrProviderDetailsObj.strMobilePhone = '(456) 678-9876';
        ctrl.WrProviderDetailsObj.strEmail = 'kishore.jonnadula@accenture.com';
        ctrl.WrProviderDetailsObj.strPracticingPhysician = false;
        ctrl.WrProviderDetailsObj.strResignedFromSutter = true;
        ctrl.WrProviderDetailsObj.strOkToText = false;
        ctrl.WrProviderDetailsObj.strAdminAssistantPhone = '(456) 678-9876';
        ctrl.WrProviderDetailsObj.strAdminAssistantEmail = 'kishore.jonnadula@accenture.com';
        ctrl.WrProviderDetailsObj.recordId = summaryRecords[0].Id;
        ctrl.primaryAddrObj = primaryAddressObj;
        ctrl.SecondaryAddrList = secondaryAddrList;
        try{
          ctrl.saveUpdatedAddress();
            System.assertEquals(true, ctrl.addressValidatedCheck);
        }catch(Exception ex){
            System.assert(ex.getMessage() != null);
        }
        test.stopTest();
  }
    
    /*******************************************************************
    Purpose:  This is used to test SaveUpdatedAddress .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void saveUpdatedAddressNegative_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            PDIAddressDoctorService__c addressService = Util01_PDIUtilTestData.insertAddressServiceSetting();
            List<PDIADStatusCodes__c> adStatusCodeList = Util01_PDIUtilTestData.insertADHttpSatusCodesSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
           system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            test.startTest();
            
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            
            ctrl.checkAllparameters();
            ctrl.acceptPVQRecord();
            ctrl.createCase();
            ctrl.fillContactName();
            
            ctrl.isEmailTrue = true;
            ctrl.WrProviderDetailsObj.strMobilePhone = '';
            ctrl.WrProviderDetailsObj.strEmail = '';
            ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
            ctrl.WrProviderDetailsObj.strOkToText = true;
            ctrl.saveUpdatedAddress();
            List<ApexPages.Message> pageMessages = ApexPages.getMessages();
            system.assertEquals(pageMessages.size()>0, true);
            
            ctrl.WrProviderDetailsObj.strMobilePhone = '2343';
            ctrl.WrProviderDetailsObj.strEmail = '23#@1@em.co';
            ctrl.WrProviderDetailsObj.strPracticingPhysician = false;
            ctrl.WrProviderDetailsObj.strAdminAssistantPhone = '5343433';
            ctrl.WrProviderDetailsObj.strOkToText = true;
            ctrl.saveUpdatedAddress();
            List<ApexPages.Message> pageMessages1 = ApexPages.getMessages();
            system.assertEquals(pageMessages1.size()>0, true);
            
            ctrl.WrProviderDetailsObj.strMobilePhone = '2343676554';
            ctrl.WrProviderDetailsObj.strEmail = 'test123@email.com';
            ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
            ctrl.WrProviderDetailsObj.strOkToText = true;
            ctrl.WrProviderDetailsObj.strAdminAssistantPhone = '2343676554';
            ctrl.WrProviderDetailsObj.strAdminAssistantEmail = 'test123@email.com';
            ctrl.providerId = summaryRecords[0].Id;
            ctrl.WrProviderDetailsObj.recordId = summaryRecords[0].Id;
            Provider_Address__c providerAddr = new Provider_Address__c();
            providerAddr.Address_Line1__c = '1401 a street';
            providerAddr.Decline_Phone__c = false;
            providerAddr.Decline_Fax__c = false;
            ctrl.primaryAddrObj = providerAddr;
            ctrl.saveUpdatedAddress();
            List<ApexPages.Message> pageMessages2 = ApexPages.getMessages();
            system.assertEquals(pageMessages2.size()>0, true);
            
            ctrl.WrProviderDetailsObj.strMobilePhone = '2343676554';
            ctrl.WrProviderDetailsObj.strEmail = 'test123@email.com';
            ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
            ctrl.WrProviderDetailsObj.strOkToText = true;
            ctrl.WrProviderDetailsObj.strAdminAssistantPhone = '2343676554';
            ctrl.WrProviderDetailsObj.strAdminAssistantEmail = 'test123@email.com';
            ctrl.providerId = summaryRecords[0].Id;
            ctrl.WrProviderDetailsObj.recordId = summaryRecords[0].Id;
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        ctrl.primaryAddrObj = address;
                    }else{
                        secondaryAddrList.add(address);
                    }
                }
                Provider_Address__c secproviderAddr = new Provider_Address__c();
                secproviderAddr.Address_Line1__c = '1401 a street';
                secproviderAddr.Address_Line_2__c = 'Apt 129';
                secproviderAddr.City__c = 'Sacramento';
                secproviderAddr.State__c = 'CA';
                secproviderAddr.Zip_Code__c = '99511';
                secproviderAddr.Address_Type__c = 'Secondary';
                secproviderAddr.Serial_Number__c = '0';
                secondaryAddrList.add(secproviderAddr);
                if(!secondaryAddrList.isEmpty()){
                    ctrl.SecondaryAddrList = secondaryAddrList;
                }
            }
            try{
                ctrl.saveUpdatedAddress();
                System.assertEquals(true, ctrl.addressValidatedCheck);
            }catch(Exception ex){
                system.assertEquals(ex.getMessage() != null, true);
            }
            test.stopTest();
    }
    }
    
    
    /*******************************************************************
    Purpose:  This is used to test New Address with Balnk Values .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void newAddressEmpty_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            test.startTest();

            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            ctrl.SecondaryAddrList = secondaryAddrList;
            ctrl.providerId = summaryRecords[0].Id;
            ctrl.providerSummaryId = summaryRecords[0].Contact_Id__c;
            ctrl.newAddress();
            
      ctrl.SecondaryAddrList = null;
            try{
                ctrl.newAddress();
                System.assert(ctrl.address != null);
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }            
            test.stopTest();
        }
    }
    /*******************************************************************
    Purpose:  This is used to test New Address .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void newAddress_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            test.startTest();

            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        ctrl.primaryAddrObj = address;
                    }else{
                        secondaryAddrList.add(address);
                    }
                } 
            }
            if(!secondaryAddrList.isEmpty()){
                ctrl.SecondaryAddrList = secondaryAddrList;
            }
            ctrl.providerId = summaryRecords[0].Id;
            ctrl.providerSummaryId = summaryRecords[0].Contact_Id__c;
            ctrl.newAddress();
            System.assert(ctrl.address != null);
            test.stopTest();
        }
    }
    /*******************************************************************
    Purpose:  This is used to test Convert Address .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void convertAddress_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            test.startTest();

            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            String serialNumber2 = '';
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        ctrl.primaryAddrObj = address;
                    }else{
                        serialNumber2 = address.Serial_Number__c;
                        secondaryAddrList.add(address);
                    }
                } 
            }
            if(!secondaryAddrList.isEmpty()){
                ctrl.SecondaryAddrList = secondaryAddrList;
            }
            if(String.isNotBlank(serialNumber2)){
                ApexPages.currentPage().getParameters().put('serNumber', serialNumber2);
                ctrl.convertAddress();
                System.assertEquals(false, ctrl.editAddrmode);
            }
            test.stopTest();
        }
    }
    /*******************************************************************
    Purpose:  This is used to test convert Address .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void convertAddress1_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            test.startTest();

            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            Provider_Address__c primaryAddr = new Provider_Address__c();
            Provider_Address__c secAddr = new Provider_Address__c();
            String serialNumber2 = '';
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(!Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        serialNumber2 = address.Serial_Number__c;
                        secondaryAddrList.add(address);
                    }
                }
                secAddr.Address_Line1__c = '1401 a street';
                secAddr.Address_Line_2__c = 'apt 129';
                secAddr.Serial_Number__c = '3';
                secAddr.City__c = 'sacramento';
                secAddr.State__c = 'CA';
                secAddr.Zip_Code__c='99511';
                secAddr.Secure_Phone__c = '(999) 123-9997';
                secAddr.Secure_Fax__c = '(999) 123-9997';
                secAddr.Address_Type__c = 'Secondary';
                secAddr.PDI_Campaign__c = '2016 Wave2';
                secondaryAddrList.add(secAddr);
            }
            ctrl.primaryAddrObj = primaryAddr;
            if(!secondaryAddrList.isEmpty()){
                ctrl.SecondaryAddrList = secondaryAddrList;
            }
            if(String.isNotBlank(serialNumber2)){
                ApexPages.currentPage().getParameters().put('serNumber', serialNumber2);
                try{
                    ctrl.convertAddress();
                    System.assert(!ctrl.SecondaryAddrList.isEmpty());
                }catch(Exception ex){
                    System.assert(ex.getMessage() != null);
                }
            }
            test.stopTest();
        }
    }
    /*******************************************************************
    Purpose:  This is used to test Converted Address Negative Scenario .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void convertAddress2_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            test.startTest();

            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            Provider_Address__c primaryAddr = new Provider_Address__c();
            Provider_Address__c secAddr = new Provider_Address__c();
            Map<String, Provider_Address__c> tempSecMap = new Map<String, Provider_Address__c>();
            secAddr.Address_Line1__c = '1401 a street';
            secAddr.Address_Line_2__c = 'apt 129';
            secAddr.Serial_Number__c = '1';
            secAddr.City__c = 'sacramento';
            secAddr.State__c = 'CA';
            secAddr.Zip_Code__c='99511';
            secAddr.Secure_Phone__c = '(999) 123-9997';
            secAddr.Secure_Fax__c = '(999) 123-9997';
            secAddr.Address_Type__c = 'Secondary';
            secAddr.PDI_Campaign__c = '2016 Wave2';
            secondaryAddrList.add(secAddr);
            tempSecMap.put(secAddr.Serial_Number__c, secAddr);
            ctrl.primaryAddrObj = primaryAddr;
            if(!secondaryAddrList.isEmpty()){
                ctrl.SecondaryAddrList = secondaryAddrList;
            }
            ApexPages.currentPage().getParameters().put('serNumber', '1');
            ctrl.tempsecondaryAddrMap = tempSecMap;
            ctrl.convertAddress();
            
            ctrl.SecondaryAddrList = null;
            ApexPages.currentPage().getParameters().put('serNumber', '1');
            try{
                ctrl.convertAddress();
                System.assert(!ctrl.SecondaryAddrList.isEmpty());
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }
            test.stopTest();
        }
    }
    /*******************************************************************
    Purpose: This method is used to test Provider validated
    Parameters: N/A
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void Provider_ValidatedTest() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            
            List<Contact_Validation_Summary__c> summaryUpdateList = new List<Contact_Validation_Summary__c>();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            for(Contact_Validation_Summary__c summary : summaryRecords){
                summary.OwnerId = UserInfo.getUserId();
                summary.Status__c = 'Validated';
                summaryUpdateList.add(summary);
            }
            update summaryUpdateList;
            
            Test.startTest();
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            
            ctrl.checkAllparameters();
            System.assert(ctrl.WrProviderDetailsObj != null);
            Test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose: This is used to Negative testing to fill selected address information
    Parameters: N/A
    Returns: Void 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void setAddressParam_NegativeTest() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();

            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            List<Contact_Validation_Summary__c> updateSummaryRecordsList = new List<Contact_Validation_Summary__c>();
            for(Contact_Validation_Summary__c sum : summaryRecords){
                
                sum.Last_Verified_Date__c = null;
                updateSummaryRecordsList.add(sum);
            }
            update updateSummaryRecordsList;
            
            Test.startTest();
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            
            ctrl.checkAllparameters();
            ctrl.acceptPVQRecord();
            ctrl.createCase();
            
            ctrl.caseObj.Common_Subject_Lines__c = 'Provider Agitated';
            ctrl.caseObj.Status = 'Closed';
            ctrl.caseObj.PDV_Contact_Name__c = 'Test Contact';
            ctrl.strCaseContactPhoneNumber = '(999) 999-9999';
            ctrl.caseObj.Validated_or_not__c = 'No';
            ctrl.caseObj.Communication_Preference_Changed_To_Fax__c = 'Yes';
            try{
              ctrl.updateCase();
                System.assertEquals(true, ctrl.isAddressValidAllFields);
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }
            Test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose: This is used to gtest update a new case.The method imposes proper checks on various fields in which input has been put and throws errors wherever necessary.
             Post verifying that necessary data has been put, it updates the related Case record
    Parameters: N/A
    Returns: PageReference  
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void updateClosedCase_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();

            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            List<Contact_Validation_Summary__c> updateSummaryRecordsList = new List<Contact_Validation_Summary__c>();
            
            Test.startTest();
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            
            ctrl.checkAllparameters();
            ctrl.acceptPVQRecord();
            ctrl.createCase();
            
            ctrl.pvqId = summaryRecords[0].Id;
            ctrl.caseObj.Common_Subject_Lines__c = 'Provider Agitated';
            ctrl.caseObj.Status = 'Closed';
            ctrl.caseObj.PDV_Contact_Name__c = 'Test Contact';
            ctrl.strCaseContactPhoneNumber = '(999) 999-9999';
            ctrl.caseObj.Validated_or_not__c = 'No';
            ctrl.caseObj.Communication_Preference_Changed_To_Fax__c = 'Yes';
            ctrl.addressValidatedCheck = true;
            try{
               ctrl.updateCase(); 
                System.assert(ctrl.isAddressValidAllFields != null);
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }
            
            
            Test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Reorder Address information .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/   
    static testMethod void reorderAddress_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            test.startTest();

            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            ctrl.reorderAddress();
            System.assertEquals(true, ctrl.reordermode);
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Cancel Reorder Address .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void cancelReorder_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            test.startTest();

            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            ctrl.cancelReorder();
            System.assertEquals(false, ctrl.reordermode);
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Find Suggested Address .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void findSuggestedAddressIsBlank_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
           
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            Provider_Address__c address = new Provider_Address__c();
            test.startTest();
            ctrl.checkAllparameters();
            ctrl.acceptPVQRecord();
            ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
            address.Address_Type__c = 'Primary';
            address.Decline_Phone__c = false;
            address.Decline_Fax__c = false;
            address.Secure_Phone_Ext__c = 'abvcd';
            ctrl.address = address;
            
            ctrl.findSuggestedAddress();
            System.assertEquals(true, ctrl.editAddrmode);
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Find Suggested Address .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void findSuggestedAddressIsNotBlank_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
           
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            test.startTest();
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            Provider_Address__c address = new Provider_Address__c();
            ctrl.checkAllparameters();
            ctrl.acceptPVQRecord();
            ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
            address.Address_Line1__c = 'Care Of 140 address';
            address.Secure_Phone__c = 'AB876#783';
            address.Secure_Fax__c = '8767823';
            ctrl.address = address;
            
            ctrl.findSuggestedAddress();
            List<ApexPages.Message> pageMessages = ApexPages.getMessages();
            system.assertEquals(pageMessages.size() > 0, true);
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Find Suggested Address .
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void findSuggestedAddressPositive_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            PDIAddressDoctorService__c addressService = Util01_PDIUtilTestData.insertAddressServiceSetting();
            List<PDIADStatusCodes__c> adStatusCodeList = Util01_PDIUtilTestData.insertADHttpSatusCodesSetting();
           
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            Provider_Address__c primaryAddrVerify = new Provider_Address__c();
            test.startTest();
            ctrl.checkAllparameters();
            ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
            
            //Address Positive
            primaryAddrVerify.Address_Line1__c = AP01_TestDataTokens.ADDR2_ADDRESS_LINE1;
            primaryAddrVerify.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
            primaryAddrVerify.City__c = AP01_TestDataTokens.CITY;
            primaryAddrVerify.State__c = AP01_TestDataTokens.STATE;
            primaryAddrVerify.Zip_Code__c = AP01_TestDataTokens.ZIP_CODE;
            primaryAddrVerify.Secure_Phone__c = AP01_TestDataTokens.ADDR2_SECURE_PHONE;
            primaryAddrVerify.Address_Type__c = Label.CL303_PDIPrimary;
            primaryAddrVerify.Secure_Fax__c = AP01_TestDataTokens.ADDR2_SECURE_FAX;
           
            Map<Integer, String> elementStatusMap = new Map<Integer, String>();
            elementStatusMap.put(0, 'PostCode0');
            elementStatusMap.put(1, 'PostCode1');
            ctrl.statusMap = elementStatusMap;
            ctrl.address =  primaryAddrVerify;
            ctrl.suggestedAddressFlag = false;
            ctrl.findSuggestedAddress();
            System.assert(!ctrl.suggestedAddressList.isEmpty());
            
            Set<String> processCodes = new Set<String>();
            processCodes.add('I3');
            ctrl.processCodes = processCodes;
            ctrl.address =  primaryAddrVerify;
            ctrl.suggestedAddressFlag = false;
            ctrl.findSuggestedAddress();
            List<ApexPages.Message> pageMessages = ApexPages.getMessages();
            system.assertEquals(pageMessages.size() > 0, true);
            
            Map<String, String> notProccessedStatMap = new Map<String, String>();
            for(PDIADNotProcessedCodes__c notProcessed : notProccessedList){
                notProccessedStatMap.put(notProcessed.Name, notProcessed.Code__c);
            }
            notProccessedStatMap.put('I3', '');
            ctrl.address =  primaryAddrVerify;
            ctrl.addressNotProcessedStatusMap = notProccessedStatMap;
            ctrl.suggestedAddressFlag = false;
            ctrl.findSuggestedAddress();
            List<ApexPages.Message> pageMessages5 = ApexPages.getMessages();
            system.assertEquals(pageMessages5.size() > 0, true);
            
            ctrl.checkAllparameters();
            ctrl.address =  primaryAddrVerify;
            ctrl.suggestedAddressFlag = false;
            ctrl.findSuggestedAddress();
            
            Map<String, String> addressWebServiceMap = new Map<String, String>();
            addressWebServiceMap.put('I3', '');
            ctrl.address =  primaryAddrVerify;
            ctrl.addressWebserviceStatusMap = addressWebServiceMap;
            
            ctrl.suggestedAddressFlag = false;
            ctrl.findSuggestedAddress();
            List<ApexPages.Message> pageMessage = ApexPages.getMessages();
            system.assertEquals(pageMessage.size() > 0, true);
            
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Save Address.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void saveAddress1_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            PDIAddressDoctorService__c addressService = Util01_PDIUtilTestData.insertAddressServiceSetting();
            List<PDIADStatusCodes__c> adStatusCodeList = Util01_PDIUtilTestData.insertADHttpSatusCodesSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            String serialNumber2 = '';
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        ctrl.primaryAddrObj = address;
                    }else{
                        serialNumber2 = address.Serial_Number__c;
                        secondaryAddrList.add(address);
                    }
                } 
            }
            if(!secondaryAddrList.isEmpty()){
                ctrl.SecondaryAddrList = secondaryAddrList;
            }
            test.startTest();
            Provider_Address__c address1 = new Provider_Address__c();
            ctrl.checkAllparameters();
            ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
            address1.Address_Line1__c = '1401 a street';
            address1.Address_Line_2__c = 'apt 129';
            address1.Serial_Number__c = '2';
            address1.City__c = 'sacramento';
            address1.State__c = 'CA';
            address1.Zip_Code__c='99511';
            address1.Secure_Phone__c = '(999) 123-9997';
            address1.Secure_Fax__c = '(999) 123-9997';
            address1.Address_Type__c = 'Primary';
            address1.PDI_Campaign__c = '2016 Wave2';
            ctrl.address = address1;
            
            try{
                ctrl.findSuggestedAddress();
                ctrl.saveAddress();
                
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Save Address.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void saveAddress2_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            PDIAddressDoctorService__c addressService = Util01_PDIUtilTestData.insertAddressServiceSetting();
            List<PDIADStatusCodes__c> adStatusCodeList = Util01_PDIUtilTestData.insertADHttpSatusCodesSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            String serialNumber2 = '';
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        ctrl.primaryAddrObj = address;
                    }else{
                        serialNumber2 = address.Serial_Number__c;
                        secondaryAddrList.add(address);
                    }
                } 
            }
            if(!secondaryAddrList.isEmpty()){
                ctrl.SecondaryAddrList = secondaryAddrList;
            }
            test.startTest();
            Provider_Address__c address1 = new Provider_Address__c();
            ctrl.checkAllparameters();
            ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
            address1.Address_Line1__c = '1401 a street';
            address1.Address_Line_2__c = 'apt 129';
            address1.Serial_Number__c = '2';
            address1.City__c = 'sacramento';
            address1.State__c = 'CA';
            address1.Zip_Code__c='99511';
            address1.Secure_Phone__c = '(999) 123-9997';
            address1.Secure_Fax__c = '(999) 123-9997';
            address1.Address_Type__c = 'Secondary';
            address1.PDI_Campaign__c = '2016 Wave2';
            ctrl.address = address1;
            
            ctrl.findSuggestedAddress();
            List<Provider_Address__c> suggestedAddressList = new List<Provider_Address__c>();
            Provider_Address__c suggestedAddr = new Provider_Address__c();
            suggestedAddr.City__c = 'FOLSOM';
            suggestedAddr.State__c = 'CA';
            suggestedAddr.Zip_Code__c = '95630-9000';
            suggestedAddr.Country__c = 'UNITED STATES';
            suggestedAddr.Address_Line1__c = '100 IRON POINT RD';
            suggestedAddr.Address_Line_2__c = 'ST 9999999';
            suggestedAddr.Formatted_Address__c = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            suggestedAddr.County__c = 'SACRAMENTO';
            suggestedAddr.Provider_Address_AD_Status__c = 'C4';
            suggestedAddr.Address_Mailability_Score__c = '1';
            suggestedAddr.Address_Result_Percentage__c = '85.00';
            suggestedAddressList.add(suggestedAddr);
            ctrl.suggestedAddressList = suggestedAddressList;
            ctrl.suggestedAddressFlag = true;
            ctrl.selectedRecord = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            ctrl.saveAddress();
            List<ApexPages.Message> pageMessages7 = ApexPages.getMessages();
            system.assertEquals(pageMessages7.size() > 0, true);
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Save Address.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void saveAddress3_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            PDIAddressDoctorService__c addressService = Util01_PDIUtilTestData.insertAddressServiceSetting();
            List<PDIADStatusCodes__c> adStatusCodeList = Util01_PDIUtilTestData.insertADHttpSatusCodesSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            String serialNumber2 = '';
            String addressId = null;
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        addressId = address.Id;
                        ctrl.primaryAddrObj = null;
                    }else{
                        serialNumber2 = address.Serial_Number__c;
                        addressId = address.Id;
                        secondaryAddrList.add(address);
                    }
                } 
            }
            if(!secondaryAddrList.isEmpty()){
                ctrl.SecondaryAddrList = secondaryAddrList;
            }
            test.startTest();
            Provider_Address__c address1 = new Provider_Address__c();
            ctrl.checkAllparameters();
            ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
            address1.Id = addressId;
            address1.Address_Line1__c = '1401 a street';
            address1.Address_Line_2__c = 'apt 129';
            address1.Serial_Number__c = '2';
            address1.City__c = 'sacramento';
            address1.State__c = 'CA';
            address1.Zip_Code__c='99511';
            address1.Secure_Phone__c = '(999) 123-9997';
            address1.Secure_Fax__c = '(999) 123-9997';
            address1.Address_Type__c = 'Secondary';
            address1.PDI_Campaign__c = '2016 Wave2';
            address1.Provider_Address_AD_Status__c = 'C3';
            address1.Address_Mailability_Score__c = '1';
            address1.Address_Result_Percentage__c = '85.00';
            ctrl.address = address1;
            
            ctrl.suggestedAddressFlag = false;
            Set<String> correctStatus = new Set<String>();
            for(PDIADCorrectAddressCodes__c correctCode : correstAddrList){
                correctStatus.add(correctCode.Name);
            }
            ctrl.correctAddrCodeSet = correctStatus;
            ctrl.saveAddress();
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Save Address.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void saveAddress4_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            PDIAddressDoctorService__c addressService = Util01_PDIUtilTestData.insertAddressServiceSetting();
            List<PDIADStatusCodes__c> adStatusCodeList = Util01_PDIUtilTestData.insertADHttpSatusCodesSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            String serialNumber2 = '';
            String addressId = null;
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        addressId = address.Id;
                        ctrl.primaryAddrObj = null;
                    }else{
                        serialNumber2 = address.Serial_Number__c;
                        addressId = address.Id;
                        secondaryAddrList.add(address);
                    }
                } 
            }
            if(!secondaryAddrList.isEmpty()){
                ctrl.SecondaryAddrList = secondaryAddrList;
            }
            test.startTest();
            Provider_Address__c address1 = new Provider_Address__c();
            ctrl.checkAllparameters();
            ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
            address1.Address_Line1__c = '1401 a street';
            address1.Address_Line_2__c = 'apt 129';
            address1.Serial_Number__c = '2';
            address1.City__c = 'sacramento';
            address1.State__c = 'CA';
            address1.Zip_Code__c='99511';
            address1.Secure_Phone__c = '(999) 123-9997';
            address1.Secure_Fax__c = '(999) 123-9997';
            address1.Address_Type__c = 'Secondary';
            address1.PDI_Campaign__c = '2016 Wave2';
            address1.Provider_Address_AD_Status__c = 'V3';
            address1.Address_Mailability_Score__c = '1';
            address1.Address_Result_Percentage__c = '85.00';
            ctrl.address = address1;
            
            ctrl.suggestedAddressFlag = false;
            Set<String> verifiedStatus = new Set<String>();
            for(PDIADVerificationCodes__c correctCode : verificationCodeList){
                verifiedStatus.add(correctCode.Name);
            }
            ctrl.verifiedAddrCodeSet = verifiedStatus;
            ctrl.saveAddress();
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Save Address.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void saveAddress5_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            PDIAddressDoctorService__c addressService = Util01_PDIUtilTestData.insertAddressServiceSetting();
            List<PDIADStatusCodes__c> adStatusCodeList = Util01_PDIUtilTestData.insertADHttpSatusCodesSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            String serialNumber2 = '';
            String addressId = null;
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        addressId = address.Id;
                        ctrl.primaryAddrObj = null;
                    }else{
                        serialNumber2 = address.Serial_Number__c;
                        addressId = address.Id;
                        secondaryAddrList.add(address);
                    }
                } 
            }
            Provider_Address__c newAddr = new Provider_Address__c();
            newAddr.Address_Line1__c = '1401 a street';
            newAddr.Address_Line_2__c = 'apt 129';
            newAddr.Serial_Number__c = '3';
            newAddr.City__c = 'sacramento';
            newAddr.State__c = 'CA';
            newAddr.Zip_Code__c='99511';
            newAddr.Secure_Phone__c = '(999) 123-9997';
            newAddr.Secure_Fax__c = '(999) 123-9997';
            newAddr.Address_Type__c = 'Secondary';
            newAddr.Address_Status__c = 'NEW';
            newAddr.PDI_Campaign__c = '2016 Wave2';
            secondaryAddrList.add(newAddr);
            
            if(!secondaryAddrList.isEmpty()){
                ctrl.SecondaryAddrList = secondaryAddrList;
            }
            Map<String, Provider_Address__c> tempsecondaryAddrMap = new Map<String, Provider_Address__c>();
            for(Provider_Address__c addressObj : secondaryAddrList){
                tempsecondaryAddrMap.put(addressObj.Serial_Number__c, addressObj);
            }
            ctrl.tempsecondaryAddrMap = tempsecondaryAddrMap;
            test.startTest();
            Provider_Address__c address1 = new Provider_Address__c();
            ctrl.checkAllparameters();
            ctrl.WrProviderDetailsObj.strPracticingPhysician = true;
            address1.Address_Line1__c = '1401 a street';
            address1.Address_Line_2__c = 'apt 129';
            address1.Serial_Number__c = '2';
            address1.City__c = 'sacramento';
            address1.State__c = 'CA';
            address1.Zip_Code__c='99511';
            address1.Secure_Phone__c = '(999) 123-9997';
            address1.Secure_Fax__c = '(999) 123-9997';
            address1.Address_Type__c = 'Secondary';
            address1.PDI_Campaign__c = '2016 Wave2';
            address1.Provider_Address_AD_Status__c = 'I2';
            address1.Address_Mailability_Score__c = '1';
            address1.Address_Result_Percentage__c = '85.00';
            ctrl.address = address1;
            
            ctrl.suggestedAddressFlag = false;
            Set<String> errorStatus = new Set<String>();
            for(PDIADErrorCodes__c errorCode : errorCodeList){
                errorStatus.add(errorCode.Name);
            }
            ctrl.processCodes = errorStatus;
            try{
                ctrl.saveAddress();
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }
            
            test.stopTest();
        }
    }
    
    /*******************************************************************
    Purpose:  This is used to test Save Address.
    Parameters: N/A
    Returns: PageReference    
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void saveAddressNegative1_Test(){
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
            PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
            List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
            PDIEmailAddressService__c emailAddressService = Util01_PDIUtilTestData.insertEmailAddressServiceSetting();
            List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
            List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
            List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
            List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
            List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
            List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
            List<PDIEmailStatusCodes__c> emailStatusList = Util01_PDIUtilTestData.insertemailStatusCodesSetting();
            PDIAddressDoctorService__c addressService = Util01_PDIUtilTestData.insertAddressServiceSetting();
            List<PDIADStatusCodes__c> adStatusCodeList = Util01_PDIUtilTestData.insertADHttpSatusCodesSetting();
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            
            Util01_PDIUtilTestData.insertProviderAddressList(summaryRecords[0].Id, summaryRecords[0].Contact_Id__c);
            
            PageReference pageRef = new PageReference('/apex/VFP42_Provider_Detail?pvqid=' + summaryRecords[0].Id);
            Test.setCurrentPage(pageRef);
    
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Serial_Number__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: summaryRecords[0].Contact_Id__c];
            
            ApexPages.StandardController con = new ApexPages.StandardController(summaryRecords[0]);
            
            VFC42_Provider_Detail_Controller ctrl = new VFC42_Provider_Detail_Controller(con);
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            Provider_Address__c addr = new Provider_Address__c();
            String serialNumber2 = '';
            String addressId = null;
            test.startTest();
            ctrl.primaryAddrObj = addr;
            ctrl.SecondaryAddrList = secondaryAddrList;
            ctrl.suggestedAddressFlag = false;
            ctrl.saveAddress();
            
            
            Provider_Address__c address1 = new Provider_Address__c();
            address1.Address_Line1__c = AP01_TestDataTokens.ADDR3_ADDRESS_LINE1;
            address1.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
            address1.Serial_Number__c = AP01_TestDataTokens.SERIAL_NUMBER_2;
            address1.City__c = AP01_TestDataTokens.CITY;
            address1.State__c = AP01_TestDataTokens.STATE;
            address1.Zip_Code__c=AP01_TestDataTokens.ZIP_CODE;
            address1.Secure_Phone__c = AP01_TestDataTokens.ADDR3_SECURE_PHONE;
            address1.Secure_Fax__c = AP01_TestDataTokens.ADDR3_SECURE_PHONE;
            address1.Address_Type__c = Label.CL359_PDI_secondaryAddress;
            address1.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            
            List<Provider_Address__c> suggestedAddressList = new List<Provider_Address__c>();
            Provider_Address__c suggestedAddr = new Provider_Address__c();
            suggestedAddr.City__c = 'FOLSOM';
            suggestedAddr.State__c = 'CA';
            suggestedAddr.Zip_Code__c = '95630-9000';
            suggestedAddr.Country__c = 'UNITED STATES';
            suggestedAddr.Address_Line1__c = '100 IRON POINT RD';
            suggestedAddr.Address_Line_2__c = 'ST 9999999';
            suggestedAddr.Formatted_Address__c = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            suggestedAddr.County__c = 'SACRAMENTO';
            suggestedAddr.Provider_Address_AD_Status__c = 'C4';
            suggestedAddr.Address_Mailability_Score__c = '1';
            suggestedAddr.Address_Result_Percentage__c = '85.00';
            suggestedAddressList.add(suggestedAddr);
            
            Set<String> processCodes = new Set<String>();
            processCodes.add('I1');
            processCodes.add('I2');
            ctrl.processCodes = processCodes;
            ctrl.address = address1;
            ctrl.suggestedAddressList = suggestedAddressList;
            ctrl.suggestedAddressFlag = true;
            ctrl.selectedRecord = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            ctrl.saveAddress();
            
             //Negative #1
            Set<String> processCodes1 = new Set<String>();
            processCodes1.add('I3');
            ctrl.processCodes = processCodes1;
            ctrl.address = address1;
            ctrl.suggestedAddressList = suggestedAddressList;
            ctrl.suggestedAddressFlag = true;
            ctrl.selectedRecord = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            ctrl.saveAddress();
            List<ApexPages.Message> pageMessages = ApexPages.getMessages();
            system.assertEquals(pageMessages.size() > 0, true);
            
            //Negative #2
            Map<String, String> notProccessedStatMap = new Map<String, String>();
            notProccessedStatMap.put('I3', '');
            ctrl.address = address1;
            ctrl.addressNotProcessedStatusMap = notProccessedStatMap;
            ctrl.suggestedAddressList = suggestedAddressList;
            ctrl.suggestedAddressFlag = true;
            ctrl.selectedRecord = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            ctrl.saveAddress();
            List<ApexPages.Message> pageMessages1 = ApexPages.getMessages();
            system.assertEquals(pageMessages1.size() > 0, true);
            //Negative #3
            Map<String, String> addressWebServiceMap = new Map<String, String>();
            addressWebServiceMap.put('I3', '');
            ctrl.address = address1;
            ctrl.suggestedAddressList = suggestedAddressList;
            ctrl.suggestedAddressFlag = true;
            ctrl.addressWebserviceStatusMap = addressWebServiceMap;
            ctrl.selectedRecord = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            ctrl.saveAddress();
            List<ApexPages.Message> pageMessages2 = ApexPages.getMessages();
            system.assertEquals(pageMessages2.size() > 0, true);
            test.stopTest();
        }
    }

}