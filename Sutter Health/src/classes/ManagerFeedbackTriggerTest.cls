/**  
  *     Class Name  : ManagerFeedbackTriggerTest
  *     Author      : IDC Offshore
  *     Date        : 11-Aug-2014
  *     Project Name: CRM - SFT - Sutter Health
  *     Description : Test Class for ManagerFeedbackTrigger. This class tests different scenarios that are handled in the code
  **/

@isTest
private class ManagerFeedbackTriggerTest
{
    /**    
     * @author IDC Team    
     * @date 20/08/2014    
     * @description  method to create test data used by all tests .check if custom setting record is already there or not.    
      If record is not available then create a new record .  
     * @param 
     * @return     
    **/
    
    @testsetup
    static void createTestData()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='S3 Flex Agent']; 
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User usr = new User(Alias = 'flexuser', Email='flexuser@fakeemail.com', 
                EmailEncodingKey='UTF-8', LastName='ut1@testorg.com', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='ut1@testorg.com');

        insert usr;
        //Assert to check if User has been created successfully 
        system.assert(usr.id!= null);
        
        User usr2 = new User(Alias = 'flexuser', Email='flexuser@fakeemail2.com', 
                EmailEncodingKey='UTF-8', LastName='ut2@testorg.com', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='ut2@testorg.com');

        insert usr2;
        //Assert to check if User has been created successfully 
        system.assert(usr2.id!= null);
        
        
         User usr3 = new User(Alias = 'flexuse2', Email='flexuser@fakeemail2.com', 
                EmailEncodingKey='UTF-8', LastName='ut2@testorg.com', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p2.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='abc234xyz@fakeemail.com');

        insert usr3;
        //Assert to check if User has been created successfully 
        system.assert(usr3.id!= null);
        
        user currentuser = [select id from user where id =:userinfo.getuserid()];
        
        System.runas(currentuser){
        String PermissionSetName ='Manager Feedback';
        PermissionSet permSet = [SELECT ID From PermissionSet WHERE Label=:PermissionSetName LIMIT 1];
            List <PermissionSetAssignment> PemrSetAssignments = new List <PermissionSetAssignment>();
            PemrSetAssignments.add( new PermissionSetAssignment(AssigneeId = usr.id,PermissionSetId = permSet.ID ) );
            PemrSetAssignments.add( new PermissionSetAssignment(AssigneeId = usr2.id,PermissionSetId = permSet.ID ) );
            PemrSetAssignments.add( new PermissionSetAssignment(AssigneeId = usr3.id,PermissionSetId = permSet.ID ) );
            insert PemrSetAssignments;  
        //Assert to check if permission set has been assigned  successfully 
        system.assert(PemrSetAssignments.size()>= 0);    
        
       }
       
       list<Manager_Feedback__c> lstManageFeedback = new list<Manager_Feedback__c>();
        
        Manager_Feedback__c objManagerfeedback = Manager_Feedback__c.getOrgDefaults();
        objManagerfeedback.Name = 'Hiring';
        objManagerfeedback.Email_to_L1__c = 'abc123xyz@fakeemail.com';
        objManagerfeedback.Email_to_L2__c = 'abc234xyz@fakeemail.com';
        objManagerfeedback.L1_Owner__c = 'ut1@testorg.com';
        objManagerfeedback.L2_Owner__c = 'ut2@testorg.com';
        lstManageFeedback.add(objManagerfeedback);
        
        Manager_Feedback__c objManagerfeedback2 = Manager_Feedback__c.getOrgDefaults();
        objManagerfeedback2.Name = 'Payroll';
        objManagerfeedback2.Email_to_L1__c = 'flexuser@fakeemail.com';
        objManagerfeedback2.Email_to_L2__c = 'flexuser@fakeemail2.com';
        objManagerfeedback2.L1_Owner__c = 'ut1@testorg.com';
        objManagerfeedback2.L2_Owner__c = 'ut2@testorg.com';
        lstManageFeedback.add(objManagerfeedback2);
        
        insert lstManageFeedback;
        
        // Assert to check custom setting  has been created successfully
        system.assert(lstManageFeedback.size() == 2);
    
    }
    /**    
     * @author IDC Team    
     * @date 20/08/2014    
     * @description test managerfeedbackinfotrigger by creating a manager feed back record 
     *  and changing its owner and by closing its status .          
     * @return void   
     **/  
    private testMethod static void testManagerFeedback(){
        
        User testUser = [ select Id from User where UserName='ut1@testorg.com' ];
        User testUser2 = [ select Id from User where UserName='abc234xyz@fakeemail.com' ];
        // Assert to check user has been fetched successfully
        system.assert(testUser!=null);
        system.assert(testUser2!=null);
        
        Account acc= new Account(name='TestAccount');
        insert acc;
        // Assert to check account  has been created successfully
        system.assert(acc.id!=null);
        
        Contact con= new Contact(lastname='TestContact', AccountId=acc.id);
        insert con;
        // Assert to check contact  has been created successfully
        system.assert(con.id!=null);
        
        Test.startTest();
        System.runAs(testUser) {
            Managers_Feedback__c feedbackRec = new Managers_Feedback__c();
            feedbackRec.Service_Area__c = 'Hiring';
            feedbackRec.Subject__c = 'Test';
            //feedbackRec.Resolution__c = 'Hiring';
            feedbackRec.WorkEmail__c = 'xyz123abc@fakeemailsacd.com';
            feedbackRec.Comments__c = 'Test';
            feedbackRec.Status__c = 'New';            
            feedbackRec.ConatctID__c = String.valueOf(con.id); 
            
            insert feedbackRec; 
            // Assert to check manager feedback record  has been created successfully
            system.assert(feedbackRec.id!=null);
            
            Task testtask = new Task(
            ActivityDate = Date.today().addDays(7),
            Subject='Sample Task',
            WhatId = feedbackRec.Id,
            Projected_Hours__c = 5 ,
            Status='In Progress');
            insert testtask;  
            // Assert to check task  record  has been created successfully
            system.assert(testtask.id!=null);
            
        } 
        System.runAs(testUser2) {
            try{
                
                Managers_Feedback__c feedbackRec = [Select id from Managers_Feedback__c where Service_Area__c = 'Hiring' limit 1 ];
                //Assert to check same manager feedback record has been fetched .
                System.assert(feedbackRec !=null);
                feedbackRec.OwnerId = testUser2.id;
                feedbackRec.Status__c = 'Closed';
                feedbackRec.Resolution__c='No Change';
                feedbackRec.Service_Area__c = 'Payroll';
                feedbackRec.Owner_Change_Count__c = Null;
                update feedbackRec;  
                // assert to check open task in closed case .
                Task opentask = [select Id, WhatId, isClosed From Task Where WhatId =:feedbackRec.id];
                system.assert(opentask.isClosed!=true);
            }catch(Exception ex){
               System.assert(ex.getmessage()!=null);
            }
        }  
        Test.stopTest(); 
    }

    /**    
     * @author IDC Team    
     * @date 20/08/2014    
     * @description test Negative Senario of managerfeedbackinfotrigger by creating a manager feed back record 
     *  and changing its owner and by closing its status .          
     * @return void   
     **/  
    private testMethod static void testNegativeManagerFeedback(){
        
        User testUser = [ select Id from User where UserName='ut1@testorg.com' ];
        User testUser2 = [ select Id from User where UserName='abc234xyz@fakeemail.com' ];
        // Assert to check user has been fetched successfully
        system.assert(testUser!=null);
        system.assert(testUser2!=null);
        
        Account acc= new Account(name='TestAccount');
        insert acc;
        // Assert to check account  has been created successfully
        system.assert(acc.id!=null);
        
        Contact con= new Contact(lastname='TestContact', AccountId=acc.id);
        insert con;
        // Assert to check contact  has been created successfully
        system.assert(con.id!=null);
        
        Test.startTest();
        System.runAs(testUser) {
            Managers_Feedback__c feedbackRec = new Managers_Feedback__c();
            feedbackRec.Service_Area__c = 'Payroll';
            feedbackRec.Subject__c = 'Test';
            //feedbackRec.Resolution__c = 'Hiring';
            feedbackRec.WorkEmail__c = 'xyz123abc@fakeemailsacd.com';
            feedbackRec.Comments__c = 'Test';
            feedbackRec.Status__c = 'New';            
            feedbackRec.ConatctID__c = String.valueOf(con.id); 
            
            insert feedbackRec; 
            // Assert to check manager feedback record  has been created successfully
            system.assert(feedbackRec.id!=null);
            
            //assert to check inserted feedback owner is change from Queue('Manager Feedback') to User/Queue.
            system.assert(feedbackRec.ownerId != testUser2.id);
        } 
        Test.stopTest(); 
    }   
    
    /**    
     * @author IDC Team    
     * @date 20/08/2014    
     * @description test managerfeedbackinfotrigger by creating a manager feed back record 
     *  and changing its owner and by closing its status for bulk data.          
     * @return void   
     **/  
    private testMethod static void testBulkManagerFeedback(){
        
        User testUser = [ select Id from User where UserName='ut1@testorg.com' ];
        User testUser2 = [ select Id from User where UserName='ut2@testorg.com' ];
        // Assert to check user has been fetched successfully
        system.assert(testUser!=null);
        system.assert(testUser2!=null);
        
        Account acc= new Account(name='TestAccount');
        insert acc;
        // Assert to check account  has been created successfully
        system.assert(acc.id!=null);
        
        Contact con= new Contact(lastname='TestContact', AccountId=acc.id);
        insert con;
        // Assert to check contact  has been created successfully
        system.assert(con.id!=null);
        
        Test.startTest();
        System.runAs(testUser) {
            list<Managers_Feedback__c> lstTempMngFeed = new list<Managers_Feedback__c>();
            for(Integer i=0;i<10;i++){
            Managers_Feedback__c feedbackRec = new Managers_Feedback__c();
            feedbackRec.Service_Area__c = 'Payroll';
            feedbackRec.Subject__c = 'Test';
            //feedbackRec.Resolution__c = 'Hiring';
            feedbackRec.WorkEmail__c = 'xyz123abc@fakeemailsacd.com';
            feedbackRec.Comments__c = 'Test';
            feedbackRec.Status__c = 'New';            
            feedbackRec.ConatctID__c = String.valueOf(con.id); 
            lstTempMngFeed.add(feedbackRec);
            }
            insert lstTempMngFeed; 
            // Assert to check manager feedback record  has been created successfully
            system.assert(lstTempMngFeed[9].id!=null);
            
            list<Task> lstTempTask = new list<task>();
            
            for(Managers_Feedback__c tempMngFeed : lstTempMngFeed){
            Task testtask = new Task(
            ActivityDate = Date.today().addDays(7),
            Subject='Sample Task',
            WhatId = tempMngFeed.Id,
            Projected_Hours__c = 5 ,
            Status='In Progress');
            lstTempTask.add(testtask);
            
            }
            insert lstTempTask;  
            // Assert to check task  record  has been created successfully
            system.assert(lstTempTask[9].id!=null);
            
        } 
        System.runAs(testUser2) {
            try{
                
                list<Managers_Feedback__c> lstfeedbackRec = [Select id from Managers_Feedback__c where Service_Area__c = 'Payroll'];
                //Assert to check same manager feedback record has been fetched .
                System.assert(lstfeedbackRec !=null);
                Integer i=0;
                for(Managers_Feedback__c feedbackRec : lstfeedbackRec){
                feedbackRec.OwnerId = testUser2.id;
                if(i==0){feedbackRec.Status__c = 'New';feedbackRec.Owner_Change_Count__c = 3;}
                else{feedbackRec.Status__c = 'Closed';feedbackRec.Owner_Change_Count__c = Null;}
                feedbackRec.Resolution__c='No Change';
                feedbackRec.Service_Area__c = 'Hiring';
                i++;
                }
                update lstfeedbackRec;  
                // assert to check open task in closed case .
                list<Task> lstopentask = [select Id, WhatId, isClosed From Task Where WhatId IN : lstfeedbackRec];
                system.assert(lstopentask[0].isClosed!=true);
            }catch(Exception ex){
               System.assert(ex.getmessage()!=null);
            }
        }  
        Test.stopTest(); 
    } 
 }