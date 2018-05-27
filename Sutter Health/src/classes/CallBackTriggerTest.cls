/**    
 *     Class Name  : CallBackTriggerTest
 *     Author      : IDC Offshore  
 *     Date        : 11-Oct-2014  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : Test Class for CallBackTrigger trigger. This class tests functionality of create/update/delete actions on 'Call_Back__c' record. 
 **/
@isTest
private class CallBackTriggerTest{
    private static final String GRIEVANCE = 'Grievance';
    private static final String CASEOBJ = 'Case';
    
     /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description: method to create test data used by all tests       
     * @return void        
     */
    @testSetup 
    static void createTestData() {
    
        UserRole  usrrole = [select id from UserRole where name=: AP01_TestDataTokens.SHP_PROFILE_NAME limit 1] ;  
        Profile p = [select id from profile where Name =: AP01_TestDataTokens.SHP_PROFILE_NAME];
        
        // Create SHP user
        User  testUser = new User(alias = 'u1', email='u123@testorg.com',
        emailencodingkey='UTF-8', lastname='Testing123', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='u123@testorg.com', 
        userroleid = usrrole.id);
        insert testUser;
       
        //Assert to check if SHP user record has been created successfully 
        system.assert(testUser.id != null);
        
        System.runAs(testUser){
        
        //Create Grievance Case 
        RecordType recType = [select id,name from recordType where sobjectType='Case' AND name='Grievance' limit 1];
        Case grievanceCase = new Case();
        grievanceCase.Subject = 'Test';
        grievanceCase.RecordTypeID = recType.ID;
        insert grievanceCase;
        
        //Assert to check if Grievance Case  record has been created successfully 
        system.assert(grievanceCase.id != null);
        system.assert(grievanceCase.RecordTypeID == recType.ID);
       }
    
    }
     
    /**             
    * @author IDC Team             
    * @date 08/Aug/2014            
    * @description: To cover Call_Back__c Insert and Update Actions.      
    * @return void             
    */   
    static testmethod void testCallBackInsertUpdateActions(){
        User  testUser = [Select id from user where username='u123@testorg.com' ];
       
        Case grievanceCase = [Select id  from case where Recordtype.Name = 'Grievance' and Subject= 'Test'limit 1];
        System.assert(grievanceCase != null);
        Call_Back__c callbackRec ;
        CaseComment caseComment ;
        String updatedComments = 'Updated Comments';
        
        Test.startTest();
        System.runAs(testUser){
            callbackRec = new Call_Back__c(Parent_Case__c=grievanceCase.id , Notes__c='Testing Comments');   
            insert callbackRec; 
            
            //Assert to check if Call_Back__c  record has been created successfully 
            system.assert(callbackRec.id != null);
            
            List<CaseComment> listOfRecords =new List<CaseComment>();
            listOfRecords = [select id from CaseComment where ParentID =: grievanceCase.id];
            System.assert(listOfRecords != null);
            

            //callbackRec.CaseCommentID__c = caseComment.id;
            callbackRec.Notes__c = updatedComments;
            update callbackRec;
            
            //Assert to check if Call_Back__c  record has been updated successfully 
            system.assert(callbackRec.Notes__c  == updatedComments);
            
            List<CaseComment> updatedListOfRecords =new List<CaseComment>();
            updatedListOfRecords = [select id, CommentBody from CaseComment where ParentID =: grievanceCase.id];
            System.assert(updatedListOfRecords != null);
            System.assert(updatedListOfRecords.get(0).CommentBody == updatedComments);
       }
       
       Test.stopTest();   
    }
    
    /**             
    * @author IDC Team             
    * @date 08/Aug/2014            
    * @description: To cover Call_Back__c Insert and delete Actions.      
    * @return void             
    */   
    static testmethod void testCallBackDeleteAction(){
        User  testUser = [Select id from user where username='u123@testorg.com' ];
       
        Case grievanceCase = [Select id  from case where Recordtype.Name = 'Grievance' and Subject= 'Test'limit 1];
        System.assert(grievanceCase != null);
        Call_Back__c callbackRec ;
        CaseComment caseComment ;
        String updatedComments = 'Updated Comments';
        
        Test.startTest();
        System.runAs(testUser){
            caseComment = new CaseComment(ParentId = grievanceCase.Id, CommentBody= 'Testing Comments');
            insert caseComment; 
           
           //Assert to check if CaseComment  record has been created successfully 
            system.assert(caseComment.id != null);
            
            callbackRec = new Call_Back__c(Parent_Case__c=grievanceCase.id , Notes__c='Testing Comments',CaseCommentID__c = caseComment.id);   
            insert callbackRec; 
            
            //Assert to check if Call_Back__c  record has been created successfully 
            system.assert(callbackRec.id != null);
            
            delete callbackRec; 
            
            //Assert....
            List<CaseComment> deletedListOfRecords = new List<CaseComment>();
            deletedListOfRecords = [select id, CommentBody from CaseComment where ParentID =: grievanceCase.id];
            System.assert(deletedListOfRecords.size()  == 0);
       }
       
       Test.stopTest();   
    }
    
}