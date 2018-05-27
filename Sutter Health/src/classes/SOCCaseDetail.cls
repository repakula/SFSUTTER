public without sharing class SOCCaseDetail {
    
    public string caseId;
    public Case caseObj {get;set;}
    public List<WRAddressCaseHistory> lstCaseAddressHistory {get;set;}
    string prefix;
   
    public  SOCCaseDetail() {
        caseObj = new Case();
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        caseObj =  [select casenumber,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                            status,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c,Communication_Preference_Changed_To_Fax__c,
                            subject,description,Close_Reason__c,CreatedBy.Name,Internal_Comments__c,MU_Escalation_Status__c,MU_Comments__c,contactId    
                            from case where Id = :caseId];
        if(caseObj.contactId != null) {
            prefix = '003';
        }                    
       fillCaseAddressHistory();                     
                   
    }
    
    public void fillCaseAddressHistory() {
        lstCaseAddressHistory = new List<WRAddressCaseHistory>();
        caseObj =  [select casenumber,Provider_Name__c,Provider_Type__c,PDV_Contact_Name__c,Contact_Number__c,Validated_or_not__c,Direct_Talk_to_Provider__c,
                                status,PDV_Escalation_Reason__c,SOC_Document_Status__c,Origin,Provider_Id_EAF_ID__c,Common_Subject_Lines__c,Communication_Preference_Changed_To_Fax__c,
                                subject,description,Close_Reason__c,CreatedBy.Name,Internal_Comments__c,MU_Escalation_Status__c,MU_Comments__c,
                                (Select ADDRESS__c, CITY__c, STATE__c, ZIP_CODE__c, PHONE__c, FAX_NUMBER__c, Suite__c, Floor__c, Address_Modified__c,lastmodifieddate,Address_Change__c,
                                    LastModifiedBy.Name From EAF_Validation_Audit_Trails__r order by LastModifiedDate desc), 
                                (Select Secure_City__c, Secure_Fax__c, Secure_Phone__c, Secure_State__c, Secure_Street_Address__c, Secure_Zip_Code__c, Secure_Suite__c, Secure_Floor__c,
                                Address_Change__c, Secure_Phone_Ext__c, Address_Modified__c,lastmodifieddate,LastModifiedBy.Name,CreatedBy.Name,Serial_Number__c From Provider_Validation_Updates__r  order by LastModifiedDate desc)     
                                from case where Id = :caseId];
        if(prefix=='003') {
                for(Contact_Validation_Audit_Trail__c obj : caseObj.Provider_Validation_Updates__r) {
                        WRAddressCaseHistory wrObj = new WRAddressCaseHistory();
                        wrObj.auditId = obj.id;
                        wrObj.addressModified = obj.Address_Modified__c;
                        //wrObj.strAddress = 'Modified By ' +obj.LastModifiedBy.Name + ': ' +obj.lastmodifieddate.format()+' '+'Address S#: '+obj.Serial_Number__c+' From '+ obj.Secure_Street_Address__c +' '+ obj.Secure_City__c+' To';//New Change
                        wrObj.strAddress  = obj.Address_Change__c;
                        wrObj.lastModifiedDate = obj.lastmodifieddate.format();
                        wrObj.strAddressModifiedBy = obj.CreatedBy.Name;
                        lstCaseAddressHistory.add(wrObj);
                }
        } else {
                for(PDV_EAF_Validation_Audit_Trail__c obj : caseObj.EAF_Validation_Audit_Trails__r) {
                        WRAddressCaseHistory wrObj = new WRAddressCaseHistory();
                        wrObj.auditId = obj.id;
                        wrObj.addressModified = obj.Address_Modified__c;
                        //wrObj.strAddress = 'Modified By ' +obj.LastModifiedBy.Name + ':' +obj.ADDRESS__c+' '+ obj.CITY__c;//New Change
                        wrObj.strAddress  = obj.Address_Change__c;
                        wrObj.lastModifiedDate = obj.lastmodifieddate.format();
                        wrObj.strAddressModifiedBy = obj.LastModifiedBy.Name;
                        lstCaseAddressHistory.add(wrObj);
                }
        }
    }
    
    public class WRAddressCaseHistory {
        public string auditId {get;set;}
        public string addressModified {get;set;}
        public string lastModifiedDate {get;set;}
        public string strAddress {get;set;}//New Change
        public string strAddressModifiedBy {get;set;}
    }
}