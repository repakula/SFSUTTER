/*******************************************************************************************************************
Class Name : HighRoads_RegeneratePageController
Author     : IDC Offshore
Date       : 10/23/2016
Description: This controller class is used to create New Document Generation Request when clicked on "Regenerate Documents" Button
History:
VERSION    AUTHOR                     DATE              DETAIL
1.0        IDC-Offshore            10/23/2016       This is controller class for HighRoads_RegeneratePage page.
                                                     This is used to create New Document Generation Request Records at SSO & Opportunity Stage
                                                     when clicked on "Regenerate Documents" button on SSO for Large Groups & on Opportunity
                                                    for Small Groups and Individual Business.
2.0        Deloitte               16/03/2017      SFSHP-12, Sales - Regenerate Documents Button
*******************************************************************************************************************/
public with sharing class HighRoads_RegeneratePageController
{
    //Class level properties
    Map<String,SF_P2A_Market_Segments_Mapping__c> groups = SF_P2A_Market_Segments_Mapping__c.getAll();
    public ID recordId              {get;set;}
    public Opportunity oppObj       {get;set;}
    public Sold_Sign_Off__c ssoObj  {get;set;}
    public String sObjName          {get;set;}
    public static boolean checkPoint{get;set;}
    public boolean isapproved       {get;set;}
    public boolean isErrorOccured   {get;set;}
    /** 
        Constructor which gets Object and Record Id on which User clicks on Regenerate Documents Button
    **/
    public HighRoads_RegeneratePageController()
    {
        checkPoint = false;//Variable to store if the existing Document generation request which are pending
        isapproved = false;//Variable to store if the existing Document generation request which are in approved status
        recordId = ApexPages.currentPage().getParameters().get(System.label.HR144_id);
        sObjName = recordId.getSObjectType().getDescribe().getName();
    }
    /**
    * Method Name : checkDocGenExists
    * Parameters  : None
    * Description : To Check if already there is document Generation Request existing in Record and show Corresponding Error/Warning messages
    * Return type : void
    **/
    public void checkDocGenExists()
    {
        System.Savepoint savePointObj = Database.setSavepoint();
        try
        {
            //Fetching Custom setting data to check if Document generation is required for Individual business
            HR_Individual_Document_Generation__c indDocGenCSObj = HR_Individual_Document_Generation__c.getInstance(System.label.HR175_IndividualAccount);
            //Check if Regenertion is triggered from Opportunity
            if(sObjName.equalsIgnoreCase(System.Label.HR22_Opportunity))
            {
                Id shpSalesRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(System.label.HR144_SHPSalesOpportunity).getRecordTypeId();
                /*Fetch the Previous Document Generation Request Record if it is not Approved*/
                oppObj = [select id,name,Employer_Type__c,Account_RecordType_Name__c ,RecordTypeId,
                (select id,name FROM Document_Generation_Requests__r
                Where Request_Status__c !=: System.label.HR140_Approved order by createddate desc limit 1)
                From Opportunity where ID =: recordId];
                SF_P2A_Market_Segments_Mapping__c grp = groups.get(oppObj.Employer_Type__c);
                // Check if Opportunity record type is SHP Sales Opportunity
                if(oppObj.RecordTypeId == shpSalesRecTypeId)
                {
                    //check if Document generation is required for Individual business
                    if(indDocGenCSObj != NULL && indDocGenCSObj.Document_Generation_Required__c)
                    {
                        //Check if there are any existing Document generation request that are not approved
                        if(oppObj.Document_Generation_Requests__r.size() > 0)
                        {
                            checkPoint =True;
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.label.HR145_documentRequestsInProgressWarning));
                        }
                        else
                        {
                            //Create Document generation request if there are no existing Document generation request that are not approved
                            isapproved = true;
                            createRecord();
                            //Display message that New Document Generation Request is created
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.HR146_NewDocReqCreated,''));
                        }
                    }
                }
            }
            else
            {
                /*Fetch the Previous Document Generation Request Record if it is not Approved*/
                ssoObj = [select id,name,Employer_Type__c,Account_RecordType_Name__c ,
                (select id,name FROM Document_Generation_Requests__r
                Where Request_Status__c !=: System.label.HR140_Approved order by createddate desc limit 1)
                From Sold_Sign_Off__c where ID =: recordId];
                SF_P2A_Market_Segments_Mapping__c grp = groups.get(ssoObj.Employer_Type__c);
                //Check if the Market Segment is large group
                if((grp != NULL && System.label.HR02_MarketSegment_LG.equalsIgnoreCase(grp.P2A_Market_Segment__c)))
                {
                    //Check if there are any existing Document generation request that are not approved
                    if(ssoObj.Document_Generation_Requests__r.size() > 0)
                    {
                        checkPoint =True;
                        //Display warning message
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.label.HR145_documentRequestsInProgressWarning));
                    }
                    else
                    {
                        //Create Document generation request if there are no existing Document generation request that are not approved
                        isapproved = true;
                        createRecord();
                        //Display message that New Document Generation Request is created
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.HR146_NewDocReqCreated,''));
                    }
                }
            }
        }
        catch(Exception ex)
        { ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR220_ErrorinDocGeneration));Database.rollback(savePointObj); isErrorOccured = true;System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
    }
    /**
    * Method Name : createRecord
    * Parameters  : None
    * Description : Create new Document Geneartion Request calling the Method from HighRoads_DocGenRequest Class
    * Return type : PageReference (SFSHP-12, Sales - Regenerate Documents Button)
    * 
    **/
    public PageReference createRecord()
    {
        System.Savepoint savePointObj = Database.setSavepoint();
        try
        {
            Set<ID> objectIdSet = new Set<ID>();
            objectIdSet.add(recordId);
            if(sObjName.equalsIgnoreCase(System.Label.HR22_Opportunity))
            {
                List<Document_Generation_Request__c> updateDocGenList = new List<Document_Generation_Request__c>();
                oppObj.regenerate__c = true;
                update oppObj;
                /*update Status of Previous Document Generation Request if it is not Approved*/
                system.debug('### oppObj : '+oppObj);
                system.debug('### oppObj : '+oppObj.Document_Generation_Requests__r);
                if(oppObj != NULL && oppObj.Document_Generation_Requests__r != NULL && oppObj.Document_Generation_Requests__r.size() >0)
                {
                    for(Document_Generation_Request__c docGenObj : oppObj.Document_Generation_Requests__r)
                    {
                        docGenObj.Request_Status__c  = System.label.HR149_NewRequestCreated;
                        updateDocGenList.add(docGenObj);
                    }
                    if(updateDocGenList !=NULL && !updateDocGenList.isEmpty())
                    {
                        try
                        {
                            update updateDocGenList;
                            HighRoads_DocGenRequest.isRegenerateDocumentRequest = true;
                            HighRoads_DocGenRequest.insertDocGenRequestsOpp(objectIdSet);
                            oppObj.regenerate__c = false;
                            update oppObj;
                            return new PageReference('/'+RecordID);
                        }
                        catch(Exception Ex)
                        {
                            isapproved = false;
                            checkPoint = true;
                            ApexPages.addMessages(Ex);
                            return null;
                        }
                    }
                }
                return null;
            }
            else
            {
                //SHP-12, Sales - Regenerate Documents Button
                List<Document_Generation_Request__c> updateDocGenList = new List<Document_Generation_Request__c>();
                ssoObj.regenerate__c = true;
                //update ssoObj;
                /*update Status of Previous Document Generation Request if it is not Approved*/
                if(ssoObj != NULL && ssoObj.Document_Generation_Requests__r != NULL && ssoObj.Document_Generation_Requests__r.size() >0)
                {
                    for(Document_Generation_Request__c docGenObj : ssoObj.Document_Generation_Requests__r)
                    {
                        docGenObj.Request_Status__c  = System.label.HR149_NewRequestCreated;
                        updateDocGenList.add(docGenObj);
                    }
                    if(updateDocGenList !=NULL && !updateDocGenList.isEmpty())
                    {
                        try
                        {
                            update updateDocGenList;
                            HighRoads_DocGenRequest.insertDocGenRequests(objectIdSet);
                            ssoObj.regenerate__c = false;
                            //update ssoObj;
                            return new PageReference('/'+RecordID);
                        }
                        catch(Exception Ex)
                        {
                            isapproved = false;
                            checkPoint = true;
                            ApexPages.addMessages(Ex);
                            return null;
                        }
                    }
                    return null;
                }
                return null;
            }
        }
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.HR220_ErrorinDocGeneration));
            Database.rollback(savePointObj);
            isErrorOccured = true;
            System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());
            return null;
        }
    }
}