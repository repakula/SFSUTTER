/*****************************************************
Class Name: BatchProviderCampaignInitiator 
Created By: Nagarjuna Kaipu
Created Date: 04/04/2016
Description: This batch class is used to create the new set of Provider Summary records 
based on the campaign name, threshold date and the provider selected criteria.
*****************************************************/
global class BatchProviderCampaignInitiator implements Database.Batchable<sObject>, Database.Stateful{
    global Id pchId;
    global String camapignName = '';
    global String excludeRetired = '';
    global String excludeInActive = ''; 
    global String excludeResigned = '';
    global String errMsg = '';
    global Integer totalCount = 0;
    global Integer successCount = 0;
    global Integer errorCount = 0;
    global String strSpace = ' ';
    
    //Constructor to get provider criteria
    global BatchProviderCampaignInitiator(Id pchId, String camapignName, String excludeRetired, String excludeInActive, String excludeResigned){
        this.excludeRetired = excludeRetired;
        this.excludeInActive = excludeInActive;
        this.excludeResigned = excludeResigned;
        this.pchId = pchid;
    }
    /* Name: Start
*Input: Batchable Context
* Return Type: Database.QueryLocator
* Description: Used to get the existing campaign records
*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //Query to get the list of valid provider records to initiate new campaign
        String query = 'SELECT ID, Contact_Id__c, Contact_Id__r.Id, Contact_Id__r.Name, Contact_Id__r.Preferred_Communication_Method__c, Contact_Id__r.Provider_Name__c, Contact_Id__r.Provider_Address_Line_2__c, '
            +' Contact_Id__r.Provider_Title__c,Contact_Id__r.Email, Contact_Id__r.MobilePhone, Contact_Id__r.Ok_To_Text__c, Contact_Id__r.Provider_Correspondence_Address__c, Contact_Id__r.Provider_Admin_Assistant_Phone__c, '
            +' Contact_Id__r.Provider_Correspondence_City__c, Contact_Id__r.Provider_Correspondence_State__c, Contact_Id__r.Provider_Correspondence_PostalCode__c, '
            +' Contact_Id__r.Provider_Correspondence_Phone__c, Contact_Id__r.Provider_Correspondence_Fax_Number__c, Contact_Id__r.Provider_Active_Status__c, Contact_Id__r.Provider_Retired_Departed__c, '
            +' Contact_Id__r.Provider_Resigned_From_Sutter__c, Contact_Id__r.Provider_Practicing_Physician__c, Contact_Id__r.Provider_Communication_Preferences_HIM__c, '
            +' Contact_Id__r.Provider_ID__c, Contact_Id__r.Provider_Admin_Assistant__c, Contact_Id__r.Provider_Admin_Assistant_Email__c, '
            +' Contact_Id__r.Provider_Access_Type__c, Contact_Id__r.Provider_Type__c, Provider_Type__c, Contact_Id__r.Deficiency_Provider__c, Contact_Id__r.Phone_Extension__c, Contact_Id__r.Provider_Admin_Assistant_Title__c, '
            +' Contact_Id__r.Contact_External_ID1__c, Contact_Id__r.Username__c, New_Street_Address__c, Provider_Last_Login_Date__c, Address_Type__c, Serial_Number__c, Tech_Is_Campaign_Done__c '
            +' FROM Contact_Validation_Summary__c'
            +' WHERE Tech_Is_Campaign_Done__c = false AND Address_Type__c = \''+Label.CL303_PDIPrimary+'\''
            +' AND PDI_Campaign__c = \''+Label.CL175_PDI_Old_Campaign_Name+'\'';
        
        if(!String.isEmpty(excludeInActive))
        {
            query = query + strSpace + Label.CL235_PDIInActiveAppend;
        }
        if(!String.isEmpty(excludeRetired))
        {
            query = query + strSpace + Label.CL234_PDIRetiredAppend;
        }
        if(!String.isEmpty(excludeResigned))
        {
            query = query + strSpace + Label.CL236_PDIResignedAppend;
        }
        System.debug('query is: '+query);
        return Database.getQueryLocator(query);
    }
    /* Name: Execute
*Input: List of Summary records
* Return Type: void
* Description:Used to create new set of campaign records
*/
    global void execute(Database.BatchableContext BC, List<Contact_Validation_Summary__c> providersSummaryList)
    {
        SystemException__c systemException = new SystemException__c();
        try
        {
            List<Contact_Validation_Summary__c> newProviderSummaryRecords = new List<Contact_Validation_Summary__c>();
            //Querying Non Validated Providers Queue to assign to new records
            Group grp =[SELECT Id, Name FROM Group WHERE TYPE = 'Queue' AND Name = 'Non Validated Providers' LIMIT 1];
            Map<Id, Contact_Validation_Summary__c> exSummaryMap = new Map<Id, Contact_Validation_Summary__c>();
            List<Id> conIdList = new List<Id>();
            
            for(Contact_Validation_Summary__c cvs: providersSummaryList)
            {
                conIdList.add(cvs.Contact_Id__r.Id);
            }

            for(Contact_Validation_Summary__c exSum: [Select Id, Contact_Id__r.Id From Contact_Validation_Summary__c Where Contact_Id__r.Id IN: conIdList AND PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name LIMIT 2000])
            {
                exSummaryMap.put(exSum.Contact_Id__r.Id, exSum);
            }
            
            for(Contact_Validation_Summary__c providerSummary: providersSummaryList)
            {   
                System.debug('inside execute');
                if(!exSummaryMap.containsKey(providerSummary.Contact_Id__r.Id))
                {
                    Contact_Validation_Summary__c newRecord = 
                    new Contact_Validation_Summary__c(PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name,
                                                      ProviderInfoHistory__c = providerSummary.Id,
                                                      Practicing_Physician__c = 'true'.equalsIgnoreCase(Label.CL375_PDIAllowInactiveProvider) && providerSummary.Contact_Id__r.Provider_Resigned_From_Sutter__c == true? true : providerSummary.Contact_Id__r.Provider_Practicing_Physician__c,
                                                      Resigned_From_Sutter__c = 'true'.equalsIgnoreCase(Label.CL375_PDIAllowInactiveProvider) && providerSummary.Contact_Id__r.Provider_Resigned_From_Sutter__c == true? false : providerSummary.Contact_Id__r.Provider_Resigned_From_Sutter__c,
                                                      Retired_Departed__c = providerSummary.Contact_Id__r.Provider_Retired_Departed__c,
                                                      Name = providerSummary.Contact_Id__r.Name,
                                                      Status__c = Label.CL185_PDI_Non_Validated_Status,
                                                      
                                                      Preferred_Communication_Method__c = providerSummary.Contact_Id__r.Preferred_Communication_Method__c,
                                                      Communication_Preferences_HIM__c = providerSummary.Contact_Id__r.Provider_Communication_Preferences_HIM__c,
                                                      Contact_Id__c = providerSummary.Contact_Id__c,
                                                      Email__c = providerSummary.Contact_Id__r.Email,
                                                      Mobile_Phone__c = providerSummary.Contact_Id__r.MobilePhone,
                                                      Ok_To_Text__c = String.isNotBlank(providerSummary.Contact_Id__r.Ok_To_Text__c)?Boolean.valueOf(providerSummary.Contact_Id__r.Ok_To_Text__c): false ,
                                                      
                                                      Username__c = providerSummary.Contact_Id__r.Username__c,
                                                      Deficiency_Provider__c = providerSummary.Contact_Id__r.Deficiency_Provider__c,
                                                      Provider_Access_Type__c = providerSummary.Contact_Id__r.Provider_Access_Type__c,
                                                      Provider_Type__c = providerSummary.Contact_Id__r.Provider_Type__c,
                                                      
                                                      Provider_ID__c = providerSummary.Contact_Id__r.Provider_ID__c,
                                                      Provider_Name__c = providerSummary.Contact_Id__r.Provider_Name__c,
                                                      Provider_Title__c = providerSummary.Contact_Id__r.Provider_Title__c,
                                                      Provider_Last_Login_Date__c = providerSummary.Provider_Last_Login_Date__c,
                                                      
                                                      Address_Type__c = providerSummary.Address_Type__c,
                                                      Serial_Number__c = providerSummary.Serial_Number__c,
                                                      New_Street_Address__c = providerSummary.New_Street_Address__c,
                                                      Address_Line_2__c = providerSummary.Contact_Id__r.Provider_Address_Line_2__c,
                                                      Secure_City__c = providerSummary.Contact_Id__r.Provider_Correspondence_City__c,
                                                      Secure_Fax__c = String.isNotBlank(providerSummary.Contact_Id__r.Provider_Correspondence_Fax_Number__c) && providerSummary.Contact_Id__r.Provider_Correspondence_Fax_Number__c.SubString(0,1).Contains('1') ? 
                                                      providerSummary.Contact_Id__r.Provider_Correspondence_Fax_Number__c.SubString(1, providerSummary.Contact_Id__r.Provider_Correspondence_Fax_Number__c.Length()): providerSummary.Contact_Id__r.Provider_Correspondence_Fax_Number__c,
                                                      Secure_Phone__c = String.isNotBlank(providerSummary.Contact_Id__r.Provider_Correspondence_Phone__c) && providerSummary.Contact_Id__r.Provider_Correspondence_Phone__c.SubString(0,1).Contains('1') ? 
                                                      providerSummary.Contact_Id__r.Provider_Correspondence_Phone__c.SubString(1, providerSummary.Contact_Id__r.Provider_Correspondence_Phone__c.Length()): providerSummary.Contact_Id__r.Provider_Correspondence_Phone__c,
                                                      Secure_Phone_Ext__c = providerSummary.Contact_Id__r.Phone_Extension__c,
                                                      Secure_State__c = providerSummary.Contact_Id__r.Provider_Correspondence_State__c,
                                                      Secure_Street_Address__c = providerSummary.Contact_Id__r.Provider_Correspondence_Address__c,
                                                      Secure_Zip_Code__c = providerSummary.Contact_Id__r.Provider_Correspondence_PostalCode__c,
                                                      
                                                      Admin_Assistant__c = providerSummary.Contact_Id__r.Provider_Admin_Assistant__c,
                                                      Admin_Assistant_Email__c = providerSummary.Contact_Id__r.Provider_Admin_Assistant_Email__c,
                                                      Admin_Assistant_Phone__c = String.isNotBlank(providerSummary.Contact_Id__r.Provider_Admin_Assistant_Phone__c) && providerSummary.Contact_Id__r.Provider_Admin_Assistant_Phone__c.SubString(0,1).Contains('1') ? 
                                                      providerSummary.Contact_Id__r.Provider_Admin_Assistant_Phone__c.SubString(1, providerSummary.Contact_Id__r.Provider_Admin_Assistant_Phone__c.Length()): providerSummary.Contact_Id__r.Provider_Admin_Assistant_Phone__c,
                                                      Admin_Assistant_Title__c = providerSummary.Contact_Id__r.Provider_Admin_Assistant_Title__c
                                                     );
                if(grp.Id != null)
                {
                    //Assigning Queue as the record owner
                    newRecord.OwnerId = grp.Id;
                }
                //List of provider summary records to insert
                newProviderSummaryRecords.add(newRecord);
                }
                //Creating new campign record
                
            }
            List<Id> successIds = new List<Id>();
            List<Id> IdstoUpdate = new List<Id>();
            List<Contact_Validation_Summary__c> successListToUpdate = new List<Contact_Validation_Summary__c>();
            System.debug('newProviderSummaryRecords are: '+newProviderSummaryRecords);
            if(!newProviderSummaryRecords.isEmpty())
            {   System.debug('inside update');
                //Inserting new Campaign Records
                Database.SaveResult[] newCampRecs = Database.insert(newProviderSummaryRecords, false);
                for(Database.SaveResult dsr : newCampRecs){
                    if(!dsr.isSuccess()){
                        errMsg = dsr.getErrors()[0].getMessage(); errorCount++;
                    }
                    else
                    {
                        successIds.add(dsr.getId());
                        successCount++;
                    }
                    totalCount++;
                }
                if(!successIds.isEmpty())
                {
                    for(Contact_Validation_Summary__c cvsIds: [SELECT ProviderInfoHistory__c FROM Contact_Validation_Summary__c WHERE Id IN: successIds LIMIT 2000])
                    {
                        IdstoUpdate.add(cvsIds.ProviderInfoHistory__c);
                    }
                    successListToUpdate = [SELECT Id FROM Contact_Validation_Summary__c WHERE Id IN: IdstoUpdate LIMIT 2000];
                    for(Contact_Validation_Summary__c campUpdate: successListToUpdate)
                    {
                        campUpdate.Tech_Is_Campaign_Done__c = true;
                    }
                    update successListToUpdate;
                    successIds.clear();
                    IdstoUpdate.clear();
                    successListToUpdate.clear();
                }
            }
        } 
        catch(Exception ex) {
            systemException.ExceptionMessage__c = ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now(); insert systemException;
        }
    }
    /* Name: finish
*Input: Batchable Context
* Return Type: void
* Description: Used to log the status
*/
    global void finish(Database.BatchableContext BC)
    {
        String body;
        //Querying In Progress Campaign history record to update with the batch status
        PDI_Campaign_History__c pch = [SELECT Id, Name, Campaign_Status__c FROM PDI_Campaign_History__c WHERE Id =: pchId AND Campaign_Status__c =: Label.CL179_PDI_Campaign_InProgress Order by CreatedDate DESC LIMIT 1];
        //Capturing batch status 
        AsyncApexJob a = [SELECT id, ApexClassId,
                          JobItemsProcessed, TotalJobItems,
                          NumberOfErrors, CreatedBy.Email, CompletedDate
                          FROM AsyncApexJob
                          WHERE id = :BC.getJobId()];
        
        if(errorCount != 0 && successCount != 0){
            
            body = 'Your batch job BatchProviderCampaignInitiator has finished at '+a.CompletedDate+'. \n Out of '+ totalCount +' records, there were '+ successCount+ 'success records and ' + errorCount + ' errors. '+errMsg;
            
            if(pch != null)
            {
                pch.Status_Description__c = body; pch.Campaign_Status__c = Label.CL193_PDICampaignPartialSuccess;
            }
        }
        else if(errorCount != 0){
            body = 'Your batch job BatchProviderCampaignInitiator has finished at '+a.CompletedDate+'. \n Out of '+ totalCount +' records, there were '+ errorCount + ' errors. '+errMsg;
            
            if(pch != null)
            {
                pch.Status_Description__c = body; pch.Campaign_Status__c = Label.CL188_PDICampaignFailed;
            }
        }
        else if(successCount != 0)
        {
            body = 'Your batch job '
                + 'BatchProviderCampaignInitiator '
                + 'has finished at '+a.CompletedDate+'. \n' 
                + ' Out of '+ totalCount +' records, there were '
                + successCount
                + 'success records Please check.';
            
            if(pch != null)
            {
                pch.Status_Description__c = body;
                pch.Campaign_Status__c = Label.CL180_PDI_Campaign_Completed;
            }
            
        }
        else
        {
            if(pch != null)
            {
                body = 'Your batch job BatchProviderCampaignInitiator has finished at '
                    +a.CompletedDate+'. \n Out of '
                    + totalCount +' records, there were no records processed as part of this batch job.';
                pch.Status_Description__c = body; 
                pch.Campaign_Status__c = Label.CL180_PDI_Campaign_Completed;
            }
        }
        
        if(pch != null)
        {
            pch.End_Date_and_Time__c = Datetime.now();
            update pch; //Updating Campaign history with the batch status
        }
    }
}