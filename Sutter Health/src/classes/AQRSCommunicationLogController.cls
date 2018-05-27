public class AQRSCommunicationLogController
{
    public List<Communication_Log__c> lstCommunicationLog{get;set;}
    public Communication_Log__c tstCommlog {get;set;}
    public List<Communication_Log__c> lstPatientCommunicationLog{get;set;}
    public List<Communication_Log__c> lstPatientCommunicationLogPVP{get;set;}
    public List<Communication_Log__c> lstPatientCommunicationLogGIC{get;set;}
    public List<Task> lstReminderTask{get;set;}
    //public date reminder_Date   {get;set;} 
    public Task objTask{get;set;}
    public List<reminderTaskWrapper> lstReminderWrapper{get;set;}
    public String[] strMeasures{get;set;}
    public date strReminderDate{get;set;}
    public date strNextAppt{get;set;}
    public date strStatusDate{get;set;}
    public date strMsgSentDate{get;set;}
    public date strLetterSentDate{get;set;}
     // Patient's GIC & PVP And Patient details
    public list<AQRSPROVIDERATTRIBUTES1.PatientDetPVPData> detailpatientPVPList {get;set;}
    public list<AQRSPROVIDERATTRIBUTES1.PatientDetGICData> detailPatientGICList {get;set;}
    public PatientDetailData patientMRNDetails {get;set;}
    public String selectedMRN_ID ; 
    public String backtoHome    {get;set;}
    Integer count = 0;
    
    public PageReference incrementCounter() {
        count++;
         Set<ID> setCommLogId = new Set<ID>();
        selectedMRN_ID = ApexPages.currentPage().getParameters().get('patinet_MRNID');
        lstPatientCommunicationLog = [Select ID from Communication_Log__c where Patient_MRN__c=:selectedMRN_ID ORDER BY createddate DESC limit 50000];  
        for(communication_Log__c cl:lstPatientCommunicationLog )
        {
            setCommLogId.add(cl.Id);
        }
        String useridValue= Userinfo.getUserId();
        lstReminderTask =[Select owner.Name,ownerId,ActivityDate,CreatedBy.Name,What.Name,status,Priority from Task where OwnerId =:useridValue  and WhatId IN:setCommLogId ORDER BY createddate DESC]; // need to add cl query
        lstReminderWrapper.clear();
        for(Task t:lstReminderTask )
        {
            reminderTaskWrapper objWrapper = new reminderTaskWrapper();
            objWrapper.reminderTaskObj = t;
            objWrapper.isChecked = false;
            lstReminderWrapper.add(objWrapper);
        } 
        system.debug('@@@Refreshed Tasks@@@@'+lstReminderWrapper);
        return null;
    }
            
    public Integer getCount() {
        return count;
    }
    
    public AQRSCommunicationLogController()
    {
        detailpatientPVPList = new list<AQRSPROVIDERATTRIBUTES1.PatientDetPVPData>();
        detailPatientGICList = new list<AQRSPROVIDERATTRIBUTES1.PatientDetGICData>();
        patientMRNDetails = new PatientDetailData();
        selectedMRN_ID = ApexPages.currentPage().getParameters().get('patinet_MRNID');
        backtoHome = ApexPages.currentPage().getParameters().get('tab_active');
        system.debug('@#@!#@@#@#@'+selectedMRN_ID+'!!!!!!!'+ApexPages.currentPage().getParameters());
        getPatientdetails();
        //strReminderDate = '';
        Id userid = Userinfo.getUserId();
        strMeasures = new List<String>();
        objTask = new Task();
        Set<ID> setCommLogId = new Set<ID>();
       lstReminderWrapper  = new List<reminderTaskWrapper>();
        lstCommunicationLog = new List<Communication_Log__c>();
        lstPatientCommunicationLog = [Select ID,Name,PCP__c,Contact_Name__c,Patient_MRN__c,Patient_Moved__c,Contacted_About__c,Relationship_to_the_Patient__c,Comments_Spoke_with_Patient__c,Documentation_Note__c,Status__c,Status_Date__c,Patient_Committed_to_Measure__c,Patient_Outreach_Complete__c,MHO_MESSAGE_SENT__c,MHO_Message_Sent_Date__c,Phone_Type_I_CAL_90__c,Sent_MHO_Letter__c,Department_Care_Center__c,Letter_Sent_Date__c,Optum_Form__c,QI_confirmed__c,BMI__c,AIM_patient__c,Patient_died__c,Number_of_contacts__c,Current_year_AWV_date__c,Prior_year_AWV_date__c,Provider_ID__c,Department_ID__c,User_ID__c,EPIC_Reference__c,EPIC_Sync_Date__c,EPIC_Response_Message__c ,Measure__c,Speciality__c ,Physician_Type__c,Facility__c,Division__c,Upcoming_Visit_Provider__c,Next_Appointment_Type__c,Upcoming_visit_apt_time__c,Reason_for_Call__c,Outreach_Call__c,Dialed_Phone__c,Contact_method__c,Call_result__c,Call_time__c from Communication_Log__c where Patient_MRN__c=:selectedMRN_ID ORDER BY createddate DESC limit 50000];  
        
        lstPatientCommunicationLogPVP = [Select ID,Name,PCP__c,Contact_Name__c,Patient_MRN__c,Patient_Moved__c,Contacted_About__c,Relationship_to_the_Patient__c,Comments_Spoke_with_Patient__c,Documentation_Note__c,Status__c,Status_Date__c,Patient_Committed_to_Measure__c,Patient_Outreach_Complete__c,MHO_MESSAGE_SENT__c,MHO_Message_Sent_Date__c,Phone_Type_I_CAL_90__c,Sent_MHO_Letter__c,Department_Care_Center__c,Letter_Sent_Date__c,Optum_Form__c,QI_confirmed__c,BMI__c,AIM_patient__c,Patient_died__c,Number_of_contacts__c,Current_year_AWV_date__c,Prior_year_AWV_date__c,Provider_ID__c,Department_ID__c,User_ID__c,EPIC_Reference__c,EPIC_Sync_Date__c,EPIC_Response_Message__c ,Measure__c,Speciality__c ,Physician_Type__c,Facility__c,Division__c,Upcoming_Visit_Provider__c,Next_Appointment_Type__c,Upcoming_visit_apt_time__c,Reason_for_Call__c,Outreach_Call__c,Dialed_Phone__c,Contact_method__c,Call_result__c,Call_time__c from Communication_Log__c where Patient_MRN__c=:selectedMRN_ID and Outreach_Call__c='Pre-Visit' ORDER BY createddate DESC limit 50000];  
        lstPatientCommunicationLogGIC = [Select ID,Name,PCP__c,Contact_Name__c,Patient_MRN__c,Patient_Moved__c,Contacted_About__c,Relationship_to_the_Patient__c,Comments_Spoke_with_Patient__c,Documentation_Note__c,Status__c,Status_Date__c,Patient_Committed_to_Measure__c,Patient_Outreach_Complete__c,MHO_MESSAGE_SENT__c,MHO_Message_Sent_Date__c,Phone_Type_I_CAL_90__c,Sent_MHO_Letter__c,Department_Care_Center__c,Letter_Sent_Date__c,Optum_Form__c,QI_confirmed__c,BMI__c,AIM_patient__c,Patient_died__c,Number_of_contacts__c,Current_year_AWV_date__c,Prior_year_AWV_date__c,Provider_ID__c,Department_ID__c,User_ID__c,EPIC_Reference__c,EPIC_Sync_Date__c,EPIC_Response_Message__c ,Measure__c,Speciality__c ,Physician_Type__c,Facility__c,Division__c,Upcoming_Visit_Provider__c,Next_Appointment_Type__c,Upcoming_visit_apt_time__c,Reason_for_Call__c,Outreach_Call__c,Dialed_Phone__c,Contact_method__c,Call_result__c,Call_time__c from Communication_Log__c where Patient_MRN__c=:selectedMRN_ID and Outreach_Call__c='Gap in Care' ORDER BY createddate DESC limit 50000];
        
        for(communication_Log__c cl:lstPatientCommunicationLog )
        {
            setCommLogId.add(cl.Id);
        }
        
        lstReminderTask =[Select owner.Name,ownerId,ActivityDate,CreatedBy.Name,What.Name,status,Priority from Task where OwnerId =: userid and WhatId IN:setCommLogId ORDER BY createddate DESC]; // need to add cl query
        for(Task t:lstReminderTask )
        {
            reminderTaskWrapper objWrapper = new reminderTaskWrapper();
            objWrapper.reminderTaskObj = t;
            objWrapper.isChecked = false;
            lstReminderWrapper.add(objWrapper);
        } 
       Communication_Log__c objCommLog = new Communication_Log__c();
       lstCommunicationLog.add(objCommLog);
       system.debug('@@@2222222@@@@'+ patientMRNDetails);
        lstCommunicationLog[0].Contact_Name__c = patientMRNDetails.patient_name;
        lstCommunicationLog[0].Patient_MRN__c = patientMRNDetails.patient_mrn;
        lstCommunicationLog[0].Reason_for_Call__c = 'Health Maintenance';
        lstCommunicationLog[0].PCP__c = patientMRNDetails.ADDLN_ATTRIBUTE1;
        lstCommunicationLog[0].Speciality__c = patientMRNDetails.SPECIALTY;//'Nuero';
        lstCommunicationLog[0].Department_Care_Center__c = patientMRNDetails.Next_appointment_department_name;//'General Physician';
        //lstCommunicationLog[0].Contacted_About__c = 'Diabetes Care – HbA1c (2 Tests)';
        lstCommunicationLog[0].Foundation__c = 'SUTTER MEDICAL GROUP';
        lstCommunicationLog[0].Facility__c = 'SMF';
        lstCommunicationLog[0].Division__c = 'SPMF LAKE DIVISION';
        lstCommunicationLog[0].Upcoming_Visit_Provider__c = 'SARINGAN, GEMMA MD';
        lstCommunicationLog[0].Next_Appointment_Type__c = 'In Person';
        lstCommunicationLog[0].Encounter_Date__c = System.today();
        lstCommunicationLog[0].Status_Date__c = System.today();
        lstCommunicationLog[0].Provider_ID__c = '1234567';
        lstCommunicationLog[0].Department_ID__c = '456789';
        lstCommunicationLog[0].Upcoming_visit_apt_time__c = System.now();
        lstCommunicationLog[0].Current_year_AWV_date__c = System.today();
        lstCommunicationLog[0].Prior_year_AWV_date__c =System.today().addDays(-2);
        lstCommunicationLog[0].Epic_Patient_ID__c = '2441539';
    }
    
    // To get the selected patient from the search result set
        public pagereference getPatientdetails(){
            // Invoke the web service class and send the parameters to "GetPatientDetailsByMRN" method
            /** Mock the response for Apex functionality**/
                AQRSPROVIDERATTRIBUTES1.PatientDetGICAndPVPData patientDetailsRecieved = new AQRSPROVIDERATTRIBUTES1.PatientDetGICAndPVPData();
                AQRS_InterfaceMockData interfaceMockPVPGICDetailInfo = new AQRS_InterfaceMockData();
                patientDetailsRecieved = interfaceMockPVPGICDetailInfo.getPatientDetailDataList(selectedMRN_ID);
                system.debug('%%%%%%%'+patientMRNDetails.EMAIL_ADDRESS);
                detailPatientGICList = patientDetailsRecieved.PatientDetGIC.PatientDetGICData;
                detailpatientPVPList = patientDetailsRecieved.PatientDetPVP.PatientDetPVPData;
                //patientMRNDetails = patientDetailsRecieved.PatientInfo; 
                patientMRNDetails.EMAIL_ADDRESS = patientDetailsRecieved.PatientInfo.EMAIL_ADDRESS;
                patientMRNDetails.PATIENT_DOB = Date.valueOf(patientDetailsRecieved.PatientInfo.PATIENT_DOB);
                patientMRNDetails.PATIENT_GENDER = patientDetailsRecieved.PatientInfo.PATIENT_GENDER;
                patientMRNDetails.PATIENT_HOME_ADDRESS = patientDetailsRecieved.PatientInfo.PATIENT_HOME_ADDRESS;
                patientMRNDetails.PATIENT_HOME_PHONE = patientDetailsRecieved.PatientInfo.PATIENT_HOME_PHONE;
                patientMRNDetails.PATIENT_MRN = patientDetailsRecieved.PatientInfo.PATIENT_MRN;
                patientMRNDetails.PATIENT_NAME = patientDetailsRecieved.PatientInfo.PATIENT_NAME;
                patientMRNDetails.PATIENT_RACE = patientDetailsRecieved.PatientInfo.PATIENT_RACE;
                patientMRNDetails.PAYOR_NAME = patientDetailsRecieved.PatientInfo.PAYOR_NAME;
                patientMRNDetails.POPULATION = patientDetailsRecieved.PatientInfo.POPULATION;
                patientMRNDetails.PATIENT_AGE = patientDetailsRecieved.PatientInfo.PATIENT_AGE;
                patientMRNDetails.PREFERRED_COMMUNICATION_METHOD = patientDetailsRecieved.PatientInfo.PREFERRED_COMMUNICATION_METHOD;
                patientMRNDetails.ADDLN_ATTRIBUTE1 = patientDetailsRecieved.PatientInfo.ADDLN_ATTRIBUTE1;//Holding Provider Name
                patientMRNDetails.SPECIALTY = detailpatientPVPList[0].SPECIALTY;
                patientMRNDetails.Next_appointment_department_name = detailpatientPVPList[0].Next_appointment_department_name;
                
                integer temp = Date.valueOf(patientMRNDetails.patient_dob).daysBetween(Date.Today());
                patientMRNDetails.PATIENT_AGE = String.valueOf(temp/365);
            /** Mock the response for Apex functionality**/
            return null;
            
        }
    
    public PageReference submitCommunicationLog()
    {
    
        try
        {
            // add server side validations
            System.debug('strMeasures:::'+strMeasures+'222');
             System.debug('strDate:::'+strReminderDate+'222');
            
            lstCommunicationLog[0].Contacted_About__c = string.valueOf(strMeasures);
           lstCommunicationLog[0].Reminder_Activity_Date__c = strReminderDate;
           lstCommunicationLog[0].Next_Planned_Appointment__c= strNextAppt;
           lstCommunicationLog[0].Status_Date__c= strStatusDate;
           lstCommunicationLog[0].MHO_Message_Sent_Date__c= strMsgSentDate;
           lstCommunicationLog[0].Letter_Sent_Date__c= strLetterSentDate;
            system.debug('@@@@@@'+lstCommunicationLog[0]);
            insert lstCommunicationLog;
            
        }
        catch(Exception e)
        {
            System.debug(e);
        } 
     //   list<String> parametersList = ApexPages.currentPage().getParameters();
        PageReference myVFPage = new PageReference('/apex/tst_AQRS_Comm_Log?patinet_MRNID='+selectedMRN_ID+'&tab_active='+ApexPages.currentPage().getParameters().get('tab_active'));
        myVFPage.setRedirect(true);
        return myVFPage;
        //return null;
    }
    public List<SelectOption> getMeasures()
    {
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('','--None--'));     
       Schema.DescribeFieldResult fieldResult =
     Communication_Log__c.Measure__c.getDescribe();
       List<Schema.PicklistEntry> lstMeasure = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : lstMeasure)
       {
          options.add(new SelectOption(f.getValue(), f.getValue()));
       }       
       return options;
    }
    public PageReference submitCommunicationLogWithReminder()
    {
        lstCommunicationLog[0].Need_Reminder__c = true;
        try
        {
            System.debug('strMeasures:::'+strMeasures);
            lstCommunicationLog[0].Contacted_About__c = string.valueOf(strMeasures);
            lstCommunicationLog[0].Reminder_Activity_Date__c = strReminderDate;
           lstCommunicationLog[0].Next_Planned_Appointment__c= strNextAppt;
           lstCommunicationLog[0].Status_Date__c= strStatusDate;
           lstCommunicationLog[0].MHO_Message_Sent_Date__c= strMsgSentDate;
           lstCommunicationLog[0].Letter_Sent_Date__c= strLetterSentDate;
            system.debug('@@@@@@'+lstCommunicationLog[0]);
            insert lstCommunicationLog;
        }
        catch(Exception e)
        {
            System.debug(e);
        } 
        PageReference myVFPage = new PageReference('/apex/tst_AQRS_Comm_Log?patinet_MRNID='+selectedMRN_ID+'&tab_active='+ApexPages.currentPage().getParameters().get('tab_active'));
        myVFPage.setRedirect(true);
        return myVFPage;
    }
    public class reminderTaskWrapper
    {
        public Task reminderTaskObj{get;set;}
        public Boolean isChecked{get;set;}
        public reminderTaskWrapper()
        {
            
        }
    }
    
    public PageReference transferTask()
    {
    List<Task> lstTaskToUpdate = new List<Task>();
    
    for(reminderTaskWrapper rtw:lstReminderWrapper)
    {
        if(rtw.isChecked)
        {
            rtw.reminderTaskObj.ownerId= objTask.ownerId;
            lstTaskToUpdate.add(rtw.reminderTaskObj);
        }
    }
    update lstTaskToUpdate;
     return null;   
    }
    public class PatientDetailData {
        public String ADDLN_ATTRIBUTE1 {get;set;}
        public String ADDLN_ATTRIBUTE2;
        public String ADDLN_ATTRIBUTE3;
        public String ADDLN_ATTRIBUTE4;
        public String ADDLN_ATTRIBUTE5;
        public String EMAIL_ADDRESS {get;set;}
        public Date PATIENT_DOB {get;set;}
        public String PATIENT_GENDER {get;set;}
        public String PATIENT_HOME_ADDRESS {get;set;}
        public String PATIENT_HOME_PHONE {get;set;}
        public String PATIENT_MRN {get;set;}
        public String PATIENT_NAME {get;set;}
        public String PATIENT_RACE {get;set;}
        public String PAYOR_NAME {get;set;}
        public String POPULATION {get;set;}
        public String PATIENT_AGE   {get;set;}
        public String PREFERRED_COMMUNICATION_METHOD {get;set;}
        public String SPECIALTY {get;set;}
        public String Next_appointment_department_name {get;set;}
        public PatientDetailData(){
            
        }
    }
}