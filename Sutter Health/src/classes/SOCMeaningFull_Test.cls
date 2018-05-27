/**  
  *     Class Name  : SOCMeaningFull_Test
  *     Author      : IDC Offshore
  *     Date        : 
  *     Project Name: CRM - SFT - Sutter Health
  *     Description : Test Class for SOC_MeaningFull_Class. This class tests different scenarios that are handled in the code
**/
@isTest
private class SOCMeaningFull_Test{

    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description method to create test data used by all test methods    
     * @return void        
     **/
    @testsetup
    Static Void createTestData()
    { 
        MeaningfulUse_Site_Credentials__c mu = new MeaningfulUse_Site_Credentials__c();
        mu.Name = '11';
        mu.username_cust_sett__c = 'TestUser';
        mu.password_cust_sett__c = 'TestPWD';
        insert mu;
        
        Case cust = new Case();Id rtId = [Select id from RecordType where SobjectType = 'Case' AND Name =: system.label.CL12_S3PatientInteractionLog].id;
        Id socRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Summary_of_Care).getRecordTypeId();
        cust.recordtypeId = socRT;
        cust.CALLID__c = '123456789';
        cust.DNISTYPECODE__c = 'PatInq';
        cust.subject = 'test';
        cust.status = 'Escalate To Meaningful Use';
        insert cust;
        //Assert to check case has been created successfully
        System.assert(cust.id!=null);

        SOC_Queue__c objSOCQueue = new SOC_Queue__c(Name = 'Test Name',Associated_Case_Id__c = cust.id);
        insert objSOCQueue;
        // Assert to check Soc Queue has been Created .
        System.assert(objSOCQueue.id != null);
    }
    
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description method to insert MeaningfulUse Site Credentials record in custom setting and check login credentials.If login credentials  match, cookie is created else an error is displayed.This test method also covers query_soc_list_map_method.    
     
     * @return void        
     **/
    static testMethod void loginMethodTest() {
    
        ApexPages.currentPage().getParameters().put('loggedInUser',userinfo.getuserid());
        ApexPages.currentPage().getParameters().put('backto','true');
        SOC_MeaningFull_Class SOCM = new SOC_MeaningFull_Class();
        SOCM.actionMethod();
                 
        SOCM.username= 'UserNameTest';
        SOCM.password= 'PWDtest';

        SOCM.loginMethod();

        SOC_MeaningFull_Class SOCM1 = new SOC_MeaningFull_Class();
        SOCM1.username= 'TestUser';
        SOCM1.password= 'TestPWD';

        SOCM1.loginMethod();
        
        MeaningfulUse_Site_Credentials__c mu = [select id,username_cust_sett__c,password_cust_sett__c from MeaningfulUse_Site_Credentials__c limit 1];
        
        // assert to check login credential are same 
        System.assertEquals(SOCM1.username,mu.username_cust_sett__c);
        System.assertEquals(SOCM1.password,mu.password_cust_sett__c);

        SOC_MeaningFull_Class SOCM2 = new SOC_MeaningFull_Class();
        SOCM2.username= '';
        SOCM2.password= '';

        SOCM2.loginMethod();
    }
    
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description: This test method aims to cover the catch block put in the code in login method     
     * @return void        
     **/
    static testMethod void TestExceptionloginMethodTest() {
    
        ApexPages.currentPage().getParameters().put('loggedInUser','123455666');
        ApexPages.currentPage().getParameters().put('backto','12345444322323432');
        SOC_MeaningFull_Class SOCM = new SOC_MeaningFull_Class();
        SOCM.actionMethod();
               
        SOCM.username= 'UserNameTest';
        SOCM.password= 'PWDtest';

        SOCM.loginMethod();

        SOC_MeaningFull_Class SOCM1 = new SOC_MeaningFull_Class();
        SOCM1.username= 'TestUser';
        SOCM1.password= 'TestPWD';

        SOCM1.loginMethod();
        
        MeaningfulUse_Site_Credentials__c mu = [select id,username_cust_sett__c,password_cust_sett__c from MeaningfulUse_Site_Credentials__c limit 1];
        
        // assert to check login credential are same 
        System.assertEquals(SOCM1.username,mu.username_cust_sett__c);
        System.assertEquals(SOCM1.password,mu.password_cust_sett__c);

        SOC_MeaningFull_Class SOCM2 = new SOC_MeaningFull_Class();
        SOCM2.username= '';
        SOCM2.password= '';

        SOCM2.loginMethod();
    }
    
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description This test method aims at checking the logic of the logoutFromSite by providing the test data sufficient enough to cover the whole method
     * @return void        
     **/
    static testMethod void logOutSiteMethodTest() {

        SOC_MeaningFull_Class SOCM = new SOC_MeaningFull_Class();
        SOCM.username= 'TestUser';
        SOCM.password= 'TestPWD';

        SOCM.logoutFromSite();
        
        MeaningfulUse_Site_Credentials__c mu = [select id,username_cust_sett__c,password_cust_sett__c from MeaningfulUse_Site_Credentials__c limit 1];
        // assert to check login credential are same 
        System.assertEquals(SOCM.username,mu.username_cust_sett__c);
        System.assertEquals(SOCM.password,mu.password_cust_sett__c);
    }
    
    /**        
     * @author IDC Team        
     * @date 24/Nov/2015       
     * @description method to cover login method by covering the Query List SOC Method completely by filling data in MapCaseIdToSOCId map
     * @return void        
     **/
    
    static testMethod void QuertListSocMethodTest() {

        SOC_Queue__c objSOCQueue = [select id from SOC_Queue__c limit 1];
        delete objSOCQueue;
        
        SOC_MeaningFull_Class SOCM = new SOC_MeaningFull_Class();
        
        SOCM.username= 'TestUser';
        SOCM.password= 'TestPWD';

        SOCM.loginMethod();
        
        MeaningfulUse_Site_Credentials__c mu = [select id,username_cust_sett__c,password_cust_sett__c from MeaningfulUse_Site_Credentials__c limit 1];
        // assert to check login credential are same 
        System.assertEquals(SOCM.username,mu.username_cust_sett__c);
        System.assertEquals(SOCM.password,mu.password_cust_sett__c);
    }
    
}