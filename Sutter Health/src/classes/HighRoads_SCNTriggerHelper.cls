/**
* Class Name  : HighRoads_SCNTriggerHelper
* Description : Helper class for Update SCN trigger.
* 				This helper class is used for auto populate the SCN data from Opportunity whenever its created.
				Used to update the Corresponding opportunity to restrict the user to perform any Plan Selection/Rate Selection as
				Child record is created.
* Created Date: 12/8/2016
* Created By  : IDC Offshore
* Req No 	   : 3980
**/
public class HighRoads_SCNTriggerHelper {
    //to avoid recursion
    public static boolean isSCNBeforeInsert = true;
    public static boolean isSCNAfterInsert = true;
    /**
    * Method Name  : autoPopulateSCNData
    * Description  : Helper method is used to autopopulate the SCN data from corresponding opportunity object.
    * Created Date : 12/8/2016
    * Created By   : IDC Offshore
    * Req No 	   : 3980
    * Parameters   : List<Employer_Group_Data__c> newList
    * Return type  : void
    **/
    public void autoPopulateSCNData(List<Employer_Group_Data__c> newList) {
        Set<ID> oppIds = new Set<ID>();
        Map<ID,Opportunity> opportunityMap = new Map<ID,Opportunity>();
        for(Employer_Group_Data__c scnObj : newList){
            oppIds.add(scnObj.Opportunity__c);
        }
        Group shpSalesQueue = [select Id from Group where Name = :System.Label.HR78_SHP_Sales_Queue and Type = :HighRoads_Constants.QUEUE];
        for(Opportunity oppObj : [SELECT Name,Id,Full_Time_Employees__c,RecordTypeId,Slicing_with_Carrier_Name__c,Account.Tax_ID__c, Employer_Type__c,Account_RecordType_Name__c,Account.Name, Account.ShippingStreet, Account.ShippingState, Account.ShippingPostalCode, 
                                  Account.ShippingCountry, Account.ShippingCity, Account.Phone, Account.Employee_Count__c,Account.SHP_Group_ID__c,
                                  Account.Broker__r.Broker_Firm_HR_ID__c, Account.Broker__c, Account.Broker_Rep__r.Name, Account.Broker_Rep__c, Account.Broker__r.License_Number__c,
                                  Account.Broker__r.End_Date__c, Broker_Rep1__r.License_Number__c, Broker_Rep1__r.License_Expiration_Date__c,
                                  Account.Broker_Rep__r.SFDC_Contact_ID__c, Account.BillingStreet, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry, Account.BillingCity, 
                                  of_Employees__c, Account.Account_TIN_Type__c, StageName, account.fax, Broker_Rep1__r.Name, Broker_Rep1__r.Account.Name, Plan_Effective_Date__c,
                                  Broker_Rep1__r.SFDC_Contact_ID__c, Broker1__r.License_Number__c, Broker1__r.End_Date__c, Renewed_Opportunity__c,AccountId, 
                                  Contribution_s_EE__c, Dependent_Contribution__c, Commission__c, Additional_Buy_Ups__c, Calendar_or_Plan_Year__c, Account.DBA__c,
                                  Account.Account_Manager__r.Name, Account.County__c, Account.Mailing_County__c, Account.Physical_County__c, Account.Account_Executive__r.name  
                                  from Opportunity where id IN:oppIds])
        {
            opportunityMap.put(oppObj.Id, oppObj);
        }
        Map<String,SF_P2A_Market_Segments_Mapping__c> mapping = SF_P2A_Market_Segments_Mapping__c.getAll();
        for(Employer_Group_Data__c scnObj : newList){
            Opportunity oppObj = opportunityMap.get(scnObj.Opportunity__c);
            if(oppObj != NULL){
                scnObj.DBA_Name__c = (scnObj.DBA_Name__c == NULL ? (oppObj.Account.DBA__c != NULL ? oppObj.Account.DBA__c : HighRoads_Constants.NA_VALUE) : scnObj.DBA_Name__c);
                scnObj.Plan_vs_Calendar_Year__c = (scnObj.Plan_vs_Calendar_Year__c == NULL ? oppObj.Calendar_or_Plan_Year__c : scnObj.Plan_vs_Calendar_Year__c);
                if(oppObj.Account_RecordType_Name__c.equalsIgnoreCase(System.Label.HR53_AccountRecordTypeName)){
                    if(oppObj.Employer_Type__c != NULL){
                        String groupType = mapping.get(oppObj.Employer_Type__c).P2A_Market_Segment__c; 
                        scnObj.Group_Type__c = (scnObj.Group_Type__c == NULL ? groupType.subStringBefore(HighRoads_Constants.GROUP_VALUE).trim() : scnObj.Group_Type__c);
                    }
                }else{
                    scnObj.Group_Type__c =  System.Label.HR03_MarketSegment_IND;
                }
                if(oppObj.Renewed_Opportunity__c == true || scnObj.Renewal_SCN__c==TRUE){
                    scnObj.Previous_Group_Insurance_through_SHP__c = true;
                }
                //checking the opportunity value is null or not before populating
                scnObj.opportunity_Account_Name__c = (scnObj.opportunity_Account_Name__c == NULL ? oppObj.AccountId : scnObj.opportunity_Account_Name__c);
                scnObj.of_Eligible_Employees__c = (scnObj.of_Eligible_Employees__c == NULL ? oppObj.Full_Time_Employees__c : scnObj.of_Eligible_Employees__c);
                scnObj.Company_Name__c = (scnObj.Company_Name__c == NULL ? oppObj.Account.Name : scnObj.Company_Name__c);
                scnObj.Street_Address__c = (scnObj.Street_Address__c == NULL ? oppObj.Account.BillingStreet : scnObj.Street_Address__c);
                scnObj.Billing_Street_Address__c = (scnObj.Billing_Street_Address__c == NULL ? oppObj.Account.ShippingStreet : scnObj.Billing_Street_Address__c);
                scnObj.State_SA__c = (scnObj.State_SA__c == NULL ? oppObj.Account.BillingState : scnObj.State_SA__c);
                scnObj.State_BA__c =  (scnObj.State_BA__c == NULL ? oppObj.Account.ShippingState : scnObj.State_BA__c);
                scnObj.Zip_SA__c = (scnObj.Zip_SA__c == NULL ? oppObj.Account.BillingPostalCode : scnObj.Zip_SA__c);
                scnObj.Zip_BA__c = (scnObj.Zip_BA__c == NULL ? oppObj.Account.ShippingPostalCode : scnObj.Zip_BA__c);
                scnObj.City_BA__c = (scnObj.City_BA__c == NULL ? oppObj.Account.ShippingCity : scnObj.City_BA__c);
                scnObj.city_SA__c = (scnObj.city_SA__c == NULL ? oppObj.Account.BillingCity : scnObj.city_SA__c);
                scnObj.Phone_Number__c = (scnObj.Phone_Number__c == NULL ? oppObj.Account.Phone : scnObj.Phone_Number__c);
                scnObj.Effective_Date__c = (scnObj.Effective_Date__c == NULL ? oppObj.Plan_Effective_Date__c : scnObj.Effective_Date__c);
                scnObj.Federal_Employer_ID_Number__c = (scnObj.Federal_Employer_ID_Number__c == NULL ? oppObj.Account.Tax_ID__c : scnObj.Federal_Employer_ID_Number__c);
                scnObj.of_Employees__c = (scnObj.of_Employees__c == NULL ? oppObj.of_Employees__c : scnObj.of_Employees__c);
                scnObj.Broker_Name__c = (scnObj.Broker_Name__c == NULL ? oppObj.Broker_Rep1__r.Name : scnObj.Broker_Name__c);
                scnObj.Broker_Agency__c = (scnObj.Broker_Agency__c == NULL ? oppObj.Broker_Rep1__r.Account.Name : scnObj.Broker_Agency__c); 
                scnObj.SFDC_Broker_ID__c = (scnObj.SFDC_Broker_ID__c == NULL ? oppObj.Broker_Rep1__r.SFDC_Contact_ID__c : scnObj.SFDC_Broker_ID__c); 
                scnObj.ACal_L_D_Licence__c = (scnObj.ACal_L_D_Licence__c == NULL ? oppObj.Broker_Rep1__r.License_Number__c : scnObj.ACal_L_D_Licence__c);
                scnObj.ACal_L_D_Expiration_Date__c = (scnObj.ACal_L_D_Expiration_Date__c == NULL ? oppObj.Broker_Rep1__r.License_Expiration_Date__c : scnObj.ACal_L_D_Expiration_Date__c);
                scnObj.Fax_Number__c = (scnObj.Fax_Number__c == NULL ? oppObj.Account.Fax : scnObj.Fax_Number__c);
                scnObj.Created_By__c = UserInfo.getUserID();
                scnObj.Employer_Contribution_Employees_Premium__c = (scnObj.Employer_Contribution_Employees_Premium__c == NULL ? oppObj.Contribution_s_EE__c : scnObj.Employer_Contribution_Employees_Premium__c);
                scnObj.Employer_Contribution_Dependents_Premium__c = (scnObj.Employer_Contribution_Dependents_Premium__c == NULL ? oppObj.Dependent_Contribution__c : scnObj.Employer_Contribution_Dependents_Premium__c);
                scnObj.Commissions_Medical__c = (scnObj.Commissions_Medical__c == NULL ? oppObj.Commission__c : scnObj.Commissions_Medical__c);
                scnObj.Slicing_with_Carrier_Name__c = (scnObj.Slicing_with_Carrier_Name__c == NULL ? oppObj.Slicing_with_Carrier_Name__c : scnObj.Slicing_with_Carrier_Name__c);
                scnObj.Slice_Account__c = (scnObj.Slice_Account__c == NULL ? oppObj.Additional_Buy_Ups__c : scnObj.Slice_Account__c);
                scnObj.Plan_vs_Calendar_Year__c = (scnObj.Plan_vs_Calendar_Year__c == NULL ? oppObj.Calendar_or_Plan_Year__c : scnObj.Plan_vs_Calendar_Year__c);
                scnObj.SHP_Sales_Representative__c = (scnObj.SHP_Sales_Representative__c == NULL ? oppObj.Account.Account_Manager__r.Name : scnObj.SHP_Sales_Representative__c);
                scnObj.County__c = (scnObj.County__c == NULL ? oppObj.Account.Mailing_County__c : scnObj.County__c);
                scnObj.Shipping_County__c = (scnObj.Shipping_County__c == NULL ? oppObj.Account.Physical_County__c : scnObj.Shipping_County__c);
                scnObj.Account_Executive__c = (scnObj.Account_Executive__c == NULL ? oppObj.Account.Account_Executive__r.name : scnObj.Account_Executive__c);
                scnObj.HR_Account_Number__c = oppObj.Account.SHP_Group_ID__c;
                scnObj.opportunity__c = oppObj.Id;
                scnObj.OwnerId = shpSalesQueue.Id;
                scnObj.Stage__c = System.Label.SCN_Status;
                if(scnObj.Effective_Date__c != NULL){
                    scnObj.Open_Enrollment_Date_From__c = scnObj.Effective_Date__c - 30; 
                    scnObj.Open_Enrollment_Date_To__c = scnObj.Open_Enrollment_Date_From__c + 29;
                }
            }                
        }
    }
    /**
    * Method Name  : updateOpponSCNCreation
    * Description  : Helper method is used to update the corresponding opprotunity whenever scn is created for it.
    * Created Date : 12/8/2016
    * Created By   : IDC Offshore
    * Req No 	   : 3980
    * Parameters   : List<Employer_Group_Data__c> newList
    * Return type  : void
    **/
    public void updateOpponSCNCreation(List<Employer_Group_Data__c> newList){
        Set<Id> scnCreatedOppId = new Set<Id>();
        List<Opportunity> scnCreatedOppList = new List<Opportunity>();
        for(Employer_Group_Data__c scnObj : newList){
            Opportunity opp = new Opportunity(id=scnObj.Opportunity__c);
            opp.Is_Child_Record_Created__c = true;
            scnCreatedOppId.add(opp.id); 
            if(!scnCreatedOppId.contains(opp.id)){
                scnCreatedOppList.add(opp);    
            }
        }
        if(scnCreatedOppList != NULL && !scnCreatedOppList.isEmpty()){
            Update scnCreatedOppList;
        }
    }
    
}