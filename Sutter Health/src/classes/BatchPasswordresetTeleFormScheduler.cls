/**
    * @author       :   OffshoreTeam
    * @date         :   31/03/2015 (DD/MM/YYYY)
    * @description  :   REQ 3399 - Scheduler Class for BatchPasswordreset 
    * @param        :   N/A
    * @return       :   N/A
    */
    
global class BatchPasswordresetTeleFormScheduler implements Schedulable
{
 

  global void execute(SchedulableContext sc)
  {
    BatchPasswordresetTeleForm b = new BatchPasswordresetTeleForm();
    Id batchprocessId = Database.executeBatch(b,1);
     
  }
}