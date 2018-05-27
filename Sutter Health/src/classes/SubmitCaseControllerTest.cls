/** Test class to test the functionality of WebToCase*/
@isTest private class SubmitCaseControllerTest{

/* test method to test the functionality of webtocase */ 
 @isTest
 static void testwebtocase()
  {
  SubmitCaseController casein = new SubmitCaseController(); 
  case tcasein  = casein.c;
  casein.submitCase() ; 
  tcasein.CusContactName__c = '003J000000tGfAJ';
  tcasein.Prior_Period_Adjustment__c = 'Additional Pay Request';
  tcasein.Effective_Pay_period__c = date.parse('5/17/2014');
  tcasein.Comments__c = 'test issue';
  tcasein.PayRoll_Type_of_Pay__c = 'Bonus';
  tcasein.Amount__c = 2000;
  casein.submitCase() ;
  tcasein.CusContactName__c = '003J000000tGfAJ';
  tcasein.Prior_Period_Adjustment__c = 'Payroll Adjustmentt';
  tcasein.Effective_Pay_period__c = date.parse('5/17/2014');
  tcasein.Comments__c = 'test issue';
  tcasein.Reason_Payroll__c = 'PTO not entered';
  casein.submitCase() ;  
  casein.InsertTimecard();
  casein.gettcr();
  casein.NewCase();
  
  //Assert to check Case is created successfully
    System.assertNotEquals(null,casein.NewCase());
  casein.EmpNumandMan();
  }

  //saasfocus
  @isTest
 static void testwebtocase2()
  {
  SH_SubmitCaseController casein = new SH_SubmitCaseController(); 
  case tcasein  = casein.c;
  casein.submitCase() ; 
  tcasein.CusContactName__c = '003J000000tGfAJ';
  tcasein.Prior_Period_Adjustment__c = 'Additional Pay Request';
  tcasein.Effective_Pay_period__c = date.parse('5/17/2014');
  tcasein.Comments__c = 'test issue';
  tcasein.PayRoll_Type_of_Pay__c = 'Bonus';
  tcasein.Amount__c = 2000;
  casein.submitCase() ;
  tcasein.CusContactName__c = '003J000000tGfAJ';
  tcasein.Prior_Period_Adjustment__c = 'Payroll Adjustmentt';
  tcasein.Effective_Pay_period__c = date.parse('5/17/2014');
  tcasein.Comments__c = 'test issue';
  tcasein.Reason_Payroll__c = 'PTO not entered';
  casein.submitCase() ;  
  
  casein.InsertTimecard();
  casein.gettcr();
  casein.NewCase();
  //Assert to check Case is created successfully
    System.assertNotEquals(null, casein.NewCase());
  casein.EmpNumandMan();
  }



/*Test method to send a case while calling the controller
  Added the method on 12 Dec 14 */
 @isTest
 static void callcontrollerwithcase()
  {
   /*Create test data*/
  
   Case cas =  AP01_TestDataUtility.createCase();
    CS_ManageProfile__c csManageCustSett = new CS_ManageProfile__c(Name = 'Communities_Provider', Profile_Name__c = 'Community Provider');
    insert csManageCustSett;
    
    Account acc = AP01_TestDataUtility.createAccount();
    //Assert to check Account is created Successfully
    system.assert(acc.id!=null);
    
    Contact con = new Contact();
    con.AccountId = acc.id;
    con.RecordtypeId = '012G0000000jjLe';
    con.LastName =  AP01_TestDataTokens.CONTACT_L_NAME;
    con.Employee_Id__c = '123456';
    con.Employee_Supervisor_Name__c = 'TestSuperVisor';
    insert con;
    //Assert to check Contact is created Successfully
    system.assert(con.id!=null);
    system.debug('@@con : '+ con);
   
   Test.StartTest() ;
       SubmitCaseController casein = new SubmitCaseController(new ApexPages.StandardController(cas)); 
      

       casein.EmployeeName = con.id;
       casein.c = cas;
       casein.EmpNumandMan();
       casein.InsertTimecard();
       casein.TCard.Date__c = System.today();
       casein.TCard.In_Punch_Time__c = 'Today';
       casein.InsertTimecard();
   Test.Stoptest();
   
  }
  //saasfocus
  @isTest
 static void callcontrollerwithcase2()
  {
   /*Create test data*/
  
   Case cas =  AP01_TestDataUtility.createCase();
   // Assert to check Case is created successfully
   system.assert(cas.id!=null);
    CS_ManageProfile__c csManageCustSett = new CS_ManageProfile__c(Name = 'Communities_Provider', Profile_Name__c = 'Community Provider');
    insert csManageCustSett;
    
    //Assert to check Custom setting is created succesfully
    system.assert(csManageCustSett!=null);
    
    Account acc = AP01_TestDataUtility.createAccount();
    Contact con = new Contact();
    con.AccountId = acc.id;
    con.RecordtypeId = '012G0000000jjLe';
    con.LastName =  AP01_TestDataTokens.CONTACT_L_NAME;
    con.Employee_Id__c = '123456';
    con.Employee_Supervisor_Name__c = 'TestSuperVisor';
    insert con;
    //Assert to check Contact is created succesfully
    system.assert(con.id!=null);
    system.debug('@@con : '+ con);
   
   Test.StartTest() ;
       SH_SubmitCaseController casein = new SH_SubmitCaseController(new ApexPages.StandardController(cas)); 
      

       casein.EmployeeName = con.id;
       casein.c = cas;
       casein.EmpNumandMan();
       casein.InsertTimecard();
       casein.TCard.Date__c = System.today();
       casein.TCard.In_Punch_Time__c = 'Today';
       casein.InsertTimecard();
   Test.Stoptest();
   
  }

  static testmethod void  callcontrollerwithcase3()
  {
   /*Create test data*/
  
   Case cas =  AP01_TestDataUtility.createCase();
   //Assert to check case is created successfully
   system.assert(cas.id!=null);
   Case cas2 =  new case();
    CS_ManageProfile__c csManageCustSett = new CS_ManageProfile__c(Name = 'Communities_Provider', Profile_Name__c = 'Community Provider');
    insert csManageCustSett;
    //Assert to check Custom setting is created successfully
    system.assert(csManageCustSett.id!=null);
    
    Account acc = AP01_TestDataUtility.createAccount();
    Contact con = new Contact();
    con.AccountId = acc.id;
    con.RecordtypeId = '012G0000000jjLe';
    con.LastName =  AP01_TestDataTokens.CONTACT_L_NAME;
    con.Employee_Id__c = '123456';
    con.Employee_Supervisor_Name__c = 'TestSuperVisor';
    insert con;
    //assert to check Contact is created successfully
    system.assert(con.id!=null);
    system.debug('@@con : '+ con);
   
   Test.StartTest() ;
       SH_SubmitCaseController casein = new SH_SubmitCaseController(new ApexPages.StandardController(cas)); 
       SH_SubmitCaseController casein2 = new SH_SubmitCaseController(new ApexPages.StandardController(cas2)); 
      

       casein.EmployeeName = con.id;
       casein.c = cas;
       casein.EmpNumandMan();
       casein.InsertTimecard();
       casein.TCard.Date__c = System.today();
       casein.TCard.In_Punch_Time__c = 'Today';
       casein.acctNum='123123';
       casein.TestFinalCaseNumber='12312';
       casein.EmployeeNumber='123123';
       casein.EmployeeManager='12331';
       casein.submited=true;
       casein.status='test';
       casein.cfile=Blob.valueof('myString');

       casein.rer=true;
       casein.tc=new List<TimeCard__c>();
       casein.tcr=new List<TimeCard__c>();
       casein.saveflag1 =true; 
       casein.CaseNumber='123';
       casein.strPayRollTypeOfPay='123123';
       casein.InsertTimecard();
       casein.EmployeeName = null;
       casein.EmpNumandMan();
        casein.conid='a1MZ0000002Gdvh';
       casein.contactold='a1MZ0000002Gdvh'; 
        casein.upload();
        Attachment a1 = casein.attachment;
   Test.Stoptest();
   
  }

}