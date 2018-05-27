/**  
*    Class Name: AP02_EmailMessage
*    Author: Offshore_Sutter_health
*    Date: 21-August-2014
*    Description: Email Message handler to send email to contacts if the status 
*    of the case is closed
*    History
*    VERSION    AUTHOR              DATE        DETAIL              Description
*     1.1       Atul Gupta         11/5/2014    Initial Development Changes as part of the Email to Case Finance Payroll : REQ 3213
*     1.2       Mohan Pindi        01/06/2016   Added changes to cover Req-3213 Finance Payroll Email-to-Case functionality for closed email to case 
*   --------
**/
// Constructors
public without sharing class AP02_EmailMessage {

    //Static variables
    private static final string ORG_EMAIL_ID = 'salesforce@sutterhealth.org';    
    private static final string EXEPTION_MSG = '\r\n';    
    private static final string TEMPLATE_NAME = 'Email Template on Case Closed';    
    private static final string CONTACT_RT = 'Vendor';    
    private static final string CLOSED_STATUS = 'Closed';    
    private static final string EXEPTION_MSG1 = '--------------';
    private static final String PAYROLL_TEMPLATE_CLOSED = 'Email Template on Case Closed Payroll';
    private static final String PAYROLL_RECORDTYPE = 'Finance Payroll RO';//Req-3213: Finance Payroll Closed Record Type
    
    /*******************************************************************
    Purpose: Method  to create temporary contacts and sends out response mail to the Vendor if the Case is Closed
    Parameters: [List of EmailMessage]
    Returns: [Void]
    Throws [Exceptions]: [EXEPTION_MSG]
    ********************************************************************/ 
    public static void EmailMessageProcessAfterInsert(List<EmailMessage> triggernew) 
    {
        //instantiate list of singleEmailMessage
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        
        //start try block
        try
        {
            //set to contain insert email message's parent case's id
            Set<Id> caseIdSet = new Set<Id>();
            //Query the specified email template          
            EmailTemplate et_payroll_closed = [Select id from EmailTemplate where name =: PAYROLL_TEMPLATE_CLOSED limit 1];
            EmailTemplate et = [Select id from EmailTemplate where name =: TEMPLATE_NAME limit 1];          
            //Query list of org wide email addresses for certain email id
            OrgWideEmailAddress[] OwdEmailAddress = [select Id from OrgWideEmailAddress where Address =: ORG_EMAIL_ID];
            //instantiate case list to contain parent cases of email messages inserted
            List<Case> caseList = new List<Case>();
            Map<Id, EmailMessage> parentIdEmailMsgMap = new Map<Id, EmailMessage>();
            
            //iterate of trigger.new
            for(EmailMessage msg : triggernew)
            {                
                //if parent is not null and message is incoming
                if(msg.Incoming == true)
                {                    
                    //store parent case ids in set
                    caseIdSet.add(msg.ParentId);
                    
                    //create map of parent case id and email message
                    parentIdEmailMsgMap.put(msg.ParentId, msg);
                }                
            }
            
            //if email message has values in it
            if(parentIdEmailMsgMap.size() > 0)
            {                
                //query parent cases of the inserted email messages
                caseList = [Select Id, Status, Subject, Description, SuppliedEmail, RecordTypeId, Non_Sutter_Email_to_case__c from Case where id IN : parentIdEmailMsgMap.keyset()];
            }
            set<string> setContactEmail = new set<string>();
            list<Contact> listContactToInsert = new list<contact>();
            map<string,id> mapContactEmailCaseId = new map<string,id>();
            map<id,id> mapContactsCase = new map<id,id>();
            Contact con = null; 
            //if parent case list is not empty          
            if(!caseList.isEmpty())
            {                
                //iterate over case list
                for(Case caseloop : caseList)
                {
                    //if case's status is closed //3213 Not sending emails back to outside addresses
                    if(caseloop.Status == CLOSED_STATUS && !caseloop.Non_Sutter_Email_to_case__c)
                    {                        
                        //instantiate temporary contact to be inserted
                        con = new Contact();
                        
                        //assign values to contact to be inserted
                        con.Email = parentIdEmailMsgMap.get(caseloop.id).fromAddress;                                               
                        con.LastName = parentIdEmailMsgMap.get(caseloop.id).fromName;
                        
                        if(con.LastName == null) 
                        {
                            con.LastName = 'Vendor';
                        }                        
                        
                        con.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT).RecordTypeId;
                                                                     
                        setContactEmail.add(con.Email);
                        listContactToInsert.add(con);
                        mapContactEmailCaseId.put(con.Email, caseloop.id); 
                     }
                 }
                 if(!listContactToInsert.isEmpty())
                  {
                    //Insert the Contacts related to Cases  
                    Database.insert(listContactToInsert);
                    
                    List<Contact> listContacts = new List<Contact>();
                      
                    if(!setContactEmail.isEmpty())
                      {
                        //Returns the Contact ids from contact which is inserted
                        listContacts = [Select id, email from contact where email IN: setContactEmail];
                      }
                    
                    if(!listContacts.isEmpty())
                      {                       
                        for(Contact cnt: listContacts)
                        {
                            //returns the contact id related to case id
                            mapContactsCase.put(mapContactEmailCaseId.get(cnt.email), cnt.id);                            
                        }                       
                      }                 
                  }
                  
                 //iterate over case list
                for(Case caseloop : caseList)
                {
                    //if case's status is closed
                    if(caseloop.Status == CLOSED_STATUS)
                    {    
                            //query specified email template
                            //instantiate email message
                            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                            
                            //assign appropriate values to email message variable
                            if ( OwdEmailAddress.size() > 0 ) {
                                email.setOrgWideEmailAddressId(OwdEmailAddress.get(0).Id);
                            }
                           //It will return the Contact's id
                            email.setTargetObjectId(mapContactsCase.get(caseloop.id));
                           if(caseloop.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(PAYROLL_RECORDTYPE).RecordTypeId)
                           {
                            //Req#-3213 if closed case recordtype is Finance Payroll
                            email.setTemplateId(et_payroll_closed.id);
                           }
                           else
                           {
                             //if case is of any other recordtype i.e. other than Finance Payroll
                             email.setTemplateId(et.id);
                           }                            
                            email.setWhatId(caseloop.id);
                            //add email message to email message list
                            allMails.add(email);                                                                
                    }                
                 }                                                    
                    
                 //if email message list is not empty
                 if(!allMails.isEmpty())
                 {
                     //send out all the emails in the list
                     Messaging.sendEmail(allMails);  
                 }                
            }
            
            //delete the temporary contact
            if(!listContactToInsert.isEmpty())
            {
               Database.delete(listContactToInsert);
            }
            
        //catch block
        } catch(Exception classException){
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG  + classException.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
        }
    }
}