/*****************************************************
Class Name: ProviderCampaignInitiatorController 
Created By: Nagarjuna Kaipu
Created Date: 05/04/2016
Description: This class is used to initiate the batch class “BatchProviderCampaignInitiator” 
to create a new set of campaign records based on the selected criteria on the page. 
This will also create a new record on the campaign history object to track the status of the initiated batch and the campaign initiation history 
References: PDICampaignInitiation vf page
*****************************************************/
public with sharing class ProviderCampaignInitiatorController {
    
    public String excludeRetired = '';
    public String excludeResigned = '';
    public String excludeInActive = '';
    public String CampaignName{get;set;}
    public Boolean isRetiredOrDeparted{get;set;}
    public Boolean isResignedFromSutter{get;set;}
    public Boolean isinActive{get;set;}
    public Boolean isTradingPartner{get;set;}
    public String CampaignStatus{get;set;}
    public List<PDI_Campaign_History__c> cHistory {get; set;}
    private List<Id> createdSummaryRecordIds = new List<Id>();
    private List<Id> exCreatedSummaryRecordIds = new List<Id>();
    private List<Contact_Validation_Summary__C> filterSummaryRecords = 
        new List<Contact_Validation_Summary__C>();
    public Boolean renderHistory{get;set;}
    
    /*Constructor to intialize
*/
    public ProviderCampaignInitiatorController()
    {
        isRetiredOrDeparted = true;
        isinActive = true;
        isTradingPartner = false;
        //To display existing campaign initiation history
        DisplayCampaignHistory();
    }
    
    /*
Method Name: Save
input Param: None
return type: void
Description: Used to insert campaign history and to invoke batch class
*/
    Public pageReference save()
    {
        SystemException__c systemException = new SystemException__c();
        try
        {
            if(!String.isBlank(CampaignName))
            {
                if(CampaignName.trim() != Label.CL176_PDI_Current_Campaign_Name)
                {
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CL194_PDICampaignNameMismatch)); return null;
                }
                
                //Creating Campaign History record
                PDI_Campaign_History__c pch = new PDI_Campaign_History__c(Name = CampaignName, 
                                                                          Campaign_Initiator__c = userinfo.getName(), 
                                                                          Start_Date_and_Time__c = System.now(), 
                                                                          Campaign_Status__c = Label.CL179_PDI_Campaign_InProgress, 
                                                                          Retired_Departed__c = isRetiredOrDeparted, 
                                                                          Resigned_From_Sutter__c= isResignedFromSutter, 
                                                                          Inactive__c = isinActive,
                                                                          Trading_Partner__c = isTradingPartner);
                Database.insert(pch);
                
                if(isinActive)
                {
                    excludeInActive = Label.CL235_PDIInActiveAppend;
                }
                if(isRetiredOrDeparted)
                {
                    excludeRetired = Label.CL234_PDIRetiredAppend;
                }
                if(isResignedFromSutter)
                {
                    excludeResigned = Label.CL236_PDIResignedAppend;
                }
                if(isTradingPartner)
                {
                    //query = query+' AND Trading_Partner__c != true';
                }
                //Calling batch to initiate new campaign
                BatchProviderCampaignInitiator batchInitiate = new 
                    BatchProviderCampaignInitiator(pch.Id, 
                                                   CampaignName, 
                                                   excludeRetired, 
                                                   excludeInActive, 
                                                   excludeResigned);
                Database.executeBatch(batchInitiate, 2000);
                DisplayCampaignHistory();
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,
                                                           Label.CL184_PDI_Campaign_Confirmation));
            }
        }
        catch(Exception ex) {
            systemException.ExceptionMessage__c = ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now(); insert systemException;
        }
        return null;
    }
    
    /*
Method Name: DisplayCampaignHistory
input Param: None
return type: void
Description: Used to get campaign history
*/
    public void displayCampaignHistory()
    {
            //Querying to load the campaign history records
            cHistory = new List<PDI_Campaign_History__c>();
            cHistory = [SELECT Name, Campaign_Initiator__c, 
                        Start_Date_and_Time__c, End_Date_and_Time__c, 
                        Retired_Departed__c, Resigned_From_Sutter__c, 
                        Inactive__c, Trading_Partner__c, 
                        Campaign_Status__c, Status_Description__c 
                        FROM PDI_Campaign_History__c 
                        Order by CreatedDate DESC LIMIT 50000];
            //Setting latest values
            CampaignName = Label.CL176_PDI_Current_Campaign_Name; 
            renderHistory = false;
            if(!cHistory.isEmpty())
            {
                renderHistory = true;
                if(cHistory[0].Campaign_Status__c != Label.CL180_PDI_Campaign_Completed)
                {
                    //CampaignName = cHistory[0].Name;
                    CampaignName = Label.CL176_PDI_Current_Campaign_Name;
                    isRetiredOrDeparted = cHistory[0].Retired_Departed__c; 
                    isResignedFromSutter = cHistory[0].Resigned_From_Sutter__c; 
                    isinActive = cHistory[0].Inactive__c;
                    isTradingPartner = cHistory[0].Trading_Partner__c;
                    CampaignStatus = cHistory[0].Campaign_Status__C;
                }
            }
    }
}