/**  
*    Class Name: ManageCaseMilestoneDatabase
*    Author: IDC Offshore
*    Date: 8-December-2013
*    Description: This is the helper class to manage the Case Milestone functionality on update of the Case records.
*                   This class checks the various milestone criterias and perform the necessary functions of updating the Case fields to indicate the status of the milestone.
*    History
*
*    VERSION    AUTHOR              DATE        DETAIL 
*      2.0     Atul Gupta      03/13/2014    Added method AssignGrievanceEntitlement that takes in a list of cases and
*                                               flips the EntitlemntId for the Cases of Record type Grievance in case the Secondary Reason is changed
*                                               from Non-Expedited value to Expedited and vice versa.
       2.1     Umesh           06/23/2016    Added method assignPDIEntitlement that takes in a list of cases and associates the Entitlement Id for PDI.
*    --------
**/
public class ManageCaseMilestoneDatabase {
    
    /* Map and Set class variables*/
    private static set<string> determination31DaySet = new set<string>();
    private static set<string> determination45DaySet = new set<string>();
    private static set<string> newCaseId = new set<string>();
    
    private static final string EXEPTION_MSG = '\r\n';
    private static final string EXEPTION_MSG1 = '--------------';
    private static final string SEC_REASON_EXEMPT = 'Exempt';
    private static final string SHP_BUSINESS_HOURS_NON_EXEMPT = 'SHP Business Hours';
    private static final string SHP_BUSINESS_HOURS_EXEMPT = 'SHP Business Hours For Exempt Grievance';
    
    /*******************************************************************
    Purpose: This method takes Case. Checks the milestone criteria for current Case milestone and update the RFI_Status__c accordingly
    Parameters: trigger.OldMap and trigger.newMap for Case
    Returns: none 
    Throws [Exceptions]: TriggerException
    ********************************************************************/
    public static void ManageCaseMilestoneBeforeUpdate(Map<Id, Case> triggerNewMap, Map<Id, Case> triggerOldMap)
    {
        try
        {
            if(!triggerNewMap.isEmpty())
            {
               
               
                /* Iterate over updated Cases*/
                for(Case newCase:triggerNewMap.values())
                {
                    /*If Case record type is Provider Dispute*/
                    if(Schema.SObjectType.Case.RecordTypeInfosByName.get(Label.CL31_Provider_Dispute).RecordTypeId == newCase.RecordTypeId || Schema.SObjectType.Case.RecordTypeInfosByName.get(Label.CL34_ProviderDisputeRO).RecordTypeId == newCase.RecordTypeId)
                    {
                    
                        /*If the RFI request date or RFI Completion Date is changed*/
                        if(newCase.RFI_Request_Date__c <> triggerOldMap.get(newCase.Id).RFI_Request_Date__c || newCase.RFI_Completion_Date__c <> triggerOldMap.get(newCase.Id).RFI_Completion_Date__c)
                        {
                            /* If RFI milestone criteria is met*/
                            if(newCase.Number_of_RFIs__c>0 && (newCase.RFI_Completion_Date__c == null || newCase.RFI_Completion_Date__c < newCase.RFI_Request_Date__c) && newCase.RFI_Request_Date__c <> null)
                            {
                                /*Update RFI Status*/
                                newCase.RFI_Status__c = system.Label.CL32_InProgressRFIStatus;
                            }
                            /* If RFI milestone completion criteria is met*/
                            else if(newCase.Number_of_RFIs__c>0 && newCase.RFI_Completion_Date__c > newCase.RFI_Request_Date__c && newCase.RFI_Request_Date__c <> null)
                            {
                                /*Update RFI Status*/
                                newCase.RFI_Status__c = system.Label.CL33_CompleteRFIStatus;
                            }
                        }
                    }                
                }
            }
        }catch(Exception TriggerException)
        {
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    
    /*******************************************************************
    Purpose: This method takes Case. Checks the milestone criteria for current Case milestone and create the set Case Ids accordingly and pass these set to a Future method.
    Parameters: trigger.OldMap and trigger.newMap for Case
    Returns: none 
    Throws [Exceptions]: TriggerException
    ********************************************************************/
    public static void ManageCaseMilestoneAfterUpdate(Map<Id, Case> triggerNewMap, Map<Id, Case> triggerOldMap)

    {
        try
        {
            if(!triggerNewMap.isEmpty())
            {
                /* Iterate over updated Cases*/
                for(Case newCase:triggerNewMap.values())
                {
                    /*If Case record type is Provider Dispute*/
                    if(Schema.SObjectType.Case.RecordTypeInfosByName.get(Label.CL31_Provider_Dispute).RecordTypeId== newCase.RecordTypeId || Schema.SObjectType.Case.RecordTypeInfosByName.get(Label.CL34_ProviderDisputeRO).RecordTypeId == newCase.RecordTypeId)
                    {
                        /*If the RFI request date or RFI Completion Date is changed*/
                        if(newCase.RFI_Request_Date__c <> triggerOldMap.get(newCase.Id).RFI_Request_Date__c || newCase.RFI_Completion_Date__c <> triggerOldMap.get(newCase.Id).RFI_Completion_Date__c)
                        {
                            /* If RFI milestone criteria is met*/
                            if(newCase.Number_of_RFIs__c>0 && (newCase.RFI_Completion_Date__c == null || newCase.RFI_Completion_Date__c < newCase.RFI_Request_Date__c) && newCase.RFI_Request_Date__c <> null)
                            {
                                /* add case to set*/
                                determination31DaySet.add(newcase.Id);
                            }
                            /* If RFI milestone completion criteria is met*/
                            else if(newCase.Number_of_RFIs__c>0 && newCase.RFI_Completion_Date__c > newCase.RFI_Request_Date__c && newCase.RFI_Request_Date__c <> null)
                            {
                                /* add case to set*/
                                determination45DaySet.add(newCase.Id);
                            }
                        }
                        /* add Case to set*/
                        newCaseId.add(newCase.Id);
                    }
                }
            }
            /*Call the future method*/
            ManageCaseMilestone.updateCaseMilestone(determination31DaySet, determination45DaySet, newCaseId);
        }catch(Exception TriggerException)
        {
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }

 
    /*******************************************************************
    Purpose: This method fires on Case update and assigns appropriate Entitlement Process to the Case where
             Secondary Reason is changed from Non-Expedited to Expedited and vice versa.
    Parameters: List<Case>
    Returns: none 
    Throws [Exceptions]: TriggerException
    ********************************************************************/
    public static void AssignGrievanceEntitlement(List<Case> milestoneUpdateCaseList) {
        
       system.debug('hello ****3333');
        /** @ Description: Lists and Maps used to store the Entitlements, Record Types, and Associated linking Custom Settings.**/
        List<RecordType> recordTypes = new List<RecordType>();
        //Map<String, RecordType> recordTypeMap = new Map<String, Recordtype>();
        Map<String, String> recordTypeMap = new Map<String, String>();
        Map<String, EntitlementRecordType__c> entitlementRecordMap = EntitlementRecordType__c.getAll();
        List<EntitlementRecordType__c> entitlementRecordList = entitlementRecordMap.values();
        List<Entitlement> entitlements;
        Map<String, Entitlement> entitlementMap = new Map<String, Entitlement>();
        Set<String> entitlementRecordSet = new Set<String>();
        
            /** @ Description: Iterate over custom settings grabbing Entitlement Record Types listed.**/
            for(EntitlementRecordType__c entitlementRecord: entitlementRecordList) {
                entitlementRecordSet.add(entitlementRecord.Entitlement__c);
            }
            
                /** @ Description: SOQL call the Id and Name of Case Record Types for evaluation.**/
                //recordTypes = [Select Id, Name, sObjectType From RecordType where sObjectType = 'Case'];
                Map<String,Schema.RecordTypeInfo> caseRtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
           
                /** @ Description: SOQL call the Entitlement and Business Hours in the Custom Settings.**/
                entitlements = [select Id, Name, BusinessHoursId From Entitlement where Name IN :entitlementRecordSet];
           
            /** @ Description: Iterate over Record types to get a ID key Name value Map.**/
            /*for(RecordType loopRecordtype: recordTypes){
                recordTypeMap.put(loopRecordtype.Name, loopRecordtype);
            }*/
            for(Schema.RecordTypeInfo rtype : caseRtMapByName.values()){
                recordTypeMap.put(rtype.getName(), rtype.getRecordTypeId());
            }
            /** @ Description: Iterate over Entitlements to get a Name key Entitlement value Map.**/
            for(Entitlement loopEntitlement: entitlements){
                entitlementMap.put(loopEntitlement.Name, loopEntitlement);
            }
        
        /** @ Description: Iterate over Cases to assign Entitlements and Business Hours.**/
        for(Case loopCase: milestoneUpdateCaseList) {
            
            /** @ Description: Check to insure the Map has the Case Record Type being evaluated from.**/
            //if(loopCase.recordTypeId == recordTypeMap.get(Label.CL43_Grievance_RT).Id){
            if(loopCase.recordTypeId == recordTypeMap.get(Label.CL43_Grievance_RT)){
                /** @ Description: Try Catch to prevent Cases entered into the system without Entitlement or Business Hours.*/
                try{
                    
                    /** @ Description: Condition to check if Secondary Reason is equal to 'Expedited' */
                    if(loopCase.Secondary_Reason__c == Label.CL42_Grievance_Expedited)
                    {
                        /** @ Description: Assigns Case EntitlementId to Expedited Entitlement Process */
                        loopCase.EntitlementId = entitlementMap.get(entitlementRecordMap.get(Label.CL42_Grievance_Expedited).Entitlement__c).Id;
                    }
                    else
                    if(loopCase.Secondary_Reason__c == 'Exempt')
                    {
                        /** @ Description: Assigns Case EntitlementId to Expedited Entitlement Process */
                       loopCase.EntitlementId = entitlementMap.get('SHP Grievance Entitlement for Exempt').Id;
                    }
                    
                    /** @ Description: Else condition if that assigns Case EntitlementId to Non-Expedited Entitlement Process */
                    else
                    {
                        loopCase.EntitlementId = entitlementMap.get(entitlementRecordMap.get(Label.CL43_Grievance_RT).Entitlement__c).Id;
                    }
                
                } catch(Exception TriggerException) {
                    
                    /** @ Description: Error added if assignment fails to stop further processing.**/
                    loopCase.addError('Assignment Update failed');
                    Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                }
            } 
        }
    }
      
    /*******************************************************************
    Purpose: This method assigns the correct entitlement process to PDI customer inquiries 
    Parameters: List<Case>
    Returns: none 
    Throws [Exceptions]: TriggerException
    ********************************************************************/
    public static void assignPDIEntitlement(List<Case> milestoneUpdateCaseList) {
        
       
        /** @ Description: Lists and Maps used to store the Entitlements, Record Types, and Associated linking Custom Settings.**/
        Map<String, String> recordTypeMap = new Map<String, String>();
        
        Map<String, Entitlement> entitlementMap = new Map<String, Entitlement>();
       
        /** @ Description: SOQL call the Id and Name of Case Record Types for evaluation.**/
        Map<String,Schema.RecordTypeInfo> caseRtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
   
        /** @ Description: SOQL call the Entitlement and Business Hours in the Custom Settings.**/
        List<Entitlement> entitlements = [select Id, Name, BusinessHoursId From Entitlement];
       
        for(Schema.RecordTypeInfo rtype : caseRtMapByName.values()){
            recordTypeMap.put(rtype.getName(), rtype.getRecordTypeId());
        }
        /** @ Description: Iterate over Entitlements to get a Name key Entitlement value Map.**/
        for(Entitlement loopEntitlement: entitlements){
            entitlementMap.put(loopEntitlement.Name, loopEntitlement);
        }
        
        /** @ Description: Iterate over Cases to assign Entitlements and Business Hours.**/
        for(Case loopCase: milestoneUpdateCaseList) {
            
            /** @ Description: Check to insure the Map has the Case Record Type being evaluated from.**/
            
            if(loopCase.recordTypeId == recordTypeMap.get('Provider Directory Inaccuracy')){
                /** @ Description: Try Catch to prevent Cases entered into the system without Entitlement or Business Hours.*/
                try{
                    
                    /** @ Description: Condition to check if Secondary Reason is equal to 'Expedited' */
                    if(loopCase.Secondary_Reason__c == 'Notification' || loopCase.Secondary_Reason__c =='Grievance')
                    {
                        /** @ Description: Assigns Case EntitlementId to Expedited Entitlement Process */
                        loopCase.EntitlementId = entitlementMap.get('SHP Provider Directory Inaccuracy Entitlement on Notification Received Date').Id;
                    }
                    
                   }
                   catch(Exception TriggerException) {
                    
                    /** @ Description: Error added if assignment fails to stop further processing.**/
                    loopCase.addError('Assignment Update failed');
                    Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                }
            } 
        }
    }
   
    
    
    /*******************************************************************
    Purpose: REQ 3318 - This method calculates end Time for BusinessHours 
    Parameters: List<Case>
    Returns: none 
    Throws [Exceptions]: ClassException
    ********************************************************************/
    
    public static Map<Id, Time> calculateEndTimeBusinessHours(List<Case> caseList){
        
        String businessHoursName = '';
        Map<id, Time> mapCaseIdBusinessTime = new Map<id, Time>();
        
        try{
        
            for(Case cases : caseList){
            
                if(cases.Secondary_Reason__c <> null && cases.Secondary_Reason__c == SEC_REASON_EXEMPT){
                    
                    Integer hoursStr = Integer.valueOf(Label.Exempt_End_Time.substring(0, 2));
                    Integer minStr = Integer.valueOf(Label.Exempt_End_Time.substring(3, 5));
                    Integer secStr = Integer.valueOf(Label.Exempt_End_Time.substring(6, 8));
                    Integer millisecStr = Integer.valueOf(Label.Exempt_End_Time.substring(9, 11));
                    Time myTime_exempt =  Time.newInstance(hoursStr, minStr, secStr, millisecStr);
                    mapCaseIdBusinessTime.put(cases.id, myTime_exempt);
                }
                else if(cases.Secondary_Reason__c <> null && cases.Secondary_Reason__c <> SEC_REASON_EXEMPT){
                    
                    Integer hoursStr = Integer.valueOf(Label.Non_Exempt_End_Time.substring(0, 2));
                    Integer minStr = Integer.valueOf(Label.Non_Exempt_End_Time.substring(3, 5));
                    Integer secStr = Integer.valueOf(Label.Non_Exempt_End_Time.substring(6, 8));
                    Integer millisecStr = Integer.valueOf(Label.Non_Exempt_End_Time.substring(9, 11));
                    Time myTime =  Time.newInstance(hoursStr, minStr, secStr, millisecStr);
                    
                    // Start - Added by venkat
                    
                       System.debug('****'+ myTime );
                    //End
                    
                    mapCaseIdBusinessTime.put(cases.id, myTime);
                }
            }
            
        }catch(Exception classException) {
            
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG + classException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG1 );
        }
        return mapCaseIdBusinessTime;
    }
    
   
    /*******************************************************************
    Purpose: REQ 3318 - This method increments the frequency counter and prevent to modify the dispute date more than one time. 
    Parameters: List<Case>
    Returns: none 
    Throws [Exceptions]: ClassException
    ********************************************************************/
    public static void incrementReceivedDateFrequencyCounter(List<Case> caseList){
        
        if(!ManageExecutions.isTriggered){
            
            for(Case gCase : caseList){
                
                if(gCase.Dispute_Received_Updated_Frequency__c <> null){
                
                    gCase.addError('You cannot update Date Grievance/Dispute Received field more than 1 time');
                    system.debug('#####freq is >=1');
                }
                else if(gCase.Dispute_Received_Updated_Frequency__c == null){
                            
                    gCase.Dispute_Received_Updated_Frequency__c = 0;
                    system.debug('#####freq is null');
                }
            }
            ManageExecutions.isTriggered = true;
        } 
    }
    
    
    /*******************************************************************
    Purpose: REQ 3318 - This method updates the milestone dates if dispute date is changed.
    Parameters: List<Case>
    Returns: none 
    Throws [Exceptions]: ClassException
    ********************************************************************/
    
    @future
    public static void caseUpdateMilestoneDate(Set<String> grievanceCaseIdSet){
    
        List<CaseMilestone> caseMilestonesToUpdate = new List<CaseMilestone>();
        List<CaseMilestone> caseMilestoneList = new List<CaseMilestone>();
        Map<Id, Time> mapCaseIdendTime = new Map<Id, Time>();
        Set<Id> caseIdSet = new Set<Id>();
        Datetime myDate;
        
        try
        {
            List<Case> insertUpdateCases = [select Secondary_Reason__c,Date_Grievance_Requested__c from Case where id IN : grievanceCaseIdSet];
            caseMilestoneList = [Select id, StartDate, CaseId,TargetResponseInMins from CaseMilestone where CaseId IN : grievanceCaseIdSet];
            system.debug('@@future caseMilestoneList'+ caseMilestoneList);
            
            if(!caseMilestoneList.isEmpty()){
                
                if(!insertUpdateCases.isEmpty()){
                    
                    mapCaseIdendTime = calculateEndTimeBusinessHours(insertUpdateCases);
                    
                     //Start - Added by venkat
                   System.debug('-----'+mapCaseIdendTime);
                
                   //End
                }
                
                if(!mapCaseIdendTime.isEmpty()){
                
                    for(Case grieveCase : insertUpdateCases){
                        
                        Datetime disputeDate = grieveCase.Date_Grievance_Requested__c;
                        
                        for(CaseMilestone cm : caseMilestoneList){
                            if(mapCaseIdendTime.containsKey(cm.caseId)){
                                if(grieveCase.Date_Grievance_Requested__c <> null){
                                    
                                    Time endTime = mapCaseIdendTime.get(cm.caseId);
                                    system.debug('@@endTime  : '+ endTime);
                                    system.debug('@@cm.TargetResponseInMins : '+ cm.TargetResponseInMins);
                                    cm.StartDate = Datetime.newInstance(disputeDate.year(), disputeDate.month(), disputeDate.day(), endTime.hour(), endTime.minute(), endTime.second());
                                    Date formatDate = cm.StartDate.date();
                                    Date daySavingDate = Date.newInstance(2015,3,8);
                                    DateTime targetDateTime = cm.StartDate.addMinutes(cm.TargetResponseInMins);
                                    Date formatTargetDate = targetDateTime.date();  
                                    if((formatDate < daySavingDate) && (formatTargetDate>= daySavingDate)) {
                                        endTime = endTime.addHours(-1);
                                        system.debug('@@endTime1  : '+ endTime);
                                        cm.StartDate = Datetime.newInstance(disputeDate.year(), disputeDate.month(), disputeDate.day(), endTime.hour(), endTime.minute(), endTime.second());
                                    }
                                    /*if(cm.TargetResponseInMins <36000) {
                                        cm.StartDate = Datetime.newInstance(disputeDate.year(), disputeDate.month(), disputeDate.day(), endTime.hour(), endTime.minute(), endTime.second());
                                    }  else if(cm.TargetResponseInMins >=36000) {
                                        endTime = endTime.addHours(-1);
                                        system.debug('@@endTime1  : '+ endTime);
                                        cm.StartDate = Datetime.newInstance(disputeDate.year(), disputeDate.month(), disputeDate.day(), endTime.hour(), endTime.minute(), endTime.second());
                                    }*/ 
                                    system.debug('@@cm.StartDate : '+ cm.StartDate);
                                    system.debug('@@cm.targetDate : '+ cm.targetDate);
                                    caseMilestonesToUpdate.add(cm);
                                }
                                else if(grieveCase.Date_Grievance_Requested__c == null){
                                
                                    Time endTime = mapCaseIdendTime.get(cm.caseId);
                                    //cm.StartDate = Datetime.newInstance(date.today().year(), date.today().month(), date.today().day(), endTime.hour(), endTime.minute(), endTime.second());
                                    cm.StartDate = Datetime.newInstance(date.today().year(), date.today().month(), date.today().day(), endTime.hour(), endTime.minute(), endTime.second());
                                    Date formatDate = cm.StartDate.date();
                                    Date daySavingDate = Date.newInstance(2015,3,8);
                                    DateTime targetDateTime = cm.StartDate.addMinutes(cm.TargetResponseInMins);
                                    Date formatTargetDate = targetDateTime.date();  
                                    if((formatDate < daySavingDate) && (formatTargetDate>= daySavingDate)) {
                                        endTime = endTime.addHours(-1);
                                        system.debug('@@endTime1  : '+ endTime);
                                        cm.StartDate = Datetime.newInstance(date.today().year(), date.today().month(), date.today().day(), endTime.hour(), endTime.minute(), endTime.second());
                                    }
                                    system.debug('@@cm.StartDate : '+ cm.StartDate);
                                    caseMilestonesToUpdate.add(cm);
                                }
                            }
                        }
                    }
                }
            }
            
            if(!caseMilestonesToUpdate.isEmpty()){
            
                Database.update(caseMilestonesToUpdate);
            }
        }catch(Exception TriggerException) {
            
            system.debug(triggerException.getMessage() + EXEPTION_MSG + triggerException.getStackTraceString() + EXEPTION_MSG + triggerException.getTypeName() + EXEPTION_MSG + System.now() + EXEPTION_MSG + EXEPTION_MSG1 );
        }
    }
}