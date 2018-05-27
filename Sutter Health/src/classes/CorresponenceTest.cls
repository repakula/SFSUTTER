@isTest
private class CorresponenceTest {

    
    private static testMethod void testMethod1() {
        try {
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            
            Contact contactObj = new Contact();
            contactObj.LastName = 'Test C1';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
            contactObj.Member_ID__c = 'M123456-01';
            contactObj.Member_Subscriber_Relationship__c  = 'Self';
            contactObj.mailingstreet = 'Test Street';
            contactObj.mailingcity = 'Test Street';
            contactObj.mailingstate = 'Test Street';
            contactObj.mailingcountry = 'Test Street';
            contactObj.MailingPostalCode= 'Test Street';
            insert contactObj;
            
            // Assert to check Contact is inserted successfully
            system.assert(contactObj.id!=null);
            
            Contact contactObj1 = new Contact();
            contactObj1.LastName = 'Test C2';
            contactObj1.AccountId = accObj.Id;
            contactObj1.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
            contactObj1.Member_ID__c = 'M123456-02';
            contactObj1.Member_Subscriber_Relationship__c  = 'Spouse';
            insert contactObj1;
            // Assert to check Contact is inserted successfully
            system.assert(contactObj1.id!=null);
            
            Contact contactObj2 = new Contact();
            contactObj2.LastName = 'Test C3';
            contactObj2.AccountId = accObj.Id;
            contactObj2.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Provider').RecordTypeId;
            contactObj2.Supplier_NPI__c = '3222244';
            contactObj2.Supplier_TIN_Address__c = '1200 Creek side\n\nFolsom, CA 95600-1000';
            insert contactObj2;
            // Assert to check Contact is inserted successfully
            system.assert(contactObj2.id!=null);
            
            Contact contactObj3 = new Contact();
            contactObj3.LastName = 'Test C4';
            contactObj3.AccountId = accObj.Id;
            contactObj3.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Sales Broker Contact Read Only').RecordTypeId;
            contactObj3.HealthRules_ID__c = '442211';
            contactObj3.mailingstreet = 'Test Street';
            contactObj3.mailingcity = 'Test Street';
            contactObj3.mailingstate = 'Test Street';
            contactObj3.mailingcountry = 'Test Street';
            contactObj3.MailingPostalCode= 'Test Street';
            insert contactObj3;
            // Assert to check Contact is inserted successfully
            system.assert(contactObj3.id!=null);
            
            Contact contactObj4 = new Contact();
            contactObj4.LastName = 'Test C5';
            contactObj4.AccountId = accObj.Id;
            contactObj4.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Sales Employer Contact Read Only').RecordTypeId;
            contactObj4.HealthRules_ID__c = '442213';
            contactObj4.mailingstreet = 'Test Street';
            contactObj4.mailingcity = 'Test Street';
            contactObj4.mailingstate = 'Test Street';
            contactObj4.mailingcountry = 'Test Street';
            contactObj4.MailingPostalCode= 'Test Street';
            insert contactObj4;
            // Assert to check Contact is inserted successfully
            system.assert(contactObj4.id!=null);
            
            Case caseObj =  new Case();
            caseObj.contactId = contactObj.Id;
            caseObj.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Correspondence').RecordTypeId;
            caseObj.subject = 'Test Case';
            insert caseObj;
            
            // Assert to check Case is inserted successfully
            system.assert(caseObj.id!=null);
            
            
            Test.StartTest();
            ApexPages.currentPage().getParameters().put('ServiceId',caseObj.Id);
            ApexPages.currentPage().getParameters().put('ContactId',contactObj.Id);
            CorrespondenceCls correspondenceClsObj= new CorrespondenceCls(new ApexPages.StandardController(new Correspondence__c()));
            correspondenceClsObj.isDefault = true;
            correspondenceClsObj.onDefaultCHKBoxClick();
            correspondenceClsObj.isDefault = false;
            correspondenceClsObj.onDefaultCHKBoxClick();
            correspondenceClsObj.correspondenceObj.Vehicle_of_Correspondence__c = 'Mail';
            correspondenceClsObj.onVehicleOfCoorespondenceChange();
            
            ApexPages.currentPage().getParameters().put('ContactId',contactObj2.Id);
            CorrespondenceCls correspondenceClsObj1 = new CorrespondenceCls(new ApexPages.StandardController(new Correspondence__c()));
            correspondenceClsObj1.isDefault = true;
            correspondenceClsObj1.onDefaultCHKBoxClick();
            correspondenceClsObj1.isDefault = false;
            correspondenceClsObj1.onDefaultCHKBoxClick();
            correspondenceClsObj1.correspondenceObj.Vehicle_of_Correspondence__c = 'Mail';
            correspondenceClsObj1.onVehicleOfCoorespondenceChange();
            
            ApexPages.currentPage().getParameters().put('ContactId',contactObj3.Id);
            CorrespondenceCls correspondenceClsObj2 = new CorrespondenceCls(new ApexPages.StandardController(new Correspondence__c()));
            
            
            
            ApexPages.currentPage().getParameters().put('ContactId',contactObj4.Id);
            CorrespondenceCls correspondenceClsObj3 = new CorrespondenceCls(new ApexPages.StandardController(new Correspondence__c()));
            correspondenceClsObj1.cancel();
            Test.StopTest();
        } catch(Exception ex) {}
    }
    
    private static testMethod void testMethod2() {
        try {
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            // Assert to check Account is inserted successfully
            system.assert(accObj.id!=null);
            
            Contact contactObj = new Contact();
            contactObj.LastName = 'Test C1';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
            contactObj.Member_ID__c = 'M123456-01';
            contactObj.Member_Subscriber_Relationship__c  = 'Self';
            contactObj.mailingstreet = 'Test Street';
            contactObj.mailingcity = 'Test Street';
            contactObj.mailingstate = 'Test Street';
            contactObj.mailingcountry = 'Test Street';
            contactObj.MailingPostalCode= 'Test Street';
            insert contactObj;
            // Assert to check Contact is inserted successfully
            system.assert(contactObj.id!=null);
            
            Contact contactObj1 = new Contact();
            contactObj1.LastName = 'Test C2';
            contactObj1.AccountId = accObj.Id;
            contactObj1.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
            contactObj1.Member_ID__c = 'M123456-02';
            contactObj1.Member_Subscriber_Relationship__c  = 'Spouse';
            insert contactObj1;
           // Assert to check Contact is inserted successfully
            system.assert(contactObj1.id!=null);
            
            Contact contactObj2 = new Contact();
            contactObj2.LastName = 'Test C3';
            contactObj2.AccountId = accObj.Id;
            contactObj2.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Provider').RecordTypeId;
            contactObj2.Supplier_NPI__c = '3222244';
            contactObj2.Supplier_TIN_Address__c = '1200 Creek side\n\nFolsom, CA 95600-1000';
            insert contactObj2;
            //  Assert to check Contact is inserted successfully
            system.assert(contactObj2.id!=null);
            
            Case caseObj =  new Case();
            caseObj.contactId = contactObj.Id;
            caseObj.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Correspondence').RecordTypeId;
            caseObj.subject = 'Test Case';
            insert caseObj;
            // Assert to check Account is Created successfully
            system.assert(caseObj.id!=null);
            
            Correspondence__c corresObj = new Correspondence__c();
            corresObj.Contact__c = contactObj.Id;
            corresObj.Street__c = 'Test 1';
            corresObj.City__c = 'Test 1';
            corresObj.State__c = 'Test 1';
            corresObj.Country__c  = 'Test 1';
            corresObj.ZipCode__c= 'Test 1';
            corresObj.Member_Type__c = 'Member';
            corresObj.Correspondence_Type__c = '';
            corresObj.Date_Sent_To_Vendor__c = System.today();
            corresObj.service_Request__c = caseObj.Id;
            corresObj.Relationship_To_Sub__c = 'Self';
            corresObj.Fax_Number__c = '222211';
            corresObj.Address_same_as_Default__c = true;
            corresObj.Vehicle_of_Correspondence__c= 'Email;Fax;';
            corresObj.Email_Id__c = 'Testrecord@test.com';
            corresObj.Status__c = 'New';
            corresObj.Comments__c = 'TestComment';
            insert corresObj;
            // Assert to check Correspondence record  is Created successfully
            system.assert(corresObj.id!=null);
            
            Correspondence__c corresObj1 = new Correspondence__c();
            corresObj1.Contact__c = contactObj2.Id;
            corresObj1.Street__c = 'Test 1';
            corresObj1.City__c = 'Test 1';
            corresObj1.State__c = 'Test 1';
            corresObj1.Country__c  = 'Test 1';
            corresObj1.ZipCode__c= 'Test 1';
            corresObj1.Member_Type__c = 'Member';
            corresObj1.Correspondence_Type__c = '';
            corresObj1.Date_Sent_To_Vendor__c = System.today();
            corresObj1.service_Request__c = caseObj.Id;
            corresObj1.Relationship_To_Sub__c = 'Self';
            corresObj1.Fax_Number__c = '222211';
            corresObj1.Address_same_as_Default__c = true;
            corresObj1.Vehicle_of_Correspondence__c= 'Email;Fax;';
            corresObj1.Email_Id__c = 'Testrecord@test.com';
            corresObj1.Status__c = 'New';
            corresObj1.Comments__c = 'TestComment';
            insert corresObj1;
            // Assert to check Correspondence record  is Created successfully
            system.assert(corresObj1.id!=null);
            
            Correspondence_Comments__c correscommentsObj1 = new Correspondence_Comments__c();
            correscommentsObj1.Comments__c = 'TestComment';
            correscommentsObj1.Correspondence__c=corresObj1.Id;
            insert correscommentsObj1;
            // Assert to check Correspondence Comment is Created successfully
            system.assert(correscommentsObj1.id!=null);
            
            Test.StartTest();
            ApexPages.currentPage().getParameters().put('corresid',corresObj1.Id);
            CorrespondenceCls correspondenceClsObj= new CorrespondenceCls(new ApexPages.StandardController(new Correspondence__c(id=corresObj.id)));
            correspondenceClsObj.isDefault = true;
            correspondenceClsObj.onDefaultCHKBoxClick();
            correspondenceClsObj.isDefault = false;
            correspondenceClsObj.onDefaultCHKBoxClick();
            correspondenceClsObj.correspondenceObj.Vehicle_of_Correspondence__c = 'Mail';
            correspondenceClsObj.onVehicleOfCoorespondenceChange();
            
            
            CorrespondenceCls correspondenceClsObj1 = new CorrespondenceCls(new ApexPages.StandardController(new Correspondence__c(id=corresObj1.id)));
            correspondenceClsObj1.isDefault = true;
            correspondenceClsObj1.onDefaultCHKBoxClick();
            correspondenceClsObj1.isDefault = false;
            correspondenceClsObj1.onDefaultCHKBoxClick();
            correspondenceClsObj1.correspondenceObj.Vehicle_of_Correspondence__c = 'Mail';
            correspondenceClsObj1.onVehicleOfCoorespondenceChange();
            
            Test.StopTest();
        } catch(Exception ex) {}
    }
    
    
    private static testMethod void testMethod3() {
        try {
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            // Assert to check Account  is Created successfully
            system.assert(accObj.id!=null);
            
            Contact contactObj = new Contact();
            contactObj.LastName = 'Test C2';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
            contactObj.Member_ID__c = 'M123456-01';
            contactObj.Member_Subscriber_Relationship__c  = 'Self';
            contactObj.mailingstreet = 'Test Street';
            contactObj.mailingcity = 'Test Street';
            contactObj.mailingstate = 'Test Street';
            contactObj.mailingcountry = 'Test Street';
            contactObj.MailingPostalCode= 'Test Street';
            insert contactObj;
            // Assert to check Contact is Created successfully
            system.assert(contactObj.id!=null);
            
            Contact contactObj1 = new Contact();
            contactObj1.LastName = 'Test C3';
            contactObj1.AccountId = accObj.Id;
            contactObj1.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
            contactObj1.Member_ID__c = 'M123456-02';
            contactObj1.Member_Subscriber_Relationship__c  = 'Spouse';
            insert contactObj1;
            // Assert to check Contact is Created successfully
            system.assert(contactObj1.id!=null);
            
            Contact contactObj2 = new Contact();
            contactObj2.LastName = 'Test C4';
            contactObj2.AccountId = accObj.Id;
            contactObj2.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Provider').RecordTypeId;
            contactObj2.Supplier_NPI__c = '3222244';
            contactObj2.Supplier_TIN_Address__c = '1200 Creek side\n\nFolsom, CA 95600-1000';
            insert contactObj2;
            // Assert to check Contact is Created successfully
            system.assert(contactObj2.id!=null);
            
            Case caseObj =  new Case();
            caseObj.contactId = contactObj.Id;
            caseObj.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Correspondence').RecordTypeId;
            caseObj.subject = 'Test Case';
            insert caseObj;
            // Assert to check Contact is Created successfully
            system.assert(caseObj.id!=null);

            Correspondence__c corresObj1 = new Correspondence__c();
            corresObj1.Contact__c = contactObj2.Id;
            corresObj1.Street__c = 'Test 1';
            corresObj1.City__c = 'Test 1';
            corresObj1.State__c = 'Test 1';
            corresObj1.Country__c  = 'Test 1';
            corresObj1.ZipCode__c= 'Test 1';
            corresObj1.Member_Type__c = 'Member';
            corresObj1.Correspondence_Type__c = '';
            corresObj1.Date_Sent_To_Vendor__c = System.today();
            corresObj1.service_Request__c = caseObj.Id;
            corresObj1.Relationship_To_Sub__c = 'Self';
            corresObj1.Fax_Number__c = '222211';
            corresObj1.Address_same_as_Default__c = true;
            corresObj1.Vehicle_of_Correspondence__c= 'Email;Fax;';
            corresObj1.Email_Id__c = 'Testrecord@test.com';
            corresObj1.Status__c = 'New';
            corresObj1.Comments__c = 'TestComment';
            insert corresObj1;
            // Assert to check Correspondence is Created successfully
            system.assert(caseObj.id!=null);
            
            Blob b = Blob.valueOf('Test Data');  
            Attachment attachment = new Attachment();  
            attachment.ParentId = caseObj.id;  
            attachment.Name = 'Test Attachment for Parent';  
            attachment.Body = b; 
            insert(attachment);
            // Assert to check attachment is Created successfully
            system.assert(caseObj.id!=null);
            
            Test.StartTest();
            CorrespondenceCls correspondenceClsObj= new CorrespondenceCls(new ApexPages.StandardController(new Correspondence__c()));
            correspondenceClsObj.saveCorrespondence();
            
            correspondenceClsObj.correspondenceObj.Vehicle_of_Correspondence__c = 'Email';
            correspondenceClsObj.correspondenceObj.Email_Id__c = 'Testrecord@test.com';
            correspondenceClsObj.correspondenceObj.Status__c = 'Pending';
            
            correspondenceClsObj.saveCorrespondence();
            correspondenceClsObj.correspondenceObj.Status__c = 'Closed';
            correspondenceClsObj.correspondenceObj.Service_Request__c = caseObj.id;
            correspondenceClsObj.correspondenceObj.Contact__c = contactObj.id;
            correspondenceClsObj.saveCorrespondence();
            correspondenceClsObj.attachment.OwnerId = Userinfo.getUserId();
            correspondenceClsObj.attachment.ParentId = caseObj.id ;
            correspondenceClsObj.attachment.body=Blob.valueOf('Unit Test Attachment Body');
            
            correspondenceClsObj.upload();
                        
            correspondenceClsObj= new CorrespondenceCls(new ApexPages.StandardController(new Correspondence__c(id=correspondenceClsObj.correspondenceObj.id)));
            Test.StopTest();
        } catch(Exception ex) {}
    }
    
    
    private static testMethod void testMethod4() {
        try {
            Account accObj = new Account();
            accObj.Name = 'Test Account';
            insert accObj;
            //Assert to check Account is created  successfully
            system.assert(accObj.id!=null);
            
            Contact contactObj = new Contact();
            contactObj.LastName = 'Test C2';
            contactObj.AccountId = accObj.Id;
            contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
            contactObj.Member_ID__c = 'M123456-01';
            contactObj.Member_Subscriber_Relationship__c  = 'Self';
            contactObj.mailingstreet = 'Test Street';
            contactObj.mailingcity = 'Test Street';
            contactObj.mailingstate = 'Test Street';
            contactObj.mailingcountry = 'Test Street';
            contactObj.MailingPostalCode= 'Test Street';
            insert contactObj;
           //Assert to check Contact  is created  successfully
            system.assert(contactObj.id!=null); 
            
            Contact contactObj1 = new Contact();
            contactObj1.LastName = 'Test C3';
            contactObj1.AccountId = accObj.Id;
            contactObj1.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
            contactObj1.Member_ID__c = 'M123456-02';
            contactObj1.Member_Subscriber_Relationship__c  = 'Spouse';
            insert contactObj1;
             //Assert to check Contact  is created  successfully
            system.assert(contactObj1.id!=null); 
            
            
            Contact contactObj2 = new Contact();
            contactObj2.LastName = 'Test C4';
            contactObj2.AccountId = accObj.Id;
            contactObj2.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Provider').RecordTypeId;
            contactObj2.Supplier_NPI__c = '3222244';
            contactObj2.Supplier_TIN_Address__c = '1200 Creek side\n\nFolsom, CA 95600-1000';
            insert contactObj2;
            //Assert to check Contact  is created  successfully
            system.assert(contactObj2.id!=null);
            
            Case caseObj =  new Case();
            caseObj.contactId = contactObj.Id;
            caseObj.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Correspondence').RecordTypeId;
            caseObj.subject = 'Test Case';
            insert caseObj;
            //Assert to check Case  is created  successfully
            system.assert(caseObj.id!=null);
            
            Correspondence__c corresObj = new Correspondence__c();
            corresObj.Contact__c = contactObj.Id;
            corresObj.Street__c = 'Test 1';
            corresObj.City__c = 'Test 1';
            corresObj.State__c = 'Test 1';
            corresObj.Country__c  = 'Test 1';
            corresObj.ZipCode__c= 'Test 1';
            corresObj.Member_Type__c = 'Member';
            corresObj.Correspondence_Type__c = '';
            corresObj.Date_Sent_To_Vendor__c = System.today();
            corresObj.service_Request__c = caseObj.Id;
            corresObj.Relationship_To_Sub__c = 'Self';
            corresObj.Fax_Number__c = '222211';
            corresObj.Address_same_as_Default__c = true;
            corresObj.Vehicle_of_Correspondence__c= 'Email;Fax;';
            corresObj.Email_Id__c = 'Testrecord@test.com';
            corresObj.Status__c = 'New';
            corresObj.Comments__c = 'TestComment';
            insert corresObj;
            //Assert to check Correspondence  is created  successfully
            system.assert(corresObj.id!=null);
            
            Correspondence_Comments__c correscommentsObj = new Correspondence_Comments__c();
            correscommentsObj.Comments__c = corresObj.Comments__c;
            correscommentsObj.Correspondence__c = corresObj.id;
            insert correscommentsObj;
            //Assert to check Correspondence  comment is created  successfully
            system.assert(correscommentsObj.id!=null);
            
            Correspondence__c corresObj1 = new Correspondence__c();
            corresObj1.Contact__c = contactObj2.Id;
            corresObj1.Street__c = 'Test 1';
            corresObj1.City__c = 'Test 1';
            corresObj1.State__c = 'Test 1';
            corresObj1.Country__c  = 'Test 1';
            corresObj1.ZipCode__c= 'Test 1';
            corresObj1.Member_Type__c = 'Member';
            corresObj1.Correspondence_Type__c = '';
            corresObj1.Date_Sent_To_Vendor__c = System.today();
            corresObj1.service_Request__c = caseObj.Id;
            corresObj1.Relationship_To_Sub__c = 'Self';
            corresObj1.Fax_Number__c = '222211';
            corresObj1.Address_same_as_Default__c = true;
            corresObj1.Vehicle_of_Correspondence__c= 'Email;Fax;';
            corresObj1.Email_Id__c = 'Testrecord@test.com';
            corresObj1.Status__c = 'New';
            corresObj1.Comments__c = 'TestComment';
            insert corresObj1;
            //Assert to check Correspondence  is created  successfully
            system.assert(corresObj.id!=null);
            
            Correspondence_Comments__c correscommentsObj1 = new Correspondence_Comments__c();
            correscommentsObj1.Comments__c = corresObj1.Comments__c;
            correscommentsObj1.Correspondence__c = corresObj1.id;
            insert correscommentsObj1;
           //Assert to check Correspondence  comment is created  successfully
            system.assert(correscommentsObj.id!=null);
            
            Test.StartTest();
            ApexPages.currentPage().getParameters().put('ServiceId',caseObj.Id);
            ApexPages.currentPage().getParameters().put('id',corresObj1.Id);
            CorrespondenceCls correspondenceClsObj= new CorrespondenceCls(new ApexPages.StandardController(new Correspondence__c()));
            
            correspondenceClsObj.correspondenceObj.Vehicle_of_Correspondence__c = 'Email';
            correspondenceClsObj.correspondenceObj.Email_Id__c = 'Testrecord@test.com';
            correspondenceClsObj.correspondenceObj.Status__c = Label.CL05_Closed;
            correspondenceClsObj.correspondenceObj.Closed_Date__c = System.now();
            correspondenceClsObj.correspondenceObj.City__c ='';
            correspondenceClsObj.correspondenceObj.State__c = '';
            correspondenceClsObj.correspondenceObj.ZipCode__c = '';
            correspondenceClsObj.correspondenceObj.Street__c = '';
            correspondenceClsObj.correspondenceObj.Comments__c = 'Test Comment';
            
           
            system.debug('@@corres Id after save : '+ correspondenceClsObj.correspondenceObj.id);
            correspondenceClsObj.correspondenceObj.Status__c = 'Closed';
            correspondenceClsObj.correspondenceObj.Service_Request__c = caseObj.id;
            correspondenceClsObj.correspondenceObj.Contact__c = contactObj.id;
            System.currentPageReference().getParameters().put('corresid', correspondenceClsObj.correspondenceObj.id);
            System.currentPageReference().getParameters().put('serviceId', caseObj.Id);
            correspondenceClsObj.saveCorrespondence();
             Test.setCurrentPageReference(new PageReference('Page.Correspondence')); 
            System.currentPageReference().getParameters().put('corresid', correspondenceClsObj.correspondenceObj.id);
            correspondenceClsObj.getAttachment();
            correspondenceClsObj.attachment.OwnerId = Userinfo.getUserId();
            correspondenceClsObj.attachment.ParentId = correspondenceClsObj.correspondenceObj.id ;
            correspondenceClsObj.attachment.body=Blob.valueOf('Unit Test Attachment Body');
                       
            
            correspondenceClsObj.upload();
                        
            //correspondenceClsObj= new CorrespondenceCls(new ApexPages.StandardController(new Correspondence__c(id=correspondenceClsObj.correspondenceObj.id)));
            Test.StopTest();
        } catch(Exception ex) {}
    }
}