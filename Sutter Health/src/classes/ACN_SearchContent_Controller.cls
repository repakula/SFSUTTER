/**  
*     Class Name: ACN_SearchContent_Controller
*     Author: ACN Onshore
*     Date: 13-October-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description: The controller class for the visual force page which displays the button to redirect into the flow 
*
*
**/

public with sharing class ACN_SearchContent_Controller {

    
    /** @Description: Creates a reference to the Flow **/
    public PageReference getNewFlow() {
        PageReference flowPageReference = new PageReference('/apex/Portal_FLOW');
        flowPageReference.setRedirect(true);
        return flowPageReference;
    }
    
}