/**  
  * Class Name: BatchAdminAssistantUserCreation
  * Author: Kishore Jonnadula
  * Date: 29/09/2016
  * Description: 
 **/
global class BatchAdminAssistantUserCreation implements Database.Batchable<String>{
    
    global  List<String> adminAsstEmailList = new List<String>();
    global  List <SystemException__c> batchExceptions = new List < SystemException__c > ();
    
   /* Name: Start
    * Input: Batchable Context
    * Return Type: Database.QueryLocators
    * Description: Used to get the list of records to pass to execute method
    */
    public List<String> start(Database.BatchableContext BC){
        List<String> emailList = new List<String>();
        
        AggregateResult[] arradminAsst = [select Admin_Assistant_Email__c, count(id) from Contact_Validation_Summary__c 
                                          where Admin_Assistant_Email__c != null group by Admin_Assistant_Email__c];
        
        for(AggregateResult arr: arradminAsst)
        {
           emailList.add(String.ValueOf(arr.get(Label.CL467_PDI_AdminAssistantEmail))); 
        }
        
        return emailList;
    }
   /* Name: Execute
    * Input: List of Email Id List
    * Return Type: void
    * Used to create account and contact records for Admin assistant users.
    */
    public void execute(Database.BatchableContext BC, List<String> emailList){
        
        try {
            PDI_AdminAssistantUserHelper adminAsstHelper = new PDI_AdminAssistantUserHelper();
            if(!emailList.isEmpty()){
                adminAsstHelper.createAdminAssistantUser(emailList);
            }
        } catch(Exception e) { System.debug(e.getTypeName() + Label.CL218_rSlashN + e.getCause() + Label.CL218_rSlashN + e.getMessage()); }
    }
   
   /* Name: finish
    * Input: Batchable Context
    * Return Type: void
    */
    global void finish(Database.BatchableContext BC){
        try{
            if( BatchExceptions != null && BatchExceptions.size() > 0)  { Database.insert(BatchExceptions,false); }
        }catch( Exception ex){ System.debug(ex.getTypeName() + ' - ' + ex.getCause() + ': ' + ex.getMessage()); }
    }
}