/********************************************************    
 *     Class Name  : SHMMN_AccountRemovedManage _Test 
 *     Author      : IDC Offshore   
 *     Date        : 04-may-2016  
 *     Project Name: CRM - SFT - Sutter Health   
 *     Description : Test Class for SHMMN_AccountRemovedManage .  
 *********************************************************/
@isTest
private class SHMMN_AccountRemovedManage_Test{

/********************************************************        
 * @author IDC Team        
 * @date  03-may-2016       
 * @description method to create test data used by all tests       
 * @return void        
********************************/
    @testSetup
    Static void createTestData(){
    
     Id profileId = [SELECT Id FROM Profile WHERE Name='SHMMN Management'].Id;
     Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN Manager'].Id;
     User SHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', 
     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
     LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole,
     TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod.com');
     insert SHMMNUser ;
     // assert to check user is created a succesfull
     system.assert(SHMMNUser.id!=null);
     
     Id ersprofileId = [SELECT Id FROM Profile WHERE Name='SHMMN Sales'].Id;
     Id uRoleERS =  [SELECT Id FROM UserRole WHERE Name='SHMMN ERS Member'].Id;
     User SHMMNERSUser = new User(Alias = 'stan2', Email='SHMMNERS@testmethod.com', 
     EmailEncodingKey='UTF-8', LastName='TestingERS', LanguageLocaleKey='en_US', 
     LocaleSidKey='en_US', ProfileId = ersprofileId, UserRoleId = uRoleERS,
     TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNERS@testmethod.com');
     insert SHMMNERSUser ;
     // assert to check user is created a succesfull
     system.assert(SHMMNERSUser.id!=null);

    System.runAs(SHMMNERSUser){
    Id accrecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
    System.assert(accrecType!=null);
    
    Account tempaccount = new Account(name ='test account',RecordTypeId = accrecType, status__c= 'Prospect');
    insert tempaccount;
    // assert to check account is created succesfully
    system.assert(tempaccount.id!=null);
    }
   }
 /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to update the Account Status by SHMMN Manager         
 * @return void        
********************************/ 
 static testmethod void AccountOverrideByManager_Test()
 {
    Account tempaccount= [select id,name,status__c from Account where name='test account' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check User is fetched successfully.
    System.assert(SHMMNUser!=null);
   
    System.runAs (SHMMNUser) {
    ApexPages.StandardController  controller = new ApexPages.StandardController(tempaccount );
    apexpages.currentpage().getparameters().put('id' , tempaccount.id);
    SHMMN_AccountRemovedManage   vfc = new SHMMN_AccountRemovedManage (controller);
    Test.startTest();
    vfc.acc.status__c= 'Removed';
    vfc.statusOverride ='Test Comment';
    vfc.updateStatus();
    vfc.CheckStatus();
    system.assert(vfc.showpage == false);
    Test.stopTest();
    }
 }   
    /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to update the Account Status by SHMMN ERS         
 * @return void        
********************************/ 
 static testmethod void AccountOverrideByERS_Test()
 {
    Account tempaccount= [select id,name,status__c,Status_Override_Comment__c from Account where name='test account' ];
    User SHMMNERSUser = [select id from User where UserName='SHMMNERS@testmethod.com'] ;
    // Assert to check User is fetched successfully.
    System.assert(SHMMNERSUser!=null);
    tempaccount.Status_Override_Comment__c ='Test Comment by ERS';
    Update tempaccount; 
    System.runAs (SHMMNERSUser) {
    ApexPages.StandardController  controller = new ApexPages.StandardController(tempaccount );
    apexpages.currentpage().getparameters().put('id' , tempaccount.id);
    SHMMN_AccountRemovedManage   vfc = new SHMMN_AccountRemovedManage (controller);
    Test.startTest();
    vfc.acc.status__c= 'Removed';
    vfc.statusOverride ='Test Comment';
    vfc.updateStatus();
    vfc.CheckStatus();
    system.assert(vfc.showpage == true);
    Test.stopTest();
    }
 }
    /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to cver negative test scenario for Account Status Update functionality         
 * @return void        
********************************/  
static testmethod void accountOverrideException_Test()
{
    Account tempaccount= [select id,name,status__c,Status_Override_Comment__c from Account where name='test account' ];
    
    User SHMMNERSUser = [select id from User where UserName='SHMMNERS@testmethod.com'] ;
    // Assert to check User is fetched successfully.
    System.assert(SHMMNERSUser!=null);
    
    Update tempaccount; 

    System.runAs (SHMMNERSUser) {

    ApexPages.StandardController  controller = new ApexPages.StandardController(tempaccount );
    apexpages.currentpage().getparameters().put('id' , tempaccount.id);
    SHMMN_AccountRemovedManage   vfc = new SHMMN_AccountRemovedManage (controller);
    Test.startTest();
    vfc.acc.Status_Override_Comment__c ='Test Comment by ERS';
    vfc.acc.status__c= 'Removed';
    vfc.acc.Industry = null;
    vfc.statusOverride = null;
    vfc.acc.Name = null;
    vfc.updateStatus(); 
    Test.stopTest();
    //Assert to check Account is not updated
    System.assert(tempaccount.Status_Override_Comment__c == null);
 }
}
 }