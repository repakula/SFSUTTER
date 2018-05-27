/*********************************************************************************************  
*     Class Name  : SHMMN_LeadHandlerTest
*     Author      : Priyatham Reddy                                                           
*     Date        : 10-Aug-2016                                                              
*     Project Name: CRM - SFT - Sutter Health                                                        
*     Description : Test class for SHMMN_LeadHandler.                                                         
**********************************************************************************************/

@isTest 
Private class SHMMN_LeadHandlerTest{
    // Creating lead with Status Suspected
    static testmethod void insertLead(){
        
        Id profileId = [SELECT Id FROM Profile WHERE Name='SHMMN Management'].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='SHMMN'].Id;
        // Create SHMMN User
        User SHMMNUser = new User(Alias = 'standt', Email='SHMMNuser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='SHMMNuser@testmethod.com');
        insert SHMMNUser ;
        
        System.RunAs(SHMMNUser){            
             
            Test.StartTest();
            //------------Suspended-------------
            Lead leadSuspected = new Lead();
            leadSuspected.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('SHMMN Lead').getRecordTypeId();
            leadSuspected.LastName = 'Test Lead Suspected';
            leadSuspected.Company = 'Sutter Health';
            leadSuspected.Email = 'test@sutterhealth.org';
            leadSuspected.NumberOfEmployees= 10;
            //leadSuspected.Lead_type__c = 'Employer';
            leadSuspected.Status = 'Suspected';
            insert leadSuspected;
            system.AssertEquals(leadSuspected.OwnerId,leadSuspected.Lead_Assigned_To__c);
            
            leadSuspected.Status = 'Qualified';
            Update leadSuspected;
            system.AssertEquals(leadSuspected.OwnerId,leadSuspected.Lead_Assigned_To__c);
                                   
            Group queueId = [select Id from Group where Name = 'SHMMN Sales Managers Queue' and Type = 'Queue'];
            system.Assert(queueId!=NULL);
            
            leadSuspected.OwnerId = queueId.Id;
            leadSuspected.Skip_Validation__c=true;
            Update leadSuspected;
            System.Assert(String.valueOf(leadSuspected.ownerId).startsWith('00G'));
            
            Test.StopTest();
                        
        }        
    }
    
}