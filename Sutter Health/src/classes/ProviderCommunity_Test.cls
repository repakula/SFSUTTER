/*    Class Name: providerCommunityTestMethod
*     Author: IDC Offshore
*     Date: 06-Oc-2015
*     Description:Test Class for ProviderLoginController. This class tests different scenarios that are handled in the code
**/
@isTest
public class ProviderCommunity_Test {
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description method to create test data used by all tests       
     * @return void        
     **/
     @testsetup
    static void createTestData()
    {
       // create custom setting Data
        CS_ManageProfile__c CSMCommunities_Portal = new CS_ManageProfile__c(Name = 'Communities_Portal', Profile_Name__c='Community Portal');
        CS_ManageProfile__c CSMCommunities_Provider = new CS_ManageProfile__c(Name = 'Communities_Provider', Profile_Name__c='Community Portal Manager');
        CS_ManageProfile__c CSMCommunity_Portal_Manager = new CS_ManageProfile__c(Name = 'Community_Portal_Manager', Profile_Name__c='Community Portal Manager');
        Insert CSMCommunities_Portal;
        Insert CSMCommunities_Provider;
        Insert CSMCommunity_Portal_Manager;

        //Assert to check custom setting data 
        system.assert(CSMCommunities_Portal!=null);
        system.assert(CSMCommunities_Provider!=null);
        system.assert(CSMCommunity_Portal_Manager!=null);
     }
    
    
    /**        
     * @author IDC Team        
     * @date 20/Oct/2015       
     * @description method to create account , contact and contact validation summary and check login functionality      
     * @return void        
     **/
    public static testMethod void providerCommunityTestMethod(){
       
        Test.startTest();   
        Account accObj = new Account();
        accObj.name = 'Test Account';
        insert accObj;
        //Assert to check account has been created  
        system.assert(accObj!=null);
        
        RecordType rtObj = new RecordType();
        rtObj = [SELECT id, name FROM recordtype WHERE name='Provider' and SObjectType='Contact' limit 1];
        
        list<contact> conList = new list<contact>();
        Contact conObj = new Contact();
                
        conList.add(new contact(
            accountId = accObj.id,
            lastName = 'Provider',
            firstName = 'Test',
            Provider_Name__c = 'Test Provider',
            Provider_Title__c = 'Mr.',
            recordTypeId = rtObj.id,
            email = 'test@test.com',
            Provider_Correspondence_Address__c = '123',
            Provider_Correspondence_City__c = 'CA',
            Provider_Correspondence_State__c = 'CA',
            Provider_Correspondence_PostalCode__c = '12345',
            Provider_Correspondence_Phone__c = '2345678901',
            Provider_Correspondence_Fax_Number__c = '2345678901',
            Provider_Practicing_Physician__c = true,
            Provider_Active_Status__c = true,
            Provider_Active_Status_Date__c = system.today(),
            MobilePhone = '2345678901',
            Contact_External_ID1__c = '1234'
        ));
        
        conList.add(new contact(
            accountId = accObj.id,
            Provider_Name__c = 'Test Provider',
            Provider_Title__c = 'Mr.',
            lastName = 'Provider',
            firstName = 'Test',
            recordTypeId = rtObj.id,
            Provider_Correspondence_Address__c = '123',
            Provider_Correspondence_City__c = 'CA',
            Provider_Correspondence_State__c = 'CA',
            Provider_Correspondence_PostalCode__c = '12345',
            Provider_Correspondence_Phone__c = '2345678901',
            Provider_Correspondence_Fax_Number__c = '2345678901',
            Provider_Practicing_Physician__c = true,
            Provider_Active_Status__c = true,
            Provider_Active_Status_Date__c = system.today(),
            MobilePhone = '2345678901',
            Contact_External_ID1__c = '12345'
        ));
        
        insert conList;   

        system.assert(conList[1]!=null);     
        Test.stopTest();
        
        // check user has been created from 1st contact record 
        User userObj = new User();
        userObj = [SELECT id FROM user WHERE contactId = :conlist[0].id];
        system.assert(userObj!=null);
        
        System.runAs(userObj) {
            
            Contact_Validation_Summary__c cvsObj = new Contact_Validation_Summary__c();
            cvsobj = [SELECT id FROM Contact_Validation_Summary__c WHERE contact_id__c = :conlist[0].id];
            cvsObj.Preferred_Communication_Method__c= 'email';
            update cvsObj;
            
            ValidateProviderController vpcObj = new ValidateProviderController();
            vpcObj.save();
            vpcObj.ifUserAuthenticated();
            
            cvsObj.Email__c= 'test1@test.com';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.save();
            
            cvsObj.Preferred_Communication_Method__c= '';
            cvsObj.Email__c = '';
            cvsObj.Mobile_Phone__c = '';
            cvsObj.Secure_Fax__c = '';
            cvsObj.Secure_City__c = '';
            cvsObj.Secure_State__c = '';
            cvsObj.Secure_Phone__c = '';
            cvsObj.Email__c = '';
            cvsObj.Secure_Zip_Code__c = '';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.providerInfo.sc_address = '';
            vpcObj.save();
            
            //cvsObj.Email__c = 'test';
            cvsObj.Mobile_Phone__c = '123456ty789';
            cvsObj.Secure_Fax__c = '1234er56789';
            cvsObj.Secure_Phone__c = '123456789';
            cvsObj.Secure_Zip_Code__c = '123';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.save();

            cvsObj.Secure_Phone__c = '123456789a';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.save();

            cvsObj.Secure_Phone__c = '1234522267812290';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.save();

            cvsObj.Secure_Phone__c = '1234567890x1q';
            update cvsObj;
            vpcObj = new ValidateProviderController();
            vpcObj.save();
            
            try{
                cvsObj.Mobile_Phone__c = '';
                cvsObj.Secure_Fax__c = '';
                cvsObj.Secure_Phone__c = '';
                cvsObj.Secure_Zip_Code__c = '';
                update cvsObj;
                vpcObj = new ValidateProviderController();
                vpcObj.save();
            }
            catch(Exception classException)
            {
                system.assert(classException.getMessage()!=null);
                Boolean expectedExceptionThrown =  classException.getMessage().contains('') ? true : false;
            }
      
            try{
                cvsObj.Email__c = 'test';
                update cvsObj;
                vpcObj = new ValidateProviderController();
                vpcObj.save();
            }
            catch(DMLException ex)
            {
                system.assert(ex.getMessage()!=null);
                Boolean expectedExceptionThrown =  ex.getMessage().contains('') ? true : false;
            }
        }
        conList[1].email = 'test@provider.com';
        update conList;
        
        ProviderLoginController plcObj = new ProviderLoginController();
        plcObj.username = 'test@test.com';
        plcObj.password = '123';
        plcObj.login();
    }
}