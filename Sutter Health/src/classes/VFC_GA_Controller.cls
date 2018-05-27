/**  
*     Class Name: VFC_GA_Controller
*     Author: Atul Gupta
*     Date: 17-April-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description: The controller class gets the User Contact's Employee Region and Affiliate Fields
*
**/
public with sharing class VFC_GA_Controller {
    
    public String currentUserId;
    public String currentUserName{get;set;}
    public String empRegion{get;set;}
    public String empAffiliate{get;set;}
    
    /**
    * @author Atul Gupta
    * @date 17/04/2014
    * @description Constructor of the class. Queries User Name, Contact Region and Affiliate data in String Variables
    * @param 
    * @return 
    */
    public VFC_GA_Controller()
    {
        try
        {
            currentUserId = UserInfo.getUserId();
            system.debug('@@currentUserId : '+ currentUserId );
            User userRecordNew = [SELECT Name FROM User where id =: currentUserId];
            system.debug('@@userRecordNew : '+ userRecordNew);
            User userRecord = [SELECT Name, Contact.Employee_Affiliate_Facility__c, Contact.Employee_Region__c FROM User where id =: currentUserId];
            system.debug('@@userRecord : '+ userRecord);
            if(userRecord <> null)
            {
                currentUserName = userRecord.Name;
                empRegion = userRecord.Contact.Employee_Region__c;
                empAffiliate = userRecord.Contact.Employee_Affiliate_Facility__c;
            }
         }
         catch(Exception classException)
         {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
             Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
         }
         
    }
}