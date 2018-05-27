/**  
*     Class Name: flowPagePOCExtension
*     Author: ACN Onshore
*     Date: 12-October-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description: This class is the controller for the flow and relays information to and from the flow. Contact ID is passed into the flow variable
*     and Search Criteria is accessed throughout the embedded flow. 
* 
*       
**/

public class flowPagePOCExtension {
    
    /** @Description: Empty Constructor **/
    public Flow.Interview.Portal_FLOW myFlow {get; set;}
    
    /** @Description: Empty Constructor **/
    public String userContactId { get; set; }
    
    public String searchTag;
    
    /** @Description: Gets the userContact Id where id=:userinfo.getuserid() **/
    public flowPagePOCExtension() {
        try{
 
            userContactId = [select Id, ContactId from user where id=:userinfo.getuserid() limit 1].ContactId;
        } catch (Exception classException) { 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.Portal_Error_Message)); 
        }  
    }

    /** @Description: Gets the search criteria from the flow  **/
    public String getSearchTag() {
    
        if(myFlow !=null ){
            searchTag = (String) myFlow.getVariableValue('SearchCriteria_TextVar');
            if(searchTag != null && searchTag !='') {
                searchTag = searchTag.replace(' ','%20');
            }else {
                searchTag = '';
            }
        } else {
            searchTag = '';
        } 
        return searchTag;
    }


}