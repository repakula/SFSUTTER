/*
    This class is used to create cases
    ===================================================================
    Name                    Date                       version	Description
    ===================================================================
    Prashant Kumar        7/20/2015                        1.0
    Brian Lee			  10/17/2016                      1.1  3930 Added menu sub-menu selection for creating SR from landing / home page
    ===================================================================
*/
public class SH_Help_Support extends SH_BaseController 
{
    //Class level variables 
    public Case objCase {get; set;}
    public string strSuccess {get; set;}
    public string strComments {get; set;}
    public string strError {get; set;}
    public string strErrorMessage {get; set;}
    //added on Client FeedBack on 04-09-2015
    public string strCaseNumber {get;set;}
    public string IsShowHP {get; set;}
    public ID caseID {get;set;}
    public String selectedMenuItem {get;set;}
    public String selectedSubMenuItem {get;set;}
    //added on Client FeedBack on 09-09-2015 to Hide the Form if either category or subcategory blank showCreateCaseForm
    public boolean showCreateCaseForm {get;set;}
    public string createCaseRouting {get;set;}
    Transient Attachment attachment;
    public Attachment getAttachment() {
		if (attachment == null){
	    	attachment = new Attachment();
		}
		return attachment;
	}
	public void setAttachment(Attachment attachment){
		this.Attachment = attachment;
	}
    public string strFaqParam {get;set;}
    
    /*
            constructor method
            ===================================================================
            Name                    Date                       version
            ===================================================================
            Prashant Kumar        7/20/2015                        1.0
            ===================================================================
        */
    public SH_Help_Support() {
        Initialize();
    }
        
        /*
            This method is used to initialize the variables
            ===================================================================
            Name                    Date                       version
            ===================================================================
            Prashant Kumar        7/20/2015                        1.0
            ===================================================================
        */    
    @TestVisible private void Initialize() {
        //added on Client FeedBack on 04-09-2015
        strCaseNumber = '';
        IsShowHP = Apexpages.currentPage().getParameters().get('HP') != null ? Apexpages.currentPage().getParameters().get('HP') : 'false';
        strCategoryForHelp = Apexpages.currentPage().getParameters().get('M');
        strSubCategoryForHelp = Apexpages.currentPage().getParameters().get('SM');
        //added on 03-09-2015 for Help and support team and customer intent
        strTeamForHelp = Apexpages.currentPage().getParameters().get('T');
        strCustomerIntentForHelp = Apexpages.currentPage().getParameters().get('CI');
        strSuccess = 'none';
        strError = 'none';
        strErrorMessage = '';
        
        //added on Client FeedBack on 09-09-2015 to Hide the Form if either category or subcategory blank 
        
        showCreateCaseForm = true;
       
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        activePgName = 'Help';
        setBreadCrumbs();        
        BreadCrumbs.add(new SH_BreadCrumb('Help' , '#'));
        createCaseRouting = 'none';
        /*START*** Code Modified by Sutter Salesforce Team****/
        caseID = Apexpages.currentPage().getParameters().get('Id');
        
        if(caseID != null)
        {
            showCreateCaseForm = true;
            strSuccess = 'block';
            strError = 'none';
            strErrorMessage = '';
            strComments = '';
            strCaseNumber = [select caseNumber from case where id=:caseID].caseNumber;
        }
        //allow selection of reason for routing Req-3930
            //  
        if(string.IsBlank(strCategoryForHelp) || string.IsBlank(strSubCategoryForHelp)){
             //create a new case 
            createCaseRouting = 'block';
            //showCreateCaseForm = false;
        }
            
        
        /*END*** Code Modified by Sutter Salesforce Team****/
        
        BindData();
        strFaqParam = SH_Common.getUrlParamString()+'&isHelp=true';
    }
    
    /*
            This method is used to bind the data on page
            ===================================================================
            Name                    Date                       version
            ===================================================================
            Prashant Kumar        7/20/2015                        1.0
            ===================================================================
            Param: none
            ===================================================================
            Output :  none
                ================================================================  
        */
    private void BindData() {
        objCase = new Case();
        objCase.SuppliedEmail = objUser.Contact.Email;
        objCase.SuppliedPhone = objUser.Contact.Phone;
        BindFunctionSubFunction(); 
    }
    
    /*
            This method is used to bind the functionand subfunction
            ===================================================================
            Name                    Date                       version
            ===================================================================
            Prashant Kumar        7/20/2015                        1.0
            ===================================================================
            Param: none
            ===================================================================
            Output :  none
                ================================================================  
        */
    private void BindFunctionSubFunction() {
        if(!string.IsBlank(strCategoryForHelp))
            objCase.Function__c = strCategoryForHelp;
        
        if(!string.IsBlank(strSubCategoryForHelp))
            objCase.Sub_Function__c = strSubCategoryForHelp;
       
        //added on 03-09-2015 for Help and support team and customer intent
        if(!string.IsBlank(strTeamForHelp))
            objCase.Team__c = strTeamForHelp;
        
        if(!string.IsBlank(strCustomerIntentForHelp))
            objCase.Customer_Intent__c = strCustomerIntentForHelp;
        
        if(string.IsBlank(strCategoryForHelp))
            objCase.Customer_Intent__c = 'General Inquiry';
    }
    
    /*
            This method is used to create case
            ===================================================================
            Name                    Date                       version
            ===================================================================
            Prashant Kumar        7/20/2015                        1.0
            ===================================================================
            Param: none
            ===================================================================
            Output :  none
                ================================================================  
        */
    public PageReference CreateCase(){
       PageReference returnPage = Apexpages.currentPage();
       returnPage.setRedirect(true);
       try{
            /* 3930 SR from landing page
            	allowing creation of SR from main landing page.  Category and Sub cat will be set
            	based on the page set menu and sub menu items.  The Unknown_Id and OTHER_NOT_SPECIFIED_ID
            	represent the options that are not specifically related to SH_Menu_Item__c or  SH_Sub_Menu_Item__c 
            */
            boolean dataError = false;
            if(string.IsBlank(strCategoryForHelp) || string.IsBlank(strSubCategoryForHelp)){
            	
            	
            	if(String.isnotblank(selectedMenuItem) && String.isnotblank(selectedSubMenuItem)){
            		if(selectedMenuItem.equals(UNKNOWN_ID)){
            			if(selectedSubMenuItem.equals(OTHER_NOT_SPECIFIED_ID)){
		    				//* This option does not exist as a menu item subitem*//
		    				SH_Sub_Menu_Item__c sMItem = UNKNOWN_ID_SUBMENU;
		    				strCategoryForHelp = sMItem.SH_Function__c;
			                strSubCategoryForHelp = sMItem.SH_Sub_Function__c; 
			                strTeamForHelp = sMItem.SH_Team__c;
			                strCustomerIntentForHelp = sMItem.SH_Customer_Intent__c;
		    			}
		    			else{
		    				dataError = true;
		    			}
            		}
            		else{
            			//* other / not specified was selected so use the menu item routing *//
            			if(selectedSubMenuItem.equals(OTHER_NOT_SPECIFIED_ID)){
            				SH_Menu_Item__c mItem = [select SH_Function__c,SH_Sub_Function__c, SH_Team__c, SH_Customer_Intent__c from SH_Menu_Item__c where id = :selectedMenuItem][0];
            				strCategoryForHelp = mItem.SH_Function__c;
			                strSubCategoryForHelp = mItem.SH_Sub_Function__c; 
			                strTeamForHelp = mItem.SH_Team__c;
			                strCustomerIntentForHelp = mItem.SH_Customer_Intent__c;
            			}
            			else{		    		
		    				SH_Sub_Menu_Item__c sMItem = [Select SH_Function__c,SH_Sub_Function__c, SH_Team__c, SH_Customer_Intent__c from SH_Sub_Menu_Item__c where id = :selectedSubMenuItem][0];
		    				strCategoryForHelp = sMItem.SH_Function__c;
			                strSubCategoryForHelp = sMItem.SH_Sub_Function__c; 
			                strTeamForHelp = sMItem.SH_Team__c;
			                strCustomerIntentForHelp = sMItem.SH_Customer_Intent__c;
            			}
		    		}
			    		
            	}
            	else{
            		dataError = true;
            	}
            	if(dataError){
            		strSuccess = 'none';
            		strError = 'block';
            		strErrorMessage = 'Please set the help with and more informaion sections for proper service request submission';
            	}
            	else{
            		BindFunctionSubFunction();
            	}
            }
            if(!dataError){ //string.IsNotBlank(strCategoryForHelp) && string.IsNotBlank(strSubCategoryForHelp)){
	            objCase.SuppliedName = objUser.Contact.Name; 
	            objCase.OwnerId = objUser.id;
	            objCase.ContactId = objUser.ContactId;
	            objCase.Status = 'New';
	            objCase.Contact_Region__c = objUser.Contact.Employee_Region__c;
	            
	            SH_Community_Settings__c objComm = SH_Community_Settings__c.getValues('Setting-1');
	            objCase.RecordTypeId = objComm.SH_Case_Record_Type_Id__c != null ? objComm.SH_Case_Record_Type_Id__c : SH_Common.GetRecordTypeId('Case', 'Employee Inquiry');
	            objCase.Origin = 'Web';
	            //objCase.Description = strComments;
	            objCase.Comments__c = strComments;
	            insert objCase;
	            returnPage.getParameters().put('Id',objCase.id);
	            /* 3930 adding attachment to case.
	            */
	            if(attachment != null && attachment.body.size() > 0){
	            	attachment.ParentId = objCase.id;
	            	attachment.OwnerId = UserInfo.getUserId();
			        attachment.IsPrivate = false;
			        try{
			        	insert attachment;
			        }
			        catch(Exception e){
			        	//Unable to load attachment
			        }
	            }
	            strCaseNumber = [select caseNumber from case where id=:objCase.Id].caseNumber;
	            strSuccess = 'block';
	            strError = 'none';
	            strErrorMessage = '';
	            strComments = '';
	            BindData();
            }
        }
        catch(Exception ex){
            strSuccess = 'none';
            strError = 'block';
            strErrorMessage = ex.getMessage();  
        }
        
        return returnPage;
    }
    @TestVisible private final static SH_Sub_Menu_Item__c UNKNOWN_ID_SUBMENU = new SH_Sub_Menu_Item__c(
			    									//SH_Function__c = 'Human Resource', *12/8* Removed, manually set by agent
			    									//SH_Sub_Function__c = 'HR Benefits',
			    									SH_Team__c = '[Tier 1] Employee Portal General',
			    									SH_Customer_Intent__c = 'General Inquiry'
		    									);
    @TestVisible private final static string UNKNOWN_ID = '9990009991'; //Id of the Unknown Menu option
    @TestVisible private final static string OTHER_NOT_SPECIFIED_ID = '9990009992'; // ID of the 'Other / Not specified' sub menu item
    /*******************************************************************
	Purpose: req 3930 Returns a list of wrapped MenuItems based on current user employee record 
	Parameters: none
	Returns: list of NVWrapper MenuItems
	Throws [Exceptions]: None
	********************************************************************/
    @remoteAction
    public static list<NVWrapper> getMenuItems(){
    	list<NVWrapper> returnList = new list<NVWrapper>();
    	list<User> currentUserList = [Select contactId, contact.Employee_EEO_SubCode__c from User where id = :Userinfo.getUserId()];
    	if(!currentUserList.isEmpty()){
    		String subCode = currentUserList[0].contact.Employee_EEO_SubCode__c != null ? currentUserList[0].contact.Employee_EEO_SubCode__c : '0';
    		for(SH_Menu_Item__c mItem : [select Name from SH_Menu_Item__c where SH_Is_Publish__c = true AND SH_Employee_EEO_subcode__c includes (:subCode) order by Name ASC]){
    			returnList.add(new NVWrapper(mItem));
    		}
    		returnList.add(new NVWrapper('Unknown',UNKNOWN_ID));
    		
    	}
    	return returnList;
    	
    }
    /*******************************************************************
	Purpose: req 3930 Returns a list of wrapped subMenuItems based on selected menuitem 
	Parameters: id of menu item
	Returns: list of NVWrapper sub MenuItems
	Throws [Exceptions]: None
	********************************************************************/
    @remoteAction
    public static list<NVWrapper> getSubMenuItems(String selectedMenuItemId){
    	list<NVWrapper> returnList = new list<NVWrapper>();
    	Id menuItemId;
    	IF(!selectedMenuItemId.equals(UNKNOWN_ID)){
	    	try{
	    		menuItemId = (Id) selectedMenuItemId;
	    	}
	    	catch(Exception e){
	    		//bad id so return emptyList
	    		return returnList;
	    	}
	    	for(SH_Sub_Menu_Item__c sMItem : [Select Name from SH_Sub_Menu_Item__c where SH_Is_Publish__c = true AND SH_Menu_Item__c = :menuItemId order by Name ASC]){
	    		returnList.add(new NVWrapper(sMItem));
	    	}
    	}
    	returnList.add(new NVWrapper('Other/ Not specified',OTHER_NOT_SPECIFIED_ID));
    	return returnList;
    }
    public class NVWrapper{
    	public String Name;
    	public String Id;
    	public NVWrapper(String inName, String inId){
    		this.Name = inName;
    		this.Id = inId;
    	}
    	public NVWrapper(SH_Menu_Item__c inMenuItem){
    		this.Name = inMenuItem.Name;
    		this.Id = inMenuItem.Id;
    	}
    	public NVWrapper(SH_Sub_Menu_Item__c inSubMenuItem){
    		this.Name = inSubMenuItem.Name;
    		this.Id = inSubMenuItem.Id;
    	}
    }
}