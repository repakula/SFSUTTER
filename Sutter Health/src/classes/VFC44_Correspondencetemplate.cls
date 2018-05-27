/****************************************************************************  
*     Class Name  : Correspondencetemplate                                  *
*     Author      : IDC Offshore                                            *
*     Date        : 09-Sept-2014                                            *
*     Project Name: CRM - SFT - Sutter Health                               *          
*     Description : Contoller for VisualForce page  Correspondence_template.*    
*****************************************************************************/


public class VFC44_Correspondencetemplate {
/****************************************************************************
*                Static Variable Section                                    *
*****************************************************************************/
    static String ErrorDate = 'Please verify the date field should enter correctly i.e. in format MM/DD/YYYY Or Please veriify the checkbox field i.e enter only true or false';
    static String ErrorBoolean = 'Please enter either true of false for checkbox fields';
    static String ErrorMsg = 'Either Value is Blank Or Selected Duplicate Field';
    static String Contains = 'Contains';
    static String Checkbox = 'Checkbox';
    static String objfalse = 'false';
    static String removeCDATA ='<![CDATA[';
    static String blankData ='';
    static String removeString =']]>';
    static String strDate ='Date';
    static String None ='None';
    static String Approved = 'Approved';
    static String ReadyForEmailSent = 'Ready For Email Sent';
    static String intialObjectReconigation = '00G';
    static String newEmailTemplateURL = '/p/email/template/NewEmailTemplateStageManager';
    static String ErrorForTemplate = 'please Select the email Letter';
    static string errorContact='select the contacts';
    static String strRecordTypeBrokerRO = '\'SHP_Sales_Broker_Contact_Read_Only\'';
    static String strRecordTypeBroker = '\'SHP_Sales_Broker_Contact\'';
    static String strRecordTypeCorrepondenceLetter ='Correspondence_Letter_RO';
    static String strMailSent = 'Mail Sent';
    static String strBrokerCorrespondence = 'Broker_Correspondence';
     
    
/********************************************************************************
*                Getter Setter and variable section                             *
*********************************************************************************/
    public String Fields{get;set;} // store objects field for query
    public String OpertaorsList{get;set;} // Store operators for query
    public string Value{get;set;} //Stores the user input for query     
    public String Fields1{get;set;}
    public String OpertaorsList1{get;set;}
    public string Value1{get;set;}    
    public String Fields2{get;set;}
    public String OpertaorsList2{get;set;}
    public string Value2{get;set;}    
    public String Fields3{get;set;}
    public String OpertaorsList3{get;set;}
    public string Value3{get;set;}    
    public String Fields4{get;set;}
    public String OpertaorsList4{get;set;} 
    public string Value4{get;set;}    
    public String Fields5{get;set;}
    public String OpertaorsList5{get;set;}
    public string Value5{get;set;}
    public String Fields6{get;set;}
    public String OpertaorsList6{get;set;}
    public string Value6{get;set;}
    public boolean initialBoolean{get;set;} // If true renders the search selection     
    public String memberList{get;set;} // list of queried broker contacts
    public List<SelectOption> members{get;set;} 
    public boolean showSendEmailMessage{get;set;} // if true renders the email sent successfully message    
    public String privew {get;set;} // preview link
    public Correspondence_Letter__c objCorrLetter {get;set;} // current correspondence record being worked on    
    public String SelectedEmailTemplate{get;set;}    
    public List<SelectOption> optionsEmailTemplate{get;set;}
    public boolean showErroronLoad1{get;set;}
    public boolean showContactFilter1{get;set;} // Booleans to add/remove rows for filter criterea
    public boolean showContactFilter2{get;set;}
    public boolean showContactFilter3{get;set;}
    public boolean showContactFilter4{get;set;}
    public boolean showContactFilter5{get;set;}
    public boolean showContactFilter6{get;set;}
    public EmailTemplate selectEmailTemplate{get;set;}
    public BrandTemplate selectbrandTemplate{get;set;}    
    public String conName{get; set;}
    public String conId{get; set;}
    public boolean displaySendButton{get;set;}
    //Req no 3378 member employer correspondence Start 
    public static string  SHP_EMPLOYER_MEMBER_RECORDTYPE ='SHP_Employer_Member';//  Define record type 
    public Boolean showErroronLoad {get;set;} // Define  Boolean variable  to render error page 
    //Req no 3378 member employer correspondence End 
    public map<String,Contact> mapOfSendToContact;
    public Map<String,EmailTemplate> mapIdtoEmailTemplate;
    public List<SelectOption>  listOfEmailTemplateName;
    List<EmailTemplate> lstEmailTemplate ;
    
    // Req 3377 - Varibale to store the SCN Training Document - Start
    public SHP_Training_Document__kav BrokerCorresponenceTrainingDocument {get;set;}
    private static final String KNOWLEDGEARTICLEID =  System.Label.Broker_Correpondence_Email_Training_Doc;      
    // Req 3377 - Varibale to store the SCN Training Document - End
    
    
/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 09/09/2015                                                  *  
*   @description .: This Method save the correspondence letter record           *
*   @param........:                                                             *    
*   @return ......: List<SelectOption>                                          *
*********************************************************************************/      
    public PageReference saveCorresspondenceLetter(){ 
        try{
            if( conId != null){
                objCorrLetter.queryForContact__c = conId;
                //objCorrLetter.To_Contact_List__c = conId;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorContact));
                return null;
            }            
            if(SelectedEmailTemplate != null && SelectedEmailTemplate != None){  
                objCorrLetter.Selected_Template__c = SelectedEmailTemplate;
                selectEmailTemplate = [SELECT Name, htmlvalue, BrandTemplateId, Subject FROM EmailTemplate WHERE id=:SelectedEmailTemplate Limit 1];
                objCorrLetter.Letterbody__c = (selectEmailTemplate.htmlvalue).replace(removeCDATA, blankData);
                objCorrLetter.Letterbody__c = (objCorrLetter.Letterbody__c).replace(removeString, blankData);
                String brandTempId = selectEmailTemplate.BrandTemplateId;
                
                if(String.isNotBlank(brandTempId)){
                    selectbrandTemplate = [SELECT value FROM BrandTemplate WHERE id=:brandTempId];
                }           
                objCorrLetter.Letter_Content__c = selectbrandTemplate.value.replace(removeCDATA, blankData);
                objCorrLetter.Letter_Content__c = (objCorrLetter.Letter_Content__c ).replace(removeString, blankData);          
                
                objCorrLetter.Selected_Template_Name__c = selectEmailTemplate.name;
                objCorrLetter.Subject__c = selectEmailTemplate.Subject;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorForTemplate));
                return null;
            }
        
            upsert objCorrLetter;
               
        }catch(Exception Ex){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Ex.getMessage()));
        }
        PageReference redirect = new PageReference('/' + objCorrLetter.id); 
        redirect.setRedirect(true);     
        return redirect;
    }

/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 09/09/2015                                                  *  
*   @description .: This Method is Contructor of Correspondencetemplate         *
*   @param........:                                                             *    
*   @return ......:                                                             *
*********************************************************************************/ 
    public VFC44_Correspondencetemplate(ApexPages.StandardController controller) {
        try{
            mapOfSendToContact = new  map<String,Contact>();
            objCorrLetter = new Correspondence_Letter__c();
            displaySendButton = true;
            SelectedEmailTemplate=None;
            showErroronLoad1 = false;
            string correspondenceId = controller.getId();
            
            if (!Test.isRunningTest()) {
                // Req 3377 Change Start - Query to get the Training Document for SCN 
                if( BrokerCorresponenceTrainingDocument == null ) {
                    BrokerCorresponenceTrainingDocument = [ SELECT Id From SHP_Training_Document__kav WHERE PublishStatus = 'Online' AND Language = 'en_US' AND KnowledgeArticleId = :KNOWLEDGEARTICLEID limit 1 ];
                }
                // Req 3377 Change End - Query to get the Training Document for SCN
            }
            
            //fetch the current values for record being edited 
            if(!string.isBlank(correspondenceId)){
                //Req no 3378  Member Employer correspondence Start
                //Added  recordtype.DeveloperName in soql   
                objCorrLetter=[SELECT Id, Status__c, recordtype.DeveloperName , To_Contact_List__c,Selected_Template__c,queryForContact__c,ownerId  FROM Correspondence_Letter__c WHERE Id =: correspondenceId ];
                //Req no 3378  Member Employer correspondence Start  
                //if the status is approved then display the send Mail button
                if(objCorrLetter.Status__c == Approved){
                    displaySendButton = false;
                }
                SelectedEmailTemplate=objCorrLetter.Selected_Template__c;
                string OwnerId = objCorrLetter.ownerId;
                conId = objCorrLetter.queryForContact__c;
                
                //check if the record is owned by a queue then throws an error
                if(OwnerId.contains(intialObjectReconigation)){
                    showErroronLoad1 = true;
                }
                //Req no 3378  Member Employer correspondence Start  
                /**  Checking condition if record type  is SHP employer or Member
                if  Record type is SHP employer or Member then display Error page   "You can not edit Member and employer correspondence" 
                if condition is false then rendering in Broker correspondence VF page  **/
             if(objCorrLetter.recordtype.DeveloperName  == SHP_EMPLOYER_MEMBER_RECORDTYPE )
             {
                showErroronLoad = true;
             }
            else
                showErroronLoad = false;
            }
            //Req no 3378  Member Employer correspondence End 
            lstEmailTemplate = new  List<EmailTemplate>();
            showContactFilter1 = false;
            showContactFilter2 = false;
            showContactFilter3 = false;
            showContactFilter4 = false;
            showContactFilter5 = false;
            showContactFilter6 = false; 
            listOfEmailTemplateName = new List<SelectOption>();      
            mapIdtoEmailTemplate = new Map<String,EmailTemplate>();
            members = new List<SelectOption>();
            members.add(new SelectOption(None,None)); 
            optionsEmailTemplate = getEmailTemplate(); 
        }catch(Exception Ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Ex.getMessage()));
        }
    } 
// Enable Boolean to Add Filter Criteria
    public void EnableshowContactFilter1() {
        showContactFilter1 = true;
        initialBoolean = false; 
    } 
// Enable Boolean to Add Filter Criteria
    public void EnableshowContactFilter2() {
        showContactFilter2 = true;
        initialBoolean = false; 
    }
// Enable Boolean to Add Filter Criteria
    public void EnableshowContactFilter3() {
        showContactFilter3 = true;
        initialBoolean = false; 
    }
// Enable Boolean to Add Filter Criteria
    public void EnableshowContactFilter4() {
        showContactFilter4 = true;
        initialBoolean = false; 
  }
// Enable Boolean to Add Filter Criteria
    public void EnableshowContactFilter5() {
        showContactFilter5 = true;
        initialBoolean = false;  
    }
// Enable Boolean to Add Filter Criteria
    public void EnableshowContactFilter6() {
        showContactFilter6 = true;
        initialBoolean = false;
    }
// Disable Boolean to Remove Filter Criteria
    public void DisableshowContactFilter1() {
        showContactFilter1 = false;
        initialBoolean = true; 
    } 
// Disable Boolean to Remove Filter Criteria
    public void DisableshowContactFilter2() {
        showContactFilter2 = false;
        initialBoolean = false; 
    }
// Disable Boolean to Remove Filter Criteria
    public void DisableshowContactFilter3() {
        showContactFilter3 = false;
        initialBoolean = false; 
    }
// Disable Boolean to Remove Filter Criteria
    public void DisableshowContactFilter4() {
        showContactFilter4 = false;
        initialBoolean = false; 
    }
// Disable Boolean to Remove Filter Criteria
    public void DisableshowContactFilter5() {
        showContactFilter5 = false;
        initialBoolean = false; 
    }
// Disable Boolean to Remove Filter Criteria
    public void DisableshowContactFilter6() {
        showContactFilter6 = false;
        initialBoolean = false; 
    }
 
/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 09/09/2015                                                  *  
*   @description .: This Method find thge email template and set email template *
*                   options.                                                    *
*   @param........:                                                             *    
*   @return ......: List<SelectOption>                                          *
*********************************************************************************/  
   // find the email template and set in the select email template options
    public List<SelectOption> getEmailTemplate(){
        try{
            // finds the folder named Broker_Correspondence
            Folder objFolder = [SELECT DeveloperName, Id FROM Folder WHERE DeveloperName =: strBrokerCorrespondence Limit 1];
            // Queries the Email templates from the above folder
            lstEmailTemplate =  [SELECT Body, BrandTemplateId, CreatedById, CreatedDate, Description, Encoding, FolderId, HtmlValue, Id, Name,
                                        Subject, TemplateStyle, TemplateType 
                                 FROM EmailTemplate 
                                 WHERE folderId =:objFolder.Id and IsActive=true Limit 50000];                         
            listOfEmailTemplateName.add(new SelectOption(None,None)); // adds a none value since select option cannot be blank
            
            for(EmailTemplate objEmailTemaplate: lstEmailTemplate){
                listOfEmailTemplateName.add(new SelectOption(objEmailTemaplate.Id,objEmailTemaplate.Name));
                mapIdtoEmailTemplate.put(objEmailTemaplate.Id,objEmailTemaplate);
            }  
           
        }catch(Exception Ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Ex.getMessage()));
        }  
        return listOfEmailTemplateName;     
    }

/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 09/09/2015                                                  *  
*   @description .: This Method creates the records of Junction object          *
*                   CorrespondenceContactAssociation which associates           *   
*                   template with contact. A batch job sends the mail           *
*                   nightly for all junction records created.                   *
*   @param........:                                                             *    
*   @return ......:PageReference                                                *
*********************************************************************************/  
    public PageReference sendMail(){
        try{
            List<CorrespondenceContactAssociation__c> lstCorrespondenceContactAssociation = new List<CorrespondenceContactAssociation__c>();
            List <string> conidlist= new List<String>();
            // Splits the records based on ';' character
            if (objCorrLetter.queryForContact__c != null) {      
                    conidlist = objCorrLetter.queryForContact__c.split(';');
            
            }
         
            if(conidlist.size() > 0) {
                for(String id: conidlist){
                    CorrespondenceContactAssociation__c objCorresContAssociation = new CorrespondenceContactAssociation__c();
                    objCorresContAssociation.Contact__c = id;//set the Contact Id in Junction record
                    objCorresContAssociation.Correspondence_Letter__c = objCorrLetter.id;// set the Correspondence Letter Id
                    objCorresContAssociation.Status__c = ReadyForEmailSent; // set the status for junction object
                    objCorresContAssociation.Selected_Template__c = objCorrLetter.Selected_Template__c;
                    lstCorrespondenceContactAssociation.add(objCorresContAssociation);
                }
                objCorrLetter.Status__c = strMailSent; // Updates the status of Correspondence letter
                Recordtype objRT = [SELECT id FROM recordtype WHERE recordtype.developername =:strRecordTypeCorrepondenceLetter limit 1];
                objCorrLetter.recordtypeid=objRT.id; //Update the record type to Correspondence_Letter_RO
                update objCorrLetter;
                database.insert(lstCorrespondenceContactAssociation,false);
            } 
            showSendEmailMessage = true; // show the message the the Email has been senT successfully           
        }catch(Exception Ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Ex.getMessage()));
        }   
        return null;
    }


/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 09/09/2015                                                  *  
*   @description .: This Method Sets the value of the options                   *
*                   on visual force page.                                       *
*   @param........:                                                             *    
*   @return ......:PageReference                                                *
*********************************************************************************/      
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        try{
             
            Map<String, Contact_Search_Fields__c> BrokerContatFields = Contact_Search_Fields__c.getAll(); // fetchs all the values from the custom setting
            List<String> fieldNames = new List<String>();
            fieldNames.addAll(BrokerContatFields.keySet());//the field name added to Contact_Search_Fields__c custom setting are added in filter values.
            fieldNames.sort();

            for(String field: fieldNames ) {
                Contact_Search_Fields__c Confield = BrokerContatFields.get(field);
                options.add(new SelectOption( Confield.Name , Confield.Field_Name__c ));        
                
            }
            options.sort();
            
        }catch(Exception Ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Ex.getMessage()));
        } 
         return options ;  
    }
/********************************************************************************
*   @author ......:IDC Team                                                     *  
*   @date ........:09/09/2015                                                   *  
*   @description .:This Method get the value of the Operator Field              *
*                     on visual force page.                                     *
*   @param........:                                                             *    
*   @return ......:PageReference                                                *
*********************************************************************************/  
    public List<SelectOption> getOperator() {
        List<SelectOption> options = new List<SelectOption>();
        try{
            options.add(new SelectOption('=','Equal'));
            options.add(new SelectOption('>','Greater'));
            options.add(new SelectOption('<','Less'));
            options.add(new SelectOption('!=','Not equal'));
            options.add(new selectOption(Contains,Contains));
        }catch(Exception Ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Ex.getMessage()));
        } 
       
        
        return options ;
    }
    

/********************************************************************************
*   @author :IDC Team                                                           *  
*   @date :09/09/2015                                                           *  
*   @description :This Method open the Email Template page                      *
*   @param :                                                                    *    
*   @return :PageReference                                                      *
*********************************************************************************/      
    
    public PageReference createTemplate() { 
        PageReference pageRef = new PageReference(newEmailTemplateURL);
        pageRef.setRedirect(true);
        return pageRef ;
    }

/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 09/09/2015                                                  *  
*   @description..: This Method open the select Email template page             *
*   @param .......:                                                             *    
*   @return ......:PageReference                                                *
*********************************************************************************/  
  public PageReference previewTemplate() { 
        
        if(SelectedEmailTemplate != null && SelectedEmailTemplate != None){
            PageReference pageRef = new PageReference('/'+SelectedEmailTemplate);
            pageRef.setRedirect(true);
            return pageRef ;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorForTemplate));
            return null;
        }
       return null ;
    }

/********************************************************************************
*   @author :IDC Team                                                           *  
*   @date :09/09/2015                                                           *  
*   @description :This Method this search the contact on the basis on the filter*
*                 criteria.                                                     *
*   @param :                                                                    *    
*   @return :PageReference                                                      *
*********************************************************************************/  
    public PageReference getcontact() {
        String FieldsQuery = blankData;
        List<Contact> con = new List<Contact>();
        conName =blankData;
        Map<String, Contact_Search_Fields__c> BrokerContatField = Contact_Search_Fields__c.getAll();
        Date DateValue;// date value if user selected any date filter
        Date DateValue1;
        Date DateValue2;
        Date DateValue3;
        Date DateValue4;
        Date DateValue5;
        Date DateValue6;
        Boolean BooleanVal; // set the boolean value to display filter criteria on visual for page 
        Boolean BooleanVal1;
        Boolean BooleanVal2;
        Boolean BooleanVal3;
        Boolean BooleanVal4;
        Boolean BooleanVal5;
        Boolean BooleanVal6;
   
        try {
            // if user didn't given any value to Value field then Error Message should shown
            if( String.isEmpty(Value) ) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter value'));
                return null;  
            }else if( OpertaorsList.equalsIgnoreCase(Contains)) {
                FieldsQuery = 'SELECT Name FROM Contact WHERE  (RecordType.developername='+strRecordTypeBroker+' or RecordType.developername= '+strRecordTypeBrokerRO+') and ' +Fields +' Like \'%'+Value+'%\'' ;
                // If field type is date or Boolean in search criteria for contact serch
            }else if( BrokerContatField.get(Fields).Field_Type__c == strDate || BrokerContatField.get(Fields).Field_Type__c == Checkbox ) {
                FieldsQuery = 'SELECT Name FROM Contact WHERE (RecordType.developername='+strRecordTypeBroker+' or RecordType.developername= '+strRecordTypeBrokerRO+') and ';
                if( BrokerContatField.get(Fields).Field_Type__c == strDate ) {
                    DateValue = Date.Parse(Value);
                    FieldsQuery += Fields+' '+String.escapeSingleQuotes(OpertaorsList)+' :DateValue';
                } else if( BrokerContatField.get(Fields).Field_Type__c == Checkbox) {
                    if(Value.equalsIgnoreCase('true') || Value.equalsIgnoreCase(objfalse)) {
                        BooleanVal = Boolean.valueOf(Value);
                        FieldsQuery += Fields+' '+string.escapeSingleQuotes(OpertaorsList)+' :BooleanVal';
                    }else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorBoolean));
                        return null;
                    }
                }
            }else {
                FieldsQuery = 'SELECT Name FROM Contact WHERE  (RecordType.developername='+strRecordTypeBroker+' or RecordType.developername= '+strRecordTypeBrokerRO+') and '  +String.escapeSingleQuotes(Fields) + ' ' + String.escapeSingleQuotes(OpertaorsList) + ' ' + '\'' + String.escapeSingleQuotes(Value) + '\'';
            }
           // if filter 1st criteria value is empity or blank
            if( showContactFilter1 && ( FieldsQuery.contains(fields1) || String.isEmpty(Value1))) { 
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorMsg));
                 return null; 
            }else if( showContactFilter1 && OpertaorsList1.equalsIgnoreCase(Contains)) {
                FieldsQuery += ' AND ' +string.escapeSingleQuotes(Fields1) +' Like \'%'+string.escapeSingleQuotes(Value1)+'%\'' ;
            }else if( showContactFilter1 && ( BrokerContatField.get(Fields1).Field_Type__c == strDate || BrokerContatField.get(Fields1).Field_Type__c == Checkbox)) {
                if( BrokerContatField.get(Fields1).Field_Type__c == strDate ) {
                    DateValue1 = Date.Parse(Value1);
                    FieldsQuery += ' AND ' +String.escapeSingleQuotes(Fields1) +' '+String.escapeSingleQuotes(OpertaorsList1)+' :DateValue1';
                }else if( BrokerContatField.get(Fields1).Field_Type__c == Checkbox) {
                    if(Value1.equalsIgnoreCase('true') || Value1.equalsIgnoreCase(objfalse)) {
                        BooleanVal1 = Boolean.valueOf(Value1);
                        FieldsQuery += ' AND '+ String.escapeSingleQuotes(Fields1)+' '+String.escapeSingleQuotes(OpertaorsList1)+' :BooleanVal1';
                    }else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorBoolean));
                        return null;
                    }
                }     
            }else if( showContactFilter1 ) {
                FieldsQuery +=' AND '+String.escapeSingleQuotes(Fields1) + ' ' + String.escapeSingleQuotes(OpertaorsList1) + ' ' + '\'' + String.escapeSingleQuotes(Value1) + '\'';
            }
             // if filter 2nd criteria value is empity or blank
            if( showContactFilter2 && ( FieldsQuery.contains(fields2) || String.isEmpty(Value2))) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorMsg));
                return null; 
            }else if( showContactFilter2 && OpertaorsList2.equalsIgnoreCase(Contains)) {
                FieldsQuery += ' AND ' +string.escapeSingleQuotes(Fields2) +' Like \'%'+string.escapeSingleQuotes(Value2)+'%\'' ;
            }else if( showContactFilter2 && ( BrokerContatField.get(Fields2).Field_Type__c == strDate || BrokerContatField.get(Fields2).Field_Type__c == Checkbox)) {
                if( BrokerContatField.get(Fields2).Field_Type__c == strDate ) {
                    DateValue2 = Date.Parse(Value2);
                    FieldsQuery += ' AND ' +String.escapeSingleQuotes(Fields2) +' '+String.escapeSingleQuotes(OpertaorsList2)+' :DateValue2';
                }else if( BrokerContatField.get(Fields2).Field_Type__c == Checkbox) {
                    if(Value2.equalsIgnoreCase('true') || Value2.equalsIgnoreCase(objfalse)) {
                        BooleanVal2 = Boolean.valueOf(Value2);
                        FieldsQuery += ' AND '+ String.escapeSingleQuotes(Fields2)+' '+String.escapeSingleQuotes(OpertaorsList2)+' :BooleanVal2';
                    }else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorBoolean));
                        return null;
                    }
                }     
            }else if( showContactFilter2 ) {
                FieldsQuery +=' AND '+String.escapeSingleQuotes(Fields2) + ' ' + String.escapeSingleQuotes(OpertaorsList2) + ' ' + '\'' + String.escapeSingleQuotes(Value2) + '\'';
            }               
            // if filter 3rd criteria value is empity or blank
            if( showContactFilter3 && ( FieldsQuery.contains(fields3) || String.isEmpty(Value3))) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorMsg));
                return null; 
            }else if( showContactFilter3 && OpertaorsList3.equalsIgnoreCase(Contains)) {
                FieldsQuery += ' AND ' +string.escapeSingleQuotes(Fields3) +' Like \'%'+string.escapeSingleQuotes(Value3)+'%\'' ;
            }else if( showContactFilter3 && ( BrokerContatField.get(Fields3).Field_Type__c == strDate || BrokerContatField.get(Fields3).Field_Type__c == Checkbox)) {
                if( BrokerContatField.get(Fields3).Field_Type__c == strDate ) {
                    DateValue3 = Date.Parse(Value3);
                    FieldsQuery += ' AND ' +String.escapeSingleQuotes(Fields3) +' '+String.escapeSingleQuotes(OpertaorsList3)+' :DateValue3';
                }else if( BrokerContatField.get(Fields3).Field_Type__c == Checkbox) {
                    if(Value3.equalsIgnoreCase('true') || Value3.equalsIgnoreCase(objfalse)) {
                        BooleanVal3 = Boolean.valueOf(Value3);
                        FieldsQuery += ' AND '+ String.escapeSingleQuotes(Fields3)+' '+String.escapeSingleQuotes(OpertaorsList3)+' :BooleanVal3';
                    }else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorBoolean));
                        return null;
                    }
                }     
            }else if( showContactFilter3 ) {
                FieldsQuery +=' AND '+String.escapeSingleQuotes(Fields3) + ' ' + String.escapeSingleQuotes(OpertaorsList3) + ' ' + '\'' + string.escapeSingleQuotes(Value3) + '\'';
            }
            // if filter 4th criteria value is empity or blank
            if( showContactFilter4 && ( FieldsQuery.contains(fields4) || String.isEmpty(Value4))) {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorMsg));
                 return null; 
            }else if( showContactFilter4 && OpertaorsList4.equalsIgnoreCase(Contains)) {
                FieldsQuery += ' AND ' +string.escapeSingleQuotes(Fields4) +' Like \'%'+string.escapeSingleQuotes(Value4)+'%\'' ;
            }else if( showContactFilter4 && ( BrokerContatField.get(Fields4).Field_Type__c == strDate || BrokerContatField.get(Fields4).Field_Type__c == Checkbox)) {
                if( BrokerContatField.get(Fields4).Field_Type__c == strDate ) {
                    DateValue4 = Date.Parse(Value4);
                    FieldsQuery += ' AND ' +String.escapeSingleQuotes(Fields4) +' '+String.escapeSingleQuotes(OpertaorsList4)+' :DateValue4';
                }else if( BrokerContatField.get(Fields4).Field_Type__c == Checkbox) {
                    if(Value4.equalsIgnoreCase('true') || Value4.equalsIgnoreCase(objfalse)) {
                        BooleanVal4 = Boolean.valueOf(Value4);
                        FieldsQuery += ' AND '+ String.escapeSingleQuotes(Fields4)+' '+String.escapeSingleQuotes(OpertaorsList4)+' :BooleanVal4';
                    }else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorBoolean));
                        return null;
                    }
                }     
            }else if( showContactFilter4 ) {
                FieldsQuery +=' AND '+String.escapeSingleQuotes(Fields4) + ' ' + String.escapeSingleQuotes(OpertaorsList4) + ' ' + '\'' + String.escapeSingleQuotes(Value4) + '\'';
            }
            
            // if filter 5th criteria value is empity or blank
            if( showContactFilter5 && ( FieldsQuery.contains(fields5) || String.isEmpty(Value5))) {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorMsg));
                 return null; 
            }else if( showContactFilter5 && OpertaorsList5.equalsIgnoreCase(Contains)) {
                FieldsQuery += ' AND ' +string.escapeSingleQuotes(Fields5) +' Like \'%'+string.escapeSingleQuotes(Value5)+'%\'' ;
            }else if( showContactFilter5 && ( BrokerContatField.get(Fields5).Field_Type__c == strDate || BrokerContatField.get(Fields5).Field_Type__c == Checkbox)) {
                if( BrokerContatField.get(Fields5).Field_Type__c == strDate ) {
                    DateValue5 = Date.Parse(Value5);
                    FieldsQuery += ' AND ' +String.escapeSingleQuotes(Fields5) +' '+String.escapeSingleQuotes(OpertaorsList5)+' :DateValue5';
                }else if( BrokerContatField.get(Fields5).Field_Type__c == Checkbox) {
                    if(Value5.equalsIgnoreCase('true') || Value5.equalsIgnoreCase(objfalse)) {
                        BooleanVal5 = Boolean.valueOf(Value5);
                        FieldsQuery += ' AND '+ String.escapeSingleQuotes(Fields5)+' '+String.escapeSingleQuotes(OpertaorsList5)+' :BooleanVal5';
                    }else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorBoolean));
                        return null;
                    }
                }     
            }else if( showContactFilter5 ) {
                FieldsQuery +=' AND '+String.escapeSingleQuotes(Fields5) + ' ' + String.escapeSingleQuotes(OpertaorsList5) + ' ' + '\'' + String.escapeSingleQuotes(Value5) + '\'';
            }
            
            // if filter 6th criteria value is empity or blank
            if( showContactFilter6 && ( FieldsQuery.contains(fields6) || String.isEmpty(Value6))) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorMsg));
                return null; 
            }else if( showContactFilter6 && OpertaorsList6.equalsIgnoreCase(Contains)) {
                FieldsQuery += ' AND ' +string.escapeSingleQuotes(Fields6) +' Like \'%'+string.escapeSingleQuotes(Value6)+'%\'' ;
            }else if( showContactFilter6 && ( BrokerContatField.get(Fields6).Field_Type__c == strDate || BrokerContatField.get(Fields6).Field_Type__c == Checkbox)) {
                if( BrokerContatField.get(Fields6).Field_Type__c == strDate ) {
                    DateValue6 = Date.Parse(Value6);
                    FieldsQuery += ' AND ' +String.escapeSingleQuotes(Fields6) +' '+String.escapeSingleQuotes(OpertaorsList6)+' :DateValue6';
                }else if( BrokerContatField.get(Fields6).Field_Type__c == Checkbox) {
                    if(Value6.equalsIgnoreCase('true') || Value6.equalsIgnoreCase(objfalse)) {
                        BooleanVal6 = Boolean.valueOf(Value6);
                        FieldsQuery += ' AND '+ String.escapeSingleQuotes(Fields6)+' '+String.escapeSingleQuotes(OpertaorsList6)+' :BooleanVal6';
                    }else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorBoolean));
                        return null;
                    }
                }     
            }else if( showContactFilter6 ) {
                FieldsQuery +=' AND '+String.escapeSingleQuotes(Fields6) + ' ' + String.escapeSingleQuotes(OpertaorsList6) + ' ' + '\'' + String.escapeSingleQuotes(Value6) + '\'';
            }
        }catch ( Exception Exp) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorDate));
            return null; 
        }
       
        if(!String.isBlank(FieldsQuery)){
            try {
             con = database.query(FieldsQuery);
            }catch (Exception Exp ) {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorDate));
               return null;        
            }
          
        }
        conId = blankData;
      
        if( !con.isEmpty()) {
            for(Contact objCon: con) {
                conName += objCon.Name + ';  ';
                conId += objCon.Id+ ';';
            }
        }
        objCorrLetter.To_Contact_List__c = conName;
        return null;
    }
}