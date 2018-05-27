/*************************************************************************************************************
*     Class Name  : SHMMN_AccountRemovedManage                                                                                                                               
*     Author      : IDC Offshore                                                                                                                                            
*     Date        : 03-May-2016                                                                                                                                             
*     Project Name: CRM - SFT - Sutter Health                                                                                                                                        
*     Description : Controller class for managing SHMMN Employer Account Status.   
**************************************************************************************************************/
public class SHMMN_AccountRemovedManage {

 public Account acc{get; set;}
 public Boolean showpage{get;set;}
 public String statusOverride {get;set;}
 public static final String ACCESS_MSG = 'Only SHMMN Manager will have Acceess on the Button'; 
 public static final string EXCEPTION_MSG = 'Status cannot be  updated.';
 /****************************************************************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                                                                        
    *   @date ........: 03-May-2016                                                                                                                                           
    *   @description .: This the constructor method provided by extension controller.                                                                                       
    *   @param........: Standard Controller                                                                                                                                            
    *   @return ......: [NA]                                                                                                                                               
    *************************************************************************************************************************************************************************/
    public SHMMN_AccountRemovedManage(ApexPages.StandardController controller) {
    
            this.acc=(Account)controller.getRecord();
            acc= [SELECT id, name,phone,Status__c,NumberOfEmployees,Employer_Type__c,Employer_First_Active_Date__c,Description,Status_Override_Comment__c  FROM Account WHERE id =: ApexPages.currentPage().getParameters().get(System.Label.SHP_RFP_74) limit 1];
         }

/**************************************************************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                                                                       
    *   @date ........: 03-May-2016                                                                                                                                       
    *   @description .: Method to update Account Status from Removed to other value.                                                                                               
    *   @param........: [NA]                                                                                                                                   
    *   @return ......: Page Reference to Account detail page.                                                                                                                              
    ***********************************************************************************************************************************************************************/    
     public PageReference updateStatus()
    {
        try{
            if(statusOverride != null){
                if(acc.Status_Override_Comment__c != null)
                {
                    acc.Status_Override_Comment__c= '[' + date.today().format() + ']'+ ': ' + statusOverride + '\n' +acc.Status_Override_Comment__c;
                }
                else
                {
                    acc.Status_Override_Comment__c= '[' + date.today().format() + ']'+ ': ' + statusOverride;
                }    
            }
            if(acc!= null && acc.status__c != null  )
             {
                update acc;
             }
           }
        catch(Exception ex)
          {
            ApexPages.addMessages(ex);  
          }
        PageReference nextpage = new PageReference(System.Label.CL_32_SM_Slash+ acc.id );
        return nextpage ;
    }
/**************************************************************************************************************************************************************************
    *   @author ......: IDC Offshore                                                                                                                                       
    *   @date ........: 03-May-2016                                                                                                                                       
    *   @description .: Method to check for role of logged in user updating account status and to check if there are open opportunities on account.                                  
    *   @param........: [NA]                                                                                                                                   
    *   @return ......: [NA]                                                                                                                              
    ***********************************************************************************************************************************************************************/    
    public void CheckStatus()
    {
        UserRole usrRole = [select name from UserRole where id = : UserInfo.getUserRoleId() limit 1];

        if(usrRole.Name != System.Label.CL_81_SM_SHMMNManager)
        {
            showpage = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ACCESS_MSG);
            ApexPages.addMessage(myMsg);
        }
        else
         {
             showpage = false;
         }        
    }
}