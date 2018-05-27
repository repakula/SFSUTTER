/**  
*    Class Name: ManageContactDatabase_Test
*    Author: 
*    Date: 
*    Description:  An apex page controller that tests the Manage Contact Database Class.
*    History
*    --------
**/
@isTest
private class ManageContactDatabase_Test {
    
    /**
    * @author Atul Gupta
    * @date 04/28/2014
    * @description Create CreatedDate__c custom setting
    * @param 
    * @return 
    */
    public static CreatedDate__c createdDateCustSetting(){
    
        CreatedDate__c createdDate = new CreatedDate__c();
        createdDate.Name = 'CopyPcpDate';
        createdDate.Created_date__c = date.today() + 1;
        insert createdDate;
        
        // Assert to check Custom Setting CreatedDate__c record created successfully
        System.assert(createdDate.id!=null);        
        
        return createdDate;
    }
    
    /**   
    *@author 
    *@date 
    *@description This method update the Contacts returned by CreatePortalManagerContacts method. This is for the Employee_EEO_SubCode__c = 0,
    *               EMPLOYEE_EMPLOYMENT_STATUS__C='Su'
    *@param     
    *@return     
    */
    @isTest 
    static void testContactToPcpUpdate() {

        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        //Assert to check Account ais created successfully
        System.assert(assignedAccount.id!=null);
        
        CreatedDate__c custSett = createdDateCustSetting();
        
        Test.startTest();
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPCP(assignedAccount);
        //Assert to check Contact created successfully
        system.assert(ContactToInsert.size()!=null);
        set<Id> setTestRecId = new set<Id>();
        
        for(Contact co : ContactToInsert){
            System.debug('SUSH'+co.id);
            setTestRecId.add(co.id);
        }

        Integer pcpInfoSize = [SELECT COUNT() FROM PCP_information__C WHERE Member_ID__c IN :setTestRecId];
        // System.assertEquals(pcpInfoSize,1000);
        ManageContactDatabase.createContactProviderSummaryRecords(ContactToInsert);

        //ManageContactDatabase.ManageUpdatedContacts(ContactToInsert,null,null);
        ManageContactDatabase.getProvidersForUserCreation(ContactToInsert,null,null); 
        ManageContactDatabase.getEmployeeRecordType();
        ManageContactDatabase.contactOwnerValidation(ContactToInsert);   

        Test.stopTest();
    }
    
    /**   
    *@author IDC Team    
    *@date    
    *@description : Test for contact owner validation
    *@param     
    *@return     
    */
    @isTest 
    static void Test_Contact_Owner_Validation() {
        
        Id adminUserId = UserInfo.getUserId();
        
        User SHPSalesUser = create_SHP_Sales_User();
        // Assert to check User is fetched successfully
        system.assert(SHPSalesUser.id!=null);
        System.runAs(SHPSalesUser){
            test.startTest();
            try{
                Account acc = AP01_TestDataUtility.createAccount();
                //Assert to check Account is created successfully
                system.assert(acc.id!=null);
                List<Contact> contactList = AP01_TestDataUtility.createContactListForPCP(acc);
                //Assert to check Contact is created successfully
                system.assert(contactList.size()>0);
                List<Contact> conListToUpdate = new List<Contact>();
                
                for(Contact con : contactList){
                    con.OwnerId = adminUserId;
                    conListToUpdate.add(con);
                }
                update conListToUpdate;
            }catch(Exception ex){
                system.assertEquals(ex.getMessage().contains('You can only change to a User of SHP Sales Profile'), true);
            }
            test.stopTest();
        }
    }
    
    /**   
    *@author IDC Team    
    *@date    
    *@description : create SHP Sales User
    *@param     
    *@return     
    */
    static User create_SHP_Sales_User(){
        
        Profile shpSalesProfileId = [Select Id from Profile where name = 'SHP Sales' Limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
        User testRunUser = new User(
            ProfileId = shpSalesProfileId.Id,
            Username = 'tester49_nky@test.com',
            UserRoleId = portalRole.Id,
            Alias = 'tester',
            Email='tester49_nky@test.com',
            EmailEncodingKey='UTF-8',
            Firstname='One',
            Lastname='Tester',
            CommunityNickname = 'tester49_nky',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Los_Angeles'
        );
        insert testRunUser;
        // Assert to check User is created successfully
        system.assert(testRunUser.id!=null);
        return testRunUser;
    }
    
    /**   
    *@author 
    *@date 
    *@description This method is used to update the archive flag to true or false
    *@param     
    *@return     
    */
    @isTest 
    static void testContactArchiveInsert() {
		Id shpSalesEmpRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SHP Sales Employer Contact').getRecordTypeId();
    	Id shpSalesEmpRORecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SHP Sales Employer Contact Read Only').getRecordTypeId();
		Account testAccount = new Account (RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('SHP Sales Employer').RecordTypeId,
                                           Name='Test Account',
                                           Status__c= 'Contracted',
                                           NumberOfEmployees = 300 );
           
        Database.insert(testAccount);
        List<Contact> conList = new List<Contact>();
        List<Contact> upateconList = new List<Contact>();
        HighRoads_ArchivedContacts.isContactBeforeInsert = true;
        HighRoads_ArchivedContacts.isContactBeforeUpdate = true;
        
        Contact con = new Contact(AccountId=testAccount.Id,firstname='test',lastname='test',phone='9876543210',email='test@test.com',recordtypeid=shpSalesEmpRecTypeId);
        Contact con1 = new Contact(AccountId=testAccount.Id,archive__c = true,firstname='test',lastname='test',phone='9876543210',email='test@test.com',recordtypeid=shpSalesEmpRecTypeId);
        conList.add(con);
        conList.add(con1);
        
        Insert conList;
        Contact conObj1 = [select id,archive__c from contact where id=:con1.id];
        conObj1.Archive__c = false;
        Contact conObj = [select id,archive__c from contact where id=:con.id];
        conObj.Archive__c = true;

        upateconList.add(conObj1);
        upateconList.add(conObj);

        Test.startTest();
        update upateconList;
        Test.stopTest();
        
        
    }
    
}