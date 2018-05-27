/**     
 *     Class Name  : GrievanceTriggerTest 
 *     Author      : IDC Offshore   
 *     Date        : 11-Oct-2014   
 *     Project Name: CRM - SFT - Sutter Health   
 *     Description : Test Class for GrievanceTrigger trigger. This class tests if any 'Case' record's recordtype is changed (from any recordtype other than Grievance) to 'Grievance' record type and it has 'CaseComment' record/s theno create/update related 'Call_Back__c' records scenario.  
 **/
@isTest
private class GrievanceTriggerTest{

    private static final String SHP_INTERACTION_LOG = 'SHP Interaction Log';
    private static final String GRIEVANCE = 'Grievance';
    private static final String CASEOBJ = 'Case';
    private static final String EXEMPT_MILESTONE = 'SHP Grievance Entitlement for Exempt'; 
    private static final String RESOLVED = 'Resolved';   
    private static final String RESOLUTION = 'Resolution';  
    
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description method to create test data used by all tests       
     * @return void        
     **/
    @testSetup
    Static void createTestData(){
        UserRole  usrrole = [select id from UserRole where name=: AP01_TestDataTokens.SHP_PROFILE_NAME limit 1] ;  
        Profile p = [select id from profile where Name ='System Administrator'];

        User  testUser = new User(alias = 'u1', email='u123@testorg.com',
        emailencodingkey='UTF-8', lastname='Testing123', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='u123@testorg.com', 
        userroleid = usrrole.id);
        
        insert testUser;
        
        //Assert to check if user record has been created successfully 
        system.assert(testUser.id != null);
        
        System.runAs(testUser)
        {
            //Create Account
             Account acc = AP01_TestDataUtility.createAccount();
             
            //Assert to check if Account record has been created successfully 
            system.assert(acc.id != null);
            
            // insert Entitlement 
            Entitlement ent = new Entitlement(Name= EXEMPT_MILESTONE ,AccountId=acc.Id, StartDate=Date.valueof(System.now().addDays(-10)),
            EndDate=Date.valueof(System.now().addYears(3)));
            insert ent;
            
             //Assert to check if Entitlement record has been created successfully 
            system.assert(ent.id != null);
        }

    }
    
    /**             
    * @author IDC Team             
    * @date 11-Oct-2014             
    * @description: To validate single Case record Insert,Update and delete Actions in GrievanceTrigger trigger.      
    * @return void             
    */
    static testmethod void testInsertUpdateDeleteActions(){
       
        String entId;
        RecordType grievanceRecType = [select id,name from recordType where sobjectType=: CASEOBJ AND name=: GRIEVANCE limit 1];
        RecordType shpRecType = [select id,name from recordType where sobjectType=: CASEOBJ AND name=: SHP_INTERACTION_LOG limit 1];
        Case grievanceCase = new Case();
        grievanceCase.Subject = 'Test';
        grievanceCase.RecordTypeID = shpRecType.ID;
        
        insert grievanceCase;
        
        //Assert to check if Case record has been created successfully 
        system.assert(grievanceCase.id != null);
        
        List<CaseComment> listOfCaseComments = new List<CaseComment>();
        CaseComment caseCommentRec1 = new CaseComment(CommentBody='TestComment1', ParentId=grievanceCase.id);
        CaseComment caseCommentRec2 = new CaseComment(CommentBody='TestComment2', ParentId=grievanceCase.id);
        listOfCaseComments.add(caseCommentRec1);
        listOfCaseComments.add(caseCommentRec2);
        insert listOfCaseComments;
        
        //Assert to check if CaseComment record has been created successfully 
        system.assert(listOfCaseComments[0].id != null);
        
        List<Entitlement> entitlementList = new List<Entitlement>();
        entitlementList = [select Id from Entitlement where name = :EXEMPT_MILESTONE limit 1];
        System.assert(entitlementList.size() > 0);
        if(entitlementList.size() > 0){
            entId = entitlementList.get(0).id;
        } 
        
        
        List<String> caseCommentIds = new List<String>();
        caseCommentIds.add(String.valueOf(caseCommentRec1.id));
        caseCommentIds.add(String.valueOf(caseCommentRec2.id));
                
        List<Call_Back__c> callbackList = new List<Call_Back__c>();
        Call_Back__c callbackRec ;
        callbackList = [select id from Call_Back__c where CaseCommentID__c IN: caseCommentIds ];
        System.assert(callbackList.size() == 0);
        
        User  testUser = [Select id from user where username='u123@testorg.com' ];
        
        Test.startTest();
        System.runAs(testUser){
        grievanceCase.RecordTypeID = grievanceRecType.ID;
        grievanceCase.Reason__c = 'Member Grievance';        
        grievanceCase.Secondary_Reason__c = 'Exempt';
        grievanceCase.Grievance_Reason__c = 'Access - General';
        grievanceCase.Date_Grievance_Requested__c = system.Now().addDays(-2);
        grievanceCase.Status = RESOLVED ;
        grievanceCase.EntitlementId = entId;
        grievanceCase.SlaStartDate =system.Now();
        
        callbackRec = new Call_Back__c(Parent_Case__c=grievanceCase.id , Notes__c='Testing Comments');   
        insert callbackRec; 
        callbackRec.CaseCommentID__c = caseCommentRec1.id;
        
        update callbackRec;
        
        update grievanceCase;
        
        List<Id> listOfCaseRecIds = new List<Id>();
        listOfCaseRecIds.add(grievanceCase.id);
        GrievanceTriggerSupport.completeMilestone(listOfCaseRecIds, RESOLUTION,  System.today()) ;
        
        Test.stopTest();
        
        callbackList = [select id from Call_Back__c where CaseCommentID__c IN: caseCommentIds ];
        System.assertEquals(2, callbackList.size(), 'Number o records did not match.');
        }
    }
    
    /**             
    * @author IDC Team             
    * @date 11-Oct-2014             
    * @description: To validate Negative senario for single Case record Insert,Update and delete Actions in GrievanceTrigger trigger.      
    * @return void             
    */
    static testmethod void testNegativeInsertUpdateDeleteActions(){
       
        String entId;
        //RecordType grievanceRecType = [select id,name from recordType where sobjectType=: CASEOBJ AND name=: GRIEVANCE limit 1];
        RecordType shpRecType = [select id,name from recordType where sobjectType=: CASEOBJ AND name=: SHP_INTERACTION_LOG limit 1];
        Case grievanceCase = new Case();
        grievanceCase.Subject = 'Test';
        grievanceCase.RecordTypeID = shpRecType.ID;
        
        insert grievanceCase;
        
        //Assert to check if Case record has been created successfully 
        system.assert(grievanceCase.id != null);
        
        List<CaseComment> listOfCaseComments = new List<CaseComment>();
        CaseComment caseCommentRec1 = new CaseComment(CommentBody='TestComment1', ParentId=grievanceCase.id);
        CaseComment caseCommentRec2 = new CaseComment(CommentBody='TestComment2', ParentId=grievanceCase.id);
        listOfCaseComments.add(caseCommentRec1);
        listOfCaseComments.add(caseCommentRec2);
        insert listOfCaseComments;
        
        //Assert to check if CaseComment record has been created successfully 
        system.assert(listOfCaseComments[0].id != null);
        
        List<Entitlement> entitlementList = new List<Entitlement>();
        entitlementList = [select Id from Entitlement where name = :EXEMPT_MILESTONE limit 1];
        System.assert(entitlementList.size() > 0);
        if(entitlementList.size() > 0){
            entId = entitlementList.get(0).id;
        } 
        
        
        List<String> caseCommentIds = new List<String>();
        caseCommentIds.add(String.valueOf(caseCommentRec1.id));
        caseCommentIds.add(String.valueOf(caseCommentRec2.id));
                
        List<Call_Back__c> callbackList = new List<Call_Back__c>();
        Call_Back__c callbackRec ;
        callbackList = [select id from Call_Back__c where CaseCommentID__c IN: caseCommentIds ];
        System.assert(callbackList.size() == 0);
        
        User  testUser = [Select id from user where username='u123@testorg.com' ];
        
        Test.startTest();
        System.runAs(testUser){
        //grievanceCase.RecordTypeID = grievanceRecType.ID;
        grievanceCase.Reason__c = 'Member Grievance';        
        grievanceCase.Secondary_Reason__c = 'Exempt';
        grievanceCase.Grievance_Reason__c = 'Access - General';
        grievanceCase.Date_Grievance_Requested__c = system.Now().addDays(-2);
        grievanceCase.Status = RESOLVED ;
        grievanceCase.EntitlementId = entId;
        grievanceCase.SlaStartDate =system.Now();
        
        callbackRec = new Call_Back__c(Parent_Case__c=grievanceCase.id , Notes__c='Testing Comments');   
        insert callbackRec; 
        callbackRec.CaseCommentID__c = caseCommentRec1.id;
        
        update callbackRec;
        
        update grievanceCase;
        
        List<Id> listOfCaseRecIds = new List<Id>();
        listOfCaseRecIds.add(grievanceCase.id);
        GrievanceTriggerSupport.completeMilestone(listOfCaseRecIds, RESOLUTION,  System.today()) ;
        
        Test.stopTest();
        
        callbackList = [select id,Notes__c from Call_Back__c where CaseCommentID__c IN: caseCommentIds ];
        //Assert to check call back notes is updated by casecomment's commentBody
        System.assert(caseCommentRec1.CommentBody != callbackList[0].Notes__c);
        }
    }
    /**             
    * @author IDC Team             
    * @date 11-Oct-2014             
    * @description: To validate multiple(Bulk) Case records Insert,Update and delete Actions in GrievanceTrigger trigger.      
    * @return void             
    */
    static testmethod void testBulkInsertUpdateDeleteActions(){
       
        String entId;
        RecordType grievanceRecType = [select id,name from recordType where sobjectType=: CASEOBJ AND name=: GRIEVANCE limit 1];
        RecordType shpRecType = [select id,name from recordType where sobjectType=: CASEOBJ AND name=: SHP_INTERACTION_LOG limit 1];
        list<case> lstCase = new list<case>();
        for(Integer i=0;i<=100;i++){
        Case grievanceCase = new Case();
        grievanceCase.Subject = 'Test';
        grievanceCase.RecordTypeID = shpRecType.ID;
        lstCase.add(grievanceCase);
        }
        insert lstCase;
        
        //Assert to check if Case record has been created successfully 
        system.assert(lstCase[100].id != null);
        
        List<CaseComment> listOfCaseComments = new List<CaseComment>();
        for(case grievanceCase : lstCase){
        CaseComment caseCommentRec1 = new CaseComment(CommentBody='TestComment', ParentId=grievanceCase.id);
        listOfCaseComments.add(caseCommentRec1);
        
        }
        insert listOfCaseComments;
        
        //Assert to check if CaseComment record has been created successfully 
        system.assert(listOfCaseComments[0].id != null);
        
        List<Entitlement> entitlementList = new List<Entitlement>();
        entitlementList = [select Id from Entitlement where name = :EXEMPT_MILESTONE limit 1];
        System.assert(entitlementList.size() > 0);
        if(entitlementList.size() > 0){
            entId = entitlementList.get(0).id;
        } 
        
        
        List<String> caseCommentIds = new List<String>();
        
        List<Call_Back__c> callbackList = new List<Call_Back__c>();
        Call_Back__c callbackRec ;
        
        User  testUser = [Select id from user where username='u123@testorg.com' ];
        
        Test.startTest();
        System.runAs(testUser){
        list<Call_Back__c> lstcallBack = new list<Call_Back__c>();
        list<case> lstUpdateCase = new list<case>();
        List<Id> listOfCaseRecIds = new List<Id>();
        for(case grievanceCase : lstCase){
        grievanceCase.RecordTypeID = grievanceRecType.ID;
        grievanceCase.Reason__c = 'Member Grievance';        
        grievanceCase.Secondary_Reason__c = 'Exempt';
        grievanceCase.Grievance_Reason__c = 'Access - General';
        grievanceCase.Date_Grievance_Requested__c = system.Now().addDays(-2);
        grievanceCase.Status = RESOLVED ;
        grievanceCase.EntitlementId = entId;
        grievanceCase.SlaStartDate =system.Now();
        
        callbackRec = new Call_Back__c(Parent_Case__c=grievanceCase.id , Notes__c='Testing Comments');   
        lstcallBack.add(callbackRec);
        lstUpdateCase.add(grievanceCase);
        listOfCaseRecIds.add(grievanceCase.id);
        }
        insert lstcallBack; 
        Integer i = 0;
        for(Call_Back__c tempCallBack : lstcallBack){
        callbackRec.CaseCommentID__c = listOfCaseComments[i].id;
        caseCommentIds.add(String.valueOf(listOfCaseComments[i].id));
        i++;
        }
        
        update lstcallBack;
        
        update lstUpdateCase;
        
        GrievanceTriggerSupport.completeMilestone(listOfCaseRecIds, RESOLUTION,  System.today()) ;
        
        Test.stopTest();
        
        callbackList = [select id from Call_Back__c where CaseCommentID__c IN: caseCommentIds ];
        System.assertEquals(101, callbackList.size(), 'Number o records did not match.');
        }
    } 
}