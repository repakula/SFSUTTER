/**    
 *     Class Name  : SelectLatestOpportunity
 *     Author      : IDC Offshore  
 *     Date        : 10-Jul-2015  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : This class is a helper class for the setting the latest Updated and Inserted Opportunity 
                     boolean true on Opportunity Record for reporting purpose.
 **/
public class SelectLatestOpportunity {
/**
    * @author IDC Team
    * @date 10/07/2015
    * @description -- This method is used to Mark the checkbox Latest Updated Opportunity of Account 
                      so that it can be selected for the Reporting Purpose.
    * @Requirement : Req-3392 Sales Report
    */
   public static void selectLatestUpdatedOpportunity( List <Opportunity> newOpportunityList) {
       
       
        if( checkRecursive.runOnce() ) {
            Set <Id> AccountIdList = new Set<Id>();
            Set <Id> AccountIdSet = new Set <Id>();
            List <Opportunity> opportunityToupdate = new List<Opportunity>();
            
        /**
        *@Description: For loop to collect Corresponding AccountId of Opportunities in List.
        **/
            for( Opportunity opnew: newOpportunityList ) {
                if( opnew.AccountId != null ) {
                    AccountIdList.add( opnew.AccountId );
                }
            }
        /**
        *@Description: Select the Latest Updatet Opportunity for Particular Account and set its boolean true.
        **/            
            if(!(AccountIdList.isEmpty())) {
                for( Account acnt:[ SELECT Id,Broker__c,Broker_Rep__c , (SELECT Id,Name, Plan_end_date__c,OverrideBrokerAndBrokerRep__c,Broker1__c,Broker_Rep1__c ,Latest_Opportunity__c,Plan_Effective_Date__c , LastModifiedDate From Opportunities ORDER BY Plan_Effective_Date__c DESC NULLS LAST,Plan_end_date__c DESC NULLS LAST, LastModifiedDate DESC NULLS LAST Limit 1 ) FROM Account WHERE ID IN :AccountIdList]) {
                    if( acnt.Opportunities != null && !(acnt.Opportunities.isEmpty())) {
                        if( acnt.Opportunities[0].Latest_Opportunity__c == false ) {
                            acnt.Opportunities[0].Latest_Opportunity__c = true;
                            opportunityToupdate.add(acnt.Opportunities[0]);
                            AccountIdSet.add(acnt.Id);
                        }
                    }
                }
            }
            
        /**
        *@Description: Set the Previous Updated Opportunitie's boolean to false.
        **/         
            if(!(AccountIdSet.isEmpty())) {
                for(Opportunity oppy: [ SELECT Id,Latest_Opportunity__c FROM Opportunity WHERE AccountId IN :AccountIdSet AND Latest_Opportunity__c = true ]) {
                        oppy.Latest_Opportunity__c = false;
                        opportunityToupdate.add(oppy);
                    }
                }
                    
            if(!(opportunityToupdate.isEmpty())) {
                try {
                    system.debug('@@@Opportunity'+opportunityToupdate);
                    update opportunityToupdate;
                } Catch ( Exception ex ) {
                    Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                }
            }
        }
    }
}