public class AQRS_Patient_SearchController
{
    //wrapper class which contains filter outputs
    public filterWrapper filterWrap{get;set;}
    public filterWrapper filterWrap1{get;set;} 
    public String loggedInUsername;
    public String toDate{get;set;}
    public String fromDate{get;set;}
    public String toDate1{get;set;}
    public String fromDate1{get;set;}
    public String strClearFields{get;set;}
    
    
    
    // Search results list
        public list<PatientSearchResultsPVP> recievedpatientPVPList {get;set;}
        public list<PatientSearchResultsGIC> recievedPatientGICList {get;set;}
   
    //maps to store each picklist field dependencies
    private Map<String,Set<String>> mapDepartmentWithProvider = new Map<String,Set<String>>();
    private Map<String,Map<String,Set<String>>> mapDivisionWithDepartment = new Map<String,Map<String,Set<String>>>();
    private Map<String,Map<String,Map<String,Set<String>>>> mapFacilityWithDivision = new Map<String,Map<String,Map<String,Set<String>>>>();
    private Map<String,Map<String,Map<String,Map<String,Set<String>>>>> mapFoundationWithFacilities = new Map<String,Map<String,Map<String,Map<String,Set<String>>>>>();
    
    
    
    
    //ShowMore Fields Functionality
    public Set<String> unSelectedNames = new Set<String>();
    public Set<String> selectedNames = new Set<String>();
        
    Public String SelString;
    Public String UnSelString;
    Public String FinalStrSel;
    Public String FinalStrUnSel;    
    Public Integer DoSel;
    Public Integer DoUnSel;
    public list<String> availableFields ;
    public list<String> selectedFields ;
    
    Public List<String> fldstoModfy;
    
    public Boolean PATIENT_MRN {get;set;}
    public Boolean PATIENT_NAME {get;set;}
    public Boolean POSSIBLE_ACTIONS_NEEDED {get;set;}
    public Boolean PREFERRED_COMMUNICATION_METHOD {get;set;}
    public Boolean PATIENT_DOB {get;set;}
    public Boolean PATIENT_GENDER {get;set;}
    public Boolean EMAIL_ADDRESS {get;set;}
    public Boolean LAST_APPOINTMENT_TYPE {get;set;}
    public Boolean NEXT_APPOINTMENT_TYPE {get;set;}
    public Boolean PATIENT_MIDDLE_NAME {get;set;}
    public Boolean PAYOR_NAME {get;set;}
    public Boolean PATIENT_HOME_ADDRESS {get;set;}
    public Boolean PATIENT_HOME_PHONE {get;set;}
    public Boolean PATIENT_RACE {get;set;}
    public Boolean PATIENT_ZIP {get;set;}    
    public ShowMoreFields__c mc ;
    //export to csv
    public string headerPVP{get;set;}
    public string headerGIC{get;set;}
    public string Filetype{get;set;}
   // public Boolean GIC{get;set;}
   // public Boolean PVP{get;set;}
    public List<UserRole> lstParentRole ;
    public boolean isextractDefPVP {get;set;}
    public boolean isextractDefGIC {get;set;}
    
    public AQRS_Patient_SearchController()
    {    
    
    
    system.debug('*****pvp/gic'+ ApexPages.currentPage().getParameters().get('extractdef'));

    
            //export to csv
        Filetype = '';
        strClearFields = '';
         headerPVP = 'Outreached,Patient Name,Patient MRN,Patient DOB,Patient Gender,Preferred Communication Method,Email Address,Patient Home Phone,Possible Actions Needed,Provider Name,Measure Name,Next Appointment Type,Payer,Race,Facility,Division,Last AWV Date,Last Appointment Date,Next Appointment Date,Address,Next Appointment Provider,Speciality,Next Department Name,Population,Department,Last Appointment Type,Next Appointment Time,Quality Gaps,HCC Gaps,AWV Gaps,Total Gaps\r\n'; 
         headerGIC = 'OutReached,Patient Name,Patient MRN,Patient DOB,Patient Gender,Preferred Communication Method,Email Address,Patient Home Phone,Possible Actions Needed,Provider Name,Measure Name,Next Appointment Type,Payer,Address,Race,Next Appointment Time,Population,Speciality,AWV Measurement,Last Billed Date,Last Appointment Date,Next Appointment Date,HCC Gaps,Total Gaps,Last AWV Date,Next Appointment Provider,Division,Department,Facility,Qualifying Measure\r\n';

        
        // Map the logged in username & instantiate the response lists
        User u = [select Id, username from User where Id = :UserInfo.getUserId()];
        loggedInUsername = u.username;
        recievedpatientPVPList = new list<PatientSearchResultsPVP>();
        recievedPatientGICList = new list<PatientSearchResultsGIC>();
        String Uname = UserInfo.getUserId();
         mc = ShowMoreFields__c.getValues(Uname);
        searchPatientPVP();
        searchPatientGIC();

        dynamicDisplayFields();   
        resetFilters();
  
    }
    
    // To search the patient PVP list based on the user's filter
        public pagereference searchPatientPVP(){
            /** Mock the response for Apex functionality**/
         /*   list<Communication_Log__c> outreached_Logs = [select id,AQRS_Reference_Id__c from Communication_Log__c limit 50000];
            AQRS_WSSchema_Details.PatientListPVPReturnData patientPVPListRecieved = new AQRS_WSSchema_Details.PatientListPVPReturnData();
            AQRS_InterfaceMockData interfaceMockPVPList = new AQRS_InterfaceMockData();
            patientPVPListRecieved = interfaceMockPVPList.getPatientPVPArray();
            for(AQRS_WSSchema_Details.PatientListForPVPData patRes : patientPVPListRecieved.PatientListForPVPData){
                PatientSearchResultsPVP patPVP = new PatientSearchResultsPVP();
                patPVP.department_ID = patRes.Department_ID;
                patPVP.patient_gender = patRes.PATIENT_GENDER;
                patPVP.epic_Patient_ID = patRes.Epic_Patient_ID;
                patPVP.facility_ID = patRes.Facility_ID;
                patPVP.foundation = patRes.Foundation;
                patPVP.foundation_ID = patRes.Foundation_ID;
                patPVP.measure_Name = patRes.Measure_Name;
                patPVP.next_Appointment_Time = patRes.Next_Appointment_Time;
                patPVP.next_appointment_department_name = patRes.Next_appointment_department_name;
                patPVP.next_appointment_provider = patRes.Next_appointment_provider;
                patPVP.patient_Race = patRes.Patient_Race;
                patPVP.patient_home_address = patRes.Patient_home_address;
                patPVP.payor_ID = patRes.Payor_ID;
                patPVP.payor_Name = patRes.Payor_Name;
                patPVP.anchor_date = patRes.anchor_date;
                patPVP.awv_gaps = patRes.awv_gaps;
                patPVP.date_of_last_appointment = patRes.date_of_last_appointment;
                patPVP.date_of_next_appointment = patRes.date_of_next_appointment;
                patPVP.department_Name = patRes.department_Name;
                patPVP.division_ID = patRes.division_ID;
                patPVP.division_name = patRes.division_name;
                patPVP.email_address = patRes.email_address;
                patPVP.facility_Name = patRes.facility_Name;
                patPVP.hcc_gaps = patRes.hcc_gaps;
                patPVP.last_appointment_type = patRes.last_appointment_type;
                patPVP.last_awv_date = patRes.last_awv_date;
                patPVP.measure_ID = patRes.measure_ID;
                patPVP.next_appointment_type = patRes.next_appointment_type;
                patPVP.patient_ID = patRes.patient_ID;
                patPVP.patient_city = patRes.patient_city;
                patPVP.patient_dob = Date.ValueOf(patRes.patient_dob);
                patPVP.patient_home_phone = patRes.patient_home_phone;
                patPVP.patient_middle_name = patRes.patient_middle_name;
                patPVP.patient_mrn = patRes.patient_mrn;
                patPVP.patient_name = patRes.patient_name;
                patPVP.patient_zip = patRes.patient_zip;
                patPVP.possible_actions_needed = patRes.possible_actions_needed;
                patPVP.preferred_communication_method = patRes.preferred_communication_method;
                patPVP.provider_ID = patRes.provider_ID;
                patPVP.quality_gaps = patRes.quality_gaps;
                patPVP.specialty = patRes.specialty;
                patPVP.ID = patRes.ID;
                patPVP.population = patRes.POPULATION;
                patPVP.outReached = 'No';
                // Compare the communication logs and identify the outreached patients
                for(Communication_Log__c commLogs : outreached_Logs){
                    if(patRes.ID == commLogs.AQRS_Reference_Id__c && patPVP.outReached == 'No'){
                        patPVP.outReached = 'Yes';
                    }
                }
                if(patPVP.hcc_gaps != null){
                patPVP.total_Gaps = patPVP.hcc_gaps;
                }
                if(patPVP.hcc_gaps != null && patPVP.awv_gaps != null){
                    patPVP.total_Gaps = String.valueOf(Integer.ValueOf(patPVP.hcc_gaps) + Integer.ValueOf(patPVP.awv_gaps));
                }
                if(patPVP.hcc_gaps != null && patPVP.awv_gaps != null && patPVP.quality_gaps!=null){
                     patPVP.total_Gaps = String.valueOf(Integer.ValueOf(patPVP.hcc_gaps) + Integer.ValueOf(patPVP.awv_gaps) + Integer.ValueOf(patPVP.quality_gaps)) ;
                } 
                recievedpatientPVPList.add(patPVP);
              }
            /** Mock the response for Apex functionality**/ 
            return null;
            
        }
        
        // To search the patient GIC list based on the user's filter
        public pagereference searchPatientGIC(){
            /** Mock the response for Apex functionality**/
            /*    list<Communication_Log__c> outreached_Logs = [select id,AQRS_Reference_Id__c from Communication_Log__c limit 50000];
                AQRS_WSSchema_Details.ArrayOfPatientListForGICData patientGICListRecieved = new AQRS_WSSchema_Details.ArrayOfPatientListForGICData();
                AQRS_InterfaceMockData interfaceMockGICList = new AQRS_InterfaceMockData();
                patientGICListRecieved = interfaceMockGICList.getPatientGICArray();
                for(AQRS_WSSchema_Details.PatientListForGICData patRes : patientGICListRecieved.PatientListForGICData){
                PatientSearchResultsGIC patGIC = new PatientSearchResultsGIC();
                    patGIC.department_ID = patRes.department_ID;
                    patGIC.patient_gender = patRes.PATIENT_GENDER;
                    patGIC.epic_Patient_ID = patRes.epic_Patient_ID;
                    patGIC.facility_ID = patRes.facility_ID;
                    patGIC.foundation = patRes.foundation;
                    patGIC.foundation_ID = patRes.foundation_ID;
                    patGIC.measure_Name = patRes.measure_Name;
                    patGIC.next_Appointment_Time = patRes.next_Appointment_Time;
                    patGIC.patient_Race = patRes.patient_Race;
                    patGIC.patient_home_address = patRes.patient_home_address;
                    patGIC.payor_ID = patRes.payor_ID;
                    patGIC.payor_Name = patRes.payor_Name;
                    patGIC.anchor_date = patRes.anchor_date;
                    patGIC.awv_measurement_this_year = patRes.awv_measurement_this_year;
                    patGIC.date_of_last_appointment = patRes.date_of_last_appointment;
                    patGIC.date_of_last_billed = patRes.date_of_last_billed;
                    patGIC.date_of_next_appointment = patRes.date_of_next_appointment;
                    patGIC.department_Name = patRes.department_Name;
                    patGIC.division_ID = patRes.division_ID;
                    patGIC.division_name = patRes.division_name;
                    patGIC.facility_Name = patRes.facility_Name;
                    patGIC.hcc = patRes.hcc;
                    patGIC.last_awv_date = patRes.last_awv_date;
                    patGIC.measure_ID = patRes.measure_ID;
                    patGIC.next_appointment_provider = patRes.next_appointment_provider;
                    patGIC.next_appointment_type = patRes.next_appointment_type;
                    patGIC.patient_ID = patRes.patient_ID;
                    patGIC.patient_address_line_1 = patRes.patient_address_line_1;
                    patGIC.patient_address_line_2 = patRes.patient_address_line_2;
                    patGIC.patient_dob = Date.ValueOf(patRes.patient_dob);
                    patGIC.patient_gender = patRes.patient_gender;
                    patGIC.patient_home_phone = patRes.patient_home_phone;
                    patGIC.patient_mrn = patRes.patient_mrn;
                    patGIC.patient_name = patRes.patient_name;
                    patGIC.possible_actions_needed = patRes.possible_actions_needed;
                    patGIC.preferred_communication_method = patRes.preferred_communication_method;
                    patGIC.provider_ID = patRes.provider_ID;
                    patGIC.qualifying_measure = patRes.qualifying_measure;
                    patGIC.specialty = patRes.specialty;
                    patGIC.ID = patRes.ID;
                    patGIC.population = patRes.POPULATION;
                    patGIC.email_Address = patRes.EMAIL_ADDRESS;
                    patGIC.outReached = 'No';
                    // Compare the communication logs and identify the outreached patients
                for(Communication_Log__c commLogs : outreached_Logs){
                    if(patRes.ID == commLogs.AQRS_Reference_Id__c && patGIC.outReached == 'No'){
                        patGIC.outReached = 'Yes';      
                    }
                }
                if(patGIC.hcc != null)
                patGIC.total_Gaps = patGIC.hcc;
                recievedPatientGICList.add(patGIC);
              }
            /** Mock the response for Apex functionality**/
            
            return null;
            
        }
        
        
        
    public void dynamicDisplayFields()
    {
    // ShowMore Fields Functionality
    fldstoModfy = new List<String>();
    
            PATIENT_MRN = false;
            PATIENT_NAME = false;
            POSSIBLE_ACTIONS_NEEDED = false;
            PREFERRED_COMMUNICATION_METHOD = false;
            PATIENT_DOB = false;
            PATIENT_GENDER = false;
            EMAIL_ADDRESS = false;
            LAST_APPOINTMENT_TYPE = false;
            NEXT_APPOINTMENT_TYPE = false;
            PATIENT_MIDDLE_NAME = false;
            PAYOR_NAME = false;
            PATIENT_HOME_ADDRESS = false;
            PATIENT_HOME_PHONE = false;
            PATIENT_RACE = false;
            PATIENT_ZIP = false;
            system.debug('c');
            if(FinalStrSel != '' && FinalStrSel !=null)
            {
               List<String> lstFinalSelected = FinalStrSel.split(','); 
               for(String s:lstFinalSelected)
               {
                   selectedNames.add(s);
               }
               system.debug('d');
            }
            else
            {
            fetchDisplayFields();
            system.debug('e');
            }
            
           
            
           // selectedNames
            for(String sa: selectedNames)
            {
                fldstoModfy.add(sa.replaceAll(' ', '_'));
            
            }
             system.debug('f');         
            system.debug('@@Saved_SelectedValues@@@'+fldstoModfy);
            for(String qa: fldstoModfy )
            {
            
                if(qa.touppercase().contains('PATIENT_MRN')){
                    PATIENT_MRN = true;
                }else if(qa.touppercase().contains('PATIENT_NAME')){
                    PATIENT_NAME = true;
                }else if(qa.touppercase().contains('PATIENT_DOB')){
                    PATIENT_DOB = true;
                }else if(qa.touppercase().contains('GENDER')){
                    PATIENT_GENDER = true;                
                }else if(qa.touppercase().contains('PREFERRED_COMMUNICATION_METHOD')){
                    PREFERRED_COMMUNICATION_METHOD = true; 
                }else if(qa.touppercase().contains('EMAIL_ADDRESS')){
                    EMAIL_ADDRESS = true; 
                }else if(qa.touppercase().contains('Possible_Actions')){
                    POSSIBLE_ACTIONS_NEEDED = true; 
                }else if(qa.touppercase().contains('last_appt_type')){
                    LAST_APPOINTMENT_TYPE = true;         
                }else if(qa.touppercase().contains('NEXT_APPOINTMENT_TYPE')){
                    NEXT_APPOINTMENT_TYPE = true;         
                }else if(qa.touppercase().contains('PATIENT_MIDDLE_NAME')){
                    PATIENT_MIDDLE_NAME = true;         
                }else if(qa.touppercase().contains('Payor')){
                    PAYOR_NAME = true;         
                }else if(qa.touppercase().contains('Address')){
                    PATIENT_HOME_ADDRESS = true;         
                }else if(qa.touppercase().contains('Race')){
                    PATIENT_RACE = true;         
                }else if(qa.touppercase().contains('PATIENT_ZIP')){
                    PATIENT_ZIP = true;         
                }else if(qa.touppercase().contains('PATIENT_HOME_PHONE')){
                    PATIENT_HOME_PHONE = true;         
                }            
            }
            system.debug('g');     
        
    }
    
     public void fetchDisplayFields()
     {
         unSelectedNames = new Set<String>();
        selectedNames = new Set<String>();
        
            selected = new List<String>();
            unselected = new List<String>();
            System.debug('unSelectedNames::'+unSelectedNames+'selectedNames:::'+selectedNames);
            if(mc.UnSeletedFields__c!='' && mc.UnSeletedFields__c!=null)
            for(String la : mc.UnSeletedFields__c.split(','))      
            unSelectedNames.add(la);
            if(mc.SelectedFields__c!='' && mc.SelectedFields__c!=null)
            for(String la1 : mc.SelectedFields__c.split(','))      
            selectedNames.add(la1);
             System.debug('unSelectedNames:1111:'+unSelectedNames+'selectedNames:::'+selectedNames);
             
     }  
     
    //method to fetch picklist values for facility and display the same in search filter
    public List<SelectOption> getFacilities() 
    {
        List<Selectoption> lstOpts = new List<SelectOption>();
        //lstOpts.add(new SelectOption('','--None--')); 
        if(mapFoundationWithFacilities.containskey(filterWrap.foundation))
        {
            for ( String s : mapFoundationWithFacilities.get(filterWrap.foundation).keySet())
            lstOpts.add(new SelectOption(s, s));
            
        }          
        return lstOpts;
    }
    
    
   
   //method to fetch picklist values for divisions and display the same in search filter 
    public List<SelectOption> getDivisions() 
    {    
            system.debug('&&Division&&'+filterWrap.lstFacilities);
        List<Selectoption> lstOpts = new List<SelectOption>();
        //lstOpts.add(new SelectOption('','--None--'));         
               
        if ( filterWrap.lstFacilities!= null && filterWrap.lstFacilities.size() > 0  ) 
        {
                Set<String> possibleOpts = new Set<String>();
                for ( String val : filterWrap.lstFacilities)
                    possibleOpts.addAll(mapFacilityWithDivision.get(val).keySet());
                for ( String s : possibleOpts )
                {
                    lstOpts.add(new SelectOption(s, s));
                    
                } 
        }        
        return lstOpts;
    }
    
     
   
   //method to fetch picklist values for department and display the same in search filter  
    public List<SelectOption> getDepartment() 
    {
        system.debug('&&Department&&');
        List<Selectoption> lstOpts = new List<SelectOption>();
        //lstOpts.add(new SelectOption('','--None--'));       
        
       
        if ( filterWrap.lstDivision!= null && filterWrap.lstDivision.size() > 0) 
        {
                Set<String> possibleOpts = new Set<String>();
                System.debug('::::'+mapDivisionWithDepartment);
                for ( String val : filterWrap.lstDivision)            
                    possibleOpts.addAll(mapDivisionWithDepartment.get(val).keySet());
                for ( String s : possibleOpts )
                {
                    lstOpts.add(new SelectOption(s, s));                    
                }
                
            
        }        
        return lstOpts;
    }
    
     
    
    //method to fetch picklist values for providers and display the same in search filter 
    public List<SelectOption> getProvider() 
    {
        
        List<Selectoption> lstOpts = new List<SelectOption>();
        //lstOpts.add(new SelectOption('','--None--'));
        if ( filterWrap.lstDepartment!= null && filterWrap.lstDepartment.size() > 0 ) 
        {
                Set<String> possibleOpts = new Set<String>();
                for ( String val : filterWrap.lstDepartment)
                    possibleOpts.addAll(mapDepartmentWithProvider.get(val));
                for ( String s : possibleOpts )
                    lstOpts.add(new SelectOption(s, s));
            
        }
        return lstOpts;
    }
    
     
    
    public PageReference actionUpdatePicklistVals() {  
   System.debug('fac:::'+filterWrap.lstFacilities);
    if(strClearFields == 'facility')
    {
        filterWrap.lstDepartment = new List<String>();
        filterWrap.lstDivision = new List<String>();
        filterWrap.lstProvider = new List<String>();
    }  
    if(strClearFields == 'division')
    {
        filterWrap.lstProvider = new List<String>();
        filterWrap.lstDepartment = new List<String>();
    }    
        return null;
    }
    
    public PageReference actionUpdatePicklistValsGIC() {        
        return null;
    }
    
    public List<SelectOption> getMeasures()
    {
      List<SelectOption> options = new List<SelectOption>();
       //options.add(new SelectOption('','--None--'));     
       Schema.DescribeFieldResult fieldResult =
     AQRS_Provider_Attributes__c.Measure__c.getDescribe();
       List<Schema.PicklistEntry> lstMeasure = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : lstMeasure)
       {
          options.add(new SelectOption(f.getLabel().toUpperCase(), f.getValue().toUpperCase()));
       }       
       return options;
    }

    public List<SelectOption> getPopulation()
    {
      List<SelectOption> options = new List<SelectOption>();
       //options.add(new SelectOption('','--None--'));      
       Schema.DescribeFieldResult fieldResult =
     AQRS_Provider_Attributes__c.Population__c.getDescribe();
       List<Schema.PicklistEntry> lstPopulation = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : lstPopulation)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }
    
    // ShowMore Fields Functionality--Create the select options for the two select lists on the page
    public List<SelectOption> getSelectedOptions() { 
        return selectOptionsFromSet(selectedNames);
    }
    public List<SelectOption> getUnSelectedOptions() { 
        return selectOptionsFromSet(unSelectedNames);
    }
    
    
    
    private List<SelectOption> selectOptionsFromSet(Set<String> opts) {
        Set<String> optionsList = new Set<String>(opts);
       // optionsList.sort();
        List<SelectOption> options = new List<SelectOption>();
        for (String s : optionsList) {
            options.add(new 
                SelectOption(s,s));
        }
        return options;
    }


    public transient List<String> selected   { get; set; }
    public transient List<String> unselected { get; set; }

    public void DoSelect() {
        DoSel = 1;
        DoUnSel = 0;
        moveFields(selected, selectedNames, unSelectedNames);
    }
    public void DoUnselect() {
        DoUnSel = 1;
        DoSel = 0;
        moveFields(unselected, unSelectedNames, selectedNames);
    }
            
    private void moveFields(List<String> items, Set<String> moveTo, Set<String> removeFrom)
    {
        system.debug('%%%%%%'+unSelectedNames+'^^^^'+selectedNames+'&&&'+unselected);
        System.debug('After moveFields ???items:111111:' + items);
        SelString = '';
        UnSelString = '';
        
        for (String s: items) 
        {
            moveTo.add(s);
            
            removeFrom.remove(s);
        }
        
        
        
        if(DoSel == 1)
        {
            System.debug('After moveFields ???MoveTo:111111:' + moveTo);
            for(String s1 : moveTo) 
            {       
                    SelString += s1+',';
             System.debug('Inside For LoopSelString... ' + SelString);       
            }            
            FinalStrSel = SelString.removeEnd(',');
            System.debug('FinalStrSelected?????' + FinalStrSel);       
        
            System.debug('After moveFields ???removeFrom:33333:' + removeFrom); 
            for(String s2 : removeFrom) 
            {
                UnSelString += s2+',';
                System.debug('Inside For Loop UnSelString' + UnSelString);       
            }            
            FinalStrUnSel = UnSelString.removeEnd(',');
            System.debug('FinalStrUnSelected!!!!!' + FinalStrUnSel);       
         }
        
        if(DoUnSel == 1)
        {
            System.debug('After moveFields ???MoveTo:111111:' + removeFrom);
            for(String s1 : removeFrom) 
            {            
                    SelString += s1+',';
             System.debug('Inside For LoopSelString... ' + SelString);       
            }            
            FinalStrSel = SelString.removeEnd(',');
            System.debug('FinalStrSelected?????' + FinalStrSel);       
        
            System.debug('After moveFields ???removeFrom:33333:' + moveTo); 
            for(String s2 : moveTo) 
            {
                UnSelString += s2+',';
                System.debug('Inside For Loop UnSelString' + UnSelString);       
            }            
            FinalStrUnSel = UnSelString.removeEnd(',');
            System.debug('FinalStrUnSelected!!!!!' + FinalStrUnSel);       
         } 
         system.debug('Final Selected Values****' + FinalStrSel);
            system.debug('Final Unselected Values****' + FinalStrUnSel);
    }
    
    public void setDisplayFields() 
    {      
         if(FinalStrSel != '' || FinalStrUnSel != ''){
           // String Uname1 = UserInfo.getUserId();        
           // ShowMoreFields__c mc1 = ShowMoreFields__c.getValues(Uname1);
system.debug('a');
            mc.UnSeletedFields__c = FinalStrUnSel;
            
            mc.SelectedFields__c = FinalStrSel;  
            
            update mc;          
         
             system.debug('Final Selected Values&&&&&&&' + FinalStrSel);
            system.debug('Final Unselected Values@@@@@@@@' + FinalStrUnSel);
         }
         //dynamicDisplayFields();   
system.debug('b');
            DoSel = 0;
            DoUnSel = 0;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter value'));


    }
    
    public PageReference cancelMoreFields() {
        PageReference page = new PageReference('/apex/AQRSCRMLandingPage?sfdc.tabName=01r0v0000000JcV');
        page.setRedirect(true);
        return page;
    }
    
      
    public class filterWrapper
    {
        public String foundation{get;set;}
        public String[] lstFacilities{get;set;}
        public String[] lstDivision{get;set;}
        public String[] lstDepartment{get;set;}
        public String[] lstProvider{get;set;}
        public String[] lstMeasure{get;set;}
        public String[] lstPopulation{get;set;}
        public String patientName {get;set;}
        public String patientMRN {get;set;}
        public filterWrapper()
        {
            lstFacilities = new List<String>();
            lstDivision = new List<String>();
            lstDepartment = new List<String>();
            lstProvider = new List<String>();
             lstMeasure = new List<String>();
              lstPopulation = new List<String>();
              patientName = '';
              patientMRN = '';
        }
    }
    // To hold the response list from AQRS
    public class PatientSearchResultsPVP {
            public String department_ID  {get;set;}
            public String epic_Patient_ID  {get;set;}
            public String facility_ID  {get;set;}
            public String foundation  {get;set;}
            public String foundation_ID  {get;set;}
            public String measure_Name  {get;set;}
            public String next_Appointment_Time  {get;set;}
            public String next_appointment_department_name  {get;set;}
            public String next_appointment_provider  {get;set;}
            public String patient_Race  {get;set;}
            public String patient_home_address  {get;set;}
            public String payor_ID  {get;set;}
            public String payor_Name  {get;set;}
            public String anchor_date  {get;set;}
            public String awv_gaps  {get;set;}
            public String date_of_last_appointment  {get;set;}
            public String date_of_next_appointment  {get;set;}
            public String department_Name  {get;set;}
            public String division_ID  {get;set;}
            public String division_name  {get;set;}
            public String email_address  {get;set;}
            public String facility_Name  {get;set;}
            public String hcc_gaps  {get;set;}
            public String last_appointment_type  {get;set;}
            public String last_awv_date  {get;set;}
            public String measure_ID  {get;set;}
            public String next_appointment_type  {get;set;}
            public String patient_ID  {get;set;}
            public String patient_city  {get;set;}
            public Date patient_dob  {get;set;}
            public String patient_home_phone  {get;set;}
            public String patient_middle_name  {get;set;}
            public String patient_mrn  {get;set;}
            public String patient_name {get;set;}
            public String patient_gender    {get;set;}
            public String patient_zip  {get;set;}
            public String possible_actions_needed  {get;set;}
            public String preferred_communication_method  {get;set;}
            public String provider_ID  {get;set;}
            public String quality_gaps  {get;set;}
            public String specialty  {get;set;}
            public String outReached  {get;set;}
            public String ID  {get;set;}
            public String total_Gaps {get;set;}
            public String population    {get;set;}
            public PatientSearchResultsPVP(){
            
            }
        }
      
        
        public class PatientSearchResultsGIC{
            public String department_ID  {get;set;}
            public String epic_Patient_ID  {get;set;}
            public String facility_ID  {get;set;}
            public String foundation  {get;set;}
            public String foundation_ID  {get;set;}
            public String measure_Name  {get;set;}
            public String next_Appointment_Time  {get;set;}
            public String patient_Race  {get;set;}
            public String patient_home_address  {get;set;}
            public String payor_ID  {get;set;}
            public String payor_Name  {get;set;}
            public String anchor_date  {get;set;}
            public String awv_measurement_this_year  {get;set;}
            public String date_of_last_appointment  {get;set;}
            public String date_of_last_billed  {get;set;}
            public String date_of_next_appointment  {get;set;}
            public String department_Name  {get;set;}
            public String division_ID  {get;set;}
            public String division_name  {get;set;}
            public String facility_Name  {get;set;}
            public String hcc  {get;set;}
            public String last_awv_date  {get;set;}
            public String measure_ID  {get;set;}
            public String next_appointment_provider  {get;set;}
            public String next_appointment_type  {get;set;}
            public String patient_ID  {get;set;}
            public String patient_address_line_1  {get;set;}
            public String patient_address_line_2  {get;set;} 
            public Date patient_dob  {get;set;}
            public String patient_gender  {get;set;}
            public String patient_home_phone  {get;set;}
            public String patient_mrn  {get;set;}
            public String patient_name  {get;set;}
            public String possible_actions_needed  {get;set;}
            public String preferred_communication_method  {get;set;}
            public String provider_ID  {get;set;}
            public String qualifying_measure  {get;set;}
            public String specialty  {get;set;}
            public String ID  {get;set;}
            public String outReached  {get;set;}
            public String email_Address {get;set;}
            public String population    {get;set;}
            public String total_Gaps    {get;set;}
            
            public PatientSearchResultsGIC(){
                
            }
        }
        
        public void resetFilters(){
        filterWrap1 = new filterWrapper();
        filterWrap = new filterWrapper();
        filterWrap.lstFacilities = new List<String>();
        filterWrap.lstDivision = new List<String>();
        filterWrap.lstDepartment =new List<String>();
        filterWrap.lstProvider = new List<String>();
         filterWrap.lstMeasure = new List<String>();
          filterWrap.lstPopulation = new List<String>(); 
        
        
       
        
            List<UserRole> lstUserRole = [Select ParentRoleId from UserRole where id =: UserInfo.getUserRoleId() limit 1];
            if(!lstUserRole.isEmpty())
            {
                lstParentRole = [Select Name,Id from UserRole where id=:lstUserROle[0].ParentRoleId limit 1];
                if(!lstParentRole.isEmpty())
                {                
                    filterWrap.foundation = lstParentRole[0].Name;                
                    filterWrap1.foundation = lstParentRole[0].Name;
                    List<AQRS_Provider_Attributes__c> lstProviders = [Select Foundation_Name__c,Facility_Name__c,Division_Name__c,Department_Name__c,Provider_Name__c from AQRS_Provider_Attributes__c where Foundation_Name__c=: lstParentRole[0].Name ];
                    for(AQRS_Provider_Attributes__c apa: lstProviders)
                    {
                        Set<String> setDeptProvider = new Set<String>();
                        Map<String,Set<String>> mapDepartment = new Map<String,Set<String>>();
                        Map<String,Map<String,Set<String>>> mapDivision = new Map<String,Map<String,Set<String>>>();
                        Map<String,Map<String,Map<String,Set<String>>>> mapFacility = new Map<String,Map<String,Map<String,Set<String>>>>();
                        if(mapFoundationWithFacilities.containsKey(apa.Foundation_Name__c))
                        {
                           mapFacility = mapFoundationWithFacilities.get(apa.Foundation_Name__c);
                           if(mapFacilityWithDivision.containsKey(apa.Facility_Name__c))
                           {
                               mapDivision = mapFacilityWithDivision.get(apa.Facility_Name__c);
                               if(mapDivisionWithDepartment.containsKey(apa.Division_Name__c))
                               {
                                   mapDepartment = mapDivisionWithDepartment.get(apa.Division_Name__c);
                                   if(mapDepartmentWithProvider.containsKey(apa.Department_Name__c))
                                       setDeptProvider = mapDepartmentWithProvider.get(apa.Department_Name__c);
                               }
                           }
                       }
                       setDeptProvider.add(apa.Provider_Name__c);
                   mapDepartment.put(apa.Department_Name__c,setDeptProvider);
                   mapDepartmentWithProvider.putall(mapDepartment);
                   mapDivision.put(apa.Division_Name__c,mapDepartment);
                   mapDivisionWithDepartment.putall(mapDivision);
                   mapFacility.put(apa.Facility_Name__c,mapDivision);
                   mapFacilityWithDivision.putall(mapFacility);
                   mapFoundationWithFacilities.put(apa.Foundation_Name__c,mapFacility);
                   
                   
                    }
                                    
                }
            } 
        }
        
         public PageReference createCSV(){
                
         PageReference pr = new PageReference('/apex/testCsvGICExport');
     
         return pr;   
         }
          public PageReference createCSVPVP(){
         
              
         PageReference pvpr = new PageReference('/apex/testCSVPreVisit');
        
         return pvpr;
         }
         
         public void refreshFilters(){
             //filterWrap1 = new filterWrapper();
             filterWrap1.lstMeasure = new list<String>();
             filterWrap1.lstPopulation = new list<String>();
             filterWrap1.patientName = '';
             filterWrap1.patientMRN = '';
             filterWrap.lstMeasure = new list<String>();
             filterWrap.lstPopulation = new list<String>();
             filterWrap.patientName = '';
             filterWrap.patientMRN = '';
                    // filterWrap = new filterWrapper();
         }
}