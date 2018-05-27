/**  
*    Class Name: VFC41_Provider_List_Controller
*    Author: IDC Offshore
*    Date: 8-July-2015
*    Description: Controller for VFP41_Provider_List visualforce page
*
*    History
*    VERSION    AUTHOR              DATE        DETAIL 
*    2.0     Atul Gupta      		07/31/2015  Made changes to PROVIDER_SELECT sub-query to fetch only primary address type summary records
*	 3.0	 Nagarjuna Kaipu		10/08/2016	Req:3926 Changes done to include transaction number and phone number search
*    --------
**/
public with sharing class VFC41_Provider_List_Controller {
    public String providerFirstName {get; set;}
    public String providerLastName {get; set;}
    public String providerNPI {get; set;}
    //PDI: Req:3923 Included Telephone and Transaction Number and removed EMP Id and Provider Id from search
    //public String providerEmPID {get; set;}
    //public String providerId {get; set;}
    public string providerTelePhoneNumber {get; set;}
    public String providerTransactionNumber {get; set;}
    //Req:3923: Ended
    List<Contact> providerResults = new List<Contact>();
    List<Contact> providerResultList = new List<Contact>();
    public final static String strSpace = '';
    public String contactId {get; set;} //PDI Req:3926 added
    public List<Id> phoneContacts {get; set;}
    
    /* @Description : Req-3694, Date: 06/10/2015, Phone number filter added on Search results  */
    //Req-3911 - Included Owner.Name in Select query
    //Req:3926 - Included search fields on summary object
    //Req- 3940 - Added "Tech_Validation_Status__c" in query to display validation source in search results
    static final String PROVIDER_SELECT = 'Select Id, OwnerId, (Select OwnerId, Owner.ProfileId, Owner.Name, Provider_NPI_F__c, Contact_Id__r.ServiceTabLabel__c, Contact_Id__r.Provider_Specialty__c, Provider_License_Number__c, Secure_Street_Address__c, Tech_Primary_Phone_Number__c, Secure_Phone__c, Status__c, Tech_Validation_Status__c FROM Summarys__r where PDI_Campaign__c = \''+Label.CL176_PDI_Current_Campaign_Name+'\' and Address_Type__c = \'Primary\'  limit 1), LastName, Provider_ID__c, Provider_Title__c, FirstName, Contact_Middle_Name__c, Provider_Name_Suffix__c, Phone, ' + 
        'Provider_NPI__c, Provider_Correspondence_Address__c, Provider_Correspondence_City__c, Provider_Correspondence_State__c, ' +
        'Provider_Correspondence_PostalCode__c, Provider_License_Number__c, Provider_License_State__c, Provider_Specialty__c, ServiceTabLabel__c, ' +
        'Teleform_Last_Validation_Date__c, Provider_Portal_Last_Validation_Date__c, Gender__c , Email From Contact where RecordTypeId = \'';
    static final String PROVIDER_FIRSTNAME_API = ' AND FirstName like \'';
    static final String PROVIDER_LASTNAME_API = ' AND LastName like \'';
    //static final String PROVIDER_EMPID_API = ' AND Emp_Id__c like \'';//Req:3923
    static final String PROVIDER_NPI_API = ' AND Provider_NPI__c = \'';
    //static final String PROVIDER_ID_API = ' AND Provider_ID__c = \'';//Req:3923
    static final String PROVIDER_TELEPHONE_NUMBER = ' AND Id IN: phoneContacts';//Req:3923
    static final String PROVIDER_TRANSACTIONNUMBER = ' AND Id = \'';//Req:3923
    
    public String searchQuery {get; set;}
    static final String MULTI_STRING = ' AND '; 
    static final String ENDING_STRING = '\'';
    static final String ENDING_WILDCARD_STRING = '%\'';
    static final String LESS_EQUAL_STRING = ' <= ';
    static final String GREATER_EQUAL_STRING = ' >= ';
    static final String PHONEENDING_STRING = '%\')';
    static Boolean isSearchValues = true;
    public boolean showProviderResults {get; set;}
    private static final String QUEUE_ID_PREFIX = '00G';
    public static final Integer MAX_LIMIT = 500;
    private ApexPages.StandardSetController setCon;
    /**
* @author       :   IDC Offshore
* @date         :   
* @description  :   Constructor used to initialise the class variables with respective values
* @param        :   N/A
* @return       :   N/A
*/ 
    public VFC41_Provider_List_Controller(){
        providerFirstName = strSpace;
        providerLastName = strSpace;
        providerNPI = strSpace;
        //Req:3923: Removed EMP ID and Provider ID search and included Telephone number and transaction number
        providerTelePhoneNumber = strSpace;
        providerTransactionNumber = strSpace;
        //Req:3923:Ended
        showProviderResults = false;
        providerResults = new List<Contact>();
        providerResultList = new List<Contact>();
    }
    /**
* @author       :   IDC Offshore
* @date         :   
* @description  :   Method to Search Providers
* @param        :   N/A
* @return       :   N/A
*/
    public void SearchProvider() {
        try {
            providerResults = new List<Contact>();
            providerResultList = new List<Contact>();
            //conWrapList = new List<ProviderWrapper>();
            showProviderResults = false;
            //Req:3923: Removed Provider ID and EMP Id and included Telephone and Transaction Numbers
            if((isValue(providerFirstName)) || (isValue(providerLastName)) || 
               (isValue(providerNPI)) || (isValue(providerTelePhoneNumber)) || (isValue(providerTransactionNumber)) ){
                   //Rrq:3923: included Telephone and Transaction Number search fields and commented Provider Id and Emp Id
                   if(providerFirstName.length() == 1 || providerLastName.length() == 1 || providerNPI.length() == 1)
                   {
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL18_NoCorrectChar));
                       isSearchValues = false;
                   }
                   else if(providerTransactionNumber.length() > 0 && !providerTransactionNumber.isNumeric())
                   {
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL383_InValidTransactionNumber));
                       isSearchValues = false;
                   }
                   else if(providerTelephoneNumber.length() > 0 && !providerTelephoneNumber.replaceAll('[^0-9]','').isNumeric())
                   {
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CL381_InValidTelephoneNumber));
                       isSearchValues = false;
                   }//3926: Ended
                   else{
                       providerResults = getSearchResults(getProviderSearchQuery());  
                   }
                   if(!providerResults.isEmpty()){//3926: Modified to is not empty
                       for(Contact con : providerResults){
                           if(!con.Summarys__r.isEmpty()){
                               if(providerResultList.size()!=MAX_LIMIT)
                               {
                                   providerResultList.add(con);
                               }
                               else
                               {
                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, Label.CL355_PDI_refineSearchCriteria));
                               }
                           }
                       }
                       isSearchValues = false;
                   }
                   //pagination
                   if(providerResultList <> null && !providerResultList.isEmpty()){
                       this.setCon = new ApexPages.StandardSetController(providerResultList);
                       this.setCon.setpageNumber(1);
                       this.setCon.setPageSize(15);
                   }
               }
            boolean resultFlag = false;
            resultFlag =  isValidSearch(providerResultList);
            
            if(resultFlag) {
                //pagination
                if(providerResultList.size()>0)
                {
                    showProviderResults = true;
                }
            }
        } 
        catch(Exception classException) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL354_PDI_hyphens);
        } 
    }
    /**
* @author       :   IDC Offshore
* @date         :   
* @description  :   Method to retrieve provider Search Query
* @param        :   N/A
* @return       :   N/A
*/
    public String getProviderSearchQuery() {
        Id recordtypeId;
        recordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId(); 
        //PDI Req:3926 Added to Search based on Transaction Number
        if(isValue(providerTransactionNumber))
        {
            //Querying to get contact id from case
            List<Case> caseList = [SELECT Id, Contact.Id, CaseNumber FROM CASE WHERE CaseNumber =: providerTransactionNumber LIMIT 1]; 
            if(!caseList.isEmpty())
            {
                contactId = caseList[0].Contact.Id;  
            }
            else
            {
                contactId = '';  
            }
        }
        if(isValue(providerTelePhoneNumber))
        {
            List<Provider_Address__c> sumAddressList = new List<Provider_Address__c>();
            //Querying Contact Ids by Phone Number search
            sumAddressList = [Select Id, Contact_Id__r.Id, Tech_Phone_Number__c From Provider_Address__c 
                              Where PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name 
                              And Tech_Phone_Number__c =: providerTelephoneNumber.replaceAll('[^0-9]','')]; 
            
            //Querying to get contact id from case
            /*List<Contact_Validation_Summary__c> SummaryList = [Select Contact_Id__r.Id, PDI_Campaign__c, Address_Type__c, Tech_Phone_Number__c FROM Contact_Validation_Summary__c 
where PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name and Address_Type__c = 'Primary' 
AND Tech_Phone_Number__c =: providerTelephoneNumber.replaceAll('[^0-9]','')]; 
*/   
            phoneContacts = new List<Id>();
            for(Provider_Address__c providerAddress: SumAddressList)
            {
                phoneContacts.add(providerAddress.Contact_Id__r.Id);  
            }
        }
        searchQuery = PROVIDER_SELECT + recordtypeId + ENDING_STRING;
        if(isValue(providerFirstName)) { searchQuery += PROVIDER_FIRSTNAME_API + String.escapeSingleQuotes(providerFirstName) + ENDING_WILDCARD_STRING;}
        if(isValue(providerLastName)) { searchQuery += PROVIDER_LASTNAME_API + String.escapeSingleQuotes(providerLastName) + ENDING_WILDCARD_STRING;}
        //if(isValue(providerEmPID)) { searchQuery += PROVIDER_EMPID_API + String.escapeSingleQuotes(providerEmPID) + ENDING_WILDCARD_STRING;}//Req:3923
        if(isValue(providerNPI)) { searchQuery += PROVIDER_NPI_API + String.escapeSingleQuotes(providerNPI) + ENDING_STRING;} 
        //if(isValue(providerId)) { searchQuery += PROVIDER_ID_API + String.escapeSingleQuotes(providerId) + ENDING_STRING;}//Req:3923   
        //PDI req: 3926: Added Telephone Number Transaction Number
        if(isValue(providerTelePhoneNumber)) { searchQuery += PROVIDER_TELEPHONE_NUMBER;}  
        if(isValue(providerTransactionNumber)) {searchQuery += PROVIDER_TRANSACTIONNUMBER + String.escapeSingleQuotes(contactId) + ENDING_STRING;} 
        //PDI req: 3926: Ended
        return searchQuery +' ORDER BY LastName, FirstName LIMIT 501';
    }
    /**
* @author       :   IDC Offshore
* @date         :   
* @description  :   This method id used to get provider search results
* @param        :   N/A
* @return       :   N/A
*/
    public List<SObject> getSearchResults(String search) {
        //PDI Req:3926 Modified the code to handle empty results
        List<SObject> returnList;
        try {
            returnList = Database.query(search);
        } catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL354_PDI_hyphens);
        }
        return returnList;
    }
    /**
* @author       :   IDC Offshore
* @date         :   
* @description  :   Method to check valid search
* @param        :   N/A
* @return       :   N/A
*/
    public Boolean isValidSearch(List<Sobject> checkList) {
        Boolean returnBoolean = true;
        if(checkList == null || checkList.isEmpty() || checkList.size() < 1 ){
            returnBoolean = false;
            //if(isSearchValues) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL17_NoResult));
            //}
        }
        return returnBoolean;
    }
    
    /**
* @author       :   IDC Offshore
* @date         :   
* @description  :   This method is used to check the string is not null
* @param        :   N/A
* @return       :   N/A
*/
    public Boolean isValue(String checkString) {
        Boolean returnValue = false;
        if(checkString != null && !String.isBlank(checkString)) {
            returnValue = true;
        }
        return returnValue;
    }
    //pagination
    // Initialize setCon and return a list of records
    // //Req:3926 - Changed to return Summary records list
    public List<Contact_Validation_Summary__c> getProvidersList() {
        List<Contact_Validation_Summary__c> sumList = new List<Contact_Validation_Summary__c>();
        for(Contact con : (List <Contact> ) setCon.getRecords()){
            for(Contact_Validation_Summary__c sumObj : con.Summarys__r) {
                //Req-3911 - Added sumObj.Owner.Name in method parameters
                 if(sumObj.Secure_Phone__c != null){
                   sumObj.Secure_Phone__c = FormatPhone(sumObj.Secure_Phone__c); 
                }
                sumList.add(sumObj);
            }
        }
        return sumList;
    }
    //Used to format the phone number into US format
    private static String FormatPhone(String Phone) {
        string nondigits = '[^0-9]';
        string PhoneDigits;
        
        // remove all non numeric
        PhoneDigits = Phone.replaceAll(nondigits,'');
        
        // 10 digit: reformat with dashes
        if (PhoneDigits.length() == 10) 
            return '('+PhoneDigits.substring(0,3)+')' + ' ' +
            PhoneDigits.substring(3,6) + '-' +
            PhoneDigits.substring(6,10);
        // 11 digit: if starts with 1, format as 10 digit 
        if (PhoneDigits.length() == 11) {
            if (PhoneDigits.substring(0,1) == '1') {
                return  '('+PhoneDigits.substring(1,4)+')' + ' ' +
                    PhoneDigits.substring(4,7) + '-' +
                    PhoneDigits.substring(7,11);
            }
        }
        
        // if it isn't a 10 or 11 digit number, return the original because
        // it may contain an extension or special information
        return( Phone );
    }       
    
    /*
*   advance to next page
*/
    public Pagereference doNext(){
        if(this.setCon.getHasNext()){
            this.setCon.next();
        }
        return null;
    }
    
    /*
*   advance to previous page
*/
    public Pagereference doPrevious(){
        if(this.setCon.getHasPrevious()){
            this.setCon.previous();
        }
        return null;
    }
    
    /*
*   advance to first page
*/
    public Pagereference doFirst(){
        this.setCon.first();
        return null;
    }
    
    /*
*   advance to last page
*/
    public Pagereference doLast(){
        this.setCon.last();
        return null;
    }
    
    /*
*   return whether previous page exists
*/
    public Boolean getHasPrevious(){
        return this.setCon.getHasPrevious();
    }
    
    /*
*   return whether next page exists
*/
    public Boolean getHasNext(){
        return this.setCon.getHasNext();
    }
    
    /*
*   return page number
*/
    public Integer getPageNumber(){
        return this.setCon.getPageNumber();  
    }
    
    /*
*    return total pages
*/
    public Integer getTotalPages(){
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
        Decimal pages = totalSize/pageSize;
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
}