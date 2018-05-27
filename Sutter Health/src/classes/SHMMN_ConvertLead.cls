/*********************************************************************************************  
*     Class Name  : SHMMN_ConvertLead                                                        
*     Author      : IDC Offshore                                                             
*     Date        : 07-Apr-2016                                                              
*     Project Name: CRM - SFT - Sutter Health                                                        
*     Description : Controller class for Strategic Marketing Lead Convert visualforce page.                                                         
**********************************************************************************************/
public without sharing class SHMMN_ConvertLead {
 
    public Boolean showduplicate {get;set;}
    public Boolean duplicateChecked {get;set;}
    public Boolean showpage{get;set;}
    public Boolean duplicate {get;set;}
    public Lead tLead {get; set;}
    public List<Account> accountSearched {get;set;}
    public Account newAccount {get;set;}
    public Contact newLeadContact {get;set;}
    public PageReference newPage {get;set;}
    public string checkQuery {get;set;}
    public string checkPhoneName {get;set;}
    public string checkNameAddress {get;set;}
    public string checkPhoneAddress {get;set;}
    public string checkName {get;set;}  
    public string checkAddress {get;set;}
    public string checkPhone {get;set;}
    public String RECORDTYPE_CONTACT {get;set;}
    public String RECORDTYPE_ACCOUNT {get;set;}
    public string checkContactName {get;set;}
    public List<ContactsList> wrapperListContact {get;set;}
    public List<ContactsList> selectedWrapperListContact {get;set;}
    public List<Contact> selectedContacts {get;set;}
    public Id AccountRecordTypeId {get;set;}
    public Id ContactRecordTypeId {get;set;}
    public static final string NO_DUPLICATE_MSG = 'Info: No duplicate account records found.';
    public static final string DUPLICATE_WARNING = 'Warning: Duplicate check is performed on basis of Account Name, Contact Name, Email, Address and Phone Number information. There are duplicate Accounts / Contacts already existing as per the criteria mentioned. Please click Approve again to continue lead conversion';
    public static final string APPROVE_MSG = 'Error: Do not select Rejection Reason when lead is approved.';
    public static final string SELECTOWNER_MSG = 'Error: Please select account owner before proceeding.';
    public static final string REJECTION_MSG = 'Error: Please select rejection reason first.';
    public static final string REJECTIONCOMMENT_MSG = 'Error: Enter Rejection Comments when Rejection Reason is Other';
    public static final string STATUS_MSG = 'Error: Status of Lead is not qualified. You cannot approve/ reject the lead until it is qualified.';
    public static final string ROLE_MSG = 'Error: Only Sales Managers can approve / reject the lead.';
    public static final string OWNER_MSG = 'Error: Owner of lead is queue. Please accept the lead before approving / rejecting the same.';
    public static final String SELECT_QUERY ='select id,Name,Phone,Region_Sales__c,Employer_Type__c,RecordType.Name,BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode, OwnerId  from account where';
    public static string RECORDTYPE_CLAUSE=' RecordTypeId =' + '\'';
    public static final String NAME_CLAUSE= ' name =' + '\'';
    public static final String PHONE_CLAUSE= ' phone =' + '\'';
    public static final String PHONE_AND_CLAUSE= ' and phone =' + '\'';
    public static final String BILLING_STREET_CLAUSE= ' BillingStreet =' + '\'' ;
    public static final String BILLING_STREET_AND_CLAUSE= ' and BillingStreet =' + '\'';
    public static final String BILLING_CITY_AND_CLAUSE= ' and BillingCity =' + '\'';
    public static final String BILLING_STATE_AND_CLAUSE= ' and BillingState =' + '\'' ;
    public static final String BILLING_POSTALCODE_AND_CLAUSE= ' and BillingPostalCode =' + '\'';
    public static final String BILLING_COUNTRY_AND_CLAUSE= ' and BillingCountry =' + '\'';
    public static final String BACK_SLASH= '\'';
    public static final String ORDERBY_NAME= ' order by name ';
    /****************** Contact Filters ****************/
    public List<Contact> contactSearched {get;set;}
    public string checkContactQuery {get;set;}
    public string checkContactPhoneName {get;set;}
    public string checkContactPhone {get;set;}        
    public string checkContactEmail {get;set;}
    public string checkContactPhoneEmail {get;set;}
    public string checkContactEmailName {get;set;}
    public string selectedRecord {get;set;}  
    public static final string NO_DUPLICATE_MSG_CONTACT = 'Info: No duplicate contact records found.';
    public static final string DUPLICATE_WARNING_CONTACT = 'Warning: Duplicate check is performed on basis of Contact Name, Address and Phone Number information. There are duplicate Contacts already existing as per the criteria mentioned. Please click Approve again to continue lead conversion';
    public static final String SELECT_QUERY_CONTACT ='select id, name, phone, email, MobilePhone, Account_Record_Type__c, RecordTypeId, Type__c from contact where';
    public static final String NAME_CLAUSE_CONTACT= ' name =' + '\'';   
    public static final String PHONE_CLAUSE_CONTACT= ' phone =' + '\'';
    public static final String PHONE_AND_CLAUSE_CONTACT= 'and phone =' + '\'';
    public static final String EMAIL_CLAUSE_CONTACT= ' email =' + '\'' ;
    public static final String EMAIL_AND_CLAUSE_CONTACT= ' and email =' + '\'' ;
    public static final string RECORDTYPE_BACKSLASH = '\' and ';
    
 /************************************************************************************
    *   @author ......: IDC Offshore                                                   
    *   @date ........: 07-Apr-2016                                                    
    *   @description .: This the constructor method provided by extension controller.
    *   @param........: Standard Controller                                                                 
    *   @return ......: [NA]                                                         
    *********************************************************************************/  
    public SHMMN_ConvertLead(ApexPages.StandardController controller) 
    {        
        this.tLead=(Lead)controller.getRecord();
        wrapperListContact = new List<ContactsList>();
        
        tLead = [SELECT id,firstname,lastname, name, phone, Company, Converted_Account__c, Description, Address, Lead_Assigned_To__c, Status, Industry, AnnualRevenue, LeadSource, Major_Carrier__c, 
                        Street, City, State, Country, Email, NumberOfEmployees, PostalCode, CreatedById,ownerId,Rejection_Reason__c, Account_Owner__c,Approval_Rejection_Comments__c,
                        Parent_Account__c, Lead_type__c  FROM Lead WHERE id =: ApexPages.currentPage().getParameters().get(System.Label.SHP_RFP_74) limit 1];
                                      
        if(tLead.Lead_type__c == 'Employer'){
            AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.CL_30_SM_SHMMNEmployer).getRecordTypeId();
            ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(System.Label.CL_30_SM_SHMMNEmployer).getRecordTypeId();
            RECORDTYPE_ACCOUNT = RECORDTYPE_CLAUSE + AccountRecordTypeId + RECORDTYPE_BACKSLASH ;
            RECORDTYPE_CONTACT = RECORDTYPE_CLAUSE + ContactRecordTypeId + RECORDTYPE_BACKSLASH ;            
        }
        else if(tLead.Lead_type__c == 'Broker'){  
            AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.CL_66_SM_SHMMNBroker).getRecordTypeId();
            ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(System.Label.CL_66_SM_SHMMNBroker).getRecordTypeId();      
            RECORDTYPE_ACCOUNT = RECORDTYPE_CLAUSE + AccountRecordTypeId + RECORDTYPE_BACKSLASH ;
            RECORDTYPE_CONTACT = RECORDTYPE_CLAUSE + ContactRecordTypeId + RECORDTYPE_BACKSLASH ;
            
        }/*
        else {
            RECORDTYPE_CLAUSE = '';
            AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
        }*/
        
        checkQuery = SELECT_QUERY + RECORDTYPE_ACCOUNT  + NAME_CLAUSE + tLead.Company + BACK_SLASH + PHONE_AND_CLAUSE + tLead.phone + BACK_SLASH + BILLING_STREET_AND_CLAUSE + tLead.Street + BACK_SLASH + BILLING_CITY_AND_CLAUSE + tLead.City + BACK_SLASH + BILLING_STATE_AND_CLAUSE + tLead.State + BACK_SLASH + BILLING_POSTALCODE_AND_CLAUSE + tLead.PostalCode + BACK_SLASH + BILLING_COUNTRY_AND_CLAUSE + tLead.Country + BACK_SLASH + ORDERBY_NAME;
        checkPhoneName = SELECT_QUERY + RECORDTYPE_ACCOUNT  + NAME_CLAUSE + tLead.Company + BACK_SLASH + PHONE_AND_CLAUSE + tLead.phone + BACK_SLASH + ORDERBY_NAME;
        checkNameAddress =  SELECT_QUERY + RECORDTYPE_ACCOUNT  + NAME_CLAUSE + tLead.Company + BACK_SLASH + BILLING_STREET_AND_CLAUSE + tLead.Street + BACK_SLASH + BILLING_CITY_AND_CLAUSE + tLead.City + BACK_SLASH + BILLING_STATE_AND_CLAUSE + tLead.State + BACK_SLASH + BILLING_POSTALCODE_AND_CLAUSE + tLead.PostalCode + BACK_SLASH + BILLING_COUNTRY_AND_CLAUSE + tLead.Country + BACK_SLASH + ORDERBY_NAME;
        checkPhoneAddress = SELECT_QUERY + RECORDTYPE_ACCOUNT  + PHONE_CLAUSE + tLead.phone + BACK_SLASH + BILLING_STREET_AND_CLAUSE + tLead.Street + BACK_SLASH + BILLING_CITY_AND_CLAUSE + tLead.City + BACK_SLASH + BILLING_STATE_AND_CLAUSE + tLead.State + BACK_SLASH + BILLING_POSTALCODE_AND_CLAUSE + tLead.PostalCode + BACK_SLASH + BILLING_COUNTRY_AND_CLAUSE + tLead.Country + BACK_SLASH + ORDERBY_NAME;
        checkName = SELECT_QUERY + RECORDTYPE_ACCOUNT  + NAME_CLAUSE + tLead.Company + BACK_SLASH + ORDERBY_NAME;
        checkAddress = SELECT_QUERY + RECORDTYPE_ACCOUNT  + BILLING_STREET_CLAUSE + tLead.Street + BACK_SLASH + BILLING_CITY_AND_CLAUSE + tLead.City + BACK_SLASH + BILLING_STATE_AND_CLAUSE + tLead.State + BACK_SLASH + BILLING_POSTALCODE_AND_CLAUSE + tLead.PostalCode + BACK_SLASH + BILLING_COUNTRY_AND_CLAUSE + tLead.Country + BACK_SLASH + ORDERBY_NAME;
        checkPhone =  SELECT_QUERY + RECORDTYPE_ACCOUNT  + PHONE_CLAUSE + tLead.phone + BACK_SLASH + ORDERBY_NAME;
        this.showduplicate =false;        
        this.duplicate = true;
        this.duplicateChecked = false;
        String uRoleId = UserInfo.getUserRoleId();
        UserRole roleName= [Select Name From UserRole where Id =: uRoleId limit 50000]; 
        Group queueId = [select Id from Group where Name =:System.Label.CL_24_SM_SHMMN_SalesM_Queue and Type =:System.Label.CL_24_SM_Queue limit 50000];
        
        checkContactQuery = SELECT_QUERY_CONTACT + RECORDTYPE_CONTACT + NAME_CLAUSE_CONTACT + tLead.Name + BACK_SLASH +PHONE_AND_CLAUSE_CONTACT+ tLead.Phone + BACK_SLASH + EMAIL_AND_CLAUSE_CONTACT + tLead.Email + BACK_SLASH  + ORDERBY_NAME;
        checkContactPhoneEmail = SELECT_QUERY_CONTACT + RECORDTYPE_CONTACT + PHONE_CLAUSE_CONTACT + tLead.Phone + BACK_SLASH + EMAIL_AND_CLAUSE_CONTACT + tLead.Email + BACK_SLASH + ORDERBY_NAME;
        checkContactEmailName = SELECT_QUERY_CONTACT + RECORDTYPE_CONTACT + NAME_CLAUSE_CONTACT + tLead.Name + BACK_SLASH + EMAIL_AND_CLAUSE_CONTACT + tLead.Email + BACK_SLASH + ORDERBY_NAME;
        checkContactPhoneName = SELECT_QUERY_CONTACT + RECORDTYPE_CONTACT + NAME_CLAUSE_CONTACT + tLead.Name + BACK_SLASH + PHONE_AND_CLAUSE_CONTACT + tLead.Phone + BACK_SLASH + ORDERBY_NAME;
        checkContactPhone = SELECT_QUERY_CONTACT + RECORDTYPE_CONTACT + PHONE_CLAUSE_CONTACT + tLead.Phone + BACK_SLASH + ORDERBY_NAME;
        checkContactEmail = SELECT_QUERY_CONTACT + RECORDTYPE_CONTACT + EMAIL_CLAUSE_CONTACT + tLead.Email + BACK_SLASH + ORDERBY_NAME;
        checkContactName = SELECT_QUERY_CONTACT + RECORDTYPE_CONTACT + NAME_CLAUSE_CONTACT + tLead.Name + BACK_SLASH + ORDERBY_NAME;
        
        setAccountOwner();      
        
        if(tLead.Status != System.Label.CL_25_SM_Qualified)
        {
            this.showpage = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,STATUS_MSG);
            ApexPages.addMessage(myMsg);
         
        }
        
        else if (roleName.Name != System.Label.CL_26_SM_SHMMNManager)
        {
            this.showpage = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,ROLE_MSG);
            ApexPages.addMessage(myMsg);
        }
        else if(tLead.OwnerId == queueId.Id)
        {
            this.showpage = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,OWNER_MSG);
            ApexPages.addMessage(myMsg);
        }
        else
        {
            this.showpage = true;
        }      
             
    }
/***************************************************************************************
    *   @author ......: IDC Offshore                                                      
    *   @date ........: 10-Apr-2016                                                       
    *   @description .: Method to set Account Owner for account inserted form lead conversion 
    *   @param........: [NA]                                                               
    *   @return ......: [NA]                                                            
    *************************************************************************************/  
    public void setAccountOwner()
    {
        if(tLead.Lead_Assigned_To__c != null)
            {
              tLead.Account_Owner__c = tLead.Lead_Assigned_To__c;
            }
        else if(tLead.Lead_Assigned_To__c == null)
            {
              tLead.Account_Owner__c = tLead.CreatedById;
            }
    }   
 /***************************************************************************************
    *   @author ......: IDC Offshore                                                      
    *   @date ........: 07-Apr-2016                                                       
    *   @description .: Method to check duplicate account records matching lead details 
    *   @param........: [NA]                                                               
    *   @return ......: [NA]                                                            
    *************************************************************************************/     
    public PageReference DuplicateCheck()
    {     
      try{
          accountSearched = new List<Account>();
          contactSearched = new List<Contact>();
          wrapperListContact = new List<ContactsList>();
          duplicateChecked = true;
          if (tLead.Company != null && tLead.Phone != null && tLead.Address != null && accountSearched.size() <= 0)  
          {
             accountSearched = Database.query(checkQuery);                                          
          } 
          if(tLead.Company != null && tLead.Phone != null && accountSearched.size() <= 0)
          {
             accountSearched = Database.query(checkPhoneName);
          }
          if(tLead.Company != null && tLead.Address != null && accountSearched.size() <= 0)
          {
             accountSearched = Database.query(checkNameAddress);
          }
          if(tLead.Company != null && accountSearched.size() <= 0)
          {
             accountSearched = Database.query(checkName);
          }
          if(tLead.Address != null && accountSearched.size() <= 0)
          {
             accountSearched = Database.query(checkAddress);
          }
          if(tLead.Phone != null && accountSearched.size() <= 0)
          {
             accountSearched = Database.query(checkPhone);
          }
          if(tLead.Phone != null && tLead.Address != null && accountSearched.size() <= 0 )
          {
             accountSearched = Database.query(checkPhoneAddress);
          }          
          if(tLead.Name != null && tLead.Phone != null && tLead.Email != null && contactSearched.size() <= 0)
          {      
             contactSearched = Database.query(checkContactQuery);
          }
          if(tLead.Name != null && tLead.Phone != null && contactSearched.size() <= 0)
          {
             contactSearched = Database.query(checkContactPhoneName);
          }
          if(tLead.Name != null && tLead.Email != null && contactSearched.size() <= 0) 
          {
              contactSearched = Database.query(checkContactEmailName);
          }
          if(tLead.Phone != null && tLead.Email != null && contactSearched.size() <= 0)
          {
              contactSearched = Database.query(checkContactPhoneEmail);
          }
          if(tLead.Phone != null && contactSearched.size() <= 0)
          {
              contactSearched = Database.query(checkContactPhone);
          }
          if(tLead.Email != null && contactSearched.size() <= 0)
          {
              contactSearched = Database.query(checkContactEmail);
          }
          if(tLead.Name != null && contactSearched.size() <= 0)
          {
              contactSearched = Database.query(checkContactName);
          }
                              
          if(!accountSearched.isEmpty())
          {
             showduplicate=true;    
             duplicate=false;         
          }      
          else 
          {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,NO_DUPLICATE_MSG);
             ApexPages.addMessage(myMsg);
          }
          
          if(!contactSearched.isEmpty())
          {
             showduplicate=true;  
             duplicate=false;
             for(Contact c : contactSearched){
                  ContactsList objContactsList = new ContactsList();
                  objContactsList.con = c;
                  objContactsList.selected = false;
                  wrapperListContact.add(objContactsList);
             }         
          }      
          else 
          {
             ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO,NO_DUPLICATE_MSG_CONTACT );
             ApexPages.addMessage(myMsg1);
          }
          return null;
       }catch(Exception e){
           ApexPages.addMessages(e);
           return null;
       }
    }
    
/*********************************************************************************************************
    *   @author ......: IDC Offshore                                                                       
    *   @date ........: 07-Apr-2016                                                                       
    *   @description .: Method to approve lead records, check for duplicates and convert lead to account 
    *   @param........: [NA]                                                                                 
    *   @return ......: PageReference to lead detail page                                                
    ******************************************************************************************************/      
    public PageReference Approve()
    {
       try{
           //wrapperListContact = new List<ContactsList>();
           if(!duplicateChecked)
               DuplicateCheck();
           
           if(accountSearched != null && accountSearched.size() > 0 && contactSearched.size() > 0 && duplicate == true)
           {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,DUPLICATE_WARNING);
              ApexPages.addMessage(myMsg);
              duplicate = false;
              duplicateChecked = true;
           } 
           else if(tLead.Rejection_Reason__c != null)
           {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,APPROVE_MSG);
              ApexPages.addMessage(myMsg);
           }
           else
           {
              
              if(tLead.Account_Owner__c == null)
              {
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,SELECTOWNER_MSG);
                  ApexPages.addMessage(myMsg);
              }
              else if (tLead.Account_Owner__c != null)
              {
                  newAccount = new Account();
                   
                  newAccount.Name = tLead.Company;
                  newAccount.Status__c = System.Label.CL_31_SM_Prospect;
                   
                  newAccount.RecordTypeid = AccountRecordTypeId;           
                  
                  if(tLead.Street != null)
                  {
                      newAccount.BillingStreet = tLead.Street;
                  }           
                  if(tLead.State != null)
                  {
                      newAccount.BillingState = tLead.State;
                  }           
                  if( tLead.City != null)
                  {
                     newAccount.BillingCity = tLead.City; 
                  }           
                  if (tLead.Country != null)
                  {
                      newAccount.BillingCountry = tLead.Country;
                  }           
                  if (tLead.PostalCode != null)
                  {
                      newAccount.BillingPostalCode = tLead.PostalCode;
                  }           
                  if (tLead.AnnualRevenue != null)
                  {
                      newAccount.AnnualRevenue = tLead.AnnualRevenue;
                  }           
                  if (tLead.NumberOfEmployees != null)
                  {
                       newAccount.NumberOfEmployees = tLead.NumberOfEmployees;
                  }           
                  if (tLead.Industry != null)
                  {
                      newAccount.Industry = tLead.Industry;
                  }           
                  if (tLead.Description != null)
                  {
                      newAccount.Description = tLead.Description;
                  }           
                  if (tLead.Phone != null)
                  {
                      newAccount.Phone = tLead.Phone;
                  }           
                  if (tLead.Account_Owner__c != null)
                  {                 
                      newAccount.OwnerId = tLead.Account_Owner__c;          
                  }
                  if (tLead.Parent_Account__c != null)
                  {                 
                      newAccount.ParentId = tLead.Parent_Account__c;          
                  }
                  if (tLead.Lead_Type__c == 'Broker')
                  {                                       
                      newAccount.Override_Duplicate__c = true;
                  }
                  
                  insert newAccount;
                  
                  tLead.Status = System.Label.CL_29_SM_Approved;
                  
                  if(!String.isBlank(tLead.Lead_Assigned_To__c))
                  {
                   tLead.Ownerid=tLead.Lead_Assigned_To__c;
                  }
                  else if (String.isBlank(tLead.Lead_Assigned_To__c))
                  {
                   tLead.Ownerid = tLead.CreatedById;
                  }
                                
                  tLead.Converted_Account__c = newAccount.id;
                  update tLead;                  
                  
                  selectedContacts = new List<Contact>();
                  if(wrapperListContact.size() > 0){
                      For(ContactsList contactList : wrapperListContact){  
                         if(selectedRecord == (String)(contactList.con.Id)){
                           selectedContacts.add(contactList.con); 
                         }                      
                      }
                  }
                  
                  if(selectedContacts.size() > 0){
                      insertContacts(newAccount, selectedContacts);
                  }
                  else{                      
                      newLeadContact = new Contact();         
                      newLeadContact.AccountId = tLead.Converted_Account__c;
                      newLeadContact.LastName = tLead.LastName;
                      newLeadContact.FirstName = tLead.FirstName;
                      newLeadContact.Email = tLead.Email;
                      newLeadContact.Phone = tLead.Phone;
                      newLeadContact.RecordTypeId = ContactRecordTypeId;
                      newLeadContact.ownerId = tLead.ownerId;
                      newLeadContact.MailingStreet = tLead.Street;
                      newLeadContact.MailingCity = tLead.city;
                      newLeadContact.MailingState = tLead.state;
                      newLeadContact.MailingCountry = tLead.country;
                      newLeadContact.MailingPostalCode = tLead.postalcode;
                      insert newLeadContact;         
                  }
                  newPage = new PageReference (System.Label.CL_32_SM_Slash + tLead.id); 
                  newPage.setRedirect(true);
              }
           } 
                      
           return newPage;
        }catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }
/*********************************************************************************************************
    *   @author ......: IDC Offshore                                                                      
    *   @date ........: 07-Apr-2016                                                                        
    *   @description .: Method to reject lead records and update lead status to Rejected                 
    *   @param........: [NA]                                                                                 
    *   @return ......: PageReference to lead detail page                                                
    ******************************************************************************************************/      
    public PageReference Reject()
    {       
       try{
           if(tLead.Rejection_Reason__c == null)
           {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,REJECTION_MSG);
              ApexPages.addMessage(myMsg);
           }
           else if(tLead.Rejection_Reason__c == System.Label.CL_27_SM_Other && tLead.Approval_Rejection_Comments__c == null)
           {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,REJECTIONCOMMENT_MSG);
              ApexPages.addMessage(myMsg);
           }
           else
           {
              tLead.Status = System.Label.CL_28_SM_Rejected;
              if(!String.isBlank(tLead.Lead_Assigned_To__c))
              {
               tLead.Ownerid=tLead.Lead_Assigned_To__c;
              }
              else if (String.isBlank(tLead.Lead_Assigned_To__c))
              {
               tLead.Ownerid = tLead.CreatedById;
              }           
              update tLead;
              newPage = new PageReference (System.Label.CL_32_SM_Slash + tLead.id);
           }       
          
           return newPage;
       }catch(Exception e){           
           ApexPages.addMessages(e);
           return null;
       }
    }
 /**********************************************************************************************************
    *   @author ......: IDC Offshore                                                                        
    *   @date ........: 07-Apr-2016                                                                         
    *   @description .: Method to open Account Hierarchy page of duplicate account records found           
    *   @param........: [NA]                                                                                   
    *   @return ......: PageReference to account hierarchy page of selected account                        
    ********************************************************************************************************/   
  public PageReference viewHierarchy() 
  {
     try{
         string passedParam1 = Apexpages.currentPage().getParameters().get(System.Label.CL_33_SM_Parentid);
         PageReference nextpage = new PageReference(System.Label.CL_34_SM_AccHierarchyJsp+passedParam1 );
         return nextpage;
     }catch(Exception e){
         
         ApexPages.addMessages(e);
         return null;
     } 
  }
 /**********************************************************************************************************
    *   @author ......: IDC Offshore                                                                        
    *   @date ........: 07-Apr-2016                                                                          
    *   @description .: Method to redirect from lead convert visualforce page to lead detail page          
    *   @param........: [NA]                                                                                   
    *   @return ......: PageReference to lead detail page                                                  
    ********************************************************************************************************/    
  public PageReference Cancel() 
  {     
         newpage = new PageReference(System.Label.CL_32_SM_Slash+ tLead.id );
         return newpage;        
  }
 /**********************************************************************************************************
  *   @author ......: IDC Offshore                                                                        
  *   @date ........: 18-Oct-2016
  *   @description .: Wrapper class for showing contacts          
  *   @param........: [NA]                                                                                   
  *   @return ......: [NA]                                                 
  ********************************************************************************************************/   
  public Class ContactsList{     
        public Contact con {get; set;}
        public Boolean selected {get; set;}
  }
 
  /**********************************************************************************************************
  *   @author ......: IDC Offshore                                                                        
  *   @date ........: 20-Oct-2016
  *   @description .: Create Relationship between account and contacts  
  *   @param........: [NA]                                                                                   
  *   @return ......: [NA]                                                 
  ********************************************************************************************************/   
  public void insertContacts(Account acc, List<Contact> selectedContact){    
                
        List<AccountContactRelation> listContactRelation = new List<AccountContactRelation>();
        for(Contact contactToRelate: selectedContact){
            AccountContactRelation objAccountContactRelation = new AccountContactRelation();
            objAccountContactRelation.AccountId = acc.Id;
            objAccountContactRelation.ContactId = contactToRelate.Id;
            listContactRelation.add(objAccountContactRelation);
        }
        insert listContactRelation;
  }
  
}