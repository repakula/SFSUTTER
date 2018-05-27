/*****************************************************
Class Name: HighRoads_UpdateGridIdInCoverageBatch 
Created By: Bhaskar Bellapu
Created Date: 28/07/2016
Description: this batch class is used to update the coverage records when portfolio records are inserted or updated
*****************************************************/
global class HighRoads_UpdateGridIdInCoverageBatch implements Database.Batchable<sObject>,Database.stateful{
	//Map for storing the Benefit Plan HCC ID and Benefit Grid ID
    Map < String,String > PlanIdGridIdMap = new Map < String,String >();
    //Set to store the insertion benefit plan Id
    Set< String> benefitPlanIdSet = new Set< String >();
    //Set to store the old benefit plan id of the portfolio
    Set < String > OldPlanIdSet = new Set < String >();
    //Set to store the new benefit plan id of the portfolio
    Set < String > newPlanIdSet = new Set < String >();
    String query = HighRoads_Constants.BLANK_VALUE;
    //static value, is used to get the current year plan id and update the benefit plan coverage record if plan coverage end date is null
    static final Integer BENEFIT_PLAN_YEAR = Date.Today().Year(); 
    //save results to identify the success or failures
    Database.SaveResult[] resultsBenPlanUpdate;
    public static SystemException__c[] updateExceptions ;

    global HighRoads_UpdateGridIdInCoverageBatch(List<SHP_Benefit_Grid__c> benefitGridList,Map<ID,SHP_Benefit_Grid__c> oldBenGridRecordMap){
        
        //constructing oldplanset and newplanset
        if(oldBenGridRecordMap != NULL && !oldBenGridRecordMap.isEmpty()){
            for( SHP_Benefit_Grid__c benGridRec : benefitGridList ) {
                if( benGridRec.Benefit_Plan_ID__c != oldBenGridRecordMap.get(benGridRec.Id).Benefit_Plan_ID__c ) {
                    OldPlanIdSet.add(oldBenGridRecordMap.get(benGridRec.Id).Benefit_Plan_ID__c);
                    if(benGridRec.SHP_Benefit_Plan_Year__c != NULL) {
                        newPlanIdSet.add(benGridRec.Benefit_Plan_ID__c);
                        PlanIdGridIdMap.put(benGridRec.Benefit_Plan_ID__c+HighRoads_Constants.HYPHEN+benGridRec.SHP_Benefit_Plan_Year__c,benGridRec.Id );
                    }
                    
                }
            }
        }else{
            //constructing set for insert records
            for(SHP_Benefit_Grid__c benefitGrid: benefitGridList ) {
                if(!(String.isEmpty(benefitGrid.Benefit_Plan_ID__c))) {
                    if ( benefitGrid.SHP_Benefit_Plan_Year__c != NULL)
                    {
                        PlanIdGridIdMap.put(benefitGrid.Benefit_Plan_ID__c+HighRoads_Constants.HYPHEN+benefitGrid.SHP_Benefit_Plan_Year__c,benefitGrid.id );
                        benefitPlanIdSet.add(benefitGrid.Benefit_Plan_ID__c);
                    }
                }
            }
        }
        //If oldplanet or newplan set is not null, it means the Portfolio is updated
        if((OldPlanIdSet != NULL && !OldPlanIdSet.isEmpty()) || (newPlanIdSet != NULL && !newPlanIdSet.isEmpty())){
            System.debug('inside update');
            query = 'SELECT Id,PlanCov_Bene_Plan_HCC_ID__c ,PlanCov_Bene_Plan_Date_Start__c, PlanCov_Bene_Plan_Date_End__c FROM Benefit_Plan_Coverage__c WHERE PlanCov_Bene_Plan_HCC_ID__c IN :newPlanIdSet OR PlanCov_Bene_Plan_HCC_ID__c IN :oldPlanIdSet';
        }
        //If benefitPlanIdSet set is null, it means the Portfolio is insert
        else if(benefitPlanIdSet != NULL && !benefitPlanIdSet.isEmpty()){
            query = 'SELECT Id,PlanCov_Bene_Plan_HCC_ID__c ,PlanCov_Bene_Plan_Date_Start__c, PlanCov_Bene_Plan_Date_End__c FROM Benefit_Plan_Coverage__c WHERE PlanCov_Bene_Plan_HCC_ID__c IN :benefitPlanIdSet';
        }
    }

    /* Name: Start
    *Input: Batchable Context
    * Return Type: Database.QueryLocator
    * Description: Used to get the list if Benefit Plan Coverage records which needs to be pass to execute method
    */
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('query'+query);
        return Database.getQueryLocator(query);
    }

    
    /* Name: Execute
    *Input: List of Benefit Plan Coverage records
    * Return Type: void
    * Description: Used to update the Benefit Plan Coverage records based on the Portfolio record update
    */
    public void execute(Database.BatchableContext batchContext, List<Benefit_Plan_Coverage__c> coverageList) {
        List<Benefit_Plan_Coverage__c> updateCoverageList = new List<Benefit_Plan_Coverage__c>();
        for(Benefit_Plan_Coverage__c planCov : coverageList){
            /* Verifying the insert record set is null or empty 
             * if it is empty then it is for benefit grid update 
             * else it is for insert */
            if(benefitPlanIdSet == NULL || benefitPlanIdSet.isEmpty()){
                if(OldPlanIdSet.contains(planCov.PlanCov_Bene_Plan_HCC_ID__c)){
                    planCov.Benefit_Grid_Plan_ID__c = null;
                    updateCoverageList.add(planCov);
                }else{
                    Benefit_Plan_Coverage__c updatedCovObj = coverageUpdateUtil(planCov);
                    updateCoverageList.add(updatedCovObj);
                }
            }
            //this code will work for portfolio insert
            else{
                Benefit_Plan_Coverage__c updatedCovObj = coverageUpdateUtil(planCov);
                updateCoverageList.add(updatedCovObj);
            }
        }
        /*
        * @Description: Update those Benefit Plans for which the lookup Ids have been changed.
        */     
        if(!(updateCoverageList.isempty())) {
            resultsBenPlanUpdate = Database.update(updateCoverageList,false);
        }
        /*
        * @Description: Get the Exceptions for failed Updates of Benefit Grid records.
        */ 
        if(resultsBenPlanUpdate != null && !(resultsBenPlanUpdate.isEmpty())){
    		catchExceptionsFromCode( resultsBenPlanUpdate ) ;   
		}
        /*
        * @Description: Insert the exceptions in the System.
        */
        if( updateExceptions != null && !(updateExceptions.isEmpty())) {
            Database.insert( updateExceptions,false);
        }
    }
    /* Name: finish
    *Input: Batchable Context
    * Return Type: void
    * Description: N/A
    */
    global void finish(Database.BatchableContext BC)
    {
        
    }
	/* Name: coverageUpdateUtil
    *Input: Benefit_Plan_Coverage__c record
    * Return Type: Benefit_Plan_Coverage__c
    * Description: to set the grid id to the Benefit Plan Coverage record. Same code need to execute for 2 different scenarios hence put it in util method
    */
    public Benefit_Plan_Coverage__c coverageUpdateUtil(Benefit_Plan_Coverage__c planCov){
        if (planCov.PlanCov_Bene_Plan_Date_End__c != null)
        {
            Integer yearInt = planCov.PlanCov_Bene_Plan_Date_End__c.year();
            if( planCov.PlanCov_Bene_Plan_HCC_ID__c != null && PlanIdGridIdMap.get(planCov.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+yearInt) != NULL )
            {
                planCov.Benefit_Grid_Plan_ID__c = PlanIdGridIdMap.get(planCov.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+yearInt);
            }
        }
        else {
            if(planCov.PlanCov_Bene_Plan_Date_Start__c != NULL && !String.isEmpty(planCov.PlanCov_Bene_Plan_HCC_ID__c) && 
               PlanIdGridIdMap.get(planCov.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+BENEFIT_PLAN_YEAR) != NULL){
                   planCov.Benefit_Grid_Plan_ID__c = PlanIdGridIdMap.get(planCov.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+BENEFIT_PLAN_YEAR);
               }
        }
        return planCov;
    }
    
    /**
    *   @Description: This is a method to insert exception messages caught by failure of Update of Benefit grid Records.
    *   @Arguments: String exception messages     
    *   @Return: Void
    **/
    public void catchExceptionsFromCode( Database.SaveResult[] results ) {
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                Database.Error[] errs = result.getErrors();
                for(Database.Error err : errs) {
                    SystemException__c systemException = new SystemException__c();systemException.ExceptionMessage__c = err.getMessage();updateExceptions.add(systemException);
                }
            }
        }
    } 
}