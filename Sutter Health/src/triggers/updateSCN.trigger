/**
    *    Trigger Name: updateSCN
    *    Author:Pulkit Jain
    *    Date: 04-Feb-2015
    *    Description: This Trigger is written to create apex sharing and update OWner as per Rejection.
    *    History
    *    --------
    *    VERSION    AUTHOR           DATE                    DETAIL
    *       1.0     IDC Offshore   02/04/2014       Ad ded Comments and Indentation
    *       2.0     IDC Offshore   10/03/2016       Wave 1 - 3880 : Added code to identify the archived contacts and throw the error message
*                                                   to not select the archived contact in SCN.
            3.0     IDC Offshore   11/14/2016       Wave 2 - 3980 : 
                                                    1. Identifying the cloned records and deleting benefit plans for them.
                                                    2. Associating the benefit plans from Opportunity or Sold Sign Off when SCN is created.
                                                    3. Associating the SCN benefit plans to Account once SCN is final approved.
                                                    4. Auto Popualting the data from Opportunity when SCN is created.
                                                    5. Checking the mandatory fields are filled or not before submitting for approval.
                                                    6. Updating opportunity "Is Child Record Created?" field which is used for technical perspective,
                                                       which will restrict the user to select plans at Opportunity level once SCN is created.
           4.0     Deloitte   16/03/2017    SFSHP-5,Sales - SCN - Visual Notification of Changes in SCN.
                                                    Pulling the SCN Name from URL and populating the lookup named Solid_Case_Notification__c.
    **/
    trigger updateSCN on Employer_Group_Data__c (before insert,before update,after insert,after update)
    {
            /*Req - 3880 Archive changes STARTS */
        map<String,ID> SCNMap = new map<String,ID>();
    if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore){
        Set<ID> archiveConIds = new Set<ID>();
        Set<ID> clonedRecordSet = new Set<ID>();//3182
        for(Employer_Group_Data__c scnObj : Trigger.New){
            archiveConIds.add(scnObj.BillingContact_Name__c);
            archiveConIds.add(scnObj.EDI_Vendor_Name__c);
            archiveConIds.add(scnObj.HREmployer_Portal_Name1__c);
            archiveConIds.add(scnObj.HREmployer_Portal_Name__c);
            archiveConIds.add(scnObj.HREnrollment_Name__c);
            archiveConIds.add(scnObj.Vendor_Contact_Name__c);
            if(trigger.isInsert)
            {
               SCNMap.put(scnObj.Cloned_from__c,null); 
            }
        }
        //SHP5 Visual Notification of Changes in SCN
        if(trigger.isInsert && trigger.isBefore && !SCNMap.isEmpty())
        {
            for(Employer_Group_Data__c E :[select ID,Name from Employer_Group_Data__c where Name IN : SCNMap.KeySet()])
            {
                SCNMap.put(E.Name,E.ID);
            }
            for(Employer_Group_Data__c E : trigger.New)
            {
                E.Sold_Case_Notification__c = SCNMap.get(E.Cloned_from__c);
                E.RecordTypeID = Schema.SObjectType.Employer_Group_Data__c.getRecordTypeInfosByName().get('Cloned SCN').getRecordTypeId();
            }
        }
        
        if(!archiveConIds.isEmpty()){
            Map<String,Contact> conMap = new Map<String,Contact>([select ID,Archive__c from Contact where ID IN:archiveConIds and Archive__c = true]);
            for(Employer_Group_Data__c scnObj : Trigger.New){
                if(conMap.get(scnObj.BillingContact_Name__c) != NULL && conMap.get(scnObj.BillingContact_Name__c).Archive__c){
                    scnObj.BillingContact_Name__c.AddError(System.Label.SHP_Archive_Error);
                }else if(conMap.get(scnObj.EDI_Vendor_Name__c) != NULL && conMap.get(scnObj.EDI_Vendor_Name__c).Archive__c){
                    scnObj.EDI_Vendor_Name__c.AddError(System.Label.SHP_Archive_Error);
                }else if(conMap.get(scnObj.HREmployer_Portal_Name1__c) != NULL && conMap.get(scnObj.HREmployer_Portal_Name1__c).Archive__c){
                    scnObj.HREmployer_Portal_Name1__c.AddError(System.Label.SHP_Archive_Error);
                }else if(conMap.get(scnObj.HREmployer_Portal_Name__c) != NULL && conMap.get(scnObj.HREmployer_Portal_Name__c).Archive__c){
                    scnObj.HREmployer_Portal_Name__c.AddError(System.Label.SHP_Archive_Error);
                }else if(conMap.get(scnObj.HREnrollment_Name__c) != NULL && conMap.get(scnObj.HREnrollment_Name__c).Archive__c){
                    scnObj.HREnrollment_Name__c.AddError(System.Label.SHP_Archive_Error);
                }else if(conMap.get(scnObj.Vendor_Contact_Name__c) != NULL && conMap.get(scnObj.Vendor_Contact_Name__c).Archive__c){
                    scnObj.Vendor_Contact_Name__c.AddError(System.Label.SHP_Archive_Error);
                }
            }
        }
        /*Req 3980 SHP Wave 2 Changes START*/
        if(Trigger.isUpdate && Trigger.isBefore){
            for(Employer_Group_Data__c scnObj : Trigger.New){
                if(scnObj.Cloned_Record__c && scnObj.Tech_Cloned_Record__c){
                    clonedRecordSet.add(scnObj.Id);
                    scnObj.Tech_Cloned_Record__c = false;
                }
                //checking mandatory fiedls are filled or not before submitting for approval
                if(Trigger.OldMap.get(scnObj.id).Stage__c !=  Trigger.NewMap.get(scnObj.id).Stage__c && scnObj.Stage__c.equalsIgnoreCase(System.Label.HR176_UnderwritingReview)){
                    if(String.isBlank(scnObj.Company_Name__c) || String.isBlank(scnObj.Federal_Employer_ID_Number__c) || String.isBlank(scnObj.Phone_Number__c) ||
                       String.isBlank(scnObj.Group_Type__c) || String.isBlank(scnObj.city_SA__c) || String.isBlank(scnObj.State_SA__c) || String.isBlank(scnObj.Zip_SA__c) ||
                       String.isBlank(String.valueOf(scnObj.of_Employees__c)) || String.isBlank(String.valueOf(scnObj.of_Eligible_Employees__c)) || String.isBlank(String.valueOf(scnObj.Projected_Enrollment__c)) || 
                       String.isBlank(String.valueOf(scnObj.Effective_Date__c)) || String.isBlank(String.valueOf(scnObj.Cobra_Members_with_this_Group__c)) || String.isBlank(String.valueOf(scnObj.Performance_or_Implementation__c)) || 
                       String.isBlank(String.valueOf(scnObj.CompletedBy__c)) || String.isBlank(String.valueOf(scnObj.AuditorName__c)) || String.isBlank(scnObj.Broker_Agency__c) || String.isBlank(scnObj.Broker_Name__c)){
                           scnObj.addError(System.Label.HR188_SCNMandatoryFields);
                       }
                }
            }
            
        }
        //to delete the benefit plan association records for cloned SCN
        if(clonedRecordSet != NULL && !clonedRecordSet.isEmpty()){
            List<Benefit_Plan_Association__c> deletePlansList = [select id from Benefit_Plan_Association__c where Sold_Case_Notification__c IN :clonedRecordSet];
            List<Rates__c> rateList = [select id from Rates__c where Sold_Case_Notification__c IN :clonedRecordSet] ;
            if(deletePlansList != NULL && !deletePlansList.isEmpty()){
                delete deletePlansList;
            }
            if(rateList != NULL && !rateList.isEmpty()){
                delete rateList;
            } 
        }
        /*Req 3980 SHP Wave 2 Changes END */
        /* Req - 3980 Auto populate SCN Data from Opportunity STARTS */
        if(Trigger.isInsert && Trigger.isBefore){
            if(HighRoads_SCNTriggerHelper.isSCNBeforeInsert){
                HighRoads_SCNTriggerHelper scnHelper = new HighRoads_SCNTriggerHelper();
                scnHelper.autoPopulateSCNData(Trigger.New);
            }
        }
        /* Req - 3980 Auto populate SCN Data from Opportunity ENDS */
        //auto populate / un populate the contact lookup details
        if(HighRoads_AutoPopulateSCNContactDetails.isSCNBeforeUpdate){
            new HighRoads_AutoPopulateSCNContactDetails().autoPopulateEmailandPhone(Trigger.New,archiveConIds);
            HighRoads_AutoPopulateSCNContactDetails.isSCNBeforeUpdate = false;
        }
    }
    /*Req - 3880 Archive changes ENDS */
        
        // list of Apex Share records to be inserted
      List <Employer_Group_Data__Share> SCNSharingToInsert=  new List <Employer_Group_Data__Share>() ;
      List <Id> acctidstoupdate = new List<Id>(); // Req - 3385
      List<Account> accTempList = new List<Account>(); // Req - 3385
      Public Boolean religious;  // Req - 3385
      
      If (trigger.isupdate && trigger.isBefore){
          /*Req-3980 Change Start*/
          List<Employer_Group_Data__c> relatedbpaList = new List<Employer_Group_Data__c>();
          relatedbpaList = [select id,name,Stage__c,(select id,name,Raider_ID__c,Benefit_Plan_Metadata__r.Plan_Status__c,
                                                     Raider_ID__r.Plan_Status__c,Raider_ID__r.Name,Benefit_Plan_Metadata__r.Name
                                                     FROM Benefit_Plan_Associations__r)
                     From Employer_Group_Data__c where ID IN: Trigger.new];
          for (Integer i = 0; i < Trigger.new.size(); i++) 
           {
             Employer_Group_Data__c rec = Trigger.new[i];
              for (Employer_Group_Data__c scn : relatedbpaList){
                  
                  if ((Trigger.newmap.get(scn.id).Stage__c != Trigger.oldmap.get(scn.id).Stage__c) && (Trigger.newmap.get(scn.id).Stage__c == 'Underwriting Review' || Trigger.newmap.get(scn.id).Stage__c == 'Completed' || Trigger.newmap.get(scn.id).Stage__c == 'Submitted for QA' || Trigger.newmap.get(scn.id).Stage__c == 'Enrollment QA Pass' || Trigger.newmap.get(scn.id).Stage__c == 'Approved')){
                    for(Benefit_Plan_Association__c bpaObj : scn.Benefit_Plan_Associations__r){
                        
                        if(bpaObj.Raider_ID__c != NULL && bpaObj.Raider_ID__r.Plan_Status__c == 'Not Available for Sale'){
                            rec.addError(bpaObj.Raider_ID__r.Name+' is Not Available for Sale. Please unselect this plan & Resubmit');
                        }
                        if(bpaObj.Raider_ID__c == NULL && bpaObj.Benefit_Plan_Metadata__r.Plan_Status__c == 'Not Available for Sale'){ 
                            rec.addError(bpaObj.Benefit_Plan_Metadata__r.Name+' is Not Available for Sale. Please unselect this plan & Resubmit');    
                        }    
                    }
                }    
              }
           }
          /*Req-3980 Change End*/
        /*START Code is added to generate the hours in each stage for reporting purpose */
       Map <id,ProcessInstance> targetwithPRinstance= new  Map<id,ProcessInstance>();
       ID businesshoursIdSHPSales  =  [select id from BusinessHours where Name = 'SHP Sales Business hours' limit 1].Id;
       for(ProcessInstance PRInstance : [Select Id,TargetObjectId,(Select Id,ElapsedTimeInHours,ProcessNodeName from Nodes ORDER BY ProcessNodeName ASC NULLS LAST) From ProcessInstance Where TargetObjectId IN:Trigger.new])
         {
         
         targetwithPRinstance.put(PRInstance.TargetObjectId,PRInstance);
         }
         /*END Code is added to generate the hours in each stage for reporting purpose */
        for (Employer_Group_Data__c emplg : Trigger.new)   //loops through the new values of the records being updated
        { 
            /*This is added  to stamp the draft start time in case of a record is updated*/
          If (emplg.Stage__c != (Trigger.oldmap.get(emplg.id).Stage__c) && (emplg.Stage__c == 'Draft' || emplg.Stage__c =='Rejected by Underwriting' || emplg.Stage__c =='Rejected'))
            {
             
                emplg.Draft_Start_Time__c = System.now();
            }
            else If (emplg.Stage__c != (Trigger.oldmap.get(emplg.id).Stage__c) && emplg.Stage__c == 'Underwriting Review')
            {
            
                    emplg.Underwriting_Start_Time__c = System.now();
                    If(emplg.Draft_hours__c == null && emplg.Draft_Start_Time__c != null)
                     emplg.Draft_hours__c =  Decimal.valueOf(BusinessHours.diff(businesshoursIdSHPSales,emplg.Draft_Start_Time__c,System.now()))/3600000;
                   else if(emplg.Draft_Start_Time__c != null)
                     emplg.Draft_hours__c = emplg.Draft_hours__c+(Decimal.valueOf(BusinessHours.diff(businesshoursIdSHPSales,emplg.Draft_Start_Time__c,System.now()))/3600000);
            }
            
             If (emplg.Stage__c != (Trigger.oldmap.get(emplg.id).Stage__c) && (emplg.Stage__c == 'Completed' || emplg.Stage__c == 'Rejected by Underwriting'))
            {
                    If(emplg.Stage__c == 'Completed')
                    {emplg.Enrollment_Start_Time__c = System.now();
                    }
                    
                    If(emplg.Underwriting_hours__c == null && emplg.Underwriting_Start_Time__c != null)
                     emplg.Underwriting_hours__c =  Decimal.valueOf(BusinessHours.diff(businesshoursIdSHPSales,emplg.Underwriting_Start_Time__c,System.now()))/3600000;
                   else if(emplg.Underwriting_Start_Time__c != null)
                      emplg.Underwriting_hours__c =  emplg.Underwriting_hours__c+(Decimal.valueOf(BusinessHours.diff(businesshoursIdSHPSales,emplg.Underwriting_Start_Time__c,System.now()))/3600000);
            }
            
            
            If (emplg.Stage__c != (Trigger.oldmap.get(emplg.id).Stage__c) && (emplg.Stage__c == 'Approved' ||emplg.Stage__c == 'Rejected') )
            { 
            
                If(emplg.Enrollment_hours__c == null && emplg.Enrollment_Start_Time__c != null)
                     emplg.Enrollment_hours__c =  Decimal.valueOf(BusinessHours.diff(businesshoursIdSHPSales,emplg.Enrollment_Start_Time__c,System.now()))/3600000;
                   else if(emplg.Enrollment_Start_Time__c  != null)
                     emplg.Enrollment_hours__c =  emplg.Enrollment_hours__c+(Decimal.valueOf(BusinessHours.diff(businesshoursIdSHPSales,emplg.Enrollment_Start_Time__c,System.now()))/3600000);
            }
          
          /* This condition ensures that the record is shared as read only with the Approver/Rejector of SCN */
          
          If (emplg.Stage__c == 'Rejected' || emplg.Stage__c == 'Rejected by Underwriting'  || emplg.Stage__c == 'Approved' &&    emplg.Stage__c != (Trigger.oldmap.get(emplg.id).Stage__c))
          {
            Employer_Group_Data__Share SCNShr  = new Employer_Group_Data__Share();
            
            SCNShr.ParentId = emplg.id;
            
            // Set the ID of user or group being granted access.
            SCNShr.UserOrGroupId = UserInfo.getUserId();
            
            // Set the access level.
            SCNShr.AccessLevel = 'Read';
            
            // Set rowCause of sharing.
            
            SCNShr.RowCause = Schema.Employer_Group_Data__Share.RowCause.Approver__c;
            
            // Add the record to the list of share records which will be inserted in bulk
            SCNSharingToInsert.add (SCNShr);
          }
          /*This condition grants read access to the user who completed the SCN */
          If (emplg.Stage__c == 'Completed'  && emplg.Stage__c != (Trigger.oldmap.get(emplg.id).Stage__c))
          {
            
            Employer_Group_Data__Share SCNShr  = new Employer_Group_Data__Share();
            
            SCNShr.ParentId = emplg.id;
            
            // Set the ID of user or group being granted access.
            SCNShr.UserOrGroupId = UserInfo.getUserId();
            
            // Set the access level.
            SCNShr.AccessLevel = 'Read';
            
            // Set rowCause of sharing.
            
            SCNShr.RowCause = Schema.Employer_Group_Data__Share.RowCause.Submitter__c;
            
            // Adds the record to the list of Sharing records to insert
            SCNSharingToInsert.add (SCNShr);
            
          }
              
          // Req - 3385
          acctidstoupdate.add(emplg.Opportunity__c);
          religious = emplg.Religious_Exemption_Applied__c;
        }
        
         // Req - 3385
        for(Opportunity o2 : [Select AccountID From Opportunity Where id IN :acctidstoupdate])
        {  
            acctidstoupdate.add(o2.AccountId);
        }
        accTempList = [select id from account where id IN : acctidstoupdate];
        if(religious == true)
        {
            for(Account a2 : accTempList)
            {
              a2.Religious_Exemption_Applied__c = true;
                /* Req - 3880 Archive fix */
              HighRoads_ArchivedContacts.isByPassValidationUpdated = false;
            }try{update accTempList;}catch(Exception e){}
        }
        else
        {
            for(Account a2 : accTempList)
            {
                a2.Religious_Exemption_Applied__c = false;
                /* Req - 3880 Archive fix */
                HighRoads_ArchivedContacts.isByPassValidationUpdated = false;
            }   try{update accTempList;}catch(Exception e){}
            
        }    
        
      }        
      If (trigger.isinsert && trigger.isAfter) 
      {
          /*********** Req-3980 HighRoads Implementation STARTS ****************************************/  
          //to update benefit plan association records with SCN information
          Map<ID,ID> ssoSCNMap = new Map<ID,ID>();
          Map<ID,ID> oppSCNMap = new Map<ID,ID>();
          for(Employer_Group_Data__c scn : Trigger.New){
              if(scn.Sold_Sign_Off__c != NULL){
                  ssoSCNMap.put(scn.Sold_Sign_Off__c,scn.id);
              }else if(scn.Opportunity__c != NULL){
                  oppSCNMap.put(scn.Opportunity__c, scn.id);
              }
          }
          
          if((!ssoSCNMap.isEmpty() || !oppSCNMap.isEmpty() )&& HighRoads_CopyOppPlansToRFPANDSCN.isSCNAfterInsert){
              HighRoads_CopyOppPlansToRFPANDSCN scn = new HighRoads_CopyOppPlansToRFPANDSCN();
              scn.copyOppPlansToSCN(ssoSCNMap,oppSCNMap);
              HighRoads_CopyOppPlansToRFPANDSCN.isSCNAfterInsert = false;
          }
          if(HighRoads_SCNTriggerHelper.isSCNAfterInsert){
              HighRoads_SCNTriggerHelper scnHelperObj = new HighRoads_SCNTriggerHelper();
              scnHelperObj.updateOpponSCNCreation(Trigger.New);
              HighRoads_SCNTriggerHelper.isSCNAfterInsert = false;
          }
      }
        
     if(Trigger.isAfter && Trigger.isUpdate){
            Set<ID> updatedIds = new Set<ID>();
            for(Employer_Group_Data__c scn : Trigger.New){
                if(scn.Stage__c != NULL && scn.Stage__c.equalsIgnoreCase(System.Label.CL_29_SM_Approved)){
                    updatedIds.add(scn.id);
                }
            }

            if(!updatedIds.isEmpty() && HighRoads_CopyOppPlansToRFPANDSCN.isSCNAfterUpdate){
                HighRoads_CopyOppPlansToRFPANDSCN updateAccountObj = new HighRoads_CopyOppPlansToRFPANDSCN();
                updateAccountObj.updateAccountIdonBPA(updatedIds);
                HighRoads_CopyOppPlansToRFPANDSCN.isSCNAfterUpdate = false;
            }
        }
       /*********** Req-3980 HighRoads Implementation ENDS ****************************************/  
      try
       {// We try to insert the SCN Share object if the list has some values
        If (SCNSharingToInsert.size() > 0 )
        List <Database.SaveResult> sr = Database.insert(SCNSharingToInsert,false);
       }
      Catch (Exception triggerException)
       {
        Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
       } 
    }