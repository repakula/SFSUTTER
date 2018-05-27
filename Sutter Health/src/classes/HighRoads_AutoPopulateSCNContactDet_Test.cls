/*
    Class name     : HighRoads_AutoPopulateSCNContactDet_Test 
    Description    : Test class for HighRoads_AutoPopulateSCNContactDet
    Created Date   : 21/MAR/2017
    Created By     : Deloitte
*/

@isTest
private class HighRoads_AutoPopulateSCNContactDet_Test {
    public static String ACNRECTYPE = 'SHP Sales Broker';
    public static String PARENTACCOUNTTYPE = 'SHP Sales Employer';
    public static String CONTACTRECTYPE = 'SHP Sales Broker Contact';
    
    
    /*******************************************************************
    Purpose: This method is written to testing to create apex sharing and update OWner as per Rejection.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/  
    public static testMethod void SharingAndUpdateowner_SingleTest(){
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
        
        Database.insert(testAccount);
        
        /*********************************************************************** 
        Verifying Account record is created successfully
        Expected Result: Account id  is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/
        system.assert(testAccount.id != null);
        
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                                type='Broker',
                                          NumberOfEmployees = 300);
     
        Database.insert(testBrokerAccount);
        
        /*********************************************************************** 
        Verifying Account record is created successfully
        Expected Result: Account id  is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/
        system.assert(testBrokerAccount.id != null);
        
        Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep'
                                          );
                                        
        Database.insert(testContact);
        
        /*********************************************************************** 
        Verifying Contact record is created successfully
        Expected Result: Contact id  is not null
        Actual Result: Contact id  is not null 
        ***********************************************************************/
        system.assert(testContact.id != null);
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       
                                                       Broker_Rep1__c = testContact.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        
        /*********************************************************************** 
        Verifying Opportunity record is created successfully
        Expected Result: Opportunity id  is not null
        Actual Result: Opportunity id  is not null 
        ***********************************************************************/
        system.assert(testOpportunity.id != null);
        
       Test.startTest();
        
        Employer_Group_Data__c testSCN = HighRoads_TestDataUtility.insertSCN();
        database.insert(testSCN);
        
        testSCN.Opportunity__c = testOpportunity.Id;
        testSCN.Stage__c = 'Draft';
        testSCN.Opportunity_Account_Name__c = testAccount.Id;

        update testSCN;
        
        /*********************************************************************** 
        Verifying Employee Group data record is created successfully
        Expected Result: Employee Group data id  is not null
        Actual Result: Employee Group data id  is not null 
        ***********************************************************************/
        system.assert(testSCN.id != null);
        
        Employer_Group_Data__c testSCN2 = HighRoads_TestDataUtility.insertSCN();
        
        
            //This covers the case when a New SCN is inserted in Complete Status                                                        
        Employer_Group_Data__c testSCN3 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Completed',
                                                                    Opportunity_Account_Name__c = testAccount.Id );
                                                                    
         database.insert(testSCN3);
         
         /*********************************************************************** 
        Verifying Employee Group data record is created successfully
        Expected Result: Employee Group data id  is not null
        Actual Result: Employee Group data id  is not null 
        ***********************************************************************/
        system.assert(testSCN3.id != null);
        
        Id salesProfileId = [SELECT Id FROM Profile WHERE Name= 'SHP Sales' limit 1].Id;
        User user1 = [SELECT Id FROM User WHERE ProfileId = :salesProfileId AND IsActive = true limit 1];
            Database.insert(testSCN2);
            testSCN2.Opportunity__c = testOpportunity.Id;
            testSCN2.Stage__c = 'Draft';
            testSCN2.Opportunity_Account_Name__c = testAccount.Id;

            update testSCN2;
        
            testSCN2.Stage__c='Underwriting Review';

            Database.update(testSCN2);

            Database.update(testSCN2);
            testSCN2.Stage__c='Completed';
            testSCN2.Religious_Exemption_Applied__c = true;

            Database.update(testSCN2);
            testSCN2.Stage__c='Approved';
            testSCN2.Enrollment_hours__c = null;

            Database.update(testSCN2);
       
        Employer_Group_Data__Share SCNShare = [SELECT Id,UserOrGroupId, AccessLevel,RowCause FROM Employer_Group_Data__Share WHERE 
                                               ParentId = :testSCN.Id limit 1];
       
        /*********************************************************************** 
        Verifying Employee Group data record is shared successfully
        Expected Result: Employee Group data AccessLevel  should be All
        Actual Result: Employee Group data AccessLevel  should be All
        ***********************************************************************/
        System.assertEquals(SCNShare.AccessLevel, 'All');
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(testSCN.id);
        req1.setSubmitterId(user1.Id); 
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        /*********************************************************************** 
        Verifying approval process result
        Expected Result: result should be true
        Actual Result: result should be true
        ***********************************************************************/
        System.assert(result.isSuccess());
        /*********************************************************************** 
        Verifying approval process for submit request
        Expected Result: result instance status should be Pending
        Actual Result: result instance status should be Pending
        ***********************************************************************/
        System.assertEquals('Pending', result.getInstanceStatus(), 
                            'Instance Status'+result.getInstanceStatus());
        
        //Reject the Submitted Request 
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Rejecting request.');
        req2.setAction('Reject');
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        // Submit the request for Rejection 
        //Approval.ProcessResult result2 =  Approval.process(req2);
        
         
        /*********************************************************************** 
        Verifying approval process for rejection
        Expected Result: result instance status should be Rejected
        Actual Result: result instance status should be Rejected
        ***********************************************************************/
       // System.assertEquals('Rejected', result2.getInstanceStatus());
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method is written to Negative testing to create apex sharing and update OWner as per Rejection.
    Parameters: N/A 
    Returns: N/A 
    Throws [Exceptions]: N/A
    ********************************************************************/  
    public static testMethod void SharingUpdateownerNegativeTest(){
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
        /*********************************************************************** 
        Verifying Account record is created successfully
        Expected Result: Account id  is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/
        system.assert(testAccount.id != null);
        
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                          type='Broker',
                                          NumberOfEmployees = 300);
     
        Database.insert(testBrokerAccount);
        /*********************************************************************** 
        Verifying Account record is created successfully
        Expected Result: Account id  is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/
        system.assert(testBrokerAccount.id != null);
        
        Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep'
                                          );
                                        
        Database.insert(testContact);
        /*********************************************************************** 
        Verifying Contact record is created successfully
        Expected Result: Contact id  is not null
        Actual Result: Contact id  is not null 
        ***********************************************************************/
        system.assert(testContact.id != null);
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       Broker_Rep1__c = testContact.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        /*********************************************************************** 
        Verifying Opportunity record is created successfully
        Expected Result: Opportunity id  is not null
        Actual Result: Opportunity id  is not null 
        ***********************************************************************/
        system.assert(testOpportunity.id != null);
        
       Test.startTest();
        
        Employer_Group_Data__c testSCN = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Company_Name__c = 'Test',
                                                                    Federal_Employer_ID_Number__c = '123456',
                                                                    Phone_Number__c = '9852147562',
                                                                    Group_Type__c ='Small',
                                                                    city_SA__c ='test',
                                                                    State_SA__c='test',
                                                                    Zip_SA__c='3434',
                                                                    of_Employees__c =33,
                                                                    of_Eligible_Employees__c =33,
                                                                    Projected_Enrollment__c =10.0,
                                                                    Effective_Date__c = System.today(),
                                                                    Cobra_Members_with_this_Group__c = 'COBRA',
                                                                    Performance_or_Implementation__c = '343',
                                                                    CompletedBy__c = UserInfo.getUserId(),
                                                                    AuditorName__c = UserInfo.getUserId(),
                                                                    Broker_Agency__c = 'test',
                                                                    Broker_Name__c= 'test',
                                                                    Opportunity_Account_Name__c = testAccount.Id );
                                                                    
        database.insert(testSCN);
        /*********************************************************************** 
        Verifying Employee Group data record is created successfully
        Expected Result: Employee Group data id  is not null
        Actual Result: Employee Group data id  is not null 
        ***********************************************************************/
        system.assert(testSCN.id != null);
        
        Employer_Group_Data__c testSCN2 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Opportunity_Account_Name__c = testAccount.Id );
            //This covers the case when a New SCN is inserted in Complete Status                                                        
        Employer_Group_Data__c testSCN3 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Religious_Exemption_Applied__c = true,
                                                                    Stage__c = 'Completed',Cloned_from__c = testSCN.Name,
                                                                    Opportunity_Account_Name__c = testAccount.Id );
                                                                    
         database.insert(testSCN3);
        /*********************************************************************** 
        Verifying Employee Group data record is created successfully
        Expected Result: Employee Group data id  is not null
        Actual Result: Employee Group data id  is not null 
        ***********************************************************************/
        system.assert(testSCN3.id != null); 
        
        Id salesProfileId = [SELECT Id FROM Profile WHERE Name= 'SHP Sales' limit 1].Id;
        User user1 = [SELECT Id FROM User WHERE ProfileId = :salesProfileId AND IsActive = true limit 1];
        
        
           
            Database.insert(testSCN2);
            testSCN2.Stage__c='Underwriting Review';
            testSCN2.Draft_hours__c = 20;
            testSCN2.Company_Name__c = 'Test';
            testSCN2.Federal_Employer_ID_Number__c = '123456';
            testSCN2.Phone_Number__c = '9852147562';
            testSCN2.Group_Type__c ='Small';
            testSCN2.city_SA__c ='test';
            testSCN2.State_SA__c='test';
            testSCN2.Zip_SA__c='3434';
            testSCN2.of_Employees__c =33;
            testSCN2.of_Eligible_Employees__c =33;
            testSCN2.Projected_Enrollment__c =10.0;
            testSCN2.Effective_Date__c = System.today();
            testSCN2.Cobra_Members_with_this_Group__c = 'COBRA';
            testSCN2.Performance_or_Implementation__c = '343';
            testSCN2.CompletedBy__c = UserInfo.getUserId();
            testSCN2.AuditorName__c = UserInfo.getUserId();
            testSCN2.Broker_Agency__c = 'test';
            testSCN2.Broker_Name__c= 'test';

            Database.update(testSCN2);
            testSCN2.Stage__c='Completed';
            testSCN2.Underwriting_hours__c = 20;

            Database.update(testSCN2);
            testSCN2.Stage__c='Approved';

            Database.update(testSCN2);
       
        Employer_Group_Data__Share SCNShare = [SELECT Id,UserOrGroupId, AccessLevel,RowCause FROM Employer_Group_Data__Share WHERE 
                                               ParentId = :testSCN.Id limit 1];
       
       /*********************************************************************** 
        Verifying Employee Group data record is shared successfully
        Expected Result: Employee Group data AccessLevel  should be All
        Actual Result: Employee Group data AccessLevel  should be All
        ***********************************************************************/
        System.assertEquals(SCNShare.AccessLevel, 'All');
       
       
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(testSCN.id);
        req1.setSubmitterId(user1.Id); 
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        /*********************************************************************** 
        Verifying approval process result
        Expected Result: result should be true
        Actual Result: result should be true
        ***********************************************************************/
        System.assert(result.isSuccess());
        
        /*********************************************************************** 
        Verifying approval process for submit request
        Expected Result: result instance status should be Pending
        Actual Result: result instance status should be Pending
        ***********************************************************************/
        System.assertEquals('Pending', result.getInstanceStatus(), 
                            'Instance Status'+result.getInstanceStatus());
        
        //Reject the Submitted Request 
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Rejecting request.');
        req2.setAction('Reject');
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        // Submit the request for Rejection 
        //Approval.ProcessResult result2 =  Approval.process(req2);
        
       /*********************************************************************** 
        Verifying approval process for rejection
        Expected Result: result instance status should be Rejected
        Actual Result: result instance status should be Rejected
        ***********************************************************************/
        //System.assertEquals('Rejected', result2.getInstanceStatus());
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method is written to bulkify testing to create apex sharing and update OWner as per Rejection.
    Parameters: N/A 
    Returns: N/A 
    Throws [Exceptions]: N/A
    ********************************************************************/  
    public static testMethod void SharingAndUpdateownerBulkTest(){
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
        /*********************************************************************** 
        Verifying Account record is created successfully
        Expected Result: Account id  is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/
        system.assert(testAccount.id != null);
        
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                          type='Broker',
                                          NumberOfEmployees = 300);
     
        Database.insert(testBrokerAccount);
        /*********************************************************************** 
        Verifying Account record is created successfully
        Expected Result: Account id  is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/
        system.assert(testBrokerAccount.id != null);
        
        Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep'
                                          );
                                        
        Database.insert(testContact);
        
        /*********************************************************************** 
        Verifying Contact record is created successfully
        Expected Result: Contact id  is not null
        Actual Result: Contact id  is not null 
        ***********************************************************************/
        system.assert(testContact.id != null);
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       Broker_Rep1__c = testContact.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        /*********************************************************************** 
        Verifying Opportunity record is created successfully
        Expected Result: Opportunity id  is not null
        Actual Result: Opportunity id  is not null 
        ***********************************************************************/
        system.assert(testOpportunity.id != null);
        
        list<Employer_Group_Data__c> lstEmployerGroupData = new list<Employer_Group_Data__c>();
       Test.startTest();
        for(Integer i=0;i<20;i++){
        Employer_Group_Data__c testSCN = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Opportunity_Account_Name__c = testAccount.Id );
         lstEmployerGroupData.add(testSCN);                                                 
         Employer_Group_Data__c testSCN2 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Underwriting Review',
                                                                    Opportunity_Account_Name__c = testAccount.Id );
        lstEmployerGroupData.add(testSCN2);                                                         
        //This covers the case when a New SCN is inserted in Complete Status                                                        
        Employer_Group_Data__c testSCN3 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Religious_Exemption_Applied__c = true,
                                                                    Stage__c = 'Completed',
                                                                    Opportunity_Account_Name__c = testAccount.Id );
        lstEmployerGroupData.add(testSCN3);
        }                                                          
        
        insert lstEmployerGroupData;
        
        Id salesProfileId = [SELECT Id FROM Profile WHERE Name= 'SHP Sales' limit 1].Id;
        User user1 = [SELECT Id FROM User WHERE ProfileId = :salesProfileId AND IsActive = true limit 1];
            
            for(Employer_Group_Data__c tempEmployerGroupData : lstEmployerGroupData){
            
            tempEmployerGroupData.Stage__c='Underwriting Review';
            tempEmployerGroupData.Draft_hours__c = 20;
            }
        try{

            update lstEmployerGroupData;
        }catch(Exception e){}
        
        for(Employer_Group_Data__c tempEmployerGroupData : lstEmployerGroupData){
            
            tempEmployerGroupData.Stage__c='Draft';
            tempEmployerGroupData.Draft_hours__c = 20;
            tempEmployerGroupData.Company_Name__c = 'test';
            tempEmployerGroupData.Federal_Employer_ID_Number__c = '1234';
            tempEmployerGroupData.Phone_Number__c= '987654310';
            tempEmployerGroupData.Group_Type__c = '';
            
            
            
            }
        
        update lstEmployerGroupData;
        Employer_Group_Data__Share SCNShare = [SELECT Id,UserOrGroupId, AccessLevel,RowCause FROM Employer_Group_Data__Share WHERE 
                                               ParentId = :lstEmployerGroupData[0].Id  limit 1];
       
        System.assertEquals(SCNShare.AccessLevel, 'All');
      
       
        
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        
        for(Employer_Group_Data__c Tempobj : lstEmployerGroupData){
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(Tempobj.id);
        req1.setSubmitterId(user1.Id); 
        requests.add(req1);
        }
        // Submit the approval request for the account
        Approval.ProcessResult[] processResults = null;
                try {
                    processResults = Approval.process(requests, true);
        }catch (System.DmlException e) {
            System.debug('Exception Is ' + e.getMessage());
        }

        
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method is written to testing to archive contact for billing contact.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/  
    public static testMethod void testArchiveContactforSCN(){
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
        
        Database.insert(testAccount);
            
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                          type='Broker',
                                          NumberOfEmployees = 300);
     
        Database.insert(testBrokerAccount);
                
        Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep'
                                          );
                                        
        Database.insert(testContact);
                
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       Broker_Rep1__c = testContact.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
      
        Contact conObj = [select id,archive__c from contact where id=:testContact.id];
        conObj.Archive__c = true;
        update conObj;
       Test.startTest();
        
        Employer_Group_Data__c testSCN = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Opportunity_Account_Name__c = testAccount.Id,
                                                                    BillingContact_Name__c = conObj.id);
        try{
            database.insert(testSCN);
        } catch(Exception e){}
        
        Employer_Group_Data__c testSCN1 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Opportunity_Account_Name__c = testAccount.Id,
                                                                    EDI_Vendor_Name__c = conObj.id);
        try{
            database.insert(testSCN1);
        } catch(Exception e){}
        
        Employer_Group_Data__c testSCN2 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Opportunity_Account_Name__c = testAccount.Id,
                                                                    HREmployer_Portal_Name__c = conObj.id);
        try{
            database.insert(testSCN2);
        } catch(Exception e){}
        
        Employer_Group_Data__c testSCN3 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Opportunity_Account_Name__c = testAccount.Id,
                                                                    HREmployer_Portal_Name1__c = conObj.id);
        try{
            database.insert(testSCN3);
        } catch(Exception e){}
        
        Employer_Group_Data__c testSCN4 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Opportunity_Account_Name__c = testAccount.Id,
                                                                    HREnrollment_Name__c = conObj.id);
        try{
            database.insert(testSCN4);
        } catch(Exception e){}
        
        Employer_Group_Data__c testSCN5 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Opportunity_Account_Name__c = testAccount.Id,
                                                                    Vendor_Contact_Name__c = conObj.id);
        try{
            database.insert(testSCN5);
        } catch(Exception e){}
        
        Employer_Group_Data__c testSCN6 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Opportunity_Account_Name__c = testAccount.Id,
                                                                    EDI_Vendor_Name__c = testContact.id);
        
        try{
            insert testSCN6;
        } catch(Exception e){}
        
    }
    
    /*******************************************************************
    Purpose: This method is written to testing to archive contact for billing contact.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/  
    public static testMethod void testArchiveContactforSCN1(){
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
        
        Database.insert(testAccount);
            
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                          type='Broker',
                                          NumberOfEmployees = 300);
     
        Database.insert(testBrokerAccount);
                
        Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep');
                                          
        Contact testContact1 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep');                                  
                                        
        Database.insert(new List<Contact>{testContact, testContact1});
                
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       Broker_Rep1__c = testContact.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
      
       Test.startTest();
        Employer_Group_Data__c testSCN6 = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Enrollment_Method__c = 'Electronic',
                                                                    Opportunity_Account_Name__c = testAccount.Id,
                                                                    EDI_Vendor_Name__c = testContact.Id, 
                                                                    Vendor_Contact_Name__c = testContact.Id,
                                                                    HREnrollment_Name__c = testContact1.Id,
                                                                    HREmployer_Portal_Name__c = testContact1.Id);
        insert testSCN6;
    }
    
    private testMethod static void clonedSCNTest(){
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
        /*********************************************************************** 
        Verifying Account record is created successfully
        Expected Result: Account id  is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/
        system.assert(testAccount.id != null);
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        List<Benefit_Plan_Metadata__c> bpmList = new List<Benefit_Plan_Metadata__c>();
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = System.today();
        bpm.End_Date__c = system.today()+360;
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
        bpm.Plan_Year__c = string.valueOf(system.today().year());
        bpmList.add(bpm);
        
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02 - 2016';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = System.today();
        bpm1.End_Date__c = system.today()+360;
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
        bpm1.Plan_Year__c = string.valueOf(system.today().year());
        bpmList.add(bpm1);
        Insert bpmList;
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Name = bpmList[0].Name;
        bpa1.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa1.Opportunity__c = testOpportunity.Id;
        bpaList.add(bpa1);
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Name = bpmList[0].Name;
        bpa2.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa2.Raider_ID__c = bpmList[1].Id;
        bpa2.Opportunity__c = testOpportunity.Id;
        bpaList.add(bpa2);
        
        Rate_Card__c rcObj = new Rate_Card__c();
        insert rcObj;
        
        Rates__c rate1 = new Rates__c();
        rate1.Plan_Name__c = 'HE02 - 2016';
        rate1.Opportunity__c = testOpportunity.Id;
        insert rate1;
        
        Rates__c rate2 = new Rates__c();
        rate2.Plan_Name__c = 'HE02 - 2016';
        rate2.Rider_Plan_Name__c ='XA02 - 2016';
        rate2.Opportunity__c = testOpportunity.Id;
        insert rate2;
        
        Employer_Group_Data__c testSCN = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Company_Name__c = 'Test',
                                                                    Federal_Employer_ID_Number__c = '123456',
                                                                    Phone_Number__c = '9852147562',
                                                                    Group_Type__c ='Small',
                                                                    city_SA__c ='test',
                                                                    State_SA__c='test',
                                                                    Zip_SA__c='3434',
                                                                    of_Employees__c =33,
                                                                    of_Eligible_Employees__c =33,
                                                                    Projected_Enrollment__c =10.0,
                                                                    Effective_Date__c = System.today(),
                                                                    Cobra_Members_with_this_Group__c = 'COBRA',
                                                                    Performance_or_Implementation__c = '343',
                                                                    CompletedBy__c = UserInfo.getUserId(),
                                                                    AuditorName__c = UserInfo.getUserId(),
                                                                    Broker_Agency__c = 'test',
                                                                    Broker_Name__c= 'test',
                                                                    Opportunity_Account_Name__c = testAccount.Id );
                                                                    
        database.insert(testSCN);
        
        Employer_Group_Data__c clonetestSCN = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Company_Name__c = 'Test',
                                                                    Federal_Employer_ID_Number__c = '123456',
                                                                    Phone_Number__c = '9852147562',
                                                                    Group_Type__c ='Small',
                                                                    city_SA__c ='test',
                                                                    State_SA__c='test',
                                                                    Zip_SA__c='3434',
                                                                    of_Employees__c =33,
                                                                    of_Eligible_Employees__c =33,
                                                                    Projected_Enrollment__c =10.0,
                                                                    Effective_Date__c = System.today(),
                                                                    Cobra_Members_with_this_Group__c = 'COBRA',
                                                                    Performance_or_Implementation__c = '343',
                                                                    CompletedBy__c = UserInfo.getUserId(),
                                                                    AuditorName__c = UserInfo.getUserId(),
                                                                    Broker_Agency__c = 'test',
                                                                    Broker_Name__c= 'test',
                                                                    Cloned_Record__c = true,
                                                                    Opportunity_Account_Name__c = testAccount.Id );
        
        Database.Insert(clonetestSCN);
        rate1.Sold_Case_Notification__c = clonetestSCN.Id;
        rate2.Sold_Case_Notification__c = clonetestSCN.Id;
        update rate1;
        update rate2;
        clonetestSCN.Tech_Cloned_Record__c = true;
        update clonetestSCN;
        
    }
    
    
    private testMethod static void plansChangedToNotSaleSCNTest(){
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
        /*********************************************************************** 
        Verifying Account record is created successfully
        Expected Result: Account id  is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/
        system.assert(testAccount.id != null);
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        List<Benefit_Plan_Metadata__c> bpmList = new List<Benefit_Plan_Metadata__c>();
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = System.today();
        bpm.End_Date__c = system.today()+360;
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
        bpm.Plan_Year__c = string.valueOf(system.today().year());
        bpmList.add(bpm);
        
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02 - 2016';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = System.today();
        bpm1.End_Date__c = system.today()+360;
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
        bpm1.Plan_Year__c = string.valueOf(system.today().year());
        bpmList.add(bpm1);
        Insert bpmList;
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Name = bpmList[0].Name;
        bpa1.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa1.Opportunity__c = testOpportunity.Id;
        bpaList.add(bpa1);
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Name = bpmList[0].Name;
        bpa2.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa2.Raider_ID__c = bpmList[1].Id;
        bpa2.Opportunity__c = testOpportunity.Id;
        bpaList.add(bpa2);
        
        Rate_Card__c rcObj = new Rate_Card__c();
        insert rcObj;
        
        Rates__c rate1 = new Rates__c();
        rate1.Plan_Name__c = 'HE02 - 2016';
        rate1.Opportunity__c = testOpportunity.Id;
        insert rate1;
        
        Rates__c rate2 = new Rates__c();
        rate2.Plan_Name__c = 'HE02 - 2016';
        rate2.Rider_Plan_Name__c ='XA02 - 2016';
        rate2.Opportunity__c = testOpportunity.Id;
        insert rate2;
        
        Employer_Group_Data__c testSCN = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Company_Name__c = 'Test',
                                                                    Federal_Employer_ID_Number__c = '123456',
                                                                    Phone_Number__c = '9852147562',
                                                                    Group_Type__c ='Small',
                                                                    city_SA__c ='test',
                                                                    State_SA__c='test',
                                                                    Zip_SA__c='3434',
                                                                    of_Employees__c =33,
                                                                    of_Eligible_Employees__c =33,
                                                                    Projected_Enrollment__c =10.0,
                                                                    Effective_Date__c = System.today(),
                                                                    Cobra_Members_with_this_Group__c = 'COBRA',
                                                                    Performance_or_Implementation__c = '343',
                                                                    CompletedBy__c = UserInfo.getUserId(),
                                                                    AuditorName__c = UserInfo.getUserId(),
                                                                    Broker_Agency__c = 'test',
                                                                    Draft_Start_Time__c = System.today(),
                                                                    Broker_Name__c= 'test',
                                                                    Opportunity_Account_Name__c = testAccount.Id );
                                                                    
        database.insert(testSCN);
        List<Benefit_Plan_Association__c> bpaList1 = new List<Benefit_Plan_Association__c>();
        for(Benefit_Plan_Association__c bpa : [select id,Sold_Case_Notification__c from Benefit_Plan_Association__c where 
                                               Opportunity__c =:testOpportunity.Id]){
                                                   bpa.Sold_Case_Notification__c = testSCN.Id;
                                                   bpa.Sold_Case_Notification__c = testSCN.Id;                       
                                                   bpaList1.add(bpa);
                                                   
        }
        update bpaList1;
        bpm.Plan_Status__c = 'Not Available for Sale';
        update bpm;
        testSCN.Stage__c = 'Underwriting Review';
        try{

            update testSCN;
        }catch(Exception e){}
        bpm.Plan_Status__c = 'Approved for Sale';
        update bpm;
        bpm1.Plan_Status__c = 'Not Available for Sale';
        update bpm1;
        testSCN.Stage__c = 'Underwriting Review';
        try{

            update testSCN;
        }catch(Exception e){}
    }
    /*******************************************************************
    Purpose: This method is written to check for SCN with stage Complete
    Parameters: N/A 
    Returns: N/A 
    Throws [Exceptions]: N/A
    ********************************************************************/  
    public static testMethod void completeSCN(){
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
        /*********************************************************************** 
        Verifying Account record is created successfully
        Expected Result: Account id  is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/
        system.assert(testAccount.id != null);
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        List<Benefit_Plan_Metadata__c> bpmList = new List<Benefit_Plan_Metadata__c>();
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = System.today();
        bpm.End_Date__c = system.today()+360;
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
        bpm.Plan_Year__c = string.valueOf(system.today().year());
        bpmList.add(bpm);
        
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02 - 2016';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = System.today();
        bpm1.End_Date__c = system.today()+360;
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
        bpm1.Plan_Year__c = string.valueOf(system.today().year());
        bpmList.add(bpm1);
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'XA02 - 2016';
        bpm2.Medical_OR_Rider__c = 'Rider';
        bpm2.Product_Class__c = 'Acupuncture and Chiro';
        bpm2.Effective_Date__c = System.today();
        bpm2.End_Date__c = system.today()+360;
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Standard';
        bpm2.Ancillary_EOC__c = true;
        bpm2.Ancillary_GSA__c = true;
        bpm2.Ancillary_SOB__c = true;
        bpm2.EOC__c = true;
        bpm2.BCM__c = true;
        bpm2.SBC__c = true;
        bpm2.Benefit_Plan_ID__c = 'XA02';
        bpm2.Plan_Status__c = 'Not Available for Sale';
        bpm2.Plan_Year__c = string.valueOf(system.today().year());
        bpmList.add(bpm2);
        
        Insert bpmList;
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Name = bpmList[0].Name;
        bpa1.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa1.Opportunity__c = testOpportunity.Id;
        bpaList.add(bpa1);
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Name = bpmList[0].Name;
        bpa2.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa2.Raider_ID__c = bpmList[1].Id;
        bpa2.Opportunity__c = testOpportunity.Id;
        bpaList.add(bpa2);
        
        Benefit_Plan_Association__c bpa3 = new Benefit_Plan_Association__c();
        bpa3.Name = bpmList[1].Name;
        bpa3.Benefit_Plan_Metadata__c = bpmList[2].Id;
        bpa3.Raider_ID__c = bpmList[2].Id;
        bpa3.Opportunity__c = testOpportunity.Id;
        bpaList.add(bpa3);
        
        Rate_Card__c rcObj = new Rate_Card__c();
        insert rcObj;
        
        Rates__c rate1 = new Rates__c();
        rate1.Plan_Name__c = 'HE02 - 2016';
        rate1.Opportunity__c = testOpportunity.Id;
        insert rate1;
        
        Rates__c rate2 = new Rates__c();
        rate2.Plan_Name__c = 'HE02 - 2016';
        rate2.Rider_Plan_Name__c ='XA02 - 2016';
        rate2.Opportunity__c = testOpportunity.Id;
        insert rate2;
        
        Employer_Group_Data__c testSCN = new Employer_Group_Data__c(Opportunity__c = testOpportunity.Id,
                                                                    Stage__c = 'Draft',
                                                                    Company_Name__c = 'Test',
                                                                    Federal_Employer_ID_Number__c = '123456',
                                                                    Phone_Number__c = '9852147562',
                                                                    Group_Type__c ='Small',
                                                                    city_SA__c ='test',
                                                                    State_SA__c='test',
                                                                    Zip_SA__c='3434',
                                                                    of_Employees__c =33,
                                                                    of_Eligible_Employees__c =33,
                                                                    Projected_Enrollment__c =10.0,
                                                                    Effective_Date__c = System.today(),
                                                                    Cobra_Members_with_this_Group__c = 'COBRA',
                                                                    Performance_or_Implementation__c = '343',
                                                                    CompletedBy__c = UserInfo.getUserId(),
                                                                    AuditorName__c = UserInfo.getUserId(),
                                                                    Broker_Agency__c = 'test',
                                                                    Broker_Name__c= 'test',
                                                                    Draft_Start_Time__c = System.today(),
                                                                    Opportunity_Account_Name__c = testAccount.Id );
        
        insert testSCN;
        List<Benefit_Plan_Association__c> bpaList1 = new List<Benefit_Plan_Association__c>();
        for(Benefit_Plan_Association__c bpa : [select id,Sold_Case_Notification__c from Benefit_Plan_Association__c where 
                                               Opportunity__c =:testOpportunity.Id]){
                                                   bpa.Sold_Case_Notification__c = testSCN.Id;                       
                                                   bpaList1.add(bpa);
                                                   
        }        
        insert bpaList1;
        
        //bpm.Plan_Status__c = 'Not Available for Sale';
        //update bpm;
        Test.startTest();
        testSCN.Stage__c = 'Underwriting Review';
        update testSCN;
        try{

            update testSCN;
        }catch(Exception e){}

        testSCN.Stage__c = 'Completed';
        update testSCN;

        testSCN.Stage__c = 'Submitted for QA';
        update testSCN;

        testSCN.Stage__c = 'Enrollment QA Pass';
        update testSCN;

        testSCN.Stage__c = 'Approved';
        update testSCN;
        try{
            User AEUser = HighRoads_TestDataUtility.createAEUser();
            system.runAs(AEUser){

            testSCN.Stage__c = 'Completed';
            update testSCN;
            }
        }catch(Exception e){}
        Test.stopTest();
    }
}