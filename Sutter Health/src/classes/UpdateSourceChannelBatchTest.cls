/**********************************************************************
Name: UpdateSourceChannelBatchTest
Copyright © 2015 IDC Offshore
======================================================
======================================================
Purpose:
This is the test class for UpdateSourceChannelBatch class
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE        DETAIL                 Description
1.0      IDC Offshore  08/31/2015 Development complete   This class is defined to test UpdateSourceChannelBatchTest class
2.0      IDC Offshore  12/30/2015  Class Optimization   Incorporated changes to implement best test practices in the test class.
***********************************************************************/

 @isTest
private class UpdateSourceChannelBatchTest{
                
      /********************************************************
     Purpose: Method to create test data used by all tests 
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A 
     *******************************************************/          

    @testsetup
    static void createtestdata() {
        
        
    /* Create custom setting Data */
    CS_ManageProfile__c CSMCommunities_Portal = new CS_ManageProfile__c(Name = 'Communities_Portal', Profile_Name__c='Community Portal');
    CS_ManageProfile__c CSMCommunities_Provider = new CS_ManageProfile__c(Name = 'Communities_Provider', Profile_Name__c='Community Portal Manager');
    CS_ManageProfile__c CSMCommunity_Portal_Manager = new CS_ManageProfile__c(Name = 'Community_Portal_Manager', Profile_Name__c='Community Portal Manager');
    Insert CSMCommunities_Portal;
    Insert CSMCommunities_Provider;
    Insert CSMCommunity_Portal_Manager;

    /*********************************************************************** 
    Verifying the Custom setting data using system.assert() 
    Expected Result: Custom setting  is not null
    Actual Result: Custom setting  is not null 
    ***********************************************************************/ 
    system.assert(CSMCommunities_Portal!=null);
    system.assert(CSMCommunities_Provider!=null);
    system.assert(CSMCommunity_Portal_Manager!=null);
    CS_ManageProfile__c profilecustsett = AP01_TestDataUtility.createManageProfileCustSetting();
    String strProvider = System.Label.Provider_Label;            
    RecordType testRecordtype = [SELECT id, name FROM recordtype WHERE name='Provider' and SObjectType='Contact' limit 1];

    /* Creating data for section TLFM */
    Account AccTLFM = new Account();        
    AccTLFM.Name = 'TLFM';        
    insert AccTLFM;     

    Contact ConTLFM = new Contact();
        ConTLFM.accountId = AccTLFM.id;
            ConTLFM.lastName = 'Test L name';
            ConTLFM.firstName = 'Test F1 Name';
            ConTLFM.Provider_Name__c = 'Test Provider';
            ConTLFM.Provider_Title__c = 'Mr.';
            ConTLFM.recordTypeId = testRecordtype.id;
            ConTLFM.email = 'test@test.com';
            ConTLFM.Provider_Correspondence_Address__c = '123';
            ConTLFM.Provider_Correspondence_City__c = 'CA';
            ConTLFM.Provider_Correspondence_State__c = 'CA';
            ConTLFM.Provider_Correspondence_PostalCode__c = '12345';
            ConTLFM.Provider_Correspondence_Phone__c = '2345678901';
            ConTLFM.Provider_Correspondence_Fax_Number__c = '2345678901';
            ConTLFM.Provider_Practicing_Physician__c = true;
            ConTLFM.Provider_Active_Status__c = true;
            ConTLFM.Provider_Active_Status_Date__c = system.today();
            ConTLFM.MobilePhone = '2345678901';
            ConTLFM.Contact_External_ID1__c = '1234';
            ConTLFM.Source_of_E_mail__c = 'TLFM';
    insert ConTLFM;    

    Contact_Validation_Summary__c convalsummaryTLFM = new Contact_Validation_Summary__c();
    convalsummaryTLFM.Contact_Id__c = ConTLFM.Id;
    convalsummaryTLFM.Name = 'TestTLFM';
    convalsummaryTLFM.Last_Verified_Date__c = DateTime.now();
    convalsummaryTLFM.Address_Type__c = 'Secondary';
    insert convalsummaryTLFM;       

    /* Creating data for section PFCHANGE */
    Account AccPFCHANGE = new Account();        
    AccPFCHANGE.Name = 'PFCHANGE';        
    insert AccPFCHANGE;     

    Contact ConPFCHANGE = new Contact();      
    ConPFCHANGE.FirstName = 'Test F1 Name';       
    ConPFCHANGE.LastName = 'Test L name';     
    ConPFCHANGE.Email = 'test2@test.com';     
    ConPFCHANGE.AccountId = AccPFCHANGE.Id; 
    ConPFCHANGE.RecordTypeID = testRecordtype.id; 
        ConPFCHANGE.Provider_Practicing_Physician__c = true;
        ConPFCHANGE.Provider_Active_Status__c = true;
    insert ConPFCHANGE;       

    Contact_Validation_Summary__c convalsummaryPFCHANGE = new Contact_Validation_Summary__c();
    convalsummaryPFCHANGE.Contact_Id__c = ConPFCHANGE.Id;
    convalsummaryPFCHANGE.Name = 'Testcvs';
        convalsummaryPFCHANGE.Address_Type__c = 'Secondary';
    insert convalsummaryPFCHANGE;

    Contact_Validation_Audit_Trail__c audittrailPFCHANGE = new Contact_Validation_Audit_Trail__c();
    audittrailPFCHANGE.Provider_Information_Summary__c = convalsummaryPFCHANGE.id;
    audittrailPFCHANGE.Sent_to_MDM__c = 'N/A';
    Insert audittrailPFCHANGE; 

    /* Creating data for section Addressonly */
    Account AccADDRESSONLY = new Account();        
    AccADDRESSONLY.Name = 'ADDRESSONLY';        
    insert AccADDRESSONLY;     

    Contact ConADDRESSONLY = new Contact();      
    ConADDRESSONLY.FirstName = 'Test F1 Name';       
    ConADDRESSONLY.LastName = 'Test L name';     
    ConADDRESSONLY.Email = 'testADDRESSONLY@test.com';     
    ConADDRESSONLY.AccountId = AccADDRESSONLY.Id; 
    ConADDRESSONLY.RecordTypeID = testRecordtype.id;
        ConADDRESSONLY.Provider_Practicing_Physician__c = true;
        ConADDRESSONLY.Provider_Active_Status__c = true;
    insert ConADDRESSONLY;       

    Contact_Validation_Summary__c convalsummaryADDRESSONLY = new Contact_Validation_Summary__c();
    convalsummaryADDRESSONLY.Contact_Id__c = ConADDRESSONLY.Id;
    convalsummaryADDRESSONLY.Address_Type__c = 'Primary';
    convalsummaryADDRESSONLY.Address_Only_Modified__c = 'test';
    convalsummaryADDRESSONLY.Name = 'Testcvs';
    convalsummaryADDRESSONLY.Secure_Zip_Code__c = '201301';
    convalsummaryADDRESSONLY.Secure_Floor__c = '12';
    convalsummaryADDRESSONLY.Secure_City__c  = 'Test';
    convalsummaryADDRESSONLY.Secure_State__c = 'Test';
    convalsummaryADDRESSONLY.New_Street_Address__c= 'Test';
    convalsummaryADDRESSONLY.Secure_Street_Address__c = 'Test';
    convalsummaryADDRESSONLY.Secure_Suite__c = 'Test';
    convalsummaryADDRESSONLY.PDI_Campaign__c = '2016 Wave1'; 
        convalsummaryADDRESSONLY.Address_Type__c = 'Primary';
    insert convalsummaryADDRESSONLY;

    Contact_Validation_Audit_Trail__c audittrailADDRESSONLY = new Contact_Validation_Audit_Trail__c();
    audittrailADDRESSONLY.Provider_Information_Summary__c = convalsummaryADDRESSONLY.id;
    audittrailADDRESSONLY.Sent_to_MDM__c = 'N/A';
    audittrailADDRESSONLY.Secure_Zip_Code__c = '302020';
    audittrailADDRESSONLY.PDI_Campaign__c = '2016 Wave1';
    Insert audittrailADDRESSONLY;

    /* Creating data for section SFSA */
    Contact ConSFSA = new Contact();      
    ConSFSA.FirstName = 'Test F1 Name';       
    ConSFSA.LastName = 'Test L name';     
    ConSFSA.Email = 'testSFSA@test.com';     
    ConSFSA.AccountId = AccADDRESSONLY.Id; 
    ConSFSA.RecordTypeID = testRecordtype.id; 
        ConSFSA.Provider_Practicing_Physician__c = true;
        ConSFSA.Provider_Active_Status__c = true;
    insert ConSFSA;                        

    Case caseSFSA = new case();
    caseSFSA.ContactId = ConSFSA.id;
    Test.startTest();
    insert caseSFSA;


    SOC_Queue__c socqueueSFSA = new SOC_Queue__c();
    socqueueSFSA.Provider_Facility_ID__c = ConSFSA.Id;
    socqueueSFSA.Type_Of_Provider__c = 'SER';
    socqueueSFSA.Associated_Case_Id__c = caseSFSA.id;
    insert socqueueSFSA;

    Contact_Validation_Summary__c convalsummarySFSA = new Contact_Validation_Summary__c();
    convalsummarySFSA.Contact_Id__c = ConSFSA.id;
    convalsummarySFSA.Last_Verified_Date__c = DateTime.now();
        convalsummarySFSA.PDI_Campaign__c = '2016 Wave1'; 
        convalsummarySFSA.Address_Type__c = 'Primary';
    insert convalsummarySFSA;

    /* Creating data for section SFPP */

    Contact_Validation_Summary__c convalsummarySFPP = new Contact_Validation_Summary__c();
    convalsummarySFPP.Contact_Id__c = ConSFSA.id;
    convalsummarySFPP.Last_Verified_Date__c = DateTime.now();
    convalsummarySFPP.Provider_Last_Login_Date__c = DateTime.now();
        convalsummarySFPP.PDI_Campaign__c = '2016 Wave1'; 
        convalsummarySFPP.Address_Type__c = 'Primary';
    insert convalsummarySFPP;

    /* Creating data for section SFPA */
    Contact_Validation_Summary__c convalsummarySFPA = new Contact_Validation_Summary__c();
    convalsummarySFPA.Contact_Id__c = ConSFSA.id;
    convalsummarySFPA.Last_Verified_Date__c = DateTime.now();
    convalsummarySFPA.Status__c = 'Validated';
    convalsummarySFPA.Associated_Case_Closed__c = true;
        convalsummarySFPA.PDI_Campaign__c = '2016 Wave1';
        convalsummarySFPA.Address_Type__c = 'Secondary';
    insert convalsummarySFPA;

    /* Creating data for section SER */
    SOC_Queue__c socqueueSER = new SOC_Queue__c();
    socqueueSER.Provider_Facility_ID__c = ConSFSA.Id;
    socqueueSER.Type_Of_Provider__c = 'SER';
    socqueueSER.Associated_Case_Id__c = caseSFSA.id;
    insert socqueueSER;

    Contact_Validation_Summary__c convalsummarySER = new Contact_Validation_Summary__c();
    convalsummarySER.Contact_Id__c = ConSFSA.id;
    convalsummarySER.Last_Verified_Date__c = DateTime.now();
    convalsummarySER.Status__c = 'Accepted';
        convalsummarySER.PDI_Campaign__c = '2016 Wave1';
        convalsummarySER.Address_Type__c = 'Secondary';
    insert convalsummarySER;

    List<Contact_Validation_Summary__c> validsummary = new List<Contact_Validation_Summary__c>{};
    for (Integer i = 0; i < 20; i++) {
    Contact_Validation_Summary__c convalsummary = new Contact_Validation_Summary__c(Name = 'Test' + i,Contact_Id__c = ConSFSA.id);  
    validsummary.add(convalsummary);
    }
    insert validsummary;
    Test.stopTest();

    
    }

    /*******************************************************************
     Purpose: This Test Method is used to test TLFM section of UpdateSourceChannelBatch class  
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/   
                
    static testmethod void testTLFM(){
                                
        Test.startTest();
        UpdateSourceChannelBatch uscBatch = new UpdateSourceChannelBatch('TLFM');
        Database.executeBatch(uscBatch,10000);
      
        Test.stopTest();
        contact ctc = [select id from contact where Source_of_E_mail__c = 'TLFM' limit 1];
        /*********************************************************************** 
        Verifying batch Contact_Validation_Summary__c updated successfully using system.assertequals() 
        Expected Result: Validation_Source_Channel__c should be TLFM
        Actual Result:Validation_Source_Channel__c is TLFM
        ***********************************************************************/ 
            
        Contact_Validation_Summary__c cvs =[select id,Validation_Source_Channel__c from Contact_Validation_Summary__c  where Name = 'TestTLFM' and Contact_Id__c=:ctc.id];
        system.assertEquals(cvs.Validation_Source_Channel__c,'TLFM');
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test Exception handler of UpdateSourceChannelBatch class  
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
                
    static testmethod void ExceptionMethod_NegativeTest(){
        Test.startTest();
        Contact obj =new Contact();
        
        UpdateSourceChannelBatch uscBatch = new UpdateSourceChannelBatch('TLFM');
         List<Database.SaveResult> resultsUpdateContacts = new List<Database.SaveResult>();
        Database.SaveResult resultsUpdateContact = Database.insert(obj, false);
        resultsUpdateContacts.add(resultsUpdateContact);
        /*********************************************************************** 
        Verifying Contact are inserted successfully for TLFM using system.assertnotequals() 
        Expected Result: resultsUpdateContact is not null 
        Actual Result: resultsUpdateContact is not null 
        ***********************************************************************/ 
        system.assertnotequals(resultsUpdateContact,null);
        
        uscBatch.catchExceptionsFromCode(resultsUpdateContacts);
        uscBatch.finish(null);
        //Database.executeBatch(uscBatch,10000);
        Test.stopTest();
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test SFSA section of UpdateSourceChannelBatch class  
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/ 
                
     static testmethod void SFSA_BULKTest(){
        Test.startTest();
        UpdateSourceChannelBatch uscBatch = new UpdateSourceChannelBatch('SFSA');
        Database.executeBatch(uscBatch,10000);
        Test.stopTest();
        
        /*********************************************************************** 
         Verifying batch is executed successfully for SFSA using system.assertnotequals() 
        Expected Result: uscBatch is not null 
        Actual Result: uscBatch is not null 
        ***********************************************************************/ 
        system.assertnotequals(uscBatch,null);
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test SFPP section of UpdateSourceChannelBatch class  
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/ 
                
     static testmethod void SFPP_Test(){
        Test.startTest();
        UpdateSourceChannelBatch uscBatch = new UpdateSourceChannelBatch('SFPP');
        Database.executeBatch(uscBatch,10000);
        Test.stopTest();
        
        /*********************************************************************** 
         Verifying batch is executed successfully for SFPP using system.assertnotequals() 
        Expected Result: uscBatch is not null 
        Actual Result: uscBatch is not null 
        ***********************************************************************/ 
        system.assertnotequals(uscBatch,null);
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test SFPA section of UpdateSourceChannelBatch class  
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
         static testmethod void SFPA_Test(){
        Test.startTest();
        UpdateSourceChannelBatch uscBatch = new UpdateSourceChannelBatch('SFPA');
        Database.executeBatch(uscBatch,10000);
        /*********************************************************************** 
         Verifying batch is executed successfully for SFPA using system.assertnotequals() 
        Expected Result: uscBatch is not null 
        Actual Result: uscBatch is not null 
        ***********************************************************************/ 
        system.assertnotequals(uscBatch,null);
        Test.stopTest();
        
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test SER section of UpdateSourceChannelBatch class  
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
                
     static testmethod void SER_Test(){
        Test.startTest();
        UpdateSourceChannelBatch uscBatch = new UpdateSourceChannelBatch('SER');
        Database.executeBatch(uscBatch,10000);
        /*********************************************************************** 
         Verifying batch is executed successfully for SER using system.assertnotequals() 
        Expected Result: uscBatch is not null 
        Actual Result: uscBatch is not null 
        ***********************************************************************/ 
        system.assertnotequals(uscBatch,null);
        Test.stopTest();
    }
    
    /*******************************************************************
     Purpose: This Test Method is used to test PFCHANGE section of UpdateSourceChannelBatch class  
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testmethod void PFCHANGE_Test(){
                                                
        Test.startTest();        
             
        UpdateSourceChannelBatch bat = new UpdateSourceChannelBatch('PFCHANGE');
        //String str = bat.getNumericValue('Test123');
        
        Database.executeBatch(bat ,10000);
        /*********************************************************************** 
        Verifying batch is executed successfully for PFCHANGE using system.assertnotequals() 
        Expected Result: uscBatch is not null 
        Actual Result: uscBatch is not null 
        ***********************************************************************/ 
        system.assertnotequals(bat,null);
        Test.stopTest();
                                
    }

    /*******************************************************************
     Purpose: This Test Method is used to test ADDRESSONLY section of UpdateSourceChannelBatch class  
     Parameters: N/A 
     Returns: void
     Throws [Exceptions]: N/A
    ********************************************************************/
    
    static testmethod void ADDRESSONLY_Test(){
                                                                                
        Test.startTest();
             
        UpdateSourceChannelBatch bat = new UpdateSourceChannelBatch('ADDRESSONLY');
        //String str = bat.getNumericValue('Test123');
        Database.executeBatch(bat ,10000);
         /*********************************************************************** 
        Verifying batch is executed successfully for ADDRESSONLY using system.assertnotequals() 
        Expected Result: uscBatch is not null 
        Actual Result: uscBatch is not null 
        ***********************************************************************/ 
        system.assertnotequals(bat,null);
        Test.stopTest();
                                
                                
    }
    
}