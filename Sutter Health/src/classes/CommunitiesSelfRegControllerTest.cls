/**********************************************************************
 Name: CommunitiesSelfRegControllerTest
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for CommunitiesSelfRegController which is an apex page controller that supports self registration of users in communities that allow self registration
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  10/16/2013  Development complete   This class is defined to test CommunitiesSelfRegController class.
 2.0      IDC Offshore  12/17/2015  Class Optimisation   Incorporated changes to implement best test practices
 ***********************************************************************/

 @IsTest 
 public with sharing class CommunitiesSelfRegControllerTest {
    
    /*******************************************************************
     Purpose: method to test CommunitiesSelfRegController positively by keeping password and confirmPassword same.
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testmethod void testCommunitiesSelfRegController_Positive() {
        
     Test.startTest();
     
     CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
     controller.firstName = 'FirstName';
     controller.lastName = 'LastName';
     controller.email = 'test@force.com';
     controller.communityNickname = 'test';
        
     // registerUser will always return null when the page isn't accessed as a guest user
     
     /*********************************************************************** 
      Verifying the value returned from method using system.assert() 
      Expected Result: null is returned from the method
      Actual Result: null is returned from the method  
     **********************************************************************/
     System.assert(controller.registerUser() == null);    
        
     controller.password = 'abcd1234';
     controller.confirmPassword = 'abcd1234';
     
     Test.stopTest();
     
     /*********************************************************************** 
      Verifying the value returned from method using system.assert() 
      Expected Result: null is returned from the method
      Actual Result: null is returned from the method  
     **********************************************************************/
     System.assert(controller.registerUser() == null);  
    
    }    
    
    /*******************************************************************
     Purpose: Purpose: method to test CommunitiesSelfRegController negatively by keeping password and confirmPassword different.
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testmethod void testCommunitiesSelfRegController_Negative() {
        
     Test.startTest();
     
     CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
     controller.firstName = 'FirstName';
     controller.lastName = 'LastName';
     controller.email = 'test@force.com';
     controller.communityNickname = 'test';
        
     // registerUser will always return null when the page isn't accessed as a guest user
     
     /*********************************************************************** 
      Verifying the value returned from method using system.assert() 
      Expected Result: null is returned from the method
      Actual Result: null is returned from the method  
     **********************************************************************/
     System.assert(controller.registerUser() == null);    
        
     controller.password = 'abcd1234';
     controller.confirmPassword = 'abcd123';
     
     Test.stopTest();
     
     /*********************************************************************** 
      Verifying the value returned from method using system.assert() 
      Expected Result: null is returned from the method
      Actual Result: null is returned from the method  
     **********************************************************************/
     System.assert(controller.registerUser() == null);  
    
    }    
}