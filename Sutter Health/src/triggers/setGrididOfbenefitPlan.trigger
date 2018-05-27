/**  
*     Trigger Name: setGrididOfbenefitPlan
*     Author: IDC Offshore
*     Date: 23-March-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description: This trigger set the Look up field of Benefit Plan record to its related Benfit Grid Record
*                  whenever a matching Benefit Grid is inserted in System.
*                  This Trigger also set the Value for "Fields Changed" Field on Benfit Grid Record before Update 
*                  of record.   
*     Version 3.0 : Req - 3890 SHP Wave 2 changes
1. Creating the Benefit Plan Metadata record on creation of Grid Record.
2. Updating the Benefit Plan Metadata record on updation of Grid Record.
3. Upserting the Audit records whenever the Grid is updated.
* 4.0       Deloitte            25-04-2017     SHP14 Inoked Audit Summary functionality on Before update event,
*                                             earlier this was on After Update event and
*                                               Added logic to fill "REQUIRED" fields
**/

trigger setGrididOfbenefitPlan on SHP_Benefit_Grid__c (after insert, before update, after update  ) {
    
    
    /* @Description: Call the method to set the value of "Fields Changed" field on benefit Grid reord if record is updated.
* @Description: Call the method updateAuditandMetadata to udpate the Benefit Grid data in Audit Object and Benefit Plan Metadata Object.
*/
    if( trigger.isUpdate && trigger.isBefore ) {
        //Commenting this code as this we are handling as part of 3182 Wave 2 release
        
        //Req 3182 Changes START
         new SHP_UpdateBenefitGridAuditandMetadata().upsertMetadata(trigger.new);
        
        //@SHP14
        SHP_UpdateBenefitGridAuditandMetadata helperObj = new SHP_UpdateBenefitGridAuditandMetadata();
        helperObj.updateSummaryChange(Trigger.New, Trigger.OldMap);
    }     
    /*
* @Description: Call the method setBenefitGridIdAfterInsert to set Look Up Id of Matching Benfit Plan if record is inserted.
* @Description: Call the method insertAuditandMetadata to insert the Benefit Grid data in Audit Object and Benefit Plan Object.
*/
    if( trigger.isInsert && trigger.isAfter ) {
        
        //Req 3182 Changes START
        
        //Calling Batch apex to update the benefit plan coverage records
        Database.executeBatch(new HighRoads_UpdateGridIdInCoverageBatch(trigger.new,null));
        //calling to update audit and metadata records
        for(SHP_Benefit_Grid__c gridObj : Trigger.New){
            if( gridObj.SHP_Benefit_Plan_Year__c != NULL ) {
               new SHP_UpdateBenefitGridAuditandMetadata().upsertMetadata(trigger.new); 
            }else{
                gridObj .addError('Please fill the Benefit year field');           }
        }
        
        //Req 3182 Changes END
    }
    /*
* @Description: Call the method to change the Look Up for related Benefit Plan when Plan id of Benefit Grid is Changed. 
*/
    if( trigger.isUpdate && trigger.isAfter ) {
        //Constructing map as Batch is not directly accepting the Trigger.OldMap if we pass
        Map<ID,SHP_Benefit_Grid__c> oldMap = new Map<ID,SHP_Benefit_Grid__c>();
        for(SHP_Benefit_Grid__c gridObj : Trigger.New){
            if( gridObj.Benefit_Plan_ID__c != Trigger.OldMap.get(gridObj.Id).Benefit_Plan_ID__c ) {
                oldMap.put(gridObj.Id, Trigger.OldMap.get(gridObj.Id));
            }
        }
        
        //Calling Batch apex to update the benefit plan coverage records
        Database.executeBatch(new HighRoads_UpdateGridIdInCoverageBatch(trigger.new,oldMap));
        new SHP_UpdateBenefitGridAuditandMetadata().updateAuditandMetadata(trigger.new,trigger.oldMap); 
    }
}