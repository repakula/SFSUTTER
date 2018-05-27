/**    
 *     Class Name  : ManageCorrespondenceHelper_Test
 *     Author      : IDC Offshore  
 *     Date        : 9-Feb-2015  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : Test Class ManageCorrespondenceHelper and ManageCorrepondence.
 **/
@isTest
private class ManageCorrespondenceHelper_Test {
    public static String PARENTACCOUNTTYPE = 'SHP Subscriber';
    public static String CONTACTRECTYPE = 'Member';
    
    @testsetup
    Static Void cretetestData()
    {
    Account testAccount = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          Subscriber_HCC_ID__c ='M000123-01',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount);
        // Assert to check Account is created successfully
        system.assert(testAccount.id!=null);
        Account testAccount1 = new Account(RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get(PARENTACCOUNTTYPE).RecordTypeId,
                                          Name='Test Account',
                                          Status__c= 'Contracted',
                                          Subscriber_HCC_ID__c ='M000113-01',
                                          NumberOfEmployees = 300);
     
        Database.insert(testAccount1);
        // Assert to check Account is created successfully
        system.assert(testAccount1.id!=null);
        Contact testContact = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep',
                                          Accountid =testAccount.id, Member_ID__c='M000123-01', MemberIdField__c='00012301'
                                          );
          Database.insert(testContact);
          // Assert to check Contact is created successfully
        system.assert(testContact.id!=null);
        Contact testContact1 = new Contact(RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACTRECTYPE).RecordTypeId,
                                          LastName = 'Test contact',
                                          Broker_Agent_Status__c = 'Prospect',
                                          Type__c = 'Broker Rep',
                                          Accountid =testAccount.id, Member_ID__c='M001123-01', MemberIdField__c='00012301'
                                          );
      Database.insert(testContact1);
    // Assert to check Contact is created successfully
        system.assert(testContact1.id!=null);                                         
    
        
    }
    /**
    * @author       :   IDC Offshore 
    * @date         :   04-Nov-2015
    * @version      :   1.0
    * @description  :   Added for Correspondence member employer  Req no 3378
    *               :   inserting   lookup only for those record  whose SHP_Correspondence_Entity_Recipient_HCC__c is not equal to  Account.Subscriber_HCC_ID__c
    * @param        :   void
    * @return       :   void
    */
     public static testMethod void testDependentCorrespondence(){
         test.starttest();
        list <Correspondence_Letter__c> listCorrespondence = new  list <Correspondence_Letter__c> ();
        Correspondence_Letter__c testCorrespondence1 = new Correspondence_Letter__c( SHP_OnBaseID__c ='123', SHP_Entity_Type__c ='member', SHP_Parent_Correspondence_ID__C ='123456',SHP_Correspondence_Entity_Recipient_HCC__c ='M000123-01');
        listCorrespondence.add(testCorrespondence1) ;
        insert listCorrespondence ;   
        Correspondence_Letter__c  testcrs= [select id from Correspondence_Letter__c where SHP_Entity_Type__c ='member'];  
        system.assert(testcrs!=null);         
        ManageCorrespondenceHelper.insertCorrespondenceSubscriber(listCorrespondence);
        ManageCorrespondenceHelper.checkRecordType(null);
        ManageCorrespondenceHelper.insertCorrespondenceSubscriber(null);
        test.stoptest();
     }
    /**
    * @author       :   IDC Offshore 
    * @date         :   04-Nov-2015
    * @version      :   1.0
    * @description  :   Correspondence member employer  Req no 3378
    *               :   inserting record whose  Account.Subscriber_HCC_ID__c != SHP_Correspondence_Entity_Recipient_HCC__c
    * @param        :   void
    * @return       :   void
    */
      public static testMethod void testDependentCorrespondence1(){
          test.starttest();
        list <Correspondence_Letter__c> listCorrespondence = new  list <Correspondence_Letter__c> ();
        Correspondence_Letter__c testCorrespondence1 = new Correspondence_Letter__c( SHP_OnBaseID__c ='123', SHP_Entity_Type__c ='member', SHP_Parent_Correspondence_ID__C ='123456',SHP_Correspondence_Entity_Recipient_HCC__c ='M001123-01');
        listCorrespondence.add(testCorrespondence1) ;
        insert listCorrespondence ;   
        Correspondence_Letter__c  testcrs= [select id from Correspondence_Letter__c where SHP_Entity_Type__c ='member'];  
        system.assert(testcrs!=null);         
        ManageCorrespondenceHelper.insertCorrespondenceSubscriber(listCorrespondence);
        test.stoptest();
    
     }
}