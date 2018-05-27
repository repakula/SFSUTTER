/*************************************************************************************************************
*     Trigger Name: ShareEmployerActivity 
*     Author      : IDC Offshore                                                                                                                                            
*     Date        : 21-Apr-2016                                                                                                                                             
*     Project Name: CRM - SFT - Sutter Health                                                                                                                                        
*     Description : Trigger is used to share the Employer Activity.   
**************************************************************************************************************/
    trigger ShareEmployerActivity on Employer_Activity__c (after insert, before update) 
    {
         List<Employer_Activity__Share> sharesToCreate = new List<Employer_Activity__Share>();
         string uid = userinfo.getUserId();
         Employer_Activity__Share cs;
         if (Trigger.isInsert)
         {
         try
         {
         {
              for (Employer_Activity__c ea : Trigger.new)
              {
                if (ea.Assigned_To__c != null && ea.Assigned_To__c != uid) 
                    {
                     cs = new Employer_Activity__Share();
                     cs.AccessLevel = System.Label.CL_40_SM_Edit;
                     cs.ParentId = ea.Id;
                     cs.UserOrGroupId =  ea.Assigned_To__c;
                     sharesToCreate.add(cs);
                     
                    }
              }

              if (sharesToCreate.size()>0)
                  {
                     insert sharesToCreate;
                  }
         }
         }
         catch (Exception ex)
         {
            cs.addError('Unable to share record. Please contact your administrator.');   
         }
         }
         if (Trigger.isUpdate)      
        { 
          try
          {       
            List<ID> shareIdsToDelete = new List<ID>();
            for (Employer_Activity__c ea : Trigger.new)
               {
                  Employer_Activity__c oldEmpActivity = Trigger.oldMap.get(ea.Id);
                  if(ea.Assigned_To__c != oldEmpActivity.Assigned_To__c)
                   {
                    shareIdsToDelete.add(ea.id);
                      if (ea.Assigned_To__c != null && ea.Assigned_To__c != uid) 
                        {
                          cs = new Employer_Activity__Share();
                          cs.AccessLevel = System.Label.CL_40_SM_Edit;
                          cs.ParentId = ea.Id;
                          cs.UserOrGroupId =  ea.Assigned_To__c;
                          sharesToCreate.add(cs);
                        }
                   }
              }
            if (shareIdsToDelete.size()>0)
               {
                    delete [select id from Employer_Activity__Share where ParentId IN :shareIdsToDelete and RowCause =: System.Label.CL_41_SM_Manual limit 50000];
               }
            if (sharesToCreate.size()>0)
               {
                    insert sharesToCreate;
               }
         }
         catch (Exception ex)
         {
             cs.addError('Unable to share record. Please contact your administrator.');
         }       
        }
    }