/**  
*     Class Name  : ProviderUserCreateScheduler_Test 
*     Author      : IDC Offshore
*     Date        : 10-April-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description : This test class is for REQ- 3399. It creates Contacts of Provider record type then schedules the ProviderUserCreateScheduler,
ProviderUserUpdateScheduler,BatchPasswordresetNonTeleForm,BatchPasswordresetTeleForm .             
**/
 @isTest
   Private class ProviderUserCreateScheduler_Test {

        /** Setting the CRON Expression for both User Create and User Update for Provider RecordType and Source of email as TLFM **/
        public static String CRON_EXP = '0 0 0 15 3 ? 2022';
        public static String CRON_EXP2 = '0 0 0 16 3 ? 2022';
        
        /**        
         * @author IDC Team        
         * @date 20/Oct/2015       
         * @description method to create test data used by all tests       
         * @return void        
         **/
        @testSetup 
        static void createTestData() {
        
            //@description This method create test data for CS_ManageProfile custom setting.
            list<CS_ManageProfile__c> lstManageProfile  = Util01_PDIUtilTestData.createManageprofileSet();
            insert lstManageProfile;
                
            //@description This method create test data for AccessTokenSetting custom setting.
            list<AccessTokenSetting__c> lstAccessTokenSetting  = Util01_PDIUtilTestData.createAccessTokenSettingSet();
            insert lstAccessTokenSetting;
        
            List<User> testRunUserList = new List<User>();
            User testRunUser1;
            Profile pp1;        
            UserRole portalRole; 

            String query = 'Select id from Contact where Source_of_E_mail__c LIKE \'%'+System.Label.TeleForm+'%\' and Email_Alert__c = \'YES\' AND Email!=null limit 145';
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
                
                //Assert to check if User has been created successfully 
                system.assert(testRunUserList[0]!= null);

            }
            System.runAs (testRunUser1) {
                Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
                 //Assert to check Account has been created successfully 
                system.assert(assignedAccount!= null);
            }
        }
        
        /**        
         * @author IDC Team        
         * @date 20/Oct/2015       
         * @description method which contains test data for covering logic related to updating info of Provider Users existing in the system     
         * @return void        
         **/
        static testmethod void TestUpdateProviderUsers(){
            List<Contact> lstContactsToUpdate = new List<Contact>();
            List<id> lstContactIds = new List<Id>();
            Map<Id,Contact> oldContactMap =  new Map<Id,Contact>();
            Map<Id,Contact> NewContactMap =  new Map<Id,Contact>();
            
            Account acc = [select id from Account where Name =: AP01_TestDataTokens.PORTAL_ACCOUNT_NAME limit 1];
         
            try{
                test.startTest();
                List<Contact> ProvidercontactPortalList = Util01_PDIUtilTestData.createProviderPortalContacts(acc);
               // Assert to check contact has been created successfully
               System.assert(ProvidercontactPortalList[0]!=null);
                for(Contact objContact:ProvidercontactPortalList) {
                    objContact.Provider_Correspondence_Address__c = 'test address';
                    objContact.Preferred_Communication_Method__c = 'Fax';
                    oldContactMap.put(objContact.id,objContact);
                    lstContactsToUpdate.add(objContact);
                }

                if(lstContactsToUpdate!=null && lstContactsToUpdate.size()>0){
                    update lstContactsToUpdate;
                }
                //Assert to check contact has updated successfully  
                for(Contact tempCont : [select id,Provider_Correspondence_Address__c,Preferred_Communication_Method__c from contact where id =: lstContactsToUpdate]){
                    system.assert(tempCont.Provider_Correspondence_Address__c == 'test address');
                    system.assert(tempCont.Preferred_Communication_Method__c == 'Fax');
                }
                
                for(Contact objCon:lstContactsToUpdate) 
                {
                lstContactIds.add(objCon.id);
                newContactMap.put(objCon.id,objCon);
                }
                ManageContactDatabase.updateProviderSummaryRecords(lstContactsToUpdate,oldContactMap,newContactMap);
                 if(lstContactIds!=null && lstContactIds.size()>0)
                ManageCommunityUsers.updateProviderUsers(lstContactIds);  
                test.stopTest();
            }catch (Exception ex){
                system.assert(ex.getmessage()!=null);
            }
        }
        /**        
         * @author IDC Team        
         * @date 10/Oct/2015       
         * @description method to catch exception of BatchPasswordresetNonTeleForm class       
         * @return void        
         **/
        static testmethod void testCatchExceptionCode_For_NONTeleformBatch() {
            
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            List<Contact> contactsToInsert = Util01_PDIUtilTestData.createProviderPortalContactsNONTeleForm(assignedAccount);
            // Assert to check  contact has been created successfully
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
            system.assert(ex.getMessage()!=null);
            }
        }
        /**        
         * @author IDC Team        
         * @date        
         * @description method to catch exception of BatchPasswordresetTeleForm class       
         * @return void        
         **/
        static testmethod void testCatchExceptionCode_For_TeleformBatch() {
            
            Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            List<Contact> contactsToInsert = Util01_PDIUtilTestData.createProviderPortalContactsNONTeleForm(assignedAccount);
           // Assert to check  contact has been created successfully
            System.assert(contactsToInsert[0]!=null);
            
            for(Contact con : contactsToInsert){
                con.License_Number__c = '1234';
            }
            List <Database.SaveResult> results = Database.insert(contactsToInsert, false);
            try{
                Test.startTest();
                BatchPasswordresetTeleForm batchClass = new BatchPasswordresetTeleForm();
                batchClass.catchExceptionsFromCode(results);
                Test.stopTest();
            }catch(Exception ex){
                system.assert(ex.getMessage()!=null);
            }
        }
        /**        
         * @author IDC Team        
         * @date       
         * @description method to create provider user  and catch exceptions of BatchPasswordresetTeleForm 
         **/
        static testmethod void testProviderUserCreate_CatchExcpetionMethod() {

            Account acc = [select id from Account where Name =: AP01_TestDataTokens.PORTAL_ACCOUNT_NAME limit 1];
             
            List<Contact> contactListToUpdate = new List<Contact>();
            List<Contact> ProvidercontactPortalList = Util01_PDIUtilTestData.createProviderPortalContactsTeleForm(acc);
            // Assert to check  contact has been created successfully
            System.assert(ProvidercontactPortalList[0]!=null);
            test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            BatchPasswordresetTeleForm obj = new BatchPasswordresetTeleForm();
            String cronID = System.scheduleBatch(obj, 'job example2', 1); 
            Database.executeBatch(obj, 200);
            obj.execute(null,ProvidercontactPortalList);
            
            // Schedule the test job
            String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,new ProviderUserCreateScheduler());
            String jobIdUserUpdate = System.schedule('ScheduleApexClassTestUserupdate',CRON_EXP2,new ProviderUserUpdateScheduler());
            test.stopTest();
        }
        
         /**        
         * @author IDC Team        
         * @date 10/Oct/2015       
         * @description method to create provider User  and catch exceptions  BatchPasswordresetNonTeleForm
         * @return void        
         **/
        static testmethod void testProviderUserCreateNonTF_CatchExceptionMethod() {

            Account acc = [select id from Account where Name =: AP01_TestDataTokens.PORTAL_ACCOUNT_NAME limit 1];
            List<Contact> ProvidercontactPortalList = Util01_PDIUtilTestData.createProviderPortalContacts(acc);
           // Assert to check  contact has been created successfully
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
                system.assert(ex.getMessage()!=null);
            }
        }
         /**        
         * @author IDC Team        
         * @date 10/Oct/2015       
         * @description: method to create Portal user and schedule ProviderUserCreateScheduler,ProviderUserUpdateScheduler classes    
         * @return void        
         **/
        
        static testmethod void testProviderUserCreateNonTeleform_SchedulerMethod() {

            List<User> testRunUserList = new List<User>();
            User testRunUser1 = [SELECT Id FROM User WHERE Username = 'tester49_nky@test.com'];  
            //Assert to check user has been fetched successfully
            system.assert(testRunUser1!=null);

            System.runAs (testRunUser1) {
                Account acc = [select id from Account where Name =: AP01_TestDataTokens.PORTAL_ACCOUNT_NAME ];
                
                List<Contact> ProvidercontactPortalList = Util01_PDIUtilTestData.createProviderPortalContacts(acc);
              // Assert to check  contact has been created successfully
                System.assert(ProvidercontactPortalList[0]!=null);
                
               //select user profile
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
                //Assert to check user has been created successfully
                system.assert(testUser!=null);
                    
                try{
                    test.startTest();
                    
                    String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,new ProviderUserCreateScheduler());  
                    String jobIdUserUpdate = System.schedule('ScheduleApexClassTestUserupdate',CRON_EXP2,new ProviderUserUpdateScheduler()); 
                    
                    BatchPasswordresetNonTeleForm obj = new BatchPasswordresetNonTeleForm();
                    Database.executeBatch(obj, 200);
                    obj.execute(null,ProvidercontactPortalList);
                    
                    BatchPasswordresetTeleForm obj2 = new BatchPasswordresetTeleForm();
                    Database.executeBatch(obj2, 200);
                    obj2.execute(null,ProvidercontactPortalList);
                    test.stopTest();
                }catch (Exception ex){
                    system.assert(ex.getMessage()!=null);
                }
            }
        }
    }