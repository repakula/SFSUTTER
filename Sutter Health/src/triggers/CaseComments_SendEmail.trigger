/**  
*    Trigger: CaseComments_SendEmail 
*    Author: IDC
*    Date: 19-Feb-2014
*    Description: This is the trigger to send an email notification after the comment is added to case
*    History:
*    6/13/2014 - Shashank Singhal
               - Added the code to setsaveasactivity to false
*              - Added comments to code
*    6/16/2014 - Umesh Kumar Vajpai
               - Portal users can't own any activity so added conditional setSaveAsActivity. 
**/
trigger CaseComments_SendEmail on CaseComment (after insert) {
    
    /*
        Variable declaration
    */
    set<string> caseCommentId = new set<string>();
    List<Messaging.SingleEmailMessage> portalMessages = new List<Messaging.SingleEmailMessage>();
    Set<Id> userId = new Set<ID>();
    Map<ID,Id> userContact = new Map<ID,ID>();
    
    try
    {
        /*
            Variable definition
        */
        string orgWideEmailId = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'salesforce@sutterhealth.org'].Id;
        string emailTemplateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Employee_Portal_Inquiry_Comment_Notification'].Id;
        
       
        //get the current user's profile
        Profile currentUserProfile =[Select Id, Name from Profile where Id=: UserInfo.getProfileId()];
        /*
            Iterate over trigger.new
        */
        for(CaseComment caseComment : trigger.new)
        {
            /*
                if comment is published            
            */
            if(caseComment.IsPublished)
            {
                caseCommentId.add(caseComment.Id);
                userId.add(caseComment.createdById);
            }
        }  
        
        //Query the user details and create a Map
        for(User u: [Select Id, ContactId from User where ID In:userId])
        {
            userContact.put(u.Id,u.ContactId);
        }
        
        /*
            fetch the case comment
        */
        for(CaseComment tempComment:[Select Id, IsPublished, ParentId, Parent.RecordType.Name, Parent.ContactId, Parent.Contact.RecordType.Name, Parent.Contact.Employee_Work_Email__c,CreatedByID,Parent.Contact.ID from CaseComment where Id IN :caseCommentId])
        {
            /*
                If agent added the comment
            */
            if((tempComment.Parent.RecordType.Name == 'Employee Inquiry'||tempComment.Parent.RecordType.Name == 'Employee Inquiry RO') && tempComment.Parent.Contact.RecordType.Name == 'Employee' && tempComment.Parent.Contact.ID != userContact.get(tempComment.CreatedByID))
            {
                /*
                    create the mail
                */
                Messaging.SingleEmailMessage tempMessage = new Messaging.SingleEmailMessage();
                tempMessage.setTargetObjectId(tempComment.Parent.ContactId);
                tempMessage.setOrgWideEmailAddressId(orgWideEmailId);
                tempMessage.setTemplateId(emailTemplateId);
                tempMessage.setWhatId(tempComment.ParentId);
                
                 /*
                 Portal users can't own any activity error; added this line of code for them.
                 */
                 if(currentUserProfile.Name.equals('Community Portal') || currentUserProfile.Name.equals('Community Portal Manager'))
                 {
                    tempMessage.setSaveAsActivity(false);
                 }
                portalMessages.add(tempMessage);
            }
        }  
        
        if(!portalMessages.isEmpty())
        {
            /*
                send mail
            */
            Messaging.sendEmail(portalMessages);
        }
    }catch(Exception TriggerException)
    {
      Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
      Utility.sendErrorEmail(TriggerException.getMessage() + '\r\n' + TriggerException.getStackTraceString() + '\r\n' + TriggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
    }
}