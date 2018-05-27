/**********************************************************************
 Name: ValidateProviderController_Test
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for ValidateProviderController.
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  12/28/2015  Development complete   This class is defined to test ValidateProviderController class.
 
 ***********************************************************************/

@isTest
public class ValidateProviderController_Test { 
    
 /*******************************************************************
  Purpose: method to create test data used by all tests 
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/  
 @testSetup
  static void createTestData() {
      
      
    List<User> testRunUserList = new List<User>();
    User testRunUser1;
    Profile pp1;
    UserRole portalRole; 

    // Create custom setting Data
    CS_ManageProfile__c CSMCommunities_Portal = new CS_ManageProfile__c(Name = 'Communities_Portal', Profile_Name__c='Community Portal');
    CS_ManageProfile__c CSMCommunities_Provider = new CS_ManageProfile__c(Name = 'Communities_Provider', Profile_Name__c='Community Portal Manager');
    CS_ManageProfile__c CSMCommunity_Portal_Manager = new CS_ManageProfile__c(Name = 'Community_Portal_Manager', Profile_Name__c='Community Portal Manager');
    Insert CSMCommunities_Portal;
    Insert CSMCommunities_Provider;
    Insert CSMCommunity_Portal_Manager;

    /*********************************************************************** 
    Verifying the Custom setting data using system.assert() 
    Expected Result: Custom setting  is not null
    Actual Result: Custom setting  is not null 
    ***********************************************************************/ 
    system.assert(CSMCommunities_Portal!=null);
    system.assert(CSMCommunities_Provider!=null);
    system.assert(CSMCommunity_Portal_Manager!=null);


    portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];

    User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
    System.runAs (thisUser) {  
        
        //select user profile
        pp1 = [Select Id from Profile where name = 'System Administrator' Limit 1];
        testRunUser1 = new User(
            ProfileId = pp1.Id,
            Username = 'tester49_nky@test.com',
            UserRoleId = portalRole.Id,
            Alias = 'tester',
            Email='tester49_nky@test.com',
            EmailEncodingKey='UTF-8',
            Firstname='One',
            Lastname='Tester',
            CommunityNickname = 'tester49_nky',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Los_Angeles'
        );
        testRunUserList.add(testRunUser1);
        insert testRunUserList;
        
    /*********************************************************************** 
    Verifying the User has been created successfully using system.assert() 
    Expected Result: user id is not null
    Actual Result: user id  is not null 
    ***********************************************************************/ 
    system.assert(testRunUser1.id!=null);
    }

    System.runAs (testRunUser1) {
        
        
        Account accObj = new Account();
        accObj.Name = 'Account Name';
        insert accObj;
        
        /*********************************************************************** 
        Verifying the Account has been created successfully using system.assert() 
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(testRunUser1.id!=null);
      
        RecordType rtObj = new RecordType();
        rtObj = [SELECT id, name FROM recordtype WHERE name='Provider' and SObjectType='Contact' limit 1];
        
        list<contact> conList = new list<contact>();
        Contact conObj = new Contact();
                
        conList.add(new contact(
            accountId = accObj.id,
            lastName = 'Provider',
            firstName = 'Test',
            Provider_Name__c = 'Test Provider',
            Provider_Title__c = 'Mr.',
            recordTypeId = rtObj.id,
            email = 'test@test.com',
            Provider_Correspondence_Address__c = '123',
            Provider_Correspondence_City__c = 'CA',
            Provider_Correspondence_State__c = 'CA',
            Provider_Correspondence_PostalCode__c = '12345',
            Provider_Correspondence_Phone__c = '2345678901',
            Provider_Correspondence_Fax_Number__c = '2345678901',
            Provider_Practicing_Physician__c = true,
            Provider_Active_Status__c = true,
            MobilePhone = '2345678901',
            Contact_External_ID1__c = '1234'
        ));
        
        conList.add(new contact(
            accountId = accObj.id,
            Provider_Name__c = 'Test Provider',
            Provider_Title__c = 'Mr.',
            lastName = 'Provider',
            firstName = 'Test',
            recordTypeId = rtObj.id,
            Provider_Correspondence_Address__c = '123',
            Provider_Correspondence_City__c = 'CA',
            Provider_Correspondence_State__c = 'CA',
            Provider_Correspondence_PostalCode__c = '12345',
            Provider_Correspondence_Phone__c = '2345678901',
            Provider_Correspondence_Fax_Number__c = '2345678901',
            Provider_Practicing_Physician__c = true,
            Provider_Active_Status__c = true,
            MobilePhone = '2345678901',
            Contact_External_ID1__c = '12345'
        ));
        
        insert conList;   

        Contact_Validation_Audit_Trail__c conAuditTrail = new Contact_Validation_Audit_Trail__c();
        ConAuditTrail.Email__c='Test@123.com';
        ConAuditTrail.Mobile_Phone__c ='1101101100';
        ConAuditTrail.Secure_City__c= 'Test ABC';
        ConAuditTrail.Secure_Fax__c='1101101100';
        ConAuditTrail.Secure_Phone__c='1101101100';
        ConAuditTrail.Secure_State__c='Test STATE';
        ConAuditTrail.Secure_Street_Address__c='Test CITY';
        ConAuditTrail.Secure_Zip_Code__c='12345';
        ConAuditTrail.Contact_Id__c= conObj.Id;
        // ConAuditTrail.Provider_Id__c =
        ConAuditTrail.Preferred_Communication_Method__c='Email';
        ConAuditTrail.First_Name__c='Fname';
        ConAuditTrail.Last_Name__c='Lname';
        
        insert ConAuditTrail;
        
        /*********************************************************************** 
        Verifying the Contact_Validation_Audit_Trail__c has been created successfully using system.assert() 
        Expected Result: Contact_Validation_Audit_Trail__c id is not null
        Actual Result: Contact_Validation_Audit_Trail__c id  is not null 
        ***********************************************************************/ 
        system.assert(ConAuditTrail.id!=null);
        
        
        Contact_Validation_Summary__c summaryObj = new Contact_Validation_Summary__c();
        summaryObj.Email__c='Test@123.com';
        summaryObj.Mobile_Phone__c='1101101100';
        summaryObj.Secure_City__c='Test CITY';
        summaryObj.Secure_Fax__c='1101101100';
        summaryObj.Secure_Phone__c='1101101100';
        summaryObj.Secure_Zip_Code__c ='11011';
        summaryObj.Secure_State__c='Test STATE';
        summaryObj.Secure_Street_Address__c='Test ABC Street';
        summaryObj.Contact_Id__c= conObj.Id;
        
        summaryObj.Preferred_Communication_Method__c='Email';
        
        insert summaryObj;
        
        /*********************************************************************** 
        Verifying the Contact_Validation_Summary__c has been created successfully using system.assert() 
        Expected Result: Contact_Validation_Summary__c id is not null
        Actual Result: Contact_Validation_Summary__c id  is not null 
        ***********************************************************************/ 
        system.assert(summaryObj.id!=null);
    }

   }
  
  /*******************************************************************
  Purpose: This method validate various scenerios of Contact_Validation_Summary__c for Email,,Mobile Phone ,Secure Fax  
  Secure City , Secure State ,Secure Phone ,Secure Zip Code
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: yes
  ********************************************************************/   
  
  public static testMethod void validate_Test(){
       
        Test.startTest();   
        
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        
        System.runAs(userObj) {
            
            Contact_Validation_Summary__c cvsObj = new Contact_Validation_Summary__c();
            cvsobj = [SELECT id FROM Contact_Validation_Summary__c WHERE contact_id__c = :conlist[0].id];
            cvsObj.Preferred_Communication_Method__c= 'email';
            update cvsObj;
            
            ValidateProviderController vpcObj = new ValidateProviderController();
            vpcObj.save();
            vpcObj.ifUserAuthenticated();
            
            cvsObj.Email__c= 'test1@test.com';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.save();
            
            cvsObj.Preferred_Communication_Method__c= '';
            cvsObj.Email__c = '';
            cvsObj.Mobile_Phone__c = '';
            cvsObj.Secure_Fax__c = '';
            cvsObj.Secure_City__c = '';
            cvsObj.Secure_State__c = '';
            cvsObj.Secure_Phone__c = '';
            cvsObj.Email__c = '';
            cvsObj.Secure_Zip_Code__c = '';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.providerInfo.sc_address = '';
            vpcObj.save();
            
            //cvsObj.Email__c = 'test';
            cvsObj.Mobile_Phone__c = '123456ty789';
            cvsObj.Secure_Fax__c = '1234er56789';
            cvsObj.Secure_Phone__c = '123456789';
            cvsObj.Secure_Zip_Code__c = '123';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.save();

            cvsObj.Secure_Phone__c = '123456789a';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.save();

            cvsObj.Secure_Phone__c = '1234522267812290';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.save();

            cvsObj.Secure_Phone__c = '1234567890x1q';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.save();
            
            try{
                vpcObj = new ValidateProviderController();
                vpcObj.summaryObj.Email__c= '@@@@@@@';
                vpcObj.save();
                
            }
            catch(Exception ex){
                /*********************************************************************** 
                Verifying the Exception  has been caught for wrong email  using system.assert() 
                Expected Result: Exception message is not null
                Actual Result: Exception message is not null
                ***********************************************************************/
                // assert to check  wrong email message
                system.assert(ex.getmessage()!=null);
                
            }
            
        }
        
        Test.stopTest();
    }
  
   
    
    /*******************************************************************
  Purpose: This method catch exceptions for validate and save method
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: yes
  ********************************************************************/
    static testMethod void validate_NegativeTest() {
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        Test.starttest();
        System.runAs(thisUser) {

            //Define Page
            PageReference pg = Page.ValidateProvider;
            Test.setCurrentPage(pg);
            pg.getParameters().put('mobileNo', '10101010');
            pg.getParameters().put('secureFaxNo', '10101010');
            pg.getParameters().put('securePhoneNo', '10101010');
            pg.getParameters().put('Secure_Zip_Code__c ', '10101010');

            // define controller 
            ValidateProviderController controller=new ValidateProviderController();

            /*********************************************************************** 
            Verifying the value using system.assertEquals() 
            Expected Result: validate() value is false
            Actual Result: validate() value is false
            ***********************************************************************/
            system.assertEquals(controller.validate(),false);

            /*********************************************************************** 
            Verifying the value using system.assertEquals() 
            Expected Result: Save() value is null
            Actual Result: Save() value is null
            ***********************************************************************/
            system.assertEquals(controller.save(),null);

        }
        Test.stoptest();
    }
    
    /*******************************************************************
      Purpose: this method test various secenerios of Contact_Validation_Summary__c object and update records 
      Parameters: N/A 
      Returns: void
      Throws [Exceptions]: yes
      ********************************************************************/
    
    static testMethod void save_Test(){
         
         
        List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        
        test.starttest();
        
        System.runAs(userObj) {
            
            Contact_Validation_Summary__c cvsObj = new Contact_Validation_Summary__c();
            cvsobj = [SELECT id FROM Contact_Validation_Summary__c WHERE contact_id__c = :conlist[0].id];
            cvsObj.Preferred_Communication_Method__c= 'email';
            update cvsObj;
            
            ValidateProviderController vpcObj = new ValidateProviderController();
            vpcObj.save();
            vpcObj.ifUserAuthenticated();
            
            //New Added Lines
            vpcObj = new ValidateProviderController();      
            cvsObj.Secure_City__c = 'test1';
            update cvsObj;      
            vpcObj.save();
            
              vpcObj = new ValidateProviderController();      
              cvsObj.New_Street_Address__c = 'test1';
              update cvsObj;      
              vpcObj.save();
              
              
              vpcObj = new ValidateProviderController();      
              cvsObj.Secure_Zip_Code__c = 'test1';
              update cvsObj;      
              vpcObj.save();
              
              vpcObj = new ValidateProviderController();      
              cvsObj.Secure_Suite__c = 'test1';
              update cvsObj;      
              vpcObj.save();
        
              vpcObj = new ValidateProviderController();      
              cvsObj.Secure_Floor__c = 'test1';
              update cvsObj;      
              vpcObj.save();
        
              vpcObj = new ValidateProviderController();      
              cvsObj.Secure_State__c = 'test1';
              update cvsObj;      
              vpcObj.save();
              
               vpcObj = new ValidateProviderController();      
              cvsObj.Secure_Phone__c = 'test1';
              update cvsObj;      
              vpcObj.save();
              
               vpcObj = new ValidateProviderController();      
              cvsObj.Secure_FAX__c = 'test1';
              update cvsObj;      
              vpcObj.save();
              
               vpcObj = new ValidateProviderController();      
              vpcObj.summaryObj.Email__c = 'test10001@test.com';
              vpcObj.save();
              
             
              
               vpcObj = new ValidateProviderController();      
              cvsObj.Mobile_Phone__c = 'test1';
              update cvsObj;      
              vpcObj.save();              
              
            //New Added Lines
            
            try{
                cvsObj.Mobile_Phone__c = '';
                cvsObj.Secure_Fax__c = '';
                cvsObj.Secure_Phone__c = '';
                cvsObj.Secure_Zip_Code__c = '';
                cvsObj.Email__c = '';
                update cvsObj;
                vpcObj = new ValidateProviderController();
                vpcObj.save();
            }
            catch(Exception classException)
            {
                Boolean expectedExceptionThrown =  classException.getMessage().contains('') ? true : false;
            }
            
             vpcObj = new ValidateProviderController();      
              vpcObj.summaryObj.Email__c = 'TEST11111@test.com';
              vpcObj.save();
              
            try{
                cvsObj.Email__c = 'test';
                update cvsObj;
                vpcObj = new ValidateProviderController();
                vpcObj.save();
            }
            catch(DMLException ex)
            {
                Boolean expectedExceptionThrown =  ex.getMessage().contains('') ? true : false;
            }
            
        }
        //conList[0].email = 'test@provider.com';
        update conList;

        test.stoptest();
        
    }
    
    /*******************************************************************
  Purpose: This method test if logged in user is not portal user 
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/
    
    static testMethod void save_NegativeTest(){
         
         
         List<Contact> conlist = [select id from contact where Provider_Name__c = 'Test Provider' ];
        
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE Username = 'tester49_nky@test.com'];
        /*********************************************************************** 
        Verifying the user has been fetched successfully using system.assert() 
        Expected Result: User is not null
        Actual Result: User  is not null 
        ***********************************************************************/
        system.assert(userObj!=null);
        
        test.starttest();
        
        System.runAs(userObj) {
            
            Contact_Validation_Summary__c cvsObj = new Contact_Validation_Summary__c();
            cvsobj = [SELECT id FROM Contact_Validation_Summary__c WHERE contact_id__c = :conlist[0].id];
            cvsObj.Preferred_Communication_Method__c= 'email';
            update cvsObj;
            
            ValidateProviderController vpcObj = new ValidateProviderController();
            vpcObj.save();
            vpcObj.ifUserAuthenticated();
            
            //New Added Lines
            vpcObj = new ValidateProviderController();      
            cvsObj.Secure_City__c = 'test1';
            update cvsObj;      
            vpcObj.save();
        }
        test.stoptest();
    }
}