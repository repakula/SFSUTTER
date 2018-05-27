/**  
*     Class Name: UpdateBenefitCovGridId
*     Author: IDC Offshore
*     Date: 30-March-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description: This class is helper class for a trigger SetBenefitGridId which set 
*                  Benefit Grid Lookup Id of Benefit Coverage record based on Benefit Plan HCC ID
*                  value
*   Version     2.0  Req number 3391 Modified code to store  benefit grid 2016 
*   Version     3.0 : Req - 3980 SHP Wave 2 changes
						Grid ID population in Benefit Plan Coverage.
*   Author      IDC Offshore  Date 11/16/2015
*
**/
public class UpdateBenefitCovGridId {
    
    public static SystemException__c[] updateExceptions ;
    public static final Integer BENEFIT_PLAN_YEAR = Date.Today().Year();    
    /**
    *   @Description: This is a method to insert exception messages caught by failure of Update of Benefit grid Records.
    *   @Arguments: String exception messages     
    *   @Return: Void
    **/
    public static void catchExceptionsFromCode( Database.SaveResult[] results ) {
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                Database.Error[] errs = result.getErrors();
                for(Database.Error err : errs) {
                    SystemException__c systemException = new SystemException__c();
                    systemException.ExceptionMessage__c = err.getMessage();
                    updateExceptions.add(systemException);
                }
            }
        }
    }   
    /**
    * @author       :   IDC Offshore
    * @date         :   30/03/2015 (DD/MM/YYYY)
    * @version      :   1.0
    * @description  :   Set the Benefit Grid Lookup Id of Benefit Plan Coverage Record based on Benefit Plan HCC Id after insert of Benefit Grid
    * @param        :   List [Benefit Grid]
    * @return       :   N/A
    */
    
    public static void setBenefitGridIdAfterInsert( List < SHP_Benefit_Grid__c > benefitGridList ) {
        
        Map < String,String > PlanIdGridIdMap = new Map < String,String >();
        Set< String> benefitPlanIdSet = new Set< String >();
        
        List < Benefit_Plan_Coverage__c > BenefitplansToupdate = new List< Benefit_Plan_Coverage__c >();
        Database.SaveResult[] resultsBenPlan;
        /*
        * @Description: Created the Map of unique Benefit Grid Plan Id and Benefit Grid Id
        */    
        for( SHP_Benefit_Grid__c benefitGrid: benefitGridList ) {
            //Req 3182 Benefit Grid Id population
            if(!(String.isEmpty(benefitGrid.Benefit_Plan_ID__c))) {
                if ( benefitGrid.SHP_Benefit_Plan_Year__c != NULL)
                {
                    PlanIdGridIdMap.put(benefitGrid.Benefit_Plan_ID__c+HighRoads_Constants.HYPHEN+benefitGrid.SHP_Benefit_Plan_Year__c,benefitGrid.id );
                    benefitPlanIdSet.add(benefitGrid.Benefit_Plan_ID__c);
                }
            }
        }
        /*
        * @Description: This loop Iterates over the matching Benefit Plans From the Map and Set the Look Up Relation between Benefit Plan 
        *               and Benefit Grid.
        */
        if(!(PlanIdGridIdMap.isEmpty())) {
            for( Benefit_Plan_Coverage__c planCov:[ SELECT Id,PlanCov_Bene_Plan_HCC_ID__c ,PlanCov_Bene_Plan_Date_Start__c, PlanCov_Bene_Plan_Date_End__c FROM Benefit_Plan_Coverage__c WHERE PlanCov_Bene_Plan_HCC_ID__c IN :benefitPlanIdSet]) {
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
                BenefitplansToupdate.add(planCov);
            }
}
        /*
        * @Description: Update those Benefit Plans for which the lookup Ids have been changed.
        */     
        if(!(BenefitplansToupdate.isempty())) {
            resultsBenPlan = Database.update(BenefitplansToupdate,false);
        }
        /*
        * @Description: Get the Exceptions for failed Updates of Benefit Grid records.
        */ 
        if(resultsBenPlan != null && !(resultsBenPlan.isEmpty())){
    catchExceptionsFromCode( resultsBenPlan ) ;   
}
        /*
        * @Description: Insert the exceptions in the System.
        */
        if( updateExceptions != null && !(updateExceptions.isEmpty())) {
            Database.insert( updateExceptions,false);
        }  
    }
    
    /**
    * @author       :   IDC Offshore
    * @date         :   23/03/2015 (DD/MM/YYYY)
    * @version      :   1.0
    * @description  :   This method is to change the look up of Benefit Plan whenever the plan Id matched Benefit Grid
                        is Updated.
    * @param        :   List [Benefit Grid]
    * @return       :   N/A
    */
    
    public static void setBenefitGridIdAfterUpdate( List < SHP_Benefit_Grid__c > newBenefitgridList, Map < Id,SHP_Benefit_Grid__c > oldBenGridRecordMap ) {
        
        Set < String > OldPlanIdSet = new Set < String >();
        Set < String > newPlanIdSet = new Set < String >();
        Map < String,String > PlanIdRecordIdMapofBenGrid = new Map < String,String >();
        
        List < Benefit_Plan_Coverage__c > BenefitPlansToUpdate = new List < Benefit_Plan_Coverage__c >();
        Database.SaveResult[] resultsBenPlanUpdate;
        
        /*
        * @Description: Iterate through every new record of benefit Grid to check if plan id is changed if so populate the changed plan ids in set and Map of 
        *               new Plan and record Id
        */     
        for( SHP_Benefit_Grid__c benGridRec:newBenefitgridList ) {
            if( benGridRec.Benefit_Plan_ID__c != oldBenGridRecordMap.get(benGridRec.Id).Benefit_Plan_ID__c ) {
                
                OldPlanIdSet.add(oldBenGridRecordMap.get(benGridRec.Id).Benefit_Plan_ID__c);
                
                if(benGridRec.SHP_Benefit_Plan_Year__c != NULL) {
                    newPlanIdSet.add(benGridRec.Benefit_Plan_ID__c);
                    PlanIdRecordIdMapofBenGrid.put(benGridRec.Benefit_Plan_ID__c+HighRoads_Constants.HYPHEN+benGridRec.SHP_Benefit_Plan_Year__c,benGridRec.Id );
                }
                
            }
        }
        /*
        * @Description: For every changed Benefit Grid record set its old value related look up to null.
        *               
        */
        if(!(OldPlanIdSet.isEmpty()) ) {
            for( Benefit_Plan_Coverage__c benefitPlanRec: [ SELECT Id,Benefit_Grid_Plan_ID__c FROM Benefit_Plan_Coverage__c WHERE PlanCov_Bene_Plan_HCC_ID__c IN :OldPlanIdSet]) {
                benefitPlanRec.Benefit_Grid_Plan_ID__c = null;
                BenefitPlansToUpdate.add(benefitPlanRec);
            }
        }
        /*
        * @Description: This loop Iterates over the matching Benefit Plans From the Map and Set the Look Up Relation betwwen Benefit Plan 
        *               and Benefit Grid.
        */     
        if(!(PlanIdRecordIdMapofBenGrid.isEmpty())) {
            for( Benefit_Plan_Coverage__c planCov:[ SELECT Id,PlanCov_Bene_Plan_HCC_ID__c,PlanCov_Bene_Plan_Date_Start__c,PlanCov_Bene_Plan_Date_End__c FROM Benefit_Plan_Coverage__c WHERE PlanCov_Bene_Plan_HCC_ID__c IN :newPlanIdSet]) {
                if(planCov.PlanCov_Bene_Plan_Date_End__c != null ) {
                    // Req no 3182 updating look up for Benefit_Plan_Coverage__c  if any thing is changed in benefit grid  object
                    Integer yearInt = planCov.PlanCov_Bene_Plan_Date_End__c.year();
                    if( planCov.PlanCov_Bene_Plan_HCC_ID__c != null && PlanIdRecordIdMapofBenGrid.get(planCov.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+yearInt) != NULL) {
                        planCov.Benefit_Grid_Plan_ID__c = PlanIdRecordIdMapofBenGrid.get(planCov.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+yearInt);
                        
                    }
                }
                else {
                    if(planCov.PlanCov_Bene_Plan_Date_Start__c != NULL && !String.isEmpty(planCov.PlanCov_Bene_Plan_HCC_ID__c) && 
                       PlanIdRecordIdMapofBenGrid.get(planCov.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+BENEFIT_PLAN_YEAR) != NULL){
                         planCov.Benefit_Grid_Plan_ID__c = PlanIdRecordIdMapofBenGrid.get(planCov.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+BENEFIT_PLAN_YEAR);
                    }
                }
                BenefitPlansToUpdate.add(planCov);
            }
        }
        /*
        * @Description: Update those Benefit Plans for which the lookup Ids have been changed.
        */     
        if(!(BenefitPlansToUpdate.isEmpty())) {
            resultsBenPlanUpdate = Database.update(BenefitPlansToUpdate,false);
        }
        /*
        * @Description: Get the Exceptions for failed Updates of Benefit Grid records.
        */     
        if(resultsBenPlanUpdate != null && !(resultsBenPlanUpdate.isEmpty())){
    catchExceptionsFromCode(resultsBenPlanUpdate);
}
        /*
        * @Description: Insert the exceptions in the System.
        */  
        if( updateExceptions != null && !(updateExceptions.isEmpty())) {
            Database.insert( updateExceptions,false);
        }
    }
}