/*************************************************************************************************************
*     Class Name  : SHMMN_ShareOpportunity                                                                                                                               
*     Author      : IDC Offshore                                                                                                                                            
*     Date        : 11-Apr-2016                                                                                                                                             
*     Project Name: CRM - SFT - Sutter Health                                                                                                                                        
*     Description : Controller class for accepting opportunity after converting it from SHMMN to SHP Sales.   
**************************************************************************************************************/
public without sharing class SHMMN_ShareOpportunity 
{
    public Opportunity newOpp {get;set;}
    
    public PageReference newPage {get;set;}
    public boolean showpage {get;set;}
    public PageReference pg {get;set;}
    public Id currentUser {get;set;}
    public string userProfile {get;set;}
    public static final String OWNER_MSG = 'Insufficient privileges to perform the action. Please contact owner of record.';
    public static final String STATUS_MSG = 'You cannot share Closed Won opportunities with SHP.';
/****************************************************************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                                                                        
    *   @date ........: 14-Apr-2016                                                                                                                                           
    *   @description .: This the constructor method provided by extension controller.                                                                                       
    *   @param........: Standard Controller                                                                                                                                            
    *   @return ......: [NA]                                                                                                                                               
    *************************************************************************************************************************************************************************/
    public SHMMN_ShareOpportunity(ApexPages.StandardController controller) 
    {
       this.newOpp=(Opportunity)controller.getRecord();
       newOpp = [Select Id, Owner.Name,  RecordTypeId,Shared_with_SHP__c, StageName from Opportunity WHERE id =: ApexPages.currentPage().getParameters().get('OpportunityId') limit 1];
       currentUser = UserInfo.getUserId();
       userProfile = ApexPages.currentPage().getParameters().get('user');
    }
/****************************************************************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                                                                        
    *   @date ........: 14-Apr-2016                                                                                                                                           
    *   @description .: Method to convert record type of SHMMN Opportunity to SHP Sales.                                                                                       
    *   @param........: [NA]                                                                                                                                           
    *   @return ......: PageReference to opportunity detail page.                                                                                                                     
    *************************************************************************************************************************************************************************/    
    public PageReference shareOpp()
    {     
      
      try{
          if(currentUser != newOpp.OwnerId)
           {
                this.showpage = false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,OWNER_MSG);
                ApexPages.addMessage(myMsg);
           }
           else if (currentUser == newOpp.OwnerId)
           {
               if(newOpp.StageName != System.Label.CL_35_SM_ClosedWon)
               {
                   this.showpage = true;
                   if(userProfile.contains('SHMMN')){
                       
                       newOpp.RecordTypeid= Schema.SObjectType.Opportunity.RecordTypeInfosByName.get(System.Label.CL_36_SM_SHP_Sales_Opportunity).RecordTypeId;
                       newOpp.Shared_with_SHP__c=true;
                       newOpp.Shared_with_SHMMN__c=false;
                   }
                   else if(userProfile.contains('SHP')){
                       
                       newOpp.RecordTypeid= Schema.SObjectType.Opportunity.RecordTypeInfosByName.get(System.Label.CL_91_SHMMN_Opportunity).RecordTypeId;
                       newOpp.Shared_with_SHMMN__c=true;
                       newOpp.Shared_with_SHP__c=false;
                   }
                   newOpp.Date_Opportunity_Shared__c = system.now();
                   newOpp.Opportunity_Creator__c = newOpp.Owner.Name;
                   newOpp.Opportunity_Shared_By__c = newOpp.OwnerId;
                   
                   update newOpp;
                   
                   pg= new PageReference(System.Label.CL_32_SM_Slash+ newOpp.id );
                   return pg;
               }
               else if (newOpp.StageName.equalsIgnoreCase(System.Label.CL_35_SM_ClosedWon))
               {
                   this.showpage = false;
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,STATUS_MSG);
                   ApexPages.addMessage(myMsg);                   
               }
           }
            return null;
        }
        catch(Exception e)
            {
               return null;
            }      
    }
/****************************************************************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                                                                        
    *   @date ........: 14-Apr-2016                                                                                                                                           
    *   @description .: Method to redirect to opportunity detail page.                                                                                       
    *   @param........: [NA]                                                                                                                                           
    *   @return ......: PageReference to opportunity detail page.                                                                                                                     
    *************************************************************************************************************************************************************************/  
    public PageReference cancel()
    {
              newpage = new PageReference(System.Label.CL_32_SM_Slash+ newOpp.id );
              return newpage;   
    }
}