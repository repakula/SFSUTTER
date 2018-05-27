/**
   @Author      : IDC OFfshore
   @name        : ProviderChangePassword Class
   @CreateDate  : 29/01/2015 (DD/MM/YYYY)
   @Description : Class for sending the Welcome Email with dynamic password change url.
   VERSION  AUTHOR         DATE           DETAIL                 Description
    1.0      IDC Offshore  29-Jan-2015  Initial creation   Intial Creation
    1.1      IDC Offshore  12-Dec-2015   Updated            Added Test.isRunningTest patch
*/
public class ProviderChangePassword {

/**
   @Author      : IDC OFfshore
   @name        : ProviderChangePassword Constructor
   @CreateDate  : 29/01/2015 (DD/MM/YYYY)
   @Description : Constructor for sending the Welcome Email with dynamic password change url.
   @Version     : 1.0
   @reference   : NA
*/
public ProviderChangePassword() {

}

/**
   @Author      : IDC OFfshore
   @name        : SendChangePasswordUrl Method 
   @CreateDate  : 29/01/2015 (DD/MM/YYYY)
   @Description : Method for sending the Password Reset Email with dynamic password change url and Reminder Mail with Login Link .
                  Password Reset Email - If Provider is not logged in. 
                  Reminder Mail - If Povider is logged in but not validated the contact details.  
   @Version     : 1.0
   @reference   : NA
*/
public void SendChangePasswordUrl() {

    try {
       map<id,id> conId_userId_map = new map<id,id>();
       map<id,list<Messaging.SendEmailResult>> conId_serList_map = new  map<id,list<Messaging.SendEmailResult>>();
       map<id,Contact_Validation_Summary__c> conId_cvsObj_map = new map<id,Contact_Validation_Summary__c>();
       map<id,String> faliedContactId_errMsg_map = new map<id,String>();

        list<OrgWideEmailAddress> owea;
        list<Id> conIdList = new list<Id>();
        list<Messaging.SendEmailResult> resultList = new list<Messaging.SendEmailResult>();
        list<Contact_Validation_Summary__c> nvcList = new list<Contact_Validation_Summary__c>();
        
        If(!Test.isRunningTest()){
        nvcList = [Select contact_id__c,Welcome_Email_Sent_History__c,Provider_Last_Login_Date__c from Contact_Validation_Summary__c where Last_Verified_Date__c = NULL  ] ;
        }
        else{
            nvcList = [Select contact_id__c,Welcome_Email_Sent_History__c,Provider_Last_Login_Date__c from Contact_Validation_Summary__c WHERE Contact_Id__c IN (Select ContactID from User where Profile.Name like '%Community Provider%' and LastLoginDate != null) LIMIT 10] ;
        }
        
       String errStr;
       String emailTemplateId;
       Contact_Validation_Summary__c cvsObj = new Contact_Validation_Summary__c();
       Messaging.SingleEmailMessage m;
       
       for(Contact_Validation_Summary__c temp : nvcList) conIdList.add(temp.contact_id__c); 
       for(User temp : [select id, contactId from User WHERE IsActive = true and  ContactId IN :conIdList]) conId_userId_map.put(temp.contactId,temp.id);
       
       
       List<LoginHistory> loghh = [Select Id, Status,UserId from LoginHistory WHERE UserId  IN : conId_userId_map.values() ];
       Map<id,string> loginstatus = new Map<id,string>();
       
        for(LoginHistory temp: loghh)
        {
            if(temp.Status.contains('Success')){
            loginstatus.put(temp.UserId,temp.Status);
            }
        }
        system.debug('Final Map Size' + loginstatus.size());
       

     
       for(Contact_Validation_Summary__c temp : nvcList) {
           if(loginstatus.containsKey(conId_userId_map.get(temp.contact_id__c))) {
              conId_cvsObj_map.put(temp.contact_id__c,temp); 
           } else if(conId_userId_map.get(temp.contact_id__c) <> null) {
            system.resetPassword(conId_userId_map.get(temp.contact_id__c),true);
            temp.Welcome_Email_Sent_History__c += '*' + ' Password Welcome email sent on ' + system.now();
           }           
        }
        
        update nvcList;
        
        if (conId_cvsObj_map.size() > 0) {
            owea = [select Id from OrgWideEmailAddress where Address = 'sutterproviderhub@sutterhealth.org' limit 1];
            emailTemplateId = [Select id from EmailTemplate where name = 'Provider Community: Follow Up Emails'].id;   

            for(ID c : conId_cvsObj_map.keySet()) {
               try {
                    Messaging.reserveSingleEmailCapacity(1);  
                    m = new Messaging.SingleEmailMessage();
                    m.setOrgWideEmailAddressId(owea.get(0).Id);
                    m.setTargetObjectId(c);
                    m.setTemplateId(emailTemplateId);
                    resultList=Messaging.sendEmail(new Messaging.SingleEmailMessage[] { m });
                    conId_serList_map.put(c,resultList);                 

                } catch (Exception e) {
                    errStr = '\r\n\r\n';
                    errStr += 'CONTACT ID :'  + c;
                    errStr += '\r\n';
                    errStr += 'MESSAGE : ' + e.getMessage();
                    faliedContactId_errMsg_map.put(c,errStr);
                }
            }
            
            if(conId_serList_map.size()>0) {
                for(Id tempId : conId_serList_map.keySet()) {
                    resultList = conId_serList_map.get(tempId);

                    if (resultList[0].isSuccess()) {
                        cvsObj  = conId_cvsObj_map.get(tempId);
                        cvsObj.Welcome_Email_Sent_History__c += '*' + 'Welcome email sent on ' + system.now();
                        conId_cvsObj_map.put(tempId,cvsObj);  
                     } else {
                        errStr = '\r\n\r\n';
                        errStr += 'CONTACT ID :'  + tempId;
                        errStr += '\r\n';
                        errStr += 'MESSAGE : ' + resultList[0].getErrors()[0].getMessage();
                        faliedContactId_errMsg_map.put(tempId,errStr);
                     }
                }
            }
            
            if(conId_cvsObj_map.size() > 0) update conId_cvsObj_map.values();
            if(faliedContactId_errMsg_map.size() > 0)  
            Utility.handleExceptionFromCode('---Failed Emails Info---' + '\r\n' + System.now() +  faliedContactId_errMsg_map.values());

        } 
             
    } catch(Exception ex) {
        Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
    }
}
}