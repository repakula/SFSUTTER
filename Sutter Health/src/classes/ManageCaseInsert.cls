/**  
*    Class Name: ManageCaseInsert
*    Author: Brandon Cassis
*    Date: 9-September-2013
*    Description: This class is used to store the methods that process when a Case is Inserted into the 
*                    database. The indivdual methods get called based on if the criteria around the record
*                    matches in the criteria set in ManageCasesDatabase.
*    History
*    VERSION    AUTHOR              DATE        DETAIL 
*      2.0     Atul Gupta      March 13, 2014    Made changes to AssignEntitlementAndBusinessHours method and added condition to set the 
*                                               Entitlement forExpedited Cases on Case creation
*    3.0       Umesh Vajpai     June 21, 2014   REQ 3835- Added if( loopCase.Origin !='Web') in AssignChildCases()
*
*    --------
**/

public class ManageCaseInsert {

    /**
    *   @Description: This method takes a list of Cases with a ParentId. For each record, it maps the case value of
    *   the parent onto the newly inserted Case. This is built statically and values cannot be added dynamically.
    *   @Arguments: List of Cases 
    *   @Return: Void
    **/
    public static void AssignChildCases(List<Case> inputList) {
        
        /** @ Description: List and Maps used to store the Parent Case and its related values.**/
        List<Case> parentCaseList = new List<Case>();
        Map<Id, String> parentCaseOrigin = new Map<Id, String>();
        Map<Id, String> parentCaseContactRegion = new Map<Id, String>();
        Map<Id, Id> parentCaseContact = new Map<Id, Id>();
        Map<Id, Id> parentCaseAccount = new Map<Id, Id>();
        Map<Id, Id> parentCasePatient = new Map<Id, Id>();
        Map<Id, Id> parentCaseGuarantor = new Map<Id, Id>();
        Map<Id, Id> parentCasePatientAccount = new Map<Id, Id>();
        List<Case> cases = new List<Case>();
        //Map variable for Case Record Types 
        Map<string, string> caseRecordTypeIdMap = new Map<string, string>();
        
        /** @ Description: Set and List used to filter down the Parent Cases being iterated over.**/
        Set<Id> parentCaseIds = new Set<Id>();
        List<Id> parentCaseSOQLList = new List<Id>();
        Map<String,Schema.RecordTypeInfo> caseRtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
        /*for(RecordType rec:[select Id, Name from RecordType where sObjectType = 'Case'])
        {
            caseRecordTypeIdMap.put(rec.Name, rec.Id);
        }*/
        for(Schema.RecordTypeInfo rtype : caseRtMapByName.values()){
                caseRecordTypeIdMap.put(rtype.getName(), rtype.getRecordTypeId());
            }
        /** @ Description: For loop used to get all of the Parent Case Ids and the new Cases.**/
        for(Case loopCase: inputList){
            if(loopCase.ParentId != null) {
                parentCaseSOQLList.add(loopCase.ParentId);
                cases.add(loopCase);
            }
        }
        
        /** @ Description: Check to see if there are values to do a SOQL against.**/
        if(parentCaseSOQLList != null && parentCaseSOQLList.size() > 0) {
        
            /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
            //try{
            
                /** @ Description: SOQL to return the Parent Cases and their needed values.**/
                parentCaseList = [select Id, CaseNumber, Origin, Contact_Region__c, Patient__c, Patient_Account__c, Guarantor__c, ContactId, AccountId From Case Where Id IN :parentCaseSOQLList];
           // }catch(Exception triggerException){
           //     Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
           // }
        }
        
        /** @ Description: Check to see if the SOQL returned any Parent Cases before entering processing.**/
        if(parentCaseList.size() > 0 ) {
        
            /** @ Description: Iterate over parent Cases to assign values to maps.**/
            for(Case parentCase: parentCaseList){
                
                /** @ Description: Check to insure the ParentId has not already been processed.**/
                if(!(parentCaseIds.contains(parentCase.Id))){
                    
                    /** @ Description: Adds the Id to the Set to insure it is only added once.**/
                    parentCaseIds.add(parentCase.Id);
                    
                    /** @ Description: Check to insure value is on the Parent, if so it adds it to the map.**/
                    if(parentCase.Origin != null) {
                        parentCaseOrigin.put(parentCase.Id, parentCase.Origin);
                    }
                    
                    /** @ Description: Check to insure value is on the Parent, if so it adds it to the map.**/
                    if(parentCase.Contact_Region__c != null) {
                        parentCaseContactRegion.put(parentCase.Id, parentCase.Contact_Region__c);
                    }
                    
                    /** @ Description: Check to insure value is on the Parent, if so it adds it to the map.**/
                    if(parentCase.ContactId != null) {
                        parentCaseContact.put(parentCase.Id, parentCase.ContactId);
                    }
                    
                    /** @ Description: Check to insure value is on the Parent, if so it adds it to the map.**/
                    if(parentCase.AccountId != null) {
                        parentCaseAccount.put(parentCase.Id, parentCase.AccountId);
                    }
                    
                    /** @ Description: Check to insure value is on the Parent, if so it adds it to the map.**/
                    if(parentCase.Patient__c != null) {
                        parentCasePatient.put(parentCase.Id, parentCase.Patient__c);
                    }
                    
                    /** @ Description: Check to insure value is on the Parent, if so it adds it to the map.**/
                    if(parentCase.Patient_Account__c != null) {
                        parentCasePatientAccount.put(parentCase.Id, parentCase.Patient_Account__c);
                    }
                    
                    /** @ Description: Check to insure value is on the Parent, if so it adds it to the map.**/
                    if(parentCase.Guarantor__c != null) {
                        parentCaseGuarantor.put(parentCase.Id, parentCase.Guarantor__c);
                    }
                } 
            }
            
            /** @ Description: Iterate over Cases originally passed to the method.**/
            for(Case loopCase:cases) {
                
                /** @ Description: Check to insure the ParentId has a value.**/
                if(loopCase.ParentId != null && loopCase.Origin !='Portal' ) {
                
                    
                    if( loopCase.Origin !='Web')
                    {
                    /** @ Description: Check to insure Map has the Key and then it copies the value.**/
                    if(parentCaseOrigin.containsKey(loopCase.ParentId) && !(caseRecordTypeIdMap.get(system.Label.CL31_Provider_Dispute) == loopCase.RecordTypeId || caseRecordTypeIdMap.get(system.Label.CL34_ProviderDisputeRO) == loopCase.RecordTypeId)) { // Offshore: added the condition to by pass setting the origin for Provider Dispute SR
                        loopCase.Origin = parentCaseOrigin.get(loopCase.ParentId);
                    }
                    
                    } 
                    
                    /** @ Description: Check to insure Map has the Key and then it copies the value.**/
                    if(parentCaseContactRegion.containsKey(loopCase.ParentId)) {
                        loopCase.Contact_Region__c = parentCaseContactRegion.get(loopCase.ParentId);
                    }
                    
                    /** @ Description: Check to insure Map has the Key and then it copies the value.**/
                    if(parentCaseContact.containsKey(loopCase.ParentId)) {
                        loopCase.ContactId = parentCaseContact.get(loopCase.ParentId);
                    }
                    
                    /** @ Description: Check to insure Map has the Key and then it copies the value.**/
                    if(parentCaseAccount.containsKey(loopCase.ParentId)) {    
                        loopCase.AccountId = parentCaseAccount.get(loopCase.ParentId);
                    }
                    
                    /** @ Description: Check to insure Map has the Key and then it copies the value.**/
                    if(parentCasePatient.containsKey(loopCase.ParentId)) {
                        loopCase.Patient__c = parentCasePatient.get(loopCase.ParentId);
                    }
                    
                    /** @ Description: Check to insure Map has the Key and then it copies the value.**/
                    if(parentCasePatientAccount.containsKey(loopCase.ParentId)) {    
                        loopCase.Patient_Account__c = parentCasePatientAccount.get(loopCase.ParentId);
                    }
                    
                    /** @ Description: Check to insure Map has the Key and then it copies the value.**/
                    if(parentCaseGuarantor.containsKey(loopCase.ParentId)) {
                        loopCase.Guarantor__c = parentCaseGuarantor.get(loopCase.ParentId);
                    }
                }
            }
        } 
    }
    
    /**
    *   @Description: This method takes a list of Cases. For each record, it maps the case or the record type
    *                    to a custom setting that matches that record type to a Entitlement. The method maps 
    *                    both the Enititlement and its Business hours to the Case to add the appropriate
    *                    CaseMilestones with related SLAs.
    *   @Arguments: List of Cases 
    *   @Return: Void
    **/  
    public static void AssignEntitlementAndBusinessHours(List<Case> inputList) {
        
        /** @ Description: Lists and Maps used to store the Entitlements, Record Types, and Associated linking Custom Settings.**/
        //List<RecordType> recordTypes = new List<RecordType>();
        Map<Id,String> recordTypeMap = new Map<Id, String>();
        Map<String, EntitlementRecordType__c> entitlementRecordMap = EntitlementRecordType__c.getAll();
        List<EntitlementRecordType__c> entitlementRecordList = entitlementRecordMap.values();
        List<Entitlement> entitlements;
        Map<String, Entitlement> entitlementMap = new Map<String, Entitlement>();
        Set<String> entitlementRecordSet = new Set<String>();
        
        /** @ Description: Check insuring first run. Sets external flag.**/
        if(!(ManageExecutions.isSameEntitlementBusinessHoursExecution)) {
            ManageExecutions.setSameEntitlementBusinessHoursExecution();
            
            /** @ Description: Iterate over custom settings grabbing Entitlement Record Types listed.**/
            for(EntitlementRecordType__c entitlementRecord: entitlementRecordList) {
                entitlementRecordSet.add(entitlementRecord.Entitlement__c);
            }
            
            /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
            //try{
                
                /** @ Description: SOQL call the Id and Name of Case Record Types for evaluation.**/
                //recordTypes = [Select Id, Name, sObjectType From RecordType where sObjectType = 'Case'];  
                Map<String,Schema.RecordTypeInfo> caseRtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
           /* } catch(Exception TriggerException) {
                Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }*/
            
            /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
            //try{
            
                /** @ Description: SOQL call the Entitlement and Business Hours in the Custom Settings.**/
                entitlements = [select Id, Name, BusinessHoursId From Entitlement where Name IN :entitlementRecordSet];
           /* } catch(Exception TriggerException) {
                Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }*/
            
            /** @ Description: Iterate over Record types to get a ID key Name value Map.**/
            /*for(RecordType loopRecordtype: recordTypes){
                recordTypeMap.put(loopRecordtype.Id,loopRecordtype.Name);
            }*/
            for(Schema.RecordTypeInfo rtype : caseRtMapByName.values()){
                recordTypeMap.put(rtype.getRecordTypeId(),rtype.getName());
            }
            /** @ Description: Iterate over Entitlements to get a Name key Entitlement value Map.**/
            for(Entitlement loopEntitlement: entitlements){
                entitlementMap.put(loopEntitlement.Name, loopEntitlement);
            }
            
            /** @ Description: Sets Maps created in an external class incase re-ran.**/
            ManageExecutions.setRecordTypeMap(recordTypeMap);
            ManageExecutions.setEntitlementMap(entitlementMap);
        } else {
            
            /** @ Description: Gets Maps from external class if it is not the methods first run.**/
            recordTypeMap.putAll(ManageExecutions.recordTypeMap);
            entitlementMap.putAll(ManageExecutions.entitlementMap);
        }
        
        /** @ Description: Iterate over Cases to assign Entitlements and Business Hours.**/
        for(Case loopCase: inputList) {
            
                /** @ Description: Check to insure the Map has the Case Record Type being evaluated from.**/
                if(entitlementRecordMap.containsKey(recordTypeMap.get(loopCase.RecordTypeId))){
                    
                /** @ Description: Try Catch to prevent Cases entered into the system without Entitlement or Business Hours.*/
                try{
                
                    /** @ Description: Sets the Entitlement and Business Hours of the Case.**/
                    loopCase.EntitlementId = entitlementMap.get(entitlementRecordMap.get(recordTypeMap.get(loopCase.RecordTypeId)).Entitlement__c).Id; 
                    
                    loopCase.BusinessHoursId = entitlementMap.get(entitlementRecordMap.get(recordTypeMap.get(loopCase.RecordTypeId)).Entitlement__c).BusinessHoursId; 
                    
                    /** @ Description: Sets the Entitlement of the Case for Expedited **/
                    if(loopCase.Secondary_Reason__c == Label.CL42_Grievance_Expedited)
                    {
                        loopCase.EntitlementId = entitlementMap.get(entitlementRecordMap.get(Label.CL42_Grievance_Expedited).Entitlement__c).Id;
                    }
                
                } catch(Exception TriggerException) {
                    
                    /** @ Description: Error added if assignment fails to stop further processing.**/
                    loopCase.addError('Assignment failed');
                    Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                }
            } 
        }
    }
    
    /**
    *   @Description: This method takes a list of Cases where their record type matches that listed as a portal
    *                    SR. The method created an Interaction Log that grabs values related to the SR.
    *   @Arguments: List of Cases 
    *   @Return: Void
    **/ 
    public static void CreateILPortalSR(List<Case> inputList) {
        
        /** @ Description: List, Map, and Variable used to store the new IL and its values.**/
        Map<Id, Case> SRILMap = new Map<Id, Case>();     
        List<Case> newIlList = new List<Case>();
        String ILrecordTypeId;
        
        /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
        try{
            
            /** @ Description: SOQL call to retrieve the Interaction Log Record Type to create an Interaction Log with.**/
            /*ILrecordTypeId = [select Id,SobjectType,Name from RecordType where DeveloperName =: system.label.CL25_S3_Interaction_Log_API and SObjectType='Case' limit 1].Id;*/  
            ILrecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S3 Interaction Log').getRecordTypeId();
        } catch(Exception TriggerException){
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        
        /** @ Description: Interative over each Case and created a Parent Interation Log and set its values.**/
        for(Case loopCase: inputList) {
            Case tempCase = new Case();
            tempCase.RecordTypeId = ILrecordTypeId;
            tempCase.Origin = Label.cl_CaseTrigger_Web_Origin;
            tempCase.Status = Label.cl_CaseTrigger_closed_Status;
            tempCase.ContactId = loopCase.ContactId;
            tempCase.Sub_Function__c = Label.cl_CaseTrigger_CV_Subfunction;
            tempCase.Close_Comments__c = Label.cl_CaseTrigger_Close_Comments;
            tempCase.Subject = loopCase.Subject;
            tempCase.Description = loopCase.Description;
            tempCase.SR_Associated__c = true;
            tempCase.Interaction_Verified__c = true;
            SRILMap.put(loopCase.Id, tempCase);
            newIlList.add(tempCase); 
        }
        
        /** @ Description: Try Catch to protect the user from errors in the DML call.**/
        try{
            
            /** @ Description: DML operation to insert the new Interaction Logs created.**/
            Insert newIlList;
        } catch(Exception TriggerException){
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        
        /** @ Description: Iteration over Portal SRs to add the newly inserted Parent Case.**/
        for(Case loopCase: inputList) {
            if(SRILMap != null && SRILMap.containsKey(loopCase.Id)) {
                loopCase.ParentId = SRILMap.get(loopCase.Id).Id;
            }
        }
    }
    
    /**
    *   @Description: This method takes a list of Cases that are from the Grievance Web-to-Case. For each 
    *                    record, it creates a Grievance SR attached to the Web-to-Case Interaction Log.
    *   @Arguments: List of Cases 
    *   @Return: Void
    **/
    public static void GrievanceWebToCase(List<Case> inputList) {
        
        /** @ Description: Lists used to store the new SRs and the Grievance Record Type Id.**/
        List<Case> newGrievanceSR = new List<Case>();
        String ILrecordTypeId;
        AssignmentRule assignRule = new AssignmentRule(); 
        Database.DMLOptions dmlOpts = new Database.DMLOptions(); 
        
        assignRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1]; 
        dmlOpts.assignmentRuleHeader.assignmentRuleId = assignRule.id; 
        
        /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
        //try{
            
            /** @ Description: SOQL call to get the Grievance Record Type Id for the new Grievance SRs created**/
            /*ILrecordTypeId = [select Id,SobjectType,Name from RecordType where DeveloperName =: system.label.CL26_SHP_Grievance_RT_API and SObjectType='Case' limit 1].Id;*/ 
            ILrecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Grievance').getRecordTypeId();
            
       /* } catch(Exception TriggerException){
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }*/
        
        /** @ Description: Iterates over the Web-to-Case Grievance IL and creates a related Grievance SR for each.**/
        for(Case loopCase: inputList) {
            Case newGSR = new Case();
            newGSR.RecordTypeId = ILrecordTypeId;
            newGSR.ParentId = loopCase.Id;
            newGSR.Origin = Label.cl_CaseTrigger_Web_Origin;
            newGSR.Reason__c = Label.cl_CaseTrigger_Grievance_Reason;
            system.debug('Testing Testing'+loopCase.Case_involve_cbk__c);
            system.debug('Testing Testing Testing'+loopCase.Case_Grievance_Conference_cbk__c);
            //Req# 3175-Added New Check box on Webtocase Form
              newGSR.Case_involve_cbk__c = loopCase.Case_involve_cbk__c;
              newGSR.Case_Grievance_Conference_cbk__c = loopCase.Case_Grievance_Conference_cbk__c;
            
            system.debug('*************'+newGSR.Case_involve_cbk__c);
            
            if (newGSR.Case_involve_cbk__c == false){
            newGSR.Secondary_Reason__c = Label.cl_CaseTrigger_Grievance_Secondary_Reason;
            }
            else{
            newGSR.Secondary_Reason__c = 'Expedited';
            }
            newGSR.status = Label.cl_CaseTrigger_New_Status;
            //Req# 3175-Added New Check box on Webtocase Form
           // newGSR.Case_involve_cbk__c = loopCase.Case_involve_cbk__c;
            newGSR.setOptions(dmlOpts); 
            newGrievanceSR.add(newGSR);
            
        }
        
        /** @ Description: Method calls to process the newly created SRs with the other Case Insert methods.**/
        AssignChildCases(newGrievanceSR);
        AssignEntitlementAndBusinessHours(newGrievanceSR);
        SetSurveyForce(newGrievanceSR);
        
        /** @ Description: Try Catch to protect the user from errors in the SOQL call.**/
        try{
        
            /** @ Description: DML operation that inserts the newly create Grievance SRs.**/
            insert newGrievanceSR;
        } catch(Exception TriggerException){
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }  
    } 
    
    /**
    *   @Description: This method takes a list of Cases that are from the Grievance Web-to-Case. For each 
    *                    record, it tries to find an contact based on the member Id and associated that record
    *                    to the contact.
    *   @Arguments: List of Cases 
    *   @Return: Void
    **/ 
    public static void GrievanceILToMember(List<Case> inputList) {
        
        /** @ Description: Lists used to store the records for processing and the related contacts searched for.**/
        List<Contact> memberContactsStandardField = new List<Contact>();
        List<Contact> memberContactsFormulaField = new List<Contact>();
        List<String> memberValues = new List<String>();
        //RecordType memberRecordType = new RecordType();
        /** @ Description: Flag used if contact is found.**/
        Boolean isAssociatedMember = false;
        //memberRecordType = [select ID from RecordType where DeveloperName =: label.MemberRecordTypeLabel];
         Id memberRecordTypeId = null; 
         Schema.RecordTypeInfo recType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(label.MemberRecordTypeLabel);
         if(recType != null)
         {
             memberRecordTypeId = recType.getRecordTypeId();
         }
        system.debug(inputList.size() + 'inputLIst size');
        /** @ Description: Iterate over inserted Cases and grabs the member Id to search off of.**/
        for(Case loopCase: inputList) {
            system.debug(loopCase.Grievance_Web_Form_Member_ID__c + 'GRIEVANCE WEB FORM HCC ID'); 
            if (loopCase.Grievance_Web_Form_Member_ID__c != null) memberValues.add(loopCase.Grievance_Web_Form_Member_ID__c);
        }
        system.debug(memberValues + 'memberValues'); 
        system.debug(memberValues.size() + 'memberValues Size');
        /** @ Description: Check to insure records have a Member ID to search for.**/
        if(memberValues != null && memberValues.size() > 0) {
            
            /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
            //try{
            
                /** @ Description: SOQL to search for Member Id based on the standardly formatted HCC ID field.**/
                memberContactsStandardField = [select Id, Member_HCC_ID__c From Contact Where Member_HCC_ID__c IN :memberValues AND Member_HCC_ID__c != '' AND RecordTypeID =: memberRecordTypeId];
            /*} catch(Exception TriggerException){
                Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }*/
            
            /** @ Description: Try Catch to protect the user from errors in the SOQL call**/
           // try{
                
                /** @ Description: SOQL to search for Member Id based on the formula field formatted HCC ID field. (Without 'M' or '-')**/
                memberContactsFormulaField = [select Id, MemberIdField__c From Contact Where MemberIdField__c IN :memberValues AND MemberIdField__c != '' AND RecordTypeID =: memberRecordTypeId];
            /*} catch(Exception TriggerException){
                Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }*/
            
            /** @ Description: Interation over the Cases to check if a Member was found in the SOQLS.**/
            for(Case loopCase: inputList) {
            
                /** @ Description: Reset the flag that a member has not been found for each Case.**/
                isAssociatedMember = false;
                
                /**
                *   @Description: Check to see if the standard search returned results, followed by an iteration
                *                    over the results to attempt to match the Contact to the Case. 
                **/ 
                if(memberContactsStandardField != null && memberContactsStandardField.size() > 0) {
                    for(Contact loopContact: memberContactsStandardField) {
                        if(loopCase.Grievance_Web_Form_Member_ID__c == loopContact.Member_HCC_ID__c) {
                            loopCase.ContactId = loopContact.Id;
                            isAssociatedMember = true;
                        }
                    }
                }
                
                /**
                *   @Description: Check to see if the formula search returned results, followed by an iteration
                *                    over the results to attempt to match the Contact to the Case. 
                **/
                if(memberContactsFormulaField != null && memberContactsFormulaField.size() > 0) {
                    for(Contact loopContact: memberContactsFormulaField) {
                        if(loopCase.Grievance_Web_Form_Member_ID__c == loopContact.MemberIdField__c) {
                            loopCase.ContactId = loopContact.Id;
                            isAssociatedMember = true;
                        }
                    }
                }
                
                /** @ Description: Check to see if a Member was found. Subject modified if not.**/
                if(!isAssociatedMember) {     
                    loopCase.Subject = Label.cl_CaseTrigger_IL_NonAssociated_Subject;
                }
            }
        }
    }
    
    /**
    *   @Description: This method takes a list of Cases. It adds a checkbox to the Parent Case as a criteria
    *                    for a workflow rule so that the Parent Case does not receive a Survey.
    *   @Arguments: List of Cases 
    *   @Return: Void
    **/
    public static void SetSurveyForce(List<Case> inputListCases) {
    
        system.debug('make it to survey');
        
        /** @ Description: Lists and Set used to store the records for processing.**/   
        Set<Id> parentCaseIds = new Set<Id>();
        List<Case> parentCases = new List<Case>();
        List<Case> updateParentCases = new List<Case>();
        
        /** @ Description: Iterate over the records to insure they have Parents needed to update.**/
        for(Case loopCase: inputListCases) {
            if(loopCase.ParentId != null)
            parentCaseIds.add(loopCase.ParentId);
        } 
        system.debug(parentCaseIds.size());
        
        /** @ Description: Try Catch to protect the user from errors in the SOQL call.**/
        //try{
        
            /** @ Description: SOQL call to grab all of Cases' Parent Cases for updating.**/
            parentCases = [select Id, SR_Associated__c From Case Where Id IN :parentCaseIds];
       /* } catch(Exception triggerException) {
            Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }*/
        
        /** @ Description: Iterate over Parent Cases and then a check to see if the SR_Associated box needs updating.**/
        for(Case loopCase: parentCases) {
            if(!loopCase.SR_Associated__c) {
                loopCase.SR_Associated__c = true;
                updateParentCases.add(loopCase);
            }
        }
        
        /** @ Description: Check to insure there are Parent Cases to update.**/
        if(updateParentCases != null && updateParentCases.size() > 0) {
            
            /** @ Description: Try Catch to protect the user from errors in the DML call**/
            try{
                
                /** @ Description: DML operation that updates the Parent Case with the workflow flag set.**/
                update updateParentCases;
            } catch(Exception triggerException) {
                Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }
        }
    }  
}