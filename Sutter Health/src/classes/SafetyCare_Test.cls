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
private class SafetyCare_Test {

    static testMethod void positiveTest() {
        PageReference pageRef = Page.safetyCare;
        Test.setCurrentPage(pageRef);
        
        safetyCare_CC sCController = new safetyCare_CC();
     	system.assert(!sCController.completed);
        Safety_Reporting__c newSurvey = sCController.safetyCare;        
        
        //Positive case, user filling out required information
        newSurvey.Affiliate__c = 'Test Affiliate';
        newSurvey.Type_of_Event__c = 'test type';
        newSurvey.Category_of_Event__c = 'test category';
        newSurvey.Causes__c = 'test cause';
        newSurvey.Tip_To_Avoid__c = 'test tip';
        newSurvey.Username__c = 'John Doe';
        newSurvey.Department__c = 'Test Department';
        newSurvey.MRN__c = '12345';
        
        sCController.SaveAndComplete();
        system.assert(newSurvey.id != null);
        system.assert(sCController.completed);
        //Survey filled out
        sCController.safetySurvey.Question_1__c = 'test question';
        sCController.safetySurvey.Q1_Other__c = 'test other';
        sCController.safetySurvey.Suggestions__c = 'test suggestion';
        PageReference newPageRef = sCController.SaveAndNew();
        Test.setCurrentPage(newPageRef);
        
        
    }
     static testMethod void negetiveTest() {
        PageReference pageRef = Page.safetyCare;
        Test.setCurrentPage(pageRef);
        safetyCare_CC sCController = new safetyCare_CC();
     	system.assert(!sCController.completed);
        Safety_Reporting__c newSurvey = sCController.safetyCare;        
        
        //Negetive Case, user did not fill out all required fields
        sCController.SaveAndComplete();
        system.assert(newSurvey.id == null);
        system.assert(!sCController.completed);
        
        //User completes survey and submits
        newSurvey.Affiliate__c = 'Test Affiliate';
        newSurvey.Type_of_Event__c = 'test type';
        newSurvey.Category_of_Event__c = 'test category';
        newSurvey.Causes__c = 'test cause';
        newSurvey.Tip_To_Avoid__c = 'test tip';
        newSurvey.Username__c = 'John Doe';
        newSurvey.Department__c = 'Test Department';
        newSurvey.MRN__c = '12345';
        sCController.SaveAndComplete();
        system.assert(newSurvey.id != null);
        system.assert(sCController.completed);
        //Survey not filled out
        Safety_Survey__c tempSurvey =  sCController.safetySurvey;
        sCController.SaveSurvey();
        system.assert(tempSurvey.id == null); //survey was not inserted
        
        
    }
    
}