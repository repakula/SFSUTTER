/**********************************************************************
Name: SiteRegisterControllerTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is the test class for SiteRegisterController.
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  9/27/2013  Development complete   This class is intended to test SiteRegisterController functions.
***********************************************************************/

   @IsTest 
  
   public with sharing class SiteRegisterControllerTest {

    /*******************************************************************
    Purpose: This Method tests the Register User method of SiteRegisterController class.Registration is to be done successfully by mentioning same value in Password and Confirm Password variable.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/

    static testmethod void testRegistration() {       
         
         Test.startTest();
         
          /** Setting the current PageReference to SiteRegister page **/
         Test.setCurrentPageReference(new PageReference('Page.SiteRegister'));
         
         /** Instantiating the controller class and then populating the value in username and other controller variables **/
         SiteRegisterController controller = new SiteRegisterController();
         
         /** Setting the username from AP_01 utility class **/
         controller.username = AP01_TestDataTokens.EMAIL;
         
         /** Setting the email from AP_01 utility class **/
         controller.email = AP01_TestDataTokens.EMAIL;
         
         /** Setting the CommunityNickName from AP_01 utility class **/
         controller.communityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME;
                             
        /** Setting the value in Password variable **/
        controller.password = 'test';
        
        /** Setting the value in confirmPassword variable **/
        controller.confirmPassword = 'test';
         
        /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: null
        Actual Result: null 
        ***********************************************************************/
        system.assertEquals(controller.registerUser(),null);
                
        Test.stopTest();
    }
  
   /*******************************************************************
    Purpose: This Method tests the Register User method of SiteRegisterController class.Registration is to be done unsuccessfully by mentioning different values in Password and confirmPassword variable.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/

    static testmethod void testRegistration_Negative() {       
         
         Test.startTest();
         
         /** Setting the current PageReference to SiteRegister page **/
         Test.setCurrentPageReference(new PageReference('Page.SiteRegister'));
         
         /** Instantiating the controller class and then populating the value in username and other controller variables **/
         SiteRegisterController controller = new SiteRegisterController();
         
         /** Setting the username from AP_01 utility class **/
         controller.username = AP01_TestDataTokens.EMAIL;
         
         /** Setting the Email from AP_01 utility class **/
         controller.email = AP01_TestDataTokens.EMAIL;
         
         /** Setting the CommunityNickName from AP_01 utility class **/
         controller.communityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME;
             
         /** Setting the value in Password variable from AP_01 utility class **/
         controller.password = AP01_TestDataTokens.PASSWORD;
         
         /** Setting the value in confirmPassword variable from AP_01 utility class **/      
         controller.confirmPassword = AP01_TestDataTokens.CONFIRM_PASSWORD;
         
         /*********************************************************************** 
          Verifying the value returning from the method using system.assertEquals() 
          Expected Result: null
          Actual Result: null   
         ***********************************************************************/
         system.assertEquals(controller.registerUser(),null);
              
         Test.stopTest();     
    }   
    
}