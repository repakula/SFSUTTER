/**
* @author       :   Kishore Jonnadula
* @date         :   29/09/2016 (DD/MM/YYYY)
* @description  :   Scheduler Class for BatchAdminAssistantUserCreation 
* @param        :   N/A
* @return       :   N/A
*/
global class BatchAdminAssistantUserScheduler implements schedulable{
    static final String adminAsstUpdateJob = 'Admin Assistant User Update Job ';
    static final String adminAsstCreateJob = 'Admin Assistant User Create Job ';
    static final String errorStr = '@@Error debug : ';
    static final String hyphenStr = '--------------';
    
    /*Execute method to shedule the batch apex class BatchAdminAssistantUserCreation*/ 
    global void execute(SchedulableContext sc)
    {
        try {
            BatchAdminAssistantUserCreation batchadminAssistant = new BatchAdminAssistantUserCreation();
            Database.executeBatch(batchadminAssistant,200);
            
            BatchAdminAssistantUserScheduler objBatchUserCreate = new BatchAdminAssistantUserScheduler();
            BatchAdminUserUpdateScheduler objBatchAdminUpdate = new BatchAdminUserUpdateScheduler();
            
            Datetime currentDatetime = datetime.now().addMinutes(5); // getting the current datetime value and add 3 minutes
            Datetime nextScheduleTime = datetime.now().addHours(1); // getting the current datetime value and add 1 hour
            //Datetime nextScheduleTime = datetime.now().addMinutes(15); // getting the current datetime value and add 3 minutes
            
            Integer currentHour = currentDatetime.hour(); // getting the current hour
            String strMin = String.valueOf(currentDatetime.minute()); // getting the current minute 
            Integer currentSec = currentDatetime.second(); // getting the current second value.
            String strHour = String.valueOf(currentHour);
            String strSec = String.valueOf(currentSec);
            string jobName = adminAsstUpdateJob +  
                currentDatetime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            
            String strExp= strSec+' '+strMin+' '+strHour+' ';
            String strschExp = strExp+'* * ?';// Here we have created the Cron Expression for the job of User Update
            String jobID = system.schedule(jobName, strschExp, objBatchAdminUpdate);
            
            currentHour = nextScheduleTime.hour(); // getting the current hour
            strMin = String.valueOf(nextScheduleTime.minute()); // getting the current minute 
            currentSec = nextScheduleTime.second(); // getting the current second value.
            strHour = String.valueOf(currentHour);
            strSec = String.valueOf(currentSec);
            jobName = adminAsstCreateJob +  
                currentDatetime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            strExp= strSec+' '+strMin+' '+strHour+' ';
            strschExp = strExp+'* * ?';// Here we have created the Cron Expression for the job of User Update
            String jobIDUserCreate = system.schedule(jobName, strschExp, objBatchUserCreate);  
            
            system.abortJob(sc.getTriggerId()); 
        } catch(Exception ex) {
            system.debug(errorStr + ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + hyphenStr);
            Utility.handleExceptionFromCode(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + hyphenStr);
        }
    }
}