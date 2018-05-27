/******************************************************************************************************************* 
Class Name : HighRoads_CreateCustomBenefitPlan 
Author	    : IDC Offshore
Date       : 10/27/2016
Description: This is controller class for HighRoads_CreateCustomPlan page.
Is used to create custom benefit plan from plan selection page
on click of Initiate custom plan. This will apply only for LG
History:
VERSION    AUTHOR              DATE        DETAIL 
1.0        IDC-Offshore      10/27/2016    This is controller class for HighRoads_CreateCustomPlan page.
Is used to create custom benefit plan from plan selection page
on click of Initiate custom plan. This will apply only for LG
*******************************************************************************************************************/
public class HighRoads_CreateCustomBenefitPlan {
    public Custom_Benefit_Plan__c customPlanObj{get;set;}
    public string accountId{get;set;}
    public string customPlanName{get;set;}
    Savepoint sp;//to roll back the transation if it fails
    //Constructor
    public HighRoads_CreateCustomBenefitPlan(ApexPages.StandardController controller){
        this.customPlanObj = (Custom_Benefit_Plan__c)controller.getRecord();
        accountId = ApexPages.currentpage().getparameters().get(HighRoads_Constants.ACCOUNTID);
        customPlanObj.Plan_Related_to_Account__c = accountId;
    }
    /**
* Method Name : insertPlan
* Parameters  : None
* Return type : PageReference - Redirecct to newly created custom benefit plan
* Description : This method is called when user clicks on Initiate custom plan button on VFP.
**/
    public PageReference insertPlan(){
        try{
            sp = Database.setSavepoint();
            insert customPlanObj;
        }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        return new PageReference(HighRoads_Constants.FWRD_SLASH+customPlanObj.Id);
    }
}