/**  
*    Batch Class Name: CaseSHPRecordTypeSelectionCtrl
*    Author: IDC
*    Date: 07-Oct-2014
*    Description: This is the controller class to redirect users to appropriate case creation page
**/
public class CaseSHPRecordTypeSelectionCtrl{

   /*variable declaration*/
   private string recordType;
   
/*Parameterised constructor*/
public CaseSHPRecordTypeSelectionCtrl(ApexPages.StandardController controller) {
        /*variable initialisation*/
        
        recordType = ApexPages.currentPage().getParameters().get('RecordType');
       
   
    }

/*action method to redirect the page*/
    public pageReference redirectPage()
    {
        /*variable declaration*/
        
       Pagereference pageRef;
       
       pageRef = new Pagereference('/setup/ui/recordtypeselect.jsp?ent=Case&save_new_url=500/e');
       
      
       
       /*return page reference*/
        return pageRef;
         
    }    
}