/**    
 *     Class Name  : RenewOpportunity_Batch
 *     Author      : IDC Offshore  
 *     Date        : 9-Feb-2015  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : This Batch class is to create the new Opportuity for all those Opprtunities in Closed Won State
                     whose Plan End Date is less than 120 Days from Today. The class creates the deep clone of opportunity 
                     copying the latest approved SCN and medical plans of Old Opportunity to newly Created Opportunity. 
                     Also Opportunities without SCN are clonned without SCN.The class Fails to create the opportunities 
                     that skipped the Look up Filter validations during Creation.                    
 *    VERSION    AUTHOR         DATE        DETAIL 
 *      2.0    IDC Offshore  05/05/2016    Added condition for Opportunity record type Id for SHP Sales Opportunity in the query.
 **/
global class RenewOpportunity_Batch implements Database.Batchable < Sobject > , Schedulable,Database.Stateful {
    Integer DateLimit = Integer.valueOf(System.Label.Number_of_Days);
    Date checkdate = Date.today() + DateLimit;
    global List < SystemException__c > BatchExceptions = new List < SystemException__c > ();
    /******************************************************************************
     * Updated By....: Offshore SHP                                               *
     * Updated Date..: 30 March 2015                                              *
     * Requirement...: 3358 Screen Optimization for sales                         *
     * Description...: adding some new field in query string of Opportunity for   *
     *                 the cloning functionality .                                * 
     ******************************************************************************/
    String query = 'SELECT Id,OwnerId,Name,GA_Contact__c,Type,AccountId,Broker1__c,Broker_of_Record__c,OverrideBrokerAndBrokerRep__c,Amount,Broker_Rep1__c,Account_Manager__c,Sales_Team__c,Opp_Renewed__c,CloseDate,of_Subscribers__c,' +
                    'Underwriting_Discretionary_Discount__c,NTE_Offered__c,Incumbent_Carrier_1__c,Incumbent_Carrier_2__c,Incumbent_Carrier_3__c,of_Enrolled__c,of_Enrolled2__c,of_Enrolled3__c,'+
                    'SHP_vs_Renewal__c,SHP_vs_Renewal2__c,SHP_vs_Renewal3__c,Other_Competitive_Carrier__c,Other_Competitive_Carrier2__c,Other_Competitive_Carrier3__c,Actual_of_Members__c, '+
                    '(SELECT ACal_L_D_Expiration_Date__c,ACal_L_D_Licence__c,AuditorName__c,Benefits_Subject_to_ERISA_Regulations__c,SHP_Broker_ID__c, ' +
                    'Billing_Contact_E_mail__c,Billing_Contact_Phone__c,Billing_Street_Address__c,Broker_Agency__c, ' +
                    'Broker_Name__c,City_BA__c,city_SA__c,Religious_Exemption_Applied__c,Commissions_Medical__c,  ' +
                    'Commissions_Optional_Acu_Chiro_ACN__c,Commissions_Optional_Dental_Delta__c,Commissions_Optional_Vision_VSP__c,Company_Name__c,Completedby__c,  ' +' EDI_Vendor_E_Mail__c, Vendor_Contact_Name__c,EDI_Vendor_Name__c, EDI_Vendor_Phone__c ,'+
                    'Country_SA__c,Country__c,County__c,Date_EOC_Sent__c,Date_SBC_Sent__c,Date_Sold__c,DBA_Name__c,Distribution_List__c,Effective_Date__c,  ' +
                    'Employee_Waiting_Period_Other__c,Employee_Waiting_Period__c,Employer_Contribution_Dependents_Premium__c,Employer_Contribution_Employees_Premium__c,  ' +
                    'Employer_Defined_Eligibility_for_Benefit__c,Enrollment_Method__c,Fax_Number__c,Federal_Employer_ID_Number__c,Group_Type__c,SHP_Sales_Representative__c,  ' +
                    'Have_the_plan_numbers_changed__c,HR_Account_Number__c,HR_Employer_Portal_E_mail1__c,HR_Employer_Portal_E_mail__c,BillingContact_Name__c,HREmployer_Portal_Name1__c,HREmployer_Portal_Name__c,' +
                    'HR_Employer_Portal_Name1__c,HR_Employer_Portal_Name__c,HR_Employer_Portal_Phone1__c,HR_Employer_Portal_Phone__c,HR_Enrollment_E_mail__c,  ' +
                    'HR_Enrollment_Phone__c,Id,Member_accumulators_previous_Carrier__c,Name,New_TPA_Vendor__c,of_Eligible_Employees__c,  ' +
                    'of_Employees__c,Open_Enrollment_Date_From__c,Open_Enrollment_Date_To__c,Other_Language_Considerations__c, HREnrollment_Name__c, ' +
                    'Performance_or_Implementation__c,Phone_Number__c,Plan_vs_Calendar_Year__c,Previous_Group_Insurance_through_SHP__c,OwnerID,  ' +
                    'Projected_Enrollment__c,SCN_Approved_Date__c,SFDC_Broker_ID__c,Title__c,Type_of_Organization_Other__c,Street_Address__c, State_BA__c,State_SA__c,' +
                    'Type_of_Organization__c,User_Employer_Group_Data__c,Zip_BA__c,Zip_SA__c,Opportunity_Account_Name__c,Created_By__c,BillingContact_Name__r.AccountID,HREmployer_Portal_Name1__r.AccountID,HREmployer_Portal_Name__r.AccountID,HREnrollment_Name__r.AccountID  FROM Sold_Case_Notification__r WHERE Stage__c =\'Approved\' ORDER BY SCN_Approved_Date__c DESC NULLS LAST limit 1 ) ' +
                    'FROM Opportunity WHERE Opp_Renewed__c = false AND Plan_end_date__c <=:checkdate AND RecordTypeId = '+'\''+System.Label.SHP_Sales_Opportunity_Id     
                    + '\' and StageName = '+'\''+System.Label.Opportunity_Status+'\'';           //Added record type condition in Where clause for SHP Sales Opportunity as a part of Req-3826 in the query
                        
    global void execute(SchedulableContext SC) {
        // invoke business logic from Apex Schedular 
        RenewOpportunity_Batch runBatch = new RenewOpportunity_Batch();
        ID batchprocessid = Database.executeBatch(runBatch, 40);
    }

    /**
    *   @Description: This is a method to insert exception messages caught by failure of Opportunity/SCN/Medical Plan insert during Batch Operation.
    *   @Arguments: String exception messages     
    *   @Return: Void
    **/
    global void catchExceptionsFromCode( Database.SaveResult[] results ) {
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                Database.Error[] errs = result.getErrors();
                for(Database.Error err : errs) {
                    SystemException__c systemException = new SystemException__c();
                    systemException.ExceptionMessage__c = err.getMessage();
                    BatchExceptions.add(systemException);
                }
            }
        }
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('@@@@' + this.query);
        return Database.getQueryLocator(this.query);
    }
    /**
    *   @Description: This is a method for Processing on record of scope.
    *   @Arguments: Database.BatchableContext      
    *   @Return: Void
    **/
    global void execute(Database.BatchableContext BC, List < Opportunity > scope) {

        List < Opportunity > oppsToUpdate = new List < Opportunity > ();
        List < Medical_Plan__c > MedplanListtoInsert = new List < Medical_Plan__c > ();
        List < Opportunity > oppswithoutSCNList = new List < Opportunity > ();
        List < Opportunity > oppstoInsertListWithSCN = new List < Opportunity > ();
        //Map of SCN Ids and related Medical Plans
        Map < Id, List < Medical_Plan__c >> SCNIdMedPlanListMap = new Map < Id, List < Medical_Plan__c >> ();
        List < Employer_Group_Data__c > scnToinsert = new List < Employer_Group_Data__c > ();
        List < Employer_Group_Data__c > oldSCNList = new List < Employer_Group_Data__c > ();
        Database.SaveResult[] resultsOppWithoutSCN;
        Database.SaveResult[] resultsOppWithSCN;
        Database.SaveResult[] resultsOppUpdates;
        Database.SaveResult[] resultsSCN;
        Database.SaveResult[] resultsMedicalPlans;
        
        /*Req - 3880 Archive changes Starts */
        //Set of archived contacts
        Set<ID> archivedContacts = new Set<ID>();

        for (Opportunity opp: scope) {
            archivedContacts.add(opp.Broker_Rep1__c);
            archivedContacts.add(opp.Account_Manager__c);
            archivedContacts.add(opp.GA_Contact__c);
             if (opp.Sold_Case_Notification__r.size() > 0) {
                 for (Employer_Group_Data__c oldSCN: opp.Sold_Case_Notification__r) {
                    archivedContacts.add(oldSCN.BillingContact_Name__c);
                    archivedContacts.add(oldSCN.EDI_Vendor_Name__c);
                    archivedContacts.add(oldSCN.HREmployer_Portal_Name1__c);
                    archivedContacts.add(oldSCN.HREmployer_Portal_Name__c);
                    archivedContacts.add(oldSCN.HREnrollment_Name__c);
                    archivedContacts.add(oldSCN.Vendor_Contact_Name__c);
                }
             }
        }
        Map<String,Contact> archivedConMap = new Map<String,Contact>([select ID,Archive__c from Contact where ID IN:archivedContacts and Archive__c = true]);
        /*Req - 3880 Archive changes ENDS */
        
         /*
          * @Description: This for Loop takes every Oppotunity in Scope and creates a new clonned Opportunity from that.
                          sets the values of newly clonned Opportunity handle validations that may cause failure of opportunity
                          insert and set the Renewal Opportunity created flag to true for Old Opportunities.
         */
        for (Opportunity opp: scope) {
            Opportunity newopp = new Opportunity();
            newopp = opp.clone();
            newopp.StageName = System.Label.Renewed_Opportunity_Stage;
            newopp.CloseDate = Date.today() + DateLimit;
            newopp.Current_Status__c = System.Label.Renewed_Opportunity_Current_Status;
            newopp.Description = System.Label.Renewed_Opportunity_Description + opp.Name;
            newopp.Renewed_Opportunity__c = true;
            /*Req - 3880 Archive changes Starts */
            if(archivedConMap.containsKey(opp.Broker_Rep1__c)){
                newopp.Broker_Rep1__c = null;
            }
            if(archivedConMap.containsKey(opp.Account_Manager__c)){
                newopp.Account_Manager__c = null;
            }
            if(archivedConMap.containsKey(opp.GA_Contact__c)){
                newopp.GA_Contact__c = null;
            }
            opp.By_Pass_Archive_Contact_Validation__c = true;
            /*Req - 3880 Archive changes Ends */
            opp.Opp_Renewed__c = true;
            
            /*
             * @Description: To check wheather broker and broker Rep of Opportunity is null is so set the Broker of record 
                             to false to skip the validation for sucessful insertion and updation opportnities
             */
            if (newopp.Broker1__c == null || newopp.Broker_Rep1__c == null) {
                newopp.Broker_of_Record__c = false;
                opp.Broker_of_Record__c = false;
            }
            oppsToUpdate.add(opp);
            
            /*
             * @Description: To maintain Seperate List of Opportunities without SCN.
             */
            if (opp.Sold_Case_Notification__r.size() == 0) {
                oppswithoutSCNList.add(newopp);
            }
            
            /*
             * @Description: This loop clones the Latest approved SCN of Old Opportunity and add it to List of SCNS to insert also add the 
                             clonned opportunities in list to ensure the same order of both Opportunity and SCN.
             */
            if (opp.Sold_Case_Notification__r.size() > 0) {
                oppstoInsertListWithSCN.add(newopp);
                for (Employer_Group_Data__c oldSCN: opp.Sold_Case_Notification__r) {
                    Employer_Group_Data__c newSCN = new Employer_Group_Data__c();
                    newSCN = oldSCN.clone(false, true);
                    newSCN.Old_SCN_Id__c = oldSCN.id;
                    /* Req - 3880 Archive check box Changes STARTS */
                    if(archivedConMap.containsKey(oldSCN.BillingContact_Name__c)){
                        newSCN.BillingContact_Name__c = null;
                    }
                    if(archivedConMap.containsKey(oldSCN.EDI_Vendor_Name__c)){
                        newSCN.EDI_Vendor_Name__c = null;
                    }
                    if(archivedConMap.containsKey(oldSCN.HREmployer_Portal_Name1__c)){
                        newSCN.HREmployer_Portal_Name1__c = null;
                    }
                    if(archivedConMap.containsKey(oldSCN.HREmployer_Portal_Name__c)){
                        newSCN.HREmployer_Portal_Name__c = null;
                    }
                    if(archivedConMap.containsKey(oldSCN.HREnrollment_Name__c)){
                        newSCN.HREnrollment_Name__c = null;
                    }
                    if(archivedConMap.containsKey(oldSCN.Vendor_Contact_Name__c)){
                        newSCN.Vendor_Contact_Name__c = null;
                    }
                    /* Req - 3880 Archive check box Changes ENDs */
                    oldSCNList.add(oldSCN);
                    scnToinsert.add(newSCN);
                }
            }
        }
        try{
         //Inserting List Of Opportunities which do not have SCN
            if( oppswithoutSCNList != null && oppswithoutSCNList.size() > 0) {
                resultsOppWithoutSCN = Database.insert(oppswithoutSCNList, false);
            }
         //Exception handling for Opportunities Without SCN 
            if(resultsOppWithoutSCN != null && resultsOppWithoutSCN.size() > 0) {
                catchExceptionsFromCode(resultsOppWithoutSCN);
            }
          //Inserting List of Opportunities that are having SCN
            if( oppstoInsertListWithSCN != null && oppstoInsertListWithSCN.size() > 0) {
                resultsOppWithSCN = Database.insert(oppstoInsertListWithSCN, false);
            }
          //Exception handling for Opportunities With SCN   
            if(resultsOppWithSCN != null && resultsOppWithSCN.size() > 0) {
                catchExceptionsFromCode(resultsOppWithSCN);
            }
          //Update the Old Opportunities List 
            if( oppsToUpdate != null && oppsToUpdate.size() > 0) {      
                resultsOppUpdates = Database.update(oppsToUpdate, false);
            }
          //Exception handling for Opportunities Update 
            if(resultsOppUpdates != null && resultsOppUpdates.size() > 0) {
                catchExceptionsFromCode(resultsOppUpdates);
            }
        }catch (Exception e){
                System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
        }           
        
        /*
          * @Description: This for loop attach the SCN to its Related new Opportunity and handle the filter validations on SCN fields.
                          Also Populate the Old SCN Id Field with the Id of SCN From Which it has been clonned.  
         */

        for (Integer i = 0; i < oppstoInsertListWithSCN.size(); i++) {
            scnToinsert[i].id = null;
            scnToinsert[i].Stage__c = System.Label.SCN_Status;
            scnToinsert[i].Opportunity__c = oppstoInsertListWithSCN[i].id;
            scnToinsert[i].OwnerId = oppstoInsertListWithSCN[i].OwnerId;
            scnToinsert[i].Created_By__c = oppstoInsertListWithSCN[i].OwnerId;
            scnToinsert[i].Opportunity_Account_Name__c = oppstoInsertListWithSCN[i].AccountId;

            if (scnToinsert[i].BillingContact_Name__r.AccountId != oppstoInsertListWithSCN[i].AccountId) {
                scnToinsert[i].BillingContact_Name__c = null;
            }
            if (scnToinsert[i].HREmployer_Portal_Name1__r.AccountId != oppstoInsertListWithSCN[i].AccountId) {
                scnToinsert[i].HREmployer_Portal_Name1__c = null;
            }
            if (scnToinsert[i].HREmployer_Portal_Name__r.AccountId != oppstoInsertListWithSCN[i].AccountId) { 
                scnToinsert[i].HREmployer_Portal_Name__c = null;
            }
            if (scnToinsert[i].HREnrollment_Name__r.AccountId != oppstoInsertListWithSCN[i].AccountId) { 
                scnToinsert[i].HREnrollment_Name__c = null;
            }
        }
        
        /*
          * @Description: Query all the Medical plans related to the Old SCNs and put the SCN Id and Medical Plan List in a Map.
         */
        for (Employer_Group_Data__c scn: [SELECT Id, (SELECT Medical_type__c, Medical__c, Custom_Medical__c, AcupunctureChiropractic_Other__c, Vision__c,
                                          Acupuncture_Chiropractic__c, Acupuncture_Other__c, Acupuncture__c,
                                          Chiropractic_Other__c, Chiropractic__c, CustomMedical_Other__c, Dental_Other__c, Dental__c,
                                          EC_Early_Retiree__c, EC__c, EE1__c, EE_1_Early_Retiree__c, EE_1__c, EE_2_Early_Retiree__c, EE_2__c, EE_Early_Retiree1__c,
                                          EE_Early_Retiree__c, EE__c, EF_Early_Retiree__c, EF__c, ES_Early_Retiree__c, ES__c, HDHP__c, Id,
                                          IndividualMedical_Other__c, Individual_Medical__c, Infertility__c, IsDeleted, Large_GroupMedical_Other__c,
                                          Large_Group_Medical__c, Medical_Plan_Notes__c, Name,
                                          No_Medical_Benefit_Plan_Change__c, No_Optional_Benefit_Change__c, Plan_Name_Active_1__c, Plan_Name_Active__c, Plan_Name_Early_Retiree_1__c,
                                          Plan_Name_Early_Retiree__c, Prosthetic_Orthotic__c, Small_GroupMedical_Other__c, Small_Group_Medical__c,
                                          Sold_Case_Notification__c, Standard_Medical_Plan_Name__c, Vision_Other__c, Other_Plan_Id__c, RecordTypeId
                                          FROM Medical_Plans__r) FROM Employer_Group_Data__c WHERE Id IN: oldSCNList]) {
            SCNIdMedPlanListMap.put(scn.id, scn.Medical_Plans__r);
        }
        
        try{
          //Inserting Clonned Sold case Notifications 
            if( scnToinsert != null && scnToinsert.size() > 0) {   
                resultsSCN = Database.insert(scnToinsert, false);
            }
            if(resultsSCN != null && resultsSCN.size() > 0) {
                catchExceptionsFromCode(resultsSCN);
            }
        }catch(Exception ex) {
                System.debug(ex.getTypeName() + ' - ' + ex.getCause() + ': ' + ex.getMessage());
        }
            /*
              * @Description: This loop clones the medical plan list and set the SCN id for each Medical Plan to its related newly created SCN.
             */
            for (Employer_Group_Data__c scnObj: scnToinsert) {
                if (scnObj.id != null) {
                    List < Medical_Plan__c > medicalPlanList = new List < Medical_Plan__c > ();
                    medicalPlanList = SCNIdMedPlanListMap.get(scnObj.Old_SCN_Id__c).deepClone(false, false, false);
                    for (Medical_Plan__c medPlanObj: medicalPlanList) {
                        medPlanObj.Sold_Case_Notification__c = scnObj.id;
                        MedplanListtoInsert.add(medPlanObj);
                    }
                }
            }
        
        try{
           //Inserting List of Medical Plans Related to The Sold case Notifications
            if( MedplanListtoInsert != null && MedplanListtoInsert.size() > 0) {   
                resultsMedicalPlans = Database.insert(MedplanListtoInsert, false);
            }
            if(resultsMedicalPlans != null && resultsMedicalPlans.size() > 0) {
                catchExceptionsFromCode(resultsMedicalPlans);
            }
        }catch(Exception ex) {
            System.debug(ex.getTypeName() + ' - ' + ex.getCause() + ': ' + ex.getMessage());
        }
    }
    /**
    *   @Description: This is a finish method executed when all the Batche Job Processing is Completed.
    *   @Arguments: Database.BatchableContext      
    *   @Return: Void
    **/
    global void finish(Database.BatchableContext BC) {
        
        try{
            if( BatchExceptions != null && BatchExceptions.size() > 0)  {
                Database.insert(BatchExceptions,false);
            }           
        }catch( Exception ex){
            System.debug(ex.getTypeName() + ' - ' + ex.getCause() + ': ' + ex.getMessage());
        }           
    }
}