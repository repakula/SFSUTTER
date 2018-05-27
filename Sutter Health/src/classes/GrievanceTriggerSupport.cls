/**  
 *    Class: GrievanceTriggerSupport
 *    Author: IDC  
 *    Date: 09-Oct-2014  
 *    Description: This class is being used by 'GrievanceComments' and 'CallBackTrigger' triggers to avoid the creation of 'Call_Back__c' records from 'GrievanceComments' trigger.
 **/

public without sharing class GrievanceTriggerSupport{
    
    public static boolean isFirstTime = true;

    /** Return current state of 'isFirstTime' variable. **/    
    public static boolean isFirstExecution() {
        return isFirstTime ;
    }

    public static void completeMilestone(List<Id> caseIds, String milestoneName, DateTime complDate) {
      List<CaseMilestone> cmsToUpdate = [select Id, completionDate from CaseMilestone cm where caseId in :caseIds and cm.MilestoneType.Name=:milestoneName and completionDate = null limit 1];
      if (cmsToUpdate.isEmpty() == false){
        for (CaseMilestone cm : cmsToUpdate){
          cm.completionDate = complDate;
        }
        update cmsToUpdate;
      } // end if
    }
}