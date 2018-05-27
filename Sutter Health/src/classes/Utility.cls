/**  
*     Class Name: Utility
*     Author: Brandon Cassis
*     Date: 22-August-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description: This class is defined with a global access modifier so that it can be accessed throughout the org,
*     the class is designed to contain utility methods, such as storage of exceptions
*     meassages from apex code. As methods are written that can be used throughout the org, they 
*     should be added to this class for consistant management.
*     At the time of writing this description the class contains two methods, one handleExceptionFromCode which is called by catch methods throughout 
*     the org, this method inserts the exception messages caught in SystemException object. 
*     Second is the sendErrorEmail email which is called throught the org, this method takes exception messages caught as argument and
*     send an email with the exception message as email body. 
*
*    History
*    --------
*
*    VERSION    AUTHOR         DATE        DETAIL 
*       1.0     IDC Offshore   07/07/2013  Changes made to the sendErrorEmail method to refer custom setting for setToAddresses field
**/

global Class Utility {
    
    
    /**
    *   @Description: This is a future method to insert exception messages caught by catch block thourghout the org
    *   @Arguments: String exception messages     
    *   @Return: Void
    *   @Exception: This method call is to accepts the exception string build out of details about 
    *   the exception and stores that exception in a custom object that can be reported on. This call does
    *   not follow standards for line length to increase test code coverage.
    *   An email containing the exception message and stack trace history is sent to the defined user in Custom Setting.
    **/
    @future
    public static void handleExceptionFromCode(String exceptionMessage) {
        
        /** @Description: Checks if the exception parameter caught is null or not **/
        if(exceptionMessage != null) {
           
           /** @Description: Initiate a new instance of SystemException__c object **/
           SystemException__c systemException = new SystemException__c();
            
           /** @Description: Assign exception message passed to the method to ExceptionMessage__c field of SystemException__c object **/
           systemException.ExceptionMessage__c = exceptionMessage;
           
           /** @Description: Start of try block **/
           try{
           
                /** @Description: insert the systemException record **/
                insert systemException;
                
            /** @Description: exception caught **/
           }catch(Exception classException) {
                
                /** @Description: Called teh sendErrorEmail method of Utility class to send and and email with exception message as email body **/
                Utility.sendErrorEmail(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }  
        }    
    }
    
    /**
    *   @Description: This method takes the exception messages as parameter, its called throughout the org wherever an exception is caught, 
    *   this method send an email to the address as defined in the custom settings, with exception message caught by the catch block as email body
    *   @Arguments: String exception message     
    *   @Return: Void
    **/    
    public static void sendErrorEmail(String exceptionMessage) {
    
        system.debug('exceptionMessage::'+exceptionMessage);
        //String[] emailAddress = '';
        
        /** @Description: String emailAddress is assigned the email address defined in the custom settings **/
        //emailAddress = Label.toEmailAddress.split(Label.CL231_PDISplitComma);
        
        /** @Description: Initiate an instance of Messaging.SingleEmailMessage **/
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        /** @Description: Put the email addresses taken from custom settings in a list of Strings toAddresses **/
        
        //******************Modified by Umesh
        
        String[] toAddresses = Label.toEmailAddress.split(Label.CL231_PDISplitComma);
        
        //***************************
        
        /** @Description: Define various parameters required to send an email **/
        mail.setToAddresses(toAddresses);
        mail.setReplyTo(Label.ReplyTo);
        mail.setSenderDisplayName(Label.SenderDisplayName);
        mail.setSubject(Label.EmailSubject);
        mail.setPlainTextBody(exceptionMessage);
        Messaging.sendEmail(new Messaging.Email[] { mail });
    }
    
    //Only designed for VFC01_CustomConsole constructor logic 
    public static void sendErrorEmailToAdmin(String exceptionMessage) {
    
        /** @Description: Initiate an instance of Messaging.SingleEmailMessage **/
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        /** @Description: Put the email addresses taken from custom settings in a list of Strings toAddresses **/
        
        //******************Modified by Umesh
        
        //String[] toAddresses = new String[] {};
        String[] toAddresses= Label.AdminEmail.split(Label.CL231_PDISplitComma);
        //String[] toaddress = Label.AdminEmail.split(',',0);
        //***************************
        
        /** @Description: Define various parameters required to send an email **/
        mail.setToAddresses(toAddresses);
        mail.setReplyTo(Label.ReplyTo);
        mail.setSenderDisplayName(Label.SenderDisplayName);
        mail.setSubject(Label.EmailSubject);
        mail.setPlainTextBody(exceptionMessage);
        Messaging.sendEmail(new Messaging.Email[] { mail });
    }
}