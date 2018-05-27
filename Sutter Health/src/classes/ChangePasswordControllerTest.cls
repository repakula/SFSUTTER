/**  
*    Class Name: ChangePasswordControllerTest
*    Author: Rahul
*    Date: 20-November-2013
*    Description: Test Class for ChangePasswordController. This class tests different scenarios that are handled in the code
*    History
*    --------
**/
@IsTest public with sharing class ChangePasswordControllerTest {
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method tests the ChangePassword Method. .
    * @param 
    * @return 
    */
    @IsTest public static void testChangePasswordController() {
        // Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = AP01_TestDataTokens.OLD_PASSWORD;
        controller.newPassword = AP01_TestDataTokens.NEW_PASSWORD;
        controller.verifyNewPassword = AP01_TestDataTokens.NEW_PASSWORD;   
        //Calling the ChangePassword Method //                  
        System.assertEquals(controller.changePassword(),null);                           
    }    
}