/************************************************************************************************************************
Class Name : SHP_UpdateBenefitGridAuditandMetadata
Author     : IDC Offshore
Date       : 10/22/2016
Description: Req - 3980 This is a helper class for Portfolioobject trigger.
It is used to insert/update the Benefit Plan Metadata
It is used to Insert the records in Audit Object
History:
VERSION    AUTHOR              DATE        DETAIL
1.0        IDC-Offshore      10/22/2016    This is a helper class for Portfolio object trigger.
                                           It is used to insert/update the Benefit Plan Metadata
                                           It is used to Insert the records in Audit Object when Portfolio is udpated
2.0       Deloitte           13-04-2017    SHP14 Added "updateSummaryChange" method to update field summary on portfolio record with the field audit history
****************************************************************************************************************************/
public class SHP_UpdateBenefitGridAuditandMetadata {
    //for recursion protection
    public static boolean isAfterInsert = true;
    public static boolean isAfterUpdate = true;
    public static boolean isBeforeUpdate = true;
    public static boolean firstTime = true;
    //set to add the fields from portfolio field set
    private Set<String> fieldSet = new Set<String>();
    //list to add new metadata plans to insert
    List<Benefit_Plan_Metadata__c> insertMetaDataList = new List<Benefit_Plan_Metadata__c>();
    //list to add updated metadata plans to update
    List<Benefit_Plan_Metadata__c> updateMetaDataList = new List<Benefit_Plan_Metadata__c>();
    //to fetch the related audit records and store in this list
    List<SHP_Benefit_Grid__c> relatedAuditList = new List<SHP_Benefit_Grid__c>();
    //to insert new audit record list
    List<Benefit_Grid_Audit__c> insertAuditList = new List<Benefit_Grid_Audit__c>();
    //to get all fields from the objet using sObjectType
    Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.SHP_Benefit_Grid__c.fields.getMap();
    //map to store grid id and audit tech date time
    Map<String,String> gridIDTechDateMap = new Map<String,String>();
    //list to update the summary of changes
    List<SHP_Benefit_Grid__c> updateGridList = new List<SHP_Benefit_Grid__c>();
    Savepoint sp;//to roll back the transation if it fails
    
    /**
    * Method Name : upsertMetadata
    * Parameters  : List<SHP_Benefit_Grid__c> insertBenefitGridList
    * Description : To upsert the metadata object whenever Portfolio is inserted/updated
    * Req no      : 3980
    * Return type : void
    **/
    public void upsertMetadata(List<SHP_Benefit_Grid__c> insertBenefitGridList){
        //map to store the grid field api and grid to metadata mapping custom setting data
        Map<string,Grid_to_Metadata_Mapping__c> metadataMap = new Map<string,Grid_to_Metadata_Mapping__c>();
        //fetching all the grid to metadata custom setting data based on condition
        //if we need to update the metadata then only fetching the fields related to metadata from custom setting
        List<Grid_to_Metadata_Mapping__c> metaDataMappingList = [select Name,Metadata_Field_API__c from Grid_to_Metadata_Mapping__c where Metadata_Field_API__c != NULL]; 
        //constructing the map to store grid field api,gridmap custom setting object
        for(Grid_to_Metadata_Mapping__c gridMapObj : metaDataMappingList){
            metadataMap.put(gridMapObj.Name, gridMapObj);
        }
        //lopping through the newly inserted/updated grid data
        for(SHP_Benefit_Grid__c gridObj : insertBenefitGridList){
            Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
            for(String fieldName : schemaFieldMap.keySet())
            {
                //fetching the corresponding metadata field api from custom setting based on the grid field api
                Grid_to_Metadata_Mapping__c mappedField = metadataMap.get(fieldName);
                //populating the value to metadata field
                if(mappedField != NULL){
                    bpm.put(mappedField.Metadata_Field_API__c,gridObj.get(fieldName));
                }
                
            }
            //constructing the name field for benefit plan metadata
            bpm.name = gridObj.Benefit_Plan_ID__c+' - '+String.valueOf(gridObj.SHP_Benefit_Plan_Year__c).subString(0,4);
            //constructing the unique key (external id) which will be used for upsert operation
            bpm.Unique_ID__c = gridObj.Benefit_Plan_ID__c+'_'+String.valueOf(gridObj.SHP_Benefit_Plan_Year__c).subString(0,4)+'_'+gridObj.Effective_Start__c+'_'+gridObj.Effective_End__c;
            bpm.Plan_Year__c = String.valueOf(gridObj.SHP_Benefit_Plan_Year__c).subString(0,4);
            //checking the plan is related to HDHP or not
            if(gridObj.IsHDHP__c){
                bpm.Product__c = gridObj.Product_Type__c + ' - HDHP';
            }else{
                bpm.Product__c = gridObj.Product_Type__c;    
            }
            //checking the plan is custom or not
            if(gridObj.IsCustom__c){
                bpm.Plan_Type__c = System.Label.HR49_Custom;        
            }else{
                bpm.Plan_Type__c =System.Label.HR48_Standard;    
            }
            //checking the plan is rider or not
            if(gridObj.IsRider__c){
                bpm.Medical_OR_Rider__c =System.Label.HR43_Rider;       
            }else{
                bpm.Medical_OR_Rider__c =System.Label.HR42_Medical;    
            }   
            //adding the metadata to insert list
            insertMetaDataList.add(bpm);
        }
        //upserting the operation
        if(!insertMetaDataList.isEmpty())
        {
            try
            {
               sp = Database.setSavepoint();
               upsert insertMetaDataList Unique_ID__c; 
            }catch(DMLException ex){ Database.rollback(sp);}
            
        }
        
    }
    
    /**
    * Method Name : updateAuditandMetadata
    * Parameters  : List<SHP_Benefit_Grid__c> newBenefitGridList,Map<ID,SHP_Benefit_Grid__c> oldBenefitGridMap
    * Description : To insert the old records of Portfolio object data into Audit object.
    * Req no      : 3980
    * Return type : void
    **/
    public void updateAuditandMetadata(List<SHP_Benefit_Grid__c> newBenefitGridList,Map<ID,SHP_Benefit_Grid__c> oldBenefitGridMap){
        //fetching the field api from the fieldset
        for(Schema.FieldSetMember fields :Schema.SObjectType.SHP_Benefit_Grid__c.fieldSets.getMap().get(System.Label.SHP_Benefit_Grid_FieldSet_Name).getFields()){
            fieldSet.add(fields.getFieldPath());
        }
        //fetching the related audit record for grid record
        relatedAuditList = [select id,Version_Number__c,Tech_Date_Time__c,(select id, Version_Number__c,Comments__c,Tech_Date_Time__c FROM Benefit_Grid_Audit__r order by createddate desc limit 1)
                            From SHP_Benefit_Grid__c where ID IN: newBenefitGridList LIMIT 10000];
        //looping through the related audit list to populate the audit record tech date time
        //this will be used to insert the audit record based on the tech date time entered in grid
        for(SHP_Benefit_Grid__c gridObj : relatedAuditList){
            if(gridObj.Benefit_Grid_Audit__r != NULL && gridObj.Benefit_Grid_Audit__r.size() > 0){
                gridIDTechDateMap.put(gridObj.Id, gridObj.Benefit_Grid_Audit__r[0].Tech_Date_Time__c);
            }else{
                gridIDTechDateMap.put(gridObj.Id, NULL);
            }
        }
        //grid object api name
        String type = HighRoads_Constants.PORTFOLIO_OBJ_API_NAME;
        //fetching all object from database
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        //fetching Grid object using api name
        Schema.SObjectType gridSchema = schemaMap.get(type);
        //fetching all the fields from grid object
        Map<String, Schema.SObjectField> fieldMap = gridSchema.getDescribe().fields.getMap();
        //looping the new data to check the tech date time value to update the grid record
        // or to insert the audit record 
        
        for(SHP_Benefit_Grid__c gridObj : newBenefitGridList){
            //creating the grid object to set the comments
            SHP_Benefit_Grid__c gridObj1 = new SHP_Benefit_Grid__c(id=gridObj.id);
            //variable is used to check if one of the field is updated then this flag will be set to false
            //once this flag is set to false, even other fields changed we are just updating the summary of record in the comments field
            //based on this flag
            Boolean isFirstTime = True;
            //audit object
            Benefit_Grid_Audit__c newAuditObj;
            //for constructing the comments which will be added to summary of changes before updating comments field
            String Comments = UserInfo.getUserName() + HighRoads_Constants.MODIFIED_ON + System.now() + HighRoads_Constants.NEW_LINE+ HighRoads_Constants.SUMMARY_OF_CHANGES + HighRoads_Constants.NEW_LINE;
            //this flag is used to check the grid record is changed(tech date time is changed)
            boolean isChanged = false;
            //this flag is used to check the grid record is updated(when old and new tech date time field value is same but some field values are changed)
            boolean isUpdated = false;
            //looping through the fieldset
            for(String field : fieldSet){
                String newValue = HighRoads_Constants.BLANK_VALUE;
                String oldValue = HighRoads_Constants.BLANK_VALUE;
                //in some of the fields there are multiple line breaks hence checking the condition
                if(gridObj.get(field) != NULL){
                    newValue = String.valueOf(gridObj.get(field));
                    if(newValue.contains(HighRoads_Constants.TAB_NEWLINE)){
                        newValue = newValue.replaceAll(HighRoads_Constants.TAB_NEWLINE,HighRoads_Constants.BLANK_VALUE);
                    }else if(newValue.contains(HighRoads_Constants.NEW_LINE)){
                        newValue = newValue.replaceAll(HighRoads_Constants.NEW_LINE,HighRoads_Constants.BLANK_VALUE);
                    }
                }
                //in some of the fields there are multiple line breaks hence checking the condition
                if(oldBenefitGridMap.get(gridObj.Id).get(field) !=NULL){
                    oldValue = String.valueOf(oldBenefitGridMap.get(gridObj.Id).get(field)); 
                    if(oldValue.contains(HighRoads_Constants.TAB_NEWLINE)){
                        oldValue = oldValue.replaceAll(HighRoads_Constants.TAB_NEWLINE,HighRoads_Constants.BLANK_VALUE);
                    }else if(oldValue.contains(HighRoads_Constants.NEW_LINE)){
                        oldValue = oldValue.replaceAll(HighRoads_Constants.NEW_LINE,HighRoads_Constants.BLANK_VALUE);
                    }
                }
                //checking conditions for new value and old value
                //if new and old value are not same
                //the below conditions are based on the tech date time field on grid and audit records
                //we are checking these conditions and updating the data some time and creating audit records in some condition
                //because Import Wizard will not support all fields at a time so loading the data in two sets hence checking the tech date time field
                if(!newValue.equalsIgnoreCase(oldValue) || ((String.valueOf(gridObj.get(field)) == NULL || String.valueOf(gridObj.get(field)) == '') && (String.valueOf(oldBenefitGridMap.get(gridObj.Id).get(field)) != NULL && String.valueOf(oldBenefitGridMap.get(gridObj.Id).get(field)) != '')) || 
                   ((String.valueOf(oldBenefitGridMap.get(gridObj.Id).get(field)) == NULL || String.valueOf(oldBenefitGridMap.get(gridObj.Id).get(field)) == '') && (String.valueOf(gridObj.get(field)) != NULL && String.valueOf(gridObj.get(field)) != ''))){
                       //tech date time is no null
                       if(gridObj.Tech_Date_Time__c != NULL){
                           //new data tech date time and old data tech date time is equal and audit record is already exists
                           //and audit tech date time and new data tech date time is equal which means second set is loading and is just updating same records
                           //so summary of record changes will update in the grid record
                           if(oldBenefitGridMap.get(gridObj.Id).Tech_Date_Time__c != NULL && oldBenefitGridMap.get(gridObj.Id).Tech_Date_Time__c.equalsIgnoreCase(gridObj.Tech_Date_Time__c) && 
                              gridIDTechDateMap.get(gridObj.Id) != NULL && gridIDTechDateMap.get(gridObj.Id) == gridObj.Tech_Date_Time__c){
                                  isUpdated = true; 
                              }
                           //new data tech date time and old data tech date time is equal and audit record is already exists
                           //and audit tech date time and new data tech date time is not equal which means first set of data is loading
                           //hence creating the audit record
                           else if(oldBenefitGridMap.get(gridObj.Id).Tech_Date_Time__c != NULL && oldBenefitGridMap.get(gridObj.Id).Tech_Date_Time__c.equalsIgnoreCase(gridObj.Tech_Date_Time__c) && 
                                       gridIDTechDateMap.get(gridObj.Id) != NULL && gridIDTechDateMap.get(gridObj.Id) != gridObj.Tech_Date_Time__c){
                                           isChanged = true;
                                           if(isFirstTime){
                                               newAuditObj = new Benefit_Grid_Audit__c();
                                               newAuditObj.Tech_Date_Time__c = gridObj.Tech_Date_Time__c;
                                               newAuditObj.Benefit_Grid__c = gridObj.Id;
                                               isFirstTime = false;
                                           }
                                       }
                           //old record tech date time null and new is not null so it is first set of data loading hence creating audit record
                           else if(oldBenefitGridMap.get(gridObj.Id).Tech_Date_Time__c == NULL && gridObj.Tech_Date_Time__c != NULL){
                                           isChanged = true;
                                           if(isFirstTime){
                                               newAuditObj = new Benefit_Grid_Audit__c();
                                               newAuditObj.Tech_Date_Time__c = gridObj.Tech_Date_Time__c;
                                               newAuditObj.Benefit_Grid__c = gridObj.Id;
                                               isFirstTime = false;
                                           }
                                       }
                           //old and new tech date time is not equal - if new tech date time is null but old is not null
                           //hence is creating new audit record
                           else if(!oldBenefitGridMap.get(gridObj.Id).Tech_Date_Time__c.equalsIgnoreCase(gridObj.Tech_Date_Time__c) && 
                                                oldBenefitGridMap.get(gridObj.Id).Tech_Date_Time__c != NULL){
                                                    isChanged = true;
                                                    if(isFirstTime){
                                                        newAuditObj = new Benefit_Grid_Audit__c();
                                                        newAuditObj.Tech_Date_Time__c = gridObj.Tech_Date_Time__c;
                                                        newAuditObj.Benefit_Grid__c = gridObj.Id;
                                                        isFirstTime = false;
                                                    }
                                                    
                                                }
                       }
                       //if tech date time is null - if user removes the tech date time and upates the record then creating new audit record
                       else{
                           isChanged = true;
                           if(isFirstTime){
                               newAuditObj = new Benefit_Grid_Audit__c();
                               newAuditObj.Benefit_Grid__c = gridObj.Id;
                           }
                           
                           isFirstTime= False;
                       }
                       
                   }
                
            }
            //populating the old comments to audit record
            if(isChanged){
                newAuditObj.Comments__c = oldBenefitGridMap.get(gridObj.Id).Comments__c;
                for(String field : fieldSet){
                    try{
                        newAuditObj.put(field,oldBenefitGridMap.get(gridObj.Id).get(field));
                    }catch(Exception e) {
                        
                    }
                }
                newAuditObj.Version_Number__c = oldBenefitGridMap.get(gridObj.Id).Version_Number__c;
                //version update
                gridObj1.Version_Number__c = gridObj.Version_Number__c+1;
                updateGridList.add(gridObj1);
                insertAuditList.add(newAuditObj);            
            }else{
                if(isUpdated){
                    updateGridList.add(gridObj1);
                }
                
            }
        } 
        try
        {
            sp = Database.setSavepoint();
            //inserting the audit list
            if(!insertAuditList.isEmpty()){
                insert insertAuditList;
            }
            
        }catch(DMLException ex){ Database.rollback(sp);}
    }
    /**
    * Method Name : updateSummaryChange
    * Parameters  : List<SHP_Benefit_Grid__c> newPortfolioList,Map<ID,SHP_Benefit_Grid__c> oldPortfolioMap
    * Description : update field summary changes in portfolio record
    * User story  : SHP14
    * Return type : void
    **/
    public void updateSummaryChange(List<SHP_Benefit_Grid__c> newPortfolioList, Map<ID,SHP_Benefit_Grid__c> oldPortfolioMap){
         //Fetching the fields into field set using FieldSet "Portfolio"
        for(Schema.FieldSetMember fields :Schema.SObjectType.SHP_Benefit_Grid__c.fieldSets.getMap().get(System.Label.HR240ChangeHistoryFieldSet).getFields()){
            fieldSet.add(fields.getFieldPath());
        }
        
        String type = HighRoads_Constants.PORTFOLIO_OBJ_API_NAME;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType gridSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = gridSchema.getDescribe().fields.getMap();
        
        //looping through the updated Portfolio records
        for(SHP_Benefit_Grid__c planObj : newPortfolioList){
            Boolean isFirstTime = True;
            Boolean isChanged = false;
            String Comments = UserInfo.getUserName() + HighRoads_Constants.MODIFIED_ON + System.now() + HighRoads_Constants.NEW_LINE+ HighRoads_Constants.SUMMARY_OF_CHANGES + HighRoads_Constants.NEW_LINE;
            for(String field : fieldSet){
                //taking new value and old value strings
                String newValue = HighRoads_Constants.BLANK_VALUE;
                String oldValue = HighRoads_Constants.BLANK_VALUE;
                //fetching and assigning old value and newvalue
                if(planObj.get(field) != NULL){
                    newValue = String.valueOf(planObj.get(field));
                }
                if(oldPortfolioMap.get(planObj.Id).get(field) != NULL){
                    oldValue = String.valueOf(oldPortfolioMap.get(planObj.Id).get(field));
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
                    isChanged = true;
                }
            }
            //    Increments version number
            if(isChanged && planObj.Tech_Date_Time__c == null){
                planObj.Version_Number__c = planObj.Version_Number__c + 1;
            }
        }
    }
}