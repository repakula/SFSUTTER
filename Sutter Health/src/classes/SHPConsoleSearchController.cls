/**  
*     Class Name  : SHPConsoleSearchController 
*     Author      : IDC Offshore
*     Date        : 08-Sept-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description : This controller class is used to search the record from Member(Contact) and claim(claim header). 
**/

public class SHPConsoleSearchController {

    public string searches{get; set;}
    public List<selectOption> searchTypes = new List<selectOption>();
    
    /*
    *   @Description: This method takes first 2 select option value.
    */
    public List<selectOption> getsearchTypes()
    {
        if(searchTypes.size()>2)
        {
            searchTypes.clear();
        }
        if(searchTypes.size()<2)
        {
            searchTypes.add(new SelectOption('Member', 'Member'));
            searchTypes.add(new SelectOption('Claim', 'Claim'));
        }
        return searchTypes;
    }
    
    static Boolean isSearchValues = true;
    static Boolean isGoodValue = true;
    public String searchQuery {get; set;}
    
    private Map<string, string> contactRecordTypeMap = new Map<string, string>();
    
    public String memberID {get; set;} 
    public String memberFirstName {get; set;}
    public String memberLastName {get; set;}
    public String memberContactNumber {get; set;} 
    public Case memberDOB = new Case();
    public List<Contact> memberResults {get; set;}
    static final String MEMBER_SELECT = 'Select Id, Name, Phone, Member_HCC_ID__c, Member_ID__c, Member_Subscriber_Relationship__c, MemberIdField__c ,Member_Name_Prefix__c, FirstName, '+ 
        'Contact_SSN_E__c, Contact_Middle_Name__c, LastName, Member_Name_Suffix__c, MailingStreet, MailingCity, MailingState, ' + 
        'MailingPostalCode, Birthdate, Member_Plan_Name__c, ServiceTabLabel__c From Contact where RecordTypeId = \'';
    static final String MEMBER_ID_API = ' AND MemberIdField__c'; 
    static final String MEMBER_HCC_ID_API = ' AND Member_HCC_ID__c'; 
    static final String MEMBER_FIRSTNAME_API = ' AND FirstName like \'';
    static final String MEMBER_LASTNAME_API = ' AND LastName like \'';
    static final String MEMBER_CONTACT_NUMBER_API = ' AND Phone = \'';
    static final String MEMBER_DOB_API = ' AND Birthdate = ';
    
    public String claimID {get; set;} 
    public String claimMemberID {get; set;}
    public String claimProviderID {get; set;}
    public Case claimSearchStartDate = new Case();
    public Case claimSearchEndDate = new Case();
    public List<Claim_Header__c> claimResults {get; set;}
    static final String CLAIM_SELECT = 'Select ID, SHPClaimHdr_Claim_HCC_ID__c, ClaimMemberIdField__c, SHPClaimHdr_Member_HCC_ID__c, SHPClaimHdr_Claim_DoS_Start__c, ' +
        'SHPClaimHdr_Claim_DoS_End__c, SHPClaimHdr_Claim_Date_of_Receipt__c, SHPClaimHdr_Procedure_Code_E__c,  SHPClaimHdr_Procedure_Code_Description_E__c, ' +
        'SHPClaimHdr_Diagnosis_Code_E__c, SHPClaimHdr_Diagnosis_Code_Description_E__c, SHPClaimHdr_Supplier_HCC_ID__c From Claim_Header__c where ';
    static final String CLAIM_ID_API = 'SHPClaimHdr_Claim_HCC_ID__c = \'';
    static final String CLAIM_MEMBER_ID_API = 'ClaimMemberIdField__c = \''; 
    static final String CLAIM_PROVIDER_ID_API = 'SHPClaimHdr_Supplier_HCC_ID__c = \'';
    static final String CLAIM_START_DATE_API = 'SHPClaimHdr_Claim_DoS_Start__c';
    
    static final String MULTI_STRING = ' AND '; 
    static final String ENDING_STRING = '\'';
    static final String ENDING_WILDCARD_STRING = '%\'';
    static final String LESS_EQUAL_STRING = ' <= ';
    static final String GREATER_EQUAL_STRING = ' >= ';
    
    /*
    *   @Description: This method put RecordType id and name into the Map
    */
        
    private void setRecordTypeMaps()
    {
        for(RecordType rec: [select Id, Name from RecordType where sObjectType = 'Contact'])
        {
            contactRecordTypeMap.put(rec.Name, rec.Id);
        }
    }
    
    /*
    *   @Description: This Constructor initialize Contact and Claim header and putting record type name and id in map
    */
    
    public SHPConsoleSearchController()
    {
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        setRecordTypeMaps();
        memberResults = new List<Contact>();
        claimResults = new List<Claim_Header__c>();
                
    }
    
    /*
    *   @Description: This method search member on the parameters MemberID,Member First Name and Member Last Name and validating Member ID length as well
    *
    */
 
     public void SearchMember() {
        if(memberResults!=null)    
        memberResults.clear();
        if((isValue(memberID))|| (isValue(memberFirstName)) || (isValue(memberLastName)) 
            ||(isValue(memberContactNumber))||(isValue(String.valueOf(memberDOB.SearchDate__c)))) {
                                
            try {
                memberResults = getSearchResults(getMemberSearchQuery());
                
            } catch(Exception classException) { 
                
                Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }
        } else{ 
             
            isSearchValues = false; 
            
        }
        
        searchTypes.clear();
        if(isValidSearch(memberResults)) {
        
             searchTypes.add(new SelectOption('MemberSearch','MemberSearch'));
             Searches = 'MemberSearch';
        }
        resetParameters();
    }
    
    /*
    *   @Description: In this method we are querying on Contact for Member.
    */
     private String getMemberSearchQuery() {
        
        Id recordtypeId;
        
        try {
            recordtypeId = contactRecordTypeMap.get(system.label.CL08_Member);
        
        } catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));            
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
          
        searchQuery =  MEMBER_SELECT + recordtypeId + ENDING_STRING;
        
        if(isValue(memberID)) { 
            if(memberID.endsWith('*')) {
            	memberID = 'M'+memberID.removeEnd('*')+'-';
                searchQuery += MEMBER_HCC_ID_API +  ' like \'' +String.escapeSingleQuotes(memberID) + ENDING_WILDCARD_STRING;
            } else {        
                searchQuery += MEMBER_ID_API +  ' = \'' + String.escapeSingleQuotes(memberID) + ENDING_STRING;
            }      
        }
            
        if(isValue(memberFirstName)) { searchQuery += MEMBER_FIRSTNAME_API + String.escapeSingleQuotes(memberFirstName) + ENDING_WILDCARD_STRING;} 
        if(isValue(memberLastName)) { searchQuery += MEMBER_LASTNAME_API + String.escapeSingleQuotes(memberLastName) + ENDING_WILDCARD_STRING;}  
        if(isValue(memberContactNumber)) {  searchQuery += MEMBER_CONTACT_NUMBER_API + String.escapeSingleQuotes(memberContactNumber) + ENDING_STRING;}
        if(isDate(memberDOB.SearchDate__c)) {  searchQuery += MEMBER_DOB_API + String.escapeSingleQuotes(formatDate(memberDOB.SearchDate__c));}
        
        return searchQuery +' ORDER BY LastName, FirstName limit 200'; 
    }
    
    /*
    *   @Description: This Method search claim header on these parameter claimID,claimMemberID,claimProviderID and validating claimMemberID length as well. 
    */
    
     public void SearchClaim() {
        if(claimResults!=null)
        claimResults.clear();
        if((isValue(claimID)) || ((isValue(claimMemberID)) && (claimMemberID.length() == 10)) || (isValue(claimProviderID)) || 
            (isValue(String.valueOf(claimSearchStartDate.SearchDate__c))) || (isValue(String.valueOf(claimSearchEndDate.SearchDate__c)))) {
            
            try {
                
                claimResults = getSearchResults(getClaimSearchQuery());   
            
            } catch(Exception classException) { 
                
                Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            }   
        } else{ 
        
            isSearchValues = false; 
            
            if((isValue(claimMemberID)) && !(claimMemberID.length() == 10)) {
                isGoodValue = false;
            }
        }
        searchTypes.clear();
        if(isValidSearch(claimResults)) {
        
            searchTypes.add(new SelectOption('ClaimSearch','ClaimSearch'));
            Searches = 'ClaimSearch';
        } 
       
        resetParameters();
    }
    
    /*
    *   @Description: In this Method ,We are querying on Claim Header.
    */
    private String getClaimSearchQuery() {
        
        searchQuery = CLAIM_SELECT;
        if(isValue(claimID)) { searchQuery += CLAIM_ID_API + String.escapeSingleQuotes(claimID) + ENDING_STRING;}
        if((isValue(claimID)) &&  (isValue(claimMemberID))) {searchQuery += MULTI_STRING;}
        if(isValue(claimMemberID)) {searchQuery += CLAIM_MEMBER_ID_API + String.escapeSingleQuotes(claimMemberID) + ENDING_STRING;}  
        if((isValue(claimProviderID)) && ((isValue(claimMemberID)) || (isValue(claimID)))) {searchQuery += MULTI_STRING;}
        if(isValue(claimProviderID)) {  searchQuery += CLAIM_PROVIDER_ID_API + String.escapeSingleQuotes(claimProviderID) + ENDING_STRING;}
        if(claimSearchStartDate.SearchDate__c != null || claimSearchEndDate.SearchDate__c != null ) {
            if((isValidDateRange(claimSearchStartDate.SearchDate__c, claimSearchEndDate.SearchDate__c)) && 
                ((isValue(claimProviderID)) || (isValue(claimMemberID)) || (isValue(claimID)))) {searchQuery += MULTI_STRING;}
            if(isValidDateRange(claimSearchStartDate.SearchDate__c, claimSearchEndDate.SearchDate__c)) {  
                searchQuery += CLAIM_START_DATE_API + GREATER_EQUAL_STRING + formatDate(claimSearchStartDate.SearchDate__c) + MULTI_STRING + 
                                   CLAIM_START_DATE_API + LESS_EQUAL_STRING + formatDate(claimSearchEndDate.SearchDate__c);
            }
        }
        return searchQuery +' ORDER BY SHPClaimHdr_Claim_HCC_ID__c limit 200'; 
    }
    
    /**
    * @author IDC Team
    * @date 08/09/2013
    * @description This method is used by all the Seach Methods to query the search string passed to it and returns the queried list of sobjects
    * @param String search
    * @return List<sObject> returnList
    */

    
     private List<SObject> getSearchResults(String search)
    {
        system.debug(search);
        List<SObject> returnList;
        try{
            returnList = Database.query(search);
     
        } catch (Exception classException){ 
                 Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');

            }
        return returnList;
    }
    
    /**
    * @author IDC Team
    * @date 15/08/2013
    * @description This method is a utility method used wherever the code needs to convert a Date type to String.
    * it takes in date as the argument and returns String
    * @param Date inputDate
    * @return return String
    */
    
     private static String formatDate(Date inputDate) {
        return String.valueOf(inputDate).substringBefore(' ');       
    }
    
    /*
    *   @Description: This method return claimSearchStartDate
    *    @return return sobject Case
    */
    public Case getClaimSearchStartDate() {
        return claimSearchStartDate;
    }
    
    /*
    *   @Description: This method return memberDOB
    *    @return return sobject Case
    */
    
    public case getMemberDOB() {
        return memberDOB;
    }
    
    /*
    *  @Description: This method return memberDOB
    *  @return return sobject Case
    */    
    public Case getClaimSearchEndDate() {
        
        if(claimSearchEndDate.SearchDate__c == null && claimSearchStartDate.SearchDate__c != null) {
            claimSearchEndDate.SearchDate__c = claimSearchStartDate.SearchDate__c;
        }
        return claimSearchEndDate;
    }
   
    /**
    * @author IDC Team
    * @date 08/09/2013
    * @description This method is a utility method used wherever the code needs to check if a particular string is empty or not.
    * This method returns true if the value is not null or empty else returns false
    * @param String checkString
    * @return Boolean returnValue
    */

    private Boolean isValue(String checkString) {
    
        Boolean returnValue = false;
        
        if(checkString != null && checkString != '') {
            returnValue = true;
        }
        return returnValue;
    }
   
    
    /**
    * @author IDC Team
    * @date 08/09/2013
    * @description This method is a utility method used wherever the code needs to check if the Search is a valid search or not.
    * It takes list of sObjects as argument and checks if the list is empty, null or its size is less than 1. 
    * If the value entered in the search field does not return any results, it shows message "No results found".
    * If the values put in are not valid values it returns "Your search did not contain the correct number of characters to perform this search".
    * If no values are entered in the search field it returns "You must enter values to search"
    * @param List of sObjects checkList
    * @return Boolean returnBoolean
    */   
     Private Boolean isValidSearch(List<Sobject> checkList) {
        Boolean returnBoolean = true;
        if(checkList == null || checkList.isEmpty() || checkList.size() < 1 ){
            returnBoolean = false;
        
            if(isSearchValues) {
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL17_NoResult));
            }else {
            
                if(!isGoodValue) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL18_NoCorrectChar));
                } else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL19_EnterValue));
                }
            }
        } 
    
        return returnBoolean;
    }
    
     /**
    * @author IDC Team
    * @date 08/09/2013
    * @description This method is a utility method used wherever the code needs to check if the date entered is null or not
    * it takes Date as argument and returns boolean
    * @param Date checkDate
    * @return return returnValue
    */
  
     private Boolean isDate(Date checkDate) {
    
        Boolean returnValue = false;
        
        if(checkDate != null) {
            
            returnValue = true;
        }
        return returnValue;
    }
    
     /**
    * @author IDC Team
    * @date 08/09/2013
    * @description This method is a utility method used wherever the code needs to check if the date entered is null or not
    * it takes Date as argument and returns boolean
    * @param Date checkDate
    * @return return returnValue
    */

     private Boolean isValidDateRange(Date startDate, Date endDate) {
    
        Boolean returnValue = false;
        
        if((String.valueOf(startDate) != null && String.valueOf(startDate) != '') && (String.valueOf(endDate) != null && String.valueOf(endDate) != '')){
            if(startDate <= endDate) {
                returnValue = true;
            } else {
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL20_EndDateValidation));
            }
            
        } else {
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL21_DateValidation));
        }
        return returnValue;
    }
    
    /*
    *  @Description: This method reseting the values of all variables
    */
    Private void resetParameters()
    {
        memberID = null;
        memberFirstName = null;
        memberLastName = null;
        memberContactNumber = null;
        memberDOB.clear();
        claimID = null;
        claimMemberID = null;
        claimProviderID = null;
        claimSearchStartDate.clear();
        claimSearchEndDate.clear();
        searchQuery = null;
    }

}