/**  
*    Class Name: CRMEmployeeSearchControllerTest
*    Author: Accenture
*    Date: 02-NOV-2014
*    Description: Test Class for CRMEmployeeSearchController Class. This test class will test the business functionality of CRMEmployeeSearch VF page.
*    History:
*    11/02/2014 - Umesh Kumar Vajpai
*               - Initial Implementation
**/

@isTest
private  class CRMEmployeeSearchControllerTest 
{
    private static final Integer maxRecords = 110;
    
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description: method to create test data used by all tests       
     * @return void        
     */
    @testSetup static void createTestData() {
        
        CS_ManageProfile__c setting = new CS_ManageProfile__c();
        setting.Name = 'Communities_Provider';
        setting.Profile_Name__c = 'Community Provider';
        insert setting;
        
        //Assert to check if CS_ManageProfile__c  custom setting has been created successfully 
        List<CS_ManageProfile__c> lstCS_ManageProfile = CS_ManageProfile__c.getall().values();
        system.assert(lstCS_ManageProfile != null);

        ActiveStatus__c statusSetting = new ActiveStatus__c();
        statusSetting.Name = 'AA';
        insert statusSetting;
    
        //Assert to check if ActiveStatus__c  custom setting has been created successfully 
        List<ActiveStatus__c> lstActiveStatus = ActiveStatus__c.getall().values();
        system.assert(lstActiveStatus != null);
        
        Salesforce_Affiliates__c affiliateSetting = new Salesforce_Affiliates__c();
        affiliateSetting.Name = 'Sutter Shared Services';
        affiliateSetting.Affiliate_Name__c = 'Sutter Shared Services';
        affiliateSetting.isSalesforce_True__c = true;
        
        //Assert to check if Salesforce_Affiliates__c  custom setting has been created successfully 
        List<Salesforce_Affiliates__c> lstSalesforceAffiliates = Salesforce_Affiliates__c.getall().values();
        system.assert(lstSalesforceAffiliates != null);
        
        //create test account
        Account acc = new Account(Name='Test Account Name');
        acc.RecordTypeId = [Select Id from RecordType Where Name = 'S3 Employee' AND sObjectType ='Account'].Id;
        insert acc;
        
        //Assert to check if Account has been created successfully 
        Account tempAcc = [select id from Account where name = 'Test Account Name' limit 1];
        system.assert(tempAcc.id != null);
        
        RecordType rt = [Select Id,Name from RecordType Where Name ='Employee' AND sObjectType='Contact'];
        Profile p = [SELECT Id FROM Profile WHERE Name='Community Portal']; 
        
        //create test contacts
        List<Contact> newContacts = new List<Contact>();
        for(Integer i=0;i<maxRecords;i++)
        {
            Contact con= new Contact();
            con.FirstName = 'Portal';
            con.LastName = 'User'+i;
            con.AccountId = acc.Id;
            con.recordTypeId = rt.Id;
            con.Email = 'portaluser'+i+'@abc.com';
            newContacts.add(con);
            
        }
        insert newContacts;
        
        //Assert to check if Contacts have been created successfully 
        list<Contact> templstContacts = [select id from Contact where AccountId =: acc.id];
        system.assert(templstContacts != null);
        
        //Create Portal Users
        List<User> portalUserList = new List<User>();
        for(Integer i=0;i<maxRecords; i++)
        {
            User u = new User(Alias = 'standt', Email='portaluser@testmethod.com', 
            EmailEncodingKey='UTF-8', LastName='User'+i, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='portaluser'+i+'@testmethod.com');
            u.contactId = newContacts[i].Id;
            portalUserList.add(u);
            
        }
        insert portalUserList;
        
        //Assert to check if Users have been created successfully 
        list<User> templstUser = [select id from User where contactId IN : newContacts];
        system.assert(templstUser != null);
    }
    
    /**             
    * @author IDC Offshore          
    * @date 02-NOV-2014 (DD/MM/YYYY)      
    * @description: To cover(Validate) SearchEmployee method.      
    * @return void             
    */
    static testMethod void testSearchEmployee(){
        //Set the page reference
        PageReference newPage = new PageReference('/apex/CRMEmployeeSearch');
        Test.setCurrentPage(newPage);
        
        //Instantiate the controller
        CRMEmployeeSearchController ctrl = new CRMEmployeeSearchController();
        
        ctrl.username =System.Label.Site_Username;
        ctrl.password =System.Label.Site_Password;
        
        ctrl.LoginCall();
        ctrl.getItems();
        ctrl.searchType = 'Employee';
        ctrl.setRenderVariables();
        
        ctrl.firstName ='';
        ctrl.employeeId ='';
        ctrl.employeeAdId ='';
        ctrl.lastName = 'User';
        ctrl.SearchEmployee();
        
        ctrl.nextPage();
        ctrl.updatePage();
        ctrl.previousPage();
        ctrl.updatePage();
        
        //search by first name
        ctrl.employeeId ='';
        ctrl.employeeAdId ='';
        ctrl.lastName = '';
        ctrl.firstName = 'Portal';
        ctrl.SearchEmployee();
        
        //search by first & last name
        ctrl.firstName  = 'Portal';
        ctrl.lastName = 'User';
        ctrl.SearchEmployee();
        
        //search by employeeId
        ctrl.employeeId    = '12345';
        ctrl.SearchEmployee();
        
        //search by AD ID 
        ctrl.employeeAdId    = 'portaluser';
        ctrl.SearchEmployee();
        
        
        //Assert to check search Employee...
        system.assert(ctrl.employeeResultWrapperList != null);
    }
    
    /**             
    * @author IDC Offshore          
    * @date 17-NOV-2015 (DD/MM/YYYY)      
    * @description: To validate the Negative Senario of SearchEmployee and  LoginCall methods.      
    * @return void             
    */
    static testMethod void testNegativeSearchEmployee(){
        //Set the page reference
        PageReference newPage = new PageReference('/apex/CRMEmployeeSearch');
        Test.setCurrentPage(newPage);
        
        //Instantiate the controller
        CRMEmployeeSearchController ctrl = new CRMEmployeeSearchController();
        ctrl.firstName = '';
        ctrl.lastName = '';
        ctrl.employeeId = '';
        ctrl.employeeAdId = '';
        ctrl.SearchEmployee();
    
        // make login call again with wrong credentials
        ctrl.username ='test';
        ctrl.password ='test';
        ctrl.LoginCall();
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Please enter at least one criteria') || msg.getDetail().contains('Your login attempt has failed. The username or password may be incorrect. Please try again.') ) b = true;
        }
        //Assert to check vf page error messages
        system.assert(b);   
    }
    
    /**             
    * @author IDC Offshore          
    * @date 02-NOV-2014 (DD/MM/YYYY)      
    * @description: To cover(Validate) SearchProvider method.      
    * @return void             
    */
    static testMethod void testSearchProvider()
    {
        
        RecordType rt = [Select Id,Name from RecordType Where Name ='Provider' AND sObjectType='Contact'];
        List<Contact> conList = [Select Id,RecordTypeId from Contact where email like '%portaluser%'];
        for(Contact c : conList)
        {
            c.recordTypeId = rt.Id;
        }
        update conList;
        
        //Set the page reference
        PageReference newPage = new PageReference('/apex/CRMEmployeeSearch');
        Test.setCurrentPage(newPage);
        
        //Instantiate the controller
        CRMEmployeeSearchController ctrl = new CRMEmployeeSearchController();
        ctrl.username =System.Label.Site_Username;
        ctrl.password =System.Label.Site_Password;
        
        ctrl.LoginCall();
        ctrl.getItems();
        ctrl.searchType = 'Provider';
        ctrl.setRenderVariables();
        
        //search by last name
        ctrl.pLastName = 'User';
        ctrl.SearchProvider();
        
        ctrl.nextPage();
        ctrl.updatePage();
        ctrl.previousPage();
        ctrl.updatePage();
        
        //search by first name
        ctrl.pLastName = '';
        ctrl.pFirstName  = 'Portal';
        ctrl.SearchProvider();
        
        //search by first & last name
        ctrl.pFirstName  = 'Portal';
        ctrl.pLastName = 'User';
        ctrl.SearchProvider();
        
        //search by email
        ctrl.pEmail   = 'portaluser';
        ctrl.SearchProvider();
        
        //search by username 
        ctrl.pUsername   = 'portaluser';
        ctrl.SearchProvider();
        
        //search by fax
        ctrl.pFax    = '222222';
        ctrl.SearchProvider();
        
        // make login call again with wrong credentials
        ctrl.username ='test';
        ctrl.password ='test';
        ctrl.LoginCall();
        
        //Assert to check search provider...
        system.assert(ctrl.providerResultWrapperList != null);
    }
    /**             
    * @author IDC Offshore          
    * @date 17-NOV-2015 (DD/MM/YYYY)      
    * @description: To validate the Negative Senario of SearchProvider method.      
    * @return void             
    */
    static testMethod void testNegativeSearchProvider(){
        //Set the page reference
        PageReference newPage = new PageReference('/apex/CRMEmployeeSearch');
        Test.setCurrentPage(newPage);
        
        //Instantiate the controller
        CRMEmployeeSearchController ctrl = new CRMEmployeeSearchController();
        ctrl.pFirstName = '';
        ctrl.pLastName = '';
        ctrl.pEmail = '';
        ctrl.pUsername = '';
        ctrl.pFax = '';
        ctrl.SearchProvider();
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Please enter at least one criteria')) b = true;
        }
        //Assert to check vf page error messages
        system.assert(b);   
    }
}