public class CaseInternalServiceRequestCtrl {

   
    
     /*variable declaration*/
   private string recordType;
   
/*Parameterised constructor*/
public CaseInternalServiceRequestCtrl(ApexPages.StandardController controller) {
        /*variable initialisation*/
        
        recordType = ApexPages.currentPage().getParameters().get('RecordType');
       
   
    }

/*action method to redirect the page*/
    public pageReference redirectPage()
    {
        /*variable declaration*/
        
       Pagereference pageRef;
       
       pageRef = new Pagereference('/500/e?RecordType=012G0000001BGfl&=Caentse');
       
      
       
       /*return page reference*/
        return pageRef;
         
    }  
    

}