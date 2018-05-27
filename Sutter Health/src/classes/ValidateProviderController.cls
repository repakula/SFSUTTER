/**
   @Author      : IDC Offshore
   @name        : ValidateProviderController
   @CreateDate  : 06/11/2014 (DD/MM/YYYY)
   @Description : Controller Class for ValidateProvider Page
   
   History
   --------
   Version  Author        Date        Detail 
   1.0     IDC Offshore   10/11/2014  PCRM Controller Class for ValidateProvider Page.
   2.0     IDC Offshore   22/11/2014  PCRM Phase1 Code changes with new enhancements.
*/
public class ValidateProviderController {  

    public string section{get;set;}
    public providerInfoStruct providerInfo{get;set;}
    public Contact_Validation_Summary__c summaryObj{get;set;}
    public string logInMsg{get;set;}
    
    private id userId;
    private id contactId;
    private dateTime lmDate;
    private user userObj;
    private contact contObj;
    private Contact_Validation_Audit_Trail__c ConAuditTrail;
    private string generalErrMsg;
    public string logoutURL{get;set;}
    public string logoutRetURL{get;set;}
    
    /**
    * @author       :   IDC Offshore
    * @date         :   07/11/2014
    * @description  :   Inner Class replicating the data Structure of Provider Information to be updated 
    * @param        :   N/A
    * @return       :   N/A
    */   
    public class providerInfoStruct {
        public string name{get;set;}
        public string sc_address{get;set;}
        public string lastModifiedDate{get;set;}
        public string oldEmail;
        
        public providerInfoStruct() {
            oldEmail = '';
        }
    }
    
     /**
    * @author       :   IDC Offshore
    * @date         :   07/11/2014
    * @description  :   Constructor
    * @param        :   N/A
    * @return       :   N/A
    */    
    public ValidateProviderController() {
        
        section = ApexPages.currentPage().getParameters().get('section');
        if(section == null || section == '') section = 'form';
        
        userId = UserInfo.getUserId();
        userObj = [SELECT contactId FROM user WHERE id = :userId];
        contactId = userObj.contactId;
        
        providerInfo = new providerInfoStruct();        
        
        if(contactId == null)    section = 'error';
        
        generalErrMsg = 'An error has occured. Please contact System Administrator.';
        logoutURL = '/providers/secur/logout.jsp';
        logoutRetURL = '%2Fproviders%2FproviderLogin';
        logInMsg = 'Logged in as ' + UserInfo.getName() + ' (' + UserInfo.getUserName() +')';
                
        if(section.equalsIgnoreCase('form') || section.equalsIgnoreCase('success')) {
            
          summaryObj = [SELECT id
                        ,Email__c,Mobile_Phone__c,Provider_Name__c,Provider_Title__c
                        ,Secure_City__c,Secure_Fax__c,Secure_Phone__c,Secure_State__c,Secure_Street_Address__c,Secure_Zip_Code__c,New_Street_Address__c
                        ,Contact_Id__c,Provider_ID__c,Last_Verified_Date__c, Preferred_Communication_Method__c
                        ,contact_Id__r.firstName, contact_Id__r.lastName, contact_Id__r.Provider_Name_Suffix__c
                        ,contact_Id__r.Contact_Middle_Name__c, ok_to_text__c
                        FROM Contact_Validation_Summary__c WHERE Contact_Id__c = :contactId  and Address_Type__c = 'Primary' limit 1]; 
                        
             if(summaryObj.Last_Verified_Date__c != null)      
                providerInfo.lastModifiedDate = summaryObj.Last_Verified_Date__c.format('MMMM dd, yyyy  hh:mm a');  
                
            if(section.equalsIgnoreCase('form')) {                         
                if(summaryObj.Provider_Name__c != null && summaryObj.Provider_Name__c != '')   
                  providerInfo.name = summaryObj.Provider_Name__c;
    
                if(summaryObj.Provider_Title__c != null && summaryObj.Provider_Title__c != '')  
                  providerInfo.name = providerInfo.name + ', ' + summaryObj.Provider_Title__c;
    
                if(summaryObj.Email__c != null && summaryObj.Email__c != '')  
                  providerInfo.oldEmail = summaryObj.Email__c;
                
                if(summaryObj.Secure_Street_Address__c != null && summaryObj.Secure_Street_Address__c != '')  
                  providerInfo.sc_address = summaryObj.Secure_Street_Address__c;
            }
           
        }
                   
    }
    
    /**
    * @author       :   IDC Offshore
    * @date         :   07/11/2014
    * @description  :   Saves the updated Record
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference save() {
        list<Contact_Validation_Audit_Trail__c> conAuditTrailList;
        List<Contact_Validation_Summary__c> summaryObjList;
        String securePhoneNo;
        String secureFaxNo;
        String mobileNo;
        String zipCode;
        PageReference prObj = new PageReference('/validateProvider');
        
        try { 

            if(summaryObj.Mobile_Phone__c != null && summaryObj.Mobile_Phone__c != '') {
                mobileNo = summaryObj.Mobile_Phone__c;
                summaryObj.Mobile_Phone__c = summaryObj.Mobile_Phone__c.replaceAll('-','').replaceAll(' ','').replaceAll('\\(','').replaceAll('\\)','');
            }
            
            if(summaryObj.Secure_Fax__c != null && summaryObj.Secure_Fax__c != '') {  
                secureFaxNo = summaryObj.Secure_Fax__c;
                summaryObj.Secure_Fax__c = summaryObj.Secure_Fax__c.replaceAll('-','').replaceAll(' ','').replaceAll('\\(','').replaceAll('\\)','');
            }
            
            if(summaryObj.Secure_Phone__c != null && summaryObj.Secure_Phone__c != '') {
                securePhoneNo = summaryObj.Secure_Phone__c;
                summaryObj.Secure_Phone__c = summaryObj.Secure_Phone__c.replaceAll('-','').replaceAll(' ','').replaceAll('\\(','').replaceAll('\\)','');
            }
              
            if(summaryObj.Secure_Zip_Code__c  != null && summaryObj.Secure_Zip_Code__c != '') {
                zipCode = summaryObj.Secure_Zip_Code__c;
                summaryObj.Secure_Zip_Code__c = summaryObj.Secure_Zip_Code__c.replaceAll('-','');
            }
                
            
            if(validate()) {
                 Contact_Validation_Summary__c pISObjOld = [select Secure_Street_Address__c,Secure_City__c,Secure_State__c,Contact_Id__c,Secure_Zip_Code__c,Secure_Suite__c,Secure_Floor__c,
                                                                        Secure_Phone__c,Secure_FAX__c,Secure_Phone_Ext__c,Email__c,Mobile_Phone__c,Ok_to_Text__c,address_modified__c,Serial_Number__c, 
                                                                        New_Street_Address__c,Preferred_Communication_Method__c from  Contact_Validation_Summary__c where 
                                                                        address_Type__c = 'Primary' and Contact_Id__c = :contactId limit 1];
                summaryObj.Secure_Phone__c = securePhoneNo;
                
                 // REQ 3670 Start - Populating the Validation Source Channel field with SFPP value 
                summaryObj.Validation_Source_Channel__c = 'SFPP';
                // REQ 3670 End
                
                
                summaryObj.Secure_Fax__c = secureFaxNo;
                summaryObj.Mobile_Phone__c = mobileNo;
                summaryObj.Secure_Zip_Code__c = zipCode;
                summaryObj.Secure_Street_Address__c = providerInfo.sc_address;
                summaryObj.Last_Verified_Date__c  = System.now();
                summaryObj.New_Street_Address__c = summaryObj.New_Street_Address__c;//Req# 3398
                summaryObj.Address_Type__c  = 'Primary'; //Req# 3398
                //REQ 3665 START
                summaryObj.Status__c = 'Validated';
                //REQ 3665 END
                ConAuditTrail = new Contact_Validation_Audit_Trail__c();
                ConAuditTrail.Email__c = summaryObj.Email__c;
                ConAuditTrail.Mobile_Phone__c = summaryObj.Mobile_Phone__c;
               
                ConAuditTrail.Secure_City__c= summaryObj.Secure_City__c;
                ConAuditTrail.Secure_Fax__c= summaryObj.Secure_Fax__c;
                ConAuditTrail.Secure_Phone__c= summaryObj.Secure_Phone__c;
                ConAuditTrail.Secure_State__c= summaryObj.Secure_State__c;
                ConAuditTrail.Secure_Street_Address__c= providerInfo.sc_address;
                ConAuditTrail.Secure_Zip_Code__c= summaryObj.Secure_Zip_Code__c;
                ConAuditTrail.Contact_Id__c = contactId;
                ConAuditTrail.Provider_Id__c = summaryObj.Provider_ID__c;
                ConAuditTrail.Preferred_Communication_Method__c = summaryObj.Preferred_Communication_Method__c;
                ConAuditTrail.First_Name__c = summaryObj.contact_Id__r.firstName;
                ConAuditTrail.Last_Name__c = summaryObj.contact_Id__r.lastName;
                ConAuditTrail.Middle_Name__c = summaryObj.contact_Id__r.Contact_Middle_Name__c;
                ConAuditTrail.Provider_Name_Suffix__c = summaryObj.contact_Id__r.Provider_Name_Suffix__c;
                ConAuditTrail.Ok_to_Text__c = summaryObj.ok_to_text__c;
                ConAuditTrail.Serial_Number__c = '1';//Req# 3398
                ConAuditTrail.New_Street_Address__c = summaryObj.New_Street_Address__c;
                //ConAuditTrail.New_Street_Address__c = summaryObj.Secure_Street_Address__c;//Req# 3398
                ConAuditTrail.Provider_Information_Summary__c = summaryObj.id;//Req# 3398
                ConAuditTrail.Address_Type__c = 'Primary'; //Req# 3398
                //Req# 3398 
                string strLog = '';
                strLog = strLog + 'At ' + system.now().format() + ' S#' +  ConAuditTrail.Serial_Number__c + '<br/>';
                if(ConAuditTrail.Secure_City__c != pISObjOld.Secure_City__c) {
                    strLog  = strLog + ' City ' + '<br/>' +
                                'From ' + pISObjOld.Secure_City__c + '<br/>' +
                                'To ' + ConAuditTrail.Secure_City__c + '<br/><br/>'; 
                }
                if(ConAuditTrail.New_Street_Address__c != pISObjOld.New_Street_Address__c) { 
                    strLog  = strLog + ' Street Address ' + '<br/> ' +
                                'From ' + pISObjOld.New_Street_Address__c + '<br/>' +
                                'To ' + ConAuditTrail.New_Street_Address__c + '<br/><br/>'; 
                }
                if(ConAuditTrail.Secure_Zip_Code__c != pISObjOld.Secure_Zip_Code__c) {
                    strLog  = strLog + ' ZipCode ' +  '<br/> ' +
                                'From ' + pISObjOld.Secure_Zip_Code__c + '<br/>' +
                                'To ' + ConAuditTrail.Secure_Zip_Code__c + '<br/><br/>'; 
                }
                if((ConAuditTrail.Secure_Suite__c != pISObjOld.Secure_Suite__c) && (!String.isBlank(ConAuditTrail.Secure_Suite__c) || !String.isBlank(pISObjOld.Secure_Suite__c))) {
                    strLog  = strLog + ' Suite ' +  '<br/> ' +
                                'From ' + pISObjOld.Secure_Suite__c + '<br/>' +
                                'To ' + ConAuditTrail.Secure_Suite__c  + '<br/><br/>'; 
                }
                if((ConAuditTrail.Secure_Floor__c != pISObjOld.Secure_Floor__c) && (!String.isBlank(ConAuditTrail.Secure_Floor__c) || !String.isBlank(pISObjOld.Secure_Floor__c))) {
                    strLog  = strLog + ' Floor ' +  '<br/> ' +
                                'From ' + pISObjOld.Secure_Floor__c + '<br/>' +
                                'To ' + ConAuditTrail.Secure_Floor__c + '<br/><br/>'; 
                }
                if((ConAuditTrail.Secure_State__c != pISObjOld.Secure_State__c)) {
                    strLog  = strLog + ' State ' +  '<br/> ' +
                                'From ' + pISObjOld.Secure_State__c + '<br/>' +
                                'To ' + ConAuditTrail.Secure_State__c + '<br/><br/>'; 
                }
                if((ConAuditTrail.Secure_Phone__c != pISObjOld.Secure_Phone__c)) {
                    strLog  = strLog + ' Phone ' +  '<br/> ' +
                                'From ' + pISObjOld.Secure_Phone__c + '<br/>' +
                                'To ' + ConAuditTrail.Secure_Phone__c + '<br/><br/>'; 
                }
                if((ConAuditTrail.Secure_FAX__c != pISObjOld.Secure_FAX__c)) {
                    strLog  = strLog + ' Fax ' +  '<br/> ' +
                                'From ' + pISObjOld.Secure_FAX__c + '<br/>' +
                                'To ' + ConAuditTrail.Secure_FAX__c + '<br/><br/>'; 
                }
                if((ConAuditTrail.Email__c != pISObjOld.Email__c)) {
                    strLog  = strLog + ' Email ' +  '<br/> ' +
                                'From ' + pISObjOld.Email__c + '<br/>' +
                                'To ' + ConAuditTrail.Email__c + '<br/><br/>'; 
                }
                if((ConAuditTrail.Mobile_Phone__c != pISObjOld.Mobile_Phone__c)) {
                    strLog  = strLog + ' Mobile Phone ' +  '<br/> ' +
                                'From ' + pISObjOld.Mobile_Phone__c + '<br/>' +
                                'To ' + ConAuditTrail.Mobile_Phone__c + '<br/><br/>'; 
                }
                ConAuditTrail.Address_Change__c = strLog; 
                /*@Description:Updating the Sent_to_MDM__c field of records of same contact created on the same day to N/A */
                conAuditTrailList= [   SELECT id, Sent_To_MDM__c FROM Contact_Validation_Audit_Trail__c
                                        WHERE contact_id__c = :contactId                                         
                                        AND Sent_To_MDM__c = null
                                    ];
                /*  For Req#3398 Modified the above query and removed this condition AND createdDate >= :Date.today() */
                for(Integer i=0;i<conAuditTrailList.size();i++)
                    conAuditTrailList[i].Sent_To_MDM__c = 'N/A';
                
                /*@Description:Updating the User record, in case if user updates his E-Mail ID */
                if(summaryObj.Email__c != providerInfo.oldEmail) {
                    userObj.email = summaryObj.Email__c;
                    update userObj;
                }
                
                update conAuditTrailList;
                update summaryObj;
                insert ConAuditTrail;
                
                prObj.getParameters().put('section','success');
                prObj.setRedirect(true);
                return prObj;
                
            }
            
          } catch(DMLException ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
                Utility.handleExceptionFromCode(ex.getMessage() + '\r\n' + ex.getStackTraceString() + '\r\n' + ex.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                return null;
                
          } catch(Exception classException) { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
                Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                return null;
          }
          return null;
    }
    
    /**
    * @author       :   IDC Offshore
    * @date         :   07/11/2014
    * @description  :   Validates the submitted Record
    * @param        :   N/A
    * @return       :   Boolean
    */
    public boolean Validate() {
        
        try {
                 
            if(summaryObj.Email__c == null ||  summaryObj.Email__c == '')
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Email is required.'));
            else if(!AP01_TestDataUtility.isEmailValid(summaryObj.Email__c))
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Email is invalid.'));
             
            if(summaryObj.Mobile_Phone__c == null || summaryObj.Mobile_Phone__c == '') {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Mobile Number is required.'));
            } else if(summaryObj.Mobile_Phone__c.length() < 10 || summaryObj.Mobile_Phone__c.length() > 10 || !summaryObj.Mobile_Phone__c.isNumeric()) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Mobile Number is invalid. It must contain 10 digits only.'));
            }
            
            if(providerInfo.sc_address == null || providerInfo.sc_address == '')
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - Street Address is required.'));
              
            if(summaryObj.Secure_Fax__c == null || summaryObj.Secure_Fax__c == '')
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - Fax is required.'));
            else if(summaryObj.Secure_Fax__c.length() < 10 || summaryObj.Secure_Fax__c.length() > 10 || !summaryObj.Secure_Fax__c.isNumeric())
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - Fax is invalid. It must contain 10 digits only.'));
              
             if(summaryObj.Secure_City__c == null || summaryObj.Secure_City__c == '')
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - City is required.'));
              
             if(summaryObj.Secure_State__c == null || summaryObj.Secure_State__c == '')
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - State is required.'));
              
            if(summaryObj.Secure_Zip_Code__c  == null || summaryObj.Secure_Zip_Code__c  == '' || !summaryObj.Secure_Zip_Code__c.isNumeric())
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - Zip Code is required.'));
            else if(
                (summaryObj.Secure_Zip_Code__c.length() < 5)
                || ((summaryObj.Secure_Zip_Code__c.length() > 5 && summaryObj.Secure_Zip_Code__c.length() < 9)) 
                || (summaryObj.Secure_Zip_Code__c.length() > 9)
              )
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - Zip Code is invalid. It must contain 5 or 9 digits only.'));
            
            /*@Description:PHONE - IF FIRST DIGIT IS 1 THEN SFDC AUTOMATICALLY REMOVES IT FROM THE FIELD */
            if(summaryObj.Secure_Phone__c == null || summaryObj.Secure_Phone__c == '') {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - Phone is required.'));
            
            /*@Description:LESS THEN 10 DIGITS OR LENGTH = 11 */
            } else if(summaryObj.Secure_Phone__c.length() < 10 || summaryObj.Secure_Phone__c.length() == 11) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - Phone is invalid. It must be either in the form of (999) 999-9999 or (999) 999-9999 x {ExtensionNo}. It must be Numeric only.'));
            
            /*@Description:PHONE NO CONTAINS CHARACTER */
            } else if(
                (summaryObj.Secure_Phone__c.length() > 10 && !summaryObj.Secure_Phone__c.subString(0,10).isNumeric())
                || (summaryObj.Secure_Phone__c.length() == 10 && !summaryObj.Secure_Phone__c.subString(0).isNumeric())
                ) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - Phone is invalid. It must be either in the form of (999) 999-9999 or (999) 999-9999 x {ExtensionNo}. It must be Numeric only.'));
            
            /*@Description:PHONE NO LENGTH > 10, EITHER X NOT PRESENT OR IS NOT AT DESIRED PLACE */
            } else if(summaryObj.Secure_Phone__c.length() > 10 
                        && (summaryObj.Secure_Phone__c.lastIndexOf('x') == -1 || summaryObj.Secure_Phone__c.lastIndexOf('x') != 10)
                ) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - Phone is invalid. It must be either in the form of (999) 999-9999 or (999) 999-9999 x {ExtensionNo}. It must be Numeric only.'));
           
            /*@Description:EXTN NO CONTAINING CHARACTERS */
            } else if(summaryObj.Secure_Phone__c.length() > 11  && !summaryObj.Secure_Phone__c.subString(11,summaryObj.Secure_Phone__c.length()).isNumeric()) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - Phone is invalid. It must be either in the form of (999) 999-9999 or (999) 999-9999 x {ExtensionNo}. It must be Numeric only.'));
            }
            
            /*@Description:Primary Clinical Contact Information - Phone is invalid. It must contain 10 digits only.*/
            if(summaryObj.Preferred_Communication_Method__c == null || summaryObj.Preferred_Communication_Method__c == '')
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Primary Clinical Contact Information - Preferred Communication Method is required.'));
            
            if(ApexPages.hasMessages()) return false;
            else return true;
               
        } catch(Exception classException)  {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, generalErrMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            return false;
        }
                
        return false;
    }
    
    /**
    * @author       :   IDC Offshore
    * @date         :   13/11/2014
    * @description  :   Check if the User is authenticated
    * @param        :   N/A
    * @return       :   PageReference
    */
    public PageReference ifUserAuthenticated() {
        PageReference prObj;
        
        if(!userInfo.getUsertype().equalsIgnoreCase('CspLitePortal')) {
            prObj = new PageReference('/providers/providerLogin');
            prObj.setRedirect(true);
            return prObj;   
        } else {
    if(section.equalsIgnoreCase('form')) {
                summaryObj.Provider_last_Login_Date__c = datetime.now();
                update summaryObj;
            }
            return null;
        }
    }
}