/**  
*     Class Name  : VFC16_CV_Portal_Test
*     Author      : IDC Offshore
*     Date        : 31-July-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : Test Class for VFC16_CV_Portal Class. This class tests for different scenarios that are handled in the code
**/
@isTest
private class VFC16_CV_Portal_Test {

    static VFC16_CV_Portal cv_ext;
    static SH_VFC16_CV_Portal SH_cv_ext;
    static Case caseRecord;
    static PageReference pref;
    static User testUser;
    
    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description init method that creates creates dummy Account, Contact, User and Case to be used in test methods
    * @param 
    * @return void
    */
    private static void init() {
        
        Account acc = new Account(name = 'Test Account');
        insert acc;
        Contact cont = new Contact(AccountId = acc.id, LastName = 'Contact Name');
        insert cont;
        
        Profile p = [select id from profile where Name =: AP01_TestDataTokens.COMMUNITY_PORTAL_MANAGER_PROFILE];

       // testUser = new User(alias = 'u1', email='u1@testorg.com',
       //emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
       // localesidkey='en_US', profileid = p.Id, country='United States',
       // timezonesidkey='America/Los_Angeles', username='u1@testorg.com', ContactId = cont.id);

       // insert testUser;
       testUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        caseRecord = new Case(Status = 'New');
    }
    
    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description Test method to test address change recordType where Provider Group id is not Group and validation is not fired
    * @param 
    * @return void
    */
    static testMethod void testMethod_Address_Change() {
        
        init();
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Address_Change);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            cv_ext = new VFC16_CV_Portal(con);
            
            cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }

    //saasfocus
    static testMethod void testMethod_Address_Change2() {
        
        init();
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Address_Change);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            SH_cv_ext = new SH_VFC16_CV_Portal(con);
            
            SH_cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(SH_cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    
    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description Test method to test address change recordType where the Group id validation is fired
    * @param 
    * @return void
    */
    static testMethod void testMethod_Address_Change_ProviderGroup() {
        
        Account acc = new Account(name = 'Test Account');
        insert acc;
        Contact cont = new Contact(AccountId = acc.id, LastName = 'Contact Name');
        insert cont;
        
        Profile p = [select id from profile where Name =: AP01_TestDataTokens.COMMUNITY_PORTAL_MANAGER_PROFILE];

       // testUser = new User(alias = 'u1', email='u1@testorg.com',
       // emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
       // localesidkey='en_US', profileid = p.Id, country='United States',
       // timezonesidkey='America/Los_Angeles', username='u1@testorg.com', ContactId = cont.id);

       // insert testUser;
       testUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    
       
        caseRecord = new Case(Status = 'New', Individual_Provider_or_Group_of_Provider__c = 'Group');
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Address_Change);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            cv_ext = new VFC16_CV_Portal(con);
            
            cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(cv_ext.Save()==null);
            Test.stopTest();
        }
    }
    //saasfocus
    static testMethod void testMethod_Address_Change_ProviderGroup2() {
        
        Account acc = new Account(name = 'Test Account');
        insert acc;
        Contact cont = new Contact(AccountId = acc.id, LastName = 'Contact Name');
        insert cont;
        
        Profile p = [select id from profile where Name =: AP01_TestDataTokens.COMMUNITY_PORTAL_MANAGER_PROFILE];

       // testUser = new User(alias = 'u1', email='u1@testorg.com',
       // emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
       // localesidkey='en_US', profileid = p.Id, country='United States',
       // timezonesidkey='America/Los_Angeles', username='u1@testorg.com', ContactId = cont.id);

       // insert testUser;
       testUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    
       
        caseRecord = new Case(Status = 'New', Individual_Provider_or_Group_of_Provider__c = 'Group');
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Address_Change);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            SH_cv_ext = new SH_VFC16_CV_Portal(con);
            
            SH_cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(SH_cv_ext.Save()==null);
            Test.stopTest();
        }
    }
    
    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description Test method to test address change recordType where Provider Group id is not Group and validation is not fired
    * @param 
    * @return void
    */
    static testMethod void testMethod_CV_Application_Request() {
        
        init();
        
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Application_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            cv_ext = new VFC16_CV_Portal(con);
            
            cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    //saasfocus
    static testMethod void testMethod_CV_Application_Request2() {
        
        init();
        
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Application_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            SH_cv_ext = new SH_VFC16_CV_Portal(con);
            
            SH_cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(SH_cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    
    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description Test method to test data change request recordType
    * @param 
    * @return void
    */
    static testMethod void testMethod_CV_Data_Change_Request() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Data_Change_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            cv_ext = new VFC16_CV_Portal(con);
            
            cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    //saasfocus
    static testMethod void testMethod_CV_Data_Change_Request2() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Data_Change_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            SH_cv_ext = new SH_VFC16_CV_Portal(con);
            
            SH_cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(SH_cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description Test method to test for recordType CV_Expirables_Request
    * @param 
    * @return void
    */
    static testMethod void testMethod_CV_Expirables_Request() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Expirables_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            cv_ext = new VFC16_CV_Portal(con);
            
            cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }

    //saasfocus
    static testMethod void testMethod_CV_Expirables_Request2() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Expirables_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            SH_cv_ext = new SH_VFC16_CV_Portal(con);
            
            SH_cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(SH_cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description Test method to test for recordType CV_Other_Request
    * @param 
    * @return void
    */
    static testMethod void testMethod_CV_Other_Request() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Other_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            cv_ext = new VFC16_CV_Portal(con);
            
            cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    
    //saasfocus
    static testMethod void testMethod_CV_Other_Request2() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Other_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            SH_cv_ext = new SH_VFC16_CV_Portal(con);
            
            SH_cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(SH_cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description Test method to test for recordType CV_Reapplication_Request
    * @param 
    * @return void
    */
    static testMethod void testMethod_CV_Reapplication_Request() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Reapplication_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            cv_ext = new VFC16_CV_Portal(con);
            
            cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    
    //saasfocus
    static testMethod void testMethod_CV_Reapplication_Request2() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Reapplication_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            SH_cv_ext = new SH_VFC16_CV_Portal(con);
            
            SH_cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(SH_cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description Test method to test for recordType CV_Report_Request
    * @param 
    * @return void
    */
    static testMethod void testMethod_CV_Report_Request() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Report_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            cv_ext = new VFC16_CV_Portal(con);
            
            cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(cv_ext.Save()==null);
            
            
            Test.stopTest();
        }
    }
    
    //saasfocus
    static testMethod void testMethod_CV_Report_Request2() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Report_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            SH_cv_ext = new SH_VFC16_CV_Portal(con);
            
            SH_cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(SH_cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description Test method to test for recordType CV_Rush_Application_Request
    * @param 
    * @return void
    */
    static testMethod void testMethod_CV_Rush_Application_Request() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Rush_Application_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            cv_ext = new VFC16_CV_Portal(con);
            
            cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    //SAASFOCUS
    static testMethod void testMethod_CV_Rush_Application_Request2() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Rush_Application_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            SH_cv_ext = new SH_VFC16_CV_Portal(con);
            
            SH_cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(SH_cv_ext.Save()==null);
            
            Test.stopTest();
        }
    }
    
    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description Test method to test for recordType CV_Temporary_Privilege_Request
    * @param 
    * @return void
    */
    static testMethod void testMethod_CV_Temporary_Privilege_Request() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Temporary_Privilege_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            cv_ext = new VFC16_CV_Portal(con);
            
            cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(cv_ext.Save()==null);
            
            Test.stopTest();
        }


    }
    //SAASFOCUS
    static testMethod void testMethod_CV_Temporary_Privilege_Request2() {
        
        init();
            
        System.runAs(testUser)
        {
            Test.startTest();
            
            PageReference page = new PageReference(AP01_TestDataTokens.CV_Portal_Temporary_Privilege_Request);
            Test.setCurrentPage(page);
            
            ApexPages.StandardController con = new ApexPages.StandardController(caseRecord);
            SH_cv_ext = new SH_VFC16_CV_Portal(con);
            
            SH_cv_ext.Save();
            
            //Using system.assert to verify the value being returned from the method
            system.assert(SH_cv_ext.Save()==null);
            
            Test.stopTest();
        }


    }
}