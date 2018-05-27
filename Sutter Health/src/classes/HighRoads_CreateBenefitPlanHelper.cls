/******************************************************************************************************************* 
Class Name: HighRoads_CreateBenefitPlanHelper 
Author: IDC Offshore
Date: 20-Oct-2016
Description: To create record in Benefit Plan Metadata once 
the BPA QA team approves the custom benefit plan as part of 3880 request.

History:
VERSION    AUTHOR              DATE        DETAIL 
1.0        IDC-Offshore      20/10/2016   To create record in Benefit Plan Metadata once the BPA QA team approves the custom benefit plan as part of 3880 request.
2.0        Deloitte          11/4/2017    SHP15 The Actively Marketed? check box should NOT be checked (false) on the new custom plan
*******************************************************************************************************************/
public class HighRoads_CreateBenefitPlanHelper {
    //to avoid recursion
    public static boolean isAfterUpdate = true;
    public static boolean isAfterInsert = true;
    public static boolean isBeforeUpdate = true;
    private Set<String> fieldSet = new Set<String>();
    Savepoint sp;//to roll back the transation if it fails

    /**
    * Method Name : createMetadataRecord
    * Parameters  : List<Custom_Benefit_Plan__c> customPlanList
    * Return type : void                                                        
    * Description : Method is called when the custom benefit plan is created from select benefit plan page
                    It is used to,                                                                        
                    1. Auto populating the data in custom benefit plan record based on                    
                       the Plan to Customize field(Benefit Grid) value selected.                                                                                            *
                    2. All the data will be populated from the selected benefit grid reord                
    **/
    public void updateCustomPlanRecord(List<Custom_Benefit_Plan__c> customPlanList){
        //Grid map to store grid id and the record which will be used to auto populate the data in custom benefit plan record
        Map<String,SHP_Benefit_Grid__c> benefitGridMap = new Map<String,SHP_Benefit_Grid__c>();
        //Custom setting map which is used to store the Benefit Grid field API as key and custom setting record as value
        //from the value, we will fetch the Custom_Benefit_Plan_Field_API__c while auto populating the data from benefit grid to custom benefit plan
        Map<string,Grid_to_Metadata_Mapping__c> customPlanMap = new Map<string,Grid_to_Metadata_Mapping__c>();
        //Fetching mapping data from custom setting 
        List<Grid_to_Metadata_Mapping__c> metaDataMappingList = [select Name,Custom_Benefit_Plan_Field_API__c from 
                                                                 Grid_to_Metadata_Mapping__c where Custom_Benefit_Plan_Field_API__c != NULL LIMIT 10000]; 
        //gridIds used in dynamic query
        Set<ID> gridIds = new Set<ID>();
        for(Custom_Benefit_Plan__c planObj : customPlanList){
            if(planObj.Benefit_Grid__c != NULL){
                gridIds.add(planObj.Benefit_Grid__c);
            }
        }
        //Constructing the customPlanMap
        for(Grid_to_Metadata_Mapping__c gridMapObj : metaDataMappingList){
            customPlanMap.put(gridMapObj.Name, gridMapObj);
        }    
        //Update List to udpate the newly inserted custom benefit plan with benefit grid data
        List<Custom_Benefit_Plan__c> updateCustomPlanList = new List<Custom_Benefit_Plan__c>();
        //Dynamic query to retrieve the data from Benefit Grid record. The fields are already stored the customPlanMap as keys
        String query = HighRoads_Constants.SELECT_STRING;
        Set<String> fieldSet = new Set<String>();
        for(String field : customPlanMap.keySet()){
            query += field + HighRoads_Constants.COMMA;
        }
        query = query.trim().removeEnd(HighRoads_Constants.COMMA);
        query = query + HighRoads_Constants.GRID_QUERY_FOR_CUSTOM_PLAN;
        //Adding the retrived results to List
        List<SHP_Benefit_Grid__c> gridObjList = Database.query(query);
        //Constructing benefitGridMap with grid id and record. It used to populate the data in custom benefit plan.
        for(SHP_Benefit_Grid__c gridObj : gridObjList){
            benefitGridMap.put(gridObj.Id, gridObj);
        }
        //Until the record is Final Approved, the record type is Soft Approval only. Updating the record type.
        ID recTypeId = Schema.SObjectType.Custom_Benefit_Plan__c.getRecordTypeInfosByName().get(HighRoads_Constants.SOFT_APPROVAL_REC_TYPE_NAME).getRecordTypeId();
        //Loop through the newly created custom benefit plans to populate the data from grid.
        for(Custom_Benefit_Plan__c customPlanObj : customPlanList){
            SHP_Benefit_Grid__c gridObj = benefitGridMap.get(customPlanObj.Benefit_Grid__c);
            for(String field : customPlanMap.keySet()){
                customPlanObj.put(customPlanMap.get(field).Custom_Benefit_Plan_Field_API__c,gridObj.get(field));
            }
            customPlanObj.Medical_OR_Rider__c = gridObj.IsRider__c == TRUE ? HighRoads_Constants.RIDER : HighRoads_Constants.MEDICAL;
            customPlanObj.Plan_Status__c = HighRoads_Constants.STATUS_NEW;
            customPlanObj.Plan_Type__c = HighRoads_Constants.TYPE_CUSTOM;
            customPlanObj.recordTypeId = recTypeId;
            customPlanObj.IsActivelyMarketed__c = false;    //@SHP15 The Actively Marketed? check box should NOT be checked (false) on the new custom plan
            
        }
        
    }
    
    /**
    * Method Name : createMetadataRecord
    * Parameters  : Set<ID> approvedCustomPlanIds
    * Return type : void                                                        
    * Description : Method is called from the trigger whenever the custom benefit plan is soft approved.         *
                    1. When the Custom Benefit Plan is soft approved, creating a record in Benefit Plan Metadata *
                       with all the details of the custom benefit plan.                                             *  
                    2. While creating the benefit plan metadata                                                  *
                       record populating the custom benefit plan referene id which will be used in sendig the email *
                       when the plan is sold at sold sign off stage.                                                *
                    3. Populating plan related to account field in Benefit Plan Metadata so that the plan will be*
                       visible for selection only for that accout.  
    **/
    public void createMetadataRecord(Set<ID> approvedCustomPlanIds){
        try{
            sp = Database.setSavepoint();
            //list to create the Beneit Plan metadata records
            List<Benefit_Plan_Metadata__c> benefitMetdataList = new List<Benefit_Plan_Metadata__c>();
            //dynamica soql to fetch the fields from field set - CopytoBenefitMetadataFields
            //The api names should be same in Custom Benefit Plan and Benefit Plan Metadata
            String query = HighRoads_Constants.SELECT_ID;
            
            Set<String> fieldSet = new Set<String>();
            //reading the fields using field set.
            for(Schema.FieldSetMember field : SObjectType.Custom_Benefit_Plan__c.FieldSets.CopytoBenefitMetadataFields.getFields()){
                query += field.getFieldPath() + HighRoads_Constants.COMMA;
                fieldSet.add(field.getFieldPath());
            }
            query = query.trim().removeEnd(HighRoads_Constants.COMMA);
            query = query + HighRoads_Constants.FROM_PART_CBP;
            //fetching the data from custom benefit plan using dynamic query
            List<Custom_Benefit_Plan__c> customPlanObjList = Database.query(query);
            //Checking the list is empty or null
            if(customPlanObjList != NULL && !customPlanObjList.isEmpty()){
                for(Custom_Benefit_Plan__c customBenefitPlan : customPlanObjList){
                    Benefit_Plan_Metadata__c metadataObj = new Benefit_Plan_Metadata__c();
                    //loop through the fieldset and construcing the metadata record.
                    for(String field : fieldSet){
                        metadataObj.put(field,customBenefitPlan.get(field));
                    }
                    metadataObj.IsCustom__c = true;//as it is a custom plan, it is always true
                    metadataObj.Plan_Type__c = HighRoads_Constants.TYPE_CUSTOM;
                    //metadataObj.IsActivelyMarketed__c = true;    //@SHP15
                    metadataObj.Custom_Benefit_Plan_ID__c = customBenefitPlan.Id;
                    
                    //Constructing the unique id with Name of the custom plan and plan year and effective start and effect end.
                    //the same unique id will be used while inserting/updating records using Benefit Grid load.
                    metadataObj.Unique_ID__c = customBenefitPlan.Name+HighRoads_Constants.UNDERSCORE+customBenefitPlan.Plan_Year__c+HighRoads_Constants.UNDERSCORE+customBenefitPlan.Effective_Date__c+HighRoads_Constants.UNDERSCORE+customBenefitPlan.End_Date__c;
                    benefitMetdataList.add(metadataObj);
                }
            }
            //Checking the list is empty or not for insertion.
            if(!benefitMetdataList.isEmpty()){
                upsert benefitMetdataList Unique_ID__c;
            }
        }catch(Exception ex){ Database.rollback(sp); }
    }
    
    /**
    * Method Name : updateMetadataRecord
    * Parameters  : Set<ID> updatedCustomPlans
    * Return type : void                                                        
    * Description : This method is used to,                                     
                    1. Update the Benefit Plan Metadata records whenver changes 
                       occurs in the Custom Benefit Plan at Soft Approved stage    
                    2. If the custom benefit plan is final approved, even if it is 
                       updated the benefit plan metadata record will not be updated
    **/
    public void updateMetadataRecord(Set<ID> updatedCustomPlans){
        try
        {
            sp = Database.setSavepoint();
            //Fetching the benefit plan metadata records based on the updated custom plan ids
            List<Benefit_Plan_Metadata__c> benefitMetdataList = [select Id,Custom_Benefit_Plan_ID__c from Benefit_Plan_Metadata__c where Custom_Benefit_Plan_ID__c IN :updatedCustomPlans LIMIT 10000];
            //list to store the updated benefit plan records
            List<Benefit_Plan_Metadata__c> updateBenefitPlanList = new List<Benefit_Plan_Metadata__c>();
            //Map is used to fetch corresponding metadata record to update the data
            Map<ID,ID> customPlanBenefitPlanMetadataMap = new Map<ID,ID>();
            //Checking the benefit metadata list is null or empty
            if(benefitMetdataList != NULL && !benefitMetdataList.isEmpty()){
                //Constructing the map with custom benefit plan id and metadata id
                for(Benefit_Plan_Metadata__c metadata : benefitMetdataList){
                    if(metadata.Custom_Benefit_Plan_ID__c != NULL)
                    {
                        customPlanBenefitPlanMetadataMap.put(metadata.Custom_Benefit_Plan_ID__c, metadata.Id);    
                    }
                    
                }
                //dynamic query to fetch the details from custom benefit plan to update the data in benefit plan metadata record.
                String query = HighRoads_Constants.SELECT_ID;
                Set<String> fieldSet = new Set<String>();
                //reading the fields using field set.
                for(Schema.FieldSetMember field : SObjectType.Custom_Benefit_Plan__c.FieldSets.CopytoBenefitMetadataFields.getFields()){
                    query += field.getFieldPath() + HighRoads_Constants.COMMA;
                    fieldSet.add(field.getFieldPath());
                }
                query = query.trim().removeEnd(HighRoads_Constants.COMMA);
                query = query + HighRoads_Constants.FROM_PART_CBP_1;
                //fetching the data from custom benefit plan using dynamic query
                List<Custom_Benefit_Plan__c> customPlanObjList = Database.query(query);
                //Checking the custom benefit plan is not null and empty
                if(customPlanObjList != NULL && !customPlanObjList.isEmpty()){
                    //looping through the custom plan object list to populate data in metadata object
                    for(Custom_Benefit_Plan__c customBenefitPlan : customPlanObjList){
                        Benefit_Plan_Metadata__c metadataObj = new Benefit_Plan_Metadata__c(Id=customPlanBenefitPlanMetadataMap.get(customBenefitPlan.Id));
                        for(String field : fieldSet){
                            metadataObj.put(field,customBenefitPlan.get(field));
                        }
                        metadataObj.IsCustom__c = true;
                        metadataObj.Plan_Type__c = HighRoads_Constants.TYPE_CUSTOM;
                        metadataObj.IsActivelyMarketed__c = true;
                        metadataObj.Custom_Benefit_Plan_ID__c = customBenefitPlan.Id;
                        metadataObj.Unique_ID__c = customBenefitPlan.Name+HighRoads_Constants.UNDERSCORE+customBenefitPlan.Plan_Year__c+HighRoads_Constants.UNDERSCORE+customBenefitPlan.Effective_Date__c+HighRoads_Constants.UNDERSCORE+customBenefitPlan.End_Date__c;
                        updateBenefitPlanList.add(metadataObj);
                    }
                }
                if(updateBenefitPlanList != NULL && !updateBenefitPlanList.isEmpty()){
                    
                    upsert updateBenefitPlanList Unique_ID__c;
                    
                }
            }
        }catch(Exception ex){ Database.rollback(sp); }  
        
    }
    
    /**
    * Method Name : updateSummaryOfChanges                                      
    * Parameters  : List<Custom_Benefit_Plan__c> newList,                       
                    Map<ID,Custom_Benefit_Plan__c> oldMap                           
    * Return type : void                                                        
    * Description : This method is used to track the changes on custom benefit   
                    plan record when ever any update occurs on the record.      
    **/
    public void updateSummaryOfChanges(List<Custom_Benefit_Plan__c> newCustomPlanList, Map<ID,Custom_Benefit_Plan__c> oldCustomPlanMap){
        //Fetching the fields into field set using FieldSet "BenefitGridieldTraking"
        for(Schema.FieldSetMember fields :Schema.SObjectType.Custom_Benefit_Plan__c.fieldSets.getMap().get(System.Label.HR210_BenefitGridFieldTrackingFieldeset).getFields()){
            if(!(fields.getFieldPath().equalsIgnoreCase(HighRoads_Constants.PLAN_STATUS_API))){
                fieldSet.add(fields.getFieldPath());
            }    
        }
        //The fields which are adding outside of the fieldset. We need to maintain the field fields as per Benefit Plan Metadata field set.
        //As whenever the custom benefit plan records updated metadata record will be updated. Both field set members and api are same.
        fieldSet.add(HighRoads_Constants.BPA_INTERNAL_STATUS_API);
        //Custom Benefit Plan Object API Name
        String type = HighRoads_Constants.CUSTOM_BENEFIT_PLAN_API_NAME;
        //fetching all the details for sobjects
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType gridSchema = schemaMap.get(type);
        //Fetching all fields from Custom Benefit Plan object
        Map<String, Schema.SObjectField> fieldMap = gridSchema.getDescribe().fields.getMap();
        //looping through the updated custom plan records
        for(Custom_Benefit_Plan__c planObj : newCustomPlanList){
            Boolean isFirstTime = True;
            String Comments = UserInfo.getUserName() + HighRoads_Constants.MODIFIED_ON + System.now() + HighRoads_Constants.NEW_LINE+ HighRoads_Constants.SUMMARY_OF_CHANGES + HighRoads_Constants.NEW_LINE;
            for(String field : fieldSet){
                //taking new value and old value strings
                String newValue = HighRoads_Constants.BLANK_VALUE;
                String oldValue = HighRoads_Constants.BLANK_VALUE;
                //fetching and assigning old value and newvalue
                if(planObj.get(field) != NULL){
                    newValue = String.valueOf(planObj.get(field));
                }
                if(oldCustomPlanMap.get(planObj.Id).get(field) != NULL){
                    oldValue = String.valueOf(oldCustomPlanMap.get(planObj.Id).get(field));
                }
                //checking the old value and new value are not same
                if(!newValue.equalsIgnoreCase(oldValue)){
                    
                    if(isFirstTime){
                        //If the record is updating first time, then fetching old commennts if any and updating the changes
                        if(planObj.Comments__c != NULL){
                            planObj.Comments__c = planObj.Comments__c +HighRoads_Constants.NEW_LINE+Comments+fieldMap.get(field).getDescribe().getLabel() + HighRoads_Constants.FROM_VALUE+oldValue+HighRoads_Constants.TO_VALUE + newValue+HighRoads_Constants.DOUBLE_QUOTE;           
                        }else{
                            planObj.Comments__c = Comments + fieldMap.get(field).getDescribe().getLabel() + HighRoads_Constants.FROM_VALUE+oldValue+HighRoads_Constants.TO_VALUE +newValue+HighRoads_Constants.DOUBLE_QUOTE;
                        }
                    }else{
                        //If it is already updated for any field then just updating the other field changes
                        planObj.Comments__c = planObj.Comments__c +HighRoads_Constants.NEW_LINE+fieldMap.get(field).getDescribe().getLabel() + HighRoads_Constants.FROM_VALUE+oldValue+HighRoads_Constants.TO_VALUE + newValue+HighRoads_Constants.DOUBLE_QUOTE;            
                    }
                    isFirstTime = false;
                }
            }
        }
        
    }
 
}