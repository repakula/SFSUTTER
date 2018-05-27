/**  
*    Class Name: ForgotPasswordControllerTest
*    Author: Rahul
*    Date: 23-December-2013
*    Description: Test Class for ForgotPasswordController. This class tests different scenarios that are handled in the code
*    History
*    --------
**/
@IsTest 
public with sharing class ForgotPasswordControllerTest {
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This method tests the ForgotPassword Method.
    *@param     
    *@return     
    */
    @IsTest 
    public static void testForgotPasswordController() {
        Profile tempProfile = [select id,Name from Profile where Name = 'Guest License User'];
        //Create Guest User
        User testuser = new User(Alias = 'standt', Email='standarduser@testmethod.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = tempProfile.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testmethod.com');
        insert testuser;
        
        //Assert to check if User has been created successfully 
        system.assert(testuser.id != null);
        
        //Instantiate a new controller with all parameters in the page//
        ForgotPasswordController controller = new ForgotPasswordController();     
        //controller.username = AP01_TestDataTokens.USER_NAME;
        controller.username = testuser.UserName;
        system.assertEquals(controller.forgotPassword(),NULL);
        
    }
}