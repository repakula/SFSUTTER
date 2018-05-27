/********************************************************    
 *     Class Name  : SHMMN_AcceptOpportunity_Test 
 *     Author      : IDC Offshore   
 *     Date        : 04-may-2016  
 *     Project Name: CRM - SFT - Sutter Health   
 *     Description : Test Class for Accept Opportunity Class.  
 *********************************************************/
@isTest
private class SHMMN_AcceptOpportunity_Test{

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
     // assert to check user is created successfully
     system.assert(SHMMNUser.id!=null);

     Id shpProfileId = [SELECT Id FROM Profile WHERE Name='SHP Sales'].Id;
     Id shpURole =  [SELECT Id FROM UserRole WHERE Name='Sales Coordinator'].Id;  
     User SHPUser = new User(Alias = 'shpAli', Email='SHPuser@testmethod.com', 
     EmailEncodingKey='UTF-8', LastName='TestingSHP', LanguageLocaleKey='en_US', 
     LocaleSidKey='en_US', ProfileId = shpProfileId, UserRoleId = shpURole,
     TimeZoneSidKey='America/Los_Angeles', UserName='SHPuser@testmethod.com');
     insert SHPUser ;   
     
     // assert to check SHP user is created a succesfull
     system.assert(SHPUser.id!=null);
    System.runAs(SHMMNUser){
    Id accrecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
    System.assert(accrecType!=null);
    
    Account tempaccount = new Account(name ='test account',RecordTypeId = accrecType);
    insert tempaccount;
    // assert to check account is created succesfully
    system.assert(tempaccount.id!=null);

    Id recType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHMMN Opportunity').getRecordTypeId();
    System.assert(recType!=null);
    
    Id recTypeSHP = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHP Sales Opportunity').getRecordTypeId();
    System.assert(recTypeSHP!=null);
    
    Opportunity tempopportunity = new Opportunity(name ='test opportunity',Full_Time_Employees__c=10,Service_Line_Product_Promotion__c='Bariatric',Plan_Effective_Date__c=Date.TODAY(), Plan_end_date__c=Date.TODAY(), StageName='Pending Broker',CloseDate=Date.TODAY(),Type='New Business',AccountId=tempaccount.id,RecordTypeId = recType);
    insert tempopportunity;
    
    Opportunity tempopportunitySHP = new Opportunity(name ='test opportunity SHP',Full_Time_Employees__c=10,Service_Line_Product_Promotion__c='Bariatric',Plan_Effective_Date__c=Date.TODAY(), Plan_end_date__c=Date.TODAY(), StageName='Pending Broker',CloseDate=Date.TODAY(),Type='New Business',AccountId=tempaccount.id,RecordTypeId = recTypeSHP);
    insert tempopportunitySHP;
    
    // assert to check opportunity is created succesfully
    system.assert(tempopportunity.id!=null);
    }
   }
 /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to Accept the Non Accepted SHMMN Shared Opportunity by SHP Sales team         
 * @return void        
********************************/ 
 static testmethod void OpportunityAccept1BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    tempOpp.Shared_with_SHP__c = true;
    tempOpp.Accepted__c = false;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHPUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assert(vfc.showAccept == false);
    }
 }
 
 /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to Accept the Accepted SHMMN Shared Opportunity by SHP Sales team         
 * @return void        
********************************/ 
 static testmethod void OpportunityAccept2BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    
    tempOpp.Shared_with_SHP__c = true;
    tempOpp.Accepted__c = true;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHPUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
/********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to Accept the Non Shared SHMMN Opportunity by SHP Sales team         
 * @return void        
********************************/ 
 static testmethod void OpportunityAccept3BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    
    tempOpp.Shared_with_SHP__c = false;
    tempOpp.Accepted__c = true;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHPUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
 
 /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to Accept Accepted Non Shared SHMMN Opportunity by SHP Sales team         
 * @return void        
********************************/ 
 static testmethod void OpportunityAccept4BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    
    tempOpp.Shared_with_SHP__c = false;
    tempOpp.Accepted__c = false;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHPUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
 
  /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to Accept Accepted Shared SHMMN Opportunity by other SHP Sales team         
 * @return void        
********************************/ 
 static testmethod void OpportunityAccept5BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
   
    
    tempOpp.Shared_with_SHP__c = true;
    tempOpp.Accepted__c = true;
    tempOpp.OwnerId= SHMMNUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHPUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assertNotEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
 
/********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to Accept Non Accepted Non Shared SHMMN Opportunity by other SHP Sales team         
 * @return void        
********************************/ 
 static testmethod void OpportunityAccept6BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
  
    
    tempOpp.Shared_with_SHP__c = false;
    tempOpp.Accepted__c = false;
    tempOpp.OwnerId= SHMMNUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHPUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assertNotEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
 
 /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to Accept Accepted Shared SHMMN Opportunity by SHMMN          
 * @return void        
********************************/ 
 static testmethod void OpportunityAccept1BySHMMNUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
  
    
    tempOpp.Shared_with_SHP__c = true;
    tempOpp.Accepted__c = true;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    vfc.Cancel();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
 
  /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to Accept Non Shared SHMMN Opportunity by SHMMN          
 * @return void        
********************************/ 
 static testmethod void OpportunityAccept2BySHMMNUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
  
    
    tempOpp.Shared_with_SHP__c = false;
    tempOpp.Accepted__c = true;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    vfc.Cancel();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
 static testmethod void OpportunityAccept2ABySHMMNUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity SHP' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
  
    
    tempOpp.Shared_with_SHP__c = true;
    tempOpp.Accepted__c = true;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity SHP' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    vfc.Cancel();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
   /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to Accept Accepted Shared SHMMN Opportunity by SHMMN          
 * @return void        
********************************/ 
 static testmethod void OpportunityAccept3BySHMMNUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
  
    
    tempOpp.Shared_with_SHP__c = true;
    tempOpp.Accepted__c = false;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    vfc.Cancel();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
 
    /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to Accept NonAccepted NonShared SHMMN Opportunity by SHMMN          
 * @return void        
********************************/ 
 static testmethod void OpportunityAccept4BySHMMNUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
  
    
    tempOpp.Shared_with_SHP__c = false;
    tempOpp.Accepted__c = false;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    vfc.Cancel();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
 
 
 /********************************************************        
 * @author IDC Team        
 * @date  04-may-2016       
 * @description method to Accept the Non Accepted SHMMN Shared Opportunity by SHP Sales team         
 * @return void        
********************************/ 
  static testmethod void OpportunityAccept11BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity SHP' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    tempOpp.Shared_with_SHMMN__c = true;
    tempOpp.Accepted__c = false;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHMMN__c,Accepted__c from Opportunity where name='test opportunity SHP' ];
    System.runAs (SHPUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assert(vfc.showAccept == false);
    }
 }
 static testmethod void OpportunityAccept12BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity SHP' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    
    tempOpp.Shared_with_SHMMN__c = true;
    tempOpp.Accepted__c = false;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHMMN__c,Accepted__c from Opportunity where name='test opportunity SHP' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
 static testmethod void OpportunityAccept13BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity SHP' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    
    tempOpp.Shared_with_SHP__c = true;
    tempOpp.Accepted__c = false;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    vfc.Cancel();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }

  static testmethod void OpportunityAccept14BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    
    tempOpp.Shared_with_SHMMN__c = false;
    tempOpp.Accepted__c = false;
    tempOpp.OwnerId= SHMMNUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHMMN__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assertEquals(tempOpp.OwnerId , SHMMNUser.id);
    }
 }
  static testmethod void OpportunityAccept15BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    
    tempOpp.Shared_with_SHMMN__c = true ;
    tempOpp.Accepted__c = true;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHMMN__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
}
 static testmethod void OpportunityAccept16BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    
    tempOpp.Shared_with_SHMMN__c = true ;
    tempOpp.Accepted__c = false;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHMMN__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHPUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
}
 static testmethod void OpportunityAccept17BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    
    tempOpp.Shared_with_SHMMN__c = true ;
    tempOpp.Accepted__c = true;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHMMN__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHPUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
}
 static testmethod void OpportunityAccept18BySHPUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
    
    tempOpp.Shared_with_SHMMN__c = true ;
    tempOpp.Accepted__c = true;
    tempOpp.OwnerId= SHMMNUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHMMN__c,Accepted__c from Opportunity where name='test opportunity' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    system.assertEquals(tempOpp.OwnerId , SHMMNUser.id);
    }
}
 static testmethod void OpportunityAccept2BBySHMMNUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity SHP' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
  
    
    tempOpp.Shared_with_SHP__c = false;
    tempOpp.Accepted__c = true;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity SHP' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    vfc.Cancel();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
static testmethod void OpportunityAccept2CBySHMMNUser_Test()
 {
    Opportunity tempOpp= [select id,name,Shared_with_SHP__c,Accepted__c,Error_Reason__c,OwnerId from Opportunity where name='test opportunity SHP' ];
    User SHMMNUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHMMNUser!=null);
    User SHPUser = [select id from User where UserName='SHPuser@testmethod.com'] ;
    // Assert to check lead is fetched successfully.
    System.assert(SHPUser!=null);
  
    
    tempOpp.Shared_with_SHP__c = true;
    tempOpp.Accepted__c = false;
    tempOpp.OwnerId= SHPUser.id;
    update tempOpp;
    List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,Accepted__c from Opportunity where name='test opportunity SHP' ];
    System.runAs (SHMMNUser) {
    ApexPages.StandardSetController  controller = new ApexPages.StandardSetController(tempOppList );
    controller.setSelected(tempOppList);
    SHMMN_AcceptOpportunity   vfc = new SHMMN_AcceptOpportunity (controller);
    vfc.updateOwner();
    vfc.Cancel();
    system.assertEquals(tempOpp.OwnerId , SHPUser.id);
    }
 }
 }