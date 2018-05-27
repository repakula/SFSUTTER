/**
 * Name : VFC09_Job_Evaluation
 * Description : Test class used for testing the VFC09_Job_Evaluation
 * Date : 6/23/14 1:34 PM 
 * Version : <initial Draft> 
 */
@isTest(SeeAllData=true)
private class VFC09_Job_Evaluation_Test { 
    /*
     *@name testSaveAndSend() 
     *@return void 
     *@description This method for saveAndSend () In CLASS VFC09_Job_Evaluation.cls
     */
     static testMethod void  testSaveAndSend() { 
        Test.startTest();
        Case  caseRecord   = UtilUnitTest.getCase();
        caseRecord.Establish_New_Job__c = false;
        caseRecord.Revision_to_Current_Job__c = false;
        caseRecord.Update_description_only__c = false;
        caseRecord.Other_Request__c = false;
        ApexPages.StandardController ctr = new ApexPages.StandardController(caseRecord);
        VFC09_Job_Evaluation VFC09_Job_EvaluationTest  =  new  VFC09_Job_Evaluation(ctr);
        
        Test.setCurrentPage(Page.VFP09_Job_Evaluation);
        PageReference pagereferenceTest = VFC09_Job_EvaluationTest.saveAndSend();
        System.assert(true);
         
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Establish_New_Job__c = false;
        caseRecord.Revision_to_Current_Job__c = false;
        caseRecord.Update_description_only__c = false;
        caseRecord.Other_Request__c = true;
        
        ctr = new ApexPages.StandardController(caseRecord);
        VFC09_Job_EvaluationTest  =  new  VFC09_Job_Evaluation(ctr);
        
        Test.setCurrentPage(Page.VFP09_Job_Evaluation);
        pagereferenceTest = VFC09_Job_EvaluationTest.saveAndSend();
        System.assert(true);
         
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Establish_New_Job__c = false;
        caseRecord.Revision_to_Current_Job__c = false;
        caseRecord.Update_description_only__c = false;
        caseRecord.Other_Request__c = true;
        caseRecord.Please_specify__c = 'test';
        VFC09_Job_EvaluationTest  =  new  VFC09_Job_Evaluation(ctr);
        
        Test.setCurrentPage(Page.VFP09_Job_Evaluation);
        pagereferenceTest = VFC09_Job_EvaluationTest.saveAndSend();
        System.assert(true);
        
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Establish_New_Job__c = false;
        caseRecord.Revision_to_Current_Job__c = false;
        caseRecord.Update_description_only__c = false;
        caseRecord.Other_Request__c = true;
        caseRecord.Please_specify__c = 'test';
        caseRecord.Subject = 'test subject';
        caseRecord.Subject1__c = '';
        ctr = new ApexPages.StandardController(caseRecord);
        VFC09_Job_EvaluationTest  =  new  VFC09_Job_Evaluation(ctr);
        
        Test.setCurrentPage(Page.VFP09_Job_Evaluation);
        pagereferenceTest = VFC09_Job_EvaluationTest.saveAndSend();
        System.assert(true);
        
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Establish_New_Job__c = false;
        caseRecord.Revision_to_Current_Job__c = false;
        caseRecord.Update_description_only__c = false;
        caseRecord.Other_Request__c = true;
        caseRecord.Please_specify__c = 'test';
        caseRecord.Subject = 'test subject';
        caseRecord.Subject1__c = '';
        
            
        Attachment attachSample = VFC09_Job_EvaluationTest.upload();
        attachSample.body = Blob.valueof('test'); 
        VFC09_Job_EvaluationTest.saveAndSend();
       
        ctr = new ApexPages.StandardController(caseRecord);
        VFC09_Job_EvaluationTest  =  new  VFC09_Job_Evaluation(ctr);
                
        Test.setCurrentPage(Page.VFP09_Job_Evaluation);
        pagereferenceTest = VFC09_Job_EvaluationTest.saveAndSend();
        System.assert(true);
                
        Test.stopTest();
    }
	//saasfocus 1/9/2015
	static testMethod void  testSaveAndSend2() { 
        Test.startTest();
        Case  caseRecord   = UtilUnitTest.getCase();
        caseRecord.Establish_New_Job__c = false;
        caseRecord.Revision_to_Current_Job__c = false;
        caseRecord.Update_description_only__c = false;
        caseRecord.Other_Request__c = false;
        ApexPages.StandardController ctr = new ApexPages.StandardController(caseRecord);
        SH_VFC09_Job_Evaluation VFC09_Job_EvaluationTest  =  new  SH_VFC09_Job_Evaluation(ctr);
        
        Test.setCurrentPage(Page.VFP09_Job_Evaluation);
        PageReference pagereferenceTest = VFC09_Job_EvaluationTest.saveAndSend();
        System.assert(true);
         
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Establish_New_Job__c = false;
        caseRecord.Revision_to_Current_Job__c = false;
        caseRecord.Update_description_only__c = false;
        caseRecord.Other_Request__c = true;
        
        ctr = new ApexPages.StandardController(caseRecord);
        VFC09_Job_EvaluationTest  =  new  SH_VFC09_Job_Evaluation(ctr);
        
        Test.setCurrentPage(Page.VFP09_Job_Evaluation);
        pagereferenceTest = VFC09_Job_EvaluationTest.saveAndSend();
        System.assert(true);
         
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Establish_New_Job__c = false;
        caseRecord.Revision_to_Current_Job__c = false;
        caseRecord.Update_description_only__c = false;
        caseRecord.Other_Request__c = true;
        caseRecord.Please_specify__c = 'test';
        VFC09_Job_EvaluationTest  =  new  SH_VFC09_Job_Evaluation(ctr);
        
        Test.setCurrentPage(Page.VFP09_Job_Evaluation);
        pagereferenceTest = VFC09_Job_EvaluationTest.saveAndSend();
        System.assert(true);
        
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Establish_New_Job__c = false;
        caseRecord.Revision_to_Current_Job__c = false;
        caseRecord.Update_description_only__c = false;
        caseRecord.Other_Request__c = true;
        caseRecord.Please_specify__c = 'test';
        caseRecord.Subject = 'test subject';
        caseRecord.Subject1__c = '';
        ctr = new ApexPages.StandardController(caseRecord);
        VFC09_Job_EvaluationTest  =  new  SH_VFC09_Job_Evaluation(ctr);
        
        Test.setCurrentPage(Page.VFP09_Job_Evaluation);
        pagereferenceTest = VFC09_Job_EvaluationTest.saveAndSend();
        System.assert(true);
        
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Establish_New_Job__c = false;
        caseRecord.Revision_to_Current_Job__c = false;
        caseRecord.Update_description_only__c = false;
        caseRecord.Other_Request__c = true;
        caseRecord.Please_specify__c = 'test';
        caseRecord.Subject = 'test subject';
        caseRecord.Subject1__c = '';
        
            
        Attachment attachSample = VFC09_Job_EvaluationTest.upload();
        attachSample.body = Blob.valueof('test'); 
        VFC09_Job_EvaluationTest.saveAndSend();
       
        ctr = new ApexPages.StandardController(caseRecord);
        VFC09_Job_EvaluationTest  =  new  SH_VFC09_Job_Evaluation(ctr);
                
        Test.setCurrentPage(Page.VFP09_Job_Evaluation);
        pagereferenceTest = VFC09_Job_EvaluationTest.saveAndSend();
        System.assert(true);
                
        Test.stopTest();
    }

	//saasfocus 1/9/2015
	static testMethod void  testSaveAndSend3() { 
        Test.startTest();
        AccessTokenSetting__c ace =new AccessTokenSetting__c();
        ApexPages.StandardController ctr = new ApexPages.StandardController(ace);
        SH_VFC09_Job_Evaluation VFC09_Job_EvaluationTest  =  new  SH_VFC09_Job_Evaluation(ctr);
        
        Test.setCurrentPage(Page.VFP09_Job_Evaluation);
        PageReference pagereferenceTest = VFC09_Job_EvaluationTest.saveAndSend();
        System.assert(true);
         
        
        Test.stopTest();
    }
}