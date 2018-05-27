/**
 * Name : TrainingRequestTrigger_Test
 * Author : IDC Team
 * Description : Test Class for TrainingRequest Trigger. This class tests different scenarios that are handled in the code
 * Date : 10/20/14 4:51 PM 
 * Version : <intial Draft> 
 */
@isTest
private class TrainingRequestTrigger_Test { 

    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description: method to create test data used by all tests       
     * @return void        
     */
    @TestSetup
    Static Void createTestData(){
        Profile p = [SELECT Id FROM Profile WHERE Name='S3 Revenue Cycle Agent']; 
        User testuser = new User(Alias = 'standt', Email='standarduser@testmethod.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testmethod.com');
        insert testuser;
        
        //Assert to check if User has been created successfully 
        system.assert(testuser.id != null);
        
        PermissionSet ps = [Select id,name from PermissionSet where Name='TrainingRequest'];
        PermissionSetAssignment psa= new PermissionSetAssignment();
        psa.AssigneeId = testuser.id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        //Assert to check if permission set assignment has been created successfully 
        system.assert(psa.id != null);
        
        List<Group> queueRecords = [select id from Group where (Name ='Training - S3' OR Name ='Training - Revenue Cycle') AND 
        Type ='Queue' limit 2];
        
        //Assert to check Training - S3 /Training - Revenue Cycle queues are available  
        system.assert(queueRecords != null);
        
        GroupMember GM = new GroupMember(GroupId = queueRecords[0].id,UserOrGroupId = testuser.Id);
        insert GM ;
        
        RecordType recType = [select id,name from recordType where sobjectType='Case' AND name='Training' limit 1];
        
        system.runAs(testuser){
            list<Case> lstCase = new list<Case>();
            for(Integer i = 0;i<=100;i++){
            Case caseTest =  new Case();
            caseTest.Subject = 'test-training';
            caseTest.Type_Training__c = 'other';
            caseTest.Time_Frame__c = Date.Today().addDays(5);
            caseTest.functional_area__c = 'CBO';
            caseTest.Team__c = 'All CBO';
            caseTest.RecordTypeID =recType.ID;
            caseTest.status= 'New' ;
            caseTest.isFiredAcceptButton__c = true;
            caseTest.Ownerid = queueRecords[0].id;
            lstCase.add(caseTest);
            }
            insert lstCase;
        //Assert to check if case has been created successfully 
        system.assert(lstCase[10].id != null);
        }
    }
    
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description: To validate for training request single case record  If Owner is a user then set status to 'in progress' and update 'Date_ownership_is_taken__c' field value.
     * @return void        
     */
    static testMethod  void ChangeCaseInProgresstestTest(){

        User testuser = [Select id from user where username ='standarduser@testmethod.com'];
        //Assert to check user record has been fetched successfully 
        system.assert(testuser!= null);
        boolean isFirstTime = true;
        
        RecordType recType = [select id,name from recordType where sobjectType='Case' AND name='Training' limit 1];
        
        Case caseTest = [Select id,Status from Case where recordType.name = 'Training' limit 1];
        //Assert to check if case has  been fetched successfully 
        system.assert(caseTest!= null);
        
        system.runAs(testuser){
            test.starttest();
            
            caseTest.Impacted_Functional_Area__c ='Testing';
            caseTest.Impacted_Team__c='Test Team';
            caseTest.Start_Date__c=date.today();
            casetest.OwnerId = testuser.id;
            caseTest.RecordTypeID =recType.ID;
            update caseTest;
            
            //Assert to check same training request case record has been  updated
            System.assertequals(caseTest.RecordTypeID,recType.ID);
            test.stoptest();
        }
        
    }
    
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description: To validate for training request bulk case records  If Owner is a user then set status to 'in progress' and update 'Date_ownership_is_taken__c' field value.
     * @return void        
     */
    static testMethod  void ChangeCaseInProgresstestBulkTest(){

        User testuser = [Select id from user where username ='standarduser@testmethod.com'];
        //Assert to check user record has been fetched successfully 
        system.assert(testuser!= null);
        boolean isFirstTime = true;
        
        RecordType recType = [select id,name from recordType where sobjectType='Case' AND name='Training' limit 1];
        
        list<Case> caseTest = [Select id,Status from Case where recordType.name = 'Training'];
        //Assert to check if case has  been fetched successfully 
        system.assert(caseTest!= null);
        
        system.runAs(testuser){
            test.starttest();
            for(Case tempcase : caseTest){
            tempcase.Impacted_Functional_Area__c ='Testing';
            tempcase.Impacted_Team__c='Test Team';
            tempcase.Start_Date__c=date.today();
            tempcase.OwnerId = testuser.id;
            tempcase.RecordTypeID =recType.ID;
            }
            update caseTest;
            
            //Assert to check same training request case record has been  updated
            System.assertequals(caseTest[10].RecordTypeID,recType.ID);
            test.stoptest();
        }
        
    }
}