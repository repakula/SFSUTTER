/**  
*    Trigger Name: Account_Owner_Validation
*    Author: IDC
*    Date: 17-September-2013
*    Description: This trigger is for Defect #2603 and fires when SHP Sales User tries to change the 
*    owner of Account to a User other than SHP Sales Profile
*
*     History
*     --------
*
*     VERSION    AUTHOR         DATE        DETAIL 
*       2.0     IDC Offshore   05/02/2014  Added functionality to insert and update Account Employer__c field on Account insert and update
*       3.0     IDC Offshore   05/03/2016  Added functionality to check for duplicate records for SHMMN Broker Accounts as part of Req-3826.
**/
trigger Account_Owner_Validation on Account (before insert, before update) {
    
  /*Req - 3880 Archive Changes STARTS */
  if(UserInfo.getProfileId() != System.Label.Integration_Admin_ProfileId){
        if(Trigger.isInsert && Trigger.isBefore){
            Set<ID> archiveConIds = new Set<ID>();
            for(Account accObj : Trigger.New){
                archiveConIds.add(accObj.Broker_Rep__c);
                archiveConIds.add(accObj.Broker_Contact__c);
            }
            if(!archiveConIds.isEmpty()){
                Map<String,Contact> conMap = new Map<String,Contact>([select ID,Archive__c from Contact where ID IN:archiveConIds and Archive__c = true]);
                for(Account accObj : Trigger.New){
                    if(conMap.get(accObj.Broker_Rep__c) != NULL && conMap.get(accObj.Broker_Rep__c).Archive__c){
                        accObj.AddError(System.Label.SHP_Archive_Error);
                    }else if(conMap.get(accObj.Broker_Contact__c) != NULL && conMap.get(accObj.Broker_Contact__c).Archive__c){
                        accObj.AddError(System.Label.SHP_Archive_Error);
                    }
                }
            }
            
        }
        
        if(Trigger.isUpdate && Trigger.isBefore){
            Set<ID> archiveConIds = new Set<ID>();
            for(Account accObj : Trigger.New){
                if(HighRoads_ArchivedContacts.isByPassValidationUpdated && accObj.By_Pass_Archive_Contact_Validation__c == FALSE){
                    archiveConIds.add(accObj.Broker_Rep__c);
                    archiveConIds.add(accObj.Broker_Contact__c);
                }
                
            }
            HighRoads_ArchivedContacts.isByPassValidationUpdated = false; 
            if(!archiveConIds.isEmpty()){
                Map<String,Contact> conMap = new Map<String,Contact>([select ID,Archive__c from Contact where ID IN:archiveConIds and Archive__c = true]);
                for(Account accObj : Trigger.New){
                    if(conMap.get(accObj.Broker_Rep__c) != NULL && conMap.get(accObj.Broker_Rep__c).Archive__c){
                        accObj.Broker_Rep__c.AddError(System.Label.SHP_Archive_Error);
                    }else if(conMap.get(accObj.Broker_Contact__c) != NULL && conMap.get(accObj.Broker_Contact__c).Archive__c){
                        accObj.Broker_Contact__c.AddError(System.Label.SHP_Archive_Error);
                    }
                }
                
            }
    }
    }
    /*Req - 3880 Archive Changes ENDS */
    
    static final string SELECT_QUERY = 'SELECT Id FROM Account WHERE';
    String loggedInprofileId = UserInfo.getProfileId();
    Map<ID, User> mapSalesUser = new Map<ID, User>();
    
    List<Account> accountRegionToUpdate = new List<Account>(); //3261
    Set<Id> profileSet = new Set<Id>();
    List<Profile> profileList = [SELECT Id, Name FROM Profile where Name = 'SHP Sales' limit 1];
    //3261 start
    Map<String,ZipcodeAndRegion__c> customSetting =  ZipcodeAndRegion__c.getAll(); //3261
    Map<String,String> PincodewithRegion = new Map<String,String>(); //stores the Pincode along with their region
    for(ZipcodeAndRegion__c zpcode: customSetting.values() )
    {
    PincodewithRegion.put(zpcode.Zipcode__c,zpcode.Region__c);
    }
    // 3261 end
    
    
    for(User userItem : [Select Id, name from User where ProfileId =: profileList[0].Id])
    {
        mapSalesUser.put(userItem.id, userItem);
    }
    
  //  RecordType RecType = [Select Id From RecordType Where SobjectType = 'Account' and DeveloperName = 'S3_Employee'];
    
  //  RecordType RecTypeSalesEmp = [Select Id From RecordType Where SobjectType = 'Account' and (DeveloperName = 'SHP_Sales_Employer')];//3261
    
    Id s3EmployeeRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('S3 Employee').getRecordTypeId();
    
    Id shpSalesRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
    
    for(Account acc : Trigger.New){
        if(trigger.isUpdate){
            if(acc.OwnerId <> trigger.oldMap.get(acc.Id).OwnerId){
                if(loggedInprofileId == profileList[0].Id && !mapSalesUser.containsKey(acc.ownerId)){ 
                    acc.addError('Account Ownership can be transferred only to a SHP Sales User');
                }
            }
            // Req 3261
            if((acc.BillingPostalCode <> trigger.oldMap.get(acc.Id).BillingPostalCode) && acc.RecordTypeId == shpSalesRecTypeId)
            {
                accountRegionToUpdate.add(acc);
            }
          
        }
        
        //3261
        
        if((acc.RecordTypeId == shpSalesRecTypeId) && (acc.BillingPostalCode <> null || acc.BillingPostalCode <> '') && trigger.isInsert)
        {
            accountRegionToUpdate.add(acc);
            
        }  //3261
        
        
        /** @Description: Rel 5.1 change - Set S3 Employee Account's Employer field with SutterHeath. 
                            This field is used in the Community Portal sharing setting 
        **/
        if(acc.RecordTypeId == s3EmployeeRecTypeId){
            acc.Employer__c = Label.Acc_SutterHealthAccount;
        }
    }
/**@ Description: Req-3826: Changes done for duplicate check on SHMMN Broker Account.******/
    /***** Req-3826 Changes Start******/
    if(Trigger.isInsert || Trigger.isUpdate)
    {
      Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
      List<Account> accList= new List<Account>();
      
      List<Account> dupes = new List<Account>();
      Set<string> namelist= new Set<string>();
      
      Map<string, id > duplicateAccountIds = new Map<string, id >();
      
      
      set<String> duplicateAccountNameSet = new set<String>();
     
      //save the list of Account name if Account is of SHMMN Broker type
      for(Account acc: Trigger.new)
      { 
          if(rtMap.get(acc.RecordTypeId) != NULL && rtMap.get(acc.RecordTypeId).getName().equalsIgnoreCase(System.Label.CL_66_SM_SHMMNBroker))  {
            if(!namelist.add(acc.Name)){
                duplicateAccountNameSet.add(acc.Name);
            } 
          }
      } 
      // Fetch the list of SHMMN account whose name is similar/duplicate
      accList= [Select name From Account where name = :namelist and Recordtype.Name =: System.Label.CL_66_SM_SHMMNBroker ];
      
      // creates a map for possible duplicate account 
      for(Account dup: accList )
       {
         duplicateAccountIds.put(dup.Name,dup.id);
          
       }
       for (Account myAccount : Trigger.new) 
       {
        if (myAccount.Name != null && rtMap.get(myAccount.RecordTypeId) != NULL && rtMap.get(myAccount.RecordTypeId).getName().equalsIgnoreCase(System.Label.CL_66_SM_SHMMNBroker) && myAccount.Override_Duplicate__c==false ) 
          {
            if( Trigger.isInsert && duplicateAccountIds.containsKey(myAccount.Name) && duplicateAccountIds.get(myAccount.Name) != myAccount.id)
             {
                    myAccount.addError(System.Label.CL_67_SM_DuplicateAccountError );
             }

            
            else if(Trigger.isUpdate &&  ((duplicateAccountIds.containsKey(myAccount.Name) && duplicateAccountIds.get(myAccount.Name)!= myAccount.id) || (duplicateAccountNameSet.contains(myAccount.Name))))  
              {
                    myAccount.addError(System.Label.CL_67_SM_DuplicateAccountError );
                    
              } 
              }
        }
        for(Account acc : accountRegionToUpdate)
        {   
            acc.Region_Sales__c = PincodewithRegion.get(acc.BillingPostalCode);
        }
    }
    /****** Req-3826 Changes End*****/
}