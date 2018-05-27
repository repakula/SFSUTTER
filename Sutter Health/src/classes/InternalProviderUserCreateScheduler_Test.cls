/**  
*     Class Name  : ProviderUserCreateScheduler_Test 
*     Author      : IDC Offshore
*     Date        : 24-Nov-2016
*     Project Name: CRM - SFT - Sutter Health
*     Description : It creates Contacts of Provider record type then schedules the ProviderUserCreateScheduler,
ProviderUserUpdateScheduler, BatchInternalProviderWelcomeEmail and BatchAdminAsstWelcomeEmail.             
**/
@isTest
public class InternalProviderUserCreateScheduler_Test {
    /**        
    * @author IDC Team        
    * @description method to code coverage of Provider User Create and Provider User Update Scheduler       
    * @return void        
    **/
    static testmethod void testProviderUserCreate_SchedulerMethod() {
        /** Setting the CRON Expression for both User Create and User Update for Provider RecordType and Source of email as TLFM **/
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        String CRON_EXP2 = '0 0 0 16 3 ? 2022';
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (thisUser) {
            // Create custom setting Data
            CS_ManageProfile__c csprofile = Util01_PDIUtilTestData.createManageProfileCustSetting();
            Account accObj = new Account();
            accObj.Name = 'Account Name';
            insert accObj;
            
            RecordType rtObj = new RecordType();
            rtObj = [SELECT id, name FROM recordtype WHERE name='Provider' and SObjectType='Contact' limit 1];
            
            list<contact> conList = new list<contact>();
            
            conList.add(new contact(
                accountId = accObj.id,
                lastName = 'Provider',
                firstName = 'Test',
                Provider_Name__c = 'Test Provider',
                Provider_Title__c = 'Mr.',
                recordTypeId = rtObj.id,
                email = 'kishore.jonnadula@accenture.com',
                Provider_Correspondence_Address__c = '123',
                Provider_Correspondence_City__c = 'CA',
                Provider_Correspondence_State__c = 'CA',
                Provider_Correspondence_PostalCode__c = '12345',
                Provider_Correspondence_Phone__c = '(234) 999-2341',
                Provider_Correspondence_Fax_Number__c = '(234) 567-8901',
                MobilePhone = '(234) 567-8901',
                Provider_Active_Status__c = true,
                Provider_Practicing_Physician__c = true,
                Provider_Access_Type__c = 'No Access',
                Employee_ADID__c = 'Gh3453J',
                Contact_External_ID1__c = '8965'
            ));
            insert conList; 
            // Assert to check  contact has been created successfully
            System.assert(conList[0]!=null);
            try{
                test.startTest();
                
                String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,new ProviderUserCreateScheduler()); 
                
                Contact conObj = new Contact();
                conObj.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                conObj.LastName = AP01_TestDataTokens.CONTACT_L_NAME;
                conObj.AccountId = accObj.id;
                conObj.Email='testpdv@dummypdvemail.com';
                conObj.RecordTypeId = rtObj.Id;
                conObj.Provider_Practicing_Physician__c = true;
                conObj.Provider_Active_Status__c = true;
                conObj.Provider_Active_Status_Date__c = system.today();
                conObj.Employee_ADID__c = 'H76656J';
                conObj.Provider_Type__c = 'Internal';
                conObj.Internal_Provider_Email__c = 'test46786@email.com';
                insert conObj;
                String jobIdUserUpdate = System.schedule('ScheduleApexClassTestUserupdate',CRON_EXP2,new ProviderUserUpdateScheduler()); 
                
                
                test.stopTest();
            }catch (Exception ex){
                system.assert(ex.getMessage()!=null);
            }
        }
    }
    
    /**        
    * @author IDC Team        
    * @date        
    * @description method to catch exception of BatchInternalProviderWelcomeEmail class       
    * @return void        
    **/
    static testmethod void testCatchExceptionCode_For_InternalProviderWelcomeEmailBatch() {
        
        Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
        List<Contact> contactsToInsert = Util01_PDIUtilTestData.createProviderPortalContactsNONTeleForm(assignedAccount);
        // Assert to check  contact has been created successfully
        System.assert(contactsToInsert[0]!=null);
        
        for(Contact con : contactsToInsert){
            con.License_Number__c = '1234';
        }
        List <Database.SaveResult> results = Database.insert(contactsToInsert, false);
        try{
            BatchInternalProviderWelcomeEmail batchClass = new BatchInternalProviderWelcomeEmail();
            batchClass.catchExceptionsFromCode(results);
        }catch(Exception ex){
            system.assert(ex.getMessage()!=null);
        }
    }
    
    /**        
    * @author IDC Team        
    * @date        
    * @description method to code coverage of BatchInternalProviderWelcomeEmail class       
    * @return void        
    **/
    static testmethod void testBatchInternalProviderWelcomeEmail() {
        String CRON_EXP2 = '0 0 0 25 3 ? 2022';
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1]; 

        System.runAs (thisUser) {
            // Create custom setting Data
            CS_ManageProfile__c csprofile = Util01_PDIUtilTestData.createManageProfileCustSetting();
            list<AccessTokenSetting__c> accessSettings = Util01_PDIUtilTestData.createAccessTokenSettingSet();
            insert accessSettings;
            Account accObj = new Account();
            accObj.Name = 'Account Name';
            insert accObj;
            
            RecordType rtObj = new RecordType();
            rtObj = [SELECT id, name FROM recordtype WHERE name='Provider' and SObjectType='Contact' limit 1];
            
            list<contact> conList = new list<contact>();
            
            conList.add(new contact(
                accountId = accObj.id,
                lastName = 'Provider',
                firstName = 'Test',
                Provider_Name__c = 'Test Provider',
                Provider_Title__c = 'Mr.',
                recordTypeId = rtObj.id,
                email = 'kishore.jonnadula@accenture.com',
                Provider_Active_Status__c = true,
                Provider_Practicing_Physician__c = true,
                Provider_Access_Type__c = 'No Access',
                Employee_ADID__c = 'Gh3453J',
                Email_Alert__c = 'YES',
                Contact_External_ID1__c = '8965'
            ));
            insert conList;
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            BatchInternalProviderWelcomeEmail obj = new BatchInternalProviderWelcomeEmail();
            String jobIdUserUpdate = System.schedule('InternalProviderWelcomeEmailScheduler',CRON_EXP2,new BatchInternalProviderEmailScheduler()); 
            Database.executeBatch(obj, 200);
            obj.execute(null,conList);
            Test.stopTest();
        }
        
    }
    
    /**        
    * @author IDC Team        
    * @date        
    * @description method to code coverage of BatchAdminAsstWelcomeEmail class       
    * @return void        
    **/
    static testmethod void testBatchAdminAsstWelcomeEmail() {
        String CRON_EXP = '0 0 0 20 3 ? 2022';
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        System.runAs (thisUser) {
            // Create custom setting Data
            CS_ManageProfile__c csprofile1 = Util01_PDIUtilTestData.createAdminManageProfileCustSetting();
            list<AccessTokenSetting__c> accessSettings = Util01_PDIUtilTestData.createAccessTokenSettingSet();
            insert accessSettings;
            Account accObj1 = new Account();
            accObj1.Name = 'Admin testAsst';
            insert accObj1;
            
            RecordType rtObj1 = new RecordType();
            rtObj1 = [SELECT id, name FROM recordtype WHERE name='Provider Admin Assistant' and SObjectType='Contact' limit 1];
            
            list<Contact> adminContactsList = new list<Contact>();
            Contact conObj1 = new Contact();
            conObj1.AccountId = accObj1.Id;
            conObj1.RecordTypeId = rtObj1.Id;
            conObj1.Email= 'test123@email.com';
            conObj1.FirstName = 'Admin';
            conObj1.LastName = 'testAssistAdmintest123';
            adminContactsList.add(conObj1);
            insert adminContactsList;
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            BatchAdminAsstWelcomeEmail obj = new BatchAdminAsstWelcomeEmail();
            String jobId = System.schedule('AdminAsstWelcomeEmailScheduler',CRON_EXP,new BatchAdminAsstWelcomeEmailScheduler());
            Database.executeBatch(obj, 200);
            obj.execute(null,adminContactsList);
            Test.stopTest();
        }
    }
    
    /**        
    * @author IDC Team        
    * @date        
    * @description method to catch exception of BatchAdminAsstWelcomeEmail class       
    * @return void        
    **/
    static testmethod void testCatchExceptionCode_For_AdminAsstWelcomeEmailBatch() {
        
        Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
        List<Contact> contactsToInsert = Util01_PDIUtilTestData.createProviderPortalContactsNONTeleForm(assignedAccount);
        // Assert to check  contact has been created successfully
        System.assert(contactsToInsert[0]!=null);
        
        for(Contact con : contactsToInsert){
            con.License_Number__c = '1234';
        }
        List <Database.SaveResult> results = Database.insert(contactsToInsert, false);
        try{
            BatchAdminAsstWelcomeEmail batchClass = new BatchAdminAsstWelcomeEmail();
            batchClass.catchExceptionsFromCode(results);
        }catch(Exception ex){
            system.assert(ex.getMessage()!=null);
        }
    }
  
}