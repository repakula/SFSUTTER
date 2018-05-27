/**  
*     Class Name: ManageCases_Life_Cycle_Test
*     Author: OffShore Team
*     Date: 14-October-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description: This is the test class for Case Life Cycle functionality : REQ_3048_Release_6.2
*     
*    History
*    --------
*
**/
@isTest
private class ManageCases_Life_Cycle_Test {

    private static integer noOfCases = 1;
    
    /**
    *   @Description: Method to insert a user
    **/
    public static User createUser() {
    
    String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.id;
    
        User usr = new User();
        usr.LastName = 'Last Name';
        usr.Username = 'test@user.com.usr';
        usr.Email = 'test@user.com';
        usr.Alias = 'tuser';
        usr.CommunityNickname = 'testnickname';
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.LocaleSidKey = 'en_US';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.profileid = usrProfileName;
        usr.isActive = true;
        
        insert usr;
        //Assert to check user is created successfully
        system.assert(usr.id!=null);
        return usr;  
    }
    
    /**
    *   @Description: Method to insert bulk interatio Logs
    **/
    static List<Case> insertBulkIL() {
        
        List<Case> listCase = new List<Case>();
        
        for(integer i=0; i<noOfCases; i++)
        {
            Case caseRec = new Case();
            caseRec.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
            caseRec.OwnerId = UserInfo.getUserId();
            caseRec.Origin = 'Phone';
            caseRec.Priority = 'Medium';
            caseRec.Urgency__c = 'Medium';
            caseRec.Status = 'Open';
            caseRec.Function__c = 'Finance';
            caseRec.Sub_Function__c = 'Accounts Payable';
            caseRec.Customer_Intent__c = 'ACH Setup';
            caseRec.Subject = 'Test Subject';
            caseRec.Description = 'Test Description';
            listCase.add(caseRec);
        }
        
        insert listCase;
        //Assert to check Case is created successfully
        system.assert(listCase.size()>0);
        return listCase;
    }
    
    /**
    *   @Description: Method to insert Single Interaction log which will the parent of Service Requests
    **/
    static Case insertSingleIL() {
        
            Case caseRec = new Case();
            caseRec.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
            caseRec.OwnerId = UserInfo.getUserId();
            caseRec.Origin = 'Phone';
            caseRec.Priority = 'Medium';
            caseRec.Urgency__c = 'Medium';
            caseRec.Status = 'Open';
            caseRec.Function__c = 'Finance';
            caseRec.Sub_Function__c = 'Accounts Payable';
            caseRec.Customer_Intent__c = 'ACH Setup';
            caseRec.Subject = 'Test Subject';
            caseRec.Description = 'Test Description';
            insert caseRec;
            //Assert to check Case is created successfully
          system.assert(caseRec.id!=null);
            return caseRec;
            
    }
    
    /**
    *   @Description: Method to insert Bulk Service Requests
    **/
    static List<Case> insertBulkSR() {
        
        Case parentCase = insertSingleIL();
        
        List<Case> listCase = new List<Case>();
        List<Case> insertCaseList = new List<Case>();
        
        for(integer i=0; i<noOfCases; i++)
        {
            Case caseRec = new Case();
            caseRec.ParentId = parentCase.id;
            caseRec.OwnerId = UserInfo.getUserId();
            caseRec.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Accounting').RecordTypeId;
            caseRec.Origin = 'Phone';
            caseRec.Priority = 'Medium';
            caseRec.Urgency__c = 'Medium';
            caseRec.Status = 'New';
            caseRec.Function__c = 'Finance';
            caseRec.Sub_Function__c = 'Accounts Payable';
            caseRec.Team__c = '[Tier 1] AP / Purchasing / Supply Chain';
            caseRec.Customer_Intent__c = 'ACH Setup';
            caseRec.Subject = 'Test Subject';
            caseRec.Description = 'Test Description';
            listCase.add(caseRec);
        }
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = false;
        
        for(Case caseRecord : listCase)
        {
            caseRecord.setOptions(dmo);
            insertCaseList.add(caseRecord);
        }
        
        insert insertCaseList;
        //Assert to check Case is created successfully
        system.assert(insertCaseList.size()>0);
        return insertCaseList;
    }
    
    /**
    *   @Description: Test method to update Interaction Log Status
    **/
    static testmethod void updateILStatus(){
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];  
        //Assert to check User is fetched successfully
        system.assert(thisUser.id!=null);
        
        System.runAs(thisUser)
        {
            List<Case> caseList = insertBulkIL();
            
            List<Case> updateCaseList = new List<Case>();
            
            for(Case caseloop : caseList)
            {
                caseloop.Status = 'Closed';
                updateCaseList.add(caseloop);
            }
            
            Test.startTest();
            update updateCaseList;
            Test.stopTest();
        }
    }
    
    /**
    *   @Description: Test method to update Service Request Status
    **/
    static testmethod void updateSRStatus() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];  
        //Assert to check User is fetched successfully
        system.assert(thisUser.id!=null);
        System.runAs(thisUser) 
        {
            List<Case> caseList = insertBulkSR();
            List<Case> updateCaseList = new List<Case>();
            
            for(Case caseloop : caseList)
            {
                caseloop.Status = 'In Progress';
                updateCaseList.add(caseloop);
            }
            
            Test.startTest();
            update updateCaseList;
            Test.stopTest();
        }
    }
    
    /**
    *   @Description: Test method to update Service Request Status and Owner
    **/
    static testmethod void updateSRStatusAndOwner() {
        
        User usr = createUser();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        //Assert to check User is fetched successfully
        system.assert(thisUser.id!=null);
        
        System.runAs(thisUser)
        {
            List<Case> insertCaseList = insertBulkSR();
            Id queueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = '[Tier 2] Finance Accounts Payable'].Id;
            //Assert to check Queue is fetched successfully
            system.assert(queueId!=null);
            
            List<Case> updateCaseList = new List<Case>();
            
            for(Case caseloop : insertCaseList)
            {
                caseloop.Status = 'In Progress';
                caseloop.OwnerId = queueId;
                updateCaseList.add(caseloop);
            }
            
            Test.startTest();
            update updateCaseList;
            Test.stopTest();
        }
    }
}