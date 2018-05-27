/**********************************************************************
Name: SiteLoginControllerTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is the test class for SiteLoginController.
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  9/27/2013  Development complete   This class is intended to test SiteLoginController functions.
***********************************************************************/
  @IsTest
  
  private class SiteLoginControllerTest {
   
 
 
 /*******************************************************************
  Purpose: This Method tests  the login functionality of site login.Login is to be done successfully using the username and password that are provided
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/
 
     static testMethod void testSiteLoginController () {
        
        Test.startTest();
        
        /** Setting the current PageReference to SiteLogin page **/
        Test.setCurrentPageReference(new PageReference('Page.SiteLogin'));

        
        /** Putting the value of refURL in the URL Parameter so that it can be retrieved in the code **/
        System.currentPageReference().getParameters().put('refURL', 'articles test Policy');
        
        /** Instantiating the controller class and then populating the value in username and password controller variable **/
        SiteLoginController controller = new SiteLoginController();
             
        /** Setting the username from the AP_01 utility class **/
        controller.username = AP01_TestDataTokens.SITE_LOGIN_USER_NAME;
        
        /** Setting the value in password from AP_01 utlity class **/
        controller.password = AP01_TestDataTokens.SITE_LOGIN_PASSWORD; 
        
        /** Using the object of the controller we instantiated above, we call the Login() method **/
        controller.login();
        
        Test.stopTest();
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: null
        Actual Result: null 
        ***********************************************************************/
        system.assertEquals(controller.login(),null);
                                      
    }   
  
 
 /*******************************************************************
  Purpose: This Method tests  the login functionality of site login completely including the else block by changing the value in refURL parameter
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/
  
  static testMethod void testSiteLoginController_Negative () {
        
        Test.startTest();
        
        /** Setting the current PageReference to SiteLogin page **/
        Test.setCurrentPageReference(new PageReference('Page.SiteLogin'));

        /** Putting the value of refURL in the URL Parameter so that it can be retrieved in the code **/
        System.currentPageReference().getParameters().put('refURL', 'article test Policy');
        
        /** Instantiating the controller class and then populating the value in username and password controller variable **/
        SiteLoginController controller = new SiteLoginController();
        
        /** Setting the username from the AP_01 utility class **/
        controller.username = AP01_TestDataTokens.SITE_LOGIN_USER_NAME;
        
        /** Setting the value in password from AP_01 utlity class **/
        controller.password = AP01_TestDataTokens.SITE_LOGIN_PASSWORD; 
        
        /** Using the object of the controller we instantiated above, we call the Login() method **/
        controller.login();
        
        Test.stopTest();
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: null
        Actual Result: null 
        ***********************************************************************/
        system.assertEquals(controller.login(),null);
                                      
    }   
    
}