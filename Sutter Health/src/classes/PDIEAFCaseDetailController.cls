/**  
*     Class Name  : PDIEAFCaseDetailController
*     Author      : Nagarjuna Kaipu
*     Date        : 28-10-2016
*     Description : used to show eaf case details
*
**/
public with sharing class PDIEAFCaseDetailController {
    public string caseId {get;set;}
    public Case caseObj {get;set;}
    public List<PDV_EAF_Validation_Audit_Trail__c> auditChangeHistory {get; set;}
    public  PDIEAFCaseDetailController(){
        caseObj = new Case();
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        caseObj =  [select casenumber, Facility_Name__c,PDV_Contact_Name__c,Contact_Number__c,
                    status,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c,
                    subject,description,Close_Reason__c,CreatedBy.Name,Internal_Comments__c,contactId    
                    from case where Id = :caseId];
        auditChangeHistory = new List<PDV_EAF_Validation_Audit_Trail__c>();
        auditChangeHistory = [Select Id,  Name, Address_Change__c, CreatedBy.Name, LastModifiedDate, 
                              LastModifiedBy.Name From PDV_EAF_Validation_Audit_Trail__c Where Case__c = :caseId Order By Id Desc];    
    }
}