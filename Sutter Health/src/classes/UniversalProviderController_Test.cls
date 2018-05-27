/**********************************************************************
Class Name   : UniversalProviderController_Test
Date Created : 06-10-2016
Created By   : IDC Offshore
Description  : Test class
Referenced/Used in : UniversalProviderController_Test
**********************************************************************/

@isTest
private class UniversalProviderController_Test {
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
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Provider Validation       
    * @return void        
    **/
    static testMethod void validate_Test(){
        Test.startTest();   
        
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
            List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
            // check user has been created from 1st contact record 
            User userObj = new User();
            userObj = [SELECT id, username FROM user WHERE contactId = :conlist[0].id];
           
            /*********************************************************************** 
            Verifying the user has been fetched successfully using system.assert() 
            Expected Result: User is not null
            Actual Result: User  is not null 
            ***********************************************************************/
            system.assert(userObj!=null);
        	System.runAs(userObj) {
                UniversalProviderController vpcObj = new UniversalProviderController();
                vpcObj.ifUserAuthenticated();
                vpcObj.redirectoFAQ();
                UniversalProviderController.wrapperFAQ faqwrap; 
                String article = Util01_PDIUtilTestData.testFAQData();
                vpcObj.articleContent = article;
                faqwrap=new UniversalProviderController.wrapperFAQ(article);
                vpcObj.contactId = conlist[0].id;
                Contact_Validation_Summary__c cvsObj = new Contact_Validation_Summary__c();
                cvsObj = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                                                           Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                                                           Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                                                           New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                                                           Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                                                           Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                                                           from Contact_Validation_Summary__c where 
                                                           address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
                System.assert(cvsObj != null);
                UniversalProviderController.providerInfoStruct providerInfo = new UniversalProviderController.providerInfoStruct();
                providerInfo.sc_address = AP01_TestDataTokens.sc_address;
                vpcObj.providerInfo = providerInfo;
                cvsObj.Mobile_Phone__c = AP01_TestDataTokens.mobilePhone;
                cvsObj.Practicing_Physician__c = true;
                cvsObj.Resigned_From_Sutter__c = true;
                cvsObj.Retired_Departed__c = false;
                cvsObj.Is_Resigned_Provider_refer__c = true;
                cvsObj.Address_Line_2__c = AP01_TestDataTokens.scAddressLine2;
                cvsObj.Secure_City__c = AP01_TestDataTokens.sc_city;
                cvsObj.Secure_State__c = AP01_TestDataTokens.sc_state;
                cvsObj.Ok_to_Text__c = false;
                cvsObj.Secure_Phone__c = AP01_TestDataTokens.sc_securePhone;
                cvsObj.Secure_Fax__c = AP01_TestDataTokens.sc_secureFax;
                cvsObj.Secure_Zip_Code__c = AP01_TestDataTokens.sc_zipCode;
                cvsObj.Admin_Assistant__c = AP01_TestDataTokens.sc_Admin_Assistant;
                cvsObj.Admin_Assistant_Email__c = AP01_TestDataTokens.sc_Admin_Assistant_Email;
                cvsObj.Admin_Assistant_Title__c = AP01_TestDataTokens.sc_Admin_Assistant_Title;
                cvsObj.Admin_Assistant_Phone__c = AP01_TestDataTokens.sc_Admin_Assistant_Phone;
                cvsObj.Preferred_Communication_Method__c = 'Fax';
                cvsObj.Communication_Preferences_HIM__c = 'Mail';
                cvsObj.Provider_Access_Type__c = AP01_TestDataTokens.sc_Provider_Access_Type;
                vpcObj.summaryObj = cvsObj;
                try{
                  vpcObj.save(); 
                  System.assertEquals('form', vpcObj.section);
                }catch(Exception ex){
                    System.assert(ex.getMessage() != null);
                }
            }
        Test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Admin Assistant insertion     
    * @return void        
    **/
    static testMethod void adminAssistant_Test(){
        Test.startTest();   
        
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
            List<Contact> conlist = [select id from contact where LastName = 'testAssistAdmintest123'];
            
            // check user has been created from 1st contact record 
            User userObj = new User();
        	userObj = [SELECT id, username FROM user WHERE contactId = :conlist[0].id];
           
            /*********************************************************************** 
            Verifying the user has been fetched successfully using system.assert() 
            Expected Result: User is not null
            Actual Result: User  is not null 
            ***********************************************************************/
            system.assert(userObj!=null);
        	System.runAs(userObj) {
                UniversalProviderController vpcObj = new UniversalProviderController();
                vpcObj.ifUserAuthenticated();
                vpcObj.redirectoFAQ();
                UniversalProviderController.wrapperFAQ faqwrap; 
                String article = Util01_PDIUtilTestData.testFAQData();
                vpcObj.articleContent = article;
                faqwrap=new UniversalProviderController.wrapperFAQ(article);
                System.assert(faqwrap != null);
                vpcObj.contactId = conlist[0].id;
                Contact_Validation_Summary__c cvsObj = new Contact_Validation_Summary__c();
                
                UniversalProviderController.providerInfoStruct providerInfo = new UniversalProviderController.providerInfoStruct();
                providerInfo.sc_address = '222 folsom';
                vpcObj.providerInfo = providerInfo;
                
                System.assertEquals('form', vpcObj.section);
            }
        Test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Redirect methods in UniversalProviderController      
    * @return void        
    **/
    static testMethod void redirectMethods_Test(){
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id, username FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        System.runAs(userObj) {
            UniversalProviderController vpcObj = new UniversalProviderController();
            vpcObj.redirectoHome();
            vpcObj.redirectoFAQ();
            vpcObj.redirectoChangePassword();
            vpcObj.redirectoProviderList();
            vpcObj.redirectoValidateProvider();
        }
        Test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of canecel provider method       
    * @return void        
    **/
    static testMethod void cancelProvider_Test(){
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id, username FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        System.runAs(userObj) {
            UniversalProviderController vpcObj = new UniversalProviderController();
            vpcObj.cancelProvider();
            vpcObj.reorderAddress();
            Boolean reordermode = vpcObj.reordermode;
            System.assert(reordermode);
        }
        Test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Change password method     
    * @return void        
    **/
    static testMethod void changePassword_Test(){
        Test.startTest();   
        
            List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
            
            // check user has been created from 1st contact record 
            User userObj = new User();
            userObj = [SELECT id, Username FROM user WHERE contactId = :conlist[0].id];
            
            /*********************************************************************** 
            Verifying the user has been fetched successfully using system.assert() 
            Expected Result: User is not null
            Actual Result: User  is not null 
            ***********************************************************************/
            system.assert(userObj!=null);
            System.runAs(userObj) {
                PDIPortalHomePage__c portalCustomSetting = Util01_PDIUtilTestData.createPDIPortalHomePageCustSetting();
                PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
                PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
                UniversalProviderController controller = new UniversalProviderController();
                controller.newPassword = AP01_TestDataTokens.NEW_PASSWORD;
                controller.confirmPassword = AP01_TestDataTokens.NEW_PASSWORD;
                controller.changePortalUserPassword();
                controller.redirectoChangePassword();
                controller.redirectoHome();
                controller.username = userObj.Username;
                controller.password = AP01_TestDataTokens.NEW_PASSWORD;
                controller.login();
                controller.redirectoValidateProvider();
            }
        Test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Cancel Address
    * @return void        
    **/
    static testMethod void cancelAddress_Test() {
        PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
        PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
        List<PDIAddressElementStatus__c> addressElement = Util01_PDIUtilTestData.insertAddressElementSetting();
        List<PDIResultStatusCodes__c> resultStatusCodeList = Util01_PDIUtilTestData.insertResultStatusCodesSetting();
        List<PDIADCorrectAddressCodes__c> correstAddrList = Util01_PDIUtilTestData.insertCorrectAddressSetting();
        List<PDIADErrorCodes__c> errorCodeList = Util01_PDIUtilTestData.insertErrorCodesSetting();
        List<PDIADVerificationCodes__c> verificationCodeList =  Util01_PDIUtilTestData.insertverifyAddressCodesSetting();
        List<PDIADNotProcessedCodes__c> notProccessedList = Util01_PDIUtilTestData.insertADNotProcessedCodesSetting();
        List<PDIADWebServiceStatusCodes__c> webServiceCodeList = Util01_PDIUtilTestData.insertADWebServiceStatusSetting();
        
        UniversalProviderController vpcObj = new UniversalProviderController();
        Test.startTest();
        vpcObj.suggestedAddressFlag = true;
        vpcObj.cancelAddress();
        Boolean editAddress = vpcObj.editAddrmode;
        System.assert(editAddress);
        vpcObj.suggestedAddressFlag = false;
        vpcObj.cancelAddress();
        Boolean editAddress1 = vpcObj.editAddrmode;
        System.assert(!editAddress1);
        Test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Cancel reorder method       
    * @return void        
    **/
    static testMethod void cancelReorder_Test(){
        CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
        PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
        
        Test.startTest();
        UniversalProviderController vpcObj = new UniversalProviderController();
        vpcObj.cancelReorder();
        Boolean reorderMode = vpcObj.reordermode;
        System.assert(!reorderMode);
        Test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of New Provider Address method      
    * @return void        
    **/
    static testMethod void newProviderAddress_Test() {
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
        
        Test.startTest();
        
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        
        UniversalProviderController vpcObj = new UniversalProviderController();
        vpcObj.redirectoValidateProvider();
        vpcObj.contactId = conlist[0].id;
        
        Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
        cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                   Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                   Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                   New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                   Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                   Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                   from Contact_Validation_Summary__c where 
                   address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
        
        vpcObj.summaryObj = cvsObj1;
        Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
        vpcObj.retriveAddressDetails();
        vpcObj.newAddress();
        Boolean editAddrMode = vpcObj.editAddrmode;
        System.assert(editAddrMode);
        List<Provider_Address__c> seccAddressList = new List<Provider_Address__c>();
        vpcObj.retriveAddressDetails();
        vpcObj.SecondaryAddrList = seccAddressList;
        vpcObj.newAddress();
        Boolean editAddrMode1 = vpcObj.editAddrmode;
        System.assert(editAddrMode1);
        seccAddressList = null;
        vpcObj.SecondaryAddrList = seccAddressList;
        try{
            vpcObj.newAddress();
        }catch(Exception ex){
          System.assert(ex.getMessage() != null);  
        }
        Test.stopTest();
    }

    /**        
    * @author IDC Team        
    * @description method to code coverage of get Selected Provider Address method    
    * @return void        
    **/
    static testMethod void getSelectedProviderAddress_Test() {
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        
        UniversalProviderController vpcObj = new UniversalProviderController();
        vpcObj.redirectoValidateProvider();
        vpcObj.contactId = conlist[0].id;
        
        Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
        cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                   Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                   Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                   New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                   Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                   Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                   from Contact_Validation_Summary__c where 
                   address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
        
        User IntegrationUser = Util01_PDIUtilTestData.prepareIntegrationUser();
        User inteUser = [SELECT Id FROM User WHERE Id = :IntegrationUser.Id Limit 1]; 
        System.runAs(inteUser){
            Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
        }
        List<Provider_Address__c> provAddressList1 = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, EPIC_Address_Status__c,
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
        
        List<Provider_Address__c> updateAddressList = new List<Provider_Address__c>();
        if(!provAddressList1.isEmpty()){
            for(Provider_Address__c address : provAddressList1){
                if('Inactive'.equalsIgnoreCase(address.EPIC_Address_Status__c)){
                    address.EPIC_Address_Status__c = 'Active';
                }
                updateAddressList.add(address);
            }
            try{
                System.runAs(inteUser){
                    update updateAddressList;
                }
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);  
            }
        }
		
        List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, EPIC_Address_Status__c,
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
        vpcObj.summaryObj = cvsObj1;
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
        vpcObj.retriveAddressDetails();
        ApexPages.currentPage().getParameters().put('addressId', addressId);
        vpcObj.getselectedAddress();
        
        vpcObj.retriveAddressDetails();
        ApexPages.currentPage().getParameters().put('addressId', secAddressId);
        vpcObj.getselectedAddress();
        
        Provider_Address__c provAddress = new  Provider_Address__c ();
        provAddress.Address_Line1__c = AP01_TestDataTokens.ADDRESS_LINE1;
        provAddress.Serial_Number__c = AP01_TestDataTokens.SERIAL_NUMBER_0;
        provAddress.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
        provAddress.City__c = AP01_TestDataTokens.CITY;
        provAddress.State__c = AP01_TestDataTokens.STATE;
        provAddress.Zip_Code__c = AP01_TestDataTokens.ZIP_CODE;
        provAddress.Secure_Phone__c = AP01_TestDataTokens.SECURE_PHONE;
        provAddress.Secure_Fax__c = AP01_TestDataTokens.SECURE_FAX;
        provAddress.Address_Type__c = Label.CL303_PDIPrimary;
        provAddress.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
        provAddress.Contact_Id__c = cvsObj1.Contact_Id__c;
        provAddress.Summary_Id__c = cvsObj1.Id; 
        
        vpcObj.primaryAddrObj = provAddress;
        ApexPages.currentPage().getParameters().put('addressId', '');
        ApexPages.currentPage().getParameters().put('serialnumber', provAddress.Serial_Number__c);
        vpcObj.getselectedAddress();
        Provider_Address__c address = vpcObj.address;
        System.assert(address != null);
        Test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of get Selected Provider Address method with serial Number   
    * @return void        
    **/
    static testMethod void getSelectedAddressSerialNumber_Test() {
        
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
        
        test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        
        UniversalProviderController vpcObj = new UniversalProviderController();
        vpcObj.contactId = conlist[0].id;
        
        Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
        cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                   Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                   Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                   New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                   Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                   Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                   from Contact_Validation_Summary__c where 
                   address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
        
        Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
        List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
        
        List<Provider_Address__c> secondaryAddressList = new List<Provider_Address__c>();
        Provider_Address__c provAddress1 = new  Provider_Address__c ();
        provAddress1.Address_Line1__c = AP01_TestDataTokens.ADDRESS_LINE1;
        provAddress1.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
        provAddress1.Serial_Number__c = AP01_TestDataTokens.SERIAL_NUMBER_1;
        provAddress1.City__c = AP01_TestDataTokens.CITY;
        provAddress1.State__c = AP01_TestDataTokens.STATE;
        provAddress1.Zip_Code__c = AP01_TestDataTokens.ZIP_CODE;
        provAddress1.Secure_Phone__c = AP01_TestDataTokens.SECURE_PHONE;
        provAddress1.Secure_Fax__c = AP01_TestDataTokens.SECURE_FAX;
        provAddress1.Address_Type__c = Label.CL359_PDI_secondaryAddress;
        provAddress1.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
        provAddress1.Contact_Id__c = cvsObj1.Contact_Id__c;
        provAddress1.Summary_Id__c = cvsObj1.Id;
        secondaryAddressList.add(provAddress1);
        Provider_Address__c primaryAddr = new Provider_Address__c();
        vpcObj.primaryAddrObj = primaryAddr;
        vpcObj.SecondaryAddrList = secondaryAddressList;
        String secSerialNumber = '';
        if(!secondaryAddressList.isEmpty()){
            for(Provider_Address__c address : secondaryAddressList){
                secSerialNumber = address.Serial_Number__c;
            } 
        }
        ApexPages.currentPage().getParameters().put('addressId', '');
        ApexPages.currentPage().getParameters().put('serialnumber', secSerialNumber);
        vpcObj.getselectedAddress();
        
        vpcObj.primaryAddrObj = primaryAddr;
        vpcObj.SecondaryAddrList = null;
        ApexPages.currentPage().getParameters().put('addressId', '');
        ApexPages.currentPage().getParameters().put('serialnumber', AP01_TestDataTokens.SERIAL_NUMBER_1);
        try{
           vpcObj.getselectedAddress(); 
        }catch(Exception ex){
            System.assert(ex.getMessage() != null);
        }
        
        test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of delete address method    
    * @return void        
    **/
    static testMethod void deleteAddress_Test() {
        
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
        
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        
        UniversalProviderController vpcObj = new UniversalProviderController();
        vpcObj.contactId = conlist[0].id;
        
        Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
        cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                   Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                   Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                   New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                   Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                   Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                   from Contact_Validation_Summary__c where 
                   address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
        
        Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
        List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                     Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
        String serialNumber1 = '';
        String serialNumber2 = '';
        Map<String, Provider_Address__c> tempSecAddrMap = new Map<String, Provider_Address__c>();
        if(!provAddressList.isEmpty()){
            for(Provider_Address__c address : provAddressList){
                if(address.Serial_Number__c == AP01_TestDataTokens.SERIAL_NUMBER_1){
                    serialNumber1 = address.Serial_Number__c;
                }else{
                    serialNumber2 = address.Serial_Number__c;
                }
             tempSecAddrMap.put(address.Serial_Number__c, address);   
            } 
        }
        vpcObj.retriveAddressDetails();
        ApexPages.currentPage().getParameters().put('serialNumber', serialNumber1);
        vpcObj.deleteAddress();
        
        ApexPages.currentPage().getParameters().put('serialNumber', serialNumber2);
        vpcObj.deleteAddress();
        Boolean editAddrMode = vpcObj.editAddrmode;
        System.assert(!editAddrMode);
        ApexPages.currentPage().getParameters().put('serialNumber', serialNumber2);
        vpcObj.SecondaryAddrList = null;
        vpcObj.deleteAddress();
        Test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of convert Address method    
    * @return void        
    **/
    static testMethod void convertAddress_Test(){
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
Verifying the user has been fetched successfully using system.assert() 
Expected Result: User is not null
Actual Result: User  is not null 
***********************************************************************/
        system.assert(userObj!=null);
        
        UniversalProviderController vpcObj = new UniversalProviderController();
        vpcObj.contactId = conlist[0].id;
        
        Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
        cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                   Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                   Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                   New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                   Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                   Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                   from Contact_Validation_Summary__c where 
                   address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
        
        Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
        List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                     Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
        
        List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
        Map<String, Provider_Address__c> tempSecAddrMap = new Map<String, Provider_Address__c>();
        String serialNumber2 = '';
        if(!provAddressList.isEmpty()){
            for(Provider_Address__c address : provAddressList){
                if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                    vpcObj.primaryAddrObj = address;
                }else{
                    serialNumber2 = address.Serial_Number__c;
                    secondaryAddrList.add(address);
                }
                tempSecAddrMap.put(address.Serial_Number__c, address);
            } 
        }
        if(!secondaryAddrList.isEmpty()){
            vpcObj.SecondaryAddrList = secondaryAddrList;
        }
        if(String.isNotBlank(serialNumber2)){
            ApexPages.currentPage().getParameters().put('serNumber', serialNumber2);
            vpcObj.convertAddress();
        }
        
        Provider_Address__c primaryAddr = new Provider_Address__c();
        Provider_Address__c secAddr = new Provider_Address__c();
        secAddr.Address_Line1__c = AP01_TestDataTokens.ADDR3_ADDRESS_LINE1;
        secAddr.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
        secAddr.Serial_Number__c = AP01_TestDataTokens.SERIAL_NUMBER_3;
        secAddr.City__c = AP01_TestDataTokens.CITY;
        secAddr.State__c = AP01_TestDataTokens.STATE;
        secAddr.Zip_Code__c=AP01_TestDataTokens.ZIP_CODE;
        secAddr.Secure_Phone__c = AP01_TestDataTokens.ADDR3_SECURE_PHONE;
        secAddr.Secure_Fax__c = AP01_TestDataTokens.ADDR3_SECURE_FAX;
        secAddr.Address_Type__c = Label.CL359_PDI_secondaryAddress;
        secAddr.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
        secondaryAddrList.add(secAddr);
        vpcObj.primaryAddrObj = primaryAddr;
        if(!secondaryAddrList.isEmpty()){
            vpcObj.SecondaryAddrList = secondaryAddrList;
        }
        if(String.isNotBlank(serialNumber2)){
            ApexPages.currentPage().getParameters().put('serNumber', serialNumber2);
            vpcObj.convertAddress();
        }
        
        vpcObj.SecondaryAddrList = null;
        ApexPages.currentPage().getParameters().put('serNumber', serialNumber2);
        try{
            vpcObj.convertAddress();
        }catch(Exception ex){
            System.assert(ex.getMessage() != null);
        }
        
        String serialNum1 = '';
        if(!provAddressList.isEmpty()){
            for(Provider_Address__c address : provAddressList){
                if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                    vpcObj.primaryAddrObj = address;
                }else{
                    serialNum1 = address.Serial_Number__c;
                    secondaryAddrList.add(address);
                    break;
                }
                tempSecAddrMap.put(address.Serial_Number__c, address);
            } 
        }
        if(!secondaryAddrList.isEmpty()){
            vpcObj.SecondaryAddrList = secondaryAddrList;
        }
        if(String.isNotBlank(serialNum1)){
            ApexPages.currentPage().getParameters().put('serNumber', serialNum1);
            vpcObj.convertAddress();
            System.assertEquals(false, vpcObj.editAddrmode);
        }
        test.stopTest();
    }

    /**        
    * @author IDC Team        
    * @description method to code coverage of find suggested Address method    
    * @return void        
    **/
	static testMethod void findSuggestedAddress_Test(){
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        
        UniversalProviderController vpcObj = new UniversalProviderController();
        vpcObj.contactId = conlist[0].id;
        
        Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
        cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                   Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                   Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                   New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                   Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                   Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                   from Contact_Validation_Summary__c where 
                   address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
        
        Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
        
        Provider_Address__c primaryAddrVerify = new Provider_Address__c();
        
        Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c();
        summaryObj = cvsObj1;
        vpcObj.summaryObj = summaryObj;
        
        //Address Positive
        primaryAddrVerify.Address_Line1__c = AP01_TestDataTokens.ADDR2_ADDRESS_LINE1;
        primaryAddrVerify.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
        primaryAddrVerify.City__c = AP01_TestDataTokens.CITY;
        primaryAddrVerify.State__c = AP01_TestDataTokens.STATE;
        primaryAddrVerify.Zip_Code__c = AP01_TestDataTokens.ZIP_CODE;
        primaryAddrVerify.Secure_Phone__c = AP01_TestDataTokens.ADDR2_SECURE_PHONE;
        primaryAddrVerify.Address_Type__c = Label.CL303_PDIPrimary;
        primaryAddrVerify.Secure_Fax__c = AP01_TestDataTokens.ADDR2_SECURE_FAX;
        summaryObj = cvsObj1;
        vpcObj.summaryObj = summaryObj;
        
		vpcObj.address =  primaryAddrVerify;
        vpcObj.suggestedAddressFlag = false;
        vpcObj.findSuggestedAddress();
        
        primaryAddrVerify.Address_Line1__c = '';
        primaryAddrVerify.City__c = '';
        primaryAddrVerify.State__c = '';
        primaryAddrVerify.Zip_Code__c = '';
        primaryAddrVerify.Secure_Phone__c = '';
        primaryAddrVerify.Address_Type__c = Label.CL303_PDIPrimary;
        primaryAddrVerify.Decline_Phone__c = false;
        primaryAddrVerify.Decline_Fax__c = false;
        primaryAddrVerify.Secure_Fax__c = '';
        primaryAddrVerify.Secure_Phone_Ext__c = AP01_TestDataTokens.NEG_SECURE_PHONE_EXT;
        primaryAddrVerify.Decline_Phone__c = false;
        
		vpcObj.address =  primaryAddrVerify;
        vpcObj.findSuggestedAddress();
        List<ApexPages.Message> pageMessages = ApexPages.getMessages();
        system.assertEquals(pageMessages.size() > 0, true);
        
        //Address PatternMatcher and Phone and Fax length
        primaryAddrVerify.Address_Line1__c = AP01_TestDataTokens.NEG_ADDRESS_LINE1;
        primaryAddrVerify.City__c = '';
        primaryAddrVerify.State__c = '';
        primaryAddrVerify.Zip_Code__c = '';
        primaryAddrVerify.Secure_Phone__c = AP01_TestDataTokens.NEG_SECURE_PHONE;
        primaryAddrVerify.Address_Type__c = Label.CL303_PDIPrimary;
        primaryAddrVerify.Decline_Phone__c = false;
        primaryAddrVerify.Decline_Fax__c = false;
        primaryAddrVerify.Secure_Fax__c = AP01_TestDataTokens.NEG_SECURE_FAX;
        primaryAddrVerify.Secure_Phone_Ext__c = AP01_TestDataTokens.NEG_SECURE_PHONE_EXT;
        primaryAddrVerify.Decline_Phone__c = false;
        
		vpcObj.address =  primaryAddrVerify;
        vpcObj.findSuggestedAddress();
        List<ApexPages.Message> pageMessages1 = ApexPages.getMessages();
        system.assertEquals(pageMessages1.size() > 0, true);
        
        //Address PatternMatcher negative
        primaryAddrVerify.Address_Line1__c = AP01_TestDataTokens.NEG_ADDRESS_LINE1;
        primaryAddrVerify.City__c = '';
        primaryAddrVerify.State__c = '';
        primaryAddrVerify.Zip_Code__c = '';
        primaryAddrVerify.Secure_Phone__c = AP01_TestDataTokens.NEG_SECURE_PHONE;
        primaryAddrVerify.Address_Type__c = Label.CL303_PDIPrimary;
        primaryAddrVerify.Decline_Phone__c = false;
        primaryAddrVerify.Decline_Fax__c = false;
        primaryAddrVerify.Secure_Fax__c = AP01_TestDataTokens.NEG_SECURE_FAX;
        primaryAddrVerify.Secure_Phone_Ext__c = AP01_TestDataTokens.NEG_SECURE_PHONE_EXT;
        primaryAddrVerify.Decline_Phone__c = false;
        
		vpcObj.address =  primaryAddrVerify;
        vpcObj.findSuggestedAddress();
        List<ApexPages.Message> pageMessages2 = ApexPages.getMessages();
        system.assertEquals(pageMessages2.size() > 0, true);
        
        
        test.stopTest();
    }

    /**        
    * @author IDC Team        
    * @description method to code coverage of find suggested Address negative method    
    * @return void        
    **/
    static testMethod void findSuggestedAddress1_Test(){
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        System.runAs(userObj) {
            UniversalProviderController vpcObj = new UniversalProviderController();
            vpcObj.contactId = conlist[0].id;
            
            Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
            cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                       Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                       Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                       New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                       Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                       Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                       from Contact_Validation_Summary__c where 
                       address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
            
            Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
            
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
            
            Provider_Address__c primaryAddrVerify = new Provider_Address__c();
            
            Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c();
            summaryObj = cvsObj1;
            vpcObj.summaryObj = summaryObj;
            
            //Address Positive
            primaryAddrVerify.Address_Line1__c = AP01_TestDataTokens.ADDR2_ADDRESS_LINE1;
            primaryAddrVerify.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
            primaryAddrVerify.City__c = AP01_TestDataTokens.CITY;
            primaryAddrVerify.State__c = AP01_TestDataTokens.STATE;
            primaryAddrVerify.Zip_Code__c = AP01_TestDataTokens.ZIP_CODE;
            primaryAddrVerify.Secure_Phone__c = AP01_TestDataTokens.ADDR2_SECURE_PHONE;
            primaryAddrVerify.Address_Type__c = Label.CL303_PDIPrimary;
            primaryAddrVerify.Secure_Fax__c = AP01_TestDataTokens.ADDR2_SECURE_FAX;
            summaryObj = cvsObj1;
            vpcObj.summaryObj = summaryObj;
            
            Map<Integer, String> elementStatusMap = new Map<Integer, String>();
            elementStatusMap.put(0, 'PostCode0');
            elementStatusMap.put(1, 'PostCode1');
            vpcObj.statusMap = elementStatusMap;
            vpcObj.address =  primaryAddrVerify;
            vpcObj.suggestedAddressFlag = false;
            vpcObj.findSuggestedAddress();
            
            Set<String> processCodes = new Set<String>();
            processCodes.add('I3');
            vpcObj.processCodes = processCodes;
            vpcObj.address =  primaryAddrVerify;
            vpcObj.suggestedAddressFlag = false;
            vpcObj.findSuggestedAddress();
            List<ApexPages.Message> pageMessages2 = ApexPages.getMessages();
        	system.assertEquals(pageMessages2.size() > 0, true);
            
            Map<String, String> notProccessedStatMap = new Map<String, String>();
            for(PDIADNotProcessedCodes__c notProcessed : notProccessedList){
                notProccessedStatMap.put(notProcessed.Name, notProcessed.Code__c);
            }
            notProccessedStatMap.put('I3', '');
            vpcObj.address =  primaryAddrVerify;
            vpcObj.suggestedAddressFlag = false;
            vpcObj.addressNotProcessedStatusMap = notProccessedStatMap;
            vpcObj.findSuggestedAddress();
            List<ApexPages.Message> pageMessg = ApexPages.getMessages();
            system.assertEquals(pageMessg.size() > 0, true);
            
            vpcObj.retriveAddressDetails();
            vpcObj.address =  primaryAddrVerify;
            vpcObj.suggestedAddressFlag = false;
            vpcObj.findSuggestedAddress();
            
            Map<String, String> addressWebServiceMap = new Map<String, String>();
            addressWebServiceMap.put('I3', '');
            vpcObj.address =  primaryAddrVerify;
            vpcObj.suggestedAddressFlag = false;
            vpcObj.addressWebserviceStatusMap = addressWebServiceMap;
            vpcObj.findSuggestedAddress();
            List<ApexPages.Message> pageMessages5 = ApexPages.getMessages();
            system.assertEquals(pageMessages5.size() > 0, true);
            
            test.stopTest();
        }
    }  
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Save Address method
    * @return void        
    **/
    static testMethod void saveAddress1_Test(){
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        System.runAs(userObj) {
            UniversalProviderController vpcObj = new UniversalProviderController();
            vpcObj.contactId = conlist[0].id;
            
            Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
            cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                       Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                       Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                       New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                       Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                       Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                       from Contact_Validation_Summary__c where 
                       address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
            
            Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
            
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
            
            Provider_Address__c primaryAddrVerify = new Provider_Address__c();
            
            Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c();
            summaryObj = cvsObj1;
            vpcObj.summaryObj = summaryObj;
            
            //Address Positive
            primaryAddrVerify.Address_Line1__c = AP01_TestDataTokens.ADDR2_ADDRESS_LINE1;
            primaryAddrVerify.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
            primaryAddrVerify.City__c = AP01_TestDataTokens.CITY;
            primaryAddrVerify.State__c = AP01_TestDataTokens.STATE;
            primaryAddrVerify.Zip_Code__c = AP01_TestDataTokens.ZIP_CODE;
            primaryAddrVerify.Secure_Phone__c = AP01_TestDataTokens.ADDR2_SECURE_PHONE;
            primaryAddrVerify.Address_Type__c = Label.CL303_PDIPrimary;
            primaryAddrVerify.Secure_Fax__c = AP01_TestDataTokens.ADDR2_SECURE_FAX;
            summaryObj = cvsObj1;
            vpcObj.summaryObj = summaryObj;
            
            vpcObj.address =  primaryAddrVerify;
            vpcObj.suggestedAddressFlag = true;
            
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
            vpcObj.processCodes = processCodes;
            vpcObj.address = address1;
            vpcObj.suggestedAddressList = suggestedAddressList;
            vpcObj.suggestedAddressFlag = true;
            vpcObj.selectedRecord = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            vpcObj.saveAddress();
            List<ApexPages.Message> pageMessages7 = ApexPages.getMessages();
            system.assertEquals(pageMessages7.size() > 0, true);
            
            //Negative #1
            Set<String> processCodes1 = new Set<String>();
            processCodes1.add('I3');
            vpcObj.processCodes = processCodes1;
            vpcObj.address = address1;
            vpcObj.suggestedAddressList = suggestedAddressList;
            vpcObj.suggestedAddressFlag = true;
            vpcObj.selectedRecord = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            vpcObj.saveAddress();
            vpcObj.findSuggestedAddress();
            List<ApexPages.Message> pageMessages2 = ApexPages.getMessages();
        	system.assertEquals(pageMessages2.size() > 0, true);
            
            //Negative #2
            Map<String, String> notProccessedStatMap = new Map<String, String>();
            notProccessedStatMap.put('I3', '');
            vpcObj.address = address1;
            vpcObj.addressNotProcessedStatusMap = notProccessedStatMap;
            vpcObj.suggestedAddressList = suggestedAddressList;
            vpcObj.suggestedAddressFlag = true;
            vpcObj.selectedRecord = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            vpcObj.saveAddress();
            vpcObj.findSuggestedAddress();
            List<ApexPages.Message> pageMessages = ApexPages.getMessages();
        	system.assertEquals(pageMessages.size() > 0, true);
            //Negative #3
            Map<String, String> addressWebServiceMap = new Map<String, String>();
            addressWebServiceMap.put('I3', '');
            vpcObj.address = address1;
            vpcObj.suggestedAddressList = suggestedAddressList;
            vpcObj.suggestedAddressFlag = true;
            vpcObj.addressWebserviceStatusMap = addressWebServiceMap;
            vpcObj.selectedRecord = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            vpcObj.saveAddress();
            vpcObj.findSuggestedAddress();
            List<ApexPages.Message> pageMessages1 = ApexPages.getMessages();
        	system.assertEquals(pageMessages1.size() > 0, true);
            
            test.stopTest();
        }
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Save Address method
    * @return void        
    **/
    static testMethod void saveAddress2_Test(){
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        System.runAs(userObj) {
            UniversalProviderController vpcObj = new UniversalProviderController();
            vpcObj.contactId = conlist[0].id;
            
            Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
            cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                       Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                       Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                       New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                       Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                       Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                       from Contact_Validation_Summary__c where 
                       address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
            
            Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
            
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
            
            Provider_Address__c primaryAddrVerify = new Provider_Address__c();
            
            Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c();
            summaryObj = cvsObj1;
            vpcObj.summaryObj = summaryObj;
            
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            Map<String, Provider_Address__c> tempSecAddrMap = new Map<String, Provider_Address__c>();
            String serialNumber2 = '';
            String addressId = null;
            String primaryaddressId = null;
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        primaryaddressId = address.Id;
                        vpcObj.primaryAddrObj = null;
                    }else{
                        serialNumber2 = address.Serial_Number__c;
                        addressId = address.Id;
                        secondaryAddrList.add(address);
                    }
                    tempSecAddrMap.put(address.Serial_Number__c, address);
                } 
            }
            if(!secondaryAddrList.isEmpty()){
                
                vpcObj.SecondaryAddrList = secondaryAddrList;
            }
            
            Provider_Address__c address1 = new Provider_Address__c();
            vpcObj.retriveAddressDetails();            
            address1.Id = addressId;
            address1.Address_Line1__c = AP01_TestDataTokens.ADDR3_ADDRESS_LINE1;
            address1.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
            address1.Serial_Number__c = AP01_TestDataTokens.SERIAL_NUMBER_2;
            address1.City__c = AP01_TestDataTokens.CITY;
            address1.State__c = AP01_TestDataTokens.STATE;
            address1.Zip_Code__c=AP01_TestDataTokens.ZIP_CODE;
            address1.Secure_Phone__c = AP01_TestDataTokens.ADDR3_SECURE_PHONE;
            address1.Secure_Fax__c = AP01_TestDataTokens.ADDR3_SECURE_FAX;
            address1.Address_Type__c = Label.CL359_PDI_secondaryAddress;
            address1.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            address1.Provider_Address_AD_Status__c = 'C3';
            address1.Address_Mailability_Score__c = '1';
            address1.Address_Result_Percentage__c = '85.00';
            vpcObj.address = address1;
            
            vpcObj.suggestedAddressFlag = false;
            Set<String> correctStatus = new Set<String>();
            for(PDIADCorrectAddressCodes__c correctCode : correstAddrList){
                correctStatus.add(correctCode.Name);
            }
            vpcObj.correctAddrCodeSet = correctStatus;
            vpcObj.saveAddress();
            
            //Verfied Address
            Provider_Address__c newAddr = new Provider_Address__c();
            newAddr.Address_Line1__c = AP01_TestDataTokens.ADDR3_ADDRESS_LINE1;
            newAddr.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
            newAddr.Serial_Number__c = AP01_TestDataTokens.SERIAL_NUMBER_3;
            newAddr.City__c = AP01_TestDataTokens.CITY;
            newAddr.State__c = AP01_TestDataTokens.STATE;
            newAddr.Zip_Code__c=AP01_TestDataTokens.ZIP_CODE;
            newAddr.Secure_Phone__c = AP01_TestDataTokens.ADDR3_SECURE_PHONE;
            newAddr.Secure_Fax__c = AP01_TestDataTokens.ADDR3_SECURE_FAX;
            newAddr.Address_Type__c = Label.CL359_PDI_secondaryAddress;
            newAddr.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            secondaryAddrList.add(newAddr);
            vpcObj.SecondaryAddrList = secondaryAddrList;
            Map<String, Provider_Address__c> tempSecAddrMap1 = new Map<String, Provider_Address__c>();
            for(Provider_Address__c addr : secondaryAddrList){
                tempSecAddrMap1.put(addr.Serial_Number__c, addr);
            }
            
            Provider_Address__c verifiedAddr = new Provider_Address__c();
            verifiedAddr.Address_Line1__c = AP01_TestDataTokens.ADDR3_ADDRESS_LINE1;
            verifiedAddr.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
            verifiedAddr.Serial_Number__c = AP01_TestDataTokens.SERIAL_NUMBER_3;
            verifiedAddr.City__c = AP01_TestDataTokens.CITY;
            verifiedAddr.State__c = AP01_TestDataTokens.STATE;
            verifiedAddr.Zip_Code__c=AP01_TestDataTokens.ZIP_CODE;
            verifiedAddr.Secure_Phone__c = AP01_TestDataTokens.ADDR3_SECURE_PHONE;
            verifiedAddr.Secure_Fax__c = AP01_TestDataTokens.ADDR3_SECURE_FAX;
            verifiedAddr.Address_Type__c = Label.CL359_PDI_secondaryAddress;
            verifiedAddr.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            verifiedAddr.Provider_Address_AD_Status__c = 'V1';
            verifiedAddr.Address_Mailability_Score__c = '1';
            verifiedAddr.Address_Result_Percentage__c = '85.00';
            vpcObj.address = verifiedAddr;
            vpcObj.suggestedAddressFlag = false;
            Set<String> verifiedStatus = new Set<String>();
            for(PDIADVerificationCodes__c correctCode : verificationCodeList){
                verifiedStatus.add(correctCode.Name);
            }
            vpcObj.tempsecondaryAddrMap = tempSecAddrMap1;
            vpcObj.verifiedAddrCodeSet = verifiedStatus;
            vpcObj.saveAddress();
            
            //Error Address
            Provider_Address__c verifiedAddr1 = new Provider_Address__c();
            verifiedAddr1.Id = primaryaddressId;
            verifiedAddr1.Address_Line1__c = AP01_TestDataTokens.ADDR3_ADDRESS_LINE1;
            verifiedAddr1.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
            verifiedAddr1.Serial_Number__c = AP01_TestDataTokens.SERIAL_NUMBER_0;
            verifiedAddr1.City__c = AP01_TestDataTokens.CITY;
            verifiedAddr1.State__c = AP01_TestDataTokens.STATE;
            verifiedAddr1.Zip_Code__c=AP01_TestDataTokens.ZIP_CODE;
            verifiedAddr1.Secure_Phone__c = AP01_TestDataTokens.ADDR3_SECURE_PHONE;
            verifiedAddr1.Secure_Fax__c = AP01_TestDataTokens.ADDR3_SECURE_FAX;
            verifiedAddr1.Address_Type__c = Label.CL303_PDIPrimary;
            verifiedAddr1.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            verifiedAddr1.Provider_Address_AD_Status__c = 'I1';
            verifiedAddr1.Address_Mailability_Score__c = '1';
            verifiedAddr1.Address_Result_Percentage__c = '85.00';
            vpcObj.address = verifiedAddr1;
            vpcObj.suggestedAddressFlag = false;
            Set<String> errorStatus = new Set<String>();
            for(PDIADErrorCodes__c errorCode : errorCodeList){
                errorStatus.add(errorCode.Name);
            }
            vpcObj.processCodes = errorStatus;
            vpcObj.saveAddress();
            
            List<Provider_Address__c> secondaryAddrList1 = new List<Provider_Address__c>();
            Provider_Address__c addr = new Provider_Address__c();
            vpcObj.primaryAddrObj = addr;
            vpcObj.SecondaryAddrList = secondaryAddrList1;
            vpcObj.suggestedAddressFlag = false;
            vpcObj.saveAddress();
            
            List<Provider_Address__c> secondaryAddrList2 = new List<Provider_Address__c>();
            vpcObj.primaryAddrObj = null;
            vpcObj.SecondaryAddrList = secondaryAddrList2;
            vpcObj.suggestedAddressFlag = false;
            try{
                vpcObj.saveAddress();
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }
            
            
            test.stopTest();
        }
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Save Address with Resigned Provider
    * @return void        
    **/
    static testMethod void saveSummaryResigned_Test(){
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
            Verifying the user has been fetched successfully using system.assert() 
            Expected Result: User is not null
            Actual Result: User  is not null 
            ***********************************************************************/
        system.assert(userObj!=null);
        
            UniversalProviderController vpcObj = new UniversalProviderController();
            vpcObj.contactId = conlist[0].id;
            
            Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
            cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                       Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                       Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                       New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                       Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                       Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                       from Contact_Validation_Summary__c where 
                       address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
            
            Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
            
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
            
            Provider_Address__c primaryAddrVerify = new Provider_Address__c();
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            Provider_Address__c primaryAddressObj = new Provider_Address__c();
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    Integer i = 1;
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        address.Address_Line1__c = '1400 a street';
                        address.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
                        address.City__c = AP01_TestDataTokens.CITY;
                        address.State__c = 'TS';
                        address.Zip_Code__c = AP01_TestDataTokens.ZIP_CODE;
                        address.Secure_Phone__c = '(234) 999-2341';
                        address.Secure_Fax__c = '(234) 999-2341';
                        address.Provider_Address_AD_Status__c ='C4';
                        address.Secure_Phone_Ext__c = '2345';
                        address.Tech_Is_Address_Updated__c = true;
                        address.County__c = 'SACRAMENTO';
                        address.Suite__c = 'suite 123';
                        address.Floor__c = '1st floor';
                        primaryAddressObj = address;
                        
                    }else{
                        address.Address_Line1__c = '140'+i+' a street';
                        address.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
                        address.City__c = AP01_TestDataTokens.CITY;
                        address.State__c = 'TS';
                        address.Zip_Code__c = AP01_TestDataTokens.ZIP_CODE;
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
            Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c();
            vpcObj.retrieveProviderProfile();
            summaryObj = cvsObj1;
            summaryObj.Practicing_Physician__c = false;
            summaryObj.Retired_Departed__c = false;
        	summaryObj.Resigned_From_Sutter__c = true;
            summaryObj.Is_Resigned_Provider_refer__c = false;
            summaryObj.Mobile_Phone__c = '12345678982';
            summaryObj.Admin_Assistant_Email__c = 'kishore.jonnadula@accenture.com';
            summaryObj.Speciality__c = 'test';
            summaryObj.Department__c = 'test';
            summaryObj.Hospital_Affiliations__c = 'test';
            summaryObj.Medical_Affiliations__c = 'test';
            summaryObj.Medical_Education__c = 'test';
            summaryObj.Internship__c = 'test';
            summaryObj.Residency__c = 'test';
            summaryObj.Spoken_Languages__c = 'test';
            summaryObj.Community_Activities__c = 'test';
            summaryObj.Personal_Interests__c = 'test';
            summaryObj.Philosophy_of_Care__c = 'test';
            summaryObj.Website_Address__c = 'test';
            summaryObj.Professional_Ineterests__c = 'test';
            summaryObj.Online_Services__c = 'test';
            summaryObj.Board_Certifications__c = 'test';
            summaryObj.Publications__c = 'test';
            summaryObj.Additional_Information__c = 'test';
            summaryObj.Admin_Assistant__c = 'test';
            summaryObj.Admin_Assistant_Title__c = 'Dr.';
            summaryObj.Admin_Assistant_Phone__c = '(234) 567-9881';
            summaryObj.Tech_is_Contact_Updated__c = false;
            vpcObj.providerSearchFlag = true;
            vpcObj.primaryAddrObj = primaryAddressObj;
            vpcObj.SecondaryAddrList = secondaryAddrList;
            vpcObj.summaryObj = summaryObj;
            vpcObj.save();
            System.assertEquals('error', vpcObj.section);
            
            test.stopTest();
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Save Address with Retired Provider
    * @return void        
    **/
    static testMethod void saveSummaryRetired_Test(){
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
            Verifying the user has been fetched successfully using system.assert() 
            Expected Result: User is not null
            Actual Result: User  is not null 
            ***********************************************************************/
        system.assert(userObj!=null);
        
            UniversalProviderController vpcObj = new UniversalProviderController();
            vpcObj.contactId = conlist[0].id;
            
            Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
            cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                       Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                       Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                       New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                       Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                       Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                       from Contact_Validation_Summary__c where 
                       address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
            
            Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
            
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
            
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
                        address.Provider_Address_AD_Status__c ='V3';
                        address.Secure_Phone_Ext__c = '2345';
                        address.Tech_Is_Address_Updated__c = false;
                        address.Tech_Is_Address_Verified__c = false;
                        secondaryAddrList.add(address);
                        i++;
                    }
                } 
            }
            Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c();
            vpcObj.retrieveProviderProfile();
            summaryObj = cvsObj1;
            summaryObj.Practicing_Physician__c = false;
            summaryObj.Retired_Departed__c = true;
            summaryObj.Mobile_Phone__c = '(234) 567-9881';
            summaryObj.Admin_Assistant_Email__c = 'kishore.jonnadula@accenture.com';
            summaryObj.Speciality__c = 'test';
            summaryObj.Department__c = 'test';
            summaryObj.Hospital_Affiliations__c = 'test';
            summaryObj.Medical_Affiliations__c = 'test';
            summaryObj.Medical_Education__c = 'test';
            summaryObj.Internship__c = 'test';
            summaryObj.Residency__c = 'test';
            summaryObj.Spoken_Languages__c = 'test';
            summaryObj.Community_Activities__c = 'test';
            summaryObj.Personal_Interests__c = 'test';
            summaryObj.Philosophy_of_Care__c = 'test';
            summaryObj.Website_Address__c = 'test';
            summaryObj.Professional_Ineterests__c = 'test';
            summaryObj.Online_Services__c = 'test';
            summaryObj.Board_Certifications__c = 'test';
            summaryObj.Publications__c = 'test';
            summaryObj.Additional_Information__c = 'test';
            summaryObj.Admin_Assistant__c = 'test';
            summaryObj.Admin_Assistant_Title__c = 'Dr.';
            summaryObj.Admin_Assistant_Phone__c = '(234) 567-9881';
            summaryObj.Tech_is_Contact_Updated__c = false;
            vpcObj.providerSearchFlag = true;
            vpcObj.primaryAddrObj = primaryAddressObj;
            vpcObj.SecondaryAddrList = secondaryAddrList;
            
            vpcObj.summaryObj = summaryObj;
            vpcObj.save();
        	System.assertEquals('success', vpcObj.section);
            
            test.stopTest();
        
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Save Address
    * @return void        
    **/
    static testMethod void saveSummary_Test(){
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
Verifying the user has been fetched successfully using system.assert() 
Expected Result: User is not null
Actual Result: User  is not null 
***********************************************************************/
        system.assert(userObj!=null);
        
        UniversalProviderController vpcObj = new UniversalProviderController();
        vpcObj.contactId = conlist[0].id;
        
        Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
        cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                   Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                   Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                   New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                   Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                   Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                   from Contact_Validation_Summary__c where 
                   address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
        
        Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
        
        List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                     Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
        
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
                    secondaryAddrList.add(address);
                    i++;
                }
            } 
        }
        Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c();
        vpcObj.retrieveProviderProfile();
        summaryObj = cvsObj1;
        summaryObj.Practicing_Physician__c = true;
        summaryObj.Mobile_Phone__c = '(234) 567-9881';
        summaryObj.Admin_Assistant_Email__c = 'kishore.jonnadula@accenture.com';
        summaryObj.Speciality__c = 'test';
        summaryObj.Department__c = 'test';
        summaryObj.Hospital_Affiliations__c = 'test';
        summaryObj.Medical_Affiliations__c = 'test';
        summaryObj.Medical_Education__c = 'test';
        summaryObj.Internship__c = 'test';
        summaryObj.Residency__c = 'test';
        summaryObj.Spoken_Languages__c = 'test';
        summaryObj.Community_Activities__c = 'test';
        summaryObj.Personal_Interests__c = 'test';
        summaryObj.Philosophy_of_Care__c = 'test';
        summaryObj.Website_Address__c = 'test';
        summaryObj.Professional_Ineterests__c = 'test';
        summaryObj.Online_Services__c = 'test';
        summaryObj.Board_Certifications__c = 'test';
        summaryObj.Publications__c = 'test';
        summaryObj.Additional_Information__c = 'test';
        summaryObj.Admin_Assistant__c = 'test';
        summaryObj.Admin_Assistant_Title__c = 'Dr.';
        summaryObj.Admin_Assistant_Phone__c = '(234) 567-9881';
        summaryObj.Delegate_Phone_Ext__c = '5786';
        summaryObj.Email__c = 'kaipu.nagarjuna@accenture.com';
        summaryObj.Tech_is_Contact_Updated__c = false;
        vpcObj.providerSearchFlag = true;
        vpcObj.primaryAddrObj = primaryAddressObj;
        vpcObj.SecondaryAddrList = secondaryAddrList;
        
        vpcObj.summaryObj = summaryObj;
        try{
            vpcObj.save();
        	System.assertEquals('success', vpcObj.section);
        }catch(Exception ex){
            System.assert(ex.getMessage() != null);
        }
        
        test.stopTest();
        
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Validate Provider
    * @return void        
    **/
    static testMethod void saveSummary1_Test(){
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
Verifying the user has been fetched successfully using system.assert() 
Expected Result: User is not null
Actual Result: User  is not null 
***********************************************************************/
        system.assert(userObj!=null);
        System.runAs(userObj) {
            UniversalProviderController vpcObj = new UniversalProviderController();
            vpcObj.contactId = conlist[0].id;
            
            Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
            cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                       Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                       Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                       New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                       Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                       Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                       from Contact_Validation_Summary__c where 
                       address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
            
            Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
            Util01_PDIUtilTestData.insertAuditRecordforSummary(cvsObj1.Contact_Id__c);
            
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
            
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
            Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c();
            vpcObj.retrieveProviderProfile();
            summaryObj = cvsObj1;
            summaryObj.Practicing_Physician__c = true;
            summaryObj.Mobile_Phone__c = '(234) 567-9881';
            summaryObj.Admin_Assistant_Email__c = 'kishore.jonnadula@accenture.com';
            summaryObj.Speciality__c = 'test';
            summaryObj.Department__c = 'test';
            summaryObj.Hospital_Affiliations__c = 'test';
            summaryObj.Medical_Affiliations__c = 'test';
            summaryObj.Medical_Education__c = 'test';
            summaryObj.Internship__c = 'test';
            summaryObj.Residency__c = 'test';
            summaryObj.Spoken_Languages__c = 'test';
            summaryObj.Community_Activities__c = 'test';
            summaryObj.Personal_Interests__c = 'test';
            summaryObj.Philosophy_of_Care__c = 'test';
            summaryObj.Website_Address__c = 'test';
            summaryObj.Professional_Ineterests__c = 'test';
            summaryObj.Online_Services__c = 'test';
            summaryObj.Board_Certifications__c = 'test';
            summaryObj.Publications__c = 'test';
            summaryObj.Additional_Information__c = 'test';
            summaryObj.Admin_Assistant__c = 'test';
            summaryObj.Admin_Assistant_Title__c = 'Dr.';
            summaryObj.Admin_Assistant_Phone__c = '(234) 567-9881';
            summaryObj.Tech_is_Contact_Updated__c = false;
            vpcObj.providerSearchFlag = true;
            vpcObj.primaryAddrObj = primaryAddressObj;
            vpcObj.SecondaryAddrList = secondaryAddrList;
            
            vpcObj.summaryObj = summaryObj;
            vpcObj.save();
            
            test.stopTest();
        }
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Validate Existing Resigned Provider
    * @return void        
    **/
    static testMethod void saveSummaryExistingResigned_Test(){
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
Verifying the user has been fetched successfully using system.assert() 
Expected Result: User is not null
Actual Result: User  is not null 
***********************************************************************/
        system.assert(userObj!=null);
        System.runAs(userObj) {
            UniversalProviderController vpcObj = new UniversalProviderController();
            vpcObj.contactId = conlist[0].id;
            
            Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
            cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                       Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                       Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                       New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                       Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                       Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                       from Contact_Validation_Summary__c where 
                       address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
            
            Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
            Util01_PDIUtilTestData.insertAuditRecordforSummary(cvsObj1.Contact_Id__c);
            
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
            
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
            Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c();
            vpcObj.retrieveProviderProfile();
            summaryObj = cvsObj1;
            summaryObj.Practicing_Physician__c = false;
            summaryObj.Resigned_From_Sutter__c = true;
            summaryObj.Retired_Departed__c = false;
            summaryObj.Mobile_Phone__c = '(234) 567-9881';
            summaryObj.Admin_Assistant_Email__c = 'kishore.jonnadula@accenture.com';
            summaryObj.Speciality__c = 'test';
            summaryObj.Department__c = 'test';
            summaryObj.Hospital_Affiliations__c = 'test';
            summaryObj.Medical_Affiliations__c = 'test';
            summaryObj.Medical_Education__c = 'test';
            summaryObj.Internship__c = 'test';
            summaryObj.Residency__c = 'test';
            summaryObj.Spoken_Languages__c = 'test';
            summaryObj.Community_Activities__c = 'test';
            summaryObj.Personal_Interests__c = 'test';
            summaryObj.Philosophy_of_Care__c = 'test';
            summaryObj.Website_Address__c = 'test';
            summaryObj.Professional_Ineterests__c = 'test';
            summaryObj.Online_Services__c = 'test';
            summaryObj.Board_Certifications__c = 'test';
            summaryObj.Publications__c = 'test';
            summaryObj.Additional_Information__c = 'test';
            summaryObj.Admin_Assistant__c = 'test';
            summaryObj.Admin_Assistant_Title__c = 'Dr.';
            summaryObj.Admin_Assistant_Phone__c = '(234) 567-9881';
            summaryObj.Tech_is_Contact_Updated__c = false;
            vpcObj.providerSearchFlag = true;
            vpcObj.primaryAddrObj = primaryAddressObj;
            vpcObj.SecondaryAddrList = secondaryAddrList;
            
            vpcObj.summaryObj = summaryObj;
            vpcObj.save();
            
            test.stopTest();
        }
    }
    
    /**        
    * @author IDC Team        
    * @description method to code coverage of Invalid Provider Details
    * @return void        
    **/
   static testMethod void saveInvalid_Test(){
        
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
        Test.startTest();
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        System.runAs(userObj) {
            UniversalProviderController vpcObj = new UniversalProviderController();
            vpcObj.contactId = conlist[0].id;
            
            Contact_Validation_Summary__c cvsObj1 = new Contact_Validation_Summary__c();
            cvsObj1 = [select id, Secure_Street_Address__c,Secure_City__c,Secure_State__c,Address_Line_2__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                       Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c,
                       Provider_ID__c,Provider_NPI_F__c,Provider_FirstName__c,Provider_MiddleName__c,Provider_LastName__c,
                       New_Street_Address__c,Preferred_Communication_Method__c,Communication_Preferences_HIM__c,Retired_Departed__c, Practicing_Physician__c,
                       Resigned_From_Sutter__c, Admin_Assistant__c,Admin_Assistant_Title__c,Admin_Assistant_Phone__c, Admin_Assistant_Email__c,PDI_Campaign__c,
                       Provider_Access_Type__c, Provider_Type__c, Deficiency_Provider__c
                       from Contact_Validation_Summary__c where 
                       address_Type__c = 'Primary' and Contact_Id__c = :conlist[0].id limit 1];
            
            Util01_PDIUtilTestData.insertProviderAddressList(cvsObj1.Id, cvsObj1.Contact_Id__c);
            
            List<Provider_Address__c> provAddressList = [select id, Address_Line1__c, Serial_Number__c, Address_Line_2__c, City__c, State__c, Zip_Code__c, Secure_Phone__c, Secure_Fax__c, 
                                                         Address_Type__c, PDI_Campaign__c, Contact_Id__c, Summary_Id__c from Provider_Address__c where Contact_Id__c =: cvsObj1.Contact_Id__c];
            
            Provider_Address__c primaryAddrVerify = new Provider_Address__c();
            List<Provider_Address__c> secondaryAddrList = new List<Provider_Address__c>();
            Provider_Address__c primaryAddressObj = new Provider_Address__c();
            if(!provAddressList.isEmpty()){
                for(Provider_Address__c address : provAddressList){
                    if(Label.CL303_PDIPrimary.equalsIgnoreCase(address.Address_Type__c)){
                        primaryAddressObj = address;
                    }else{
                        secondaryAddrList.add(address);
                    }
                } 
            }
            Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c();
            summaryObj = cvsObj1;
            vpcObj.retriveAddressDetails();
            vpcObj.summaryObj = summaryObj;
            vpcObj.save();
            
            summaryObj.Mobile_Phone__c = '(234) 567-988';
            summaryObj.Email__c = '';
            summaryObj.Practicing_Physician__c = false;
            summaryObj.Resigned_From_Sutter__c = false;
            summaryObj.Retired_Departed__c = false;
            vpcObj.summaryObj = summaryObj;
            try{
                vpcObj.save();
            }catch(Exception ex){
                System.assert(ex.getMessage()!=null);
            }
            
            
            Provider_Address__c primaryAddress = new Provider_Address__c();
            summaryObj.Mobile_Phone__c = null;
            summaryObj.Ok_to_Text__c = true;
            summaryObj.Practicing_Physician__c = true;
            summaryObj.Admin_Assistant_Email__c = 'test12@.com';
            primaryAddress.Address_Line1__c = null;
            vpcObj.primaryAddrObj = primaryAddress;
            vpcObj.summaryObj = summaryObj;
            try{
                vpcObj.save();
            }catch(Exception ex){
                System.assert(ex.getMessage()!=null);
            }
            
            summaryObj.Mobile_Phone__c = '';
            summaryObj.Ok_to_Text__c = true;
            summaryObj.Practicing_Physician__c = true;
            summaryObj.Admin_Assistant_Email__c = 'test12@.com';
            primaryAddress.Address_Line1__c = '1400 a street';
            primaryAddress.Secure_Phone__c = '';
            primaryAddress.Secure_Fax__c = '';
            primaryAddress.Provider_Address_AD_Status__c = null;
            vpcObj.primaryAddrObj = primaryAddress;
            vpcObj.summaryObj = summaryObj;
            try{
                vpcObj.save();
            }catch(Exception ex){
                System.assert(ex.getMessage()!=null);
            }
            
            test.stopTest();
        }
    }

}