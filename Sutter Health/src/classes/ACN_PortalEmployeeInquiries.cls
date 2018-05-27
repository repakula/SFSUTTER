/**  
*     Class Name: ACN_PortalEmployeeInquiries
*     Author: ACN Onshore
*     Date: 12-October-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description: Generates a list of previous inquiries for the visualforce page to display
*
*
**/

public with sharing class ACN_PortalEmployeeInquiries {

    
    List<Case> displayList;
    public Case recentIL = new Case(); 
    public Boolean isILShowing = false;
    
    public Boolean flowFlag;
    public String flowFlagValue;    
    
    /** @ Description: Constructor sets the recentIL display value (if any) and the displayList of related ILs **/
    public ACN_PortalEmployeeInquiries() {
            
        flowflagValue = getFlowFlagValue();
        if(getDisplayList().size() > 0) {  
            recentIL = getDisplayList()[0];
        }
        if(recentIL != null && isSoon(recentIL)) {
          isILShowing = true;
        }                          
        
    }
     
    /** @ Description: Checks to see if a recent IL was created and if true, queries and stores the result set in a list **/
    public Case getInquiryId() {
                           
        return recentIL;
    }
    
    /** @ Description: Gets a result set where CreatedById = :userinfo.getuserid() and stores in a list **/   
    public List<Case> getDisplayList() {
        try{
             if(displayList == null) displayList = [select Id, Contact.Name,Requestor_Type__c, CaseNumber, Origin, CreatedDate, Status, Priority, Comments__c,Internal_Comments__c, Subject, Customer_Intent__c from Case where CreatedById = :userinfo.getuserid() ORDER BY caseNumber DESC NULLS Last]; 
        } catch (Exception classException) {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.Portal_Error_Message));
        }
       
        return displayList;
    }
    
    /** @ Description: isILShowing getter method **/
    public Boolean getisILShowing() {
    
        return isILShowing;
    }
     public Case getrecentIL() {
    
        return recentIL;
    }
    
     /** @ Description: Sets the variable isILShowing **/
    public void setisILShowing(Boolean setValue) {
    
        isILShowing = setValue;
    }
    
    /** @ Description: Sets recentIL to recentCase **/
    public void setrecentIL(Case recentCase) {
    
        recentIL = recentCase;
    }
    
    /** @ Description: Checks if IL was created now and returns a boolean dictating if recentIL is displayed **/ 
    public Boolean isSoon(Case recentIL) {
        Boolean returnValue = false;
        DateTime dt_createdPlus = recentIL.CreatedDate;
        if(dt_createdPlus != null) {
            dt_createdPlus = dt_createdPlus.addSeconds(15);
        }
        if(dt_createdPlus > System.Now() ) {
            returnValue = true;
        }   
        
        return returnValue;
    
    }
    
    /** @ Description: Empty Constructor **/
    public String userContactId { get; set; }
    
    /** @ Description: Sets a flag value to true if the returnValue is not null (the flow creates an IL) **/ 
    public String getflowFlagValue() {
        String returnValue = ApexPages.CurrentPage().getParameters().get('flowflag');
        if(returnValue != null) {
            setflowflag(true);
        }
        return returnValue;
    }
    
    /** @ Description: flowFlag getter method **/
    public Boolean getflowFlag() {
        return flowFlag;
    }
    
    /** @ Description: flowFlag setter method **/
    public void setflowflag(Boolean newValue) {
        flowFlag = newValue;
    
    }
    

    

}