/**  
*    Class Name: ManageCaseDatabase
*    Author: Brandon Cassis
*    Date: 1-September-2013
*    Description: This class is used to control the order of execution of the different methods
*    that are executed on the Case object. The records are filtered through to evaluate criteria  
*    and then passed to the appropriate method.
*    History
*    --------
**/
public class ManageCaseDatabase {
    
    /** @ Description: final static values for REQ 3262 **/
    private static final string OOA_QUEUE_NAME = 'SHP OOA/OON';
    private static final string OOA_VIEW_ONLY = 'SHP OOA/OON View Only';
    public static boolean isMemberOfSHP_OOA_OON = false;
    public static boolean isMemberOfSHP_OOA_OON_View_Only = false;
    private static final string EXEPTION_MSG = '\r\n';        
    private static final string EXEPTION_MSG1 = '--------------';
    public static string REASON_CLINICAL = 'Clinical'; 
    public static string webGrievanceRecordType ='Grievance Web Form Interaction Log';
    
    /** @ Description: Variables used to store what is passed Case data to Classes**/
    public static List<Case> insertedChildCases = new List<Case>();
    
    /** @ Description: Variables used to store criteria to determine the Cases passed to the Classes**/
    public static Id webGrievanceRecordTypeId;
    public static List<Id> cvServiceRequest = new List<Id>();
    
    /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
    public static Map<string , string> objectPrefixMap = new Map<string, string>();
    /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
    
    
    /**
    *   @Description: This method controls the order of execution on a Before Insert DML Transaction from the trigger.
    *   It evaluated the record based on criteria and passes the recordes to the appropriate method to be processed.
    *   @Arguments: List of Cases 
    *   @Return: Void
    **/
    public static void ManageBeforeInsertedCases(List<Case> insertedCases) {
        
        /** @ Description: Variables used to store criteria to determine the Cases passed to the Classes**/
        List<Case> webGrievanceCases = new List<Case>();
        List<RecordType> cvPortalSRIds = new List<RecordType>();
        List<PortalSRILCreation__c> portalSRCS = new List<PortalSRILCreation__c>();
        Set<String> serviceRequestNamesCV = new Set<String>();
        List<Case> cvPortalSR = new List<Case>();
        String grievanceName;
        
        /** @ Description: Label used to pull the Grievance record type.**/
        grievanceName = Label.WebGrievance;
        
        /** @ Description: External check to see if the Web Grievance Id is stored to reduce SOQL calls.**/
        if(ManageExecutions.isSameGrienanceId) {
            webGrievanceRecordTypeId = ManageExecutions.webGrievanceRecordTypeId;
        } else {
            
            /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
            try{
                
                /** @ Description: SOQL call to retrieve the Web Grievance Record Type Id.**/
                //webGrievanceRecordTypeId = [select Id, SobjectType, Name from RecordType where DeveloperName = :grievanceName and SObjectType='Case' limit 1].Id; 
                webGrievanceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(webGrievanceRecordType).getRecordTypeId();
                
                /** @ Description: Set Web Grievance Record Type Id in External Class.**/
                ManageExecutions.setSameGrienanceId();
                ManageExecutions.setGrienanceId(webGrievanceRecordTypeId);
            } catch(Exception TriggerException){
            
                /** @ Description: Pass errors to the system to be logged.**/
                Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }    
        }
        
        /** @ Description: Adds Cases with with the Grievance Record Type to the list.**/
        for(Case loopCase: insertedCases) {
            if(loopCase.RecordTypeId == webGrievanceRecordTypeId) {
                webGrievanceCases.add(loopCase);
            }
        }
        
        /** @ Description: If there are Grievance Cases it send them to a method to be processed.**/
        If(webGrievanceCases != null && webGrievanceCases.size() > 0) {
            ManageCaseInsert.GrievanceILToMember(webGrievanceCases);
        }
        
        /** @ Description: If this Case is the child of another Case it adds the Case to the list.**/
        for(Case loopCase: insertedCases) {
            if(loopCase.ParentId != null) {
                insertedChildCases.add(loopCase);
            }
        }
        
        /** @ Description: If the list has Cases it passes it to the method for processing.**/
        If(insertedChildCases != null && insertedChildCases.size() > 0) {
            ManageCaseInsert.AssignChildCases(insertedChildCases);
        }
        
        /** @ Description: If the list has Cases it passes it to the method for processing.**/    
        If(insertedCases != null && insertedCases.size() > 0) {    
            ManageCaseInsert.SetSurveyForce(insertedCases);
        }
        
        /** @ Description: If the list has Cases it passes it to the method for processing.**/
        If(insertedCases != null && insertedCases.size() > 0) {
            ManageCaseInsert.AssignEntitlementAndBusinessHours(insertedCases);
        }
        
        /** @ Description: External check to see if the Portal Service Request Record Types are stored to reduce SOQL calls.**/
        if(ManageExecutions.isSameCVServiceRequests) {
            cvServiceRequest.addAll(ManageExecutions.cvServiceRequests);
        } else {
            
            /** @ Description: Add Custom Settings related to Portal Service Requests to a list.**/
            portalSRCS = PortalSRILCreation__c.getAll().values();
            for(PortalSRILCreation__c loopSRCS : portalSRCS) {
                serviceRequestNamesCV.add(loopSRCS.Name);          
            }
            
            /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
            try{
            
                /** @ Description: Check to make sure at there are Service Request Types to SOQL**/
                if(serviceRequestNamesCV != null && serviceRequestNamesCV.size() > 0) {
                    cvPortalSRIds = [select Id, SobjectType, Name from RecordType where DeveloperName IN :serviceRequestNamesCV and SObjectType='Case'];  
                    for(RecordType loopRT: cvPortalSRIds) {
                        cvServiceRequest.add(loopRT.Id);
                    }
                    
                    /** @ Description: Set Portal Service Request Record Types in an External Class.**/
                    ManageExecutions.setSameCVServiceRequests();
                    if(cvServiceRequest != null && cvServiceRequest.size() > 0) {
                        ManageExecutions.setCVServiceRequests(cvServiceRequest);
                    }
                }
            } catch(Exception TriggerException){
                Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }    
        }
        
        /** @ Description: Interate through Portal Service Request Types to determine which should be added to the list.**/
        for(Case loopCase: insertedCases) {
            for(Id loopId: cvServiceRequest) {
                
                /** @ Description: Check to make sure that the Service Request came from the Portal by making sure there is no Interaction Log.**/ 
                if(loopCase.RecordTypeId == loopId && loopCase.ParentId == null) {
                    cvPortalSR.add(loopCase);
                }
            }
        }
        
        /** @ Description: If the list has Cases it passes it to the method for processing.**/
        If(cvPortalSR != null && cvPortalSR.size() > 0) {
            ManageCaseInsert.CreateILPortalSR(cvPortalSR);
        }
        
        /** @ Description: Check to make sure that an error has not been added throughout the rest of the classes. If so, it stores the 
        *         information submitted by the user in an exception.
        **/ 
        for(Case loopCase: webGrievanceCases) {
            if(loopCase.isTriggerError__c) {
                Utility.handleExceptionFromCode('The following Member Grievance was not able to be logged' + 
                    loopCase.Grievance_Web_Form_Member_ID__c + 'First: ' + loopCase.Grievance_Web_Form_Member_First_Name__c + 'Last: ' +
                    loopCase.Grievance_Web_Form_Member_Last_Name__c + 'Street: ' + loopCase.Grievance_Web_Form_Member_Street_Address__c + 'City: ' +
                    loopCase.Grievance_Web_Form_Member_City__c + 'State: ' + loopCase.Grievance_Web_Form_Member_State__c + 'Zip: ' +
                    loopCase.Grievance_Web_Form_Member_Zip__c + 'Day Phone: ' + loopCase.Grievance_Web_Form_Member_Daytime_Phone__c + 'Evening Phone: ' +
                    loopCase.Grievance_Web_Form_Member_Evening_Phone__c + 'Email: ' + loopCase.Grievance_Web_Form_Member_Email_address__c + 'Concern: ' +
                    loopCase.Grievance_Web_Form_Concern__c);
            }
        }  
    }
    
    /**
    *   @Description: This method controls the order of execution on a After Insert DML Transaction from the trigger.
    *   It evaluated the record based on criteria and passes the recordes to the appropriate method to be processed.
    *   @Arguments: List of Cases 
    *   @Return: Void
    **/
    public static void ManageAfterInsertedCases(List<Case> insertedCases) {
        
        /** @ Description: List used to store Cases that have met the criteria to be passed to the Classes**/
        List<Case> webGrievanceCases = new List<Case>();
        
        /** @ Description: External check to see if the Web Grievance Service Request Record Types are stored to reduce SOQL calls.**/
        if(!ManageExecutions.isSameGrienanceId && webGrievanceRecordTypeId == null) {
            
            /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
            try{
            
                /** @ Description: SOQL call to retrieve the Web Grievance Record Type Id.**/
                //webGrievanceRecordTypeId = [select Id, SobjectType, Name from RecordType where DeveloperName = :Label.WebGrievance and SObjectType='Case' limit 1].Id;
                webGrievanceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(webGrievanceRecordType).getRecordTypeId();
                
                /** @ Description: Set external class incase class is entered again to reduce SOQL calls.**/
                ManageExecutions.setSameGrienanceId();
                ManageExecutions.setGrienanceId(webGrievanceRecordTypeId);   
            } catch(Exception TriggerException){
                Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }    
        } else if(webGrievanceRecordTypeId == null) {
            webGrievanceRecordTypeId = ManageExecutions.webGrievanceRecordTypeId;
        }
        
        /** @ Description: Check to make sure that it is a Web Grievance Interaction Log Case.**/
        for(Case loopCase: insertedCases) {
            if(loopCase.RecordTypeId == webGrievanceRecordTypeId) {
                webGrievanceCases.add(loopCase);
            }
        }
        
        /** @ Description: If the list has Cases it passes it to the method for processing.**/
        if(webGrievanceCases != null && webGrievanceCases.size() > 0) {
            ManageCaseInsert.GrievanceWebToCase(webGrievanceCases);
        }
    }
     /** @Req.3082 Release 5.2 Changes **/
     /**
    *   @Description: This method controls the order of execution on a After Insert DML Transaction from the trigger.
    *   It evaluated the record based on criteria and passes the recordes to the appropriate method to be processed.
    *   @Arguments: List of Cases 
    *   @Return: Void
    **/
    public static void ManageAfterInsertedUpdatedMemberInquiries(List<Member_Enquiries__c> insertedUpdatedMemInquiries) 
    {
            /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
            try{
                system.debug('@@insertedUpdatedMemInquiries : '+ insertedUpdatedMemInquiries);
                insert insertedUpdatedMemInquiries;
            } catch(Exception TriggerException){
                system.debug('@@exception : '+ triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }            
    }
    
    /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
    /**
    * @author IDC Team
    * @date 04/09/2013
    * @description This method is used for storing the KeyPrefixes for User and Group(Queue) in a map
    *   Req. 3048 Release 6.2 Changes Date : 9/30/2014
    * @param 
    */
    public static void setUserGroupPrefixMap()
    {
        schema.DescribeSObjectResult userResult = User.SObjectType.getDescribe();
        string userPrefix = userResult.getKeyPrefix();
        objectPrefixMap.put('User', userPrefix);
        schema.DescribeSObjectResult grpResult = Group.SObjectType.getDescribe();
        string grpPrefix = grpResult.getKeyPrefix();
        objectPrefixMap.put('Queue', grpPrefix);
    }
    
    /**
    *   @Description: Req. 3048 Release 6.2 Changes Date : 9/30/2014
    *    This method populates the Last Owner Name field on Case with the value of previous owner name of the record
    *   @Arguments: oldMap of cases whose ownerid has been changed, newMap of cases whose ownerid has been changed
    *   @Return: Void
    **/
    public static void beforeUpdateLastOwnerCase(Map<Id, Case> oldCaseMap, Map<Id, Case> newCaseMap) 
    {
        /** @ Description: Variables declared and initialized to be used in the method **/
        Set<Id> ownerIdSet = new Set<Id>();
        Set<Id> userOwnerIdSet = new Set<Id>();
        Set<Id> queueOwnerIdSet = new Set<Id>();
        Map<Id, String> userIdNameMap = new Map<Id, String>();
        Map<Id, String> queueIdNameMap = new Map<Id, String>();
        
        Map<Id, String> caseIdUserNameMap = new Map<Id, String>();
        Map<Id, String> caseIdQueueNameMap = new Map<Id, String>();
        
        try{
            
            /** @ Description: Loop over oldcasemap to their ownerIds in the set **/
            for(Case caseRecord : oldCaseMap.values())
            {
                ownerIdSet.add(caseRecord.ownerId);
            }
            
            /** @ Description: if ownerid set is not empty  **/
            if(!ownerIdSet.isEmpty())
            {
                /** @ Description: call method to populate object prefix map  **/
                setUserGroupPrefixMap();
                
                /** @ Description: logic to populate userownerid set and queueOwnerId set **/
                for(String recordId : ownerIdSet)
                {
                    if(recordId.substring(0,3) == objectPrefixMap.get('User'))
                    {
                        userOwnerIdSet.add(recordId);
                    }
                    else if(recordId.substring(0,3) == objectPrefixMap.get('Queue'))
                    {
                        queueOwnerIdSet.add(recordId);
                    }
                }
            }
                
            if(!userOwnerIdSet.isEmpty())
            {
                /** @ Description:  **/
                for(List<User> userList : [Select Name from User where Id IN : userOwnerIdSet])
                {
                    for(User userRecord : userList)
                    {
                        userIdNameMap.put(userRecord.Id, userRecord.Name);
                    }
                }
                
                for(Case caseOne : oldCaseMap.values())
                {
                    caseIdUserNameMap.put(caseOne.id, userIdNameMap.get(caseOne.ownerId));
                }
                
                for(Case caseRecord : newCaseMap.values())
                {
                    caseRecord.Last_Owner_Name__c = caseIdUserNameMap.get(caseRecord.id);
                }
            }
            else if(!queueOwnerIdSet.isEmpty())
            {
                for(List<Group> queueList : [SELECT Name FROM Group where Type = 'Queue' AND Id IN : queueOwnerIdSet])
                {
                    for(Group queueRecord : queueList)
                    {
                        queueIdNameMap.put(queueRecord.Id, queueRecord.Name);
                    }
                }
                
                
                for(Case caseOne : oldCaseMap.values())
                {
                    caseIdQueueNameMap.put(caseOne.id, queueIdNameMap.get(caseOne.ownerId));
                }
                
                for(Case caseRecord : newCaseMap.values())
                {
                   caseRecord.Last_Owner_Name__c = caseIdQueueNameMap.get(caseRecord.Id);
                }
            }
            
        } catch(Exception TriggerException){
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
        /**
    *   @Description: Req. 3048 Release 6.2 Changes Date : 9/30/2014
    *   @Arguments: old case map and new case map
    *   @Return: Void
    **/
    public static void afterUpdateStatusDurationRecordInsert(Map<Id, Case> oldMap, Map<Id, Case> newMap) 
    {
        Set<Id> caseIdSet = new Set<Id>();
        Set<String> recordTypeIdSet = new Set<String>();
        List<Recordtype> S3RecTypeList = new List<Recordtype>();
        Set<Id> S3RecordtypeIdSet = new Set<Id>();
        
        integer s3_recordcount;
        Map<String, Datetime> caseIdMaxUntilMap = new Map<String, Datetime>();
        List<Status_and_Ownership_Duration__c> statusDurationList = new List<Status_and_Ownership_Duration__c>();
        
        try{
            
            //Get the default business hours 
            BusinessHours defaultHours = [select Id from BusinessHours where Name =: Label.CL54_LifeCycle_Business_Hours];
            
            for(Case loopCase : newMap.values())
            {
                caseIdSet.add(loopCase.id);
                recordTypeIdSet.add(loopCase.RecordTypeId);
            }
            
            S3RecTypeList = [SELECT Id FROM RecordType where BusinessProcessId IN (SELECT ID FROM BusinessProcess WHERE Name LIKE '%s3%' AND IsActive = true AND TableEnumOrId = 'Case') and IsActive = true and Id IN : recordTypeIdSet];
            system.debug('@@S3RecTypeList : '+ S3RecTypeList);
            for(RecordType rt : S3RecTypeList)
            {
                S3RecordtypeIdSet.add(rt.id);
            }
            
            system.debug('@@S3RecordtypeIdSet : '+ S3RecordtypeIdSet);
            
            if(!caseIdSet.isEmpty())
            {
                for(AggregateResult aggResult : [Select MAX(Until__c) maxVal, Case__c from Status_and_Ownership_Duration__c 
                                                            where Case__c IN :caseIdSet
                                                            GROUP BY Case__c])
                {
                    String IdValue = (String)aggResult.get('Case__c');
                    Datetime maxValue = (Datetime)aggResult.get('maxVal');
                    caseIdMaxUntilMap.put(IdValue, maxValue);
                }
                
            }
            
            for(Case caseRec : newMap.values())
            {
                if(S3RecordtypeIdSet.contains(caseRec.RecordtypeId))
                {
                    Status_and_Ownership_Duration__c statusOwnerRecord = new Status_and_Ownership_Duration__c();
                    statusOwnerRecord.Case__c = caseRec.id;
                    statusOwnerRecord.Owner__c = newMap.get(caseRec.Id).Last_Owner_Name__c;
                    statusOwnerRecord.Status__c = oldMap.get(caseRec.Id).Status;
                    
                    if(caseIdMaxUntilMap.containsKey(caseRec.id))
                    {
                        statusOwnerRecord.From__c = caseIdMaxUntilMap.get(caseRec.id);
                    }
                    else
                    {
                        statusOwnerRecord.From__c = newMap.get(caseRec.Id).CreatedDate;
                    }
                    
                    statusOwnerRecord.Until__c = system.now();
                    
                    Id hoursToUse = caseRec.BusinessHoursId!=null?caseRec.BusinessHoursId:defaultHours.Id;
                    
                    Decimal calculatedBusinessHours = (BusinessHours.diff(hoursToUse, statusOwnerRecord.From__c, statusOwnerRecord.Until__c)/3600000.0).setscale(2);
                    
                    statusOwnerRecord.Business_Hours__c = calculatedBusinessHours;
                    
                    statusOwnerRecord.Customer_Intent__c = caseRec.Customer_Intent__c;
                    statusOwnerRecord.Customer_Sub_Intent__c = caseRec.Customer_Sub_Intents__c;
                    //Req #3048 - 10/10/2014 - Start
                    statusOwnerRecord.Function__c = caseRec.Function__c;
                    statusOwnerRecord.Sub_Function__c = caseRec.Sub_Function__c;
                    statusOwnerRecord.Team__c = caseRec.Team__c;
                    //Req #3048 - 10/10/2014 - End
                    
                    statusOwnerRecord.Business_Hours_In_Min__c  = calculatedBusinessHours != null ? (calculatedBusinessHours * 60) : 0;
                    statusOwnerRecord.Business_Hours_In_Days__c  = calculatedBusinessHours != null ? (calculatedBusinessHours /24) : 0;
                             
                     statusDurationList.add(statusOwnerRecord);
                    //3048 - Start
                     //s3_recordcount = [SELECT count() FROM RecordType where BusinessProcessId in (SELECT ID FROM BusinessProcess WHERE Name LIKE '%s3%' AND IsActive = true) and IsActive = true and id =: caseRec.RecordTypeId];   
                    //3048 - End
                    //if (s3_recordcount > 0){
                    //}
                }
            }
            system.debug('@@statusDurationList : '+ statusDurationList);
            
            if(!statusDurationList.isEmpty())
            {
                Database.insert(statusDurationList);
            }
        } catch(Exception TriggerException){
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }

    /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
    
    
    /** @Req.3082 Release 5.2 Changes **/
    /**
    *   @Description: This method controls the order of execution on a Before Update DML Transaction from the trigger.
    *   It evaluated the record based on criteria and passes the recordes to the appropriate method to be processed.
    *   @Arguments: List of Cases, Old <Id, Case> Map for Cases, New <Id, Case> Map for Cases  
    *   @Return: Void
    **/
    public static void ManageBeforeUpdatedCases(List<Case> insertedCases, Map<Id, Case> oldMap, Map<Id, Case> newMap) {
        
        /** @ Description: List used to store Cases that have met the criteria to be passed to the Classes**/
        List<Case> updatedOwner = new List<Case>();
        List<Case> newlyClosedCases = new List<Case>();
        List<Case> casesWithoutError = new List<Case>();
        
        /** @ Description: Check to make sure that the Owner of the Case has changed.**/
        for(Case loopCase: insertedCases) {
            if(newmap.get(loopCase.id).OwnerId != (oldmap.get(loopCase.Id).OwnerId)){
                updatedOwner.add(loopCase);
            }
        }
        
         /** @ Description: If the list has Cases it passes it to the method for processing.**/    
        If(insertedCases != null && insertedCases.size() > 0) {    
            ManageCaseInsert.SetSurveyForce(insertedCases);
        }
        
        /** @ Description: If the list has Cases it passes it to the method for processing.**/    
        If(updatedOwner != null && updatedOwner.size() > 0) {
            ManageCaseUpdate.ManageCaseOwnership(updatedOwner, oldMap, newMap); 
        }
        
        /** @ Description: Check to make sure that it is a newly closed Case.**/
        for(Case loopCase: insertedCases) {
            if(oldMap.get(loopCase.Id).status != 'Closed' && newMap.get(loopCase.Id).status == 'Closed') {
                newlyClosedCases.add(loopCase);
            }
        }
        
        /** @ Description: If the list has Cases it passes it to the method for processing.**/   
        If(newlyClosedCases != null && newlyClosedCases.size() > 0) {
            ManageCaseUpdate.CheckOpenTasks(newlyClosedCases, newMap);  
        }
        /** @ Description: Check to make sure that an error has not been added throughout the rest of the classes.**/ 
        for(Case loopCase: newlyClosedCases) {
            if(!loopCase.isTriggerError__c) {
                casesWithoutError.add(loopCase);
            }
        }
        
        /** @ Description: If the list has Cases it passes it to the method for processing.**/   
        If(casesWithoutError != null && casesWithoutError.size() > 0) {
            ManageCaseUpdate.CloseCaseMilestones(casesWithoutError);
        }
    }
    
    /**
    *   @Description: Req. 3262 Release 7 Changes Date : 01/02/2015, method used to update parent IL of the SR of type OOA/OON
    *   @Arguments: service request list of type OOA/OON
    *   @Return: Void
    **/
    public static void updateOOA_OON_InteractionLog(List<Case> OOA_OON_srList){
        
        /** @ Description: try block start **/
        try{
            /** @ Description: collections instantiated to be used in this method **/
            Map<Id, Case> parentIdSRMap = new Map<Id, Case>();
            List<Case> parentInteractionLogList = new List<Case>();
            
            /** @ Description: if SR list passed is not empty **/
            if(!OOA_OON_srList.isEmpty()){
                
                /** @ Description: iterate over the SR list **/
                for(Case srloop : OOA_OON_srList){
                    
                    /** @ Description: populate the map of SR's parent Id(IL Id) and SR **/
                    parentIdSRMap.put(srloop.ParentId, srloop);
                }
                
                /** @ Description: if IL Id and SR records map is not empty **/
                if(!parentIdSRMap.isEmpty()){
                    
                    /** @ Description: iterate over the list of ILs **/
                    for(Case parentCase : [Select Id, Reason__c from Case where Id IN : parentIdSRMap.keySet()]){
                        
                        /** @ Description: only update those ILs whose Reason is Clinical **/
                        if(parentCase.Reason__c == REASON_CLINICAL){
                            
                            /** @ Description: update the queried cases(ILs) sec reason value with that of SR's sec reason **/
                            parentCase.Secondary_Reason__c = parentIdSRMap.get(parentCase.id).Secondary_reason__c;
                        }
                        
                        /** @ Description: add the record to list **/
                        parentInteractionLogList.add(parentCase);
                    }
                }
                
                /** @ Description: if list of IL records is not empty **/
                if(!parentInteractionLogList.isEmpty()){
                    
                    /** @ Description: update IL record list **/
                    Database.update(parentInteractionLogList);
                }
            }
            
        /** @ Description: catch block to catch any exceptions **/
        } catch(Exception TriggerException){
            Utility.handleExceptionFromCode(triggerException.getMessage() + EXEPTION_MSG + triggerException.getStackTraceString() + EXEPTION_MSG + triggerException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG1);
        }
    }
    /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 END**/
    
    /**
    *   @Description: Req. 3262 Release 7 Changes Date : 01/02/2015 
    *                       Update Member fields on change of Member Name
    *   @Arguments: service request list of type OOA/OON
    *   @Return: Void
    **/
    public static void updateMemberFieldsSR(List<Case> srList){
        
        
        /** @ Description: try block start **/
        try{
            
            /** @ Description: collections instantiated to be used in this method **/
            Map<Id, Id> srIdMemberIdMap = new Map<Id, Id>();
            List<Case> caseToUpdate = new List<Case>();
            Integer age;
            
            /** @ Description: iterate over list of SRs passed **/
            for(Case srloop : srList){
                
                /** @ Description: populate the map of SR id and SR member Id **/
                srIdMemberIdMap.put(srloop.id, srloop.Member_Name_OOA_OON__c);
            }
            
            /** @ Description: if above map is not empty **/
            if(!srIdMemberIdMap.isEmpty()){
                
                /** @ Description: query SR and its member contact's fields **/
                for(Case srCase : [Select Id, Member_Name_OOA_OON__r.Member_ID__c, Member_Name_OOA_OON__r.Birthdate, Member_Name_OOA_OON__r.Phone,
                                                Member_Name_OOA_OON__r.Member_PCP_Name_Full__c, Member_Name_OOA_OON__r.Member_Group_Affiliation__c 
                                                from Case where Id IN : srIdMemberIdMap.keyset()]){
                    
                    /** @ Description: populate the member fields from related Member Contact **/
                    srCase.Member_DOB_OOA_OON__c = srCase.Member_Name_OOA_OON__r.Birthdate;
                    srCase.Member_Phone__c = srCase.Member_Name_OOA_OON__r.Phone;
                    srCase.Member_PCP__c = srCase.Member_Name_OOA_OON__r.Member_PCP_Name_Full__c;
                    srCase.Medical_Group__c = srCase.Member_Name_OOA_OON__r.Member_Group_Affiliation__c;
                    srCase.Member_ID_OOA_OON__c = srCase.Member_Name_OOA_OON__r.Member_ID__c;
                    
                    /** @ Description: calculate the age of the member **/
                    if(srCase.Member_Name_OOA_OON__r.Birthdate <> null)
                    {
                        age = ((srCase.Member_Name_OOA_OON__r.Birthdate).monthsBetween(system.today()))/12;
                    }
                    
                    srCase.Member_Age__c = String.valueOf(age);
                    
                    /** @ Description: add the case to case update list **/
                    caseToUpdate.add(srCase);
                }
            }
            
            /** @ Description: if the case update list is not empty **/
            if(!caseToUpdate.isEmpty()){
                
                /** @ Description: update the list **/
                Database.update(caseToUpdate);
            }
        
        /** @ Description: catch block to catch any exceptions **/   
        } catch(Exception TriggerException){
            Utility.handleExceptionFromCode(triggerException.getMessage() + EXEPTION_MSG + triggerException.getStackTraceString() + EXEPTION_MSG + triggerException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG1);
        }
    }
    /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 END**/
    
    /**
    *   @Description: Req. 3262 Release 7 Changes Date : 01/05/2015 
    *                       Find which Group the logged in User belongs to
    *   @Arguments: service request list of type OOA/OON
    *   @Return: Void
    **/
    public static void groupMember(){
        
        /** @ Description: try block start **/
        try{
            
            /** @ Description: get logged in user's ID **/
            Id currentUserId = UserInfo.getUserId();  
            
            /** @ Description: query group id for queue **/
            List<Group> qId = [select id from Group where Name=: OOA_QUEUE_NAME];
            
            /** @ Description: query group member where user id is current user and group id is queue's group**/
            List<Groupmember> grpMem = [SELECT UserOrGroupId, groupid  FROM GroupMember where GroupId IN:qid and UserOrGroupId=:currentUserId];
            
            /** @ Description: query group id for Read Only group **/
            List<Group> qId1 = [select id from Group where Name=: OOA_VIEW_ONLY];
            
            /** @ Description: query group member where user id is current user and group id is read only group**/
            List<Groupmember> grpMemViewOnly = [select UserOrGroupId from GroupMember where GroupId IN:qId1 and UserOrGroupId=:currentUserId];
            
            /** @ Description: if current user belongs to SHP OOA/OON group **/
            if(grpMem.size() > 0){         
    
                isMemberOfSHP_OOA_OON = true;
            
            /** @ Description: else if current user belongs to SHP OOA/OON Read only group **/
            } else if(grpMemViewOnly.size() >0 ){
            
                isMemberOfSHP_OOA_OON_View_Only = true;            
            }
        
        /** @ Description: catch block to catch any exceptions **/
        } catch(Exception TriggerException){
            
            /** @ Description: **/
            Utility.handleExceptionFromCode(triggerException.getMessage() + EXEPTION_MSG + triggerException.getStackTraceString() + EXEPTION_MSG + triggerException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG1);
        }
    }
    /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 END**/
    
}