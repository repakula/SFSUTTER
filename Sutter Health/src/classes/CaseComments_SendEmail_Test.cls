/**  
*     Class Name: CaseComments_SendEmail_Test
*     Author: Atul Gupta
*     Date: 21-February-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description: This is a Test Class for CaseComments_SendEmail Trigger.
*     
*    History
*    --------
*
*    VERSION    AUTHOR         DATE        DETAIL 
*       
**/
@isTest
public class CaseComments_SendEmail_Test{
    
    static testMethod void insertCaseComment()
    {
        Account acc = AP01_TestDataUtility.createAccount();
        //Assert to check Account is created successfull
        system.assert(acc.id!=null);
        Contact con = AP01_TestDataUtility.employeeContact(acc);
        //Assert to check Contact is created successfull
        system.assert(con.id!=null);
        Case empCase = AP01_TestDataUtility.employeeInquiryCase(con);
        //Assert to case is created successfull
        system.assert(empCase.id!=null);
        CaseComment comment = AP01_TestDataUtility.employeeInquiryCaseComment(empCase);
        //Assert to check case comment is created successfull
        system.assert(comment.id!=null);
    }
}