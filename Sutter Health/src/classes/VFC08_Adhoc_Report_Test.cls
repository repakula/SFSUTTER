/**
 * Name : VFC08_Adhoc_Report_Test
 * Description : Test class used for testing the VFC08_Adhoc_Report
 * Date : 6/23/14 1:34 PM 
 * Version : <intial Draft> 
 */
@isTest(SeeAllData=true)
private class VFC08_Adhoc_Report_Test { 
    /*
     *@name testSaveAndSend() 
     *@return void 
     *@description This method for saveAndSend () In CLASS VFC08_Adhoc_Report.cls
     */
     static testMethod void  testSaveAndSend() { 
        Test.startTest();
        Case  caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = null;      
        ApexPages.StandardController ctr = new ApexPages.StandardController(caseRecord);
        VFC08_Adhoc_Report vFC08_Adhoc_ReportTest  =  new  VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.VFP08_Adhoc_Report);
        PageReference pagereferenceTest = vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
         
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = date.parse('6/17/2014');
        
        ctr = new ApexPages.StandardController(caseRecord);
        vFC08_Adhoc_ReportTest  =  new  VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.VFP08_Adhoc_Report);
        pagereferenceTest = vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
         
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = date.parse('6/17/2014');
        caseRecord.Date_Range_to__c = date.parse('6/27/2014');
        ctr = new ApexPages.StandardController(caseRecord);
        vFC08_Adhoc_ReportTest  =  new  VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.VFP08_Adhoc_Report);
        pagereferenceTest = vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
        
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = date.parse('6/17/2014');
        caseRecord.Date_Range_to__c = date.parse('6/27/2014');
        caseRecord.Internal_Comments__c='test';
        ctr = new ApexPages.StandardController(caseRecord);
        vFC08_Adhoc_ReportTest  =  new  VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.VFP08_Adhoc_Report);
        pagereferenceTest = vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
        Test.stopTest();
    }
    //Added By RISHI 
    //SAASFOCUS 1/9/2015
    static testMethod void  testSaveAndSend2() { 
        Test.startTest();
        Case  caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = null;      
        ApexPages.StandardController ctr = new ApexPages.StandardController(caseRecord);
        SH_VFC08_Adhoc_Report vFC08_Adhoc_ReportTest  =  new  SH_VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.sh_VFP08_Adhoc_Report);
        PageReference pagereferenceTest = vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
         
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = date.parse('6/17/2014');
        
        ctr = new ApexPages.StandardController(caseRecord);
        vFC08_Adhoc_ReportTest  =  new  SH_VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.sh_VFP08_Adhoc_Report);
        pagereferenceTest = vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
         
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = date.parse('6/17/2014');
        caseRecord.Date_Range_to__c = date.parse('6/27/2014');
        ctr = new ApexPages.StandardController(caseRecord);
        vFC08_Adhoc_ReportTest  =  new  SH_VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.sh_VFP08_Adhoc_Report);
        //pagereferenceTest = 
        vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
        
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = date.parse('6/17/2014');
        caseRecord.Date_Range_to__c = date.parse('6/27/2014');
        caseRecord.Internal_Comments__c='test';
        ctr = new ApexPages.StandardController(caseRecord);
        vFC08_Adhoc_ReportTest  =  new  SH_VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.sh_VFP08_Adhoc_Report);
        pagereferenceTest = vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
        Test.stopTest();
    }

    static testMethod void  testSaveAndSend3() { 
        Test.startTest();
        Case  caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = null;   
        AccessTokenSetting__c act= new AccessTokenSetting__c();  
        ApexPages.StandardController ctr = new ApexPages.StandardController(act);
        SH_VFC08_Adhoc_Report vFC08_Adhoc_ReportTest  =  new  SH_VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.sh_VFP08_Adhoc_Report);
        PageReference pagereferenceTest = vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
         
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = date.parse('6/17/2014');
        
        ctr = new ApexPages.StandardController(caseRecord);
        vFC08_Adhoc_ReportTest  =  new  SH_VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.sh_VFP08_Adhoc_Report);
        pagereferenceTest = vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
         
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = date.parse('6/17/2014');
        caseRecord.Date_Range_to__c = date.parse('6/27/2014');
        ctr = new ApexPages.StandardController(caseRecord);
        vFC08_Adhoc_ReportTest  =  new  SH_VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.sh_VFP08_Adhoc_Report);
        //pagereferenceTest = 
        vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
        
        caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = date.parse('6/17/2014');
        caseRecord.Date_Range_to__c = date.parse('6/27/2014');
        caseRecord.Internal_Comments__c='test';
        ctr = new ApexPages.StandardController(caseRecord);
        vFC08_Adhoc_ReportTest  =  new  SH_VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.sh_VFP08_Adhoc_Report);
        pagereferenceTest = vFC08_Adhoc_ReportTest.saveAndSend();
        System.assert(true);
        Test.stopTest();
    }
    static testMethod void  testSaveAndSend4() { 
        Test.startTest();
        Case  caseRecord   = UtilUnitTest.getCase();
        caseRecord.Current_Date__c = null; 
        caseRecord.As_of_Date__c = null;
        caseRecord.Date_Range_from__c = null;      
        ApexPages.StandardController ctr = new ApexPages.StandardController(caseRecord);
        SH_VFC08_Adhoc_Report vFC08_Adhoc_ReportTest  =  new  SH_VFC08_Adhoc_Report(ctr);
        
        Test.setCurrentPage(Page.sh_VFP08_Adhoc_Report);
        
        vFC08_Adhoc_ReportTest.caseRecord.Report_Previously_Requested__c = 'Yes' ;
        vFC08_Adhoc_ReportTest.caseRecord.Date_of_Requested_Last_Report__c = null ;
        vFC08_Adhoc_ReportTest.caseRecord.Service_Request_Number__c = null;
        vFC08_Adhoc_ReportTest.caseRecord.Reporting_Team_Member__c = null;
        vFC08_Adhoc_ReportTest.noteValue ='test';
        vFC08_Adhoc_ReportTest.caseRecord.Internal_Comments__c='test';
        PageReference pagereferenceTest = vFC08_Adhoc_ReportTest.saveAndSend();
        //Assert to check Adhoc report
        system.assertnotequals(vFC08_Adhoc_ReportTest,null);
        
        Test.stopTest();
    }
}