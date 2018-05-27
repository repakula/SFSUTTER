/* 
     Class Name: DocGenRequest_Trigger_Test 
     Author: IDC Offshore
     Date: 06-Dec-2016
     Description: Test class for DocGenRequest_Trigger Trigger.
*/
@isTest 
private class DocGenRequest_Trigger_Test {   
  
    private static Document_Generation_Request__c dgr,dgr1,dgr2;
    private static Account acc;
    private static Opportunity opp,opp1;
    private static Benefit_Plan_Association__c bpa;
    private static Benefit_Plan_Metadata__c bpm;
    private static SHP_Benefit_Grid__c grid;
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
  private static Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHP Sales Opportunity').getRecordTypeId();
  
    private static testMethod void testController(){
        
        List<SF_P2A_Market_Segments_Mapping__c> p2aList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert p2aList;
        
        acc = new Account();
        acc.Name = 'TestAcc1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Labor and Trust';
        insert acc;
        
        opp = new Opportunity();
        opp.Name = 'TestOpp1';
        opp.RecordTypeId = oppRecordTypeId;
        opp.AccountId = acc.id;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today();
        opp.StageName = 'Closed Won';
        insert opp;
        
        dgr = new Document_Generation_Request__c();
    dgr.Opportunity__c =  opp.id;      
    dgr.Status__c = System.label.HR141_Draft; 
        dgr.Request_Status__c = System.label.HR141_Draft; 
        dgr.has_Custom_Plans__c = true;
        dgr.Expedite__c = false;
        insert dgr;
    
      Test.startTest();
    
             // BusinessHours busHours=[select id from BusinessHours where Name =:System.label.HR138_SHPBusinessHours limit 1];
          dgr.Status__c = System.label.HR139_OnHold;
          dgr.Request_Status__c = System.label.HR140_Approved;
          update dgr;
          dgr1 = [Select id, Request_Due_Date__c, Request_Approved_Date__c from Document_Generation_Request__c where Opportunity__c = :dgr.Opportunity__c];
          system.assertEquals(NULL,dgr1.Request_Due_Date__c);
          system.assertEquals(System.today(),dgr1.Request_Approved_Date__c);
          dgr.has_Custom_Plans__c = false;
            dgr.Expedite__c = false;
      dgr.Status__c = System.label.HR141_Draft;
          update dgr;
          /*dgr1 = [Select id, Request_Due_Date__c, Request_Created_Date__c from Document_Generation_Request__c where Opportunity__c = :dgr.Opportunity__c];
          system.assertEquals(Date.valueOf(BusinessHours.add(busHours.id,dgr1.Request_Created_Date__c,97200000)),dgr1.Request_Due_Date__c);*/
            dgr.Expedite__c = true;
          update dgr;
            dgr.Expedite__c = false;
          update dgr;
            
            dgr.Status__c = System.label.HR139_OnHold;
            dgr.Expedite__c = true;
          update dgr;
          system.assertEquals(NULL,dgr1.Request_Due_Date__c);
      dgr.Status__c = System.label.HR141_Draft;
          update dgr;
        
        Test.stopTest();
    }
}