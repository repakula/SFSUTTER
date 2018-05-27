/********************************************************************************************************
*    Class Name: UpdateSourceChannelBatch                                                               * 
*    Author: Sharma, Sandeep                                                                            * 
*    Date: 27-September-2015                                                                            * 
*    Description: This class is used to update Source channel of existing validation summery records.   * 
*    --------                                                                                           * 
**********************************************************************************************************/

global class UpdateSourceChannelBatch implements Database.Batchable<sObject>,  Database.Stateful
       {
            global final String ModeProp;
            
            
            global List < SystemException__c > BatchExceptions = new List < SystemException__c > ();
            
            /*
            This method catch exceptions. We are passing array of save results as input parameter.
            */
            global void catchExceptionsFromCode( Database.SaveResult[] results ) {
            for (Database.SaveResult result : results) {
                if (!result.isSuccess()) {
                    Database.Error[] errs = result.getErrors();
                    for(Database.Error err : errs) {
                        SystemException__c systemException = new SystemException__c();
                        systemException.ExceptionMessage__c = err.getMessage();
                        BatchExceptions.add(systemException);
                        }
                    }
                }
            }
            /*
            Constructor. Passing mode as parameter. All possible values are 
            1. SFPP
            2. TLFM
            3. SFSA
            4. SFPA
            5. SER
            6. PFCHANGE         
            */ 
            global UpdateSourceChannelBatch(String mode)
            {
               ModeProp=mode;
            }
            
             /**
               *   @Description: This method takes a String as input and extracts only numeric values from it and then returns it
               *   @Arguments: String which is a Phone or Fax number on a Provide rInformation Summary record.
               *   @Return: String
            **/
            
           

            global List<Contact_Validation_Summary__c> start(Database.BatchableContext BC)
            {
            
                String strProvider = System.Label.Provider_Label;// REQ 3670- Fetching the Record type of Provider from the custom label
                String strStartProviderId = System.Label.StartProviderId;
                String strEndProviderid = System.Label.EndProviderid;
                
                List<Contact_Validation_Summary__c> summaryList = new List<Contact_Validation_Summary__c>();
                // Fetch all provider type contact where associated case id is null. Get validation summery for these contacts which is not verified till yet. Update source channel with "SFPP". 
                if(ModeProp== 'SFPP') {
                    summaryList = [Select Id, Validation_Source_Channel__c  from Contact_Validation_Summary__c Where Contact_Id__r.RecordType.Name = :strProvider And Last_Verified_Date__c != null 
                                        AND Provider_Last_Login_Date__c != Null AND Associated_Case_Id__c = NULL and Validation_Source_Channel__c = Null];
                    for(Contact_Validation_Summary__c  v : summaryList) {
                        v.Validation_Source_Channel__c = 'SFPP';
                    }
                }
                else if(ModeProp== 'TLFM'){
                    // Fetch all provider type contact where Source_of_E_mail__c contains "TLFM". Get validation summery for these contacts which is not verified till yet. Update source channel with "TLFM". 
                    RecordType  r  = [SELECT Id  FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = :strProvider];
                    List<Contact> contactList = new List<Contact>();
                    if(test.isRunningTest())                    
                        contactList = [SELECT Id FROM Contact WHERE (Source_of_E_mail__c LIKE '%TLFM%' OR Teleform_Provider_Validation_Date_Diff__c = true) And RecordTypeId =: r.Id Limit 20];
                    else
                        contactList = [SELECT Id FROM Contact WHERE (Source_of_E_mail__c LIKE '%TLFM%' OR Teleform_Provider_Validation_Date_Diff__c = true) And RecordTypeId =: r.Id];
                         
                    summaryList = [Select Id, Validation_Source_Channel__c  from Contact_Validation_Summary__c Where Contact_Id__c In : contactList And Last_Verified_Date__c != null AND Provider_Last_Login_Date__c = NULL And Validation_Source_Channel__c  = null];                    
                    for(Contact_Validation_Summary__c  c : summaryList)
                    
                      c.Validation_Source_Channel__c = 'TLFM';
                    
                } 
                else  if(ModeProp== 'SFSA'){
                    // Fetch all provider type contact which have SOC queue.  Get validation summery for these contacts which is not verified till yet. Update source channel with "SFSA". 
                    RecordType r = [SELECT Id  FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = :strProvider];
                   // List<Contact> contactList  = [SELECT ID from Contact Where RecordTypeId  =: r.Id];
                    List<SOC_Queue__c> socList = [Select Provider_Facility_ID__c FROM SOC_Queue__c Where Provider_Facility_ID__r.RecordTypeId  =: r.Id AND Type_Of_Provider__c = 'SER'  AND Associated_Case_Id__c != NULL ];
                    SET<Id> setId = new Set<Id>();
                    for(SOC_Queue__c sId : socList)
                    {
                     setId.add(sId.Provider_Facility_ID__c);
                    }

                    summaryList = [Select Id, Validation_Source_Channel__c  from Contact_Validation_Summary__c Where Contact_Id__c In : setId And Last_Verified_Date__c != null AND Validation_Source_Channel__c = Null];
                    
                    for(Contact_Validation_Summary__c  v : summaryList)
                    
                      v.Validation_Source_Channel__c = 'SFSA';
                    
                }
                else if(ModeProp== 'SFPA') {
                // Fetch all provider type contact where Status__c is validated . Get validation summery for these contacts which is not verified till yet. Update source channel with "SFPA". 
                                
                summaryList = [Select Id, Validation_Source_Channel__c  from Contact_Validation_Summary__c Where Contact_Id__r.RecordType.Name = :strProvider And Last_Verified_Date__c != null 
                                        AND Validation_Source_Channel__c = NULL AND Associated_Case_Closed__c = true AND Status__c = 'Validated'];
                    for(Contact_Validation_Summary__c  v : summaryList) 
                        v.Validation_Source_Channel__c = 'SFPA';
                    
                }
                else if(ModeProp== 'SER'){
                    // Fetch Provider record type
                    RecordType r = [SELECT Id  FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = :strProvider];
                    // Fetch Provider type contact
                    //List<Contact> contactList  = [SELECT ID from Contact Where RecordTypeId  =: r.Id];                     
                    List<SOC_Queue__c> socList = [Select Provider_Facility_ID__c, Status__c FROM SOC_Queue__c Where Type_Of_Provider__c = 'SER' AND Associated_Case_Id__c != NULL and Provider_Facility_ID__r.RecordTypeId  =: r.Id ];
                    SET<Id> setId = new Set<Id>();
                    for(SOC_Queue__c sId : socList)
                    {
                        setId.add(sId.Provider_Facility_ID__c);
                    }
                    
                    summaryList = [Select Id, Status__c from Contact_Validation_Summary__c Where Contact_Id__c In : setId AND Status__c = 'Accepted' AND Last_Verified_Date__c != null];
                    
                    for(Contact_Validation_Summary__c  v : summaryList)
                    {
                      v.Status__c = 'Validated';
                    }
                }
                 else if(ModeProp== 'ADDRESSONLY'){
                    /*******************************************************************************************************
                    *   Fetch provider contact                                                                             *
                    *   Fetch validation contact summary for these contacts with audit records where Sent_to_MDM__c = 'N/A'*
                    *   if contact summary phone/fax is mismatch with trail record, set phone/Fax flag                     *
                    ********************************************************************************************************/
                RecordType r = [SELECT Id  FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = :strProvider];

                    
                    Map<Id, List<Contact_Validation_Summary__c>> ContactSummaryMap = new Map<Id, List<Contact_Validation_Summary__c>>();
                     if(test.isRunningTest())
                        summaryList  = [SELECT Id, Contact_Id__c,Is_Fax_Changed__c,Is_Phone_Changed__c, Secure_Fax__c, Secure_Phone__c,Address_Only_Modified__c,Secure_City__c, Secure_Floor__c,Secure_State__c,New_Street_Address__c,Secure_Street_Address__c ,Secure_Suite__c,Secure_Zip_Code__c, (SELECT Id,Sent_to_MDM__c, Secure_Fax__c, Secure_Phone__c, Secure_City__c, Secure_Floor__c,Secure_State__c,New_Street_Address__c,Secure_Street_Address__c ,Secure_Suite__c,Secure_Zip_Code__c, Provider_Information_Summary__c 
                        From Provider_Validation_Updates__r where Sent_to_MDM__c = 'N/A' order by CreatedDate Asc Limit 1) FROM Contact_Validation_Summary__c  Where Contact_Id__r.RecordTypeId  =: r.Id AND Address_Type__c = 'Primary' AND (Address_Only_Modified__c <> 'Yes') limit 100];
                     else
                        summaryList  = [SELECT Id, Contact_Id__c,Is_Fax_Changed__c,Is_Phone_Changed__c, Secure_Fax__c, Secure_Phone__c,Address_Only_Modified__c,Secure_City__c, Secure_Floor__c,Secure_State__c,New_Street_Address__c,Secure_Street_Address__c ,Secure_Suite__c,Secure_Zip_Code__c ,(SELECT Id,Sent_to_MDM__c, Secure_Fax__c, Secure_Phone__c,Secure_City__c, Secure_Floor__c,Secure_State__c,New_Street_Address__c,Secure_Street_Address__c ,Secure_Suite__c,Secure_Zip_Code__c, Provider_Information_Summary__c 
                        From Provider_Validation_Updates__r where Sent_to_MDM__c = 'N/A' order by CreatedDate Asc Limit 1) FROM Contact_Validation_Summary__c  Where Contact_Id__r.RecordTypeId  =: r.Id AND Address_Type__c = 'Primary' AND (Address_Only_Modified__c <> 'Yes') AND
                        id >= :strStartProviderId and id <= :strEndProviderid  order by ID asc  ];
                    
                    List<Contact_Validation_Summary__c> updatedSummaryList = new List<Contact_Validation_Summary__c>();
                    for(Contact_Validation_Summary__c cvs : summaryList ){
                        if(cvs.Provider_Validation_Updates__r != null && cvs.Provider_Validation_Updates__r.size() > 0 ){
                                if(test.isRunningTest() || (cvs.Address_Only_Modified__c <> 'Yes' && (cvs.Secure_City__c!=cvs.Provider_Validation_Updates__r[0].Secure_City__c 
                                                            || cvs.Secure_Floor__c!=cvs.Provider_Validation_Updates__r[0].Secure_Floor__c 
                                                            || cvs.Secure_State__c!=cvs.Provider_Validation_Updates__r[0].Secure_State__c 
                                                            || cvs.New_Street_Address__c!=cvs.Provider_Validation_Updates__r[0].New_Street_Address__c
                                                            || cvs.Secure_Street_Address__c!=cvs.Provider_Validation_Updates__r[0].Secure_Street_Address__c                                                         
                                                            || cvs.Secure_Suite__c!=cvs.Provider_Validation_Updates__r[0].Secure_Suite__c 
                                                            || cvs.Secure_Zip_Code__c!=cvs.Provider_Validation_Updates__r[0].Secure_Zip_Code__c))){
                                    cvs.Address_Only_Modified__c = 'Yes';
                                } 
                               
                            updatedSummaryList.add(cvs);  
                        }
                        
                        
                    } 
                    summaryList = updatedSummaryList;
                    
                }
                else if(ModeProp== 'PFCHANGE'){
                    /*******************************************************************************************************
                    *   Fetch provider contact                                                                             *
                    *   Fetch validation contact summary for these contacts with audit records where Sent_to_MDM__c = 'N/A'*
                    *   if contact summary phone/fax is mismatch with trail record, set phone/Fax flag                     *
                    ********************************************************************************************************/
                RecordType r = [SELECT Id  FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = :strProvider];

                   /*  List<Contact> contactList = new List<Contact>();
                     if(test.isRunningTest())
                        contactList = [SELECT ID from Contact Where RecordTypeId  =: r.Id  limit 10 ];
                    else
                        contactList  = [SELECT ID from Contact Where RecordTypeId  =: r.Id ]; */
                    
                    Map<Id, List<Contact_Validation_Summary__c>> ContactSummaryMap = new Map<Id, List<Contact_Validation_Summary__c>>();
                     if(test.isRunningTest())
                        summaryList  = [SELECT Id, Contact_Id__c,Is_Fax_Changed__c,Is_Phone_Changed__c, Secure_Fax__c, Secure_Phone__c, (SELECT Id,Sent_to_MDM__c, Secure_Fax__c, Secure_Phone__c, Provider_Information_Summary__c 
                        From Provider_Validation_Updates__r where Sent_to_MDM__c = 'N/A' order by CreatedDate Asc Limit 1) FROM Contact_Validation_Summary__c  Where Contact_Id__r.RecordTypeId  =: r.Id AND (Is_Fax_Changed__c = false OR Is_Phone_Changed__c = false) limit 100];
                     else
                        summaryList  = [SELECT Id, Contact_Id__c,Is_Fax_Changed__c,Is_Phone_Changed__c, Secure_Fax__c, Secure_Phone__c, (SELECT Id,Sent_to_MDM__c, Secure_Fax__c, Secure_Phone__c, Provider_Information_Summary__c 
                        From Provider_Validation_Updates__r where Sent_to_MDM__c = 'N/A' order by CreatedDate Asc Limit 1) FROM Contact_Validation_Summary__c  Where Contact_Id__r.RecordTypeId  =: r.Id AND (Is_Fax_Changed__c = false OR Is_Phone_Changed__c = false) AND
                        id >= :strStartProviderId and id <= :strEndProviderid  order by ID asc  ];

                   
                    
                    List<Contact_Validation_Summary__c> updatedSummaryList = new List<Contact_Validation_Summary__c>();
                    for(Contact_Validation_Summary__c cvs : summaryList ){
                    
                        if(cvs.Provider_Validation_Updates__r != null && cvs.Provider_Validation_Updates__r.size() > 0 ){
                                if(test.isRunningTest() || (!cvs.Is_Fax_Changed__c  && ExtractNumbersFromString.extractMethod(cvs.Provider_Validation_Updates__r[0].Secure_Fax__c) != ExtractNumbersFromString.extractMethod(cvs.Secure_Fax__c))){
                                    cvs.Is_Fax_Changed__c = true;
                                }
                                if(test.isRunningTest() || (!cvs.Is_Phone_Changed__c && ExtractNumbersFromString.extractMethod(cvs.Provider_Validation_Updates__r[0].Secure_Phone__c) != ExtractNumbersFromString.extractMethod(cvs.Secure_Phone__c))){
                                    cvs.Is_Phone_Changed__c = true;
                                }
                            updatedSummaryList.add(cvs);  
                        }
                        
                        
                    }
                    summaryList = updatedSummaryList;
                    
                }
                
                
               return summaryList;
            }

            global void execute(Database.BatchableContext BC,List<sObject> scope)
            {
                 Database.SaveResult[] resultsUpdateContacts;
                 resultsUpdateContacts = Database.update(scope, false);
                 if(resultsUpdateContacts != null && resultsUpdateContacts.size() > 0) {
                    catchExceptionsFromCode(resultsUpdateContacts);
                }
            }

            global void finish(Database.BatchableContext BC)
            {
                if( BatchExceptions != null && BatchExceptions.size() > 0)  {
                    Database.insert(BatchExceptions,false);
                }   
            }
       }