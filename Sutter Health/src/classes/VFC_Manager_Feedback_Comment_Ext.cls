/**  
*     Class Name  : VFC_Manager_Feedback_Comment_Ext
*     Author      : Manish
*     Date        : 21-August-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : Written to create and save Manger feedback Comment from manager feedback record.
**/

public with sharing class VFC_Manager_Feedback_Comment_Ext {
    public Manager_Feedback_Comment__c commentRecord {get;set;}
    
    private Managers_Feedback__c feedbackRecord; 
    
    //To capture manager feedback record id from url.
    private String recId;  
    
    private static final string EXEPTION_MSG = '\r\n';
    
    private static final string EXEPTION_MSG1 = '--------------';
    
    public VFC_Manager_Feedback_Comment_Ext(ApexPages.StandardController controller) {
         //get manager feedback record id from 'feedbackid' parameter in url.
         recId = ApexPages.currentPage().getParameters().get('feedbackid');
         if(recId == null || recId.trim() ==''){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Manager feedback record id not found.'));                    
         }else{       
             try{
                 List<Managers_Feedback__c> feedbackRecords = [select id from Managers_Feedback__c where id =: recId limit 1];   
                 if(feedbackRecords != null && feedbackRecords.size() > 0){
                    feedbackRecord = feedbackRecords.get(0);
                    // create new 'Manager Feedback Comment' record with manager feedback record's reference.                     
                    commentRecord = new Manager_Feedback_Comment__c(comments__c='', Managers_Feedback__c=feedbackRecord.id);
                 }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Manager feedback record id not matched.'));                    
                 } 
             }catch(Exception ex){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error:'+ex.getMessage()));                    
                 Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG  + ex.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );                 
             }         
         }              
    }
    
    //Redirect to manager feedback record.   
    public PageReference cancel(){
        if(recId != null){
            return (new PageReference('/'+recId));            
        }
        return null;
    }
    
    //Save record, if exist, and redirect to manager feedback record.     
    public PageReference save(){
        //insert new manager feedback comment record.
        if(commentRecord != null){
            insert commentRecord ;
        }
        //if manager feedback id is not null then redirect to manager feedback record.            
        if(recId != null){
            return (new PageReference('/'+recId));            
        }
        return null;
    }
}