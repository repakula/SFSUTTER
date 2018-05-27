/**********************************************************************
Name: ImportCandidatesCtlr()
======================================================
======================================================
Purpose:
This Class works as controller for import candidate module
======================================================
======================================================
History
-------
VERSION             AUTHOR              DATE                DETAIL                  Description
1.0                 IDC Offshore        13-Sep-2015     INITIAL DEVELOPMENT         Custom Controller for ImportCandidates page, for REQ 3618 - Lead Import (Sourcing)
***********************************************************************/

public with sharing class ImportCandidatesCtlr {

    private ApexPages.StandardSetController setCon;
    // Map to store the Error Records from the various pages that the user has traversed
    public Map<id,Candidate_Import_Error__c>  errorMapFromCurrentPage = new Map<id,Candidate_Import_Error__c>();
    // Property declaration section
    public Blob objFile {get;set;}
    public String[] csvFileLines {get;set;}
     public String fullFileURL {
        get {
            return URL.getSalesforceBaseUrl().toExternalForm();
        }
    }
    
    public List < Lead > lstLeads; // List of Leads to be inserted
    public String strSuccessMsg {get;set;} // Stores the message being displyed post insertion activity
    public Integer successCtr, failCtr, updCtr; // Counter variables to count the number of successful insertions and failed records
    public String selectedValue{get;set;}
    public Boolean showMsg {get;set;} // Boolean variable to determine message display
    public Boolean showErrors {get;set;} // Boolean variable to determine error records display
    public Boolean showErrorRecords {get;set;} // Boolean variable to determine error message display
    public List < Candidate_Import_Error__c > lstErrors {get;set;} // List to store Failed records
    public String ErrorString {get;set;} // contains the String Error Records
    public Integer totalRecords; // Variable to store the total number of records on which operation is being done.    
    public Boolean showUpdate {get;set;}
    public String strOwner {get;set;}
    public String CandidateRecTypeId;// Variable to store the Candidate recordtype id 
    public Boolean error;
    List<Candidate_Import_Error__c> tempErrorList = new List<Candidate_Import_Error__c>();// List of Error Records to be used for internal processing
    set<Id> errorIdSet = new set<Id>();// Set to store Error Record Ids for internal processing
    
    //Creating final variables to replace the hardcoded values
    private static final string NEWLINE = '\n';
    private static final string DOT_CSV = '.csv';
    private static final string Duplicate_Email = 'Duplicate Email';
    private static final string LINKEDIN = 'LINKEDIN';
    private static final string OTHER = 'OTHER';
    private static final string PERMISSIONSET_NAME = 'S3_Sourcing_Agent';
    private static final string QUEUE_NAME = 'Lead Queue';
    private static final string ERROR_STRING = 'Error Records';
    private static final string FILENULL_ERRORMSG = 'File need to be chosen to start the import process';
    private static final string NONCSVFILE_ERRORMSG = 'Given file is not in acceptable format to import the Sourcing candidates';
    private static final string FILESIZE_ERRORMSG = 'File has more data ,Please split the file into multiple files';
    private static final string WRONGFILE_SELECT_ERRORMSG = 'Incorrect file being selected.Please select the relevant file.';
    private static final string CORRECTCSV_ERRORMSG = 'Please select the relevant CSV file to import Candidate records';
    private static final string MOREEERRORRECORDS = 'Error Records are more than 50 Please split the file';
    private static final string JOBNUMBER = 'Job #';
    private static final string POSITION = 'Position:';
    private static final string EXPERIENCE = 'Experience:';
    private static final string COMPANY = 'Company:';
    private static final string LOCATION = 'Location:';
    private static final string DEGREE_NUMBER = 'Degree #:';
    private static final string DEGREE_INSTITUTE = 'Degree Institution:';
    private static final string DEGREE = 'Degree:';
    private static final string DEGREE_YEAR = 'Degree Year:';
    private static final string OUT_OF_BOUNDS = 'out of bounds';
    private static final string JOBFAIR = 'JobFair';
    private static final string CANDIDATE_QUALIFIED = 'Candidate Qualified';
    private static final string CANDIDATE_RECORDTYPE = 'Candidate';
    private static final string No_Of_Connections = '# of Connections';
    private static final string RECORD_LIMIT_ERR = 'Given file contains more than 500 records, import function can only process 500 at a time';
    
    /** Populating the Sourcing From Drop down with relevant values **/
    /*******************************************************************
    Purpose: create a drop down list for sourcing from
    Parameters: NA
    Returns: List < selectOption >
    Throws [Exceptions]: NA
    ********************************************************************/
    public List < selectOption > getSourcingFrom() {
        // Add Sourcing picklist Values 
        List < selectOption > options = new List < selectOption > ();
        options.add(new selectOption(LINKEDIN, LINKEDIN));
        options.add(new selectOption(OTHER, OTHER));
        return options; //return the picklist options
    }

   
    /*******************************************************************
    Purpose: Fetching the Sourcing Agents and Lead queue to store them in the Owner dropdown
    Parameters: NA
    Returns: List < selectOption >
    Throws [Exceptions]: NA
    ********************************************************************/
    public List < selectOption > getSourcingAgents() {
        // Add Sourcing Agents
        List < selectOption > options = new List < selectOption > ();
        User objCurrentUser = [select id,name from user where id=:userinfo.getuserid()];
        // Add Current User
        options.add(new selectOption(objCurrentUser.id, objCurrentUser.name)); 
        List < id > lstUserIds = new List < Id > ();
        Id QueueId = [select id from Group where name = :QUEUE_NAME and Type = 'Queue'].id;
        Id permissionSetId = [select id from PermissionSet where name =: PERMISSIONSET_NAME ].id;
        List < PermissionSetAssignment > lstAssignedPS = [select id, Assigneeid from PermissionSetAssignment where PermissionSetId = : permissionSetId];
        if (!lstAssignedPS.isEmpty()) {
            for (PermissionSetAssignment objPSA: lstAssignedPS)
                lstUserIds.add(objPSA.Assigneeid);
        }
        // Add Active User Assigned the permission Set "S3_Sourcing_Agent"
        for (User objUser: [select id, name from user where id in : lstUserIds AND IsActive = true]){
            if(objUser.id!=userinfo.getUserId())
            options.add(new selectOption(objUSer.id, objUser.name));
        }
        // Add "Lead Queue" option
        options.add(new selectOption(QueueId, QUEUE_NAME));
        return options; //return the picklist options
    }

    /*******************************************************************
    Purpose: Constructor to initialize the variables
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    ********************************************************************/
    public ImportCandidatesCtlr() {
        lstLeads = new List < Lead > ();
        successCtr = 0;
        failCtr = 0;
        updCtr = 0;
        showMsg = false;
        error = false;
        lstErrors = new List < Candidate_Import_Error__c > ();
        ErrorString = ERROR_STRING;
        // Candidate Recordtype Id
        CandidateRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(CANDIDATE_RECORDTYPE).getRecordTypeId();
        tempErrorList = new List<Candidate_Import_Error__c>();
        // Initialize StandardSet Contoller Object
        setCon = new ApexPages.StandardSetController(tempErrorList);  
        
    }
   
    /*******************************************************************
    Purpose: Import Method which reads the CSV file and processes it
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    ********************************************************************/
    public transient string csvAsString {get;set;}
    public Boolean strCheck {get;set;}
    public String strSourcingFrom {get;set;}
    public void Import() {
        successCtr = 0;
        failCtr = 0;
        lstErrors = new List < Candidate_Import_Error__c > ();
        Set<String> setLeadEmails = new Set < String > ();
        errorIdSet = new set<Id>();
        showerrors = false;
        showErrorRecords = false;
        error = false;
        strCheck = false;
        showUpdate = false;
        showMsg = false;
        lstLeads = new List < Lead > ();
        if(selectedValue==null || selectedValue=='') {
        // Populates the selectedValue with current user in case Agent has not selected any owner from the dropdown
            selectedValue = userinfo.getUserId();
        }
        
        //If no file is selected we need to throw an error message
        if (objFile == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, FILENULL_ERRORMSG);
            ApexPages.addMessage(myMsg);
        } 
        //If a non CSV file is selected we need to throw an error message
        else if(objFile!=null && csvAsString!=null && !(csvAsString.endsWith(DOT_CSV))) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, NONCSVFILE_ERRORMSG);
            ApexPages.addMessage(myMsg);  
        }       
        //If a CSV file is selected we start processing it
        else if(objFile!=null && csvAsString!=null && (csvAsString.endsWith(DOT_CSV))) {
            String hex = EncodingUtil.convertToHex(objFile); 
            final Integer bytesCount = hex.length() >> 1; 
            String[] bytes = new String[bytesCount];
            List < List < String >> lstRecordsHeaders;
            List < List < String >> lstRecords;
            //Checking if the file size is grater than 430 KB, we throw an error message on the page
            if(bytesCount>450000) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, FILESIZE_ERRORMSG);
                ApexPages.addMessage(myMsg);
                error = true; 
            } else {
                for(Integer i = 0; i < bytesCount; ++i) {  
                   bytes[i] = hex.mid(i << 1, 2); 
                } 
                csvAsString=EncodingUtil.urlDecode('%' + String.join(bytes, '%'), 'UTF-8');
                lstRecordsHeaders = HRSourcingCsvParser.parseCSV(csvAsString, false);
                lstRecords = HRSourcingCsvParser.parseCSV(csvAsString, true);
                //Checking if the no. of records in the file is greater than 500, we throw an error message on the page
                if (lstRecords==null) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, RECORD_LIMIT_ERR);
                    ApexPages.addMessage(myMsg);
                    error = true;
                    
                } 
            }      
                
            //LinkedIn processing code for LinkedIn files - START
            if (strSourcingFrom == LINKEDIN) {
                try {
                    if(error==false) {
                        if(!(lstRecords.isEmpty()))
                            totalRecords = lstRecords.size(); 
                        String strtest;
                        List < String > lstHeaders;
                        if(!(lstRecordsHeaders.isempty())) {
                            lstHeaders = lstRecordsHeaders[0];
                            strtest = lstHeaders[8];
                        }
                        //Checking if relevant LinkedIn CSV file is selected else throw an error message on the page
                        if (!strtest.containsIgnoreCase(No_Of_Connections)){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, WRONGFILE_SELECT_ERRORMSG);
                            ApexPages.addMessage(myMsg);
                            error = true;
                        }   
                    }
                    if (error == false) {
                        setLeadEmails = new Set < String > ();
                        for(Lead objLd: [select email from Lead where recordtypeid = : CandidateRecTypeId limit 50000]) {
                            setLeadEmails.add(objLd.Email);
                        } 
                
                        for(List < String > lstString: lstRecords) {
                            //Matching the record's Email with the existing Lead Records' Email in the system
                            if (setLeadEmails.contains(lstString[96].toLowerCase().replaceFirst('"','').removeEnd('"'))) {
                                Candidate_Import_Error__c objError = new Candidate_Import_Error__c();
                                objError.First_Name__c = lstString[0].replaceFirst('"','').removeEnd('"');
                                objError.Last_Name__c = lstString[1].replaceFirst('"','').removeEnd('"');
                                objError.Email__c = lstString[96].toLowerCase().replaceFirst('"','').removeEnd('"');
                                String strProfileURL = lstString[2].replaceFirst('"','').removeEnd('"');
                                String strProfileURLFinal = parseProfileURL(strProfileURL);
                                objError.Profile_URL__c = strProfileURLFinal;
                                objError.LinkedIn_Id__c = lstString[3].replaceFirst('"','').removeEnd('"');
                                objError.Industry__c = lstString[7].replaceFirst('"','').removeEnd('"');
                                objError.of_Connections__c = lstString[8].replaceFirst('"','').removeEnd('"');
                                objError.Summary__c = lstString[9].replaceFirst('"','').removeEnd('"');
                                objError.Skills__c = lstString[90].replaceFirst('"','').removeEnd('"');
                                objError.Languages__c = lstString[93].replaceFirst('"','').removeEnd('"');
                                objError.Interests__c = lstString[94].replaceFirst('"','').removeEnd('"');
                                objError.Current_Company_Domain__c = lstString[95].replaceFirst('"','').removeEnd('"');
                                objError.Phone__c = lstString[97].replaceFirst('"','').removeEnd('"');
                                objError.IM__c = lstString[98].replaceFirst('"','').removeEnd('"');
                                objError.Twitter__c = lstString[99].replaceFirst('"','').removeEnd('"');
                                objError.Project__c = lstString[100].replaceFirst('"','').removeEnd('"');
                                objError.Description__c = lstString[14].replaceFirst('"','').removeEnd('"');
                                objError.Error_Encountered__c = Duplicate_Email;
                                objError.Company__c = lstString[5].replaceFirst('"','').removeEnd('"');
                                objError.Current_Position__c = lstString[4].replaceFirst('"','').removeEnd('"');
                                objError.Location__c = lstString[6].replaceFirst('"','').removeEnd('"');
                                objError.Persons_In_Common__c = lstString[91].replaceFirst('"','').removeEnd('"');
                                objError.Groups__c = lstString[92].replaceFirst('"','').removeEnd('"');
                                objError.Owner_Id__c = selectedValue;
                                objError.Lead_Source__c = LINKEDIN;
                                integer j = 1;
                                integer i;
                                //Importing Company Information
                                for (i = 10; i < 56; i += 5) {
                                    if (lstString[i] != null && lstString[i] != '' && lstString[i]!='"') {
                                        if (objError.Previous_Companies__c == null)
                                            objError.Previous_Companies__c = JOBNUMBER + j;
                                        else
                                            objError.Previous_Companies__c = objError.Previous_Companies__c + NEWLINE + JOBNUMBER + j;
                                        objError.Previous_Companies__c = objError.Previous_Companies__c + NEWLINE + '.         '+Position+' ' + lstString[i].replaceFirst('"','').removeEnd('"');
                                        objError.Previous_Companies__c = objError.Previous_Companies__c + NEWLINE + '.         '+Company+' ' + lstString[i + 1].replaceFirst('"','').removeEnd('"');
                                        objError.Previous_Companies__c = objError.Previous_Companies__c + NEWLINE + '.         '+Experience+' ' + lstString[i + 2].replaceFirst('"','').removeEnd('"');
                                        objError.Previous_Companies__c = objError.Previous_Companies__c + NEWLINE + '.         '+Location+' ' + lstString[i + 3].replaceFirst('"','').removeEnd('"');
                                        j++;
                                    }
                                }
                                //Importing Education Records
                                j = 1;
                                for (i = 60; i < 90; i += 3) {
                                    if (lstString[i] != null && lstString[i] != '' && lstString[i]!='"') {
                                        if (objError.Education_Details__c == null)
                                            objError.Education_Details__c = DEGREE_NUMBER + j;
                                        else
                                            objError.Education_Details__c = objError.Education_Details__c + NEWLINE + DEGREE_NUMBER + j;
                                        objError.Education_Details__c = objError.Education_Details__c + NEWLINE + '.         '+Degree_Institute+' ' + lstString[i].replaceFirst('"','').removeEnd('"');
                                        objError.Education_Details__c = objError.Education_Details__c + NEWLINE + '.         '+Degree+' ' + lstString[i + 1].replaceFirst('"','').removeEnd('"');
                                        objError.Education_Details__c = objError.Education_Details__c + NEWLINE + '.         '+Degree_Year+' ' + lstString[i + 2].replaceFirst('"','').removeEnd('"');
        
                                        j++;
                                    }
                                }
                                lstErrors.add(objError);
                                failCtr += 1;
                                showUpdate = true;
                            } 
                            //If the record's Email is unique , we try creating a Lead record for it
                            else {
                                Lead objLead = new Lead();
                                objLead.FirstName = lstString[0].replaceFirst('"','').removeEnd('"');
                                objLead.LastName = lstString[1].replaceFirst('"','').removeEnd('"');
                                String strProfileURL = lstString[2].replaceFirst('"','').removeEnd('"');
                                String strProfileURLFinal = parseProfileURL(strProfileURL);
                                objLead.Profile_URL__c = strProfileURLFinal;
                                objLead.Linkedin_Id__c = lstString[3].replaceFirst('"','').removeEnd('"');
                                objLead.Company = lstString[5].replaceFirst('"','').removeEnd('"');
                                objLead.Location__c = lstString[6].replaceFirst('"','').removeEnd('"');
                                objLead.Email = lstString[96].toLowerCase().replaceFirst('"','').removeEnd('"');
                                objLead.Current_Position__c = lstString[4].replaceFirst('"','').removeEnd('"');
                                objLead.Industry__c = lstString[7].replaceFirst('"','').removeEnd('"');
                                objLead.of_Connections__c = lstString[8].replaceFirst('"','').removeEnd('"');
                                objLead.Summary__c = lstString[9].replaceFirst('"','').removeEnd('"');
                                objLead.Skills__c = lstString[90].replaceFirst('"','').removeEnd('"');
                                objLead.Languages__c = lstString[93].replaceFirst('"','').removeEnd('"');
                                objLead.Interests__c = lstString[94].replaceFirst('"','').removeEnd('"');
                                objLead.Current_Company_Domain__c = lstString[95].replaceFirst('"','').removeEnd('"');
                                objLead.Phone = lstString[97].replaceFirst('"','').removeEnd('"');
                                objLead.IM__c = lstString[98].replaceFirst('"','').removeEnd('"');
                                objLead.Twitter__c = lstString[99].replaceFirst('"','').removeEnd('"');
                                objLead.Project__c = lstString[100].replaceFirst('"','').removeEnd('"');
                                objLead.Description = lstString[14].replaceFirst('"','').removeEnd('"');
                                objLead.Groups__c = lstString[92].replaceFirst('"','').removeEnd('"');
                                objLead.Persons_In_Common__c = lstString[91].replaceFirst('"','').removeEnd('"');
                                objLead.LeadSource = LINKEDIN;
                                objLead.Status = CANDIDATE_QUALIFIED;
                                objLead.OwnerId = selectedValue;
                                objLead.recordTypeId = CandidateRecTypeId;
                                integer j = 1;
                                integer i;
                                //Importing Company Information from the respective file columns
                                for (i = 10; i < 56; i += 5) {
                                    if (lstString[i] != null && lstString[i] != '' && lstString[i]!='"' ) {
                                        if (objLead.Company__c == null)
                                            objLead.Company__c = JOBNUMBER + j;
                                        else
                                            objLead.Company__c = objLead.Company__c + NEWLINE + JOBNUMBER + j;
                                        objLead.Company__c = objLead.Company__c + NEWLINE + '.         '+POSITION+' ' + lstString[i].replaceFirst('"','').removeEnd('"');
                                        objLead.Company__c = objLead.Company__c + NEWLINE + '.         '+Company+' ' + lstString[i + 1].replaceFirst('"','').removeEnd('"');
                                        objLead.Company__c = objLead.Company__c + NEWLINE + '.         '+Experience+' ' + lstString[i + 2].replaceFirst('"','').removeEnd('"');
                                        objLead.Company__c = objLead.Company__c + NEWLINE + '.         '+Location+' ' + lstString[i + 3].replaceFirst('"','').removeEnd('"');
                                        j++;
                                    }
                                }
                                //Importing Education Records from the respective file columns
                                j = 1;
                                for (i = 60; i < 90; i += 3) {
                                    if (lstString[i] != null && lstString[i] != '' && lstString[i]!='"') {
                                        if (objLead.Education_Details__c == null)
                                            objLead.Education_Details__c = DEGREE_NUMBER + j;
                                        else
                                            objLead.Education_Details__c = objLead.Education_Details__c + NEWLINE + DEGREE_NUMBER + j;
                                        objLead.Education_Details__c = objLead.Education_Details__c + NEWLINE + '.         '+Degree_Institute+' ' + lstString[i].replaceFirst('"','').removeEnd('"');
                                        objLead.Education_Details__c = objLead.Education_Details__c + NEWLINE + '.         '+Degree+' ' + lstString[i + 1].replaceFirst('"','').removeEnd('"');
                                        objLead.Education_Details__c = objLead.Education_Details__c + NEWLINE + '.         '+Degree_Year+' ' + lstString[i + 2].replaceFirst('"','').removeEnd('"');
                                        j++;
                                    }
                                }
                                lstLeads.add(objLead);
                            }
                        }
                        if (!lstLeads.isempty()) {
                            List < Database.SaveResult > saveResults = Database.insert(lstLeads, false);
                            for (Integer i = 0; i < saveResults.size(); i++) {
                                //Checking if the Lead Record was successfully inserted or not
                                if (saveResults.get(i).isSuccess() == true) {
                                    successCtr += 1; // Increasing the success counter for successfully inserted records
                                } 
                                else {
                                    //Creating an Error Record for unsuccessful Lead Records
                                    Database.Error error = saveResults.get(i).getErrors().get(0);
                                    String failedDML = error.getMessage();
                                    lstLeads.get(i); //failed record from the list
                                    Candidate_Import_Error__c objError = createErrorRecord(lstLeads.get(i),failedDML);
                                    objError.Owner_Id__c = selectedValue;
                                    lstErrors.add(objError);
                                    failCtr += 1;
                                }
                            }
                        }
                        strSuccessMsg = 'There are ' + successCtr + ' successful insertions and ' + failCtr + ' failures out of ' + totalRecords + ' records';
                        showMsg = true;
                        if (!(lstErrors.isEmpty())) {
                            List < String > lstErrormail = new List < String > ();
                            for (Candidate_Import_Error__c objCandErr: lstErrors) {
                                lstErrormail.add(objCandErr.Email__c);
                            }
                            //Fetching the existing error records in the system on basis of current import's error records' Email
                            List < Candidate_Import_Error__c > lstErrorsExisting = [select id from Candidate_Import_Error__c where Email__c in : lstErrormail];
                            // Deleting the existing error Records in the system , if found
                            if (!lstErrorsExisting.isempty())
                                delete lstErrorsExisting;
                            //Inserting the current import's error Records in the system               
                            insert lstErrors; 
                            for(Candidate_Import_Error__c obj : lstErrors) {
                                errorIdSet.add(obj.id);
                            }
                            showErrors = true; // showing the Error Table on the Page
                            showErrorRecords = true; // Showing the Error Records text on the page
                            showUpdate=true; // Showing the Note text on the page at the bottom of the error table
                        }
                    }
                } catch (Exception e) {
                    ApexPages.Message errorMessage;
                    //Displaying error message on the page if any unacceptable CSV file is selected
                    if(e.getMessage().containsIgnoreCase(OUT_OF_BOUNDS)){
                        errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,CORRECTCSV_ERRORMSG);
                    }
                    else {}   
                    if(errorMessage!=null)
                        ApexPages.addMessage(errorMessage);
                }
            }
            //LinkedIn processing code for LinkedIn files - END
            /*********************************************/
            //JobFair processing code for JobFair files - START
            else if (strSourcingFrom == OTHER) {
                try {
                    if(error==false) {
                        if(!lstRecords.isEmpty())
                            totalRecords = lstRecords.size();
                        String strtest;
                        List < String > lstHeaders;
                        if(!(lstRecordsHeaders.isEmpty())) {
                            lstHeaders = lstRecordsHeaders[0];
                            strtest = lstHeaders[8];
                        }
                        //Checking whether JobFair CSV file has been selected or not
                        if (strtest.containsIgnoreCase(No_Of_Connections)) {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, WRONGFILE_SELECT_ERRORMSG);
                            ApexPages.addMessage(myMsg);
                            error = true;
                        }
                    }
                    if (error == false) {
                        setLeadEmails = new Set < String > ();
                        for (Lead objLd: [select email from Lead where recordtypeid = : CandidateRecTypeId limit 50000]) {
                            setLeadEmails.add(objLd.Email);
                        }  
                        for (List < String > lstString: lstRecords) {
                            //Checking whether record's Email is matching with the Email of any Lead existing in the system
                            if (setLeadEmails.contains(lstString[14].toLowerCase().replaceFirst('"','').removeEnd('"'))) {
                                Candidate_Import_Error__c objError = new Candidate_Import_Error__c();
                                objError.First_Name__c = lstString[0].replaceFirst('"','').removeEnd('"');
                                objError.Last_Name__c = lstString[1].replaceFirst('"','').removeEnd('"');
                                objError.Email__c = lstString[14].toLowerCase().replaceFirst('"','').removeEnd('"');
                                String strProfileURL = lstString[2].replaceFirst('"','').removeEnd('"');
                                String strProfileURLFinal = parseProfileURL(strProfileURL);
                                objError.Profile_URL__c = strProfileURLFinal;
                                objError.LinkedIn_Id__c = lstString[3].replaceFirst('"','').removeEnd('"');
                                objError.Error_Encountered__c = Duplicate_Email;
                                objError.Company__c = lstString[5].replaceFirst('"','').removeEnd('"');
                                objError.Current_Position__c = lstString[4].replaceFirst('"','').removeEnd('"');
                                objError.Location__c = lstString[6].replaceFirst('"','').removeEnd('"');
                                objError.Industry__c = lstString[7].replaceFirst('"','').removeEnd('"');
                                objError.Summary__c = lstString[8].replaceFirst('"','').removeEnd('"');
                                objError.Description__c = lstString[9].replaceFirst('"','').removeEnd('"');
                                objError.Education_Details__c = lstString[10].replaceFirst('"','').removeEnd('"');
                                objError.Skills__c = lstString[11].replaceFirst('"','').removeEnd('"');
                                objError.Interests__c = lstString[12].replaceFirst('"','').removeEnd('"');
                                objError.Current_Company_Domain__c = lstString[13].replaceFirst('"','').removeEnd('"');
                                objError.Phone__c = lstString[15].replaceFirst('"','').removeEnd('"');
                                objError.IM__c = lstString[16].replaceFirst('"','').removeEnd('"');
                                objError.Twitter__c = lstString[17].replaceFirst('"','').removeEnd('"');
                                objError.Project__c = lstString[18].replaceFirst('"','').removeEnd('"');
                                objError.Owner_Id__c = selectedValue;
                                objError.Lead_Source__c = JOBFAIR;
                                lstErrors.add(objError);
                                failCtr += 1;
                                showUpdate = true;
                            } 
                            //Creating a Lead Record if the Record's Email is unique
                            else {
                                Lead objLead = new Lead();
                                objLead.FirstName = lstString[0].replaceFirst('"','').removeEnd('"');
                                objLead.LastName = lstString[1].replaceFirst('"','').removeEnd('"');
                                String strProfileURL = lstString[2].replaceFirst('"','').removeEnd('"');
                                String strProfileURLFinal = parseProfileURL(strProfileURL);
                                objLead.Profile_URL__c = strProfileURLFinal;
                                objLead.Linkedin_Id__c = lstString[3].replaceFirst('"','').removeEnd('"');
                                objLead.Current_Position__c = lstString[4].replaceFirst('"','').removeEnd('"');
                                objLead.Company = lstString[5].replaceFirst('"','').removeEnd('"');
                                objLead.Location__c = lstString[6].replaceFirst('"','').removeEnd('"');
                                objLead.Industry__c = lstString[7].replaceFirst('"','').removeEnd('"');
                                objLead.Summary__c = lstString[8].replaceFirst('"','').removeEnd('"');
                                objLead.Description = lstString[9].replaceFirst('"','').removeEnd('"');
                                objLead.Education_Details__c = lstString[10].replaceFirst('"','').removeEnd('"');
                                objLead.Skills__c = lstString[11].replaceFirst('"','').removeEnd('"');
                                objLead.Interests__c = lstString[12].replaceFirst('"','').removeEnd('"');
                                objLead.Current_Company_Domain__c = lstString[13].replaceFirst('"','').removeEnd('"');
                                objLead.Email = lstString[14].replaceFirst('"','').removeEnd('"');
                                objLead.Phone = lstString[15].replaceFirst('"','').removeEnd('"');
                                objLead.IM__c = lstString[16].replaceFirst('"','').removeEnd('"');
                                objLead.Twitter__c = lstString[17].replaceFirst('"','').removeEnd('"');
                                objLead.Project__c = lstString[18].replaceFirst('"','').removeEnd('"');
                                objLead.Status = CANDIDATE_QUALIFIED;
                                objLead.OwnerId = selectedValue;
                                objLead.LeadSource=JOBFAIR;
                                objLead.recordTypeId = CandidateRecTypeId;
                                lstLeads.add(objLead);
                            }
                        }
                    }
                    if (!lstLeads.isempty()) {
                        List < Database.SaveResult > saveResults = Database.insert(lstLeads, false);
                        for (Integer i = 0; i < saveResults.size(); i++) {
                            //Checking whether record is successfully inserted in the system                  
                            if (saveResults.get(i).isSuccess() == true) {
                                successCtr += 1;
                            } else {
                                //Creating an Error Record if insertion failed due to any reason
                                Database.Error error = saveResults.get(i).getErrors().get(0);
                                String failedDML = error.getMessage();
                                lstLeads.get(i); //failed record from the list
                                Candidate_Import_Error__c objError = new Candidate_Import_Error__c();
                                objError.First_Name__c = lstLeads.get(i).FirstName;
                                objError.Last_Name__c = lstLeads.get(i).LastName;
                                objError.Email__c = lstLeads.get(i).Email;
                                objError.Profile_URL__c = lstLeads.get(i).Profile_URL__c;
                                objError.LinkedIn_Id__c = lstLeads.get(i).LinkedIn_Id__c;
                                objError.Error_Encountered__c = failedDML;
                                objError.Company__c = lstLeads.get(i).Company;
                                objError.Current_Position__c = lstLeads.get(i).Current_Position__c;
                                
                                objError.Location__c = lstLeads.get(i).Location__c;
                                objError.Industry__c = lstLeads.get(i).Industry__c;
                                objError.Summary__c = lstLeads.get(i).Summary__c;
                                objError.Description__c = lstLeads.get(i).Description;
                                objError.Education_Details__c = lstLeads.get(i).Education_Details__c;
                                objError.Skills__c = lstLeads.get(i).Skills__c;
                                objError.Interests__c = lstLeads.get(i).Interests__c;
                                objError.Current_Company_Domain__c = lstLeads.get(i).Current_Company_Domain__c;
                                objError.Phone__c = lstLeads.get(i).Phone;
                                objError.IM__c = lstLeads.get(i).IM__c;
                                objError.Twitter__c = lstLeads.get(i).Twitter__c;
                                objError.Project__c = lstLeads.get(i).Project__c;
                                objError.Owner_Id__c = selectedValue;
                                objError.Lead_Source__c = JOBFAIR;
                                lstErrors.add(objError);
                                failCtr += 1;
                            }
                        }
                    }
                    strSuccessMsg = 'There are ' + successCtr + ' successful insertions and ' + failCtr + ' failures out of ' + totalRecords + ' records';
                    showMsg = true;
                    if (!(lstErrors.isEmpty())) {
                        List < String > lstErrormail = new List < String > ();
                        for (Candidate_Import_Error__c objCandErr: lstErrors) {
                            lstErrormail.add(objCandErr.Email__c);
                        }
                        //Fetching the existing error records in the system on basis of current import's error records' Email
                        List < Candidate_Import_Error__c > lstErrorsExisting = [select id from Candidate_Import_Error__c where Email__c in : lstErrormail ];
                        //Deleting the existing error Records in the system , if found
                        if (!lstErrorsExisting.isempty())
                            delete lstErrorsExisting;
                        //Inserting the current import's error Records in the system   
                        insert lstErrors;
                        for(Candidate_Import_Error__c obj : lstErrors) {
                            errorIdSet.add(obj.id);
                        }
                        showErrors = true; // showing the Error Table on the Page
                        showErrorRecords = true; // Showing the Error Records text on the page
                        showUpdate=true; // Showing the Note text on the page at the bottom of the error table
                    }
                }
                catch (Exception e) {
                    ApexPages.Message errorMessage;
                //Displaying the error message on the page if any unacceptable CSV file is selected
                if(e.getMessage().containsIgnoreCase(OUT_OF_BOUNDS)) {
                    errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,CORRECTCSV_ERRORMSG);
                }
                else {
                }   
                if(errorMessage!=null)
                    ApexPages.addMessage(errorMessage);
                }               
            }
            //JobFair processing code for JobFair files - END
        }
        objFile = null;
        //Fetching the Current Import's Error Records and setting them in the StandardSetController for pagination
        tempErrorList = new List<Candidate_Import_Error__c>([SELECT First_Name__c,Last_Name__c,Email__c,Profile_URL__c,LinkedIn_Id__c,Error_Encountered__c,Company__c,Current_Position__c, 
                                                                Industry__c,of_Connections__c,Summary__c,Skills__c,Languages__c,Interests__c,Current_Company_Domain__c,Phone__c,IM__c,Twitter__c,
                                                                Project__c,Description__c,Education_Details__c,Previous_Companies__c,Activity_Details__c,Groups__c,Persons_In_Common__c,Location__c,
                                                                Owner_Id__c,Lead_Source__c  FROM Candidate_Import_Error__c where ID IN :errorIdSet order by lastModifieddate desc ]);
        this.setCon = new ApexPages.StandardSetController(tempErrorList);
        this.setCon.setpageNumber(1);
        // Set Page Size
        this.setCon.setPageSize(5);
    }
    
    /*******************************************************************
    Purpose: Method to return list of error records for set controller
    Parameters: NA
    Returns: List<Candidate_Import_Error__c>
    Throws [Exceptions]: NA
    ********************************************************************/
    public List<Candidate_Import_Error__c> getErrorList() {
        List<Candidate_Import_Error__c> lstErrorsTEMP = new List<Candidate_Import_Error__c>();
        if(setCon != NULL) {           
            lstErrorsTEMP = (List<Candidate_Import_Error__c>)setCon.getRecords();
        }
        return lstErrorsTEMP;
    }
   
    /*******************************************************************
    Purpose: Method to process the error Records present in the table, which have been updated
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    ********************************************************************/
    public void UpdateDuplicate() {
        Set<String> setUpdatedLeadsErrorMail =new Set<String>();
        lstErrors =new List<Candidate_Import_Error__c>();
        if(!(errorMapFromCurrentPage.isEmpty())){
        //Storing the updated error Records, modified on the rest of the pages, from the map to List of Error records
            for(Candidate_Import_Error__c objCandidateErr:errorMapFromCurrentPage.values())  
                lstErrors.add(objCandidateErr); 
        }    
        //Storing the updated error Records, modified on the current page **/
        for(Candidate_Import_Error__c objCanError:getErrorList()){
            if(errorMapFromCurrentPage.get(objCanError.id)==null)
                lstErrors.add(objCanError);     
        }
        Integer lstVar = 0;
        updCtr = 0;
        List < Lead > lstLeadsUpd = new List < Lead > ();
        Map<Id, Lead> mapLeadsUpd = new Map<Id, Lead>();
        Map < String, Lead > mapLeadsEmail = new Map < String, Lead > ();
        Map < String, String > mapLeadsFirstName = new Map < String, String > ();
        Map < String, String > mapLeadsLastName = new Map < String, String > ();
        Map < String, String > mapLeadsLinkedInId = new Map < String, String > ();
        Map < String, String > mapLeadsProfileURL = new Map < String, String > ();
        Map < String, String > mapLeadsCompany = new Map < String, String > ();
        Map < String, String > mapLeadsPosition = new Map < String, String > ();
        List < Candidate_Import_Error__c > lstErrorsTmp = new List < Candidate_Import_Error__c > ();
        List < Lead > lstLeadsIns = new List < Lead > ();
        Set < String > setLeadEmails = new Set < String > ();
        if(selectedValue==null || selectedValue=='')
            selectedValue = userinfo.getUserId();
        showErrors = true;
        showErrorRecords = true;
        failCtr = 0;
        successCtr = 0;
        showUpdate = false;
        //Storing  existing Lead Records' information in the respecive maps to verify that error records have been updated in the table or not  **/
        for (Lead obj: [select id, Email, Profile_URL__c, LinkedIn_Id__c, ownerid, recordTypeId, Company, Location__c, Current_Position__c, FirstName, LastName, Industry__c, 
                            of_Connections__c, Summary__c, Skills__c, Languages__c, Interests__c, Current_Company_Domain__c, Phone, IM__c, Twitter__c, Project__c, Description, LeadSource, 
                            Education_Details__c, Company__c, Activity_Details__c from lead where recordtypeid = : CandidateRecTypeId limit 50000]) {
            mapLeadsEmail.put(obj.Email, obj);
            setLeadEmails.add(obj.Email);
            mapLeadsFirstName.put(obj.Email,obj.FirstName);
            mapLeadsLastName.put(obj.Email,obj.LastName);
            mapLeadsLinkedInId.put(obj.Email,obj.LinkedIn_Id__c);
            mapLeadsProfileURL.put(obj.Email,obj.Profile_URL__c);
            mapLeadsCompany.put(obj.Email,obj.Company);
            mapLeadsPosition.put(obj.Email,obj.Current_Position__c);
        }
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        for (Candidate_Import_Error__c objErr: lstErrors) {
            if(mapLeadsEmail.get(objErr.Email__c) != null) {
                Lead objLead = mapLeadsEmail.get(objErr.Email__c);
                //Chekcing if Error Record's information has been updated or not.If it is updated, we update the corresponding Lead record  **/
                if (objLead != null && (objErr.First_Name__c!=mapLeadsFirstName.get(objErr.Email__c) || objErr.Last_Name__c!=mapLeadsLastName.get(objErr.Email__c) || 
                        objErr.LinkedIn_Id__c!=mapLeadsLinkedInId.get(objErr.Email__c) || objErr.Profile_URL__c!=mapLeadsProfileURL.get(objErr.Email__c) || 
                        objErr.Company__c!=mapLeadsCompany.get(objErr.Email__c) || objErr.Current_Position__c!=mapLeadsPosition.get(objErr.Email__c))) {
                    objLead.recordTypeId = CandidateRecTypeId;
                    objLead.Email = objErr.Email__c;
                    objLead.LinkedIn_Id__c = objErr.LinkedIn_Id__c;
                    objLead.Profile_URL__c = objErr.Profile_URL__c;
                    objLead.Company = objErr.Company__c;
                    objLead.Location__c = objErr.Location__c;
                    objLead.Current_Position__c = objErr.Current_Position__c;
                    objLead.FirstName = objErr.First_Name__c;
                    objLead.LastName = objErr.Last_Name__c;
                    objLead.Industry__c = objErr.Industry__c;
                    objLead.of_Connections__c = objErr.of_Connections__c;
                    objLead.Summary__c = objErr.Summary__c;
                    objLead.Skills__c = objErr.Skills__c;
                    objLead.Languages__c = objErr.Languages__c;
                    objLead.Interests__c = objErr.Interests__c;
                    objLead.Current_Company_Domain__c = objErr.Current_Company_Domain__c;
                    objLead.Phone = objErr.Phone__c;
                    objLead.IM__c = objErr.IM__c;
                    objLead.Twitter__c = objErr.Twitter__c;
                    objLead.Project__c = objErr.Project__c;
                    objLead.Description = objErr.Description__c;
                    objLead.Groups__c = objErr.Groups__c;
                    objLead.Persons_In_Common__c = objErr.Persons_In_Common__c;
                    objLead.LeadSource = objErr.Lead_Source__c;
                    objLead.Education_Details__c = objErr.Education_Details__c;
                    objLead.Company__c = objErr.Previous_Companies__c;
                    objLead.Activity_Details__c = objErr.Activity_Details__c;
                    // Changing the Owner of the Lead record if the Current Lead owner is Lead Queue and new Owner is a Sourcing Agent 
                    // Skip Validation field is used to bypass the validation rules created on Lead **/ 
                    if (objLead != null && ((String) objLead.Ownerid).startsWith(groupType) && selectedValue!=null && selectedValue.startsWith(userType)) {
                        objLead.Ownerid = selectedValue;
                        objLead.Skip_Validation__c = true;
                    }
                    if (objLead != null && ((String) objLead.Ownerid).startsWith(groupType) && selectedValue!=null && selectedValue.startsWith(groupType)) {
                        objLead.Skip_Validation__c = true;
                    }
                    if (objLead != null && ((String) objLead.Ownerid).startsWith(userType) && selectedValue!=null && selectedValue.startsWith(userType)) {
                        objLead.Skip_Validation__c = true;
                    }
                    if (objLead != null && ((String) objLead.Ownerid).startsWith(userType) && selectedValue!=null && selectedValue.startsWith(groupType)) {
                        objLead.Skip_Validation__c = true;
                    }
                    mapLeadsUpd.put(objLead.Id, objLead);
                }
            }
        }
        if (!mapLeadsUpd.isempty()) {
            lstLeadsUpd = mapLeadsUpd.values();
            List < Database.SaveResult > saveResultsUpd = Database.update(lstLeadsUpd, false);
            for (Integer i = 0; i < saveResultsUpd.size(); i++) {
                if (saveResultsUpd.get(i).isSuccess() == true) {
                    updCtr += 1;
                } else {
                    Database.Error error = saveResultsUpd.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    lstLeadsUpd.get(i); //failed record from the list
                    Candidate_Import_Error__c objError = createErrorRecord(lstLeadsUpd.get(i),failedDML);
                    objError.Owner_Id__c = lstLeadsUpd.get(i).ownerid;
                    lstErrorsTmp.add(objError);
                    failCtr += 1;
                }
            }
        }
        List<Candidate_Import_Error__c> tempList = lstErrors;
        while (lstVar < lstErrors.size()) {
            if ( mapLeadsEmail.get(lstErrors.get(lstVar).Email__c) != null && (mapLeadsFirstName.get(lstErrors.get(lstVar).Email__c)!=lstErrors.get(lstVar).First_Name__c || 
                    mapLeadsLastName.get(lstErrors.get(lstVar).Email__c)!=lstErrors.get(lstVar).Last_Name__c || 
                    mapLeadsLinkedInId.get(lstErrors.get(lstVar).Email__c)!= lstErrors.get(lstVar).LinkedIn_Id__c || 
                    mapLeadsProfileURL.get(lstErrors.get(lstVar).Email__c)!=lstErrors.get(lstVar).Profile_URL__c || mapLeadsCompany.get(lstErrors.get(lstVar).Email__c)!=lstErrors.get(lstVar).Company__c 
                    || mapLeadsPosition.get(lstErrors.get(lstVar).Email__c)!=lstErrors.get(lstVar).Current_Position__c)) {
                // Removing the successfully updated error records,whose Leads got updated successfully, from the Error Set  **/                 
                errorIdSet.remove(lstErrors.get(lstVar).id);
                lstVar++;
            } else {
                lstVar++;
            }
        }
        
        // Implemeting logic for re-inserting error records **/
        for (Candidate_Import_Error__c objError: lstErrors) {
            // Checking if the Error Record's Email which is updated, is still existing in any of the Lead Record's Email  **/
            if (setLeadEmails.contains(objError.Email__c) ) {
                Candidate_Import_Error__c objErr = new Candidate_Import_Error__c();
                objErr.First_Name__c = objError.First_Name__c;
                objErr.Last_Name__c = objError.Last_Name__c;
                objErr.Email__c = objError.Email__c;
                objErr.Profile_URL__c = objError.Profile_URL__c;
                objErr.LinkedIn_Id__c = objError.LinkedIn_Id__c;
                objErr.Location__c = objError.Location__c;
                objErr.Industry__c = objError.Industry__c;
                objErr.of_Connections__c = objError.of_Connections__c;
                objErr.Summary__c = objError.Summary__c;
                objErr.Skills__c = objError.Skills__c;
                objErr.Languages__c = objError.Languages__c;
                objErr.Interests__c = objError.Interests__c;
                objErr.Current_Company_Domain__c = objError.Current_Company_Domain__c;
                objErr.Phone__c = objError.Phone__c;
                objErr.IM__c = objError.IM__c;
                objErr.Twitter__c = objError.Twitter__c;
                objErr.Project__c = objError.Project__c;
                objErr.Description__c = objError.Description__c;
                objErr.Groups__c = objError.Groups__c;
                objErr.Persons_In_Common__c = objError.Persons_In_Common__c;
                objErr.Error_Encountered__c = Duplicate_Email;
                objErr.Company__c = objError.Company__c;
                objErr.Current_Position__c = objError.Current_Position__c;
                objErr.Education_Details__c = objError.Education_Details__c;
                objErr.Previous_Companies__c = objError.Previous_Companies__c;
                objErr.Activity_Details__c = objError.Activity_Details__c;
                objErr.owner_id__c = selectedValue;
                objErr.Lead_Source__c = objError.Lead_Source__c;
                failCtr += 1;
                showUpdate = true;
            } else {
                // Creating a Lead Record if the Error Record's Email is unique **/
                Lead objLead = new Lead();
                objLead.FirstName = objError.First_Name__c;
                objLead.LastName = objError.Last_Name__c;
                objLead.Profile_URL__c = objError.Profile_URL__c;
                objLead.Linkedin_Id__c = objError.LinkedIn_Id__c;
                objLead.Company = objError.Company__c;
                objLead.Location__c = objError.Location__c;
                objLead.Email = objError.Email__c;
                objLead.Current_Position__c = objError.Current_Position__c;
                objLead.Industry__c = objError.Industry__c;
                objLead.of_Connections__c = objError.of_Connections__c;
                objLead.Summary__c = objError.Summary__c;
                objLead.Skills__c = objError.Skills__c;
                objLead.Languages__c = objError.Languages__c;
                objLead.Interests__c = objError.Interests__c;
                objLead.Current_Company_Domain__c = objError.Current_Company_Domain__c;
                objLead.Phone = objError.Phone__c;
                objLead.IM__c = objError.IM__c;
                objLead.Twitter__c = objError.Twitter__c;
                objLead.Project__c = objError.Project__c;
                objLead.Description = objError.Description__c;
                objLead.Groups__c = objError.Groups__c;
                objLead.Persons_In_Common__c = objError.Persons_In_Common__c;
                objLead.LeadSource = objError.Lead_Source__c;
                objLead.Status = CANDIDATE_QUALIFIED;
                objLead.recordTypeId = CandidateRecTypeId;
                objLead.OwnerId = selectedValue;
                objLead.Education_Details__c = objError.Education_Details__c;
                objLead.Company__c = objError.Previous_Companies__c;
                objLead.Activity_Details__c = objError.Activity_Details__c;
                lstLeadsIns.add(objLead);
            }
        }

        if (!lstLeadsIns.isempty()) {
            List < Database.SaveResult > saveResults = Database.insert(lstLeadsIns, false);
            for (Integer i = 0; i < saveResults.size(); i++) {
                if (saveResults.get(i).isSuccess() == true) {
                    successCtr += 1;
                } else {
                    Database.Error error = saveResults.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    lstLeadsIns.get(i); //failed record from the list
                    Candidate_Import_Error__c objError = createErrorRecord(lstLeadsIns.get(i),failedDML);
                    objError.Owner_Id__c = lstLeadsIns.get(i).ownerid;
                    lstErrorsTmp.add(objError);
                    failCtr += 1;
                }
            }
        }
        set<id> setErrorRecIds = new Set<id>();
        for(Candidate_Import_Error__c objCandidateEr:lstErrorsTmp)
            setErrorRecIds.add(objCandidateEr.id);
        Integer totalCtr = successCtr+updCtr;
        strSuccessMsg = totalCtr+' records has been inserted/updated out of '+totalRecords+' records into the Lead Object as Sourcing Candidates';
        showMsg = true;
        lstVar=0;
        List<Candidate_Import_Error__c> lstErrorTemp = lstErrors;
        while (lstVar < lstErrors.size()) {
            // Removing the Error Records for which new Lead has been created in the system  **/
            if (mapLeadsEmail.get(lstErrors.get(lstVar).Email__c) == null &&  !(setErrorRecIds.contains(lstErrors.get(lstVar).id))) {
                errorIdSet.remove(lstErrors.get(lstVar).id);
                lstVar++;
            } else {
                lstVar++;
            }
        }
        if (!(lstErrorsTmp.isEmpty())) {
            List < String > lstErrormail = new List < String > ();
            for (Candidate_Import_Error__c objCandErr: lstErrorsTmp) {
                lstErrormail.add(objCandErr.Email__c);
            }
            List < Candidate_Import_Error__c > lstErrorsExisting = [select id from Candidate_Import_Error__c where Email__c in : lstErrormail];
            if (!lstErrorsExisting.isempty())
                delete lstErrorsExisting;
                         
            insert lstErrorsTmp;
            for(Candidate_Import_Error__c obj : lstErrorsTmp) {
                errorIdSet.add(obj.id);
            }
            showErrors = true;
            showErrorRecords = true;
            showUpdate = true;
        }
        showErrors = true;
        showErrorRecords = true;
        showUpdate = true;
        tempErrorList = new List<Candidate_Import_Error__c>([SELECT First_Name__c,Last_Name__c,Email__c,Profile_URL__c,LinkedIn_Id__c,Error_Encountered__c,Company__c,Current_Position__c, 
                                    Industry__c,of_Connections__c,Summary__c,Skills__c,Languages__c,Interests__c,Current_Company_Domain__c,Phone__c,IM__c,Twitter__c,Project__c,Description__c,
                                    Education_Details__c,Previous_Companies__c,Activity_Details__c,Groups__c,Persons_In_Common__c,Location__c,Owner_Id__c,Lead_Source__c  FROM 
                                    Candidate_Import_Error__c where ID IN :errorIdSet order by lastModifieddate desc]);
        this.setCon = new ApexPages.StandardSetController(tempErrorList);
        this.setCon.setpageNumber(1);
        this.setCon.setPageSize(5);
        // Reinitializing the map so that successfully inserted or updated Error Records don't get displayed in the table again **/
        errorMapFromCurrentPage = new Map<id,Candidate_Import_Error__c>();
    }
    
    /*******************************************************************
    Purpose: Method to go to the next page
    Parameters: NA
    Returns: Pagereference
    Throws [Exceptions]: NA
    ********************************************************************/
    public Pagereference doNext(){
        showMsg = false;
        if(this.setCon.getHasNext()){
            // Save current page
            this.setCon.save();
            List<Candidate_Import_Error__c> ErrorListFromCurrentPageTmp = (List<Candidate_Import_Error__c>)this.setCon.getRecords();
            for(Candidate_Import_Error__c objCandErr:ErrorListFromCurrentPageTmp) {
                errorMapFromCurrentPage.put(objCandErr.id,objCandErr);
            }
            // Return Reference of next page
            this.setCon.next();
        }
        return null;
    }
    
    /*******************************************************************
    Purpose:  Method to go to the previous page
    Parameters: NA
    Returns: Pagereference
    Throws [Exceptions]: NA
    ********************************************************************/
    public Pagereference doPrevious() {
        showMsg=false;
        if(this.setCon.getHasPrevious()){
            // Save current page
            this.setCon.save();
            List<Candidate_Import_Error__c> ErrorListFromCurrentPageTmp = (List<Candidate_Import_Error__c>)this.setCon.getRecords();
            for(Candidate_Import_Error__c objCandErr:ErrorListFromCurrentPageTmp){
                errorMapFromCurrentPage.put(objCandErr.id,objCandErr);
            }
            // Return Reference of previous page
            this.setCon.previous();
        }
        return null;
    }
    
    /*******************************************************************
    Purpose: Method to go to the first page
    Parameters: NA
    Returns: Pagereference
    Throws [Exceptions]: NA
    ********************************************************************/
    public Pagereference doFirst(){
        showMsg=false;
        // Save current page
        this.setCon.save();
        List<Candidate_Import_Error__c> ErrorListFromCurrentPageTmp = (List<Candidate_Import_Error__c>)this.setCon.getRecords();
        for(Candidate_Import_Error__c objCandErr:ErrorListFromCurrentPageTmp){
           errorMapFromCurrentPage.put(objCandErr.id,objCandErr);
        }
        // Return Reference of First page
        this.setCon.first();
        return null;
    }
    
    /*******************************************************************
    Purpose:  Method to go to the last page
    Parameters: NA
    Returns: Pagereference
    Throws [Exceptions]: NA
    ********************************************************************/
    public Pagereference doLast(){
        showMsg=false;
        // Save current page
        this.setCon.save();
        List<Candidate_Import_Error__c> ErrorListFromCurrentPageTmp = (List<Candidate_Import_Error__c>)this.setCon.getRecords();
        for(Candidate_Import_Error__c objCandErr:ErrorListFromCurrentPageTmp){
            errorMapFromCurrentPage.put(objCandErr.id,objCandErr);
        }
        // Return Reference of last page
        this.setCon.last();
        return null;
    }

    /*******************************************************************
    Purpose:  Method to find whether previous page exists or not
    Parameters: NA
    Returns: boolean
    Throws [Exceptions]: NA
    ********************************************************************/
    public Boolean getHasPrevious() {
        // Check previous page exist or not
        return this.setCon.getHasPrevious();
    }
    
    /*******************************************************************
    Purpose: Method to find whether next page exists or not
    Parameters: NA
    Returns: boolean
    Throws [Exceptions]: NA
    ********************************************************************/
    public Boolean getHasNext(){
        // Check next page exist or not
        return this.setCon.getHasNext();
    }
    
    /*******************************************************************
    Purpose: Method to find the current page number
    Parameters: NA
    Returns: Integer
    Throws [Exceptions]: NA
    ********************************************************************/
    public Integer getPageNumber(){
        // Get Current Page 
        return this.setCon.getPageNumber();  
    }

    /*******************************************************************
    Purpose: Method to find the total number of pages
    Parameters: NA
    Returns: Integer
    Throws [Exceptions]: NA
    ********************************************************************/
    public Integer getTotalPages(){
        // Get Total Number of pages
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
        Decimal pages = totalSize/pageSize;
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
    
    /*******************************************************************
    Purpose: Method to process the Profile URL and break it in case its length is more than 40  
    Parameters: String
    Returns: String
    Throws [Exceptions]: NA
    ********************************************************************/
    public String parseProfileURL(String strProfileURL){
        String strProfileURLFinal='';
        // If length is greater than 40
        if(strProfileURL!=null && strProfileURL.length()>40){
            for(Integer i=0;i<strProfileURL.length();i++){
                if(math.mod(i,40)==0 && i>0)  
                    strProfileURLFinal = strProfileURLFinal +NEWLINE;
                else
                    strProfileURLFinal = strProfileURLFinal+ String.fromCharArray(new List<Integer>{strProfileURL.charAt(i)});                             
            } 
        } else
            strProfileURLFinal= strProfileURL;
      return strProfileURLFinal;
    }
  
    /*******************************************************************
    Purpose: Method to create an Error Record for Lead which was inserted or updated unsuccessfully  
    Parameters: Lead,String
    Returns: Candidate_Import_Error__c
    Throws [Exceptions]: NA
    ********************************************************************/
    public Candidate_Import_Error__c createErrorRecord(Lead objLead,String failedDML) {
        // Initiate Error Object & assign the values
        Candidate_Import_Error__c objError = new Candidate_Import_Error__c();
        objError.First_Name__c = objLead.FirstName;
        objError.Last_Name__c = objLead.LastName;
        objError.Email__c = objLead.Email;
        objError.Profile_URL__c = objLead.Profile_URL__c;
        objError.LinkedIn_Id__c = objLead.LinkedIn_Id__c;
        objError.Error_Encountered__c = failedDML;
        objError.Company__c = objLead.Company;
        objError.Current_Position__c = objLead.Current_Position__c;
        objError.Industry__c = objLead.Industry__c;
        objError.of_Connections__c = objLead.of_Connections__c;
        objError.Summary__c = objLead.Summary__c;
        objError.Skills__c = objLead.Skills__c;
        objError.Languages__c = objLead.Languages__c;
        objError.Interests__c = objLead.Interests__c;
        objError.Current_Company_Domain__c = objLead.Current_Company_Domain__c;
        objError.Phone__c = objLead.Phone;
        objError.IM__c = objLead.IM__c;
        objError.Twitter__c = objLead.Twitter__c;
        objError.Project__c = objLead.Project__c;
        objError.Description__c = objLead.Description;
        objError.Education_Details__c = objLead.Education_Details__c;
        objError.Previous_Companies__c = objLead.Company__c;
        objError.Activity_Details__c = objLead.Activity_Details__c;
        objError.Groups__c = objLead.Groups__c;
        objError.Persons_In_Common__c = objLead.Persons_In_Common__c;
        objError.Lead_Source__c = objLead.LeadSource; 
        // Return Error Object
        return objError;
    }
}