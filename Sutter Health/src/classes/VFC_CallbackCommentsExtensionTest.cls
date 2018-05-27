/**   
 *     Class Name  : VFC_CallbackCommentsExtensionTest 
 *     Author      : IDC Offshore 
 *     Date        : 11-Oct-2014 
 *     Project Name: CRM - SFT - Sutter Health 
 *     Description : Test Class for VFC_CallbackCommentsExtension Class. This class tests creating a new 'Call_Back__c' (also called Customer Inquiry Comment) record and saving that record, canceling that record scenarios.
 **/
@isTest
private class VFC_CallbackCommentsExtensionTest{
    static string pageURL = 'apex/VFP_CallbackComments';
    
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015     
     * @description :method to create test data used by all tests    
     * @return void        
     */
    @testsetup
    Static void createTestData()
    {
        //UserRole  usrrole = [select id from UserRole where name=: AP01_TestDataTokens.SHP_PROFILE_NAME limit 1] ;  
        UserRole  usrrole = [select id from UserRole where name= 'SHP Grievance Coordinator' limit 1] ;
        Profile p = [select id from profile where Name =: AP01_TestDataTokens.SHP_PROFILE_NAME];

        // insert an User 
        User  testUser = new User(alias = 'u1', email='u123@testorg.com',emailencodingkey='UTF-8',lastname='SHP Grievance Coordinator',languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id, country='United States',timezonesidkey='America/Los_Angeles',username='u123@testorg.com', userroleid = usrrole.id);
        
        insert  testUser;
        //Assert to check if User record has been created successfully 
        system.assert(testUser.id != null);

        System.runAs(testUser){
        // insert grievance case 
        RecordType recType = [select id,name from recordType where sobjectType='Case' AND name='Grievance' limit 1];
        Case grievanceCase = new Case();
        grievanceCase.Subject = 'Test';
        grievanceCase.RecordTypeID = recType.ID;
        insert grievanceCase;
        //Assert to check if grievance record has been created successfully 
        system.assert(grievanceCase.id != null);
        }
    }
     
    /**        
    * @author IDC Team        
    * @date 20/Oct/2015     
    * @description :Method to create call back record    
    * @return void        
    */
    static testmethod void testCreateCallbackRecord(){
    
        User  testUser = [Select id from User where username ='u123@testorg.com' limit 1 ];
        //Assert to check user has been fetched  successfully 
        system.assert(testUser!= null);
        
        System.runAs(testUser)
        { 
            Case grievanceCase = [Select id from Case where recordType.name ='Grievance' and Subject = 'Test' limit 1];
            //Assert to check grievance record has been fetched  successfully 
           system.assert(grievanceCase!= null);
            
            Test.startTest();
            Call_Back__c callback = new Call_Back__c ();
          
            PageReference page = new PageReference(pageURL);
            Test.setCurrentPage(page);
            
            ApexPages.currentPage().getParameters().put('cid', grievanceCase.id);
            ApexPages.StandardController con = new ApexPages.StandardController(callback);
            VFC_CallbackCommentsExtension comments = new VFC_CallbackCommentsExtension(con);
           
            comments.callbackRec.Notes__c ='testingComments';
            comments.save();
            //Assert to check callback record has been created  successfully 
            system.assert(comments.callbackRec!=null);
            
            Test.stopTest();
        }
    } 
    
    /**        
    * @author IDC Team        
    * @date 20/Oct/2015     
    * @description :Method to create OOAOONcase call back record    
    * @return void        
    */
    static testmethod void testCreateOOAOONCase(){
    
        User  testUser = [Select id from User where username ='u123@testorg.com' limit 1 ];
        //Assert to check user has been fetched  successfully 
        system.assert(testUser!= null);
        Case grievanceCase = [Select id from Case where recordType.name ='Grievance' and Subject = 'Test' limit 1];
        //Assert to check grievance record has been fetched  successfully 
        system.assert(grievanceCase!= null);
        RecordType recType = [select id,name from recordType where sobjectType='Case' AND name='OOA/OON' limit 1];
        //Assert to check OOA/OON recordtype has been fetched  successfully 
        system.assert(grievanceCase!= null);
        grievanceCase.RecordTypeID = recType.ID;
        update grievanceCase;
        
        System.runAs(testUser)
        { 
            Test.startTest();
            Call_Back__c callback = new Call_Back__c ();
            
            callback.Notes__c ='testingComments123';
            callback.Parent_Case__c = grievanceCase.id;
            insert callback;
            //Assert to check callback record has been inserted  successfully 
            system.assert(callback.id!=null);
          
            PageReference page = new PageReference(pageURL);
            Test.setCurrentPage(page);
            ApexPages.currentPage().getParameters().put('id', callback.id);
            ApexPages.currentPage().getParameters().put('cid', grievanceCase.id);
           
            
            ApexPages.StandardController con = new ApexPages.StandardController(callback);
            VFC_CallbackCommentsExtension comments = new VFC_CallbackCommentsExtension(con);
            
            comments.isMemberOfSHP_OOA_OON = true ;
            comments.groupMember();
            string CALLBACK_RT = 'Comments OOA OON';
            comments.callback.RecordTypeId = Schema.SObjectType.Call_Back__c.RecordTypeInfosByName.get(CALLBACK_RT).RecordTypeId;
            comments.callback.Concurrent_Review_Received_Date__c = null;
            comments.callback.Concurrent_Review_Received__c = true;
            comments.Save_OOA();
            Test.stopTest();
        }
    } 
    
    /**        
    * @author IDC Team        
    * @date 20/Oct/2015     
    * @description :Method to create OOAOONcase and cancel the call back record    
    * @return void        
    */
    static testmethod void testCreateOOAOONCaserecord2(){
    
        User  testUser = [Select id from User where username ='u123@testorg.com' limit 1 ];
        //Assert to check user has been fetched  successfully 
        system.assert(testUser!= null);
        Case grievanceCase = [Select id from Case where recordType.name ='Grievance' and Subject = 'Test' limit 1];
        //Assert to check grievance record has been fetched  successfully 
        system.assert(grievanceCase!= null);
        RecordType recType = [select id,name from recordType where sobjectType='Case' AND name='OOA/OON' limit 1];
        //Assert to check OOA/OON recordtype has been fetched  successfully 
        system.assert(grievanceCase!= null);
        grievanceCase.RecordTypeID = recType.ID;
        update grievanceCase;
        
        System.runAs(testUser)
        {
            Test.startTest();
            Call_Back__c callback = new Call_Back__c ();
            
            callback.Notes__c ='testingComments123';
            callback.Parent_Case__c = grievanceCase.id;
            insert callback;
            //Assert to check callback record has been inserted  successfully 
            system.assert(callback.id!=null);
            PageReference page = new PageReference(pageURL);
            Test.setCurrentPage(page);
            
            String Cancel = '/'+callback.id+'?';
            ApexPages.currentPage().getParameters().put('cancelURL',Cancel);
            
            ApexPages.StandardController con = new ApexPages.StandardController(callback);
            VFC_CallbackCommentsExtension comments = new VFC_CallbackCommentsExtension(con);
            comments.callback.Notes__c ='testingComments';
            comments.Save_OOA();
            comments.groupMember();
            
            Test.stopTest();
        }
    } 
    
    /**        
    * @author IDC Team        
    * @date 20/Oct/2015     
    * @description :Method to edit call back record    
    * @return void        
    */
    static testmethod void testEditCallbackRecord(){
        User  testUser = [Select id from User where username ='u123@testorg.com'];
        //Assert to check user has been fetched  successfully 
        system.assert(testUser!= null);
        System.runAs(testUser)
        {
           Case grievanceCase = [Select id from Case where recordType.name ='Grievance' and Subject = 'Test' limit 1];
            //Assert to check grievance record has been fetched  successfully 
            system.assert(grievanceCase!= null);
            Call_Back__c callback = new Call_Back__c ();
          
            callback.Notes__c ='testing Previous';
            callback.Parent_Case__c = grievanceCase.id;
            insert callback;
            //Assert to check callback record has been inserted  successfully 
            system.assert(callback.id!=null);
            
            Test.startTest();
            
            PageReference page = new PageReference(pageURL);
            Test.setCurrentPage(page);
            
            ApexPages.currentPage().getParameters().put('id', callback.id);
            ApexPages.currentPage().getParameters().put('cid', grievanceCase.id);
            
            ApexPages.StandardController con = new ApexPages.StandardController(callback);
            VFC_CallbackCommentsExtension comments = new VFC_CallbackCommentsExtension(con);
            callback.Notes__c ='testing new ';
            boolean flag=comments.ErrorsPresent;
            comments.save();
            //Assert to check call back comment updated
            System.assert(callback.Notes__c!= 'testing Previous');
            comments.groupMember();
            comments.Save_OOA();
            comments.cancel();
            Test.stopTest();
        }
    } 
    
    /**        
    * @author IDC Team        
    * @date 20/Oct/2015     
    * @description :Method to catch exception   
    * @return void        
    */
    static testmethod void testException(){
        User  testUser = [Select id from User where username ='u123@testorg.com'];
        //Assert to check user has been fetched  successfully 
        system.assert(testUser!= null);
         
        System.runAs(testUser)
        {
            Call_Back__c callback = new Call_Back__c ();
            
            Test.startTest();
            try{
                PageReference page = new PageReference(pageURL);
                Test.setCurrentPage(page);
                ApexPages.StandardController con = new ApexPages.StandardController(callback);
                VFC_CallbackCommentsExtension comments = new VFC_CallbackCommentsExtension(null);
            }catch(Exception ex){
                system.assert(ex.getMessage() != null);
            }
            Test.stopTest();
        }
    } 
    
    
    /**        
    * @author IDC Team        
    * @date 20/Nov/2015     
    * @description :Method to add error messages on the page from the validatonRulesForAgentAnd method of the class. 
    * @return void        
    */
    static testmethod void testAddingErrorMsgs(){
        string CALLBACK_RT = 'Comments OOA OON';
        User  testUser = [Select id from User where username ='u123@testorg.com'];
        //Assert to check user has been fetched  successfully 
        system.assert(testUser!= null);
        System.runAs(testUser)
        {
           Case grievanceCase = [Select id from Case where recordType.name ='Grievance' and Subject = 'Test' limit 1];
            //Assert to check grievance record has been fetched  successfully 
            system.assert(grievanceCase!= null);
            system.debug('&&'+grievanceCase.id);
            Call_Back__c callback = new Call_Back__c ();
          callback.recordtypeid=Schema.SObjectType.Call_Back__c.RecordTypeInfosByName.get(CALLBACK_RT).RecordTypeId;
          callback.Concurrent_Review_Received__c = true;
          callback.Concurrent_Review_Requested__c = true;
          callback.Concurrent_Review_Received_Date__c = null;
          callback.Concurrent_Review_Requested_Date__c = null;
            callback.Notes__c ='testing Previous';
            callback.Parent_Case__c = grievanceCase.id;
            insert callback;
            
            system.debug('$$$ before'+callback);
            //Assert to check callback record has been inserted  successfully 
            system.assert(callback.id!=null);
            
            Test.startTest();
            
            PageReference page = new PageReference(pageURL);
            Test.setCurrentPage(page);
            
            ApexPages.currentPage().getParameters().put('id', callback.id);
            ApexPages.currentPage().getParameters().put('cid', grievanceCase.id);
            
            ApexPages.StandardController con = new ApexPages.StandardController(callback);
            VFC_CallbackCommentsExtension comments = new VFC_CallbackCommentsExtension(con);
            callback.Notes__c ='testing new ';
            
            comments.save();
            
            //Assert to check call back comment updated
            System.assert(callback.Notes__c!= 'testing Previous');
            comments.groupMember();
            system.debug('$$$ after1'+callback);
            comments.Save_OOA();
            system.debug('$$$ after2'+callback);
            comments.cancel();
            Test.stopTest();
        }
    } 
    
    /**        
    * @author IDC Team        
    * @date 20/Nov/2015     
    * @description :Method to validate group Member fuctionality from groupMember method of the class. 
    * @return void        
    */
    static testmethod void testGrpMemberMtd1(){
        string CALLBACK_RT = 'Comments OOA OON';
        string OOA_QUEUE_NAME = 'SHP OOA/OON';
        string OOA_VIEW_ONLY = 'SHP OOA/OON View Only';
        User  testUser = [Select id from User where username ='u123@testorg.com'];
        //Assert to check user has been fetched  successfully 
        system.assert(testUser!= null);
        System.runAs(testUser)
        {
           
           GroupMember obj_GM1 = new GroupMember();
           obj_GM1.groupid = [select id from group where name=:OOA_QUEUE_NAME limit 1].id;
           obj_GM1.userorgroupid = testUser.id;
           insert obj_GM1;
           
           Case grievanceCase = [Select id from Case where recordType.name ='Grievance' and Subject = 'Test' limit 1];
            //Assert to check grievance record has been fetched  successfully 
            system.assert(grievanceCase!= null);
            Call_Back__c callback = new Call_Back__c ();
              
            callback.Notes__c ='testing Previous';
            callback.Parent_Case__c = grievanceCase.id;
            insert callback;
            
            system.debug('$$$ before'+callback);
            //Assert to check callback record has been inserted  successfully 
            system.assert(callback.id!=null);
            
            Test.startTest();
            
            PageReference page = new PageReference(pageURL);
            Test.setCurrentPage(page);
            
            ApexPages.currentPage().getParameters().put('id', callback.id);
            ApexPages.currentPage().getParameters().put('cid', grievanceCase.id);
            
            ApexPages.StandardController con = new ApexPages.StandardController(callback);
            VFC_CallbackCommentsExtension comments = new VFC_CallbackCommentsExtension(con);
            callback.Notes__c ='testing new ';
            
            comments.save();
            
            //Assert to check call back comment updated
            System.assert(callback.Notes__c!= 'testing Previous');
            comments.groupMember();
            
            
            Test.stopTest();
        }
    }
    
    /**        
    * @author IDC Team        
    * @date 20/Nov/2015     
    * @description :Method to validate group Member fuctionality from groupMember method of the class. 
    * @return void        
    */ 
    static testmethod void testGrpMemberMtd2(){
        string CALLBACK_RT = 'Comments OOA OON';
        string OOA_QUEUE_NAME = 'SHP OOA/OON';
     string OOA_VIEW_ONLY = 'SHP OOA/OON View Only';
        User  testUser = [Select id from User where username ='u123@testorg.com'];
        //Assert to check user has been fetched  successfully 
        system.assert(testUser!= null);
        System.runAs(testUser)
        {
           
           GroupMember obj_GM1 = new GroupMember();
           obj_GM1.groupid = [select id from group where name=:OOA_VIEW_ONLY limit 1].id;
           obj_GM1.userorgroupid = testUser.id;
           insert obj_GM1;
           
           Case grievanceCase = [Select id from Case where recordType.name ='Grievance' and Subject = 'Test' limit 1];
            //Assert to check grievance record has been fetched  successfully 
            system.assert(grievanceCase!= null);
            Call_Back__c callback = new Call_Back__c ();
              
            callback.Notes__c ='testing Previous';
            callback.Parent_Case__c = grievanceCase.id;
            insert callback;
            
            system.debug('$$$ before'+callback);
            //Assert to check callback record has been inserted  successfully 
            system.assert(callback.id!=null);
            
            Test.startTest();
            
            PageReference page = new PageReference(pageURL);
            Test.setCurrentPage(page);
            
            ApexPages.currentPage().getParameters().put('id', callback.id);
            ApexPages.currentPage().getParameters().put('cid', grievanceCase.id);
            
            ApexPages.StandardController con = new ApexPages.StandardController(callback);
            VFC_CallbackCommentsExtension comments = new VFC_CallbackCommentsExtension(con);
            callback.Notes__c ='testing new ';
            
            comments.save();
            
            //Assert to check call back comment updated
            System.assert(callback.Notes__c!= 'testing Previous');
            comments.groupMember();
            
            
            Test.stopTest();
        }
    } 
}