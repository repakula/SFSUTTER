/*****************************************************
Class Name: BatchAutoAssignPhoneToAgentsScheduler 
Created By: Nagarjuna Kaipu
Created Date: 15/09/2016
Description: This class is used to schedule the batch class "BatchAutoAssignPhoneRecordsToAgents" to auto assign 
the non validated duplicate phone records to agents based on the selected criteria by the lead
*****************************************************/
global class BatchAutoAssignPhoneToAgentsScheduler implements Schedulable{
/*Execute method to shedule the batch aoex class BatchAutoAssignPhoneRecordsToAgents*/
global void execute(SchedulableContext SC)
{
    BatchAutoAssignPhoneRecordsToAgents autoAssignRecords = new BatchAutoAssignPhoneRecordsToAgents();
    Database.executeBatch(autoAssignRecords);
}
}