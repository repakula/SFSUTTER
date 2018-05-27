/**
    * @author       :   OffshoreTeam
    * @date         :   01/16/2015 (DD/MM/YYYY)
    * @description  :   Scheduler Class
    * @param        :   N/A
    * @return       :   N/A
    */
    
global class DeliverabilityCheckScheduler implements Schedulable
{
    global static void scheduleMe(String mode)
  {
    DeliverabilityCheckScheduler  dcs = new DeliverabilityCheckScheduler();
    String sch = '0 0 0 * * ?'; // base this on mode or whatever your params are
    String jobID = system.schedule('Scheduled Job', sch, dcs);
  }
  
    global void execute(SchedulableContext sc)
  {
    DeliverabilityCheck  dc = new DeliverabilityCheck();
    dc.sendDeliverabilityEmails(null);
  }
}