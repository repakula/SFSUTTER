/**  
*     Class Name  : VFC21_FPAttachment
*     Author      : Rahul Nasa
*     Date        : 18-Aug-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : 6.1 Release Req-3143 Facilities Form
**/
public class SH_VFC21_FPAttachment extends SH_BaseCOntroller
{

    private ApexPages.StandardController controller {get; set;}
     
    public String noteValue{get; set;}
    public Case caseRecord{get; set;}
    private static final string  RECORDTYPE_NAME = 'Finance_Payroll';
    private static final string  FUNCTION_NAME= 'Operations';
    private static final string  SUB_FUNCTION_NAME = 'Payroll/T&E';
    private static final string  TEAM_NAME = '[Tier 3] Payroll Upload';
    private static final string  INTENT_NAME = 'Pay Upload';
    private static final string  SUB_INTENT_NAME = 'Pay Upload';
    private static final string  CASE_OBJECT = 'Case';    
    private static final string  BACKSLASH = '/';
    private static final string  BACKSLASH1 = '\r\n';
    private static final string  HYPHEN = '--------------';
    private static final string  ATTACH_ERROR = 'Error uploading attachment';
    private static final string  SUCCESS_MSG = 'Attachment uploaded successfully';
    private static final string  CUSTOM_REC_TYPE = 'Payroll Upload';
    private static final string  SUBJECT = 'Payroll Upload - Web';
    
    public Attachment attachment{get; set;}
    //Added By SaaSfocus on on 22/09/2015
    public Boolean IsSuccess {get; set;}
    public String CaseNumber{get; set;}
    
    /** Description Constructor of the class **/
    public SH_VFC21_FPAttachment(ApexPages.StandardController controller) 
    {
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        activePgName = 'Payroll Upload Form';
        setBreadCrumbs(); 
        BreadCrumbs.add(new SH_BreadCrumb('Payroll Upload Form' , '#'));
        strCancelLink = SH_Common.CancelForm(BreadCrumbs) ;
        IsSuccess = false;
        
        try
        {
        
            this.controller = controller;
            this.caseRecord = (Case)controller.getRecord();
          //  User user = [Select ContactId from User where id =: UserInfo.getUserId() limit 1];
            User user =  usercontact();
            
            
            RecordType rType = caserecordtype();
            caseRecord.RecordTypeId = rType.id;
            caseRecord.ContactId = user.ContactId;
            caseRecord.Sub_Function__c= SUB_FUNCTION_NAME ;
            caseRecord.Affiliate__c =AffiliateFacility();
            caseRecord.Team__c =TEAM_NAME ;
            caseRecord.Customer_Intent__c=INTENT_NAME;
            caseRecord.Customer_Sub_Intents__c=SUB_INTENT_NAME ;
            caseRecord.Section_View__c = CUSTOM_REC_TYPE;
            caseRecord.Subject = SUBJECT ;
            caseRecord.Call_Back_defaut_true__c = false ;
            if(attachment == null)
            {
                attachment = new Attachment();
            }         
           
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
    
    /* Method for AffiliateFacility */
    public string AffiliateFacility(){
        User curruser = usercontact();
        List<Contact> lstContact =[Select Employee_Affiliate_Facility__c From Contact where Id =: curruser.Contactid limit 1];
        If(lstContact.size()>0)
        return lstContact[0].Employee_Affiliate_Facility__c;
        else
        return null;
    }
    /** Attach the file to parent record id **/
public Attachment upload() {
    
    attachment.OwnerId = UserInfo.getUserId(); 
    attachment.ParentId = caseRecord.id; // the record the file is attached to
    attachment.IsPrivate = false;
 
    try {
      insert(attachment);
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, SUCCESS_MSG));
    } 
    catch (Exception e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ATTACH_ERROR));
    } 
    return attachment;    
  }
     

    
     /** This is to validate the page and to fire assignment rule and insert record **/
     public PageReference saveAndSend() 
     {
         PageReference pageRef = null;
         try
         {     
            if(attachment.body==null)
            {
                caseRecord.addError(System.Label.Please_attach_the_document);
            }
            /*
            else if(attachment.body.size()>5242880)
            {
                                    
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'File is not Uploaded:Max.File Size is 5MB'));   
                 return null;  
            }
            */
                else
                {
                    //Assign the assignment rule to be fired
                   
                    AssignmentRule aR = new AssignmentRule();
                    aR = [select id from AssignmentRule where SobjectType =: CASE_OBJECT and Active = true limit 1];
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.assignmentRuleId= aR.id;
                    
                    caseRecord.setOptions(dmlOpts);  
                    caseRecord.Origin=System.Label.cl_CaseTrigger_Web_Origin;  
                    caseRecord.Status='New';   
                   
             
                    //caseRecord.Subject = caseRecord.Subject1__c;
                    //insert the case record into database
                    //insert caseRecord;
                    try
                    {
                        insert caseRecord;
                    }
                     
                     Catch (Exception e)
                     {system.debug('@error'+e.getmessage());
                     }

    
                   // database.insert(caseRecord);
                    Attachment att= upload();
                     if(caseRecord.Internal_Comments__c != null)
                    {
                        CaseComment caseCom = new CaseComment();
                        caseCom.ParentId = caseRecord.id;
                        caseCom.IsPublished = true;
                        caseCom.CommentBody = caseRecord.Internal_Comments__c;
                        insert caseCom;
                    }
                    //pageRef = new PageReference(BACKSLASH +caseRecord.Id);
                    //pageRef.setRedirect(true);
                    //added on 22-Sep-2015 by SaaSfocus for showing caseNumber
                    //Case insertedCase = [Select id, casenumber from case where id=:caseRecord.Id];
                    //CaseNumber = insertedCase.casenumber;
                    //IsSuccess = true;
                    //pageRef = Page.SH_Help_Support;
                    //updated on 30-sep-2015 for redirecting on case detail page on sutter request
                    pageRef = Page.SH_CaseDetail;

                    pageRef.getParameters().put('Id',  caseRecord.Id);
                    pageRef.setRedirect(true);
                    SH_Common.setFormUrlParams(pageRef);
                    return pageRef;
                  }
         }
         catch(Exception classException)
         {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + BACKSLASH1 + classException.getStackTraceString() + BACKSLASH1 + classException.getTypeName() + BACKSLASH1 + System.now() + BACKSLASH1 + HYPHEN);
         } finally {
             attachment = new attachment();
         }
         return null;
     }
       /** Setter and getter methods of Attachment **/  
       /*  public transient Attachment attachment {
              get {
                  if (attachment == null){
                    attachment = new Attachment();
                    }
                  return attachment;
                }
              set;
          }*/
 


}