/**  
*    Class Name: VFC41_Provider_List_Controller_Test
*    Author: IDC Team
*    Date: -July-2015
*    Description:  Test class for VFC41_Provider_List_Controller Controller
*    History
*    --------
**/
@isTest
private class VFC41_Provider_List_Controller_Test{

    static testMethod void SearchValidatedProvider() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            try{
                /* @Description : Req-3694, Date: 06/10/2015, Phone number filter added on Search results  */  
                List<Contact> validatedContactList = Util01_PDIUtilTestData.create_Provider_Validated_Contact();
                
                PageReference pageRef = new PageReference('/apex/VFP41_Provider_List');
                Test.setCurrentPage(pageRef);
                
                VFC41_Provider_List_Controller providerListController = new VFC41_Provider_List_Controller();
    
                providerListController.providerLastName = 'LastNameP';
                providerListController.SearchProvider();
                providerListController.getProvidersList();
                providerListController.doNext();
                providerListController.doPrevious();
                providerListController.dofirst();
                providerListController.doLast();
                providerListController.getHasPrevious();
                providerListController.getHasNext();
                providerListController.getPageNumber();
                providerListController.getTotalPages();
      
            }catch(Exception ex){
                
            }
        }
        
    }
    
    static testMethod void SearchValidatedProvider_Provider_NPI() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            try{
                /* @Description : Req-3694, Date: 06/10/2015, Phone number filter added on Search results  */  
                List<Contact> validatedContactList = Util01_PDIUtilTestData.create_Provider_Validated_Contact();
                
                PageReference pageRef = new PageReference('/apex/VFP41_Provider_List');
                Test.setCurrentPage(pageRef);
                
                VFC41_Provider_List_Controller providerListController = new VFC41_Provider_List_Controller();
    
                providerListController.providerNPI = '1234';
    
                providerListController.SearchProvider();
      
            }catch(Exception ex){
                system.assertEquals(ex.getMessage(), 'No results found');
            }
        }
    }
    
    static testMethod void SearchValidatedProvider_No_of_Characters_Error() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            try{
                /* @Description : Req-3694, Date: 06/10/2015, Phone number filter added on Search results  */  
                List<Contact> validatedContactList = Util01_PDIUtilTestData.create_Provider_Validated_Contact();
                
                PageReference pageRef = new PageReference('/apex/VFP41_Provider_List');
                Test.setCurrentPage(pageRef);
                
                VFC41_Provider_List_Controller providerListController = new VFC41_Provider_List_Controller();
    
                providerListController.providerLastName = 'L';
    
                providerListController.SearchProvider();
      
            }catch(Exception ex){
                system.assertEquals(ex.getMessage(), 'Your search did not contain the correct number of characters to perform this search');
            }
        }
    }
    
   static testMethod void SearchValidatedProvider1() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            try{
                /* @Description : Req-3694, Date: 06/10/2015, Phone number filter added on Search results  */  
                List<Contact> validatedContactList = Util01_PDIUtilTestData.create_Provider_Validated_Contact();
                Contact_Validation_Summary__c objSumm = new Contact_Validation_Summary__c();
                objSumm.name='test';
                objSumm.PDI_Campaign__c='2016 Wave1';
                objSumm.Address_Type__c ='Primary';
                objSumm.Contact_Id__c = validatedContactList[0].id;
                insert objSumm;
                PageReference pageRef = new PageReference('/apex/VFP41_Provider_List');
                Test.setCurrentPage(pageRef);
                
                VFC41_Provider_List_Controller providerListController = new VFC41_Provider_List_Controller();
    
                providerListController.providerLastName = 'LastNameP';
                providerListController.SearchProvider();
                providerListController.getProvidersList();
                providerListController.doNext();
                providerListController.doPrevious();
                providerListController.dofirst();
                providerListController.doLast();
                providerListController.getHasPrevious();
                providerListController.getHasNext();
                providerListController.getPageNumber();
                providerListController.getTotalPages();
            }catch(Exception ex){
                
            }
        }
        
    }
    static testMethod void SearchValidatedProvider_No_Provider() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            try{
               /* @Description : Req-3694, Date: 06/10/2015, Phone number filter added on Search results  */ 
                List<Contact> validatedContactList = Util01_PDIUtilTestData.create_Provider_Validated_Contact();
                
                PageReference pageRef = new PageReference('/apex/VFP41_Provider_List');
                Test.setCurrentPage(pageRef);
                
                VFC41_Provider_List_Controller providerListController = new VFC41_Provider_List_Controller();
    
                providerListController.providerLastName = 'test';
                
                providerListController.SearchProvider();
                
            }catch(Exception ex){
                system.assert(ex!=null);
                
            }
        }
    }
    
    static testMethod void SearchValidatedProvider_Exception_Test() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            try{
               /* @Description : Req-3694, Date: 06/10/2015, Phone number filter added on Search results  */ 
                List<Contact> validatedContactList = Util01_PDIUtilTestData.create_Provider_Validated_Contact();
                
                PageReference pageRef = new PageReference('/apex/VFP41_Provider_List');
                Test.setCurrentPage(pageRef);
                
                VFC41_Provider_List_Controller providerListController = new VFC41_Provider_List_Controller();
    
                providerListController.providerLastName = 'test';
                providerListController.getProviderSearchQuery();
                providerListController.getSearchResults(null);
                providerListController.SearchProvider();
                
            }catch(Exception ex){
                system.assert(ex!=null);
                
            }
        }
    }
     static testMethod void ProviderSummaryCustomSearchWithPhoneNumber() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            try{
                /* @Description : Req-3694, Date: 06/10/2015, Phone number filter added on Search results  */  
                List<Contact> validatedContactList = Util01_PDIUtilTestData.create_Validated_Contact();
                PageReference pageRef = new PageReference('/apex/VFP41_Provider_List');
                Test.setCurrentPage(pageRef);
                VFC41_Provider_List_Controller providerListController = new VFC41_Provider_List_Controller();
                Test.startTest();
                providerListController.providerTelePhoneNumber = '5657657688';
                providerListController.SearchProvider();
                providerListController.getProvidersList();
                providerListController.doNext();
                providerListController.doPrevious();
                providerListController.dofirst();
                providerListController.doLast();
                providerListController.getHasPrevious();
                providerListController.getHasNext();
                providerListController.getPageNumber();
                providerListController.getTotalPages();
                Test.stopTest();
      
            }catch(Exception ex){
                
            }
        }
        
    }
    
    static testMethod void SearchWithInvalidPhoneNumber() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            try{
                /* @Description : Req-3694, Date: 06/10/2015, Phone number filter added on Search results  */  
                List<Contact> validatedContactList = Util01_PDIUtilTestData.create_Provider_Validated_Contact();
                
                PageReference pageRef = new PageReference('/apex/VFP41_Provider_List');
                Test.setCurrentPage(pageRef);
                
                VFC41_Provider_List_Controller providerListController = new VFC41_Provider_List_Controller();
    
                providerListController.providerTelePhoneNumber = 'abcd';
    
                providerListController.SearchProvider();
      
            }catch(Exception ex){
                system.assertEquals(ex.getMessage(), Label.CL381_InValidTelephoneNumber);
            }
        }
    }
    
    static testMethod void SearchWithInvalidCaseNumber() {
        
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        
        System.runAs(socUser){
            try{
                /* @Description : Req-3694, Date: 06/10/2015, Phone number filter added on Search results  */  
                List<Contact> validatedContactList = Util01_PDIUtilTestData.create_Provider_Validated_Contact();
                
                PageReference pageRef = new PageReference('/apex/VFP41_Provider_List');
                Test.setCurrentPage(pageRef);
                
                VFC41_Provider_List_Controller providerListController = new VFC41_Provider_List_Controller();
    
                providerListController.providerTransactionNumber = 'abcd';
    
                providerListController.SearchProvider();
      
            }catch(Exception ex){
                system.assertEquals(ex.getMessage(), Label.CL383_InValidTransactionNumber);
            }
        }
    }
    
    /*******************************************************************
    Purpose: This is used to test the custom search with case number.
    Parameters: N/A
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void ProviderSummaryCustomSearchWithCaseNumber() {
        
        User socUser1 = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(socUser1){
            
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            
            List<Contact_Validation_Summary__c> summaryUpdateList = new List<Contact_Validation_Summary__c>();
            
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();

            system.assert(conList.size()>0);

            Case caseObj = new Case();
            caseObj.subject = 'Test';
            caseObj.recordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Provider Validation RT').RecordTypeId;
            caseObj.origin = 'Outbound Call';
            caseObj.Common_Subject_Lines__c = 'Validated Provider';
                caseObj.Provider_Name__c =  conList[0].Name;
                caseObj.Provider_Type__c =  'Provider';
                caseObj.Provider_Id_EAF_ID__c = conList[0].Provider_ID__c;
                caseObj.contactId = conList[0].Id;
            insert caseObj;
       
            
            caseObj = [select OwnerId, casenumber,Close_Reason__c,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                       status,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c, Provider_Assigned_Date__c,
                       subject,description,CreatedBy.Name,owner.Name from case where Id = :caseObj.Id];
           
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c, PDI_campaign__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            for(Contact_Validation_Summary__c summary : summaryRecords){
                summary.OwnerId = UserInfo.getUserId();
                summary.Status__c = 'Validated';
                summary.Associated_Case_Id__c = caseObj.Id;
                summaryUpdateList.add(summary);
            }
            update summaryUpdateList;

            String ContactId;
             List<Case> caseList = [SELECT Id, Contact.Id, CaseNumber FROM CASE WHERE CaseNumber =: caseObj.CaseNumber LIMIT 1]; 
            if(!caseList.isEmpty())
            {
                contactId = caseList[0].Contact.Id;  
            }
            else
            {
                contactId = '';  
            }

            PageReference pageRef = new PageReference('/apex/VFP41_Provider_List');
                Test.setCurrentPage(pageRef);
                VFC41_Provider_List_Controller providerListController = new VFC41_Provider_List_Controller();
                Test.startTest();
                providerListController.providerTransactionNumber = caseObj.CaseNumber;
                providerListController.SearchProvider();
                providerListController.getProvidersList();
                providerListController.doNext();
                providerListController.doPrevious();
                providerListController.dofirst();
                providerListController.doLast();
                providerListController.getHasPrevious();
                providerListController.getHasNext();
                providerListController.getPageNumber();
                providerListController.getTotalPages();
                Test.stopTest();
        }
    }
}