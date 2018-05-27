/**
    * @author       :   OffshoreTeam
    * @date         :   01/28/2015 (DD/MM/YYYY)
    * @description  :   Scheduler Class for ProviderForgetPassword Class
    * @param        :   N/A
    * @return       :   N/A
    */
    
global class ProviderChangePasswordScheduler implements Schedulable
{
  global static void scheduleMe(String mode)
  {
    ProviderChangePasswordScheduler pfps = new ProviderChangePasswordScheduler();
    String sch = '0 0 0 * * ?'; // base this on mode or whatever your params are
    String jobID = system.schedule('Scheduled Job', sch, pfps);
  }

  global void execute(SchedulableContext sc)
  {
    ProviderChangePassword pfp = new ProviderChangePassword();
    pfp.SendChangePasswordUrl();
  }
}