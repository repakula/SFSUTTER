/**  
*     Class Name  : VFC08_Adhoc_Report
*     Author      : Atul Gupta
*     Date        : 19-June-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : 
**/
public class VFC08_Adhoc_Report {

    private ApexPages.StandardController controller {get; set;}
     
    public String noteValue{get; set;}
    public Case caseRecord{get; set;}
    
    //Req. 3193 Release 6.3 Changes
    private static final string  FUNCTION_NAME = 'Human Resource';
    private static final string  SUB_FUNCTION_NAME = 'HR Information System (HRIS)';
    private static final string  TEAM_NAME = '[Tier 3] HR Reporting';
    private static final string  INTENT_NAME = 'HR Reporting';
    private static final string  SUB_INTENT_NAME = 'Adhoc Report Request Web';


    
    public VFC08_Adhoc_Report(ApexPages.StandardController controller) 
    {
        try
        {
        
            this.controller = controller;
            this.caseRecord = (Case)controller.getRecord();
            User user = [Select ContactId from User where id =: UserInfo.getUserId()];
            
           // RecordType rType = [Select Id,Name from RecordType where Name = 'Human Resources Adhoc Reports' AND SobjectType = 'Case'];
           
           //Req. 3193 Release 6.3 Changes          
            RecordType rType = [Select Id,Name from RecordType where Name = 'Human Resource Web to Case' AND SobjectType = 'Case'];         
             caseRecord.Sub_Function__c = SUB_FUNCTION_NAME ;                        
             caseRecord.Team__c=TEAM_NAME ;          
            caseRecord.Customer_Intent__c=INTENT_NAME ;         
            caseRecord.Customer_Sub_Intents__c=SUB_INTENT_NAME ;            
            Schema.DescribeFieldResult noteFieldDescribe = Case.Note__c.getDescribe();
            
            caseRecord.Note__c = noteFieldDescribe.getDefaultValueFormula();
            caseRecord.Reports_Link__c = 'http://mysutter/Resources/SystemDepartments/HRIS/CrystalLawson/Pages/CrystalReports.aspx';
            caseRecord.RecordTypeId = rType.id;
            caseRecord.ContactId = user.ContactId;
            
         }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
         }
    }
    
     public PageReference saveAndSend() 
     {
         try
         {      
            
            String errorMessage ='';
            
            if(caseRecord.Current_Date__c == null && caseRecord.As_of_Date__c == null && caseRecord.Date_Range_from__c == null)
            {
                //caseRecord.addError('Please enter a date value for one of the fields below: Current Date, As Of Date or Date Range');
                errorMessage = errorMessage + 'Please enter a date value for one of the fields below: Current Date, As Of Date or Date Range' + '</br>';
            }
            if(caseRecord.Date_Range_from__c != null && caseRecord.Date_Range_To__c == null)
            {
                //caseRecord.addError('The Date Range To field is required if Date Range From field has data');
                errorMessage = errorMessage + 'The Date Range To field is required if Date Range From field has data' + '</br>';
            }
            if (caseRecord.Report_Previously_Requested__c == 'Yes' 
             && caseRecord.Date_of_Requested_Last_Report__c == null 
             && caseRecord.Service_Request_Number__c == null
             && caseRecord.Reporting_Team_Member__c == null)
             {
                //caseRecord.addError('Please enter a value for one of the fields below: Date of Requested Last Report, Service Request Number, Reporting Team Member');
                errorMessage = errorMessage + 'Please enter a value for one of the fields below: Date of Requested Last Report, Service Request Number, Reporting Team Member' + '</br>';
             }
             
             if(errorMessage !='')
             {
                caseRecord.addError(errorMessage);
             }
            else
            {
                
                    //Assign the assignment rule to be fired
                    AssignmentRule AR = new AssignmentRule();
                    AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                    caseRecord.setOptions(dmlOpts);
                    caseRecord.Subject = caseRecord.subject__c;  
                    caseRecord.Section_View__c= System.Label.CL56_HR_Report;           
                    
                    //insert the case record into database
                    insert caseRecord;
                   
                    if(caseRecord.Internal_Comments__c != null)
                    {
                        CaseComment caseCom = new CaseComment();
                        caseCom.ParentId = caseRecord.id;
                        caseCom.IsPublished = true;
                        caseCom.CommentBody = caseRecord.Internal_Comments__c;
                        insert caseCom;
                    }
                    PageReference pageRef = new PageReference('/'+caseRecord.Id);
                    pageRef.setRedirect(true);
                    return pageRef;
                }
         }
         catch(Exception classException)
         {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
         }
         return null;
     }
}