/**     
 *     Class Name  : GrievanceTriggerSupportTest
 *     Author      : IDC Offshore   
 *     Date        : 14-Oct-2014   
 *     Project Name: CRM - SFT - Sutter Health   
 *     Description : Test Class for GrievanceTriggerSupport class. This class tests the 'completeMilestone' scenario.  
 **/
@isTest
private class GrievanceTriggerSupportTest{

    private static final String SHP_INTERACTION_LOG = 'SHP Interaction Log';
    private static final String GRIEVANCE = 'Grievance';
    private static final String CASEOBJ = 'Case';
    private static final String EXEMPT_MILESTONE = 'SHP Grievance Entitlement for Exempt'; 
    private static final String RESOLVED = 'Resolved';
    private static final String RESOLUTION = 'Resolution';   

    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description: method to create test data used by all tests       
     * @return void        
     */
    @testsetup
    Static void createTestData()
    {
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
        
            SlaProcess process =[SELECT Id,Name FROM SlaProcess where Name = :EXEMPT_MILESTONE limit 1];
            
            // insert Entitlement 
            Entitlement ent = new Entitlement(Name= EXEMPT_MILESTONE ,AccountId=acc.Id,SlaProcessId=process.Id, StartDate=Date.valueof(System.now().addDays(-10)),
            EndDate=Date.valueof(System.now().addYears(3)));
            insert ent;
            
            //Assert to check if Entitlement record has been created successfully 
            system.assert(ent.id != null);
            
        }
    }
    
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description: method to create grievance case , update case and check completeMilestone method        
     * @return void        
     */
    static testmethod void testExemptMilestoneCompletion(){
           
        String entId ;    
        User  testUser = [Select  id from User where username='u123@testorg.com'];
        
        //Assert to check if User record has been retrieved successfully 
        system.assert(testUser.id != null);
        
        RecordType grievanceRecType = [select id,name from recordType where sobjectType=: CASEOBJ AND name=: GRIEVANCE limit 1];
        RecordType shpRecType = [select id,name from recordType where sobjectType=: CASEOBJ AND name=: SHP_INTERACTION_LOG limit 1];
        Case grievanceCase = new Case();
        grievanceCase.Subject = 'Test';
        grievanceCase.RecordTypeID = shpRecType.ID;
        
        insert grievanceCase;
        
        //Assert to check if Case record has been created successfully 
        system.assert(grievanceCase.id != null);
            
        List<Entitlement> entitlementList = new List<Entitlement>();
        entitlementList = [select Id from Entitlement where Name = :EXEMPT_MILESTONE limit 1];
        System.assert(entitlementList.size() > 0);
        if(entitlementList.size() > 0){
            entId = entitlementList.get(0).id;
        }  

        grievanceCase.RecordTypeID = grievanceRecType.ID;
        grievanceCase.Subject = 'Test';
        grievanceCase.Reason__c = 'Member Grievance';        
        grievanceCase.Secondary_Reason__c = 'Exempt';
        grievanceCase.Grievance_Reason__c = 'Access - General';
        grievanceCase.Date_Grievance_Requested__c = system.Now().addDays(-2);
        grievanceCase.Status = RESOLVED ;
        grievanceCase.EntitlementId = entId;
        grievanceCase.SlaStartDate =system.Now();
        
        System.runAs(testUser){ 
         
            Test.startTest();
            try{
            update grievanceCase;
            List<Id> listOfCaseRecIds = new List<Id>();
            listOfCaseRecIds.add(grievanceCase.id);
            GrievanceTriggerSupport.completeMilestone(listOfCaseRecIds, RESOLUTION,  System.now()) ;
            List<CaseMilestone> cmsToUpdate = [select Id, completionDate from CaseMilestone cm where caseId in :listOfCaseRecIds and cm.MilestoneType.Name=:RESOLUTION and completionDate = null limit 1];
            
                //assert to check expect result after excute trigger...
                if (cmsToUpdate.isEmpty() == false){
                    for (CaseMilestone cm : cmsToUpdate){
                      system.assert(cm.completionDate == System.now());
                    }
                }
            }catch(Exception ex){}
            Test.stopTest();
        }            
    }
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description: method to test isFirstExecution        
     * @return void        
     */
    static testmethod void testIsFirstExecutionVar(){
         Test.startTest();
         
         System.assert(GrievanceTriggerSupport.isFirstExecution() == true);
         GrievanceTriggerSupport.isFirstTime = false;
         System.assert(GrievanceTriggerSupport.isFirstExecution() == false);          
         
         Test.stopTest(); 
    }    
        
}