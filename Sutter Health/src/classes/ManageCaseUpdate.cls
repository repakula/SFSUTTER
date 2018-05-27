/**  
*    Class Name: ManageCaseUpdate
*    Author: Brandon Cassis
*    Date: 1-September-2013
*    Description: This class is used to perform operations on Case Updates. There are methods for stopping
*                    the closing of Cases with Tasks, closing all CaseMilestones, and controlling the Ownership
*                    of classes to insure they are not assigned to queues of the wrong Line of Business.
*    History
    VERSION    AUTHOR              DATE        DETAIL
     1.1     Prerna Chandak     06/28/2016    REQ 3835-Added method closePDICaseMilestones that takes in a list of cases and updates the completion date on Milestone for PDI.
*    --------
**/
public class ManageCaseUpdate {

    /*******************************************************************
    Purpose: This method accepts a list of Cases along with there new status. If a Case
             has tasks that are open, it adds an error to prevent the Case from closing.
    Parameters: List<Case> inputList, Map<Id, Case> newMap
    Returns: none 
    Throws [Exceptions]: TriggerException
    ********************************************************************/
    
    public static void CheckOpenTasks(List<Case> inputList, Map<Id, Case> newMap) {
        
        /** @ Description: List used to store Tasks associated to the Cases.**/
        List<Task> openTasks = new List<Task>();

        /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
        try{
        
            /** @ Description: SOQL call to retrieve the Tasks associated to the Case.**/
            openTasks = [select Id, WhatId, isClosed From Task Where WhatId In :inputList]; 
        } catch(Exception triggerException) {
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        
        /** @ Description: Iterate over the list of Tasks to see if they are not closed.**/
        for (Task loopTask: openTasks) {
            if(!loopTask.isClosed){
                Id caseId = (Id) loopTask.get('WhatId');
        
                /** @ Description: If any Tasks are not closed, it adds an error that does not allow DML operation to occur**/
                Case errorCase = newMap.get(caseId);
                errorCase.isTriggerError__c = true;
                /** @ Description: Error Message to  be displayed when there is a case error**/
                errorCase.addError('This case cannot be closed because not all of the tasks are completed'); 
            }
        }
    }
    
    
    /*******************************************************************
    Purpose: This method accepts a list of Cases. If a Case CaseMilestones that are open,
             the method closes all of the CaseMilestones.
    Parameters: List<Case> inputListCases, Map<Id, Case> oldMap,  Map<Id, Case> newMap
    Returns: none 
    Throws [Exceptions]: TriggerException
    ********************************************************************/
    
    public static void CloseCaseMilestones(List<Case> inputListCases) {
        
        /** @ Description: List used to store CaseMilstones associated to the Cases.**/
        List<CaseMilestone> milestoneToClose = new List<CaseMileStone>();
        
        /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
        try{
        
             /** @ Description: SOQL to get Case Milestones associated to the Case. **/
            milestoneToClose = [select Id, CaseId, CompletionDate, isCompleted From CaseMilestone Where CaseId IN :inputListCases AND isCompleted = false];
        } catch(Exception triggerException) {
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        
        /** @ Description: Sets CaseMilestanes to close by entering the time into the completion DateTime.**/
        for(CaseMilestone loopCM: milestoneToClose) {
            loopCM.CompletionDate = System.Now();
        }
        
         /** @ Description: Try Catch to protect the user from errors in the DML call.**/
        try{
            
            /** @ Description: DML opperation to update newly closed CaseMilestones.**/
            Update milestoneToClose;
        } catch(Exception triggerException) {
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }  
    }
    
    
     
    /*******************************************************************
    Purpose: REQ 3835- To close PDI associated milestones in certain criteria.
    Parameters: List<Case>
    Returns: none 
    Throws [Exceptions]: TriggerException
    ********************************************************************/
    
    public static void closePDICaseMilestones(List<Case> inputListCases) {
        
        /** @ Description: List used to store CaseMilstones associated to the Cases.**/
        
        Map<Id,Case> objCaseMapParent = new Map<Id,Case>();
        Map<id,Case> objCaseUpdateMilestoneMap= new Map<id,Case>();
        Map<string, string> milestoneIdMap = new Map<string, string>();
        
            for(MilestoneType mileType:[select Id, Name from MilestoneType limit 1000])
            {
                milestoneIdMap.put(mileType.Name, mileType.Id);
            }
            
            For(Case c: inputListCases){
                
                if(c.ParentId != NULL){
                    objCaseMapParent.put(c.ParentId,c);
                }
                objCaseUpdateMilestoneMap.put(c.Id,c);
            }
           
           List<CaseMilestone> objUpdateCaseMilestone = new List<CaseMilestone>();
         
           for(CaseMilestone cm : [select id,caseId,CompletionDate,MilestoneTypeId  from CaseMilestone where caseId IN : objCaseMapParent.keyset() and isCompleted=false]){
               
               if(cm.MilestoneTypeId == milestoneIdMap.get(Label.CL_380_Milestone_PNN)){
                    Case c = objCaseMapParent.get(cm.CaseId);
                    
                    cm.CompletionDate = c.CreatedDate;
                    objUpdateCaseMilestone.add(cm);
                    
               }
           }
           for(CaseMilestone cm : [select id,caseId,CompletionDate,MilestoneTypeId  from CaseMilestone where caseId IN : objCaseUpdateMilestoneMap.keyset() and isCompleted=false]){
               if(cm.MilestoneTypeId == milestoneIdMap.get(Label.CL_381_Milestone_IOP)){
                    
                    Case c = objCaseUpdateMilestoneMap.get(cm.CaseId);
                    
                    if(c.Provider_Outreach_Date__c != null){
                        
                        cm.CompletionDate = c.Provider_Outreach_Date__c;                        
                    } 
                    objUpdateCaseMilestone.add(cm);
               }
               else if(cm.MilestoneTypeId == milestoneIdMap.get(Label.CL_382_Milestone_AG_CLosure)){
                    
                    Case c = objCaseUpdateMilestoneMap.get(cm.CaseId);
                   
                    if(c.Status=='Ready for Callback' || c.Status=='Resolved'){
                        cm.CompletionDate = c.LastModifiedDate;                        
                      }
                      objUpdateCaseMilestone.add(cm);                    
               }
               else if(cm.MilestoneTypeId == milestoneIdMap.get(Label.CL_382_Milestone_Closure)){
                    Case c = objCaseUpdateMilestoneMap.get(cm.CaseId);
                    if(c.Status=='Ready for Callback'){
                        cm.CompletionDate = c.LastModifiedDate;
                        objUpdateCaseMilestone.add(cm); 
                        
                    } 
                    
               }
           }
        
         /** @ Description: Try Catch to protect the user from errors in the DML call.**/
        try{
            
            /** @ Description: DML opperation to update newly closed CaseMilestones.**/
            Update objUpdateCaseMilestone;
        } catch(Exception triggerException) {
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }  
    }
    
    
    /*******************************************************************
    Purpose: This method checks the new Case owner. If the new owner is a Queue, it verifies
            that the owner's line of business is the same based on naming convention of the profiles and queues.
    Parameters: List<Case> inputListCases, Map<Id, Case> oldMap,  Map<Id, Case> newMap
    Returns: none 
    Throws [Exceptions]: TriggerException
    ********************************************************************/
    
    public static void ManageCaseOwnership(List<Case> inputListCases, Map<Id, Case> oldMap,  Map<Id, Case> newMap) {
        
        /** @ Description: List used to store Cases that meet the criteria for checking change of ownership.**/
        Map<Id, Group> newOwner;
        List<Case> ownerCases = new List<Case>(); 
        List<Case> queueOwnerCases = new List<Case>();   
        Set<Id> caseSOQLSet = new Set<Id>();
        
        /** @ Description: Variables used to store the criteria for checking change of ownership.**/
        String currentUser;
        String ownershipCheck = Label.OwnershipQueueLabel; 
        
        /** @ Description: Create a Set of the Owner Id's for the SOQL.**/
        for(Case loopCase: inputListCases) {
            caseSOQLSet.add(newMap.get(loopCase.Id).OwnerId);
            system.debug('Owner Id' + newMap.get(loopCase.Id).OwnerId);
        }
        
        /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
        try{
        
            /** @ Description: SOQL to get Queue information to check against User Profile Name. **/
            newOwner = new map<id, Group>([select callGroup.Id, callGroup.Type, callGroup.Name from Group callGroup where callGroup.Id in :caseSOQLSet]);
        } catch(Exception triggerException) {
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        
        /** @ Description: Iterative loop checking if the Owner changes was of type 'Queue' before it is added to the list. **/
        for(Case loopCase: inputListCases) {
            if(newOwner.containskey(newMap.get(loopCase.Id).OwnerId)) {
                if(newOwner.get(newMap.get(loopCase.Id).OwnerId).Type == 'Queue') {
                    queueOwnerCases.add(loopCase);
                    system.debug('Owner Type' + newOwner.get(newMap.get(loopCase.Id).OwnerId).Type);
                }
            }
        }
        
        /** @ Description: Check to make sure that there are items in the list before SOQL user information.**/
        if(queueOwnerCases != null && queueOwnerCases.size() > 0) {
            
            /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
            try{
                
                /** @ Description: SOQL to get User's Profile Name for checking against Queue Name. **/
                currentUser = [Select Id, Profile.Name from User where Id = :UserInfo.getUserId() limit 1].Profile.Name;
            } catch(Exception triggerException) {
                Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }
        }
        
        /** @ Description: Check to see if the user is a System Administrator to bypass this validation.**/
        if(!(currentUser == 'System Administrator')) {
            for(Case loopCase: queueOwnerCases) {
                
                /** @ Description: Check to see what Line of Business the Queue is associated to.**/
                if(newOwner.get(newMap.get(loopCase.Id).OwnerId).Name.startsWith(ownershipCheck)) {
                
                    /** @ Description: Check to see what Line of Business the user is associated to.**/
                    if(!(currentUser.startsWith(ownershipCheck))) {
         
                        /** @ Description: If the ownership has been assigned to the wrong Line of Business, it adds an error precenting a save.**/
                        Case errorCase = newMap.get(loopCase.Id);
                        errorCase.isTriggerError__c = true;
                        /** @ Description: Error Message to  be displayed when there is a case error**/
                        errorCase.addError('You may pick only an S3 queue.');
                    }
                    
                /** @ Description: Check to see what Line of Business the user is associated to.**/    
                } else if(currentUser.startsWith(ownershipCheck)) {
        
                    /** @ Description: If the ownership has been assigned to the wrong Line of Business, it adds an error precenting a save.**/
                    Case errorCase = newMap.get(loopCase.Id);
                    errorCase.isTriggerError__c = true;
                    /** @ Description: Error Message to  be displayed when there is a case error**/
                    errorCase.addError('You may pick only an SHP queue.');
                }
            }
        } 
    }
}