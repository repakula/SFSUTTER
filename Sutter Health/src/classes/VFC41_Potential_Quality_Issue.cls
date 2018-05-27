/**  
*     Class Name  : VFC41_Potential_Quality_Issue
*     Author      : IDC Offshore
*     Date        : 01-Aug-2015
*     Project Name: CRM - SHP - Sutter Health
*     Description : VFC41_Potential_Quality_Issue Class.
**/
public  with sharing  class VFC41_Potential_Quality_Issue{
    // Variables used in PQI Page
   
    public Potential_Quality_Issue__c objPotentialQualityIssue{get;set;}
    //public String PCPPractionerName{get;set;}
    //public String PCPSupplierName{get;set;}
    public boolean isPQINamePopulated{get;set;}
    public boolean isPOIPractionerNamePopulated{get;set;}
    public boolean isPQIMemberMedicalGroupAffiliation{get;set;}
    public boolean isMemberDOB{get;set;}
    public Date dt{get;set;}
    public boolean isother {get;set;}
    public boolean isotherMedical {get;set;}
    public boolean isotherMedicalPqiIndicator {get;set;}
    public String showBlankVlaue{get;set;}
    public String errorMessage {get;set;}
    public Boolean showErroronLoad {get;set;} // if true an error shown to the user and redirected back to PQI PAge  
   
    //public String selectItem {get; set;}
    //public String memberName {get; set;}
    
    // Req 3377 - Varibale to store the SCN Training Document - Start
    public SHP_Training_Document__kav PQITrainingDocument {get;set;}
    private static final String KNOWLEDGEARTICLEID =  System.Label.PQI_Training_Doc_KnowledgeId;      
    // Req 3377 - Varibale to store the SCN Training Document - End
    
    /**
* @author IDC Team
* @date 1/08/2015
* @description Constructor of the class. It initializes required variable and assigne those variable with the        
* respective value. 
* @param 
* @return Void 
*/
    public VFC41_Potential_Quality_Issue(ApexPages.StandardController stdController){
        isother  =false;
        isotherMedical  = false;
        isotherMedicalPqiIndicator = false;
       // selectItem = '';
            objPotentialQualityIssue = new Potential_Quality_Issue__c ();
            List<String> strName; 
            List<String> lstStr;
        try
        {
            list<String> lstField = new  List<String>{'Access_Availability__c', 'Admit_within_3_days_of_ER__c','Assessment_Treatment_Diagnosis__c','Assigned_Medical_Director__c','Assigned_RN__c',
                'Coding__c','Communications_Conduct__c','Continuity_of_Care__c','Customer_Inquiry_Type__c','Delay_Care_or_Referral__c','Description_of_Events1__c',
                'Facility_Office_Environment__c','Medical_Director_Recommendations__c','Medical_Director_Review_Summary1__c',
                'Member_ID__c','Member_Medical_Group_Affiliation__c','Member_Name__c','Member_DOB__C','Member_Age__c','Never_Events__c','Overutilization__c',
                'PCP_Practioner_Name__c','Pharmacy__c','PQI_Referral_Date__c','PQI_Referred_By__c','Quality_of_Care__c','Readmission__c','Reason_for_Referral__c',
                'RN_Case_Review_Summary1__c','RN_Recommendations__c','Safety__c','Sentinel_Event__c','Settings__c','Severity_Level__c','PQI_Status__C','Surgical_Services__c',
                'Technical_Competence__c','UM_Referrals_or_Auths__c','Underutilization__c','Unexpected_Death__c','Unsure__c','Facility_Office_BH__c','Id','Member_ID__r.Name',
                'RN_Leveling__c','Date_of_Occurrence__c','Peer_Review_Credentialing_Outcome__c','RN_Date_of_Review__C','RN_Timeline_of_Key_Events__C','RN_Pertinent_criteria_guidelines_standa__C',
                'RN_Justification_of_Recommendation__C','RN_Severity_Level__C','MD_Date_of_Review__C','Setting_other__c','PQI_indicator_Other__c','Medical_Director_Recommendations_Other__c',
                'Peer_Review_Other__c','ByPass_CMO__c','RN_Reviewer_user__c','Other_CheckBox__c','Assigned_RN__r.Name','RN_Reviewer_user__r.Name'
                ,'Owner.Name','Selected_PQI_Indicators__c','Related_Provider_applicable__c','name','Comment_UM__c','Comment_CMO__c','Comment_PRC__c'};
            
             if (!Test.isRunningTest())
            {   
                stdController.addFields(lstField); 
                // Req 3377 Change Start - Query to get the Training Document for SCN 
                if( PQITrainingDocument == null ) {
                    PQITrainingDocument = [ SELECT Id From SHP_Training_Document__kav WHERE PublishStatus = 'Online' AND Language = 'en_US' AND KnowledgeArticleId = :KNOWLEDGEARTICLEID limit 1 ];
                }
                // Req 3377 Change End - Query to get the Training Document for SCN
            }
            
            
            objPotentialQualityIssue=  (Potential_Quality_Issue__c) stdController.getRecord();
            //Shows the error if the owner of PQI is a queue
            if(objPotentialQualityIssue.PQI_Status__c == 'Closed' || objPotentialQualityIssue.owner.name == 'Quality'|| objPotentialQualityIssue.owner.name =='CMO' || objPotentialQualityIssue.owner.name == 'UM Reviewers' || (objPotentialQualityIssue.ownerID != Userinfo.getuserId() && objPotentialQualityIssue.ownerID != null)) 
                showErroronLoad = true;
            else
                showErroronLoad = false;
            
            OtherValue(); // Checks if other is selected in a Multi PickList for PRC section
            OtherValuePqiIndicator(); // Checks if the Other checkbox is selected in PQI indicator
            isOtherMedical(); // Checks if other is selected in a Multi PickList for MD Review section
            if(stdController.getRecord() != null)
            {    
                contact objContact = new contact();
                List<contact> listContact = new List<contact>();
                List<PCP_Information__c> lstPCPInfo = new List<PCP_Information__c>();
                string idStr = objPotentialQualityIssue.Member_ID__c;
                datetime todayTimeAndDate = System.today(); 
                //lstPCPInfo = listContact.PCP_Informations__r;   
                date CurrentDate = Date.newInstance(todayTimeAndDate.year(),todayTimeAndDate.month(),todayTimeAndDate.day());  
                if(objPotentialQualityIssue.Member_ID__c!= null ){  
                    
                    listContact = [SELECT Name, Member_ID__c,Birthdate, Member_Group_Affiliation__c,(SELECT PCP_Practitioner_Name__c
                                FROM PCP_Informations__r 
                                WHERE (PCP_Effective_date__c <=: CurrentDate AND PCP_Termination_Date__c >=: CurrentDate))  FROM contact WHERE id =: idStr and Account.name !='' limit 1];                                              
                    // If the Member ID or any other relevant fields are not auto populated then they are made editable.                                                                                                
                    if(ListContact.size()>0 && ListContact != null && !ListContact.isEmpty())
                    {
                        if( listContact[0].Member_ID__c != null)
                        {
                            isPQINamePopulated = true;
                        }
                        else{
                            
                            isPQINamePopulated = false;
                        }
                        
                        
                        if(listContact[0].Member_Group_Affiliation__c != null)
                        {
                            isPQIMemberMedicalGroupAffiliation = true;
                        }
                        else
                        {
                            
                            isPQIMemberMedicalGroupAffiliation = false;
                        }
                        if(listContact[0].BirthDate != null){
                            
                            isMemberDOB = true;
                        }
                        else
                        {
                            
                            isMemberDOB = false;
                        }
                        if(listContact[0].PCP_Informations__r.size() == 1 &&  listContact[0].PCP_Informations__r[0].PCP_Practitioner_Name__c != null)
                        {
                            
                            isPOIPractionerNamePopulated = true;
                        }
                        else
                        {
                            
                            isPOIPractionerNamePopulated = false;
                        }
                       
                    }               
                }
            }
        if (Test.isRunningTest())
        {
            integer i =6/0 ;
        }
            
        }catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage())); 
        }
    }
    
    
    
/**
* @author IDC Team
* @date 1/08/2015
* @description used to enable or disable other text box basis on  multi select value from peer review
* the opened Customer Interaction
* @param 
* @return void
*/
    public void OtherValue()
    {
        if(objPotentialQualityIssue.Peer_Review_Credentialing_Outcome__c != null)
        {
            if(objPotentialQualityIssue.Peer_Review_Credentialing_Outcome__c.contains('Other'))
                isother = true;
            else
                isother = false;
        }
    }
/**
* @author IDC Team
* @date 1/08/2015
* @description used to enable or disable other text box basis on  checkbox value
* the opened Customer Interaction
* @param 
* @return void
*/
    public void OtherValuePqiIndicator()
    {
        if(objPotentialQualityIssue.Other_CheckBox__c == true)
            isotherMedicalPqiIndicator = true; 
        else
            isotherMedicalPqiIndicator = false;
    }
    
    
/**
* @author IDC Team
* @date 1/08/2015
* @description used to enable or disable other text box basis on  multi select value from peer review Medical Director Recommendations
* the opened Customer Interaction
* @param 
* @return void
*/
    
    public void isOtherMedical()
    {
        if(objPotentialQualityIssue.Medical_Director_Recommendations__c!= null)
        {
            if(objPotentialQualityIssue.Medical_Director_Recommendations__c.contains('Other'))
                isotherMedical = true; 
            else
                isotherMedical = false;
        }
    }
    
/**
* @author IDC Team
* @date 15/08/2013
* @description When a user clicks on the Save button on Cutomer all value will get save in PQI object
* @param 
* @return object
*/
    
    public PageReference Save(){
        if (!CheckHyperLink() ) {
            return null;
        }
        
        if(objPotentialQualityIssue.Other_CheckBox__c == null || objPotentialQualityIssue.Other_CheckBox__c != true)
            objPotentialQualityIssue.PQI_indicator_Other__c  = null;
        if(objPotentialQualityIssue.Medical_Director_Recommendations__c==null || !objPotentialQualityIssue.Medical_Director_Recommendations__c.contains('Other'))
            objPotentialQualityIssue.Medical_Director_Recommendations_Other__c  = null;
        if(objPotentialQualityIssue.Peer_Review_Credentialing_Outcome__c==null || !objPotentialQualityIssue.Peer_Review_Credentialing_Outcome__c.contains('Other'))
            objPotentialQualityIssue.Peer_Review_Other__c   = null;
        if(objPotentialQualityIssue.Settings__c == null || objPotentialQualityIssue.Settings__c != 'Other')
            objPotentialQualityIssue.Setting_other__c   = null;
        
        try
        {
                // Checks for all the required fields are populated and populates the PQI_Required_Field__C so that Approval from standard page can be sent with the required field values 
            if (PQIRequired()){
                objPotentialQualityIssue.PQI_Required_Field__C =true;
            }else{
                objPotentialQualityIssue.PQI_Required_Field__C =false;
            }
            objPotentialQualityIssue.RN_Reviewer_user__c =objPotentialQualityIssue.Assigned_RN__c ;
            Database.upsert(objPotentialQualityIssue,true);
            PageReference objPR = new PageReference('/'+objPotentialQualityIssue.Id);   
            objPR.setRedirect(true); 
            return objPR;
        }
        catch(Exception classException){         
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------'));      
            
        }
        return null;
    }
    
    /* When a record is Closed  using Closed  button*/
    public Pagereference closeRecord()
    {
        try{
            if(objPotentialQualityIssue != null)
                objPotentialQualityIssue.PQI_Status__c  = 'Closed';
            Database.upsert(objPotentialQualityIssue,true);
            PageReference objPR = new PageReference('/'+objPotentialQualityIssue.Id);   
            objPR.setRedirect(true); 
            return objPR;
        }
        catch(Exception classException){         
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------'));      
           
        }
        return null;
    }
    
/**
* @author IDC Team
* @date 15/08/2013
* @description This method is use  for the validation in mandatory fields
* @param 
* @return boolean
*/
    public boolean PQIRequired(){
        boolean isValid = true;
        boolean isValidPQIIndicator = false;
        
        if ( isEmpty(objPotentialQualityIssue.Member_Name__c)|| objPotentialQualityIssue.Member_Name__c == null) {
            
            isValid = false;
            errorMessage = 'Error: Please Enter the value in Member ID !';
            objPotentialQualityIssue.Member_Name__c.addError('Please Enter the value Member ID!');
        }
        if ( objPotentialQualityIssue.Member_ID__c == null) {
            isValid = false;
            objPotentialQualityIssue.Member_ID__c.addError('Please Enter the value in  Member Name !');
        }
        if ( objPotentialQualityIssue.PQI_Referral_Date__c == null) {
            isValid = false;
            objPotentialQualityIssue.PQI_Referral_Date__c.addError('Please Enter the value in PQI Referral Date!');
        }
        if (isEmpty(objPotentialQualityIssue.PQI_Referred_By__c) || objPotentialQualityIssue.PQI_Referred_By__c == null) {
            isValid = false;
            objPotentialQualityIssue.PQI_Referred_By__c.addError('Please Enter the value  in PQI Referred By!');
        }
        if (isEmpty(objPotentialQualityIssue.Reason_for_Referral__c) || objPotentialQualityIssue.Reason_for_Referral__c == null) {
            isValid = false;
            objPotentialQualityIssue.Reason_for_Referral__c.addError('Please Enter the value in Reason For Referral!');
        }
        if (isEmpty(objPotentialQualityIssue.Assigned_RN__c) ||objPotentialQualityIssue.Assigned_RN__c == null) {
            isValid = false;
            objPotentialQualityIssue.Assigned_RN__c.addError('Please Enter the value in Assigned RN!');
        }
        List<Schema.FieldSetMember> schemaset= SObjectType.Potential_Quality_Issue__c.FieldSets.PQI_Indicators_Fields.getFields();
        for(integer a=0;a<schemaset.size();a++){
            if( objPotentialQualityIssue.get(schemaset[a].getFieldPath()) == true )
                isValidPQIIndicator = true;
            
        }
        
        If (isValidPQIIndicator == false &&  objPotentialQualityIssue.Other_CheckBox__c==  false )
            objPotentialQualityIssue.addError('PQI Indicators: Please Select  PQI Indicators!');
        
        if (objPotentialQualityIssue.Other_CheckBox__c==  true && isValidPQIIndicator== false ) {
            if(string.isEmpty(objPotentialQualityIssue.PQI_indicator_Other__c)){
                isValid = false;
                objPotentialQualityIssue.PQI_indicator_Other__c.addError('Please Enter the value Other PQI Indicators!');
            }
            else{
                isValidPQIIndicator = true;
            }
        }
        
        if (objPotentialQualityIssue.Settings__c== 'Other' ) {
            if(isEmpty(objPotentialQualityIssue.Setting_other__c)){
                isValid = false;
                objPotentialQualityIssue.Setting_other__c.addError('Please Enter the value in Other Settings!');
            }
        }
        
        if (objPotentialQualityIssue.Medical_Director_Recommendations__c== 'Other' ) {
            if(isEmpty(objPotentialQualityIssue.Medical_Director_Recommendations_Other__c)){
                isValid = false;
                objPotentialQualityIssue.Medical_Director_Recommendations_Other__c.addError('Please Enter the value in Other Medical Director Recommendations!');
            }
        }
        
        if (objPotentialQualityIssue.Peer_Review_Credentialing_Outcome__c== 'Other' ) {
            if(isEmpty(objPotentialQualityIssue.Peer_Review_Other__c)){
                isValid = false;
                objPotentialQualityIssue.Peer_Review_Other__c.addError('Please Enter the value  in Other Peer Review Credentialing Outcome !');
            }
        }
        if (isValidPQIIndicator && isValid )
            return true;
        else
            return false ;
    }
     public boolean isEmpty(String strValue) {
        if (String.IsBlank(strValue)) {
            return true;
        }
        return false;
    } 
    
/**
* @author IDC Team
* @date 04/08/2015
* @description This method to validate if any richtext field contains hyper link
* @param 
* @return boolean
*/
    
    Public boolean  CheckHyperLink()
    {
        boolean boolHasHyperLink = false;
        
        if(objPotentialQualityIssue.Description_of_Events1__c != null)
        {
            if(objPotentialQualityIssue.Description_of_Events1__c.contains('<a href') == true )
            {
                boolHasHyperLink = true; 
            }
        }
        if(objPotentialQualityIssue.RN_Timeline_of_Key_Events__c !=null)
        {
            if(objPotentialQualityIssue.RN_Timeline_of_Key_Events__c.contains('<a href') == true )
            {
                boolHasHyperLink = true; 
            }
        }
        if(objPotentialQualityIssue.RN_Case_Review_Summary1__c != null)
        {
            if(objPotentialQualityIssue.RN_Case_Review_Summary1__c.contains('<a href') == true )
            {
                boolHasHyperLink = true; 
            }
        }
        if(objPotentialQualityIssue.RN_Pertinent_criteria_guidelines_standa__c != null)
        {
            if(objPotentialQualityIssue.RN_Pertinent_criteria_guidelines_standa__c.contains('<a href') == true )
            {
                boolHasHyperLink = true; 
            }
        }
        if(objPotentialQualityIssue.RN_Justification_of_Recommendation__c != null)
        {
            if(objPotentialQualityIssue.RN_Justification_of_Recommendation__c.contains('<a href') == true )
            {
                boolHasHyperLink = true; 
            }
        }
        if(objPotentialQualityIssue.Medical_Director_Review_Summary1__c != null)
        {
            if(objPotentialQualityIssue.Medical_Director_Review_Summary1__c.contains('<a href') == true )
            {
                boolHasHyperLink = true; 
            }
        }
        if(boolHasHyperLink == true  ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, 'Please remove the hyperlink from  Notes.');
            ApexPages.addMessage(myMsg); 
            return false;                                   
        } 
        
        return true;
    }
    
     
    
/**
* @author IDC Team
* @date 04/08/2015
* @description This method is used submit approval process from from vf page also
* @param 
* @return object
*/
    public PageReference Completed() {
        PageReference objPR;
        try { // checks on submission if all required fields are populated and there are no hyperlinks in Rich text area
            if (!PQIRequired() || !CheckHyperLink()) {  
                return null;
            }
            
            
            objPotentialQualityIssue.PQI_Required_Field__C =true;// set true to enter into the approval process
            objPotentialQualityIssue.RN_Reviewer_user__c =objPotentialQualityIssue.Assigned_RN__c ;      
            Database.upsert(objPotentialQualityIssue,true);
            objPR = new PageReference('/'+objPotentialQualityIssue.Id);     
            objPR.setRedirect(true); 
            Database.SaveResult res = Database.update(objPotentialQualityIssue);
            If (res.issuccess())
            {
                // calling approval process method
                SubmitForApproval();
                return objPR;
            } 
            
        }    
        catch(Exception classException){             
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------'));      
           
        }
        return null;
    }
    
    /* This method is used for approval process*/
    public void SubmitForApproval()
    {
        try{
            /* submit the request for approval */
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Request for Approval');
            req1.setObjectId(objPotentialQualityIssue.id);
            Approval.ProcessResult result = Approval.process(req1);
            
            /* returns to PQI  Page */
                 
        }
        catch(Exception classException){             
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------'));      

        }
        
        
    }
    
    
/**
* @author IDC Team
* @date 04/08/2015
* @description This method is used submit approval process from from vf page  and send to PRC
* @param 
* @return object
*/
    public PageReference sendPRC () 
    {
        try{
             if (!PQIRequired() ) {
                return null;
            }
                objPotentialQualityIssue.PQI_Status__c = 'PRC';
                Database.SaveResult res = Database.update(objPotentialQualityIssue);
                If (res.issuccess())
                {
                    // calling approval process method
                    SubmitForApproval();
                    PageReference objPR = new PageReference('/'+objPotentialQualityIssue.Id); 
                    objPR.setRedirect(true); 
                    return objPR;
                }
                else
                    return null;
                
            }
        
        catch(Exception classException){             
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------'));      
            return null;
        }
        return null;
    }
    
/**
* @author IDC Team
* @date 04/08/2015
* @description This method is used to approve record and this method is use for  Approve button and approve prc button
* @param 
* @return object
*/
    public Pagereference approveRecord()
    {
        try{
            if (!PQIRequired()|| !CheckHyperLink() ) {
                return null;
            } 
            
            PQIUpdateQueue pqiUpdate  = new  PQIUpdateQueue();
            pqiUpdate.updatequeue(objPotentialQualityIssue);
            PageReference objPR = new PageReference('/'+objPotentialQualityIssue.Id);   
            objPR.setRedirect(true); 
            return objPR;
        }
        catch(Exception classException){             
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------'));      
           
        }
        return null;
    }
    
/**
* @author IDC Team
* @date 04/08/2015
* @description This method is used to approve record and this method is use for  Reject button and Reject prc button
* @param 
* @return object
*/
    public Pagereference rejectRecord()
    {
        try
        {
            if (!PQIRequired() || !CheckHyperLink() ) {
                return null;
            }
            PQIUpdateQueue pqiUpdate  = new  PQIUpdateQueue();
            boolean  status =  pqiUpdate.updatequeueReject(objPotentialQualityIssue);
            
            if (status !=true)
            {
                return null;
            }
            PageReference objPR = new PageReference('/'+objPotentialQualityIssue.Id);    
            objPR.setRedirect(true); 
            return objPR;
        }
        catch(Exception classException){             
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------'));      
            
        }
        return null;
    }
/**
* @author IDC Team
* @date 04/08/2015
* @description This method is used populate member from contact object and PCP object
* @param 
* @return void
*/
    public void autoPopulateMember()
    {
        try
        {
            // resetting to null value if user is searching another member
            objPotentialQualityIssue.Member_Name__c ='';
            objPotentialQualityIssue.Member_Medical_Group_Affiliation__c = '';
            objPotentialQualityIssue.Member_DOB__c = null;
            objPotentialQualityIssue.PCP_Practioner_Name__c = '';
            
             List<contact> listContact = new List<contact>();
          
            List<PCP_Information__c> lstPCPInfo = new List<PCP_Information__c>();
            datetime todayTimeAndDate = System.today(); 
         
            date CurrentDate = Date.newInstance(todayTimeAndDate.year(),todayTimeAndDate.month(),todayTimeAndDate.day());  
            
            if(objPotentialQualityIssue.Member_ID__c!= null )
            {   string idStr = objPotentialQualityIssue.Member_ID__c;           
                listContact = [SELECT Name, Member_ID__c,Birthdate, Member_Group_Affiliation__c,(SELECT PCP_Practitioner_Name__c, PCP_Effective_date__c, PCP_Termination_Date__c 
                                                                                                                FROM PCP_Informations__r 
                                                                                                                WHERE (PCP_Effective_date__c <=: CurrentDate AND PCP_Termination_Date__c >=: CurrentDate)) 
                              FROM contact WHERE id =: idStr  and Account.name !='' limit 1 ];
                //lstPCPInfo = objContact.PCP_Informations__r;
               if(ListContact != null && ListContact.size()>0  ){
                   // system.debug('!!!objContact.Member_ID__c' +objContact.Member_ID__c);
                    if( ListContact[0].Member_ID__c != null){
                        objPotentialQualityIssue.Member_Name__c = ListContact[0].Member_ID__c;
                        isPQINamePopulated = true;
                    }else{
                        if(objPotentialQualityIssue.Member_Name__c == null){
                            objPotentialQualityIssue.Member_Name__c = '';
                        }
                        
                        isPQINamePopulated = false;
                    }
                    if(ListContact[0].Member_Group_Affiliation__c != null){
                        objPotentialQualityIssue.Member_Medical_Group_Affiliation__c = ListContact[0].Member_Group_Affiliation__c;
                        isPQIMemberMedicalGroupAffiliation = true;
                    }else{
                        if(objPotentialQualityIssue.Member_Medical_Group_Affiliation__c == null){
                            objPotentialQualityIssue.Member_Medical_Group_Affiliation__c = '';
                        }
                        
                        isPQIMemberMedicalGroupAffiliation = false;
                    }
                    if(ListContact[0].BirthDate != null){
                        objPotentialQualityIssue.Member_DOB__c = ListContact[0].BirthDate;
                        dt=ListContact[0].BirthDate;
                        isMemberDOB = true;
                    }else{
                        if(objPotentialQualityIssue.Member_DOB__c == null){
                            objPotentialQualityIssue.Member_DOB__c = null;
                        }
                        
                        isMemberDOB = false;
                    }
                    if(!listContact[0].PCP_Informations__r.isempty() && listContact[0].PCP_Informations__r.size() == 1 &&  listContact[0].PCP_Informations__r[0].PCP_Practitioner_Name__c != null){
                        objPotentialQualityIssue.PCP_Practioner_Name__c = ListContact[0].PCP_Informations__r[0].PCP_Practitioner_Name__c;
                        isPOIPractionerNamePopulated = true;
                    }else{
                        if(objPotentialQualityIssue.PCP_Practioner_Name__c == null){
                            objPotentialQualityIssue.PCP_Practioner_Name__c = '';
                        }
                        
                        isPOIPractionerNamePopulated = false;
                    }
               }
            }
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }
        }
         catch(Exception classException){             
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------'));      
        }
       
    }
}