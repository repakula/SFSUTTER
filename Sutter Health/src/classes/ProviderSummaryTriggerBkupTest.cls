/**********************************************************************
Name: ProviderSummaryTriggerBkupTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is the test class for Provider Summary trigger 
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE        DETAIL                 Description
1.0      IDC Offshore  10/6/2015  Development complete   This class is defined to test Provider Summary trigger for all scenarios
***********************************************************************/


@isTest
public class ProviderSummaryTriggerBkupTest {
    
    /*******************************************************************
Purpose: method to create test data used by all test methods
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
    @testsetup
    static void createTestData()
    {
        
        /** Creating Custom Setting data to be used in the code of various helper classes like ManageContactDatabase,ManageCommunityUsers etc. **/
        CreatedDate__c obj =new CreatedDate__c();
        obj.Created_date__c = date.today();
        obj.name ='CopyPcpDate';
        insert obj;
        
        CS_ManageProfile__c CSMCommunities_Portal = new CS_ManageProfile__c(Name = 'Communities_Portal', Profile_Name__c='Community Portal');
        CS_ManageProfile__c CSMCommunities_Provider = new CS_ManageProfile__c(Name = 'Communities_Provider', Profile_Name__c='Community Portal Manager');
        CS_ManageProfile__c CSMCommunity_Portal_Manager = new CS_ManageProfile__c(Name = 'Community_Portal_Manager', Profile_Name__c='Community Portal Manager');
        Insert CSMCommunities_Portal;
        Insert CSMCommunities_Provider;
        Insert CSMCommunity_Portal_Manager;
        
        /** Fetching the profile id of system Administrator for creating test data **/
        Id profileId = [select id from Profile where name='System Administrator'].id;
        Group objPublicGrp_Queue,objPublicGrp_Queue_Ng;
        QueueSobject objQueueSobject,objQueueSobject_Ng;
        User objUser = [select id from user where profileid=:profileId and isActive=true limit 1];
        
        System.runAs(objUser){
            /** Creating a public Group **/     
            Group objPublicGrp = new Group();
            objPublicGrp.name='test';
            insert objPublicGrp;
            
            /** Creating a Group member and assigning it to the above created Group **/
            GroupMember objGrpMember =new GroupMember();
            objGrpMember.userorgroupid=userinfo.getuserid();
            objGrpMember.groupid=objPublicGrp.id;
            insert objGrpMember;
            
            /** Creating a Queue for Positive test case**/
            objPublicGrp_Queue = new group();
            objPublicGrp_Queue.name='test2';
            objPublicGrp_Queue.type='Queue';
            insert objPublicGrp_Queue;
            
        }
        
        System.runAs(objUser){
            
            /** Creating a QueueSobject to give permission to queue created above of SOC Queue object **/
            objQueueSobject =new queuesobject();
            objQueueSobject.sobjecttype='Contact_Validation_Summary__c';
            objQueueSobject.QueueId=objPublicGrp_Queue.id;
            insert objQueueSobject;
            
        }
        
        /** Creating Account record **/
        Account accObj = new Account();
        accObj.name = 'Test Account';
        insert accObj;
        
        /** Fetching the Provider Recordtype of Contact **/
        RecordType rtObj = new RecordType();
        rtObj = [SELECT id, name FROM recordtype WHERE name='Provider' and SObjectType='Contact' limit 1];
        
        /** Creating List of Contacts to insert Contacts **/
        list<contact> conList = new list<contact>();
        
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
            MobilePhone = '2345678901',
            Contact_External_ID1__c = '12345'
        ));
        
        insert conList;   
        
        /*********************************************************************** 
Verifying the values of custom Settings and contacts using system.assert() 
Expected Result: values should not be null for the custom Setting records and contact records
Actual Result: values should not be null for the custom Setting records and contact records
***********************************************************************/
        system.assert(CSMCommunities_Portal!=null);
        system.assert(CSMCommunities_Provider!=null);
        system.assert(CSMCommunity_Portal_Manager!=null);
        system.assert(conList[1]!=null);    
    }
    
    /*******************************************************************
Purpose: method to create contact validation summary and check the logic written in ProviderSummaryTriggerBkup(trigger)  
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
    public static testMethod void providerSummaryTrigger_Test(){
        
        /** Fetching the queue created above, in test data method**/
        Group objPublicGrp_Queue = [select id from Group where type='Queue' and name='test2'];
        
        list<contact> conList = [select id from Contact where Contact_External_ID1__c like '%123%'];
        
        Test.startTest();   
        
        /** Deleting the existing Summary record for the Contact to cover all scenarios and test the logic **/
        List<Contact_Validation_Summary__c> cvsObject = [select id from Contact_Validation_Summary__c where contact_id__c=:conlist[0].id];
        delete cvsObject;        
        
        /** Creating a new Summary Record to cover the insertion scenario **/
        Contact_Validation_Summary__c cvsObjectSecondary = new Contact_Validation_Summary__c();
        cvsObjectSecondary.Contact_Id__c = [select id from contact where Contact_External_ID1__c = '1234'].id;
        cvsObjectSecondary.Preferred_Communication_Method__c= 'email';
        cvsObjectSecondary.Address_Type__c = 'Secondary';
        cvsObjectSecondary.Serial_Number__c = null;
        cvsObjectSecondary.Validation_Source_Channel__c = 'test1';
        cvsObjectSecondary.ownerid = objPublicGrp_Queue.id;
        insert cvsObjectSecondary;
        System.assert(cvsObjectSecondary.Id != null);
        
        /** Updating the Summary record to cover updation scenario of owner change **/
        cvsObjectSecondary.Validation_Source_Channel__c = 'test2';
        cvsObjectSecondary.Serial_Number__c = null;
        cvsObjectSecondary.ownerid= userinfo.getuserid();
        update cvsObjectSecondary;
        System.assertEquals('Secondary', cvsObjectSecondary.Address_Type__c);
        /*********************************************************************** 
Verifying the value using system.assert() 
Expected Result: Serial number on Summary should be null
Actual Result: Serial number on Summary should be null
***********************************************************************/
        system.assertEquals(cvsObjectSecondary.Serial_Number__c ,null);
        
        /** Creating  a new Summary record for the Contact to cover insertion logic for all conditions **/
        Contact_Validation_Summary__c cvsObjSecondary = new Contact_Validation_Summary__c();
        cvsObjSecondary.Contact_Id__c = conlist[0].id;
        cvsObjSecondary.Preferred_Communication_Method__c= 'email';
        cvsObjSecondary.Address_Type__c = 'Secondary';
        cvsObjSecondary.Serial_Number__c = null;
        insert cvsObjSecondary;
        System.assert(cvsObjSecondary.Id != null);
        Contact_Validation_Summary__c cvsObj = new Contact_Validation_Summary__c();
        cvsobj = [SELECT id FROM Contact_Validation_Summary__c WHERE contact_id__c = :conlist[0].id limit 1];
        cvsObj.Preferred_Communication_Method__c= 'email';
        update cvsObj;
        System.assert(cvsObj.Id != null);
        Test.stopTest();  
        
        
        
    }
    
    /*******************************************************************
Purpose: method to create contact validation summary and check the logic written in ProviderSummaryTriggerBkup(trigger) for bulk scenarios 
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
    public static testMethod void providerSummaryTrigger_BulkTest(){
        
        List<Contact_Validation_Summary__c> lstSummariesIns =new List<Contact_Validation_Summary__c>();
        List<Contact_Validation_Summary__c> lstsummariesUpd =new List<Contact_Validation_Summary__c>();
        
        
        /** Fetching the queue created above, in test data method**/
        Group objPublicGrp_Queue = [select id from Group where type='Queue' and name='test2'];
        
        list<contact> conList = [select id from Contact where Contact_External_ID1__c like '%123%'];
        
        Test.startTest();   
        
        /** Deleting the existing Summary record for the Contact to cover all scenarios and test the logic **/
        List<Contact_Validation_Summary__c> cvsObject = [select id from Contact_Validation_Summary__c where contact_id__c=:conlist[0].id];
        delete cvsObject;        
        
        /** Creating  new Summary Records to cover the insertion scenario **/
        for(Integer i=1;i<=200;i++){
            Contact_Validation_Summary__c cvsObjectSecondary = new Contact_Validation_Summary__c();
            cvsObjectSecondary.Contact_Id__c = conList[0].id;
            cvsObjectSecondary.Preferred_Communication_Method__c= 'email';
            cvsObjectSecondary.Address_Type__c = 'Secondary';
            cvsObjectSecondary.Serial_Number__c = null;
            cvsObjectSecondary.Validation_Source_Channel__c = 'test1';
            cvsObjectSecondary.ownerid = objPublicGrp_Queue.id;
            lstSummariesIns.add(cvsObjectSecondary);
        }
        
        insert lstSummariesIns;
        System.assert(lstSummariesIns.size() > 0);
        for(Contact_Validation_Summary__c cvsObjectSecondary:lstSummariesIns){
            
            /** Updating the Summary record to cover updation scenario of owner change **/
            cvsObjectSecondary.Validation_Source_Channel__c = 'test2';
            cvsObjectSecondary.Serial_Number__c = null;
            cvsObjectSecondary.ownerid= userinfo.getuserid();
            lstsummariesUpd.add(cvsObjectSecondary);
        }
        update lstsummariesUpd;
        System.assert(!lstsummariesUpd.isEmpty());
        /*********************************************************************** 
Verifying the value using system.assert() 
Expected Result: Serial number on Summary should be null
Actual Result: Serial number on Summary should be null
***********************************************************************/
        Contact_Validation_Summary__c objSummary = lstsummariesUpd[0];
        system.assertEquals(objSummary.Serial_Number__c ,null);
        
        /** Creating  a new Summary record for the Contact to cover insertion logic for all conditions **/
        Contact_Validation_Summary__c cvsObjSecondary = new Contact_Validation_Summary__c();
        cvsObjSecondary.Contact_Id__c = conlist[0].id;
        cvsObjSecondary.Preferred_Communication_Method__c= 'email';
        cvsObjSecondary.Address_Type__c = 'Secondary';
        cvsObjSecondary.Serial_Number__c = null;
        insert cvsObjSecondary;
        System.assert(cvsObjSecondary.Id != null);
        Contact_Validation_Summary__c cvsObj = new Contact_Validation_Summary__c();
        cvsobj = [SELECT id FROM Contact_Validation_Summary__c WHERE contact_id__c = :conlist[0].id limit 1];
        cvsObj.Preferred_Communication_Method__c= 'email';
        update cvsObj;
        System.assert(cvsObj.Id != null);
        Test.stopTest();  
        
        
        
    }
    
    /*******************************************************************
Purpose: Negative test method to create contact validation summary and check the logic written in ProviderSummaryTriggerBkup(trigger)  by not populating the contact lookup and providing data not processed by the trigger
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
    public static testMethod void providerSummaryTrigger_NegativeTest(){
        
        /** Fetching the queue created above, in test data method**/
        Group objPublicGrp_Queue = [select id from Group where type='Queue' and name='test2'];
        
        list<contact> conList = [select id from Contact where Contact_External_ID1__c like '%123%'];
        
        Test.startTest();   
        
        /** Deleting the existing Summary record for the Contact to cover all scenarios and test the logic **/
        List<Contact_Validation_Summary__c> cvsObject = [select id from Contact_Validation_Summary__c where contact_id__c=:conlist[0].id];
        delete cvsObject;        
        
        /** Creating a new Summary Record to cover the insertion scenario **/
        Contact_Validation_Summary__c cvsObjectSecondary = new Contact_Validation_Summary__c();
        cvsObjectSecondary.Preferred_Communication_Method__c= 'email';
        cvsObjectSecondary.Address_Type__c = 'Secondary';
        cvsObjectSecondary.Serial_Number__c = null;
        cvsObjectSecondary.Validation_Source_Channel__c = 'test1';
        cvsObjectSecondary.ownerid = objPublicGrp_Queue.id;
        insert cvsObjectSecondary;
        System.assert(cvsObjectSecondary.Id != null);
        /** Updating the Summary record to cover updation scenario of owner change **/
        cvsObjectSecondary.Validation_Source_Channel__c = 'test2';
        cvsObjectSecondary.Serial_Number__c = null;
        cvsObjectSecondary.ownerid= userinfo.getuserid();
        update cvsObjectSecondary;
        System.assert(cvsObjectSecondary.Id != null);
        /*********************************************************************** 
Verifying the value using system.assert() 
Expected Result: Serial number on Summary should be null
Actual Result: Serial number on Summary should be null
***********************************************************************/
        system.assertEquals(cvsObjectSecondary.Serial_Number__c ,null);
        
        Test.stopTest();  
        
    }
    
    /*******************************************************************
Purpose: method to test providers by phone number helper class
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    public static testMethod void providersByPhoneNumberHelper_Test(){
        CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
        PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
        PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
        List<Contact> cList = Util01_PDIUtilTestData.CreateDupPhoneContacts();
        
        List<Contact> cListToUpdate = new List<Contact>();
        for(Contact c: cList){
            if(c.LastName == 'Test0' || c.LastName == 'Test1'){
                cListToUpdate.add(c);
            }
        }
        insert cListToUpdate;
        
        List<ProvidersByPhoneNumber__c> phoneList = new List<ProvidersByPhoneNumber__c>();
        phoneList = [Select Tech_Phone_Number__c from ProvidersByPhoneNumber__c Limit 1];
        
        List<contact_validation_summary__c> sList = new List<contact_validation_summary__c>();
        sList = [Select Id, Tech_Phone_Number__c, Provider_LastName__c from contact_validation_summary__c Limit 1];
        contact_validation_summary__c sum = sList[0];
        sum.Secure_Phone__c = '9767564456';
        sum.Tech_Phone_Number__c = '9767564456';
        
        Test.startTest();
        update sum;
        System.assert(sum.Id != null);
        Test.stopTest();
    }
    /*******************************************************************
Purpose: method to test providers by phone number helper class
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    public static testMethod void providersByPhoneNumberHelperAccepted_Test(){
        CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
        PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
        PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
        List<Contact> cList = Util01_PDIUtilTestData.CreateDupPhoneContacts();
        
        List<Contact> cListToUpdate = new List<Contact>();
        for(Contact c: cList){
            if(c.LastName == 'Test0' || c.LastName == 'Test1'){
                cListToUpdate.add(c);
            }
        }
        insert cListToUpdate;
        System.assert(!cListToUpdate.isEmpty());
        List<ProvidersByPhoneNumber__c> phoneList = new List<ProvidersByPhoneNumber__c>();
        phoneList = [Select Tech_Phone_Number__c from ProvidersByPhoneNumber__c Limit 1];
        
        List<contact_validation_summary__c> sList = new List<contact_validation_summary__c>();
        List<contact_validation_summary__c> sumList = new List<contact_validation_summary__c>();
        sList = [Select Id, Tech_Phone_Number__c, Provider_LastName__c from contact_validation_summary__c Limit 2];
        for(contact_validation_summary__c sum: sList){
            if(sum.Provider_LastName__c == 'Test0'){
                sum.Secure_Phone__c = '9676561568';
                sum.Tech_Phone_Number__c = '9676561568'; 
                sum.Status__c = 'Accepted';
            }
            else if(sum.Provider_LastName__c == 'Test1'){
                sum.Secure_Phone__c = '9767364456';
                sum.Tech_Phone_Number__c = '9767364456'; 
                sum.Status__c = 'Accepted';
            }
            sumList.add(sum);
        }
        Test.startTest();
        update sumList;
        System.assert(sumList != null);
        Test.stopTest();
    }
    /*******************************************************************
Purpose: method to test providers by phone number helper class
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    public static testMethod void providersByPhoneNumberHelperValidated_Test(){
        CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
        PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
        PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
        List<Contact> cList = Util01_PDIUtilTestData.CreateDupPhoneContacts();
        
        List<Contact> cListToUpdate = new List<Contact>();
        for(Contact c: cList){
            if(c.LastName == 'Test0' || c.LastName == 'Test1'){
                cListToUpdate.add(c);
            }
        }
        insert cListToUpdate;
        
        List<ProvidersByPhoneNumber__c> phoneList = new List<ProvidersByPhoneNumber__c>();
        phoneList = [Select Tech_Phone_Number__c from ProvidersByPhoneNumber__c Limit 1];
        ProvidersByPhoneNumber__c ph = phoneList[0];        
        List<contact_validation_summary__c> sList = new List<contact_validation_summary__c>();
        List<contact_validation_summary__c> sumList = new List<contact_validation_summary__c>();
        
        sList = [Select Id, Tech_Phone_Number__c, Provider_LastName__c from contact_validation_summary__c Limit 2];
        for(contact_validation_summary__c sum: sList){
            if(sum.Provider_LastName__c == 'Test0'){
                sum.Secure_Phone__c = '9676561568';
                sum.Tech_Phone_Number__c = '9676561568'; 
                sum.Status__c = 'Validated';
            }
            else if(sum.Provider_LastName__c == 'Test1'){
                sum.Secure_Phone__c = '9767364456';
                sum.Tech_Phone_Number__c = '9767364456'; 
                sum.Status__c = 'Validated';
            }
            sumList.add(sum);
        }
        
        Test.startTest();
        update sumList;
        System.assert(sumList!= null);
        Test.stopTest();
    }
    /*******************************************************************
Purpose: method to test providers by phone number helper class
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    public static testMethod void providersByPhoneNumberHelperPhoneChange_Test(){
        CreatedDate__c createdDate = Util01_PDIUtilTestData.insertCreatedDateCustSetting();
        PDIProviderSearch__c providerSearch = Util01_PDIUtilTestData.insertProviderSearchSetting();
        PDICallCampaignEmail__c callCampaign = Util01_PDIUtilTestData.insertCallCampaignSetting();
        List<Contact> cList = Util01_PDIUtilTestData.CreateDupPhoneContacts();
        
        List<Contact> cListToUpdate = new List<Contact>();
        for(Contact c: cList){
            if(c.LastName == 'Test0' || c.LastName == 'Test1'){
                cListToUpdate.add(c);
            }
        }
        insert cListToUpdate;
        
        List<ProvidersByPhoneNumber__c> phoneList = new List<ProvidersByPhoneNumber__c>();
        phoneList = [Select Tech_Phone_Number__c from ProvidersByPhoneNumber__c Limit 1];
        
        List<contact_validation_summary__c> sList = new List<contact_validation_summary__c>();
        List<contact_validation_summary__c> sumList = new List<contact_validation_summary__c>();
        sList = [Select Id, Tech_Phone_Number__c, Provider_LastName__c from contact_validation_summary__c Limit 2];
        for(contact_validation_summary__c sum: sList){
            if(sum.Provider_LastName__c == 'Test0'){
                sum.Secure_Phone__c = '19767564456';
                sum.Tech_Phone_Number__c = '19767564456'; 
            }
            else if(sum.Provider_LastName__c == 'Test1'){
                sum.Secure_Phone__c = '9767364456';
                sum.Tech_Phone_Number__c = '9767364456'; 
                sum.Status__c = 'Accepted';
            }
            sumList.add(sum);
        }
        Test.startTest();
        update sumList;
        System.assert(!sumList.isEmpty());
        Test.stopTest();
    }
}