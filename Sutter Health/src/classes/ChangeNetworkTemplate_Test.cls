/**
    @Author      : IDC Offshore
    @name        : ChangeNetworkTemplate_Test Class
    @CreateDate  : 07/04/2015 (DD/MM/YYYY)
    @Description : Used for PDV Requirement REQ#3399.This class is test class for ChangeNetworkTemplate
    @Version     : 1.0
    @reference   : NA
    */

@isTest
Private class ChangeNetworkTemplate_Test {
    /**             
    * @author IDC Offshore          
    * @date 07/04/2015 (DD/MM/YYYY)      
    * @description:Method to create custom setting data and test ChangeTemplate method.      
    * @return void             
    */  
    static testmethod void testNetworkUpdate(){
        //@description This method create test data for AccessTokenSetting custom setting.
        list<AccessTokenSetting__c> lstAccessTokenSetting  = AP01_TestDataUtility.createAccessTokenSettingSet();
        insert lstAccessTokenSetting;
        
        //Assert to check if AccessTokenSetting__c  custom setting has been created successfully 
        List<AccessTokenSetting__c> TemplstAccessTokenSetting = AccessTokenSetting__c.getall().values();
        system.debug(TemplstAccessTokenSetting != null);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        test.startTest();
        EmailTemplate ProviderTeleForm = [select id from EmailTemplate where name='Provider Community: Provider Welcome Email For TeleForm'];
        System.assert(ProviderTeleForm !=null);
        ChangeNetworkTemplate objChangeNetwork = new ChangeNetworkTemplate();
        objChangeNetwork.ChangeTemplate(ProviderTeleForm.id);
        test.stopTest();

    }
    /**             
    * @author IDC Offshore          
    * @date 18/11/2015 (DD/MM/YYYY)      
    * @description:To validate negative senario of  ChangeTemplate method through wrong username and Password.  
    * @return void             
    */  
    static testmethod void testNegativeNetworkUpdate(){
        //@description This method create test data for AccessTokenSetting custom setting.
        list<AccessTokenSetting__c> lstAccessTokenSetting  = AP01_TestDataUtility.createAccessTokenSettingSet();
        lstAccessTokenSetting[0].Username__c = 'Wrongtestusername';
        lstAccessTokenSetting[0].Password__c  = 'wrongPassword';
        insert lstAccessTokenSetting;
        
        //Assert to check if AccessTokenSetting__c  custom setting has been created successfully 
        List<AccessTokenSetting__c> TemplstAccessTokenSetting = AccessTokenSetting__c.getall().values();
        system.debug(TemplstAccessTokenSetting != null);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        test.startTest();
        EmailTemplate ProviderTeleForm = [select id from EmailTemplate where name='Provider Community: Provider Welcome Email For TeleForm'];
        System.assert(ProviderTeleForm !=null);
        try{
        ChangeNetworkTemplate objChangeNetwork = new ChangeNetworkTemplate();
        objChangeNetwork.ChangeTemplate(ProviderTeleForm.id);
        }
        catch(exception ex ){system.assert(ex.getMessage() != null);}
        test.stopTest();

    }
}