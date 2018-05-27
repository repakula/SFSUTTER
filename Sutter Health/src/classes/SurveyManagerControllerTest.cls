/**  
*    Class Name: SurveyManagerControllerTest
*    Author: Saket
*    Date: 26-December-2013
*    Description:  Test class used for testing the SurveyManagerController Class
*    History
*    --------
**/
@IsTest
private class SurveyManagerControllerTest {
    /**        
    * @author IDC Team        
    * @date 10/Oct/2015       
    * @description: method to create test data used by all tests       
    * @return void        
    **/
    @testsetup
    Static Void createTestData()
    {
        Profile pp1;
        UserRole portalRole; 
        pp1 = [Select Id from Profile where name = 'SHP Agent' Limit 1];
        //Assert to check SHP Agent profile is available 
        system.assert(pp1.id != null);
        portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User testUser = new User(
            ProfileId = pp1.Id,
            Username = 'tester49_nky1@test.com',
            UserRoleId = portalRole.Id,
            Alias = 'tester1',
            Email='tester49_nky@test.com',
            EmailEncodingKey='UTF-8',
            Firstname='One',
            Lastname='Tester1',
            CommunityNickname = 'tester49_nky1',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Los_Angeles'
        );
        insert testUser;
        //Assert to check if User has been created successfully 
        system.assert(testUser.id != null);
    }

    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This Method tests login functionality of site login by SHP Agent
    *@param     
    *@return     
    */
    static testMethod void testSurveyManagerController() {
        User testuser = [select id from user where Username = 'tester49_nky1@test.com' limit 1];
        //Assert to check User has been fetched  successfully 
        system.assert(testUser.id != null);
        test.starttest();
        System.runAs(testuser){
            ApexPages.StandardController stdController;
            SurveyManagerController controller = new SurveyManagerController(stdController);
            controller.getEditCSS();
            //Assert to check editCSS = false if logged in user is SHP Agent  
            system.assert(controller.editCSS == false);
        } 
        test.stoptest();        
    }  
    /**   
    *@author IDC Team    
    *@date 01/01/2014    
    *@description This Method tests login functionality of site login by System Administrator 
    *@param     
    *@return     
    */  
    static testMethod void testSurveyManagerController2() { 
        test.starttest();
        ApexPages.StandardController stdController;
        SurveyManagerController controller = new SurveyManagerController(stdController);
        controller.getEditCSS();
        //Assert to check editCSS = true if logged in user is System Administrator
        system.assert(controller.editCSS == true);
        test.stoptest();        
    } 
}