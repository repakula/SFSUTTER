/**  
 *     Class Name  : SendManagerFeedbackEmailTest
 *     Author      : IDC Offshore
 *     Date        : 08-Aug-2014
 *     Project Name: CRM - SFT - Sutter Health
 *     Description : Test Class for SendManagerFeedbackEmail Class. This class tests sending email to managers feedback record owners scenario.
**/
@isTest
private class SendManagerFeedbackEmailTest
{ 
    /**        
     * @author IDC Team        
     * @date 10/Oct/2015       
     * @description: method to create test data used by all tests       
     * @return void        
     */
    @testsetup
    Static void createtestData()
    {
        Account acc= new Account(name='TestAccount');
        insert acc;
        //Assert to check if account record has been created successfully 
        system.assert(acc.id != null);
        
        Contact con= new Contact(lastname='TestContact', AccountId=acc.id);
        insert con;
        //Assert to check if contact record has been created successfully 
        system.assert(con.id != null);
        
        list<Managers_Feedback__c> lstManagersFeed = new list<Managers_Feedback__c>();
        for(Integer i=0;i<10;i++){
        Managers_Feedback__c feedbackRec = new Managers_Feedback__c();
        feedbackRec.Service_Area__c = 'Hiring';
        feedbackRec.Subject__c = 'Test';
        feedbackRec.WorkEmail__c = 'xyz123abc@fakeemailsacd.com';
        feedbackRec.Comments__c = 'Test';
        feedbackRec.Status__c = 'New'; 
        feedbackRec.ConatctID__c =String.valueOf(con.id);
        lstManagersFeed.add(feedbackRec);
        }
        insert lstManagersFeed; 
        //Assert to check if manager feedback record has been created successfully 
        system.assert(lstManagersFeed[5].id != null);
    }
    
    /**             
    * @author IDC Team             
    * @date 08/Aug/2014            
    * @description: To validate Send Email to Managers feedback record's owner at Managers feedback record creation time for single record.
    * @return void             
    */
    private testMethod static void testSendEmail(){
        Managers_Feedback__c feedbackRec = [Select id,Subject__c,name,Status__c,InternalURL__c,Comments__c,ConatctID__c,WorkEmail__c,Job_Title__c,Affiliate__c from Managers_Feedback__c where WorkEmail__c = 'xyz123abc@fakeemailsacd.com' limit 1];
        //Assert to check if manager feedback record has been fetched successfully 
        system.assert(feedbackRec .id != null);
        System.assertEquals(feedbackRec.Status__c, 'New');
        List<Managers_Feedback__c > listRecords = new List<Managers_Feedback__c>();
        listRecords.add(feedbackRec);
        Map<Id,Id> feedbackUserIdMap = new Map<ID,Id>(); 
        feedbackUserIdMap.put(feedbackRec.id, UserInfo.getUserId()); 
        
        Test.startTest();
        
        SendManagerFeedbackEmail sendmailObj = new SendManagerFeedbackEmail(); 
        sendmailObj.sendMail(listRecords , feedbackUserIdMap); 
        
        Test.stopTest();
    }
    
    /**             
    * @author IDC Team             
    * @date 08/Aug/2014            
    * @description: To cover exception catch block on send Email to To validate Send Email to Managers feedback record's owner at Managers feedback record creation time for single record.          
    * @return void             
    */
    private testMethod static void testBulkSendEmail(){
        list<Managers_Feedback__c> listRecords = [Select id,Status__c from Managers_Feedback__c where WorkEmail__c = 'xyz123abc@fakeemailsacd.com'];
        //Assert to check if manager feedback record has been fetched successfully 
        system.assert(listRecords[0] .id != null);
        System.assertEquals(listRecords[0].Status__c, 'New');

        Map<Id,Id> feedbackUserIdMap = new Map<ID,Id>();
        for(Managers_Feedback__c feedbackRec : listRecords){
        feedbackUserIdMap.put(feedbackRec.id, UserInfo.getUserId()); 
        }
        Test.startTest();
        try{
        SendManagerFeedbackEmail sendmailObj = new SendManagerFeedbackEmail(); 
        sendmailObj.sendMail(listRecords , feedbackUserIdMap); 
        }
        catch(exception ex){
            //Assert to check exception 
            system.assert(ex.getMessage() != null);
        }
        
        Test.stopTest();
    }
    
    /**             
    * @author IDC Team             
    * @date 08/Aug/2014            
    * @description: To validate Send Email to Managers feedback record's owner at Managers feedback record creation time for bulk records.           
    * @return void             
    */
    private testMethod static void testExceptionSendEmail(){
        Managers_Feedback__c feedbackRec = [Select id,Subject__c,name,Status__c,InternalURL__c,Comments__c,ConatctID__c,WorkEmail__c,Job_Title__c,Affiliate__c from Managers_Feedback__c where WorkEmail__c = 'xyz123abc@fakeemailsacd.com' limit 1];
        //Assert to check if manager feedback record has been fetched successfully 
        system.assert(feedbackRec .id != null);
        System.assertEquals(feedbackRec.Status__c, 'New');
        List<Managers_Feedback__c > listRecords = new List<Managers_Feedback__c>();
        listRecords.add(feedbackRec);
        Map<Id,Id> feedbackUserIdMap = new Map<ID,Id>(); 
        feedbackUserIdMap.put(feedbackRec.id, UserInfo.getUserId()); 
        
        Test.startTest();
        
        SendManagerFeedbackEmail sendmailObj = new SendManagerFeedbackEmail(); 
        sendmailObj.sendMail(listRecords , feedbackUserIdMap); 
        
        Test.stopTest();
    }
}