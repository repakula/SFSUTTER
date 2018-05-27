global class ProviderValidationReport_New implements Database.Batchable<sObject> {

    
     global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Address_Modified__c,Address_Type__c,Attn_To__c,Id,Contact_Id__r.LastName,Contact_Id__r.FirstName,LastModifiedBy.Name,Last_Verified_Date__c,Name,Names_Changes_Suggested__c,Provider_ID__c,Provider_Name__c,Provider_FullName__c,Secure_City__c,Secure_Fax__c,Secure_Floor__c,Secure_Phone_Ext__c,Secure_Phone__c,Secure_State__c,Secure_Street_Address__c,Secure_Suite__c,Secure_Zip_Code__c FROM Contact_Validation_Summary__c WHERE Last_Verified_Date__c = YESTERDAY and Address_Type__c = \'Secondary\' ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Contact_Validation_Summary__c> clist)
   {

string header = 'Provider ID, Provider Name , Secure Street Address, Secure Suite,Secure Floor,Secure City,Secure State,Secure Zip Code,Secure Phone,Secure Fax,Attn To,Names Changes Suggested,Last Modified By: Full Name,Last Verified date,Address Modified \n';
string finalstr = header ;
for(Contact_Validation_Summary__c a: clist)
{
     //  string FullName = (a.Contact_Id__r.LastName + ', '+a.Contact_Id__r.FirstName);
    //   FullName = FullName.toUpperCase();
       string recordString = '"'+a.Provider_ID__c+'","'+a.Provider_FullName__c+'","'+a.Secure_Street_Address__c+'","'+a.Secure_Suite__c+'","'+a.Secure_Floor__c+'","'+a.Secure_City__c+'","'+a.Secure_State__c+'","'+a.Secure_Zip_Code__c+'","'+a.Secure_Phone__c+'","'+a.Secure_Fax__c+'","'+a.Attn_To__c+'","'+a.Names_Changes_Suggested__c+'","'+a.LastModifiedBy.Name+'","'+a.Last_Verified_date__c +'","'+a.Address_Modified__c +'"\n';
       finalstr = finalstr +recordString;
}
OrgWideEmailAddress orgWideAddressId = [select id,Address from OrgWideEmailAddress where DisplayName='Sutter Provider Hub' limit 1];
Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
blob csvBlob = Blob.valueOf(finalstr);
string csvname= 'ProviderValidationReport.csv';
csvAttc.setFileName(csvname);
csvAttc.setBody(csvBlob);
Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
string temp = Label.ProviderReportEmailids;
List<String> emails= temp.split(',');
String[] toAddresses = new list<string> ();
toAddresses.addAll(emails);
String subject ='Provider Validation Report';
email.setSubject(subject);
email.setOrgWideEmailAddressId(orgWideAddressId.id);
email.setToAddresses( toAddresses );
email.setHtmlBody('Hi.<br/><br/> Please find attached Provider Validation Report. <br/><br/> Regards<br/>Sutter Provider Hub');
email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

   }
   
global void finish(Database.BatchableContext BC)
    {
    }   
   

}