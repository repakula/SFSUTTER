/*
* This utility class creates objects and sets the required fields on them. This is done by scanning objects folder
* The appropriate static methods of this Utility Class will be called in Test Classes, Unit test  whenever the test class has to create objects
* 
*/
 @isTest
 public class UtilUnitTest { 
/*
* @Method This method getUser is used to get a User
* @param Method is not having any parameters
* @return User - Method returning instance of User
* @throws exception - Method is not throwing any exception
*/ 
 public static User getUser(){ 
    String aliasString = 'test';
    Id sysAdminId = [Select Id from Profile Where Name = 'System Administrator' Limit 1].Id;
    // Assert to check Admin profile is fetched 
    system.assert(sysAdminId!=null);
    User usr = new User(
    alias = aliasString, 
    email= aliasString+'@accenture.com',
    emailencodingkey='UTF-8',
    lastname='Testing', 
    languagelocalekey='en_US',
    localesidkey='en_US',
    profileid = sysAdminId,
    timezonesidkey='Europe/London',
    username= aliasString+'@accenture.com');
    return usr;
 }

/*
* @Method This method  getCase is used to get a  Case
* @param Method is not having any parameters
* @return Case - Method returning instance of  Case
* @throws exception - Method is not throwing any exception
*/  
 public static Case getCase() {
    Case caseSample=new Case();
    caseSample.SuppliedEmail = 'test@salesforce.com';
    // Assert to check email is not blank
    system.assertnotequals(caseSample,null);

    return caseSample;
  }

/*
* @Method This method  getServiceRequests__c is used to get a  ServiceRequests__c
* @param Method is not having any parameters
* @return ServiceRequests__c - Method returning instance of  ServiceRequests__c
* @throws exception - Method is not throwing any exception
*/  
 public static ServiceRequests__c getServiceRequests_c() {
    ServiceRequests__c servicerequestsSample=new ServiceRequests__c();
    servicerequestsSample.Name='Test ServiceRequests__c';
    //Assert to check ServiceRequests__c is not blank
    system.assertnotequals(servicerequestsSample,null);

    return servicerequestsSample;
  }

 }