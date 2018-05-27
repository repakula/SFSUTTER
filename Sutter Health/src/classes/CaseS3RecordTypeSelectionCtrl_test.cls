@isTest
private class CaseS3RecordTypeSelectionCtrl_test{

   static testMethod void shpTest(){
   //pageReference pegRef = new pageReference('/setup/ui/recordtypeselect.jsp?ent=Case&save_new_url=500/e');
    Case testCase = new Case();
    ApexPages.StandardController stdCont = new ApexPages.StandardController(testCase); 
    CaseS3RecordTypeSelectionCtrl cnt = new CaseS3RecordTypeSelectionCtrl(stdCont);
    cnt.redirectPage();
    //Assert to check page is redirected successfully
    System.assertNotEquals(null,cnt.redirectPage());
   
   }
  }