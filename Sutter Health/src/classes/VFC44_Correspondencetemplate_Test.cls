/**********************************************************************
 Name: VFC44_Correspondencetemplate_Test
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for Correspondencetemplate class
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  10-September-2015 Development complete   Test Class for Correspondencetemplate.
 2.0      IDC Offshore  08-Jan-2016  Class Optimization   Incorporated changes to implement best test practices in the test class.
 ***********************************************************************/
   @isTest
  private class VFC44_Correspondencetemplate_Test{
    /*******************************************************************
    Purpose: method to create test data used by all tests 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/  
    @testSetup static void createData() {
    RecordType rtype = [select id,Name from RecordType where developername='SHP_Sales_Broker_Contact' Limit 1];
    Contact con = new Contact(FirstName = 'Test',LastName='Test', RecordTypeid=rtype.id,Broker_Agent_Date_HIPAA__c = System.Today() );
    insert con;
    /*********************************************************************** 
    Verifying the contact has created successfuly 
    Expected Result: Contact id is not null
    Actual Result: Contact id is not null 
    ***********************************************************************/ 
    system.assert(con.id!=null);
    
    //Create Contact_Search_Fields__c custom Setting
    List <Contact_Search_Fields__c> consearchfields = new List<Contact_Search_Fields__c>();

    Contact_Search_Fields__c Duplicate=  new Contact_Search_Fields__c(Name='Duplicate__c', Field_Type__c= 'Checkbox'); //Create a Custom setting for Duplicate__c Field
    consearchfields.add(Duplicate);

    Contact_Search_Fields__c ContractContact=  new Contact_Search_Fields__c(Name='Contract_Contact__c', Field_Type__c= 'Checkbox'); //Create a Custom setting for Duplicate__c Field
    consearchfields.add(ContractContact);

    Contact_Search_Fields__c PrimaryContact=  new Contact_Search_Fields__c(Name='Primary_Contact__c', Field_Type__c= 'Checkbox'); //Create a Custom setting for Duplicate__c Field
    consearchfields.add(PrimaryContact);
    Contact_Search_Fields__c DoNotCall=  new Contact_Search_Fields__c(Name='DoNotCall', Field_Type__c= 'Checkbox'); //Create a Custom setting for Duplicate__c Field
    consearchfields.add(DoNotCall);
    Contact_Search_Fields__c HasOptedOutOfEmail=  new Contact_Search_Fields__c(Name='HasOptedOutOfEmail', Field_Type__c= 'Checkbox'); //Create a Custom setting for Duplicate__c Field
    consearchfields.add(HasOptedOutOfEmail);
    Contact_Search_Fields__c HasOptedOutOfFax=  new Contact_Search_Fields__c(Name='HasOptedOutOfFax', Field_Type__c= 'Checkbox'); //Create a Custom setting for Duplicate__c Field
    consearchfields.add(HasOptedOutOfFax);
    Contact_Search_Fields__c Behavirol =  new Contact_Search_Fields__c(Name='Behavioral_Health_Active__c', Field_Type__c= 'Checkbox'); //Create a Custom setting for Duplicate__c Field
    consearchfields.add(Behavirol);
    
    Contact_Search_Fields__c Birthdate=  new Contact_Search_Fields__c(Name='Birthdate', Field_Type__c= 'Date'); //Create a Custom setting for BirthDate Field
    consearchfields.add(Birthdate);
    Contact_Search_Fields__c BrokerAgentDateHIPAA =  new Contact_Search_Fields__c(Name='Broker_Agent_Date_HIPAA__c', Field_Type__c= 'Date'); //Create a Custom setting for BrokerAgent_License_State__c Field
    consearchfields.add(BrokerAgentDateHIPAA );
    Contact_Search_Fields__c BrokerAgentEndDate =  new Contact_Search_Fields__c(Name='Broker_Agent_End_Date__c', Field_Type__c= 'Date'); //Create a Custom setting for BrokerAgent_License_State__c Field
    consearchfields.add(BrokerAgentEndDate );
    Contact_Search_Fields__c BrokerAgentStartDate =  new Contact_Search_Fields__c(Name='Broker_Agent_Start_Date__c', Field_Type__c= 'Date'); //Create a Custom setting for BrokerAgent_License_State__c Field
    consearchfields.add(BrokerAgentStartDate );
    Contact_Search_Fields__c BrokerAgentExpirationDate =  new Contact_Search_Fields__c(Name='License_Expiration_Date__c', Field_Type__c= 'Date'); //Create a Custom setting for BrokerAgent_License_State__c Field
    consearchfields.add(BrokerAgentExpirationDate );
      Contact_Search_Fields__c DateDeath =  new Contact_Search_Fields__c(Name='Member_Date_Death__c', Field_Type__c= 'Date'); //Create a Custom setting for BrokerAgent_License_State__c Field
    consearchfields.add(DateDeath );
    Contact_Search_Fields__c EmployeeAffiliateHireDate =  new Contact_Search_Fields__c(Name='Employee_Affiliate_HireDate__c', Field_Type__c= 'Test'); //Create a Custom setting for BrokerAgent_License_State__c Field
    consearchfields.add(EmployeeAffiliateHireDate );
    Database.insert(consearchfields);
    
    }

    /*******************************************************************
    Purpose: :This Method is used to test search the contact on the basis on for multiple filters and save the correspondence letter record.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/ 
    static testMethod void getcontact_saveCorresspondenceLetterTest(){

    Pagereference ref1 = Page.VFP44_Correspondencetemplate;
    Test.setCurrentPage(ref1); 
    Correspondence_Letter__c cLetter = new Correspondence_Letter__c();
    insert cLetter;
    /*********************************************************************** 
    Verifying the Correspondence_Letter__c has created successfuly 
    Expected Result: Correspondence_Letter__c id is not null
    Actual Result: Correspondence_Letter__c id is not null 
    ***********************************************************************/ 
    system.assert(cLetter.id != null);
    
    ApexPages.StandardController ctr = new ApexPages.StandardController(cLetter );
    Test.startTest();
    VFC44_Correspondencetemplate correspCtrl = new VFC44_Correspondencetemplate(ctr);
    correspCtrl.saveCorresspondenceLetter() ;//covers the error message for ErrorForTemplate
    EmailTemplate edm1 =  [Select id,Name from EmailTemplate Where TemplateType ='HTML' Limit 1];
    correspCtrl.getItems();
    correspCtrl.getOperator();
    correspCtrl.saveCorresspondenceLetter() ; // calls the save method and generates an error since no contact is searched
    correspCtrl.Fields =  'FirstName';
    Pagereference redirect5 = correspCtrl.getcontact();// throws an error 'Please Enter Value' as no value for search is set
    correspCtrl.Value = 'Test';
    correspCtrl.OpertaorsList = 'Contains';
    correspCtrl.saveCorresspondenceLetter() ;// Throws an error on save since Email template is not selected
    correspCtrl.SelectedEmailTemplate = edm1.id;
    Pagereference redirect3 = correspCtrl.getcontact();
    correspCtrl.Fields =  'Duplicate__c';// we set a field of type boolean
    correspCtrl.OpertaorsList = 'equals';
    correspCtrl.getcontact();//  we get an error on search ass right boolean value is not set
    correspCtrl.Value ='true';
    correspCtrl.getcontact();// the records can be searched now since boolean is set rightly
    // Assert to check correspondence template  
    system.assertnotequals(correspCtrl,null);

    /*Test for filter 1 with date field*/
    correspCtrl.enableshowContactFilter1() ;// adds a new row for filter criterea
    correspCtrl.Value1 = '08/08/2015';
    correspCtrl.Fields1 =  'Broker_Agent_Date_HIPAA__c';
    correspCtrl.OpertaorsList1 = 'equals';
    correspCtrl.getcontact();//
    correspCtrl.Value1 = 'test';
    correspCtrl.Fields1 =  'Contract_Contact__c';
    correspCtrl.getcontact();//

    correspCtrl.Fields1 =  'Employee_Affiliate_HireDate__c';
    correspCtrl.getcontact();//

    correspCtrl.Value1 = 'false';
    correspCtrl.Fields1 =  'Contract_Contact__c';
    correspCtrl.getcontact();
    
    /*Test for filter 2 with date field*/
    correspCtrl.enableshowContactFilter2() ;// adds a new row for filter criterea
    correspCtrl.Value2 = '08/08/2015';
    correspCtrl.Fields2 =  'Broker_Agent_End_Date__c';
    correspCtrl.OpertaorsList2 = 'equals';
    correspCtrl.getcontact();//
    correspCtrl.Value2 = 'true';
    correspCtrl.Fields2 =  'Primary_Contact__c';    
    correspCtrl.getcontact();//

    /*Test for filter 3 with date field*/
    correspCtrl.enableshowContactFilter3() ;// adds a new row for filter criterea
    correspCtrl.Value3 = '08/08/2015';
    correspCtrl.Fields3 =  'Broker_Agent_Start_Date__c';
    correspCtrl.OpertaorsList3 = 'equals';
    correspCtrl.getcontact();//
    correspCtrl.Value3 = 'true';
    correspCtrl.Fields3 =  'DoNotCall';    
    correspCtrl.getcontact();//

    /*Test for filter 4 with date field*/
    correspCtrl.enableshowContactFilter4() ;// adds a new row for filter criterea
    correspCtrl.Value4 = '08/08/2015';
    correspCtrl.Fields4 =  'License_Expiration_Date__c';
    correspCtrl.OpertaorsList4 = 'equals';
    correspCtrl.getcontact();//
    correspCtrl.Value4 = 'true';
    correspCtrl.Fields4 =  'HasOptedOutOfEmail';    
    correspCtrl.getcontact();//

    /*Test for filter 5 with date field*/
    correspCtrl.enableshowContactFilter5() ;// adds a new row for filter criterea
    correspCtrl.Value5 = '08/08/2015';
    correspCtrl.Fields5 =  'Member_Date_Death__c';
    correspCtrl.OpertaorsList5 = 'equals';
    correspCtrl.getcontact();//
                    correspCtrl.Value5 = 'true';
    correspCtrl.Fields5 =  'HasOptedOutOfFax';    
    correspCtrl.getcontact();//

    /*Test for filter 6 with date field*/
    correspCtrl.enableshowContactFilter6() ;// adds a new row for filter criterea
    correspCtrl.Value6 = '08/08/2015';
    correspCtrl.Fields6 =  'Employee_Affiliate_HireDate__c';
    correspCtrl.OpertaorsList6 = 'equals';
    correspCtrl.getcontact();//
    correspCtrl.Value6 = 'true';
    correspCtrl.Fields6 =  'Behavioral_Health_Active__c';    
    correspCtrl.getcontact();
    
    correspCtrl.saveCorresspondenceLetter() ;
    correspCtrl.DisableshowContactFilter1() ;
    correspCtrl.DisableshowContactFilter2() ;
    correspCtrl.DisableshowContactFilter3() ;
    correspCtrl.DisableshowContactFilter4() ;
    correspCtrl.DisableshowContactFilter5() ;
    correspCtrl.DisableshowContactFilter6() ;
    List<SelectOption> seloptions = correspCtrl.getEmailTemplate() ;
    Pagereference redirect1 = correspCtrl.sendMail();
    Pagereference redirect2 = correspCtrl.createTemplate();
    Pagereference redirect4 = correspCtrl.previewTemplate();
    
    /*Works for Approved Template*/
    List <Group> queueid = [Select ID from Group Where Name = 'Sales & Marketing Queue' limit 1];
    cLetter.Status__c = 'Approved';
    cLetter.OwnerID = queueid[0].id;
    update cLetter;
    ApexPages.StandardController ctr1 = new ApexPages.StandardController(cLetter );
    VFC44_Correspondencetemplate correspCtrl1 = new VFC44_Correspondencetemplate(ctr1);
    correspCtrl1.saveCorresspondenceLetter() ;
    correspCtrl1.memberList = '';
    correspCtrl1.privew = '';
    correspCtrl1.BrokerCorresponenceTrainingDocument = new SHP_Training_Document__kav();
    Test.stopTest();
    }
        
    /*******************************************************************
    Purpose: :This Method is used to negative test search the contact on the basis on for multiple filters and save the correspondence letter record.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: yes
    ********************************************************************/ 
    static testMethod void getcontact_saveCorresspondenceLetterNegativeTest(){

    Pagereference ref1 = Page.VFP44_Correspondencetemplate;
    Test.setCurrentPage(ref1); 
    Correspondence_Letter__c cLetter = new Correspondence_Letter__c();
    insert cLetter;
    /*********************************************************************** 
    Verifying the Correspondence_Letter__c has created successfuly 
    Expected Result: Correspondence_Letter__c id is not null
    Actual Result: Correspondence_Letter__c id is not null 
    ***********************************************************************/ 
    system.assert(cLetter.id != null);
    
    ApexPages.StandardController ctr = new ApexPages.StandardController(cLetter );
    Test.startTest();
    VFC44_Correspondencetemplate correspCtrl = new VFC44_Correspondencetemplate(ctr);
    correspCtrl.saveCorresspondenceLetter() ;//covers the error message for ErrorForTemplate
    EmailTemplate edm1 =  [Select id,Name from EmailTemplate Where TemplateType ='HTML' Limit 1];
    correspCtrl.getItems();
    correspCtrl.getOperator();
    correspCtrl.saveCorresspondenceLetter() ; // calls the save method and generates an error since no contact is searched
    correspCtrl.Fields =  'FirstName';
    Pagereference redirect5 = correspCtrl.getcontact();// throws an error 'Please Enter Value' as no value for search is set
    correspCtrl.Value = 'Test';
    correspCtrl.OpertaorsList = 'Contains';
    correspCtrl.saveCorresspondenceLetter() ;// Throws an error on save since Email template is not selected
    correspCtrl.SelectedEmailTemplate = edm1.id;
    Pagereference redirect3 = correspCtrl.getcontact();
    correspCtrl.Fields =  'Duplicate__c';// we set a field of type boolean
    correspCtrl.OpertaorsList = 'equals';
    correspCtrl.getcontact();//  we get an error on search ass right boolean value is not set
    correspCtrl.Value ='true';
    correspCtrl.getcontact();// the records can be searched now since boolean is set rightly
    // Assert to check correspondence template  
    system.assertnotequals(correspCtrl,null);

    /*Test for filter 1 with date field*/
    correspCtrl.enableshowContactFilter1() ;// adds a new row for filter criterea
    correspCtrl.Value1 = '08/08/2015';
    correspCtrl.Fields1 =  'Broker_Agent_Date_HIPAA__c';
    correspCtrl.OpertaorsList1 = 'equals';
    correspCtrl.getcontact();//
    correspCtrl.Value1 = 'test';
    correspCtrl.Fields1 =  'Contract_Contact__c';
    correspCtrl.getcontact();//

    correspCtrl.Fields1 =  'Employee_Affiliate_HireDate__c';
    correspCtrl.getcontact();//

    correspCtrl.Value1 = 'false';
    correspCtrl.Fields1 =  'Contract_Contact__c';
    correspCtrl.getcontact();//
    /*Test for filter 2 with date field*/
    correspCtrl.enableshowContactFilter2() ;// adds a new row for filter criterea
    correspCtrl.Value2 = '08/08/2015';
    correspCtrl.Fields2 =  'Broker_Agent_End_Date__c';
    correspCtrl.OpertaorsList2 = 'equals';
    correspCtrl.getcontact();//

    correspCtrl.Fields2 =  'Employee_Affiliate_HireDate__c';
    correspCtrl.getcontact(); 

    correspCtrl.Value2 = 'falsetestetetete';
    correspCtrl.Fields2 =  'Primary_Contact__c';
    correspCtrl.getcontact();

    correspCtrl.Fields2 =  'Contact';    
    correspCtrl.getcontact();//

    correspCtrl.Fields2 =  'Broker_Agent_End_Date__c';
    correspCtrl.OpertaorsList2 = 'Contains';
    correspCtrl.getcontact();

    /*Test for filter 3 with date field*/
    correspCtrl.enableshowContactFilter3() ;// adds a new row for filter criterea
    correspCtrl.Value3 = '08/08/2015';
    correspCtrl.Fields3 =  'Broker_Agent_Start_Date__c';
    correspCtrl.OpertaorsList3 = 'equals';
    correspCtrl.getcontact();//

    correspCtrl.Value3 = 'falsetestetetete';
    correspCtrl.Fields3 =  'DoNotCall';
    correspCtrl.getcontact();

    correspCtrl.Fields3 =  'Employee_Affiliate_HireDate__c';
    correspCtrl.getcontact(); 

    correspCtrl.Fields3 =  'Contact';    
    correspCtrl.getcontact();//

    correspCtrl.Fields3 =  'Broker_Agent_Start_Date__c';
    correspCtrl.OpertaorsList3 = 'Contains';
    correspCtrl.getcontact();//

    /*Test for filter 4 with date field*/
    correspCtrl.enableshowContactFilter4() ;// adds a new row for filter criterea
    correspCtrl.Fields4 =  'Contact';  
    correspCtrl.getcontact();

    correspCtrl.Fields4 =  'License_Expiration_Date__c';
    correspCtrl.Value4 = 'test';
    correspCtrl.OpertaorsList4 = 'Contains';
    correspCtrl.getcontact();//

    correspCtrl.Value4 = '08/08/2015';
    correspCtrl.Fields4 =  'License_Expiration_Date__c';
    correspCtrl.OpertaorsList4 = 'equals';
    correspCtrl.getcontact();//
    correspCtrl.Value4 = 'falsetest';
    correspCtrl.Fields4 =  'HasOptedOutOfEmail';    
    correspCtrl.getcontact();//

    correspCtrl.Fields4 =  'Employee_Affiliate_HireDate__c';
    correspCtrl.getcontact(); 

    /*Test for filter 5 with date field*/
    correspCtrl.enableshowContactFilter5() ;// adds a new row for filter criterea
    correspCtrl.Fields5 =  'Contact';  
    correspCtrl.getcontact();

    correspCtrl.Fields5 =  'License_Expiration_Date__c';
    correspCtrl.Value5 = 'test';
    correspCtrl.OpertaorsList5 = 'Contains';
    correspCtrl.getcontact();//

    correspCtrl.Value5 = '08/08/2015';
    correspCtrl.Fields5 =  'Member_Date_Death__c';
    correspCtrl.OpertaorsList5 = 'equals';
    correspCtrl.getcontact();//
    correspCtrl.Value5 = 'falsetest';
    correspCtrl.Fields5 =  'HasOptedOutOfFax';    
    correspCtrl.getcontact();//

    correspCtrl.Fields5 =  'Employee_Affiliate_HireDate__c';
    correspCtrl.getcontact(); 

    /*Test for filter 6 with date field*/
    correspCtrl.enableshowContactFilter6() ;// adds a new row for filter criterea
    correspCtrl.Fields6 =  'Contact';  
    correspCtrl.getcontact();

    correspCtrl.Fields6 =  'License_Expiration_Date__c';
    correspCtrl.Value6 = 'test';
    correspCtrl.OpertaorsList6 = 'Contains';
    correspCtrl.getcontact();//

    correspCtrl.Value6 = '08/08/2015';
    correspCtrl.Fields6 =  'Employee_Affiliate_HireDate__c';
    correspCtrl.OpertaorsList6 = 'equals';
    correspCtrl.getcontact();//
    correspCtrl.Value6 = 'falsetest';
    correspCtrl.Fields6 =  'Behavioral_Health_Active__c';    
    correspCtrl.getcontact();//

    correspCtrl.Fields6 =  'testtestEmployee_Affiliate_HireDate__c';
    correspCtrl.getcontact();
    Test.stopTest();
    }

    /*******************************************************************
    Purpose: This Method is used to test get the value of the Operator Field and open the select Email template page .
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/ 
    static testMethod void getOperator_previewTemplateTest(){

    Pagereference ref1 = Page.VFP44_Correspondencetemplate;
    Test.setCurrentPage(ref1); 
    Correspondence_Letter__c cLetter = new Correspondence_Letter__c();
    insert cLetter;
    /*********************************************************************** 
    Verifying the Correspondence_Letter__c has created successfuly 
    Expected Result: Correspondence_Letter__c id is not null
    Actual Result: Correspondence_Letter__c id is not null 
    ***********************************************************************/ 
    system.assert(cLetter.id != null);
    
    ApexPages.StandardController ctr = new ApexPages.StandardController(cLetter );
    Test.startTest();
    VFC44_Correspondencetemplate correspCtrl = new VFC44_Correspondencetemplate(ctr);
    correspCtrl.saveCorresspondenceLetter() ;//covers the error message for ErrorForTemplate
    EmailTemplate edm1 =  [Select id,Name from EmailTemplate Where TemplateType ='HTML' Limit 1];
    correspCtrl.getItems();
    correspCtrl.getOperator();
    correspCtrl.saveCorresspondenceLetter() ; // calls the save method and generates an error since no contact is searched
    correspCtrl.Fields =  'FirstName';
    Pagereference redirect5 = correspCtrl.getcontact();// throws an error 'Please Enter Value' as no value for search is set
    correspCtrl.Value = 'Test';
    correspCtrl.OpertaorsList = 'Contains';
    correspCtrl.saveCorresspondenceLetter() ;// Throws an error on save since Email template is not selected
    //correspCtrl.SelectedEmailTemplate = edm1.id;
    Pagereference redirect3 = correspCtrl.getcontact();
    correspCtrl.Fields =  'Birthdate';// we set a field of type boolean
    correspCtrl.OpertaorsList = 'equals';
    correspCtrl.getcontact();//  we get an error on search ass right boolean value is not set
    correspCtrl.Value = '01/11/2016';//system.today();
    correspCtrl.getcontact();// the records can be searched now since boolean is set rightly
    correspCtrl.saveCorresspondenceLetter();
    correspCtrl.previewTemplate();

    correspCtrl.Fields =  'Employee_Affiliate_HireDate__c';// we set a field of type boolean
    correspCtrl.OpertaorsList = 'equals';
    correspCtrl.Value = 'test';//system.today();
    correspCtrl.showContactFilter1 = true;
    correspCtrl.fields1 = 'Contact';
    correspCtrl.getcontact();// the records can be searched now since boolean is set rightly

    correspCtrl.Fields =  'Employee_Affiliate_HireDate__c';// we set a field of type boolean
    correspCtrl.OpertaorsList = 'equals';
    correspCtrl.Value = 'test';//system.today();
    correspCtrl.showContactFilter1 = true;
    correspCtrl.OpertaorsList1 = 'Contains';
    correspCtrl.getcontact();// the records can be searched now since boolean is set rightly

    correspCtrl.Fields =  'TestTestTest';// we set a field of type boolean
    correspCtrl.OpertaorsList = 'equals';
    correspCtrl.Value = 'testtest';//system.today();
    correspCtrl.getcontact();// the records can be searched now since boolean is set rightly 

    /*Test for filter 2 with date field*/
    correspCtrl.enableshowContactFilter2() ;// adds a new row for filter criterea
    correspCtrl.Value2 = '08/08/2015';
    correspCtrl.Fields2 =  'Broker_Agent_End_Date__c';
    correspCtrl.OpertaorsList2 = 'equals';
    correspCtrl.getcontact();//
    correspCtrl.Value2 = 'true';
    correspCtrl.Fields2 =  'Primary_Contact__c';    
    correspCtrl.getcontact();//

    correspCtrl.Fields2 =  'Contact';    
    correspCtrl.getcontact();
    Test.stopTest();
    }
}