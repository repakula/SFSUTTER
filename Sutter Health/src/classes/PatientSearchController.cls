public class PatientSearchController {

// load the filter values in the vf page        
     
 // Hold the selected filter values    
        public String dept_ID {get;set;}
        public String dept_Name {get;set;}
        public String division_ID {get;set;}
        public String division_Name {get;set;}
        public String end_Date {get;set;}
        public String facility_ID {get;set;}
        public String facility_name {get;set;}
        public String foundation_ID {get;set;}
        public String foundation_Name {get;set;}
        public String measure_Name {get;set;}
        public String patient_MRN {get;set;}
        public String patient_Name {get;set;}
        public String payer {get;set;}
        public String population {get;set;}
        public String preferred_COMM_METHOD {get;set;}
        public String prov_ID {get;set;}
        public String provider_Name {get;set;}
        public String start_Date {get;set;}
        public String specialty {get;set;}
       // public PatientSearchGICPVPInputData patientSearchFilterQuery {get;set;}
        
        public String loggedInUsername;
        // Search results list
        public list<PatientSearchResultsPVP> recievedpatientPVPList {get;set;}
        public list<PatientSearchResultsGIC> recievedPatientGICList {get;set;}
        // Patient's GIC & PVP And Patient details
        public list<AQRS_WSSchema_Details.PatientDetPVPData> detailpatientPVPList {get;set;}
        public list<AQRS_WSSchema_Details.PatientDetGICData> detailPatientGICList {get;set;}
        public AQRS_WSSchema_Details.PatientInfoData patientMRNDetails {get;set;}
        public PatientSearchController(){
            //Get the logged in user's Username 
            User u = [select Id, username from User where Id = :UserInfo.getUserId()];
            loggedInUsername = u.username;
            recievedpatientPVPList = new list<PatientSearchResultsPVP>();
            recievedPatientGICList = new list<PatientSearchResultsGIC>();
            detailpatientPVPList = new list<AQRS_WSSchema_Details.PatientDetPVPData>();
            detailPatientGICList = new list<AQRS_WSSchema_Details.PatientDetGICData>();
            patientMRNDetails = new AQRS_WSSchema_Details.PatientInfoData();
        }
        // To search the patient PVP list based on the user's filter
        public pagereference searchPatientPVP(){
           /* Actual Searrch Function 
            PatientSearchGICPVPInputData  filterInputValues = new PatientSearchGICPVPInputData();
            filterInputValues.Dept_ID = dept_ID;
            filterInputValues.Dept_Name = dept_Name;
            filterInputValues.Division_ID = division_ID;
            filterInputValues.Division_Name = division_Name;
            filterInputValues.END_DATE = end_Date;
            filterInputValues.Facility_ID = facility_ID;
            filterInputValues.Facility_name = facility_name;
            filterInputValues.Foundation_ID = foundation_ID;
            filterInputValues.Foundation_Name = foundation_Name;
            filterInputValues.MEASURE_NAME = measure_Name;
            filterInputValues.PATIENT_MRN = patient_MRN;
            filterInputValues.PATIENT_NAME = patient_Name;
            filterInputValues.PAYER = payer;
            filterInputValues.POPULATION = population;
            filterInputValues.PREFERRED_COMM_METHOD = preferred_COMM_METHOD;
            filterInputValues.PROV_ID = prov_ID;
            filterInputValues.Provider_Name = provider_Name;
            filterInputValues.START_DATE = start_Date;
            filterInputValues.Specialty = specialty;
            
            // Query the communication logs to compare and identify the outreached patients
           /* list<Communication_Log__c> outreached_Logs = [select id,AQRS_Reference_Id__c from Communication_Log__c limit 50000];
            
            // Invoke the web service class and send the parameters to "GetPatientListByPVP" method
            ProviderAttributes.BasicHttpBinding_ISutterService  getPVPList = new ProviderAttributes.BasicHttpBinding_ISutterService ();
            try{
                AQRS_WSSchema_Details.ArrayOfPatientListForPVPData patientPVPListRecieved = new AQRS_WSSchema_Details.ArrayOfPatientListForPVPData();
                patientPVPListRecieved  = getPVPList.GetPatientListByPVP(filterInputValues,loggedInUsername);
                // Copy the response in to the list - rendered on to VF page table
                for(AQRS_WSSchema_Details.PatientListForPVPData patRes : patientPVPListRecieved.PatientListForPVPData){
                PatientSearchResultsPVP patPVP = new PatientSearchResultsPVP();
                patPVP.department_ID = patRes.Department_ID;
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
                patPVP.patient_dob = patRes.patient_dob;
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
                patPVP.outReached = 'No';
                for(Communication_Log__c commLogs : outreached_Logs){
                    if(patRes.ID == commLogs.AQRS_Reference_Id__c && patPVP.outReached == 'No'){
                        patPVP.outReached = 'Yes';
                    }
                }
                recievedpatientPVPList.add(patPVP);
              }
                
            } catch (System.CalloutException e){
                 System.debug('ERROR:' + e);
                 ApexPages.addMessages(e); 
            } 
            
            /** Mock the response for Apex functionality**/
           /* list<Communication_Log__c> outreached_Logs = [select id,AQRS_Reference_Id__c from Communication_Log__c limit 50000];
            AQRS_WSSchema_Details.ArrayOfPatientListForPVPData patientPVPListRecieved = new AQRS_WSSchema_Details.ArrayOfPatientListForPVPData();
            AQRS_InterfaceMockData interfaceMockPVPList = new AQRS_InterfaceMockData();
            patientPVPListRecieved = interfaceMockPVPList.getPatientPVPArray();
            for(AQRS_WSSchema_Details.PatientListForPVPData patRes : patientPVPListRecieved.PatientListForPVPData){
                PatientSearchResultsPVP patPVP = new PatientSearchResultsPVP();
                patPVP.department_ID = patRes.Department_ID;
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
                patPVP.patient_dob = patRes.patient_dob;
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
                patPVP.outReached = 'No';
                for(Communication_Log__c commLogs : outreached_Logs){
                    if(patRes.ID == commLogs.AQRS_Reference_Id__c && patPVP.outReached == 'No'){
                        patPVP.outReached = 'Yes';
                    }
                }
                recievedpatientPVPList.add(patPVP);
              } 
            /** Mock the response for Apex functionality**/
            return null;
            
        }
        // To search the patient GIC list based on the user's filter
        public pagereference searchPatientGIC(){
            AQRS_WSSchema_Details.PatientListGICPVPInputData filterInputValues = new AQRS_WSSchema_Details.PatientListGICPVPInputData();
            filterInputValues.Dept_ID = dept_ID;
            filterInputValues.Dept_Name = dept_Name;
            filterInputValues.Division_ID = division_ID;
            filterInputValues.Division_Name = division_Name;
            filterInputValues.END_DATE = end_Date;
            filterInputValues.Facility_ID = facility_ID;
            filterInputValues.Facility_name = facility_name;
            filterInputValues.Foundation_ID = foundation_ID;
            filterInputValues.Foundation_Name = foundation_Name;
            filterInputValues.MEASURE_NAME = measure_Name;
            filterInputValues.PATIENT_MRN = patient_MRN;
            filterInputValues.PATIENT_NAME = patient_Name;
            filterInputValues.PAYER = payer;
            filterInputValues.POPULATION = population;
            filterInputValues.PREFERRED_COMM_METHOD = preferred_COMM_METHOD;
            filterInputValues.PROVIDER_ID = prov_ID;
            filterInputValues.Provider_Name = provider_Name;
            filterInputValues.START_DATE = start_Date;
            filterInputValues.Specialty = specialty;
            /** Actual method for runtime Web services**/
          /*  // Invoke the web service class and send the parameters to "GetPatientListByGIC" method
            ProviderAttributes.BasicHttpBinding_ISutterService  getGICList = new ProviderAttributes.BasicHttpBinding_ISutterService ();
            AQRS_WSSchema_Details.ArrayOfPatientListForGICData patientGICListRecieved = new AQRS_WSSchema_Details.ArrayOfPatientListForGICData();
            
            // Copy the response in to the list - rendered on to VF page table
            list<Communication_Log__c> outreached_Logs = [select id,AQRS_Reference_Id__c from Communication_Log__c limit 50000];
            try{
                patientGICListRecieved  = getGICList.GetPatientListByGIC(filterInputValues,loggedInUsername);
                for(AQRS_WSSchema_Details.PatientListForGICData patRes : patientGICListRecieved.PatientListForGICData){
                PatientSearchResultsGIC patGIC = new PatientSearchResultsGIC();
                    patGIC.department_ID = patRes.department_ID;
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
                    patGIC.patient_dob = patRes.patient_dob;
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
                    patGIC.outReached = 'No';
                for(Communication_Log__c commLogs : outreached_Logs){
                    if(patRes.ID == commLogs.AQRS_Reference_Id__c && patGIC.outReached == 'No'){
                        patGIC.outReached = 'Yes';      
                    }
                }
                recievedPatientGICList.add(patGIC);
              }
            }catch (System.CalloutException e){
                 System.debug('ERROR:' + e);
                 ApexPages.addMessages(e); 
            } */
            /** Actual method for runtime Web services**/
            
            /** Mock the response for Apex functionality**/
             /*   list<Communication_Log__c> outreached_Logs = [select id,AQRS_Reference_Id__c from Communication_Log__c limit 50000];
                AQRS_WSSchema_Details.ArrayOfPatientListForGICData patientGICListRecieved = new AQRS_WSSchema_Details.ArrayOfPatientListForGICData();
                AQRS_InterfaceMockData interfaceMockGICList = new AQRS_InterfaceMockData();
                patientGICListRecieved = interfaceMockGICList.getPatientGICArray();
                for(AQRS_WSSchema_Details.PatientListForGICData patRes : patientGICListRecieved.PatientListForGICData){
                PatientSearchResultsGIC patGIC = new PatientSearchResultsGIC();
                    patGIC.department_ID = patRes.department_ID;
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
                    patGIC.patient_dob = patRes.patient_dob;
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
                    patGIC.outReached = 'No';
                for(Communication_Log__c commLogs : outreached_Logs){
                    if(patRes.ID == commLogs.AQRS_Reference_Id__c && patGIC.outReached == 'No'){
                        patGIC.outReached = 'Yes';      
                    }
                }
                recievedPatientGICList.add(patGIC);
              }
            /** Mock the response for Apex functionality**/
            //recievedPatientGICList = patientGICListRecieved.PatientListForGICData;
            return null;
            
        }
        // To get the selected patient from the search result set
        public pagereference getPatientdetails(){
            // Invoke the web service class and send the parameters to "GetPatientDetailsByMRN" method
            /** Actual Method for runtime Apex webservice functionality**/
        /*  ProviderAttributes.BasicHttpBinding_ISutterService  getGICList = new ProviderAttributes.BasicHttpBinding_ISutterService ();
            AQRS_WSSchema_Details.PatientDetGICAndPVPData patientDetailsRecieved = new AQRS_WSSchema_Details.PatientDetGICAndPVPData();
            try{
                patientDetailsRecieved  = getGICList.GetPatientDetailsByMRN(patient_MRN,loggedInUsername);
                // Copy the response in to the list - rendered on to VF page table
                detailPatientGICList = patientDetailsRecieved.PatientDetGIC.PatientDetGICData;
                detailpatientPVPList = patientDetailsRecieved.PatientDetPVP.PatientDetPVPData;
                patientMRNDetails = patientDetailsRecieved.PatientInfo; 
            }catch (System.CalloutException e){
                 System.debug('ERROR:' + e);
                 ApexPages.addMessages(e); 
            } */
            /** Actual Method for runtime Apex webservice functionality**/
            /** Mock the response for Apex functionality**/
           /*     AQRS_WSSchema_Details.PatientDetGICAndPVPData patientDetailsRecieved = new AQRS_WSSchema_Details.PatientDetGICAndPVPData();
                AQRS_InterfaceMockData interfaceMockPVPGICDetailInfo = new AQRS_InterfaceMockData();
                patientDetailsRecieved = interfaceMockPVPGICDetailInfo.getPatientDetailDataList('MRN 123-638');
                detailPatientGICList = patientDetailsRecieved.PatientDetGIC.PatientDetGICData;
                detailpatientPVPList = patientDetailsRecieved.PatientDetPVP.PatientDetPVPData;
                patientMRNDetails = patientDetailsRecieved.PatientInfo; 
            /** Mock the response for Apex functionality**/
            return null;
            
        }
     
        public Class PatientSearchGICPVPInputData{
            public String ADDLN_ATTRIBUTE1   {get;set;}
            public String ADDLN_ATTRIBUTE2   {get;set;}
            public String ADDLN_ATTRIBUTE3   {get;set;}
            public String ADDLN_ATTRIBUTE4   {get;set;}
            public String ADDLN_ATTRIBUTE5   {get;set;}
            public String DEPT_ID   {get;set;}
            public String DEPT_NAME   {get;set;}
            public String DIVISION_ID   {get;set;}
            public String DIVISION_NAME   {get;set;}
            public String END_DATE   {get;set;}
            public String FACILITY_ID   {get;set;}
            public String FACILITY_NAME   {get;set;}
            public String FOUNDATION_ID   {get;set;}
            public String FOUNDATION_NAME   {get;set;}
            public String MEASURE_NAME   {get;set;}
            public String PATIENT_MRN   {get;set;}
            public String PATIENT_NAME   {get;set;}
            public String PAYER   {get;set;}
            public String POPULATION   {get;set;}
            public String PREFERRED_COMM_METHOD   {get;set;}
            public String PROVIDER_ID   {get;set;}
            public String PROVIDER_NAME   {get;set;}
            public String SPECIALTY   {get;set;}
            public String START_DATE   {get;set;}
            
            public PatientSearchGICPVPInputData(){
                ADDLN_ATTRIBUTE1 = '';
                ADDLN_ATTRIBUTE2 = '';
                ADDLN_ATTRIBUTE3 = '';
                ADDLN_ATTRIBUTE4 = '';
                ADDLN_ATTRIBUTE5 = '';
                DEPT_ID = '';
                DEPT_NAME = '';
                DIVISION_ID = '';
                DIVISION_NAME = '';
                END_DATE = '';
                FACILITY_ID = '';
                FACILITY_NAME = '';
                FOUNDATION_ID = '';
                FOUNDATION_NAME = '';
                MEASURE_NAME = '';
                PATIENT_MRN = '';
                PATIENT_NAME = '';
                PAYER = '';
                POPULATION = '';
                PREFERRED_COMM_METHOD = '';
                PROVIDER_ID = '';
                PROVIDER_NAME = '';
                SPECIALTY = '';
                START_DATE = '';
            }
            
        }
     
        public class PatientSearchResultsPVP {
            public String ADDLN_ATTRIBUTE1  {get;set;}
            public String ADDLN_ATTRIBUTE2  {get;set;}
            public String ADDLN_ATTRIBUTE3  {get;set;}
            public String ADDLN_ATTRIBUTE4  {get;set;}
            public String ADDLN_ATTRIBUTE5  {get;set;}
            public String ANCHOR_DATE  {get;set;}
            public String AWV_GAPS  {get;set;}
            public String DATE_OF_LAST_APPOINTMENT  {get;set;}
            public String DATE_OF_NEXT_APPOINTMENT  {get;set;}
            public String DEPARTMENT_ID  {get;set;}
            public String DEPARTMENT_NAME  {get;set;}
            public String DIVISION_ID  {get;set;}
            public String DIVISION_NAME  {get;set;}
            public String EMAIL_ADDRESS  {get;set;}
            public String EPIC_PATIENT_ID  {get;set;}
            public String FACILITY_ID  {get;set;}
            public String FACILITY_NAME  {get;set;}
            public String FOUNDATION  {get;set;}
            public String FOUNDATION_ID  {get;set;}
            public String HCC_GAPS  {get;set;}
            public String ID  {get;set;}
            public String LAST_APPOINTMENT_TYPE  {get;set;}
            public String LAST_AWV_DATE  {get;set;}
            public String MEASURE_ID  {get;set;}
            public String MEASURE_NAME  {get;set;}
            public String NEXT_APPOINTMENT_DEPARTMENT_NAME  {get;set;}
            public String NEXT_APPOINTMENT_PROVIDER  {get;set;}
            public String NEXT_APPOINTMENT_TIME  {get;set;}
            public String NEXT_APPOINTMENT_TYPE  {get;set;}
            public String PATIENT_CITY  {get;set;}
            public String PATIENT_DOB  {get;set;}
            public String PATIENT_GENDER  {get;set;}
            public String PATIENT_HOME_ADDRESS  {get;set;}
            public String PATIENT_HOME_PHONE  {get;set;}
            public String PATIENT_ID  {get;set;}
            public String PATIENT_MIDDLE_NAME  {get;set;}
            public String PATIENT_MRN  {get;set;}
            public String PATIENT_NAME  {get;set;}
            public String PATIENT_RACE  {get;set;}
            public String PATIENT_ZIP  {get;set;}
            public String PAYOR_ID  {get;set;}
            public String PAYOR_NAME  {get;set;}
            public String POPULATION  {get;set;}
            public String POSSIBLE_ACTIONS_NEEDED  {get;set;}
            public String PREFERRED_COMMUNICATION_METHOD  {get;set;}
            public String PROVIDER_ID  {get;set;}
            public String QUALITY_GAPS  {get;set;}
            public String SPECIALTY  {get;set;}
            public String outReached {get;set;}
            public PatientSearchResultsPVP(){
            
            }
        }
      
        
        public class PatientSearchResultsGIC{
            public String ADDLN_ATTRIBUTE1  {get;set;}
            public String ADDLN_ATTRIBUTE2  {get;set;}
            public String ADDLN_ATTRIBUTE3  {get;set;}
            public String ADDLN_ATTRIBUTE4  {get;set;}
            public String ADDLN_ATTRIBUTE5  {get;set;}
            public String ANCHOR_DATE  {get;set;}
            public String AWV_MEASUREMENT_THIS_YEAR  {get;set;}
            public String DATE_OF_LAST_APPOINTMENT  {get;set;}
            public String DATE_OF_LAST_BILLED  {get;set;}
            public String DATE_OF_NEXT_APPOINTMENT  {get;set;}
            public String DEPARTMENT_ID  {get;set;}
            public String DEPARTMENT_NAME  {get;set;}
            public String DIVISION_ID  {get;set;}
            public String DIVISION_NAME  {get;set;}
            public String EMAIL_ADDRESS  {get;set;}
            public String EPIC_PATIENT_ID  {get;set;}
            public String FACILITY_ID  {get;set;}
            public String FACILITY_NAME  {get;set;}
            public String FOUNDATION  {get;set;}
            public String FOUNDATION_ID  {get;set;}
            public String HCC  {get;set;}
            public String ID  {get;set;}
            public String LAST_AWV_DATE  {get;set;}
            public String MEASURE_ID  {get;set;}
            public String MEASURE_NAME  {get;set;}
            public String NEXT_APPOINTMENT_PROVIDER  {get;set;}
            public String NEXT_APPOINTMENT_TIME  {get;set;}
            public String NEXT_APPOINTMENT_TYPE  {get;set;}
            public String PATIENT_ADDRESS_LINE_1  {get;set;}
            public String PATIENT_ADDRESS_LINE_2  {get;set;}
            public String PATIENT_DOB  {get;set;}
            public String PATIENT_GENDER  {get;set;}
            public String PATIENT_HOME_ADDRESS  {get;set;}
            public String PATIENT_HOME_PHONE  {get;set;}
            public String PATIENT_ID  {get;set;}
            public String PATIENT_MRN  {get;set;}
            public String PATIENT_NAME  {get;set;}
            public String PATIENT_RACE  {get;set;}
            public String PAYOR_ID  {get;set;}
            public String PAYOR_NAME  {get;set;}
            public String POPULATION  {get;set;}
            public String POSSIBLE_ACTIONS_NEEDED  {get;set;}
            public String PREFERRED_COMMUNICATION_METHOD  {get;set;}
            public String PROVIDER_ID  {get;set;}
            public String QUALIFYING_MEASURE  {get;set;}
            public String SPECIALTY  {get;set;}
            public String outReached {get;set;}
            
            public PatientSearchResultsGIC(){
                
            }
        }
        
        

}