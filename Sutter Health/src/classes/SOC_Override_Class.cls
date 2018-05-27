public with sharing class SOC_Override_Class {

    public String providerFirstName {get; set;}
    public String providerLastName {get; set;}
    public String providerNPI {get; set;}
    public String providerEmPID {get; set;}
    public String faciltyID {get; set;}
    public String facilityName {get; set;}
    public String providerId {get; set;}
    List<Contact> providerResults;
    List<PDV_EAF_Facility__c> faciltyResults;
    static final String PROVIDER_SELECT = 'Select Id, (Select Id, OwnerId, status__c, owner.name from SOC_Queues__r), LastName, Provider_ID__c, Provider_Title__c, FirstName, Contact_Middle_Name__c, Provider_Name_Suffix__c, Phone, ' + 
        'Provider_NPI__c, Provider_Correspondence_Address__c, Provider_Correspondence_City__c, Provider_Correspondence_State__c, ' +
        'Provider_Correspondence_PostalCode__c, Provider_License_Number__c, Provider_License_State__c, Provider_Specialty__c, ServiceTabLabel__c, ' +
        'Gender__c, Email From Contact where RecordTypeId = \'';
    static final String PROVIDER_FIRSTNAME_API = ' AND FirstName like \'';
    static final String PROVIDER_LASTNAME_API = ' AND LastName like \'';
    static final String PROVIDER_EMPID_API = ' AND Emp_Id__c like \'';
    static final String PROVIDER_NPI_API = ' AND Provider_NPI__c = \'';
    static final String PROVIDER_ID_API = ' AND Provider_ID__c = \'';
    
    static final String FACILITY_NAME_API = ' AND Name like \'';
    static final String FACILITY_ID_API = ' AND Facility_ID__c like \'';
    
    public String searchQuery {get; set;}
    
    static final String MULTI_STRING = ' AND '; 
    static final String ENDING_STRING = '\'';
    static final String ENDING_WILDCARD_STRING = '%\'';
    static final String LESS_EQUAL_STRING = ' <= ';
    static final String GREATER_EQUAL_STRING = ' >= ';
    
    static Boolean isGoodValue = true;
    static Boolean isSearchValues = true;

    public boolean showProviderResults {get; set;}
    public string providerType {get;set;}
    public transient List<ContactSOCWrapper> conWrapList {get; set;}
    public transient List<FacilitySOCWrapper> facilityWrapList {get; set;}
    private static final String QUEUE_ID_PREFIX = '00G';
    
    public SOC_Override_Class(){
        try {
        		providerFirstName = '';
			    providerLastName = '';
			    providerNPI = '';
			    providerEmPID = '';
			    faciltyID = '';
			    facilityName = '';
			    providerId = '';
                
                providerType = 'SER';
                showProviderResults = false;
                providerResults = new List<Contact>();
                faciltyResults = new List<PDV_EAF_Facility__c>();
                conWrapList = new List<ContactSOCWrapper>();
                facilityWrapList = new List<FacilitySOCWrapper>();
                                             
        }catch(Exception classException) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
         }                    
    }
    
    //
    public void SearchProvider() {
        providerResults.clear();
        conWrapList = new List<ContactSOCWrapper>();
        facilityWrapList = new List<FacilitySOCWrapper>();
        //conWrapList.clear();
        faciltyResults.clear();
        //facilityWrapList.clear();
        showProviderResults = false;
        if((isValue(providerFirstName)) || (isValue(providerLastName)) || 
                                                        (isValue(providerNPI)) || (isValue(providerEmPID)) || (isValue(providerId)) ) {
            
            try {
                
                if(providerFirstName.length() == 1 || providerLastName.length() == 1 || providerNPI.length() == 1
                                                                                        || providerEmPID.length() == 1 || providerId.length() == 1){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL18_NoCorrectChar));
                        isSearchValues = false;
                }
                else{
                        providerResults = getSearchResults(getProviderSearchQuery());   
                }
                
                if(!providerResults.isEmpty()){
                        for(Contact con : providerResults){
                                
                                if(!con.SOC_Queues__r.isEmpty()){
                                        for(SOC_Queue__c soc : con.SOC_Queues__r){
                                                if(String.valueOf(soc.OwnerId).subString(0,3) == QUEUE_ID_PREFIX){
                                                        conWrapList.add(new ContactSOCWrapper(con, 'In Queue', soc));
                                                }
                                                else{
                                                        conWrapList.add(new ContactSOCWrapper(con, 'Accepted', soc));
                                                }
                                        }
                                }
                                else{
                                        conWrapList.add(new ContactSOCWrapper(con, '', null));
                                }
                        }
                        isSearchValues = false;
                }
                    
            } catch(Exception classException) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }   
        } else if((isValue(faciltyID)) || (isValue(facilityName)) ) {
                if(faciltyID.length() == 1 || facilityName.length() == 1 ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL18_NoCorrectChar));
                isSearchValues = false;
            }
            else{
                faciltyResults = getSearchResults(getFaciltySearchQuery());   
            }
                        
            if(!faciltyResults.isEmpty()){
	            for(PDV_EAF_Facility__c facility : faciltyResults){
	            
		            if(!facility.SOC_Queues__r.isEmpty()){
                        for(SOC_Queue__c soc : facility.SOC_Queues__r){
                                
                            if(String.valueOf(soc.OwnerId).subString(0,3) == QUEUE_ID_PREFIX){
                                facilityWrapList.add(new FacilitySOCWrapper(facility, 'In Queue', soc));
                            }
                            else{
                                facilityWrapList.add(new FacilitySOCWrapper(facility, 'Accepted', soc));
                            }
                        }
		            }else{
	                    facilityWrapList.add(new FacilitySOCWrapper(facility, '', null));
		            }
	            }
	            isSearchValues = false;
            }
        }
        
        boolean resultFlag = false;
        if(providerType == 'EAF') {
                resultFlag = isValidSearch(faciltyResults);
        } else if(providerType == 'SER') {
                resultFlag =  isValidSearch(providerResults);
        }
        
        if(resultFlag) {
        
            if(providerResults.size()>0)
            {
                showProviderResults = true;
            } 
            else if(faciltyResults.size()>0) {
                showProviderResults = true;
            } 
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No Provider/Facility found !!!'));
            }
        }
    }
    
    //
    public String getProviderSearchQuery() {
        
        Id recordtypeId;
        
        try {
            recordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId(); 
           
        
        } catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));    
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        
        searchQuery = PROVIDER_SELECT + recordtypeId + ENDING_STRING;
        if(isValue(providerFirstName)) { searchQuery += PROVIDER_FIRSTNAME_API + String.escapeSingleQuotes(providerFirstName) + ENDING_WILDCARD_STRING;}
        if(isValue(providerLastName)) { searchQuery += PROVIDER_LASTNAME_API + String.escapeSingleQuotes(providerLastName) + ENDING_WILDCARD_STRING;}
        if(isValue(providerEmPID)) { searchQuery += PROVIDER_EMPID_API + String.escapeSingleQuotes(providerEmPID) + ENDING_WILDCARD_STRING;}
        if(isValue(providerNPI)) { searchQuery += PROVIDER_NPI_API + String.escapeSingleQuotes(providerNPI) + ENDING_STRING;} 
        if(isValue(providerId)) { searchQuery += PROVIDER_ID_API + String.escapeSingleQuotes(providerId) + ENDING_STRING;}        
        return searchQuery +' ORDER BY LastName, FirstName limit 100'; 
    }
    
    public String getFaciltySearchQuery() {
        string strQuery = 'Select ZIP_CODE__c, (Select Id, OwnerId, owner.name,status__c from SOC_Queues__r), STATE__c, Emp_Id__c, PHONE__c, Name, Last_Verified_date__c, Facility_ID__c, FAX_NUMBER__c, CITY__c, ADDRESS__c From PDV_EAF_Facility__c ';
        strQuery = strQuery + 'where Name != null ';
        if(isValue(faciltyID)) {
                strQuery = strQuery + FACILITY_ID_API + String.escapeSingleQuotes(faciltyID) + ENDING_WILDCARD_STRING;
        } 
        if(isValue(facilityName)) {
                strQuery = strQuery + FACILITY_NAME_API + String.escapeSingleQuotes(facilityName) + ENDING_WILDCARD_STRING;
        }
        return strQuery +' ORDER BY Name limit 100';
    }
    
    
    //
    public List<SObject> getSearchResults(String search) {
       
        List<SObject> returnList;
        try {
            returnList = Database.query(search);
        } catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }
        return returnList;
    }
    
    public void onProviderTypeChange() {
    	conWrapList = new List<ContactSOCWrapper>();
    	facilityWrapList = new List<FacilitySOCWrapper>();
    	showProviderResults = false;
        if(providerType == 'EAF') {
                providerFirstName = '';
                providerLastName = '';
                providerNPI = '';
                providerEmPID = '';
                faciltyID = '';
                facilityName = '';
        } else if(providerType == 'SER'){
                providerFirstName = '';
                providerLastName = '';
                providerNPI = '';
                providerEmPID = '';
                faciltyID = '';
                facilityName = '';
        }
    }
    
    //
    public Boolean isValidSearch(List<Sobject> checkList) {
        Boolean returnBoolean = true;
        if(checkList == null || checkList.isEmpty() || checkList.size() < 1 ){
            returnBoolean = false;
        
            if(isSearchValues) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL17_NoResult));
            }else {
                if(!isGoodValue) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL18_NoCorrectChar));
                }
            }
        } 
    
        return returnBoolean;
    }
    
    //
    public Boolean isValue(String checkString) {
    
        Boolean returnValue = false;
        
        if(checkString != null && checkString != '') {
            returnValue = true;
        }
        return returnValue;
    }
        
        public class ContactSOCWrapper{
                
            public Contact socContact {get; set;}
            public String socOwner {get; set;}
            public SOC_Queue__c conSoc {get;set;}
            
            public ContactSOCWrapper(Contact con, String ownerName, SOC_Queue__c soc){
                    
                socContact = con;
                socOwner = ownerName;
                conSoc = soc;
            }
        }
        
        public class FacilitySOCWrapper{
                
            public PDV_EAF_Facility__c socFacility {get; set;}
            public String socFacOwner {get; set;}
            public SOC_Queue__c facSoc {get; set;}
            
            public FacilitySOCWrapper(PDV_EAF_Facility__c facility, String ownerName, SOC_Queue__c soc){
                    
                socFacility = facility;
                socFacOwner = ownerName;
                facSoc = soc;
            }
        }
        
}