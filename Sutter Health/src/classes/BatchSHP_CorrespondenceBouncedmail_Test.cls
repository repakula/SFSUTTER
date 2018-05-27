/**********************************************************************
 Name: BatchSHP_CorrespondenceBouncedmail_Test
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for BatchSHPBrokerCorrespondenceBouncedmail batch class
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  11-Sep-2015 Development complete   This class is defined to test BatchSHPBrokerCorrespondenceBouncedmail class.
 2.0      IDC Offshore  12/18/2015  Class Optimsation   Incorporated changes to implement best test practices in the test class.
 ***********************************************************************/
 
@isTest
private class BatchSHP_CorrespondenceBouncedmail_Test {

    /** Setting values in variables to be used in the test methods **/
    public static String ACNRECTYPE = 'SHP Sales Broker';
    public static String PARENTACCOUNTTYPE = 'SHP Sales Employer';
    public static String CONTACTRECTYPE = 'SHP Sales Broker Contact';
    public static String TEMPLATEFOLDER = 'Broker Correspondence';
    public static String FOLDERTYPE = 'Email';
    public static String LETTERHEADNAME = 'SHP Letterhead';
    
    /** Setting the CRON Expression for both User Create and User Update for Provider RecordType and Source of email as TLFM **/
        public static String CRON_EXP = '0 0 0 15 3 ? 2022';
        
    /*******************************************************************
     Purpose: method to create test data used by all test methods
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
     ********************************************************************/
    
    @testSetup 
    static void createTestData() {
     
     User objUser = [select id from user where id=:userinfo.getuserid()];
     
     /** Creating Custom Setting data to be used in the code of various helper classes like ManageContactDatabase,ManageCommunityUsers etc. **/
     system.runAs(objUser){
       CreatedDate__c obj =new CreatedDate__c();
       obj.Created_date__c = date.today();
       obj.name ='CopyPcpDate';
       insert obj;
           
        CS_ManageProfile__c CSMCommunities_Portal = new CS_ManageProfile__c(Name = 'Communities_Portal', Profile_Name__c='Community Portal');
        CS_ManageProfile__c CSMCommunities_Provider = new CS_ManageProfile__c(Name = 'Communities_Provider', Profile_Name__c='Community Portal Manager');
        CS_ManageProfile__c CSMCommunity_Portal_Manager = new CS_ManageProfile__c(Name = 'Community_Portal_Manager', Profile_Name__c='Community Portal Manager');
        Insert CSMCommunities_Portal;
        Insert CSMCommunities_Provider;
        Insert CSMCommunity_Portal_Manager;
     }
     
     /** Creating Account,Contact and Broker Email Template records to be used in the test methods **/
     Account testAccount,testBrokerAccount;
     Contact testContact;
     Id IdofBrokerAccount,RecordTypeIdOfBroker,RecordTypeIdOfAccount,IdofAccount;    
     
     Id TemplateFolderId = [ SELECT Id FROM Folder WHERE Type = :FOLDERTYPE AND Name = :TEMPLATEFOLDER ].Id;
     Id LetterHeadId = [ SELECT Id FROM BrandTemplate WHERE Name = :LETTERHEADNAME ].Id;

     EmailTemplate BrokerEmailTemplate = new EmailTemplate ( Name = 'Broker Email Template Test',
                                                                DeveloperName = 'Broker_Email_Template',
                                                                BrandTemplateId = LetterHeadId,
                                                                FolderId = TemplateFolderId,
                                                                IsActive = true ,
                                                                Subject = 'Send Email To Broker',
                                                                TemplateType = 'text',
                                                                TemplateStyle = 'promotionLeft',
                                                                Body = 'Hi This is test Template',
                                                                HtmlValue = '<HTML> Hello </html>');

     insert BrokerEmailTemplate;
     
     system.runAs(objUser){
     testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
                                          
     testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testBrokerAccount);
        Database.insert(testAccount);
        
        /** Fetching recrod type id of Account Recordtype **/
        RecordTypeIdOfBroker = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId;
        RecordTypeIdOfAccount = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId;
        IdofBrokerAccount = [SELECT Id FROM Account WHERE RecordTypeId = :RecordTypeIdOfBroker limit 1].Id;
        
        
        IdofAccount = [SELECT Id FROM Account WHERE RecordTypeId = :RecordTypeIdOfAccount limit 1].Id;
        
        /** Creating a Contact for Broker Account **/
        testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact1',
                                          AccountId = IdofBrokerAccount,
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep',
                                          Email = 'gaurav.b.agarwal@accenture.com'
                                          );
                                        
        insert testContact ;
        
        
     }
       /*********************************************************************** 
        Verifying the values of Account and Contact records that are created above 
        Expected Result: id values should not be null 
        Actual Result: id values should not be null 
       **********************************************************************/
        system.assert(testAccount.id!=null);
        system.assert(testBrokerAccount.id!=null);
        system.assert(testContact.id!=null);
             
    }

    /*******************************************************************
     Purpose: method to create Correspondence Letter as a test Data for all test methods
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
     
    public static void createCorrespondenceLetter() {
        Correspondence_Letter__c CorrespondenceLetter = new Correspondence_Letter__c(Status__c = 'Mail Sent',
                                                                                     Selected_Template_Name__c = 'Broker Email Template Test',
                                                                                     To_Contact_List__c = 'Test contact;') ;

        insert CorrespondenceLetter;
        
        /*********************************************************************** 
        Verifying the value of Correspondence record that is created above 
        Expected Result: id value should not be null 
        Actual Result: id value should not be null 
       **********************************************************************/
        system.assert(CorrespondenceLetter.id!=null);
    }   
  
    /*******************************************************************
     Purpose: This method insert Contact with invalid Email Id for Sending Email Using Contact and Bouncing the email   
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
    public static void createContactForBounceEmail() {
        Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
        
        Account testBrokerAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(ACNRECTYPE).RecordTypeId,
                                          Name='Test Account SCN',
                                          Status__c= 'Contracted',
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
                                          Type__c = 'Broker Rep',
                                          Email = 'gaurav.b.agarwal234@accenture.com',
                                                              EmailBouncedReason = 'Invalid Email Id',
                                                              EmailBouncedDate = Datetime.now()
                                          );
                                        
        insert testContact ;
        
        /*********************************************************************** 
        Verifying the value of Contact record that is created above 
        Expected Result: id value should not be null 
        Actual Result: id value should not be null 
       **********************************************************************/
        system.assert(testContact.id!=null);
    }
    
    /*******************************************************************
     Purpose: This method Test the Batch Class functionality of updating the junction Object Records for Bounced email for class BatchSHPBrokerCorrespondenceBouncedmail  
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
     public static testMethod void BatchSHPBrokerCorrespondenceBouncedmail_Test() {
      List< CorrespondenceContactAssociation__c > AssociationObjectListToInsert = new List< CorrespondenceContactAssociation__c>();
        createContactForBounceEmail();
        createCorrespondenceLetter();
      
      List < Contact > InsertedContactList = new List<Contact>([Select Id, Name , RecordType.Name , LastName , EmailBouncedReason , EmailBouncedDate FROM Contact where name='Test contact' ]);
      List <Correspondence_Letter__c> CorrespondenceLetterList = new List<Correspondence_Letter__c>([Select Id , Name FROM Correspondence_Letter__c limit 200 ]);

      
      if ( !InsertedContactList.isEmpty()  && !CorrespondenceLetterList.isEmpty() ) {
        
            CorrespondenceContactAssociation__c JunctionAssociationObj = new CorrespondenceContactAssociation__c(Contact__c = InsertedContactList[0].Id,
                                                                                                                 Correspondence_Letter__c = CorrespondenceLetterList[0].Id,
                                                                                                                 Status__c = 'Mail Sent' );      
                                                                                                      
            AssociationObjectListToInsert.add(JunctionAssociationObj);
      }

      if( !AssociationObjectListToInsert.isEmpty()) {
        
        insert AssociationObjectListToInsert;
      }
      
      Test.startTest();
      
      /** Covering the execute method of database.Schedulable **/
      String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,new BatchSHPBrokerCorrespondenceBouncedmail());
      
      BatchSHPBrokerCorrespondenceBouncedmail runBatch = new BatchSHPBrokerCorrespondenceBouncedmail();
      Id batchprocessid = Database.executeBatch(runBatch,1);
      Test.stopTest();

      for(CorrespondenceContactAssociation__c junctionObj: [Select Id, Status__c ,Bounced_Mail_Reasion__c FROM CorrespondenceContactAssociation__c ]) {
          
        /*********************************************************************** 
        Verifying that Mail has been bounced for CorrespondenceContactAssociation__c record
        Expected Result:  Status is Mail Bounced
        Actual Result:  Status is Mail Bounced
       **********************************************************************/  
        system.assertEquals( junctionObj.Status__c ,'Mail Bounced');
        system.assertEquals( junctionObj.Bounced_Mail_Reasion__c ,InsertedContactList[0].EmailBouncedReason);
      }
    }
    
    
    /*******************************************************************
     Purpose: This method tests the Batch Class functionality of updating the junction Object Records for Bounced email for BatchSHPBrokerCorrespondenceBouncedmail  negatively
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
    public static testMethod void BatchSHPBrokerCorrespondenceBouncedmail_negativeTest() {
      List< CorrespondenceContactAssociation__c > AssociationObjectListToInsert = new List< CorrespondenceContactAssociation__c>();
        createContactForBounceEmail();
        createCorrespondenceLetter();
        
      List < Contact > InsertedContactList = new List<Contact>([Select Id, Name , RecordType.Name , LastName , EmailBouncedReason , EmailBouncedDate FROM Contact limit 200 ]);
      List <Correspondence_Letter__c> CorrespondenceLetterList = new List<Correspondence_Letter__c>([Select Id , Name FROM Correspondence_Letter__c limit 200]);

      
      if ( !InsertedContactList.isEmpty()  && !CorrespondenceLetterList.isEmpty() ) {
            CorrespondenceContactAssociation__c JunctionAssociationObj = new CorrespondenceContactAssociation__c(Contact__c = InsertedContactList[0].Id,
                                                                                                                 Correspondence_Letter__c = CorrespondenceLetterList[0].Id,
                                                                                                                 Status__c = 'Mail Sent'
                                                                                                                 );
              AssociationObjectListToInsert.add(JunctionAssociationObj);
      }

      if( !AssociationObjectListToInsert.isEmpty()) {
        insert AssociationObjectListToInsert;
      }
      
      Test.startTest();
      
      BatchSHPBrokerCorrespondenceBouncedmail runBatch = new BatchSHPBrokerCorrespondenceBouncedmail();
      Id batchprocessid = Database.executeBatch(runBatch,1);
      Test.stopTest();

      for(CorrespondenceContactAssociation__c junctionObj: [Select Id, Status__c ,Bounced_Mail_Reasion__c FROM CorrespondenceContactAssociation__c ]) {
        
        /*********************************************************************** 
        Verifying that Mail has been sent for CorrespondenceContactAssociation__c record
        Expected Result:  Status is Mail Sent
        Actual Result:  Status is Mail Sent
       **********************************************************************/  
        system.assertEquals( junctionObj.Status__c ,'Mail Sent');
        
      }
    }
    
    }