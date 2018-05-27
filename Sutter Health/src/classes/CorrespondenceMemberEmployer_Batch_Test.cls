/**    
 *     Class Name  : CorrespondenceMemberEmployer_Batch_Test
 *     Author      : IDC Offshore  
 *     Date        : 03-Nov-2015  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : Test Class for CorrespondenceMemberEmployer Batch.
 **/
@isTest
private class CorrespondenceMemberEmployer_Batch_Test {
    public static String PARENTCORRESPONDENCETYPE = 'SHP Employer Member';
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    public static testMethod void testBatchOpportunity(){
        Correspondence_Letter__c testCorrespondence = new Correspondence_Letter__c
                                        (RecordTypeId = Schema.SObjectType.Correspondence_Letter__c.RecordTypeInfosByName.get(PARENTCORRESPONDENCETYPE).RecordTypeId,
                                          SHP_OnBaseID__c ='123456',
                                          SHP_Correspondence_ID__c= '123456',
                                          SHP_Parent_Correspondence_ID__C = '123456'
                                         );
                                           Database.insert(testCorrespondence);
                                            List<Correspondence_Letter__c> corrlistInsert = new List<Correspondence_Letter__c>();
                                            for(integer i = 0; i<200 ;i++)
                                            {
                                                Correspondence_Letter__c testCorrespondence1 = new Correspondence_Letter__c( SHP_OnBaseID__c ='123'+i, SHP_Entity_Type__c ='member', SHP_Parent_Correspondence_ID__C ='123456');
                                                corrlistInsert.add(testCorrespondence1);
                                            }
                                            Database.insert(corrlistInsert);
                                            test.starttest();
                                            String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,new CorrespondenceMemberEmployerScheduler ());

                                            Test.stopTest();
                                            List<Correspondence_Letter__c >  corrList= new List<Correspondence_Letter__c >();
                                            corrList = [select id from  Correspondence_Letter__c where  SHP_Entity_Type__c ='member'];
                                            System.assertEquals(corrList.size(),200);

                                        }

}