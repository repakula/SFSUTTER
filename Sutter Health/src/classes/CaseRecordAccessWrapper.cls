/**  
*     Class Name: CaseRecordAccessWrapper
*     Author: IDC Offshore
*     Date: 24-May-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description: This is Wrapper Class to bind the accesslevel property of Case to the Case object.
*                  Implemented as a part of Req 3364 : Security and Roles Evaluation ,so that based on 
*                  the hasAccess boolean value we will be able to render Subject and Column values on 
*                  Customer Inquiries tab of OLTP Screen. 
**/
    public class CaseRecordAccessWrapper {
        public Case caseRecord {get; set;}
        public Boolean hasAccess {get; set;}

      //This is the contructor method. When we create a new wrapCaseobject we pass a Case that is set to the caseRecord property and
      //hasAccess boolean which is set to hasAccess property
        public CaseRecordAccessWrapper(Case c, Boolean hasAccess) {
            this.caseRecord = c;
            this.hasAccess = hasAccess;
        }
    }