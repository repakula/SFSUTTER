/**   Class Name  : SendManagerFeedbackEmail
*     Author      : Manish
*     Date        : 08-Aug-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : Written to send email notifications to owners on manager feedback record assignment to user.
**/

public class SendManagerFeedbackEmail { 
    
    private static final string SUB1= 'Manager Feedback:';
    
    private static final string EXEPTION_MSG1 = '--------------';
    
    private static final String  HTML_BODY1 = '<html><body> Manager\'s feedback <br/><p>';
    
    private static final String  HTML_BODY2 = '<br/><br/><br/><br/><br/><p> Submitted by :';
    
    private static final String  HTML_BODY3 = ' <br/> Email :';
    
    private static final String  HTML_BODY4 = '<br/>Job Title :';
    
    private static final String  HTML_BODY5 = '<br/> Affiliate:';
    
    private static final String  HTML_BODY6 = '<br/>Click the link below to access the manager\'s feedback.<br/> ';
    
    //private static final String  HTML_BODY7 = 'https://cs20.salesforce.com/';
    
    private static final String  HTML_BODY8 = '</body></html>';
    
    private static final string COLON =':';
    
    private static final string BLANK_STRING = '';
    
    private static final string SPLIT_FROM = ',';
    
    private static final string EXEPTION_MSG = '\r\n';        
       
    
    public void sendMail(List<Managers_Feedback__c> listOfFeedbackRecords, Map<Id,Id> mapOfRecAndOwnerIds) {
        List<Messaging.SingleEmailMessage> emails;
        Map<Id, User> usrRecordMap = new Map<Id, User>(); 
        try{
        if(listOfFeedbackRecords != null && listOfFeedbackRecords.size() > 0 
          && mapOfRecAndOwnerIds != null && mapOfRecAndOwnerIds.size() > 0){
            for(User usr : [select id,  Email from User where id IN : mapOfRecAndOwnerIds.values()]){
                usrRecordMap.put(usr.id, usr);
            }
            Id fromAddressId = null;
            OrgWideEmailAddress[] orgDefEmail = [select Id from OrgWideEmailAddress where Address = 'salesforce@sutterhealth.org' limit 1];                
            if(orgDefEmail != null && orgDefEmail.size() > 0){
                fromAddressId = orgDefEmail[0].id;    
            }
      
            for(Managers_Feedback__c feedbackRec : listOfFeedbackRecords){
                Id usrId =  mapOfRecAndOwnerIds.get(feedbackRec.id);
                User recordUser = usrRecordMap.get(usrId); 
                if(recordUser != null){
                    if(emails == null){
                        emails = new list<Messaging.SingleEmailMessage>();
                    }
                           
                    Messaging.SingleEmailMessage email = createEmail(feedbackRec, recordUser );
                    if(email != null){
                        if(fromAddressId != null){
                            email.setOrgWideEmailAddressId(fromAddressId);               
                        }                    
                        emails.add(email);
                    }                    
                }           
            }
            if(emails != null && emails.size() > 0){
                Messaging.sendEmail( emails );            
            }
        }
        }catch(Exception ex){
           Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG  + ex.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );       
        }               
    }
    

    public Messaging.SingleEmailMessage  createEmail(Managers_Feedback__c feedbackRec, User recordUser){
        Messaging.SingleEmailMessage email ;
        try{
            email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{String.valueOf(recordUser.Email)});                
            email.setWhatId(feedbackRec.id); 
            email.setSaveAsActivity(false);
            email.setSubject(SUB1+feedbackRec.name+COLON+ feedbackRec.Subject__c);
            String HTML_BODY7 = (feedbackRec.InternalURL__c  != null ?  feedbackRec.InternalURL__c :  BLANK_STRING ) ;        
            String  htmlBody = HTML_BODY1 + feedbackRec.Comments__c+ HTML_BODY2 + feedbackRec.ConatctID__c +HTML_BODY3 + (feedbackRec.WorkEmail__c != null ? feedbackRec.WorkEmail__c : BLANK_STRING)  + HTML_BODY4 + (feedbackRec.Job_Title__c != null ? feedbackRec.Job_Title__c : BLANK_STRING) + HTML_BODY5 + (feedbackRec.Affiliate__c != null ? feedbackRec.Affiliate__c : BLANK_STRING) + 
                HTML_BODY6 + '<a href='+HTML_BODY7+ feedbackRec.Id +'>'+HTML_BODY7+ feedbackRec.Id+'</a>'+ HTML_BODY8;
                                    
            email.setHtmlBody(htmlBody);
       }catch(Exception ex){
           Utility.handleExceptionFromCode(ex.getMessage() + EXEPTION_MSG + ex.getStackTraceString() + EXEPTION_MSG  + ex.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
       }
       return email; 
    }
}