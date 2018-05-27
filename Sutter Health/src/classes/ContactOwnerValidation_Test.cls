/**  
*    Class Name: ContactOwnerValidation_Test
*    Author: Rahul
*    Date: 23-December-2013
*    Description:  An apex page controller that tests the Manage Contact Database Class.
*    History
*    --------
**/

@isTest
private class ContactOwnerValidation_Test{
    
         /**   
*@author IDC Team    
*@date 01/01/2014    
*@description This method Craete the users and then assign that user to Contact Owner.
*@param     
*@return     Void
*/
    @isTest static void testOwnerValidation() {
        
        List<Profile> p = [SELECT Id FROM Profile WHERE Name=:AP01_TestDataTokens.SHP_SALES_PROFILE_NAME limit 1];  
        //Assert to check Profile is fetched successfully
        system.assert(p!=null);
       
          User u = new User(Alias = AP01_TestDataTokens.ALIAS, Email=AP01_TestDataTokens.USER_EMAIL, 
          EmailEncodingKey=AP01_TestDataTokens.EMAIL_ENCODING_KEYS, LastName=AP01_TestDataTokens.LAST_NAME, LanguageLocaleKey=AP01_TestDataTokens.LANGUAGE_LOCALE_KEY, 
          LocaleSidKey=AP01_TestDataTokens.LOCALE_SID_KEY, ProfileId = p[0].Id, 
          TimeZoneSidKey=AP01_TestDataTokens.TIME_ZONES_ID_KEY, UserName=AP01_TestDataTokens.USER_NAME);
          
          User u1 = new User(Alias = AP01_TestDataTokens.ALIAS1, Email=AP01_TestDataTokens.EMAIL, 
          EmailEncodingKey=AP01_TestDataTokens.EMAIL_ENCODING_KEYS, LastName=AP01_TestDataTokens.LAST_NAME, LanguageLocaleKey=AP01_TestDataTokens.LANGUAGE_LOCALE_KEY, 
          LocaleSidKey=AP01_TestDataTokens.LOCALE_SID_KEY, ProfileId = p[0].Id, 
          TimeZoneSidKey=AP01_TestDataTokens.TIME_ZONES_ID_KEY, UserName=AP01_TestDataTokens.USER_NAME1);
          insert u1;
        //Assert to check user is creted successfully
            system.assert(u1.id!=null);
        
        Test.startTest(); 
        System.runAs(u){
            Account acc = AP01_TestDataUtility.createAccountOwnerValidation();
            Contact con = AP01_TestDataUtility.createContactOwnerValidation(acc);           
            con.OwnerId = u1.Id;
            update con;            
        }
        
        Test.stopTest();  
    }    
     
         /**   
*@author IDC Team    
*@date 01/01/2014    
*@description This method tests the contactOwnerValidation Method.
*@param     
*@return   Void  
*/
    @isTest static void testOwnerValidation_Neg() {
        
        List<Profile> p = [SELECT Id FROM Profile WHERE Name=:AP01_TestDataTokens.SHP_PROFILE_NAME limit 1]; 
       List<Profile> p1 = [SELECT Id FROM Profile WHERE Name=:AP01_TestDataTokens.SHP_SALES_PROFILE_NAME limit 1]; 
          User u = new User(Alias = AP01_TestDataTokens.ALIAS, Email=AP01_TestDataTokens.USER_EMAIL, 
          EmailEncodingKey=AP01_TestDataTokens.EMAIL_ENCODING_KEYS, LastName=AP01_TestDataTokens.LAST_NAME, LanguageLocaleKey=AP01_TestDataTokens.LANGUAGE_LOCALE_KEY, 
          LocaleSidKey=AP01_TestDataTokens.LOCALE_SID_KEY, ProfileId = p1[0].Id, 
          TimeZoneSidKey=AP01_TestDataTokens.TIME_ZONES_ID_KEY, UserName=AP01_TestDataTokens.USER_NAME);
          
          User u1 = new User(Alias = AP01_TestDataTokens.ALIAS1, Email=AP01_TestDataTokens.EMAIL, 
          EmailEncodingKey=AP01_TestDataTokens.EMAIL_ENCODING_KEYS, LastName=AP01_TestDataTokens.LAST_NAME, LanguageLocaleKey=AP01_TestDataTokens.LANGUAGE_LOCALE_KEY, 
          LocaleSidKey=AP01_TestDataTokens.LOCALE_SID_KEY, ProfileId = p[0].Id, 
          TimeZoneSidKey=AP01_TestDataTokens.TIME_ZONES_ID_KEY, UserName=AP01_TestDataTokens.USER_NAME1);
          insert u1;
          //Assert to check user is creted successfully
            system.assert(u1.id!=null);
        
        Test.startTest();
        System.runAs(u){
            Account acc1 = AP01_TestDataUtility.createAccountOwnerValidation();
            Contact con1 = AP01_TestDataUtility.createContactOwnerValidation(acc1);           
            con1.OwnerId = u1.Id;
            try{
            update con1;
            }catch(Exception e)
            {
             system.AssertEquals(true, e.getMessage().contains(AP01_TestDataTokens.CONTACT_OWNER_MESSAGE));
            }
        }
        Test.stopTest();
    }
}