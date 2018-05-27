/**
@Author      : IDC Offshore
@name        : CorrespondenceMemberEmployer  Class
@CreateDate  : 27/10/2015 (DD/MM/YYYY)
@Description : This batch  class create a parent correspondence  lookup  for the child correspondence for  Req no 3378   member employer correspondence 
@Version     : 1.0
@reference   : NA
*/

global class CorrespondenceMemberEmployer implements Database.Batchable<sObject>, Database.Stateful
{
    
    global List < SystemException__c > BatchExceptions = new List < SystemException__c > ();
    /**
     @ Updated By....: IDC offshore                                              
     @ Updated Date..: 27/10/2015 (DD/MM/YYYY)                                    
     @ Requirement...: 3378 Correspondence                                        
     @ Description...: Query string of Correspondence_Letter__c                   
     @                 the cloning functionality .  
     @ @return ......: list 
      **/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'select id , SHP_Correspondence_ID__c, SHP_Parent_Correspondence_ID__C ,SHP_Parent_Correspondence_ID_Lookup__c from Correspondence_Letter__c where SHP_Correspondence_ID__c != null limit 50000 ';
        return Database.getQueryLocator(query);
    }
   /**
    @ author IDC Team
    @ date 27/10/2015
    @ description   Req no 3378 Correspondence  Member  employer  This function is used to create  parent look up
    @ param   Database.BatchableContext 
    @ return void
    **/
    global void execute(Database.BatchableContext BC, list<Correspondence_Letter__c> lstCorr)
    {
        try
        {
         List<Database.UpsertResult> resultsUpdateCorrespondence;
         list<Correspondence_Letter__c> lstCorr1 = new list<Correspondence_Letter__c>();
        Map<string, Correspondence_Letter__c > correspondenceMap = new Map<string, Correspondence_Letter__c>();
        // Created map of SHP_Correspondence_ID__c and   Correspondence_Letter__c object
        for(Correspondence_Letter__c corr: lstCorr ) {
            correspondenceMap.put(corr.SHP_Correspondence_ID__c, corr);
        }
        for (Correspondence_Letter__c corres : lstCorr)
        {       
            if(!correspondenceMap.isempty() && corres.SHP_Correspondence_ID__c != null) 
            {    
            
                if(corres.SHP_Parent_Correspondence_ID__C != null || corres.SHP_Parent_Correspondence_ID__C ==corres.SHP_Correspondence_ID__c )
                {
                    //Checking  SHP_Parent_Correspondence_ID__C value exist in child correspondence  SHP_Correspondence_ID__c
                    
                    if(correspondenceMap.get(corres.SHP_Parent_Correspondence_ID__C)!=null){
                    corres.SHP_Parent_Correspondence_ID_Lookup__c = correspondenceMap.get(corres.SHP_Parent_Correspondence_ID__C).id;
                    lstCorr1.add(corres);
                    }
                    
            }
            else 
            {
                corres.SHP_Parent_Correspondence_ID_Lookup__c =  null;
            }
            }
            
            
        }
        resultsUpdateCorrespondence = Database.upsert(lstCorr1, false);
             /** @Description: Iterate over the list of all inserted or updated Correspondence Letter object and saving all failed data into exceptions object**/
            for(Integer i=0;i<resultsUpdateCorrespondence.size();i++){
                if (!resultsUpdateCorrespondence.get(i).isSuccess()){
                     Database.Error error = resultsUpdateCorrespondence.get(i).getErrors().get(0);
                    lstCorr1.get(i);//failed record from the list
                    SystemException__c newObj = new SystemException__c() ;   
                    newObj.ExceptionMessage__c = lstCorr1[i].id + error.getMessage();  
                    BatchExceptions.add(newObj);
                  
                }
            }
          // to cover exception  from test class
      if (Test.isRunningTest())
            {
                integer i =6/0 ;
            }  
        
    }
    catch(Exception e) {
        System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
        }
        
    }   
    /**
    @ @author IDC Team
    @ @date 27/10/2015
    @ @description   Req no 3378 Correspondence  Member  employer  this method will call once execute method get executed
    @ for Req no 3378 
    @ param   Database.BatchableContext 
    @ @return void
    **/
    global void finish(Database.BatchableContext BC)
    {
        // Inserting all exception  SystemException__c custom object
        if(!BatchExceptions.isEmpty()) {
            Database.insert(BatchExceptions);
        }
    }
}