public class claim_line_item // keep in mapping class 
    {
         // Header section    
            public  string claim_id{get;set;}
            public  string claim_type{get;set;}
            public  string claim_line_no{get;set;}
            public  string claim_date_service{get;set;}
            public  string claim_source{get;set;}
        
        public  integer int_claim_no{get;set;}
        public  string str_start_service{get;set;}
        public  string str_end_service{get;set;}
        public  string cpt_hcpcs_code{get;set;}
        public  string str_denial_code{get;set;}
        public  string billed{get;set;}
        public  string hcc_amount{get;set;}
        public  string line_status{get;set;}
        public  boolean excluded_reinsurance{get;set;}
        public  boolean excluded_bundling{get;set;}
        public  string clean_claim_date{get;set;}
        
        
        //*** Field defination for Health Plan Section ***//
        public  string str_Health_Plan_ID {get;set;}
        public  string str_Plan_Name {get;set;}
        public  string str_Group_Name {get;set;}
        public  string str_Benefit_Plan_Type {get;set;}
        
        //*** Field defination for Admission/Discharge Section ***//
        public  Date str_Admission_Date {get;set;}
        public  string str_Admission_Hour {get;set;}
        public  string str_Admission_Type {get;set;}
        public  string str_Admission_Source {get;set;}
        public  string str_Discharge_Hour {get;set;}
        
        //*** Field defination for Payer Section ***//
        public  string str_Payer_Name {get;set;}
        public  string str_Responsible_Party_Name {get;set;}
        public  string str_Responsible_Party_Address {get;set;}
        public  string str_Responsible_Party_City {get;set;}
        public  string str_Responsible_Party_State {get;set;}
        public  string str_Responsible_Party_Zip {get;set;}
        public  string str_Responsible_Party_Phone {get;set;}
        
        //*** Field defination for Diagnosis/Proc codes Section ***//
        public  string str_Procedure_Code {get;set;}
        public  string str_Procedure_Code_Translation {get;set;}
        public  string str_Other_Procedure_Code {get;set;}
        public  string str_Other_Procedure_Code_Translation {get;set;}
        public  string str_Diagnosis_Code {get;set;}
        public  string str_Diagnosis_Code_Translation {get;set;}
        public  List<string> str_Condition_Codes {get;set;}
        public  string str_Occurrence_Code {get;set;}
        public  Integer str_Occurrence_Span {get;set;}
        public  string str_Admit_Diagnosis {get;set;}
        public  List<string> str_Patient_Reason_Diagnosis {get;set;}
        public  List<string> str_Treatment_Authorization_Codes {get;set;}
        
        //*** Field defination for CPT/HCPCS (Claim Line Detail Level) Section ***//
        public  string str_Service_Code {get;set;}
        public  string str_Service_Code_Description {get;set;}
        
        //*** Field defination for Provider Section ***//
        public  string str_Provider_Name {get;set;}
        public  string str_Provider_NPI {get;set;}
        public  string str_Type_of_Bill {get;set;}
        public  string str_Fed_Tax_Number {get;set;}
        public  string str_Attending_Physician {get;set;}
        public  string str_Operating_Physician {get;set;}
        
        //*** Field defination for Subscriber Section ***//
        public  string str_Subscriber_First_Name {get;set;}
        public  string str_Subscriber_Last_Name {get;set;}
        public  string str_Subscriber_City {get;set;}
        public  string str_Subscriber_State {get;set;}
        public  string str_Subscriber_Zip_Code {get;set;}
        public  string str_Subscription_ID {get;set;}
        
        //*** Field defination for Patient Section ***//
        public  string str_Patient_Name {get;set;}
        public  string str_Patient_Address {get;set;}
        public  string str_Patient_Birthday {get;set;}
        public  string str_Patient_Sex {get;set;}
        public  string str_P_Rel_Patients_relationship_to_insured {get;set;}
        
        //*** Field defination for Financial Section ***//
        public  Date str_Payment_Date {get;set;}
        public  Long str_Batch_Number {get;set;}
        public  string str_Clearinghouse_Number {get;set;}
        public  string str_Pay_To {get;set;}
        public  Integer str_Check_Number {get;set;}
        public  string str_Member_Responsibility_Amount {get;set;}
        public  string str_Plan_Paid_Amount {get;set;}
        public  string str_Total_Allowed_Amount {get;set;}
        public  string str_InNetwork_Allowed_Amount {get;set;}
        public  string str_Out_Network_Allowed_Amount {get;set;}
        public  string str_Coinsurance_Amount {get;set;}
        public  string str_Copay_Amount {get;set;}
        public  string str_Deductible_Amount {get;set;}
        public  string str_Non_Covered_Charges {get;set;}
        public  string str_EOB_Paid_Amount {get;set;}
        public  string str_HCC_Amount {get;set;}
        public  string str_HRA_Amount {get;set;}
        public  string str_Requested_Amount {get;set;}
        public  string str_Member_Paid_Amount {get;set;}
        public  string str_Network_Savings {get;set;}
        
        //*** Field defination for Benefit Section ***//
        public  string str_Member_Deductible_to_Date {get;set;}
        public  string str_Family_Deductible_to_Date {get;set;}
        public  string str_Remaining_Member_Deductible {get;set;}
        public  string str_Remaining_Family_Deductible {get;set;}
        public  string str_Member_Out_of_Pocket_to_Date {get;set;}
        public  string str_Family_Out_of_Pocket_to_Date {get;set;}
        public  string str_Remaining_Member_Out_of_Pocket_to_Date {get;set;}
        public  string str_Remaining_Family_Out_of_Pocket_to_Date {get;set;}
        
        //*** Field defination for Denial Section ***//
        public  string str_Denial_Code_Desc {get;set;}
        //public  string str_Denial_Code {get;set;}
        
        //*** Field defination for Adjustment Section ***//
        public  string str_Adjustment_Code {get;set;}
        public  string str_Adjustment_Code_Desc {get;set;}
    }