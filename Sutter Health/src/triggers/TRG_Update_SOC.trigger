trigger TRG_Update_SOC on SOC_Queue__c (before update,before insert) {
    
    private static final String QUEUE_ID_PREFIX = '00G';
    private static final String USER_ID_PREFIX = '005';
    private static final String ACCEPTED_STATUS = 'Accepted';
   if(Trigger.isUpdate) {  
    try{
        for(SOC_Queue__c soc : Trigger.new){
            
            if(trigger.oldMap.get(soc.id).OwnerId <> soc.OwnerId){
                
                String oldOwnerIdPrefix = String.valueOf(trigger.oldMap.get(soc.id).OwnerId).subString(0,3);
                String newOwnerIdPrefix = String.valueOf(soc.OwnerId).subString(0,3);
                
                if(oldOwnerIdPrefix == QUEUE_ID_PREFIX && newOwnerIdPrefix == USER_ID_PREFIX){
                    
                    soc.Status__c = ACCEPTED_STATUS;
                }
            }
        }
    } catch(Exception classException) {
        Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
    }
  }
 /* Insert Provider summary record for provider which does not have summary record */
  if(Trigger.isInsert) { 
  
    List<Contact> providerContacts = new List<Contact>();
    List<Contact_Validation_Summary__c> summaryContacts = new List<Contact_Validation_Summary__c>();
    list<Contact_Validation_Summary__c> cvsList = new list<Contact_Validation_Summary__c>(); 
    Map<id,string> MapSERContactIds = new Map<id,string>();
  for(SOC_Queue__c objSocQ:Trigger.New) {
            if(objSocQ.Type_of_Provider__c == 'SER'){
            MapSERContactIds.put(objSocQ.Provider_Facility_ID__c,objSocQ.Type_of_Provider__c);
            }
        }
        
 summaryContacts = [select Contact_Id__c,Address_Type__c from Contact_Validation_Summary__c where Contact_Id__c in: MapSERContactIds.keyset() and  Address_Type__c = 'Primary']; 
 

        
  for(Contact_Validation_Summary__c tempsummary:summaryContacts){    
  
     MapSERContactIds.remove(tempsummary.Contact_Id__c); 

  }
  
        
     
    providerContacts =  [select Provider_Name__c,Provider_Title__c,Email,MobilePhone,Provider_Correspondence_Address__c,Provider_Correspondence_City__c,
    Provider_Correspondence_State__c,Provider_Correspondence_PostalCode__c,Provider_Correspondence_Phone__c,Provider_Correspondence_Fax_Number__c,               Contact_External_ID1__c,id,Username__c from contact where id in: MapSERContactIds.keyset()  ];  
    
  // Integer primaryaddress = [select count() from Contact_Validation_Summary__c where Contact_Id__c in: setSERContactIds and  Address_Type__c = 'Primary'];  
  
   if(providerContacts != null && !providerContacts.isEmpty()) {
  
           try { 
            for(Contact tempCon : providerContacts) {
                
                cvsList.add(new Contact_Validation_Summary__c(
                    Provider_Name__c = tempCon.Provider_Name__c
                    , Provider_Title__c = tempCon.Provider_Title__c
                    , Email__c = tempCon.Email
                    , Mobile_Phone__c = tempCon.MobilePhone
                    , Secure_Street_Address__c = tempCon.Provider_Correspondence_Address__c
                    , Secure_City__c = tempCon.Provider_Correspondence_City__c
                    , Secure_State__c = tempCon.Provider_Correspondence_State__c
                    , Secure_Zip_Code__c = tempCon.Provider_Correspondence_PostalCode__c
                    , Secure_Phone__c = tempCon.Provider_Correspondence_Phone__c
                    , Secure_Fax__c = tempCon.Provider_Correspondence_Fax_Number__c
                    , Provider_ID__c = tempCon.Contact_External_ID1__c
                    , Contact_ID__c = tempCon.id
                    , Username__c = tempCon.Username__c
                    , New_Street_Address__c = tempCon.Provider_Correspondence_Address__c
                ));
            }  
            
            insert cvsList; 
            
        } catch(Exception e) {
            Utility.handleExceptionFromCode(e.getMessage() + '\r\n' + e.getStackTraceString() + '\r\n' + e.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }

   }   

  }  



  
}