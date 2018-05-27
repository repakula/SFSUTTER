/**  
*     Class Name  : BatchProviderClasses_Test
*     Author      : IDC Offshore
*     Date        : 16-April-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description : This test class is for REQ- 3399. It firstly creates Contacts of Provider recordtype and then schedules the batch classes for TeleForm and non Teleform.
                     
**/


   @isTest
    class BatchProviderClasses_Test{

    /** Setting the CRON Expression for both User Create and User Update for Provider RecordType and Source of email as TLFM **/
    
    public static String CRON_EXP2 = '0 0 0 16 3 ? 2022';
    
    
    static testmethod void testTeleFormBatch() {
    
    
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    String jobIdUserUpdate = System.schedule('ScheduleApexClassTestUserupdate',CRON_EXP2,new BatchPasswordresetTeleFormScheduler()); 
     
    // Assert to check   BatchPasswordresetTeleFormScheduler is scheduled 
    system.assert(jobIdUserUpdate!=null);
    
    
    }
    
    static testmethod void testNonTeleFormBatch() {
    
    
    
    String jobIdUserUpdate = System.schedule('ScheduleApexClassTestUserupdate',CRON_EXP2,new BatchPasswordresetnonTeleFormScheduler());  
      // Assert to check     BatchPasswordresetnonTeleFormScheduler is scheduled 
    system.assert(jobIdUserUpdate!=null);
    
    }
    
    }