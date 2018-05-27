/**  
*    Trigger Name: MemberInquiryTrigger
*    Author: IDC Sutter Health Team
*    Date: 12/31/2014
*    Description: Trigger on Customer Inquiry Comments object. Calls helper class AP02_MemberInquiry for the functionality
*    
*    History
*      
*    VERSION    AUTHOR              DATE        DETAIL 
*
**/
trigger MemberInquiryTrigger on Member_Enquiries__c (after insert) {
	
	/** @Description: if trigger context is isInsert **/
	if(Trigger.isInsert){
        
        /** @Description: isafter trigger context in isInsert **/
        if(Trigger.isAfter){
        	
        	if(Label.DisableTrigger == 'FALSE'){
        		
        		/** @Description: helper class method invoked for the logic, trigger.new and trigger.newMap passed as parameters **/
            	AP02_MemberInquiry.updateOOASR_Member_fields(trigger.new, trigger.newMap);
        	}
        }
    }
}