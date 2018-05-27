/**  
*     Class Name  : VFC16_CV_Portal
*     Author      : Atul Gupta
*     Date        : 17-July-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : Release 6 Req-3138 CV Portal : Extension class to support the CV Portal Case creation functionality

      History:
      08/15/2104 - Umesh Kumar Vajpai
                 - Added Default values for Function, Sub-Function and Team (TC-3087)
   
**/
public class VFC16_CV_Portal {
    
    /** Description: variable for Standard Controller
    **/
    private ApexPages.StandardController controller {get; set;}
    
    /** Description: variable to hold the case
    **/
    public Case caseRecord{get; set;}
    public String rType = '';
    
    /** Description: Name, id map of case recordtypes
    **/
    public Map<String, String> caseRecordTypeMap = new Map<String, String>();
    public String rTypeId = '';
    
    /** Description: boolean variables to show different sections as per the case recordtype
    **/
    public boolean addressChange{get;set;}
    public boolean applicationRequest{get;set;}
    public boolean dateChangeRequest{get;set;}
    public boolean expirablesRequest{get;set;}
    public boolean otherRequest{get;set;}
    public boolean reapplicationRequest{get;set;}
    public boolean reportRequest{get;set;}
    public boolean rushApplicationRequest{get;set;}
    public boolean tempPrivilegeRequest{get;set;}
    
    
    /** Description: contructor for the class, takes standard controller as parameter
    **/
    public VFC16_CV_Portal(ApexPages.StandardController controller) 
    {
        try
        {
            addressChange = false;
            applicationRequest = false;
            dateChangeRequest = false;
            expirablesRequest = false;
            otherRequest = false;
            reapplicationRequest = false;
            reportRequest = false;
            rushApplicationRequest = false;
            tempPrivilegeRequest = false;
            
            this.controller = controller;
            
            /** Description: typecast case record to case variable
            **/
            this.caseRecord = (Case)controller.getRecord();
            
            /** Description: capture case recordtype url parameter
            **/
            rType = ApexPages.currentPage().getParameters().get('RT');
            
            /** Description: if recordtype is address change
            **/
            if(rType == 'CV_Address_Change_Request')
            {
                addressChange = true;
                applicationRequest = false;
                dateChangeRequest = false;
                expirablesRequest = false;
                otherRequest = false;
                reapplicationRequest = false;
                reportRequest = false;
                rushApplicationRequest = false;
                tempPrivilegeRequest = false;
                
                //set the case team default value
                caseRecord.Team__c = '[Tier 3] CV Priority Queue';
                
            }
            
            /** Description: if recordtype is application request
            **/
            else if(rType == 'CV_Application_Request')
            {
                addressChange = false;
                applicationRequest = true;
                dateChangeRequest = false;
                expirablesRequest = false;
                otherRequest = false;
                reapplicationRequest = false;
                reportRequest = false;
                rushApplicationRequest = false;
                tempPrivilegeRequest = false;
                
                //set the case team default value
                caseRecord.Team__c = '[Tier 3] CV Standard Queue';
            }
            
            /** Description: if recordtype is data change request
            **/
            else if(rType == 'CV_Data_Change_Request')
            {
                addressChange = false;
                applicationRequest = false;
                dateChangeRequest = true;
                expirablesRequest = false;
                otherRequest = false;
                reapplicationRequest = false;
                reportRequest = false;
                rushApplicationRequest = false;
                tempPrivilegeRequest = false;
                
                //set the case team default value
                caseRecord.Team__c = '[Tier 3] CV Priority Queue';
            }
            
            /** Description: if recordtype is expirables request
            **/
            else if(rType == 'CV_Expirables_Request')
            {
                addressChange = false;
                applicationRequest = false;
                dateChangeRequest = false;
                expirablesRequest = true;
                otherRequest = false;
                reapplicationRequest = false;
                reportRequest = false;
                rushApplicationRequest = false;
                tempPrivilegeRequest = false;
                
                //set the case team default value
                caseRecord.Team__c = '[Tier 3] CV Standard Queue';
            }
            
            /** Description: if recordtype is other request
            **/
            else if(rType == 'CV_Other_Request')
            {
                addressChange = false;
                applicationRequest = false;
                dateChangeRequest = false;
                expirablesRequest = false;
                otherRequest = true;
                reapplicationRequest = false;
                reportRequest = false;
                rushApplicationRequest = false;
                tempPrivilegeRequest = false;
                
                //set the case team default value
                caseRecord.Team__c = '[Tier 3] CV Standard Queue';
            }
            
            /** Description: if recordtype is cv reapplication request
            **/
            else if(rType == 'CV_Reapplication_Request')
            {
                addressChange = false;
                applicationRequest = false;
                dateChangeRequest = false;
                expirablesRequest = false;
                otherRequest = false;
                reapplicationRequest = true;
                reportRequest = false;
                rushApplicationRequest = false;
                tempPrivilegeRequest = false;
                
                //set the case team default value
                caseRecord.Team__c = '[Tier 3] CV Standard Queue';
            }
            
            /** Description: if recordtype is cv report request
            **/
            else if(rType == 'CV_Report_Request')
            {
                addressChange = false;
                applicationRequest = false;
                dateChangeRequest = false;
                expirablesRequest = false;
                otherRequest = false;
                reapplicationRequest = false;
                reportRequest = true;
                rushApplicationRequest = false;
                tempPrivilegeRequest = false;
                
                //set the case team default value
                caseRecord.Team__c = '[Tier 3] CV Priority Queue';
            }
            
            /** Description: if recordtype is cv rush application request
            **/
            else if(rType == 'CV_Rush_Application_Request')
            {
                addressChange = false;
                applicationRequest = false;
                dateChangeRequest = false;
                expirablesRequest = false;
                otherRequest = false;
                reapplicationRequest = false;
                reportRequest = false;
                rushApplicationRequest = true;
                tempPrivilegeRequest = false;
                
                //set the case team default value
                caseRecord.Team__c = '[Tier 3] CV Priority Queue';
            }
            
            /** Description: if recordtype is cv temporary privilege request
            **/
            else if(rType == 'CV_Temporary_Privilege_Request')
            {
                addressChange = false;
                applicationRequest = false;
                dateChangeRequest = false;
                expirablesRequest = false;
                otherRequest = false;
                reapplicationRequest = false;
                reportRequest = false;
                rushApplicationRequest = false;
                tempPrivilegeRequest = true;
                
                //set the case team default value
                caseRecord.Team__c = '[Tier 3] CV Priority Queue';
            }
         
         /** Description: catch statement to capture any errors in the code, show a message on the page and log as a record in system exceptions object
         **/
        }catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @date 07/17/2014
    * @description Method to create Map of Case object recordtype DeveloperName and ID
    * @param
    * @return void
    */
    public void setCaseRecordTypeMap()
    {
        /** Description: query through case recordtypes to populate map of case recordtype name and id
        **/
        for(RecordType rec: [select Id, DeveloperName from RecordType where sObjectType = 'Case'])
        {
            caseRecordTypeMap.put(rec.DeveloperName, rec.Id);
        }
    }
    
    /**
    * @author IDC Team
    * @date 07/17/2014
    * @description Method to create Map of Case object recordtype DeveloperName and ID
    * @param
    * @return pagereference pageRef
    */
    public Pagereference Save()
    {   
        /** Description: page reference variable
        **/
        Pagereference pageRef;
        try
        {
            /** Description: call the method to populate the case recordtype map
            **/
            setCaseRecordTypeMap();
            rTypeId = caseRecordTypeMap.get(rType);
            
            /** Description: set the recordtype of the case
            **/
            caseRecord.recordtypeId = rTypeId;
            
            //Set the default values for Function, Sub-Function and Team
            caseRecord.Function__c = 'Credentialing Verification';
            caseRecord.Sub_Function__c = 'Credentialing Verification';
            
            
            /** Description: default value for origin as 'Web'
            **/
            caseRecord.Origin = 'Web';
            /** Description: set dmloptions to run the assignment rule while inserting this record
            **/
            AssignmentRule aR = new AssignmentRule();
            aR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= aR.id;
            caseRecord.setOptions(dmlOpts);
            
            /** Description: validation to check if the provider is individual or group, if group then group id cannot be null
            **/
            if(rType == 'CV_Address_Change_Request' && caseRecord.Individual_Provider_or_Group_of_Provider__c == 'Group' && 
               (caseRecord.Provider_Group_ID__c == '' || caseRecord.Provider_Group_ID__c == null))
            {   
                /** Description: show an error message on page if the validation is not passed
                **/
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Provider Group Id is Required'));
              
              /** Description: else condition if recordtype is not address change request
              **/  
            } else {
                
                /** Description: insert case
                **/  
                Database.insert(caseRecord);
                
                /** Description: page reference to open case detail page
                **/  
                pageRef = new PageReference('/'+caseRecord.Id);
                
                /** Description: flushes the view state
                **/  
                pageRef.setRedirect(true);                
            }
            
         /** Description: catch statement to capture any errors in the code, show a message on the page and log as a record in system exceptions object
         **/  
        }catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        
        /** Description: return pagereference
        **/
        return pageRef;
    }
}