/**    
 *     Class Name  : SHPSRCreationThroughChatter_Test
 *     Author      : IDC Offshore  
 *     Date        : 01-Nov-2015  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : Test Class for SHPSRCreationThroughChatter Trigger Helper Class.
 **/
@isTest
private class SHPSRCreationThroughChatter_Test {
    
    /**
    *   @Description: Methods creates test user for Inserting Post in Chatter.
    *   @Arguments: None     
    *   @Return: User
    **/
    static User getUser(){ 
      String aliasString = 'ChatT';
      Id sysAdminId = [Select Id from Profile Where Name = 'System Administrator' Limit 1].Id;
      User usr = new User(
      alias = aliasString, 
      email= aliasString+'@accenture.com',
      emailencodingkey='UTF-8',
      lastname='Testing', 
      languagelocalekey='en_US',
      localesidkey='en_US',
      profileid = sysAdminId,
      timezonesidkey='Europe/London',
      username= aliasString+'@accenture.com');
      return usr;
    }
    
    /**
    *   @Description: Methods creates Contacts as lookup to SR.
    *   @Arguments: None     
    *   @Return: List<Contact>
    **/
    static List<Contact> createContacts() {
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        accObj.SHP_Group_ID__c = '123456';
        insert accObj;
        List <Contact> TestContactListToInsert = new List<Contact>();
        
        Contact MemberContact = new Contact( LastName = 'Test Contact Member',
                                             RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId,
                                             AccountId = accObj.Id,
                                             Member_ID__c = 'M64882370-98');
        TestContactListToInsert.add(MemberContact);
       
       /*
        Contact ProviderContact = new Contact( LastName = 'Test Contact Provider',
                                                RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Provider').RecordTypeId,
                                                AccountId = accObj.Id,
                                                Supplier_NPI__c = '12346567890'); 
        TestContactListToInsert.add(ProviderContact);*/
        
        Contact BrokerContact = new Contact( LastName = 'Test Contact Sushant',
                                             RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Sales Broker Contact').RecordTypeId,
                                             AccountId = accObj.Id,
                                             HealthRules_ID__c = 'C-00997070'); 
        TestContactListToInsert.add(BrokerContact);
        
        Contact EmployerContact = new Contact( LastName = 'Test Contact Employer',
                                               RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('SHP Sales Employer Contact').RecordTypeId,           
                                               AccountId = accObj.id);
        TestContactListToInsert.add(EmployerContact);
        
        return TestContactListToInsert;
    }

    /**
    *   @Description: Methods Tests the Scenario where user post chatter comment to create and SR is created to that post.
    *                 where member id is mentioned in post and related Member is attached to the Post.
    *   @Arguments: None     
    *   @Return: void
    **/
    static testMethod void SRCreationthroughChatterTestMember() {
        User testUser = getUser();
        insert testUser;
        List <Contact> TestContactListToInsert =  createContacts();
        Id SHPbillingId = [ Select Id From Group Where Type='Queue' AND DeveloperName = 'SHP_Billing' limit 1].Id;
        SHP_SR_Creation_From_Chatter__c ShpBillingCustomSetting = new SHP_SR_Creation_From_Chatter__c(Name = 'SHP Billing',
                                                                                                      Queue_Id__c = SHPbillingId);
        insert ShpBillingCustomSetting;
        
        if( !TestContactListToInsert.isEmpty()) {
            Database.insert(TestContactListToInsert);
        }
        
        FeedItem chatterPost = new FeedItem(Body = 'Hi @SHP Billing SR For Member:M64882370-98 from Chatter',
                                            ParentId = testUser.Id);
        system.runAs( testUser ) {
            Test.startTest();
            insert chatterPost;
            Test.stopTest();
        }
        
        Case ChatterSR = [Select Id, Origin , Status , RecordTypeId, ContactId ,Description FROM Case limit 1];
        
        if( ChatterSR != null ) {
            system.assertEquals( ChatterSR.Origin , 'Chatter');
            system.assertEquals( ChatterSR.Status,'New' );
            system.assertEquals( ChatterSR.RecordTypeId , Schema.SObjectType.Case.RecordTypeInfosByName.get('SHP Chatter SR - Service').RecordTypeId );
            system.assertEquals( ChatterSR.ContactId ,TestContactListToInsert[0].Id );  
        }
    }
    
    /**
    *   @Description: Methods Tests the Scenario where user post chatter comment to create and SR is created to that post.
    *                 where Broker id is mentioned in post and related Broker is attached to the Post.
    *   @Arguments: None     
    *   @Return: void
    **/
    
    static testMethod void SRCreationthroughChatterTestBroker() {
        User testUser = getUser();
        insert testUser;
        List <Contact> TestContactListToInsert =  createContacts();
        Id SHPbillingId = [ Select Id From Group Where Type='Queue' AND DeveloperName = 'SHP_Billing' limit 1].Id;
        SHP_SR_Creation_From_Chatter__c ShpBillingCustomSetting = new SHP_SR_Creation_From_Chatter__c(Name = 'SHP Billing',
                                                                                                      Queue_Id__c = SHPbillingId);
        String BrokerIdvalue;                                                                                              
        insert ShpBillingCustomSetting;
        
        CreatedDate__c CustomSettingOLTP = new CreatedDate__c( Name = 'CopyPcpDate',
                                                               Created_date__c = Date.today());
        insert CustomSettingOLTP;
        
        if( !TestContactListToInsert.isEmpty()) {
            Database.insert(TestContactListToInsert);
        }
        Contact con = [Select Id, Member_ID__c,HealthRules_ID__c FROM Contact WHERE HealthRules_ID__c != null limit 1] ;
        if( con != null ) {
            BrokerIdvalue = con.HealthRules_ID__c;  
        }
        
        
        FeedItem chatterPost = new FeedItem(Body = ' Hi @SHP Billing SR For Broker:' + BrokerIdvalue + 'from Chatter',
                                            ParentId = testUser.Id);
        system.debug('@@@@'+TestContactListToInsert[1]);
        
     
        system.runAs( testUser ) {
            Test.startTest();
            insert chatterPost;
            Test.stopTest();    
        }
        
        
        Case ChatterSR = [Select Id, Origin , Status , RecordTypeId, ContactId ,Description FROM Case limit 1];
        
        if( ChatterSR != null ) {
            system.assertEquals( ChatterSR.Origin , 'Chatter');
            system.assertEquals( ChatterSR.Status,'New' );
            system.assertEquals( ChatterSR.RecordTypeId , Schema.SObjectType.Case.RecordTypeInfosByName.get('SHP Chatter SR - Service').RecordTypeId );
            system.assertEquals( ChatterSR.ContactId ,TestContactListToInsert[1].Id );  
        }
    }
    
    /**
    *   @Description: Methods Tests the Scenario where user post chatter comment to create and SR is created to that post.
    *                 where Employer id is mentioned in post and related Employer is attached to the Post.
    *   @Arguments: None     
    *   @Return: void
    **/
    
    static testMethod void SRCreationthroughChatterTestEmployer() {
        User testUser = getUser();
        insert testUser;
        List <Contact> TestContactListToInsert =  createContacts();
        Id SHPbillingId = [ Select Id From Group Where Type='Queue' AND DeveloperName = 'SHP_Billing' limit 1].Id;
        SHP_SR_Creation_From_Chatter__c ShpBillingCustomSetting = new SHP_SR_Creation_From_Chatter__c(Name = 'SHP Billing',
                                                                                                      Queue_Id__c = SHPbillingId);
        insert ShpBillingCustomSetting;
        
        if( !TestContactListToInsert.isEmpty()) {
            Database.insert(TestContactListToInsert);
        }
        
        FeedItem chatterPost = new FeedItem(Body = ' Hi @SHP Billing SR For Employer: 123456 from Chatter',
                                            ParentId = testUser.Id);
        system.runAs( testUser ) {
            Test.startTest();
            insert chatterPost;
            Test.stopTest();
        }
        
        Case ChatterSR = [Select Id, Origin , Status , RecordTypeId, ContactId ,Description FROM Case limit 1];
        
        if( ChatterSR != null ) {
            system.assertEquals( ChatterSR.Origin , 'Chatter');
            system.assertEquals( ChatterSR.Status,'New' );
            system.assertEquals( ChatterSR.RecordTypeId , Schema.SObjectType.Case.RecordTypeInfosByName.get('SHP Chatter SR - Service').RecordTypeId );
            system.assertEquals( ChatterSR.ContactId ,TestContactListToInsert[2].Id );  
        }
    }
    
    /**
    *   @Description: Methods Tests the Scenario where user post chatter comment to create and SR is created to that post.
    *                 where Member id is mentioned in post and Member Related to it is not present in the System .
    *   @Arguments: None     
    *   @Return: void
    **/
    
    static testMethod void SRCreationthroughChatterTestMember_NoContact() {
        User testUser = getUser();
        insert testUser;
        List <Contact> TestContactListToInsert =  createContacts();
        Id SHPbillingId = [ Select Id From Group Where Type='Queue' AND DeveloperName = 'SHP_Billing' limit 1].Id;
        SHP_SR_Creation_From_Chatter__c ShpBillingCustomSetting = new SHP_SR_Creation_From_Chatter__c(Name = 'SHP Billing',
                                                                                                      Queue_Id__c = SHPbillingId);
        insert ShpBillingCustomSetting;
        
        if( !TestContactListToInsert.isEmpty()) {
            Database.insert(TestContactListToInsert);
        }
        
        FeedItem chatterPost = new FeedItem(Body = ' Hi @SHP Billing SR For Employer: 54671 from Chatter',
                                            ParentId = testUser.Id);
        system.runAs( testUser ) {
            Test.startTest();
            insert chatterPost;
            Test.stopTest();
        }
        
        Case ChatterSR = [Select Id, Origin , Status , RecordTypeId, ContactId ,Description FROM Case limit 1];
        
        if( ChatterSR != null ) {
            system.assertEquals( ChatterSR.Origin , 'Chatter');
            system.assertEquals( ChatterSR.Status,'New' );
            system.assertEquals( ChatterSR.RecordTypeId , Schema.SObjectType.Case.RecordTypeInfosByName.get('SHP Chatter SR - Service').RecordTypeId );
            system.assertEquals( ChatterSR.ContactId ,null );  
        }
    }
    
    /**
    *   @Description: Methods Tests the Scenario where user post chatter comment to create and SR is created to that post.
    *                 where Member id is not mentioned in post.
    *   @Arguments: None     
    *   @Return: void
    **/
    static testMethod void SRCreationthroughChatterTestMember_NegativeTeast() {
        User testUser = getUser();
        insert testUser;
        List <Contact> TestContactListToInsert =  createContacts();
        Id SHPbillingId = [ Select Id From Group Where Type='Queue' AND DeveloperName = 'SHP_Billing' limit 1].Id;
        SHP_SR_Creation_From_Chatter__c ShpBillingCustomSetting = new SHP_SR_Creation_From_Chatter__c(Name = 'SHP Billing',
                                                                                                      Queue_Id__c = SHPbillingId);
        insert ShpBillingCustomSetting;
    
        if( !TestContactListToInsert.isEmpty()) {
            Database.insert(TestContactListToInsert);
        }
        
        FeedItem chatterPost = new FeedItem(Body = ' Hi @SHP Billing SR For Member: from Chatter',
                                            ParentId = testUser.Id);
        
                                            
        system.runAs( testUser ) {
            Test.startTest();
            insert chatterPost;
            Test.stopTest();
        }
        
        Case ChatterSR = [Select Id, Origin , Status , RecordTypeId, ContactId ,Description FROM Case limit 1];
        
        if( ChatterSR != null ) {
            system.assertEquals( ChatterSR.Origin , 'Chatter');
            system.assertEquals( ChatterSR.Status,'New' );
            system.assertEquals( ChatterSR.RecordTypeId , Schema.SObjectType.Case.RecordTypeInfosByName.get('SHP Chatter SR - Service').RecordTypeId );
            system.assertEquals( ChatterSR.ContactId ,null );  
        }
    }
    
     /**
    *   @Description: Methods Tests the Scenario where user post chatter comment to create and SR is created to that post.
    *                 where Broker id is not mentioned in post.
    *   @Arguments: None     
    *   @Return: void
    **/
    static testMethod void SRCreationthroughChatterTestBroker_NegativeTeast() {
        User testUser = getUser();
        insert testUser;
        List <Contact> TestContactListToInsert =  createContacts();
        Id SHPbillingId = [ Select Id From Group Where Type='Queue' AND DeveloperName = 'SHP_Billing' limit 1].Id;
        SHP_SR_Creation_From_Chatter__c ShpBillingCustomSetting = new SHP_SR_Creation_From_Chatter__c(Name = 'SHP Billing',
                                                                                                      Queue_Id__c = SHPbillingId);
        insert ShpBillingCustomSetting;
    
        if( !TestContactListToInsert.isEmpty()) {
            Database.insert(TestContactListToInsert);
        }
        
        FeedItem chatterPost = new FeedItem(Body = ' Hi @SHP Billing SR For Broker: from Chatter',
                                            ParentId = testUser.Id);
        
                                            
        system.runAs( testUser ) {
            Test.startTest();
            insert chatterPost;
            Test.stopTest();
        }
        
        Case ChatterSR = [Select Id, Origin , Status , RecordTypeId, ContactId ,Description FROM Case limit 1];
        
        if( ChatterSR != null ) {
            system.assertEquals( ChatterSR.Origin , 'Chatter');
            system.assertEquals( ChatterSR.Status,'New' );
            system.assertEquals( ChatterSR.RecordTypeId , Schema.SObjectType.Case.RecordTypeInfosByName.get('SHP Chatter SR - Service').RecordTypeId );
            system.assertEquals( ChatterSR.ContactId ,null );  
        }
    }
    
    /**
    *   @Description: Methods Tests the Scenario where user post chatter comment to create and SR is created to that post.
    *                 where Employer id is not mentioned in post.
    *   @Arguments: None     
    *   @Return: void
    **/
    static testMethod void SRCreationthroughChatterTestEmployer_NegativeTeast() {
        User testUser = getUser();
        insert testUser;
        List <Contact> TestContactListToInsert =  createContacts();
        Id SHPbillingId = [ Select Id From Group Where Type='Queue' AND DeveloperName = 'SHP_Billing' limit 1].Id;
        SHP_SR_Creation_From_Chatter__c ShpBillingCustomSetting = new SHP_SR_Creation_From_Chatter__c(Name = 'SHP Billing',
                                                                                                      Queue_Id__c = SHPbillingId);
        insert ShpBillingCustomSetting;
    
        if( !TestContactListToInsert.isEmpty()) {
            Database.insert(TestContactListToInsert);
        }
        
        FeedItem chatterPost = new FeedItem(Body = ' Hi @SHP Billing SR For Employer: from Chatter',
                                            ParentId = testUser.Id);
        
                                            
        system.runAs( testUser ) {
            Test.startTest();
            insert chatterPost;
            Test.stopTest();
        }
        
        Case ChatterSR = [Select Id, Origin , Status , RecordTypeId, ContactId ,Description FROM Case limit 1];
        
        if( ChatterSR != null ) {
            system.assertEquals( ChatterSR.Origin , 'Chatter');
            system.assertEquals( ChatterSR.Status,'New' );
            system.assertEquals( ChatterSR.RecordTypeId , Schema.SObjectType.Case.RecordTypeInfosByName.get('SHP Chatter SR - Service').RecordTypeId );
            system.assertEquals( ChatterSR.ContactId ,null );  
        }
    }
    
    /**
    *   @Description: Methods Tests the Scenario where user post null chatter comment and encounter exception
    *   @Arguments: None     
    *   @Return: void
    **/
    static testMethod void SRCreationthroughChatterTestEmployer_ExceptionTest() {
        User testUser = getUser();
        insert testUser;
        List <Contact> TestContactListToInsert =  createContacts();
        Id SHPbillingId = [ Select Id From Group Where Type='Queue' AND DeveloperName = 'SHP_Billing' limit 1].Id;
        SHP_SR_Creation_From_Chatter__c ShpBillingCustomSetting = new SHP_SR_Creation_From_Chatter__c(Name = 'SHP Billing',
                                                                                                      Queue_Id__c = SHPbillingId);
        insert ShpBillingCustomSetting;
    
        if( !TestContactListToInsert.isEmpty()) {
            Database.insert(TestContactListToInsert);
        }
        
        FeedItem chatterPost = new FeedItem(Type='ApprovalPost' ,
        
                                            ParentId = testUser.Id);
        
                                            
        system.runAs( testUser ) {
            Test.startTest();
            insert chatterPost;
            Test.stopTest();
        }
        
        SystemException__c ChatterException = [Select Id, ExceptionMessage__c FROM SystemException__c limit 1];
        
        if( ChatterException != null ) {
            system.assertNotEquals( ChatterException.ExceptionMessage__c ,null );
        }
    }
    
       
}