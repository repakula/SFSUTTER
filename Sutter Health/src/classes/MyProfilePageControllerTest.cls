/**  
*    Class Name: MyProfilePageControllerTest
*    Author: Rahul
*    Date: 27-December-2013
*    Description:  An apex class that keeps updates of a portal user in sync with its corresponding contact.
   Guest users are never able to access this page.
*    History
*    --------
**/
@IsTest public with sharing class MyProfilePageControllerTest {
		/**
    *   @Description:  This method tests the Contact Fields like First Name and Last Name.
    *	@Arguments: 
    *   @Return: Void
    **/
    @IsTest(SeeAllData=true) static void testSetContactFields() {
        User u = [select title, firstname, lastname, email, phone, mobilephone, fax, street, city, state, postalcode, country
                           FROM User WHERE id =: UserInfo.getUserId()];

        Contact c = new Contact();

        MyProfilePageController.setContactFields(c, u);
        System.assertEquals(c.firstname, u.firstname, AP01_TestDataTokens.MY_PROFILE_PAGE_CONTROLLER_MESSGE1);
        System.assertEquals(c.lastname, u.lastname, AP01_TestDataTokens.MY_PROFILE_PAGE_CONTROLLER_MESSGE2);
    }
  
  
  	/**
    *   @Description:  Covering the Save Method
    *	@Arguments: trigger.OldMap and trigger.newMap for Case
    *   @Return: Void
    **/
    @IsTest(SeeAllData=true) static void testSave() {
        // Modify the test to query for a portal user that exists in your org
        List<User> existingPortalUsers = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType=:AP01_TestDataTokens.USER_TYPE];
        Contact c = new Contact();
        if (existingPortalUsers.isEmpty()) {
            User currentUser = [select id, title, firstname, lastname, email, phone, mobilephone, fax, street, city, state, postalcode, country
                                FROM User WHERE id =: UserInfo.getUserId()];
            MyProfilePageController controller = new MyProfilePageController();
            System.assertEquals(currentUser.Id, controller.getUser().Id, AP01_TestDataTokens.MY_PROFILE_PAGE_CONTROLLER_MESSGE3);
            System.assert(controller.getIsEdit() == false, AP01_TestDataTokens.MY_PROFILE_PAGE_CONTROLLER_MESSGE4);
            controller.edit();
            System.assert(controller.getIsEdit() == true);
            controller.cancel();
            System.assert(controller.getIsEdit() == false);
 
            //Contact c = new Contact();
            c.LastName = AP01_TestDataTokens.CONTACT_L_NAME; 
            insert c;

            c.title = currentUser.title;
            c.firstname = currentUser.firstname;
            c.lastname = currentUser.lastname;
            c.email = currentUser.email;
            c.phone = currentUser.phone;
            c.mobilephone = currentUser.mobilephone;
            c.fax = currentUser.fax;
            c.mailingstreet = currentUser.street;
            c.mailingcity = currentUser.city;
            c.mailingstate = currentUser.state;
            c.mailingpostalcode = currentUser.postalcode;
            c.mailingcountry = currentUser.country;
            controller.save();
            System.assert(Page.ChangePassword.getUrl().equals(controller.changePassword().getUrl()));
        } else {
            User existingPortalUser = existingPortalUsers[0];
            String randFax = Math.rint(Math.random() * 1000) + AP01_TestDataTokens.RAND_FAX;

            System.runAs(existingPortalUser) {
                MyProfilePageController controller = new MyProfilePageController();
                System.assertEquals(existingPortalUser.Id, controller.getUser().Id, AP01_TestDataTokens.MY_PROFILE_PAGE_CONTROLLER_MESSGE3);
                System.assert(controller.getIsEdit() == false, AP01_TestDataTokens.MY_PROFILE_PAGE_CONTROLLER_MESSGE4);
                controller.edit();
                System.assert(controller.getIsEdit() == true);

                controller.cancel();
                System.assert(controller.getIsEdit() == false);
                controller.getUser().contact=c;
                controller.getUser().Fax = randFax;
                controller.save();
                System.assert(controller.getIsEdit() == false);
            }

            // verify that the user and contact were updated
            existingPortalUser = [Select id, fax, Contact.Fax from User where id =: existingPortalUser.Id];
            System.assert(existingPortalUser.fax == randFax);
            System.assert(existingPortalUser.Contact.fax == randFax);
        }
    }
       
    	/**
    *   @Description:  Covering the Save Method in case when User.Contact is not equal to NULL
    *	@Arguments: trigger.OldMap and trigger.newMap for Case
    *   @Return: Void
    **/
   @IsTest(SeeAllData=true) static void testSave1() { 
    List<User> existingPortalUsers = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType=:AP01_TestDataTokens.USER_TYPE];
    User currentUser = [select id, title, firstname, lastname, email, phone, mobilephone, fax, street, city, state, postalcode, country
                                FROM User WHERE id =: UserInfo.getUserId()];
    Contact c = new Contact();
    c.LastName = AP01_TestDataTokens.CONTACT_L_NAME;
    c.title = currentUser.title;
    c.firstname = currentUser.firstname;
    c.lastname = currentUser.lastname;
    c.email = currentUser.email;
    c.phone = currentUser.phone;
    c.mobilephone = currentUser.mobilephone;
    c.fax = currentUser.fax;
    c.mailingstreet = currentUser.street;
    c.mailingcity = currentUser.city;
    c.mailingstate = currentUser.state;
    c.mailingpostalcode = currentUser.postalcode;
    c.mailingcountry = currentUser.country;
    upsert c;
    
    
    
    MyProfilePageController controller = new MyProfilePageController();
    controller.getUser().contact=c;    
    controller.save();
    system.assertEquals(controller.getUser().Id , UserInfo.getUserId());        
     
   }
}