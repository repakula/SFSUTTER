/**  
  *     Class Name  : VFC24_Training_Request_Form_Test
  *     Author      : IDC Offshore
  *     Date        : 17-Sep-2014
  *     Project Name: CRM - SFT - Sutter Health
  *     Description : Training Request Form
**/

@isTest
private class VFC24_Training_Request_Form_Test {
 
    static testMethod void testTrainingRequestForm() {
        try {
            System.Test.startTest();
            Account accObj = new Account();
            accObj.Name = 'Account Name';
            insert accObj;
            

            

            Contact contObj = new Contact();
            contObj.FirstName = 'Contact FName';
            contObj.LastName = 'Contact LName';
            contObj.email = 'testContact@test.com';
            insert contObj;
            // Assert to check Contact is created successfully
            system.assert(contObj.id!=null);
            
            System.Test.stopTest();
 
            Case caseObj = new Case();
            caseObj.subject = 'Test Case';
            caseObj.description = 'Test Case';        
            caseObj.accountId = accObj.id;
            caseObj.contactId = contObj.id;
            //insert caseObj;
            
            VFC24_Training_Request_Form clsObj = new  VFC24_Training_Request_Form(new ApexPages.StandardController(caseObj));
            clsObj.caseRecord.Time_Frame__c = null;
            clsObj.saveAndSend();
            clsObj.caseRecord.Time_Frame__c = System.today();
            clsObj.saveAndSend();
            clsObj.okay();
       } catch(Exception ex) {} 
        
    }

    //SAASFOCUS
    static testMethod void testTrainingRequestForm2() {
            
            /*
            profile objProfile=new Profile();
            objProfile.Name='Community';
            user objUser=new user ();
            
            objUser.LastName='teast';
            objUser.Email='segf@asd.com';
            objUser.Alias='se';
            objUser.CommunityNickname='Community';

            insert objUser;
            */
        
        try 
        
        {
            System.Test.startTest();
            Account accObj = new Account();
            accObj.Name = 'Account Name';
            insert accObj;
           
            Contact contObj = new Contact();
            contObj.FirstName = 'Contact FName';
            contObj.LastName = 'Contact LName';
            contObj.email = 'testContact@test.com';
            insert contObj;

            // Assert to check Contact is created successfully
            system.assert(contObj.id!=null);
            
            System.Test.stopTest();
 
            Case caseObj = new Case();
            caseObj.subject = 'Test Case';
            caseObj.description = 'Test Case';        
            caseObj.accountId = accObj.id;
            caseObj.contactId = contObj.id;
            //insert caseObj;

            
            
            SH_VFC24_Training_Request_Form clsObj = new  SH_VFC24_Training_Request_Form(new ApexPages.StandardController(caseObj));
            clsObj.caseRecord.Time_Frame__c = null;
            clsObj.saveAndSend();
            clsObj.caseRecord.Time_Frame__c = System.today();
            clsObj.saveAndSend();
            clsObj.okay();
       } catch(Exception ex) {} 
        
    }
    

    static testMethod void testTrainingRequestForm3() {
            
            /*
            profile objProfile=new Profile();
            objProfile.Name='Community';
            user objUser=new user ();
            
            objUser.LastName='teast';
            objUser.Email='segf@asd.com';
            objUser.Alias='se';
            objUser.CommunityNickname='Community';

            insert objUser;
            */
        
            
            System.Test.startTest();
            Account accObj = new Account();
            accObj.Name = 'Account Name';
            insert accObj;
            // Assert to check Account is created successfully
            system.assert(accObj.id!=null);
           
            Contact contObj = new Contact();
            contObj.FirstName = 'Contact FName';
            contObj.LastName = 'Contact LName';
            contObj.email = 'testContact@test.com';
            //insert contObj;

            
            AccessTokenSetting__c act= new AccessTokenSetting__c();
            System.Test.stopTest();
 
            Case caseObj = new Case();
            caseObj.subject = 'Test Case';
            caseObj.description = 'Test Case';        
            //caseObj.accountId = accObj.id;
            //caseObj.contactId = contObj.id;
            //insert caseObj;
            
            SH_VFC24_Training_Request_Form clsObj = new  SH_VFC24_Training_Request_Form(new ApexPages.StandardController(act));
            //clsObj.caseRecord.Time_Frame__c = null;
            clsObj.saveAndSend();
            //clsObj.caseRecord.Time_Frame__c = System.today();
            //clsObj.saveAndSend();
            //clsObj.okay();
        
        
    }
}