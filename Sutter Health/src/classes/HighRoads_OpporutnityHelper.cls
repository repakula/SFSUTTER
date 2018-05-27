/**
* Class Name  : HighRoads_OpporutnityHelper
* Description : Helper class for After Update context for Update Broker trigger.
*                This helper class is used to check any SCN are in rejected status or not.
*                If user tries to re open the opportunity it will check for the existing SCNs whether they are in rejected status or not.
* Created Date: 12/8/2016
* Created By  : IDC Offshore
* Req No       : 3980
*  Version       Author             Date            Description
*   1.0         Deloitte          09-03-2017      SHP30 - Added the Latest_Opportunity__c to the query and a check to ensure the opportunity is updated correctly
*   2.0         Deloitte          06-04-2017      SHP33 - Modifed the if condition in oder not to create documnet generation for Individual account
															when opportunity stage is closed own
**/
public class HighRoads_OpporutnityHelper {
    //to avoid recursion
    public static boolean isOpportunityAfterUpdate = true;
    /**
    * Method Name  : updateOpportunity
    * Description  : Helper method for After Update context for Update Broker trigger.
    *                This helper class is used to check any SCN are in rejected status or not.
    *                If user tries to re open the opportunity it will check for the existing SCNs whether they are in rejected status or not.
    *                If it is a Small Group Account opportunity and it is closed won, then creating a new SCN.
    *                If it is a Small Group Account Opportunity, creating a Document Generation Request for that Account.
    * Created Date : 12/8/2016
    * Created By   : IDC Offshore
    * Req No       : 3980
    * Parameters   : Map<ID,Opportunity> newMap,Map<ID,Opportunity> oldMap
    * Return type  : void
    **/
    public void updateOpportunity(Map<ID,Opportunity> newMap,Map<ID,Opportunity> oldMap){
        Id shpSalesRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(System.label.HR144_SHPSalesOpportunity).getRecordTypeId();
        Set<ID> shpSalesOppIds = new Set<ID>();//Store Opportuity ID's for Which Document Generation Request need to be created
        Map<String,SF_P2A_Market_Segments_Mapping__c> groups = SF_P2A_Market_Segments_Mapping__c.getAll();
        HR_Individual_Document_Generation__c indDocGenCSObj = HR_Individual_Document_Generation__c.getInstance(System.label.HR175_IndividualAccount);
        List<Employer_Group_Data__c> newSCNList = new List<Employer_Group_Data__c>();
        List<Document_Generation_Request__c> updateDocGenList = new List<Document_Generation_Request__c>();
        List<FeedItem> insertPostList = new List<FeedItem>();
        List<CollaborationGroup> chatterGroup = [SELECT Id FROM CollaborationGroup WHERE Name =: System.label.HR179_SHPBPAGroup LIMIT 1];
        Boolean isErrorThrown = false;
        Group shpSalesQueue = [select Id from Group where Name = :System.Label.HR78_SHP_Sales_Queue and Type = :HighRoads_Constants.QUEUE];
        Map<String,Employer_Group_Data__c> oppSCNMap = new Map<String,Employer_Group_Data__c>();
       
   //   SHP-30 Change
        Map<String,Opportunity> opportunityMap = new Map<String,Opportunity>([SELECT Name,Id,Latest_Opportunity__c,Full_Time_Employees__c,RecordTypeId,Slicing_with_Carrier_Name__c,Account.Tax_ID__c, Employer_Type__c,Account_RecordType_Name__c,Account.Name, Account.ShippingStreet, Account.ShippingState, Account.ShippingPostalCode, 
                                                                              Account.ShippingCountry, Account.ShippingCity, Account.Phone, Account.Employee_Count__c,
                                                                              Account.Broker__r.Broker_Firm_HR_ID__c, Account.Broker__c, Account.Broker_Rep__r.Name, Account.Broker_Rep__c, Account.Broker__r.License_Number__c,
                                                                              Account.Broker__r.End_Date__c, Broker_Rep1__r.License_Number__c, Broker_Rep1__r.License_Expiration_Date__c,
                                                                              Account.Broker_Rep__r.SFDC_Contact_ID__c, Account.BillingStreet, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry, Account.BillingCity, 
                                                                              of_Employees__c, Account.Account_TIN_Type__c, StageName, account.fax, Broker_Rep1__r.Name, Broker_Rep1__r.Account.Name, Plan_Effective_Date__c,
                                                                              Broker_Rep1__r.SFDC_Contact_ID__c, Broker1__r.License_Number__c, Broker1__r.End_Date__c, Renewed_Opportunity__c,AccountId, 
                                                                              Contribution_s_EE__c, Dependent_Contribution__c, Commission__c, Additional_Buy_Ups__c, Calendar_or_Plan_Year__c, Account.DBA__c,
                                                                              Account.Account_Manager__r.Name, Account.County__c, Account.Mailing_County__c, Account.Physical_County__c, Account.Account_Executive__r.name,
                                                                              (select id,name,Plans__c,Request_Status__c FROM Document_Generation_Requests__r Where Request_Status__c !=: System.label.HR140_Approved order by createddate desc limit 1),
                                                                              (select id,name,Raider_ID__c,Raider_ID__r.Name,Benefit_Plan_Metadata__r.Name,Raider_ID__r.Unique_ID__c, Benefit_Plan_Metadata__r.Unique_ID__c FROM Benefit_Plan_Associations__r),
                                                                              (select id,Stage__c from Sold_Case_Notification__r where Stage__c NOT IN (:System.label.HR180_Rejected,:System.label.HR218_RejectedByUnderwriting,:System.Label.HR217_EnrollmentQAFail))
                                                                              From Opportunity where ID IN: newMap.keySet()]);
        /* Check if plans exists for the opportunity before closed won for small group account */
        Map<String,SF_P2A_Market_Segments_Mapping__c> marketSegment = SF_P2A_Market_Segments_Mapping__c.getAll();
        
        for(Opportunity opp : opportunityMap.values()){ 
            
            /*Throw error when Opportunity Stage is changed from Closed Won and related SCN is not in a Rejected status*/
            if(opportunityMap.get(opp.Id).StageName != oldMap.get(opp.Id).StageName && oldMap.get(opp.Id).StageName == System.label.HR79_ClosedWon && 
               opportunityMap.get(opp.Id).Sold_Case_Notification__r != NULL && opportunityMap.get(opp.Id).Sold_Case_Notification__r.size() > 0 && opportunityMap.get(opp.Id).RecordTypeId == shpSalesRecTypeId){
                   newMap.get(opp.Id).addError(System.label.HR181_OppStageChangeError);
                   return; 
               }
            /*Throw error when Opportunity Stage is changed to Closed won and No Plans are Associated*/
            //   SHP-30 Change
            if(opp.Employer_Type__c != NULL && marketSegment.get(opp.Employer_Type__c) != NULL && marketSegment.get(opp.Employer_Type__c).P2A_Market_Segment__c.equalsIgnoreCase(System.Label.HR01_MarketSegment_SG)
               && (opportunityMap.get(opp.Id).Benefit_Plan_Associations__r == NULL || opportunityMap.get(opp.Id).Benefit_Plan_Associations__r.size() == 0 ) && opp.StageName == System.label.HR79_ClosedWon && opportunityMap.get(opp.Id).RecordTypeId == shpSalesRecTypeId
               )
               {
                   newMap.get(opp.Id).addError(System.label.HR182_AddPlansBeforeClosedWon);
                   return;
             }
             
            Set<String> oldPlanNames = new Set<String>();//Store Benefit Plans names stored in Plans Field of Old Document Generation Request
            Set<String> newPlanNames = new Set<String>();//Store related Benefit Plan names in Current Opportunity
            boolean isOldNewNotSame = false;// Variable indicating Plan Selection Change 
            SF_P2A_Market_Segments_Mapping__c grp = groups.get(opp.Employer_Type__c);
            
            /*check if SHP Sales Opportunity Stage is changed to Closed Won*/
            
            
            if(opp.RecordTypeId == shpSalesRecTypeId && oldMap.get(opp.id).StageName != newMap.get(opp.id).StageName &&
               opp.StageName.equalsIgnoreCase(System.Label.HR79_ClosedWon)){
                   /* check if related Account is Small Group or Individual Business and Document_Generation_Required__c field is check in Custom Setting */
                   //@SHP33 Modifed if condition
                   if((grp != NULL && System.label.HR01_MarketSegment_SG.equalsIgnoreCase(grp.P2A_Market_Segment__c))){
                          /*Check if there are already Document Generation Requests related to Opportunity*/
                          if(opp.Document_Generation_Requests__r != NULL && opp.Document_Generation_Requests__r.size() > 0){
                              /*Verify if Plan Selection is Changed for Opporutnity*/
                              for(Benefit_Plan_Association__c bpaObj : opp.Benefit_Plan_Associations__r){
                                  if(bpaObj.Raider_ID__c != NULL){
                                      newPlanNames.add(bpaObj.Raider_ID__r.Unique_ID__c+'-'+bpaObj.Benefit_Plan_Metadata__r.Unique_ID__c);
                                  }else{
                                      newPlanNames.add(bpaObj.Benefit_Plan_Metadata__r.Unique_ID__c);
                                  }    
                              }
                              for(Document_Generation_Request__c docGenObj : opp.Document_Generation_Requests__r){
                                  if(docGenObj.Plans__c != NULL){
                                      String[] oldPlanList = docGenObj.Plans__c.split(',');
                                      oldPlanNames.addAll(oldPlanList);
                                  }
                                  for(String newplan : newPlanNames){
                                      if(!oldPlanNames.contains(newplan)){
                                          isOldNewNotSame = true;
                                          break;
                                      }     
                                  }
                                  if(!isOldNewNotSame){
                                      for(String oldplan : oldPlanNames){
                                          if(!newPlanNames.contains(oldplan)){
                                              isOldNewNotSame = true;
                                              break;
                                          }
                                      }
                                  }
                                  /*If Plan Selection is changed, Post to SHP BPA Chatter Group and add Opportunity Id to Set*/
                                  if(isOldNewNotSame){
                                      FeedItem post = new FeedItem();
                                      if(chatterGroup != NULL && !chatterGroup.isEmpty()){
                                          post.ParentId = chatterGroup[0].Id;
                                          post.Body = System.label.HR177_ChatterGroupPost1 + opp.name + System.label.HR178_ChatterGroupPost2;      
                                          shpSalesOppIds.add(opp.id);    
                                          insertPostList.add(post);
                                      }
                                  }
                              }
                          }
                          /*add Opportunity Id to Set if there are no Document Generation Requests related to Opportunity*/
                          else{
                              shpSalesOppIds.add(opp.id); 
                          }  
                      }
                   /*Check if related Account is of Employer Type Small Group*/
                   if(grp != NULL && System.label.HR01_MarketSegment_SG.equalsIgnoreCase(grp.P2A_Market_Segment__c)){
                       /*Create new SCN with owner Set to SHP Sales Queue and map the fields in SCN with Fields in Opportuity*/
                       Employer_Group_Data__c newSCN = new Employer_Group_Data__c();
                       newSCN.Opportunity_Account_Name__c = opp.AccountId;
                       newSCN.of_Eligible_Employees__c = opp.Full_Time_Employees__c;
                       newSCN.Company_Name__c = opp.Account.Name;
                       newSCN.Street_Address__c = opp.Account.BillingStreet;
                       newSCN.Billing_Street_Address__c = opp.Account.ShippingStreet;
                       newSCN.State_SA__c = opp.Account.BillingState;
                       newSCN.State_BA__c =  opp.Account.ShippingState;
                       newSCN.Zip_SA__c = opp.Account.BillingPostalCode;
                       newSCN.Zip_BA__c = opp.Account.ShippingPostalCode;
                       newSCN.City_BA__c = opp.Account.ShippingCity;
                       newSCN.city_SA__c = opp.Account.BillingCity;
                       newSCN.Phone_Number__c = opp.Account.Phone;
                       newSCN.Effective_Date__c = opp.Plan_Effective_Date__c;
                       newSCN.Federal_Employer_ID_Number__c = opp.Account.Tax_ID__c;
                       newSCN.of_Employees__c = opp.of_Employees__c;
                       newSCN.Broker_Name__c = opp.Broker_Rep1__r.Name;
                       newSCN.Broker_Agency__c = opp.Broker_Rep1__r.Account.Name; 
                       newSCN.SFDC_Broker_ID__c = opp.Broker_Rep1__r.SFDC_Contact_ID__c; 
                       newSCN.ACal_L_D_Licence__c = opp.Broker_Rep1__r.License_Number__c;
                       newSCN.ACal_L_D_Expiration_Date__c = opp.Broker_Rep1__r.License_Expiration_Date__c;
                       newSCN.Fax_Number__c = opp.Account.Fax;
                       newSCN.Created_By__c = UserInfo.getUserID();
                       newSCN.Employer_Contribution_Employees_Premium__c = opp.Contribution_s_EE__c;
                       newSCN.Employer_Contribution_Dependents_Premium__c = opp.Dependent_Contribution__c;
                       newSCN.Commissions_Medical__c = opp.Commission__c;
                       newSCN.Slicing_with_Carrier_Name__c = opp.Slicing_with_Carrier_Name__c;
                       newSCN.Slice_Account__c = opp.Additional_Buy_Ups__c;
                       newSCN.Plan_vs_Calendar_Year__c = opp.Calendar_or_Plan_Year__c;
                       newSCN.DBA_Name__c = opp.Account.DBA__c;
                       newSCN.SHP_Sales_Representative__c = opp.Account.Account_Manager__r.Name;
                       newSCN.County__c = opp.Account.Mailing_County__c;
                       newSCN.Shipping_County__c = opp.Account.Physical_County__c;
                       newSCN.Account_Executive__c = opp.Account.Account_Executive__r.name;
                       newSCN.Opportunity__c = opp.Id;
                       newSCN.OwnerId = shpSalesQueue.Id;
                       newSCN.Stage__c = System.Label.SCN_Status;
                       oppSCNMap.put(opp.Id,newSCN);
                       
                   }
               }
        }
        
        /*Create New SCN with fields in it auto-populated*/
        if(oppSCNMap != NULL && !oppSCNMap.isEmpty() && HighRoads_DocGenRequest.isOppClosedWon){
            Insert oppSCNMap.values();
            HighRoads_DocGenRequest.isOppClosedWon = false;
        }
        /*Create new Document Generation Request for the Opportunity Ids in the Set*/
        if(HighRoads_DocGenRequest.isOpportunityAfterUpdate && !shpSalesOppIds.isEmpty()){
            HighRoads_DocGenRequest.insertDocGenRequestsOpp(shpSalesOppIds);
            HighRoads_DocGenRequest.isOpportunityAfterUpdate = false;
        }
        /*Post to the Chatter Group about creation of new Document Generation Request due to Plan Selection Change*/
        if(insertPostList !=NULL && !insertPostList.isEmpty()){
            insert insertPostList;
        }
    }
}