/**  
*     Trigger Name: UpdateBenefitGrid
*     Author: IDC Offshore
*     Date: 23-March-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description: This trigger set the Look up field of Benefit Plan record to its related Benfit Grid Record
*                  whenever a matching Benefit Grid is inserted in System.
*                  This Trigger also set the Value for "Fields Changed" Field on Benfit Grid Record before Update 
*                  of record.                  
**/
trigger UpdateBenefitGrid on Benefit_Plan_Coverage__c (before insert, before update) {
 /*
  * @Description: Call the method setBenefitGridId to set the look up link between Benefit Plan and Benefit Grid.
  */
    if((trigger.isInsert || trigger.isUpdate) && trigger.isBefore) {
        UpdateBenefitGridIdofBenefitCov.setBenefitGridId(trigger.new);
    }

}