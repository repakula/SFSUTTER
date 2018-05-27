/**  
*     Class Name  : VFC02_Claim_Search
*     Author      : IDC Offshore
*     Date        : 16-Dec-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description : Controller Class for VFP02_Claim_Search page. This Class contains methods to Search for Claims, Associate and Dissociate Claims from
*     the Interaction log
**/

public class VFC02_Claim_Search {
    /** @Description: Boolean variables to maintain the state of the page, render certain components based on certain criterias **/
    public boolean showResults{get; set;}
    public boolean showTabPanel{get; set;}
    static Boolean isSearchValues = true;
    public boolean isClosed{get; set;}
    public boolean showClaimDetail{get; set;}
    public boolean showAssociatedClaims{get; set;}
    public boolean multipleMessage{get; set;}
    public boolean singleMessage{get; set;}
    public boolean deleteMessage{get; set;}
    public boolean alreadyMessage{get; set;}
    public boolean showAssociatedClaimDetail{get; set;}
    
    /** @Description: String variables Status of Interaction log, memberid, providerid, etc **/
    public String searchQuery = '';
    public String calledFrom;
    public String showTab{get; set;}
    public String memberId = '';
    public String providerId = '';
    public String custId = '';
    public String isClosedString = '';
    public String selClaim{get; set;}
    public String disClaim{get; set;}
    public String claimLinkId{get; set;}
    public String ClaimDetailId{get; set;}
    public String claimID {get; set;}
    public String claimMemberID {get; set;}
    public String claimProviderID {get; set;}
    public String pTabId {get; set;}
    
    /** @Description: Wrapper lists for wrapper inner class **/
    public List<claimWrapper> claimWrapperList{get; set;}
    public List<claimWrapper> associateClaimWrapperList{get; set;}
    
    public Case claimSearchStartDate = new Case();
    public Case claimSearchEndDate = new Case();
    public List<Claim_Header__c> claimResults;
    /** @Description: String variables defined to create Claim Header search query **/
    static final String CLAIM_SELECT = 'Select ID, SHPClaimHdr_Claim_HCC_ID__c, ClaimMemberIdField__c, SHPClaimHdr_Member_HCC_ID__c, SHPClaimHdr_Claim_DoS_Start__c, ' +
        'SHPClaimHdr_Claim_DoS_End__c, SHPClaimHdr_Claim_Date_of_Receipt__c, SHPClaimHdr_Procedure_Code_E__c,  SHPClaimHdr_Procedure_Code_Description_E__c, ' +
        'SHPClaimHdr_Diagnosis_Code_E__c, SHPClaimHdr_Diagnosis_Code_Description_E__c, SHPClaimHdr_Supplier_HCC_ID__c, SHPClaimHdr_Supplier_Epic_ID__c From Claim_Header__c where ';
    static final String CLAIM_ID_API = 'SHPClaimHdr_Claim_HCC_ID__c = \'';
    static final String CLAIM_MEMBER_ID_API = 'SHPClaimHdr_Member_HCC_ID__c = \''; 
    static final String CLAIM_PROVIDER_ID_API = 'SHPClaimHdr_Supplier_Epic_ID__c = \'';
    static final String CLAIM_START_DATE_API = 'SHPClaimHdr_Claim_DoS_Start__c';
    
    static final String MULTI_STRING = ' AND '; 
    static final String ENDING_STRING = '\'';
    static final String ENDING_WILDCARD_STRING = '%\'';
    static final String LESS_EQUAL_STRING = ' <= ';
    static final String GREATER_EQUAL_STRING = ' >= ';
   
    /**
    * @author IDC Team
    * @date 16/12/2013
    * @description Constructor of the class. It initializes required variable and assigns those variable with the        
    * respective value. This Constructor initializes claim header and wrapper lists, fetches the parameters passed through the URL, sets the memberId
    * and providerId values
    * @param 
    * @return 
    */
    public VFC02_Claim_Search(){
        
        /** @Description: start of try block **/
        try{
           
            /** @Description: Sets the value of isClosed boolean variable to true**/
            isClosed = false;
            system.debug('inside constructor');
            
            /** @Description: Sets headers for the current page to get the page open by the most recent "standards mode" **/
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
            
            /** @Description: Initialize the Claim Header and Wrapper Lists **/
            claimResults = new List<Claim_Header__c>();
            claimWrapperList = new List<claimWrapper>();
            associateClaimWrapperList = new List<claimWrapper>();
            /** @Description: init() method called to get all the query string parameters passed **/
            init();
            
            /** @Description: Set the calledFrom String variable to be passed to alreadyAssociatedClaims method **/
            calledFrom = 'constructor';
            alreadyAssociatedClaims(calledFrom);
        
        /** @Description:  Catch Block starts **/
        }catch(Exception classException) {
            
            /** @Description:  Add the page messages, if any **/
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            
            /** @Description:  send out an email if an exception is raised **/
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @date 02/01/2014
    * @description Method called in the Constructor and in Search Claim Method. This method fetches all the query string parameters passed to the page.
    * Method is called in SearchClaim method to refresh the search parameters
    * @param 
    * @return Void
    */
    public void init(){
    	
    	/** @Description:  Fetch the variables passed in the URLs and store them in variables **/
        custId = ApexPages.currentPage().getParameters().get('custId');
        isClosedString = ApexPages.currentPage().getParameters().get('caseStatus');
        memberId = ApexPages.currentPage().getParameters().get('memberId');
        providerId = ApexPages.currentPage().getParameters().get('providerId');
        pTabId = ApexPages.currentPage().getParameters().get('primaryTabId');
        
        /** @Description:  Assign memberId to String variable if it has some value **/
        if(memberId != ''){
            claimMemberID = memberId;
        }
        
        /** @Description:  Assign providerId to String variable if it has some value **/
        if(providerId != ''){
            claimProviderID = providerId;
        }
        
        /** @Description:  Assign Status as true to boolean variable if it has some value and isClosed is true **/
        if(isClosedString != '' && isClosedString == 'true'){
            isClosed = true;
        }
        
        /** @Description:  Assign Status as false to boolean variable if it has some value and isClosed is false **/
        else if(isClosedString != '' && isClosedString == 'false'){
            isClosed = false;
        }  
    }
    
    /**
    * @author IDC Team
    * @date 16/12/2013
    * @description Method is called whenever Claim/Claims are associated/dissociated from the Interaction log, and the boolean variables to render
    * different components on the page are set accordingly
    * @param String 'calledFrom' that tells the method from where its called
    * @return Void
    */
    public void alreadyAssociatedClaims(String calledfrom){
        
        /** @Description: start try block **/
        try{
            
            /** @Description: clear the associatedClaimsWrapper list to get fresh list of claims everytime **/
            associateClaimWrapperList.clear();
            
            /** @Description: Claim header list and Set<Id> to contain claim header ids adn associated claim ids **/
            List<Claim_Header__c> claim_header_list = new List<Claim_Header__c>();
            Set<Id> claimHeaderIds = new Set<Id>();
            Set<Id> associatedClaimIds = new Set<Id>();
            
            /** @Description: SOQL query to store associated claims to the interaction log **/
            List<Customer_Inquiry_Claim_Association__c> custAssociationList = [Select id, Claim__c, Customer_Inquiry__c from Customer_Inquiry_Claim_Association__c where Customer_Inquiry__c =:custId];
            
            /** @Description: check if associated claims list is empty **/
            if(!custAssociationList.isEmpty()){
                for(Customer_Inquiry_Claim_Association__c custAssociation : custAssociationList){
                    
                    /** @Description: Claim headers associated to interaction log stored in Set of Ids **/
                    claimHeaderIds.add(custAssociation.claim__c);
                }
                
                /** @Description: SOQL query for list of claim headers linked to that interation log **/
                claim_header_list = [Select Id, SHPClaimHdr_Claim_HCC_ID__c, SHPClaimHdr_Member_HCC_ID__c, SHPClaimHdr_Claim_DoS_Start__c, SHPClaimHdr_Claim_DoS_End__c, SHPClaimHdr_Claim_Date_of_Receipt__c from Claim_Header__c where Id IN : claimHeaderIds];
                for(Claim_Header__c claimh : claim_header_list){
                    
                    /** @Description: Add associated claims to the wrapper list **/
                    associateClaimWrapperList.add(new claimWrapper(claimh, false));
                }
            }
            
            /** @Description: If associated claims list is empty **/
            else{
                showAssociatedClaims = false;
            }
            
            /** @Description: If the method is called from Constructor **/
            if(calledfrom == 'constructor'){
                system.debug('##contructor##');
                
                /** @Description: If associated claims list is not empty set the boolean variables accordingly **/
                if(!custAssociationList.isEmpty()){
                    showAssociatedClaims = true;
                    showTabPanel = true;
                    showTab = 'tab2';
                    showResults = false;
                }
                
                /** @Description: if associated claims list is empty set the variables **/
                else{
                    showAssociatedClaims = false;
                    showTabPanel = true;
                    showTab = 'tab1';
                    showResults = false;
                }
            }
            
            /** @Description: If the method is called from dissociateClaims method **/
            if(calledfrom == 'dissociateClaims'){
                system.debug('##dissociateClaims##');
                
                /** @Description: If associated claims list is not empty set the boolean variables accordingly **/
                if(!custAssociationList.isEmpty()){
                    showAssociatedClaims = true;
                    showTabPanel = true;
                    showTab = 'tab2';
                    multipleMessage = false;
                    singleMessage = false;
                    alreadyMessage = false;
                }
                
                /** @Description: if associated claims list is empty set the variables **/
                else{
                    showAssociatedClaims = false;
                    showTabPanel = true;
                    showTab = 'tab1';
                    multipleMessage = false;
                    singleMessage = false;
                    alreadyMessage = false;
                }
            }
            
            /** @Description: If the method is called from associateMultipleClaims method, set the variables accordingly **/
            if(calledfrom == 'associateMultipleClaim'){
                showTabPanel = true;
                showTab = 'tab1';
                singleMessage = false;
                deleteMessage = false;
            }
            
            /** @Description: If the method is called from associateSingleClaim method, set the variables accordingly **/
            if(calledfrom == 'associateSingleClaim'){
                showAssociatedClaims = true;
                showTabPanel = true;
                showTab = 'tab3';
                showClaimDetail = true;
                multipleMessage = false;
                deleteMessage = false;
            }
        
        /** @Description:  Catch Block starts **/
        }catch(Exception classException) {
            
            /** @Description:  Add the page messages, if any **/
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            
            /** @Description:  send out an email if an exception is raised **/
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @date 16/12/2013
    * @description Dissociate claims method is called when dissociate claims button is clicked to dissociate any associated claims from the interaction log
    * @param 
    * @return Void
    */
    public void dissociateClaims(){
        
        /** @Description: start try block **/
        try{
            disClaim = '';
            deleteMessage = false;
            boolean atleastOneSelected = false;
            isInteractionLogClosed();
            /** @Description: Initialize the list of claims to be dissociated **/
            List<Customer_Inquiry_Claim_Association__c> associationsToDeleteList = new List<Customer_Inquiry_Claim_Association__c>();
            Set<Id> claimIds = new Set<Id>();
            
            /** @Description: If the interaction log is not Closed **/
            if(isClosed == false){
                
                /** @Description: If the claims are associated to the interaction log **/
                if(!associateClaimWrapperList.isEmpty()){
                    
                    /** @Description: Iterate over the associated claims list **/
                    for(claimWrapper cWrap : associateClaimWrapperList){
                        
                        /** @Description: If the claim is checked **/
                        if(cWrap.isSelected == true){
                            
                            atleastOneSelected = true;
                            
                            /** @Description: Add 'comma' after the Claim HCC Ids, these will be part of the dissociation message **/
                            disClaim = disClaim + cWrap.claim.SHPClaimHdr_Claim_HCC_ID__c+', ';
                            
                            /** @Description: Add the claims to be dissociated to the claim Ids Set **/
                            claimIds.add(cWrap.claim.id);
                        }
                    }
                    
                    /** @Description: SOQL over the junction object based on claims ids set **/
                    associationsToDeleteList = [Select Id from Customer_Inquiry_Claim_Association__c where claim__c IN : claimIds];
                }
                
                /** @Description: If no claim has been selected and Dissociate button is clicked, show the message **/
                if(!atleastOneSelected){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please Select a Claim'));
                }
                
                /** @Description: If the queried out list is not empty **/
                if(!associationsToDeleteList.isEmpty()){
                    
                    /** @Description: Delete the junction object record for that claim id **/
                    Database.DeleteResult[] deleteResult = Database.delete(associationsToDeleteList, false);
                    
                    /** @Description: Set dissociation message boolean to true **/
                    deleteMessage = true;
                }
                
                /** @Description: Remove the 'comma' at the end **/
                disClaim = disClaim.removeEnd(', ');
                calledFrom = 'dissociateClaims';
                
                /** @Description: Call the method to refresh the list of already associated claims **/
                alreadyAssociatedClaims(calledFrom);
            }
            
        /** @Description: Catch block starts **/    
        }catch(Exception classException) {
            
            /** @Description:  Add the page messages, if any **/
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            
            /** @Description:  send out an email if an exception is raised **/
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @date 16/12/2013
    * @description Associate Claims method called from the Claim Search Results tab when atleast one claim is checked
    * @param 
    * @return Void
    */
    public void associateMultipleClaim(){
        
        /** @Description: start try block **/
        try {
            Set<string> associationSet = new Set<string>();
            List<Customer_Inquiry_Claim_Association__c> newAssociationList = new List<Customer_Inquiry_Claim_Association__c>();
            selClaim = '';
            isInteractionLogClosed();
            /** @Description: If the interaction log is not Closed **/
            if(isClosed == false){
                
                /** @Description: Fetch the list of already associated claims to the interaction log**/
                for(Customer_Inquiry_Claim_Association__c association:[select id, Claim__c, Customer_Inquiry__c from Customer_Inquiry_Claim_Association__c where Customer_Inquiry__c =:custId])
                {
                    /** @Description: Add the claim ids to the set **/
                    associationSet.add(association.Claim__c);
                }
                /** @Description: Initialize boolean that will check whether at least one claim is selected **/
                boolean atleastOneSelected = false;
                
                /** @Description: If claimWrapper list is not empty **/
                if(!claimWrapperList.isEmpty()){
                	
                	/** @Description: render associated claim message to false **/
                    multipleMessage = false;
                    
                    /** @Description: Iterate over the claimWrapper list **/
                    for(claimWrapper wrapClaim : claimWrapperList ){
                        /** @Description: if Claim is selected **/
                        if(wrapClaim.isSelected){
                            
                            /** @Description: Set at least one selected boolean to true **/
                            atleastOneSelected = true;
                            
                            /** @Description: add selected claim HCC id to the message string **/
                            selClaim = selClaim+wrapClaim.claim.SHPClaimHdr_Claim_HCC_ID__c+', ';
                            
                            /** @Description: if the selected claim is not already associated to the interaction log **/
                            if(!associationSet.Contains(wrapClaim.claim.Id)){
                                
                                /** @Description: Intantiate new juntion object **/
                                Customer_Inquiry_Claim_Association__c newAssociation = new Customer_Inquiry_Claim_Association__c();
                                
                                /** @Description: assign the claim id **/
                                newAssociation.Claim__c = wrapClaim.claim.Id;
                                
                                /** @Description: assign teh customer interaction id **/
                                newAssociation.Customer_Inquiry__c = custId;
                                
                                /** @Description: add the record to the list **/
                                newAssociationList.add(newAssociation);
                                
                                /** @Description: render the already associated message boolean to falsed **/
                                alreadyMessage = false;
                                /** @Description: render associated claim message **/
                				multipleMessage = true;
                				/** @Description: Show associated claims tab boolean tab set to true **/
                    			showAssociatedClaims = true;
                            }
                        }
                    }
                    
                    /** @Description: Remove the 'comma' at the end **/
                    selClaim = selClaim.removeEnd(', ');
                }
                
                /** @Description: If no claim has been selected and Associate button is clicked, show the message **/
                if(!atleastOneSelected){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please Select a Claim'));
                }
                
                /** @Description: If a new record is created and added to the list **/
                if(!newAssociationList.isEmpty())
                {
                    /** @Description: insert the list **/
                    Database.Saveresult[] srList = Database.insert(newAssociationList, false);
                    
                }
                
                calledFrom = 'associateMultipleClaim';
                
                /** @Description: refresh the list of already associated claims **/
                alreadyAssociatedClaims(calledFrom);
            }
            
        /** @Description: Catch block starts **/    
        }catch(Exception classException) {  
            /** @Description:  Add the page messages, if any **/
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            
            /** @Description:  send out an email if an exception is raised **/
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        
    }
    
    /**
    * @author IDC Team
    * @date 16/12/2013
    * @description 
    * @param 
    * @return Void
    */
    public void associateSingleClaim(){
        try {
        	isInteractionLogClosed();
            Set<string> associationSet = new Set<string>();
            if(isClosed == false){
                
                for(Customer_Inquiry_Claim_Association__c association:[select id, Claim__c, Customer_Inquiry__c from Customer_Inquiry_Claim_Association__c where Customer_Inquiry__c =:custId])
                {
                    associationSet.add(association.Claim__c);
                }
                if(claimLinkId <> null && claimLinkId <> '')
                {
                    if(!associationSet.Contains(claimLinkId))
                    {
                        Customer_Inquiry_Claim_Association__c newAssociation = new Customer_Inquiry_Claim_Association__c();
                        newAssociation.Claim__c = claimLinkId;
                        newAssociation.Customer_Inquiry__c = custId;
                        insert newAssociation;
                        singleMessage = true;
                        alreadyMessage = false;
                    }
                    else{
                        singleMessage = false;
                        alreadyMessage = true;
                    }
                }
                calledFrom = 'associateSingleClaim';
                alreadyAssociatedClaims(calledFrom);
            }
        }catch(Exception classException) { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @date 16/12/2013
    * @description method called on click of claim on claim results page, opens the claim detail page in another tab
    * @param 
    * @return Void
    */
    public void setClaimLink()
    {
        showClaimDetail = true;
        showTab = 'tab3';
        singleMessage = false;
        multipleMessage = false;
        deleteMessage = false;
    }
    
    /**
    * @author IDC Team
    * @date 16/12/2013
    * @description method called on click of claim on Associated Claims page
    * @param 
    * @return Void
    */
    public void openAssociatedClaimDetail()
    {
        showAssociatedClaimDetail = true;
        showTab = 'tab4';
        multipleMessage = false;
        singleMessage = false;
        deleteMessage = false;
        alreadyMessage = false;
    }
    
    /**
    * @author IDC Team
    * @date 16/12/2013
    * @description method called on click of close on claim detail page
    * @param 
    * @return Void
    */
    public void showDetailClose()
    {
        showClaimDetail = false;
        showTab = 'tab1';
        multipleMessage = false;
        singleMessage = false;
        deleteMessage = false;
        alreadyMessage = false;
    }
    
    /**
    * @author IDC Team
    * @date 16/12/2013
    * @description This Method search claim header on these parameter claimID,claimMemberID,claimProviderID and validating claimMemberID length as well. 
    * @param 
    * @return Void
    */
    public void SearchClaim() {
        try{
            alreadyMessage = false;
            multipleMessage = false;
            singleMessage = false;
            showResults = false;
            deleteMessage = false;
            
            if(claimResults <> null)
            claimResults.clear();
            if(claimWrapperList <> null)
            claimWrapperList.clear();
            isInteractionLogClosed();
            init();
            if((isValue(claimID)) || (isValue(claimMemberID)) || (isValue(claimProviderID)) 
                || (isValue(String.valueOf(claimSearchStartDate.SearchDate__c))) || (isValue(String.valueOf(claimSearchEndDate.SearchDate__c)))) {
                
                try {  
                    claimResults = getSearchResults(getClaimSearchQuery());
                    system.debug('@@claimResults :'+claimResults);
                } catch(Exception classException) {
                    
                    Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                }   
            } else{ 
            
                isSearchValues = false; 
                
            }
            if(isValidSearch(claimResults)) {
                showResults = true;
                showTab = 'tab1';
                showTabPanel = true;
                for(Claim_Header__c claim : claimResults){
                    claimWrapperList.add(new claimWrapper(claim, false));
                }
                system.debug('@@claimWrapperList :'+claimWrapperList);
            }
            resetParameters();
        }catch(Exception classException) { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    /**
    * @author IDC Team
    * @date 16/12/2013
    * @description In this Method ,we are creating the query that needs to be done on Claim Header. 
    * @param 
    * @return String
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
        system.debug('@@searchQuery :'+searchQuery);
        return searchQuery +' ORDER BY SHPClaimHdr_Claim_HCC_ID__c limit 200'; 
    }
        
    /**
    * @author IDC Team
    * @date 08/09/2013
    * @description This method is used by the Seach Method to query the search string passed to it and returns the queried list of sobjects
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
    private Boolean isValidSearch(List<Sobject> checkList) {
        Boolean returnBoolean = true;
        if(checkList == null || checkList.isEmpty() || checkList.size() < 1 ){
            returnBoolean = false;
        
            if(isSearchValues) {
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL17_NoResult));
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.CL19_EnterValue));
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
    
    /**
    * @author IDC Team
    * @date 08/09/2013
    * @description This method resets the values of all variables
    * @param 
    * @return 
    */
    private void resetParameters(){
        claimID = null;
        claimMemberID = null;
        claimProviderID = null;
        claimSearchStartDate.clear();
        claimSearchEndDate.clear();
        searchQuery = null;
    }
    
    /**
    * @author IDC Team
    * @date 08/09/2013
    * @description This is the inner Wrapper Class, the wraps the Claim Header sObject and a boolean to be shown in table form in the tabs on the page
    * @param 
    * @return 
    */
    public class claimWrapper {
        public Claim_Header__c claim {get; set;}
        public Boolean isSelected {get; set;}
        public claimWrapper(Claim_Header__c claim, boolean bool)
        {
            this.claim = claim;
            this.isSelected = bool;
        }
    }
    
    /**
    * @author IDC Team
    * @date 08/09/2013
    * @description Method to check if interaction log's status is closed or not
    * @param 
    * @return 
    */
    public void isInteractionLogClosed() {
    	try{
	    	if(custId != null || custId != ''){
		    	Case customerInteractionLog = [Select Status from Case where Id =: custId];
		    	if(customerInteractionLog.Status == 'Closed'){
		    		isClosed = true;
		    	}
	    	}
    	}catch(Exception classException) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The Case Id is not valid'));
			Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
		}
    }
}