/**
  * @author       :   Kishore Jonnadula
  * @date         :   03/10/2016 (DD/MM/YYYY)
  * @description  :   Scheduler Class for BatchAdminAsstWelcomeEmail 
  * @param        :   N/A
  * @return       :   N/A
  */
global class BatchAdminAsstWelcomeEmailScheduler implements Schedulable {
    
    /*Execute method to shedule the batch apex class BatchAdminAsstWelcomeEmail*/
    global void execute(SchedulableContext sc)
    {
        BatchAdminAsstWelcomeEmail batchADID = new BatchAdminAsstWelcomeEmail();
        Database.executeBatch(batchADID,1);
    }
}