/*
*     Class Name  : CorrespondenceCls
*     Author      : IDC Offshore
*     Date        : 02-Dec-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : CorrespondenceCls Class and Correspondence VF page.
*
*       History
*      
*       VERSION         AUTHOR              DATE              DETAIL 
*         2.0          Saddam Hussain      07/04/2015       Updates  the class to Add Comments History Grid for REQ 3406 and attach documents to Correspondence Requests for REQ 3315
*/
public with sharing Class CorrespondenceCls {
    public Correspondence__c correspondenceObj {get;set;}
    string serviceId;
    public string contactId {get;set;}
    public string contactName {get;set;}
    public string subId {get;set;}
    public boolean isDefault {get;set;}
    public boolean isDisabled {get;set;}
    public string subScriberId {get;set;}
    ApexPages.StandardController  controller;
    Contact contactObj;
    public string subjectId {get;set;}
    public string strHeaderMsg {get;set;}
    public WrSystemInformation wrSystemInfo {get;set;}
    BusinessHours defaultHours;
    Contact contactFromUrlDetail;
    public string correspondenceStatus {get;set;}
    public string correspondenceComments {get;set;}
    public boolean isUserSHPAgent {get;set;}
    public boolean isUserSHPCorrespondence {get;set;}
    string strVehicleValueOnOnLoad;
    String corresid;
    public List<Correspondence_Comments__c> correspondenceComment {get;set;}
    public boolean displaycomments {get; set;}
    //Start Attachment
   public transient Attachment attachment;
     
    //End Attachment
    public CorrespondenceCls(ApexPages.StandardController  controller) {
        correspondenceObj = new Correspondence__c();
        //3151
        //correspondenceObj.Address_same_as_Default__c = true;
        corresid = ApexPages.currentPage().getParameters().get('id');
        
        String getId = controller.getId();
        serviceId = ApexPages.CurrentPage().getParameters().get('ServiceId');
        contactId = ApexPages.CurrentPage().getParameters().get('ContactId');
        this.controller = controller;
        isDefault = true;
        isDisabled = true;
        contactObj = new Contact();
        wrSystemInfo = new WrSystemInformation();
        displaycomments  = false;
        correspondenceComments = '';
        isUserSHPAgent = false;
        isUserSHPCorrespondence = false;
        Profile userProfile = [select Name from Profile where id = :UserInfo.getProfileId()];
        if(Label.Correspondence_Agents_Profiles.containsIgnoreCase(userProfile.Name)) {
            isUserSHPAgent = true;
        } else if(Label.SHP_Correspondence.containsIgnoreCase(userProfile.Name)) {
            isUserSHPCorrespondence = true;
        }
        try {
            if(controller.getId() != null) {
                correspondenceObj = [select Contact__c,Street__c,City__c,State__c,Country__c,ZipCode__c,Overnight__c,Triggered_in_Health_Rules__c,
                                      Subject_Name__c,Member_Type__c,Correspondence_Type__c, Date_Sent_To_Vendor__c,service_Request__c,Relationship_To_Sub__c,
                                      Contact__r.Name,Subscriber_ID__c,Fax_Number__c,Subject_Name__r.Name,Subject_Name__r.Member_ID__c,Address_same_as_Default__c,
                                      Vehicle_of_Correspondence__c,Email_Id__c,Name,CreatedById,CreatedBy.Name, CreatedDate,Status__c,Closed_Date__c,Comments__c,
                                      Address_2__c,Days_Taken_To_Close__c
                                       from Correspondence__c where Id =:controller.getId()];
                correspondenceStatus =  correspondenceObj.Status__c;
               // correspondenceComments =  correspondenceObj.Comments__c;                       
                contactName = correspondenceObj.Subject_Name__r.Name;
                subId = correspondenceObj.Subject_Name__c;
                contactId = correspondenceObj.Contact__c;
                serviceId = correspondenceObj.service_Request__c;
                subjectId = correspondenceObj.Subject_Name__r.Member_ID__c;
                strVehicleValueOnOnLoad = correspondenceObj.Vehicle_of_Correspondence__c;
                if(correspondenceObj.Address_same_as_Default__c == true) {
                     isDefault = true;
                     isDisabled = true;
                } else {
                     isDefault = false;
                     isDisabled = false;
                }
                contactFromUrlDetail = [select Member_ID__c,RecordType.Name,HealthRules_ID__c,Supplier_NPI__c,Provider_NPI__c,email 
                                        from Contact where Id = :contactId];
                Contact mainSubscriber = getMainContactId(contactId);                        
                contactObj = [select mailingstreet,mailingcity, mailingstate,mailingcountry,MailingPostalCode,Name,Member_ID__c,Supplier_TIN_Address__c,
                                RecordType.Name,HealthRules_ID__c,Supplier_NPI__c,Provider_NPI__c     
                                from Contact where Id =:mainSubscriber.id];
                if(contactFromUrlDetail.RecordType.Name == Label.MemberRecordTypeLabel) {
                    subScriberId = contactFromUrlDetail.Member_ID__c;
                } else if(contactFromUrlDetail .RecordType.Name == Label.CL09_SHPProvider) {
                    subScriberId = contactFromUrlDetail.Supplier_NPI__c;
                } else {
                    subScriberId = contactFromUrlDetail.HealthRules_ID__c;
                }               
                if(String.isBlank(correspondenceObj.Email_Id__c)) {
                    correspondenceObj.Email_Id__c = contactFromUrlDetail.email;
                }
                strHeaderMsg = correspondenceObj.Name; 
                wrSystemInfo.createdBy = correspondenceObj.CreatedBy.Name;
                wrSystemInfo.createdDate = correspondenceObj.CreatedDate.format('MM/dd/yyyy, h:m a z');
                if(correspondenceObj.Status__c == Label.CL05_Closed) {
                    if(correspondenceObj.Closed_Date__c != null) {
                        wrSystemInfo.closedDate =  (correspondenceObj.Closed_Date__c).format('MM/dd/yyyy, h:m a z');
                        defaultHours = [select Id from BusinessHours where Name = :Label.SHP_Business_Hours];
                        //Decimal calculatedBusinessHours = (BusinessHours.diff(defaultHours.id,correspondenceObj.CreatedDate.date(),correspondenceObj.Closed_Date__c)/3600000.0).setscale(2);
                        //system.Debug('>>>111>>'+correspondenceObj.CreatedDate);
                        //system.Debug('>>2222>>'+correspondenceObj.Closed_Date__c);
                        //system.Debug('>>33333>>'+BusinessHours.diff(defaultHours.id,DateTime.valueOf('2014-11-26 12:28:48'),Datetime.valueOf('2014-12-01 15:16:07'))/3600000.0);
                        //system.Debug('>>33333>>'+BusinessHours.diff(defaultHours.id,correspondenceObj.CreatedDate,correspondenceObj.Closed_Date__c)/3600000.0);
                        Decimal calculatedBusinessHours = (BusinessHours.diff(defaultHours.id,correspondenceObj.CreatedDate,correspondenceObj.Closed_Date__c)/3600000.0).setscale(2);
                        system.debug('>>calculatedBusinessHours>>>'+calculatedBusinessHours);
                        wrSystemInfo.duration = calculatedBusinessHours != null ? ((calculatedBusinessHours/9).setscale(2)) : 0;
                        system.debug('>>wrSystemInfo.duration>>>'+calculatedBusinessHours);
                        if(wrSystemInfo.duration  == 0) {
                            Decimal time1 = correspondenceObj.Closed_Date__c.getTime();
                            Decimal time2 = correspondenceObj.CreatedDate.getTime();
                            Decimal diff = time1 - time2;
                            system.debug('diff->'+diff);
                            wrSystemInfo.duration = (diff/(1000*60*60*9)).setscale(2);
                        }
                        system.debug('>>wrSystemInfo.11duration>>>'+wrSystemInfo.duration);
                    }
                }
                // Start REQ 3406: Added for Correspondence Comment 
                
                
                if(!String.ISBLANk(corresid))
                {
                    correspondenceComment = [Select Id,Name,CreatedBy.Id,Comments__c,CreatedBy.Name,LastModifiedBy.Id,LastModifiedBy.Name ,CreatedDate,LastmodifiedDate
                                                        FROM Correspondence_Comments__c
                                                        WHERE Correspondence__c = :corresid
                                                        order by CreatedDate DESC];
               
                  
                       if(correspondenceComment.size()>0)
                          {                   
                        displaycomments = true;
                        }
                        else
                        {
                        displaycomments=false;
                        } 
                   
                }
                //END  REQ 3406: Added for Correspondence Comment
            } else if(serviceId != null && contactId != null) {
                strHeaderMsg = 'New Correspondence';
                correspondenceObj.Service_Request__c = serviceId;
                contactFromUrlDetail = [select Member_ID__c,RecordType.Name,HealthRules_ID__c,Supplier_NPI__c,Provider_NPI__c,email 
                                           from Contact where Id = :contactId];
                Contact mainSubscriber = getMainContactId(contactId);
                system.Debug('>>mainSubscriber.id>>>>'+mainSubscriber.id); 
                contactObj = [select mailingstreet,mailingcity, mailingstate,mailingcountry,MailingPostalCode,Name,Member_ID__c,Supplier_TIN_Address__c
                               from Contact where Id =:mainSubscriber.id];
                correspondenceObj.Contact__c = contactId;
                correspondenceObj.Email_Id__c = contactFromUrlDetail.email;
                if(contactFromUrlDetail.RecordType.Name == Label.CL09_SHPProvider) {
                    if(!String.isBlank(contactObj.Supplier_TIN_Address__c)) {
                       system.Debug('>>contactObj.Supplier_TIN_Address__c>>>'+contactObj.Supplier_TIN_Address__c); 
                       String[] arrAddress =  contactObj.Supplier_TIN_Address__c.split('\n');
                       system.Debug('>>arrAddress >>>'+arrAddress ); 
                       if(arrAddress != null && arrAddress.size()>2) {
                         //  correspondenceObj.Street__c =  arrAddress[0];
                         //  correspondenceObj.Address_2__c = arrAddress[2];
                          correspondenceObj.Street__c =  arrAddress[0];
                          String[] arrAddress2 =  arrAddress[2].split('\\,');
                          if(arrAddress2 != null && arrAddress2.size()>=2){
                           system.debug(arrAddress2[0] +'' +arrAddress2[1] +'Address');
                           system.debug( arrAddress2.size() + 'Address'); 
                          //correspondenceObj.Address_2__c = arrAddress2[0];
                            correspondenceObj.City__c = arrAddress2[0];
                            String[] arrAddress3 =  arrAddress2[1].split('\\ ');
                            if(arrAddress3 != null && arrAddress3.size()>2) {
                                correspondenceObj.State__c = arrAddress3[1];
                                correspondenceObj.Country__c = 'USA';
                                correspondenceObj.ZipCode__c = arrAddress3[2];
                            }
                          } 
                       }
                    }
                } else {
                    correspondenceObj.Street__c = contactObj.mailingstreet;
                    correspondenceObj.City__c = contactObj.mailingcity;
                    correspondenceObj.State__c = contactObj.mailingstate;
                    correspondenceObj.Country__c = contactObj.mailingcountry;
                    correspondenceObj.ZipCode__c = contactObj.MailingPostalCode;
                }
                
                if(contactFromUrlDetail != Null) {
                    if(contactFromUrlDetail.RecordType.Name == Label.MemberRecordTypeLabel) {
                        correspondenceObj.Member_Type__c = Label.CL08_Member;
                        subScriberId = contactFromUrlDetail.Member_ID__c;
                        subId  = contactObj.Id;
                        subjectId = contactObj.Member_ID__c;
                        contactName = contactObj.Name;  
                    } else if(contactFromUrlDetail.RecordType.Name == Label.CL09_SHPProvider) {
                        correspondenceObj.Member_Type__c = Label.CL15_Provider;
                        correspondenceObj.Relationship_To_Sub__c = '';
                        subScriberId = contactFromUrlDetail.Supplier_NPI__c;
                    } else if(contactFromUrlDetail.RecordType.Name == Label.CL10_SHPBroker) {   // SHP Sales Broker Contact Read Only
                        correspondenceObj.Member_Type__c = Label.Correspondence_Broker;
                        correspondenceObj.Relationship_To_Sub__c = '';
                        subScriberId = contactFromUrlDetail.HealthRules_ID__c;
                    } else if(contactFromUrlDetail.RecordType.Name == Label.CL11_SHPEmployer) { // SHP Sales Employer Contact Read Only
                        correspondenceObj.Member_Type__c = Label.Correspondence_Employer;
                        correspondenceObj.Relationship_To_Sub__c = '';
                        subScriberId = contactFromUrlDetail.HealthRules_ID__c;
                    }
                }
            }
        } catch(Exception ex) {
            system.debug('>>1ex111>>>'+ex.getMessage());
        } 
          
    }
    public Attachment getAttachment(){
        if (attachment == null)
            attachment = new Attachment();
          return attachment;
          }
    
    public void onDefaultCHKBoxClick() {
        try {
            system.Debug('>>>isDefault >>>'+isDefault);
            if(isDefault == true) {
                correspondenceObj.Address_2__c = '';
                isDisabled = true;
                if(contactFromUrlDetail.RecordType.Name == Label.CL09_SHPProvider) {
                    if(!String.isBlank(contactObj.Supplier_TIN_Address__c)) {
                       String[] arrAddress =  contactObj.Supplier_TIN_Address__c.split('\n');
                       if(arrAddress != null && arrAddress.size()>2) {
                          correspondenceObj.Street__c =  arrAddress[0];
                          String[] arrAddress2 =  arrAddress[2].split('\\,');
                          if(arrAddress2 != null && arrAddress2.size()>=2){
                            system.debug(arrAddress2[0] +'' +arrAddress2[1] +'Address');  
                            system.debug(arrAddress2.size() +'Address');
                          //correspondenceObj.Address_2__c = arrAddress2[0];
                            correspondenceObj.City__c = arrAddress2[0];
                            String[] arrAddress3 =  arrAddress2[1].split('\\ ');
                            if(arrAddress3 != null && arrAddress3.size()>2) {
                                correspondenceObj.State__c = arrAddress3[1];
                                correspondenceObj.Country__c = 'USA';
                                correspondenceObj.ZipCode__c = arrAddress3[2];
                            }
                          }  
                       }
                    }
                } else {
                    system.Debug('>>>!contactObj.mailingstreet>>>'+contactObj.mailingstreet);
                    correspondenceObj.Street__c = contactObj.mailingstreet;
                    correspondenceObj.City__c = contactObj.mailingcity;
                    correspondenceObj.State__c = contactObj.mailingstate;
                    correspondenceObj.Country__c = contactObj.mailingcountry;
                    correspondenceObj.ZipCode__c = contactObj.MailingPostalCode;
                }
            } else if(isDefault == false) {
                isDisabled = false;
                if(controller.getId() == null) {
                    correspondenceObj.Street__c = '';
                    correspondenceObj.City__c = '';
                    correspondenceObj.State__c = '';
                    correspondenceObj.Country__c = '';
                    correspondenceObj.ZipCode__c = '';
                    correspondenceObj.Address_2__c = '';
                } else if(controller.getId() != null) {
                    Correspondence__c correTempObj = [select Street__c,City__c,State__c,Country__c,ZipCode__c,Address_2__c from Correspondence__c 
                                                        where id=:controller.getId()];
                    correspondenceObj.Street__c = correTempObj.Street__c;
                    correspondenceObj.City__c = correTempObj.City__c;
                    correspondenceObj.State__c = correTempObj.State__c;
                    correspondenceObj.Country__c = correTempObj.Country__c;
                    correspondenceObj.ZipCode__c = correTempObj.ZipCode__c;
                    correspondenceObj.Address_2__c = correTempObj.Address_2__c;                                    
                }
            }   
        } catch(Exception ex) {}
    }
    
    public Contact getMainContactId(string contactId) {
        try {
           Contact contObj = [select Member_ID__c,id from Contact where Id=:contactId];
           if(contObj.Member_ID__c != null) {
               String[] strArrContactMemId = contObj.Member_ID__c.split('-');
               if(strArrContactMemId.size()>1) {
                   if(strArrContactMemId[1].trim()  ==  '01')  {
                       return contObj;
                   } else {
                       string mainSubMemId = strArrContactMemId[0] + '-01';
                       return [select Id,Member_ID__c  from Contact where Member_ID__c = :mainSubMemId];
                   }
               }
           } else {
               return contObj;
           }
        } catch(Exception ex) {}
        return null;     
    }
    
    public PageReference saveCorrespondence() {
        Savepoint sp;
        try {
            system.Debug('>>>3333>>>'+ correspondenceObj.Vehicle_of_Correspondence__c);
            if(String.IsBlank(correspondenceObj.Vehicle_of_Correspondence__c)){
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Vehicle of Correspondence: You must enter a value');
                Apexpages.addmessage(msg);
                return null;
            } 
            else if(!String.IsBlank(correspondenceObj.Vehicle_of_Correspondence__c) && 
                    correspondenceObj.Vehicle_of_Correspondence__c.contains('Mail')) {
                if(String.isBlank(correspondenceObj.Street__c)) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Address 1: You must enter a value');
                    Apexpages.addmessage(msg);
                    return null;
                }
                /*if(String.isBlank(correspondenceObj.Address_2__c)) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Address 2: You must enter a value');
                    Apexpages.addmessage(msg);
                }*/
                if(String.isBlank(correspondenceObj.City__c)) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'City: You must enter a value');
                    Apexpages.addmessage(msg);
                    return null;
                }
                if(String.isBlank(correspondenceObj.State__c)) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'State: You must enter a value');
                    Apexpages.addmessage(msg);
                    return null;
                }
                if(String.isBlank(correspondenceObj.ZipCode__c)) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'ZipCode: You must enter a value');
                    Apexpages.addmessage(msg);
                    return null;
                }
                if(String.isBlank(correspondenceObj.Country__c)) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Country: You must enter a value');
                    Apexpages.addmessage(msg);
                    return null;
                }
            }
            if(!String.IsBlank(correspondenceObj.Vehicle_of_Correspondence__c)) {
                if(!correspondenceObj.Vehicle_of_Correspondence__c.contains('Email')) {
                    correspondenceObj.Email_Id__c = '';
                }
                if(!correspondenceObj.Vehicle_of_Correspondence__c.contains('Fax')) {
                    correspondenceObj.Fax_Number__c = '';
                }
                if(!correspondenceObj.Vehicle_of_Correspondence__c.contains('Mail')) {
                    isDefault = false;
                    correspondenceObj.Street__c = '';
                    correspondenceObj.City__c = '';
                    correspondenceObj.State__c = '';
                    correspondenceObj.Country__c = '';
                    correspondenceObj.ZipCode__c = '';
                    correspondenceObj.Address_2__c = ''; 
                }
            }
            sp = Database.setSavepoint();
            if(subId != Null  && subId != '') {
                correspondenceObj.Subject_Name__c = subId;
            }
            defaultHours = [select Id from BusinessHours where Name = :Label.SHP_Business_Hours]; //SHP Business Hours
            correspondenceObj.Address_same_as_Default__c = isDefault;
            if(correspondenceStatus != Label.CL05_Closed && correspondenceObj.status__c == Label.CL05_Closed && correspondenceObj.id != null) {
                correspondenceObj.Closed_Date__c = system.now();
                system.Debug('>>1111>>>'+defaultHours);
                system.Debug('>>222>>>'+correspondenceObj.CreatedDate);
                system.Debug('>>3333>>>'+system.today());
                Decimal calculatedBusinessHours = (BusinessHours.diff(defaultHours.id,correspondenceObj.CreatedDate,system.now())/3600000.0).setscale(2);
                system.Debug('>>4444>>>');
                correspondenceObj.Days_Taken_To_Close__c = calculatedBusinessHours != null ? (calculatedBusinessHours/9).setScale(2) : 0;
                if(correspondenceObj.Days_Taken_To_Close__c  == 0) {
                    Decimal time1 = correspondenceObj.Closed_Date__c.getTime();
                    Decimal time2 = correspondenceObj.CreatedDate.getTime();
                    Decimal diff = time1 - time2;
                    system.debug('diff->'+diff);
                    correspondenceObj.Days_Taken_To_Close__c = (diff/(1000*60*60*9)).setscale(2);
                }
            }
            system.debug('>>correspondenceComments>>>'+ correspondenceComments);
            correspondenceObj.Comments__c = correspondenceComments;
            upsert correspondenceObj;
            
            /*if(Test.isRunningTest()) {
               Database.DMLOptions dmlOpts = new Database.DMLOptions();
               //dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
               dmlOpts.assignmentRuleHeader.useDefaultRule = false;
               correspondenceObj.setOptions(dmlOpts);
               upsert correspondenceObj; 
            } else {
                
            }*/
            
            //Case Comments
            
            correspondenceObj = [select Service_Request__r.Correspondence_Total_Duration__c,
                                     Contact__c,Street__c,City__c,State__c,Country__c,ZipCode__c,Overnight__c,Triggered_in_Health_Rules__c,Subject_Name__c,Member_Type__c,Correspondence_Type__c,  
                                     Date_Sent_To_Vendor__c,service_Request__c,Relationship_To_Sub__c,Contact__r.Name,Subscriber_ID__c,Fax_Number__c,
                                     Subject_Name__r.Name,Subject_Name__r.Member_ID__c,Address_same_as_Default__c,Vehicle_of_Correspondence__c,Email_Id__c,
                                     Name,CreatedById,CreatedBy.Name, CreatedDate,Status__c,Closed_Date__c,Comments__c,Address_2__c,Days_Taken_To_Close__c    
                                     from Correspondence__c where Id =:correspondenceObj.id]; 
            
            
            CaseComment commentObj = new CaseComment();
            commentObj.ParentId = correspondenceObj.Service_Request__c;
            if (correspondenceObj.Name <> null) {
                commentObj.CommentBody = correspondenceObj.Name +':Record Comments :'+ correspondenceObj.Comments__c;
             
            }
            if(!Test.isRunningTest()) {
                insert commentObj;
            }
            
            if(correspondenceObj.Status__c == Label.CL05_Closed &&  correspondenceObj.Closed_Date__c != null) {
                Case CaseObjToUpd = new Case(id=correspondenceObj.Service_Request__c);
                Decimal correspondenceDuration = 0; 
                for(Correspondence__c correspondenceObj1 : [select Days_Taken_To_Close__c,Service_Request__r.Correspondence_Total_Duration__c 
                                                            from Correspondence__c where status__c = :Label.CL05_Closed 
                                                            and Service_Request__c = :correspondenceObj.Service_Request__c]) {
                    correspondenceDuration  = correspondenceDuration  + (correspondenceObj1.Days_Taken_To_Close__c == null ? 0:correspondenceObj1.Days_Taken_To_Close__c);
                }
                CaseObjToUpd.Correspondence_Total_Duration__c = correspondenceDuration;
                if(Test.isRunningTest()) {
                    CaseObjToUpd.ownerId = UserInfo.getUserId();
                }
                update CaseObjToUpd;
            }
            //call upload function after inserting, updating correspondence record
            upload();
            //Start REQ 3406: To insert Correspondence comments in CorrespondenceComments__c  object 
            if(!String.isBlank(corresid))
            {
             correspondenceObj = [select Id, Comments__c
                                       from Correspondence__c where Id =:controller.getId()];
                                       
             Correspondence_Comments__c newObj = new Correspondence_Comments__c(); 
                    newObj.Comments__c = correspondenceObj.Comments__c;
                    newObj.Correspondence__c=corresid;
                    Database.insert(newObj);
            }
            else
            {
            Correspondence_Comments__c newObj2 = new Correspondence_Comments__c(); 
                    newObj2.Comments__c = correspondenceComments;
                    newObj2.Correspondence__c=correspondenceObj.id;
                    Database.insert(newObj2);
            }
            
            //END REQ 3406:To insert Correspondence comments in CorrespondenceComments__c  object 
            PageReference pgRef = new PageReference('/'+ serviceId);
            pgRef.setRedirect(true);
            return pgRef;
        } catch(Exception ex) {
            system.debug('>11ex11>>'+ex.getMessage());
            if(ex.getMessage().contains('Customer Inquiry without assigning it to yourself from the queue')){
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,Label.Correspondence_Error_Msg);
                Apexpages.addmessage(msg);
            }
            Database.rollback(sp);
        }
        return null;
    }
    
    public void onVehicleOfCoorespondenceChange() {
        try {
            //system.Debug('>>>3334>>>'+ correspondenceObj.Vehicle_of_Correspondence__c);
            if(!String.IsBlank(correspondenceObj.Vehicle_of_Correspondence__c) && !String.IsBlank(strVehicleValueOnOnLoad) &&  controller.getId() != NULL){
                if(correspondenceObj.Vehicle_of_Correspondence__c.contains('Mail') && !strVehicleValueOnOnLoad.contains('Mail')){
                    isDefault = true; 
                    isDisabled = true;
                    if(contactFromUrlDetail.RecordType.Name == Label.CL09_SHPProvider) {
                        if(!String.isBlank(contactObj.Supplier_TIN_Address__c)) {
                           String[] arrAddress =  contactObj.Supplier_TIN_Address__c.split('\n');
                           if(arrAddress != null && arrAddress.size()>2) {
                              correspondenceObj.Street__c =  arrAddress[0];
                              String[] arrAddress2 =  arrAddress[2].split('\\,');
                              if(arrAddress2 != null && arrAddress2.size()>=2){
                                system.debug(arrAddress2[0] +'' +arrAddress2[1] +'Address');  
                                system.debug(arrAddress2.size() +'Address');
                              //correspondenceObj.Address_2__c = arrAddress2[0];
                                correspondenceObj.City__c = arrAddress2[0];
                                String[] arrAddress3 =  arrAddress2[1].split('\\ ');
                                if(arrAddress3 != null && arrAddress3.size()>2) {
                                    correspondenceObj.State__c = arrAddress3[1];
                                    correspondenceObj.Country__c = 'USA';
                                    correspondenceObj.ZipCode__c = arrAddress3[2];
                                }
                              }  
                           }
                        }
                    } else {
                        system.Debug('>>>!contactObj.mailingstreet>>>'+contactObj.mailingstreet);
                        correspondenceObj.Street__c = contactObj.mailingstreet;
                        correspondenceObj.City__c = contactObj.mailingcity;
                        correspondenceObj.State__c = contactObj.mailingstate;
                        correspondenceObj.Country__c = contactObj.mailingcountry;
                        correspondenceObj.ZipCode__c = contactObj.MailingPostalCode;
                    }
               }
            } else if(controller.getId() == null && !String.IsBlank(correspondenceObj.Vehicle_of_Correspondence__c) && 
                correspondenceObj.Vehicle_of_Correspondence__c.contains('Mail') ) {
                isDefault = true; 
                    isDisabled = true;
                    if(contactFromUrlDetail.RecordType.Name == Label.CL09_SHPProvider) {
                        if(!String.isBlank(contactObj.Supplier_TIN_Address__c)) {
                           String[] arrAddress =  contactObj.Supplier_TIN_Address__c.split('\n');
                           if(arrAddress != null && arrAddress.size()>2) {
                              correspondenceObj.Street__c =  arrAddress[0];
                              String[] arrAddress2 =  arrAddress[2].split('\\,');
                              if(arrAddress2 != null && arrAddress2.size()>=2){
                                system.debug(arrAddress2[0] +'' +arrAddress2[1] +'Address');  
                                system.debug(arrAddress2.size() +'Address');
                              //correspondenceObj.Address_2__c = arrAddress2[0];
                                correspondenceObj.City__c = arrAddress2[0];
                                String[] arrAddress3 =  arrAddress2[1].split('\\ ');
                                if(arrAddress3 != null && arrAddress3.size()>2) {
                                    correspondenceObj.State__c = arrAddress3[1];
                                    correspondenceObj.Country__c = 'USA';
                                    correspondenceObj.ZipCode__c = arrAddress3[2];
                                }
                              }  
                           }
                        }
                    } else {
                        system.Debug('>>>!contactObj.mailingstreet>>>'+contactObj.mailingstreet);
                        correspondenceObj.Street__c = contactObj.mailingstreet;
                        correspondenceObj.City__c = contactObj.mailingcity;
                        correspondenceObj.State__c = contactObj.mailingstate;
                        correspondenceObj.Country__c = contactObj.mailingcountry;
                        correspondenceObj.ZipCode__c = contactObj.MailingPostalCode;
                    }
            }
        } catch(Exception ex) {}
    }
    
    public PageReference cancel() {
        PageReference pgRef = new PageReference('/'+ serviceId);
        pgRef.setRedirect(true);
        return pgRef;
    }
    // Start REQ 3315:To upload attachment in attachment related list
    public Pagereference upload()
    {
        try {
            if(!String.isBlank(corresid)){
                
                attachment.OwnerId = Userinfo.getUserId();
                attachment.ParentId = corresid;
            }
            else{
                
                attachment.OwnerId = Userinfo.getUserId();
                attachment.ParentId = correspondenceObj.id;
            }
            if(attachment.body <> null){
                Database.insert(attachment);
            }
        } catch (Exception ex) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
          return null;
        }finally{
            if(attachment.body == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,Label.Choose_a_File));
            }
            if(attachment.id <> null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,Label.File_Uploaded));
            }
            displaycomments = true;
            attachment = new Attachment();
        }
        return null;
    }
    // End REQ 3315:To upload attachment in attachment related list
    
    public class WrSystemInformation {
        public string createdBy {get;set;}
        public string createdDate {get;set;}
        public string closedDate {get;set;}
        public Decimal duration {get;set;}
    }
}