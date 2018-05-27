/**    
 *     Trigger Name  : InserCaseForSpecificPost
 *     Author      : IDC Offshore  
 *     Date        : 20-Oct-2015  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : InsertCaseForSpecificPost is fired when Chatter post is inserted for creating suggestion links and SRs.
 *                   .                      
 **/
trigger InsertCaseForSpecificPost on FeedItem ( before insert , after insert , before update , after update ) {
    
    public static String EXTERNALPROFILEID = System.Label.SHP_Chatter_External_Profile_Id;
    String ExternalProfileIdValue = UserInfo.getProfileId();
    
    // Skip the Execution for Chatter External User 
    if(!(ExternalProfileIdValue.contains(EXTERNALPROFILEID))) {
        if( trigger.isBefore ) {
            SHPSRCreationThroughChatter.createSHPSRFromChatter( trigger.new );
        }
        
        if( trigger.isAfter ) {
            new ChatterPostActionsHelper().suggestLinksThroughChatterComments( trigger.new );
        }
    }
    
    if ( trigger.isBefore ) {
        new BlacklistFilterDelegate().filterFeedItems(trigger.new);
    }
}