/**
    * @author       :   OffshoreTeam
    * @date         :   03/11/2015 (DD/MM/YYYY)
    * @description  :   REQ 3378 - Scheduler Class for CorrespondenceMemberEmployer Member and employer Contact
    * @param        :   N/A
    * @return       :   N/A
    */
    
global class CorrespondenceMemberEmployerScheduler implements Schedulable
{
 

  global void execute(SchedulableContext sc)
  {
    CorrespondenceMemberEmployer C= new CorrespondenceMemberEmployer ();
    Id batchprocessId = Database.executeBatch(c,200);
  }
}