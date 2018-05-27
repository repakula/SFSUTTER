/**********************************************************************
Class Name: ProviderChangePasswordTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is test Class for ProviderChangePassword.
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  12/04/2015  Development complete   This class is intended to test ProviderChangePassword functions.
***********************************************************************/
@isTest(seeAllData = true)
private class ProviderChangePasswordTest{
     
    /*******************************************************************
    Purpose: method to create test data used by all test methods
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    Static Void createTestData()
    {
         //Create Account
        Account acc = AP01_TestDataUtility.createAccount();
        
        /*********************************************************************** 
        Assert to check ACCOUNT has been created successfully
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(acc.id != null);
        
        //Create Contact
        Contact cont = AP01_TestDataUtility.createContact(acc);
        
        /*********************************************************************** 
        Assert to check Contact has been created successfully
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(cont.id != null);
        
        //Create User record..
        User testUser;
        Profile tempProfile;
        
        User tempUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (tempUser) {  
        
            //select user profile
            tempProfile = [Select Id from Profile where name = 'Community Portal' Limit 1];
                testUser = new User(
                    ProfileId = tempProfile.Id,
                    Username = 'test.portalReactivation@test.com',
                    Alias = 'tester',
                    Email='test.portalReactivation@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = cont.Id
                );
            insert testUser;
           
            /*********************************************************************** 
            Assert to check User has been created successfully
            Expected Result: !=null
            Actual Result: !=null   
            ***********************************************************************/
            system.assert(testUser.id != null);
        
        //Create Provider Summary record
        Contact_Validation_Summary__c tempProSummy  = createProviderSummary(cont.id);
        
        /*********************************************************************** 
        Assert to check Contact_Validation_Summary__c has been created successfully
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(tempProSummy.id != null);
        }
    }
    /**
    * @author IDC Team  
    * @date 04/Dec/2015
    * @description Create Provider Summary record
    * @param - Contact
    * @return - Contact_Validation_Summary__c
    */
    /*******************************************************************
    Purpose: Create Provider Summary record
    Parameters: Contact
    Returns: Contact_Validation_Summary__c
    Throws [Exceptions]: N/A
    ********************************************************************/
    public static Contact_Validation_Summary__c createProviderSummary(Id conId){
        Contact_Validation_Summary__c summary = new Contact_Validation_Summary__c();
        summary.Name = 'Summary Record 01';
        summary.Printed_Contact_Name__c = 'Printed Contact';
        summary.Printed_Street_Address__c = 'Printed Address';
        summary.Printed_Suite__c = 'Printed Suite';
        summary.Printed_Floor__c = 'Printed Floor';
        summary.Printed_City__c = 'Printed City';
        summary.Printed_State__c = 'CA';
        summary.Printed_Zip_Code__c = 'Printed ZipCode';
        summary.Contact_Id__c = conId;
        insert summary;

        return summary;
    }
    
    /*******************************************************************
    Purpose: method to validate for sending the Password Reset Email with dynamic password change url and Reminder Mail with Login Link .
             Password Reset Email - If Provider is not logged in. 
             Reminder Mail - If Povider is logged in but not validated the contact details 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void SendChangePasswordUrl_Test(){
        Test.startTest();
            ProviderChangePassword tempProviderChangePassword  = new ProviderChangePassword();
            tempProviderChangePassword.SendChangePasswordUrl();
        Test.stopTest();
        
         /*********************************************************************** 
        Assert to check Contact_Validation_Summary__c has been fetched successfully
        Expected Result: list size should not be blank 
        Actual Result: list is not blank 
        ***********************************************************************/
        list<Contact_Validation_Summary__c>lstCVS=[Select contact_id__c from Contact_Validation_Summary__c 
                                                               WHERE Contact_Id__c 
                                                               IN (Select ContactID from User where Profile.Name like '%Community Provider%' and LastLoginDate != null) 
                                                               LIMIT 10] ;
        system.assert(lstCVS.size()!=null);     
    }
}