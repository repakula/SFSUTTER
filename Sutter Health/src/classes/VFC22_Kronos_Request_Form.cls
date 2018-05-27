/**  
*     Class Name  : VFC22_Kronos_Request_Form
*     Author      : Apoorv Kuchhal
*     Date        : 19-Aug-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : Kronos Web Request Form
**/
public class VFC22_Kronos_Request_Form{

    private ApexPages.StandardController controller {get; set;}
     
 // public String noteValue{get; set;}
    public Case caseRecord{get; set;}
    private static final string  SUB_FUNCTION_NAME = 'HR Information System (HRIS)';
    private static final string  TEAM_NAME = '[Tier 3] HR Data';
    private static final string  INTENT_NAME = 'HR Data';
    private static final string  SUB_INTENT_NAME = 'Kronos';
    private static final string  ORIGIN = 'Web';
    private static final string  SUBJECT= 'Kronos Access Request - Web';
    private static final string  RECORDNAME= 'Human_Resource_Job_Evaluation_Form';
    private static final string  OBJECTNAME= 'Case';
  
    /* Constructor for VFC22_Kronos_Request_Form Standard Controller */
    public VFC22_Kronos_Request_Form(ApexPages.StandardController controller) 
    {
        try
        {
        
            this.controller = controller;
            this.caseRecord = (Case)controller.getRecord();
            User user = [Select ContactId from User where id =: UserInfo.getUserId() limit 1];
            
            RecordType rType = [Select Id,Name from RecordType where DeveloperName =: RECORDNAME AND SobjectType =: OBJECTNAME Limit 1];
            system.debug('@Pul'+  rtype.name);
            caseRecord.RecordTypeId = rType.id;
            caseRecord.ContactId = user.ContactId;
            caseRecord.Date_Requested__c=System.Now();
            caseRecord.Effective_Date_of_Change__c=System.Today();
            caseRecord.Origin= ORIGIN ;
            caseRecord.Subject= SUBJECT;
            caseRecord.Sub_Function__c = SUB_FUNCTION_NAME ;             
            caseRecord.Team__c=TEAM_NAME ;
            caseRecord.Customer_Intent__c=INTENT_NAME ; 
            caseRecord.Customer_Sub_Intents__c=SUB_INTENT_NAME ;   
            caseRecord.Section_View__c = SUB_INTENT_NAME;
            caseRecord.Call_Back_defaut_true__c = false;
         }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
         }
    }
    
     /* Method for PageReference and Method saveAndSend */
     public PageReference saveAndSend() 
     {
         try
         {      if(caseRecord.Date_Requested__c== null ){
                    caseRecord.addError(System.Label.Case_Record_Error);
                }
                else if(caseRecord.Date_Requested__c!= null && caseRecord.Effective_Date_of_Change__c== null){
                        caseRecord.addError(System.Label.Case_Record_Not_Null_Error);
                        }
                    else    
                {
                    //Assign the assignment rule to be fired
                    AssignmentRule AR = new AssignmentRule();
                    AR = [select id from AssignmentRule where SobjectType =: OBJECTNAME and Active = true limit 1];
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                    caseRecord.setOptions(dmlOpts);             
                    caseRecord.Section_View__c= System.Label.Kronos;
                   
                    
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