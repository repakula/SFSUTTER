/* Test class for CorrespondenceLookup
Created on: 11/12/14
Author :Accenture Sutter IDC team
*/
@isTest
private class CorrespondenceLookup_Test
{



 static testmethod void test1()
 {
  /* test data creation start */
   Account acc= new Account (Name ='TestAcc',Broker_Firm_HCC_ID__c = '543412');
   Contact con = new Contact(FirstName='Testing',LastName='Contact',Phone='1234567890',Account= acc,Member_ID__c = '123432',Member_Subscriber_Relationship__c = 'Relationtest',RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Member').getRecordTypeId() ); 
   Contact con1   = new Contact(FirstName='Testing1',LastName='Contact1',Phone='1234567891',Account= acc,Member_Subscriber_Relationship__c = 'Relationtest1');
   insert acc;
   //Assert to check Account is created successfully
   system.assert(acc.id!=null);
   insert con;
   //Assert to check Contact is created successfully
   system.assert(con.id!=null);
   insert con1;
   
  //Assert to check Contact is created successfully
   system.assert(con1.id!=null);
   // End of creation of test data
 test.startTest();

  Test.setCurrentPageReference(new PageReference('Page.CorrespondenceLookup'));

  System.currentPageReference().getParameters().put('ContactId', con.id);
  System.currentPageReference().getParameters().put('CorrepondenceType', Label.CL08_Member);
  CorrespondenceLookup controller = new CorrespondenceLookup();
  controller.inputSrch = 'test';
  controller.searchMember();
   System.currentPageReference().getParameters().put('ContactId', con1.id);
  System.currentPageReference().getParameters().put('CorrepondenceType', Label.CL08_Member);
  CorrespondenceLookup controller1 = new CorrespondenceLookup();
  
  
 test.stopTest();
 }




}