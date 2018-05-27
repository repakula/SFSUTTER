/*************************************************************************************************************
*     Class Name  : SHMMN_OpportunityUpdate                                                                                                                               
*     Author      : IDC Offshore                                                                                                                                            
*     Date        : 14-Apr-2016                                                                                                                                             
*     Project Name: CRM - SFT - Sutter Health                                                                                                                                        
*     Description : Controller class for updating Opportunity after converting it from SHMMN to SHP Sales.   
**************************************************************************************************************/
public without sharing class SHMMN_OpportunityUpdate {
        public Set<String> parentList {get;set;}
        public Opportunity opp {get;set;}
        public Id currentUserId {get;set;}
        public Id currentUserRole {get;set;}
        public User currentUser {get;set;}
        public String rId {get;set;}
        public User shareUser {get;set;}
        public Id shareId {get;set;}
        public List<String> prlist {get;set;}
        public UserRole pr {get;set;}
        public string prid {get;set;}
        public PageReference newPage {get;set;}
        public boolean showPage {get;set;}
        //public static Employer_Activity__c employerAgreement {get;set;}
        public static boolean run = true;
        //public static List<Employer_Activity__c> employerAgreementList {get;set;}
        //public static Map<string, string> employeragreementRecordTypeMap {get;set;}
        public static final String OWNER_MSG = 'Insufficient privileges to perform the action. Please contact owner of record.';
        public static final String ERROR_MSG = 'You cannot update SHP Opportunity.';
        public static final string CLASSIFICATION_MSG = 'Error: Please select the Classification for SHP Service line';
/****************************************************************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                                                                        
    *   @date ........: 14-Apr-2016                                                                                                                                           
    *   @description .: This the constructor method provided by extension controller.                                                                                       
    *   @param........: Standard Controller                                                                                                                                            
    *   @return ......: [NA]                                                                                                                                               
    *************************************************************************************************************************************************************************/
    public SHMMN_OpportunityUpdate(ApexPages.StandardController controller) 
    {
          opp = [Select Id, name, Type, Opportunity_Shared_By__c, Shared_with_SHP__c, Classification__c, Probability, StageName, Account_Manager__c, Purchased__c, Service_Line_Product_Promotion__c, Account_Type__c, RecordType.Name, Owner.Name, Account.Name, SHMMN_Opportunity__c, /*Digital_Campaigns__c,*/ 
          Annual_Revenue__c, /*Strategic_Opportunities__c,*/ Director_of_Opportunity__c, 
          Date_Opportunity_Shared__c,  Opportunity_Creator__c from Opportunity WHERE id =: ApexPages.currentPage().getParameters().get(System.Label.CL_23_SM_ID) limit 1000];
          currentUserId = UserInfo.getUserId();
          currentUserRole = UserInfo.getUserRoleId();
          currentUser = [Select id, profile.name from user where id =: opp.OwnerId limit 1];
          rId=currentUserRole;
          rId= rId.substring(0, 15);
          parentList = new Set<String>();
          if(opp.Shared_with_SHP__c == true)
          {
          shareUser= [select userroleID from user where id =: opp.Opportunity_Shared_By__c limit 100];
          shareId= shareUser.userroleID ;
          getRoles(shareId);
          if(currentUserId == opp.Opportunity_Shared_By__c)
          {
           this.showPage = true;
          }
          else if (parentList.contains(rId))
          {
           this.showPage = true;
          }
          else
          {
            this.showPage = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,OWNER_MSG);
            ApexPages.addMessage(myMsg);
          }
          }
          else if(opp.Shared_with_SHP__c == false && currentUser.Profile.Name.equalsIgnoreCase(System.Label.CL_37_SM_SHPSales))
          {
           this.showPage = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ERROR_MSG);
            ApexPages.addMessage(myMsg);
          }else{}
          
          }
/**************************************************************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                                                                       
    *   @date ........: 14-Apr-2016                                                                                                                                       
    *   @description .: Method to get parent roles of logged in user role.                                                                                               
    *   @param........: Id of role of logged in user.                                                                                                                                   
    *   @return ......: [NA]                                                                                                                                              
    ***********************************************************************************************************************************************************************/   
    public void getRoles(ID ur)
    {
        
        try{
            prlist = new List<String>();
            pr= [ select ParentRoleId from UserRole where Id =: ur limit 100];
            if(pr.ParentRoleId != null)
            {
             prid = pr.ParentRoleId ;
             prid= prid.substring(0, 15);     
             parentList.add(prid);
             getRoles(pr.ParentRoleId);
            }  
        }catch(Exception e){
            
        }  
        
    }
/************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                     
    *   @date ........: 14-Apr-2016                                                                                     
    *   @description .: Method to update opportunity and return opportunity detail page.                                
    *   @param........: [NA]                                                                                               
    *   @return ......: PageReference to opportunity detail page.                                                                                           
    *********************************************************************************************************************/    
   public pagereference Save()
    {
         try{
            
    if( opp.Service_Line_Product_Promotion__c != null)
    {       
     if(opp.Service_Line_Product_Promotion__c.contains(System.Label.CL_77_SM_SHP) && opp.Classification__c != null)
     {  
     update opp;
     newPage = new PageReference (System.Label.CL_32_SM_Slash+opp.id);
     }
     else if(opp.Service_Line_Product_Promotion__c.contains(System.Label.CL_77_SM_SHP) && opp.Classification__c == null)
     {
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,CLASSIFICATION_MSG);
         ApexPages.addMessage(myMsg);
         newPage = null;
     }
    }
     else 
     {
         update opp;
         newPage = new PageReference (System.Label.CL_32_SM_Slash+opp.id);
     }
     return newPage;
     }catch(Exception e){
             return null;
         }
    }
/************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                     
    *   @date ........: 14-Apr-2016                                                                                     
    *   @description .: Method to return opportunity detail page.                                                       
    *   @param........: [NA]                                                                                               
    *   @return ......: PageReference to opportunity detail page.                                                                                             
    *********************************************************************************************************************/  
    public pagereference Cancel()
    {
         
             newPage = new PageReference (System.Label.CL_32_SM_Slash+opp.id);
             return newPage;
         
    }
/*******************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                            
    *   @date ........: 14-Apr-2016                                                                                             
    *   @description .: Method to create Signed Agreement Employer Agreement record on account when opportunity is Closed Won. 
    *   @param........: List of Opportunity                                                                                                           
    *   @return ......: [NA]                                                                                                   
    ****************************************************************************************************************************-/     
  public static void createSignedAgreement( List <Opportunity> newOpportunityList) 
  {
    try{
        employeragreementRecordTypeMap = new Map<string, string>();
        employerAgreement = new Employer_Activity__c ();
        employerAgreementList = new List<Employer_Activity__c>();
        set<Id> accids = new Set<id>();
        Map<Id,Date> accountmap = new Map<Id,Date>();
        for(RecordType rec:[select Id , name from RecordType where sObjectType =: System.Label.CL_38_SM_EmployerActivity limit 1000] )
        {
              employeragreementRecordTypeMap.put(rec.Name, rec.Id);
        }  
        for(Opportunity opp : newOpportunityList)
        {
            accids.add(opp.AccountId);
        }
    
        for(Account acc: [SELECT id,Employer_First_Renewal_Date__c from Account where id in : accids limit 1000])
        {
            accountmap.put(acc.id,acc.Employer_First_Renewal_Date__c);
        }
        for(Opportunity opp : newOpportunityList)
           {
              if(opp.AccountId != null) 
              {
                 employerAgreement.Account_Name__c=opp.AccountId;
              }
              if(opp.Full_Time_Employees__c != null)
              {
                 employerAgreement.No_of_Employees__c = opp.Full_Time_Employees__c;  
              }
              if(opp.Plan_Effective_Date__c != null)
              {
                 employerAgreement.Plan_Effective_Date__c = opp.Plan_Effective_Date__c; 
              }
              if(opp.Plan_end_date__c != null)
              {
                 employerAgreement.Agreement_End_Date__c = opp.Plan_end_date__c; 
              }
              if(opp.Service_Line_Product_Promotion__c != null)
              {
                 employerAgreement.Service_Line_Product_Promotion__c = opp.Service_Line_Product_Promotion__c;
              }
              if(accountmap.get(opp.AccountId) != null)
              {
                employerAgreement.First_Renewal_Date__c = accountmap.get(opp.AccountId);
              }
              
              employerAgreement.RecordTypeId= employeragreementRecordTypeMap.get(System.Label.CL_39_SM_SignedAgreement);              
              employerAgreement.Start_Date__c= system.today();          
              employerAgreement.Status__c= System.Label.CL_78_SM_Completed;
              employerAgreement.Assigned_To__c = opp.OwnerId;
              employerAgreement.Due_Date__c = opp.CloseDate;
              employerAgreement.Completed_Date__c = System.today();           
              employerAgreement.Date_Sold__c = System.today();            
              employerAgreementList.add(employerAgreement);
              
             
           }     
          insert employerAgreementList;
          run =false;
     }catch(Exception e){
         
     }
  } */
}