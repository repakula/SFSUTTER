@isTest


class TestProviderSummaryTrigger{

static testmethod void TestSummaryIns(){


 Account assignedAccount = AP01_TestDataUtility.createPortalAccount();
            Contact assignedContact = AP01_TestDataUtility.employeeContact(assignedAccount);
            
            Contact_Validation_Summary__c objSummary = new Contact_Validation_Summary__c();
            objSummary.Contact_Id__c=assignedContact.id;
            objSummary.Name='test';
           
            insert objSummary;
            //Assert to check Contact_Validation_Summary__c  is created successfully
            system.assert(objSummary.id!=null);
            
            Contact_Validation_Summary__c objSummary2 = new Contact_Validation_Summary__c();
            objSummary2.Contact_Id__c=assignedContact.id;
            objSummary2.Name='test2';
            insert objSummary2;
            //Assert to check Contact_Validation_Summary__c  is created successfully
            system.assert(objSummary2.id!=null);

             objSummary2.Name='test22';
            update objSummary2;




}


}