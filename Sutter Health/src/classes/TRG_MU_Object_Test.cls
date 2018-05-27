/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TRG_MU_Object_Test {

    static testMethod void createTestData(){
    
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('S3 Employee').getRecordTypeId();
        insert acc;
        // Assert to check Account is created successfully
        system.assert(acc.id!=null);
        
        Contact con = new Contact();
        con.LastName = 'Test LastName';
        con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        con.AccountId = acc.id;
        insert con;
        // Assert to check Contact is created successfully
        system.assert(con.id!=null);
        
        Case newCase = new Case();
        newCase.RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Summary of Care').getRecordTypeId();
        //newCase.name = 'test case';
        newCase.ContactId = con.id;
        insert newCase;
        // Assert to check Case is created  successfully
        system.assert(newCase.id!=null);
        
        MU_Object__c mu = new MU_Object__c();
        mu.Status__c = 'In Progress';
        mu.Comments__c = 'Test Comments';
        mu.Escalation_Status__c = 'Cannot send documents to Provider';
        mu.Case__c = newCase.id;
        insert mu;
        // Assert to check MU_Object__c is created  successfully
        system.assert(mu.id!=null);
    }
}