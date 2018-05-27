@isTest
private class CaseSHPRecordTypeSelectionCtrl_test{

   static testMethod void shpTest(){
   //pageReference pegRef = new pageReference('/setup/ui/recordtypeselect.jsp?ent=Case&save_new_url=500/e');
    Case testCase = new Case();
    ApexPages.StandardController stdCont = new ApexPages.StandardController(testCase); 
    CaseSHPRecordTypeSelectionCtrl cnt = new CaseSHPRecordTypeSelectionCtrl(stdCont);
    cnt.redirectPage();
    //Assert to check page is redirected successfully
    System.assertNotEquals(null,cnt.redirectPage());
   }
  }