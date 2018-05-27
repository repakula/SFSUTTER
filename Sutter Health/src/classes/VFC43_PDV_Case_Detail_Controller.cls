/**  
*     Class Name  : VFC43_PDV_Case_Detail_Controller
*     Author      : IDC Offshore
*     Date        : 2-07-2015
*     Project Name: SOC Sutter Health
*     Description : VFC43_PDV_Case_Detail_Controller Class.
*
**/
public with sharing class VFC43_PDV_Case_Detail_Controller {
    
    public string caseId;
    public Case caseObj {get;set;}
    public List<WRAddressCaseHistory> lstCaseAddressHistory {get;set;}
    string prefix;
   
   /**
    * @author       :   IDC Offshore
    * @date         :   
    * @description  :   This constructor method is used to retrieve case record based on the caseId
    * @param        :   N/A
    * @return       :   N/A
    */
    public  VFC43_PDV_Case_Detail_Controller() {
        
        caseObj = new Case();
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        caseObj =  [select casenumber,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                            status,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c,Communication_Preference_Changed_To_Fax__c,
                            subject,description,Close_Reason__c,CreatedBy.Name,Internal_Comments__c,contactId    
                            from case where Id = :caseId];
        /*Req-3950 commented
         * if(caseObj.contactId != null) {
            prefix = '003';
        }    */    
       fillCaseAddressHistory();       
    }
    
   /**
    * @author       :   IDC Offshore
    * @date         :   
    * @description  :   This method is used to retrieve the caseAddressHistory
    * @param        :   N/A
    * @return       :   N/A
    */
    public void fillCaseAddressHistory() {
        lstCaseAddressHistory = new List<WRAddressCaseHistory>();
        caseObj =  [select casenumber,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                                status,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c,Communication_Preference_Changed_To_Fax__c,
                                subject,description,Close_Reason__c,CreatedBy.Name,Internal_Comments__c,
                                (Select ADDRESS__c, CITY__c, STATE__c, ZIP_CODE__c, PHONE__c, FAX_NUMBER__c, Suite__c, Floor__c, Address_Modified__c,lastmodifieddate,Address_Change__c,
                                    LastModifiedBy.Name From EAF_Validation_Audit_Trails__r order by LastModifiedDate desc), 
                                (Select Secure_City__c, Secure_Fax__c, Secure_Phone__c, Secure_State__c, Secure_Street_Address__c, Secure_Zip_Code__c, Secure_Suite__c, Secure_Floor__c,
                                Address_Change__c, Secure_Phone_Ext__c, Address_Modified__c,lastmodifieddate,LastModifiedBy.Name,CreatedBy.Name,Serial_Number__c From Provider_Validation_Updates__r  order by LastModifiedDate desc)     
                                from case where Id = :caseId];
       // if(prefix=='003') { Req-3950
            for(Contact_Validation_Audit_Trail__c obj : caseObj.Provider_Validation_Updates__r) {
                    WRAddressCaseHistory wrObj = new WRAddressCaseHistory();
                    wrObj.auditId = obj.id;
                    wrObj.addressModified = obj.Address_Modified__c;
                    wrObj.strAddress  = obj.Address_Change__c;
                    wrObj.lastModifiedDate = obj.lastmodifieddate.format();
                    wrObj.strAddressModifiedBy = obj.CreatedBy.Name;
                    lstCaseAddressHistory.add(wrObj);
            }
        //} Req-3950
    }
    
    /**
    * @author       :   IDC Offshore
    * @date         :   
    * @description  :   Inner class with setters and getters
    * @param        :   N/A
    * @return       :   N/A
    */
    public class WRAddressCaseHistory {
        public string auditId {get;set;}
        public string addressModified {get;set;}
        public string lastModifiedDate {get;set;}
        public string strAddress {get;set;}
        public string strAddressModifiedBy {get;set;}
    }
}