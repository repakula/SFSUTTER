/**  
*    Class Name: ManageCaseMilestoneDatabase
*    Author: IDC Offshore
*    Date: 8-December-2013
*    Description: This is the helper class to manage the Case Milestone functionality on update of the Case records.
*                   This class updates the milestone Start Date and Completion date.
*    History
*    --------
**/
public class ManageCaseMilestone 
{
    /**
    *   @Description: This is a future method takes set of Case. updates the milestone Start Date and Completion date accordingly.
    *   @Arguments: sets of Case
    *   @Return: Void
    **/
    @future
    public static void updateCaseMilestone(set<string> determination31DaySet, set<string> determination45DaySet, set<string> newCaseId)
    {
        /* Map and list variable*/
        Map<string, string> milestoneIdMap = new Map<string, string>();
        List<CaseMilestone> caseMilestonestoUpdate = new List<CaseMilestone>();
        Map<string, Case> newCaseMap = new Map<string, Case>();
        
        try
        {
            /*Create a map of the existing milestones*/
            for(MilestoneType mileType:[select Id, Name from MilestoneType limit 1000])
            {
                milestoneIdMap.put(mileType.Name, mileType.Id);
            }
            
            if(!newCaseId.isEmpty())
            {
                /* Query the Updated cases and put them in a map*/
                for(Case newCase:[select Id, RFI_Request_Date__c, RFI_Completion_Date__c from Case where Id IN:newCaseId])
                {
                    /* Create a map*/
                    newCaseMap.put(newCase.Id, newCase);
                }
            }
            
            if(!determination31DaySet.isEmpty())
            {
                /* Fetch the Case Milestones for the PArticular Cases*/
                for(CaseMilestone caseMile:[select Id, StartDate, CompletionDate, CaseId from CaseMilestone where CaseId IN :determination31DaySet AND (MilestoneTypeId = :milestoneIdMap.get(system.Label.CL35_RFIMilestone) OR MilestoneTypeId = :milestoneIdMap.get(system.Label.CL36_DLMilestone))])
                {
                    caseMile.CompletionDate = null;
                    caseMile.StartDate = newCaseMap.get(caseMile.CaseId).RFI_Request_Date__c;
                    caseMilestonestoUpdate.add(caseMile);
                }
            }
            
            if(!determination45DaySet.isEmpty())
            {
                /* Fetch the Case Milestones for the PArticular Cases*/
                for(CaseMilestone caseMile:[select Id, StartDate, CompletionDate, CaseId, MilestoneTypeId from CaseMilestone where CaseId IN :determination45DaySet AND (MilestoneTypeId = :milestoneIdMap.get(system.Label.CL35_RFIMilestone) OR MilestoneTypeId = :milestoneIdMap.get(system.Label.CL36_DLMilestone))])
                {
                    if(CaseMile.MilestoneTypeId == milestoneIdMap.get(system.Label.CL35_RFIMilestone))
                    {
                        caseMile.CompletionDate = newCaseMap.get(caseMile.CaseId).RFI_Completion_Date__c;
                        caseMilestonestoUpdate.add(caseMile);
                    }
                    else if(CaseMile.MilestoneTypeId == milestoneIdMap.get(system.Label.CL36_DLMilestone))
                    {
                        caseMile.CompletionDate = null;
                        caseMile.StartDate = newCaseMap.get(caseMile.CaseId).RFI_Completion_Date__c;
                        caseMilestonestoUpdate.add(caseMile);
                    }
                }
            }
            
            if(!caseMilestonestoUpdate.isEmpty())
            {
                /* Update Case Milestones*/
                database.update(caseMilestonestoUpdate, false);
            }
        }catch (Exception classException) 
        {
            Utility.sendErrorEmail(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
}