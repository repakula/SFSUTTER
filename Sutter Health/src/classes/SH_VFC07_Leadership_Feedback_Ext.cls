/**  
*     Name  : SH_VFC07_Leadership_Feedback_Ext
*     Author      : Alok
*     Date        : 30-Sep-2015
*     Description : Copied functionality from VFC07_Leadership_Feedback_Ext 
*     Functionality : Written to save Manager feedback from community portal. Also sends 'thank you' email to current user.
**/

public without sharing class SH_VFC07_Leadership_Feedback_Ext extends SH_BaseController{
    
    private ApexPages.StandardController controller {get; set;}
    
    //private Map<String, Manger_Feedback__c> managerFeedbackCustSettMap = Manger_Feedback__c.getAll();
    private Map<String, InstanceURL__c> instanceURLsMap = InstanceURL__c.getAll();
 
    private static final string custSettURL = 'InstanceURL'; 
    private Managers_Feedback__c managerFeedback{get;set;}
    
    private static final string MANAGER_FEEDBACK_FOR_REQUESTOR = 'Manager Feedback For Requestor';
       
    private static final string MANAGER_REC_TYPE = 'ManagerFeedback';    
    
    private static final string QUEUENAME ='Manager Feedback';
             
    private static final string COLON =':';
    
    private static final string BLANK_STRING = '';
    
    private static final string SPLIT_FROM = ',';
    
    private static final string REPLACE_STRING = '\\s+';
    
    private static final string EXEPTION_MSG = '\r\n';
    
    private static final string EXEPTION_MSG1 = '--------------';
    
    private static final string SUB1= 'Manager Feedback :';
    
    private static final String  HTML_BODY1 = '<html><body> Manager\'s feedback <br/><p>';
    
    private static final String  HTML_BODY2 = '<br/><br/><br/><br/><br/><p> Submitted by :';
    
    private static final String  HTML_BODY3 = ' <br/> Email :';
    
    private static final String  HTML_BODY4 = '<br/>Job Title :';
    
    private static final String  HTML_BODY5 = '<br/> Affiliate:';
    
    private static final String  HTML_BODY6 = '<br/>Click the link below to access the manager\'s feedback.<br/> ';
    
    //private static final String  HTML_BODY7 = 'https://cs20.salesforce.com/';
    
    private static final String  HTML_BODY8 = '</body></html>';
    
    private String emailAddressL1 = null;
    private String emailAddressL2 = null;        
    private String ownerNameL2 = null;
    public Boolean showMsg{get;set;}
    
        
    public SH_VFC07_Leadership_Feedback_Ext(ApexPages.StandardController controller){
        BreadCrumbs = new list<SH_BreadCrumb> { new SH_BreadCrumb('Home', 'sh_landing') };
        activePgName = 'VFP07_Leadership_Feedback';
        setBreadCrumbs();        
        BreadCrumbs.add(new SH_BreadCrumb('VFP07_Leadership_Feedback', '#'));
        
        this.controller = controller;
        this.managerFeedback = (Managers_Feedback__c)controller.getRecord();
        showMsg = false;
    }
    
     /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method is called to save the manger feedback record. 
    * @param 
    * @return 
    */
    
    public PageReference saveAndSend(){
        try{
            String serviceAreaStr = null;
            String serviceAreaTrimmed = null;
            String l2EmailId = null;
            
            Messaging.SingleEmailMessage emailForL2 = new Messaging.SingleEmailMessage();
            
            Map<String, Manager_Feedback__c> managerFeedbackCustSettMap = Manager_Feedback__c.getAll();
            User userRecord = new User();
            
            serviceAreaStr = managerFeedback.Service_Area__c;            
            serviceAreaTrimmed = serviceAreaStr.replaceAll(REPLACE_STRING, BLANK_STRING);
            
            //Get 'ManagerFeedback' rcord type and assign it to manager feedback record.            
            RecordType recType = [select id,name from recordType where name=:MANAGER_REC_TYPE limit 1];
            managerFeedback.RecordTypeId = recType.Id;
                            
            //Assign current user's contact to manager feedback record.            
            User lstUser = [select u.contact.id, Email, u.contact.account.id, u.Id, u.ContactId, u.contact.name, u.contact.Employee_Affiliate_Facility__c, u.contact.Employee_Work_Email__c,u.contact.Employee_Job_Code__c,u.contact.Title from User u where u.id =: UserInfo.getUserId() limit 1];
            
            //Atul
            if(managerFeedbackCustSettMap.containsKey(serviceAreaTrimmed))
            {
                if(!String.isEmpty(managerFeedbackCustSettMap.get(serviceAreaTrimmed).Email_to_L2__c))
                {
                    l2EmailId = managerFeedbackCustSettMap.get(serviceAreaTrimmed).Email_to_L2__c;
                }
            }
            
            if(lstUser.contact != null ){
                try{ 
                    managerFeedback.contact__c = lstUser.contact.id;
                }catch (Exception ex){
                    system.debug('Exception caught while assigning contact to feedback:'+ex);
                    Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG  + ex.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );                    
                }

                //Assign current user's account to manager feedback record.                           
                if(lstUser.contact.account != null){
                    managerFeedback.account__c = lstUser.contact.account.id; 
                }else{
                    system.debug('Account is not assigned to feeedback.');                              
                }                   
            }       
                        
            try{
                if(instanceURLsMap.containsKey(custSettURL) && instanceURLsMap.get(custSettURL) != null){
                    String intURL = instanceURLsMap.get(custSettURL).URL__c;
                    if(intURL != null && intURL.trim() != ''){
                        if(!intURL.endsWith('/')){
                            intURL = intURL + '/';                                             
                        }
                        managerFeedback.InternalURL__c = intURL;
                    }                        
                }
                //system.debug('managerFeedback.InternalURL__c='+managerFeedback.InternalURL__c);                     
            }catch(Exception e){
                system.debug('Exception in getting custom settings InternalURL value='+e); 
            }  
                
            managerFeedback.ConatctID__c = lstUser.Contact.name;
            managerFeedback.Affiliate__c = lstUser.contact.Employee_Affiliate_Facility__c;
            
            if(lstUser.contact.Employee_Work_Email__c != null){                
                managerFeedback.WorkEmail__c = lstUser.contact.Employee_Work_Email__c;
            }else{
                managerFeedback.WorkEmail__c = lstUser.Email;
            }
            managerFeedback.Job_Title__c = lstUser.contact.Title;
                
            //Insert manager feedback record and send a mail(do not send mail if record is not inserted).               
            try{                   
                upsert managerFeedback;               
                showMsg = true;        
                
                
               //Prepare a thank you mail and send it to current logged in user.
                try{
                    OrgWideEmailAddress[] orgDefEmail = [select Id from OrgWideEmailAddress where Address = 'salesforce@sutterhealth.org' limit 1];                
                    EmailTemplate et1 = [Select Id from EmailTemplate where Name =:MANAGER_FEEDBACK_FOR_REQUESTOR limit 1];                
                    Messaging.SingleEmailMessage emailForReq = new Messaging.SingleEmailMessage();    
                    if(orgDefEmail != null && orgDefEmail.size() > 0){
                        emailForReq.setOrgWideEmailAddressId(orgDefEmail[0].id);    
                    }
                    emailForReq.setTemplateId(et1.id);
                    emailForReq.setWhatId(managerFeedback.id);
                    emailForReq.setTargetObjectId(lstUser.ContactId);
                    emailForReq.setSaveAsActivity(false); 
                    
                    if(!String.isEmpty(l2EmailId))
                    {
                        emailForL2.setToAddresses(new String[]{String.valueOf(l2EmailId)});                
                        emailForL2.setWhatId(managerFeedback.id); 
                        emailForL2.setSaveAsActivity(false);
                        emailForL2.setOrgWideEmailAddressId(orgDefEmail[0].id);
                        emailForL2.setSubject(SUB1+managerFeedback.name+COLON+ managerFeedback.Subject__c);
                        String HTML_BODY7 = (managerFeedback.InternalURL__c  != null ?  managerFeedback.InternalURL__c :  BLANK_STRING ) ;        
                        String  htmlBody = HTML_BODY1 + managerFeedback.Comments__c+ HTML_BODY2 + managerFeedback.ConatctID__c +HTML_BODY3 + (managerFeedback.WorkEmail__c != null ? managerFeedback.WorkEmail__c : BLANK_STRING)  + HTML_BODY4 + (managerFeedback.Job_Title__c != null ? managerFeedback.Job_Title__c : BLANK_STRING) + HTML_BODY5 + (managerFeedback.Affiliate__c != null ? managerFeedback.Affiliate__c : BLANK_STRING) + 
                            HTML_BODY6 + '<a href='+HTML_BODY7+ managerFeedback.Id +'>'+HTML_BODY7+ managerFeedback.Id+'</a>'+ HTML_BODY8;
                                                
                        emailForL2.setHtmlBody(htmlBody);
                    }
                    
                    Messaging.SendEmailResult [] r1 = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailForReq});
                    
                 //   Messaging.SendEmailResult [] r2 = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailForL2});
                
                }catch(Exception sendemailException){                
                    //system.debug('Exception while sending tahnk you mail to user:'+sendemailException);
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Due to some error system did not send a Thank you mail.'));
                       
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, sendemailException.getMessage()));                    
                    Utility.handleExceptionFromCode(sendemailException.getMessage() + EXEPTION_MSG + sendemailException.getStackTraceString() + EXEPTION_MSG  + sendemailException.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
                }
            }catch(DmlException dmlEx){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, dmlEx.getMessage()));
                Utility.handleExceptionFromCode(dmlEx.getMessage() + EXEPTION_MSG + dmlEx.getStackTraceString() + EXEPTION_MSG  + dmlEx.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
            }                
                       
        } catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG  + classException.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
        }
        return null;
    }
}