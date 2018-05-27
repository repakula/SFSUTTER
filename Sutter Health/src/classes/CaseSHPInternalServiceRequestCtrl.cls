public class CaseSHPInternalServiceRequestCtrl {

   
    
     /*variable declaration*/
   private string recordType;
   
    /*Parameterised constructor*/
    public CaseSHPInternalServiceRequestCtrl(ApexPages.StandardController controller) {
        /*variable initialisation*/        
        recordType = ApexPages.currentPage().getParameters().get('RecordType');      
   
    }

    /*action method to redirect the page*/
    public pageReference redirectPage()
    {    
   
       RecordType r= [select Id , name from RecordType where sObjectType = 'Case' and recordType.Name='SHP Internal Service Request'];
       Pagereference  pageRef = new Pagereference('/500/e?RecordType='+r.id+'&=Caentse');
       
        return pageRef;
    }     
}