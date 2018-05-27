/********************************************************    
 *     Class Name  : SHMMN_VFC51_OpportunityUpdate_Test 
 *     Author      : IDC Offshore   
 *     Date        : 05-may-2016  
 *     Project Name: CRM - SFT - Sutter Health   
 *     Description : Test class for HMMN_VFC51_OpportunityUpdate class.  
 *********************************************************/
@isTest
private class SHMMN_OpportunityUpdate_Test{

/********************************************************        
 * @author IDC Team        
 * @date  03-may-2016       
 * @description method to create test data used by all tests       
 * @return void        
********************************/
    @testSetup
    Static void createTestData()
    {
    
     Id profileId = [SELECT Id FROM Profile WHERE Name='SHMMN Management'].Id;
     Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN Manager'].Id;
     User SHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
     LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod.com');
     insert SHMMNUser ;
     // assert to check user is created a succesfull
     system.assert(SHMMNUser.id!=null);     
     System.runAs (SHMMNUser ) 
     {       
        Id accrecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
        System.assert(accrecType!=null);
        
        Account tempaccount = new Account(name ='test account',NumberOfEmployees=10,RecordTypeId = accrecType, Employer_First_Renewal_Date__c =Date.TODAY());
        insert tempaccount;
        // assert to check account is created succesfully
        system.assert(tempaccount.id!=null);

        Id recType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHMMN Opportunity').getRecordTypeId();
        System.assert(recType!=null);
        
        Opportunity tempopportunity = new Opportunity(name ='test opportunity',Full_Time_Employees__c=10,Service_Line_Product_Promotion__c='Bariatric',Plan_Effective_Date__c=Date.TODAY(), Plan_end_date__c=Date.TODAY(), StageName='Pending Broker',CloseDate=Date.TODAY(),Type='New Business',AccountId=tempaccount.id,RecordTypeId = recType);
        insert tempopportunity;
        
        // assert to check opportunity is created succesfully
        system.assert(tempopportunity.id!=null);  
     }
   }
 /*******************************************************************
    Purpose: method to check positive scenario of updating shared opportunity by user who shared the opportunity 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/ 
 static testmethod void OpportunityUpdateSharedByUser_Test()
 {
        Opportunity tempOpp= [select id,name,Shared_with_SHP__c from Opportunity where name='test opportunity' ];
        User tempUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
        // Assert to check lead is fetched successfully.
        System.assert(tempOpp!=null);
        System.runAs (tempUser ) 
        {
            tempOpp.Shared_with_SHP__c = true;
            tempOpp.Opportunity_Shared_By__c = tempUser.id;
            tempOpp.Service_Line_Product_Promotion__c=System.Label.CL_77_SM_SHP;
            tempOpp.Classification__c = 'RFP Request';
            update tempOpp;
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempOpp);
            apexpages.currentpage().getparameters().put('id' , tempOpp.id);
            SHMMN_OpportunityUpdate   vfc = new SHMMN_OpportunityUpdate(controller);
            Test.startTest();
            vfc.Save();
            vfc.Cancel();
            //Assert to check page to update opportunity is shown to user
            system.assert(vfc.showPage == true);
            Test.stopTest();
        }
 }
/*******************************************************************
    Purpose: method to check positive scenario of updating shared opportunity by user above in hierarchy of user who shared opportunity  
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/  
 static testmethod void OpportunityUpdateAboveSharedByUser_Test()
 {
         Opportunity tempOpp= [select id,name,Shared_with_SHP__c from Opportunity where name='test opportunity' ];
         User tempUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
         //Assert to check opportunity is fetched successfully
         System.assert(tempOpp!=null);

         Id profileId = [SELECT Id FROM Profile WHERE Name='SHMMN Management'].Id;
         Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN Director'].Id;
         User SHMMNUser = new User(Alias = 'standt1', Email='SHMMNuser1@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuserDircetor@testmethod.com');
         insert SHMMNUser ;
         // assert to check user is created successfully
         system.assert(SHMMNUser.id!=null);
        
         System.runAs (SHMMNUser ) 
         {
            Test.startTest();            
            tempOpp.Shared_with_SHP__c = true;
            tempOpp.Opportunity_Shared_By__c = tempUser.id;
            update tempOpp;
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempOpp);
            apexpages.currentpage().getparameters().put('id' , tempOpp.id);
            SHMMN_OpportunityUpdate   vfc = new SHMMN_OpportunityUpdate(controller);
            //Assert to check vf page is shown to user
            system.assert(vfc.showPage == true);
            Test.stopTest();
         }
 }
/*******************************************************************
    Purpose: method to check negative scenario of updating shared opportunity by user below in hierarchy of user who shared opportunity  
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/  
 static testmethod void OpportunityUpdateBelowSharedByUser_Test()
 {
         Opportunity tempOpp= [select id,name,Shared_with_SHP__c from Opportunity where name='test opportunity' ];
         User tempUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
         //Assert to check opportunity is fetched successfully
         System.assert(tempOpp!=null);
         Id profileId = [SELECT Id FROM Profile WHERE Name='SHMMN Sales'].Id;
         Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN ERS Member'].Id;
         User SHMMNUser = new User(Alias = 'standt2', Email='SHMMNuser2@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuserERS@testmethod.com');
         insert SHMMNUser ;
         // assert to check user is created successfully
         system.assert(SHMMNUser.id!=null);
         Test.startTest();
         System.runAs (tempUser ) 
         {
            tempOpp.Shared_with_SHP__c = true;
            tempOpp.Opportunity_Shared_By__c = tempUser.id;
            update tempOpp;
          }
         System.runAs (SHMMNUser ) 
         {
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempOpp);
            apexpages.currentpage().getparameters().put('id' , tempOpp.id);
            SHMMN_OpportunityUpdate   vfc = new SHMMN_OpportunityUpdate(controller);
            //Assert to check page is shown to user
            system.assert(vfc.showPage == false);
         }
         Test.stopTest();
 }
/*******************************************************************
    Purpose: method to check negative scenario of updating shared opportunity by SHP Sales User  
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/  
static testmethod void OpportunityUpdateSHPUser_Test()
 {
         Opportunity tempOpp= [select id,name,Shared_with_SHP__c from Opportunity where name='test opportunity' ];
         User tempUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
         //Assert to check opportunity is fetched successfully
         System.assert(tempOpp!=null);
         Id profileId = [SELECT Id FROM Profile WHERE Name='SHP Sales'].Id;
         Id uRole =  [SELECT Id FROM UserRole WHERE Name='Sales Coordinator'].Id;
         User SHPUser = new User(Alias = 'standt3', Email='SHPuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHP@testmethod.com');
         insert SHPUser ;
         // assert to check user is created successfully
         system.assert(SHPUser.id!=null);
         Test.startTest();
         System.runAs (tempUser) 
         {
            tempOpp.Shared_with_SHP__c = false;
            tempOpp.Opportunity_Shared_By__c = tempUser.id;
            tempOpp.OwnerId= SHPUser.id;
            update tempOpp;
         }
         System.runAs (SHPUser) 
         {
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempOpp);
            apexpages.currentpage().getparameters().put('id' , tempOpp.id);
            SHMMN_OpportunityUpdate   vfc = new SHMMN_OpportunityUpdate(controller);
            //Assert to check page is not shown to SHP user
            system.assert(vfc.showPage == false);
         }
          Test.stopTest();
 }
 /*******************************************************************
    Purpose: method to check negative scenario of updating shared opportunity with Service Line/Product Promotion as SHP and Classification as blank  
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/ 
 static testmethod void OpportunitySave_Test()
 {
         Opportunity tempOpp= [select id,name,Shared_with_SHP__c from Opportunity where name='test opportunity' ];
         User tempUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
         //Assert to check opportunity is fetched successfully
         System.assert(tempOpp!=null);       
         System.runAs (tempUser ) 
         {
            tempOpp.Shared_with_SHP__c = true;
            tempOpp.Opportunity_Shared_By__c = tempUser.id;
            update tempOpp;
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempOpp);
            apexpages.currentpage().getparameters().put('id' , tempOpp.id);
            SHMMN_OpportunityUpdate   vfc = new SHMMN_OpportunityUpdate(controller);
            Test.startTest();
            vfc.opp= tempOpp;
            vfc.opp.Service_Line_Product_Promotion__c =System.Label.CL_77_SM_SHP;
            vfc.Save();
            SHMMN_OpportunityUpdate   vfc1 = new SHMMN_OpportunityUpdate(controller);
            vfc1.opp= tempOpp;
            vfc1.opp.Service_Line_Product_Promotion__c ='Bariatric';
            vfc1.Save();
            Test.stopTest();
         }
 }
 /*******************************************************************
    Purpose: method to check scenario of creating Signed Agreement Employer Agreement on updating opportunity stage to Closed Won  
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************-/ 
 static testmethod void createSignedAgreement_Test()
 {
        Account ac = [Select name, id from Account where name ='test account'];
        Opportunity tempOpp= [select id,name,Shared_with_SHP__c from Opportunity where name='test opportunity' ];
        List<Opportunity> tempOppList = [select id,name,Shared_with_SHP__c,AccountId,Full_Time_Employees__c,CloseDate,Plan_Effective_Date__c,Plan_end_date__c,OwnerId,Service_Line_Product_Promotion__c from Opportunity where name='test opportunity' ];
        User tempUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
        //Assert to check opportunity is fetched successfully
        System.assert(tempOpp!=null);
           
        System.runAs (tempUser ) 
        {
          Test.startTest();  
          SHMMN_OpportunityUpdate.createSignedAgreement(tempOppList);   
          Test.stopTest();
        }
        List<Employer_Activity__c> empAct = [Select id, name from Employer_Activity__c where Account_Name__c =: ac.id and RecordType.Name='Signed Agreement'];
        //Assert to check employer activity is created
        System.assert(empAct!=null);
     } */
     
/*******************************************************************
    Purpose: method to check negative scenario of updating shared opportunity Opportunity name as null  
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
   ********************************************************************/ 
 static testmethod void saveNegative_Test()
 {
         Opportunity tempOpp= [select id,name,Shared_with_SHP__c,CloseDate from Opportunity where name='test opportunity' ];
         User tempUser = [select id from User where UserName='SHMMNuser@testmethod.com'] ;
         //Assert to check opportunity is fetched successfully
         System.assert(tempOpp!=null);       
         System.runAs (tempUser ) 
         {
            tempOpp.Shared_with_SHP__c = true;
            tempOpp.Opportunity_Shared_By__c = tempUser.id;
            update tempOpp;
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tempOpp);
            apexpages.currentpage().getparameters().put('id' , tempOpp.id);
            SHMMN_OpportunityUpdate   vfc1 = new SHMMN_OpportunityUpdate(controller);
            Test.startTest();
            vfc1.opp= tempOpp;
          //  vfc1.opp.Service_Line_Product_Promotion__c ='Bariatric';
            vfc1.opp.CloseDate = null;
            vfc1.Save();
            Test.stopTest();
            //Assert to check opportunity is not updated
            System.assertEquals(tempOpp.CloseDate, null);
         }
 }
}