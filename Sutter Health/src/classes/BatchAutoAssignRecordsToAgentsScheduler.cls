/*****************************************************
Class Name: BatchAutoAssignRecordsToAgentsScheduler 
Created By: Nagarjuna Kaipu
Created Date: 18/04/2016
Description: This class is used to schedule the batch class "BatchAutoAssignRecordsToAgents" to auto assign 
the non validated records to agents based on the selected criteria by the lead
*****************************************************/
global class BatchAutoAssignRecordsToAgentsScheduler implements Schedulable{
/*Execute method to shedule the batch aoex class BatchAutoAssignRecordsToAgents*/
global void execute(SchedulableContext SC)
{
    BatchAutoAssignRecordsToAgents autoAssignRecords = new BatchAutoAssignRecordsToAgents();
    Database.executeBatch(autoAssignRecords);
}
}