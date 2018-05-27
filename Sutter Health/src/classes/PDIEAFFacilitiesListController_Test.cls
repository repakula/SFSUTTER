/*****************************************************
Class Name: PDIEAFFacilitiesListController_Test
Created By: Nagarjuna Kaipu
Created Date: 15/11/2016
Description: test class for PDIEAFFacilitiesListController class
******************************************************/
@isTest
public class PDIEAFFacilitiesListController_Test {
    //Method to test the facility records searh functionality based on name
    static testMethod void SearchFacilityController() {
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        System.runAs(socUser){
            List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
            insert facList;
            PageReference pageRef = new PageReference('/apex/PDIEAFFacilitiesList');
            Test.setCurrentPage(pageRef);
            PDIEAFFacilitiesListController eafListController = new PDIEAFFacilitiesListController();
            Test.startTest();
            eafListController.facilityName = 'Test';
            eafListController.faciltyID = '';
            eafListController.searchFacility();
            eafListController.getFacilitiesList();
            eafListController.doNext();
            eafListController.doPrevious();
            eafListController.dofirst();
            eafListController.doLast();
            eafListController.getHasPrevious();
            eafListController.getHasNext();
            eafListController.getPageNumber();
            eafListController.getTotalPages();
            System.assertEquals(true, eafListController.getFacilitiesList().size()>0);
            Test.stopTest();
        }
    }
    //Method to test the facility records searh functionality based on facility Id
    static testMethod void SearchFacilityWithFacilityId() {
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        System.runAs(socUser){
            List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
            insert facList;
            PageReference pageRef = new PageReference('/apex/PDIEAFFacilitiesList');
            Test.setCurrentPage(pageRef);
            PDIEAFFacilitiesListController eafListController = new PDIEAFFacilitiesListController();
            Test.startTest();
            eafListController.facilityName = '';
            eafListController.faciltyID = 'abcd0';
            eafListController.searchFacility();
            eafListController.getFacilitiesList();
            eafListController.doNext();
            eafListController.doPrevious();
            eafListController.dofirst();
            eafListController.doLast();
            eafListController.getHasPrevious();
            eafListController.getHasNext();
            eafListController.getPageNumber();
            eafListController.getTotalPages();
            System.assertEquals(true, eafListController.getFacilitiesList().size()>0);
            Test.stopTest();
        }
    }
    //Method to test the facility records searh functionality based on invalid entries
    static testMethod void SearchFacilityWithInvalidParams() {
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        System.runAs(socUser){
            List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
            insert facList;
            PageReference pageRef = new PageReference('/apex/PDIEAFFacilitiesList');
            Test.setCurrentPage(pageRef);
            PDIEAFFacilitiesListController eafListController = new PDIEAFFacilitiesListController();
            Test.startTest();
            eafListController.facilityName = 'T';
            eafListController.faciltyID = '';
            eafListController.searchFacility();
            eafListController.getFacilitiesList();
            eafListController.doNext();
            eafListController.doPrevious();
            eafListController.dofirst();
            eafListController.doLast();
            eafListController.getHasPrevious();
            eafListController.getHasNext();
            eafListController.getPageNumber();
            eafListController.getTotalPages();
            System.assertEquals(false, eafListController.isSearchValues);
            Test.stopTest();
        }
    }
    //Method to test the facility records searh functionality to check no result
    static testMethod void SearchFacilityNoResult() {
        User socUser = Util01_PDIUtilTestData.createSOCUser();
        System.runAs(socUser){
            List<PDV_EAF_Facility__c> facList = Util01_PDIUtilTestData.createEAFFacilityList();
            insert facList;
            PageReference pageRef = new PageReference('/apex/PDIEAFFacilitiesList');
            Test.setCurrentPage(pageRef);
            PDIEAFFacilitiesListController eafListController = new PDIEAFFacilitiesListController();
            Test.startTest();
            eafListController.facilityName = 'kaipu';
            eafListController.faciltyID = '';
            eafListController.searchFacility();
            eafListController.getFacilitiesList();
            eafListController.doNext();
            eafListController.doPrevious();
            eafListController.dofirst();
            eafListController.doLast();
            eafListController.getHasPrevious();
            eafListController.getHasNext();
            eafListController.getPageNumber();
            eafListController.getTotalPages();
            System.assertEquals(true, eafListController.getFacilitiesList().size() == 0);
            Test.stopTest();
        }
    }
}