/*/ 
*     Class Name  : VFC24_Training_Request_Form
*     Author      : Apoorv Kuchhal
*     Date        : 27-Aug-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : Training Request Form
**/
public class SH_VFC24_Training_Request_Form extends SH_BaseController{
    private static final String REC_TYPE='Training' ;
    private ApexPages.StandardController controller {get; set;}
    public boolean showMsg {get;set;}
    public Case caseRecord{get; set;}
    private static final string  STATUS_INPROGRESS = 'In Progress';   
    private static final string  ORIGIN = 'Web';
    //private static final string  SUBJECT= 'Training Request Form';
    private static final string  GROUPTYPE= 'Queue';
    private static final string  CASEOBJ= 'Case';
    private static final string  QUEUENAME1 = 'Training - S3';
    private static final string  QUEUENAME2 = 'Training - Revenue Cycle';
    private static final string  INTERNAL = 'Internal';
    public String caseNum {get;set;}
    
    /* Constructor for VFC24_Training_Request_Form Standard Controller */
    public SH_VFC24_Training_Request_Form(ApexPages.StandardController controller) 
    {
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        activePgName = 'Traning REQUEST FORM';
        setBreadCrumbs();        
        BreadCrumbs.add(new SH_BreadCrumb('Traning REQUEST FORM' , '#'));
        
        //added on 21-Sep-2015 by Saasfocus to redirect on last visited link 
        strCancelLink = SH_Common.CancelForm(BreadCrumbs) ;
            
        try{
            showMsg = false;            
            this.controller = controller;
            this.caseRecord = (Case)controller.getRecord();
            User user = [Select Id,ContactId from User where id =: UserInfo.getUserId() limit 1];
            
            RecordType rType = [Select Id,Name from RecordType where Name =: REC_TYPE AND SobjectType =: CASEOBJ limit 1];
            caseRecord.RecordTypeId = rType.id;
            caseRecord.ContactId = user.ContactId;
          
            caseRecord.Origin= ORIGIN;
            caseRecord.Priority = caseRecord.PRIORITY__c;
            //caseRecord.Subject= SUBJECT;
            
            caseNum = '';                
         }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
         }

    }
    
    /*
    public PageReference cancel(){
        return null;
    }
    */
     public PageReference saveAndSend(){
         try{     
             if(caseRecord.Time_Frame__c == null ){
                 caseRecord.addError(System.Label.Case_Record_Error_Time);
             }
             else
             {               
                 User loggedInUser = [Select Id, Profile.Name from User where Id =: UserInfo.getUserId() limit 1];
                 List<GroupMember> queuenames = new List<GroupMember>() ;
                 queuenames =  [SELECT Group.Name FROM GroupMember WHERE  UserOrGroupId =: UserInfo.getUserId() 
                     AND (Group.Name =:QUEUENAME1  OR Group.Name =:QUEUENAME2) Limit 1]; //removed this clause " AND Group.Type =: GROUPTYPE"
               
                 system.debug(queuenames+'@queuename');
                 If(queuenames.size() < 1){
                     //Assign the assignment rule to be fired
                     AssignmentRule AR = new AssignmentRule();
                     AR = [select id from AssignmentRule where SobjectType = :System.Label.CL37_CaseObject and Active = true limit 1];
                     Database.DMLOptions dmlOpts = new Database.DMLOptions();
                     dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                     caseRecord.setOptions(dmlOpts);  
                 }else{
                     //Set status as 'In Progress'.               
                     caseRecord.Origin = INTERNAL;
                     caseRecord.Status = STATUS_INPROGRESS;
                                        
                 }            
                caseRecord.Priority = caseRecord.PRIORITY__c; 
               caseRecord.Date_submitted__c = Date.Today();
               //insert the case record into database
               insert caseRecord;
                             
                 /*if(caseRecord.Internal_Comments__c != null)
                    {
                        CaseComment caseCom = new CaseComment();
                        caseCom.ParentId = caseRecord.id;
                        caseCom.IsPublished = true;
                        caseCom.CommentBody = caseRecord.Internal_Comments__c;
                        insert caseCom;
                    }*/
               //set showMsg to true.
               Case caseRec=[select id, caseNumber from Case where id=: caseRecord.id limit 1]; 
               caseNum = caseRec.caseNumber;
                //commented on 22-Sep-2015 by Saasfocus to stop redirection
                /*
                if(loggedInUser.Profile.Name.contains('Community'))
                {
                    showMsg = true; 
                }
                else
                {
                    PageReference pageRef = new PageReference('/'+caseRecord.Id);
                    pageRef.setRedirect(true);
                    return pageRef;
                }
                */
                
                PageReference pageRef = Page.SH_Help_Support;
                pageRef.getParameters().put('Id',  caseRecord.Id);
                pageRef.setRedirect(true);
                
                SH_Common.setFormUrlParams(pageRef);
                
                return pageRef; 
                
                //added on 22-Sep-2015 by Saasfocus
                showMsg = true; 
                
               return null;
           }
               
         }
         catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
         }
         return null;
     }
     
     /* Method for PageReference */
     public PageReference okay() {
           PageReference pageRef = new PageReference('/'+caseRecord.Id);
           pageRef.setRedirect(true);
           return pageRef;
     }
     
     
}