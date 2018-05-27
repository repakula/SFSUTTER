/* 
     Class Name: VFC45_SHP_RFPForm_Test 
     Author: Prerna Chandak
     Date: 8-Mar-2016
     Description: Test class for VFP45_SHP_RFPForm controller to create new Incumbent Carrier of RFPForm record type.
     History:
     VERSION    AUTHOR              DATE         DETAIL 
     1.0        Prerna Chandak      2-5-2016     Added TestMethod3 and TestMethod4.
     1.1        Haritha             12-7-2016    
     2.0        Deloitte            3-15-2017    Increased the test coverage
*/
@isTest (SeeAllData=true)

private class VFC45_SHP_RFPForm_Test{

    private static Account acc;
    private static Opportunity opp;
    private static Incumbent_Carrier__c inc, inc1,inc2,inc3,inc4,inc5;
    private static Census__c census, census1;
    private static List<Incumbent_Carrier__c> incList;
    private integer counter=0;
    private static   Zip_Code_Master__c zmaster , zmaster1;
    private static List<Zip_Code_Master__c> zipCodeList;
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
    private static Id accIndRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Individual').getRecordTypeId();
    private static Id incRecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('RFP Form').getRecordTypeId();
    private static Id incRecordTypeId2 = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('Incumbent Carrier').getRecordTypeId();
    private static Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHP Sales Opportunity').getRecordTypeId();
    
/* Method to set test data*/
public static TestMethod void setupTestData(){

    Profile profile = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
    User user = new User(Alias = 'test', Email='test.user@sutter.com.pred',
          EmailEncodingKey='ISO-8859-1', LastName='Account Manager',LanguageLocaleKey='en_US',
          LocaleSidKey='en_US', ProfileId = profile.Id,TimeZoneSidKey='America/Los_Angeles',
          UserName='test.user@sutter.com.pred');
    insert user;
    
    incList = new List<Incumbent_Carrier__c>();
    
    acc = new Account();
    acc.Name = 'Test Account';
    acc.RecordTypeId = accRecordTypeId;
    acc.NumberOfEmployees = 50;
    acc.Industry = 'Test Industry';
    insert acc;
    
    opp = new Opportunity();
    opp.Name = 'Test Oppty';
    opp.AccountId = acc.id;
    opp.type = 'Test type';
    opp.CloseDate = Date.Today();
    opp.StageName = 'Pending Broker';
    opp.Current_Status__c = 'No';
    opp.Renewed_Opportunity__c = true;
    insert opp;
    
    inc1 = new Incumbent_Carrier__c();
    inc1.RecordtypeId = incRecordTypeId2 ;
    inc1.Opportunity__c = opp.id;
    inc1.EE__c = '20';
    inc1.EC__c = '14';
    inc1.EF__c = '14';
    inc1.ES__c = '14';
    inc1.ECH__c = '14';
    inc1.EC_Renewal__c = '20';
    inc1.EE_Renewal__c = '14';
    inc1.EF_Renewal__c = '14';
    inc1.ES_Renewal__c = '14';
    inc1.ECH_Renewal__c = '24';
    
    inc2 = new Incumbent_Carrier__c();
    inc2 .RecordtypeId = incRecordTypeId2 ;
    inc2 .Opportunity__c = opp.id;
    
    inc3 = new Incumbent_Carrier__c();
    inc3 .RecordtypeId = incRecordTypeId2 ;
    inc3 .Opportunity__c = opp.id;
    
    inc4 = new Incumbent_Carrier__c();
    inc4 .RecordtypeId = incRecordTypeId2;
    inc4 .Opportunity__c = opp.id;
    
    inc5 = new Incumbent_Carrier__c();
    inc5 .RecordtypeId = incRecordTypeId2 ;
    inc5 .Opportunity__c = opp.id;
    
    inc = new Incumbent_Carrier__c();
    inc.RecordtypeId = incRecordTypeId;
    inc.Renewed_RFP_Form__c = true;
    inc.Opportunity__c = opp.id;
    
    incList.add(inc1);
    incList.add(inc2);
    incList.add(inc3);
    incList.add(inc4);
    incList.add(inc5);
    incList.add(inc);
    
    insert incList;
    
    census = new Census__c();
    census.Format_Match_Boolean__c = true;
    census.DOB__c = Date.today().addDays(-15);
    census.Opportunity__c = opp.id;
    census.Status__c = 'Errored';
    insert census;
    
    census1 = new Census__c();
    census1.Format_Match_Boolean__c = false;
    census1.Employee_Zip__c = '94577';
    census1.DOB__c = Date.today().addDays(-15);
    census1.Opportunity__c = opp.id;
    census1.Status__c = 'Successful';
    insert census1;
    
    zmaster = new Zip_Code_Master__c();
    zmaster.Zip_code__c = '94577'  ;
    zmaster.Region__c = 'East Bay';
    zmaster.County_1__c = 'Alameda' ;
   
    insert zmaster;
    //insert zipCodeList;
   
    List<Incumbent_Carrier__c> resultList = [Select Opportunity__r.name from Incumbent_Carrier__c  where Opportunity__c =: opp.id];
        
   // system.assertEquals('Test Oppty', resultList[0].Opportunity__r.name);
    //system.assertEquals('Test Oppty', resultList[1].Opportunity__r.name);
}


/* Test menthod to test the CSV upload functionality */
public static testMethod void TestMethod1() 
    {
    Test.startTest();
    setupTestData();  
        
    ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(inc);
    ApexPages.currentPage().getParameters().put('Id',inc.id);
    VFC45_SHP_RFPForm controller = new VFC45_SHP_RFPForm(sc);
    
    StaticResource testdoc = [Select Id,Body from StaticResource where name ='SHP_testMethodCSVUpload'];
    
    controller.contentFile= testdoc.Body;
    
    census1 = new Census__c();
    census1.Opportunity__c = opp.id;
    census1.Format_Match_Boolean__c = true;
    census1.Status__c = 'Errored';
    census1.DOB__c = Date.today().addDays(-15);
    census1.Employee_Zip__c = '94577';
    insert census1;
    
    zmaster = new Zip_Code_Master__c();
    zmaster.Zip_code__c = '94577'  ;
    zmaster.Region__c = 'East Bay';
    zmaster.County_1__c = 'Alameda' ;
    insert zmaster;
     
    controller.ReadFile();
    controller.searchRelatedIncumbentCarriers();
    controller.First();
    //controller.Previous();
    
    controller.Last();
    controller.getDisableNext();
    controller.getTotal_size();
    controller.getPageNumber();
    controller.getTotalPages();
    controller.getRedirectToCensusPage();
    //controller.getDocumentLogoUrl();
    controller.RedirectToOpportunity();
    controller.getIncumbentCarrierDataList();
    controller.saveForm();
    controller.getRFPTypes();
    
    StaticResource resultdoc = [Select name from StaticResource where name ='SHP_testMethodCSVUpload'];
    //system.assertEquals('SHP_testMethodCSVUpload', resultdoc.name);
    Test.stopTest();
    }
    
    
/* Test menthod to test pagination, redirection, accessing template from documents functionality */    
public static testMethod void TestMethod2() 
    {
    Test.startTest();
    setupTestData();   
    
    ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(inc);
    ApexPages.currentPage().getParameters().put('Id',inc.id);
    VFC45_SHP_RFPForm controller = new VFC45_SHP_RFPForm(sc);
    
    StaticResource testdoc = [Select Id,Body from StaticResource where name ='SHP_testMethodCSVUpload'];
    
    
    controller.contentFile= null;
    
    census1 = new Census__c();
    census1.Opportunity__c = opp.id;
    census1.DOB__c = null;
    insert census1;
    
    
    Integer result = math.mod(4,4);
    //if(result == 0){
    inc = new Incumbent_Carrier__c();
    inc.RecordtypeId = incRecordTypeId;
    inc.Renewed_RFP_Form__c = true;
    inc.Opportunity__c = opp.id;
    insert inc; 
    
            
    controller.ReadFile();
    
    controller.getIncumbentCarrierDataList();   
    
    controller.Next();
    controller.Previous();
    controller.Last();
    controller.saveForm();
    controller.getDisablePrevious();
    controller.getTotal_size();
    controller.getPageNumber();
    controller.getTotalPages();
    controller.getDisableNext();
    
    //controller.getDocumentLogoUrl();
    controller.getRedirectToCensusPage(); 
    controller.RedirectToOpportunity();
   
    StaticResource resultdoc = [Select name from StaticResource where name ='SHP_testMethodCSVUpload']; 
    //system.assertNotEquals(null, resultdoc.name);
    Test.stopTest();
    
    }
    
    public static testMethod void TestMethod3() 
    {
        Test.startTest();
        setupTestData();   
        
        try{
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(inc);
            VFC45_SHP_RFPForm controller = new VFC45_SHP_RFPForm(sc);
            StaticResource testdoc = [Select Id,Body from StaticResource where name ='SHP_testMethodCSVUpload'];
            
            controller.contentFile= null;
            controller.ReadFile();
            controller.saveForm(); 
              
            StaticResource resultdoc = [Select name from StaticResource where name ='SHP_testMethodCSVUpload']; 
            //system.assertNotEquals(null, resultdoc.name);
        Test.stopTest();
        }catch(Exception e){}
    }
    
   public static testMethod void TestMethod4() 
    {
    Test.startTest();
    Account acc1 = new Account();
    acc1.Name = 'Test Account';
    acc1.RecordTypeId = accRecordTypeId;
    acc1.NumberOfEmployees = 50;
    acc1.Industry = 'Test Industry';
    acc1.Employer_Type__c = 'Labor and Trust';
    insert acc1;
    
    Opportunity opp1 = new Opportunity();
    opp1.Name = 'Test Oppty';
    opp1.AccountId = acc1.id;
    opp1.type = 'Test type';
    opp1.CloseDate = Date.Today();
    opp1.StageName = 'Pending Broker';
    opp1.Current_Status__c = 'No';
    opp1.Renewed_Opportunity__c = true;
    insert opp1;
    
    Incumbent_Carrier__c inc6 = new Incumbent_Carrier__c();
    inc6.Opportunity__c = opp1.id;    
    insert inc6;
    inc6.id = null; 
    PageReference pref = Page.VFP45_SHP_RFPForm;
    pref.getParameters().put('Id',inc6.id);
    Test.setCurrentPage(pref); 
    ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(inc6);
    
    VFC45_SHP_RFPForm controller = new VFC45_SHP_RFPForm(sc);
      
    controller.saveForm();
    inc6.id = null;
    controller.RFPForm = inc6;
    controller.RelatedOpportunity = opp1;
    controller.RedirectToOpportunity();
   
    StaticResource resultdoc = [Select name from StaticResource where name ='SHP_testMethodCSVUpload']; 
   // system.assertNotEquals(null, resultdoc.name);
    Test.stopTest();
    }
    
    /*Test Method to test the Custom Validations added to RFP Form Page*/
    public static testMethod void TestCustomValidations(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(alias = 'al', email='test.user@sutter.com.dev', 
            emailencodingkey='UTF-8', lastname='lname', 
            languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', 
            username='test.user@sutter.com.dev');
        insert u;
        
        
              Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('SHP Sales Broker').RecordTypeId,
                                                  Name='Test Account SCN',
                                                  Status__c= 'Contracted',
                                                  NumberOfEmployees = 300,
                                                  type='Broker');
                Database.insert(testBrokerAccount);
            
                Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Sales Broker Contact').RecordTypeId,
                                                  LastName = 'Test contact',
                                                  AccountId = testBrokerAccount.Id,
                                                  Broker_Agent_Status__c = 'Prospect',
                                                  Type__c = 'Broker Rep'
                                                  );
                Database.insert(testContact);
        
            Account acc2 = new Account();
            acc2.Name = 'Test Account1';
            acc2.RecordTypeId = accRecordTypeId;
            acc2.NumberOfEmployees = 50;
            acc2.Industry = 'Hospitaity';
            acc2.Employer_Type__c = 'Labor and Trust';
            acc2.Broker__c = testBrokerAccount.id;
            acc2.Broker_Rep__c = testContact.id;
            insert acc2;
        
            Opportunity opp2 = new Opportunity();
            opp2.Name = 'Test Opp';
            opp2.AccountId = acc2.id;
            opp2.RecordTypeId = oppRecordTypeId;
            opp2.type = 'New Business';
            opp2.CloseDate = Date.Today()+30;
            opp2.StageName = 'Closed Won';
            opp2.Renewed_Opportunity__c = false;
            opp2.Broker1__c = testBrokerAccount.id;
            insert opp2;
            
            Incumbent_Carrier__c ic1 = new Incumbent_Carrier__c();
            ic1.RecordtypeId = incRecordTypeId2 ;
            ic1.Opportunity__c = opp2.id;
            ic1.EE__c = '14';
            ic1.EC__c = '14';
            ic1.EE__c = '14';
            ic1.ES__c = '14';
            ic1.ECH__c = '14';
            ic1.EC_Renewal__c = '14';
            ic1.EE_Renewal__c = '14';
            ic1.EF_Renewal__c = '14';
            ic1.ES_Renewal__c = '14';
            ic1.ECH_Renewal__c = '14';
            
            Incumbent_Carrier__c rfp = new Incumbent_Carrier__c();
             
            Test.setCurrentPage(Page.VFP45_SHP_RFPForm);
            ApexPages.currentPage().getParameters().put('OpportunityId',opp2.id);
            ApexPages.currentPage().getParameters().put('RecordTypeId',incRecordTypeId);
            
            /*Verify validation for SIC Code in Account Mandatory*/
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller = new VFC45_SHP_RFPForm(sc);
            controller.saveForm();
            controller.getRFPTypes();
        
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            //System.assertNotEquals(0, pageMessages.size());
            Boolean messageFound = false;
            for(ApexPages.Message message : pageMessages) {
                if(message.getDetail().contains(System.Label.HR94_SICCodeMandatory)) {
                    messageFound = true;        
                }
            }
            //System.assert(messageFound);
            Test.startTest();
            acc2.SIC_Code__c = '1234';
            update acc2;
            
            /*Verify validation for BillingCity in Account Mandatory*/
            ApexPages.Standardcontroller sc1 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller1 = new VFC45_SHP_RFPForm(sc1);
        
            ApexPages.Message[] pageMessages1 = ApexPages.getMessages();
            //System.assertNotEquals(0, pageMessages1.size());
            Boolean messageFound1 = false;
            for(ApexPages.Message message : pageMessages1) {
                if(message.getDetail().contains(System.Label.HR95_ERCityMandatory)) {
                    messageFound1 = true;        
                }
            }
            //System.assert(messageFound1);
        
            acc2.BillingCity = 'city1';
            update acc2;
        
            /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller2 = new VFC45_SHP_RFPForm(sc2);
        
            ApexPages.Message[] pageMessages2 = ApexPages.getMessages();
            //System.assertNotEquals(0, pageMessages2.size());
            Boolean messageFound2 = false;
            for(ApexPages.Message message : pageMessages2) {
                if(message.getDetail().contains(System.Label.HR96_SlicingWithCNameMandatory)) {
                    messageFound2 = true;        
                }
            }
            //System.assert(messageFound2);
        
            opp2.Slicing_with_Carrier_Name__c = 'Test Name1';
            update Opp2;
        
            /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc3 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller3 = new VFC45_SHP_RFPForm(sc3);
        
            ApexPages.Message[] pageMessages3 = ApexPages.getMessages();
            //System.assertNotEquals(0, pageMessages3.size());
            Boolean messageFound3 = false;
            for(ApexPages.Message message : pageMessages3) {
                if(message.getDetail().contains(System.Label.HR97_AccountExecutiveMandatory)) {
                    messageFound3 = true;        
                }
            }
            //System.assert(messageFound3);
        
            acc2.Account_Executive__c = u.id;
            update acc2;
        
            ApexPages.Standardcontroller sc4 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller4 = new VFC45_SHP_RFPForm(sc4);
        
            ApexPages.Message[] pageMessages4 = ApexPages.getMessages();
           // System.assertNotEquals(0, pageMessages4.size());
            Boolean messageFound4 = false;
            for(ApexPages.Message message : pageMessages4) {
                if(message.getDetail().contains(System.Label.HR98_OutofAreaEEMandatory)) {
                    messageFound4 = true;        
                }
            }
            //System.assert(messageFound4);
           Test.stopTest();
    }
    public static testMethod void TestCustomValidationsForAEUser(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(alias = 'al', email='test.user@sutter.com.dev', 
            emailencodingkey='UTF-8', lastname='lname', 
            languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', 
            username='test.user@sutter.com.dev');
        insert u;
        
         User AEUser = HighRoads_TestDataUtility.createAEUser();
         test.StartTest();
            System.runAs(AEUser){
                Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('SHP Sales Broker').RecordTypeId,
                                                  Name='Test Account SCN',
                                                  Status__c= 'Contracted',
                                                  NumberOfEmployees = 300,
                                                  type='Broker');
                Database.insert(testBrokerAccount);
            
                Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Sales Broker Contact').RecordTypeId,
                                                  LastName = 'Test contact',
                                                  AccountId = testBrokerAccount.Id,
                                                  Broker_Agent_Status__c = 'Prospect',
                                                  Type__c = 'Broker Rep'
                                                  );
                Database.insert(testContact);
            
                Account acc3 = new Account();
                acc3.Name = 'Test Account1';
                acc3.RecordTypeId = accRecordTypeId;
                acc3.NumberOfEmployees = 50;
                acc3.Industry = 'Hospitaity';
                acc3.SIC_Code__c = '1234';
                acc3.BillingCity = 'city1';
                acc3.Account_Executive__c = u.id;
                acc3.Employer_Type__c = 'Labor and Trust';
                acc3.Broker__c = testBrokerAccount.id;
                acc3.Broker_Rep__c = testContact.id;
                insert acc3;
            
                Opportunity opp3 = new Opportunity();
                opp3.Name = 'Test Opp';
                opp3.AccountId = acc3.id;
                opp3.RecordTypeId = oppRecordTypeId;
                opp3.type = 'New Business';
                opp3.CloseDate = Date.Today()+30;
                opp3.StageName = 'Closed Won';
                opp3.Slicing_with_Carrier_Name__c = 'name1';
                opp3.Out_of_Area__c = 123;
                opp3.RFP_Due_Date__c = Date.today()+30;
                opp3.Broker1__c = testBrokerAccount.id;
                opp3.Broker_Rep1__c = testContact.id;
                opp3.Contribution_s_EE__c = '12';
                opp3.Full_Time_Employees__c = 200;
                opp3.Waived__c = 10;
                opp3.Additional_Buy_Ups__c = 'Slice';
                opp3.Dependent_Contribution__c = '123';
                opp3.Plan_Effective_Date__c = Date.today();
                opp3.Group_Renewal_Date__c = Date.today()+360;
                opp3.Total_Subs_in_SHP_Service_Areas_SA__c = 123;
                //opp3.SHP_SA_Subs_minus_Valid_Waiver__c = 12;
                opp3.Total_SHP_SA_Subs_with_Valid_Waivers__c =12;
                opp3.Renewed_Opportunity__c = true;
                insert opp3;
                
                Incumbent_Carrier__c rfp = new Incumbent_Carrier__c();
             
                Test.setCurrentPage(Page.VFP45_SHP_RFPForm);
                ApexPages.currentPage().getParameters().put('OpportunityId',opp3.id);
                ApexPages.currentPage().getParameters().put('RecordTypeId',incRecordTypeId);
                
                ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(rfp);
                VFC45_SHP_RFPForm controller = new VFC45_SHP_RFPForm(sc);
                controller.saveForm();
                
                ApexPages.Message[] pageMessages = ApexPages.getMessages();
                //System.assertNotEquals(0, pageMessages.size());
                System.debug('ERROR SIZE>>>>'+pageMessages.size());
                Boolean messageFound = false;
                for(ApexPages.Message message : pageMessages) {
                    System.debug('error detail AE'+message.getDetail());
                    if(message.getDetail().contains('Mandatory')) {
                        messageFound = true;        
                    }
                }
                //System.assert(messageFound);
            } 
            test.StopTest();   
        }
    
     /*Test Method to test Custom Validations when User tries to create RFP for small Group*/
    public static testMethod void rfpCreationForSmallGroup(){
        Test.startTest();
            Account acc2 = new Account();
            acc2.Name = 'Test Account1';
            acc2.RecordTypeId = accRecordTypeId;
            acc2.NumberOfEmployees = 50;
            acc2.Industry = 'Hospitaity';
            acc2.Employer_Type__c = 'Small Group (1 - 50)';
            insert acc2;
        
            Opportunity opp2 = new Opportunity();
            opp2.Name = 'Test Opp';
            opp2.AccountId = acc2.id;
            opp2.RecordTypeId = oppRecordTypeId;
            opp2.type = 'New Business';
            opp2.CloseDate = Date.Today()+30;
            opp2.StageName = 'Closed Won';
            insert opp2;
            
            Incumbent_Carrier__c ic1 = new Incumbent_Carrier__c();
            ic1.RecordtypeId = incRecordTypeId2 ;
            ic1.Opportunity__c = opp2.id;
            insert ic1;
            
            Incumbent_Carrier__c rfp = new Incumbent_Carrier__c();
             
            Test.setCurrentPage(Page.VFP45_SHP_RFPForm);
            ApexPages.currentPage().getParameters().put('OpportunityId',opp2.id);
            ApexPages.currentPage().getParameters().put('RecordTypeId',incRecordTypeId);
            
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller = new VFC45_SHP_RFPForm(sc);
        
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            //System.assertNotEquals(0, pageMessages.size());
            Boolean messageFound = false;
            for(ApexPages.Message message : pageMessages) {
                if(message.getDetail().contains('RFP Can not be created for Small Group')) {
                    messageFound = true;        
                }
            }
            //System.assert(messageFound);  
    }
    
     /*Test Method to test Custom Validations when User tries to create RFP for Individual Business*/
    public static testMethod void rfpCreationForIndividual(){
        Test.startTest();
            Account acc2 = new Account();
            acc2.Name = 'Test Account1';
            acc2.Phone = '(88) 9547 5689';
            acc2.RecordTypeId = accIndRecordTypeId;
            insert acc2;
        
            Opportunity opp2 = new Opportunity();
            opp2.Name = 'Test Opp';
            opp2.AccountId = acc2.id;
            opp2.RecordTypeId = oppRecordTypeId;
            opp2.type = 'New Business';
            opp2.CloseDate = Date.Today()+30;
            opp2.StageName = 'Closed Won';
            opp2.Renewed_Opportunity__c = false;
            insert opp2;
            
            Incumbent_Carrier__c ic1 = new Incumbent_Carrier__c();
            ic1.RecordtypeId = incRecordTypeId2 ;
            ic1.Opportunity__c = opp2.id;
            insert ic1;
            
            Incumbent_Carrier__c rfp = new Incumbent_Carrier__c();
             
            Test.setCurrentPage(Page.VFP45_SHP_RFPForm);
            ApexPages.currentPage().getParameters().put('OpportunityId',opp2.id);
            ApexPages.currentPage().getParameters().put('RecordTypeId',incRecordTypeId);
            
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller = new VFC45_SHP_RFPForm(sc);
        
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            //System.assertNotEquals(0, pageMessages.size());
            Boolean messageFound = false;
            for(ApexPages.Message message : pageMessages) {
                if(message.getDetail().contains('RFP Can not be created for Individual Account')) {
                    messageFound = true;        
                }
            }
            //System.assert(messageFound);  
    }
     public static testMethod void TestCustomValidations1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(alias = 'al', email='test.user@sutter.com.dev', 
            emailencodingkey='UTF-8', lastname='lname', 
            languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', 
            username='test.user@sutter.com.dev');
        insert u;
        
        
              Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('SHP Sales Broker').RecordTypeId,
                                                  Name='Test Account SCN',
                                                  Status__c= 'Contracted',
                                                  NumberOfEmployees = 300,
                                                  type='Broker');
                Database.insert(testBrokerAccount);
            
                Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Sales Broker Contact').RecordTypeId,
                                                  LastName = 'Test contact',
                                                  AccountId = testBrokerAccount.Id,
                                                  Broker_Agent_Status__c = 'Prospect',
                                                  Type__c = 'Broker Rep'
                                                  );
                Database.insert(testContact);
        
            Account acc2 = new Account();
            acc2.Name = 'Test Account1';
            acc2.RecordTypeId = accRecordTypeId;
            acc2.NumberOfEmployees = 50;
            acc2.Industry = 'Hospitaity';
            acc2.Employer_Type__c = 'Labor and Trust';
            acc2.Broker__c = testBrokerAccount.id;
            acc2.Broker_Rep__c = testContact.id;
            acc2.BillingCity = 'city1';
            acc2.SIC_Code__c = '1234';
            acc2.Account_Executive__c = u.id;
            insert acc2;
        
            Opportunity opp2 = new Opportunity();
            opp2.Name = 'Test Opp';
            opp2.AccountId = acc2.id;
            opp2.RecordTypeId = oppRecordTypeId;
            opp2.type = 'New Business';
            opp2.CloseDate = Date.Today()+30;
            opp2.StageName = 'Closed Won';
            opp2.Renewed_Opportunity__c = true;
            opp2.Broker1__c = testBrokerAccount.id;
            opp2.Out_of_Area__c = 23;
            opp2.Slicing_with_Carrier_Name__c = 'Test Name1';
         
            insert opp2;
            
            Incumbent_Carrier__c ic1 = new Incumbent_Carrier__c();
            ic1.RecordtypeId = incRecordTypeId2 ;
            ic1.Opportunity__c = opp2.id;
            insert ic1;
            
            Incumbent_Carrier__c rfp = new Incumbent_Carrier__c();
             Test.startTest();
            Test.setCurrentPage(Page.VFP45_SHP_RFPForm);
            ApexPages.currentPage().getParameters().put('OpportunityId',opp2.id);
            ApexPages.currentPage().getParameters().put('RecordTypeId',incRecordTypeId);
            
            
         /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc5 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller5 = new VFC45_SHP_RFPForm(sc5);
        
            ApexPages.Message[] pageMessages5 = ApexPages.getMessages();
            //System.assertNotEquals(0, pageMessages5.size());
            Boolean messageFound5 = false;
            for(ApexPages.Message message : pageMessages5) {
                if(message.getDetail().contains(System.Label.HR88_RFPDueDateMandatory)) {
                    messageFound5 = true;        
                }
            }
            //System.assert(messageFound5);
        
            opp2.RFP_Due_Date__c = Date.today()+30;
            update Opp2;
        
            /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc6 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller6 = new VFC45_SHP_RFPForm(sc6);
        
            ApexPages.Message[] pageMessages6 = ApexPages.getMessages();
            //System.assertNotEquals(0, pageMessages6.size());
            Boolean messageFound6 = false;
            for(ApexPages.Message message : pageMessages6) {
                if(message.getDetail().contains(System.Label.HR99_BrokerRepMandatory)) {
                    messageFound6 = true;        
                }
            }
            //System.assert(messageFound6);
            
            opp2.Broker_Rep1__c = testContact.id;
            update Opp2;
            /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc7 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller7 = new VFC45_SHP_RFPForm(sc7);
        
            ApexPages.Message[] pageMessages7 = ApexPages.getMessages();
            //System.assertNotEquals(0, pageMessages7.size());
            Boolean messageFound7 = false;
            for(ApexPages.Message message : pageMessages7) {
                if(message.getDetail().contains(System.Label.HR100_ContributionsEEMandatory)) {
                    messageFound7 = true;        
                }
            }
            //System.assert(messageFound7);
        
            opp2.Contribution_s_EE__c = '123';
            update Opp2;
            /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc8 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller8 = new VFC45_SHP_RFPForm(sc8);
        
            ApexPages.Message[] pageMessages8 = ApexPages.getMessages();
            //System.assertNotEquals(0, pageMessages8.size());
            Boolean messageFound8 = false;
            for(ApexPages.Message message : pageMessages8) {
                if(message.getDetail().contains(System.Label.HR101_FulltimeEmployeesMandatory)) {
                    messageFound8 = true;        
                }
            }
            //System.assert(messageFound8);
        
            opp2.Full_Time_Employees__c = 300;
            update Opp2;
            /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc9 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller9 = new VFC45_SHP_RFPForm(sc9);
        
            ApexPages.Message[] pageMessages9 = ApexPages.getMessages();
           // System.assertNotEquals(0, pageMessages9.size());
            Boolean messageFound9 = false;
            for(ApexPages.Message message : pageMessages9) {
                if(message.getDetail().contains(System.Label.HR102_WaivedMandatory)) {
                    messageFound9 = true;        
                }
            }
         Test.stopTest();
            //System.assert(messageFound9);
     }
    
    public static testMethod void TestCustomValidations2(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(alias = 'al', email='test.user@sutter.com.dev', 
            emailencodingkey='UTF-8', lastname='lname', 
            languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', 
            username='test.user@sutter.com.dev');
        insert u;
        
        
              Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('SHP Sales Broker').RecordTypeId,
                                                  Name='Test Account SCN',
                                                  Status__c= 'Contracted',
                                                  NumberOfEmployees = 300,
                                                  type='Broker');
                Database.insert(testBrokerAccount);
            
                Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Sales Broker Contact').RecordTypeId,
                                                  LastName = 'Test contact',
                                                  AccountId = testBrokerAccount.Id,
                                                  Broker_Agent_Status__c = 'Prospect',
                                                  Type__c = 'Broker Rep'
                                                  );
                Database.insert(testContact);
        
            Account acc2 = new Account();
            acc2.Name = 'Test Account1';
            acc2.RecordTypeId = accRecordTypeId;
            acc2.NumberOfEmployees = 50;
            acc2.Industry = 'Hospitaity';
            acc2.Employer_Type__c = 'Labor and Trust';
            acc2.Broker__c = testBrokerAccount.id;
            acc2.Broker_Rep__c = testContact.id;
            acc2.BillingCity = 'city1';
            acc2.SIC_Code__c = '1234';
            acc2.Account_Executive__c = u.id;
            insert acc2;
        
            Opportunity opp2 = new Opportunity();
            opp2.Name = 'Test Opp';
            opp2.AccountId = acc2.id;
            opp2.RecordTypeId = oppRecordTypeId;
            opp2.type = 'New Business';
            opp2.CloseDate = Date.Today()+30;
            opp2.StageName = 'Closed Won';
            opp2.Renewed_Opportunity__c = true;
            opp2.Broker1__c = testBrokerAccount.id;
            opp2.Out_of_Area__c = 23;
            opp2.Slicing_with_Carrier_Name__c = 'Test Name1';
            opp2.RFP_Due_Date__c = Date.today()+30;
            opp2.Broker_Rep1__c = testContact.id;
            opp2.Contribution_s_EE__c = '123';
            opp2.Full_Time_Employees__c = 300;
            opp2.Waived__c = 50;
         Test.startTest();
            insert opp2;
            
            Incumbent_Carrier__c ic1 = new Incumbent_Carrier__c();
            ic1.RecordtypeId = incRecordTypeId2 ;
            ic1.Opportunity__c = opp2.id;
            insert ic1;
            
            Incumbent_Carrier__c rfp = new Incumbent_Carrier__c();
             
            Test.setCurrentPage(Page.VFP45_SHP_RFPForm);
            ApexPages.currentPage().getParameters().put('OpportunityId',opp2.id);
            ApexPages.currentPage().getParameters().put('RecordTypeId',incRecordTypeId);
            
            /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc10 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller10 = new VFC45_SHP_RFPForm(sc10);
        
            ApexPages.Message[] pageMessages10 = ApexPages.getMessages();
           // System.assertNotEquals(0, pageMessages10.size());
            Boolean messageFound10 = false;
            for(ApexPages.Message message : pageMessages10) {
                if(message.getDetail().contains(System.Label.HR90_ProposalScenarioMandatory)) {
                    messageFound10 = true;        
                }
            }
            //System.assert(messageFound10);
        
            opp2.Additional_Buy_Ups__c = 'Slice';
            update Opp2;
            /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc11 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller11 = new VFC45_SHP_RFPForm(sc11);
        
            ApexPages.Message[] pageMessages11 = ApexPages.getMessages();
            //System.assertNotEquals(0, pageMessages11.size());
            Boolean messageFound11 = false;
            for(ApexPages.Message message : pageMessages11) {
                if(message.getDetail().contains(System.Label.HR104_DependentContributionMandatory)) {
                    messageFound11 = true;        
                }
            }
           // System.assert(messageFound11);
            
            opp2.Dependent_Contribution__c = '30';
            update Opp2;
            /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc12 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller12 = new VFC45_SHP_RFPForm(sc12);
        
            ApexPages.Message[] pageMessages12 = ApexPages.getMessages();
           // System.assertNotEquals(0, pageMessages12.size());
            Boolean messageFound12 = false;
            for(ApexPages.Message message : pageMessages12) {
                if(message.getDetail().contains(System.Label.HR91_PlanEffectiveDateMandatory)) {
                    messageFound12 = true;        
                }
            }
           // System.assert(messageFound12);
        
            opp2.Plan_Effective_Date__c = Date.today();
            update Opp2;
            /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc13 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller13 = new VFC45_SHP_RFPForm(sc13);
        
            ApexPages.Message[] pageMessages13 = ApexPages.getMessages();
         //   System.assertNotEquals(0, pageMessages13.size());
            Boolean messageFound13 = false;
            for(ApexPages.Message message : pageMessages13) {
                if(message.getDetail().contains(System.Label.HR106_TotalSubsinSHPSAreaMandatory)) {
                    messageFound13 = true;        
                }
            }
           // System.assert(messageFound13);
        
            opp2.Total_Subs_in_SHP_Service_Areas_SA__c = 200;
            update Opp2;
            /*Verify validation for Slicing with Carrier Name in Opportunity Mandatory*/
            ApexPages.Standardcontroller sc14 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller14 = new VFC45_SHP_RFPForm(sc14);
        
            ApexPages.Message[] pageMessages14 = ApexPages.getMessages();
          //  System.assertNotEquals(0, pageMessages14.size());
            Boolean messageFound14 = false;
            for(ApexPages.Message message : pageMessages14) {
                if(message.getDetail().contains(System.Label.HR107_SHPSASubsminusValidWaiverMandatory)) {
                    messageFound14 = true;        
                }
            }
          //  System.assert(messageFound14);
        Test.stopTest();
     }
    
    public static testMethod void TestCustomValidations3(){
                Profile profile = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
            User user = new User(Alias = 'test', Email='test.user@sutter.com.pred',
                  EmailEncodingKey='ISO-8859-1', LastName='Account Manager',LanguageLocaleKey='en_US',
                  LocaleSidKey='en_US', ProfileId = profile.Id,TimeZoneSidKey='America/Los_Angeles',
                  UserName='test.user@sutter.com.pred');
            insert user;
        
              Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('SHP Sales Broker').RecordTypeId,
                                                  Name='Test Account SCN',
                                                  Status__c= 'Contracted',
                                                  NumberOfEmployees = 300,
                                                  type='Broker');
                Database.insert(testBrokerAccount);
            
                Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Sales Broker Contact').RecordTypeId,
                                                  LastName = 'Test contact',
                                                  AccountId = testBrokerAccount.Id,
                                                  Broker_Agent_Status__c = 'Prospect',
                                                  Type__c = 'Broker Rep'
                                                  );
                Database.insert(testContact);
        
            Account acc2 = new Account();
            acc2.Name = 'Test Account1';
            acc2.RecordTypeId = accRecordTypeId;
            acc2.NumberOfEmployees = 50;
            acc2.Industry = 'Hospitaity';
            acc2.Employer_Type__c = 'Labor and Trust';
            acc2.Broker__c = testBrokerAccount.id;
            acc2.Broker_Rep__c = testContact.id;
            acc2.BillingCity = 'city1';
            acc2.SIC_Code__c = '1234';
            acc2.Account_Executive__c = user.id;
            insert acc2;
        
            Opportunity opp2 = new Opportunity();
            opp2.Name = 'Test Opp';
            opp2.AccountId = acc2.id;
            opp2.RecordTypeId = oppRecordTypeId;
            opp2.type = 'New Business';
            opp2.CloseDate = Date.Today()+30;
            opp2.StageName = 'Closed Won';
            opp2.Renewed_Opportunity__c = true;
            opp2.Broker1__c = testBrokerAccount.id;
            opp2.Out_of_Area__c = 23;
            opp2.Slicing_with_Carrier_Name__c = 'Test Name1';
            opp2.RFP_Due_Date__c = Date.today()+30;
            opp2.Broker_Rep1__c = testContact.id;
            opp2.Contribution_s_EE__c = '123';
            opp2.Full_Time_Employees__c = 300;
            opp2.Waived__c = 50;
            opp2.Additional_Buy_Ups__c = 'Slice';
            opp2.Dependent_Contribution__c = '30';
            opp2.Plan_Effective_Date__c = Date.today();
            //opp2.SHP_SA_Subs_minus_Valid_Waiver__c = 200;
            opp2.Total_Subs_in_SHP_Service_Areas_SA__c = 200;
            opp2.Total_SHP_SA_Subs_with_Valid_Waivers__c = 100;
            insert opp2;
        
            Incumbent_Carrier__c rfp = new Incumbent_Carrier__c();
            
            Test.setCurrentPage(Page.VFP45_SHP_RFPForm);
            ApexPages.currentPage().getParameters().put('OpportunityId',opp2.id);
            //ApexPages.currentPage().getParameters().put('RecordTypeId',incRecordTypeId);
            
            ApexPages.Standardcontroller sc16 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller16 = new VFC45_SHP_RFPForm(sc16);
            controller16.getIncumbentCarrierDataList();
            
            rfp.No_of_Quotes_Requested__c = 12;
            controller16.saveForm();
            Test.setCurrentPage(Page.VFP45_SHP_RFPForm);
            ApexPages.currentPage().getParameters().put('OpportunityId',opp2.id);
            //ApexPages.currentPage().getParameters().put('RecordTypeId',incRecordTypeId);
            ApexPages.Standardcontroller sc17 = new ApexPages.Standardcontroller(rfp);
            VFC45_SHP_RFPForm controller17 = new VFC45_SHP_RFPForm(sc16);
            rfp.Reason_for_Market_Check__c = 'Renewal';
            controller17.saveForm();
            rfp.Tiered_Rates__c = '14';
            controller16.saveForm();
            rfp.Strategy_Statement__c = 'test';
            controller16.saveForm();
            rfp.Special_Instuctions__c = 'test data';
            controller16.saveForm();

     }
}