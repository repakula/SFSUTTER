/**  
*     Class Name  : CaseFieldSetController
*     Author      : IDC Offshore
*     Date        : 9-Sep-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : Case Field Set Controller
**/

/* Class for Case Field Set Controller */
public class CaseFieldSetController 
{
    public String queryString{get;set;}     
    public List<Case> caseList{get;set;}     
    public Case objCase{get;set;} 
    public string custId {get;set;}
    public boolean Flag {get;set;}
    private ApexPages.StandardController controller {get; set;}
  
    /* Class for Case Field Set Controller Standard Controller */
    public CaseFieldSetController(ApexPages.StandardController controller) 
    {
        
        system.debug('<<----'+ custId );
        this.controller = controller;
        Flag=False;
        
        this.objCase = (Case)controller.getRecord();
        custId = objCase.id;
        
        queryString = 'select id,Section_View__c';       
        


        for(Schema.FieldSetMember fld :SObjectType.Case.FieldSets.Kronos_Request_Form_KFS.getFields()) 
        {          
            queryString += System.Label.Comma + fld.getFieldPath();         
        } 

        for(Schema.FieldSetMember fld :SObjectType.Case.FieldSets.Kronos_Request_Form_TAN.getFields()) 
        {          
            queryString += System.Label.Comma + fld.getFieldPath();         
        } 

 

         queryString += ' FROM Case where ID = \''+ custId +'\''; 
         system.debug('<<<----'+  queryString );             
         caselist = Database.query(queryString);     

       if (caselist[0].Section_View__c.equals(System.Label.Agent_View_Kronos) 
           || caselist[0].Section_View__c.equals(System.Label.Portal_View)) 
           {
          
               Flag=true;
               system.debug('<<<----'+  Flag); 
            
            
      
        }

        else {Flag=false;} 
     }  
     
     /* Class for PageReference and Method saveAndSend */
      public PageReference saveAndSend() 
     {
        if( objCase.OwnerId !=UserInfo.getUserId())
     {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.Case_Owner_User_Id_Error));
     
     }
     else
     {
     try
     {   
         upsert objCase;
       
        PageReference pageRef = new PageReference('/apex/VFP23_KronosDetail?id='+objCase.id);

        
        pageRef.setRedirect(true);
        return pageRef;
                   
       }
                    
       catch(Exception classException)
         {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
         }
         }
         return null;             
    }
}