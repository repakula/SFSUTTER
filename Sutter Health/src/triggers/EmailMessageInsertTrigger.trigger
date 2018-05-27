/**  
 *    Trigger Name: EmailMessageInsertTrigger
 *    Author: Offshore IDC 
 *    Date: 21-August-2014
 *    Description: On "Insert" event trigger calls the class "AP02_EmailMessage" that sends response to those emailaddresses that are executing the "Email To Case functionality" on closed Cases.
 *    			   On "Delete" that trigger prevent the end user to delete the email records.	
 *    History
 *    VERSION    AUTHOR              DATE         DETAIL              Description   
 *    1.1        Offshore IDC        21-Aug-2014  Initial Development Changes as part of the Email to Case Finance Payroll : REQ 3139
 *    --------
 **/
trigger EmailMessageInsertTrigger on EmailMessage(after insert, before delete) {
    // if trigger is context is insert
    if (Trigger.isInsert) {
        //trigger after insert
        if (Trigger.isAfter) {
            //Method sends response to those emailaddresses that are executing the "Email To Case functionality" on closed Cases.
            AP02_EmailMessage.EmailMessageProcessAfterInsert(Trigger.new);
        }
    } 
    else if (Trigger.isDelete) {
      	//trigger before delete
        if (Trigger.isBefore) {
            for (EmailMessage a: Trigger.old) {
            	// Prevent the end user to delete the email records.
                a.addError('Email Deletion Is Not Authorized.');
            }
        }
    }
}