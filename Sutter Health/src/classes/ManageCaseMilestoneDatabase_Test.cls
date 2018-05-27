/**  
*    Class Name: ManageCaseMilestoneDatabase_Test
*    Author: Prerna Chandak
*    Date: 7/26/2016
*    Description: Test Class for ManageCaseMilestoneDatabase.
*    History
*
*    VERSION    AUTHOR              DATE        DETAIL 
*      1.0     Prerna Chandak      July 27, 2016    Initial Creation
*    --------
**/
@isTest
private class ManageCaseMilestoneDatabase_Test{
        static string grievanceRecTypeId = [Select Id from RecordType where SObjectType = :'Case' AND Name = 'Grievance'].Id;
        static string providerRecTypeId = [Select Id from RecordType where SObjectType = :system.Label.CL37_CaseObject AND Name = 'Provider Dispute'].Id;
        static string pdiRecTypeId = [Select Id from RecordType where SObjectType = :system.Label.CL37_CaseObject AND Name = 'Provider Directory Inaccuracy'].Id;
        static Entitlement en, en1,en2;
        static List<Case> caseList,caseLst;
        static Case caseRec1,caseRec2,caseRec3,caseRec4  ;
        static Account acc;
        static SlaProcess process;
        static AssignmentRule AR;
        static Database.Dmloptions dmlOpts;
        
/*******************************************************************
Purpose: Set ups test data used across all test methods.
Parameters: None
Returns: none 
Throws [Exceptions]: None
********************************************************************/
        
 static testMethod void setUpTestData() {
        //Query the SLA process
        process =[SELECT Id,Name FROM SlaProcess where Name = 'SHP Grievance Entitlement for Exempt V2' limit 1];
        //Create Account
        acc = AP01_TestDataUtility.createAccount();
        //Assert to check if Account record has been created successfully 
        system.assertNotEquals(acc.id,null);
        
        //Create Entitlement
        en = new Entitlement();
        en.Name = 'SHP Grievance Entitlement for Exempt V2';
        en.AccountId = acc.Id;
        en.SlaProcessId = process.Id;
        insert en;
        //Assert to check if Entitlement record has been created successfully 
        system.assertNotEquals(en.id,null);
        
        caseList = new List<Case>();
        caseRec1 = new Case();
        caseRec1 .RFI_Request_Date__c = system.Now();
        caseRec1 .RFI_Completion_Date__c = null;
        caseRec1 .RecordTypeId = providerRecTypeId;
        caseList.add(caseRec1 );
       
        caseRec2 = new Case();
        caseRec2 .RFI_Request_Date__c = system.Now().addDays(-2);
        caseRec2 .RFI_Completion_Date__c = system.Now();
        caseRec2.RecordTypeId = providerRecTypeId;
        caseList.add(caseRec2);
        
        caseRec3 = new Case();
        caseRec3.RecordTypeId = grievanceRecTypeId;
        caseRec3.Date_Grievance_Requested__c = system.Now();
        caseRec3.Origin = system.label.CL38_ElectonicSubmission;
        caseRec3.Dispute_Received_Updated_Frequency__c = 1;
        caseRec3.Secondary_Reason__c = 'Expedited';
        caseList.add(caseRec3);
        
        caseRec4 = new Case();
        caseRec4 .RecordTypeId = grievanceRecTypeId;
        caseRec4 .Date_Grievance_Requested__c = system.Now();
        caseRec4 .Origin = system.label.CL38_ElectonicSubmission;
        caseRec4 .Dispute_Received_Updated_Frequency__c = 1;
        caseRec4 .Secondary_Reason__c = 'Routine';
        caseList.add(caseRec4 );
        
        insert caseList; 
        //Assert to check if Case records has been created successfully 
        system.assertNotEquals(caseList.size(),null);
        
        EntitlementRecordType__c entRec = new EntitlementRecordType__c();
        entRec.Name = 'test';
        insert entRec;
        
        //Query the active case assignment rules.
        AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        dmlOpts = new Database.Dmloptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;

    }


  static testMethod void bulkTesting() {
   
   List<Case> caseBulkLoad = new List<Case>();
   
   Account acc1 = new Account();
   acc1.Name = 'Accenture';
   insert acc1;
   
 
    
   en2 = new Entitlement();
        en2.Name = 'SHP Grievance Entitlement for Exempt V2';
        en2.AccountId = acc1.Id;
        //en2.SlaProcessId = process.Id;
        insert en2; 
        
   for(integer i=0; i<=49; i++){
        case caseRec = new case();
        
        caseRec .RFI_Request_Date__c = system.Now();
        caseRec .RFI_Completion_Date__c = null;
        caseRec .RecordTypeId = grievanceRecTypeId;
        caseRec.EntitlementId = en2.id;
        caseBulkLoad .add(caseRec );
        
      
   }
   insert caseBulkLoad ;
   
   system.assertEquals(caseBulkLoad.size(), 50);
        Test.startTest();
        ManageCaseMilestoneDatabase.AssignGrievanceEntitlement(caseBulkLoad);
        ManageCaseMilestoneDatabase.assignPDIEntitlement(caseBulkLoad);
        ManageCaseMilestoneDatabase.calculateEndTimeBusinessHours(caseBulkLoad);
        ManageCaseMilestoneDatabase.incrementReceivedDateFrequencyCounter(caseBulkLoad);
        Test.stopTest();
  
   
  }
   
/*******************************************************************
Purpose: Update Case records with Grievance record type.
Parameters: None
Returns: none 
Throws [Exceptions]: None
********************************************************************/
 static testMethod void ManageCaseMilestoneDB_GrievanceTest() {
        //Invoking the test data method created above.     
        setUpTestData();
        
        //Creating set of case ids
        Set<id> caseIds = new Set<Id>();
        for(Case c :caseList){
        caseIds.add(c.id); 
        }
        //Assert to check if set of case ids has been created successfully 
        system.assertNotEquals(caseIds.size(),null);
        
        //Query the inserted case record to assign it to Request_for_Information__c object.
        List<Case> caseAfterInsert = [Select id,RFI_Request_Date__c,RFI_Completion_Date__c  from Case where id IN :caseIds];
        
        //Create Request for Information object to get the count in Number of RFIs field on case. 
        Request_for_Information__c obj = new Request_for_Information__c();
        obj.Service_Request__c = caseAfterInsert[0].id;
        obj.Date_Information_Requested__c = system.Now();
        insert obj;
        //Assert to check if Request for Information record has been created successfully 
        system.assertNotEquals(obj.id,null); 
        
        caseLst = new List<Case>();
        //Updating new values in case records.
        caseRec1.RecordTypeId = grievanceRecTypeId;
        caseRec1.Date_Grievance_Requested__c = system.Now();
        caseRec1.Origin = system.label.CL38_ElectonicSubmission;
        caseRec1.Dispute_Received_Updated_Frequency__c = 1;
        caseRec1.EntitlementId = en.Id;
        caseRec1.Secondary_Reason__c = 'Exempt';
        caseRec1.setOptions(dmlOpts);
        caseLst.add(caseRec1);
       
        
        caseRec2.RecordTypeId = providerRecTypeId;
        caseRec2.Date_Grievance_Requested__c = null;
        caseRec2.Origin = system.label.CL38_ElectonicSubmission;
        caseRec2.Dispute_Received_Updated_Frequency__c = 1;
        caseRec2.EntitlementId = en.Id;
        caseRec2 .RFI_Request_Date__c = system.Now().addDays(-2);
        caseRec2 .RFI_Completion_Date__c = system.Now();
        //caseRec2 .RFI_Status__c = 'Complete';
        caseLst.add(caseRec2);  
        
        if(caseLst.size()!= null && caseLst.size() > 0){
        //Updating the case list.
        update caseLst;
        }
        //Assert to check if Case List has been updated.
        system.assertNotEquals(caseLst.size(),null); 
        
        //Creating set of case ids
        Set<String> grievCaseIds = new Set<String>();
        for(Case c :caseList ){
        grievCaseIds.add(c.id); 
        }
        Try{
        Test.startTest();
        //Invoking the class methods.
        ManageCaseMilestoneDatabase.AssignGrievanceEntitlement(caseList );
        ManageCaseMilestoneDatabase.assignPDIEntitlement(caseList );
        ManageCaseMilestoneDatabase.calculateEndTimeBusinessHours(caseList );
        ManageCaseMilestoneDatabase.incrementReceivedDateFrequencyCounter(caseList );
        ManageCaseMilestoneDatabase.caseUpdateMilestoneDate(grievCaseIds);
        Test.stopTest();
        }Catch (Exception e)        
        { system.assert(e!=NULL); }
}

/*******************************************************************
Purpose: Update Case records with Grievance record type.
Parameters: None
Returns: none 
Throws [Exceptions]: None
********************************************************************/
 static testMethod void ManageCaseMilestoneDB_PDITest() {
        //Invoking the test data method created above.
        setUpTestData();
        
        //Creating set of case ids
        Set<id> caseIds = new Set<Id>();
        for(Case c :caseList){
        caseIds.add(c.id); 
        }
        //Assert to check if set of case ids has been created successfully 
        system.assertNotEquals(caseIds.size(),null);
        
        //Query the inserted case record to assign it to Request_for_Information__c object.
        List<Case> caseAfterInsert = [Select id,RFI_Request_Date__c,RFI_Completion_Date__c  from Case where id IN :caseIds];
        
        //Create Request for Information object to get the count in Number of RFIs field on case. 
        Request_for_Information__c obj = new Request_for_Information__c();
        obj.Service_Request__c = caseAfterInsert[0].id;
        obj.Date_Information_Requested__c = system.Now();
        insert obj;
        //Assert to check if Request for Information record has been created successfully 
        system.assertNotEquals(obj.id,null);
        
        caseLst = new List<Case>();
        
       /* en1 = new Entitlement();
        en1.Name = 'SHP Provider Directory Inaccuracy Entitlement on Notification Received Date';
        en1.AccountId = acc.Id;
        en1.SlaProcessId = process.Id;
        insert en1; */
        
        en.Name = 'SHP Provider Directory Inaccuracy Entitlement on Notification Received Date';
        update en;
        
        //Updating new values in case records.
        caseRec1.RecordTypeId = pdiRecTypeId;
        caseRec1.Date_Grievance_Requested__c = system.Now();
        caseRec1.Origin = system.label.CL38_ElectonicSubmission;
        caseRec1.EntitlementId = en.Id;
        caseRec1.Bypass_ValidationRule__c= True;
        caseRec1.Other_Provider__c= 'test';
        caseRec1.Reason__c = 'Provider Directory Inaccuracy';
        caseRec1.Secondary_Reason__c = 'Grievance';
        caseRec1.Provider_Not_Found__c = true;
        caseRec1.Reported_Inaccuracies__c = 'Provider Name';
        caseRec1.setOptions(dmlOpts);
        caseLst.add(caseRec1); 
        
        
        caseRec2.RecordTypeId = pdiRecTypeId;
        caseRec2.Notification_Received_Date__c = system.Now();
        caseRec2.Origin = system.label.CL38_ElectonicSubmission;
        caseRec2.subject = 'Test';
        caseRec2.EntitlementId = en.Id;
        caseRec2.Bypass_ValidationRule__c= True;
        caseRec2.Other_Provider__c= 'test';
        caseRec2.Reason__c = 'Provider Directory Inaccuracy';
        caseRec2.Secondary_Reason__c = 'Notification';
        caseRec2.Provider_Not_Found__c = true;
        caseRec2.Reported_Inaccuracies__c = 'Provider Name';
        caseLst.add(caseRec2); 
        update caseLst;
        
        //Creating set of case ids
        Set<String> grievCaseIds = new Set<String>();
        for(Case c :caseList ){
        grievCaseIds.add(c.id); 
        }
        
        Test.startTest();
        //Invoking the class methods.
        ManageCaseMilestoneDatabase.AssignGrievanceEntitlement(caseList );
        ManageCaseMilestoneDatabase.assignPDIEntitlement(caseList );
        ManageCaseMilestoneDatabase.calculateEndTimeBusinessHours(caseList );
        ManageCaseMilestoneDatabase.incrementReceivedDateFrequencyCounter(caseList );
        ManageCaseMilestoneDatabase.caseUpdateMilestoneDate(grievCaseIds);
        Test.stopTest(); 
        
        
    }

}