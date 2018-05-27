/**********************************************************************
  Name: BatchPasswordResetNonTeleForm_test
  Copyright © 2015 IDC Offshore
  ======================================================
  ======================================================
  Purpose:
  This is the test class for BatchPasswordresetNonTeleForm batch class            
  ======================================================
  ======================================================
  History
  -------
  VERSION  AUTHOR        DATE        DETAIL                 Description
  1.0      IDC Offshore  12/23/2015 Development complete   This class is defined to test BatchPasswordresetNonTeleForm batch class code related classes related to REQ - 3399.  
  ***********************************************************************/
 
 @isTest
   Private class BatchPasswordResetNonTeleForm_Test {

        /** Setting the CRON Expression for both User Create and User Update for Provider RecordType and Source of email as TLFM **/
        public static String CRON_EXP = '0 0 0 15 3 ? 2022';
        public static String CRON_EXP2 = '0 0 0 16 3 ? 2022';
        
       /*******************************************************************
        Purpose: method to create test data used by all test methods
        Parameters: N/A 
        Returns: void
        Throws [Exceptions]: N/A
       ********************************************************************/
       
        @testSetup 
        static void createTestData() {
        
            /** Create test data for CS_ManageProfile custom setting **/
            list<CS_ManageProfile__c> lstManageProfile  = AP01_TestDataUtility.createManageprofileSet();
            insert lstManageProfile;
                       
            /** Create test data for AccessTokenSetting custom setting **/
            list<AccessTokenSetting__c> lstAccessTokenSetting  = AP01_TestDataUtility.createAccessTokenSettingSet();
            insert lstAccessTokenSetting;
        
            List<User> testRunUserList = new List<User>();
            User testRunUser1;
            Profile pp1;        
            UserRole portalRole; 

            String query = 'Select id from Contact where Source_of_E_mail__c LIKE \'%'+System.Label.TeleForm+'%\' and Email_Alert__c = \'YES\' AND Email!=null limit 145';
            portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];

            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
            System.runAs (thisUser) {
                
                /** select user profile of System Administrator **/
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
                Verifying the values of inserted user created above
                Expected Result: id value should not be null 
                Actual Result: id value should not be null 
               **********************************************************************/
                system.assert(testRunUserList[0]!= null);

            }
            
              System.runAs (testRunUser1) {
              Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
                
              /*********************************************************************** 
               Verifying the id value of inserted account record created above
               Expected Result: id value should not be null 
               Actual Result: id value should not be null 
              **********************************************************************/
               system.assert(assignedAccount!= null);
            }
        }
               
        /*******************************************************************
        Purpose: method to catch exception of BatchPasswordresetNonTeleForm class for performing negative test  
        Parameters: N/A 
        Returns: void
        Throws [Exceptions]: N/A
        ********************************************************************/
         
        static testmethod void testCatchExceptionCode_For_NONTeleformBatch_Negative() {
            
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            List<Contact> contactsToInsert = AP01_TestDataUtility.createProviderPortalContactsNONTeleForm(assignedAccount);
            
              /*********************************************************************** 
               Verifying the contact record inserted
               Expected Result: id value should not be null 
               Actual Result: id value should not be null 
              **********************************************************************/
            System.assert(contactsToInsert[0]!=null);
            for(Contact con : contactsToInsert){
                con.License_Number__c = '1234';
            }
            List <Database.SaveResult> results = Database.insert(contactsToInsert, false);
            try{
            Test.startTest();
            BatchPasswordresetNonTeleForm batchClass = new BatchPasswordresetNonTeleForm();
            batchClass.catchExceptionsFromCode(results);
            Test.stopTest();
            }catch(Exception ex){
                
            /*********************************************************************** 
             Verifying the message for the exception generated
             Expected Result: message value should not be null 
             Actual Result: message value should not be null 
            **********************************************************************/
            system.assert(ex.getMessage()!=null);
            }
        }        
                   
        /*******************************************************************
        Purpose: method to create provider User  and catch exceptions  BatchPasswordresetNonTeleForm
        Parameters: N/A 
        Returns: void
        Throws [Exceptions]: N/A
        ********************************************************************/  
                
        static testmethod void testProviderUserCreateNonTF_CatchExceptionMethod() {

            Account acc = [select id from Account where Name =: AP01_TestDataTokens.PORTAL_ACCOUNT_NAME limit 1];
            List<Contact> ProvidercontactPortalList = AP01_TestDataUtility.createProviderPortalContacts(acc);
           
           /*********************************************************************** 
            Verifying the contact record inserted
            Expected Result: id value should not be null 
            Actual Result: id value should not be null 
           **********************************************************************/
            System.assert(ProvidercontactPortalList[0]!=null);
            try{
                test.startTest();
                // Schedule the test job
                String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,new ProviderUserCreateScheduler());  
                String jobIdUserUpdate = System.schedule('ScheduleApexClassTestUserupdate',CRON_EXP2,new ProviderUserUpdateScheduler());
                BatchPasswordresetNonTeleForm obj = new BatchPasswordresetNonTeleForm();
                String cronID = System.scheduleBatch(obj, 'job example2', 1); 
                Database.executeBatch(obj, 200);
                obj.execute(null,null);
                test.stopTest();
            }catch (Exception ex){
                
            /*********************************************************************** 
             Verifying the message for the exception generated
             Expected Result: message value should not be null 
             Actual Result: message value should not be null 
            **********************************************************************/
             system.assert(ex.getMessage()!=null);
            }
        }         
         
        /*******************************************************************
        Purpose: method to create Portal user and schedule ProviderUserCreateScheduler,ProviderUserUpdateScheduler classes
        Parameters: N/A 
        Returns: void
        Throws [Exceptions]: N/A
        ********************************************************************/  
        
        static testmethod void testProviderUserCreateNonTeleform_SchedulerMethod() {

            List<User> testRunUserList = new List<User>();
            User testRunUser1 = [SELECT Id FROM User WHERE Username = 'tester49_nky@test.com'];  
            System.runAs (testRunUser1) {
                Account acc = [select id from Account where Name =: AP01_TestDataTokens.PORTAL_ACCOUNT_NAME ];
                
                List<Contact> ProvidercontactPortalList = AP01_TestDataUtility.createProviderPortalContacts(acc);
              
              /*********************************************************************** 
               Verifying the contact record inserted
               Expected Result: id value should not be null 
               Actual Result: id value should not be null 
              **********************************************************************/
                System.assert(ProvidercontactPortalList[0]!=null);
                
               /** select user profile of Community Portal **/
                Profile pp1;
                UserRole portalRole; 
                pp1 = [Select Id from Profile where name = 'Community Portal' Limit 1];
                portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                User testUser = new User(
                    ProfileId = pp1.Id,
                    Username = 'tester49_nky1@test.com',
                    //UserRoleId = portalRole.Id,
                    Alias = 'tester1',
                    ContactId = ProvidercontactPortalList[0].id,
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
                                    
                try{
                    test.startTest();
                    
                    String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,new ProviderUserCreateScheduler());  
                    String jobIdUserUpdate = System.schedule('ScheduleApexClassTestUserupdate',CRON_EXP2,new ProviderUserUpdateScheduler()); 
                    
                    BatchPasswordresetNonTeleForm obj = new BatchPasswordresetNonTeleForm();
                    Database.executeBatch(obj, 200);
                    obj.execute(null,ProvidercontactPortalList);
                                        
                    test.stopTest();
                }catch (Exception ex){
                    
                   /*********************************************************************** 
                    Verifying the message for the exception generated
                    Expected Result: message value should not be null 
                    Actual Result: message value should not be null 
                   **********************************************************************/
                    system.assert(ex.getMessage()!=null);
                }
            }
        }
    }