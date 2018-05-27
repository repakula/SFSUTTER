/**********************************************************************
Name: SafetyCare_CC()
======================================================
======================================================
Purpose: Custom Controller for SafetyCare.page
-------	
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL Description
1.0 Brian Lee 03/23/2016 INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class SafetyCare_CC {
	public Safety_Reporting__c safetyCare {get;set;}
	public boolean completed {get;private set;}
	public boolean surveySaved {get;private set;}
	public Safety_Survey__c safetySurvey {get;set;}
	public static final list<String> eventOptions {get;}
	public static final list<String> categoryOptions {get;}
	//Populate option lists with picklist options, picklists displayed on page as radio options
	static{
		eventOptions = new list<String>();
		Schema.DescribeFieldResult fieldResult = Safety_Reporting__c.Type_of_Event__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
   		for(Schema.PicklistEntry f : ple){
      		eventOptions.add(f.getValue());
   		}
   		categoryOptions = new list<String>();
		fieldResult = Safety_Reporting__c.Category_of_Event__c.getDescribe();
		ple = fieldResult.getPicklistValues();
   		for(Schema.PicklistEntry f : ple){
      		categoryOptions.add(f.getValue());
   		}
	}       

	
	public SafetyCare_CC() {
		this.safetyCare = new Safety_Reporting__c();
		this.completed = false;
		this.surveySaved = false;
	}
/*******************************************************************
Purpose: Insert the Safety_Reporting__c record provided required fields have information and flag as completed
Parameters: None
Returns: None
Throws [Exceptions]: None, Exceptions caught and displayed in message box
********************************************************************/
    public void SaveAndComplete(){
    	try{
    		//validate require fields
    		boolean sCareDone = true;
    		if(String.isBlank(safetyCare.Affiliate__c)){
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Location is required'));
    			sCareDone = false;
    		}
    		if(String.isBlank(safetyCare.Type_of_Event__c)){
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Event Type is required'));
    			sCareDone = false;
    		}
    		if(String.isBlank(safetyCare.Category_of_Event__c)){
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Event Category is required'));
    			sCareDone = false;
    		}
    		if(String.isBlank(safetyCare.Causes__c)){
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Finding is required'));
    			sCareDone = false;
    		}
    		if(String.isBlank(safetyCare.Username__c)){
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Your Name is required'));
    			sCareDone = false;
    		}  
    		if(sCareDone){
	    		insert safetyCare;
	    		safetySurvey = new Safety_Survey__c(Safety_Reporting__c = safetyCare.id);
	    		safetyCare = null; 
	    		this.completed = true;
    		}
    	}
    	catch(exception e){
    		ApexPages.addMessages(e);
    	}
    }
/*******************************************************************
Purpose: Calls SaveSurvey to insert Survey and refreshed page for new SafetyCare entry
Parameters: None
Returns: PageReference to current page and requests redirect
Throws  None
********************************************************************/    
    public PageReference SaveAndNew(){
    	SaveSurvey();
    	PageReference thisPage = ApexPages.currentPage(); 
    	thisPage.setRedirect(true);
    	return thisPage;
    }
/*******************************************************************
Purpose: Insert the Safety_Survey__c if filled out and flag survey completed 
Parameters: None
Returns: None
Throws [Exceptions]: None, Exceptions caught and displayed in page message box
********************************************************************/    
    public void SaveSurvey(){
    	if(safetySurvey != null){
    		try{
	    		//insert survey is question one or suggestions have been entered.
	    		if(!String.isBlank(safetySurvey.Question_1__c) || !String.isBlank(safetySurvey.Suggestions__c)){
		    		insert safetySurvey;
	    		}
	    		safetySurvey = null;
		    	this.surveySaved = true;
    		}
    		catch(exception e){
    			ApexPages.addMessages(e);
    		}
    	}
    }		
}