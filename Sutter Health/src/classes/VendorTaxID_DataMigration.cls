/**  
*     Class Name  : VendorTaxID_DataMigration
*     Author      : IDC Offshore
*     Date        : 2-MAY-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : VendorTaxID_DataMigration Batch Class.
**/
/* Start Method Of Batch Class */
global class VendorTaxID_DataMigration implements Database.Batchable <sObject> {
   
global final string query ='Select Id,Vendor_TaxID__c,AccountId, Account.RecordType.Name FROM Contact where RecordType.Name =\'Vendor\'';
global List<id> failedAccountIDList = new List<id>();
   
global Database.QueryLocator start(Database.BatchableContext BC){
return Database.getQueryLocator(this.query);
}
   
/* Execute Method Of Batch Class */
global void execute(Database.BatchableContext BC,List<sObject>scope){
   
   List<Contact> existingContacts = (List<Contact>)scope;
   Map<Id, Account> lstAccToUpdate = new Map<Id, Account>();
   //Map<ID, Account> AccountMap = new Map<ID, Account>([Select Id,Vendor_Tax_ID__c FROM Account where RecordType.Name = 'S3 Vendor'] );
   Set<Id> accountIds = new Set<Id>();
   list<id> failedAccountID = new list<id>();
   set<id> successAccountID = new set<id>();
   //Fetching the Account object from the Account Map fetched from the Account Object.
   for(Contact con:existingContacts)
   {
       System.Debug(' Trigger 1 - ' + con.id);
       //Account acc = AccountMap.get(con.AccountId);
       if (con.Account.RecordType.Name=='S3 Vendor'){
           Account acc = new Account();
           acc.id=con.AccountId;
           acc.Vendor_Tax_ID__c = con.Vendor_TaxID__c;
           //putting the account record into the map
           lstAccToUpdate.put(acc.Id, acc);
           System.Debug('++++---Trigger2 '+ con.id + ' Account - ' + acc.id + ' RecordType - ' + con.Account.RecordType.Name);
       }
   }
        System.Debug('Final List - ' + lstAccToUpdate);
        database.saveresult[] saveResults;
        
        if (lstAccToUpdate!= Null && lstAccToUpdate.size()>0 )
        {
            saveResults = database.update(lstAccToUpdate.values(),false);
        }
        if (saveResults != Null)
        {
            for(Database.saveresult sr: saveResults )
            {
                if(sr.isSuccess())
                {
                    successAccountID.add(sr.getId());
                }
            }
        }
        for(Id tempId:lstAccToUpdate.keyset())
        {
            if(!successAccountID.contains(tempId))
            {
                failedAccountID.add(tempId);
            }
        }
        
        
        if(!failedAccountID.isEmpty())
           {
                failedAccountIDList.addAll(failedAccountID);
           }
   
   }

/* Finsih Method of Batch Class */   
global void finish(Database.BatchableContext BC){
      
      string emailString = '';
      if(!failedAccountIDList.isEmpty()){
        for(Id tempId: failedAccountIDList) {
       emailString = emailString + '##AccountId :' + tempId  +'\r\n';
        }
        Utility.sendErrorEmail('###Failed Ids ::  '+ emailString);
        
     }
   }
 }