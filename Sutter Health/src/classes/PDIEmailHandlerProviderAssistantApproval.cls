/**  
*    Class Name: PDIEmailHandlerProviderAssistantApproval 
*    Date: 15-11-2016
*    Created By: IDC Offshore		
*    Description: Used to capture provider admin aasistant approval status reply from incoming email.
**/
global class PDIEmailHandlerProviderAssistantApproval implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        SystemException__c systemException = new SystemException__c();
        try{
            String strSubject = email.Subject;
            strSubject = strSubject.trim();
            String summaryId = strSubject.subString(strSubject.length()-18, strSubject.length());
            String strBody = email.plainTextBody;
            List<String> parts = strBody.split('\n');
            String strBodyLine1 =  parts[0];
            String approvedStatus;
            Contact_Validation_Summary__c providerToUpdate = new Contact_Validation_Summary__c();
            //querying to get the provider summary info to update the approval status
            providerToUpdate = [SELECT Id,Name, Admin_Assistant__c, Admin_Assistant_Email__c, 
                                Admin_Assistant_Approval_Status__c FROM Contact_Validation_Summary__c  WHERE Id = :summaryId];
            List<PDIAdminAssistantApprovalKeywords__c> keyWords = PDIAdminAssistantApprovalKeywords__c.getall().values();
            for(PDIAdminAssistantApprovalKeywords__c appStatus: keyWords){
                if(strBodyLine1.toUpperCase().trim().contains(appStatus.Name)){
                    approvedStatus = Label.CL580_PDIEmailApprovedText;
                }
            }
            if(String.isNotBlank(approvedStatus) && approvedStatus == Label.CL580_PDIEmailApprovedText){
                approvedStatus = Label.CL580_PDIEmailApprovedText;
                providerToUpdate.Admin_Assistant_Approval_Status__c = approvedStatus;
            }
            else{
                approvedStatus = Label.CL581_PDIEmailRejectedText;
                providerToUpdate.Admin_Assistant_Approval_Status__c = approvedStatus;
            }
            if(providerToUpdate != null){
                providerToUpdate.Admin_Approval_Status_Received_On__c = System.now();
                providerToUpdate.Tech_Success_Email__c = false;
                update providerToUpdate;
                String headerBody = Label.CL582_PDIEmailFromText + email.fromAddress +'\n'
                    + Label.CL583_PDIEmailApprovalSubject + email.Subject +'\n'
                    + Label.CL584_PDIEmailApprovalReceivedOn +  System.now().format() +'';
                Attachment attachment = new Attachment();
                attachment.Name = Label.CL585_PDIEmailApprovalStatusText +approvedStatus + ' (' + System.now().format() + ').PDF';
                attachment.Body = Blob.toPDF(email.HtmlBody);
                attachment.ParentId = summaryId;
                attachment.Description = headerBody;
                insert attachment;
            }
            return null;
        } 
        catch(Exception ex) {
            systemException.ExceptionMessage__c = ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now(); insert systemException; return null;
        }
    }
}