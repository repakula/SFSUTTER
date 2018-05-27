/**********************************************************************
Name: CommunitiesLoginControllerTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is the test class for CommunitiesLoginController.
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  10/16/2013  Development complete   This class is intended to test CommunitiesLoginController functions.
***********************************************************************/

@IsTest 
 global class CommunitiesLoginControllerTest {
 
 /*******************************************************************
  Purpose: This method tests the forwardToCustomAuthPage() method and forwardToAuthPage() method as well without setting any values in parameters.Redirection to the Auth page,both custom and the standard redirect should be successful
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/
 
    static testmethod void testCommunitiesLoginController_NoParameters_Negative() {
                
        /** Setting the current page reference to CommunitiesLogin page **/
        PageReference pageRef = Page.CommunitiesLogin;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
                
        /** Instantiating the controller class **/
        CommunitiesLoginController controller = new CommunitiesLoginController();
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: null
        Actual Result: null 
        ***********************************************************************/
        System.assertEquals(controller.forwardToAuthPage(),null);  
                        
        /** Invoking the forwardToCustomAuthPage() method which in turn redirects to the specified PageReference  **/
        controller.forwardToCustomAuthPage();     
        
        Test.stopTest();
    }    
 
 /*******************************************************************
  Purpose: This method tests the forwardToCustomAuthPage() method and forwardToAuthPage() method as well without setting any values in parameters.Redirection to the Auth page,both custom and the standard redirect should be successful
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/

    static testmethod void testCommunitiesLoginController_AllParameters() {
        
        String strStartURL = 'http://www.testurl.com';
        
        /** Setting the current page reference to CommunitiesLogin page **/
        PageReference pageRef = Page.CommunitiesLogin;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('startURL', strStartURL);
        ApexPages.currentPage().getParameters().put('display', 'test');
        
        Test.startTest();
        
        /** Instantiating the controller class **/
        CommunitiesLoginController controller = new CommunitiesLoginController();
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assertEquals() 
        Expected Result: null
        Actual Result: null 
        ***********************************************************************/
        System.assertEquals(controller.forwardToAuthPage(),null); 
                        
        /** Invoking the forwardToCustomAuthPage() method which in turn redirects to the specified PageReference  **/
        controller.forwardToCustomAuthPage();     
        
        Test.stopTest();
    }    
}