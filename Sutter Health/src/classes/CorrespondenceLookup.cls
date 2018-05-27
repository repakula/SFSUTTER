/*
*     Class Name  : CorrespondenceLookup
*     Author      : IDC Offshore
*     Project Name: CRM - SFT - Sutter Health
*     
*
*       History
*      
*       VERSION         AUTHOR              DATE              DETAIL 
*         1.0          IDC                                     Initial Creation
          1.1          IDC         12/04/15                  Added member search limit to 1000
*/

public without sharing class CorrespondenceLookup {
    transient public List<WRContactDetails> lstWRContacts {get;set;}
    public string correspondenceType {get;set;}
    public string inputSrch {get;set;}
    public CorrespondenceLookup() {
        lstWRContacts = new List<WRContactDetails>();
        try {
           string contactId = ApexPages.CurrentPage().getParameters().get('ContactId');
           correspondenceType = ApexPages.CurrentPage().getParameters().get('CorrepondenceType');
           if(!String.isBlank(contactId) && !String.isBlank(correspondenceType)) {
               string memberId = [select Member_ID__c from Contact where Id =:contactId].Member_ID__c;
               getContactMembers(memberId);
           }
            
        } catch(Exception ex){}
    }
    
    public void getContactMembers(string contactMemberID) {
        try {
            string strQuery;
            if(correspondenceType == Label.CL08_Member) {
                string[] memberIdArr = contactMemberID.split('-');
                if(memberIdArr != null && memberIdArr.size()>0) {
                    string memberIdPrefix = memberIdArr[0];
                    strQuery = 'select Name,Member_ID__c, Member_Subscriber_Relationship__c '+
                                   'from Contact where Member_ID__c != null and '+
                               'Member_ID__c like \'' + memberIdPrefix + '%\' '+
                               'order by Member_ID__c asc';
                }
            } else {
                strQuery = 'select Name,Member_ID__c, Member_Subscriber_Relationship__c '+
                               'from Contact where RecordType.Name = \'Member\' ' +
                               'order by Member_ID__c asc Limit 1000';
            }
            system.Debug('>>strQuery >>'+ strQuery);                   
            for(SObject sObj : Database.Query(strQuery)) {
               Contact contObj = (Contact)sObj;
               WRContactDetails wrObj = new WRContactDetails();
               wrObj.contactId = contObj.Id;
               wrObj.contactName = contObj.Name;
               wrObj.contactMemberId = contObj.Member_ID__c;
               if(correspondenceType == Label.CL08_Member) {
                   wrObj.contactRelationship = contObj.Member_Subscriber_Relationship__c;
               } else {
                   wrObj.contactRelationship = Label.CL08_Member;
               }
               lstWRContacts.add(wrObj);
            }
        } catch(Exception ex) {}
    }
    
    public void searchMember() {
        try {
            if(!String.isBlank(inputSrch)) {
                lstWRContacts = new List<WRContactDetails>();
                string strQuery = 'select Name,Member_ID__c, Member_Subscriber_Relationship__c '+
                                   'from Contact where RecordType.Name = \'Member\' and (FirstName like \'' + String.escapeSingleQuotes(inputSrch.trim()) + '%\' OR ' + 
                                   ' LastName like \'' + String.escapeSingleQuotes(inputSrch.trim()) + '%\') ' +
                                   'order by Member_ID__c asc Limit 1000';
                system.Debug('>>strQuery >>'+ strQuery );                   
                for(SObject sObj : Database.Query(strQuery)) {
                   Contact contObj = (Contact)sObj;
                   WRContactDetails wrObj = new WRContactDetails();
                   wrObj.contactId = contObj.Id;
                   wrObj.contactName = contObj.Name;
                   wrObj.contactMemberId = contObj.Member_ID__c;
                   if(correspondenceType ==  Label.CL08_Member) {
                       wrObj.contactRelationship = contObj.Member_Subscriber_Relationship__c;
                   } else {
                       wrObj.contactRelationship = Label.CL08_Member;
                   }
                   lstWRContacts.add(wrObj);
                }                   
            }
        } catch(Exception ex) {}
    }
    
    public class WRContactDetails {
        public string contactId {get;set;}
        public string contactName {get;set;}
        public string contactMemberId {get;set;}
        public string contactRelationship {get;set;}
    }
}