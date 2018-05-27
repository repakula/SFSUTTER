/* 
Class Name: CaseAcceptButtonHelper_Test 
Author: IDC Offshore
Date: 22-Dec-2016
Description: Test class for CaseAcceptButtonHelper class.

History:
VERSION    AUTHOR              DATE        DETAIL 
1.0        Prerna Chandak      22-Dec-2016    Initial Creation.

*/
@isTest(SeeAllData = true)
private class CaseAcceptButtonHelper_Test{

    
    /*******************************************************************
    Purpose: Custom Accept Button scenario wherein Inquiry is already assigned to running user.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testmethod void ownerIsLoggedInUser_Test()
    {        
        
        /*
            If an inquiry is already assigned to running user, system will not allow user to accept the ticket from the queue.
        */
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'S3 Human Resources Agent'].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='S3 Tier 1 HR Agent'].Id;

        User testUser = new User(Alias = 'standt', Email='testUser1@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='testUser1@testmethod.com');
        insert testUser;

        Group hrGroup = [Select Id from Group Where DeveloperName ='Tier_1_HR_Recruitment' and type= 'Regular' LIMIT 1];
        
        //add user to Group
        GroupMember gm = new GroupMember();
        gm.groupId = hrGroup.ID;
        gm.userorGroupId = testUser.ID;
        insert gm;
        
        
        Case caseRec = new Case();
        system.runAs(testUser)
        {       
            Id recType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Human Resources').getRecordTypeId();
            System.assert(recType !=null);   
            
            //Note- We do not set assignment rule to fire, owner would be running user.
            
            caseRec.RecordTypeId = recType;
            caseRec.Function__c = 'Human Resource';
            caseRec.Sub_Function__c = 'Recruitment';
            caseRec.Team__c = '[Tier 1] HR Recruitment';
            caseRec.Customer_Intent__c = 'DMC Service Request';
            caseRec.Status = 'New';
            caseRec.Priority= 'Medium';
            caseRec.Subject = 'Testing';
            caseRec.Bypass_ValidationRule__c = true;
            insert caseRec;
            system.assert(caseRec.id!=null);
            
            //Query same inquiry
            Case insertedCase = [Select ID, OwnerId from Case where Id =: caseRec.Id];
            String userMessage = CaseAcceptButtonHelper.getGroupMembers(insertedCase.OwnerId);
            system.assertEquals(userMessage, Label.AcceptButtonLabel_A);
        }

    }
    
    /*******************************************************************
    Purpose: Custom Accept Button scenario wherein Inquiry is already assigned to other user.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testmethod void ownerIsOtherUser_Test()
    {        
        /*
            If an inquiry is already assigned to other user, system will not allow user to accept the ticket from the queue.
        */
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'S3 Human Resources Agent'].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='S3 Tier 1 HR Agent'].Id;

        User testUser = new User(Alias = 'standt', Email='testUser1@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='testUser1@testmethod.com');
        insert testUser;

        Group hrGroup = [Select Id from Group Where DeveloperName ='Tier_1_HR_Recruitment' and type= 'Regular' LIMIT 1];
        
        //add user to Group
        GroupMember gm = new GroupMember();
        gm.groupId = hrGroup.ID;
        gm.userorGroupId = testUser.ID;
        insert gm;
        
        
        Case caseRec = new Case();
        system.runAs(testUser)
        {       
            Id recType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Human Resources').getRecordTypeId();
            System.assert(recType !=null);   
            
            //Note- We do not set assignment rule to fire, owner would be running user.
            
            caseRec.RecordTypeId = recType;
            caseRec.Function__c = 'Human Resource';
            caseRec.Sub_Function__c = 'Recruitment';
            caseRec.Team__c = '[Tier 1] HR Recruitment';
            caseRec.Customer_Intent__c = 'DMC Service Request';
            caseRec.Status = 'New';
            caseRec.Priority= 'Medium';
            caseRec.Subject = 'Testing';
            caseRec.Bypass_ValidationRule__c = true;
            insert caseRec;
            system.assert(caseRec.id!=null);
            
            
        }
        
        //Query same inquiry
        Case insertedCase = [Select ID, OwnerId from Case where Id =: caseRec.Id];
        String userMessage = CaseAcceptButtonHelper.getGroupMembers(insertedCase.OwnerId);
        system.assertEquals(userMessage, Label.AcceptButtonLabel_B);

    }
    
    /*******************************************************************
    Purpose: Custom Accept Button scenario wherein user is added to the group.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testmethod void userIsAddedToGroup_Test()
    {        
        /*
            If an inquiry is assigned to queue and user is added to queue, system will allow user to accept the ticket from queue.
        */
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'S3 Human Resources Agent'].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='S3 Tier 1 HR Agent'].Id;

        User testUser = new User(Alias = 'standt', Email='testUser1@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='testUser1@testmethod.com');
        insert testUser;

        Group hrGroup = [Select Id from Group Where DeveloperName ='Tier_1_HR_Recruitment' and type= 'Regular' LIMIT 1];
        
        //add user to Group
        GroupMember gm = new GroupMember();
        gm.groupId = hrGroup.ID;
        gm.userorGroupId = testUser.ID;
        insert gm;
        
        
        Case caseRec = new Case();
        system.runAs(testUser)
        {       
            Id recType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Human Resources').getRecordTypeId();
            System.assert(recType !=null);   
            
            caseRec.RecordTypeId = recType;
            caseRec.Function__c = 'Human Resource';
            caseRec.Sub_Function__c = 'Recruitment';
            caseRec.Team__c = '[Tier 1] HR Recruitment';
            caseRec.Customer_Intent__c = 'DMC Service Request';
            caseRec.Status = 'New';
            caseRec.Priority= 'Medium';
            caseRec.Subject = 'Testing';
            caseRec.Bypass_ValidationRule__c = true;
            
            //Set the AssignmentRule
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
            caseRec.setOptions(dmlOpts);                
            
            insert caseRec;
            system.assert(caseRec.id!=null);
            
            //Query same inquiry
            Case insertedCase = [Select ID, OwnerId from Case where Id =: caseRec.Id];
            String userMessage = CaseAcceptButtonHelper.getGroupMembers(insertedCase.OwnerId);
            system.assertEquals(userMessage, Label.AcceptButtonLabel_C);
        }

    }

    
    /*******************************************************************
    Purpose: Custom Accept Button scenario wherein user is not added to group either directly or indirectly.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testmethod void userIsNotAddedToGroup_Test()
    {        
        /*
            If an inquiry is assigned to queue and user is not added to queue, system will not allow user to accept the ticket from queue.
        */
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'S3 Human Resources Agent'].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='S3 Tier 3 HR Agent'].Id;

        User testUser = new User(Alias = 'standt', Email='testUser1@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='testUser1@testmethod.com');
        insert testUser;

        Case caseRec = new Case();
        system.runAs(testUser)
        {       
            Id recType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Human Resources').getRecordTypeId();
            System.assert(recType !=null);   

            caseRec.RecordTypeId = recType;
            caseRec.Function__c = 'Human Resource';
            caseRec.Sub_Function__c = 'Recruitment';
            caseRec.Team__c = '[Tier 3] Recruitment';
            caseRec.Customer_Intent__c = 'DMC Service Request';
            caseRec.Status = 'New';
            caseRec.Priority= 'Medium';
            caseRec.Subject = 'Testing';
            caseRec.Bypass_ValidationRule__c = true;
            
            //Set the AssignmentRule
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
            caseRec.setOptions(dmlOpts);                
            
            insert caseRec;
            system.assert(caseRec.id!=null);
        }
        
        //Query same inquiry
        Case insertedCase = [Select ID, OwnerId from Case where Id =: caseRec.Id];
        system.runAs(testUser)
        {       
            String userMessage = CaseAcceptButtonHelper.getGroupMembers(insertedCase.OwnerId);
            system.assertEquals(userMessage, Label.AcceptButtonLabel_E);
        }
            
    }
    
    /*******************************************************************
    Purpose: Custom Accept Button scenario where user role is added to the group 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testmethod void userRoleIsAddedToGroup_Test()
    {        
        /*
            If an inquiry is assigned to queue and user role is  added to queue, system will  allow user to accept the ticket from queue.
        */
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'S3 Human Resources Agent'].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='S3 Tier 1 HR Agent'].Id;

        User testUser = new User(Alias = 'standt', Email='testUser1@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole, TimeZoneSidKey='America/Los_Angeles', UserName='testUser1@testmethod.com');
        insert testUser;

        Group hrGroup = [Select Id from Group Where DeveloperName ='Tier_1_HR_Recruitment' and type= 'Regular' LIMIT 1];
        
        Case caseRec = new Case();
        system.runAs(testUser)
        {       
            Id recType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Human Resources').getRecordTypeId();
            System.assert(recType !=null);   

            caseRec.RecordTypeId = recType;
            caseRec.Function__c = 'Human Resource';
            caseRec.Sub_Function__c = 'Recruitment';
            caseRec.Team__c = '[Tier 1] HR Recruitment';
            caseRec.Customer_Intent__c = 'DMC Service Request';
            caseRec.Status = 'New';
            caseRec.Priority= 'Medium';
            caseRec.Subject = 'Testing';
            caseRec.Bypass_ValidationRule__c = true;
            
            //Set the AssignmentRule
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
            caseRec.setOptions(dmlOpts);                
            
            insert caseRec;
            system.assert(caseRec.id!=null);
            
            //Query same inquiry
            Case insertedCase = [Select ID, OwnerId from Case where Id =: caseRec.Id];
            String userMessage = CaseAcceptButtonHelper.getGroupMembers(insertedCase.OwnerId);
            system.assertEquals(userMessage, Label.AcceptButtonLabel_C);
        }
        
    }
    
    /*******************************************************************
    Purpose: Custom Accept Button scenario wherein user is in top hierarchy 
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testmethod void userInRoleHeirarchy_Test()
    {        
        
        /*
            If an inquiry is assigned to queue and user is top in the hierarchy, system will allow user to accept the ticket from queue.
        */
        
        Id agentProfileId = [SELECT Id FROM Profile WHERE Name = 'S3 Human Resources Agent'].Id;
        Id agentRole =  [SELECT Id FROM UserRole WHERE Name='S3 Tier 1 HR Agent'].Id;

        User agentUser = new User(Alias = 'standt', Email='agentUser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = agentProfileId, UserRoleId = agentRole, TimeZoneSidKey='America/Los_Angeles', UserName='agentUser@testmethod.com');
        insert agentUser;
        
        Group hrGroup = [Select Id from Group Where DeveloperName ='Tier_1_HR_Recruitment' and type= 'Regular' LIMIT 1];
        
        //add user to Group
        GroupMember gm = new GroupMember();
        gm.groupId = hrGroup.ID;
        gm.userorGroupId = agentUser.ID;
        insert gm;
        
        
        Case caseRec = new Case();
        system.runAs(agentUser)
        {       
            Id recType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Human Resources').getRecordTypeId();
            System.assert(recType !=null);   

            caseRec.RecordTypeId = recType;
            caseRec.Function__c = 'Human Resource';
            caseRec.Sub_Function__c = 'Recruitment';
            caseRec.Team__c = '[Tier 1] HR Recruitment';
            caseRec.Customer_Intent__c = 'DMC Service Request';
            caseRec.Status = 'New';
            caseRec.Priority= 'Medium';
            caseRec.Subject = 'Testing';
            caseRec.Bypass_ValidationRule__c = true;
            //Set the AssignmentRule
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
            caseRec.setOptions(dmlOpts);       
            
            insert caseRec;
            system.assert(caseRec.id!=null);
        }
        
        
        // Log in as manager and check access
        Id managerProfileId = [SELECT Id FROM Profile WHERE Name = 'S3 Human Resources Agent'].Id;
        Id managerRole =  [SELECT Id FROM UserRole WHERE Name='S3 HR Management'].Id;

        User managerUser = new User(Alias = 'standt', Email='managerUser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = managerProfileId, UserRoleId = managerRole, TimeZoneSidKey='America/Los_Angeles', UserName='managerUser@testmethod.com');
        insert managerUser;

        system.runAs(managerUser)
        { 
            //Query same inquiry
            Case insertedCase = [Select ID, OwnerId from Case where Id =: caseRec.Id];
            String userMessage = CaseAcceptButtonHelper.getGroupMembers(insertedCase.OwnerId);
            system.assertEquals(userMessage, Label.AcceptButtonLabel_D);
        } 

    }


    
    /*******************************************************************
    Purpose: Custom Accept Button scenario wherein logged in user has no access to edit the record
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testmethod void userHasNoEdit_Test()
    { 
        /*
            If an inquiry is assigned to queue and user has not profile access to Edit the record, system will not allow user to accept the ticket from queue.
        */
        
        Id agentProfileId = [SELECT Id FROM Profile WHERE Name = 'S3 Human Resources Agent'].Id;
        Id agentRole =  [SELECT Id FROM UserRole WHERE Name='S3 Tier 1 HR Agent'].Id;

        User agentUser = new User(Alias = 'standt', Email='agentUser@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = agentProfileId, UserRoleId = agentRole, TimeZoneSidKey='America/Los_Angeles', UserName='agentUser@testmethod.com');
        insert agentUser;
        
        Group hrGroup = [Select Id from Group Where DeveloperName ='Tier_1_HR_Recruitment' and type= 'Regular' LIMIT 1];
        
        //add user to Group
        GroupMember gm = new GroupMember();
        gm.groupId = hrGroup.ID;
        gm.userorGroupId = agentUser.ID;
        insert gm;
        
        
        Case caseRec = new Case();
        system.runAs(agentUser)
        {       
            Id recType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Human Resources').getRecordTypeId();
            System.assert(recType !=null);   

            caseRec.RecordTypeId = recType;
            caseRec.Function__c = 'Human Resource';
            caseRec.Sub_Function__c = 'Recruitment';
            caseRec.Team__c = '[Tier 1] HR Recruitment';
            caseRec.Customer_Intent__c = 'DMC Service Request';
            caseRec.Status = 'New';
            caseRec.Priority= 'Medium';
            caseRec.Subject = 'Testing';
            caseRec.Bypass_ValidationRule__c = true;
            //Set the AssignmentRule
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
            caseRec.setOptions(dmlOpts);       
            
            insert caseRec;
            system.assert(caseRec.id!=null);
        }
        
        //login as lead user and check the access
        Id callCenterLeadId = [SELECT Id FROM Profile WHERE Name = 'S3 Call Center Lead'].Id;
        Id callCenterLeadRole =  [SELECT Id FROM UserRole WHERE Name='Sutter Shared Services'].Id;

        User leadUser = new User(Alias = 'standt', Email='testUser1@testmethod.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = callCenterLeadId, UserRoleId = callCenterLeadRole, TimeZoneSidKey='America/Los_Angeles', UserName='testUser1@testmethod.com');
        insert leadUser;
        
        system.runAs(leadUser)
        { 
            //Query same inquiry
            Case insertedCase = [Select ID, OwnerId from Case where Id =: caseRec.Id];
            String userMessage = CaseAcceptButtonHelper.getGroupMembers(insertedCase.OwnerId);
            system.assertEquals(userMessage, Label.AcceptButtonLabel_G);
        } 

    }
}