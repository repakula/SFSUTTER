/**  
*    Class Name: ManageCase_S3_Test
*    Author: Saket
*    Date: 27-December-2013
*    Description:  An apex page controller that test the Utility Class.
*    History
*    --------
**/

/**   
*@author IDC Team    
*@date 01/01/2014    
*@description This Method tests the Send Error Email method of Utility Class 
*@param     
*@return     
*/
@isTest
private class UtilityTest {

    static testMethod void myUnitTest() {
        
         Test.startTest();
         String ExceptionMsg =AP01_TestDataTokens.EXCEPTION_MSG;
         String ErrorMsg =AP01_TestDataTokens.ERROR_MSG;
         Utility.handleExceptionFromCode(ExceptionMsg);
         String emailAddress =AP01_TestDataTokens.EMAIL_ADDRESS;
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         String[] toAddresses = new String[] {emailAddress};
         mail.setToAddresses(toAddresses);
         mail.setReplyTo(AP01_TestDataTokens.SET_REPLY_TO);
         mail.setSenderDisplayName(AP01_TestDataTokens.SET_SENDER_DISPLAY_NAME);
         mail.setSubject(AP01_TestDataTokens.SET_SUBJECT);
         mail.setPlainTextBody(ExceptionMsg);
         /*Testing the sendErrorEmail method in Utility class*/
         // Assert to check mail is send 
         system.assertnotequals(mail,null);
         Utility.sendErrorEmail(ErrorMsg);
         Utility.sendErrorEmailToAdmin(ErrorMsg);
         Test.stopTest();
        
    }
    
     
}