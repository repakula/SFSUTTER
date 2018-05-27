/* 
     Class Name: SHP_updateRegionOnCensus_Test 
     Author: Haritha
     Date: 20-Apr-2016
     Description: Test class for SHP_updateRegionOnCensus Trigger.

*/
@isTest 

private class  SHP_updateRegionOnCensus_Test{
 
 private static Account acc;
 private static Opportunity opp;
 private static Census__c census , census1;
 private static   Zip_Code_Master__c zmaster , zmaster1;
 private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
 
 /*Method to Set up Test data*/
 
 public static TestMethod void setupTestData(){
    
    //Insert Account
    acc = new Account();
    acc.Name = 'Test Account';
    acc.RecordTypeId = accRecordTypeId;
    acc.NumberOfEmployees = 100;
    acc.Industry = 'Test Industry';
    insert acc;
    
    //Insert Opportunity
    opp = new Opportunity();
    opp.Name = 'Test Opportunity';
    opp.AccountId = acc.id;
    opp.type = 'Test type';
    opp.CloseDate = Date.Today();
    opp.StageName = 'Pending Broker';
    opp.Current_Status__c = 'No';
    insert opp;
    
    //Insert Zip Code master record
    zmaster = new Zip_Code_Master__c();
    zmaster.Zip_code__c = '94577'  ;
    zmaster.Region__c = 'East Bay';
    zmaster.County_1__c = 'Alameda' ;
  
    insert zmaster;
    
    //Insert SHP Census record
    census = new Census__c();
    census.Format_Match_Boolean__c = true;
    census.DOB__c = Date.today().addDays(-15);
    census.Opportunity__c = opp.id;
    census.Employee_Zip__c = '94577';
    
    insert census;
    
    //Update Census record
    
    census.Status__c = 'Successful';
    
    update census;
    
 }
 
 /* Test method to test the Region & County fields update on census for Valid Zip given */
 
 public static testMethod void TestRegionUpdate() 
 {
 
  Test.startTest();
  setupTestData();
  zmaster1 =[ Select id, Region__c, County__c, Zip_code__c from Zip_Code_Master__c where Zip_code__c = :census.Employee_Zip__c];
  census1 = [ Select id, Region__c, County__c,Employee_Zip__c from Census__c ];
  
  system.assertEquals(zmaster1.Region__c,census1 .Region__c);
  system.assertEquals(zmaster1.County__c,census1 .County__c);
  Test.stopTest(); 
  
 }
 
/* Test method to test the Region & County fields update on census for Invalid Zips given */

 public static testMethod void TestRegionUpdate1() 
 {
 
  Test.startTest();
  setupTestData();
  census.Employee_Zip__c = '77777';
  update census;
  
  census1 = [ Select id, Region__c, County__c,Employee_Zip__c from Census__c ];
  system.assertEquals(Label.SHP_Region_Value,census1.Region__c);
  system.assertEquals(Label.SHP_Region_Value,census1.County__c);
  Test.stopTest(); 
  
 } 
 
 /* Test method to test the Region & County fields update on census when updated in Zip code master */ 
 public static testMethod void TestRegionUpdate2() 
 {
 
  Test.startTest();
  setupTestData();
  
  zmaster.Zip_code__c = '94577';
  zmaster.Region__c = 'Bay';
  zmaster.County_1__c = 'Ala' ;
  update zmaster;
  
  census.Employee_Zip__c = '94577';
  //census.Zip_Code_Master__c = zmaster.id;
  update census;
  
  zmaster1 =[ Select id, Region__c, County__c, Zip_code__c from Zip_Code_Master__c where Zip_code__c = :census.Employee_Zip__c]; 
  census1 = [ Select id, Region__c, County__c,Employee_Zip__c from Census__c ];
  
  system.assertEquals(zmaster1.Zip_code__c,census1 .Employee_Zip__c);
  system.assertEquals(zmaster1.Region__c,census1 .Region__c);
  system.assertEquals(zmaster1.County__c,census1 .County__c);
  
  Test.stopTest(); 
  }
  
}