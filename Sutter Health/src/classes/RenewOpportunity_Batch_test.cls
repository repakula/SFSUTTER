/**********************************************************************
 Name: RenewOpportunity_Batch_test
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for Renew Opportunity Batch class.
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  2/9/2015  Development complete   This class is defined to test Renew Opportunity Batch class.
 2.0      IDC Offshore  12/18/2015  Class Optimisation   Incorporated changes to implement best test practices in the test class.
 3.0      IDC Offshore  05/05/2016  Req-3826 changes      Added condition for Opportunity record type as part of Req-3826 changes.
 ***********************************************************************/
 
@isTest
private class RenewOpportunity_Batch_test {
    
    /** Setting the value of record type names in String variables which will be used in the test method **/
    public static String ACNRECTYPE = 'SHP Sales Broker';
    public static String PARENTACCOUNTTYPE = 'SHP Sales Employer';
    public static String CONTACTRECTYPE = 'SHP Sales Broker Contact';
        
    /*******************************************************************
     Purpose: method to create test data used by all test methods
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    @testSetup 
    static void createTestData() {
     
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
        
        Account testAccount1 = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='TestAccount1',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount1);
        
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                          Type = 'Broker',
                                          NumberOfEmployees = 300);
     
        Database.insert(testBrokerAccount);
        
        Id RecordTypeIdOfBroker = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId;
        Id RecordTypeIdOfAccount = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId;
        
        Id IdofAccount = [SELECT Id FROM Account WHERE RecordTypeId = :RecordTypeIdOfAccount limit 1].Id;
        
        Id IdofBrokerAccount = [SELECT Id FROM Account WHERE RecordTypeId = :RecordTypeIdOfBroker limit 1].Id;
        
        Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = IdofBrokerAccount,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep'
                                          );
        
        Contact scnContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'SCNcontact',
                                          AccountId = IdofAccount,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep'
                                          );                                
        Database.insert(testContact);
        Database.insert(scnContact);
        Id IdofContact = [SELECT Id FROM Contact limit 1].Id;
        
        List<Opportunity> OpplistInsert = new List<Opportunity>();
        
        List<Employer_Group_Data__c> SCNList = new List<Employer_Group_Data__c>();
        List<Medical_Plan__c> MedPlanList1 = new List<Medical_Plan__c>();
        List<Medical_Plan__c> MedPlanList2 = new List<Medical_Plan__c>();
        List<Opportunity> OpplistwithoutSCNInsert = new List<Opportunity>();
        
        for (integer i=0;i<20;i++){
          Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN' + i,
                                                       Type = 'New Business',
                                                       AccountId = IdofAccount,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = IdofBrokerAccount,
                                                     //  Broker_Rep1__c = IdofContact,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                OpplistInsert.add(testOpportunity )   ;     
                                                       
        
        }
        
         for (integer i=0;i<20;i++){
          Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN' + i,
                                                       Type = 'New Business',
                                                       AccountId = IdofAccount,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = IdofBrokerAccount,
                                                     //  Broker_Rep1__c = IdofContact,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                        RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                OpplistwithoutSCNInsert .add(testOpportunity )   ;     
                                                       
        
        }
      
        //Insert the list of opportunities                                                
        Database.insert(OpplistInsert);
        Database.insert(OpplistwithoutSCNInsert);
        
          for (integer i=0;i<20;i++){
           Employer_Group_Data__c SCN = new Employer_Group_Data__c();
           SCN.Member_accumulators_previous_Carrier__c = true;
           SCN.Opportunity__c = OpplistInsert[i].id;
           SCN.Opportunity_Account_Name__c = OpplistInsert[i].AccountId   ;
           SCN.Stage__c = 'Approved';
           SCN.BillingContact_Name__c = scnContact.Id;
           SCN.EDI_Vendor_Name__c = scnContact.Id;
           SCN.HREmployer_Portal_Name__c = scnContact.Id;
           SCN.HREmployer_Portal_Name1__c = scnContact.Id;
           SCN.HREnrollment_Name__c = scnContact.Id;
           SCN.Vendor_Contact_Name__c = scnContact.Id;
           SCNList.add(SCN) ;
          }
         
          //List of SCNS are being inserted for test data
         Database.insert( SCNList);
         
         for (integer i=0;i<20;i++)
         {
         Medical_Plan__c mplan =  new Medical_Plan__c();
         mplan.Sold_Case_Notification__c =SCNList[i].id;
         mplan.Acupuncture_Other__c = 'Acupunture 1';
         MedPlanList1.add(mplan);
         }
          Database.insert(MedPlanList1);
          
         for (integer i=0;i<20;i++)
         {
         Medical_Plan__c mplan =  new Medical_Plan__c();
         mplan.Sold_Case_Notification__c =SCNList[i].id;
         mplan.Acupuncture_Other__c = 'Acupunture 2';
         MedPlanList2.add(mplan);
         }
          Database.insert(MedPlanList2);

       /*********************************************************************** 
        Verifying the id values of records created above using system.assert() 
        Expected Result: id values should not be null 
        Actual Result: id values should not be null 
       ************************************************************************/
        system.assert(testAccount.id!=null);
        system.assert(testBrokerAccount.id!=null);
        system.assert(testContact.id!=null);          
             
    }
    
    /*******************************************************************
     Purpose: method to test the logic written in RenewOpportunity_Batch class for SCN and Medical Plan records 
              to create the new Opportuity for all those Opprtunities in Closed Won State
              whose Plan End Date is less than 120 Days from Today. The class creates the deep clone of opportunity 
              copying the latest approved SCN and medical plans of Old Opportunity to newly Created Opportunity. 
              Also Opportunities without SCN are clonned without SCN.
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    public static testMethod void RenewOpportunity_Batchtest(){
       
        /** Instantiating the Medical Plan records list to be used in verifying class logic post successful run in system.assert() method **/  
        List<Medical_Plan__c> renewedMedPlanlist = new List<Medical_Plan__c>();
          
        Test.startTest();
        
        /**  Schedule the batch job using system.schedule() method **/
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        RenewOpportunity_Batch runBatch1 = new RenewOpportunity_Batch();
        String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,runBatch1 );
         
        /** Instantiating the batch class  **/
        RenewOpportunity_Batch runBatch = new RenewOpportunity_Batch();
        Id batchprocessid = Database.executeBatch(runBatch,200);
        Test.stopTest();
                       
        List<Opportunity> renewedOppList = new List<Opportunity>();
        List<Employer_Group_Data__c>  renewedSCNList = new List<Employer_Group_Data__c>();
            
        renewedOppList = [SELECT Id,(SELECT Id FROM Sold_Case_Notification__r) FROM Opportunity WHERE Opp_Renewed__c = true];
        renewedSCNList = [SELECT id,Stage__c,Opportunity__c,(SELECT id FROM Medical_Plans__r) FROM Employer_Group_Data__c WHERE Opportunity__r.Renewed_Opportunity__c = true];
        
        renewedMedPlanlist = [SELECT Id FROM Medical_Plan__c WHERE Sold_Case_Notification__c IN :renewedSCNList];
        
        /*********************************************************************** 
        Verifying the size of Medical Plan and SCN records 
        Expected Result: size for SCN is 20 and Medical plan is 40
        Actual Result: size for SCN is 20 and Medical plan is 40
        ************************************************************************/
       
        System.assertEquals(renewedSCNList.size(),20);
        System.assertEquals(renewedMedPlanlist.size(),40);
             
        
    }
    
    /*******************************************************************
     Purpose: method to test Negative Scenario in RenewOpportunity_Batch class for SCN and Medical Plan records 
              to create the new Opportunity for all those Opportunities in Closed Won State
              whose Plan End Date is less than 120 Days from Today. The class creates the deep clone of opportunity 
              copying the latest approved SCN and medical plans of Old Opportunity to newly Created Opportunity. 
              Also Opportunities without SCN are cloned without SCN.
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    public static testMethod void RenewOpportunity_BatchtNegativeTest(){
       
        /** Instantiating the Medical Plan records list to be used in verifying class logic post successful run in system.assert() method **/  
        List<Medical_Plan__c> renewedMedPlanlist = new List<Medical_Plan__c>();
        list<Opportunity> lstOpp =[SELECT Id,Opp_Renewed__c FROM Opportunity WHERE Opp_Renewed__c = false];
        Test.startTest();
        for(Opportunity tempOpp : lstOpp){
        tempOpp.Opp_Renewed__c = true;
        }
        update lstOpp;
        Test.stopTest();
        
        
        /**  Schedule the batch job using system.schedule() method **/
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        RenewOpportunity_Batch runBatch1 = new RenewOpportunity_Batch();
        String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,runBatch1 );
         
        /** Instantiating the batch class  **/
        RenewOpportunity_Batch runBatch = new RenewOpportunity_Batch();
        Id batchprocessid = Database.executeBatch(runBatch,200);
        
                       
        List<Opportunity> renewedOppList = new List<Opportunity>();
            
        renewedOppList = [SELECT Id FROM Opportunity WHERE StageName = : System.Label.Renewed_Opportunity_Stage];
        
        /*********************************************************************** 
        Verifying Clone Opportunity
        Expected Result: size for Clone Opportunity is empty
        Actual Result: size for Clone Opportunity is empty
        ************************************************************************/
        System.assertEquals(renewedOppList.size(),0);   
    }
	
    
    /*******************************************************************
     Purpose: method to test the archive check box in opportunity object flag on contact
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    public static testMethod void RenewOpportunity_BatchOpportunityArchiveTest(){
       Test.startTest();
        /** Instantiating the Medical Plan records list to be used in verifying class logic post successful run in system.assert() method **/  
        Contact conObj = [select id,LastName,Archive__c from Contact where LastName ='Test contact' LIMIT 1];
        conObj.archive__c = true;
        update conObj;
        
        list<Opportunity> lstOpp =[SELECT Id,Broker_Rep1__c,Account_Manager__c,GA_Contact__c FROM Opportunity WHERE Opp_Renewed__c = false];
        
        for(Opportunity tempOpp : lstOpp){
        	tempOpp.Broker_Rep1__c = conObj.Id;
        }
        try{
            update lstOpp;
        }catch(Exception e){
            
        }
        
        for(Opportunity tempOpp : lstOpp){
        	tempOpp.Account_Manager__c = conObj.Id;
        }
        try{
            update lstOpp;
        }catch(Exception e){
            
        }
        
        for(Opportunity tempOpp : lstOpp){
        	tempOpp.GA_Contact__c = conObj.Id;
        }
        try{
            update lstOpp;
        }catch(Exception e){
            
        }
        
        

        
        /**  Schedule the batch job using system.schedule() method **/
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        RenewOpportunity_Batch runBatch1 = new RenewOpportunity_Batch();
        String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,runBatch1 );
         
        /** Instantiating the batch class  **/
        RenewOpportunity_Batch runBatch = new RenewOpportunity_Batch();
        Id batchprocessid = Database.executeBatch(runBatch,200);
        Test.stopTest();
        
    }
    
     /*******************************************************************
     Purpose: method to test the archive check box in SCN object flag on contact
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    public static testMethod void RenewOpportunity_BatchSCNArchiveTest(){
       Test.startTest();
        Contact conObj = [select id,LastName,Archive__c from Contact where LastName ='SCNcontact' LIMIT 1];
        conObj.archive__c = true;
        update conObj;
        
        

        
        /**  Schedule the batch job using system.schedule() method **/
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        RenewOpportunity_Batch runBatch1 = new RenewOpportunity_Batch();
        String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,runBatch1 );
         
        /** Instantiating the batch class  **/
        RenewOpportunity_Batch runBatch = new RenewOpportunity_Batch();
        Id batchprocessid = Database.executeBatch(runBatch,200);
        Test.stopTest();
                       
          
    }
    
    /*******************************************************************
     Purpose: method to test the lookup filter account ids in SCN is 
			  different with the opportunity account id
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    public static testMethod void RenewOpportunity_BatchSCNTest(){
       Test.startTest();
        ID accountId = [select id from account where name ='TestAccount1' limit 1].ID;
        list<Opportunity> lstOpp =[SELECT Id,AccountId FROM Opportunity WHERE Opp_Renewed__c = false];
        for(Opportunity tempOpp : lstOpp){
            tempOpp.AccountId = accountId;
        }
        update lstOpp;
        
        
        
        /**  Schedule the batch job using system.schedule() method **/
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        RenewOpportunity_Batch runBatch1 = new RenewOpportunity_Batch();
        String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,runBatch1 );
         
        /** Instantiating the batch class  **/
        RenewOpportunity_Batch runBatch = new RenewOpportunity_Batch();
        Id batchprocessid = Database.executeBatch(runBatch,200);
        Test.stopTest();
         
    }
    
    
    
}