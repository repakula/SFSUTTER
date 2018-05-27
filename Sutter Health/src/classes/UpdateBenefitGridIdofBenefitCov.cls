/**  
*     Class Name: UpdateBenefitGridIdofBenefitCov
*     Author: IDC Offshore
*     Date: 23-March-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description: This class is helper class for a trigger UpdateBenefitGridId which set 
*                  Benefit Grid Lookup Id of Benefit Coverage record based on Benefit Plan HCC ID
*                  value.
*   Version         2.0  Req number 3391 Modified code to store  Benefit plan coverage for  plan year  2016
                    3.0 Req number 3391 is totally removed and added dynamic logic for Benefit Plan Coverage update for all years.
*   Author          IDC Offshore  Date 11/16/2015
    
*
*
**/
public class UpdateBenefitGridIdofBenefitCov {
    public static final Integer BENEFIT_PLAN_YEAR = Date.Today().Year(); 
    public static boolean isBeforeInsertUpdate = true;
    /**
    * @author       :   IDC Offshore
    * @date         :   23/03/2015 (DD/MM/YYYY)
    * @version      :   1.0
    * @description  :   Set the Benefit Grid Lookup Id of Benefit Plan Coverage Record based on Benefit Plan HCC Id
    * @param        :   List [Benefit Plan Coverage]
    * @return       :   N/A
    */
    public static void setBenefitGridId( List < Benefit_Plan_Coverage__c > benefitPlanCovList ) {
        
        Set < String > BenefitPlanHCCIdSet = new Set< String >();
        Set< Integer > BenefitPlanCovPlanYearSet = new Set< Integer >();
        Map < String,String > BenefitGridPlanIdRecIdMap = new Map < String,String >();
        
        try {
            /*
            * @Description: Get the Benefit Plan HCC Ids of Updated records in a Set.
            */  
            for(Benefit_Plan_Coverage__c benefitCov : benefitPlanCovList ) {
                if(!(String.isEmpty(benefitCov.PlanCov_Bene_Plan_HCC_ID__c)) && benefitCov.PlanCov_Bene_Plan_HCC_ID__c.contains(Highroads_Constants.HYPHEN)) {
                    String benefitPlanCovHCCID = benefitCov.PlanCov_Bene_Plan_HCC_ID__c.subStringAfter(Highroads_Constants.HYPHEN);
                    BenefitPlanHCCIdSet.add(benefitPlanCovHCCID);
                }else if(!(String.isEmpty(benefitCov.PlanCov_Bene_Plan_HCC_ID__c)) && !benefitCov.PlanCov_Bene_Plan_HCC_ID__c.contains(Highroads_Constants.HYPHEN)){
                    BenefitPlanHCCIdSet.add(benefitCov.PlanCov_Bene_Plan_HCC_ID__c);
                }
            }
            /*
            * @Description: This for loop populate the Map with plan Id as key and record Id of matching Benefit Grid records 
            */
            if(!(BenefitPlanHCCIdSet.isEmpty())) {
                for(SHP_Benefit_Grid__c benefitGrid:[SELECT Id, Benefit_Plan_ID__c , SHP_Benefit_Plan_Year__c FROM SHP_Benefit_Grid__c WHERE Benefit_Plan_ID__c IN :BenefitPlanHCCIdSet 
                                                     AND Plan_Status__c =:System.Label.HR110_ApprovedForSale]) {
                    if(!(String.isEmpty(benefitGrid.Benefit_Plan_ID__c))  ) {
                        
                       //Req 3182 change in the Benefit Grid object
                        if (benefitGrid.SHP_Benefit_Plan_Year__c != NULL)
                        {
                            BenefitGridPlanIdRecIdMap.put(benefitGrid.Benefit_Plan_ID__c+HighRoads_Constants.HYPHEN+benefitGrid.SHP_Benefit_Plan_Year__c, benefitGrid.Id );
                        }
                    }
                }
            }
            /*
            * @Description: This for loop set the look up id of Matching Benefit Plan as per the Map record Id
            */
            
            if(!(BenefitGridPlanIdRecIdMap.isEmpty())) {
                for(Benefit_Plan_Coverage__c benefitPlan: benefitPlanCovList) {
                    if (benefitPlan.PlanCov_Bene_Plan_Date_End__c != null)
                    {
                        // Req 3182 - getting plan year from PlanCov_Bene_Plan_Date_End__c 
                        Integer yearInt = benefitPlan.PlanCov_Bene_Plan_Date_End__c.year();
                        if(benefitPlan.PlanCov_Bene_Plan_HCC_ID__c != null && BenefitGridPlanIdRecIdMap.get(benefitPlan.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+yearInt) != NULL) {
                            benefitPlan.Benefit_Grid_Plan_ID__c = BenefitGridPlanIdRecIdMap.get(benefitPlan.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+yearInt);
                        }
                        else{
                            benefitPlan.Benefit_Grid_Plan_ID__c = BenefitGridPlanIdRecIdMap.get(benefitPlan.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+BENEFIT_PLAN_YEAR) != NULL ? BenefitGridPlanIdRecIdMap.get(benefitPlan.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+BENEFIT_PLAN_YEAR) : NULL;
                        }
                    }
                    else
                    {
                        if(benefitPlan.PlanCov_Bene_Plan_Date_Start__c != NULL && !String.isEmpty(benefitPlan.PlanCov_Bene_Plan_HCC_ID__c) && 
                           BenefitGridPlanIdRecIdMap.get(benefitPlan.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+BENEFIT_PLAN_YEAR) != NULL){
                               benefitPlan.Benefit_Grid_Plan_ID__c = BenefitGridPlanIdRecIdMap.get(benefitPlan.PlanCov_Bene_Plan_HCC_ID__c+HighRoads_Constants.HYPHEN+BENEFIT_PLAN_YEAR);
                        }
                    }
                }
            }
            
        }catch(Exception triggerException) {Utility.handleExceptionFromCode(triggerException.getMessage() + '\r\n' + triggerException.getStackTraceString() + '\r\n' + triggerException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');}
    }
}