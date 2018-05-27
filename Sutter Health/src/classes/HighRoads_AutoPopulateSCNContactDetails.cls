/**
 * Class Name  : HighRoads_AutoPopulateSCNContactDetails
 * Author      : IDC Offshore
 * Description : This class is used to update the Email and Phone for all Contact Lookups on SCN
 * Created Date: 11/25/2016
 *
 Change Log
 * _______________________________________________________________________________________________________________________________________________________________
 *    Version           Name          Date        Userstory       Description
 * _______________________________________________________________________________________________________________________________________________________________
 *      1.0             Deloitte   16/03/2017     SFSHP-1         Sales - SCN - Missing Vendor Name
 * _______________________________________________________________________________________________________________________________________________________________
 **/
public class HighRoads_AutoPopulateSCNContactDetails {
    public static boolean isSCNBeforeInsert = true;
    public static boolean isSCNBeforeUpdate = true;
    /**
     * Method Name : autoPopulateEmailandPhone
     * Parameters  : List<Employer_Group_Data__c> scnList
     * Description : This method will be called when SCN is created and updated
     * Return Type : void
     **/
    public void autoPopulateEmailandPhone(List<Employer_Group_Data__c> scnList,Set<ID> contactIds){
        //Contact IDs are empty or not condition check, these contacts ids on sold case notification object.
        if(contactIds != NULL && !contactIds.isEmpty()){
            //Fetching the contact details like phone,email,department to populate in the contact references
            Map<String,Contact> contactMap = new Map<String,Contact>([select Id,Phone,Email,Department From Contact Where Id IN :contactIds LIMIT 10000]);
            for(Employer_Group_Data__c scnObj : scnList){
                //checking condition if scn billing cotact name is not null and then populate the data
                if(scnObj.BillingContact_Name__c != NULL){
                    scnObj.Billing_Contact_E_mail__c = contactMap.get(scnObj.BillingContact_Name__c).Email;
                    scnObj.Billing_Contact_Phone__c = contactMap.get(scnObj.BillingContact_Name__c).Phone;
                }
                //Else block is used to remove the data if the billing contact is null
                else{
                    scnObj.Billing_Contact_E_mail__c = NULL;
                    scnObj.Billing_Contact_Phone__c = NULL;
                }
                //checking condition if scn EDI Vendor cotact name is not null and then populate the data
                if(scnObj.EDI_Vendor_Name__c != NULL){
                    scnObj.EDI_Vendor_E_Mail__c = contactMap.get(scnObj.EDI_Vendor_Name__c).Email;
                    scnObj.EDI_Vendor_Phone__c = contactMap.get(scnObj.EDI_Vendor_Name__c).Phone;
                }
                //Else block is used to remove the data if the EDI Vendor contact is null
                else{
                    scnObj.EDI_Vendor_E_Mail__c = NULL;
                    scnObj.EDI_Vendor_Phone__c = NULL;
                }
                //checking condition if scn HR Employer Portal cotact name is not null and then populate the data
                if(scnObj.HREmployer_Portal_Name1__c != NULL){
                    scnObj.HR_Employer_Portal_E_mail1__c = contactMap.get(scnObj.HREmployer_Portal_Name1__c).Email;
                    scnObj.HR_Employer_Portal_Phone1__c = contactMap.get(scnObj.HREmployer_Portal_Name1__c).Phone;
                }
                //Else block is used to remove the data if the HR Employer Portal contact is null
                else{
                    scnObj.HR_Employer_Portal_E_mail1__c = NULL;
                    scnObj.HR_Employer_Portal_Phone1__c = NULL;
                }
                //checking condition if scn HR Employer Portal cotact name is not null and then populate the data
                if(scnObj.HREmployer_Portal_Name__c != NULL){
                    scnObj.HR_Employer_Portal_E_mail__c = contactMap.get(scnObj.HREmployer_Portal_Name__c).Email;
                    scnObj.HR_Employer_Portal_Phone__c = contactMap.get(scnObj.HREmployer_Portal_Name__c).Phone;
                }
                //Else block is used to remove the data if the HR Employer Portal contact is null
                else{
                    scnObj.HR_Employer_Portal_E_mail__c = NULL;
                    scnObj.HR_Employer_Portal_Phone__c = NULL;
                }
                //checking condition if scn HR Enrollment cotact name is not null and then populate the data
                if(scnObj.HREnrollment_Name__c != NULL){
                    scnObj.HR_Enrollment_E_mail__c = contactMap.get(scnObj.HREnrollment_Name__c).Email;
                    scnObj.HR_Enrollment_Phone__c = contactMap.get(scnObj.HREnrollment_Name__c).Phone;
                }
                //Else block is used to remove the data if the scn HR Enrollment contact is null
                else{
                    scnObj.HR_Enrollment_E_mail__c = NULL;
                    scnObj.HR_Enrollment_Phone__c = NULL;
                }
                //checking condition if scn Vendor cotact name is not null and then populate the data
                if(scnObj.Vendor_Contact_Name__c != NULL){
                    scnObj.Vendor_Contact_Email__c = contactMap.get(scnObj.Vendor_Contact_Name__c).Email;
                    scnObj.Vendor_Contact_Phone__c = contactMap.get(scnObj.Vendor_Contact_Name__c).Phone;
                    scnObj.Vendor_Name__c = contactMap.get(scnObj.Vendor_Contact_Name__c).Department;
                }
                //Else block is used to remove the data if the Vendor contact is null
                else
                {
                    scnObj.Vendor_Contact_Email__c = NULL;
                    scnObj.Vendor_Contact_Phone__c = NULL;
                    //scnObj.Vendor_Name__c = NULL; //SHP1 Missing Vendor Name
                }
            }
        }
    }
}