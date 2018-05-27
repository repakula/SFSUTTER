/**  
*     Class Name  : ManageCaseHelpTrigger
*     Author      : IDC Offshore
*     Date        : 8/24/2015 
*     Project Name: CRM - SFT - Sutter Health
*     Description : Handler class for Trigger ManageCases.
*
*     History:
*      
*     VERSION        AUTHOR            DATE             DETAIL Description
*      2.0          Umesh Vajpai      5/27/16       Commented out few validation rules as part of request 3732
**/

public with sharing class ManageCaseHelpTrigger {
    
    
    public static Map<string, string> caseRecordTypeMap;
    private static final String ErrorSting = 'please porvide the value';
    private static final String SHP_ATC_Eligibility_Related = 'SHP ATC Eligibility Related';
    private static final String Verify_Eligibility = 'Verify Eligibility';
    private static final String Termination = 'Termination';    // Req 3390 - web to case
    private static final String SHP_ATC_Incomplete_Submission_Related = 'SHP ATC Incomplete Submission Related';    
    private static final String Missing_Information = 'Missing Information';
    private static final String No_Submission_Reason_Given = 'No Submission Reason Given';
    private static final String No_Effective_Date_Listed = 'No Effective Date Listed'; 
    private static final String Other_Missing_Information  = 'Other Missing Information' ;
    private static final String ATC_Form_Clarification_Needed  = 'ATC Form Clarification Needed' ;
    private static final String Illegible_ATC_Form  = 'Illegible ATC Form'; 
    private static final String SHP_ATC_Plan_Change_Issue_Related  ='SHP ATC Plan Change Issue Related';
    private static final String Clarity_Needed  = 'Clarity Needed';
    private static final String Change_of_Medical_Plan  = 'Change of Medical Plan';
    private static final String Change_of_Sub_Account  = 'Change of Sub Account';
    private static final String Change_to_Cobra  = 'Change to Cobra';
    private static final String SHP_Billing_Invoice_Question  = 'SHP Billing Invoice Question';
    private static final String Invoice_Request  = 'Invoice(s) Request';
    private static final String Current_Balance  = 'Current Balance';
    private static final String Payment_Rec_d  = 'Payment Rec\'d?';
    private static final String Invoice_Discrepancy  = 'Invoice Discrepancy';
    private static final String Extended_Bill_Reconciliation  = 'Bill Reconciliation';
    private static final String SHP_Broker_Education  = 'SHP Broker Education';
    private static final String Group_Kit_Request  = 'Group Kit Request';
    private static final String Small_Group  = 'Small Group';
    private static final String Large_Group  = 'Large Group';
    private static final String Form_Requests = 'Form Requests';
    private static final String Service_Area_Expansion_Questions  = 'Service Area/Expansion Questions';
    private static final String Benefit_Related  = 'Benefit Related';
    private static final String Rate_Questions  = 'Rate Questions';
    private static final String SHP_Employer_Education  = 'SHP Employer Education';
    private static final String SHP_EDI_Escalated_Issue  = 'SHP EDI Escalated Issue';
    private static final String Previous_EDI_Issue  = 'Previous EDI Issue';
    private static final String Repeat_Offender  = 'Repeat Offender';
    private static final String Reach_out_to_Employer_EDI_Vender  = 'Reach out to Employer/EDI Vender';
    private static final String SHP_EDI_Feed_Issue  = 'SHP EDI Feed Issue';
    private static final String Eligibility  = 'Eligibility';
    private static final String SS  = 'SS#';
    private static final String DOB  = 'DOB';
    private static final String PCP_or_PCP_ID  = 'PCP or PCP ID #';
    private static final String Incorrectly_Keyed_Submission  = 'Incorrectly Keyed Submission';
    private static final String SHP_EDI_Issue_Member_in_WB  = 'SHP EDI Issue Member in WB';
    private static final String SHP_Employer_Portal_Approval_Access_Inquiries  = 'SHP Employer Portal Approval Access Inquiries';
    private static final String Create_Account  = 'Create Account';
    private static final String Account_Access  = 'Account Access';
    private static final String SHP_Member_Information_Request_Related  = 'SHP Member Information Request Related';
    private static final String IFP_Lead  = 'IFP Lead';
    private static final String SHP_RFP_Rejection_Related  = 'SHP RFP Rejection Related';
    private static final String DQ_d  = 'DQ\'d';
    private static final String SHP_SCN_Submission_Rejection_Related  = 'SHP SCN Submission Rejection Related';
    private static final String Clarification_Needed  = 'Clarification Needed';
    private static final String Missing_Rate_Sheet  = 'Missing Rate Sheet';
    private static final String SHP_Update_Request_for_Accounts  = 'SHP Update Request for Accounts';
    private static final String Broker_Account   = 'Broker Account';
    private static final String Change_of_Contact_Information  = 'Change of Contact Information';
    private static final String Addition_of_New_Broker_Contact  = 'Addition of New Broker Contact';
    private static final String Addition_of_New_Division  = 'Addition of New Division';
    private static final String Termination_Request  = 'Termination Request';
    private static final String Employer_Account  = 'Employer Account';
    private static final String Sub_Account_Change_of_Contact_Information  = 'Sub Account Change of Contact Information';
    private static final String Change_of_Broker_of_Record  = 'Change of Broker of Record';
    private static final String SHP_Update_Request_for_Contact  = 'SHP Update Request for Contact';
    private static final String Broker_Contact  = 'Broker Contact';
    private static final String Removal_Termination_of_Broker  = 'Removal/Termination of Broker';
    private static final String Employer_Contact  = 'Employer Contact';
    private static final String Change_of_Primary_Point_of_Contact  = 'Change of Primary Point of Contact'; 
    private static final String Change_of_Billing_Point_of_Contact  = 'Change of Billing Point of Contact';
    private static final String Media_Inquires ='Media Inquires';
    private static final String Portal ='Portal Inquiry';    
    private static final String Benefits = 'Benefits';
    private static final String Claims  = 'Claim Review';
    private static final String Clincial = 'Clinical Notifications';
    private static final String Eligiblity = 'Eligiblity ';
    private static final String Non_SHP_Contact = 'Non-SHP Contact';
    private static final String Cobra = 'Cobra';
    private static final String Rx_Issue = 'Rx Issue';
    private static final String Follow_up_Review_Clarification = 'Follow up/Review Clarification';  
    private static final String Accumulator = 'Accumulator';
    private static final String Ed_notification = 'Ed notification';
    private static final String OON_OOA = 'OON/OOA';
    private static final String PCP_Change_Request = 'PCP Change Request';
    private static final String Portal_Unlock_General  = 'Portal Unlock General';
    private static final String strError = 'please chech the above check-box';
    private static final String Billing  = 'Billing';   // Req. 3390 Web to Case        
    private static final String Complaint = 'Complaint';  // Req. 3390 Web to Case      
    private static final String Enrollment = 'Enrollment';  // Req. 3390 Web to Case
    
   
    /*************************************************************************************************
    *   @Description....................: validating the sales service request dynamically           *
    *   @Param..........................: List<Case>                                                 *
    *   @Return.........................: void                                                       *      
    *   @Requirement....................: 3369 Automation workflow phaseII                           *
    **************************************************************************************************/
    public Static void dynamicallyValidateMandatoryFieldsOnSR(List<Case> TriggerNew, Map<String, String> caseRecdMap){
         caseRecordTypeMap = caseRecdMap;
        
          for(case ObjCase : TriggerNew){
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_ATC_Eligibility_Related)){             
                if((ObjCase.Sub_Category__c == Verify_Eligibility)  ){
                    if(objCase.Employer_Name__c == null)
                        ObjCase.Employer_Name__c.addError(ErrorSting);
                    if(objCase.Group_Id__c == null)
                        ObjCase.Group_Id__c.addError(ErrorSting);
                    if(objCase.Member_Name__c == null)
                        ObjCase.Member_Name__c.addError(ErrorSting);
                    if(objCase.Member_ID_SHP_SR__c == null)
                        ObjCase.Member_ID_SHP_SR__c.addError(ErrorSting);
                }
                /* Req 3390 - web to case       
                *  if subcategory is 'Termination' in SR - SHP_ATC_Eligibility_Related, then below validation would work.
                */
                if((ObjCase.Sub_Category__c == Termination)  ){     
                    if(objCase.Termination_Reason__c == null)       
                        ObjCase.Termination_Reason__c.addError(ErrorSting);     
                    if(objCase.Termination_Date__c == null)     
                        ObjCase.Termination_Date__c.addError(ErrorSting);       
                }
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_ATC_Incomplete_Submission_Related)){
                
                if(objCase.Sub_Category__c == Missing_Information){
                    if(ObjCase.SR_Option__c == No_Submission_Reason_Given || ObjCase.SR_Option__c == No_Effective_Date_Listed || ObjCase.SR_Option__c == Other_Missing_Information 
                        ||  ObjCase.SR_Option__c == ATC_Form_Clarification_Needed || ObjCase.SR_Option__c ==Illegible_ATC_Form) {
                        if(objCase.Employer_Name__c == null)
                            ObjCase.Employer_Name__c.addError(ErrorSting);
                        if(objCase.Group_Id__c == null)
                            ObjCase.Group_Id__c.addError(ErrorSting);
                        if(objCase.Member_Name__c == null)
                            ObjCase.Member_Name__c.addError(ErrorSting);
                        if(objCase.Member_ID_SHP_SR__c == null)
                            ObjCase.Member_ID_SHP_SR__c.addError(ErrorSting);
                    }
                }
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_ATC_Plan_Change_Issue_Related)){
                if(objCase.Sub_Category__c == Clarity_Needed){
                    if(ObjCase.SR_Option__c == Change_of_Medical_Plan|| ObjCase.SR_Option__c ==Change_of_Sub_Account || ObjCase.SR_Option__c ==Change_to_Cobra )
                        if(objCase.Employer_Name__c == null)
                            ObjCase.Employer_Name__c.addError(ErrorSting);
                        if(objCase.Group_Id__c == null)
                            ObjCase.Group_Id__c.addError(ErrorSting);
                        if(objCase.Member_Name__c == null)
                            ObjCase.Member_Name__c.addError(ErrorSting);
                        if(objCase.Member_ID_SHP_SR__c == null)
                            ObjCase.Member_ID_SHP_SR__c.addError(ErrorSting);
                }
            }
            
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_Billing_Invoice_Question)){ 
                if((objCase.Sub_Category__c == Invoice_Request) || (objCase.Sub_Category__c == Current_Balance) 
                    || (objCase.Sub_Category__c == Payment_Rec_d) || (objCase.Sub_Category__c == Invoice_Discrepancy) || (objCase.Sub_Category__c == Extended_Bill_Reconciliation)){                    
                        if(objCase.Employer_Name__c == null)
                            ObjCase.Employer_Name__c.addError(ErrorSting);  
                        if(objCase.Group_Id__c == null)
                            ObjCase.Group_Id__c.addError(ErrorSting);                           
                        if(objCase.POC_Name_Broker_or_Employer__c == null)
                            ObjCase.POC_Name_Broker_or_Employer__c.addError(ErrorSting);
                        if(objCase.POC_Contact_Information_Email__c == null)
                            ObjCase.POC_Contact_Information_Email__c.addError(ErrorSting);
                        if(objCase.POC_Contact_Information_Phone__c == null)
                            ObjCase.POC_Contact_Information_Phone__c.addError(ErrorSting);
                }
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_Broker_Education)){
                if((objCase.Sub_Category__c == Group_Kit_Request) 
                    && ((objCase.SR_Option__c == Small_Group)|| (objCase.SR_Option__c == Large_Group))){                    
                        if(objCase.Brokerage_Name__c == null)
                            ObjCase.Brokerage_Name__c.addError(ErrorSting);                     
                        if(objCase.POC_Information__c == null)
                            ObjCase.POC_Information__c.addError(ErrorSting);
                }
                
                if(objCase.Sub_Category__c == Form_Requests){                   
                        if(objCase.Brokerage_Name__c == null)
                            ObjCase.Brokerage_Name__c.addError(ErrorSting);                     
                        if(objCase.POC_Information__c == null)
                            ObjCase.POC_Information__c.addError(ErrorSting);
                        if(objCase.Type_of_Form__c == null)
                            ObjCase.Type_of_Form__c.addError(ErrorSting);
                }
                
                if((objCase.Sub_Category__c == Service_Area_Expansion_Questions)
                    ||(objCase.Sub_Category__c == Benefit_Related)
                    ||(objCase.Sub_Category__c == Rate_Questions)){                 
                    if(objCase.Brokerage_Name__c == null)
                        ObjCase.Brokerage_Name__c.addError(ErrorSting);                     
                    if(objCase.POC_Information__c == null)
                        ObjCase.POC_Information__c.addError(ErrorSting);
                }
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_Employer_Education)){
                if(objCase.Sub_Category__c == Form_Requests){                   
                        if(objCase.Employer_Name__c == null)
                            ObjCase.Employer_Name__c.addError(ErrorSting);                      
                        if(objCase.POC_Information__c == null)
                            ObjCase.POC_Information__c.addError(ErrorSting);
                        if(objCase.Type_of_Form__c == null)
                            ObjCase.Type_of_Form__c.addError(ErrorSting);
                }
                
                if(objCase.Sub_Category__c == Service_Area_Expansion_Questions){                    
                    if(objCase.Employer_Name__c == null)
                        ObjCase.Employer_Name__c.addError(ErrorSting);                      
                    if(objCase.POC_Information__c == null)
                        ObjCase.POC_Information__c.addError(ErrorSting);
                }
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_EDI_Escalated_Issue)){
                if(((objCase.Sub_Category__c ==Previous_EDI_Issue) 
                || (objCase.Sub_Category__c == Repeat_Offender)) && (objCase.SR_Option__c == Reach_out_to_Employer_EDI_Vender)){                    
                        if(objCase.Employer_Name__c == null)
                            ObjCase.Employer_Name__c.addError(ErrorSting);                      
                        if(objCase.Group_Id__c == null)
                            ObjCase.Group_Id__c.addError(ErrorSting);
                        if(objCase.Member_ID_SHP_SR__c == null)
                            ObjCase.Member_ID_SHP_SR__c.addError(ErrorSting);
                        if(objCase.Member_Name__c == null)
                            ObjCase.Member_Name__c.addError(ErrorSting);
                }
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_EDI_Feed_Issue)){
                if(objCase.Sub_Category__c == Eligibility){
                    if(objCase.SR_Option__c == Verify_Eligibility){
                        if(objCase.Employer_Name__c == null)
                            ObjCase.Employer_Name__c.addError(ErrorSting);                      
                        if(objCase.Group_Id__c == null)
                            ObjCase.Group_Id__c.addError(ErrorSting);
                        if(objCase.Member_ID_SHP_SR__c == null)
                            ObjCase.Member_ID_SHP_SR__c.addError(ErrorSting);
                        if(objCase.Member_Name__c == null)
                            ObjCase.Member_Name__c.addError(ErrorSting);
                    }
                }
                if(objCase.Sub_Category__c == Missing_Information){
                    if((objCase.SR_Option__c == SS)
                        ||(objCase.SR_Option__c == DOB)
                        ||(objCase.SR_Option__c == PCP_or_PCP_ID)
                        ||(objCase.SR_Option__c == Other_Missing_Information)
                        ||(objCase.SR_Option__c == Incorrectly_Keyed_Submission)){
                            if(objCase.Employer_Name__c == null)
                                ObjCase.Employer_Name__c.addError(ErrorSting);                      
                            if(objCase.Group_Id__c == null)
                                ObjCase.Group_Id__c.addError(ErrorSting);
                            if(objCase.Member_ID_SHP_SR__c == null)
                                ObjCase.Member_ID_SHP_SR__c.addError(ErrorSting);
                            if(objCase.Member_Name__c == null)
                                ObjCase.Member_Name__c.addError(ErrorSting);
                    }
                }
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_EDI_Issue_Member_in_WB)){
                if(objCase.Sub_Category__c == Eligibility){
                    if(objCase.SR_Option__c == Verify_Eligibility){
                        if(objCase.Employer_Name__c == null)
                            ObjCase.Employer_Name__c.addError(ErrorSting);                      
                        if(objCase.Group_Id__c == null)
                            ObjCase.Group_Id__c.addError(ErrorSting);
                        if(objCase.Member_ID_SHP_SR__c == null)
                            ObjCase.Member_ID_SHP_SR__c.addError(ErrorSting);
                        if(objCase.Member_Name__c == null)
                            ObjCase.Member_Name__c.addError(ErrorSting);
                    }
                }
                if(objCase.Sub_Category__c ==Missing_Information){
                    if((objCase.SR_Option__c == SS)
                        ||(objCase.SR_Option__c == DOB)
                        ||(objCase.SR_Option__c == PCP_or_PCP_ID)
                        ||(objCase.SR_Option__c == Other_Missing_Information)
                        ||(objCase.SR_Option__c == Incorrectly_Keyed_Submission)){
                            if(objCase.Employer_Name__c == null)
                                ObjCase.Employer_Name__c.addError(ErrorSting);                      
                            if(objCase.Group_Id__c == null)
                                ObjCase.Group_Id__c.addError(ErrorSting);
                            if(objCase.Member_ID_SHP_SR__c == null)
                                ObjCase.Member_ID_SHP_SR__c.addError(ErrorSting);
                            if(objCase.Member_Name__c == null)
                                ObjCase.Member_Name__c.addError(ErrorSting);
                    }
                }
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_Employer_Portal_Approval_Access_Inquiries)){
                if((objCase.Sub_Category__c == Create_Account)||(objCase.Sub_Category__c == Account_Access)){
                    if(objCase.Username__c == null)
                        ObjCase.Username__c.addError(ErrorSting);                       
                    if(objCase.Employer_Name__c == null)
                        ObjCase.Employer_Name__c.addError(ErrorSting);
                    if(objCase.POC_Information__c == null)
                        ObjCase.POC_Information__c.addError(ErrorSting);
                }
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_Member_Information_Request_Related)){
                if((objCase.Sub_Category__c == IFP_Lead) || (objCase.Sub_Category__c == Form_Requests)){
                    if(objCase.POC_Name__c == null)
                        objCase.POC_Name__c.addError(ErrorSting);
                    if(objCase.Contact_Information__c == null){
                        objCase.Contact_Information__c.addError(ErrorSting);
                    }
                    if(objCase.Type_of_Form__c == null){
                        objCase.Type_of_Form__c.addError(ErrorSting);
                    }
                }
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_RFP_Rejection_Related)){
                if((ObjCase.Sub_Category__c ==Missing_Information) || (ObjCase.Sub_Category__c == DQ_d) ){
                    if(objCase.Description == null)
                        objCase.Description.addError(ErrorSting);
                }
            
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_SCN_Submission_Rejection_Related)){
                if((ObjCase.Sub_Category__c ==Missing_Information) || (ObjCase.Sub_Category__c == Clarification_Needed) || (ObjCase.Sub_Category__c == Missing_Rate_Sheet)){
                    if(objCase.Description == null)
                        objCase.Description.addError(ErrorSting);
                }
            }
            
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_Update_Request_for_Accounts)){
                if(objCase.Sub_Category__c == Broker_Account ){
                    if(ObjCase.SR_Option__c == Change_of_Contact_Information) {
                        if(objCase.Brokerage_Name__c == null) 
                            objCase.Brokerage_Name__c.addError(ErrorSting);
                        //REQ 3732 start----
                        /*if(objCase.Change_of_Primary_Correspondence_Address__c == null) 
                            objCase.Change_of_Primary_Correspondence_Address__c.addError(ErrorSting);
                        if(objCase.Change_of_Billing_Correspondence_Address__c == null)
                            objCase.Change_of_Billing_Correspondence_Address__c.addError(ErrorSting);*/
                            //REQ 3732 end----
                        if(objCase.Change_of_Phone__c == null)
                            objCase.Change_of_Phone__c.addError(ErrorSting);
                    }
                    if(ObjCase.SR_Option__c == Addition_of_New_Broker_Contact){
                            if(objCase.Broker_Name__c == null)
                                objCase.Broker_Name__c.addError(ErrorSting);
                            if(objCase.License__c == null)
                                objCase.License__c.addError(ErrorSting);
                            if(objCase.Tax_ID__c == null)
                                objCase.Tax_ID__c.addError(ErrorSting);
                            if(objCase.Phone_s_If_Different__c == null)
                                objCase.Phone_s_If_Different__c.addError(ErrorSting);
                            if(objCase.Address_If_Different__c == null)
                                objCase.Address_If_Different__c.addError(ErrorSting);
                            if(objCase.email_address__c == null)
                                objCase.email_address__c.addError(ErrorSting);
                    }
                    if((ObjCase.SR_Option__c == Addition_of_New_Division)){
                        if(objCase.Division_Name__c == null)
                            objCase.Division_Name__c.addError(ErrorSting);
                        if(objCase.License__c == null)
                            objCase.License__c.addError(ErrorSting);
                        if(objCase.Tax_ID__c == null)
                            objCase.Tax_ID__c.addError(ErrorSting);
                        if(objCase.Primary_Correspondence_Address__c == null)
                            objCase.Primary_Correspondence_Address__c.addError(ErrorSting);
                        if(objCase.Phone_s__c == null)
                            objCase.Phone_s__c.addError(ErrorSting);
                        if(objCase.email_address__c == null)
                            objCase.email_address__c.addError(ErrorSting);
                    }
                    if(ObjCase.SR_Option__c == Termination_Request){
                        if(objCase.Brokerage_Name__c == null)
                            objCase.Brokerage_Name__c.addError(ErrorSting);
                    }
                }
                if(objCase.Sub_Category__c == Employer_Account){
                    if(ObjCase.SR_Option__c == Change_of_Contact_Information){ 
                        if(objCase.Employer_Name__c == null)  
                            objCase.Employer_Name__c.addError(ErrorSting);
                        if(objCase.Group_Id__c == null)
                            objCase.Group_Id__c.addError(ErrorSting);
                        if(objCase.Primary_Correspondence_Address__c == null) 
                            objCase.Primary_Correspondence_Address__c.addError(ErrorSting);
                        if(objCase.Billing_Correspondence_Address__c == null)
                            objCase.Billing_Correspondence_Address__c.addError(ErrorSting);
                        if(objCase.Phone_s__c == null)
                            objCase.Phone_s__c.addError(ErrorSting);
                    }
                    if(ObjCase.SR_Option__c == Sub_Account_Change_of_Contact_Information){
                        if(objCase.Employer_Name__c == null)
                            objCase.Employer_Name__c.addError(ErrorSting);
                        if(objCase.Group_Id__c == null)
                            objCase.Group_Id__c.addError(ErrorSting);
                        if(objCase.Name_of_Sub_Account__c == null)
                            objCase.Name_of_Sub_Account__c.addError(ErrorSting);
                        //REQ 3732 start----
                        /*if(objCase.Change_of_Primary_Correspondence_Address__c == null)
                             objCase.Change_of_Primary_Correspondence_Address__c.addError(ErrorSting);
                        if(objCase.Change_of_Other_Correspondence_Address__c == null)
                            objCase.Change_of_Other_Correspondence_Address__c.addError(ErrorSting);*/
                            //REQ 3732 end----
                        if(objCase.Change_of_Phone__c == null)
                            objCase.Change_of_Phone__c.addError(ErrorSting);
                    }
                    if(ObjCase.SR_Option__c == Change_of_Broker_of_Record){
                        if(objCase.Employer_Name__c == null)
                            objCase.Employer_Name__c.addError(ErrorSting);
                        if(objCase.Group_Id__c == null)
                            objCase.Group_Id__c.addError(ErrorSting);
                        if(objCase.Brokerage_Name__c == null)
                            objCase.Brokerage_Name__c.addError(ErrorSting);
                        if(objCase.Producer_Name__c == null)
                            objCase.Producer_Name__c.addError(ErrorSting);
                    }
                }
                
            }
            // Update Request for Contact//
            if(ObjCase.RecordTypeId == caseRecordTypeMap.get(SHP_Update_Request_for_Contact)){
                if(objCase.Sub_Category__c == Broker_Contact){
                    if(ObjCase.SR_Option__c == Change_of_Contact_Information) {
                        if(objCase.Brokerage_Name__c == null )
                            objCase.Brokerage_Name__c.addError(ErrorSting);
                        if(objCase.Broker_Name__c == null )
                            objCase.Broker_Name__c.addError(ErrorSting);
                        if(objCase.Primary_Correspondence_Address__c == null)
                            objCase.Primary_Correspondence_Address__c.addError(ErrorSting);
                        if(objCase.Phone_s__c == null)
                            objCase.Phone_s__c.addError(ErrorSting);
                        if(objCase.email_address__c == null)
                            objCase.email_address__c.addError(ErrorSting);
                    }
                    if(ObjCase.SR_Option__c == Removal_Termination_of_Broker){
                        if(objCase.Brokerage_Name__c == null)
                            objCase.Brokerage_Name__c.addError(ErrorSting);
                        if(objCase.Broker_Name__c == null)
                            objCase.Broker_Name__c.addError(ErrorSting);
                    }
                }
                if(objCase.Sub_Category__c == Employer_Contact){
                    if(ObjCase.SR_Option__c == Change_of_Contact_Information) {
                        if(objCase.Employer_Name__c == null )
                            objCase.Employer_Name__c.addError(ErrorSting);
                        if(objCase.Group_Id__c == null )
                            objCase.Group_Id__c.addError(ErrorSting);
                        if(objCase.Primary_Correspondence_Address__c == null)
                            objCase.Primary_Correspondence_Address__c.addError(ErrorSting);
                        if(objCase.Phone_s__c == null)
                            objCase.Phone_s__c.addError(ErrorSting);
                    }
                    if(ObjCase.SR_Option__c == Change_of_Primary_Point_of_Contact) {
                        if(objCase.POC_Name__c == null )
                            objCase.POC_Name__c.addError(ErrorSting);
                        if(objCase.Primary_Correspondence_Address__c == null)
                            objCase.Primary_Correspondence_Address__c.addError(ErrorSting);
                        if(objCase.Phone_s__c == null)
                            objCase.Phone_s__c.addError(ErrorSting);
                        if(objCase.email_address__c == null)
                            objCase.email_address__c.addError(ErrorSting);
                    }
                    if(ObjCase.SR_Option__c == Change_of_Billing_Point_of_Contact) {
                        if(objCase.Billing_POC_Name__c == null )
                            objCase.Billing_POC_Name__c.addError(ErrorSting);
                        if(objCase.Billing_Correspondence_Address__c == null)
                            objCase.Billing_Correspondence_Address__c.addError(ErrorSting);
                        if(objCase.Phone_s__c == null)
                            objCase.Phone_s__c.addError(ErrorSting);
                        if(objCase.email_address__c == null)
                            objCase.email_address__c.addError(ErrorSting);
                    }
                }
            }
        }
    } 

/* Req. 3390 - Web to Case - Method 'createSRForWebToCase' to add Contact Name/Claim Id on Incoming cases via Portal. 
    * Below method will check whether the case origin is Portal or not and accordingly will perform  operation.
    * Method will add contact details on incoming cases based on their SR's.
*/      
public static void createSRForWebToCase( List<Case> insertedCaseList, Map<String,String> caseRecordTypeMapWebtoCase ) {     
            
    List < String > EmaillistOfInsetedCases = new List< String >();     
    List < String > GroupIdOfInsertedCase = new List <String>();        
    List < String > MemberIdOfInsertedCase = new List <String>();       
    List < String > AccId = new List <String>();        
    List < String > ClaimIdOfInsertedCase = new List <String>();        
    List < Case > PortalCaseList = new List<Case >();       // List to store cases where origin will be 'Portal'.       
     
    // Defined Map to contain records based on different condition. 
    Map<String,Contact> emailToContactMap = new Map<String,Contact>(); // To capture contact based on Email provided. 
    Map<String,Account> Accountbygroupid = new Map<String,Account>();  // To capture Account based on supplied groupId.
    Map<String,Contact> ContactbyAccount = new Map<String,Contact>();  // To capture last modified contact based on AccountID - For Employer SR     
    Map<String,Contact> MemberIDbyAccount = new Map<String,Contact>();  // To capture contact based on MemberId - For Member SR        
    Map<String,Claim_Header__c> ContactbyClaimHeader = new Map<String,Claim_Header__c>(); // To capture Claim header ID based on claim Id.     
    
    //  List 'PortalCaseList' to store cases belongs to origin 'Portal'.       
    for ( Case InsertedCase: insertedCaseList  ) {      
        if ( InsertedCase.origin == 'Portal') {     
            PortalCaseList.add(InsertedCase);       
        }       
    }       
            
            
    if ( !PortalCaseList.isEmpty() )        
    {       
                
        for (Case insertedCase:PortalCaseList ) {       
                    
            if( insertedCase.SuppliedEmail != null ) {      
                EmaillistOfInsetedCases.add(insertedCase.SuppliedEmail);        
            }       
            if( insertedCase.Group_Id__c != null) {     
                GroupIdOfInsertedCase.add(insertedCase.Group_Id__c);        
            }       
            if( insertedCase.shp_Member_Id__c != null){     
                MemberIdOfInsertedCase.add(insertedCase.shp_Member_Id__c);      
            }       
            if (insertedCase.Member_Claim_ID__c != null){       
                ClaimIdOfInsertedCase.add(insertedCase.Member_Claim_ID__c);     
            }       
        }       
                
    // Populate Map with all contact if Supplied Email is not empty.          
        if( !EmaillistOfInsetedCases.isEmpty() ) {      
            for( Contact loopCon: [ SELECT Id,Email,Member_ID__c FROM Contact WHERE Email IN :EmaillistOfInsetedCases ]) {      
                emailToContactMap.put(loopCon.Email, loopCon );     
                    
            }       
        }       
    // Populate Map for those contact where Member id is equal to supplied Member Id - Member SR.            
        if(!MemberIdOfInsertedCase.isEmpty() ) {        
            for(Contact loopConMemberId: [ SELECT Id,Member_ID__c FROM Contact WHERE Member_ID__c IN :MemberIdOfInsertedCase ]) {       
                MemberIDbyAccount.put(loopConMemberId.Member_ID__c, loopConMemberId);       
            }       
        }       
    // Populate Map for those Account where Group id is equal to supplied group id - Employer SR.            
        if (!GroupIdOfInsertedCase.isEmpty()) {     
            for( Account loopAcn: [SELECT Id,SHP_Group_ID__c FROM Account WHERE SHP_Group_ID__c IN :GroupIdOfInsertedCase]) {       
                Accountbygroupid.put(loopAcn.SHP_Group_ID__c, loopAcn);     
                AccId.add(loopAcn.Id);      
            }       
    // Populate Map only for those contact where Account ID is equal to collected ID in above query.             
            for( Contact loopContact: [SELECT Id,AccountId FROM Contact WHERE AccountID IN :AccId Order by LastModifiedDate ASC]) {     
                ContactbyAccount.put(loopContact.AccountId, loopContact);       
            }           
        }       
    // Populate Map for those Claim header where claim name is equal to supplied claim name.            
        if (!ClaimIdOfInsertedCase.isEmpty() ) {        
            for( Claim_Header__c loopClaim: [SELECT Id, name FROM Claim_Header__c where name IN :ClaimIdOfInsertedCase ]) {     
                ContactbyClaimHeader.put(loopClaim.name,loopClaim);         
            }       
        }       
    // Below loop is for inserted case and checking for supplied Email. 
    // If Supplied Email is not valid or Null then it will add contact details based on Group Id for Employer & Member Id for Member. 
    
        for(Case loopCase : PortalCaseList) {       
        if (loopCase.SuppliedEmail == NULL || emailToContactMap.get(loopCase.SuppliedEmail) == NULL)        
        {       
                                        
            if(loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(SHP_ATC_Eligibility_Related)         
                 ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(SHP_ATC_Plan_Change_Issue_Related)             
                 ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(SHP_Billing_Invoice_Question)                  
                 ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(SHP_Update_Request_for_Accounts)       
                )           
                {       
                    if(loopCase.Group_Id__c == NULL || Accountbygroupid.get(loopCase.Group_Id__c) == NULL) {      
                    }           
                    else        
                    {       
                    String accidbygroup = Accountbygroupid.get(loopCase.Group_Id__c).Id;  // Getting AccountID of supplied group Id.      
                    loopCase.ContactId = ContactbyAccount.get(accidbygroup).Id;   // Adding last modified contact on supplied Group Id.  
                    }       
                }       
                        
            if(loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Benefits)        
           ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Billing)             
           ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Claims)                  
           ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Complaint)       
           ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Eligibility)     
           ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Enrollment)      
            )           
            {       
                    if(loopCase.shp_Member_Id__c == NULL || MemberIDbyAccount.get(loopCase.shp_Member_Id__c) == NULL) {       
                    }       
                    else        
                    {       
                    loopCase.ContactId = MemberIDbyAccount.get(loopCase.shp_Member_Id__c).Id;     // Adding Contact Id of supplied Member id.   
                    loopCase.Member_Id_Contact__c= MemberIDbyAccount.get(loopCase.shp_Member_Id__c).Id;  // Adding Contact Id of supplied Member id.  
                    }       
            }       
            if(loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Claims))     
            {       
                    if(loopCase.Member_Claim_ID__c == NULL || ContactbyClaimHeader.get(loopCase.Member_Claim_ID__c) == NULL){        
                    }       
                    else        
                    {       
                    loopCase.Claim_ID__c= ContactbyClaimHeader.get(loopCase.Member_Claim_ID__c).Id;   // Adding Claim Id.   
                    }       
            }       
        }       
                
        else        
            {       
                if(loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(SHP_ATC_Eligibility_Related)             
                 ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(SHP_ATC_Plan_Change_Issue_Related)                     
                 ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(SHP_Billing_Invoice_Question)                      
                 ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(SHP_Update_Request_for_Accounts)           
                )                   
                {               
                    if(loopCase.Group_Id__c == NULL || Accountbygroupid.get(loopCase.Group_Id__c) == NULL){              
                    }       
                    else                
                    {               
                    String accidbygroup = Accountbygroupid.get(loopCase.Group_Id__c).Id;    // Getting AccountID of supplied group Id.            
                    loopCase.ContactId = ContactbyAccount.get(accidbygroup).Id;   // Adding last modified contact on supplied Group Id.            
                    }               
                }       
                if(loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Benefits)        
                 ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Billing)               
                 ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Claims)                
                 ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Complaint)     
                 ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Eligibility)       
                 ||  loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Enrollment)        
                )       
                {       
                    if(loopCase.shp_Member_Id__c == NULL || MemberIDbyAccount.get(loopCase.shp_Member_Id__c) == NULL){  
                    }       
                    else        
                    {       
                    loopCase.ContactId = MemberIDbyAccount.get(loopCase.shp_Member_Id__c).Id;      // Adding Contact Id of supplied Member id. 
                    loopCase.Member_Id_Contact__c= MemberIDbyAccount.get(loopCase.shp_Member_Id__c).Id;   // Adding Contact Id of supplied Member id.  
                    }       
                }       
                if(loopCase.RecordTypeId == caseRecordTypeMapWebtoCase.get(Claims))     
                {       
                    if(loopCase.Member_Claim_ID__c == NULL || ContactbyClaimHeader.get(loopCase.Member_Claim_ID__c) == NULL){        
                    }
                    else        
                    {       
                    loopCase.Claim_ID__c= ContactbyClaimHeader.get(loopCase.Member_Claim_ID__c).Id;    // Adding Claim Id. 
                    }       
                }       
            }       
        }       
    }       
   }
   
   /*************************************************************************************************
    *   @Description....................: Auto populate Employee Id and Preferred CallBack Number on Service Request record*
    *   @Param..........................: List<Case>                                                 *
    *   @Return.........................: void                                                       *      
    *   @Requirement....................: 3756                                                       *
    **************************************************************************************************/
    public Static void autoPopulateFields(List<Case> TriggerNew){
    
        map<string, string> caseRecordTypeMapName = new Map<string, string>();
        Map<String,Schema.RecordTypeInfo> caseRtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        for( Schema.RecordTypeInfo rtype : caseRtMapByName.values()){
            caseRecordTypeMapName.put(rtype.getName(), rtype.getRecordTypeId());
        }
        //system.debug(TriggerNew);
        map<id,String> mapRelatedEmpToEmpIdId = new map<id,String>();
        set<Id> ContactSet = new set<Id>();
        
        for(case objCase : TriggerNew)
            ContactSet.add(objCase.Related_to_Employee__c);
            
        for(Contact objContact : [Select id,Employee_ID__C from Contact where Id IN:ContactSet])
            mapRelatedEmpToEmpIdId.put(objContact.Id,objContact.Employee_ID__C);
        
        for(case objCase : TriggerNew){
            if(objCase.RecordTypeId == caseRecordTypeMapName.get('Human Resources') || objCase.RecordTypeId == caseRecordTypeMapName.get('Finance Payroll') || objCase.RecordTypeId == caseRecordTypeMapName.get('S3 Interaction Log')){
                if(objCase.Related_to_Employee__c != null)
                {
                    if(mapRelatedEmpToEmpIdId.get(objCase.Related_to_Employee__c) != null){
                        objCase.Related_to_Employee_ID__c = mapRelatedEmpToEmpIdId.get(objCase.Related_to_Employee__c);
                    }
                }
            }
        }
    }    
}