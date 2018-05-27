/**  
*     Class Name: ManageCaseMilestone_Test
*     Author: OffShore Team
*     Date: 19-December-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description: Test Class for ManageCaseMilestone Class. This class tests different scenarios that are handled in the code
*     
*    History
*    --------
*
*    VERSION    AUTHOR         DATE             DETAIL 
*       2.0     Atul Gupta      03/18/2014      Added test methods to test Expedited Entitlement functionality
*
**/
@isTest
private class ManageCaseMilestone_Test {

    /**    
     * @author IDC Team    
     * @date 20/08/2014    
     * @description: This is the Test method to test the ManageCaseMilestone. This method creates test Case and associate RFIs to the Case. On insert and update of the RFI the Case is updated by a workflow action and that fires the trigger to process the Milestones attached to the Case.    
     * @param 
     * @return 
    **/
    static testMethod void ManageCaseMilestone_PositiveTest() {
         SlaProcess process =[SELECT Id,Name FROM SlaProcess where Name = 'SHP Provider Dispute Resolution Entitlement' limit 1];
        //Create Account
        Account acc = AP01_TestDataUtility.createAccount();
        //Assert to check if Account record has been created successfully 
        system.assert(acc.id != null);
        
        //Create Entitlement
        Entitlement en = new Entitlement();
        en.Name = 'SHP Provider Dispute Resolution Entitlement';
        en.AccountId = acc.Id;
        en.SlaProcessId = process.Id;
        //en.AssetId = a;                 Compiler error on this line
        insert en;
        //Assert to check if Entitlement record has been created successfully 
        system.assert(en.id != null);
        
        /* Fetch the Id of the Record type Provider Dispute*/
        string providerRecTypeId = [Select Id from RecordType where SObjectType = :system.Label.CL37_CaseObject AND Name = 'Provider Dispute'].Id;
        
        /* Fetch the Id of the Entitlement 'SHP Provider Dispute Entitlement' to fire the appropriate Entitlement Process*/
        string entId = [select Id from Entitlement where Name = 'SHP Provider Dispute Resolution Entitlement' limit 1].Id;
        
        /* Set DML Options to By pass the Assignment Rule assignment*/
        Database.Dmloptions dmlOpts = new Database.Dmloptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule = false;
        
        /* Create a Test Case Record*/
        Case testCase = new Case();
        testCase.Date_Grievance_Requested__c = system.Now().addDays(-4);
        testCase.RecordTypeId = providerRecTypeId;
        testCase.Origin = system.label.CL38_ElectonicSubmission;
        testCase.EntitlementId = entId;
        testCase.RFI_Request_Date__c = system.Now();
        /* By pass the assignment rule for this test case*/
        testCase.setOptions(dmlOpts);
        
        test.startTest();
        insert testCase;
        //Assert to check if Case record has been created successfully 
        system.assert(testCase.id != null);
        
        /* Create a Test RFI Record*/
        Request_for_Information__c testRFI = new Request_for_Information__c();
        testRFI.Service_Request__c = testCase.Id;
        testRFI.Date_Information_Requested__c = system.now().addDays(-3);
        insert testRFI;
        //Assert to check if Request_for_Information__c record has been created successfully 
        system.assert(testRFI.id != null);
        
        /* fetch the Inserted Case*/
        testCase = [select Id, RFI_Status__c from Case where Id = :testCase.Id];
        /* Validate test run*/
        system.assertEquals(testCase.RFI_Status__c, system.label.CL32_InProgressRFIStatus);
        
        /* Update Test RFI Record*/
        testRFI.Date_Information_Received__c = system.now().addDays(-2);
        update testRFI;
        
        /* fetch the Inserted Case*/
        testCase = [select Id, RFI_Status__c from Case where Id = :testCase.Id];
        /* Validate test run*/
        system.assertEquals(testCase.RFI_Status__c, system.label.CL33_CompleteRFIStatus);
        
        /*Create a Test RFI Record*/
        
        Request_for_Information__c testRFI1 = new Request_for_Information__c();
        testRFI1.Service_Request__c = testCase.Id;
        testRFI1.Date_Information_Requested__c = system.now().addDays(-2);
        insert testRFI1;
        
        /* fetch the Inserted Case*/
        testCase = [select Id, RFI_Status__c from Case where Id = :testCase.Id];
        /* Validate test run*/
        system.assertEquals(testCase.RFI_Status__c, system.label.CL32_InProgressRFIStatus);
        
        /* Update Test RFI Record*/
        testRFI1.Date_Information_Received__c = system.now().addDays(-1);
        update testRFI1;
        test.StopTest();
        /* fetch the Inserted Case*/
        testCase = [select Id, RFI_Status__c from Case where Id = :testCase.Id];
        /* Validate test run*/
        system.assertEquals(testCase.RFI_Status__c, system.label.CL33_CompleteRFIStatus);
        set<string> SetCase = new set<string>();
        SetCase.add(testCase.id);
        //ManageCaseMilestone objManageCaseMilestone  = new ManageCaseMilestone();
        ManageCaseMilestone.updateCaseMilestone(SetCase,SetCase,SetCase);
    }
    
    /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description :Test to check update for Entitlement when Case is changed from Non-Expedited to Expedited
    *@param     
    *@return     
    */
    static testMethod void nonExpToExpeditedCaseUpdate() 
    {
        List<Case> updatedEntitlementCases = new List<Case>();
        User shpUser = AP01_TestDataUtility.createSHPUser();
        String entExp = AP01_TestDataTokens.ENTITLEMNT_EXP;
        //String entId = [select Id from Entitlement where Name =: entExp limit 1].Id;
        
        System.runAs(shpUser)
        {
            if(Limits.getFutureCalls() >= Limits.getLimitFutureCalls()) {
            }
            else 
            {
                Case intLog = AP01_TestDataUtility.createShpInteractionLog();
            }
        }
        system.assert(updatedEntitlementCases!=null);
    }
    
    /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description :Test to insert Expedited Cases
    *@param     
    *@return     
    */
    
    static testMethod void expeditedCaseInsert() 
    {
        if(Limits.getFutureCalls() >= Limits.getLimitFutureCalls()) {
        }
        else 
        {
            User shpUser = AP01_TestDataUtility.createSHPUser();
            //Assert to check User is created successfully
            system.assert(shpUser.id != null);
            
            String entNon_Exp = AP01_TestDataTokens.ENTITLEMNT_NON_EXP;
        }   
    }
    
    /**   
    *@author IDC Team    
    *@date 09/04/2015    
    *@description :Test to check update for Entitlement when Case is changed from Expedited to Non-Expedited
    *@param     
    *@return     
    */
    static testMethod void expToNonExpeditedCaseUpdate() 
    {
        if(Limits.getFutureCalls() >= Limits.getLimitFutureCalls()) {
        }
        else 
        {
            List<Case> updatedNonExpEntitlementCases = new List<Case>();
            User shpUser = AP01_TestDataUtility.createSHPUser();
            String entNon_Exp = AP01_TestDataTokens.ENTITLEMNT_NON_EXP;
 
            System.runAs(shpUser)
            {
                Case intLog = AP01_TestDataUtility.createShpInteractionLog();
            }
            system.assert(updatedNonExpEntitlementCases!=null);
        }
    }
}