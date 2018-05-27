/*************************************************************************************************************
*     Class Name  : SHMMN_AcceptOpportunity                                                                                                                               
*     Author      : IDC Offshore                                                                                                                                            
*     Date        : 14-Apr-2016                                                                                                                                             
*     Project Name: CRM - SFT - Sutter Health                                                                                                                                        
*     Description : Controller class for accepting opportunity after converting it from SHMMN to SHP Sales.   
**************************************************************************************************************/
public without sharing class SHMMN_AcceptOpportunity 
{
  private ApexPages.StandardSetController standardController;
  public List<Opportunity> oppList{get;set;}
  public Set<Id> oppIds = new Set<Id>();
  public Set<Id> oppOwnerIds = new Set<Id>();
  public PageReference newPage {get;set;}
  public List<Opportunity> oppSucessList{get;set;}
  public List<Opportunity> oppErrorList{get;set;}
  public boolean showpage {get;set;}
  public String pname {get;set;}
  public boolean showAccept {get;set;}
  public boolean showError {get;set;}
  public Id currentUserId {get;set;}
  public User currentUser {get;set;}
  public Map<Id, User>  userMap {get;set;}
  public static final string SHP_PROFILE_MSG = 'Only SHP Sales Team can accept this shared opportunity.';
  public static final string SHMMN_PROFILE_MSG = 'Only SHMMN Team can accept this shared opportunity.';
  public static final string OPP_MSG = 'This opportunity is not shared yet.';
  public static final string ACCEPT_MSG = 'You have already accepted this opportunity.';
  public static final string ERROR_MSG = 'Opportunity is already accepted by another user.';
  public static final string SHPOPP_MSG = 'This is SHP opportunity. You cannot accept this.';
  public static final string SHMMNOPP_MSG = 'This is SHMMN opportunity. You cannot accept this.';
  public static final string SHP_PROFILE = 'SHP Sales';
  public static final string SHMMN_PROFILE = 'SHMMN';
  public static final string OPP_PAGE = '/006';
  
/****************************************************************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                                                                        
    *   @date ........: 14-Apr-2016                                                                                                                                           
    *   @description .: This the constructor method provided by extension controller.                                                                                       
    *   @param........: Standard Controller                                                                                                                                            
    *   @return ......: [NA]                                                                                                                                               
    *************************************************************************************************************************************************************************/
 public SHMMN_AcceptOpportunity (ApexPages.StandardSetController standardController)
 {
   this.standardController = standardController;
   oppList= new List<Opportunity>();
   for (Opportunity opp: [SELECT id,ownerId from opportunity where id IN: standardController.getSelected() ])
    { 
      oppIds.add(opp.Id);
      oppOwnerIds.add(opp.ownerId);
    }
    oppList= [SELECT Name, RecordType.Name, ownerID,Shared_with_SHP__c,Shared_with_SHMMN__c,Accepted__c, Error_Reason__c  FROM Opportunity WHERE ID IN: oppIds limit 50000];
    this.showAccept = false;
    this.showError = false;
    pname = [Select Name from Profile where Id =: UserInfo.getProfileId() limit 1].name;
    if (pname.equals(SHP_PROFILE) || pname.contains(SHMMN_PROFILE))
    {
         this.showpage = true;
      }
      else
      {
        this.showpage = false;
      }
 }
/**************************************************************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                                                                       
    *   @date ........: 14-Apr-2016                                                                                                                                       
    *   @description .: Method to update owner of converted opportunity when accept butotn is clicked by SHP User.                                                            
    *   @param........: [NA]                                                                                                                                                   
    *   @return ......: [NA]                                                                                                                                              
    ***********************************************************************************************************************************************************************/ 
 public PageReference updateOwner()
 {
     try{
         oppSucessList= new List<opportunity>();
         oppErrorList= new List<opportunity>();
         currentUserId = UserInfo.getUserId();   
         userMap = new Map<Id, User>();
            
         for(User objUse:[Select Id, profile.Name from user where IsActive = true and ID IN: oppOwnerIds limit 50000]){
                 userMap.put(objUse.Id,objUse);
         }
         if (!oppList.isEmpty())
         {
         for(Opportunity opp : oppList)
         {
             currentUser = userMap.get(opp.ownerId);
             
             if(opp.RecordType.Name == 'SHP Sales Opportunity')
             {
             
             if(opp.Shared_with_SHP__c == true && opp.Accepted__c== false && pname.equals(SHP_PROFILE) )
             {
                opp.ownerid= UserInfo.getUserId();
                opp.Accepted__c= true;
                oppSucessList.add(opp);
             }
             else 
             {   
             if(opp.Shared_with_SHP__c == true && opp.Accepted__c== true && pname.contains(SHMMN_PROFILE))
             {
                 opp.Error_Reason__c = SHP_PROFILE_MSG;
                 oppErrorList.add(opp);
                 
             }
             if(opp.Shared_with_SHP__c == false && opp.Accepted__c== true && pname.contains(SHMMN_PROFILE))
             {
                 opp.Error_Reason__c = OPP_MSG;
                 oppErrorList.add(opp);
                 
             }
             if(opp.Shared_with_SHP__c == true && opp.Accepted__c== false && pname.contains(SHMMN_PROFILE))
             {
                 opp.Error_Reason__c = SHP_PROFILE_MSG;
                 oppErrorList.add(opp);
                 
             }
             if(opp.Shared_with_SHP__c == false && opp.Accepted__c== false && pname.contains(SHMMN_PROFILE))
             {
                 opp.Error_Reason__c = OPP_MSG;
                 oppErrorList.add(opp);
                 
             }
             if(opp.Shared_with_SHP__c == true && opp.Accepted__c== true && opp.OwnerId == currentUserId && pname.equals(SHP_PROFILE))
             {
                 opp.Error_Reason__c = ACCEPT_MSG;
                 oppErrorList.add(opp);
             }
             else if(opp.Shared_with_SHP__c == true && opp.Accepted__c== true && pname.equals(SHP_PROFILE))
             {
                 opp.Error_Reason__c = ERROR_MSG;
                 oppErrorList.add(opp);
                 
             }
             
             if(opp.Shared_with_SHP__c == false && opp.Accepted__c== true && pname.equals(SHP_PROFILE))
             {
                 opp.Error_Reason__c = OPP_MSG;
                 oppErrorList.add(opp);
                 
             }
             if(opp.Shared_with_SHP__c == false && opp.Accepted__c== false && pname.equals(SHP_PROFILE) && (currentUser.profile.name == SHP_PROFILE))
             {
                 opp.Error_Reason__c = SHPOPP_MSG;
                 oppErrorList.add(opp);
                 
             }  
             else if(opp.Shared_with_SHP__c == false && opp.Accepted__c== false && pname.equals(SHP_PROFILE))
             {
                 opp.Error_Reason__c = OPP_MSG;
                 oppErrorList.add(opp);
                 
             }
             }
             }
              else if(opp.RecordType.Name == 'SHMMN Opportunity')
              
              {
                      
                      
                       if(opp.Shared_with_SHMMN__c == true && opp.Accepted__c== false && pname.contains(SHMMN_PROFILE) )
                     {
                        
                        opp.ownerid= UserInfo.getUserId();
                        opp.Accepted__c= true;
                        oppSucessList.add(opp);
                     }
                     else 
                     {   
                     if(opp.Shared_with_SHMMN__c == true && opp.Accepted__c== true && pname.equals(SHP_PROFILE))
                     {
                         opp.Error_Reason__c = SHMMN_PROFILE_MSG;
                         oppErrorList.add(opp);
                         
                     }
                     if(opp.Shared_with_SHMMN__c == false && opp.Accepted__c== true && pname.equals(SHP_PROFILE))
                     {
                         opp.Error_Reason__c = OPP_MSG;
                         oppErrorList.add(opp);
                         
                     }
                     if(opp.Shared_with_SHMMN__c == true && opp.Accepted__c== false && pname.equals(SHP_PROFILE))
                     {
                         opp.Error_Reason__c = SHMMN_PROFILE_MSG;
                         oppErrorList.add(opp);
                         
                     }
                     if(opp.Shared_with_SHMMN__c == false && opp.Accepted__c== false && pname.equals(SHP_PROFILE))
                     {
                         opp.Error_Reason__c = OPP_MSG;
                         oppErrorList.add(opp);
                         
                     }
                     if(opp.Shared_with_SHMMN__c == true && opp.Accepted__c== true && opp.OwnerId == currentUserId && pname.contains(SHMMN_PROFILE))
                     {
                         opp.Error_Reason__c = ACCEPT_MSG;
                         oppErrorList.add(opp);
                     }
                     else if(opp.Shared_with_SHMMN__c == true && opp.Accepted__c== true && pname.contains(SHMMN_PROFILE))
                     {
                         opp.Error_Reason__c = ERROR_MSG;
                         oppErrorList.add(opp);
                         
                     }
                     
                     if(opp.Shared_with_SHMMN__c == false && opp.Accepted__c== true && pname.contains(SHMMN_PROFILE))
                     {
                         opp.Error_Reason__c = OPP_MSG;
                         oppErrorList.add(opp);
                         
                     }
                     if(opp.Shared_with_SHMMN__c == false && opp.Accepted__c== false && pname.contains(SHMMN_PROFILE) && (currentUser.profile.name.contains(SHMMN_PROFILE)))
                     {
                         opp.Error_Reason__c = SHMMNOPP_MSG;
                         oppErrorList.add(opp);
                         
                     }  
                     else if(opp.Shared_with_SHMMN__c == false && opp.Accepted__c== false && pname.contains(SHMMN_PROFILE))
                     {
                         opp.Error_Reason__c = OPP_MSG;
                         oppErrorList.add(opp);
                         
                     }
                   }
 
            }        

        }
         }
         if(oppSucessList.size() > 0) 
         {
             showAccept = true;
             update oppSucessList;
         }
         else if (oppSucessList.size() == 0)
         {
            showAccept = false;
         }
         
         if(oppErrorList.size() > 0) 
         {
         showError = true;
         
         }
         else if(oppErrorList.size() == 0)
         {       
         showError = false;
         }
         
         return null;
     }catch(Exception e){
         ApexPages.addMessages(e);
         return null;
     }
 }
/**************************************************************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                                                                       
    *   @date ........: 14-Apr-2016                                                                                                                                       
    *   @description .: Method to redirect to list view page (opportunity home page) on click of Back to Opportunity button.                                                            
    *   @param........: [NA]                                                                                                                                                   
    *   @return ......:  PageReference to return opportunity home page.                                                                                                                
    ***********************************************************************************************************************************************************************/ 
 public PageReference Cancel()
    {
      newpage = new PageReference(OPP_PAGE);
      return newpage;       
    } 

}