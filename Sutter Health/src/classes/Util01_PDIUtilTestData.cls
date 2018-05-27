/*****************************************************
Class Name: Util01_PDIUtilTestData
Created By: Nagarjuna Kaipu
Created Date: 24/05/2016
Description: This class is used PDI test methods creation to insert test data for code coverage.
*****************************************************/
public class Util01_PDIUtilTestData
{
    public static Account testAccount;
    public static Contact testContact;
    public static PDI_Campaign_History__c testCampaignHistory;
    public static List<Contact> testContactList = new List<Contact>();
    public static List<Contact_Validation_Summary__c> testContactSummaryList = new List<Contact_Validation_Summary__c>();
    public static List<User> PDIUsers = new List<User>();
    public static UserRole portalRole;
    public static User integrationUser;
    
    public static User PDITestUser(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='Account Executive'].Id;
        User PDIUser = new User(Alias = 'RunAs', Email='PDIRunAsUser@test.com', 
                                LastName='RunAsTest', ProfileId = profileId, UserName='PDIRunAsUser@test.com', 
                                EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert PDIUser;
        return PDIUser;
    }
    public static User PDITestUser2(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='Account Executive'].Id;
        User PDIUser = new User(Alias = 'RunAs2', Email='PDIRunAsUser2@test.com', 
                                LastName='RunAsTest', ProfileId = profileId, UserName='PDIRunAsUser2@test.com', 
                                EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert PDIUser;
        return PDIUser;
    }
    public static List<User> createPDIAgents(){
        Id profileId = [SELECT Id FROM Profile WHERE Name='SOC' OR Name = 'PDI' LIMIT 1].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='Account Executive'].Id;
        for(Integer i = 1; i<=15; i++)
        {
            User PDIAgent = new User(Alias = 'kaipu'+i, Email='PDIAgent@test.com'+i, 
                                     LastName='PDITest'+i, ProfileId = profileId, UserName='PDIAgent@test.com'+i, 
                                     EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', UserRoleId = uRole, isActive = true,
                                     LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
            PDIUsers.add(PDIAgent);
        }
        return PDIUsers;
    }      
    public static Account createAccount()
    {
        
        testAccount = new Account(Name = 'test Account');
        testAccount.RecordTypeId = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Account' AND Name = 'S3 Provider' Limit 1].Id;
        return testAccount;  
        
    }
    public static PDI_Campaign_History__c createCampaignHistory()
    {
        testCampaignHistory = new PDI_Campaign_History__c(Name = '2016 Wave1', Campaign_Initiator__c = userinfo.getName(), 
                                                          Start_Date_and_Time__c = System.now(), Campaign_Status__c = 'In Progress', 
                                                          Retired_Departed__c = false, End_Date_and_Time__c = System.now(), 
                                                          Resigned_From_Sutter__c= false, Inactive__c = false);
        return testCampaignHistory;
    }
    
    public static Contact createContact()
    {
        Id profileId = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='Account Executive'].Id;
        
        User PDIAdmin = new User(Alias = 'AdminT', Email='PDIAdminTestUser@test.com', 
                                 LastName='PDIAdminTestUser', ProfileId = profileId, UserName='PDIAdminTestUser@test.com', 
                                 EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', UserRoleId = uRole,
                                 LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert PDIAdmin;
        
        System.runAs(PDIAdmin)
        {        
            Account acc = createAccount();
            insert acc;
            
        }
        
        Account acc = [Select Id, Name from Account Where Name = 'test Account' Limit 1];
        Contact con = new Contact();
        con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
        con.Firstname = 'Test';
        con.LastName = 'ContactLastName';
        con.Email  = 'nagarjuna.kaipu@accenture.com';
        con.Provider_NPI__c = '45345';
        con.Provider_ID__c = '567544';
        con.Provider_Correspondence_Address__c = '9676561568';
        con.Provider_Active_Status__c = true;
        con.Provider_Active_Status_Date__c = system.today();
        con.Provider_Practicing_Physician__c = true;
        con.Provider_Type__c = 'External';
        con.AccountId = acc.id;
        return con;
    }
    public static List<Contact> createContacts()
    {
        Id profileId = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='Account Executive'].Id;
        
        User PDIAdmin = new User(Alias = 'AdminT', Email='PDIAdminTestUser@test.com', 
                                 LastName='PDIAdminTestUser', ProfileId = profileId, UserName='PDIAdminTestUser@test.com', 
                                 EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', UserRoleId = uRole,
                                 LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert PDIAdmin;
        
        System.runAs(PDIAdmin)
        {        
            Account acc = createAccount();
            insert acc;
            
        }
        
        Account acc = [Select Id, Name from Account Where Name = 'test Account' Limit 1];
        for(Integer i = 1; i <= 10; i++)
        {
            Contact con = new Contact();
            con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
            con.Firstname = 'Test';
            con.LastName = 'LastNameP' + i;
            con.Email  = 'testEmail@test.com'+i;
            con.Provider_NPI__c = '12345';
            con.Provider_ID__c = '343545';
            con.Provider_Active_Status__c = true;
            con.Provider_Active_Status_Date__c = system.today();
            con.Provider_Practicing_Physician__c = true;
            con.Provider_Type__c = 'External';
            con.Provider_Communication_Preferences_HIM__c = 'Printed Letter';
            con.AccountId = acc.Id;
            testContactList.add(con);
        }
        return testContactList;
    }
    
    public static List<Contact_Validation_Summary__c> createSummaryRecords()
    {
        Id profileId = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='Account Executive'].Id;
        
        User PDIAdmin2 = new User(Alias = 'AdminT22', Email='PDIAdminTestUser22@test.com', 
                                  LastName='PDIAdminTestUser22', ProfileId = profileId, UserName='PDIAdminTestUser22@test.com', 
                                  EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', UserRoleId = uRole,
                                  LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert PDIAdmin2;
        
        List<Contact> contactList = createContacts();
        System.runAs(PDIAdmin2)
        {        
            
            insert contactList;
            
            
            for(contact c: contactList)
            {
                Contact_Validation_Summary__c summaryRecord = new Contact_Validation_Summary__c(
                    Provider_Name__c = c.LastName, Email__c = c.Email, Address_Type__c = 'Primary', Contact_Id__c = c.Id,
                    Practicing_Physician__c = true, Resigned_From_Sutter__c = false, Retired_Departed__c = false, 
                    PDI_Campaign__c = '2015 Phase', Tech_Is_Campaign_Done__c = false);
                testContactSummaryList.add(summaryRecord);
            }
        }
        return testContactSummaryList;
    }
    public static PDIAutoAssignCriteria__c PDIAutoAssignCriteriaFieldValues()
    {
        PDIAutoAssignCriteria__c autoAssignFieldVal = 
            new PDIAutoAssignCriteria__c(Name = Label.CL213_AutoAssignFieldValues, 
                                         Assign_Based_On__c = 'Provider_FirstName__c;Provider FirstName,Provider_LastName__c;Provider LastName,Provider_NPI_F__c;Provider NPI,Tech_Last_Verified_Date__c;Last Verified Date', Sorting_Order__c = 'Asc,Desc');
        return autoAssignFieldVal;
    }
    public static PDIAutoAssignSelectedCriteria__c PDIAutoAssignSelectedCriteria()
    {
        PDIAutoAssignSelectedCriteria__c autoAssignFieldVal = 
            new PDIAutoAssignSelectedCriteria__c(Name = Label.CL201_AutoAssignSelectedCriteria, 
                                                 Assign_Based_On__c = 'Provider_LastName__c', Record_Count_Per_Agent__c = 2, Sorting_Order__c = 'Asc');
        return autoAssignFieldVal;
    }
    
    public static String testFAQData(){
        String articleBody = null; 
        articleBody  = '<h1>Sutter Provider Hub--Frequently Asked Questions (FAQ)</h1>'+
            '<br><u><b>Section1 Data Collection Rationale</b></u>'+
            '<ul><li>S1Q1 Why am I being asked to validate my contact information?</li></ul>'+
            'S1Q1A1 Ensuring the accuracy of your contact information is critical to preventing misrouting of'+ 'sensitive clinical patient data. We want to ensure that the protected health information (PHI) you for your patients is always delivered to the appropriate destination.<br>'+ 
            '<ul><li>S1Q2 Why is my mobile phone number required?</li></ul>'+
            'S1Q2A2 Mobile phone numbers are being requested for future projects where information may be '+  'providers via text message.<br> <br><u><b>Section2 Access</b></u><br>'+ 
            '<ul><li>S2Q1 Who will have access to this information?</li></ul>'+
            'S2Q1A1 Validated information is for internal use only, and will be shared selectively with clinical'+ 'applications which send out patient information. None of the information currently being collected'+ 'be accessible by patients.<br>'+
            '<ul><li>S2Q2 Will you share my email address with anyone?</li></ul>'+
            'S2Q2A2 Email addresses will be shared with the Credentials Verification Office (CVO) and Epic in cases where the provider wishes to have chart deficiency notifications go to email.<br>'+ 
            '<ul><li>S2Q3 Can you confirm that this portal is for providers and not patients?</li></ul>'+
            'S2Q3A3 Patients will never have access to this portal, nor to any of the information contained within it.<br> <br><u><b>Section3 Technical</b></u><br>' +
            '<ul><li>S3Q1 Should office phone be my main office number or my personal back line?</li></ul>' +
            'S3Q1A1 In general it is best to provide a number where someone will answer 24/7, so in most cases'+
            ' main practice number is the most appropriate phone to provide.<br>'+ 
            '<ul><li>S3Q2 What if I have two offices, or if I have my business correspondence go to a different than patient information?</li></ul>'+
            'S3Q2A2 At this point, we are asking all providers to specify one primary set of contact information'+ 'transmission of patient information.   For some providers, this will be the same as their business'+ 'correspondence.  In the future, we plan to expand the portal to allow providers to specify multiple of contact information.<br>'+ 
            '<ul><li>S3Q3 What if I want to change the email address you have on file?</li></ul>'+
            'S3Q3A3 Simply log in and change the address.  Going forward, all validation messages will go'+ 'to the new address.<br>'+ 
            '<ul><li>S3Q4 Can I change my user name?</li></ul>'+
            'S3Q4A4 At this time, we do not allow for changing of the user name.  However, this is being'+ 'considered'+ 'as a future enhancement.<br>'+ 
            '<ul><li>S3Q5 I don’t have a fax number.  What do I enter in the field?</li></ul>'+
            'S3Q5A5 We plan to have an opt-out check box for this field in the near future.  In the meantime, you'+ 'may satisfy the field requirement by entering a set of fictitious numbers (111-111-1111).'+
            'Our central hub will filter this out and not transmit it to downstream applications.<br>'+ 
            '<ul><li>S4Q1 What if I no longer work with Sutter Health or am retired?</li></ul>'+
            'S4Q1A1 Please select the appropriate provider status within the portal.<br>'+
            '<ul><li>S4Q2 I am not a Sutter doctor.  Do I still have to do this?</li></ul>'+
            'S4Q2A2 If any of your patients may possibly be seen at a Sutter Health facility, or if there is any'+ 'chance of you receiving patient health information from Sutter Health, you should complete this'+ 'validation.  You do not have to be employed by Sutter or be a referring Sutter physician for this to'+ 'be applicable and valuable to you.<br>'+ 
            '<ul><li>S4Q3 I am a practice manager and not an MD.  Can I still complete this?</li></ul>'+
            'S4Q3A3 Practice managers can in theory complete the online validation.  However, we ask that the '+ 'address associated with the provider profile be an address specific to that provider.  This prevents'+ 'confusion if/when a provider leaves a particular practice. In the near future, we will be '+  'administrator console which will allow delegates to complete validation on a provider’s behalf.<br>'+ 
            '<ul><li>S4Q4 Can someone just call my office to confirm?</li></ul>'+
            'S4Q4A4 We are encouraging all providers to complete this process online.<br> <br>';
        
        return articleBody;
    }
    
    public static List<Contact_Validation_Summary__c> createDuplicatePhoneSummaryRecords()
    {
        Id profileId = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='Account Executive'].Id;
        
        User PDIAdmin2 = new User(Alias = 'AdminT22', Email='PDIAdminTestUser22@test.com', 
                                  LastName='PDIAdminTestUser22', ProfileId = profileId, UserName='PDIAdminTestUser22@test.com', 
                                  EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', UserRoleId = uRole,
                                  LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert PDIAdmin2;
        
        CreatedDate__c createdDate = insertCreatedDateCustSetting();
        List<Contact> contactList = create_Validated_Contact();
        System.runAs(PDIAdmin2)
        {        
            
            testContactSummaryList = [select id, Provider_Name__c, PDI_Campaign__c, Secure_Phone__c from Contact_Validation_Summary__c where Contact_Id__c IN: contactList];
            
        }
        return testContactSummaryList;
    }
    
    public static List<Contact> CreateDupPhoneContacts(){
        Account acc = Util01_PDIUtilTestData.createAccount();
        List<contact> cList = new List<contact>();
        for(Integer i = 0; i<20; i++){
            contact c = new contact();
            c.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
            c.FirstName = 'Nagarjuna';
            c.LastName = 'Test'+i;
            c.Email = 'nagarjuna@kapu'+i+'.com';
            c.Provider_Practicing_Physician__c = true;
            c.Provider_Retired_Departed__c = false;
            c.Provider_Resigned_From_Sutter__c = false;
            c.Provider_Active_Status__c = true;
            c.Provider_Active_Status_Date__c = system.today();
            c.Provider_Correspondence_Phone__c = '9676561568';
            c.MobilePhone = '9654325678';
            c.Phone = '9756454567';
            c.Provider_NPI__c = '1234';
            c.Provider_License_Number__c = '76589';
            c.Provider_License_State__c = 'CA';
            c.Provider_ID__c = '098765';
            c.Provider_Type__c = 'External';
            c.Deficiency_Provider__c = true;
            c.Provider_Portal_Last_Validation_Date__c = system.today();
            c.Provider_Admin_Assistant__c = 'naga admin';
            c.Provider_Admin_Assistant_Email__c = 'naga@admin.com';
            c.Provider_Admin_Assistant_Title__c = 'mr';
            c.Provider_Admin_Assistant_Phone__c = '9645343456';
            c.Provider_Delegate_Phone_Ext__c = '4567';
            c.Provider_Communication_Preferences_HIM__c = 'InBasket-Letter';
            c.Provider_Correspondence_Address__c = '123';
            c.Provider_Correspondence_City__c = 'Hyderabad';
            c.Provider_Correspondence_State__c = 'CA';
            c.Provider_Correspondence_PostalCode__c = '52311';
            c.Provider_Correspondence_Fax_Number__c = '9675658769';
            cList.add(c);
        }
        return cList;
    }    
    
    public static List<Contact> CreateDupPhoneInActiveContacts(){
        Account acc = Util01_PDIUtilTestData.createAccount();
        List<contact> cList = new List<contact>();
        for(Integer i = 0; i<20; i++){
            contact c = new contact();
            c.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
            c.FirstName = 'Nagarjuna';
            c.LastName = 'Test'+i;
            c.Email = 'nagarjuna@kapu'+i+'.com';
            c.Provider_Practicing_Physician__c = false;
            c.Provider_Retired_Departed__c = false;
            c.Provider_Resigned_From_Sutter__c = true;
            c.Provider_Active_Status__c = true;
            c.Provider_Active_Status_Date__c = system.today();
            c.Provider_Correspondence_Phone__c = '9676561555';
            c.MobilePhone = '9654325678';
            c.Phone = '9756454567';
            c.Provider_NPI__c = '1234';
            c.Provider_License_Number__c = '76589';
            c.Provider_License_State__c = 'CA';
            c.Provider_ID__c = '098765';
            c.Provider_Type__c = 'External';
            c.Deficiency_Provider__c = true;
            c.Provider_Portal_Last_Validation_Date__c = system.today();
            c.Provider_Admin_Assistant__c = 'naga admin';
            c.Provider_Admin_Assistant_Email__c = 'naga@admin.com';
            c.Provider_Admin_Assistant_Title__c = 'mr';
            c.Provider_Admin_Assistant_Phone__c = '9645343456';
            c.Provider_Delegate_Phone_Ext__c = '4567';
            c.Provider_Correspondence_Address__c = '123';
            c.Provider_Correspondence_City__c = 'Hyderabad';
            c.Provider_Correspondence_State__c = 'CA';
            c.Provider_Correspondence_PostalCode__c = '52311';
            c.Provider_Correspondence_Fax_Number__c = '9675658769';
            cList.add(c);
        }
        return cList;
    }  
    
    /**
* @author Nagarjuna Kaipu
* @date 11/28/2016
* @description This method is to create a Case of type 'Summary of Care' for EAF facilities
* @return Case
*/
    public static Case facilityInquiryCase()
    {
        Id facCaseRecTypeId = [Select Id, SobjectType, Name From RecordType Where Name=: Label.CL446_PDISummaryOfCareCaseRecType Limit 1].Id;
        Case facCase = new Case();
        facCase.RecordTypeId = facCaseRecTypeId;
        facCase.PDV_Contact_Name__c = 'nagarjuna';
        facCase.Contact_Number__c = 9676561568.00;
        facCase.Common_Subject_Lines__c = 'Validated the Facility Record';
        facCase.Origin = 'Outbound Call';
        facCase.Subject = 'Initiated';
        facCase.Status = 'New';
        return facCase;
    }
    
    /**
* @author Nagarjuna Kaipu
* @date 11/28/2016
* @description This method is to create eaf facility
* @return Case
*/
    public static PDV_EAF_Facility__c createEAFFacility()
    {
        PDV_EAF_Facility__c eafFac = new PDV_EAF_Facility__c();
        eafFac.Name = 'My Fac1';
        return eafFac;
    }
    
        /**
* @author Nagarjuna Kaipu
* @date 11/28/2016
* @description This method is to create list of eaf facilities
* @return Case
*/
    public static List<PDV_EAF_Facility__c> createEAFFacilityList()
    {
        List<PDV_EAF_Facility__c> facList = new List<PDV_EAF_Facility__c>();
        for(Integer i=0; i<=30; i++){
            PDV_EAF_Facility__c eafFac = new PDV_EAF_Facility__c();
            eafFac.Name = 'My Test'+i;
            eafFac.Facility_ID__c = 'abcd'+i;
            eafFac.PHONE__c = '(967) 656-1568';
            eafFac.FAX_NUMBER__c = '(967) 656-1568';
            eafFac.Address_Line_1__c = '1544 eureka road';
            eafFac.CITY__c = 'Roseville';
            eafFac.STATE__c = 'CA';
            eafFac.ZIP_CODE__c = '95630';
            eafFac.Tech_is_Facility_Updated__c = false;
            eafFac.Is_Address_Chagned__c = false;
            eafFac.Is_Address_Line_2_Changed__c = false;
            eafFac.Is_City_Changed__c = false;
            eafFac.Is_State_Changed__c = false;
            eafFac.Is_Zip_Code_Changed__c = false;
            eafFac.Is_Phone_Changed__c = false;
            eafFac.Is_Phone_Extension_Changed__c = false;
            eafFac.Is_Fax_Changed__c = false;
            eafFac.Tech_ByPass_Address_Verification__c = true;
            facList.add(eafFac);
        }
        return facList;
    }
    /* @author Nagarjuna Kaipu
* @date 11/28/2016
* @description This method is to create eaf facility
* @return EAF Audit
*/
    public static PDV_EAF_Validation_Audit_Trail__c createEAFAudit()
    {
        PDV_EAF_Validation_Audit_Trail__c eafAudit = new PDV_EAF_Validation_Audit_Trail__c();
        eafAudit.Name ='My Fac1';
        return eafAudit;
    }
     /* @author Nagarjuna Kaipu
* @date 11/28/2016
* @description This method is to create approval keywords
* @return PDIAdminAssistantApprovalKeywords__c list
*/
    public static List<PDIAdminAssistantApprovalKeywords__c> PDIApprovalKeyWords()
    {
        List<PDIAdminAssistantApprovalKeywords__c> appKeyWords = new List<PDIAdminAssistantApprovalKeywords__c>();
        for(Integer i = 0; i < 5; i++){
            PDIAdminAssistantApprovalKeywords__c appKey = new PDIAdminAssistantApprovalKeywords__c(); 
            if(i == 0){
                appKey.Name = 'APPROVED';
            }
            else if(i == 1){
                appKey.Name = 'APPROVES';
            }
            else if(i == 2){
                appKey.Name = 'APPROVE';
            }
            else if(i == 3){
                appKey.Name = 'YES';
            }
            else if(i == 4){
                appKey.Name = 'OK';
            }
            appKeyWords.add(appKey);
        }
        return appKeyWords;
    }
    
    /**
    * @author IDC team
    * @date 07/8/2015
    * @description This method creates validated provider contacts
    * @param 
    * @return 
    */
    public static Contact create_Validated_Provider_Contact(){
        
        Contact con = new Contact();
            con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
            con.Firstname = 'TestP';
            con.LastName = 'LastNameP';
            con.Provider_NPI__c = '1234';
            con.Provider_ID__c = '098765';
            con.Provider_Active_Status__c = true;
            con.Provider_Active_Status_Date__c = system.today();
            con.Provider_Practicing_Physician__c = true;
            con.Email = 'testcontact@email.com';
            con.Provider_Type__c = 'External';
            con.Provider_Portal_Last_Validation_Date__c = system.today();
            con.Provider_Admin_Assistant__c = 'test User';
            con.Preferred_Communication_Method__c = 'In Basket';
            con.Provider_Communication_Preferences_HIM__c = 'InBasket-Letter';
            con.Provider_Correspondence_City__c = 'testcity';
            con.Provider_Correspondence_State__c = 'CA';
            con.Provider_Correspondence_PostalCode__c = '56789';
            con.Provider_Correspondence_Phone__c = '3456789123';
            con.Provider_Correspondence_Fax_Number__c = '3456789123';
            
        return con;
    }
    
    public static CS_ManageProfile__c createManageProfileCustSetting(){
        CS_ManageProfile__c csprofile = new CS_ManageProfile__c();
        csprofile.Name = 'Communities_Provider';
        csprofile.Profile_Name__c = 'PDV Community Provider';
        insert csprofile;
        
        return csprofile;
    }
    
    public static CS_ManageProfile__c createAdminManageProfileCustSetting(){
        CS_ManageProfile__c csadminprofile = new CS_ManageProfile__c();
        csadminprofile.Name = 'Communities_AdminAssistant';
        csadminprofile.Profile_Name__c = 'PDI Community Admin Assistant';
       
        insert csadminprofile;
        return csadminprofile;
    }
    
    public static PDIPortalHomePage__c createPDIPortalHomePageCustSetting(){
        PDIPortalHomePage__c portalHomePage = new PDIPortalHomePage__c();
        portalHomePage.Name = '1.Sutter Network of Care';
        portalHomePage.DataValue1__c = 'testdata1';
        portalHomePage.DataValue2__c = 'testdata2';
        portalHomePage.Icon__c = 'fa fa-plus';
        insert portalHomePage;
        
    return portalHomePage;
    }
    
    /**
    * @author IDC team
    * @description This method creates test data for Provider Search custom setting record
    * @param 
    * @return 
    */
    public static PDIProviderSearch__c insertProviderSearchSetting(){
        
        PDIProviderSearch__c providerSearch = new PDIProviderSearch__c();
        providerSearch.Name = 'ProviderSearchFlag';
        providerSearch.Value__c = false;
        insert providerSearch;
        
        return providerSearch;
    }
    
    /**
    * @author IDC team
    * @description This method creates test data for Created Date custom setting record
    * @param 
    * @return 
    */
    public static PDICallCampaignEmail__c insertCallCampaignSetting(){
        
        PDICallCampaignEmail__c callCampaign = new PDICallCampaignEmail__c();
        callCampaign.Name = 'Email';
        callCampaign.Value__c = true;
        insert callCampaign;
        
        return callCampaign;
    }
    /**
    * @author Kishore jonnadula
    * @date 25/11/2016
    * @description This method create test data for PDIEmailAddressService custom setting.
    * @param 
    * @return PDIEmailAddressService__c
    */
    public static PDIEmailAddressService__c insertEmailAddressServiceSetting(){
        
        PDIEmailAddressService__c emailAddress = new PDIEmailAddressService__c();
        emailAddress.Content_Type__c = 'text/xml';
        emailAddress.Endpoint__c = 'http://ws.strikeiron.com/StrikeIron/emv6Hygiene';
        emailAddress.Host__c = 'ws.strikeiron.com';
        emailAddress.Name = 'EmailAddressService';
        emailAddress.Password__c = 'Informatica32';
        emailAddress.RequestMethod__c = 'POST';
        emailAddress.SoapAction__c = 'http://www.strikeiron.com/VerifyEmail';
        emailAddress.TimeOut__c = '90';
        emailAddress.UserName__c = 'sutterhealth@informatica.com1';
        
        insert emailAddress;
        
        return emailAddress;
    }
    
    /**
    * @author Kishore jonnadula
    * @date 25/11/2016
    * @description This method create test data for PDIAddressDoctorService custom setting.
    * @param 
    * @return PDIAddressDoctorService__c
    */
    public static PDIAddressDoctorService__c insertAddressServiceSetting(){
        
        PDIAddressDoctorService__c addressService = new PDIAddressDoctorService__c();
        addressService.Content_Type__c = 'text/xml';
        addressService.Endpoint__c = 'http://validator5.addressdoctor.com/webservice5/v2/addressvalidation.asmx';
        addressService.Host__c = 'validator5.addressdoctor.com';
        addressService.Name = 'AddressDoctorService';
        addressService.Password__c = 'SutHea4661232';
        addressService.RequestMethod__c = 'POST';
        addressService.SoapAction__c = 'http://validator5.AddressDoctor.com/Webservice5/v2/Process';
        addressService.ProcessMode__c = 'INTERACTIVE';
        addressService.UserName__c = 'sutterhealth@informatica.com1';
        
        insert addressService;
        
        return addressService;
    }
    
    /**
    * @author Kishore Jonnadula
    * @description This method creates test data for Address Element Status custom setting record
    * @param 
    * @return List<PDIAddressElementStatus__c>
    */
    public static List<PDIAddressElementStatus__c> insertAddressElementSetting(){
        
        List<PDIAddressElementStatus__c> eleStatusList = new List<PDIAddressElementStatus__c>();
        PDIAddressElementStatus__c addressEle = new PDIAddressElementStatus__c();
        addressEle.Name = '0';
        addressEle.Value__c = 'PostalCode0';
        eleStatusList.add(addressEle);
        PDIAddressElementStatus__c addressEle1 = new PDIAddressElementStatus__c();
        addressEle1.Name = '1';
        addressEle1.Value__c = 'PostalCode1';
        eleStatusList.add(addressEle1);
        PDIAddressElementStatus__c addressEle2 = new PDIAddressElementStatus__c();
        addressEle2.Name = '2';
        addressEle2.Value__c = 'Locality0';
        eleStatusList.add(addressEle2);
        PDIAddressElementStatus__c addressEle3 = new PDIAddressElementStatus__c();
        addressEle3.Name = '3';
        addressEle3.Value__c = 'Locality1';
        eleStatusList.add(addressEle3);
        PDIAddressElementStatus__c addressEle4 = new PDIAddressElementStatus__c();
        addressEle4.Name = '4';
        addressEle4.Value__c = 'Province0';
        eleStatusList.add(addressEle4);
        PDIAddressElementStatus__c addressEle5 = new PDIAddressElementStatus__c();
        addressEle5.Name = '5';
        addressEle5.Value__c = 'Province1';
        eleStatusList.add(addressEle5);
        PDIAddressElementStatus__c addressEle6 = new PDIAddressElementStatus__c();
        addressEle6.Name = '6';
        addressEle6.Value__c = 'Street0';
        eleStatusList.add(addressEle6);
        PDIAddressElementStatus__c addressEle7 = new PDIAddressElementStatus__c();
        addressEle7.Name = '7';
        addressEle7.Value__c = 'Street1';
        eleStatusList.add(addressEle7);
        PDIAddressElementStatus__c addressEle8 = new PDIAddressElementStatus__c();
        addressEle8.Name = '8';
        addressEle8.Value__c = 'HouseNumber0';
        eleStatusList.add(addressEle8);
        PDIAddressElementStatus__c addressEle9 = new PDIAddressElementStatus__c();
        addressEle9.Name = '9';
        addressEle9.Value__c = 'HouseNumber1';
        eleStatusList.add(addressEle9);
        PDIAddressElementStatus__c addressEle10 = new PDIAddressElementStatus__c();
        addressEle10.Name = '10';
        addressEle10.Value__c = 'deliveryService0';
        eleStatusList.add(addressEle10);
        PDIAddressElementStatus__c addressEle11 = new PDIAddressElementStatus__c();
        addressEle11.Name = '11';
        addressEle11.Value__c = 'deliveryService1';
        eleStatusList.add(addressEle11);
        PDIAddressElementStatus__c addressEle12 = new PDIAddressElementStatus__c();
        addressEle12.Name = '12';
        addressEle12.Value__c = 'building0';
        eleStatusList.add(addressEle12);
        PDIAddressElementStatus__c addressEle13 = new PDIAddressElementStatus__c();
        addressEle13.Name = '13';
        addressEle13.Value__c = 'building1';
        eleStatusList.add(addressEle13);
        PDIAddressElementStatus__c addressEle14 = new PDIAddressElementStatus__c();
        addressEle14.Name = '14';
        addressEle14.Value__c = 'SubBuilding0';
        eleStatusList.add(addressEle14);
        PDIAddressElementStatus__c addressEle15 = new PDIAddressElementStatus__c();
        addressEle15.Name = '15';
        addressEle15.Value__c = 'SubBuilding1';
        eleStatusList.add(addressEle15);
        insert eleStatusList;
        
        return eleStatusList;
    }
    /**
    * @author Kishore Jonnadula
    * @description This method creates test data for PDI Result Status Code custom setting record
    * @param 
    * @return List<PDIResultStatusCodes__c>
    */
    public static List<PDIResultStatusCodes__c> insertResultStatusCodesSetting(){
        List<PDIResultStatusCodes__c> resultStatusList = new List<PDIResultStatusCodes__c>();
        
        PDIResultStatusCodes__c resultStatus = new PDIResultStatusCodes__c();
        resultStatus.Name = 'F';
        resultStatus.value__c = 'Validated';
        
        resultStatusList.add(resultStatus);
        
        PDIResultStatusCodes__c resultStatus1 = new PDIResultStatusCodes__c();
        resultStatus1.Name = '8';
        resultStatus1.value__c = 'Validated';
        
        resultStatusList.add(resultStatus1);
        
        PDIResultStatusCodes__c resultStatus2 = new PDIResultStatusCodes__c();
        resultStatus2.Name = 'E';
        resultStatus2.value__c = 'Validated';
        
        resultStatusList.add(resultStatus2);
        
        PDIResultStatusCodes__c resultStatus3 = new PDIResultStatusCodes__c();
        resultStatus3.Name = '3';
        resultStatus3.value__c = 'InValid';
        
        resultStatusList.add(resultStatus3);
        
        PDIResultStatusCodes__c resultStatus4 = new PDIResultStatusCodes__c();
        resultStatus4.Name = '4';
        resultStatus4.value__c = 'Unchecked';
        
        resultStatusList.add(resultStatus4);
        
        PDIResultStatusCodes__c resultStatus5 = new PDIResultStatusCodes__c();
        resultStatus5.Name = '2';
        resultStatus5.value__c = 'Unchecked';
        
        resultStatusList.add(resultStatus5);
        insert resultStatusList;
        
        return resultStatusList;
    }
    /**
    * @author Kishore Jonnadula
    * @description This method creates test data for PDIADCorrectAddressCodes__c custom setting record
    * @param 
    * @return List<PDIADCorrectAddressCodes__c>
    */
    public static List<PDIADCorrectAddressCodes__c> insertCorrectAddressSetting(){
        List<PDIADCorrectAddressCodes__c> correstAddrList = new List<PDIADCorrectAddressCodes__c>();
        PDIADCorrectAddressCodes__c correctAddrCodes = new PDIADCorrectAddressCodes__c();
            correctAddrCodes.Name = 'C1';
            correctAddrCodes.Value__c = '';
        correstAddrList.add(correctAddrCodes);
        
        PDIADCorrectAddressCodes__c correctAddrCodes1 = new PDIADCorrectAddressCodes__c();
            correctAddrCodes1.Name = 'C2';
            correctAddrCodes1.Value__c = '';
        correstAddrList.add(correctAddrCodes1);
        
        PDIADCorrectAddressCodes__c correctAddrCodes2 = new PDIADCorrectAddressCodes__c();
            correctAddrCodes2.Name = 'C3';
            correctAddrCodes2.Value__c = '';
        correstAddrList.add(correctAddrCodes2);
        
        PDIADCorrectAddressCodes__c correctAddrCodes3 = new PDIADCorrectAddressCodes__c();
            correctAddrCodes3.Name = 'C4';
            correctAddrCodes3.Value__c = '';
        correstAddrList.add(correctAddrCodes3);
                
        insert correstAddrList;
        
        return correstAddrList;
    }
    /**
    * @author Kishore Jonnadula
    * @description This method creates test data for PDIADErrorCodes__c custom setting record
    * @param 
    * @return List<PDIADErrorCodes__c>
    */
    public static List<PDIADErrorCodes__c> insertErrorCodesSetting(){
        
        List<PDIADErrorCodes__c> errorCodeList = new List<PDIADErrorCodes__c>();
        PDIADErrorCodes__c errorCode = new PDIADErrorCodes__c();
        errorCode.Name = 'I1';
        errorCode.Value__c = '';
        errorCodeList.add(errorCode);
        
        PDIADErrorCodes__c errorCode1 = new PDIADErrorCodes__c();
        errorCode1.Name = 'I2';
        errorCode1.Value__c = '';
        errorCodeList.add(errorCode1);
        
        PDIADErrorCodes__c errorCode2 = new PDIADErrorCodes__c();
        errorCode2.Name = 'I4';
        errorCode2.Value__c = '';
        errorCodeList.add(errorCode2);
                
        insert errorCodeList;
        
        return errorCodeList;
    }
    
    /**
    * @author Kishore Jonnadula
    * @description This method creates test data for PDIADVerificationCodes__c custom setting record
    * @param 
    * @return List<PDIADVerificationCodes__c>
    */
    public static List<PDIADVerificationCodes__c> insertverifyAddressCodesSetting(){
        List<PDIADVerificationCodes__c> verifyAddrList = new List<PDIADVerificationCodes__c>();
        PDIADVerificationCodes__c verifyAddrCodes = new PDIADVerificationCodes__c();
            verifyAddrCodes.Name = 'V1';
            verifyAddrCodes.Value__c = '';
        verifyAddrList.add(verifyAddrCodes);
        
        PDIADVerificationCodes__c verifyAddrCodes1 = new PDIADVerificationCodes__c();
            verifyAddrCodes1.Name = 'V2';
            verifyAddrCodes1.Value__c = '';
        verifyAddrList.add(verifyAddrCodes1);
        
        PDIADVerificationCodes__c verifyAddrCodes2 = new PDIADVerificationCodes__c();
            verifyAddrCodes2.Name = 'V3';
            verifyAddrCodes2.Value__c = '';
        verifyAddrList.add(verifyAddrCodes2);
        
        PDIADVerificationCodes__c verifyAddrCodes3 = new PDIADVerificationCodes__c();
            verifyAddrCodes3.Name = 'V4';
            verifyAddrCodes3.Value__c = '';
        verifyAddrList.add(verifyAddrCodes3);
                
        insert verifyAddrList;
        
        return verifyAddrList;
    }
    
     /**
    * @author Kishore Jonnadula
    * @description This method creates test data for PDIEmailStatusCodes__c custom setting record
    * @param 
    * @return List<PDIEmailStatusCodes__c>
    */
    public static List<PDIEmailStatusCodes__c> insertemailStatusCodesSetting(){
        List<PDIEmailStatusCodes__c> emailStatusList = new List<PDIEmailStatusCodes__c>();
        PDIEmailStatusCodes__c emailStatusCodes = new PDIEmailStatusCodes__c();
            emailStatusCodes.Name = '220';
            emailStatusCodes.Value__c = 'Analytics in Progress';
        emailStatusList.add(emailStatusCodes);
        
        PDIEmailStatusCodes__c emailStatusCodes1 = new PDIEmailStatusCodes__c();
            emailStatusCodes1.Name = '260';
            emailStatusCodes1.Value__c = 'Domain Confirmed. Potentially Dangerous.';
        emailStatusList.add(emailStatusCodes1);
        
        PDIEmailStatusCodes__c emailStatusCodes2 = new PDIEmailStatusCodes__c();
            emailStatusCodes2.Name = '300';
            emailStatusCodes2.Value__c = 'Email Not Valid.';
        emailStatusList.add(emailStatusCodes2);
        
        PDIEmailStatusCodes__c emailStatusCodes3 = new PDIEmailStatusCodes__c();
            emailStatusCodes3.Name = '400';
            emailStatusCodes3.Value__c = 'Invalid Input.';
        emailStatusList.add(emailStatusCodes3);
                
        insert emailStatusList;
        
        return emailStatusList;
    }
    
    /**
    * @author Kishore Jonnadula
    * @description This method creates test data for PDIADNotProcessedCodes__c custom setting record
    * @param 
    * @return List<PDIADNotProcessedCodes__c>
    */
    public static List<PDIADNotProcessedCodes__c> insertADNotProcessedCodesSetting(){
        List<PDIADNotProcessedCodes__c> notProccessedAddrList = new List<PDIADNotProcessedCodes__c>();
        PDIADNotProcessedCodes__c notProcessedAddrCodes = new PDIADNotProcessedCodes__c();
            notProcessedAddrCodes.Name = 'N1';
            notProcessedAddrCodes.Code__c = 'Informatica Address Verification could not recognize the country and hence could not validate the address';
        notProccessedAddrList.add(notProcessedAddrCodes);
        
        PDIADNotProcessedCodes__c notProcessedAddrCodes1 = new PDIADNotProcessedCodes__c();
            notProcessedAddrCodes1.Name = 'N2';
            notProcessedAddrCodes1.Code__c = 'Informatica Address Verification could not validate the address because the corresponding reference database was not available.';
        notProccessedAddrList.add(notProcessedAddrCodes1);
        
        PDIADNotProcessedCodes__c notProcessedAddrCodes2 = new PDIADNotProcessedCodes__c();
            notProcessedAddrCodes2.Name = 'N3';
            notProcessedAddrCodes2.Code__c = 'Unable to validate the address because the single-line address verification is not supported for the destination country';
        notProccessedAddrList.add(notProcessedAddrCodes2);
        
        insert notProccessedAddrList;
        
        return notProccessedAddrList;
    }
    
    /**
    * @author Kishore Jonnadula
    * @description This method creates test data for PDIADWebServiceStatusCodes__c custom setting record
    * @param 
    * @return List<PDIADWebServiceStatusCodes__c>
    */
    public static List<PDIADWebServiceStatusCodes__c> insertADWebServiceStatusSetting(){
        List<PDIADWebServiceStatusCodes__c> webServiceCodesList = new List<PDIADWebServiceStatusCodes__c>();
        PDIADWebServiceStatusCodes__c webServiceStatusCodes = new PDIADWebServiceStatusCodes__c();
            webServiceStatusCodes.Name = 'W1';
            webServiceStatusCodes.Code__c = 'Not allowed - No transactions available for the specified country';
        webServiceCodesList.add(webServiceStatusCodes);
        
        PDIADWebServiceStatusCodes__c webServiceStatusCodes1 = new PDIADWebServiceStatusCodes__c();
            webServiceStatusCodes1.Name = 'W7';
            webServiceStatusCodes1.Code__c = 'Input error';
        webServiceCodesList.add(webServiceStatusCodes1);
        
        PDIADWebServiceStatusCodes__c webServiceStatusCodes2 = new PDIADWebServiceStatusCodes__c();
            webServiceStatusCodes2.Name = 'W8';
            webServiceStatusCodes2.Code__c = 'Timeout - Address was not processed';
        webServiceCodesList.add(webServiceStatusCodes2);
        
        insert webServiceCodesList;
        
        return webServiceCodesList;
    }
    
    /**
    * @author Kishore Jonnadula
    * @description This method creates test data for PDIADStatusCodes__c custom setting record
    * @param 
    * @return List<PDIADStatusCodes__c>
    */
    public static List<PDIADStatusCodes__c> insertADHttpSatusCodesSetting(){
        List<PDIADStatusCodes__c> httpRespStatusCodesList = new List<PDIADStatusCodes__c>();
        PDIADStatusCodes__c httpRespStatusCodes = new PDIADStatusCodes__c();
            httpRespStatusCodes.Name = '100';
            httpRespStatusCodes.Status_Message__c = 'OK';
        httpRespStatusCodesList.add(httpRespStatusCodes);
        
        PDIADStatusCodes__c httpRespStatusCodes1 = new PDIADStatusCodes__c();
            httpRespStatusCodes1.Name = '200';
            httpRespStatusCodes1.Status_Message__c = 'Parameters must be supplied';
        httpRespStatusCodesList.add(httpRespStatusCodes1);
        
        PDIADStatusCodes__c httpRespStatusCodes2 = new PDIADStatusCodes__c();
            httpRespStatusCodes2.Name = '205';
            httpRespStatusCodes2.Status_Message__c = 'Invalid value for parameter FormatDelimiter value';
        httpRespStatusCodesList.add(httpRespStatusCodes2);
        
        insert httpRespStatusCodesList;
        
        return httpRespStatusCodesList;
    }
    
    /**
    * @author Kishore Jonnadula
    * @description This method creates test data Provider Address
    * @param 
    * @return void
    */
    public static void insertProviderAddressList(String summaryId, String contactId)
    {
        List<Provider_Address__c> providerAddressList = new List<Provider_Address__c>();
        Provider_Address__c provAddress = new  Provider_Address__c ();
        provAddress.Address_Line1__c = '2300 iron point Rd';
        provAddress.Address_Line_2__c = 'apt 111';
        provAddress.City__c = 'folsom';
        provAddress.State__c = 'CA';
        provAddress.Zip_Code__c = '95630';
        provAddress.Secure_Phone__c = '19991239997';
        provAddress.Secure_Fax__c = '(999) 123-9997';
        provAddress.Address_Type__c = Label.CL303_PDIPrimary;
        provAddress.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
        provAddress.Contact_Id__c = contactId;
        provAddress.Summary_Id__c = summaryId;
        
        providerAddressList.add(provAddress);
        
        Provider_Address__c provAddress1 = new  Provider_Address__c ();
        provAddress1.Address_Line1__c = '1400 a street';
        provAddress1.Address_Line_2__c = 'apt 129';
        provAddress1.City__c = 'sacramento';
        provAddress1.State__c = 'CA';
        provAddress1.Zip_Code__c = '99511';
        provAddress1.Secure_Phone__c = '(999) 123-9998';
        provAddress1.Secure_Fax__c = '(999) 123-9998';
        provAddress1.Address_Type__c = Label.CL359_PDI_secondaryAddress;
        provAddress1.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
        provAddress1.Contact_Id__c = contactId;
        provAddress1.Summary_Id__c = summaryId;
        
        providerAddressList.add(provAddress1);
        
        Provider_Address__c provAddress2 = new  Provider_Address__c ();
        provAddress2.Address_Line1__c = '1402 a street';
        provAddress2.Address_Line_2__c = 'apt 129';
        provAddress2.City__c = 'sacramento';
        provAddress2.State__c = 'CA';
        provAddress2.Zip_Code__c = '99511';
        provAddress2.Secure_Phone__c = '(999) 123-9998';
        provAddress2.Secure_Fax__c = '(999) 123-9998';
        provAddress2.Address_Type__c = Label.CL359_PDI_secondaryAddress;
        provAddress2.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
        provAddress2.Contact_Id__c = contactId;
        provAddress2.Summary_Id__c = summaryId;
        provAddress2.EPIC_Address_Status__c = 'Inactive';
        
        providerAddressList.add(provAddress2);
        
        insert providerAddressList;
    }

    /**
    * @author Kishore Jonnadula
    * @description This method creates test Audit record for summary record.
    * @param 
    * @return void
    */
    public static void insertAuditRecordforSummary(String contactId)
    {
        Contact_Validation_Audit_Trail__c auditObj = new Contact_Validation_Audit_Trail__c();
        auditObj.Serial_Number__c = '0';
        auditObj.Address_Type__c = 'Primary';
        auditObj.Admin_Assistant__c = 'test1211';
        auditObj.Admin_Assistant_Email__c = 'test13@email.com';
        auditObj.Admin_Assistant_Phone__c = '(222) 987-4653';
        auditObj.Admin_Assistant_Title__c = 'Dr.';
        auditObj.Contact_Id__c = contactId;
        auditObj.Email__c = 'test13@email.com';
        auditObj.First_Name__c = 'Provider';
        auditObj.Last_Name__c = 'Test';
        auditObj.Mobile_Phone__c = '(222) 987-4653';
        auditObj.PDI_Campaign__c = '2016 Wave2';
        auditObj.Practicing_Physician__c = true;
        auditObj.Provider_Type__c = 'External';
        auditObj.Sent_to_MDM__c = ' ';
        
        insert auditObj;
    }
    
    /**
    * @author Kishore Jonnadula
    * @description This method creates test Integration User data
    * @param 
    * @return void
    */
    public static User prepareIntegrationUser() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];  
        System.runAs (thisUser) { 
            portalRole = [Select Id From UserRole Where PortalType = :AP01_TestDataTokens.PORTAL_TYPE Limit 1];
            Profile integrationProfile = [Select Id from Profile where name =: AP01_TestDataTokens.INTEGRATION_PROFILE_NAME Limit 1];
                
            integrationUser = new User(
                    ProfileId = integrationProfile.Id,
                    Username = AP01_TestDataTokens.USER_NAME,
                    UserRoleId = portalRole.Id,
                    Alias =  AP01_TestDataTokens.ALIAS,
                    Email= AP01_TestDataTokens.EMAIL,
                    EmailEncodingKey=AP01_TestDataTokens.EMAIL_ENCODING_KEYS,
                    Firstname=AP01_TestDataTokens.FIRST_NAME,
                    Lastname=AP01_TestDataTokens.LAST_NAME,
                    CommunityNickname =AP01_TestDataTokens.COMMUNITY_NICK_NAME,
                    LanguageLocaleKey=AP01_TestDataTokens.LANGUAGE_LOCALE_KEY,
                    LocaleSidKey=AP01_TestDataTokens.LOCALE_SID_KEY,
                    TimeZoneSidKey=AP01_TestDataTokens.TIME_ZONES_ID_KEY
                ); 
                
            insert integrationUser;
        }
        return integrationUser;
    }
    
    /**
    * @author IDC team
    * @date 07/8/2015
    * @description This method create SOC Profile User
    * @param 
    * @return 
    */
    public static User createSOCUser(){
        
        Id profileId = [SELECT Id FROM Profile WHERE Name='PDI'].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='SOC Agents'].Id;
        
        User socUser = new User(Alias = 'standt', Email='standarduser@testmethod.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole,
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testmethod.com');
        
        insert socUser;
        return socUser;
    }
    
    /**
    * @author IDC team
    * @date 07/8/2015
    * @description This method creates Created Date custom setting record
    * @param 
    * @return 
    */
    public static CreatedDate__c insertCreatedDateCustSetting(){
        
        CreatedDate__c createdDate = new CreatedDate__c();
        createdDate.Name = 'CopyPcpDate';
        createdDate.Created_date__c = system.today();
        insert createdDate;
        
        return createdDate;
    }
    
    /**
    * @author IDC team
    * @date 07/8/2015
    * @description This method creates validated provider contacts
    * @param 
    * @return 
    */
    public static List<Contact> create_Validated_Contact(){
        
        List<Contact> conList = new List<Contact>();
        
        for(Integer i=0; i<5; i++){
            
            Contact con = new Contact();
            con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
            con.Firstname = 'Test';
            con.LastName = 'LastNameP' + i;
            con.Provider_NPI__c = '1234';
            con.Provider_ID__c = '098765';
            con.Provider_Active_Status__c = true;
            con.Provider_Active_Status_Date__c = system.today();
            con.Provider_Practicing_Physician__c = true;
            con.Provider_Type__c = 'External';
            con.Provider_Portal_Last_Validation_Date__c = system.today();
            con.MobilePhone = '(565) 765-7688';
            con.Provider_Correspondence_Fax_Number__c = '(565) 765-7688';
            con.Provider_Correspondence_Phone__c = '(565) 765-7688';
            con.Provider_Admin_Assistant_Phone__c = '(565) 765-7688';
            conList.add(con);
        }
        
        insert conList;
        return conList;
    }
    
    /**
    * @author IDC team
    * @date 06/10/2015
    * @description This method creates validated provider contacts with phone number
    * @param 
    * @return 
    * @Req-3694 
    */
    public static List<Contact> create_Provider_Validated_Contact(){
        
        List<Contact> conList = new List<Contact>();
        
        for(Integer i=0; i<5; i++){
        
            Contact con = new Contact();
            con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.CL15_Provider).getRecordTypeId();
            con.Firstname = 'Test';
            con.LastName = 'LastNameP' + i;
            con.Provider_NPI__c = '1234';
            con.Provider_ID__c = '098765';
            con.provider_correspondence_Phone__c = '(564) 895-6321';
            con.Provider_Portal_Last_Validation_Date__c = system.today();
            conList.add(con);
        }
        
        insert conList;
        return conList;
    }
    
    /**
    * @author Saddam 
    * @date 05/10/2015
    * @description This method create test data for CS_ManageProfile custom setting.
    * @param 
    * @return : Manageprofile list 
    */
    public static list<CS_ManageProfile__c> createManageprofileSet(){
        list<CS_ManageProfile__c> lstManageProfile = new list<CS_ManageProfile__c>();
        
        //Community Portal CS_ManageProfile
        
        CS_ManageProfile__c objManageProfile = CS_ManageProfile__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objManageProfile);
        objManageProfile.Name = 'Communities_Portal';
        objManageProfile.Profile_Name__c = 'Community Portal';
        lstManageProfile.add(objManageProfile);
        
        //Communities_Provider CS_ManageProfile
        
        CS_ManageProfile__c objManageProfile1 = CS_ManageProfile__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objManageProfile1);
        objManageProfile1.Name = 'Communities_Provider';
        objManageProfile1.Profile_Name__c = 'PDV Community Provider';
        lstManageProfile.add(objManageProfile1);
        
        
        //Community_Portal_Manager CS_ManageProfile
        
        CS_ManageProfile__c objManageProfile2 = CS_ManageProfile__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objManageProfile2);
        objManageProfile2.Name = 'Community_Portal_Manager';
        objManageProfile2.Profile_Name__c = 'Community Portal Manager';
        lstManageProfile.add(objManageProfile2);
        
        CS_ManageProfile__c objManageProfile3 = CS_ManageProfile__c.getOrgDefaults();
        objManageProfile3.Name = 'Communities_AdminAssistant';
        objManageProfile3.Profile_Name__c = 'PDI Community Admin Assistant';
        lstManageProfile.add(objManageProfile3);
        
        return lstManageProfile;
    }
    
    /**
    * @author Saddam 
    * @date 05/10/2015
    * @description This method create test data for Access Token Setting custom setting.
    * @param 
    * @return : AccessTokenSetting list 
    */
    public static list<AccessTokenSetting__c> createAccessTokenSettingSet(){
        list<AccessTokenSetting__c> lstAccessTokenSetting = new list<AccessTokenSetting__c>();
        
        //Community Portal AccessTokenSetting
        
        AccessTokenSetting__c objAccessTokenSetting = AccessTokenSetting__c.getOrgDefaults();
        system.debug('Custom Setting Before: ' + objAccessTokenSetting);
        objAccessTokenSetting.Name = 'Administrator';
        objAccessTokenSetting.Username__c = 'hernanf3@sutterhealth.org';
        objAccessTokenSetting.Password__c = ' UGEkJHdvcmQz';
        
        lstAccessTokenSetting.add(objAccessTokenSetting);
        
        return lstAccessTokenSetting;
    }
    
    
    /**
    * @author Abhijeet
    * @date 09/04/2015
    * @description This method create test data for list of contact of Provider RecordType for Req 3399 PDV.
    * @param Account
    * @return List of contact
    */
    public static List<Contact> createProviderPortalContacts(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
        Id recordTypeCon = getProviderRecordTypeId();
            for(integer i=0; i<5;i++){
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME + i;
                con.AccountId = account.id;
                con.Email='testnondummy@test'+i+'.com';
                con.RecordTypeId = recordTypeCon;
                con.Provider_Practicing_Physician__c = true;
                con.Provider_Active_Status__c = true;
                con.Provider_Active_Status_Date__c = system.today();
                con.Employee_ADID__c = null;
                conListToAdd.add(con);
            }
        insert conListToAdd;
        
        return conListToAdd;
    }
    
    /**
    * @author Abhijeet
    * @date 
    * @description This method create test data for list of contact of Provider RecordType for Req 3399 PDV.
    * @param Account
    * @return List of contact
    */
    public static List<Contact> createProviderPortalContactsNONTeleForm(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
        Id recordTypeCon = getProviderRecordTypeId();
            for(integer i=0; i<105;i++){
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME + i;
                con.Source_of_E_Mail__c=System.Label.TeleForm;
                con.Email='testemailcheck@testtest'+(i+1)+'.com';
                con.AccountId = account.id;
                con.RecordTypeId = recordTypeCon;
                conListToAdd.add(con);
            }
        
        return conListToAdd;
    }
    
    /**
    * @author Abhijeet
    * @date 09/04/2015
    * @description This method create test data for list of contact of Provider RecordType for Req 3399 PDV.
    * @param Account
    * @return List of contact
    */
    public static List<Contact> createProviderPortalContactsTeleForm(Account account){
    
        List<Contact> conListToAdd = new List<Contact>();
        Id recordTypeCon = getProviderRecordTypeId();
            for(integer i=0; i<5;i++){
                Contact con = new Contact();
                con.FirstName = AP01_TestDataTokens.CONTACT_F_NAME ;
                con.LastName = AP01_TestDataTokens.CONTACT_L_NAME + i;
                con.Source_of_E_Mail__c=System.Label.TeleForm;
                con.Email='testemailcheck@testtest'+(i+1)+'.com';
                con.AccountId = account.id;
                con.RecordTypeId = recordTypeCon;
                conListToAdd.add(con);
            }
        insert conListToAdd;
        
        return conListToAdd;
    }
     /**
    * @author Abhijeet
    * @date 09/04/2015
    * @description This method create test data for record type.
    * @param 
    * @return ID
    */
    public static Id getProviderRecordTypeId() {
        Id recordType = [select Id, SobjectType, Name from RecordType where name='Provider' and SObjectType='Contact' limit 1].Id;
        return recordType;
    }
    
    /**
    * @author Kishore Jonnadula
    * @description This method creates test data for PDI_Bypass_AddressVerification__c custom setting record
    * @param 
    * @return List<PDI_Bypass_AddressVerification__c>
    */
    public static List<PDI_Bypass_AddressVerification__c> insertBypassAddressVerificationSetting(){
        List<PDI_Bypass_AddressVerification__c> addressVerifyList = new List<PDI_Bypass_AddressVerification__c>();
        PDI_Bypass_AddressVerification__c byPassAddr1 = new PDI_Bypass_AddressVerification__c();
            byPassAddr1.Name = 'BypassAddressVerificationFlag';
            byPassAddr1.byPassValue__c = false;
        addressVerifyList.add(byPassAddr1);
        
        PDI_Bypass_AddressVerification__c byPassAddr2 = new PDI_Bypass_AddressVerification__c();
            byPassAddr2.Name = 'ByPassAddressVerificationInEAF';
            byPassAddr2.byPassValue__c = false;
        addressVerifyList.add(byPassAddr2);
        
        PDI_Bypass_AddressVerification__c byPassAddr3 = new PDI_Bypass_AddressVerification__c();
            byPassAddr3.Name = 'BypassCallCampaignAddressVerification';
            byPassAddr3.byPassValue__c = false;
        addressVerifyList.add(byPassAddr3);
        
        insert addressVerifyList;
        
        return addressVerifyList;
    }
    
    /**
    * @author Kishore Jonnadula
    * @description This method creates test data for PDIByPassEmailVerification__c custom setting record
    * @param 
    * @return PDIByPassEmailVerification__c
    */
    public static PDIByPassEmailVerification__c insertBypassEmailAddrVerificationSetting(){
        PDIByPassEmailVerification__c byPassEmailAddress = new PDIByPassEmailVerification__c();
        byPassEmailAddress.Name = 'ByPassEmailVerification';
        byPassEmailAddress.ByPassInCallCampaign__c = false;
        byPassEmailAddress.ByPassInPortal__c = false;
        
        insert byPassEmailAddress;
        
        return byPassEmailAddress;
    }

}