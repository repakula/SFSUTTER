/**    
 *     Class Name  : RenewOpportunity_Batch
 *     Author      : IDC Offshore  
 *     Date        : 9-Feb-2015  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : This class contains the method to check if the trigger is runing due to first insert/update operation 
                     and set the run boolean false after first execution to avoid the recursive execution. 
 **/
public Class checkRecursive{
    private static boolean run = true;
    public static boolean runOnce(){
    if(run){
     run=false;
     return true;
    }else{
        return run;
    }
    }
    public static void setRunTrue() {
        run = true;
    }
}