@isTest
public class BatchAdminAssistantUserScheduler_Test {
    // CRON expression: ealry morning at 4am.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    /**        
    * @author IDC Team        
    * @date        
    * @description method to code coverage of BatchAdminAssistantUserScheduler class       
    * @return void        
    **/
    static testmethod void testAdminAsssistantUserCreatePositive_test() {
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        String CRON_EXP = '0 0 4 * * ?';
        System.runAs(testUser)
        {
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            List<Contact> conList = Util01_PDIUtilTestData.create_Validated_Contact();
            /*********************************************************************** 
            Verifying the contact are inserted succesfully 
            Expected Result: Contact list size should not be equal to 0.
            Actual Result: Contact list size should not be equal to 0.
            ***********************************************************************/ 
            system.assert(conList.size()>0);
            Set<Id> conIdSet = new Set<Id>();
            
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            
            List<Contact_Validation_Summary__c> summaryRecords = [select id, Contact_Id__c from Contact_Validation_Summary__c where Contact_Id__c IN : conIdSet];
            system.debug('@@summaryRecords : '+ summaryRecords);
            Contact_Validation_Summary__c summary = new Contact_Validation_Summary__c();
            if(!summaryRecords.isEmpty()){
                summary.Id = summaryRecords[0].Id;
                summary.Admin_Assistant_Approval_Status__c = 'Approved';
                summary.Admin_Assistant__c = 'teststAdmin Asst2';
                summary.Admin_Assistant_Email__c = 'tetst1234@email.com';
                update summary;
            }
            /*********************************************************************** 
            Verifying the contact record inserted
            Expected Result: id value should not be null 
            Actual Result: id value should not be null 
            **********************************************************************/
            System.assert(summary.Id != null);
            Test.startTest();
            
            // Schedule the test job
            String jobId = System.schedule('BatchAdminAssistantUserSchedular',
                                           CRON_EXP, 
                                           new BatchAdminAssistantUserScheduler());
            
            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                              NextFireTime
                              FROM CronTrigger WHERE id = :jobId];
            
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, 
                                ct.CronExpression);
            
            // Verify the job has not run
            System.assertEquals(0, ct.TimesTriggered);
            Test.stopTest();
        }
        
    }
    
    /**        
    * @author IDC Team        
    * @date        
    * @description method to code coverage of BatchAdminUserUpdateScheduler class       
    * @return void        
    **/
    static testmethod void testAdminAssistantUserUpdate_test() {
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        String CRON_EXP = '0 0 4 * * ?';
        System.runAs(testUser)
        {
            CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
            
            CS_ManageProfile__c csprofile1 = Util01_PDIUtilTestData.createAdminManageProfileCustSetting();
            
            Account accObj1 = new Account();
            accObj1.Name = 'Admin testAssistAdmintest123';
            insert accObj1;
            
            RecordType rtObj1 = new RecordType();
            rtObj1 = [SELECT id, name FROM recordtype WHERE name='Provider Admin Assistant' and SObjectType='Contact' limit 1];
            
            Contact conObj1 = new Contact();
            conObj1.AccountId = accObj1.Id;
            conObj1.RecordTypeId = rtObj1.Id;
            conObj1.Email= 'testadmin@dummyAsstemail.com';
            conObj1.FirstName = 'Admin';
            conObj1.LastName = 'testAssistAdmintest123';
            conObj1.Admin_Temp_Email__c = 'test123@email.com';
            
            insert conObj1;
            
           
            Test.startTest();
            
            // Schedule the test job
            String jobId = System.schedule('BatchAdminAssistantUserUpdateSchedular',
                                           CRON_EXP, 
                                           new BatchAdminUserUpdateScheduler());
            
            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                              NextFireTime
                              FROM CronTrigger WHERE id = :jobId];
            
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, 
                                ct.CronExpression);
            
            // Verify the job has not run
            System.assertEquals(0, ct.TimesTriggered);
            Test.stopTest();
        }
    }
    
    /**        
    * @author IDC Team        
    * @date        
    * @description method to code coverage of BatchAdminAssistantUserCreate Catch class       
    * @return void        
    **/
    static testmethod void testAdminAsssistantUserCreateCatch_test() {
        User testUser = Util01_PDIUtilTestData.PDITestUser();
        System.runAs(testUser)
        {
            Test.startTest();
            try{
                BatchAdminAssistantUserCreation obj = new BatchAdminAssistantUserCreation();
                Database.executeBatch(obj, 200);
                obj.execute(null, null);
            }catch(Exception ex){
                System.assert(ex.getMessage() != null);
            }
            Test.stopTest();
        }
    }

}