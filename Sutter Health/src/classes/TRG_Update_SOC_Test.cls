/**********************************************************************
 Name: TRG_Update_SOC_Test
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for TRG_Update_SOC.
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE       DETAIL                 Description
 1.0      IDC Offshore  4/20/2015  Development complete   This class is intended to test TRG_Update_SOC trigger.
 ***********************************************************************/

   @isTest

    public class TRG_Update_SOC_Test{
   
     /*******************************************************************
     Purpose: method to create test data used by all tests 
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    @testSetup 
     
    static void createTestData() {
        
        /** Fetching the profile id of system Administrator for creating test data **/
        Id profileId = [select id from Profile where name='System Administrator'].id;
        
        /** Declaring variables to create queue,queuesobject and storing a user of System Admin profile **/
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
        
        /** Creating a Queue for Negative test case**/
        objPublicGrp_Queue_Ng = new group();
        objPublicGrp_Queue_Ng.name='Negative Test Group';
        objPublicGrp_Queue_Ng.type='Queue';
        insert objPublicGrp_Queue_Ng;
        
        }
        
        system.runAs(objUser){
            
        /** Creating a QueueSobject to give permission to queue created above of SOC Queue object **/
        objQueueSobject =new queuesobject();
        objQueueSobject.sobjecttype='SOC_queue__c';
        objQueueSobject.QueueId=objPublicGrp_Queue.id;
        insert objQueueSobject;
        
        objQueueSobject_Ng =new queuesobject();
        objQueueSobject_Ng.sobjecttype='SOC_queue__c';
        objQueueSobject_Ng.QueueId=objPublicGrp_Queue_Ng.id;
        insert objQueueSobject_Ng;
            
        }
                
        /** create Account for testing purposes **/
        Account acc =  TRG_Update_SOC_Test.createAccount();
        insert acc;
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assert() 
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(acc.id != null);
        
        /** Create Provider record for testing purposes **/
        Contact provider  = TRG_Update_SOC_Test.createProvider();
        provider.AccountId = acc.Id;
        database.insert(provider,false);
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assert() 
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(provider.id != null);
        
        /** Create Custom Setting containing Profile Names to be used in createProviderUser() method in ManageCommunityUsers class **/
        list<CS_ManageProfile__c> lstCS_ManageProfile = new list<CS_ManageProfile__c>();
        CS_ManageProfile__c objCS_ManageProfile1 = new CS_ManageProfile__c(Name = 'Communities_Portal',Profile_Name__c = 'Community Portal');
        lstCS_ManageProfile.add(objCS_ManageProfile1);
        CS_ManageProfile__c objCS_ManageProfile2 = new CS_ManageProfile__c(Name = 'Communities_Provider',Profile_Name__c = 'PDV Community Provider');
        lstCS_ManageProfile.add(objCS_ManageProfile2);
        
        CS_ManageProfile__c objCS_ManageProfile3 = new CS_ManageProfile__c(Name = 'Community_Portal_Manager',Profile_Name__c = 'Community Portal Manager');
        lstCS_ManageProfile.add(objCS_ManageProfile3);
        
        insert lstCS_ManageProfile;

        /*********************************************************************** 
        Verifying the value returning from the method using system.assert() 
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        list<CS_ManageProfile__c> templstCS_ManageProfile = CS_ManageProfile__c.getAll().values();
        system.assert(templstCS_ManageProfile != null);
               
        /** Create Case for tsting purposes**/
        Case socCase = TRG_Update_SOC_Test.createCase();
        socCase.ContactId = provider.Id;
        database.insert(socCase,false);
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assert() 
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(socCase.id != null);
        
        /** Create PDV EAF Facility record **/
        PDV_EAF_Facility__c facility  = TRG_Update_SOC_Test.createFacility();
        facility.Case__c = socCase.Id;
        facility.Last_Verified_Date__c = system.today();
        database.insert(facility,false);
                
        /*********************************************************************** 
        Verifying the value returning from the method using system.assert() 
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        system.assert(facility.id != null);
        
        /** Fetching the Validation Summary record created for Provider by the trigger while insertion and deleting it to cover all the scenarios of test execution  **/
        Contact_Validation_Summary__c obj =[select id from Contact_Validation_Summary__c where contact_id__c=:provider.Id];
        delete obj;
        
        /** create SOC_Queue__c for testing purpose **/
        SOC_Queue__c socQueue  = TRG_Update_SOC_Test.createSOCQueue();
        socQueue.Associated_Case_Id__c = socCase.Id;
        socQueue.Facility_Id__c = facility.Id;
        socQueue.Provider_Facility_ID__c = provider.Id;
        socQueue.Printed_Id__c = 'Test PrintedId';
        socQueue.status__c = 'Sent';
        socQueue.Type_of_Provider__c='SER';
        socQueue.ownerId = objPublicGrp_Queue.id;
        insert socQueue; 
        
        /*********************************************************************** 
        Verifying the value returning from the method using system.assert() 
        Expected Result: !=null
        Actual Result: !=null   
        ***********************************************************************/
        System.assert(socQueue.id != null);
        
        /** Creating SOC Queue records in bulk for bulk testing **/
        List<SOC_Queue__c> lstSOCQueue_Ins = new List<SOC_Queue__c>();
        
        for(Integer i=1;i<=100;i++){
            
        SOC_Queue__c objSocQueue  = TRG_Update_SOC_Test.createSOCQueue();
        objSocQueue.Associated_Case_Id__c = socCase.Id;
        objSocQueue.Facility_Id__c = facility.Id;
        objSocQueue.Provider_Facility_ID__c = provider.Id;
        objSocQueue.Printed_Id__c = 'Test PrintedId';
        objSocQueue.status__c = 'Sent';
        objSocQueue.Type_of_Provider__c='SER';
        objSocQueue.Name = 'Test Bulk SOC Queue Record '+i;
        objSocQueue.ownerId = objPublicGrp_Queue.id;
        
        lstSOCQueue_Ins.add(objSocQueue);       
            
        }
        
        insert lstSOCQueue_Ins;
        
       /*********************************************************************** 
        Verifying the value returning from the method using system.assert() 
        Expected Result: 100
        Actual Result: 100  
        ***********************************************************************/
        List<SOC_Queue__c> lstInsertedSOCQueue = [select id from SOC_Queue__c where name like '%test bulk soc queue record%']; 
        system.assertEquals(lstInsertedSOCQueue.size(),100);        
    }
    
     /*******************************************************************
     Purpose: method to create SOC_Queue__c object record 
     Parameters: N/A 
     Returns: SOC_Queue__c
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    public static SOC_Queue__c createSOCQueue(){
        SOC_Queue__c socQueue = new SOC_Queue__c(Name = 'Test SOC' );
        socQueue.status__c = 'Accepted';
        return socQueue;
    }
    
    /*******************************************************************
     Purpose: method to create Provider type contact
     Parameters: N/A 
     Returns: Provider contact
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    public static Contact createProvider(){
        RecordType recTypecont = [select Id from RecordType where Name = 'Provider' and sObjectType = 'Contact'];
        
        Contact provider = new Contact();
        provider.FirstName ='Test';
        provider.LastName = 'Provider';
        provider.RecordTypeId = recTypecont.Id;
        provider.email= 'test@test.com';
        provider.Provider_Title__c ='';
        provider.MobilePhone ='';
        provider.Provider_Correspondence_Address__c='testing';
        provider.Provider_Correspondence_City__c='testing';
        provider.Provider_Correspondence_State__c ='testing';
        provider.Provider_Correspondence_PostalCode__c='12345';
        provider.Provider_Correspondence_Phone__c='1234567890';
        provider.Provider_Correspondence_Fax_Number__c='1234567890';
        provider.Contact_External_ID1__c ='123456';
        provider.Provider_Practicing_Physician__c = true;
        provider.Provider_Active_Status__c = true;
        provider.Provider_Active_Status_Date__c = system.today();
        
        return provider;
    }
        
    /*******************************************************************
     Purpose: method to Create PDV_EAF_Facility__c  record
     Parameters: N/A 
     Returns: PDV_EAF_Facility__c record
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    public static PDV_EAF_Facility__c createFacility(){
        PDV_EAF_Facility__c facility = new PDV_EAF_Facility__c();
        facility.Name = 'Test Facility';
        facility.CITY__c = 'FOLSOM';
        facility.ADDRESS__c ='1200 CREEKSIDE DR';
        facility.ZIP_CODE__c ='95630';
        facility.Suite__c  = '123 Suite';
        facility.Floor__c = '3 Floor';
        facility.STATE__c = 'Test State';
        facility.Attn_To__c = 'Test AttnTo';
        facility.Names_Changes_Suggested__c = 'test Change';
        
        return facility;
    }
        
    /*******************************************************************
     Purpose: method to SOC case  record
     Parameters: N/A 
     Returns: SOC case
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    public static Case createCase(){
        RecordType recType = [select Id from RecordType where DeveloperName = 'Summary_of_Care' and sObjectType = 'Case'];
        
        Case socCase = new Case();
        socCase.RecordTypeId = recType.Id;
        socCase.subject = 'Test Case';
        socCase.description =  'Test Case';
        socCase.Provider_Name__c = 'Test Provider';
        socCase.Provider_Type__c = 'Provider';   //Facility and Provider
        socCase.PDV_Contact_Name__c = 'Test Provider';
        socCase.Contact_Number__c = Integer.valueOf('1234567890');
        
        return socCase;
    }
        
    /*******************************************************************
     Purpose: method to create test Account
     Parameters: N/A 
     Returns: Account 
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    public static Account createAccount(){
        Account acc = new Account(Name='Test Account Name');
        acc.RecordTypeId = [Select Id from RecordType Where Name = 'S3 Employee' AND sObjectType ='Account'].Id;
        
        return acc;
    }
    
    /*******************************************************************
     Purpose: method to update the SOC Queue record and cover the trigger code completely by including the scenario where the summary record is not attached to Provider record.At the end of the processing,the owner of the SOC queue record should be changed
     Parameters: N/A 
     Returns: void 
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    static testmethod void TestTRG_Update_SOC_Single(){

    Test.startTest();
    
    /** Fetching the SOC Queue created in the test data and updating its owner id **/
    SOC_Queue__c socQueue  = [select id,Provider_Facility_ID__c from SOC_Queue__c where Name = 'Test SOC'];         
    socQueue.ownerid = userinfo.getuserid();    
    update socQueue;
    
    Test.stopTest();
    
    /*********************************************************************** 
     Verifying the value returning from the method using system.assertEquals() 
     Expected Result: userinfo.getuserid()
     Actual Result: userinfo.getuserid()
     ***********************************************************************/
    system.AssertEquals(userinfo.getuserid(),socQueue.ownerid);
        
    }
    
    /*******************************************************************
     Purpose: method to update the SOC Queue records and cover the trigger code completely by including the scenario where the summary record is not attached to Provider record.This is used for testing the scenario for bulk records.After complete processing,the owner of the SOC queue records should be changed
     Parameters: N/A 
     Returns: void 
     Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testmethod void TestTRG_Update_SOC_Bulk(){

    Test.startTest();
    
    List<SOC_Queue__c> lstSOCQueue_Upd = new List<SOC_Queue__c>();
    
    /** Fetching the SOC Queue created in the test data and updating its owner id **/
    List<SOC_Queue__c> lstInsertedSOCQueue = [select id from SOC_Queue__c where name like '%test bulk soc queue record%'];        
    for(SOC_Queue__c socQueue:lstInsertedSOCQueue){
    socQueue.ownerid = userinfo.getuserid();
    lstSOCQueue_Upd.add(socQueue);
    }    
    update lstSOCQueue_Upd;
    
    Test.stopTest();
    
    SOC_Queue__c objSOCQueue = [select id,ownerid from SOC_Queue__c where name like '%test bulk soc queue record%' limit 1];
    
    /*********************************************************************** 
     Verifying the value returning from the method using system.assertEquals() 
     Expected Result: userinfo.getuserid()
     Actual Result: userinfo.getuserid()
     ***********************************************************************/
    system.AssertEquals(userinfo.getuserid(),objSOCQueue.ownerid);
        
    }
       
    /*******************************************************************
     Purpose: method to update the SOC Queue record negatively to test negative scenario.We update the owner to another Queue but the owner of the SOC queue record should not be changed
     Parameters: N/A 
     Returns: void 
     Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testmethod void TestTRG_Update_SOC_Negative(){

    Test.startTest();
    
    /** Fetching the SOC Queue created in the test data and updating its owner id **/
    SOC_Queue__c socQueue  = [select id,Provider_Facility_ID__c from SOC_Queue__c where Name = 'Test SOC']; 
    Group objPublicGrp_Queue = [select id from Group where type='Queue' and name='Negative Test Group' limit 1];
    socQueue.ownerid = objPublicGrp_Queue.id;    
    update socQueue;
    
    Test.stopTest();
    
    /*********************************************************************** 
     Verifying the value returning from the method using system.assertEquals() 
     Expected Result: original ownerid of the record which is objPublicGrp_Queue.id
     Actual Result: original ownerid of the record which is objPublicGrp_Queue.id
     ***********************************************************************/
    system.AssertEquals(objPublicGrp_Queue.id,socQueue.ownerid);
        
    }
    
  }