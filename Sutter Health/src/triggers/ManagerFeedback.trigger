/**  
s   Trigger Name  : ManagerFeedback
*     Author      : Manish
*     Date        : 07-Aug-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : Written to update Status on Owner change from Queue('Manager Feedback') to User/Queue. 
*                   Also sends an email to owner for notification. 
**/

trigger ManagerFeedback on Managers_Feedback__c (before insert, before update) {
    
     
    private static final String CLOSED_STATUS = 'Closed';
    
    private static final String WHATID = 'WhatId';
    private static final string SUB1= 'Manager Feedback Item';
    private static final string BLANK_STRING_MAIL = '';
    private static final String  HTML_BODY1 = '<html><body>Hello ';
    private static final String  HTML_BODY2 = '<br/><br/> You have been assigned a new Manager Feedback item.';
    private static final String  HTML_BODY3 = ' <br/> To view the item click here ';
    private static final String  HTML_BODY4 = '<br/><br/>Thank you,';
    private static final String  HTML_BODY5 = '<br/> S3 Leadership Team';
    private static final String  HTML_BODY8 = '</body></html>';
    private static final String OPEN_TASK_ERROR = 'This Manager Feedback Item cannot be closed because all of the tasks are not completed';
    private static final String CHANGE_OWNER_ERROR = 'You cannot change the service area more than 2 times';

    
    /** @ Description: List used to store Tasks associated to the Cases.**/
    List<Task> openTasks = new List<Task>();
    
    OrgWideEmailAddress[] orgDefEmail = [select Id from OrgWideEmailAddress where Address = 'salesforce@sutterhealth.org' limit 1]; 

    //Before Insert condition to update L1 and L2 owner Name and email information in object.
    //Also assigns ownr as a Queue or user.     
    if(Trigger.isInsert && Trigger.isBefore)
    {
        Map<String, Manager_Feedback__c> managerFeedbackCustSettMap = Manager_Feedback__c.getAll();
        String REPLACE_STRING = '\\s+';
        String BLANK_STRING = '';                
        String emailAddressL1 = null;
        String emailAddressL2 = null;        
        String ownerNameL2 = null;
        String QUEUENAME ='Manager Feedback';  
        String PermissionSetName ='Manager Feedback';
        String EXEPTION_MSG1 = '--------------';   
        String EXEPTION_MSG = '\r\n';  
        
        //Get Permission Set for later use
        PermissionSet ps = [SELECT Id, Name, Label from PermissionSet where Label=:PermissionSetName LIMIT 1];
        
        for(Managers_Feedback__c managerFeedback : Trigger.new)
        {
            String serviceAreaStr =  managerFeedback.Service_Area__c;
            String serviceAreaTrimmed = serviceAreaStr.replaceAll(REPLACE_STRING, BLANK_STRING);
            User ownerRec;
            
            managerFeedback.Owner_Change_Count__c = 0;
            
            if(managerFeedbackCustSettMap.containsKey(serviceAreaTrimmed))
            {
                if(managerFeedbackCustSettMap.get(serviceAreaTrimmed).L1_Owner__c != null)
                {            
                    managerFeedback.L1_Owner__c = managerFeedbackCustSettMap.get(serviceAreaTrimmed).L1_Owner__c;
                }
                
                if(managerFeedbackCustSettMap.get(serviceAreaTrimmed).Email_to_L1__c != null)
                {
                    emailAddressL1 = managerFeedbackCustSettMap.get(serviceAreaTrimmed).Email_to_L1__c;
                    managerFeedback.Email_to_L1__c = emailAddressL1 ;               
                }
                    
                ownerNameL2 = managerFeedbackCustSettMap.get(serviceAreaTrimmed).L2_Owner__c;                                
                if(ownerNameL2 != null)
                { 
                    ownerNameL2 = ownerNameL2.trim();           
                    managerFeedback.L2_Owner__c = ownerNameL2 ;
                }
                
                if(managerFeedbackCustSettMap.get(serviceAreaTrimmed).Email_to_L2__c  != null)
                {            
                    emailAddressL2 = managerFeedbackCustSettMap.get(serviceAreaTrimmed).Email_to_L2__c;
                    emailAddressL2 = emailAddressL2.trim();
                    managerFeedback.Email_to_L2__c = emailAddressL2;                     
                }
          
                if(ownerNameL2 != null && emailAddressL2 != null)
                {
                    //get all the users by name L2 Owner
                    List<User> users = [SELECT Id,Email,Username,( SELECT Id,PermissionSetId FROM PermissionSetAssignments) FROM User WHERE Name =: ownerNameL2];
                    for( User u: users)
                    {
                        for(PermissionSetAssignment psa: u.PermissionSetAssignments)
                        {
                            system.debug('@@psa.PermissionSetId : '+ psa.PermissionSetId);
                            system.debug('@@ps.Id : '+ ps.Id);
                            system.debug('@@u.username : '+ u.username);
                            system.debug('@@emailAddressL2 : '+ emailAddressL2);
                            if(psa.PermissionSetId == ps.Id && u.username.contains(emailAddressL2))
                            {
                                system.debug('Hello');
                                ownerRec= u;
                            }
                        }
                    }
                }
            }              
            
            try{
                system.debug(' ownerRec ='+ ownerRec );                                   
                if(ownerRec != null){                           
                    managerFeedback.ownerId = ownerRec.id ;                                            
                }else{
                    List<Group> queueRecords = [select id from Group where Name =: QUEUENAME AND Type =: 'Queue' limit 1]; 
                    if(queueRecords != null && queueRecords.size() > 0){
                        managerFeedback.ownerId = queueRecords.get(0).id;                     
                    }               
                }               
            }catch(Exception ownerException){
                Utility.handleExceptionFromCode(ownerException.getMessage() + EXEPTION_MSG + ownerException.getStackTraceString() + EXEPTION_MSG  + ownerException.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
            } 
        }          
    }

     //Before Update condition to change status from 'New' to 'In Progress'.
     //Also sends email to owners.     
     if(Trigger.isUpdate && Trigger.isBefore)
     {
        
         String ownerNameL2 = null;
         String PermissionSetName ='Manager Feedback';
         String REPLACE_STRING = '\\s+';
         String BLANK_STRING = '';
         String emailAddressL2 = null;
         String QUEUENAME ='Manager Feedback';
         String EXEPTION_MSG1 = '--------------';   
         String EXEPTION_MSG = '\r\n';
         
         PermissionSet ps = [SELECT Id, Name, Label from PermissionSet where Label=:PermissionSetName LIMIT 1];
         
         /** @ Description: As part of CR : List to get all teh custom settings data for Manager Feedback **/
         Map<String, Manager_Feedback__c> managerFeedbackCustSettMap = Manager_Feedback__c.getAll();
         
         List<Managers_Feedback__c> listOfRecords = new List<Managers_Feedback__c>();
         Map<Id,Id> recordUserIdMap = new Map<Id,Id>();
         
         for(Managers_Feedback__c feedbackNewRec : Trigger.new)
         {
            Managers_Feedback__c feedbackOldRec = Trigger.oldMap.get(feedbackNewRec.id);
            /** @ Description: As part of CR : Assign Owner on Service Area Change **/
            if(feedbackNewRec.Service_Area__c <> feedbackOldRec.Service_Area__c)
            {
                if(feedbackNewRec.Owner_Change_Count__c == null)
                {
                    feedbackNewRec.Owner_Change_Count__c = 0;
                }
                feedbackNewRec.Owner_Change_Count__c = feedbackNewRec.Owner_Change_Count__c + 1;
                if(feedbackNewRec.Owner_Change_Count__c <= 2)
                {
                    String serviceAreaStr =  feedbackNewRec.Service_Area__c;
                    String serviceAreaTrimmed = serviceAreaStr.replaceAll(REPLACE_STRING, BLANK_STRING);
                    User ownerRec;
                    
                    if(managerFeedbackCustSettMap.containsKey(serviceAreaTrimmed))
                    {
                    
                        ownerNameL2 = managerFeedbackCustSettMap.get(serviceAreaTrimmed).L2_Owner__c;                                
                        if(ownerNameL2 != null)
                        { 
                            ownerNameL2 = ownerNameL2.trim();
                        }
                        
                        if(managerFeedbackCustSettMap.get(serviceAreaTrimmed).Email_to_L2__c  != null)
                        {            
                            emailAddressL2 = managerFeedbackCustSettMap.get(serviceAreaTrimmed).Email_to_L2__c;
                            emailAddressL2 = emailAddressL2.trim();                   
                        }
                  
                        if(ownerNameL2 != null && emailAddressL2 != null)
                        {
                            List<User> users = [SELECT Id,Email,Username,( SELECT Id,PermissionSetId FROM PermissionSetAssignments) FROM User WHERE Name =: ownerNameL2];
                            for( User u: users)
                            {
                                for(PermissionSetAssignment psa: u.PermissionSetAssignments)
                                {
                                    if(psa.PermissionSetId == ps.Id && u.username.contains(emailAddressL2))
                                    {
                                        ownerRec= u;
                                    }
                                }
                            }
                        }
                    }              
                    
                    try{
                        system.debug(' ownerRec ='+ ownerRec );                                   
                        if(ownerRec != null){                           
                            feedbackNewRec.ownerId = ownerRec.id ;                                          
                        }             
                    }catch(Exception ownerException){
                        Utility.handleExceptionFromCode(ownerException.getMessage() + EXEPTION_MSG + ownerException.getStackTraceString() + EXEPTION_MSG  + ownerException.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
                    }
                }
                else
                {
                    feedbackNewRec.addError(CHANGE_OWNER_ERROR);
                }
            }
            
             if(feedbackOldRec.ownerId != feedbackNewRec.ownerId)
             { 
                 String queuesObjectType='Managers_Feedback__c';
                 //If old record's ownerId matches current user id then allow execution.
                 if(feedbackNewRec.Status__c == 'New')
                 {               
                     feedbackNewRec.Status__c = 'In Progress';
                 }
                 
                 listOfRecords.add(feedbackNewRec);
                 recordUserIdMap.put(feedbackNewRec.id, feedbackNewRec.OwnerId);
              }
            
            if(recordUserIdMap != null && recordUserIdMap.size() > 0 )
            {
                if(listOfRecords != null && listOfRecords.size() > 0)
                {           
                    SendManagerFeedbackEmail sendFeedbackEmail = new SendManagerFeedbackEmail();
                    sendFeedbackEmail.sendMail(listOfRecords,recordUserIdMap);                     
                }                
            }
            
            if(feedbackNewRec.Status__c == CLOSED_STATUS)
            {
                
                /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
                try{
                
                    /** @ Description: SOQL call to retrieve the Tasks associated to the Case.**/
                    openTasks = [select Id, WhatId, isClosed From Task Where WhatId In :Trigger.new]; 
                } catch(Exception triggerException) {
                    Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                }
            }
        }
        
        if(!openTasks.isEmpty())
        {
            /** @ Description: Iterate over the list of Tasks to see if they are not closed.**/
            for (Task loopTask: openTasks) 
            {
                if(!loopTask.isClosed)
                {
                    Id mfId = (Id) loopTask.get(WHATID);
            
                    /** @ Description: If any Tasks are not closed, it adds an error that does not allow DML operation to occur**/
                    Managers_Feedback__c errorMF = Trigger.newMap.get(mfId);
                    
                    /** @ Description: Error Message to  be displayed when there is a case error**/
                    errorMF.addError(OPEN_TASK_ERROR); 
                }
            }
        }
    }
}