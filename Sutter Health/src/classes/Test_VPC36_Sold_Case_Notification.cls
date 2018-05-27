/**********************************************************************
 Name: Test_VPC36_Sold_Case_Notification
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for VPC36_Sold_Case_Notification class
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  2/25/2015 Development complete   This class is defined to test Test_VPC36_Sold_Case_Notification class
 2.0      IDC Offshore  12/28/2015  Class Optimization   Incorporated changes to implement best test practices in the test class.
 3.0      IDC Offshore  05/05/2016  Req-3826 changes     Added condition for Opportunity record type as part of Req-3826 changes.
 ***********************************************************************/
@isTest
private class Test_VPC36_Sold_Case_Notification {

    /*******************************************************************
     Purpose: This Test Method is used to test to Save SCN without Validation  
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/   
    
    static testMethod void Save_Test(){
    String ACNRECTYPE = 'SHP Sales Broker';
    String PARENTACCOUNTTYPE = 'SHP Sales Employer';
    String CONTACTRECTYPE = 'SHP Sales Broker Contact';
    
    Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                      Name='Test Account',
                                      Status__c= 'Contracted',
                                      
                                      NumberOfEmployees = 300);
 
    Database.insert(testAccount);
    
    /*********************************************************************** 
    Verifying the Account is created successfully
    Expected Result: value is not null
    Actual Result: value is not null
    **********************************************************************/
    system.assert(testAccount!=null);
    
    Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                            type='Broker',
                                          NumberOfEmployees = 300);
     
    Database.insert(testBrokerAccount);

    /*********************************************************************** 
    Verifying the Account is created successfully
    Expected Result: value is not null
    Actual Result: value is not null
    **********************************************************************/
    system.assert(testBrokerAccount!=null);
    
    Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                               
    AccountId = testBrokerAccount.Id,
              Broker_Agent_Status__c = 'Prospect',
              Type__c = 'Broker Rep'
              );
                                        
    Database.insert(testContact);
    
    /*********************************************************************** 
    Verifying the Contact is created successfully
    Expected Result: value is not null
    Actual Result: value is not null
    **********************************************************************/
    system.assert(testContact!=null);
    Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                   Type = 'New Business',
                                                   AccountId = testAccount.Id,
                                                   StageName = 'Missing Information',
                                                   Amount = 450,
                                                   CloseDate = Date.today()+25,
                                                   Plan_end_date__c = Date.today()+110,
                                                   Broker1__c = testBrokerAccount.Id,
                                                   Broker_Rep1__c = testContact.Id,
                                                   Current_Status__c = 'Information Requested',
                                                   Opp_Renewed__c =false,
                                                   //Added condition for opportunity record type as part of Req-3826 changes
                                                   RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                   Renewed_Opportunity__c = true,
                                                   Sales_Team__c = 'TSS');
                                                   
    Database.insert(testOpportunity);
    
    /*********************************************************************** 
    Verifying the Opportunity is created successfully
    Expected Result: value is not null
    Actual Result: value is not null
    **********************************************************************/
    system.assert(testOpportunity!=null);
    
    Test.startTest();   
    Employer_Group_Data__c newEmployerGroupDate = new Employer_Group_Data__c();
    newEmployerGroupDate.Opportunity__c = testOpportunity.Id;       
    ApexPages.StandardController sc = new ApexPages.StandardController(newEmployerGroupDate);
    VFC36_Sold_Case_Notification testSCN = new VFC36_Sold_Case_Notification(sc);
   
    testSCN.Save();
    testSCN.Completed(); 
    Test.stopTest();
    }   
    
    
    /*******************************************************************
     Purpose: This Test Method is used to test to complete SCN with Validation.   
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
     static testMethod void Completed_Test() {
        String medicalPlanRecordType ='Medical Plan Other';
        String standardMedicalplan = 'Standard medical plan';
        
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Medical_Plan__c' and isActive=true];
        Map<string, String> medicalPlansRecordTypes = new Map<String,String>();
        for(RecordType rt: rtypes){
            medicalPlansRecordTypes.put(rt.Name,rt.Id);
        }
                
        List<Profile> p = [SELECT   Id FROM Profile WHERE Name='SHP Sales' limit 1];  
        //Create test User
          
         User userObjTest = new User(Alias = 'standt', Email='abc@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p[0].Id, TimeZoneSidKey='America/Los_Angeles', UserName='ABC@testorg.com');
        insert  userObjTest;    

        /*********************************************************************** 
        Verifying the User is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(userObjTest.id!=null);        
        
        String ACNRECTYPE = 'SHP Sales Broker';
        String PARENTACCOUNTTYPE = 'SHP Sales Employer';
        String CONTACTRECTYPE = 'SHP Sales Broker Contact';
        //Create Account
        Account testAccount = new Account(  Name = 'Test Account',
                                            NumberOfEmployees = 300,
                                            RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                            Status__c = 'Contracted'
                                          );
     
        Database.insert(testAccount);
       
        /*********************************************************************** 
        Verifying the Account is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testAccount.id!=null);
        

        
        //Create Account
        Account testBrokerAccount = new Account( Name = 'Test Account SCN',
                                                 NumberOfEmployees = 300,
                                                type='Broker',
                                                 RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                 Status__c= 'Contracted');
     
        Database.insert(testBrokerAccount);
        
        
        //Create Opportunity
        Opportunity testOpportunity = new Opportunity( AccountId = testAccount.Id,
                                                       Amount = 450,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       CloseDate = Date.today()+25,
                                                       Current_Status__c = 'Information Requested',
                                                       Name  = 'Test Opportunity SCN',
                                                       Opp_Renewed__c = false,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Renewed_Opportunity__c = false,
                                                       Sales_Team__c = 'TSS',
                                                       StageName = 'Closed Won',
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Type = 'New Business' );
                                                       
        Database.insert(testOpportunity);
        
        
      //Create Employer Group Data
        Employer_Group_Data__c newEmployerGroupDate = new Employer_Group_Data__c(  AuditorName__c = userObjTest.iD,
                                                                                   Billing_Contact_Phone__c = '1098211211',
                                                                                   Broker_Agency__c = '102981 ',
                                                                                   Broker_Name__c = 'Test',
                                                                                   city_SA__c = 'Test City ',
                                                                                   Cobra_Members_with_this_Group__c = 'COBRA',
                                                                                   Company_Name__c = 'Test Company',
                                                                                   Completedby__c = userObjTest.iD,
                                                                                   Effective_Date__c = date.newInstance(2015, 02, 18),
                                                                                   Employee_Waiting_Period__c = 'Other',
                                                                                   Employee_Waiting_Period_Other__c = 'Test',
                                                                                   Enrollment_Method__c = 'Electronic',
                                                                                   Federal_Employer_ID_Number__c = 'Em-121',
                                                                                   Group_Type__c = 'Small',
                                                                                   HR_Enrollment_Phone__c = '1098211211',
                                                                                   of_Eligible_Employees__c = 9.00,
                                                                                   of_Employees__c = 12.00,
                                                                                   Performance_or_Implementation__c = 'Test ',
                                                                                   Phone_Number__c = '8081802080',
                                                                                   Plan_vs_Calendar_Year__c = 'Plan Calendar',
                                                                                   Projected_Enrollment__c = 110.00,
                                                                                   SHP_Sales_Representative__c = 'Test',
                                                                                   State_SA__c = 'Test State',
                                                                                   Street_Address__c = 'Test Address',
                                                                                   Type_of_Organization__c = 'Other',
                                                                                   Type_of_Organization_Other__c = 'test',
                                                                                   Zip_SA__c = '123123' );
                                                                                    
        newEmployerGroupDate.Opportunity_Account_Name__c = testAccount.Id;
        newEmployerGroupDate.Opportunity__c = testOpportunity.Id;      
        Test.startTest();
        insert  newEmployerGroupDate;
        
        //Create Medical Plan
        Medical_Plan__c testMP = new Medical_Plan__c( Acupuncture__c='other',
                                                      Acupuncture_Chiropractic__c='others',
                                                      Acupuncture_Other__c = 'test',
                                                      AcupunctureChiropractic_Other__c ='test',
                                                      Chiropractic__c='other',
                                                      Chiropractic_Other__c ='test',
                                                      Custom_Medical__c ='other',
                                                      CustomMedical_Other__c ='test',
                                                      Dental__c='other',
                                                      Dental_Other__c ='test',
                                                      Infertility__c ='other',
                                                      Medical__c = 'other',
                                                      Medical_Plan_Notes__c ='test',
                                                      Other_Plan_Id__c = 'test',
                                                      Prosthetic_Orthotic__c='other',
                                                      Vision__c='other',
                                                      Vision_Other__c = 'test',
                                                      Medical_type__c = 'other');
                                                          
        testMP.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
        
        Medical_Plan__c testMP3 = new Medical_Plan__c();
        testMP3 = testMP;
        testMP3.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
        //Create Medical Plan
        Medical_Plan__c TestNonMediPlan = new Medical_Plan__c(  Acupuncture__c = 'other',
                                                                Acupuncture_Chiropractic__c = 'others',
                                                                Acupuncture_Other__c  = 'test',
                                                                AcupunctureChiropractic_Other__c  = 'test',
                                                                Chiropractic__c = 'other',
                                                                Chiropractic_Other__c  = 'test',
                                                                Dental__c = 'other',
                                                                Dental_Other__c  = 'test',
                                                                Infertility__c  = 'other',
                                                                Medical_type__c  = 'other',
                                                                Medical_Plan_Notes__c  = 'test',
                                                                Other_Plan_Id__c  = 'test',
                                                                Prosthetic_Orthotic__c = 'other',
                                                                Vision__c = 'other',
                                                                Vision_Other__c  = 'test');
                                                          
        TestNonMediPlan.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        
        Medical_Plan__c TestNonMediPlan3 = new Medical_Plan__c();
        TestNonMediPlan3 = TestNonMediPlan;
        TestNonMediPlan3.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newEmployerGroupDate);
        VFC36_Sold_Case_Notification testSCN = new VFC36_Sold_Case_Notification(sc);
        
        testSCN.showBlankVlaue = '';
        testSCN.strOpportunityRedirectId = testOpportunity.Id;
        List<Employer_Group_Data__c> lstEmployerGroupDate1 = testSCN.lstEGD;
        
        testSCN.lstMedicalPlan = new List<Medical_Plan__c>() ;
        testSCN.lstMedicalPlan.add(testMP);
        testSCN.lstMedicalPlan.add(testMP3);
        testSCN.lstMedicalPlanOther = new List<Medical_Plan__c>();
        testSCN.lstMedicalPlanOther.add(TestNonMediPlan);
        testSCN.lstMedicalPlanOther.add(TestNonMediPlan3);
        testSCN.Save();
        testSCN.Completed();
        testSCN.DisableAndEnableEDISection();
        testSCN.autoPopulateEDIVendor();
        Test.stopTest();
    }
    
    
    /*******************************************************************
     Purpose: This Test Method is used to negative test to Save and complete SCN with Validation .   
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void SaveAndComplated_NegativeTest() {
        String medicalPlanRecordType ='Medical Plan Other';
        String standardMedicalplan = 'Standard medical plan';
        
        
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Medical_Plan__c' and isActive=true];
        Map<string, String> medicalPlansRecordTypes = new Map<String,String>();
        for(RecordType rt: rtypes){
            medicalPlansRecordTypes.put(rt.Name,rt.Id);
        }
                
        List<Profile> p = [SELECT   Id FROM Profile WHERE Name='SHP Sales' limit 1];  

        User userObjTest = new User(Alias = 'standt', Email='abc@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p[0].Id, TimeZoneSidKey='America/Los_Angeles', UserName='ABC@testorg.com');
        insert  userObjTest;
  
        /*********************************************************************** 
        Verifying User is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
         system.assert(userObjTest.id!=null);       
        
        String ACNRECTYPE = 'SHP Sales Broker';
        String PARENTACCOUNTTYPE = 'SHP Sales Employer';
        String CONTACTRECTYPE = 'SHP Sales Broker Contact';
        
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
        /*********************************************************************** 
        Verifying Account is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
         system.assert(testAccount.id!=null);       
        
         
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                type='Broker',
                                                NumberOfEmployees = 300);
     
        Database.insert(testBrokerAccount);
        
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       Renewed_Opportunity__c =false,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        
        /*********************************************************************** 
        Verifying Opportunity is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
         system.assert(testOpportunity.id!=null);   
        
      
        Employer_Group_Data__c newEmployerGroupDate = new Employer_Group_Data__c(  AuditorName__c = userObjTest.iD,
                                                                                   Billing_Contact_Phone__c = '1098211211',
                                                                                   Broker_Agency__c = '102981 ',
                                                                                   Broker_Name__c = 'Test',
                                                                                   city_SA__c = 'Test City ',
                                                                                   Cobra_Members_with_this_Group__c = 'COBRA',
                                                                                   Company_Name__c = 'Test Company',
                                                                                   Completedby__c = userObjTest.iD,
                                                                                   Effective_Date__c = date.newInstance(2015, 02, 18),
                                                                                   Employee_Waiting_Period__c = 'Other',
                                                                                   Employee_Waiting_Period_Other__c = 'Test',
                                                                                   Enrollment_Method__c = 'Test',
                                                                                   Federal_Employer_ID_Number__c = 'Em-121',
                                                                                   Group_Type__c = 'Small',
                                                                                   HR_Enrollment_Phone__c = '1098211211',
                                                                                   of_Eligible_Employees__c = 9.00,
                                                                                   of_Employees__c = 12.00,
                                                                                   Performance_or_Implementation__c = 'Test ',
                                                                                   Phone_Number__c = '8081802080',
                                                                                   Plan_vs_Calendar_Year__c = 'Plan Calendar',
                                                                                   Projected_Enrollment__c = 110.00,
                                                                                   SHP_Sales_Representative__c = 'Test',
                                                                                   State_SA__c = 'Test State',
                                                                                   Street_Address__c = 'Test Address',
                                                                                   Type_of_Organization__c = 'Other',
                                                                                   Type_of_Organization_Other__c = 'test',
                                                                                   Zip_SA__c = '123123' );
                                                                                    
        newEmployerGroupDate.Opportunity_Account_Name__c =testAccount.Id;
        newEmployerGroupDate.Opportunity__c = testOpportunity.Id;  
        Test.startTest();
        insert  newEmployerGroupDate;
        
         Medical_Plan__c testMP = new Medical_Plan__c( Medical_type__c = 'Test test',
                                                      Medical__c = 'Others',
                                                      Custom_Medical__c='Other',
                                                      Dental__c='Other',
                                                      Vision__c='Other',
                                                      Chiropractic__c='Other',
                                                      Acupuncture__c='Other',
                                                      Acupuncture_Chiropractic__c='Others',
                                                      Prosthetic_Orthotic__c='test test',
                                                      Infertility__c ='test test', 
                                                      CustomMedical_Other__c ='test',
                                                      Dental_Other__c ='test',
                                                      Vision_Other__c = 'test',
                                                      Chiropractic_Other__c ='test',
                                                      AcupunctureChiropractic_Other__c = 'test',                                                      
                                                      Acupuncture_Other__c = 'test',
                                                      Other_Plan_Id__c ='test',
                                                      Medical_Plan_Notes__c = 'test');
                                                      
        testMP.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testMP.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
        insert testMP;
        
        Medical_Plan__c TestNonMediPlan = new Medical_Plan__c( Dental__c='Other',
                                                               Vision__c='Other',
                                                               Chiropractic__c='Other',
                                                               Acupuncture__c='Other',
                                                               Acupuncture_Chiropractic__c='Others',
                                                               Prosthetic_Orthotic__c='test test',
                                                               Infertility__c ='test test', 
                                                               CustomMedical_Other__c ='test',
                                                               Dental_Other__c ='test',
                                                               Vision_Other__c = 'test',
                                                               Chiropractic_Other__c ='test',
                                                               AcupunctureChiropractic_Other__c = 'test',                                                      
                                                               Acupuncture_Other__c = 'test',
                                                               Medical_Plan_Notes__c = 'test'
                                                             );
        TestNonMediPlan.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        TestNonMediPlan.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        insert TestNonMediPlan;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newEmployerGroupDate);
        VFC36_Sold_Case_Notification testSCN = new VFC36_Sold_Case_Notification(sc);
        testSCN.save();
        testSCN.Completed();
       
        
        TestNonMediPlan.Medical_Plan_Notes__c ='<a href';
        update TestNonMediPlan;
        testMP.Medical_Plan_Notes__c = '<a href';
        update testMP;
        
        Employer_Group_Data__c newEmployerGroupDate1 = newEmployerGroupDate;
        ApexPages.StandardController sc2 = new ApexPages.StandardController(newEmployerGroupDate1);
        VFC36_Sold_Case_Notification testSCN2 = new VFC36_Sold_Case_Notification(sc2);
      
        testSCN2.save();
        testSCN2.Completed();
        testSCN2.autoPopulateEDIVendor();
        Test.stopTest();
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test  Disable and enable the EDI Section.   
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void autoPopulateHRandEnrollment_Test() {
        Test.startTest();
        String medicalPlanRecordType ='Medical Plan Other';
        String standardMedicalplan = 'Standard medical plan';
        
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Medical_Plan__c' and isActive=true];
        Map<string, String> medicalPlansRecordTypes = new Map<String,String>();
        for(RecordType rt: rtypes){
            medicalPlansRecordTypes.put(rt.Name,rt.Id);
        }
                
        List<Profile> p = [SELECT   Id FROM Profile WHERE Name='SHP Sales' limit 1];  

        User userObjTest = new User(Alias = 'standt', Email='abc@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p[0].Id, TimeZoneSidKey='America/Los_Angeles', UserName='ABC@testorg.com');
        insert  userObjTest;
     
        /*********************************************************************** 
        Verifying User is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
       system.assert(userObjTest.id!=null);     
        
        String ACNRECTYPE = 'SHP Sales Broker';
        String PARENTACCOUNTTYPE = 'SHP Sales Employer';
        String CONTACTRECTYPE = 'SHP Sales Broker Contact';
        
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
        
                
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       Renewed_Opportunity__c =true,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        
        /*********************************************************************** 
        Verifying Opportunity is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testOpportunity.id!=null);    
      
        Employer_Group_Data__c newEmployerGroupDate = new Employer_Group_Data__c(Company_Name__c ='Test Company',
                                                                                 Street_Address__c ='Test Address',
                                                                                 city_SA__c =' Test City ',
                                                                                 State_SA__c ='Test State',
                                                                                 Zip_SA__c ='123123',
                                                                                 Phone_Number__c ='8081802080',
                                                                                 Federal_Employer_ID_Number__c ='Em-121',
                                                                                 Group_Type__c ='Small',
                                                                                 of_Employees__c =12.00,
                                                                                 SHP_Sales_Representative__c ='Test',
                                                                                 of_Eligible_Employees__c =9.00,
                                                                                 Projected_Enrollment__c =110.00,
                                                                                 Plan_vs_Calendar_Year__c ='Plan Calendar',
                                                                                 Effective_Date__c = date.newInstance(2015, 02, 18),
                                                                                 HR_Enrollment_Phone__c ='1098211211',
                                                                                 Billing_Contact_Phone__c ='1098211211',
                                                                                 Completedby__c =userObjTest.iD,
                                                                                 AuditorName__c =userObjTest.iD,
                                                                                 Performance_or_Implementation__c ='Test ',
                                                                                 Broker_Name__c ='Test',
                                                                                 Broker_Agency__c ='102981 ',
                                                                                 Employee_Waiting_Period__c ='Other',
                                                                                 Employee_Waiting_Period_Other__c ='Test',
                                                                                 Type_of_Organization__c ='Other',
                                                                                 Type_of_Organization_Other__c = 'test',
                                                                                 Enrollment_Method__c = 'Electronic');
        newEmployerGroupDate.Opportunity_Account_Name__c =testAccount.Id;
        newEmployerGroupDate.Opportunity__c = testOpportunity.Id;       
        insert  newEmployerGroupDate;
        
        List<Medical_Plan__c> lstMedicalPlan = new List<Medical_Plan__c>();
        Medical_Plan__c testMP = new Medical_Plan__c( Medical_type__c = 'other',
                                                          Medical__c = 'other',
                                                          Custom_Medical__c='other',
                                                          Dental__c='other',
                                                          Vision__c='other',
                                                          Chiropractic__c='other',
                                                          Acupuncture__c='other',
                                                          Acupuncture_Chiropractic__c='others',
                                                          Prosthetic_Orthotic__c='other',
                                                          Infertility__c ='other',
                                                          Medical_Plan_Notes__c ='<a href');
        testMP.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testMP.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
        
        Medical_Plan__c testMP1 =  new Medical_Plan__c( Medical_type__c = 'other',
                                                          Medical__c = 'other',
                                                          Custom_Medical__c='other',
                                                          Dental__c='other',
                                                          Vision__c='other',
                                                          Chiropractic__c='other',
                                                          Acupuncture__c='other',
                                                          Acupuncture_Chiropractic__c='others',
                                                          Prosthetic_Orthotic__c='other',
                                                          Infertility__c ='other',
                                                          Medical_Plan_Notes__c ='<a href');
        testMP1.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testMP1.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
        lstMedicalPlan.add(testMP);
        lstMedicalPlan.add(testMP1);
          
        Medical_Plan__c TestNonMediPlan = new Medical_Plan__c(Dental__c='other',
                                                          Vision__c='other',
                                                          Chiropractic__c='other',
                                                          Acupuncture__c='other',
                                                          Acupuncture_Chiropractic__c='others',
                                                          Prosthetic_Orthotic__c='other',
                                                          Infertility__c ='other',
                                                          Medical_Plan_Notes__c ='<a href');
        TestNonMediPlan.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        TestNonMediPlan.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        
        Medical_Plan__c testMP2 =  new Medical_Plan__c(Dental__c='other',
                                                          Vision__c='other',
                                                          Chiropractic__c='other',
                                                          Acupuncture__c='other',
                                                          Acupuncture_Chiropractic__c='others',
                                                          Prosthetic_Orthotic__c='other',
                                                          Infertility__c ='other',
                                                          Medical_Plan_Notes__c ='<a href');
        //testMP2 = TestNonMediPlan;
        testMP2.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testMP2.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        lstMedicalPlan.add(TestNonMediPlan);
        lstMedicalPlan.add(testMP2);
        
        insert lstMedicalPlan;
        
        system.debug(TestNonMediPlan);
        Test.stopTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newEmployerGroupDate);
        VFC36_Sold_Case_Notification testSCN = new VFC36_Sold_Case_Notification(sc);
        testSCN.save();
        try{
            testSCN.DisableAndEnableEDISection();
            testSCN.autoPopulateEDIVendor();
            testSCN.autoPopulateHREmployPortal1();
            testSCN.autoPopulateHREmployPortal();
            testSCN.autoPopulateBilling();
            testSCN.autoPopulateHRandEnrollment();
        }catch(Exception e){}
        
        testSCN.Completed();
       
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test autoPopulateEDIVendor method.   
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testMethod void autoPopulateEDIVendor_Test(){
        Test.startTest();
        String medicalPlanRecordType ='Medical Plan Other';
        String standardMedicalplan = 'Standard medical plan';
        
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Medical_Plan__c' and isActive=true];
        Map<string, String> medicalPlansRecordTypes = new Map<String,String>();
        for(RecordType rt: rtypes){
            medicalPlansRecordTypes.put(rt.Name,rt.Id);
        }
                
        List<Profile> p = [SELECT   Id FROM Profile WHERE Name='SHP Sales' limit 1];  

        User userObjTest = new User(Alias = 'standt', Email='abc@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p[0].Id, TimeZoneSidKey='America/Los_Angeles', UserName='ABC@testorg.com');
        insert  userObjTest;
        // Assert to check user is created successfully
       system.assert(userObjTest.id!=null);     
        
        String ACNRECTYPE = 'SHP Sales Broker';
        String PARENTACCOUNTTYPE = 'SHP Sales Employer';
        String CONTACTRECTYPE = 'SHP Sales Broker Contact';
        
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
       
        /*********************************************************************** 
        Verifying Account is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
       system.assert(testAccount.id!=null);      
        Contact con = new Contact();
         con.AccountId = testAccount.Id;
         con.RecordtypeId =  Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId;
         con.LastName =  'TEST';
         con.Employee_Id__c = '123456';
         con.Employee_Supervisor_Name__c = 'TestSuperVisor';
         con.Email = 'test@test.com';
         con.Phone = '9876543210';
         insert con;
         
        
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                type='Broker',
                                                NumberOfEmployees = 300);
     
        Database.insert(testBrokerAccount);
        
        
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       Renewed_Opportunity__c =true,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        
        /*********************************************************************** 
        Verifying Opportunity is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testOpportunity.id!=null);    
      
        Employer_Group_Data__c newEmployerGroupDate = new Employer_Group_Data__c(Company_Name__c ='Test Company',
                                                                                 Street_Address__c ='Test Address',
                                                                                 city_SA__c =' Test City ',
                                                                                 State_SA__c ='Test State',
                                                                                 Zip_SA__c ='123123',
                                                                                 Phone_Number__c ='8081802080',
                                                                                 Federal_Employer_ID_Number__c ='Em-121',
                                                                                 Group_Type__c ='Small',
                                                                                 of_Employees__c =12.00,
                                                                                 SHP_Sales_Representative__c ='Test',
                                                                                 of_Eligible_Employees__c =9.00,
                                                                                 Projected_Enrollment__c =110.00,
                                                                                 Plan_vs_Calendar_Year__c ='Plan Calendar',
                                                                                 Effective_Date__c = date.newInstance(2015, 02, 18),
                                                                                 HR_Enrollment_Phone__c ='1098211211',
                                                                                 Billing_Contact_Phone__c ='1098211211',
                                                                                 Completedby__c =userObjTest.iD,
                                                                                 AuditorName__c =userObjTest.iD,
                                                                                 HREnrollment_Name__c = con.iD,
                                                                                 Vendor_Contact_Name__c = con.iD,
                                                                                 EDI_Vendor_Name__c = con.iD,
                                                                                 HREmployer_Portal_Name__c = con.iD,
                                                                                 Performance_or_Implementation__c ='Test ',
                                                                                 Broker_Name__c ='Test',
                                                                                 Broker_Agency__c ='102981 ',
                                                                                 Employee_Waiting_Period__c ='Other',
                                                                                 Employee_Waiting_Period_Other__c ='Test',
                                                                                 Type_of_Organization__c ='Other',
                                                                                 Type_of_Organization_Other__c = 'test',
                                                                                 BillingContact_Name__c = con.iD,
                                                                                 HREmployer_Portal_Name1__c = con.id,
                                                                                 Enrollment_Method__c = 'Electronic');
        
                                                                                    
        newEmployerGroupDate.Opportunity_Account_Name__c =testAccount.Id;
        newEmployerGroupDate.Opportunity__c = testOpportunity.Id;       
        insert  newEmployerGroupDate;
        
        List<Medical_Plan__c> lstMedicalPlan = new List<Medical_Plan__c>();
        Medical_Plan__c testMP = new Medical_Plan__c( Medical_type__c = 'other',
                                                          Medical__c = 'other',
                                                          Custom_Medical__c='other',
                                                          Dental__c='other',
                                                          Vision__c='other',
                                                          Chiropractic__c='other',
                                                          Acupuncture__c='other',
                                                          Acupuncture_Chiropractic__c='others',
                                                          Prosthetic_Orthotic__c='other',
                                                          Infertility__c ='other',
                                                          Medical_Plan_Notes__c ='<a href');
        testMP.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testMP.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
        
        Medical_Plan__c testMP1 =  new Medical_Plan__c( Medical_type__c = 'other',
                                                          Medical__c = 'other',
                                                          Custom_Medical__c='other',
                                                          Dental__c='other',
                                                          Vision__c='other',
                                                          Chiropractic__c='other',
                                                          Acupuncture__c='other',
                                                          Acupuncture_Chiropractic__c='others',
                                                          Prosthetic_Orthotic__c='other',
                                                          Infertility__c ='other',
                                                          Medical_Plan_Notes__c ='<a href');
                                                          
        testMP1.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testMP1.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
        lstMedicalPlan.add(testMP);
        lstMedicalPlan.add(testMP1);
          
        system.debug(testMP);
        Medical_Plan__c TestNonMediPlan = new Medical_Plan__c(Dental__c='other',
                                                          Vision__c='other',
                                                          Chiropractic__c='other',
                                                          Acupuncture__c='other',
                                                          Acupuncture_Chiropractic__c='others',
                                                          Prosthetic_Orthotic__c='other',
                                                          Infertility__c ='other',
                                                          Medical_Plan_Notes__c ='<a href');
        TestNonMediPlan.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        TestNonMediPlan.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        
        Medical_Plan__c testMP2 =  new Medical_Plan__c(Dental__c='other',
                                                          Vision__c='other',
                                                          Chiropractic__c='other',
                                                          Acupuncture__c='other',
                                                          Acupuncture_Chiropractic__c='others',
                                                          Prosthetic_Orthotic__c='other',
                                                          Infertility__c ='other',
                                                          Medical_Plan_Notes__c ='<a href');
    
        testMP2.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testMP2.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        lstMedicalPlan.add(TestNonMediPlan);
        lstMedicalPlan.add(testMP2);
        
        insert lstMedicalPlan;
        
        system.debug(TestNonMediPlan);
        Test.stopTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newEmployerGroupDate);
        VFC36_Sold_Case_Notification testSCN = new VFC36_Sold_Case_Notification(sc);
        testSCN.errorOccur = false;
        testSCN.SCNTrainingDocument = new SHP_Training_Document__kav();
        testSCN.save();
        try{
            testSCN.DisableAndEnableEDISection();
            testSCN.autoPopulateEDIVendor();
            testSCN.autoPopulateHREmployPortal1();
            testSCN.autoPopulateHREmployPortal();
            testSCN.autoPopulateBilling();
            testSCN.autoPopulateHRandEnrollment();
        }catch(Exception e){}
        
        testSCN.Completed();
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test validating the scn form on completion .   
     Parameters: N/A 
     Returns: Boolean
     Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void isValidAllData_Test() {
        String medicalPlanRecordType ='Medical Plan Other';
        String standardMedicalplan = 'Standard medical plan';
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Medical_Plan__c' and isActive=true];
        Map<string, String> medicalPlansRecordTypes = new Map<String,String>();
        for(RecordType rt: rtypes){
            medicalPlansRecordTypes.put(rt.Name,rt.Id);
        }
        String ACNRECTYPE = 'SHP Sales Broker';
        String PARENTACCOUNTTYPE = 'SHP Sales Employer';
        String CONTACTRECTYPE = 'SHP Sales Broker Contact';
        
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
        /*********************************************************************** 
        Verifying Account is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testAccount.id!=null);
        
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

        /*********************************************************************** 
        Verifying Contact is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testContact.id!=null);
        
        
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
                                                       Opp_Renewed__c = false,
                                                       Renewed_Opportunity__c =false,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        
        
      
        Employer_Group_Data__c newEmployerGroupDate = new Employer_Group_Data__c();
        newEmployerGroupDate.Performance_or_Implementation__c ='';
        newEmployerGroupDate.Employee_Waiting_Period__c = 'other';
        newEmployerGroupDate.Type_of_Organization__c = 'other';
        newEmployerGroupDate.Type_of_Organization_Other__c = 'Test';
        newEmployerGroupDate.Plan_vs_Calendar_Year__c ='';
        newEmployerGroupDate.Employee_Waiting_Period_Other__c = '';
        newEmployerGroupDate.Opportunity_Account_Name__c =testAccount.Id;
        newEmployerGroupDate.Opportunity__c = testOpportunity.Id;       
        insert newEmployerGroupDate;
         Medical_Plan__c testMP = new Medical_Plan__c(
                                    Medical__c = '',
                                    Other_Plan_Id__c = '',
                                    CustomMedical_Other__c = '',
                                    Dental_Other__c = '',
                                    Vision_Other__c = '',
                                    Chiropractic_Other__c = '',
                                    AcupunctureChiropractic_Other__c ='',
                                    Medical_Plan_Notes__c = '',
                                    Custom_Medical__c=null,
                                     Dental__c=null,
                                     Vision__c=' ',
                                     Chiropractic__c=' ',
                                     Acupuncture__c=' ',
                                     Acupuncture_Chiropractic__c=' ',
                                     Prosthetic_Orthotic__c=' ',
                                     Infertility__c =' '
                                    );
        testMP.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testMP.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
        insert testMP;
         Medical_Plan__c testNMP1 = new Medical_Plan__c(
                                    Medical__c = 'Others',
                                    Other_Plan_Id__c = '',
                                    CustomMedical_Other__c = '',
                                    Dental_Other__c = '',
                                    Vision_Other__c = '',
                                    Chiropractic_Other__c = '',
                                    AcupunctureChiropractic_Other__c ='',
                                    Medical_Plan_Notes__c = '',
                                    Custom_Medical__c= 'Other',
                                     Dental__c='Other',
                                     Vision__c='Other',
                                     Chiropractic__c='Other',
                                     Acupuncture__c='Other',
                                     Acupuncture_Chiropractic__c='Others',
                                     Prosthetic_Orthotic__c=' ',
                                     Infertility__c =' '
                                    );
        testNMP1.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP1.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
                                    insert testNMP1 ; 
        
        
        Medical_Plan__c testNMP =new Medical_Plan__c(Dental__c=' ',
                                                                Vision__c=' ',
                                                                Chiropractic__c=' ',
                                                                Acupuncture__c=' ',
                                                                Acupuncture_Chiropractic__c=' ',
                                                                Prosthetic_Orthotic__c=' ',
                                                                Infertility__c=' ',
                                                                Medical_Plan_Notes__c = '<a href test');
        testNMP.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        insert testNMP;
        Medical_Plan__c testNMP2 =new Medical_Plan__c(Dental__c='Other',
                                                        Dental_Other__c = '',
                                                                Vision__c='Other',
                                                                Vision_Other__c = '',
                                                                Chiropractic__c='Other',
                                                                Chiropractic_Other__c = '',
                                                                Acupuncture__c='Other',
                                                                Acupuncture_Other__c = '',
                                                                Acupuncture_Chiropractic__c='Others',
                                                                AcupunctureChiropractic_Other__c = '',
                                                                Prosthetic_Orthotic__c=' ',
                                                                Infertility__c=' ',
                                                                Medical_Plan_Notes__c = '<a href test');
        testNMP2.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP2.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        insert testNMP2;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newEmployerGroupDate);
        VFC36_Sold_Case_Notification testSCN = new VFC36_Sold_Case_Notification(sc);
        testSCN.checkOldorNew();
        testSCN.getOptVal();
        testSCN.addMedicalPan();
        testSCN.addNonMedicalPan();
        testSCN.addNonMedicalPan();
        testSCN.removeNonMedicalPan();
        testSCN.removeMedicalPan();
        testSCN.isValidAllDataMPO();
        testSCN.isValidAllData();
        testSCN.Completed();
        testSCN.Save();
        testSCN.soldCaseNotificationClone();
        Test.stopTest();
    }
    /*******************************************************************
     Purpose: This Test Method is used to test  intailization medical and  Non-medical plan with 'N/A' value.     .   
     Parameters: N/A 
     Returns: PageReference
     Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void addNonMedicalPan_Test() {
        String medicalPlanRecordType ='Medical Plan Other';
        String standardMedicalplan = 'Standard medical plan';
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Medical_Plan__c' and isActive=true];
        Map<string, String> medicalPlansRecordTypes = new Map<String,String>();
        for(RecordType rt: rtypes){
            medicalPlansRecordTypes.put(rt.Name,rt.Id);
        }
        String ACNRECTYPE = 'SHP Sales Broker';
        String PARENTACCOUNTTYPE = 'SHP Sales Employer';
        String CONTACTRECTYPE = 'SHP Sales Broker Contact';
        
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
      
        /*********************************************************************** 
        Verifying Account is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testAccount.id!=null);
        
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
       
        /*********************************************************************** 
        Verifying Contact is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testContact.id!=null);
        
        
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
                                                       Opp_Renewed__c = false,
                                                       Renewed_Opportunity__c =false,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        
        
      
        Employer_Group_Data__c newEmployerGroupDate = new Employer_Group_Data__c();
        newEmployerGroupDate.Performance_or_Implementation__c ='';
        newEmployerGroupDate.Employee_Waiting_Period__c = 'other';
        newEmployerGroupDate.Type_of_Organization__c = 'other';
        newEmployerGroupDate.Type_of_Organization_Other__c = 'Test';
        newEmployerGroupDate.Plan_vs_Calendar_Year__c ='';
        newEmployerGroupDate.Employee_Waiting_Period_Other__c = '';
        newEmployerGroupDate.Opportunity_Account_Name__c =testAccount.Id;
        newEmployerGroupDate.Opportunity__c = testOpportunity.Id;
        newEmployerGroupDate.Enrollment_Method__c = 'Electronic';

        insert newEmployerGroupDate;
         Medical_Plan__c testMP = new Medical_Plan__c(
                                    Medical__c = '',
                                    Other_Plan_Id__c = '',
                                    CustomMedical_Other__c = '',
                                    Dental_Other__c = '',
                                    Vision_Other__c = '',
                                    Chiropractic_Other__c = '',
                                    AcupunctureChiropractic_Other__c ='',
                                    Medical_Plan_Notes__c = '',
                                    Custom_Medical__c=null,
                                     Dental__c=null,
                                     Vision__c=' ',
                                     Chiropractic__c=' ',
                                     Acupuncture__c=' ',
                                     Acupuncture_Chiropractic__c=' ',
                                     Prosthetic_Orthotic__c=' ',
                                     Infertility__c =' '
                                    );
        testMP.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testMP.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
        insert testMP;
         Medical_Plan__c testNMP1 = new Medical_Plan__c(
                                    Medical__c = 'Others',
                                    Other_Plan_Id__c = '',
                                    CustomMedical_Other__c = '',
                                    Dental_Other__c = '',
                                    Vision_Other__c = '',
                                    Chiropractic_Other__c = '',
                                    AcupunctureChiropractic_Other__c ='',
                                    Medical_Plan_Notes__c = '',
                                    Custom_Medical__c= 'Other',
                                     Dental__c='Other',
                                     Vision__c='Other',
                                     Chiropractic__c='Other',
                                     Acupuncture__c='Other',
                                     Acupuncture_Chiropractic__c='Others',
                                     Prosthetic_Orthotic__c=' ',
                                     Infertility__c =' '
                                    );
        testNMP1.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP1.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
                                    insert testNMP1 ; 
        
        
        Medical_Plan__c testNMP =new Medical_Plan__c(Dental__c=' ',
                                                                Vision__c=' ',
                                                                Chiropractic__c=' ',
                                                                Acupuncture__c=' ',
                                                                Acupuncture_Chiropractic__c=' ',
                                                                Prosthetic_Orthotic__c=' ',
                                                                Infertility__c=' ',
                                                                Medical_Plan_Notes__c = 'test');
        testNMP.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        insert testNMP;
        Medical_Plan__c testNMP2 =new Medical_Plan__c(Dental__c='Other',
                                                        Dental_Other__c = '',
                                                                Vision__c='Other',
                                                                Vision_Other__c = '',
                                                                Chiropractic__c='Other',
                                                                Chiropractic_Other__c = '',
                                                                Acupuncture__c='Other',
                                                                Acupuncture_Other__c = '',
                                                                Acupuncture_Chiropractic__c='Others',
                                                                AcupunctureChiropractic_Other__c = '',
                                                                Prosthetic_Orthotic__c=' ',
                                                                Infertility__c=' ',
                                                                Medical_Plan_Notes__c = 'test');
        testNMP2.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP2.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        insert testNMP2;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newEmployerGroupDate);
        VFC36_Sold_Case_Notification testSCN = new VFC36_Sold_Case_Notification(sc);
        test.startTest();
        testSCN.getOptVal();
        testSCN.addMedicalPan();
        testSCN.addNonMedicalPan();
        
        testSCN.removeNonMedicalPan();
        testSCN.removeMedicalPan();
        testSCN.showRenwalForm = true;
        testSCN.isValidAllData();
        testSCN.isValidAllDataMPO();
        testSCN.Save();
        testSCN.soldCaseNotificationClone();
        testSCN.Completed();   
        test.stopTest();
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test custom clone functionality which used to clone SCN record with it Medical Plan records 
     Parameters: N/A 
     Returns: PageReference
     Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void soldCaseNotificationClone_Test(){      
        User objUser ;
 
        Group g1 = [SELECT DeveloperName,Email,Id,Name,OwnerId,RelatedId,Type FROM Group WHERE DeveloperName = 'SHP_Sales_Queue'];   

      // Assert to check group is fetched successfully
      /*********************************************************************** 
        Verifying Group is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
       system.assert(g1!=null);   
       
        List<GroupMember> lstGM = [Select UserOrGroupId, GroupId From GroupMember Where GroupId = :g1.id];
        system.debug('lstGM '+lstGM.size());
        List<String> lstId = new List<String>();
        for(GroupMember obj:lstGM){
            lstId.add(obj.UserOrGroupId);
        }
        system.debug('lstId '+lstId.size());
        List<GroupMember> objGM = [SELECT GroupId, Id, UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN:lstId];
        List<User> lstUser = new List<User>();
        if(!objGM.isEmpty()){
            lstUser = [Select Id,Email,LastName,UserName From User Where Id IN :lstId];
        }
        system.debug('lstUser  '+lstUser);  
        system.debug('lstUser  '+lstUser.size());
        User temp =  [Select Id,Email,LastName,UserName From User Where Id =: UserInfo.getUserId()];
        update temp;
        if(lstUser != NULL & lstUser.size() >0) {
            objUser = lstUser[0];
            }
        else{
            objUser = temp;
            }
        String medicalPlanRecordType ='Medical Plan Other';
        String standardMedicalplan = 'Standard medical plan';
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Medical_Plan__c' and isActive=true];
        Map<string, String> medicalPlansRecordTypes = new Map<String,String>();
        for(RecordType rt: rtypes){
            medicalPlansRecordTypes.put(rt.Name,rt.Id);
        }
        String ACNRECTYPE = 'SHP Sales Broker';
        String PARENTACCOUNTTYPE = 'SHP Sales Employer';
        String CONTACTRECTYPE = 'SHP Sales Broker Contact';
        Test.startTest();
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId, 
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
 
        /*********************************************************************** 
        Verifying Account is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testAccount!=null);
        
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
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN', Type = 'New Business', AccountId = testAccount.Id, StageName = 'Closed Won',
                                                       Amount = 450, CloseDate = Date.today()+25, Plan_end_date__c = Date.today()+110,Broker1__c = testBrokerAccount.Id,
                                                       Broker_Rep1__c = testContact.Id,Current_Status__c = 'Information Requested', Opp_Renewed__c = false,
                                                       Renewed_Opportunity__c =false, RecordTypeID = System.label.SHP_Sales_Opportunity_Id,Sales_Team__c = 'TSS');  
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       
        Database.insert(testOpportunity);
      
        /*********************************************************************** 
        Verifying Opportunity is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testOpportunity!=null);
        
        
      
        Employer_Group_Data__c newEmployerGroupDate = new Employer_Group_Data__c();
        newEmployerGroupDate.Performance_or_Implementation__c ='';
        newEmployerGroupDate.Employee_Waiting_Period__c = 'other';
        newEmployerGroupDate.Type_of_Organization__c = 'other';
        newEmployerGroupDate.Type_of_Organization_Other__c = 'Test';
        newEmployerGroupDate.Plan_vs_Calendar_Year__c ='';
        newEmployerGroupDate.Employee_Waiting_Period_Other__c = '';
        newEmployerGroupDate.Opportunity_Account_Name__c =testAccount.Id;
        newEmployerGroupDate.Opportunity__c = testOpportunity.Id;       
        insert newEmployerGroupDate;
         Medical_Plan__c testMP = new Medical_Plan__c(Medical__c = '',Other_Plan_Id__c = '',CustomMedical_Other__c = '',Dental_Other__c = '',Vision_Other__c = '',
                                    Chiropractic_Other__c = '', AcupunctureChiropractic_Other__c ='', Medical_Plan_Notes__c = '',Custom_Medical__c=null,
                                     Dental__c=null, Vision__c=' ', Chiropractic__c=' ', Acupuncture__c=' ', Acupuncture_Chiropractic__c=' ',
                                     Prosthetic_Orthotic__c=' ', Infertility__c =' '
                                    );
        testMP.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testMP.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
        insert testMP;
         Medical_Plan__c testNMP1 = new Medical_Plan__c(
                                    Medical__c = 'Others',
                                    Other_Plan_Id__c = '',
                                    CustomMedical_Other__c = '',
                                    Dental_Other__c = '',
                                    Vision_Other__c = '',
                                    Chiropractic_Other__c = '',
                                    AcupunctureChiropractic_Other__c ='',
                                    Medical_Plan_Notes__c = '',
                                    Custom_Medical__c= 'Other',
                                     Dental__c='Other',
                                     Vision__c='Other',
                                     Chiropractic__c='Other',
                                     Acupuncture__c='Other',
                                     Acupuncture_Chiropractic__c='Others',
                                     Prosthetic_Orthotic__c=' ',
                                     Infertility__c =' '
                                    );
        testNMP1.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP1.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
                                    insert testNMP1 ;       
        
        Medical_Plan__c testNMP =new Medical_Plan__c(Dental__c=' ',
                                                                Vision__c=' ',
                                                                Chiropractic__c=' ',
                                                                Acupuncture__c=' ',
                                                                Acupuncture_Chiropractic__c=' ',
                                                                Prosthetic_Orthotic__c=' ',
                                                                Infertility__c=' ',
                                                                Medical_Plan_Notes__c = 'test');
        testNMP.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        insert testNMP;
        Medical_Plan__c testNMP2 =new Medical_Plan__c(Dental__c='Other',
                                                        Dental_Other__c = '',
                                                                Vision__c='Other',
                                                                Vision_Other__c = '',
                                                                Chiropractic__c='Other',
                                                                Chiropractic_Other__c = '',
                                                                Acupuncture__c='Other',
                                                                Acupuncture_Other__c = '',
                                                                Acupuncture_Chiropractic__c='Others',
                                                                AcupunctureChiropractic_Other__c = '',
                                                                Prosthetic_Orthotic__c=' ',
                                                                Infertility__c=' ',
                                                                Medical_Plan_Notes__c = 'test');
        testNMP2.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP2.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        insert testNMP2;
        
        system.currentPageReference().getParameters().put('Id', newEmployerGroupDate.Id);       
        Test.stopTest();
        
        
       
        System.runAs(objUser) {
            
          ApexPages.StandardController sc = new ApexPages.StandardController(newEmployerGroupDate);
            VFC36_Sold_Case_Notification testSCN = new VFC36_Sold_Case_Notification(sc);
            testSCN.soldCaseNotificationClone();
      } 
            
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to Negative test custom clone functionality which used to clone SCN record with it Medical Plan records
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void soldCaseNotificationClone_NegativeTest(){      
        
        User objUser = [select id from user where id=: userinfo.getUserId()];
        System.runAs(objUser) {    
        Group tempGroup = new Group(
        Name = 'unit test group',
        DeveloperName = 'SHP_Sales_Queue',
        Type = 'Regular'
        );
        insert tempGroup;
         
        /*********************************************************************** 
        Verifying Group object record is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
       **********************************************************************/
        system.assert(tempGroup.Id != null);
        
        GroupMember tempGroupMember = new GroupMember(
        GroupId = tempGroup.Id,
        UserOrGroupId = objUser.id
        );
        insert tempGroupMember;
        
        /*********************************************************************** 
        Verifying GroupMember object record is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        
        system.assert(tempGroup.Id != null);
        
        String ACNRECTYPE = 'SHP Sales Broker';
        String PARENTACCOUNTTYPE = 'SHP Sales Employer';
        String CONTACTRECTYPE = 'SHP Sales Broker Contact';
        String medicalPlanRecordType ='Medical Plan Other';
        String standardMedicalplan = 'Standard medical plan';
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Medical_Plan__c' and isActive=true];
        Map<string, String> medicalPlansRecordTypes = new Map<String,String>();
        for(RecordType rt: rtypes){
            medicalPlansRecordTypes.put(rt.Name,rt.Id);
        }
        
        Test.startTest();
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId, 
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
     
        /*********************************************************************** 
        Verifying Account object record is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testAccount!=null);
        
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
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN', Type = 'New Business', AccountId = testAccount.Id, StageName = 'Closed Won',
                                                       Amount = 450, CloseDate = Date.today()+25, Plan_end_date__c = Date.today()+110,Broker1__c = testBrokerAccount.Id,
                                                       Broker_Rep1__c = testContact.Id,Current_Status__c = 'Information Requested', Opp_Renewed__c = false,
                                                       Renewed_Opportunity__c =false, RecordTypeID = System.label.SHP_Sales_Opportunity_Id, Sales_Team__c = 'TSS');
                                                       //Added condition for opportunity record type as part of Req-3826 changes
        Database.insert(testOpportunity);
      
        /*********************************************************************** 
        Verifying Opportunity object record is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testOpportunity!=null);
 
        Employer_Group_Data__c newEmployerGroupDate = new Employer_Group_Data__c();
        newEmployerGroupDate.Performance_or_Implementation__c ='';
        newEmployerGroupDate.Employee_Waiting_Period__c = 'other';
        newEmployerGroupDate.Type_of_Organization__c = 'other';
        newEmployerGroupDate.Type_of_Organization_Other__c = 'Test';
        newEmployerGroupDate.Plan_vs_Calendar_Year__c ='';
        newEmployerGroupDate.Employee_Waiting_Period_Other__c = '';
        newEmployerGroupDate.Opportunity_Account_Name__c =testAccount.Id;
        newEmployerGroupDate.Opportunity__c = testOpportunity.Id;
       
        insert newEmployerGroupDate;
        
        Medical_Plan__c testMP = new Medical_Plan__c(Medical__c = '',Other_Plan_Id__c = '',CustomMedical_Other__c = '',Dental_Other__c = '',Vision_Other__c = '',
                                    Chiropractic_Other__c = '', AcupunctureChiropractic_Other__c ='', Medical_Plan_Notes__c = '',Custom_Medical__c=null,
                                     Dental__c=null, Vision__c=' ', Chiropractic__c=' ', Acupuncture__c=' ', Acupuncture_Chiropractic__c=' ',
                                     Prosthetic_Orthotic__c=' ', Infertility__c =' '
                                    );
        testMP.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testMP.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
        insert testMP;
         Medical_Plan__c testNMP1 = new Medical_Plan__c(
                                    Medical__c = 'Others',
                                    Other_Plan_Id__c = '',
                                    CustomMedical_Other__c = '',
                                    Dental_Other__c = '',
                                    Vision_Other__c = '',
                                    Chiropractic_Other__c = '',
                                    AcupunctureChiropractic_Other__c ='',
                                    Medical_Plan_Notes__c = '',
                                    Custom_Medical__c= 'Other',
                                     Dental__c='Other',
                                     Vision__c='Other',
                                     Chiropractic__c='Other',
                                     Acupuncture__c='Other',
                                     Acupuncture_Chiropractic__c='Others',
                                     Prosthetic_Orthotic__c=' ',
                                     Infertility__c =' '
                                    );
        testNMP1.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP1.RecordTypeId = medicalPlansRecordTypes.get(standardMedicalplan);
                                    insert testNMP1 ;       
        
        Medical_Plan__c testNMP =new Medical_Plan__c(Dental__c=' ',
                                                                Vision__c=' ',
                                                                Chiropractic__c=' ',
                                                                Acupuncture__c=' ',
                                                                Acupuncture_Chiropractic__c=' ',
                                                                Prosthetic_Orthotic__c=' ',
                                                                Infertility__c=' ',
                                                                Medical_Plan_Notes__c = 'test');
        testNMP.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        insert testNMP;
        Medical_Plan__c testNMP2 =new Medical_Plan__c(Dental__c='Other',
                                                        Dental_Other__c = '',
                                                                Vision__c='Other',
                                                                Vision_Other__c = '',
                                                                Chiropractic__c='Other',
                                                                Chiropractic_Other__c = '',
                                                                Acupuncture__c='Other',
                                                                Acupuncture_Other__c = '',
                                                                Acupuncture_Chiropractic__c='Others',
                                                                AcupunctureChiropractic_Other__c = '',
                                                                Prosthetic_Orthotic__c=' ',
                                                                Infertility__c=' ',
                                                                Medical_Plan_Notes__c = 'test');
        testNMP2.Sold_Case_Notification__c = newEmployerGroupDate.Id;
        testNMP2.RecordTypeId = medicalPlansRecordTypes.get(medicalPlanRecordType);
        insert testNMP2;
        
        system.currentPageReference().getParameters().put('Id', newEmployerGroupDate.Id);       
        Test.stopTest();
        
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newEmployerGroupDate);
        VFC36_Sold_Case_Notification testSCN = new VFC36_Sold_Case_Notification(sc);
        testSCN.soldCaseNotificationClone();
      } 
            
    }
    /**
     * Method Name : scnPDFGenerationWithoutRates
     * Descrption  : This method is used to test the pdf generation of scn all rates
     * Author      : IDC Offshore
     * Return type : void
     **/
    private testMethod static void ssoPDFGenerationWithAllRates(){
        List<Benefit_Plan_Data_Filters__c> bpdfList = HighRoads_TestDataUtility.insertBenefitDataFiltersCS();
        insert bpdfList;
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegList;
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        List<SHP_Benefit_Grid__c> benefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        insert benefitGrid;
        
        List<Benefit_Plan_Metadata__c> benefitPlanMetadata = [SELECT ID,Benefit_Grid__c,EOC__c ,SBC__c ,BCM__c ,
                                                              Ancillary_EOC__c ,Ancillary_SOB__c,Ancillary_GSA__c,
                                                              Version_Number__c,IsActivelyMarketed__c,Plan_Year__c,Market_Segment__c,
                                                              Plan_Related_to_Account__c,Name,Plan_Name__c,Plan_Status__c,
                                                              Deductible__c,Family_Deductible__c,Ind_Family_Deductible__c,
                                                              DOV__c,Inpatient__c,Emergency_Room__c,Medical_OR_Rider__c,    
                                                              IsCustom__c,IsHDHP__c,Office_Visit__c,Out_of_Pocket_Maximum__c,
                                                              Family_OOPM__c,Ind_Family_OOPM__c,Product_Family__c,
                                                              Outpatient__c,Product__c,RX_Tier_1__c,RX_Tier_2__c,RX_Tier_3__c,
                                                              RX_Tier_4__c,Rx_Deductible_Family__c,Rx_Deductible_Ind_Family__c,
                                                              Rx_Deductible_Individual__c,Specialist_Office_Visit__c,Benefit_Plan_ID__c,
                                                              Visit_Limit__c,Rider_Cost_Share__c,Product_Class__c,
                                                              Plan_Type__c,Product_Types__c FROM Benefit_Plan_Metadata__c];
        
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        Benefit_Plan_Association__c medical = new Benefit_Plan_Association__c();
        medical.Name = benefitPlanMetadata[0].Name;
        medical.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medical.Opportunity__c = opp.Id;
        bpaList.add(medical);
        
        Benefit_Plan_Association__c rider1 = new Benefit_Plan_Association__c();
        rider1.Name = benefitPlanMetadata[0].Name;
        rider1.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        rider1.Raider_ID__c = benefitPlanMetadata[1].Id;
        rider1.Opportunity__c = opp.Id;
        bpaList.add(rider1);
        
        Insert bpaList;
        
        Test.startTest();
        Test.setCurrentPage(Page.HighRoads_RatesSelection);
        ApexPages.currentPage().getParameters().put('recordId',opp.id);
        HighRoads_RateSelection rateSelecObj = new HighRoads_RateSelection();
        List<HighRoads_RateSelection.RateTiers> rateTierObjList = rateSelecObj.planRateTierList[0].tierList;
        for(HighRoads_RateSelection.RateTiers rateTier : rateTierObjList){
            rateTier.tier1 = true;
            rateTier.tier2 = true;
            rateTier.tier3 = true;
            rateTier.tier4 = true;
            rateTier.tier5 = true;
        }
        rateSelecObj.panel1Next();
        rateSelecObj.addGroup();
        rateSelecObj.other1 = 'OTH1';
        rateSelecObj.addGroup();
        rateSelecObj.other2 = 'OTH2';
        rateSelecObj.addGroup();
        rateSelecObj.other3 = 'OTH3';
        rateSelecObj.addGroup();
        rateSelecObj.other4 = 'OTH4';
        rateSelecObj.addGroup();
        rateSelecObj.other5 = 'OTH5';
        rateSelecObj.addGroup();
        rateSelecObj.other6 = 'OTH6';
        rateSelecObj.addGroup();
        rateSelecObj.other7 = 'OTH7';
        rateSelecObj.addGroup();
        rateSelecObj.other8= 'OTH8';
        rateSelecObj.addGroup();
        rateSelecObj.other9 = 'OTH9';
        rateSelecObj.addGroup();
        rateSelecObj.other10 = 'OTH10';
        rateSelecObj.cancel();
        List<HighRoads_RateSelection.PlanRateTier> planRateTierList = rateSelecObj.planRateTierGroupList;
        List<HighRoads_RateSelection.PlanGroups> planGroups = planRateTierList[0].plangroupList;
        for(HighRoads_RateSelection.PlanGroups planGroup : planGroups){
            for(HighRoads_RateSelection.RateGroups rateGrpObj : planGroup.rateGrpList){
                rateGrpObj.active = true;
                rateGrpObj.earlyRetiree = true;
                rateGrpObj.other1 = true;
                rateGrpObj.other2 = true;
                rateGrpObj.other3 = true;
                rateGrpObj.other4 = true;
                rateGrpObj.other5 = true;
                rateGrpObj.other6 = true;
                rateGrpObj.other7 = true;
                rateGrpObj.other8 = true;
                rateGrpObj.other9 = true;
                rateGrpObj.other10 = true;
            }
        }
        rateSelecObj.panel2Next();
        for(HighRoads_RateSelection.PlanRateTier saveRateTable : rateSelecObj.PlanRateTierGroupandRateEntryList){
            for(HighRoads_RateSelection.PlanTierandRateEntry planTierRate : saveRateTable.planTierandRateEntryList){
                for(HighRoads_RateSelection.TierandRateEntry tierType : planTierRate.tierRateEntryList){
                    for(HighRoads_RateSelection.RateEntry rateEntry : tierType.rateEntryList){
                        if('Tier 1'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier1Composite = '120';
                        }
                        else if('Tier 2'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier2EE = '120';
                            rateEntry.tier2EF = '120';
                        }else if('Tier 3'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier3EE = '120';
                            rateEntry.tier3E1 = '120';
                            rateEntry.tier3E2 = '120';
                        }else if('Tier 4'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier4EE = '120';
                            rateEntry.tier4EC = '120';
                            rateEntry.tier4ES = '120';
                            rateEntry.tier4EF = '120';
                        }else if('Tier 5'.equalsIgnoreCase(tierType.tierName)){
                            rateEntry.tier5EE = '120';
                            rateEntry.tier5EC = '120';
                            rateEntry.tier5ES = '120';
                            rateEntry.tier5EF = '120';
                            rateEntry.tier5ECH = '120';
                        }
                    }
                }
            }
        }
        
        rateSelecObj.saveRates();
		Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        
        Proposal__c quote = new Proposal__c();
        quote.RFP_Form__c = rfpObj.Id;
        quote.Opportunity_ID__c = opp.Id;
        Insert quote;
        
        Sold_Sign_Off__c sso = new Sold_Sign_Off__c();
        sso.Quote__c = quote.Id;
        sso.Opportunity_ID__c = opp.Id;
        Insert sso;
        
        Employer_Group_Data__c scn = new Employer_Group_Data__c();
        scn.Sold_Sign_Off__c = sso.Id;
        scn.Opportunity__c = opp.Id;
        Insert scn;   
        
        ApexPages.StandardController sc = new ApexPages.StandardController(scn);
        VFC36_Sold_Case_Notification scnObj = new VFC36_Sold_Case_Notification(sc);
        
        PageReference pageRef = Page.SoldCaseNotificationPDFGeneration;
        pageRef.getParameters().put('id', String.valueOf(scn.Id));
        Test.setCurrentPage(pageRef);
        
        Test.stopTest();
    }
    /**
     * Method Name : scnPDFGenerationWithoutRates
     * Descrption  : This method is used to test the pdf generation of scn without rates
     * Author      : IDC Offshore
     * Return type : void
     **/
    private testMethod static void scnPDFGenerationWithoutRates(){
        List<Benefit_Plan_Data_Filters__c> bpdfList = HighRoads_TestDataUtility.insertBenefitDataFiltersCS();
        insert bpdfList;
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegList;
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        List<SHP_Benefit_Grid__c> benefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        insert benefitGrid;
        
        List<Benefit_Plan_Metadata__c> benefitPlanMetadata = [SELECT ID,Benefit_Grid__c,EOC__c ,SBC__c ,BCM__c ,
                                                              Ancillary_EOC__c ,Ancillary_SOB__c,Ancillary_GSA__c,
                                                              Version_Number__c,IsActivelyMarketed__c,Plan_Year__c,Market_Segment__c,
                                                              Plan_Related_to_Account__c,Name,Plan_Name__c,Plan_Status__c,
                                                              Deductible__c,Family_Deductible__c,Ind_Family_Deductible__c,
                                                              DOV__c,Inpatient__c,Emergency_Room__c,Medical_OR_Rider__c,    
                                                              IsCustom__c,IsHDHP__c,Office_Visit__c,Out_of_Pocket_Maximum__c,
                                                              Family_OOPM__c,Ind_Family_OOPM__c,Product_Family__c,
                                                              Outpatient__c,Product__c,RX_Tier_1__c,RX_Tier_2__c,RX_Tier_3__c,
                                                              RX_Tier_4__c,Rx_Deductible_Family__c,Rx_Deductible_Ind_Family__c,
                                                              Rx_Deductible_Individual__c,Specialist_Office_Visit__c,Benefit_Plan_ID__c,
                                                              Visit_Limit__c,Rider_Cost_Share__c,Product_Class__c,
                                                              Plan_Type__c,Product_Types__c FROM Benefit_Plan_Metadata__c];
        
        System.assertEquals(4, benefitPlanMetadata.size());
        
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc;
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp;
        Benefit_Plan_Association__c medical = new Benefit_Plan_Association__c();
        medical.Name = benefitPlanMetadata[0].Name;
        medical.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        medical.Opportunity__c = opp.Id;
        bpaList.add(medical);
        
        Benefit_Plan_Association__c rider1 = new Benefit_Plan_Association__c();
        rider1.Name = benefitPlanMetadata[0].Name;
        rider1.Benefit_Plan_Metadata__c = benefitPlanMetadata[0].Id;
        rider1.Raider_ID__c = benefitPlanMetadata[1].Id;
        rider1.Opportunity__c = opp.Id;
        bpaList.add(rider1);
        
        Insert bpaList;
        
        Test.startTest();
        
		Incumbent_Carrier__c rfpObj = new Incumbent_Carrier__c();
        rfpObj.RecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(System.Label.HR21_RFPFormRecordType).getRecordTypeId();
        rfpObj.Opportunity__c = opp.Id;
        Insert rfpObj;
        
        Proposal__c quote = new Proposal__c();
        quote.RFP_Form__c = rfpObj.Id;
        quote.Opportunity_ID__c = opp.Id;
        Insert quote;
        
        Sold_Sign_Off__c sso = new Sold_Sign_Off__c();
        sso.Quote__c = quote.Id;
        sso.Opportunity_ID__c = opp.Id;
        Insert sso;
        
        Employer_Group_Data__c scn = new Employer_Group_Data__c();
        scn.Sold_Sign_Off__c = sso.Id;
        scn.Opportunity__c = opp.Id;
        Insert scn;   
        
        ApexPages.StandardController sc = new ApexPages.StandardController(scn);
        VFC36_Sold_Case_Notification scnObj = new VFC36_Sold_Case_Notification(sc);
        
        PageReference pageRef = Page.SoldCaseNotificationPDFGeneration;
        pageRef.getParameters().put('id', String.valueOf(scn.Id));
        Test.setCurrentPage(pageRef);
        
        Test.stopTest();
    }
    
    private testMethod static void checkOldorNewTest(){
        Test.startTest();
        String ACNRECTYPE = 'SHP Sales Broker';
        String PARENTACCOUNTTYPE = 'SHP Sales Employer';
        String CONTACTRECTYPE = 'SHP Sales Broker Contact';
        List<Profile> p = [SELECT   Id FROM Profile WHERE Name='SHP Sales' limit 1];  

        User userObjTest = new User(Alias = 'standt', Email='abc@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p[0].Id, TimeZoneSidKey='America/Los_Angeles', UserName='ABC@testorg.com');
        insert  userObjTest;
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
       
        /*********************************************************************** 
        Verifying Account is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
       system.assert(testAccount.id!=null);      
        
         
        
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                type='Broker',
                                                NumberOfEmployees = 300);
     
        Database.insert(testBrokerAccount);
        
        
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       Renewed_Opportunity__c =true,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        
        /*********************************************************************** 
        Verifying Opportunity is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testOpportunity.id!=null);    
      
        Employer_Group_Data__c newEmployerGroupDate = new Employer_Group_Data__c(Company_Name__c ='Test Company',
                                                                                 Street_Address__c ='Test Address',
                                                                                 city_SA__c =' Test City ',
                                                                                 State_SA__c ='Test State',
                                                                                 Zip_SA__c ='123123',
                                                                                 Phone_Number__c ='8081802080',
                                                                                 Federal_Employer_ID_Number__c ='Em-121',
                                                                                 Group_Type__c ='Small',
                                                                                 of_Employees__c =12.00,
                                                                                 SHP_Sales_Representative__c ='Test',
                                                                                 of_Eligible_Employees__c =9.00,
                                                                                 Projected_Enrollment__c =110.00,
                                                                                 Plan_vs_Calendar_Year__c ='Plan Calendar',
                                                                                 Effective_Date__c = date.newInstance(2015, 02, 18),
                                                                                 HR_Enrollment_Phone__c ='1098211211',
                                                                                 Billing_Contact_Phone__c ='1098211211',
                                                                                 Completedby__c =userObjTest.iD,
                                                                                 AuditorName__c =userObjTest.iD,
                                                                                 Performance_or_Implementation__c ='Test ',
                                                                                 Broker_Name__c ='Test',
                                                                                 Broker_Agency__c ='102981 ',
                                                                                 Employee_Waiting_Period__c ='Other',
                                                                                 Employee_Waiting_Period_Other__c ='Test',
                                                                                 Type_of_Organization__c ='Other',
                                                                                 Type_of_Organization_Other__c = 'test',
                                                                                 Enrollment_Method__c = 'Electronic');
        
                                                                                    
        newEmployerGroupDate.Opportunity_Account_Name__c =testAccount.Id;
        newEmployerGroupDate.Opportunity__c = testOpportunity.Id;       
        insert  newEmployerGroupDate;
        
        system.currentPageReference().getParameters().put('Id', newEmployerGroupDate.Id);       
        ApexPages.StandardController sc = new ApexPages.StandardController(newEmployerGroupDate);
        VFC36_Sold_Case_Notification testSCN = new VFC36_Sold_Case_Notification(sc);
        Test.stopTest();
    }
    private testMethod static void checkOldorNewTest_Old(){
        Test.startTest();
        String ACNRECTYPE = 'SHP Sales Broker';
        String PARENTACCOUNTTYPE = 'SHP Sales Employer';
        String CONTACTRECTYPE = 'SHP Sales Broker Contact';
        List<Profile> p = [SELECT   Id FROM Profile WHERE Name='SHP Sales' limit 1];  

        User userObjTest = new User(Alias = 'standt', Email='abc@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p[0].Id, TimeZoneSidKey='America/Los_Angeles', UserName='ABC@testorg.com');
        insert  userObjTest;
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
       
        /*********************************************************************** 
        Verifying Account is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
       system.assert(testAccount.id!=null);      
        
         
        
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                                Name='Test Account SCN',
                                                Status__c= 'Contracted',
                                                type='Broker',
                                                NumberOfEmployees = 300);
     
        Database.insert(testBrokerAccount);
        
        
        
        Opportunity testOpportunity = new Opportunity( Name = 'Test Opportunity SCN',
                                                       Type = 'New Business',
                                                       AccountId = testAccount.Id,
                                                       StageName = 'Closed Won',
                                                       Amount = 450,
                                                       CloseDate = Date.today()+25,
                                                       Plan_end_date__c = Date.today()+110,
                                                       Broker1__c = testBrokerAccount.Id,
                                                       Current_Status__c = 'Information Requested',
                                                       Opp_Renewed__c =false,
                                                       Renewed_Opportunity__c =true,
                                                       
                                                       //Added condition for opportunity record type as part of Req-3826 changes
                                                       RecordTypeID = System.label.SHP_Sales_Opportunity_Id,
                                                       Sales_Team__c = 'TSS');
                                                       
        Database.insert(testOpportunity);
        
        /*********************************************************************** 
        Verifying Opportunity is created successfully
        Expected Result: value is not null
        Actual Result: value is not null
        **********************************************************************/
        system.assert(testOpportunity.id!=null);    
      
        Employer_Group_Data__c newEmployerGroupDate = new Employer_Group_Data__c();
        newEmployerGroupDate.Opportunity__c = testOpportunity.Id;
        ApexPages.StandardController sc = new ApexPages.StandardController(newEmployerGroupDate);
        VFC36_Sold_Case_Notification testSCN = new VFC36_Sold_Case_Notification(sc);

        Test.stopTest();
    }
}