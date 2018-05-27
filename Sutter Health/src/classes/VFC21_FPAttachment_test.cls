/**
 * Name : VFC21_FPAttachment_test
 * Description : Test class used for testing the VFC21_FPAttachment_test
 * Date : 9/17/14 1:34 PM 
 * Version : <initial Draft> 
 */
@isTest
private class VFC21_FPAttachment_test { 
    /*
     *@name testSaveAndSend() 
     *@return void 
     *@description This method for saveAndSend () In CLASS VFC21_FPAttachment
     */
     static testMethod void  testSaveAndSend() { 
        Test.startTest();
        Case  caseRecord   = UtilUnitTest.getCase();
        // Assert to check case is created succesfully
        system.assertnotequals(caseRecord,null);
        caseRecord.Requestor_Name_Attachment__c = 'Test';
        caseRecord.Affiliate__c = 'Test';
        caseRecord.Pay_Period_Date__c = System.Today();
        caseRecord.Employee__c = 'test';
        ApexPages.StandardController ctr = new ApexPages.StandardController(caseRecord);
        VFC21_FPAttachment VFC21_FPAttachmentPage  =  new  VFC21_FPAttachment(ctr);
        
        Test.setCurrentPage(Page.VFP21_FPAttachment);
        PageReference pagereferenceTest1 = VFC21_FPAttachmentPage.saveAndSend();

        Attachment attachSample = VFC21_FPAttachmentPage.upload();
        attachSample.body = Blob.valueof('test'); 
        VFC21_FPAttachmentPage.saveAndSend();
        
        
        //System.assert(true);
         
         
         /*
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
              */  
        Test.stopTest();
    }


    //SAASFOCUS
    static testMethod void  testSaveAndSend2() { 
        Test.startTest();
        Case  caseRecord   = UtilUnitTest.getCase();
        // Assert to check case is created succesfully
        system.assertnotequals(caseRecord,null);
        caseRecord.Requestor_Name_Attachment__c = 'Test';
        caseRecord.Affiliate__c = 'Test';
        caseRecord.Pay_Period_Date__c = System.Today();
        caseRecord.Employee__c = 'test';
        caseRecord.Internal_Comments__c='test';
        ApexPages.StandardController ctr = new ApexPages.StandardController(caseRecord);
        SH_VFC21_FPAttachment VFC21_FPAttachmentPage  =  new  SH_VFC21_FPAttachment(ctr);
        
        Test.setCurrentPage(Page.VFP21_FPAttachment);
        PageReference pagereferenceTest1 = VFC21_FPAttachmentPage.saveAndSend();

        Attachment attachSample = VFC21_FPAttachmentPage.upload();
        attachSample.body = Blob.valueof('test'); 
        VFC21_FPAttachmentPage.saveAndSend();
        
        
        //System.assert(true);
         
         
         /*
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
              */  
        Test.stopTest();
    }

    //SAASFOCUS
    static testMethod void  testSaveAndSend3() { 
        Test.startTest();
        
        Case  caseRecord =new Case();
        /*
        caseRecord.Requestor_Name_Attachment__c = 'Test';
        caseRecord.Affiliate__c = 'Test';
        caseRecord.Pay_Period_Date__c = System.Today();
        caseRecord.Employee__c = 'test';
        caseRecord.Internal_Comments__c='test';
        */
        ApexPages.StandardController ctr = new ApexPages.StandardController(caseRecord);
        SH_VFC21_FPAttachment VFC21_FPAttachmentPage  =  new  SH_VFC21_FPAttachment(ctr);
        VFC21_FPAttachmentPage.noteValue='test';
        Test.setCurrentPage(Page.VFP21_FPAttachment);
        PageReference pagereferenceTest1 = VFC21_FPAttachmentPage.saveAndSend();

        Attachment attachSample = VFC21_FPAttachmentPage.upload();
        attachSample.body = Blob.valueof('test'); 
        VFC21_FPAttachmentPage.saveAndSend();
        VFC21_FPAttachmentPage.AffiliateFacility();
        // Assert to check attachment 
        system.assertnotequals(VFC21_FPAttachmentPage,null);

        
        
        //System.assert(true);
         
         
         /*
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
              */  
        Test.stopTest();
    }

}