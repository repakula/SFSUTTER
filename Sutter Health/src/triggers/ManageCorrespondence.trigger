/**  
*    Trigger Name: ManageCorrespondence
*    Author: Abhishek Gupta
*    Date: 20-October-2015
*    Description:  Requirement number 3378 Member Employer Correspondence This Trigger insert and update  Subscriber id in lookup if any member is subscriber and  it have a dependent 

*    History
*    --------
*    VERSION    AUTHOR           DATE        DETAIL 
*       1.0     IDC Offshore   20/10/2015  Write Trigger for correspondence 
*       
**/
trigger ManageCorrespondence on Correspondence_Letter__c (before insert, before update  ) {

  if(Trigger.isInsert|| trigger.isupdate) 
    {   
        if(Trigger.isbefore)
        {
            ManageCorrespondenceHelper.insertCorrespondenceSubscriber(trigger.new);
        }
    }
}