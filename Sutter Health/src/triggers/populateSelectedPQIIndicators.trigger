/**
    *    Trigger Name: populateSelectedPQIIndicators
    *    Author:IDC Offshore
    *    Date: 4-Augast-2015
    *    Description: This Trigger is written to Populate Select PQI Indicators field before insert and update of PQI.
    *    History
    *    --------
    *    
    **/
trigger populateSelectedPQIIndicators on Potential_Quality_Issue__c ( before insert , before Update ) {
    
    if( Trigger.isBefore && ( Trigger.isInsert || Trigger.isUpdate) ) {
        Schema.DescribeSObjectResult pqiFields = Potential_Quality_Issue__c.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> pqiFieldMap = pqiFields.fields.getMap();
        Map<String,String> FieldNameLabelMap = new Map<String,String> ();
        
        //Create Map of Field API Names and Labels of Fields of Potential Quality Object
        for(String fieldName : pqiFieldMap.keySet())
        {
            Schema.SObjectField field = pqiFieldMap.get( fieldName );
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            
            if( fieldDescribe.isCustom() && (fieldDescribe.getSOAPType() == Schema.SOAPType.BOOLEAN ) && !( fieldDescribe.getName() =='PQI_Required_Field__c' || fieldDescribe.getName() =='ByPass_CMO__c' || fieldDescribe.getName() =='Behavior__c' || fieldDescribe.getName() =='Medical_Records_Collected__c' || fieldDescribe.getName() =='Mental_Health__c' || fieldDescribe.getName() =='Peer_Review_Other__c' || fieldDescribe.getName() =='Related_UM_Concurrent_Review__c')) {
                FieldNameLabelMap.put(fieldDescribe.getName(),fieldDescribe.getLabel());
            }
        }
        
        //For every PQI being inserted or updated check which indicators are selected true and put a value in Selected PQI Indicators field 
        for( Potential_Quality_Issue__c pqi: trigger.new ) {
            String indicatorsSelected = '';
            List <String> IndicatorLabelList = new List<String> ();
            for(String fieldName : FieldNameLabelMap.keySet()) {
                if( pqi.get(fieldName) == true ) {
                    IndicatorLabelList.add(FieldNameLabelMap.get(fieldName));
                }
            }
            IndicatorLabelList.sort();
            
            for( Integer i=0; i < IndicatorLabelList.size() ; i++ ) {
                indicatorsSelected = indicatorsSelected + ','+IndicatorLabelList.get(i);
            }
            
            String indicatorsSelectedToAssign = indicatorsSelected.removeStartIgnoreCase(',');
            pqi.Selected_PQI_Indicators__c = indicatorsSelectedToAssign;
        }
    }
}