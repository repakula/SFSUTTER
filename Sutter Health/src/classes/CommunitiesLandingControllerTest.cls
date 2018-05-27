/**
*    Class Name: CommunitiesLandingControllerTest
*    Author: Rahul
*    Date: 24-December-2013
*    Description:  An apex page controller that takes the user to the right start page based on credentials or lack thereof
*    History
*    --------
**/

 /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method tests the forwardTocustomStartPage,forwardTocustomAuthPage Method. .
    * @param 
    * @return 
    */
@IsTest public with sharing class CommunitiesLandingControllerTest {
    @IsTest(SeeAllData=true) public static void testCommunitiesLandingController() {
        /* Instantiate a new controller with all parameters in the page*/
        CommunitiesLandingController controller = new CommunitiesLandingController();       
        /*Covering the forwardTocustomStartPage Method.*/
        System.assertEquals(controller.forwardTocustomStartPage().getURL(),AP01_TestDataTokens.START_URL);
        controller.forwardToStartPage();
      }
}