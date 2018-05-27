@isTest(SeeAllData=true)
private class SH_TestPayrollStopPayment {

    static testMethod void stopPaymentTest() {
        try {
          Test.startTest();
          Account acc1 = new Account();
          acc1.Name = 'TestAccount10';
          insert acc1;
          
          Contact cont1 = new Contact(); 
          cont1.LastName= 'Testcontact';
          cont1.accountid = acc1.id;
          cont1.recordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
          cont1.email = 'test24@test.com';
          cont1.Employee_Union_Affiliate__c = 'HREB';
          cont1.Employee_Employment_Status__c = 'AA';
          cont1.Employee_Affiliate_Facility__c = 'Alta Bates Summit Med Center';
          cont1.Employee_Work_Email__c = 'test24@test.com';
          cont1.Employee_EEO_SubCode__c = '6';
          cont1.Employee_ADID__c = 'Test24';
          cont1.Employee_ID__c = 'T32211';
          cont1.phone = '9810546384';
          cont1.MailingStreet = 'Test Street, Test Building';
          cont1.MailingCity = 'TestCity';
          cont1.MailingState = 'TestState';
          cont1.MailingPostalCode = '201001';
          insert cont1;
          
          Test.StopTest();
          List<User> userLst = [select Id from User where email = 'test24@test.com'];
          system.Debug('>>>>>userLst>>>'+userLst);
          if(userLst.size()>0) {
            system.runas(userLst[0]) 
			{
				  SH_PayrollStopPaymentsController temppaymentObj = new SH_PayrollStopPaymentsController(new ApexPages.standardController(new Case()));
				  temppaymentObj.caseObj.Payment_Date__c = system.today();
				  temppaymentObj.caseObj.Net_Amount__c = Decimal.ValueOf('1234');
				  temppaymentObj.caseObj.Contact_Phone_Number__c = '9810546384';
				  temppaymentObj.submitCase();
				  temppaymentObj.cancel();
				  temppaymentObj.newStopPayment();
				  temppaymentObj = new SH_PayrollStopPaymentsController(new ApexPages.standardController(new Case(id=temppaymentObj.caseObj.id)));
				  
            }
          }
        } catch(Exception ex) {}
    }
}