/**    
 *     Class Name  : GrievanceCommentsTest
 *     Author      : IDC Offshore  
 *     Date        : 11-Oct-2014  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : Test Class for GrievanceComments trigger. This class tests creating a 'CaseComment' record and also creating related 'Call_Back__c' record scenario. 
 **/
@isTest(seeAllData = true)
private class GrievanceCommentsTest{
    private static final String GRIEVANCE = 'Grievance';
    private static final String CASEOBJ = 'Case';

    static testmethod void testCreateCallbackRecordsFromComments(){
        UserRole  usrrole = [select id from UserRole where name=: AP01_TestDataTokens.SHP_PROFILE_NAME limit 1] ;  
        Profile p = [select id from profile where Name =: AP01_TestDataTokens.SHP_PROFILE_NAME];

        User  testUser = new User(alias = 'u1', email='u123@testorg.com',
        emailencodingkey='UTF-8', lastname='Testing123', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='u123@testorg.com', 
        userroleid = usrrole.id);

        System.runAs(testUser)
        {
            RecordType recType = [select id,name from recordType where sobjectType=:CASEOBJ AND name=:GRIEVANCE limit 1];
            
            Case grievanceCase = new Case();
            grievanceCase.Subject = 'Test';
            grievanceCase.RecordTypeID = recType.ID;
            insert grievanceCase;
                     
            Test.startTest();

            CaseComment caseCommentRec = new CaseComment(ParentId=grievanceCase.id , CommentBody='Testing Comments');   
            insert caseCommentRec;
           
            
            Test.stopTest();
            
            List<Call_Back__c> listOfRecords =new List<Call_Back__c>();
            String caseCommentId = String.valueOf(caseCommentRec.id);
            listOfRecords = [select id from Call_Back__c where CaseCommentID__c =: caseCommentId];
            System.assert(listOfRecords != null);
            
        }
    } 

}