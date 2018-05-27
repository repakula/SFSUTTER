/*****************************************************
Class Name: PDIEAFFacilitiesListController 
Created By: Nagarjuna Kaipu
Created Date: 04/10/2016
Description: This class is used to show EAF Facilities
*****************************************************/
public class PDIEAFFacilitiesListController {
    public String faciltyID {get; set;}
    public String facilityName {get; set;}
    public Boolean isSearchValues {get; set;}
    
    public boolean showResults {get; set;}
    public List<PDV_EAF_Facility__c> faciltyResults {get; set;}
    
    private ApexPages.StandardSetController setCon;
    
    static final String FACILITY_NAME_API = ' AND Name like \'%';
    static final String FACILITY_ID_API = ' AND Facility_ID__c like \'';
    static final String ENDING_WILDCARD_STRING = '%\'';
    
    public PDIEAFFacilitiesListController(){
        showResults = false;
        faciltyResults = new List<PDV_EAF_Facility__c>();
        this.setCon = new ApexPages.StandardSetController(faciltyResults);
    }
    
    public void searchFacility(){
        try{
            showResults = false;
            faciltyResults = new List<PDV_EAF_Facility__c>();
            if((String.isBlank(faciltyID)) || (String.isBlank(facilityName)) ) {
                if(faciltyID.length() == 1 || facilityName.length() == 1 ){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL18_NoCorrectChar));
                    isSearchValues = false;
                }
                else{
                    faciltyResults = getSearchResults();
                    //pagination
                    if(faciltyResults <> null && !faciltyResults.isEmpty()){
                        showResults = true;
                        this.setCon = new ApexPages.StandardSetController(faciltyResults);
                        this.setCon.setpageNumber(1);
                        this.setCon.setPageSize(2);
                    }
                    else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL17_NoResult));
                    }
                }
            }
        } catch(Exception ex) {
            Utility.handleExceptionFromCode(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN);
        }
    }
    
    public List<PDV_EAF_Facility__c> getSearchResults() {
        List<PDV_EAF_Facility__c> returnList;
        String search = getFaciltySearchQuery();
        returnList = Database.query(search);
        return returnList;
    }
    
    public String getFaciltySearchQuery() {
        string strQuery = 'Select Id, Name, Facility_ID__c, Emp_Id__c, ADDRESS__c, Address_Line_1__c, CITY__c, STATE__c, ZIP_CODE__c, PHONE__c, FAX_NUMBER__c, Last_Verified_date__c, Owner.Name From PDV_EAF_Facility__c ';
        /*Phone number filter added on Search results  */
        strQuery = strQuery + 'where Name != null ';
        /*Phone number filter added on Search results  */
        if(String.isNotBlank(faciltyID)) {
            strQuery = strQuery + FACILITY_ID_API + String.escapeSingleQuotes(faciltyID) + ENDING_WILDCARD_STRING;
        } 
        if(String.isNotBlank(facilityName)) {
            strQuery = strQuery + FACILITY_NAME_API + String.escapeSingleQuotes(facilityName) + ENDING_WILDCARD_STRING;
        }
        return strQuery +' ORDER BY Name limit 100';
    }
    
    public List<PDV_EAF_Facility__c> getFacilitiesList() {
        List<PDV_EAF_Facility__c> fList = new List<PDV_EAF_Facility__c>();
        for(PDV_EAF_Facility__c EAF : (List<PDV_EAF_Facility__c> )setCon.getRecords()){
            fList.add(EAF);
        }
        return fList;
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