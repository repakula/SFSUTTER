/**  
  * Class Name: PDI_AdminAssistantUserHelper
  * Author: Kishore Jonnadula
  * Date: 29/09/2016
  * Description: 
 **/
public class PDI_AdminAssistantUserHelper {
    static final String dummyadminEmail = 'testadmin@dummyAsst';
    static final String emaildotcom = 'email.com';
    static final String hyphen = ' - ';
    static final String colon = ': ';
    static final String space_constant = '';
    static final String strSpace = ' ';
    
   /* Name: createAdminAssistantUser
    * Input: email list
    * Return Type: void
    * Description: This method is used to create account and contact for admin assistant users
    */
    public void createAdminAssistantUser(List<String> emailList){
        List<Contact_Validation_Summary__c> provAsstList = new List<Contact_Validation_Summary__c>();
        List<Contact_Validation_Summary__c> providerAdminAsstList = new List<Contact_Validation_Summary__c>();
        List<Contact> AdminAsstOldContList = new List<Contact>();
        List<Contact> originalConList = new List<Contact>();
        Map<String, Contact_Validation_Summary__c> newAdminAssistantMap = new Map<String, Contact_Validation_Summary__c>();
        Map<String, Contact> adminAsstoldConMap = new Map<String, Contact>();
        Map<String, String> accountMap = new Map<String, String>();
        List<Account> accList = new List<Account>();
        List<Contact> updateConList;
        String strRandomEmail;
        Savepoint sp;
        
        try{
            Id assistantRecordTypeId = [select Id from RecordType where name =:Label.CL468_PDI_AdminAssistant and SObjectType =:Label.CL469_PDI_Contact limit 1].Id;
            Id accAsstRecordTypeId = [select Id from RecordType where name =:Label.CL468_PDI_AdminAssistant and SObjectType =:Label.CL470_PDI_Account limit 1].Id;
            sp = Database.setSavepoint();
            
            if(!emailList.isEmpty()){
                // Retrieve provider admin assistant records based on admin assistant email.
                providerAdminAsstList = [select Provider_Name__c, Admin_Assistant__c, Admin_Assistant_Email__c from Contact_Validation_Summary__c 
                                where PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name 
                                and Admin_Assistant_Approval_Status__c = 'Approved' and Admin_Assistant_Email__c in :emailList];
                AdminAsstOldContList = [select id, firstName, lastName, Email, AccountId, RecordTypeId from contact 
                                        where Email in :emailList and RecordTypeId =: assistantRecordTypeId];
                
            }
            if(!providerAdminAsstList.isEmpty()){
                for(Contact_Validation_Summary__c summary : providerAdminAsstList){
                    if(summary.Admin_Assistant__c != null){
                        newAdminAssistantMap.put(summary.Admin_Assistant_Email__c, summary);
                    }
                }
            }
            // Assign contact email and contact object to admin assistant contact old map
            if(!AdminAsstOldContList.isEmpty()){
                for(Contact con : AdminAsstOldContList){ adminAsstoldConMap.put(con.Email, con); }
            }
            
            if(!newAdminAssistantMap.isEmpty()){
                for(String key : newAdminAssistantMap.keySet()){
                    if(!adminAsstoldConMap.containsKey(key)){
                        provAsstList.add(newAdminAssistantMap.get(key));
                    }
                }
            }
            // Create account records for admin assistant users
            if(!provAsstList.isEmpty()){
                for(Contact_Validation_Summary__c summary : provAsstList){
                    Account acc = new Account();
                    acc.name = summary.Admin_Assistant__c;
                    acc.PDI_Email__c = summary.Admin_Assistant_Email__c;
                    acc.RecordTypeId = accAsstRecordTypeId;
                    accList.add(acc); 
                }
                if(!acclist.isEmpty()){
                    insert acclist;
                }
                
                if(!acclist.isEmpty()){
                    for(Account acc : accList){
                        accountMap.put(acc.PDI_Email__c, acc.Id);
                    }
                    for(Contact_Validation_Summary__c asstCon : provAsstList){
                        String firstName = space_constant;
                        String lastName = space_constant;
                        if(accountMap.containsKey(asstCon.Admin_Assistant_Email__c)){
                            Contact adminContact = new Contact();
                            strRandomEmail = GetRandomString.generateString();
                            adminContact.AccountId = accountMap.get(asstCon.Admin_Assistant_Email__c);
                            adminContact.RecordTypeId = assistantRecordTypeId;
                            adminContact.Email=dummyadminEmail+strRandomEmail+emaildotcom;
                            adminContact.Admin_Temp_Email__c = asstCon.Admin_Assistant_Email__c;
                            String associatedProviders = '';
                            if(!providerAdminAsstList.isEmpty()){
                                for(Contact_Validation_Summary__c adminAsstCon : providerAdminAsstList){
                                    if(asstCon.Admin_Assistant_Email__c == adminAsstCon.Admin_Assistant_Email__c){
                                        if(adminAsstCon.Provider_Name__c != null && String.isNotBlank(adminAsstCon.Provider_Name__c)){
                                            associatedProviders += adminAsstCon.Provider_Name__c + ',';
                                        }
                                    }
                                }  
                            }
                            adminContact.Tech_Admin_Associated_Providers__c = associatedProviders;
                            if(asstCon.Admin_Assistant__c.contains(strSpace)){
                                firstName = asstCon.Admin_Assistant__c.substring(0,asstCon.Admin_Assistant__c.indexOf(' '));
                                lastName = asstCon.Admin_Assistant__c.substring(asstCon.Admin_Assistant__c.indexOf(' ')+1);
                            }else{
                                lastName = asstCon.Admin_Assistant__c;
                            }
                            adminContact.FirstName = firstName;
                            adminContact.LastName = lastName;
                            originalConList.add(adminContact);  
                        }
                    }
                    if(!originalConList.isEmpty()){
                        insert originalConList;
                    }
                }
            }
        }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + hyphen + ex.getCause() + colon + ex.getMessage());
        }catch(Exception ex){ Database.rollback(sp); System.debug(ex.getTypeName() + hyphen + ex.getCause() + colon + ex.getMessage()); }
    }
    
}