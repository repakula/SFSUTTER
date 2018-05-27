/**
    * @author       :   OffshoreTeam
    * @date         :   14/04/2015 (DD/MM/YYYY)
    * @description  :   REQ 3399 - Scheduler Class for BatchPasswordreset non TeleForm Contacts
    * @param        :   N/A
    * @return       :   N/A
    */
    
global class BatchPasswordresetNonTeleFormScheduler implements Schedulable
{
 

  global void execute(SchedulableContext sc)
  {
    BatchPasswordresetNonTeleForm b = new BatchPasswordresetNonTeleForm();
    Id batchprocessId = Database.executeBatch(b,1);
  }
}