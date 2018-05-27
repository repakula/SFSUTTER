/**********************************************************************
Name: HighRoads_RenewOpportunity_Test
Purpose: Test Class for HighRoads_RenewOpportunity Class

History
-------
VERSION         AUTHOR          DATE        DETAIL                  Description
1.0             offshore IDC    28-Nov-2016 INITIAL DEVELOPMENT     Test class covers the scenario of Renew opportunity.   
***********************************************************************/

@isTest
private class HighRoads_RenewOpportunity_Test{    
    
    /*******************************************************************
Purpose: Scenario on renew opportunity.
Parameters: [NA]
Returns: [void]
Throws [Exceptions]: [NA]
********************************************************************/
    
    static testMethod void testRenewOpportunity() {
        
        Test.StartTest();
        List<SF_P2A_Market_Segments_Mapping__c> p2aList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert p2aList;
        /* Inserting Account */
        Account accountS3BPA_Small_Group = new Account();
        accountS3BPA_Small_Group.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('SHP Sales Employer').RecordTypeId; 
        accountS3BPA_Small_Group.Name = 'Account Small Group';
        accountS3BPA_Small_Group.Employer_Type__c = 'Small Group (1 - 50)';
        accountS3BPA_Small_Group.Status__c = 'Prospect';
        accountS3BPA_Small_Group.Industry = 'Healthcare';
        accountS3BPA_Small_Group.NumberOfEmployees = 12;
        insert accountS3BPA_Small_Group;
        /* Verify the Account has been inserted successfully */
        System.assertNotEquals(accountS3BPA_Small_Group.Id, NULL);
        
        /*Inserting Opportunity */
        Opportunity oppS3BPA_Small_Group1 = new Opportunity();
        oppS3BPA_Small_Group1.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('SHP Sales Opportunity').RecordTypeId; 
        oppS3BPA_Small_Group1.Name = 'Opportunity Small Group 1';
        oppS3BPA_Small_Group1.Type = 'Existing Business';
        oppS3BPA_Small_Group1.AccountId = accountS3BPA_Small_Group.Id;
        oppS3BPA_Small_Group1.StageName =  'Pending Broker';
        oppS3BPA_Small_Group1.Current_Status__c = 'No';
        oppS3BPA_Small_Group1.CloseDate = date.parse('7/25/2016');
        insert oppS3BPA_Small_Group1;
        /* Verify the Opportunity has been inserted successfully */
        System.assertNotEquals(oppS3BPA_Small_Group1.Id, NULL);
        
        //Checking the RenewOpportunity
        Test.setCurrentPageReference(new PageReference('Page.HighRoads_RenewalOpportunity')); 
        System.currentPageReference().getParameters().put('Id', accountS3BPA_Small_Group.Id);
        HighRoads_RenewOpportunity objHighRoadsRenewOpportunity = new HighRoads_RenewOpportunity();
        PageReference pr = objHighRoadsRenewOpportunity.isOpportunityExists(); 
        
        System.AssertEquals(pr, NULL);
        
        Employer_Group_Data__c scn = new Employer_Group_Data__c();
        scn.Opportunity__c = oppS3BPA_Small_Group1.Id;
        Insert scn;
        
        oppS3BPA_Small_Group1.StageName = 'Closed Won'; 
        update oppS3BPA_Small_Group1;
        
        /* Inserting the Metadata */
        List<Benefit_Plan_Metadata__c> bpmList = new List<Benefit_Plan_Metadata__c>();
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Ancillary_EOC__c = false;
        bpm.Ancillary_GSA__c = false;
        bpm.Ancillary_SOB__c = false;
        bpm.EOC__c = true;
        bpm.BCM__c = true;
        bpm.SBC__c = true;
        bpm.Benefit_Plan_ID__c = 'HE02';
        bpm.Plan_Status__c = 'Available for Sale - Approved';
        bpm.Plan_Year__c = '2016';
        bpmList.add(bpm);
        
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02 - 2016';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = Date.parse('1/1/2016');
        bpm1.End_Date__c = Date.parse('12/31/2016');
        bpm1.Market_Segment__c = 'Large Group';
        bpm1.Plan_Type__c = 'Standard';
        bpm1.Ancillary_EOC__c = true;
        bpm1.Ancillary_GSA__c = true;
        bpm1.Ancillary_SOB__c = true;
        bpm1.EOC__c = true;
        bpm1.BCM__c = true;
        bpm1.SBC__c = true;
        bpm1.Benefit_Plan_ID__c = 'XA02';
        bpm1.Plan_Status__c = 'Available for Sale - Approved';
        bpm1.Plan_Year__c = '2016';
        bpmList.add(bpm1);
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Effective_Date__c = Date.parse('1/1/2016');
        bpm2.End_Date__c = Date.parse('12/31/2016');
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Custom';
        bpm2.Ancillary_EOC__c = true;
        bpm2.Ancillary_GSA__c = true;
        bpm2.Ancillary_SOB__c = true;
        bpm2.EOC__c = false;
        bpm2.BCM__c = false;
        bpm2.SBC__c = false;
        bpm2.Benefit_Plan_ID__c = 'ML02';
        bpm2.Plan_Status__c = 'Available for Sale - Approved';
        bpm2.Plan_Year__c = '2016';
        bpmList.add(bpm2);
        
        Benefit_Plan_Metadata__c bpm3 = new Benefit_Plan_Metadata__c();
        bpm3.Name = 'XA16 - 2016';
        bpm3.Medical_OR_Rider__c = 'Rider';
        bpm3.Product_Class__c = 'Acupuncture and Chiro';
        bpm3.Effective_Date__c = Date.parse('1/1/2016');
        bpm3.End_Date__c = Date.parse('12/31/2016');
        bpm3.Market_Segment__c = 'Large Group';
        bpm3.Plan_Type__c = 'Standard';
        bpm3.Ancillary_EOC__c = true;
        bpm3.Ancillary_GSA__c = true;
        bpm3.Ancillary_SOB__c = true;
        bpm3.EOC__c = true;
        bpm3.BCM__c = true;
        bpm3.SBC__c = true;
        bpm3.Benefit_Plan_ID__c = 'XA16';
        bpm3.Plan_Status__c = 'Available for Sale - Approved';
        bpm3.Plan_Year__c = '2016';
        bpmList.add(bpm3);
        
        /* Creating the Next year Plans */
        Benefit_Plan_Metadata__c bpm4 = new Benefit_Plan_Metadata__c();
        bpm4.Name = 'HE02 - 2017';
        bpm4.Medical_OR_Rider__c = 'Medical';
        bpm4.Product_Class__c = 'Medical';
        bpm4.Effective_Date__c = Date.parse('1/1/2017');
        bpm4.End_Date__c = Date.parse('12/31/2017');
        bpm4.Market_Segment__c = 'Large Group';
        bpm4.Plan_Type__c = 'Standard';
        bpm4.Ancillary_EOC__c = false;
        bpm4.Ancillary_GSA__c = false;
        bpm4.Ancillary_SOB__c = false;
        bpm4.EOC__c = true;
        bpm4.BCM__c = true;
        bpm4.SBC__c = true;
        bpm4.Benefit_Plan_ID__c = 'HE02';
        bpm4.Plan_Status__c = 'Available for Sale - Approved';
        bpm4.Plan_Year__c = '2017';
        bpm4.Previous_Year_Plan_Id__c = 'HE02';
        bpmList.add(bpm4);
        
        Benefit_Plan_Metadata__c bpm5 = new Benefit_Plan_Metadata__c();
        bpm5.Name = 'XA02 - 2017';
        bpm5.Medical_OR_Rider__c = 'Rider';
        bpm5.Product_Class__c = 'Acupuncture and Chiro';
        bpm5.Effective_Date__c = Date.parse('1/1/2017');
        bpm5.End_Date__c = Date.parse('12/31/2017');
        bpm5.Market_Segment__c = 'Large Group';
        bpm5.Plan_Type__c = 'Standard';
        bpm5.Ancillary_EOC__c = true;
        bpm5.Ancillary_GSA__c = true;
        bpm5.Ancillary_SOB__c = true;
        bpm5.EOC__c = true;
        bpm5.BCM__c = true;
        bpm5.SBC__c = true;
        bpm5.Benefit_Plan_ID__c = 'XA02';
        bpm5.Plan_Status__c = 'Available for Sale - Approved';
        bpm5.Plan_Year__c = '2017';
        bpm5.Previous_Year_Plan_Id__c = 'XA02';
        bpmList.add(bpm5);
        
        Benefit_Plan_Metadata__c bpm6 = new Benefit_Plan_Metadata__c();
        bpm6.Name = 'ML02';
        bpm6.Medical_OR_Rider__c = 'Medical';
        bpm6.Product_Class__c = 'Medical';
        bpm6.Effective_Date__c = Date.parse('1/1/2017');
        bpm6.End_Date__c = Date.parse('12/31/2017');
        bpm6.Market_Segment__c = 'Large Group';
        bpm6.Plan_Type__c = 'Standard';
        bpm6.Ancillary_EOC__c = true;
        bpm6.Ancillary_GSA__c = true;
        bpm6.Ancillary_SOB__c = true;
        bpm6.EOC__c = false;
        bpm6.BCM__c = false;
        bpm6.SBC__c = false;
        bpm6.Benefit_Plan_ID__c = 'ML02';
        bpm6.Plan_Status__c = 'Available for Sale - Approved';
        bpm6.Plan_Year__c = '2017';
        bpm6.Previous_Year_Plan_Id__c = 'ML02';
        bpmList.add(bpm6);
        
        Benefit_Plan_Metadata__c bpm7 = new Benefit_Plan_Metadata__c();
        bpm7.Name = 'XA16 - 2017';
        bpm7.Medical_OR_Rider__c = 'Rider';
        bpm7.Product_Class__c = 'Acupuncture and Chiro';
        bpm7.Effective_Date__c = Date.parse('1/1/2017');
        bpm7.End_Date__c = Date.parse('12/31/2017');
        bpm7.Market_Segment__c = 'Large Group';
        bpm7.Plan_Type__c = 'Standard';
        bpm7.Ancillary_EOC__c = true;
        bpm7.Ancillary_GSA__c = true;
        bpm7.Ancillary_SOB__c = true;
        bpm7.EOC__c = true;
        bpm7.BCM__c = true;
        bpm7.SBC__c = true;
        bpm7.Benefit_Plan_ID__c = 'XA16';
        bpm7.Plan_Status__c = 'Available for Sale - Approved';
        bpm7.Plan_Year__c = '2017';
        bpm7.Previous_Year_Plan_Id__c = 'XA16';
        bpmList.add(bpm7);
        
        
        Insert bpmList;
        /* verity all benefit plan metadata records are inserted succesfully or not */
        System.assertEquals(8, bpmList.size());
        
        /* Inserting the benefit plan association records */
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Name = bpmList[0].Name;
        bpa.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa.Opportunity__c = oppS3BPA_Small_Group1.Id;
        bpa.Sold_Case_Notification__c = scn.Id;
        bpaList.add(bpa);
        
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Name = bpmList[0].Name;
        bpa1.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa1.Raider_ID__c = bpmList[1].Id;
        bpa1.Opportunity__c = oppS3BPA_Small_Group1.Id;
        
        bpaList.add(bpa1);
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Name = bpmList[0].Name;
        bpa2.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa2.Raider_ID__c = bpmList[3].Id;
        bpa2.Opportunity__c = oppS3BPA_Small_Group1.Id;
        
        bpaList.add(bpa2);
        
        Insert bpaList;
        /* Verify the benefit plan association records are successfully inserted or not */
        System.assertEquals(3, bpaList.size());
        
        Rate_Card__c rc = new Rate_Card__c();
        insert rc;
        /*Verifying the Rate Card is inserted successfully or not */
        System.assertNotEquals(rc.Id, NULL);
        
        Rates__c rate = new Rates__c();
        rate.Rate_Card_ID__c = rc.Id;
        rate.Sold_Case_Notification__c = scn.id;
        rate.Plan_Name__c = 'HE02 - 2016'; 
        rate.Tier_Type__c = 'Tier 1';
        rate.Group_Type__c = 'Active';
        
        rate.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_Medical';
        rate.Plan_Type_Tier_Group__c = scn.id+'_HE02 - 2016_Medical_Tier 1_Active';
        insert rate; 
        
        Rates__c rate1 = new Rates__c();
        rate1.Rate_Card_ID__c = rc.Id;
        rate1.Sold_Case_Notification__c = scn.id;
        rate1.Tier_Type__c = 'Tier 1';
        rate1.Group_Type__c = 'Active';
        
        rate1.Medical_Plan_Rider_Plan__c = 'HE02 - 2016_XA02 - 2016';
        rate1.Plan_Type_Tier_Group__c = scn.id+'_HE02 - 2016_XA02 - 2016_Tier 1_Active';
        rate1.Plan_Name__c = 'HE02 - 2016'; 
        
        insert rate1; 
        
        //Updating the rate card and account details in the benefit plan association
        List<Benefit_Plan_Association__c> updateList = new List<Benefit_Plan_Association__c>();
        for(Benefit_Plan_Association__c bpaObj : bpaList){
            bpaObj.Sold_Case_Notification__c = scn.Id;
            bpaObj.Account__c = accountS3BPA_Small_Group.Id;
            bpaObj.SCN_Rate_Card__c = rc.Id;
            updateList.add(bpaObj);
        }
        update updateList;
        
        /*Checking renew opportunity after asociating the plans  and rates at Account Level */
        
        Test.setCurrentPageReference(new PageReference('Page.HighRoads_RenewalOpportunity')); 
        System.currentPageReference().getParameters().put('Id', accountS3BPA_Small_Group.Id);
        HighRoads_RenewOpportunity objHighRoadsRenewOpportunity1 = new HighRoads_RenewOpportunity();
        
        PageReference pr1 = objHighRoadsRenewOpportunity1.isOpportunityExists(); 
        System.AssertEquals(pr1, NULL);
        
        PageReference redirectToOppPageReference = objHighRoadsRenewOpportunity1.redirectToOpp();
        
        PageReference p = objHighRoadsRenewOpportunity1.renewOpportunity();
        System.AssertEquals(p,NULL);
        
    }
    /*******************************************************************
Purpose: Test the renew opportunity when account there is no renewal opportunities for the existing plans
Parameters: [NA]
Returns: [void]
Throws [Exceptions]: [NA]
********************************************************************/
    
    static testMethod void testRenewOpportunityWithoutRenewalPlans() {
        
        Test.StartTest();
        List<SF_P2A_Market_Segments_Mapping__c> p2aList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert p2aList;
        /* Inserting Account */
        Account accountS3BPA_Small_Group = new Account();
        accountS3BPA_Small_Group.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('SHP Sales Employer').RecordTypeId; 
        accountS3BPA_Small_Group.Name = 'Account Small Group';
        accountS3BPA_Small_Group.Employer_Type__c = 'Small Group (1 - 50)';
        accountS3BPA_Small_Group.Status__c = 'Prospect';
        accountS3BPA_Small_Group.Industry = 'Healthcare';
        accountS3BPA_Small_Group.NumberOfEmployees = 12;
        insert accountS3BPA_Small_Group;
        /* Verify the Account has been inserted successfully */
        System.assertNotEquals(accountS3BPA_Small_Group.Id, NULL);
        
        /*Inserting Opportunity */
        Opportunity oppS3BPA_Small_Group1 = new Opportunity();
        oppS3BPA_Small_Group1.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('SHP Sales Opportunity').RecordTypeId; 
        oppS3BPA_Small_Group1.Name = 'Opportunity Small Group 1';
        oppS3BPA_Small_Group1.Type = 'Existing Business';
        oppS3BPA_Small_Group1.AccountId = accountS3BPA_Small_Group.Id;
        oppS3BPA_Small_Group1.StageName =  'Pending Broker';
        oppS3BPA_Small_Group1.Current_Status__c = 'No';
        oppS3BPA_Small_Group1.CloseDate = date.parse('7/25/2016');
        insert oppS3BPA_Small_Group1;
        /* Verify the Opportunity has been inserted successfully */
        System.assertNotEquals(oppS3BPA_Small_Group1.Id, NULL);
        
        oppS3BPA_Small_Group1.StageName = 'Closed Won'; 
        update oppS3BPA_Small_Group1;
        
        Employer_Group_Data__c scn = new Employer_Group_Data__c();
        scn.Opportunity__c = oppS3BPA_Small_Group1.Id;
        Insert scn;
        
        /* Inserting the Metadata */
        List<Benefit_Plan_Metadata__c> bpmList = new List<Benefit_Plan_Metadata__c>();
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Ancillary_EOC__c = false;
        bpm.Ancillary_GSA__c = false;
        bpm.Ancillary_SOB__c = false;
        bpm.EOC__c = true;
        bpm.BCM__c = true;
        bpm.SBC__c = true;
        bpm.Benefit_Plan_ID__c = 'HE02';
        bpm.Plan_Status__c = 'Available for Sale - Approved';
        bpm.Plan_Year__c = '2016';
        bpmList.add(bpm);
        
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02 - 2016';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = Date.parse('1/1/2016');
        bpm1.End_Date__c = Date.parse('12/31/2016');
        bpm1.Market_Segment__c = 'Large Group';
        bpm1.Plan_Type__c = 'Standard';
        bpm1.Ancillary_EOC__c = true;
        bpm1.Ancillary_GSA__c = true;
        bpm1.Ancillary_SOB__c = true;
        bpm1.EOC__c = true;
        bpm1.BCM__c = true;
        bpm1.SBC__c = true;
        bpm1.Benefit_Plan_ID__c = 'XA02';
        bpm1.Plan_Status__c = 'Available for Sale - Approved';
        bpm1.Plan_Year__c = '2016';
        bpmList.add(bpm1);
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Effective_Date__c = Date.parse('1/1/2016');
        bpm2.End_Date__c = Date.parse('12/31/2016');
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Custom';
        bpm2.Ancillary_EOC__c = true;
        bpm2.Ancillary_GSA__c = true;
        bpm2.Ancillary_SOB__c = true;
        bpm2.EOC__c = false;
        bpm2.BCM__c = false;
        bpm2.SBC__c = false;
        bpm2.Benefit_Plan_ID__c = 'ML02';
        bpm2.Plan_Status__c = 'Available for Sale - Approved';
        bpm2.Plan_Year__c = '2016';
        bpmList.add(bpm2);
        
        Benefit_Plan_Metadata__c bpm3 = new Benefit_Plan_Metadata__c();
        bpm3.Name = 'XA16 - 2016';
        bpm3.Medical_OR_Rider__c = 'Rider';
        bpm3.Product_Class__c = 'Acupuncture and Chiro';
        bpm3.Effective_Date__c = Date.parse('1/1/2016');
        bpm3.End_Date__c = Date.parse('12/31/2016');
        bpm3.Market_Segment__c = 'Large Group';
        bpm3.Plan_Type__c = 'Standard';
        bpm3.Ancillary_EOC__c = true;
        bpm3.Ancillary_GSA__c = true;
        bpm3.Ancillary_SOB__c = true;
        bpm3.EOC__c = true;
        bpm3.BCM__c = true;
        bpm3.SBC__c = true;
        bpm3.Benefit_Plan_ID__c = 'XA16';
        bpm3.Plan_Status__c = 'Available for Sale - Approved';
        bpm3.Plan_Year__c = '2016';
        bpmList.add(bpm3);
        
        Insert bpmList;
        
        /* verity all benefit plan metadata records are inserted succesfully or not */
        System.assertEquals(4, bpmList.size());
        
        /* Inserting the benefit plan association records */
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Name = bpmList[0].Name;
        bpa.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa.Opportunity__c = oppS3BPA_Small_Group1.Id;
        bpa.Sold_Case_Notification__c = scn.Id;
        bpaList.add(bpa);
        
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Name = bpmList[0].Name;
        bpa1.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa1.Raider_ID__c = bpmList[1].Id;
        bpa1.Opportunity__c = oppS3BPA_Small_Group1.Id;
        
        bpaList.add(bpa1);
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Name = bpmList[0].Name;
        bpa2.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa2.Raider_ID__c = bpmList[3].Id;
        bpa2.Opportunity__c = oppS3BPA_Small_Group1.Id;
        
        bpaList.add(bpa2);
        
        Insert bpaList;
        /* Verify the benefit plan association records are successfully inserted or not */
        System.assertEquals(3, bpaList.size());
        
        //Updating the rate card and account details in the benefit plan association
        List<Benefit_Plan_Association__c> updateList = new List<Benefit_Plan_Association__c>();
        for(Benefit_Plan_Association__c bpaObj : bpaList){
            bpaObj.Sold_Case_Notification__c = scn.Id;
            bpaObj.Account__c = accountS3BPA_Small_Group.Id;
            updateList.add(bpaObj);
        }
        update updateList;
        
        /*Checking renew opportunity after asociating the plans  and rates at Account Level */
        
        Test.setCurrentPageReference(new PageReference('Page.HighRoads_RenewalOpportunity')); 
        System.currentPageReference().getParameters().put('Id', accountS3BPA_Small_Group.Id);
        HighRoads_RenewOpportunity objHighRoadsRenewOpportunity1 = new HighRoads_RenewOpportunity();
               
        PageReference p = objHighRoadsRenewOpportunity1.renewOpportunity();
        System.debug('pLLLLLLLLLLLLLL'+p);
        System.AssertEquals(p,NULL);
    }    
}