global class ProviderValidationReportScheduler implements Schedulable
{
 

  global void execute(SchedulableContext sc)
  {
    ProviderValidationReport_New b = new ProviderValidationReport_New();
    Id batchprocessId = Database.executeBatch(b);
     
  }
}