/**  
*     Class Name  : VFC_CallbackCommentsExtension
*     Author      : Manish
*     Date        : 29-September-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : Written to create and save Callback and Case Comments records.
*
*       History
*      
*       VERSION         AUTHOR            DATE          DETAIL 
*         1.0          Atul Gupta      01/12/2014       Added functionality for REQ 3262 to show differenct fields when SHP Agent, Clinical Team
*                                                           or CMC Team memebers login and try to create new Customer Inquiry Comments
*     
**/

public with sharing class VFC_CallbackCommentsExtension{
    public Call_Back__c callbackRec {get;set;}
    public List<CaseCommentsWrapper> caseCommentHistory {get;set;}
    private List<CaseComment> CaseComments {get;set;}
    public Id recId {get;set;}
    public Id caseId {get;set;}  
    private static final string EXEPTION_MSG = '\r\n';        
    private static final string EXEPTION_MSG1 = '--------------';
    private static final string VALIDATION_MSG1 = 'Concurrent/Retro Comments are Required';
    private static final string VALIDATION_MSG2 = 'Concurrent Review Received Date is Required';
    private static final string VALIDATION_MSG3 = 'Concurrent Review Requested Date is Required';
    private static final string OOA_QUEUE_NAME = 'SHP OOA/OON';
    private static final string OOA_VIEW_ONLY = 'SHP OOA/OON View Only';
    private static final string SHP_GRIEVANCE_ROLE = 'SHP Grievance Coordinator';
    
    public boolean isCommentSaved {get;private set;}
 
    //3262
    public string rtType {get; set;}
    private static final string CALLBACK_RT = 'Comments OOA OON';
    private static final string CALLBACK_GRIEVANCE_RT = 'Comments Grievance';
    private static final string BLANK_STRING = '';
    
    private static final string SPLIT_FROM = ',';
    
    private static final string REPLACE_STRING = '\\s+';
      
    public Call_Back__c callback {get; set;}
    private string parentCID;
    private Id parentCaseId;
    Case parentCaseRecord;
    
    public boolean isMemberOfSHP_OOA_OON {get; set;}
    public boolean isMemberOfSHP_OOA_OON_View_Only {get; set;}
    public List<CaseCallBackWrapper> casecallBackHistory {get;set;}
    private List<Call_Back__c> caseCallBacks {get;set;}
    String finalStr = BLANK_STRING;
    public boolean isError {get; set;}
    public boolean isCoordinator {get; set;}
    
    public Boolean ErrorsPresent{
    
        get{        
            return ApexPages.hasMessages(ApexPages.Severity.ERROR);
        }
    }

    public PageReference save(){    
    PageReference pageRef;
    	 
    	 callbackRec.RecordtypeId = Schema.SObjectType.Call_Back__c.RecordTypeInfosByName.get(CALLBACK_GRIEVANCE_RT).RecordTypeId;
         upsert callbackRec;
          
        isCommentSaved = true;
      return pageRef ;   
    }         
    
    
    public PageReference cancel(){

       isCommentSaved = false;        
       return null;          
    }
  
    /** Constructor: takes **/
    public VFC_CallbackCommentsExtension(ApexPages.StandardController controller) {
        
        try{
            
            parentCaseRecord = new Case();
            isError = false;
            isCoordinator = false;
            isMemberOfSHP_OOA_OON = false;      
            isMemberOfSHP_OOA_OON_View_Only = false;
            
            recId = ApexPages.currentPage().getParameters().get('id');
            system.debug('@@recId : '+ recId);
            
            String cancelStr = ApexPages.currentPage().getParameters().get('cancelURL');
            
            if(cancelStr <> null){
                
                String str1 = cancelStr.substringAfter('/');
                finalStr = str1.substringBefore('?');
            }
            system.debug('@@finalStr : '+ finalStr);
            
            parentCID = ApexPages.currentPage().getParameters().get('cid');
            system.debug('@@parentCID : '+ parentCID);
            
            if(!String.isBlank(parentCID)){
            	
            	parentCaseRecord = [Select RecordType.Name from Case where id =: parentCID limit 1];
            }
            else if(!String.isBlank(finalStr)){
            	
            	Id callbackParent = [select id, Parent_Case__c from Call_Back__c where id =: finalStr limit 1].Parent_Case__c;
            	
            	if(callbackParent <> null){
            		
            		parentCaseRecord = [Select RecordType.Name from Case where id =: callbackParent limit 1];
            	}
            }
            
            if(parentCaseRecord <> null && (parentCaseRecord.Recordtype.Name == Label.CL43_Grievance_RT 
            										|| parentCaseRecord.Recordtype.Name == 'Grievance RO')){
            
            	rtType = 'Grievance';
            }
            else if(parentCaseRecord <> null && (parentCaseRecord.Recordtype.Name == 'OOA/OON'
            										|| parentCaseRecord.Recordtype.Name == 'OOA/OON RO')){
            	
            	rtType = 'OOA_OON';
            	groupMember();
            }
            
            if(!String.isBlank(recId)){
            	
            	Call_Back__c grievance_call_back = [Select Parent_Case__r.RecordType.Name from Call_Back__c where Id =: recId limit 1];
            	
            	if(grievance_call_back <> null && (grievance_call_back.Parent_Case__r.Recordtype.Name == Label.CL43_Grievance_RT 
            										|| grievance_call_back.Parent_Case__r.Recordtype.Name == 'Grievance RO')){
            		
            		rtType = 'Grievance';
            	}
            }
            
            if(rtType == 'Grievance'){
                
                //Get Call_Back__c record id from 'id' parameter in url.  
                isCommentSaved = false;        
                
                //Get Case record id from 'cid' parameter in url.
                if(recId == null){         
                    caseId = ApexPages.currentPage().getParameters().get('cid');
                }else{
                    Call_Back__c callBackRecord = new Call_Back__c();
                    callBackRecord = [select id, Parent_Case__c from Call_Back__c where id =: recId limit 1];
                    if(callBackRecord != null){
                      caseId = callBackRecord.Parent_Case__c;
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Customer Interaction Comment record not found.')); 
                    }        
                }      
                caseCommentHistory = new List<CaseCommentsWrapper>();
                
                if(caseId == null ){          
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Customer Interaction record id not found.'));
                }else{
                    caseComments = [select id, CreatedBy.Id , CreatedBy.Name, CommentBody, CreatedDate, LastModifiedBy.Id, LastModifiedBy.Name, LastModifiedDate, IsPublished from CaseComment where ParentId =: caseId order by CreatedDate DESC];
                    for(CaseComment comment : caseComments){
                                  
                       // Build String to display.
                       String commentString  = '<b>Created By: <a href=\'/' + comment.CreatedBy.Id + '\'>' + comment.CreatedBy.Name + '</a> (' + comment.CreatedDate.format() + ') | ';
                       commentString  += 'Last Modified By: <a href=\'/' + comment.LastModifiedBy.Id + '\'>' + comment.LastModifiedBy.Name + '</a> (' + comment.LastModifiedDate.format() + ')</b><br>';
                       commentString   += comment.CommentBody;               
                       
                       caseCommentHistory.add(new CaseCommentsWrapper(comment.IsPublished, commentString ));
                    }                         
                    
                    if(recId == null){
                        //It is a new record.            
                        callbackRec = new Call_Back__c();
                        callbackRec.Parent_Case__c = caseId;
                        //Create new 'callback' record with Case record's reference.                                         
                                         
                    }else{
                        //Edit this record. 
                        try{                 
                            List<Call_Back__c> callbackRecords = [select id, Notes__c, Action__c, CaseCommentID__c, Parent_Case__c, CreatedById, Name, Call_Date__c, Phone_Number__c, Call_Duration__c from Call_Back__c where id =: recId and Parent_Case__c =: caseId limit 1];                    
                            if(callbackRecords!= null && callbackRecords.size() > 0){                    
                                callbackRec = callbackRecords.get(0);              
                            }else{                    
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Callback record not found.'));                                     
                            }                  
                        }catch(Exception ex){                 
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error:'+ex.getMessage()));
                            Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG  + ex.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );                              
                        }
                    }            
                }
            }
            else{
                
                casecallBackHistory = new List<CaseCallBackWrapper>();         
                this.callback = (Call_Back__c)controller.getRecord();
                callback = new Call_Back__c();
                
                if(!string.isBlank(parentCID)) {
                    caseCallBacks = [select id, CreatedBy.Id , CreatedBy.Name, Clinical_Review_Comments__c,Concurrent_Retro_Comments__c,CreatedDate, 
                                        LastModifiedBy.Id, LastModifiedBy.Name,Comments__c, 
                                        LastModifiedDate  from Call_Back__c where Parent_Case__c =: parentCID order by CreatedDate DESC];
                                        
                    for(Call_Back__c callBackObj: caseCallBacks){
                       
                       String commentString  = '<b>Created By: <a href=\'/' + callBackObj.CreatedBy.Id + '\'>' + callBackObj.CreatedBy.Name + '</a> (' + callBackObj.CreatedDate.format() + ') | ';
                       commentString  += 'Last Modified By: <a href=\'/' + callBackObj.LastModifiedBy.Id + '\'>' + callBackObj.LastModifiedBy.Name + '</a> (' + callBackObj.LastModifiedDate.format() + ')</b><br>';
                       
                       casecallBackHistory.add(new CaseCallBackWrapper(false, commentString, callBackObj.Concurrent_Retro_Comments__c, callBackObj.Clinical_Review_Comments__c, callBackObj.Comments__c));
                    }
                }
                else if(finalStr <> ''){
                    
                    
                    if(parentCaseRecord <> null){
                        caseCallBacks = [select id, CreatedBy.Id , CreatedBy.Name, Clinical_Review_Comments__c,Concurrent_Retro_Comments__c,CreatedDate, 
                                        LastModifiedBy.Id, LastModifiedBy.Name,Comments__c, 
                                        LastModifiedDate  from Call_Back__c where Parent_Case__c =: parentCaseRecord.Id order by CreatedDate DESC];
                                        
                        for(Call_Back__c callBackObj: caseCallBacks){
                           
                           String commentString  = '<b>Created By: <a href=\'/' + callBackObj.CreatedBy.Id + '\'>' + callBackObj.CreatedBy.Name + '</a> (' + callBackObj.CreatedDate.format() + ') | ';
                           commentString  += 'Last Modified By: <a href=\'/' + callBackObj.LastModifiedBy.Id + '\'>' + callBackObj.LastModifiedBy.Name + '</a> (' + callBackObj.LastModifiedDate.format() + ')</b><br>';
                           
                           casecallBackHistory.add(new CaseCallBackWrapper(false, commentString, callBackObj.Concurrent_Retro_Comments__c, callBackObj.Clinical_Review_Comments__c, callBackObj.Comments__c));
                        }
                    }
                }
            }
        } catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG  + classException.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
        }
    }
    
    /** 3262 */ 
    public void groupMember(){

        Id currentUserId = UserInfo.getUserId();  
        Id coordinatorRoleId = null;
        
        List<Group> qId = [select id from Group where Name=: OOA_QUEUE_NAME];
        List<Groupmember> grpMem = [SELECT UserOrGroupId, groupid  FROM GroupMember where GroupId IN:qid and UserOrGroupId=:currentUserId]; 

        List<Group> qId1 = [select id from Group where Name=: OOA_VIEW_ONLY];
        List<Groupmember> grpMemViewOnly = [select UserOrGroupId from GroupMember where GroupId IN:qId1 and UserOrGroupId=:currentUserId]; 

        if(grpMem.size() > 0){         

            isMemberOfSHP_OOA_OON = true;
            coordinatorRoleId = [SELECT Id FROM UserRole where Name =: SHP_GRIEVANCE_ROLE].Id;
            
        } else if(grpMemViewOnly.size() >0 ){
        
            isMemberOfSHP_OOA_OON_View_Only = true;            
        }
        else{
        	
        	isMemberOfSHP_OOA_OON_View_Only = true;
        }
        
        if(isMemberOfSHP_OOA_OON && coordinatorRoleId == UserInfo.getUserRoleId()){
        	
        	isCoordinator = true;
        }
        
    }
    
    /**   3262*/
    public Pagereference Save_OOA(){
        try{
            
                callback.Parent_Case__c =  parentCaseRecord.Id;
                callback.RecordtypeId = Schema.SObjectType.Call_Back__c.RecordTypeInfosByName.get(CALLBACK_RT).RecordTypeId;
                
                if(isMemberOfSHP_OOA_OON){
                    
                    validatonRulesForAgentAnd();
                }
                
                if(!isError){
                    insert callback;
                }
            
            return null;
        }
        catch(Exception classException){
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG  + classException.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
        }
        return null;
    }
    
    /** Validation Rules  3262*/    
    private void validatonRulesForAgentAnd(){
        
        isError = false;
        
        if(callback.RecordTypeId == Schema.SObjectType.Call_Back__c.RecordTypeInfosByName.get(CALLBACK_RT).RecordTypeId
                        && callback.Concurrent_Review_Received__c == true && callback.Concurrent_Review_Received_Date__c == null){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, VALIDATION_MSG2));
            isError = true;
        }
        
        if(callback.RecordTypeId == Schema.SObjectType.Call_Back__c.RecordTypeInfosByName.get(CALLBACK_RT).RecordTypeId
                        && callback.Concurrent_Review_Requested__c == true && callback.Concurrent_Review_Requested_Date__c == null){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, VALIDATION_MSG3));
            isError = true;
        }
        
    }
    
    
    /** Wrapper class: To show CaseComments in related list  3262*/    
    public class CaseCallBackWrapper{
        
        public string strHistory1 {get;set;}
        public String caseCommentValue1 {get;set;}
        public String caseCommentValue2 {get;set;}
        public String caseCommentValue3 {get;set;}
        public boolean isPublic {get;set;}
           
        public CaseCallBackWrapper(boolean isPublic,string strHistory1,String caseCommentValue1,string caseCommentValue2,string caseCommentValue3){
            
            this.isPublic = isPublic;
            this.strHistory1 = strHistory1; 
            this.caseCommentValue1 = caseCommentValue1 ;
            this.caseCommentValue2 = caseCommentValue2 ;
            this.caseCommentValue3 = caseCommentValue3 ;
        }
    }
    
    /** Wrapper class: To show CaseComments in related list */    
    public class CaseCommentsWrapper {
        public String caseCommentValue {get;set;}
        public boolean isPublic {get;set;}       
        public CaseCommentsWrapper (boolean isPublic, String caseCommentValue ){
            this.isPublic = isPublic;
            this.caseCommentValue = caseCommentValue ;
        }
    } 

}