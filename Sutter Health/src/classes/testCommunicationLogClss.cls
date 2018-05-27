public class testCommunicationLogClss
{

   
   public Communication_Log__c commlog{get;set;}
   public Communication_Log__c commlogtest{get;set;} 
    
    public testCommunicationLogClss()
    {
    commlog = new Communication_Log__c(); 
    }
    
    
    

      public void addFieldValues()
      {
       
     
       insert commlog;
         
              
      }
}