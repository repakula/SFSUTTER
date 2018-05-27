global class EAFValidationReportScheduler implements Schedulable
{
 

  global void execute(SchedulableContext sc)
  {
    EAFValidationReport_New b = new EAFValidationReport_New();
    Id batchprocessId = Database.executeBatch(b);
     
  }
}