/**********************************************************************
Name: AP01_TestDataTokensTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is the test class for AP01_TestDataTokens.
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  1/12/2015  Development complete   This class is intended to test AP01_TestDataTokens.
***********************************************************************/

  @IsTest
  
  private class AP01_TestDataTokensTest {
  
  /*******************************************************************
  Purpose: This Method covers all the static variables declared in AP01_TestDataTokens class
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/
   static testMethod void testSiteLoginController () {
        
    Test.startTest();
        
    AP01_TestDataTokens objTokenClass = new AP01_TestDataTokens();
    
     /*********************************************************************** 
        Verifying the AP01_TestDataTokens class variables values 
        Expected Result: AP01_TestDataTokens class variables should have values 
        Actual Result: AP01_TestDataTokens class variables should have values
       ************************************************************************/
       system.assert(AP01_TestDataTokens.COMMUNITY_PORTAL_PROFILE == 'Community Portal');
       system.assert(AP01_TestDataTokens.COMMUNITY_PORTAL_MANAGER_PROFILE == 'Community Portal Manager');
    Test.stopTest();
    } 
    
  }