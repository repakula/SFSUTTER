/************************************************************************************************************************
     Class Name : HighRoads_SendAttachmentsInEmail
     Author     : IDC Offshore
     Date       : 12/1/2016
     Description: Req - 3980 This is used to send the attachments of the record to current logged in user
							 This class will be called from Send All Attachments button on Quote and SSO
     History:
     VERSION    AUTHOR              DATE        DETAIL
     1.0        IDC-Offshore      12/1/2016     This is used to send the attachments of the record to current logged in user
****************************************************************************************************************************/
global class HighRoads_SendAttachmentsInEmail {
    
    /**
     * Method Name : sendAttachments
     * Parameters  : ID recordId,String[] userEmail,String objName
     * Description : To send attachments in the email
     * Req no      : 3980
     * Return type : String - success or failure message
     **/
    webservice static String sendAttachments(ID recordId,String[] userEmail,String objName,String accountName,String DBAName,String mailSubject){
        try{
            //fetching the org wide email address to send the email
            OrgWideEmailAddress[] owea = [select Id,DisplayName from OrgWideEmailAddress where Address = :System.Label.fromEmailAddress];
            //creating single email message instance
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //setting the to address
            mail.setToAddresses(userEmail);
            //setting the org wide email address to send the email from this address
            //i.e. salesforce@sutterhealth.org
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            //mail body fetching from custom label
            String mailBody = system.Label.HR216_QuoteSSOAttachmentEmailFormat;
            //replacing the constants in email template
            mailBody = mailBody.replace(HighRoads_Constants.OBJ_NAME_CONSTANT, objName).replace(HighRoads_Constants.EMP_DBA_CONSTANT ,HighRoads_Constants.EMP_NAME_CONSTANT+accountName+HighRoads_Constants.DBA_CONSTANT+DBAName);
            //setting mail subject
            mail.setSubject(mailSubject);
            //setting the plain text body to email
            mail.setPlainTextBody(mailBody);
            //adding the attachments from the records to send them to user
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            for (Attachment attachObj : [select Name, Body, BodyLength from Attachment where ParentId = :recordId])
            {
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(attachObj.Name);
                efa.setBody(attachObj.Body);
                fileAttachments.add(efa);
            }
            //setting the multiple file attachments
            mail.setFileAttachments(fileAttachments);
            //sending email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            //return the successmessage
            return System.Label.HR198_EmailAttachmentSent;
        }catch(Exception e){
            return e.getMessage();
        }
        
    }
}