/**
  * @author       :   Kishore Jonnadula
  * @date         :   01/09/2016 (DD/MM/YYYY)
  * @description  :   Scheduler Class for BatchInternalProviderEmail 
  * @param        :   N/A
  * @return       :   N/A
  */
global class BatchInternalProviderEmailScheduler implements Schedulable {
    
    /*Execute method to shedule the batch apex class BatchPasswordreset*/
    global void execute(SchedulableContext sc)
    {
        BatchInternalProviderWelcomeEmail batchADID = new BatchInternalProviderWelcomeEmail();
        Database.executeBatch(batchADID,1);
    }
}