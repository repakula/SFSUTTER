/**********************************************************************
 Name: ACN_Portal_Test
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for ACN_PortalEmployeeInquiries.
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  10/16/2013  Development complete   This class is defined to test ACN_PortalEmployeeInquiries class.
 2.0      IDC Offshore  12/17/2015  Class Optimsation   Incorporated changes to implement best test practices in the test class
 ***********************************************************************/

@isTest
public class ACN_Portal_Test {

  /*******************************************************************
  Purpose: method to create test data used by all tests 
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/
    
  @testSetup 
     
  static void createTestData() {
      
   Case caseItem;
   
   /** Fetching the current loggedin user's id **/
   User u=[Select Id from User where Id=:userinfo.getuserid()];
   
   /** Creating a Case from the Current User's context **/
   System.runAs(u){
   caseItem = new Case();
   caseItem.SearchDate__c = Date.today();                   
   insert caseItem;
   }      
  
  /*********************************************************************** 
   Verifying the value using system.assertNotEquals() 
   Expected Result: Case id is not null
   Actual Result: Case id is not null  
  ***********************************************************************/
  system.assertNotEquals(caseItem.id,null);
  
  }   


 /*******************************************************************
  Purpose: This Method tests the Flow for all the Portal Employees 
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/   
   
 static testMethod void Portal_Flow_Test(){
  
   Test.startTest();
   
  //Test converage for the myPage visualforce page
  PageReference pageRef = Page.Portal_Flow;
  Test.setCurrentPageReference(pageRef);
  
  // create an instance of the controller
  flowPagePOCExtension myPageCon = new flowPagePOCExtension();
  
  Test.stopTest();
  
  /*********************************************************************** 
   Verifying the value using system.assertNotEquals() 
   Expected Result: value returned from the method getSearchTag() is not null
   Actual Result: value returned from the method getSearchTag() is not null
  ***********************************************************************/
  system.assertNotEquals(myPageCon.getsearchTag(),null);
  
  } 

  /*******************************************************************
  Purpose: This Method tests the Interaction log created for the ACNPortalEmployee negatively by preventing reinitalisation of the controller
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/  
  
  
  static testMethod void Portal_Inquiries_Test_Negative(){
      
  Test.startTest();
  
  /** Test converage for the myPage visualforce page **/
  PageReference pageRef = Page.ACN_Employee_Customer_Inquiries;
  Test.setCurrentPageReference(pageRef);
  
  /**  create an instance of the controller **/
  ACN_PortalEmployeeInquiries myPageCon = new ACN_PortalEmployeeInquiries();
  
  /** try calling methods/properties of the controller in all possible scenarios **/
   myPageCon.getrecentIL();
   
  /** Code Added By Rahul Nasa to increase the Test coverage **/
  ApexPages.CurrentPage().getParameters().put('flowflag','Test');
  myPageCon.getflowFlagValue();
  myPageCon.setflowflag(false);
  
  Test.stopTest();
  
  /*********************************************************************** 
   Verifying the value using system.assertEquals() 
   Expected Result: getflowflag() value is false
   Actual Result: getflowflag() value is false
   ***********************************************************************/
  system.assertEquals(myPageCon.getflowflag(),false);
  
  myPageCon.setIsILShowing(false);
  
  /*********************************************************************** 
   Verifying the value using system.assertEquals() 
   Expected Result: getIsILShowing() value is false
   Actual Result: getIsILShowing() value is false
   ***********************************************************************/
  system.assertEquals( myPageCon.getIsILShowing(),false);
  
  Case objCase= myPageCon.getInquiryId();
  myPageCon.setRecentIL(objCase);  
   
  List <Case> lstCase=new List<Case>();
  lstCase = myPageCon.getDisplayList(); 
  myPageCon.isSoon(objCase);
    
  /*********************************************************************** 
   Verifying the value using system.assertEquals() 
   Expected Result: size of list is 1
   Actual Result: size of list is 1
  ***********************************************************************/
  system.assertEquals(lstCase.size(),1);
  
}

/*******************************************************************
  Purpose: This Method tests the Interaction log created for the ACNPortalEmployee positively by reinitalisation of the controller
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/  
  
  
  static testMethod void Portal_Inquiries_Test_Positive(){
      
  Test.startTest();
  
  /** Test converage for the myPage visualforce page **/
  PageReference pageRef = Page.ACN_Employee_Customer_Inquiries;
  Test.setCurrentPageReference(pageRef);
  
  /**  create an instance of the controller **/
  ACN_PortalEmployeeInquiries myPageCon = new ACN_PortalEmployeeInquiries();
  
  /** try calling methods/properties of the controller in all possible scenarios **/
   myPageCon.getrecentIL();
   
  /** Code Added By Rahul Nasa to increase the Test coverage **/
  ApexPages.CurrentPage().getParameters().put('flowflag','Test');
  myPageCon.getflowFlagValue();
  myPageCon.setflowflag(false);
  
  /*********************************************************************** 
   Verifying the value using system.assertEquals() 
   Expected Result: getflowflag() value is false
   Actual Result: getflowflag() value is false
   ***********************************************************************/
  system.assertEquals(myPageCon.getflowflag(),false);
  
  myPageCon.setIsILShowing(false);
  
  /*********************************************************************** 
   Verifying the value using system.assertEquals() 
   Expected Result: getIsILShowing() value is false
   Actual Result: getIsILShowing() value is false
   ***********************************************************************/
  system.assertEquals( myPageCon.getIsILShowing(),false);
  
  Case objCase= myPageCon.getInquiryId();
  myPageCon.setRecentIL(objCase);  
   
  List <Case> lstCase=new List<Case>();
  lstCase = myPageCon.getDisplayList(); 
  myPageCon.isSoon(objCase);
  
  /** Instantiating the controller to cover the scenario where we call isSoon() method **/
  ACN_PortalEmployeeInquiries objmyPageCon = new ACN_PortalEmployeeInquiries();
  
  /** Setting the value in userContactId variable **/
  objmyPageCon.userContactId='test';
  
  Test.stopTest();
  
  /*********************************************************************** 
   Verifying the value using system.assertEquals() 
   Expected Result: size of Case list is 1
   Actual Result: size of Case list is 1
  ***********************************************************************/
  system.assertEquals(lstCase.size(),1);
  
}


 /*******************************************************************
  Purpose: This Method test the Searched Articles for Portal Users and also the properties of SearchContent Controller 
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/  

 static testMethod void searchCtrlTest() {
     
  Test.startTest();
  
  //Test converage for the myPage visualforce page
  PageReference pageRef = Page.SearchArticlesPortal;
  Test.setCurrentPageReference(pageRef);
  
  // create an instance of the controller
  ACN_SearchContent_Controller myPageCon = new ACN_SearchContent_Controller();
   
  Test.stopTest();
  
  /*********************************************************************** 
   Verifying the value returning from the method using system.assertNotEquals() 
   Expected Result: value from getNewFlow() is not null
   Actual Result: value from getNewFlow() is not null 
   ***********************************************************************/
  system.assertNotEquals(myPageCon.getNewFlow(),null);            
}
}