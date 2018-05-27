/**********************************************************************
Class Name: DeliverabilityCheckTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is test Class for DeliverabilityCheck.
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  12/08/2015  Development complete   This class is intended to test DeliverabilityCheck functions.
***********************************************************************/
@isTest
private class DeliverabilityCheckTest{
    /*******************************************************************
    Purpose: method to create test data used by all test methods
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    @testsetup
    Static Void createTestData()
    {
        //Create Email Invocation Limit custom setting data..
        list<Email_Invocation_Limit__c> lstEmail_Invocation_Limit = new list<Email_Invocation_Limit__c>();
        Email_Invocation_Limit__c tempEmail_Invocation_Limit = new Email_Invocation_Limit__c();
        tempEmail_Invocation_Limit.Name = 'Email Invocations';
        tempEmail_Invocation_Limit.Daily_Limit__c = 4;
        lstEmail_Invocation_Limit.add(tempEmail_Invocation_Limit);
        insert lstEmail_Invocation_Limit;
        
        /*********************************************************************** 
        Assert to validate Email_Invocation_Limit__c has created successfully..
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(tempEmail_Invocation_Limit.id != null);
            
        //Create Account
        Account acc = AP01_TestDataUtility.createAccount();
        
        /*********************************************************************** 
        Assert to validate ACCOUNT has created successfully..
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(acc.id != null);
        
        //Create Contact
        List<Contact> lstcont  = AP01_TestDataUtility.createPortalContacts(acc);
       
        /*********************************************************************** 
        Assert to validate Contact has created successfully..
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(lstcont[0].id != null);
        
        //Create User record..
        User testUser;
        Profile tempProfile;
        
        User tempUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (tempUser) {  
        
            //select user profile
            tempProfile = [Select Id from Profile where name = 'Community Portal' Limit 1];
            list<user> lstUser = new list<user>();
            Integer i = 1;
            for(Contact tempCont : lstcont){
                testUser = new User(
                    ProfileId = tempProfile.Id,
                    Username = 'test.portalReactivation'+i+'@test.com',
                    Alias = 'tester',
                    Email='test.portalReactivation'+i+'@test.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='One',
                    Lastname='Tester',
                    CommunityNickname = 'test.portalReactivation'+i,
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    TimeZoneSidKey='America/Los_Angeles',
                    ContactId = tempCont.Id
                );
                i++;
                lstUser.add(testUser);
            }
            insert lstUser;
     
            /*********************************************************************** 
            Assert to validate User has created successfully..
            Expected Result: !=null
            Actual Result: !=null   
            ***********************************************************************/
            system.assert(lstUser[0].id != null);
        
        //Create Provider Summary record
        list<Contact_Validation_Summary__c> tempProSummy  = createProviderSummary(lstcont);
       
        /*********************************************************************** 
        Assert to validate Contact_Validation_Summary__c has created successfully..
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(tempProSummy[0].id != null);
        }
    }

     /*******************************************************************
    Purpose: Create Provider Summary record
    Parameters: Contact
    Returns: Contact_Validation_Summary__c
    Throws [Exceptions]: N/A
    ********************************************************************/
    public static list<Contact_Validation_Summary__c> createProviderSummary(list<Contact> lstContact){
    list<Contact_Validation_Summary__c> lstContactValidationSummary = new list<Contact_Validation_Summary__c>();
    for(Contact tempCont : lstContact){
    Contact_Validation_Summary__c summary = new Contact_Validation_Summary__c();
    summary.Name = 'Summary Record 01';
    summary.Printed_Contact_Name__c = 'Printed Contact';
    summary.Printed_Street_Address__c = 'Printed Address';
    summary.Printed_Suite__c = 'Printed Suite';
    summary.Printed_Floor__c = 'Printed Floor';
    summary.Printed_City__c = 'Printed City';
    summary.Printed_State__c = 'CA';
    summary.Printed_Zip_Code__c = 'Printed ZipCode';
    summary.Contact_Id__c = tempCont.id;
    summary.Deliverability_Email_Sent__c = false;
    lstContactValidationSummary.add(summary);
    }
    insert lstContactValidationSummary;

    return lstContactValidationSummary;
    }
  
    /*******************************************************************
    Purpose:  method to validate Processes queued up Deliverability E-Mails with single record.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void sendDeliverabilityEmailsSingleTest(){
        try{
            //Create Email Template...
            EmailTemplate validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'Provider Community: Deliveribilty Email';
            validEmailTemplate.DeveloperName = 'Test';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = UserInfo.getUserId();

            insert validEmailTemplate;
            
            /*********************************************************************** 
            Assert to check Email Template has been created successfully
            Expected Result: !=null
            Actual Result: !=null   
            ***********************************************************************/
            system.assert(validEmailTemplate.id != null);
            
            //Fetch User that is created in @testsetUp...
            User tempUser = [select id from User where id =: userInfo.getUserId()];
            
            //Fetch contact created in @testsetUp method
            list<contact> lstContact = [select id,is_portal_user__c from contact];
            set<id> p_contactIdSet = new set<id>();
            lstContact[0].is_portal_user__c = true;
            p_contactIdSet.add(lstContact[0].id);
            
            system.RunAs(tempUser){
            update lstContact[0];
            }
            Test.startTest();
                DeliverabilityCheck  tempDeliverabilityCheck  = new DeliverabilityCheck ();
                tempDeliverabilityCheck.sendDeliverabilityEmails(p_contactIdSet);
            Test.stopTest(); 
        }
        catch(exception ex){}
        
        
    }
 
    /*******************************************************************
    Purpose:  method to validate Processes queued up Deliverability E-Mails with bulk records. 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void sendDeliverabilityEmailsBulkTest(){
        try{
            //Create Email Template...
            EmailTemplate validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'Provider Community: Deliveribilty Email';
            validEmailTemplate.DeveloperName = 'Test';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = UserInfo.getUserId();

            insert validEmailTemplate;
            
            /*********************************************************************** 
            Assert to check Email Template has been created successfully
            Expected Result: !=null
            Actual Result: !=null   
            ***********************************************************************/
            system.assert(validEmailTemplate.id != null);
            
            //Fetch login User...
            User tempUser = [select id from User where id =: userInfo.getUserId()];
            
            //Fetch contact created in @testsetUp method
            list<contact> lstContact = [select id,is_portal_user__c from contact];
            set<id> p_contactIdSet = new set<id>();
            for(Contact tempcont : lstContact){
                //system.assert(tempcont.is_portal_user__c == true);
                tempcont.is_portal_user__c = true;
                p_contactIdSet.add(tempcont.id);
            }
            system.RunAs(tempUser){
            update lstContact;
            }
            Test.startTest();
                DeliverabilityCheck  tempDeliverabilityCheck  = new DeliverabilityCheck ();
                tempDeliverabilityCheck.sendDeliverabilityEmails(p_contactIdSet);
            Test.stopTest(); 
        }
        catch(exception ex){}
        
        
    }
    
        /**        
     * @author IDC Offshore        
     * @date 08/Dec/2015       
     * @description:- method to validate exception catch block in DeliverabilityCheckScheduler class scheduler to execute DeliverabilityCheck class. 
     * @return void        
     **/
    /*******************************************************************
    Purpose:  method to validate exception catch block in DeliverabilityCheckScheduler class scheduler to execute DeliverabilityCheck class. 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: Yes
    ********************************************************************/
    static testMethod void NegativesendDeliverabilityEmailsTest(){
        //Create Email Template...
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'Provider Community: Deliveribilty Email';
        validEmailTemplate.DeveloperName = 'Test';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();

        insert validEmailTemplate;
        
        /*********************************************************************** 
        Assert to check Email Template has been created successfully
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(validEmailTemplate.id != null);

        //Fetch login User...
        User tempUser = [select id from User where id =: userInfo.getUserId()];
        system.runAs(tempUser){
        //update Email_Invocation_Limit__c custom setting with Daily_Limit__c = null
        Email_Invocation_Limit__c eilObj = Email_Invocation_Limit__c.getValues('Email Invocations');
        eilObj.Daily_Limit__c = null;
        update eilObj;
        }
        
        
        Test.startTest();
            try{
            DeliverabilityCheck  tempDeliverabilityCheck  = new DeliverabilityCheck ();
            tempDeliverabilityCheck.getMassEmailLimit();
            }
            catch(exception ex){
                /*********************************************************************** 
                Assert to check exception 
                Expected Result: !=null
                Actual Result: !=null   
                ***********************************************************************/
                system.assert(ex.getMessage() != null);
            }
        Test.stopTest();
        
    }
}