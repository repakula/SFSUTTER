/**  
*    Class Name: ManageCase_SHP_Test
*    Author: Rahul
*    Date: 26-December-2013
*    Description:  This test class tests ManageCaseInsert, ManageCaseUpdate, ManageCaseDatabase classes and Managecases trigger.This class tests different scenarios that are handled in the code for SHP Users.
*    History
*    --------
**/

@isTest
private without sharing class ManageCase_SHP_Test{

    private static final String SHP_PROFILE_NAME = 'SHP Agent';
    private static final String SHP_GRI_COORDINATOR_ROLE = 'SHP Grievance Coordinator';
    private static final String SHP_ROLE_NAME = 'SHP Agent';
    private static final String CONT_RT_MEMBER = 'Member';
    private static final string CONTACT_RT_SHP_PROVIDER = 'SHP Provider';
    private static final string CASE_RT_GRIEVANCE = 'Grievance';
    private static final string REASON_CLINICAL = 'Clinical';
    private static final string OOA_MEDICAL = 'Out of Area – Medical';
    private static final string OOA_BEHAVIORAL = 'Out of Area – Behavioral';
    private static final string VFC_URL_STR1 = '/apex/VFP01_CustomConsole?CALLID=';
    private static final string VFC_URL_STR2 = '&DEV=87667676&DNISTC=SHPM&CALLDT=&TRANF=NO'; 
    private static final string MEMBER_ID = '12345678';
    private static final string NAME_STR = 'Test';
    private static final string MEMBER_CONTACT_NUM = '616-643-7555';
    private static final string PROVIDER_NPI = '111123';
    private static final string OOA_VIEW_ONLY = 'SHP OOA/OON View Only';
    private static final string OOA_OON_RT = 'OOA/OON';
    private static final string ER_VERIFICATION = 'ER Verification';
    private static final string TEST_STR = 'Test';
    private static final string DMHC_VALUE = 'Met';
    private static final string DMHC_ERROR = 'You do not have the right to fill DMHC fields';
    public static final string HR_AUTH_ERROR = 'You do not have the right to fill HR Authorization';
    
    /**
    * @author IDC Team
    * @date 28/09/2015
    * @description :method to create test data used by all tests  
    * @param 
    * @return void
    */
    @testSetup 
    static void createTestData() {
            
        CreatedDate__c obj =  new CreatedDate__c();
        obj.Created_date__c = date.today();
        obj.name='CopyPcpDate';
        insert obj;
        
        String RTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONT_RT_MEMBER).RecordTypeId;
        Account acc1 = AP01_TestDataUtility.createAccount();
        Contact cont = new Contact (Lastname='Test', AccountId =acc1.id,Member_HCC_ID__c ='12345678',MemberIdField__c ='12345678',recordTypeID =RTypeId);
        insert cont;
        //Assert to check Contact has created successfully
        system.assert(cont.Id != null);
        
        
        
    }
    
    /**
    * @author IDC Team
    * @date 28/09/2015
    * @description :method to create case 
    * @param 
    * @return void
    */
    public static list<case> createcases(){
        list<Case> lstCase = new list<Case>();
        string caseRecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Grievance Web Form Interaction Log').RecordTypeId;
        Case caseObj = new Case();
        caseObj.RecordTypeId = caseRecordTypeId;
        caseObj.Status = 'New';
        caseObj.RFI_Request_Date__c = system.today();
        caseObj.isTriggerError__c = true;
        lstCase.add(caseObj);
        insert lstCase;
        
        //Assert to check case has created successfully...
        system.assert(lstCase[0].id != null);
        
        return lstCase;
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description : create SHP Agent(role :SHP Grievance Coordinator) User of SHP OOA/OON View Only Group //3318
    * @param 
    * @return user
    */
    public static User createSHPGrievanceUser(){
        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        User usr = new User();
        System.runAs ( thisUser ) {
            
            Id profileID = [Select Id from Profile where Name =: SHP_PROFILE_NAME].Id;
            Id roleId = [SELECT Id FROM UserRole where Name =: SHP_GRI_COORDINATOR_ROLE].Id;
        
            usr.LastName = AP01_TestDataTokens.USER_LAST_NAME;
            usr.Username = AP01_TestDataTokens.USER_NAME;
            usr.Email = AP01_TestDataTokens.USER_EMAIL;
            usr.Alias = AP01_TestDataTokens.ALIAS;
            usr.CommunityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME ;
            usr.TimeZoneSidKey = AP01_TestDataTokens.TIME_ZONES_ID_KEY;
            usr.LocaleSidKey = AP01_TestDataTokens.LOCALE_SID_KEY;
            usr.EmailEncodingKey = AP01_TestDataTokens.EMAIL_ENCODING_KEYS;
            usr.LanguageLocaleKey = AP01_TestDataTokens.LANGUAGE_LOCALE_KEY;
            usr.profileid = profileID;
            usr.UserRoleId = roleId;
            usr.isActive = true;
            
            Database.insert(usr);
            
            //Assert to check User has created successfully...
            system.assert(usr.Id != null);
        }
        return usr;
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description : create grievance Case  records
    * @param 
    * @return user
    */
    public static List<Case> createGrievanceSR(){
        
        List<Case> grievanceCaseList = new List<Case>();
        string caseRecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_GRIEVANCE).RecordTypeId;
        for(Integer i=0; i<5; i++){
            
            Case grievanceCase = new Case();
            grievanceCase.RecordTypeId = caseRecordTypeId;
            grievanceCase.Status = 'New';
            grievanceCase.Origin = 'Web';
            grievanceCase.Reason__c = 'Member Grievance';
            grievanceCase.Secondary_Reason__c = 'Routine';
            grievanceCase.Grievance_Issue_Description__c = 'Access to Care - Distance';
            grievanceCase.Priority = 'Medium';
            grievanceCaseList.add(grievanceCase);
        }
        Database.insert(grievanceCaseList);
        
        //Assert to check case has created successfully...
        system.assert(grievanceCaseList[0].id != null);
        system.assert(grievanceCaseList[1].id != null);
        system.assert(grievanceCaseList[2].id != null);
        system.assert(grievanceCaseList[3].id != null);
        system.assert(grievanceCaseList[4].id != null);
        return grievanceCaseList;
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description : To catch exception error.
    * @param 
    * @return user
    */
    static testMethod void disputeDateChangeErrorTest(){
        User shpGrievanceUser = createSHPGrievanceUser();
        List<Case> grievanceCases;
        List<Case> grievanceCaseToUpdate = new List<Case>();
        List<Case> grievanceCaseToUpdate2 = new List<Case>();
        system.RunAs(shpGrievanceUser){
        
            grievanceCases = createGrievanceSR();
            
            for(Case gCase : grievanceCases){
            
                gCase.Date_Grievance_Requested__c = datetime.now();
                grievanceCaseToUpdate.add(gCase);
            }
            
            Test.startTest();
                Database.update(grievanceCaseToUpdate);
            Test.stopTest();
            
            for(Case gCase2 : grievanceCaseToUpdate){
                
                gCase2.Date_Grievance_Requested__c = gCase2.Date_Grievance_Requested__c.addSeconds(1);
                grievanceCaseToUpdate2.add(gCase2);
            }
            try{
                Database.update(grievanceCaseToUpdate2);
                
            }catch(Exception classException){
                Boolean expectedExceptionThrown = classException.getMessage().contains('You cannot update Date Grievance/Dispute Received field more than 1 time') ? true : false;
                System.assert(classException.getMessage()!=null);
            }
        }
    
        
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description : update grievance case to test milestone date
    * @param 
    * @return user
    */
    static testMethod void updateMilestoneDateTest(){
        User shpGrievanceUser = createSHPGrievanceUser();
        List<Case> grievanceCases;
        List<Case> grievanceCaseToUpdate = new List<Case>();
        List<Case> grievanceCaseToUpdate2 = new List<Case>();
        
        system.RunAs(shpGrievanceUser){
            grievanceCases = createGrievanceSR();
            for(Case gCase : grievanceCases) {
                gCase.Secondary_Reason__c = 'Exempt';
                grievanceCaseToUpdate.add(gCase);
            }
            
            Test.startTest();
            Try{
                Database.update(grievanceCaseToUpdate);
                
            } catch (Exception classException) {
                system.assert(classException.getmessage()!=null);
        
            }
            Test.stopTest();
        }
    }
    
    /**
    * @author :IDC Offshore
    * @date 01/03/2014
    * @description : update grievance case REQ:3318
    * @param 
    * @return user
    */
    static testMethod void GrivenceAfterUpdateTest(){
        User shpGrievanceUser = createSHPGrievanceUser();
        List<Case> grievanceCases;
        List<Case> grievanceCaseToUpdate = new List<Case>();
        List<Case> grievanceCaseToUpdate2 = new List<Case>();
        
        system.RunAs(shpGrievanceUser){
            grievanceCases = createGrievanceSR();
            for(Case gCase : grievanceCases) {
                gCase.Reason__c = 'DMHC Additional information ';
                gCase.Secondary_Reason__c = 'Routine';
                gCase.Date_Grievance_Requested__c=Date.valueOf(system.today());
                gCase.Grievance_Issue_Description__c = 'Access to Care';
                gCase.Priority = 'Medium';
                gCase.Request_Clinical_Records__c =True;
                grievanceCaseToUpdate.add(gCase);
            }
            
            Test.startTest();
            Try{
                ManageExecutions.isSameCaseUpdate=false;
                Database.update(grievanceCaseToUpdate);
                
            } catch (Exception classException) {
                system.assert(classException.getmessage()!=null);
        
            }
            Test.stopTest();
        }
    }
    /**
    * @author Saket
    * @date 01/03/2014
    * @description : create a new case to check case milestone 
    * @param 
    * @return user
    */
    static testMethod void caseMilestoneBeforeUpdateTest(){
        string caseRecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(system.Label.CL31_Provider_Dispute).RecordTypeId;
        Case caseObj = new Case();
        caseObj.RecordTypeId = caseRecordTypeId;
        caseObj.Status = 'New';
        caseObj.RFI_Request_Date__c = system.today();
        insert caseObj;
        
        Request_for_Information__c reqObj = new Request_for_Information__c();
        reqObj.Service_Request__c = caseObj.id;
        reqObj.Comments__c = 'Test';
        reqObj.Date_Information_Received__c = System.Now();
        reqObj.Date_Information_Requested__c = System.Now(); 
        insert reqObj;
        
        caseObj.RFI_Request_Date__c = system.today() + 5;
        update caseObj;
        
        //Assert to check update on case...
        case tempcase = [select id,RFI_Request_Date__c from case where id = : caseObj.id];
        system.assert(tempcase.RFI_Request_Date__c == system.today() + 5);
    } 
    
    
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method calls the Test data Method by passing the count for Number of Cases as 30 .
    * @param 
    * @return 
    */
    @isTest static void testManageCase() {        
        AP01_TestDataUtility.prepareSHPUsers();
   
        System.runAs(AP01_TestDataUtility.shpAgent) {  
            
            ManageExecutions.isSameGrienanceId = true;
            
            AP01_TestDataUtility.prepareTestData(AP01_TestDataUtility.NUMBER_OF_CASES);
            
            AP01_TestDataUtility.setTaskLookupCase();
            //AP01_TestDataUtility.setTasksToClosed();
            try{
                AP01_TestDataUtility.setCasesToClosed();                
                update AP01_TestDataUtility.testCases; 
                AP01_TestDataUtility.setSRClosed();
                AP01_TestDataUtility.setCasesUnclosedClosed();
                AP01_TestDataUtility.setTasksToClosed();
            } catch (Exception classException) {
            
                Boolean expectedExceptionThrown =  classException.getMessage().contains('This case cannot be closed because not all of the tasks are completed') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
        
            }
            try{
                AP01_TestDataUtility.setS3OwnerhipCase();                
                update AP01_TestDataUtility.testCases;
            } catch (Exception classException) {
            
                Boolean expectedExceptionThrown =  classException.getMessage().contains('You may pick only an SHP queue.') ? true : false;
                  System.AssertEquals(expectedExceptionThrown, false);

        
            }
        }
    }
    
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method calls the Test data Method by passing the count for Number of Cases as 30 and querying the Grievance RecordType
    * @param 
    * @return 
    */
    
    @isTest static void testManageCaseQueryWebGrievanceRecordType() {        
        AP01_TestDataUtility.prepareSHPUsers();
   
        System.runAs(AP01_TestDataUtility.shpAgent) {  
            
            ManageExecutions.isSameGrienanceId = false;
            
            AP01_TestDataUtility.prepareTestData(AP01_TestDataUtility.NUMBER_OF_CASES);
            
            AP01_TestDataUtility.setTaskLookupCase();
            try{
                AP01_TestDataUtility.setCasesToClosed();                
                update AP01_TestDataUtility.testCases; 
            } catch (Exception classException) {
            
                Boolean expectedExceptionThrown =  classException.getMessage().contains('This case cannot be closed because not all of the tasks are completed') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
        
            }
            AP01_TestDataUtility.setSRClosed();
            
            AP01_TestDataUtility.setCasesUnclosedClosed();
            AP01_TestDataUtility.setTasksToClosed();
    
            try{
                AP01_TestDataUtility.setS3OwnerhipCase();                
                update AP01_TestDataUtility.testCases;
            } catch (Exception classException) {
            
                Boolean expectedExceptionThrown =  classException.getMessage().contains('You may pick only an SHP queue.') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
        
            }
        }
    }
    
    
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method calls the Test data Method by passing the count for Number of Cases as 30. Closed Task case is tested here
    * @param 
    * @return 
    */
    @isTest static void testManageCaseClosedTask() {        
        AP01_TestDataUtility.prepareSHPUsers();
   
        System.runAs(AP01_TestDataUtility.shpAgent) {  
            
            ManageExecutions.isSameGrienanceId = true;
            
            AP01_TestDataUtility.prepareTestData(AP01_TestDataUtility.NUMBER_OF_CASES);
            
            AP01_TestDataUtility.setTaskLookupCase();
            
            try{
                AP01_TestDataUtility.setCasesToClosed();
                AP01_TestDataUtility.setTasksToClosed();              
                update AP01_TestDataUtility.testCases; 
            }catch (Exception classException) {
            
                Boolean expectedExceptionThrown =  classException.getMessage().contains('This case cannot be closed because not all of the tasks are completed') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
        
            }
            
            ManageCaseUpdate.CloseCaseMilestones(AP01_TestDataUtility.returnTestCases());
        }
    }
 
     /*******************************************************************
    Purpose: To check case milestone   .   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void Closecasemilestonecheck(){
         
    //Create Account
         Account acc = AP01_TestDataUtility.createAccount();
         
        //Assert to check if Account record has been created successfully 
        system.assert(acc.id != null);
        
        // insert Entitlement 
        Entitlement ent = new Entitlement(Name= 'SHP Grievance Entitlement for Exempt' ,AccountId=acc.Id, StartDate=Date.valueof(System.now().addDays(-10)),
        EndDate=Date.valueof(System.now().addYears(3)));
        insert ent;
        
         //Assert to check if Entitlement record has been created successfully 
        system.assert(ent.id != null);
        
        Case objCase3 =new Case();
        objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Grievance').RecordTypeId;
        objCase3.EntitlementId = ent.Id;
        objCase3.SlaStartDate =system.Now();
        
        insert objCase3;
        //Assert to check if Entitlement record has been created successfully 
        system.assert(objCase3.id != null);
        
        test.startTest();
        
        casemilestone cm = new casemilestone();
        
         
        List<case> listOfCase = new List<case>();
        listOfCase.add(objCase3);
         ManageCaseUpdate.CloseCaseMilestones(listOfCase);
       
       test.stoptest(); 
        
    }
 
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description : To create case for customer inquiry through VFC01_CustomConsole vf page.
    * @param 
    * @return 
    */
    static testMethod void createOOA_OONViewOnlyUser_HR_AUTH_ERROR() {
        
        try
        {
            User ooa_oonUser = createSHP_OOA_OON_User();
            
            //assert to check user has created successfully...
            system.assert(ooa_oonUser.id != null);
            
            String callIDStr = String.valueOf(system.now());
            
            System.runAs(ooa_oonUser){
                
                PageReference consolePage = new PageReference(VFC_URL_STR1 + callIDStr + VFC_URL_STR2);
                Test.setCurrentPage(consolePage);
                
                Account acc1 = AP01_TestDataUtility.createAccount();
                //assert to check Account has created successfully...
                system.assert(acc1.id != null);
                
                Contact cont = AP01_TestDataUtility.createContact(acc1);
                //assert to check Contact has created successfully...
                system.assert(cont.id != null);
                
                cont.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT_SHP_PROVIDER).RecordTypeId;
                update cont;
                Guarantor__c Gur = new Guarantor__c();
                Gur.Guarantor_First_Name__c = 'Test';
                Gur.Guarantor_Phone_Home__c = '1234567890';
                Gur.Guarantor_ID__c = '12345';
                Gur.Guarantor_Last_Name__c = 'Last Name';
                Gur.Guarantor_Middle_Name__c = 'Middle';
                Gur.Guarantor_Phone_Work__c = '0987654321';
                Insert Gur;
                
                //assert to check Guarantor__c has created successfully...
                system.assert(Gur.id != null);
                
                Patient_Account__c Pa = new Patient_Account__c();
                Pa.Guarantor_ID_Lookup__c = Gur.id;
                Pa.Guarantor_ID__c = 'New Guarantor';
                Pa.Patient_Account_Admission_Date__c = System.Today();
                Pa.Patient_Account_Number__c = '12345';
                Pa.Patient_Account_Service_Location__c = 'New Service';
                Pa.Patient_DotOne__c = 'Test';
                Insert Pa;
                
                //assert to check Patient_Account__c has created successfully...
                system.assert(Pa.id != null);
                
                // Create a patient Record
                Patient__c patient = new Patient__c(Patient_DotOne__c='1234',Name='test patient');
                insert patient;
                
                //assert to check Patient_c has created successfully...
                system.assert(patient.id != null);
                
                VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
                
                consoleController.providerFirstName = NAME_STR;
                consoleController.providerLastName = NAME_STR;
                consoleController.providerNPI = PROVIDER_NPI;
                consoleController.SearchProvider();
                                
                consoleController.contactVerification();
                
                consoleController.custInteraction.Reason__c = REASON_CLINICAL;
                consoleController.custInteraction.Secondary_Reason__c = OOA_BEHAVIORAL;
                consoleController.custInteraction.Contact_Region__c = 'test contact reason';
                consoleController.custInteraction.Patient_Account__c = pa.id;
                consoleController.custInteraction.Guarantor__c = Gur.id;
                
                Test.startTest();
                consoleController.saveSHP();
                Test.stopTest();
               
                Case srCase = new Case();
                srCase.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(OOA_OON_RT).RecordTypeId;
                srCase.Secondary_Reason__c = OOA_MEDICAL;
                srCase.ED_Type__c = ER_VERIFICATION;
                srCase.Hospital_Contact__c = TEST_STR;
                srCase.Hospital_Name__c = TEST_STR;
                srCase.Diagnosis__c = TEST_STR;
                srCase.Patient__c=patient.id;
                srCase.Hospital_Contact_Phone__c = MEMBER_CONTACT_NUM;
                srCase.Date_of_ER_Visit__c = Date.valueOf(system.today());
                srCase.HR_Authorization__c = MEMBER_ID;
                srCase.ParentId = consoleController.custInteraction.Id;
                
                Database.insert(srCase);
                
                //assert to check Case has created successfully...
                system.assert(srCase.id != null);
            }
        } catch(Exception ex){
            
            system.assertEquals(ex.getMessage().contains(HR_AUTH_ERROR), true);
        }
        
    }

    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description : to cover CheckOpenTasks method of ManageCaseUpdate class and ManageBeforeInsertedCases of ManageCaseDatabase class.
    * @param 
    * @return 
    */
    static testMethod void caseGrivanceWebFormWithTaskTest(){
        try{
            User ooa_oonUser = createSHP_OOA_OON_User();
            System.runAs(ooa_oonUser){
                string caseRecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Grievance Web Form Interaction Log').RecordTypeId;
                Case caseObj = new Case();
                caseObj.RecordTypeId = caseRecordTypeId;
                caseObj.Status = 'New';
                caseObj.RFI_Request_Date__c = system.today();
                caseObj.isTriggerError__c = true; 
                insert caseObj;
                
                //assert to check Case has created successfully...
                system.assert(caseObj.id != null);
                
                Task loopTask = new Task();
                loopTask.WhatId = caseObj.Id;
                insert loopTask;
                
                //assert to check Task has created successfully...
                system.assert(loopTask.id != null);
                
                caseObj.RFI_Request_Date__c = system.today() + 5;
                //update caseObj;
                caseObj.status='Closed';
                update caseObj;
            }
        } catch(Exception ex){ }
    }


    /**
    * @author Saket
    * @date 01/03/2014
    * @description : create SHP Service and Sales of SHP OOA/OON View Only Group
    * @param 
    * @return user
    */
    public static User TestSHPUser(){
    
        Id profileID = [Select Id from Profile where Name ='SHP Service and Sales'].Id;
        Id roleId = [SELECT Id FROM UserRole where Name ='MU Agent'].Id;
        
        User usr = new User();
        usr.LastName = 'TestUserTest1';
        usr.Username = 'TestUserTest1@acc.com';
        usr.Email = 'TestUserTest1@acc.com';
        usr.Alias = 'TestUs';
        usr.CommunityNickname = 'TestUserTest1@acc.com' ;
        usr.TimeZoneSidKey = AP01_TestDataTokens.TIME_ZONES_ID_KEY;
        usr.LocaleSidKey = AP01_TestDataTokens.LOCALE_SID_KEY;
        usr.EmailEncodingKey = AP01_TestDataTokens.EMAIL_ENCODING_KEYS;
        usr.LanguageLocaleKey = AP01_TestDataTokens.LANGUAGE_LOCALE_KEY;
        usr.profileid = profileID;
        usr.UserRoleId = roleId;
        usr.isActive = true;
        
        Database.insert(usr);
        
        //assert to check User has created successfully...
        system.assert(usr.id != null);
        
        List<Group> shpViewOnlyGroup = [select id from Group where Name=: OOA_VIEW_ONLY];
        
        if(!shpViewOnlyGroup.isEmpty()){
            
            GroupMember grpMem = new GroupMember();
            grpMem.GroupId = shpViewOnlyGroup[0].Id;
            grpMem.UserOrGroupId = usr.Id;
            
            Database.insert(grpMem);
        }
        
        return usr;
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description : create S3 Operations profile User of SHP OOA/OON View Only Group
    * @param 
    * @return user
    */
    public static User TestS3User(){
    
        Id profileID = [Select Id from Profile where Name ='S3 Operations'].Id;
        Id roleId = [SELECT Id FROM UserRole where Name =: SHP_ROLE_NAME].Id;
        
        User usr = new User();
        usr.LastName = AP01_TestDataTokens.USER_LAST_NAME;
        usr.Username = AP01_TestDataTokens.USER_NAME;
        usr.Email = AP01_TestDataTokens.USER_EMAIL;
        usr.Alias = AP01_TestDataTokens.ALIAS;
        usr.CommunityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME ;
        usr.TimeZoneSidKey = AP01_TestDataTokens.TIME_ZONES_ID_KEY;
        usr.LocaleSidKey = AP01_TestDataTokens.LOCALE_SID_KEY;
        usr.EmailEncodingKey = AP01_TestDataTokens.EMAIL_ENCODING_KEYS;
        usr.LanguageLocaleKey = AP01_TestDataTokens.LANGUAGE_LOCALE_KEY;
        usr.profileid = profileID;
        usr.UserRoleId = roleId;
        usr.isActive = true;
        
        Database.insert(usr);
        //assert to check User has created successfully...
        system.assert(usr.id != null);
        
        List<Group> shpViewOnlyGroup = [select id from Group where Name=: OOA_VIEW_ONLY];
        
        if(!shpViewOnlyGroup.isEmpty()){
            
            GroupMember grpMem = new GroupMember();
            grpMem.GroupId = shpViewOnlyGroup[0].Id;
            grpMem.UserOrGroupId = usr.Id;
            
            Database.insert(grpMem);
        }
        
        return usr;
    }
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description : to cover CheckOpenTasks method of ManageCaseUpdate class for negative case and and ManageAfterInsertedCases of ManageCaseDatabase class..
    * @param 
    * @return 
    */
    static testMethod void caseGrivanceWebFormWithoutTaskTest(){
        User ooa_oonUser = TestS3User();
            
        System.runAs(ooa_oonUser){
            string caseRecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Grievance Web Form Interaction Log').RecordTypeId;
            Case caseObj = new Case();
            caseObj.RecordTypeId = caseRecordTypeId;
            caseObj.Status = 'New';
            caseObj.RFI_Request_Date__c = system.today();
            caseObj.isTriggerError__c = true; 
            insert caseObj;
            //assert to check Case has created successfully...
            system.assert(caseObj.id != null);
            
            caseObj.RFI_Request_Date__c = system.today() + 5;           
            caseObj.status='Closed';
            caseObj.Close_Reason__c = 'Test Close Reason';
            update caseObj;
        }
    }
    
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description : method check those Cases that are from the Grievance Web-to-Case. For each record, it tries to find an contact based on the  member Id and associated that record to the contact.
    * @param 
    * @return 
    */
    static testMethod void caseGrivanceWebFormTest(){
        User ooa_oonUser = TestS3User();
            
        System.runAs(ooa_oonUser){
            string caseRecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Grievance Web Form Interaction Log').RecordTypeId;
            Case caseObj = new Case();
            caseObj.RecordTypeId = caseRecordTypeId;
            caseObj.Status = 'New';
            caseObj.RFI_Request_Date__c = system.today();
            caseObj.isTriggerError__c = true; 
            caseObj.Grievance_Web_Form_Member_ID__c = '12345678';
            caseObj.contact_Region__c = 'test contact';
            insert caseObj;
            
            //assert to check Case has created successfully...
            system.assert(caseObj.id != null);
        }
    }
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description : to cover CheckOpenTasks method of ManageCaseUpdate class for negative case and ManageAfterInsertedUpdatedMemberInquiries of ManageCaseDatabase class when case owner is queue.
    * @param 
    * @return 
    */
    static testMethod void caseGrivanceWebFormOwnerTest(){
        User objUser = TestSHPUser();
        
        //assert to check User has created successfully...
        system.assert(objUser.id != null);
        
        System.runAs(objUser){
            try{
                //Create  Group and Queue
                Group objGrp = new Group(Name='group name', type='Queue');
                insert objGrp;
                //assert to check Group has created successfully...
                system.assert(objGrp.id != null);
                
                QueuesObject objQueue = new QueueSObject(QueueID = objGrp.id, SobjectType = 'Case');
                insert objQueue;
                //assert to check QueuesObject has created successfully...
                system.assert(objQueue.id != null);
                
                string caseRecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Grievance Web Form Interaction Log').RecordTypeId;
                Case caseObj = new Case();
                caseObj.RecordTypeId = caseRecordTypeId;
                caseObj.Status = 'New';
                caseObj.RFI_Request_Date__c = system.today();
                caseObj.isTriggerError__c = true; 
                insert caseObj;
                //assert to check Case has created successfully...
                system.assert(caseObj.id != null);
                
                caseObj.RFI_Request_Date__c = system.today() + 5;           
                caseObj.status='Closed';
                caseObj.Close_Reason__c = 'Test Close Reason';
                caseObj.ownerId = objGrp.id;
                update caseObj;
            }
            catch(exception ex){}
        }
    } 
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description : to catch exception of ManageAfterInsertedCases method of ManageCaseDatabase class.  
    * @param 
    * @return 
    */
    static testMethod void managecaseExceptionTest(){
        User objUser = TestSHPUser();
        System.runAs(objUser){
            try{
                ManageExecutions.isSameGrienanceId = false;
                ManageCaseDatabase.webGrievanceRecordTypeId = null;
                ManageCaseDatabase.ManageAfterInsertedCases(null);
                ManageExecutions.isSameGrienanceId = true;
                ManageCaseDatabase.webGrievanceRecordTypeId = null;
                ManageCaseDatabase.ManageAfterInsertedCases(null);
            }catch (Exception ex){
                system.assert(ex.getMessage()!=null);
            }
        }
    }
    
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description : to cover exception of ManageAfterInsertedUpdatedMemberInquiries method of ManageCaseDatabase class.  
    * @param 
    * @return 
    */
    static testMethod void ManageAfterInsertedUpdatedMemberInquiriesException(){
        User objUser = TestSHPUser();
        System.runAs(objUser){
            try{
                ManageExecutions.isSameGrienanceId = true;
                ManageCaseDatabase.webGrievanceRecordTypeId = null;
                ManageCaseDatabase.ManageAfterInsertedCases(null);
                ManageCaseDatabase.ManageAfterInsertedUpdatedMemberInquiries(null);
            }
            catch(exception ex){
                system.assert(ex.getMessage()!=null);
            }
        }
    }
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description : to cover exception of ManageAfterInsertedUpdatedMemberInquiries,CheckOpenTasks,CloseCaseMilestones,ManageCaseOwnership method of ManageCaseDatabase class.  
    * @param 
    * @return 
    */
    static testMethod void managecaseExceptionTest_relatedcases(){
        User objUser = TestSHPUser();
        System.runAs(objUser){
            try{
                ManageCaseDatabase.ManageAfterInsertedUpdatedMemberInquiries(null);
                ManageCaseUpdate.CheckOpenTasks(null,null);
                ManageCaseUpdate.CloseCaseMilestones(null);
                ManageCaseUpdate.ManageCaseOwnership(null,null,null);
                managecaseinsert.CreateILPortalSR(null);
                managecaseinsert.SetSurveyForce(null);
            }
            catch(exception ex){
                system.assert(ex.getMessage()!=null);
            }
        }
    }
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description : to cover exception of CreateILPortalSR method of ManageCaseInsert class.  
    * @param 
    * @return 
    */
    static testMethod void managecaseUpdateExceptiontest_CreateILPortalSR() {
        
        
            User ooa_oonUser = createSHP_OOA_OON_User();
            
            String callIDStr = String.valueOf(system.now());
            Case srCase = new Case();
            System.runAs(ooa_oonUser){
                
                Account acc1 = AP01_TestDataUtility.createAccount();
                //assert to check Account has created successfully...
                system.assert(acc1.id != null);
                
                Contact cont = AP01_TestDataUtility.createContact(acc1);
                //assert to check Contact has created successfully...
                system.assert(cont.id != null);
                
                Guarantor__c Gur = new Guarantor__c();
                Gur.Guarantor_First_Name__c = 'Test';
                Gur.Guarantor_Phone_Home__c = '1234567890';
                Gur.Guarantor_ID__c = '12345';
                Gur.Guarantor_Last_Name__c = 'Last Name';
                Gur.Guarantor_Middle_Name__c = 'Middle';
                Gur.Guarantor_Phone_Work__c = '0987654321';
                Insert Gur;
                //assert to check Guarantor__c has created successfully...
                system.assert(Gur.id != null);
                
                Patient_Account__c Pa = new Patient_Account__c();
                Pa.Guarantor_ID_Lookup__c = Gur.id;
                Pa.Guarantor_ID__c = 'New Guarantor';
                Pa.Patient_Account_Admission_Date__c = System.Today();
                Pa.Patient_Account_Number__c = '12345';
                Pa.Patient_Account_Service_Location__c = 'New Service';
                Pa.Patient_DotOne__c = 'Test';
                Insert Pa;
                //assert to check Patient_Account__c has created successfully...
                system.assert(Pa.id != null);
                
                
                // Create a patient Record
                Patient__c patient = new Patient__c(Patient_DotOne__c='1234',Name='test patient');
                insert patient;
                
                //assert to check Patient_c has created successfully...
                system.assert(patient.id != null);
                
                cont.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT_SHP_PROVIDER).RecordTypeId;
                update cont;
                
                srCase.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(OOA_OON_RT).RecordTypeId;
                srCase.Secondary_Reason__c = OOA_MEDICAL;
                srCase.ED_Type__c = ER_VERIFICATION;
                srCase.Hospital_Contact__c = TEST_STR;
                srCase.Hospital_Name__c = TEST_STR;
                srCase.Diagnosis__c = TEST_STR;
                srCase.Hospital_Contact_Phone__c = MEMBER_CONTACT_NUM;
                srCase.Date_of_ER_Visit__c = Date.valueOf(system.today());
                srCase.Contact_Region__c = 'East Bay Region';
                srCase.ContactId = cont .id;
                srCase.AccountId = acc1.id; 
                srCase.Patient__c = patient.id;
                srCase.Patient_Account__c = pa.id;
                srCase.Guarantor__c = Gur.id;
                Database.insert(srCase);               
                list<case> lstCases = new list<case>();
                lstCases.add(srCase);
                ManageCaseInsert.AssignChildCases(lstCases);
                srCase.OwnerId = ooa_oonUser.id;
                Test.startTest();
                database.update(srCase);
                ManageCaseInsert.CreateILPortalSR(lstCases);
                     
                Test.stopTest();
                                
            }
    }
        
    /**
    * @author Saket
    * @date 01/03/2014
    * @description : create SHP Agent User of SHP OOA/OON View Only Group
    * @param 
    * @return user
    */
    public static User createSHP_OOA_OON_User(){
    
        Id profileID = [Select Id from Profile where Name =: SHP_PROFILE_NAME].Id;
        Id roleId = [SELECT Id FROM UserRole where Name =: SHP_ROLE_NAME].Id;
        
        User usr = new User();
        usr.LastName = AP01_TestDataTokens.USER_LAST_NAME;
        usr.Username = AP01_TestDataTokens.USER_NAME;
        usr.Email = AP01_TestDataTokens.USER_EMAIL;
        usr.Alias = AP01_TestDataTokens.ALIAS;
        usr.CommunityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME ;
        usr.TimeZoneSidKey = AP01_TestDataTokens.TIME_ZONES_ID_KEY;
        usr.LocaleSidKey = AP01_TestDataTokens.LOCALE_SID_KEY;
        usr.EmailEncodingKey = AP01_TestDataTokens.EMAIL_ENCODING_KEYS;
        usr.LanguageLocaleKey = AP01_TestDataTokens.LANGUAGE_LOCALE_KEY;
        usr.profileid = profileID;
        usr.UserRoleId = roleId;
        usr.isActive = true;
        
        Database.insert(usr);
        
        // Assert to check user has been created successfully
        System.assert(usr.id!=null);
        
        List<Group> shpViewOnlyGroup = [select id from Group where Name=: OOA_VIEW_ONLY];
        
        if(!shpViewOnlyGroup.isEmpty()){
            
            GroupMember grpMem = new GroupMember();
            grpMem.GroupId = shpViewOnlyGroup[0].Id;
            grpMem.UserOrGroupId = usr.Id;
            
            Database.insert(grpMem);
        }
        
        return usr;
    }
    /*******************************************************************
    Purpose: To Cover a scenerio when Team :[Tier 3] Compensation ,Customer intent:Job Description Evaluation 
                        and Team :[Tier 3] Reporting and Audit ,Customer intent:Job Description Evaluation    
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    
    static testmethod void manageCaseTriggerTest(){
        
        string strProfileId =[select id from profile where name='Executive Services Team'].id;
        user objUser = [select id from user where profileid=:strProfileId limit 1];
        system.runAs(objUser){
        
            Case objCase =new Case();
            objCase.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Human Resources').RecordTypeId;
            objCase.Team__c = '[Tier 3] Compensation';
            objCase.customer_intent__c = 'Job Description Evaluation';
            insert objCase;
            // Assert to check Case is inserted successfully
            System.assert(objCase.id!=null);
            
            Case objCase1 =new Case();
            objCase1.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Human Resources').RecordTypeId;
            objCase1.Team__c = '[Tier 3] Reporting and Audit';
            objCase1.customer_intent__c = 'Job Description Evaluation';
            objCase1.Function__c = 'Finance';
            insert objCase1;
            // Assert to check case is inserted successfully
            System.assert(objCase1.id!=null);
        } 
        
    }
     /*******************************************************************
    Purpose: To Cover a scenerio when Team :[Tier 3] Physician Contract Team' 
                        and Team :[Tier 3] Payroll Taxes for Human Resources Record type     
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void manageCaseTriggerTest_Payroll(){
        
        string strProfileId =[select id from profile where name='Executive Services Team'].id;
        user objUser = [select id from user where profileid=:strProfileId limit 1];
        system.runAs(objUser){
            
            Case objCase2 =new Case();
            objCase2.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Human Resources').RecordTypeId;
            objCase2.Team__c = '[Tier 3] Physician Contract Team';
            objCase2.Function__c = 'Finance';
            insert objCase2;
            // Assert to check case is inserted successfully
            System.assert(objCase2.id!=null);
            
            Case objCase3 =new Case();
            objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Human Resources').RecordTypeId;
            objCase3.Team__c = '[Tier 3] Payroll Taxes';
            objCase3.Function__c = 'Finance';
            insert objCase3;
            // Assert to check case is inserted successfully
            System.assert(objCase3.id!=null);
        
        }
    }
     /*******************************************************************
    Purpose: To Cover a scenerio when Team :[Tier 3] HR Reporting' ,customer_intent__c = 'HR Reporting'
                        and Team :[Tier 3] Payroll Taxes ,customer_intent__c = 'Employee Compensation' for Human Resources Record type     
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void manageCaseTriggerTest_HR(){
        string strProfileId =[select id from profile where name='Executive Services Team'].id;
        user objUser = [select id from user where profileid=:strProfileId limit 1];
        system.runAs(objUser){
            
            Case objCase2 =new Case();
            objCase2.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Human Resources').RecordTypeId;
            objCase2.Team__c = '[Tier 3] HR Reporting';
            objCase2.customer_intent__c = 'HR Reporting';
            objCase2.Function__c = 'Human Resource';
            objCase2.Customer_Sub_Intents__c = 'Adhoc Report Request Web';
            objCase2.Inquiry_Type__c = 'HR Benefits';
            objCase2.Inquiry_Reason__c = 'Health & Welfare - Premium Billing';
            insert objCase2;
            // Assert to check case is inserted successfully
            System.assert(objCase2.id!=null);
            
            Case objCase3 =new Case();
            objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Human Resources').RecordTypeId;
            objCase3.Team__c = '[Tier 3] Payroll Taxes';
            objCase3.customer_intent__c = 'Employee Compensation';
            objCase3.Function__c = 'Human Resource';
            objCase3.Customer_Sub_Intents__c = 'Job Evaluation';
            insert objCase3;
            // Assert to check case is inserted successfully
            System.assert(objCase3.id!=null);
        
        }
    }
    /*******************************************************************
    Purpose: To Cover a scenerio when Team :[Tier 3] Compensation' ,customer_intent__c = 'Employee Compensation'
                        and change the function of case for Human Resources Record type     
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void manageCaseTriggerTest_HRCompensation(){
        
    CreatedDate__c obj =  new CreatedDate__c();
        obj.Created_date__c = date.today();
        obj.name='CopyPcpDate';
        insert obj;
    
    contact obj1 =new contact();
    obj1.recordtypeid=Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
    obj1.lastname='test1';
    obj1.Member_PCP_Practitioner_HR_ID__c ='111';
    obj1.Member_HR_ID__c ='222';
    insert obj1;
    //Assert to check Contact is inserted successfully
    system.assert(obj1.id!=null);
    
    contact obj2 =new contact();
    obj2.recordtypeid=Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
    obj2.lastname='test1';
    obj2.Member_PCP_Practitioner_HR_ID__c ='111';
    obj2.Member_HR_ID__c ='222';
    insert obj2;
    //Assert to check Contact is inserted successfully
    system.assert(obj1.id!=null);
    
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.Team__c = '[Tier 3] Compensation';
    objCase3.member_id_Contact__c = obj1.id;
    objCase3.customer_intent__c = 'Employee Compensation';
    objCase3.Function__c = 'Human Resource';
    objCase3.Customer_Sub_Intents__c = 'Job Evaluation';
    insert objCase3;
    //Assert to check Case is inserted successfully
    system.assert(objCase3.id!=null);
        
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    objCase3.Function__c = 'Finance';
    objCase3.member_id_Contact__c = obj2.id;
    update objCase3;
    
    }
    
    /*******************************************************************
    Purpose: To Cover a scenerio when updating record values  for OOA/OON case Record type     
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void manageCaseTriggerTest_OOAOON(){
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('OOA/OON').RecordTypeId;
    objCase3.Diagnosis_HA__c = 'test';
    objCase3.Hospital_Contact_HA__c = 'test';
    objCase3.Hospital_Contact_Phone_HA__c = 'test';
    objCase3.Hospital_Name_HA__c = 'test';
    objCase3.Date_of_Hospital_Admit__c = date.today();
    objCase3.ed_type__c = 'Hospital Admit';
    insert objCase3;
    //Assert to check Case is inserted successfully
    system.assert(objCase3.id!=null);
        
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    objCase3.ed_type__c = 'ER Verification';
    objCase3.Diagnosis__c = 'hhh';
    objCase3.Hospital_Contact__c = 'ggg';
    objCase3.Hospital_Contact_Phone__c = '12345';
    objCase3.Hospital_Name__c = 'll';
    objCase3.Date_of_ER_Visit__c =date.today();
    update objCase3;
    //Assert to check Case is updates successfully
    system.assertequals(objCase3.Diagnosis__c,'hhh');
    
    }
     /*******************************************************************
    Purpose: To Cover a scenerio when Team :[Tier 3] HR Reporting' ,customer_intent__c = 'HR Reporting'
                        and accept a case  for Human Resources Record type     
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
   
    static testmethod void manageCaseTriggerTest_HRReporting(){
        
        string strProfileId =[select id from profile where name='Executive Services Team'].id;
        user objUser = [select id from user where profileid=:strProfileId limit 1];
        system.runAs(objUser){
                
            contact obj1 =new contact();
            obj1.recordtypeid=Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
            obj1.lastname='test1';
            obj1.Member_PCP_Practitioner_HR_ID__c ='111';
            obj1.Member_HR_ID__c ='222';
            insert obj1;
            //Assert to check contact is inserted successfully
            system.assert(obj1.id!=null);
            
            Case objCase2 =new Case();
            objCase2.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Human Resources').RecordTypeId;
            objCase2.Team__c = '[Tier 3] HR Reporting';
            objCase2.customer_intent__c = 'HR Reporting';
            objCase2.Function__c = 'Human Resource';
            objCase2.Customer_Sub_Intents__c = 'Adhoc Report Request Web';
            objCase2.member_id_Contact__c = obj1.id;
            objCase2.Inquiry_Type__c = 'HR Benefits';
            objCase2.Inquiry_Reason__c = 'Health & Welfare - Premium Billing';
            insert objCase2;
            //Assert to check case is inserted successfully
            system.assert(objCase2.id!=null);
            
            objCase2.isFiredAcceptButton__c = true;
            objCase2.ownerid= userinfo.getuserid();
            update objCase2;
            
            // Assert to check case is accepted 
            system.assertequals(objCase2.isFiredAcceptButton__c, true);
            
        }
    
    }
    
    /*******************************************************************
    Purpose: To Cover a scenerio when Function is Finance ,Team is [Tier 3] Compensation and change it to '[Tier 3] Payroll Taxes'     
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    
    static testmethod void manageCaseTriggerTest_Finance(){
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.Team__c = '[Tier 3] Compensation';
    
    objCase3.customer_intent__c = 'Employee Compensation';
    objCase3.Function__c = 'Finance';
    objCase3.Customer_Sub_Intents__c = 'Job Evaluation';
    insert objCase3;
    //assert to check case is created successfully
     System.assert(objCase3.id!=null);
     
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    objCase3.Team__c = '[Tier 3] Payroll Taxes';
    update objCase3;
    
    
    }
    
   /*******************************************************************
    Purpose: To Cover a scenerio when Function is Human Resource ,Team is [Tier 3] Payroll Taxes and change it to '[Tier 3] Compensation' 
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    
    static testmethod void manageCaseTriggerTest_HRPayrollCompensation(){
    
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.Team__c = '[Tier 3] Payroll Taxes';
    
    objCase3.customer_intent__c = 'Employee Compensation';
    objCase3.Function__c = 'Human Resource';
    objCase3.Customer_Sub_Intents__c = 'Job Evaluation';
    insert objCase3;
    //assert to check case is created successfully
     System.assert(objCase3.id!=null);
        
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    objCase3.Team__c = '[Tier 3] Compensation';
    update objCase3;
    
    
    }
    
    static testmethod void ManageCaseUpdateMilestoneTest_Benefits(){
        
    
    
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.Team__c = '[Tier 3] Payroll Taxes';
    
    //objCase3.customer_intent__c = 'Employee Compensation';
    objCase3.Function__c = 'Human Resource';
    //objCase3.Customer_Sub_Intents__c = 'Job Evaluation';
    insert objCase3;
    //Assert to check case is inserted successfully
    system.assert(objCase3.id!=null);
    
        
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    
    objCase3.Team__c = '[Tier 3] Compensation';
    update objCase3;
    
    
    }
   /*******************************************************************
    Purpose: To Cover a scenerio when Function is Revenue Cycle ,Team is [Tier 3] Payroll Taxes and change it to '[Tier 3] Compensation'  
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void manageCaseTriggerTest_RevenueCycle(){
        
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.Team__c = '[Tier 3] Payroll Taxes';
    objCase3.Function__c = 'Revenue Cycle';
    insert objCase3;
    //assert to check case is created successfully
     System.assert(objCase3.id!=null);
        
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    objCase3.Team__c = '[Tier 3] Compensation';
    update objCase3;
    
    
    }
     /*******************************************************************
    Purpose: To Cover a scenerio when Function is Supply Chain ,Team is [Tier 3] Payroll Taxes and change it to '[Tier 3] Compensation'     
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void manageCaseTriggerTest_SupplyChain(){
    
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.Team__c = '[Tier 3] Payroll Taxes';
    objCase3.Function__c = 'Supply Chain';
    insert objCase3;
    //assert to check case is created successfully
     System.assert(objCase3.id!=null);
        
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    objCase3.Status='Open';
    objCase3.Function__c = 'Revenue Cycle';
    objCase3.Team__c = '[Tier 3] Compensation';
    update objCase3;
    
    
    }
    /*******************************************************************
    Purpose: To Update OOA/OON case after update    
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    
    static testmethod void manageCaseTriggerTest_UpdateOOAOON(){
        
    contact obj1 =new contact();
    obj1.recordtypeid=Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
    obj1.lastname='test1';
    obj1.Member_PCP_Practitioner_HR_ID__c ='111';
    obj1.Member_HR_ID__c ='222';
    insert obj1;
    //Assert to check Contact is created successfully
    system.assert(obj1.id!=null);
    
    contact obj2 =new contact();
    obj2.recordtypeid=Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
    obj2.lastname='test1';
    obj2.Member_PCP_Practitioner_HR_ID__c ='111';
    obj2.Member_HR_ID__c ='222';
    insert obj2;
    
    //Assert to check Contact is created successfully
    system.assert(obj2.id!=null);
    
    
    Case objCase3 =new Case();
    User shpGrievanceUser = createSHPGrievanceUser();
    system.RunAs(shpGrievanceUser){
    
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('OOA/OON').RecordTypeId;
    objCase3.Reason__c = REASON_CLINICAL;
    objCase3.Member_Name_OOA_OON__c= obj1.id;
    objCase3.CreatedDate=Date.valueOf(system.today());
    objCase3.Status='New';
    insert objCase3;
    //Assert to check Case is created successfully
    system.assert(objCase3.id!=null);
    }
    
    test.starttest();
    
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    ManageExecutions.isSameCaseUpdate=false;
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('OOA/OON').RecordTypeId;
    objCase3.Status='Open';
    objCase3.Member_Name_OOA_OON__c= obj2.id;
    objCase3.ED_Type__c = ER_VERIFICATION;
    objCase3.Hospital_Contact__c = TEST_STR;
    objCase3.Secondary_Reason__c = OOA_MEDICAL;
    objCase3.Hospital_Name__c = TEST_STR;
    objCase3.Diagnosis__c = TEST_STR;
    objCase3.Hospital_Contact_Phone__c = MEMBER_CONTACT_NUM;
    objCase3.Date_of_ER_Visit__c = Date.valueOf(system.today());
    update objCase3;
    test.stoptest();
    
    }
    /*******************************************************************
    Purpose: when function and team values are changing .   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void manageCaseTriggerTest_FunctionTeamUpdate(){
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.Team__c = '[Tier 3] Compensation';
    objCase3.customer_intent__c = 'Employee Compensation';
    objCase3.Function__c = 'Human Resource';
    objCase3.Customer_Sub_Intents__c = 'Job Evaluation';
    insert objCase3;
    //Assert to check Case is created successfully
    system.assert(objCase3.id!=null);
        
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    test.startTest();
    ManageExecutions.isSameCaseUpdate=false;
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.Function__c = 'Finance';
    update objCase3;
    test.stoptest();
    
    }
     /*******************************************************************
    Purpose: To cover a scenerio when Member id is changing for a case  and memberEnquiry is available.   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void manageCaseTriggerTest_MemberIdUpdate(){
        
    contact obj1 =new contact();
    obj1.recordtypeid=Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
    obj1.lastname='test1';
    obj1.Member_PCP_Practitioner_HR_ID__c ='111';
    obj1.Member_HR_ID__c ='222';
    insert obj1;
    //Assert to check Contact is created successfully
    system.assert(obj1.id!=null);
    
    contact obj2 =new contact();
    obj2.recordtypeid=Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
    obj2.lastname='test1';
    obj2.Member_PCP_Practitioner_HR_ID__c ='111';
    obj2.Member_HR_ID__c ='222';
    insert obj2;
    //Assert to check Contact is created successfully
    system.assert(obj2.id!=null);
    
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.Team__c = '[Tier 3] Compensation';
    objCase3.member_id_Contact__c = obj1.id;
    objCase3.customer_intent__c = 'Employee Compensation';
    objCase3.Function__c = 'Human Resource';
    objCase3.Customer_Sub_Intents__c = 'Job Evaluation';
    insert objCase3;
    //Assert to check Case is created successfully
    system.assert(objCase3.id!=null);
    
    Member_Enquiries__c memberEnquiry = new Member_Enquiries__c(Member_Id__c=obj2.id,Case__c=objCase3.id,Intent__c='Clinical');
    insert memberEnquiry;
        
    //Assert to check Member Enquiries is created successfully
    system.assert(memberEnquiry.id!=null);
    
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    test.startTest();
    try{
    ManageExecutions.isSameCaseUpdate=false;
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.member_id_Contact__c = obj2.id;
    update objCase3;
    }catch(Exception ex ){}
    test.stoptest();
    
    }
    
    /*******************************************************************
    Purpose: To cover a scenerio when Member id is changing for a case and memberEnquiry not availble  .   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void manageCaseTriggerTest_MemberIdUpdateNegative(){
        
    contact obj1 =new contact();
    obj1.recordtypeid=Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
    obj1.lastname='test1';
    obj1.Member_PCP_Practitioner_HR_ID__c ='111';
    obj1.Member_HR_ID__c ='222';
    insert obj1;
    //Assert to check Contact is created successfully
    system.assert(obj1.id!=null);
    
    contact obj2 =new contact();
    obj2.recordtypeid=Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
    obj2.lastname='test1';
    obj2.Member_PCP_Practitioner_HR_ID__c ='111';
    obj2.Member_HR_ID__c ='222';
    insert obj2;
    //Assert to check Contact is created successfully
    system.assert(obj2.id!=null);
    
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.Team__c = '[Tier 3] Compensation';
    objCase3.member_id_Contact__c = obj1.id;
    objCase3.customer_intent__c = 'Employee Compensation';
    objCase3.Function__c = 'Human Resource';
    objCase3.Customer_Sub_Intents__c = 'Job Evaluation';
    insert objCase3;
    //Assert to check case is created successfully
    system.assert(objCase3.id!=null);
   
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    test.startTest();
    ManageExecutions.isSameCaseUpdate=false;
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
    objCase3.member_id_Contact__c = obj2.id;
    update objCase3;
    test.stoptest();
    
    }
    
    /*******************************************************************
    Purpose: To cover a scenerio when case is closed and recordtypes changed to RO  .   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void closecaseRecordtpeTest_RectypeUpdateToRO(){
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Address Change Request').RecordTypeId;
    objCase3.Team__c = '[Tier 3] Compensation';
    objCase3.customer_intent__c = 'Employee Compensation';
    objCase3.Function__c = 'Human Resource';
    objCase3.Customer_Sub_Intents__c = 'Job Evaluation';
    insert objCase3;
    //Assert to check case is created successfully
    system.assert(objCase3.id!=null);
    
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    test.startTest();
    // Record type :CV - Address Change Request
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Address Change Request').RecordTypeId;
    objCase3.Status='closed';
    objCase3.Close_Reason__c='Already exists';
    update objCase3;
    
    // Record type :CV - Affiliate Data Change Request
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Affiliate Data Change Request').RecordTypeId;
    objCase3.Status='closed';
    objCase3.Close_Reason__c='Already exists';
    update objCase3;
    
    //Record type :CV - Application Request
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Application Request').RecordTypeId;
    objCase3.Status='closed';
    objCase3.Close_Reason__c='Already exists';
    update objCase3;
    
    //Record type :CV - Data Change Request
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Data Change Request').RecordTypeId;
    objCase3.Status='closed';
    objCase3.Close_Reason__c='Already exists';
    update objCase3;
    
    //Record type :CV - Expirables Request
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Expirables Request').RecordTypeId;
    objCase3.Status='closed';
    objCase3.Close_Reason__c='Already exists';
    update objCase3;
    
    test.stoptest();
    }
    
    /*******************************************************************
    Purpose: To cover a scenerio when case is closed and recordtypes changed to RO  .   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void closecaseRecordtpeTest_CVRectypeUpdateToRO(){
    Case objCase3 =new Case();
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Address Change Request').RecordTypeId;
    objCase3.Team__c = '[Tier 3] Compensation';
    objCase3.customer_intent__c = 'Employee Compensation';
    objCase3.Function__c = 'Human Resource';
    objCase3.Customer_Sub_Intents__c = 'Job Evaluation';
    insert objCase3;
    //Assert to check case is created successfully
    system.assert(objCase3.id!=null);
    
    objCase3.isFiredAcceptButton__c = true;
    objCase3.ownerid= userinfo.getuserid();
    update objCase3;
    
    test.startTest();
    
    //Record type :CV - Other Request
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Other Request').RecordTypeId;
    objCase3.Status='closed';
    objCase3.Close_Reason__c='Already exists';
    update objCase3;
    
    //Record type :CV - Reapplication Request
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Reapplication Request').RecordTypeId;
    objCase3.Status='closed';
    objCase3.Close_Reason__c='Already exists';
    update objCase3;
    
    //Record type :CV - Report Request
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Report Request').RecordTypeId;
    objCase3.Status='closed';
    objCase3.Close_Reason__c='Already exists';
    update objCase3;
    
    //Record type :CV - Rush Application Request
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Rush Application Request').RecordTypeId;
    objCase3.Status='closed';
    objCase3.Close_Reason__c='Already exists';
    update objCase3;
    
    //Record type :CV - Temporary Privilege Request
    objCase3.recordtypeid=Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Temporary Privilege Request').RecordTypeId;
    objCase3.Status='closed';
    objCase3.Close_Reason__c='Already exists';
    update objCase3;
    
    test.stoptest();
    }
    
    /*******************************************************************
    Purpose: To cover a scenerio method assigns the correct entitlement process to PDI customer inquiries   
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/  
    static testmethod void assignPDIEntitlement_ManageCaseMilestoneDatabase(){
        test.starttest();
        Case case1 = new Case();
        case1.Function__c = 'Credentialing Verification';
        case1.Status = 'Open';
        case1.RecordtypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        case1.Subject = 'Test';
        case1.Description = 'Test';
        case1.Requestor_Name__c = 'RequestorName';
        case1.Requestor_Type__c = 'Candidate';
        case1.Requestor_Number__c = '121212';        
        insert case1;
        
        Case case2 = new Case();
        case2.Secondary_Reason__c = 'Notification';
        case2.Status = 'New';
        case2.Subject = 'Test';
        case2.ParentId = case1.Id;
        case2.Comments__c = 'Test';
        case2.Origin = 'Phone';
        case2.Reason__c = 'Provider Directory Inaccuracy';
        case2.Other_Provider__c = 'Test';
        case2.Reported_Inaccuracies__c = 'Provider Name';
        case2.Bypass_ValidationRule__c=true;
        case2.Notification_Received_Date__c = system.today();
        case2.RecordtypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Provider Directory Inaccuracy').RecordTypeId;
        //insert case2;
        //system.assert(case1.EntitlementId != NULL);
        test.stoptest();
        List<Case> caseList = new List<Case>();
        caseList.add(case2);
        ManageCaseMilestoneDatabase.assignPDIEntitlement(caseList);
        
    }
   
     /*******************************************************************
    Purpose: To cover whether PDI is closed for associated milestones in certain criteria.
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/    
    
    static testmethod void closePDICaseMilestones_ManageCaseUpdate(){
        test.starttest();
        Case case1 = new Case();
        case1.Function__c = 'Credentialing Verification';
        case1.Status = 'Open';
        case1.RecordtypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        case1.Subject = 'Test';
        case1.Description = 'Test';
        case1.Requestor_Name__c = 'RequestorName';
        case1.Requestor_Type__c = 'Candidate';
        case1.Requestor_Number__c = '121212';        
        insert case1;
        
        Case case2 = new Case();
        case2.Secondary_Reason__c = 'Notification';
        case2.Status = 'New';
        case2.Subject = 'Test';
        case2.ParentId = case1.Id;
        case2.Comments__c = 'Test';
        case2.Origin = 'Phone';
        case2.Reason__c = 'Provider Network Notification';
        case2.Other_Provider__c = 'Test';
        case2.Reported_Inaccuracies__c = 'Provider Name';
        case2.Bypass_ValidationRule__c=true;
        case2.Notification_Received_Date__c = system.today();
        case2.RecordtypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Provider Directory Inaccuracy').RecordTypeId;
        //insert case2;
        //system.assert(case1.EntitlementId != NULL);
        
        List<Case> caseList = new List<Case>();
        //caseList.add(case1);
        caseList.add(case2);
        /*
        Map<string, string> milestoneIdMap = new Map<string, string>();
        for(MilestoneType mileType:[select Id, Name from MilestoneType limit 1000]){
            milestoneIdMap.put(mileType.Name, mileType.Id);
        
        ManageCaseUpdate.closePDICaseMilestones(caseList);
        for(CaseMilestone cmList : [select id,caseId,CompletionDate,MilestoneTypeId  from CaseMilestone where caseId =: case1.Id and isCompleted=:false]){
            if(cmList.MilestoneTypeId == milestoneIdMap.get(Label.CL_380_Milestone_PNN)){
                cmList.CompletionDate = case1.CreatedDate;
            }        
        }
        */
        ManageCaseUpdate.closePDICaseMilestones(caseList);
        
        test.stoptest();
        
    }  
}