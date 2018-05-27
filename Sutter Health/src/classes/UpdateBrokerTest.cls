@isTest
private class UpdateBrokerTest {
    public static String ACNRECTYPE = 'SHP Sales Broker';
    public static String PARENTACCOUNTTYPE = 'SHP Sales Employer';
    public static String CONTACTRECTYPE = 'SHP Sales Broker Contact';

    static testMethod void UpdatePlTest()
    {

        Account acc = new Account();
        acc.Broker_Firm_HCC_ID__c = '545412';
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'SHP Sales Employer'];
        acc.recordtypeId = rt.id;
        //acc.Broker__c = NULL;
        //acc.Broker_Rep__c = NULL;
        acc.Name = 'Test Account';
        acc.Phone = '9876543210';
        //acc.Tax_ID__c = '0001';
        //acc.Account_TIN_Type__c = 'Tax-ID1';
            
        insert acc;
        //Assert to check Account is created successfully
        system.assert(acc.id!=null);
        
        Account acc1 = new Account();
        RecordType rt1 = [SELECT Id FROM RecordType WHERE Name = 'SHP Sales Broker'];
        acc1.Status__c = 'Contracted';
        acc1.recordtypeId = rt1.id;
        acc1.Broker_Firm_HCC_ID__c = '645412';
        //acc.Broker__c = NULL;
        //acc.Broker_Rep__c = NULL;
        acc1.Name = 'Test Account1';
        acc1.Phone = '9876543211';
        acc1.type = 'Broker';
        //acc1.Tax_ID__c = '0002';
        //acc1.Account_TIN_Type__c = 'Tax-ID';
            
        insert acc1;
        //Assert to check Account is created successfully
        system.assert(acc1.id!=null);
        
        Account acc2 = new Account();
        acc2.Broker_Firm_HCC_ID__c = '645412';
        //acc.Broker__c = NULL;
        //acc.Broker_Rep__c = NULL;
        acc2.Name = 'Test Account2';
        acc2.Phone = '9876543211';
        //acc2.Tax_ID__c = '0002';
        //acc2.Account_TIN_Type__c = 'Tax-ID';
            
        insert acc2;
        //Assert to check Account is created successfully
        system.assert(acc2.id!=null);
        
        Contact con = new Contact();
        RecordType rt2 = [SELECT Id FROM RecordType WHERE Name = 'SHP Sales Broker Contact'];
        con.FirstName = 'First Name';
        con.LastName =  'Last Name';
        con.AccountId = acc1.id;
        con.RecordTypeId=rt2.Id;
        con.Type__c = 'Broker Rep';
        con.Broker_Agent_Status__c = 'Prospect';
        insert con;
        //Assert to check Contact is created successfully
        system.assert(con.id!=null);
        
        Opportunity opp = new Opportunity();
        //opp.Broker_of_Record__c = true;
        opp.AccountId = acc.id;
        opp.Broker1__c = acc1.id;
        opp.Broker_Rep1__c = con.id;
        //opp.OverrideBrokerAndBrokerRep__c = true;
        opp.Name='Test Opportunity';
        opp.StageName='Prospecting';
        opp.CloseDate=system.Today();
        opp.RecordTypeID = System.label.SHP_Sales_Opportunity_Id;
        
        insert opp;
        //Assert to check Opportunity is created successfully
        system.assert(opp.id!=null);
        
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300,
                                          Broker__c = acc2.Id,
                                          Broker_Rep__c = con.Id);
         Database.insert(testAccount);
         
          Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300,
                                          Broker__c = acc2.Id,
                                          type='Broker',
                                          Broker_Rep__c = con.Id);
     
        Database.insert(testBrokerAccount);
        Test.startTest();
        Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep'
                                          );
                                        
        Database.insert(testContact);
        
        Opportunity testOpportunity2 = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Missing Information',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       OverrideBrokerAndBrokerRep__c = true,
                                                       Broker_of_Record__c = true,
                                                       Broker_Rep1__c = testContact.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity2);
        
        Opportunity testOpportunity3 = new Opportunity( Name = 'Test Opportunity SCN',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       OverrideBrokerAndBrokerRep__c = false,
                                                       Broker_of_Record__c = true,
                                                       Broker_Rep1__c = testContact.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id);
                                                       
        
        try{
                Database.insert(testOpportunity3);
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('Broker and Broker Rep are associated with this Account to override broker and broker rep please check "override Broker And BrokerRep" checkbox otherwise just unchecked "Broker of Record"') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
        Test.stopTest();     
    }
    
    /**
    * @author IDC Team
    * @date 10/07/2015
    * @description -- This testMethod is for testing the Latest Opportunity selection function of trigger Update broker for 
                      reporting purpose.
    * @Requirement : Req-3392 Sales Report Changes
    */
    public static testMethod void testOpportunityInsert() {
        List <Opportunity> OpprtunityListToInsert = new List<Opportunity>();
        List <Opportunity> OpportunityListToUpdate = new List<Opportunity>();
          
        Account testAccount = new Account (RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                           Name='Test Account',
                                           Status__c= 'Contracted',
                                           NumberOfEmployees = 300 );
           
        Database.insert(testAccount);
        // Assert to check Account is created successfully
        system.assert(testAccount.id!=null);
         
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                type ='Broker',
                                                NumberOfEmployees = 300);
       
        Database.insert(testBrokerAccount);
        // Assert to check Account is created successfully
        system.assert(testBrokerAccount.id!=null);
          
          
        CreatedDate__c createdDateCustomSetting = new CreatedDate__c (Name= 'CopyPcpDate',Created_date__c=System.Today());
        insert createdDateCustomSetting ;
        CS_ManageProfile__c custsetting2 = new CS_ManageProfile__c (Name='Communities_Provider',Profile_Name__c= 'Community Provider' );
        insert custsetting2 ;
        // Assert to check Custom Setting  is created successfully
        system.assert(custsetting2.id!=null);
          
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
                                          
        Database.insert(testContact);
          
        Id IdofContact = [SELECT Id FROM Contact limit 1].Id;
          
        for(Integer i=0; i<100 ; i++ ) {
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN'+i,
                                                       Type = 'New Business',
                                                       AccountId = IdofAccount,
                                                       StageName = 'Missing Information',
                                                       Amount = 450+i,
                                                       CloseDate = Date.today()+i,
                                                       Plan_end_date__c = Date.today()+i,
                                                       Broker1__c = IdofBrokerAccount,
                                                       Broker_Rep1__c = IdofContact,
                                                       Current_Status__c = 'Information Requested',
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
            OpprtunityListToInsert.add(testOpportunity);
        }
          
        Test.startTest();
        Database.insert(OpprtunityListToInsert);
        OpprtunityListToInsert[25].Amount = 1000;
        OpprtunityListToInsert[25].Plan_end_date__c = Date.today()+100;
        OpportunityListToUpdate.add(OpprtunityListToInsert[25]);
        checkRecursive.setRunTrue();
        Database.update(OpportunityListToUpdate);
        Test.stopTest();
        List<Opportunity> retrieveOppList = new List<Opportunity>([Select Id, Name ,Amount,Latest_Opportunity__c FROM Opportunity where RecordTypeID =: System.label.SHP_Sales_Opportunity_Id]);
        Opportunity LatestUpdatedOpp = [ SELECT Id,Name,Amount,Latest_Opportunity__c FROM Opportunity WHERE Amount = 1000 and RecordTypeID =: System.label.SHP_Sales_Opportunity_Id limit 1];
        Integer CountTrue = 0;
        Integer CountFalse = 0;
        for( Opportunity opp :retrieveOppList ) {
            if( opp.Latest_Opportunity__c == false ) {
                    CountFalse = CountFalse + 1;
            }
            else {
                  CountTrue = CountTrue + 1;
            }
        }
        system.assertEquals(CountFalse,99);
        system.assertEquals(CountTrue,1);

    }
     /**
    * @author IDC Team
    * @date 10/07/2016
    * @description -- This testMethod is for testing the Archive check box flag.
    * @Requirement : Req-3392 Sales Report Changes
    */
    public static testMethod void testOpportunityInsertwithArchiveContact() {
        Profile p = [SELECT Id FROM Profile WHERE Name like 'SHMMN%' limit 1]; 
        User testuser = new User(Alias = 'standt', Email='standarduser@testmethod.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testmethod909.com');
        insert testuser;
        
        system.runAs(testuser){
        List <Opportunity> OpprtunityListToInsert = new List<Opportunity>();
        List <Opportunity> OpportunityListToUpdate = new List<Opportunity>();
          
        Account testAccount = new Account (RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                           Name='Test Account',
                                           Status__c= 'Contracted',
                                           NumberOfEmployees = 300 );
           
        Database.insert(testAccount);
                 
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                Type ='Broker',
                                                NumberOfEmployees = 300);
       
        Database.insert(testBrokerAccount);
         Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep',
                                          archive__c = false
                                          );
                                        
        Database.insert(testContact);
        Test.startTest();
        Opportunity testOpportunity2 = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Missing Information',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       OverrideBrokerAndBrokerRep__c = true,
                                                       Broker_of_Record__c = true,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
        
        try{
            testOpportunity2.Broker_Rep1__c = testContact.Id;
            Database.insert(testOpportunity2);
        }catch(Exception e) {}
        
        try{
            testOpportunity2.Broker_Rep1__c = null;
            testOpportunity2.Account_Manager__c = testContact.Id;
            Database.insert(testOpportunity2);
        }catch(Exception e) {}
        
        try{
            testOpportunity2.Account_Manager__c  = null;
            testOpportunity2.Broker_Rep1__c = null;
            testOpportunity2.GA_Contact__c = testContact.Id;
            
            
            Database.insert(testOpportunity2);
        }catch(Exception e) {}
        Test.stopTest();
       }
    }
    
    /**
    * @author IDC Team
    * @date 10/07/2016
    * @description -- This testMethod is for testing the Archive check box flag.
    * @Requirement : Req-3392 Sales Report Changes
    */
    public static testMethod void testOpportunityUpdatewithArchiveContact() {
        List <Opportunity> OpprtunityListToInsert = new List<Opportunity>();
        List <Opportunity> OpportunityListToUpdate = new List<Opportunity>();
          
        Account testAccount = new Account (RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                           Name='Test Account',
                                           Status__c= 'Contracted',
                                           NumberOfEmployees = 300 );
           
        Database.insert(testAccount);
                 
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                Type ='Broker',
                                                NumberOfEmployees = 300);
        
        Account testBrokerAccount1 = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                Type ='General Agent',
                                                NumberOfEmployees = 300);
       
        Database.insert(testBrokerAccount);
        Insert testBrokerAccount1;
        
        Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep'
                                          );
                                        
        
        
       
        Contact testContact2 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep',
                                           Archive__c = false
                                          );
                                        
        
        
        Database.insert(testContact);
        Database.insert(testContact2);
        Account acObj = new Account(id=testAccount.id);
        acObj.Broker_Rep__c = testContact2.id;
        
        Contact testContact1 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount1.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'General Agent'
                                          );
        Test.startTest();
        update acObj;                              
        Database.insert(testContact1);
        
        
        
        Contact brokercon = new Contact(id=testContact.Id);
        brokercon.Archive__c = true;
        
        
        Contact gacon = new Contact(id=testContact1.Id);
        gacon.Archive__c = true;
        
        List<Contact> conList = new List<Contact>();
        conList.add(brokercon);
        conList.add(gacon);
       
        Opportunity testOpportunity2 = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Missing Information',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       OverrideBrokerAndBrokerRep__c = true,
                                                       Broker_of_Record__c = true,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       General_Agent__c = testBrokerAccount1.Id,
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
        testOpportunity2.Broker_Rep1__c = testContact.Id;
        testOpportunity2.Account_Manager__c = testContact.Id;
        testOpportunity2.GA_Contact__c = testContact1.Id;
        Database.insert(testOpportunity2);
        //Opportunity opp = [select id,Broker_Rep1__c,Account_Manager__c,GA_Contact__c from Opportunity where id=:testOpportunity2.Id];
        
        update conList;
        try{
            testOpportunity2.Broker_Rep1__c = brokercon.id;
            testOpportunity2.Account_Manager__c = null;
            testOpportunity2.GA_Contact__c = null;
            HighRoads_ArchivedContacts.isByPassValidationUpdated = true;
            update testOpportunity2;
        }catch(Exception e){
            
        }
        Test.stopTest();
    }
    
    /**
    * @author IDC Team
    * @date 10/07/2016
    * @description -- This testMethod is for testing the Archive check box flag.
    * @Requirement : Req-3392 Sales Report Changes
    */
    public static testMethod void testOpportunityUpdatewithArchiveContact1() {
        List <Opportunity> OpprtunityListToInsert = new List<Opportunity>();
        List <Opportunity> OpportunityListToUpdate = new List<Opportunity>();
          
        Account testAccount = new Account (RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                           Name='Test Account',
                                           Status__c= 'Contracted',
                                           NumberOfEmployees = 300 );
           
        Database.insert(testAccount);
                 
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                Type ='Broker',
                                                NumberOfEmployees = 300);
        
        Account testBrokerAccount1 = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                Type ='General Agent',
                                                NumberOfEmployees = 300);
       
        Database.insert(testBrokerAccount);
        Insert testBrokerAccount1;
         Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep'
                                          );
                                        
        Database.insert(testContact);
        
        Contact testContact1 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount1.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'General Agent'
                                          );
                                        
        Database.insert(testContact1);
         
        
        
        Contact brokercon = [select id,archive__c from contact where id=:testContact.Id];
        brokercon.Archive__c = true;
        
        
        Contact gacon = [select id,archive__c from contact where id=:testContact1.Id];
        gacon.Archive__c = true;
        
        
        Test.startTest();
        Opportunity testOpportunity2 = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Missing Information',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       OverrideBrokerAndBrokerRep__c = true,
                                                       Broker_of_Record__c = true,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       General_Agent__c = testBrokerAccount1.Id,
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
        testOpportunity2.Broker_Rep1__c = testContact.Id;
        testOpportunity2.Account_Manager__c = testContact.Id;
        testOpportunity2.GA_Contact__c = testContact1.Id;
        Database.insert(testOpportunity2);
        Opportunity opp = [select id,Broker_Rep1__c,Account_Manager__c,GA_Contact__c from Opportunity where id=:testOpportunity2.Id];
        update brokercon;
        update gacon;
        try{
            opp.Account_Manager__c = brokercon.id;
            opp.Broker_Rep1__c = null;
            opp.GA_Contact__c = null;
            HighRoads_ArchivedContacts.isByPassValidationUpdated = true;
            update opp;
        }catch(Exception e){
            
        }
        Test.stopTest();
    }
    
    /**
    * @author IDC Team
    * @date 10/07/2016
    * @description -- This testMethod is for testing the Archive check box flag.
    * @Requirement : Req-3392 Sales Report Changes
    */
    public static testMethod void testOpportunityUpdatewithArchiveContact2() {
        List <Opportunity> OpprtunityListToInsert = new List<Opportunity>();
        List <Opportunity> OpportunityListToUpdate = new List<Opportunity>();
          
        Account testAccount = new Account (RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                           Name='Test Account',
                                           Status__c= 'Contracted',
                                           NumberOfEmployees = 300 );
           
        Database.insert(testAccount);
                 
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                Type ='Broker',
                                                NumberOfEmployees = 300);
        
        Account testBrokerAccount1 = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                Type ='General Agent',
                                                NumberOfEmployees = 300);
       
        Database.insert(testBrokerAccount);
        Insert testBrokerAccount1;
         Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep'
                                          );
                                        
        Database.insert(testContact);
        
        Contact testContact1 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          AccountId = testBrokerAccount1.Id,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'General Agent'
                                          );
                                        
        Database.insert(testContact1);
         
        
        
        Contact brokercon = [select id,archive__c from contact where id=:testContact.Id];
        brokercon.Archive__c = true;
        
        
        Contact gacon = [select id,archive__c from contact where id=:testContact1.Id];
        gacon.Archive__c = true;
        
        Test.startTest();
        Opportunity testOpportunity2 = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Missing Information',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       OverrideBrokerAndBrokerRep__c = true,
                                                       Broker_of_Record__c = true,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       General_Agent__c = testBrokerAccount1.Id,
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
        testOpportunity2.Broker_Rep1__c = testContact.Id;
        testOpportunity2.Account_Manager__c = testContact.Id;
        testOpportunity2.GA_Contact__c = testContact1.Id;
        Database.insert(testOpportunity2);
        Opportunity opp = [select id,Broker_Rep1__c,Account_Manager__c,GA_Contact__c from Opportunity where id=:testOpportunity2.Id];
        update brokercon;
        update gacon;
        
        try{
            opp.Broker_Rep1__c = null;
            opp.Account_Manager__c = null;
            opp.GA_Contact__c = gacon.id;
            HighRoads_ArchivedContacts.isByPassValidationUpdated = true;
            update opp;
        }catch(Exception e){
            
        }
        Test.stopTest();
        
    }
    /**
    * @author IDC Team
    * @date 12/09/2016
    * @description -- This testMethod is for testing the Closed Opportunities and create scn for small group accounts.
    * @Requirement : Req-3980 Sales Report Changes
    */
    public static testMethod void testClosedWonOpportunity() {
        
        User AEUser = HighRoads_TestDataUtility.createAEUser();
        system.Runas(AEUser){
                
        List<SF_P2A_Market_Segments_Mapping__c> marketSegments = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegments;
        
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
        insert bpm;
        
        
        Account acc = new Account();
        acc.Name = 'Test Account1';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Individual').getRecordTypeId();
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Small Group (1 - 50)';
        insert acc;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SHP Sales Broker Contact').getRecordTypeId();
        con.Archive__c = true;
        con.LastName = 'Test';
        con.Phone = '1234567890';
        con.EMail = 'test@sutter.com';
        insert con;
                
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHP Sales Opportunity').getRecordTypeId();
        opp.type = 'New Business';
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.Today()+120;
        opp.Plan_Effective_Date__c = Date.Today();
        opp.Plan_end_date__c = Date.today()+360;
        opp.StageName = 'Pending Broker';
        opp.Renewed_Opportunity__c = false;
        insert opp;
        
        Document_Generation_Request__c dgr = new Document_Generation_Request__c();
        dgr.Opportunity__c =  opp.id;      
        dgr.Status__c = System.label.HR141_Draft; 
        dgr.Request_Status__c = System.label.HR141_Draft; 
        dgr.has_Custom_Plans__c = true;
        dgr.Expedite__c = false;
        dgr.Plans__c = 'SE08_2017_2017-01-01 ';
        insert dgr;
        
        Incumbent_Carrier__c rfp = new Incumbent_Carrier__c();
        rfp.RecordtypeId =  Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('RFP Form').getRecordTypeId();
        rfp.Opportunity__c = opp.id;
        insert rfp;
        
        Proposal__c quote = new Proposal__c();
        quote.Opportunity_ID__c = opp.id;
        quote.RFP_Form__c = rfp.id;
        insert quote;
        
        Sold_Sign_Off__c sso = new Sold_Sign_Off__c();
        sso.Opportunity_ID__c = opp.id;
        sso.Quote__c = quote.id;
        sso.SSO_RSO_Due_Date__c = Date.today()+60;
        sso.Stage__c = 'Draft';
        insert sso;
        
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Benefit_Plan_Metadata__c = bpm.id;
        bpa.SSO_Benefit_Version__c = 1;
        bpa.Sold_Sign_Off__c = sso.id;
        insert bpa;
        
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Benefit_Plan_Metadata__c = bpm.id;
        bpa1.Raider_ID__c = bpm.id;
        bpa1.SSO_Benefit_Version__c = 1;
        bpa1.Sold_Sign_Off__c = sso.id;
        bpa1.Opportunity__c = opp.id;
        insert bpa1;
        
        Benefit_Plan_Association__c bpa2 = new Benefit_Plan_Association__c();
        bpa2.Benefit_Plan_Metadata__c = bpm.id;
        bpa2.Sold_Sign_Off__c = sso.id;
        bpa2.SSO_Benefit_Version__c = 1;
        bpa2.Opportunity__c = opp.id;
        insert bpa2;
        
        Benefit_Plan_Association__c bpa3 = new Benefit_Plan_Association__c();
        bpa3.Benefit_Plan_Metadata__c = bpm.id;
        bpa3.Version_Number__c = 1;
        bpa3.Opportunity__c = opp.id;
        insert bpa3;
        AP01_TestDataUtility.runOnce = true;
        HighRoads_OpporutnityHelper.isOpportunityAfterUpdate = true;
        opp.StageName = 'Closed Won';
           Test.startTest();
        Update opp;
        Test.stopTest();

        }
        
        
    }
    /**
    * @author IDC Team
    * @date 12/09/2016
    * @description -- This testMethod is for testing the cloned opportunities
    * @Requirement : Req-3980 Sales Report Changes
    */
    public static testMethod void testMethodForRecordIdPopulatoin() {
        Account testAccount = new Account (RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                           Name='Test Account',
                                           Status__c= 'Contracted',
                                           NumberOfEmployees = 300 );
           
        Database.insert(testAccount);
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today(),
                                                       Plan_end_date__c = Date.today(),
                                                       Current_Status__c = 'Information Requested',
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
          
        Test.startTest();
        Insert testOpportunity;
        Opportunity testOpportunity2 = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today(),
                                                       Plan_end_date__c = Date.today(),
                                                      
                                                       Current_Status__c = 'Information Requested',
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS',
                                                       Record_ID__c = testOpportunity.Id);
        Insert testOpportunity2;
        Test.stopTest();
        }
     /**
    * @author IDC Team
    * @date 10/07/2015
    * @description -- This testMethod is for testing the associating the plans to opportunity after closed won
    * 				  reopen and associate new plans
    * @Requirement : Req-3392 Sales Report Changes
    */
    public static testMethod void testPlanSelectionChangeAfterClosedWon() {
        List<SF_P2A_Market_Segments_Mapping__c> p2aList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert p2aList;
        
        HighRoads_TestDataUtility.DocGenReqforInd();
        
        Account testAccount = new Account (RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                           Name='Test Account',
                                           Status__c= 'Contracted',
                                           NumberOfEmployees = 300,
                                           Employer_Type__c = 'Small Group (1 - 50)');
           
        Database.insert(testAccount);
                
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Pending Broker',
                                                       Amount = 450,
                                                       CloseDate = Date.today(),
                                                       Plan_end_date__c = Date.today(),
                                                       Plan_Effective_date__c = Date.parse('1/1/2016'),
                                                       Current_Status__c = 'Information Requested',
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
            
          
        Database.insert(testOpportunity);
        
        
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
        
        Insert bpmList;
        
        /* Inserting the benefit plan association records */
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Name = bpmList[0].Name;
        bpa.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa.Opportunity__c = testOpportunity.Id;
        bpaList.add(bpa);
        
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Name = bpmList[0].Name;
        bpa1.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa1.Raider_ID__c = bpmList[1].Id;
        bpa1.Opportunity__c = testOpportunity.Id;
        bpaList.add(bpa1);
        
        Insert bpaList;
        HighRoads_OpporutnityHelper.isOpportunityAfterUpdate = true;
        HighRoads_DocGenRequest.isOpportunityAfterUpdate = true;
        testOpportunity.StageName = 'Closed Won';
        Test.startTest();
        update testOpportunity;
        
        List<Benefit_Plan_Association__c> bpaList1 = [select id from Benefit_Plan_Association__c where Opportunity__c =:testOpportunity.Id];
        system.debug('bpaList1'+bpaList1);
        Document_Generation_Request__c dgrObj = [select id,Plans__c from Document_Generation_Request__c where Opportunity__c =:testOpportunity.Id];
        System.debug('dgrObj'+dgrObj);
        System.debug('dgrObj:::'+dgrObj.Plans__c);
        
        Employer_Group_Data__c updateSCN = [select id,stage__c from Employer_Group_Data__c where Opportunity__c =:testOpportunity.Id];
        updateSCN.Stage__c = 'Rejected';
        update updateSCN;
        
        testOpportunity.StageName = 'Pending Broker';
        HighRoads_OpporutnityHelper.isOpportunityAfterUpdate = true;
        update testOpportunity;
        
        Benefit_Plan_Association__c bpa4 = new Benefit_Plan_Association__c();
        bpa4.Name = bpmList[0].Name;
        bpa4.Benefit_Plan_Metadata__c = bpmList[2].Id;
        bpa4.Opportunity__c = testOpportunity.Id;
        insert bpa4;
        
        testOpportunity.StageName = 'Closed Won';
        HighRoads_OpporutnityHelper.isOpportunityAfterUpdate = true;
        update testOpportunity;
        
        Document_Generation_Request__c dgrObj1 = [select id,Plans__c from Document_Generation_Request__c where Opportunity__c =:testOpportunity.Id];
        System.debug('dgrObj:::'+dgrObj1.Plans__c);
        Test.stopTest();
    }
    
	
	 /**
    * @author IDC Team
    * @date 10/07/2015
    * @description -- This testMethod is for testing the associating the plans to opportunity after closed won
    * 				  reopen and associate new plans
    * @Requirement : Req-3392 Sales Report Changes
    */
    public static testMethod void testRiderPlanSelectionChangeAfterClosedWon() {
        List<SF_P2A_Market_Segments_Mapping__c> p2aList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert p2aList;
        
        HighRoads_TestDataUtility.DocGenReqforInd();
        
        Account testAccount = new Account (RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                           Name='Test Account',
                                           Status__c= 'Contracted',
                                           NumberOfEmployees = 300,
                                           Employer_Type__c = 'Small Group (1 - 50)');
           
        Database.insert(testAccount);
                
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Pending Broker',
                                                       Amount = 450,
                                                       CloseDate = Date.today(),
                                                       Plan_end_date__c = Date.today(),
                                                       Plan_Effective_date__c = Date.parse('1/1/2016'),
                                                       Current_Status__c = 'Information Requested',
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
            
          
        Database.insert(testOpportunity);
        
        /* Inserting the Metadata */
        List<Benefit_Plan_Metadata__c> bpmList = new List<Benefit_Plan_Metadata__c>();
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = Date.parse('1/1/2016');
        bpm.End_Date__c = Date.parse('12/31/2016');
        bpm.Market_Segment__c = 'Small Group';
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
        bpm.Unique_ID__c = 'HE02_2016_1/1/2016_12/31/2016';
        bpmList.add(bpm);
        
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02 - 2016';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = Date.parse('1/1/2016');
        bpm1.End_Date__c = Date.parse('12/31/2016');
        bpm1.Market_Segment__c = 'Small Group';
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
        bpm1.Unique_ID__c = 'XA02_2016_1/1/2016_12/31/2016';
        bpmList.add(bpm1);
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'XA03';
        bpm2.Medical_OR_Rider__c = 'Rider';
        bpm2.Product_Class__c = 'Rider';
        bpm2.Effective_Date__c = Date.parse('1/1/2016');
        bpm2.End_Date__c = Date.parse('12/31/2016');
        bpm2.Market_Segment__c = 'Small Group';
        bpm2.Plan_Type__c = 'Custom';
        bpm2.Ancillary_EOC__c = true;
        bpm2.Ancillary_GSA__c = true;
        bpm2.Ancillary_SOB__c = true;
        bpm2.EOC__c = false;
        bpm2.BCM__c = false;
        bpm2.SBC__c = false;
        bpm2.Benefit_Plan_ID__c = 'XA03';
        bpm2.Plan_Status__c = 'Available for Sale - Approved';
        bpm2.Plan_Year__c = '2016';
        bpm2.Unique_ID__c = 'XA03_2016_1/1/2016_12/31/2016';
        bpmList.add(bpm2);
        
        Insert bpmList;
        
        /* Inserting the benefit plan association records */
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Benefit_Plan_Association__c bpa = new Benefit_Plan_Association__c();
        bpa.Name = bpmList[0].Name;
        bpa.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa.Opportunity__c = testOpportunity.Id;
        bpaList.add(bpa);
        
        Benefit_Plan_Association__c bpa1 = new Benefit_Plan_Association__c();
        bpa1.Name = bpmList[0].Name;
        bpa1.Benefit_Plan_Metadata__c = bpmList[0].Id;
        bpa1.Raider_ID__c = bpmList[1].Id;
        bpa1.Opportunity__c = testOpportunity.Id;
        bpaList.add(bpa1);
        
        Insert bpaList;
        HighRoads_OpporutnityHelper.isOpportunityAfterUpdate = true;
        HighRoads_DocGenRequest.isOpportunityAfterUpdate = true;
        testOpportunity.StageName = 'Closed Won';
        Test.startTest();
        update testOpportunity;
        
        List<Benefit_Plan_Association__c> bpaList1 = [select id from Benefit_Plan_Association__c where Opportunity__c =:testOpportunity.Id];

        Document_Generation_Request__c dgrObj = [select id,Plans__c from Document_Generation_Request__c where Opportunity__c =:testOpportunity.Id];
        
        Employer_Group_Data__c updateSCN = [select id,stage__c from Employer_Group_Data__c where Opportunity__c =:testOpportunity.Id];
        updateSCN.Stage__c = 'Rejected';
        update updateSCN;
        
        testOpportunity.StageName = 'Pending Broker';
        HighRoads_OpporutnityHelper.isOpportunityAfterUpdate = true;
        update testOpportunity;
        
       		bpa1.Opportunity__c = null;
           update bpa1;
        
        testOpportunity.StageName = 'Closed Won';
        HighRoads_DocGenRequest.isOpportunityAfterUpdate = true;
        HighRoads_OpporutnityHelper.isOpportunityAfterUpdate = true;
        update testOpportunity;
        
        Document_Generation_Request__c dgrObj1 = [select id,Plans__c from Document_Generation_Request__c where Opportunity__c =:testOpportunity.Id];
		Test.stopTest();
    }
}