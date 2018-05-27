/**********************************************************************
Name: Mass_Transfer_CC
======================================================
======================================================
Purpose: Controller for the page Mass_Transfer.  This class allows the user to filter visible case records using criteria set on the tempCase variable.  Once filtered the 
user can select 0 or more cases to change. The ownership change be either to another user or to a queue provided the validation rule for changing case to queue
ownership is overridden using 'Bypass_Validation__c = true'.  This field is promptly set back to false using the workflow rule 'Reset bypass checkbox'. 
-------	
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL Description
1.0 Brian Lee 06/08/2016 INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class Mass_Transfer_CC {
    //List of applicable record types
    @TestVisible  private static list<String> recordTypeNames = new list<String>{'Finance Accounting', 'Finance Accounts Payable', 'Finance Payroll', 'Human Resources', 'Revenue Cycle', 'Supply Chain'};
    @TestVisible  private static boolean THROW_EXCEPTION = false; // Strictly for code test coverage.  No other use
    private static Integer PAGE_SIZE = 35;
    public String selectedRecordType {get;set;}
    public map<id,boolean> caseChecked {get;set;}
    private map<id,String> caseIdToCaseNumberMap;
    public boolean showCaseList {get;set;}
    public Case tempCase {get;set;}
    public boolean queryCriteriaSaved {get;private set;}
    @TestVisible private static list<String> IGNORE_STATUS = new list<String>{'Closed'}; //Will not be swapping ownership on closed cases
	public String ownerName {get;set;}
    public Integer ResultSize {get;private set;}
    public Integer PageSize {get;private set;}
    public boolean pickOwnerField {get;set;}
    private String sortDir = 'ASC';
    private String sortExp = 'CreatedDate'; 
    
    /*******************************************************************
	Purpose: Instantiates the Mass_Transfer_CC 
	Parameters: none
	Returns: none 
	Throws [Exceptions]: None
	********************************************************************/
    public Mass_Transfer_CC(){
    	showCaseList = true;
    	queryCriteriaSaved = false;
    	pickOwnerField = false;
    	tempCase = new case();
    }
    
    /*******************************************************************
	Purpose: Instantiates the Case Standardsetcontroller with filtering based on page set variables 
	Parameters: none
	Returns: ApexPages.StandardSetController 
	Throws [Exceptions]: None
	********************************************************************/
    public ApexPages.StandardSetController setMass_Transfer {
    	get{
    		if(setMass_Transfer == null){
    			caseChecked = new map<id,boolean>();
    			caseIdToCaseNumberMap = new map<id,String>();
    			//Escape strings set by the page input
    			ownerName = String.isNotBlank(ownerName) ? String.escapeSingleQuotes(ownerName) : ownerName;
    			tempCase.Team__c = String.isNotBlank(tempCase.Team__c) ? String.escapeSingleQuotes(tempCase.Team__c) : tempCase.Team__c;
    			tempCase.Function__c = String.isNotBlank(tempCase.Function__c) ? String.escapeSingleQuotes(tempCase.Function__c) : tempCase.Function__c;
    			tempCase.Sub_Function__c = String.isNotBlank(tempCase.Sub_Function__c) ? String.escapeSingleQuotes(tempCase.Sub_Function__c) : tempCase.Sub_Function__c;
    			sortExp =  String.isNotBlank(sortExp) ? String.escapeSingleQuotes(sortExp) : sortExp;
    			sortDir =  String.isNotBlank(sortDir) ? String.escapeSingleQuotes(sortDir) : sortDir;
    			
    			String queryString = 'Select Owner.Type, CaseNumber, CreatedDate, Status, Contact_Name__c,'
    				 		+ ' Sub_Function__c, Team__c, Function__c,recordType.Name, Owner.Username, Owner.Name, OwnerId, Customer_Intent__c, Customer_Sub_Intents__c, Subject__c' 
    				 		+ ' from case where Owner.Type = \'User\' AND Status not in: IGNORE_STATUS';
    			
    			
    			if(String.isNotBlank(ownerName)){
					queryString += ' AND owner.Name like \'%' + ownerName.trim() + '%\'';
    			}	
    			if(String.isNotBlank(tempCase.Team__c)){
    				 queryString += ' AND Team__c = \'' + tempCase.Team__c + '\''; 
    			}
    			if(String.isNotBlank(tempCase.Function__c)){
    				queryString += ' AND Function__c = \'' + tempCase.Function__c + '\'';
    			}
    			if(String.isNotBlank(tempCase.Sub_Function__c)){
    				queryString += ' AND Sub_Function__c = \'' + tempCase.Sub_Function__c + '\'';
    			}
    			queryString += ' order by ' + sortExp +  ' ' + sortDir  + ' NULLS LAST limit 10000';
    			setMass_Transfer = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
    			setMass_Transfer.setPageSize(PAGE_SIZE);
    			ResultSize = setMass_Transfer.getResultSize();
    			PageSize = setMass_Transfer.getPageSize();
    		}
    		return setMass_Transfer;
    	}
    	set;
    }
    
	/*******************************************************************
	Purpose: Get and Set the sortexpression to order by in StandardSetController.  Defaults new Order By field to 'ASC' order. 
	Parameters: String that represents the field that should be used for sorting  
	Returns: The current field used for sorting
	Throws [Exceptions]: None
	********************************************************************/
    public String sortExpression{
        get{
            return sortExp;
        }
        set{
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp){
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            }
            else{
                sortDirection = 'ASC';
            }
            sortExp = value;
            //Reset the SetController to requery records 
            setMass_Transfer = null;
        }
    }
    
    /*******************************************************************
	Purpose: Get and Set the SortDirection to order StandardSetController by ASC or DESC. 
	Parameters: String that sets the sorting direction  
	Returns: The current sorting direction
	Throws [Exceptions]: None
	********************************************************************/
    public String SortDirection{ 
        get{
	        //if not column is selected 
	        if (sortExpression == null || sortExpression == ''){
	            return 'ASC';
	        }
	        else{
	            return sortDir;
	        }
        }
        set{
        	sortDir = value;
        }
    }
    
    /*******************************************************************
	Purpose: Get the pagenumber from the  StandardSetController
	Parameters: None  
	Returns: The current page number
	Throws [Exceptions]: None
	********************************************************************/
    public Integer getPageNumber(){
    	return setMass_Transfer.getPageNumber();
    }
    
	/*******************************************************************
	Purpose: Flags the query criteria as set by user and clears the StandardSetController
	Parameters: None  
	Returns: None
	Throws [Exceptions]: None
	********************************************************************/   
    public void queryCases(){
    	queryCriteriaSaved = true;
    	setMass_Transfer = null;
    }
    
    /*******************************************************************
	Purpose: Creates a list of currently displayed case records, populates the casechecked map and captures the case numbers 
	Parameters: None  
	Returns: list<Case> - List of cases based on page set filtering variables
	Throws [Exceptions]: None
	********************************************************************/
    public list<Case> getCaseList(){
    	list<Case>  returnList = setMass_Transfer.getRecords();
    	
    	for(Case thisCase : returnList){
    		if(!caseChecked.containsKey(thisCase.id)){
    			caseChecked.put(thisCase.id,false);
    			caseIdToCaseNumberMap.put(thisCase.id,thisCase.CaseNumber);
    		}
    	}
    	return returnList;
    }
    
    /*******************************************************************
	Purpose: Create a list of case record types that are listed in recordTypeNames and are available to the user per their profile 
	Parameters: None  
	Returns: list<SelectOption> - List of available recordtypes.  If more then one type is available then the option 'None' is the first option.  
				If only one record type is available then none is not returned as an option in the list
	Throws [Exceptions]: None
	********************************************************************/
    public list<SelectOption> getRecordTypeSelectOptions(){
    	list<SelectOption> returnList = new list<SelectOption>{new SelectOption('','None')};
    	list<SelectOption> tempList = new list<SelectOption>();
		Map<String,Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Case.getRecordTypeInfosByName();
		for( String recordType : recordTypeNames){
			if(recordTypeMap.containsKey(recordType) && recordTypeMap.get(recordType).isAvailable()){
				tempList.add(new SelectOption(recordTypeMap.get(recordType).getRecordTypeId(), recordType));
			}
		}
    	if(tempList.size() == 1){
    		returnList = tempList;
    	}
    	else{
    		returnList.addAll(tempList);
    	}
    	
    	return returnList;
    }
	
    /*******************************************************************
	Purpose: Updates the owner of all selected cases to the owner specified in the tempCase.OwnerId field. 
	Parameters: None  
	Returns: null.  Success and failture are displayed to user in page messages
	Throws [Exceptions]: None, error is caught and appropriatly displayed to the user
	********************************************************************/
    public PageReference updateOwner(){
    	list<Case> selectedList = new list<Case>();
    	for(Id thisId : caseChecked.keySet()){
    		if(caseChecked.get(thisId)){
    			selectedList.add(new case(id = thisId, OwnerId = tempCase.OwnerId, Bypass_Validation__c = true));
    		}
    	}
    	try{
	    	update selectedList;
	    	setMass_Transfer = null;
	    	tempCase.OwnerId = null;
	    	pickOwnerField = false;
	    	if(selectedList.size() == 1){
	    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Update Successful : 1 Record was transfered.'));
	    	}
	    	else{
	    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Update Successful : ' + selectedList.size() + ' Records were transfered.'));
	    	}
	    	if(Test.IsRunningTest() && THROW_EXCEPTION){
	    		insert new Account(); //Purely for code coverage in catch block
	    	}
    	}
    	catch(Exception e){
    		if(e.getTypeName().equals('System.DmlException')){
	    		for(integer i = 0; i < e.getNumDml(); i++){
	    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Transaction Number : ' + caseIdToCaseNumberMap.get(e.getDMLId(i)) + ' - ' + e.getDmlMessage(i)));
	    		}
    		}
    		else{
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getTypeName() + 'Update Error : Please contact your System Administrator -' + e.getMessage()));
    		}
    	}
    	return null;
    }
    
    /*******************************************************************
	Purpose: Updates StandardSetController to previous page of cases if available. 
	Parameters: None  
	Returns: None
	Throws [Exceptions]: None
	********************************************************************/
    public void previousPage(){
    	if(setMass_Transfer.getHasPrevious()){
    		setMass_Transfer.previous();
    	}
    }
    
	/*******************************************************************
	Purpose: Updates StandardSetController to next page of cases if available. 
	Parameters: None  
	Returns: None
	Throws [Exceptions]: None
	********************************************************************/
    public void nextPage(){
    	if(setMass_Transfer.getHasNext()){
    		setMass_Transfer.next();
    	}

    }
}