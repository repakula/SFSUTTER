/* 
Class Name: HighRoads_OpporutnityHelperTest 
     Author: Deloitte
     Date: 19-4-2017
     Description: Test class for HighRoads_OpportunityHelper class.
*/
@isTest
private class HighRoads_OpporutnityHelperTest {
    @testSetup
    static void testData() {
        
        
        List<SF_P2A_Market_Segments_Mapping__c> p2aList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert p2aList;
        
        //    New Collaboration Group
        CollaborationGroup chattergroup = new CollaborationGroup(Name = 'Test - ' + System.label.HR179_SHPBPAGroup, CollaborationType = 'Public');
        insert chatterGroup;
        
        
        
        //    New Account 
        Account accountS3BPA_Small_Group = new Account();
        accountS3BPA_Small_Group.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('SHP Sales Employer').RecordTypeId; 
        accountS3BPA_Small_Group.Name = 'Account Small Group';
        accountS3BPA_Small_Group.Employer_Type__c = 'Small Group (1 - 50)';
        accountS3BPA_Small_Group.Status__c = 'Prospect';
        accountS3BPA_Small_Group.Industry = 'Healthcare';
        accountS3BPA_Small_Group.NumberOfEmployees = 12;
        insert accountS3BPA_Small_Group;
        
        // Verify the Account has been inserted successfully
        System.assertNotEquals(accountS3BPA_Small_Group.Id, NULL);
        
        //    New Opportunity 
        Opportunity oppS3BPA_Small_Group1 = new Opportunity();
        oppS3BPA_Small_Group1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHP Sales Opportunity').getRecordTypeId();
        oppS3BPA_Small_Group1.Name = 'Opportunity Small Group 1';
        oppS3BPA_Small_Group1.Type = 'Existing Business';
        oppS3BPA_Small_Group1.AccountId = accountS3BPA_Small_Group.Id;
        oppS3BPA_Small_Group1.StageName =  'Pending Broker';
        oppS3BPA_Small_Group1.Current_Status__c = 'No';
        oppS3BPA_Small_Group1.CloseDate = date.parse('7/25/2016');
        insert oppS3BPA_Small_Group1;

        //   New Rider Plan
        Benefit_Plan_Metadata__c bpm4 = new Benefit_Plan_Metadata__c();
        bpm4.Name = 'XA03 - 2016';
        bpm4.Medical_OR_Rider__c = 'Rider';
        bpm4.Product_Class__c = 'Acupuncture and Chiro';
        bpm4.Effective_Date__c = Date.parse('1/1/2016');
        bpm4.End_Date__c = Date.parse('12/31/2016');
        bpm4.Market_Segment__c = 'Large Group';
        bpm4.Plan_Type__c = 'Standard';
        bpm4.Benefit_Plan_ID__c = 'XA03';
        bpm4.Plan_Status__c = 'Available for Sale - Approved';
        bpm4.Plan_Year__c = '2016';
        Insert bpm4;

        /*Associating the Benefit Plans to Opportunity record */
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm4.id;
        bpa.Raider_Id__c = bpm4.Id;
        bpa.Version_Number__c = 1;
        bpa.Opportunity__c = oppS3BPA_Small_Group1.id;
        insert bpa;
        
        Document_Generation_Request__c dgr = new Document_Generation_Request__c();
        dgr.Opportunity__c =  oppS3BPA_Small_Group1.id;      
        dgr.Status__c = System.label.HR141_Draft; 
        dgr.Request_Status__c = System.label.HR141_Draft; 
        dgr.has_Custom_Plans__c = true;
        dgr.Expedite__c = false;
        dgr.Plans__c = 'Test Plan';
        insert dgr;
    }
    
    @isTest
    static void method1() {

        Test.startTest();
        Opportunity oppS3BPA_Small_Group2 = [Select Id, StageName, RecordTypeId From Opportunity limit 1];
        oppS3BPA_Small_Group2.StageName = 'Closed Won';
        update oppS3BPA_Small_Group2;
        
        Opportunity oppS3BPA_Small_Group3 = [Select Id, StageName, RecordTypeId From Opportunity Where Id =: oppS3BPA_Small_Group2.Id];
        system.assertEquals(oppS3BPA_Small_Group3.StageName, 'Closed Won');
        oppS3BPA_Small_Group3.StageName = 'Pending Broker';
        update oppS3BPA_Small_Group3;
        Test.stopTest();
    }
}