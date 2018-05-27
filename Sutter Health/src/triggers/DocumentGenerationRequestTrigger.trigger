/******************************************************************************************************************* 
     Trigger Name : DocumentGenerationRequestTrigger 
     Author     : IDC Offshore
     Date       : 10/19/2016
     Description: This Trigger is written to make Field updations on Document Generation Request based on Criteria
     History:
     VERSION    AUTHOR              DATE        DETAIL 
     1.0        IDC-Offshore      10/19/2016    It is used to make Field updations on Document Generation Request based on Criteria
*******************************************************************************************************************/
trigger DocumentGenerationRequestTrigger on Document_Generation_Request__c (before update) {
    BusinessHours busHours=[select id from BusinessHours where Name =:System.label.HR138_SHPBusinessHours limit 1];
    Map<String,SF_P2A_Market_Segments_Mapping__c> groups = SF_P2A_Market_Segments_Mapping__c.getAll();
    Integer BusinessHoursPerDay = 9; // Variable to Store No.of Business Hours per Day
    Integer ConversionFactor = 60*60*1000;// Variable stores Minutes*Seconds*1000 - Used to Convert Hours into Milliseconds 
    
    if(Trigger.isUpdate && Trigger.isBefore){ 
        for(Document_Generation_Request__c docGenObj : Trigger.New){ 
            /*Show error message to user during QA Approval if Status is not Documents Generated*/
            if(docGenObj.Status__c != System.label.HR239_DocumentsGenerated && 
               Trigger.oldMap.get(docGenObj.id).Request_Status__c != Trigger.newMap.get(docGenObj.id).Request_Status__c && 
               Trigger.newMap.get(docGenObj.id).Request_Status__c.equalsIgnoreCase(System.label.HR240_ApprovedByBPAQA))
            {
                docGenObj.addError(System.label.HR241_DocGenQAStatusError);
                return;
            }
            SF_P2A_Market_Segments_Mapping__c grp = groups.get(docGenObj.Employer_Type__c);
            /*Nullify Request Due Date value when status is changed to 'On Hold'*/
            if(Trigger.oldMap.get(docGenObj.id).Status__c != Trigger.newMap.get(docGenObj.id).Status__c && 
               Trigger.newMap.get(docGenObj.id).Status__c.equalsIgnoreCase(System.label.HR139_OnHold)){  
                docGenObj.Request_Due_Date__c = NULL;      
            }
            /*Update Request Approved Date when Request Status is changed as 'Approved'*/
            if(Trigger.oldMap.get(docGenObj.id).Request_Status__c != Trigger.newMap.get(docGenObj.id).Request_Status__c && 
               Trigger.newMap.get(docGenObj.id).Request_Status__c.equalsIgnoreCase(System.label.HR140_Approved)){  
                docGenObj.Request_Approved_Date__c = System.today();   
            }
            /*Check if Status is Changed from On Hold to Draft and Has Custom Plans is not true*/
            if(Trigger.oldMap.get(docGenObj.id).Status__c.equalsIgnoreCase(System.label.HR139_OnHold) && Trigger.newMap.get(docGenObj.id).Status__c.equalsIgnoreCase(System.label.HR141_Draft) && Trigger.newMap.get(docGenObj.id).has_Custom_Plans__c != true){
                /*Update Request Due Date as 3 Business days away from Request Created Date if Expedite is Not True*/
                if(docGenObj.Expedite__c != True && docGenObj.Request_Created_Date__c != NULL ){
                    docGenObj.Request_Due_Date__c = Date.valueOf(BusinessHours.add(busHours.id,docGenObj.Request_Created_Date__c,3*BusinessHoursPerDay*ConversionFactor));
                }
                /*Update Request Due Date as 1 Business day away from Request Created Date if Expedite is checked*/
                else if(docGenObj.Expedite__c == True && docGenObj.Request_Created_Date__c != NULL){
                    docGenObj.Request_Due_Date__c = Date.valueOf(BusinessHours.add(busHours.id,docGenObj.Request_Created_Date__c,1*BusinessHoursPerDay*ConversionFactor));    
                }
            }
            /*Nullify Request Date when Has Custom Plan is True*/
            else if(Trigger.newMap.get(docGenObj.id).has_Custom_Plans__c == true){
                 docGenObj.Request_Due_Date__c = Null;      
            }
            /*Check if Expedite is Changed*/
            if(Trigger.oldMap.get(docGenObj.id).Expedite__c != Trigger.newMap.get(docGenObj.id).Expedite__c && Trigger.newMap.get(docGenObj.id).has_Custom_Plans__c != true){
                /*Update Request Due Date as 1 Business day away from Request Created Date if Expedite is checked*/
                if(Trigger.newMap.get(docGenObj.id).Expedite__c == true && docGenObj.Request_Created_Date__c != NULL){
                    docGenObj.Request_Due_Date__c = Date.valueOf(BusinessHours.add(busHours.id,docGenObj.Request_Created_Date__c,1*BusinessHoursPerDay*ConversionFactor));    
                }
                /*Update Request Due Date as 3 Business days away from Request Created Date if Expedite is Unchecked*/
                else if(Trigger.newMap.get(docGenObj.id).Expedite__c != true && docGenObj.Request_Created_Date__c != NULL ){  
                    docGenObj.Request_Due_Date__c = Date.valueOf(BusinessHours.add(busHours.id,docGenObj.Request_Created_Date__c,3*BusinessHoursPerDay*ConversionFactor));  
                }
            }
            /*Nullify Request Date when Has Custom Plan is True*/
            else if(Trigger.newMap.get(docGenObj.id).has_Custom_Plans__c == true){
                 docGenObj.Request_Due_Date__c = Null;      
            }
        }
    }
}