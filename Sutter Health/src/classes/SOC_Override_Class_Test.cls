/**********************************************************************
 Name: SOC_Override_Class_Test
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for SOC_Override_Class.
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  04/20/2015  Development complete   This class is defined to test  SOC_Override_Class class.
 2.0      IDC Offshore  12/29/2015  Optimization           Incorporated changes to implement best test practices in the test class
 
 ***********************************************************************/

@isTest
private class SOC_Override_Class_Test{
    
/*******************************************************************
  Purpose: method to create test data used by all tests 
  Parameters: N/A 
  Returns: void
  Throws [Exceptions]: N/A
  ********************************************************************/  
 @testSetup
  static void createTestData() {  
        
         List<SOC_Queue__c> lstSocqueue = new List<SOC_Queue__c>();
        Contact con = new Contact();
        con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
        con.Firstname = 'Test';
        con.LastName = 'LastName';
        insert con;
        
         /*********************************************************************** 
         Verifying the Contact is created successfully using system.assert() 
         Expected Result:Contact id is not null
         Actual Result: Contact id is not null
        ***********************************************************************/
        system.assert(con.id!=null);

        case c = new case();
        c.RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Summary_of_Care).getRecordTypeId();             
        c.ContactId = con.id;
        c.status = 'New';
        insert c;
        /*********************************************************************** 
         Verifying the Case is created successfully using system.assert() 
         Expected Result:Case id is not null
         Actual Result: Case id is not null
        ***********************************************************************/
        system.assert(c.id!=null);
             
        PDV_EAF_Facility__c PDVEAF = new PDV_EAF_Facility__c();
        PDVEAF.Case__c = c.id;
        PDVEAF.Name = 'Test123';
        insert PDVEAF;
        
        /*********************************************************************** 
         Verifying the PDV_EAF_Facility__c is created successfully using system.assert() 
         Expected Result:PDV_EAF_Facility__c id is not null
         Actual Result: PDV_EAF_Facility__c id is not null
        ***********************************************************************/
        system.assert(PDVEAF.id!=null);
        
        
         /** Creating  SOC QUEUE records for testing purpose **/
        
        for(Integer i=1;i<=20;i++){
        
        SOC_Queue__c Soc = new SOC_Queue__c();
        Soc.name = 'Test';
        Soc.Provider_Facility_ID__c = con.id;
        Soc.Associated_Case_Id__c = c.Id;
        Soc.Facility_Id__c = PDVEAF.id;
        
        lstSocqueue.add(Soc);
        }
        insert lstSocqueue;
        
        /*********************************************************************** 
         Verifying the SOC_Queue__c is created successfully using system.assert() 
         Expected Result:SOC_Queue__c id is not null
         Actual Result: SOC_Queue__c id is not null
        ***********************************************************************/
        system.assert(lstSocqueue[0].id!=null);
        
        
    }
    
     /*******************************************************************
      Purpose: method to search provider for SER and EAF
      Parameters: N/A
      Returns: void
      Throws [Exceptions]: N/A
      ********************************************************************/

    static testMethod void SearchProvider_Test() {
        
        list <contact> con = [select id from contact where LastName = 'LastName'];
        
        /*********************************************************************** 
         Verifying the Contacts are fetched successfully using system.assert
         Expected Result:contact list size should be greater than zero
         Actual Result: list size is greater than zero 
        ***********************************************************************/
        system.assert(con.size()>0);
        
        test.starttest();
        SOC_Override_Class socController = new SOC_Override_Class();
        socController.providerType = 'SER';
        socController.providerFirstName = 'Test';
        socController.SearchProvider();
        
        // Executing Tests with facilityName for EAF
        SOC_Override_Class socController1 = new SOC_Override_Class();
        socController1.providerType = 'EAF';
        socController1.facilityName = 'Test';
        socController1.SearchProvider();
        socController1.isValidSearch(con);
        
        test.stoptest();   
        
    }
    
    /*******************************************************************
      Purpose: method to search provider for SER and EAF when SOC and Facilty are in queue 
      Parameters: N/A
      Returns: void
      Throws [Exceptions]: yes
      ********************************************************************/

    static testMethod void SearchProvider_NegativeTest() {
        
        
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;

        /*********************************************************************** 
         Verifying the Group is created successfully using system.assert() 
         Expected Result:Group id is not null
         Actual Result: Group id is not null
        ***********************************************************************/
        system.assert(testGroup.id!=null);
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
        QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'SOC_Queue__c');
        insert testQueue;
        
        SOC_Queue__c Soc =[select id,OwnerId from SOC_Queue__c where name = 'Test' limit 1];
        
        Soc.OwnerId = testGroup.id ;
        update Soc;
        
        SOC_Queue__c temp =[select id,OwnerId from SOC_Queue__c where name = 'Test' limit 1];
        
        /*********************************************************************** 
         Verifying the SOC Queue  is updated successfully using system.assert() 
         Expected Result:owner id is equals to  group id 
         Actual Result:owner id is equals to  group id 
        ***********************************************************************/
        system.assertequals(temp.OwnerId,testGroup.id );
        
        }
        
        try{
        
            PageReference pageRef = new PageReference('/apex/SOC_Override_VF');
            Test.setCurrentPage(pageRef);
            
            SOC_Override_Class socController = new SOC_Override_Class();
            socController.providerType = 'SER';
            socController.providerFirstName = 'Test';
            socController.faciltyID ='Test';
            socController.getFaciltySearchQuery();
            socController.isValidSearch(null);
            socController.SearchProvider();
            socController.onProviderTypeChange();
            socController.providerType = 'EAF';
            socController.onProviderTypeChange();
            

            // Executing Tests for EAF 
            SOC_Override_Class socController1 = new SOC_Override_Class();
            socController1.providerType = 'EAF';
            socController1.facilityName = 'Test';
            socController1.SearchProvider();
            socController1.getSearchResults('@@@@#$');
            
        }catch(Exception ex){
            
            system.assertEquals(ex.getMessage(), 'No results found');
        }
        
    }
    /*******************************************************************
      Purpose: method to search provider for SER and EAF when Contact and EAF Facility are not avilable with SOC queue 
      Parameters: N/A
      Returns: void
      Throws [Exceptions]: N/A
      ********************************************************************/
    
    
    static testMethod void SearchProvider_BulkTest() {
        
        list<SOC_Queue__c> lstSoc = [select id ,Facility_Id__c,Provider_Facility_ID__c from SOC_Queue__c where name = 'Test'];
        
        list<SOC_Queue__c> lstSocqueue = new list<SOC_Queue__c>();
        
        /*********************************************************************** 
         Verifying the SOC_Queue__c are fetched successfully using system.assert
         Expected Result:SOC_Queue__c size should be greater than zero
         Actual Result:SOC_Queue__c size is greater than zero 
        ***********************************************************************/
        system.assert(lstSoc.size()>0);
        
        for(SOC_Queue__c soc : lstSoc )
        {
        soc.Facility_Id__c =null;
        soc.Provider_Facility_ID__c =null;
        lstSocqueue.add(soc);
        }
        update lstSocqueue;
    
    
        /*********************************************************************** 
         Verifying the SOC_Queue__c are updated  successfully using system.assertequals
         Expected Result:Facility_Id__c  should be null
         Actual Result: Facility_Id__c is null 
        ***********************************************************************/
        system.assertequals(lstSocqueue[0].Facility_Id__c ,null);
    
    
        Test.starttest();
        
        SOC_Override_Class socController = new SOC_Override_Class();
        socController.providerType = 'SER';
        socController.providerFirstName = 'Test';
        
        socController.SearchProvider();
        
        // Executing Tests with First name
        SOC_Override_Class socController1 = new SOC_Override_Class();
        socController1.providerType = 'EAF';
        socController1.facilityName = 'Test';
        socController1.SearchProvider();
            
        Test.stoptest(); 
        
    }
    
    /*******************************************************************
      Purpose: method to search provider for SER and EAF by using a first letter only 
      Parameters: N/A
      Returns: void
      Throws [Exceptions]: N/A
      ********************************************************************/
    
    static testMethod void isValidSearch_Test() {
        
        list <contact> con = [select id from contact where LastName = 'LastName'];
        
        /*********************************************************************** 
         Verifying the Contacts are fetched successfully using system.assert
         Expected Result:contact list size should be greater than zero
         Actual Result: list size is greater than zero 
        ***********************************************************************/
        system.assert(con.size()>0);
        
        List<SObject> soList = (List<SObject>)(new List<Account>());
        
        test.starttest();
        SOC_Override_Class socController = new SOC_Override_Class();
        socController.providerType = 'SER';
        socController.providerFirstName = 'T';
        socController.isValidSearch(soList);
        socController.SearchProvider();
        
        /*********************************************************************** 
         Verifying the Search is successfull by using system.assertnotequals
         Expected Result:isValidSearch() return false 
         Actual Result: isValidSearch() return false 
        ***********************************************************************/
        
        system.assertequals(socController.isValidSearch(soList),false);
            
        
        // Executing Tests with First name
        SOC_Override_Class socController1 = new SOC_Override_Class();
        socController1.providerType = 'EAF';
        socController1.facilityName = 'T';
        socController1.SearchProvider();
         
        test.stoptest();
        
    }

}