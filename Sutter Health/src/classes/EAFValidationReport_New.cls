global class EAFValidationReport_New implements Database.Batchable<sObject> {

    
     global Database.QueryLocator start(Database.BatchableContext BC)
    {
      String query = 'SELECT Address_Modified__c ,ADDRESS__c,Attn_To__c,CITY__c,Facility_ID__c,FAX_NUMBER__c,Floor__c,Id,LastModifiedBy.Name,Last_Verified_date__c,Name,Names_Changes_Suggested__c,PHONE__c,STATE__c,Suite__c,ZIP_CODE__c FROM PDV_EAF_Facility__c where  Last_Verified_date__c = YESTERDAY ';

        return Database.getQueryLocator(query);

    }
    
    global void execute(Database.BatchableContext BC, list<PDV_EAF_Facility__c> EA_Facilitylist )
   {

string header = 'Facility ID, Facility Name ,SUITE,FLOOR, ADDRESS, CITY,STATE,ZIP CODE,PHONE,FAX NUMBER,Attn To,Names Changes Suggested,Last Modified By: Full Name,Last Verified date,Address Modified \n';
string finalstr = header ;
for(PDV_EAF_Facility__c a: EA_Facilitylist)
{
       string recordString = '"'+a.Facility_ID__c+'","'+a.Name+'","'+a.Suite__c+'","'+a.Floor__c+'","'+a.ADDRESS__c+'","'+a.CITY__c+'","'+a.STATE__c+'","'+a.ZIP_CODE__c+'","'+a.PHONE__c+'","'+a.FAX_NUMBER__c+'","'+a.Attn_To__c+'","'+a.Names_Changes_Suggested__c+'","'+a.LastModifiedBy.Name+'","'+a.Last_Verified_date__c +'","'+a.Address_Modified__c +'"\n';
       finalstr = finalstr +recordString;
}
OrgWideEmailAddress orgWideAddressId = [select id,Address from OrgWideEmailAddress where DisplayName='Sutter Provider Hub' limit 1];

Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
blob csvBlob = Blob.valueOf(finalstr);
string csvname= 'FacilityValidationReport.csv';
csvAttc.setFileName(csvname);
csvAttc.setBody(csvBlob);
Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
string temp = Label.EAFReportEmailIds;
List<String> emails= temp.split(',');
String[] toAddresses = new list<string> ();
toAddresses.addAll(emails);
String subject ='EAF Validation Report';
email.setSubject(subject);
email.setOrgWideEmailAddressId(orgWideAddressId.id);
email.setToAddresses( toAddresses );
email.setHtmlBody('Hi.<br/><br/> Please find attached EAF Validation Report. <br/><br/> Regards<br/>Sutter Provider Hub');
email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

}
   
global void finish(Database.BatchableContext BC)
    {
    }   
   

}