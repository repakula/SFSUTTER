/**  
*     Class Name: MemberInquiryTriggerTest
*     Author: Atul Gupta
*     Date: 14-January-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description: Test Class for MemberInquiryTrigger Trigger. This class tests for different scenarios that are handled in the code
*     
*    History
*    --------
*
*    VERSION    AUTHOR         DATE        DETAIL 
*       
**/
@isTest
private class MemberInquiryTriggerTest {

    private static final String SHP_PROFILE_NAME = 'SHP Agent';
    private static final String SHP_ROLE_NAME = 'SHP Agent';
    private static final String CONT_RT_MEMBER = 'Member';
    private static final string CONTACT_RT_SHP_PROVIDER = 'SHP Provider';
    private static final string REASON_CLINICAL = 'Clinical';
    private static final string OOA_MEDICAL = 'Out of Area – Medical';
    private static final string OOA_BEHAVIORAL = 'Out of Area – Behavioral';
    private static final string VFC_URL_STR1 = '/apex/VFP01_CustomConsole?CALLID=';
    private static final string VFC_URL_STR2 = '&DEV=87667676&DNISTC=SHPM&CALLDT=&TRANF=NO';
    private static final string MEMBER_ID = '12345678';
    private static final string NAME_STR = 'Test';
    private static final string MEMBER_CONTACT_NUM = '616-643-7555';
    private static final string PROVIDER_NPI = '111123';
    private static final string OOA_VIEW_ONLY = 'SHP OOA/OON View Only';
    private static final string OOA_OON_RT = 'OOA/OON';
    private static final string ER_VERIFICATION = 'ER Verification';
    private static final string TEST_STR = 'Test';
    private static final string DMHC_VALUE = 'Met';
    private static final string MEM_INQ_ERROR = 'You cannot choose the same type of Contact as the Parent IL. Example: If Provider is selected on the IL, Member must be entered on Customer Inquiries By Others.';
    
    /**
    * @author IDC Team
    * @date 
    * @description 
    * @param 
    * @return void
    */
    static testMethod void createCustInqByOthersForSameContactError() {
        
        try
        {
            User ooa_oonUser = createSHP_OOA_OON_User();
            
            String callIDStr = String.valueOf(system.now());
            
            System.runAs(ooa_oonUser){
                
                PageReference consolePage = new PageReference(VFC_URL_STR1 + callIDStr + VFC_URL_STR2);
                Test.setCurrentPage(consolePage);
                
                Account acc1 = AP01_TestDataUtility.createAccount();
                Contact cont = AP01_TestDataUtility.createContact(acc1);
                
                cont.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT_SHP_PROVIDER).RecordTypeId;
                update cont;
                
                Contact provider2 = AP01_TestDataUtility.createContact(acc1);
                
                provider2.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT_SHP_PROVIDER).RecordTypeId;
                update provider2;
                
                VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
                
                consoleController.providerFirstName = NAME_STR;
                consoleController.providerLastName = NAME_STR;
                consoleController.providerNPI = PROVIDER_NPI;
                consoleController.SearchProvider();
                
                consoleController.linkId = cont.Id;
                
                consoleController.contactVerification();
                
                system.assertEquals(consoleController.custInteraction.contactId <> null, true);
                
                consoleController.custInteraction.Reason__c = REASON_CLINICAL;
                consoleController.custInteraction.Secondary_Reason__c = OOA_MEDICAL;
                
                Test.startTest();
                consoleController.saveSHP();
                Test.stopTest();
                
                List<Case> childCases = [Select Id from Case where ParentId =: consoleController.custInteraction.Id];
                
                system.assertEquals(childCases.size() > 0, true);
                
                Member_Enquiries__c mem = new Member_Enquiries__c();
                mem.Case__c = consoleController.custInteraction.Id;
                mem.Member_Id__c = provider2.Id;
                
                Database.insert(mem);
            }
        } catch(Exception ex){
            
            system.assertEquals(ex.getMessage().contains(MEM_INQ_ERROR), true);
        }
        
    }
    
    /**
    * @author IDC Team
    * @date 
    * @description 
    * @param 
    * @return void
    */
    static testMethod void createCustInqByOthersForProvider() {
        
        try
        {
            User ooa_oonUser = createSHP_OOA_OON_User();
            
            String callIDStr = String.valueOf(system.now());
            
            System.runAs(ooa_oonUser){
                
                PageReference consolePage = new PageReference(VFC_URL_STR1 + callIDStr + VFC_URL_STR2);
                Test.setCurrentPage(consolePage);
                
                Account acc1 = AP01_TestDataUtility.createAccount();
                Contact cont = AP01_TestDataUtility.createContact(acc1);
                
                cont.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT_SHP_PROVIDER).RecordTypeId;
                update cont;
                
                Contact member = AP01_TestDataUtility.createContact(acc1);
                
                member.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONT_RT_MEMBER).RecordTypeId;
                update member;
                
                VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
                
                consoleController.providerFirstName = NAME_STR;
                consoleController.providerLastName = NAME_STR;
                consoleController.providerNPI = PROVIDER_NPI;
                consoleController.SearchProvider();
                
                consoleController.linkId = cont.Id;
                
                consoleController.contactVerification();
                
                system.assertEquals(consoleController.custInteraction.contactId <> null, true);
                
                consoleController.custInteraction.Reason__c = REASON_CLINICAL;
                consoleController.custInteraction.Secondary_Reason__c = OOA_MEDICAL;
                
                Test.startTest();
                consoleController.saveSHP();
                Test.stopTest();
                
                Member_Enquiries__c mem = new Member_Enquiries__c();
                mem.Case__c = consoleController.custInteraction.Id;
                mem.Member_Id__c = member.Id;
                
                Database.insert(mem);
                
                List<Case> childCases = [Select Id, Facility_Name_OOA_OON__c, Member_Name_OOA_OON__c from Case where ParentId =: consoleController.custInteraction.Id];
                
                system.assertEquals(childCases.size() > 0, true);
                system.assertEquals(childCases[0].Facility_Name_OOA_OON__c, cont.Id);
                
                system.assertEquals(childCases[0].Member_Name_OOA_OON__c, member.Id);
            }
        } catch(Exception ex){
            
        }
    }
    
    /**
    * @author IDC Team
    * @date 
    * @description 
    * @param 
    * @return void
    */
    static testMethod void createCustInqByOthersForMember() {
        
        try
        {
            User ooa_oonUser = createSHP_OOA_OON_User();
            
            String callIDStr = String.valueOf(system.now());
            
            System.runAs(ooa_oonUser){
                
                PageReference consolePage = new PageReference(VFC_URL_STR1 + callIDStr + VFC_URL_STR2);
                Test.setCurrentPage(consolePage);
                
                Account acc1 = AP01_TestDataUtility.createAccount();
                Contact cont = AP01_TestDataUtility.createContact(acc1);
                
                cont.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONT_RT_MEMBER).RecordTypeId;
                update cont;
                
                Contact prov = AP01_TestDataUtility.createContact(acc1);
                
                prov.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT_SHP_PROVIDER).RecordTypeId;
                update prov;
                
                VFC01_CustomConsole consoleController = new VFC01_CustomConsole();
                
                consoleController.memberID = MEMBER_ID;
                consoleController.memberFirstName = TEST_STR;
                consoleController.memberLastName = TEST_STR;
                consoleController.memberContactNumber = MEMBER_CONTACT_NUM;
                consoleController.memberDOB.SearchDate__c = system.today();
                consoleController.SearchMember();
                
                consoleController.linkId = cont.Id;
                
                consoleController.contactVerification();
                
                system.assertEquals(consoleController.custInteraction.contactId <> null, true);
                
                consoleController.custInteraction.Reason__c = REASON_CLINICAL;
                consoleController.custInteraction.Secondary_Reason__c = OOA_MEDICAL;
                
                Test.startTest();
                consoleController.saveSHP();
                Test.stopTest();
                
                Member_Enquiries__c mem = new Member_Enquiries__c();
                mem.Case__c = consoleController.custInteraction.Id;
                mem.Member_Id__c = prov.Id;
                
                Database.insert(mem);
                
                List<Case> childCases = [Select Id, Facility_Name_OOA_OON__c, Member_Name_OOA_OON__c from Case where ParentId =: consoleController.custInteraction.Id];
                
                system.assertEquals(childCases.size() > 0, true);
                system.assertEquals(childCases[0].Facility_Name_OOA_OON__c, prov.Id);
                
                system.assertEquals(childCases[0].Member_Name_OOA_OON__c, cont.Id);
            }
        }catch(Exception ex){
            
        }
    }
    
    /**
    * @author Saket
    * @date 01/03/2014
    * @description : create SHP Agent User of SHP OOA/OON View Only Group
    * @param 
    * @return user
    */
    public static User createSHP_OOA_OON_User(){
    
        Id profileID = [Select Id from Profile where Name =: SHP_PROFILE_NAME].Id;
        Id roleId = [SELECT Id FROM UserRole where Name =: SHP_ROLE_NAME].Id;
        
        User usr = new User();
        usr.LastName = AP01_TestDataTokens.USER_LAST_NAME;
        usr.Username = AP01_TestDataTokens.USER_NAME;
        usr.Email = AP01_TestDataTokens.USER_EMAIL;
        usr.Alias = AP01_TestDataTokens.ALIAS;
        usr.CommunityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME ;
        usr.TimeZoneSidKey = AP01_TestDataTokens.TIME_ZONES_ID_KEY;
        usr.LocaleSidKey = AP01_TestDataTokens.LOCALE_SID_KEY;
        usr.EmailEncodingKey = AP01_TestDataTokens.EMAIL_ENCODING_KEYS;
        usr.LanguageLocaleKey = AP01_TestDataTokens.LANGUAGE_LOCALE_KEY;
        usr.profileid = profileID;
        usr.UserRoleId = roleId;
        usr.isActive = true;
        
        Database.insert(usr);
        
        List<Group> shpViewOnlyGroup = [select id from Group where Name=: OOA_VIEW_ONLY];
        
        if(!shpViewOnlyGroup.isEmpty()){
            
            GroupMember grpMem = new GroupMember();
            grpMem.GroupId = shpViewOnlyGroup[0].Id;
            grpMem.UserOrGroupId = usr.Id;
            
            Database.insert(grpMem);
        }
        
        return usr;
    }
}