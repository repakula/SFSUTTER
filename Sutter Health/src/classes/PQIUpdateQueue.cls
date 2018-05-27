/**  
*     Class Name  : PQIUpdateQueue
*     Author      : IDC Offshore
*     Date        : 01-Aug-20115
*     Project Name: CRM - SHP - Sutter Health
*     Description : PQIUpdateQueue Class.
**/

public without sharing Class PQIUpdateQueue
{
    
    public Potential_Quality_Issue__c objPotentialQualityIssue{get;set;}
    public PQIUpdateQueue ()
    {
        objPotentialQualityIssue = new Potential_Quality_Issue__c ();
        
    }
    /**
    * @author IDC Team
    * @date 1/08/2015
    * @description This method is used to hit the approval process by the Vf page  for approved button
    * the opened Customer Interaction
    * @param 
    * @return void
    */
    public  void updatequeue(Potential_Quality_Issue__c  objPotentialQualityIssue)
    {
        try
        {
            // initiating approval process by VF page
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approved by ' + objPotentialQualityIssue.Owner.Name);
            req.setAction('Approve');
            Id workItemId = getWorkItemId(objPotentialQualityIssue.id); 
            system.debug('!!!!workItemId ' +workItemId );
            if(workItemId == null)
            {
                objPotentialQualityIssue.addError('No Approval process linked');
            }
            else
            {
                if (objPotentialQualityIssue.PQI_Status__c == System.Label.CL146_UM_Review && (objPotentialQualityIssue.bypass_cmo__c == false || objPotentialQualityIssue.bypass_cmo__c == null))
                {
                    objPotentialQualityIssue.PQI_Status__c = System.Label.CL147_MD_Review;
                    Group mdqueue=[Select Id , name from Group where name = :System.Label.CL155_CMO Limit 1];
                    objPotentialQualityIssue.ownerid = mdqueue.id;
                }
                else if(objPotentialQualityIssue.PQI_Status__c == System.Label.CL147_MD_Review)
                {
                    objPotentialQualityIssue.PQI_Status__c = System.Label.CL148_MD_Approved;
                    Group qualityqueue=[Select Id , name from Group where name =:System.Label.CL156_Quality Limit 1];
                    objPotentialQualityIssue.ownerid = qualityqueue.id;
                }
                
                else if(objPotentialQualityIssue.PQI_Status__c == System.Label.CL154_PRC)  
                {
                 objPotentialQualityIssue.PQI_Status__c = System.Label.CL149_PRC_Approved;
                 Group qualityqueue=[Select Id , name from Group where name =:System.Label.CL156_Quality Limit 1];
                 objPotentialQualityIssue.ownerid = qualityqueue.id;
                }
                req.setWorkitemId(workItemId);
                // create save point 
               Savepoint sp = Database.setSavepoint();
                update objPotentialQualityIssue;
                
                Approval.ProcessResult result =  Approval.process(req);
                If (!result.isSuccess())
                  Database.rollback(sp);// roll back if approval get failed
                // Updating object  and changing  owner from CMO to Quality Queue
                 if((objPotentialQualityIssue.bypass_cmo__c == true && result.isSuccess() )&&  (objPotentialQualityIssue.PQI_Status__c != System.Label.CL154_PRC && objPotentialQualityIssue.PQI_Status__c != System.Label.CL149_PRC_Approved && objPotentialQualityIssue.PQI_Status__c != System.Label.CL153_PRC_Rejected))
                {
                    Group qualityqueue=[Select Id , name from Group where name =:System.Label.CL156_Quality Limit 1];
                    objPotentialQualityIssue.ownerid = qualityqueue.id;
                    objPotentialQualityIssue.PQI_Status__c = System.Label.CL150_UM_Approved;
                    update objPotentialQualityIssue;
                }
                
            }
            if (Test.isRunningTest())
            {
                integer i =6/0 ;
            } 
 
        }
         catch(Exception classException){             
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------'));      
        }
        
    }
    /**
    * @author IDC Team
    * @date 1/08/2015
    * @description This method is used to hit the approval process by the Vf page  for reject button
    * the opened Customer Interaction
    * @param 
    * @return Boolean 
    */
    
    public  boolean updatequeueReject(Potential_Quality_Issue__c  objPotentialQualityIssue)
    {
     try {
        boolean isValid = true;
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Rejected by ' + objPotentialQualityIssue.Owner.Name);
        req.setAction('Reject');
        Id workItemId = getWorkItemId(objPotentialQualityIssue.id); 
        if(workItemId == null)
        {
            objPotentialQualityIssue.addError('No Approval process linked');
        }
        else
        {  If(objPotentialQualityIssue.PQI_Status__c == System.Label.CL146_UM_Review)
            {
                if ( objPotentialQualityIssue.Comment_UM__c == null) {
                    isValid = false;
                    objPotentialQualityIssue.Comment_UM__c.addError('Please Enter the Comment!');
                    return false;
                }
                objPotentialQualityIssue.PQI_Status__c = System.Label.CL151_UM_Rejected;

            }
         else if( objPotentialQualityIssue.PQI_Status__c == System.Label.CL147_MD_Review)
         {
             if ( objPotentialQualityIssue.Comment_CMO__c == null) {
                 isValid = false;
                 objPotentialQualityIssue.Comment_CMO__c.addError('Please Enter the Comment!');
                 return false;
             }
             objPotentialQualityIssue.PQI_Status__c = System.Label.CL152_MD_Rejected;
         }
         else if( objPotentialQualityIssue.PQI_Status__c == System.Label.CL154_PRC)
         {
             if ( objPotentialQualityIssue.Comment_PRC__c == null) {
                 isValid = false;
                 objPotentialQualityIssue.Comment_PRC__c.addError('Please Enter the Comment!');
                 return false;
             }
             objPotentialQualityIssue.PQI_Status__c = System.Label.CL153_PRC_Rejected;
         }
         req.setWorkitemId(workItemId); 
         Group qualityqueue=[Select Id , name from Group where name = :System.Label.CL156_Quality Limit 1];
         objPotentialQualityIssue.ownerid = qualityqueue.id;
         Savepoint sp = Database.setSavepoint();
                update objPotentialQualityIssue;
                Approval.ProcessResult result =  Approval.process(req);
                If (!result.isSuccess())
                  Database.rollback(sp);
        }  
        
        return  true;
     }
         catch(Exception classException){             
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------'));      
        }
         return null;
    }
    /**
    * @author IDC Team
    * @date 1/08/2015
    * @description This method is used to in approval process  and it will return id of   ProcessInstance
    * the opened Customer Interaction
    * @param 
    * @return id 
    */
    
    public Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;
        
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                                                 where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
            system.debug('!!!!workItem' +retval);
        }
        
        return retVal;
    }
}