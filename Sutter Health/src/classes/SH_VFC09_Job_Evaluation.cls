/**  
*     Class Name  : VFC09_Job_Evaluation
*     Author      : Venkat Ramesh
*     Date        : 10-July-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : 5.3 Release Req-3119 Job Evaluation Form
History
-------
VERSION  AUTHOR        DATE       DETAIL                 Description
1.0      IDC Offshore  1/13/2015  View State Bug Fix   Added new transient biding variable to hold attachment body and cleared after upload. 
**/
public class SH_VFC09_Job_Evaluation extends SH_BaseController 
{

    private ApexPages.StandardController controller {get; set;}
    public Attachment attachment {get; set;}  
    transient public Blob attachBody {get;set;}  // Transient variable capture attachment body in VF page & to bypass view state limit. 
    public String noteValue{get; set;}
    public Case caseRecord{get; set;}
    private static final string  RECORDTYPE_NAME = 'Human_Resource_Job_Evaluation_Form';
    private static final string  CASE_OBJECT = 'Case';
    private static final string  CHECK_BOX_ERROR = 'Any one field is required out of these "Establish New Job", "Revision to Current Job", "Update description only", "Other Request" fields';
    private static final string  CHECK_BOX_ERROR1 = 'When selected "Other Request", "Please specify" field is required';
    private static final string  ATTACH_ERROR = 'Error uploading attachment';
    private static final string  SUCCESS_MSG = 'Attachment uploaded successfully';
    private static final string  BACKSLASH = '/';
    private static final string  BACKSLASH1 = '\r\n';
    private static final string  HYPHEN = '--------------';
    private static final string  SECTIONVIEW = 'Job Evaluation';
    
    //Added By SaaSfocus on on 22/09/2015
    public Boolean IsSuccess {get; set;}
    public String CaseNumber{get; set;}
    /** Description Constructor of the class **/
    public SH_VFC09_Job_Evaluation(ApexPages.StandardController controller) 
    { 
        
        attachment = new Attachment();
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        activePgName = 'Customer Inquiry Edit';
        setBreadCrumbs();        
        BreadCrumbs.add(new SH_BreadCrumb('Customer Inquiry Edit' , '#'));
        //added on 21-Sep-2015 by Saasfocus to redirect on last visited link 
        strCancelLink = SH_Common.CancelForm(BreadCrumbs) ;
        IsSuccess = false;
        try
        {
        
            this.controller = controller;
            this.caseRecord = (Case)controller.getRecord();
          //  User user = [Select ContactId from User where id =: UserInfo.getUserId() limit 1];
            User user =  usercontact();
            
            //RecordType rType = [Select Id,Name from RecordType where Name = RECORDTYPE_NAME AND SobjectType = CASE_OBJECT limit 1];
            RecordType rType = caserecordtype();
            caseRecord.RecordTypeId = rType.id;
            caseRecord.ContactId = user.ContactId;
            caseRecord.Subject = caseRecord.subject1__c;
            caseRecord.Section_View__c = SECTIONVIEW;
         }
         catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
         }
    }
    /** Method to get contact id of logged in user**/
    public user usercontact(){
        
        User usercontact = [Select ContactId from User where id =: UserInfo.getUserId() limit 1];
        return usercontact;
    }
    /** Method to get case record type id**/
    public RecordType caserecordtype(){
        
        RecordType rTypecase = [Select Id,Name from RecordType where DeveloperName =: RECORDTYPE_NAME AND SobjectType =: CASE_OBJECT limit 1];
        return rTypecase;
    }
    
    
     /** This is to validate the page and to fire assignment rule and insert record **/
     public PageReference saveAndSend() 
     {
         PageReference pageRef = null;
         try
         {      if(!(caseRecord.Establish_New_Job__c || caseRecord.Revision_to_Current_Job__c || caseRecord.Update_description_only__c || caseRecord.Other_Request__c )){
                    caseRecord.addError(CHECK_BOX_ERROR);
                }
                else if(caseRecord.Other_Request__c && caseRecord.Please_specify__c == null){
                     caseRecord.addError(CHECK_BOX_ERROR1);
                }
                else
                if(attachBody==null)
                {
                    caseRecord.addError('Please attach the document');
                }
                else
                {
                    //Assign the assignment rule to be fired
                    AssignmentRule aR = new AssignmentRule();
                    aR = [select id from AssignmentRule where SobjectType =: CASE_OBJECT and Active = true limit 1];
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.assignmentRuleId= aR.id;
                    caseRecord.setOptions(dmlOpts);             
                    caseRecord.Subject = caseRecord.Subject1__c;
                    //insert the case record into database
                    //insert caseRecord;
                    insert caseRecord;
                    Attachment att= upload();
                    
                    pageRef = Page.SH_Help_Support;
                    pageRef.getParameters().put('Id',  caseRecord.Id);
                    //added for setting Breadcrum params
                    SH_Common.setFormUrlParams(pageRef);
                    
                    //added by saasfocus for showing only success message on help and support page
                    pageRef.getParameters().put('HP','true');
                    
                    pageRef.setRedirect(true);
                    return pageRef;
                   
                }
         }
         catch(Exception classException)
         {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + BACKSLASH1 + classException.getStackTraceString() + BACKSLASH1 + classException.getTypeName() + BACKSLASH1 + System.now() + BACKSLASH1 + HYPHEN);
         }
         return pageRef;
     }
  
/** Attach the file to parent record id **/
public Attachment upload() {
    
    attachment.OwnerId = UserInfo.getUserId(); 
    attachment.ParentId = caseRecord.id; // the record the file is attached to
    attachment.IsPrivate = false;
    attachment.body = attachBody; 
 
    try {
      insert(attachment);
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, SUCCESS_MSG));
    } 
    catch (Exception e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ATTACH_ERROR));
    } 
    finally {
            attachment = new Attachment();
                        
        }
    return attachment;    
  }
     
}