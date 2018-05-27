/*****************************************************
Class Name: PDIEAFFacilityDetailController_Test
Created By: Nagarjuna Kaipu
Created Date: 15/11/2016
Description: test class for PDIEAFFacilityDetailController class
******************************************************/
@isTest
public class PDIEAFFacilityDetailController_Test {
    /*******************************************************************
Purpose:  This is used to test Save Address.
Parameters: N/A
Returns: PageReference    
Throws [Exceptions]: N/A
********************************************************************/
    static testMethod void saveFacilityAddress_Test(){
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
            List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
            insert facList;
            
            PageReference pageRef = new PageReference('/apex/PDIEAFFacilityDetail?EAFId=' + facList[0].Id);
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController con = new ApexPages.StandardController(facList[0]);
            PDIEAFFacilityDetailController ctrl = new PDIEAFFacilityDetailController(con);
            
            //PDV_EAF_Facility__c address1 = new PDV_EAF_Facility__c();
            ctrl.checkAllparameters();
            ctrl.EAF.Address_Line_1__c = '400 West I Street';
            ctrl.EAF.Address_Line_2__c = 'Suite C';
            ctrl.EAF.City__c = 'Los Banos';
            ctrl.EAF.State__c = 'CA';
            ctrl.EAF.Zip_Code__c='93635';
            ctrl.EAF.Phone__c = '(999) 123-9997';
            ctrl.EAF.Fax_Number__c = '(999) 123-9997';
            test.startTest();
            ctrl.findSuggestedAddress();
            List<PDV_EAF_Facility__c> suggestedAddressList = new List<PDV_EAF_Facility__c>();
            PDV_EAF_Facility__c suggestedAddr = new PDV_EAF_Facility__c();
            suggestedAddr.City__c = 'FOLSOM';
            suggestedAddr.State__c = 'CA';
            suggestedAddr.Zip_Code__c = '95630-9000';
            suggestedAddr.Address_Line_1__c = '100 IRON POINT RD';
            suggestedAddr.Address_Line_2__c = 'ST 9999999';
            suggestedAddr.Formatted_Address__c = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            suggestedAddr.AD_Address_Process_Status__c = 'C4';
            suggestedAddr.AD_Address_Mailability_Score__c = '1';
            suggestedAddr.AD_Address_Result_Percentage__c = '85.00';
            suggestedAddressList.add(suggestedAddr);
            ctrl.suggestedAddressList = suggestedAddressList;
            ctrl.suggestedAddressFlag = true;
            ctrl.selectedRecord = '100 IRON POINT RD ST 9999999 FOLSOM CA 95630-9000 UNITED STATES';
            ctrl.saveAddress();
            System.assertEquals(true, ctrl.verifiedAddressList.size()>0);
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
        List<PDV_EAF_Facility__c> facListUpdate = new List<PDV_EAF_Facility__c>();
        List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
        insert facList;
        for(PDV_EAF_Facility__c facToUpdate: facList){
            facToUpdate.ADDRESS__c = '1544 Eureka';
            facToUpdate.Address_Line_1__c = '1544 Eureka';
            facToUpdate.Address_Line_2__c = 'Suite D';
            facToUpdate.City__c = 'Hyderabad';
            facToUpdate.State__c = 'AL';
            facToUpdate.ZIP_CODE__c = '52356';
            facToUpdate.Phone__c = '19675456789';
            facToUpdate.Phone_Extension__c = '2126';
            facToUpdate.FAX_NUMBER__c = '9634534534';
            facListUpdate.add(facToUpdate);
        }
        update facListUpdate;
        
        PageReference pageRef = new PageReference('/apex/PDIEAFFacilityDetail?EAFId=' + facList[0].Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController con = new ApexPages.StandardController(facList[0]);
        PDIEAFFacilityDetailController ctrl = new PDIEAFFacilityDetailController(con);
        
        PDV_EAF_Facility__c address1 = new PDV_EAF_Facility__c();
        
        ctrl.checkAllparameters();
        
        test.startTest();
        
        ctrl.createCase();
        ctrl.EAFId = facList[0].Id;
        ctrl.checkAllparameters();
        ctrl.EAF.Address_Line_1__c = '400 West I Street';
        ctrl.EAF.Address_Line_2__c = 'Suite C';
        ctrl.EAF.City__c = 'Los Banos';
        ctrl.EAF.State__c = 'AI';
        ctrl.EAF.Zip_Code__c='93635';
        ctrl.EAF.Phone__c = '(1999) 123-9997';
        ctrl.EAF.Fax_Number__c = '(999) 123-9997';
        ctrl.EAF.Phone_Extension__c = '9676';
        ctrl.EAF.Names_Changes_Suggested__c = 'nagatest';
        ctrl.saveUpdatedAddress();
        ctrl.caseObj.PDV_Contact_Name__c = 'nagarjuna';
        ctrl.caseObj.Contact_Number__c = 19676561568.00;
        ctrl.caseObj.Status = 'Closed';
        ctrl.updateCase();
        ctrl.EAF.Address_Line_1__c = 'Care Of %%^% stre wetew';
        ctrl.saveUpdatedAddress();
        List<ApexPages.Message> pageMessages2 = ApexPages.getMessages();
        system.assertEquals(pageMessages2.size() > 0, true);
        test.stopTest();
    }
    
    /*******************************************************************
Purpose:  This is used to test SaveUpdatedAddress .
Parameters: N/A
Returns: PageReference    
Throws [Exceptions]: N/A
********************************************************************/
    static testMethod void saveUpdatedAddressWithEmptyInput_Test(){
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
        
        List<PDV_EAF_Facility__c> facListUpdate = new List<PDV_EAF_Facility__c>();
        List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
        insert facList;
        
        PageReference pageRef = new PageReference('/apex/PDIEAFFacilityDetail?EAFId=' + facList[0].Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController con = new ApexPages.StandardController(facList[0]);
        PDIEAFFacilityDetailController ctrl = new PDIEAFFacilityDetailController(con);
        
        PDV_EAF_Facility__c address1 = new PDV_EAF_Facility__c();
        
        ctrl.checkAllparameters();
        
        test.startTest();
        
        ctrl.createCase();
        ctrl.EAFId = facList[0].Id;
        ctrl.checkAllparameters();
        ctrl.EAF.Address_Line_1__c = '';
        ctrl.EAF.Address_Line_2__c = '';
        ctrl.EAF.City__c = '';
        ctrl.EAF.State__c = 'None';
        ctrl.EAF.Zip_Code__c='';
        ctrl.EAF.Phone__c = '';
        ctrl.EAF.Fax_Number__c = '';
        ctrl.EAF.Phone_Extension__c = '';
        ctrl.EAF.Names_Changes_Suggested__c = '';
        ctrl.saveUpdatedAddress();
        ctrl.caseObj.PDV_Contact_Name__c = 'nagarjuna';
        ctrl.caseObj.Contact_Number__c = 19676561568.00;
        ctrl.caseObj.Status = 'Closed';
        ctrl.updateCase();
        System.assertEquals(false, ctrl.isAddressValidated);
        test.stopTest();
    }
    /*******************************************************************
Purpose:  This is used to test existing address validation .
Parameters: N/A
Returns: PageReference    
Throws [Exceptions]: N/A
********************************************************************/
    static testMethod void saveUpdateExistingAddress_Test(){
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
        List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
        insert facList;
        
        PageReference pageRef = new PageReference('/apex/PDIEAFFacilityDetail?EAFId=' + facList[0].Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController con = new ApexPages.StandardController(facList[0]);
        PDIEAFFacilityDetailController ctrl = new PDIEAFFacilityDetailController(con);
        
        PDV_EAF_Validation_Audit_Trail__c audit = Util01_PDIUtilTestData.createEAFAudit();
        audit.EAF_Facility__c = facList[0].Id;
        audit.Address_Line_1__c = '1541 Florida Avenue';
        audit.Address_Line_2__c = 'Suite 200';
        audit.City__c = 'Modesto';
        audit.State__c = 'AI';
        audit.Zip_Code__c = '95350';
        audit.Phone__c = '9985432126';
        audit.Phone_Extension__c = '3456';
        audit.FAX_NUMBER__c = '9745645643';        
        insert audit;
        
        test.startTest();
        ctrl.checkAllparameters();
        ctrl.createCase();
        ctrl.EAFId = facList[0].Id;
        ctrl.saveUpdatedAddress();
        try{
            ctrl.saveUpdatedAddress();  
        }catch(Exception ex){
            System.assert(ex.getMessage() != null);
        }
        test.stopTest();
        
    }
    
    /*******************************************************************
Purpose:  This is used to test Find Suggested Address with blank values.
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
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
            List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
            insert facList;
            
            PageReference pageRef = new PageReference('/apex/PDIEAFFacilityDetail?EAFId=' + facList[0].Id);
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController con = new ApexPages.StandardController(facList[0]);
            PDIEAFFacilityDetailController ctrl = new PDIEAFFacilityDetailController(con);
            
            ctrl.checkAllparameters();
            ctrl.EAF.Decline_Phone__c = false;
            ctrl.EAF.Decline_Fax__c = false;
            ctrl.EAF.Phone__c = '19676561568';
            ctrl.EAF.Phone_Extension__c = 'abvcd';
            test.startTest();
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
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
            List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
            insert facList;
            
            PageReference pageRef = new PageReference('/apex/PDIEAFFacilityDetail?EAFId=' + facList[0].Id);
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController con = new ApexPages.StandardController(facList[0]);
            PDIEAFFacilityDetailController ctrl = new PDIEAFFacilityDetailController(con);
            
            ctrl.checkAllparameters();
            ctrl.EAF.Address_Line_1__c = 'Care Of 140 address';
            ctrl.EAF.Phone__c = 'AB876#783';
            ctrl.EAF.Fax_Number__c = '8767823';
            test.startTest();
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
    static testMethod void findSuggestedAddressWithEmptyInput_Test() {
        
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
            
            List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
            insert facList;
            
            PageReference pageRef = new PageReference('/apex/PDIEAFFacilityDetail?EAFId=' + facList[0].Id);
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController con = new ApexPages.StandardController(facList[0]);
            PDIEAFFacilityDetailController ctrl = new PDIEAFFacilityDetailController(con);
            
            ctrl.checkAllparameters();
            ctrl.EAF.Address_Line_1__c = '';
            ctrl.EAF.Phone__c = '';
            ctrl.EAF.Fax_Number__c = '';
            ctrl.EAF.City__c = '';
            ctrl.EAF.State__c = 'None';
            ctrl.EAF.Zip_Code__c = '';
            
            test.startTest();
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
            PDIByPassEmailVerification__c byPassEmail = Util01_PDIUtilTestData.insertBypassEmailAddrVerificationSetting();
            List<PDI_Bypass_AddressVerification__c> byPassAddress = Util01_PDIUtilTestData.insertBypassAddressVerificationSetting();
            
            List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
            insert facList;
            
            PageReference pageRef = new PageReference('/apex/PDIEAFFacilityDetail?EAFId=' + facList[0].Id);
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController con = new ApexPages.StandardController(facList[0]);
            PDIEAFFacilityDetailController ctrl = new PDIEAFFacilityDetailController(con);
            Provider_Address__c primaryAddrVerify = new Provider_Address__c();
            test.startTest();
            ctrl.checkAllparameters();
            
            //Address Positive
            ctrl.EAF.Address_Line_1__c = AP01_TestDataTokens.ADDR2_ADDRESS_LINE1;
            ctrl.EAF.Address_Line_2__c = AP01_TestDataTokens.ADDRESS_LINE2;
            ctrl.EAF.City__c = AP01_TestDataTokens.CITY;
            ctrl.EAF.State__c = AP01_TestDataTokens.STATE;
            ctrl.EAF.Zip_Code__c = AP01_TestDataTokens.ZIP_CODE;
            ctrl.EAF.Phone__c = AP01_TestDataTokens.ADDR2_SECURE_PHONE;
            ctrl.EAF.Fax_Number__c = AP01_TestDataTokens.ADDR2_SECURE_FAX;
            
            Map<Integer, String> elementStatusMap = new Map<Integer, String>();
            elementStatusMap.put(0, 'PostCode0');
            elementStatusMap.put(1, 'PostCode1');
            ctrl.statusMap = elementStatusMap;
            ctrl.suggestedAddressFlag = false;
            ctrl.findSuggestedAddress();
            
            Set<String> processCodes = new Set<String>();
            processCodes.add('I3');
            ctrl.processCodes = processCodes;
            ctrl.suggestedAddressFlag = false;
            ctrl.findSuggestedAddress();
            
            Map<String, String> notProccessedStatMap = new Map<String, String>();
            for(PDIADNotProcessedCodes__c notProcessed : notProccessedList){
                notProccessedStatMap.put(notProcessed.Name, notProcessed.Code__c);
            }
            notProccessedStatMap.put('I3', '');
            ctrl.addressNotProcessedStatusMap = notProccessedStatMap;
            ctrl.suggestedAddressFlag = false;
            ctrl.findSuggestedAddress();
            
            ctrl.checkAllparameters();
            ctrl.suggestedAddressFlag = false;
            ctrl.findSuggestedAddress();
            
            Map<String, String> addressWebServiceMap = new Map<String, String>();
            addressWebServiceMap.put('I3', '');
            ctrl.addressWebserviceStatusMap = addressWebServiceMap;
            ctrl.suggestedAddressFlag = false;
            ctrl.findSuggestedAddress();
            System.assertEquals(true, ctrl.verifiedAddressList.size()>0);
            test.stopTest();
        }
    }
    /*******************************************************************
Purpose:  This is used to test cancel Address.
Parameters: N/A
Returns: PageReference    
Throws [Exceptions]: N/A
********************************************************************/
    static testMethod void cancelAddress_Test(){
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
        
        List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
        insert facList;
        
        PageReference pageRef = new PageReference('/apex/PDIEAFFacilityDetail?EAFId=' + facList[0].Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController con = new ApexPages.StandardController(facList[0]);
        PDIEAFFacilityDetailController ctrl = new PDIEAFFacilityDetailController(con);
        
        ctrl.checkAllparameters();
        test.startTest();
        ctrl.createCase();
        ctrl.cancelAddress();
        System.assertEquals(false, ctrl.isAddressValidated);
        test.stopTest();
    }
    
    /*******************************************************************
Purpose:  This is used to test updateCaseRequired.
Parameters: N/A
Returns: PageReference    
Throws [Exceptions]: N/A
********************************************************************/
    static testMethod void updateCaseValidation_Test(){
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
        
        List<PDV_EAF_Facility__c> facListUpdate = new List<PDV_EAF_Facility__c>();
        List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
        insert facList;
        
        PageReference pageRef = new PageReference('/apex/PDIEAFFacilityDetail?EAFId=' + facList[0].Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController con = new ApexPages.StandardController(facList[0]);
        PDIEAFFacilityDetailController ctrl = new PDIEAFFacilityDetailController(con);
        
        PDV_EAF_Facility__c address1 = new PDV_EAF_Facility__c();
        
        ctrl.checkAllparameters();
        
        test.startTest();
        
        ctrl.createCase();
        ctrl.caseObj.PDV_Contact_Name__c = '';
        ctrl.strCaseContactPhoneNumber = '';
        ctrl.caseObj.Common_Subject_Lines__c = 'None';
        ctrl.caseObj.status = '';
        ctrl.updateCase();
        ctrl.strCaseContactPhoneNumber = '94646dgdfg';
        ctrl.updateCase();
        List<ApexPages.Message> pageMessages2 = ApexPages.getMessages();
        system.assertEquals(pageMessages2.size() > 0, true);
        test.stopTest();
    }
}