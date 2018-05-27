/*************************************************************************************************************
*     Class Name  : SHMMN_SHMMNIncumebnt                                                                                                                               
*     Author      : IDC Offshore                                                                                                                                            
*     Date        : 21-Apr-2016                                                                                                                                             
*     Project Name: CRM - SFT - Sutter Health                                                                                                                                        
*     Description : Controller class for creating incumbent carrier on SHMMN Employer Account.   
**************************************************************************************************************/
public without sharing class SHMMN_SHMMNIncumebnt {
    
    public Account shmmnAccount{get;set;}
    public SHMMN_Incumbent_Carrier__c extcont;
    public Integer incumbentCount =3;
    public List<incumbentWrapper> incumbentList {get;set;}
    public List<SHMMN_Incumbent_Carrier__c > incumbentInsertList {get;set;}
    public PageReference newPage {get;set;}
    public List<SHMMN_Incumbent_Carrier__c> incumbentCreatedList {get;set;}
    public boolean showMsg {get;set;}   
    public static final string SUBPROD_MSG = 'Sub-Product is mandatory if Incumbent Carrier is selected.';  
    /****************************************************************************************************************************************************************************
*   @author ......: IDC Offshore                                                                                                                                        
*   @date ........: 21-Apr-2016                                                                                                                                           
*   @description .: This the constructor method provided by extension controller.                                                                                       
*   @param........: Standard Controller                                                                                                                                            
*   @return ......: [NA]                                                                                                                                               
*************************************************************************************************************************************************************************/
    public SHMMN_SHMMNIncumebnt(ApexPages.StandardController stdController) 
    {
        this.extcont= (SHMMN_Incumbent_Carrier__c )stdController.getRecord();
        incumbentInsertList = new List<SHMMN_Incumbent_Carrier__c >();
        incumbentCreatedList = new List<SHMMN_Incumbent_Carrier__c >();
        
        shmmnAccount=[SELECT Id,Name, Employer_Type__c, Status__c, NumberOfEmployees from account where id =: extcont.Account__c limit 1];
        incumbentCreatedList = [SELECT ID, Name, Incumbent_Carrier__c, Sub_Product__c, Contain__c from SHMMN_Incumbent_Carrier__c where Account__c =: shmmnAccount.id limit 50000];
        incumbentList = new List<incumbentWrapper>();
        if(incumbentCreatedList.size() >0)
        {
            for(SHMMN_Incumbent_Carrier__c sic: incumbentCreatedList)
            {
                incumbentWrapper incwrap = new incumbentWrapper( shmmnAccount, sic);
                incumbentList.add(incwrap );       
            }
        }
        else  {
            for(integer k =0; k <incumbentCount ; k++)
            {
                incumbentWrapper incwrap = new incumbentWrapper( shmmnAccount);
                incumbentList.add(incwrap );       
            }
        }
    }
    /****************************************************************************************************************************************************************************
*   @author ......: IDC Offshore                                                                                                                                        
*   @date ........: 21-Apr-2016                                                                                                                                           
*   @description .: Method to decrease list of incumbent carrier.                                                                                       
*   @param........: [NA]                                                                                                                                            
*   @return ......: [NA]                                                                                                                                               
*************************************************************************************************************************************************************************/
    public Void decreaseList()
    {
        
            Integer incumbentSize = incumbentList.size();
            if(incumbentCreatedList.size() >0 && incumbentSize > incumbentCreatedList.size())
            {
                incumbentList.remove(incumbentSize-1);
            }
            else if(incumbentSize>1 && incumbentCreatedList.size() == 0)
                incumbentList.remove(incumbentSize-1);
        
    }
    /****************************************************************************************************************************************************************************
*   @author ......: IDC Offshore                                                                                                                                        
*   @date ........: 21-Apr-2016                                                                                                                                           
*   @description .: Method to increase list of incumbent carrier.                                                                                       
*   @param........: [NA]                                                                                                                                            
*   @return ......: [NA]                                                                                                                                               
*************************************************************************************************************************************************************************/    
    public Void increaseList()
    {
        
            incumbentWrapper incwrap = new incumbentWrapper( shmmnAccount);
            incumbentList.add(incwrap ); 
        
    }
    /****************************************************************************************************************************************************************************
*   @author ......: IDC Offshore                                                                                                                                        
*   @date ........: 21-Apr-2016                                                                                                                                           
*   @description .: Method to save the list of incumbent carrier.                                                                                       
*   @param........: [NA]                                                                                                                                            
*   @return ......: PageReference to return to account detail page.                                                                                                              
*************************************************************************************************************************************************************************/ 
    public PageReference saveIncumbentCarriers() {
        try{
            incumbentInsertList.clear();
            Decimal sum=0;
            Map<String,String> mergeIncumbent = new Map<String, String>();
            for(incumbentWrapper ins: incumbentList)
            {
                if(ins.obj.Incumbent_Carrier__c != null )
                {
                incumbentInsertList.add(ins.obj);
                }
                else if (ins.obj.id != null)
                incumbentInsertList.add(ins.obj);
                if(ins.obj.Contain__c != null)
                sum= sum + ins.obj.Contain__c;
                if(ins.obj.Incumbent_Carrier__c != null)
                {
                if(ins.obj.Sub_Product__c != null)
                {
                String dupCheck = ins.obj.Incumbent_Carrier__c + ins.obj.Sub_Product__c;
                mergeIncumbent.put(dupCheck, System.Label.CL_79_SM_DupCheck);
                showMsg = true;
                }
                else if (ins.obj.Sub_Product__c == null)
                {
                 showMsg = false;   
                }
                }
            }
            
            if(mergeIncumbent.size() != incumbentInsertList.size())
            {
                if(showMsg == false)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,SUBPROD_MSG);
                ApexPages.addMessage(myMsg);
            }
                if(showMsg == true)
                {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.CL_74_SM_IncumbentDupErrorMsg);
                ApexPages.addMessage(myMsg);
                newPage = null;
                }
            }
            else if(sum > 100.00)
            { 
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.CL_68_SM_Morethan100);
                ApexPages.addMessage(myMsg);
                newPage = null;
                
            }   
            else if(sum <= 100.00)
            {
                upsert incumbentInsertList;
                newPage = new PageReference (System.Label.CL_32_SM_Slash + shmmnAccount.id);
            }
            return newPage ;
        }catch(Exception e){
            
            ApexPages.addMessages(e);
            return null;
        }
    }
    /****************************************************************************************************************************************************************************
*   @author ......: IDC Offshore                                                                                                                                        
*   @date ........: 21-Apr-2016                                                                                                                                           
*   @description .: Wrapper class for SHMMN Incumbent Carrier                                                                                       
*   @param........: [NA]                                                                                                                                            
*   @return ......: [NA]                                                                                                             
*************************************************************************************************************************************************************************/     
    public class incumbentWrapper
    {
        public SHMMN_Incumbent_Carrier__c obj{get;set;}
        
        public incumbentWrapper(Account acc )
        {
            obj= new SHMMN_Incumbent_Carrier__c ();
            obj.Account__c=acc.id;
        }
        public incumbentWrapper(Account acc, SHMMN_Incumbent_Carrier__c sic )
        {
            obj= sic;
            obj.Account__c=acc.id;
        }
        
    }
}