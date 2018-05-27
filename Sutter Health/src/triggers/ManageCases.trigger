/**  
*   Trigger Name: ManageCases
*    Author: Brandon Cassis
*    Date: 1-September-2013
*    Description: This Trigger runs on the insert and update of Cases. It is used to manage the
*    execution of the different actions programitacally performed on Cases made of of Interaction 
*    logs and Service Request.
*    
*    History
*      
*    VERSION    AUTHOR              DATE        DETAIL 
*      2.0     Atul Gupta       03/13/2014       On Case update called the method AssignGrievanceEntitlement of Class ManageCaseMilestoneDatabase 
*                                               that flips the EntitlemntId for the Cases of Record type Grievance in case the Secondary Reason is changed
*                                               from Non-Expedited value to Expedited and vice versa.
*      3.0    Apoorv Kuchhal    06/06/2014       We have modified the code for Release 5.2 , Requirement 3040. For Service Request "Internal Service Request". 
*      3.1    Venkat Ramesh     06/12/2014       Added some debug logs to see assignment rule condition values 
*      3.2    Shivangi Gaur     03/11/2014       Added 4 conditions for the new Finance Payroll queues ("Payroll Leave Processing", "Payroll Absence Plans", "Payroll Deductions", "Payroll Accounting and Banking" and edited an existing condition for "Payroll Coordination" queue to "Payroll Taxes" queue.
*      3.3    Nikhil Srivastava 08/12/2015       REQ 3390 - Web to Case. Method 'createSRForWebToCase' in helper class 'ManageCaseHelpTrigger' to check incoming cases via portal.
*      3.4    Anupam Goel       26/11/2015       REQ-3708 added condition block in before update for Unlock Priority and Urgency Fields on Service Requests used by Contact Center.
       3.5    Prerna Chandak    6/28/2016        Req-3835 added code in isAfter to update the milestone completion dates.
*    --------
**/

/** 
*    @Description: Executes on Before Insert, After Insert, and Before Update.
**/
trigger ManageCases on Case (before insert, after insert, before update, after update) {

    /** @Description:Req. Release 6.3 Changes START**/
    private static final String QUEUE_ID_PREFIX = '00G';
    private static final String ERROR_OWNER_CHANGE='You cannot modify the owner of others record';
    private static final string HR_AUTH_ERROR = 'You do not have the right to fill HR Authorization';
    private static final string DMHC_ERROR = 'You do not have the right to fill DMHC fields';

    private static final string ERROR_URGENCY_PRIORITY_CHANGE='You can only update the Priority and Urgency fields';      // req: 3708, Error messages User can only edit the Priority and Urgency fields.      
    private static final string ERROR_ASSIGN_CASE ='You cannot edit the Customer Inquiry without assigning it to yourself from the queue';     // req: 3708, Error messages User can not edit the record. 
        
    map<string, string> caseRecordTypeMap = new Map<string, string>();
    map<string, string> caseRecordTypeNameMap = new Map<string, string>();
    map<string, string> contactRecordTypeMap = new Map<string, string>();

    /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 START**/
    private static final string CASE_RT_OOA_OON = 'OOA/OON';
    
    List<Case> OOA_OON_SRList = new List<Case>();
    List<Case> updateMemberFieldsSRList = new List<Case>();
    List<Case> updateMemberFieldsSRList_OnInsert = new List<Case>();
    /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 END**/
    
    /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
    Map<Id, Case> oldCaseMap = new Map<Id, Case>();
    Map<Id, Case> newCaseMap = new Map<Id, Case>();
    Map<Id,Case> objCaseMapParent = new Map<Id,Case>();
    
    /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
	/** @START: Req 3213 Email to case payroll**/
	private static final list<String> SUTTER_EMAIL = new list<String>{'@cpmcri.org','@pamf.org','@caminomedical.org','@support.pamf.org','@sutterhealth.org','@fpnc.com','@sutterhealthplus.org','@sutterphysicianservices.net',
																		'@sutterphysicianservices.org','@sutterphysicianservices.com','@sutterhealthpartners.com','@mgma.sutterhealth.org','@mysutter.com'};
	/** @END: Req 3213 Email to case payroll**/
   /* for(RecordType rec:[select Id , name from RecordType where sObjectType = 'Case'])
    {
        caseRecordTypeMap.put(rec.Name, rec.Id);
        caseRecordTypeNameMap.put(rec.Id,rec.Name);
    }*/
    
    Map<String,Schema.RecordTypeInfo> caseRtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
    for( Schema.RecordTypeInfo rtype : caseRtMapByName.values()){
        caseRecordTypeMap.put(rtype.getName(), rtype.getRecordTypeId());
        caseRecordTypeNameMap.put(rtype.getRecordTypeId(),rtype.getName());
    }
    
    /*Code added in release 6.1 as the Human Resource Job Evaluation Form was renamed to Human Resource Web To Case So that the class is handled properly*/
     If(caseRecordTypeMap.get('Human Resource Web To Case')!= null)
     {
      caseRecordTypeMap.put('Human Resource Job Evaluation Form', caseRecordTypeMap.get('Human Resource Web To Case'));
      caseRecordTypeNameMap.put(caseRecordTypeMap.get('Human Resource Web To Case'),'Human Resource Job Evaluation Form');
     }
     
    /*for(RecordType rec:[select Id , name from RecordType where sObjectType = 'Contact'])
    {
        contactRecordTypeMap.put(rec.Name, rec.Id);        
    } */
    
    
     Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Contact.getRecordTypeInfosByName();
    for( Schema.RecordTypeInfo rtype: rtMapByName.values() ) {
    contactRecordTypeMap.put( rtype.getName() , rtype.getRecordTypeId());
    }    
    

/** @Description: Variables used to pass Case data to Classes**/
    List<Case> updateCases = new List<Case>();
    List<Case> beforeInsertCases = new List<Case>();
    List<Case> afterInsertCases = new List<Case>();
    
    List<Member_Enquiries__c> afterInsertMemberInquiries = new List<Member_Enquiries__c>();
    Map<Id, Case> newMap = new Map<Id, Case>();
    Map<Id, Case> oldMap = new Map<Id, Case>();
    List<Case> milestoneUpdateCases =  new List<Case>();
    List<Member_Enquiries__c> afterUpdateMemberInquiries = new List<Member_Enquiries__c>();
    
    /** @Description: bypass trigger logic if custom label is set to TRUE **/
    if(Label.DisableTrigger == 'FALSE'){
    //3318
    List<Case> afterInsertGrievanceCases = new List<Case>();
    Set<String> afterInsertGrievanceCaseIdSet = new Set<String>();
    
    //3318
    List<Case> grievanceCasesUpdated = new List<Case>();
    List<Case> afterUpdateGrievanceCases = new List<Case>();
    Set<String> afterUpdateGrievanceCaseIdSet = new Set<String>();

/** @Description: Fetching the Contact Records in the map where Record Type is Member. **/
// map<Id,Contact> mapContact=new map<Id,Contact>([Select Id,Name from Contact where RecordType.Id=:contactRecordTypeMap.get('Member')]);
/** @Description: This section will execute if this trigger is fired due to an insert operation, from the Salesforce user interface, Apex, or the API. **/
    
    
    
    if(Trigger.isInsert) {
   

        
        /** @Description: This section will execute if this trigger is fired due to an before insert operation, from the Salesforce user interface, Apex, or the API. **/
        if(Trigger.isBefore) {    
            
        /* Req 3390 - Web to Case. Method 'createSRForWebToCase' in helper class 'ManageCaseHelpTrigger' to check incoming cases via portal and accordingly perform operation on      incoming case. 
        *  Passing new case detail & Map of record type 
        */
           ManageCaseHelpTrigger.createSRForWebToCase(trigger.new,caseRecordTypeMap);
           List<Case> parentRecordsUdpate = new List<Case> ();
           Set<id> parentRecordsUdpateSetId= new Set<Id>();
           Profile s3Profile = [Select Name from Profile where Id =: UserInfo.getProfileId() limit 1];
            
            // @Description: Capturing a list of the new versions of the Case records by iterating the "Trigger.New" and storing in list variable of Case. **/
            for(Case loopCase: Trigger.new) {
            
             /* @@ Added as part of Req-3835 START */ 
            if(loopCase.ParentId != NULL){
                parentRecordsUdpateSetId.add(loopCase.ParentId);
               
            }
               /* @@ Added as part of Req-3835 END*/
            
            //Req # 3200
            if((loopCase.Secondary_Reason__c == 'Exempt' || loopCase.Secondary_Reason__c == Label.CL_379_PDI_Secondary_Reason_Grievance || loopCase.Secondary_Reason__c == Label.CL_378_PDI_Secondary_Reason_Notification))
            {
                //loopCase.Bypass_ValidationRule__c = true;
                milestoneUpdateCases.add(loopCase);
            }
            
           // REQ-3555: Check Executive Service flag for Executive service team profile                  
                    if(s3Profile.Name == Label.CL_Executive_Service_Team            
                     && (loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Accounting')          
                         ||  loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Accounts Payable')        
                         ||  loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Payroll')          
                         ||  loopCase.RecordTypeId == caseRecordTypeMap.get('Human Resources')          
                           
                      )        
                    ){          
                                    
                        loopCase.Executive_Service__c = true;
                        if(!String.isBlank(loopCase.Executive_Calling_in_Reference_To__c)){
                            Contact c = [SELECT Id, name FROM Contact WHERE Id =: loopCase.Executive_Calling_in_Reference_To__c];
                            loopCase.Requestor_Calling_in_Reference_To__c = c.Name;
                        }
                        
                                 
                    }
            
            /** @Description:Req. 3040 Release 5.2 Changes **/       
            /** @Description:Req. 3123 Release 5.3 Changes **/      
            if(loopCase.RecordTypeId != caseRecordTypeMap.get('Internal Service Request') 
            && loopCase.RecordTypeId != caseRecordTypeMap.get('Employee Inquiry')
            && loopCase.RecordTypeId != caseRecordTypeMap.get('Human Resource Job Evaluation Form')
            && loopCase.RecordTypeId != caseRecordTypeMap.get('Human Resource Web To Case')  )
            {
                if(loopCase.Function__c <> Null && loopCase.Team__c <> Null)
                {
                   if(loopCase.Function__c == 'Document Management Center')
                    {
                     loopCase.RecordTypeId = caseRecordTypeMap.get('Document Management Center');
                    }
                    else if(loopCase.Function__c == 'Finance')
                    {
                        if(loopCase.Team__c == '[Tier 3] Regional Accounting Leads' 
                        || loopCase.Team__c == '[Tier 3] JE & Balance Sheet Recons'
                        || loopCase.Team__c == '[Tier 3] Cash Accounting'
                        || loopCase.Team__c == '[Tier 3] Fixed Assets'
                        || loopCase.Team__c == '[Tier 3] Accounts Receivable'
                        || loopCase.Team__c == '[Tier 3] Managed Care'
                        || loopCase.Team__c == '[Tier 3] Financial Data & Applications'
                        || loopCase.Team__c == '[Tier 3] Reporting and Audit')
                        {
                         loopCase.RecordTypeId = caseRecordTypeMap.get('Finance Accounting');
                        }
                        else if(loopCase.Team__c == '[Tier 1] AP / Purchasing / Supply Chain' 
                        || loopCase.Team__c == '[Tier 2] Finance Accounts Payable'
                        || loopCase.Team__c == '[Tier 3] Invoice & Payment Processing'
                        || loopCase.Team__c == '[Tier 3] Exception Resolution'
                        || loopCase.Team__c == '[Tier 3] Physician Contract Team')
                        {
                         loopCase.RecordTypeId = caseRecordTypeMap.get('Finance Accounts Payable');
                        }
                        /** @Description:Req. 3190 Release 6.3 Changes Date : 11/03/2014**/
                        else if(loopCase.Team__c == '[Tier 2] Finance Payroll / T&E' 
                        || loopCase.Team__c == '[Tier 1] Payroll T&E / Compensation'
                        || loopCase.Team__c == '[Tier 3] Payroll Review'
                        || loopCase.Team__c == '[Tier 3] Compensation'
                        || loopCase.Team__c == '[Tier 3] Payroll Leave Processing'
                        || loopCase.Team__c == '[Tier 3] Payroll Accounting and Banking'
                        || loopCase.Team__c == '[Tier 3] Payroll Deductions'
                        || loopCase.Team__c == '[Tier 3] Payroll Upload'  
                        || loopCase.Team__c == '[Tier 3] Payroll Absence Plans'
                        || loopCase.Team__c == '[Tier 3] Payroll Taxes')
                        /** @Description:Req. 3190 Release 6.3 Changes Date : 11/03/2014**/
                        {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('Finance Payroll');
                        }
                    }
                    else if(loopCase.Function__c == 'Human Resource')
                    {
                     if(loopCase.Function__c == 'Human Resource' 
                        && loopCase.Customer_Intent__c == 'HR Reporting'
                        && loopCase.Team__c == '[Tier 3] HR Reporting'
                        && loopCase.Customer_Sub_Intents__c == 'Adhoc Report Request Web')
                        {
                          
                          loopCase.RecordTypeId = caseRecordTypeMap.get('Human Resource Web To Case');
                        }
                        else if(loopCase.Function__c == 'Human Resource' 
                        && loopCase.Customer_Intent__c == 'Employee Compensation'
                        && loopCase.Team__c == '[Tier 3] Compensation'
                        && loopCase.Customer_Sub_Intents__c == 'Job Evaluation' && loopCase.origin =='Web')
                        {
                         loopCase.RecordTypeId = caseRecordTypeMap.get('Human Resource Job Evaluation Form');
                        }
                        
                    else if(loopCase.Function__c == 'Human Resource')
                        {
                         loopCase.RecordTypeId = caseRecordTypeMap.get('Human Resources');
                        }
                                       
                    }
                    else if(loopCase.Function__c == 'Revenue Cycle')
                    {
                     loopCase.RecordTypeId = caseRecordTypeMap.get('Revenue Cycle');
                    }
                    else if(loopCase.Function__c == 'Supply Chain')
                    {
                     loopCase.RecordTypeId = caseRecordTypeMap.get('Supply Chain');
                    }
                }
            }

            /* if any case is generated through Email-to Case module, and User sets out of office reply. Now S3 agents reply to the mail 
            *  Automatic mail will be triggered from  mail box and there will be a new case created in response.
            *  To fix this issue, we are checking all possible values in case subject. If it matches then we are not creating case.
            */
            
            

            if(loopCase.Origin=='Email to Case')        
            {
                
                List<string> possiblePhrases = system.label.OOO1.split(',');
                boolean isAutomaticReply = false;
               
                for(string phraseValue : possiblePhrases){
                    if(String.IsNotBlank(loopCase.Subject) && loopCase.Subject.startsWithIgnoreCase(phraseValue)){
                        isAutomaticReply = true;
                    }
                }
                
                if(!isAutomaticReply){
                    
                
                /** @Description:Req. 3139 Release 6 Changes Date : 7/8/2014**/
                if(loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Accounts Payable'))
                {
                    loopCase.Function__c= 'Finance';
                    loopCase.Email_from_Case__c = true;
                    //loopCase.Origin='Email';
                    loopCase.Requestor_Email__c = loopCase.SuppliedEmail;
                    loopCase.Sub_Function__c ='Accounts Payable';
                    loopCase.Team__c ='[Tier 1] AP / Purchasing / Supply Chain';
                   // loopCase.Customer_Intent__c = 'Vendor Setup/Vendor Data Change Request';
                   
                   
                                                         
                /** @Description:Req. 3122 Release 5.3 Changes Date : 7/23/2014**/
                    loopCase.Call_Back_defaut_true__c =false;
                } 
                else if(loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Accounting'))                
                {
                    /** @Description:Req. 3008 Release 5.3 Changes Date : 7/8/2014**/
                    //loopCase.RecordTypeId=caseRecordTypeMap.get('Finance Accounting');    
                    loopCase.Function__c= 'Finance';
                    loopCase.Email_from_Case__c = true;
                    //loopCase.Origin='Email';
                    loopCase.Sub_Function__c ='GL Accounting';
                    loopCase.Team__c ='Accounting Service Desk';
                    loopCase.Customer_Intent__c = 'Other';
                    loopCase.Priority='Medium';
                    /** @Description:Req. 3122 Release 5.3 Changes Date : 7/23/2014**/
                    loopCase.Call_Back_defaut_true__c =false;
                    /** @Description:Req. 3122 Release 5.3 Changes Date : 7/8/2014**/ 
                }
                /** @Description:Req. 3008 Release 5.3 Changes Date : 7/8/2014**/
                /** @Description:Req. 3122 Release 5.3 Changes Date : 7/8/2014**/
                 /** @Description:Req. 3213 Release 6.3 Changes Date : 10/28/2014**/
                /** @Description:Req. 3213 Changes Date : 10/28/2014 Changed Team field value for Finance Payroll Email-to-Case**/ 
                else if(loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Payroll'))
                {
                    loopCase.Function__c= 'Finance';
                    loopCase.Email_from_Case__c = true;
                    //loopCase.Origin='Email'; Leave as origin set in email-to-case config
                    loopCase.Requestor_Email__c = loopCase.SuppliedEmail;
                    loopCase.Sub_Function__c ='Payroll/T&E';
                    loopCase.Team__c ='[Tier 1] Payroll T&E / Compensation';
                    loopCase.Call_Back_defaut_true__c =false;
                    boolean isValidEmail = false;
                    for(String internalEmail : SUTTER_EMAIL){
                    	if(String.isNotBlank(loopCase.SuppliedEmail) && loopCase.SuppliedEmail.contains(internalEmail)){
                    		isValidEmail = true;
                    	}
                    }
                    if(!isValidEmail){
                    	loopCase.Status = 'Closed';
                    	loopCase.Non_Sutter_Email_to_case__c = true;
                    	loopCase.RecordTypeId = caseRecordTypeMap.get('Finance Payroll RO');
                    	loopCase.S3_Resolution__c = 'Other';
                    	loopCase.S3_Root_Cause__c = 'Other';
                    	loopCase.Close_Reason__c = 'Rejected';
                    }
                }
                /** @Description:Req. 3213 Release 6.3 Changes Date : 10/28/2014**/ 
                /** @Description:Req. 3213 Release 6.3 Changes Date : 10/28/2014**/

                
            }
            }
              
            if(loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Accounts Payable') || 
                loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Payroll') || 
                loopCase.RecordTypeId == caseRecordTypeMap.get('Human Resources') ||
                loopCase.RecordTypeId == caseRecordTypeMap.get('Revenue Cycle')||
                /** @Description:Req. 3402 : Updated call back value with default value Date : 9/14/2015**/
                loopCase.RecordTypeId == caseRecordTypeMap.get('Supply Chain'))
                {
                    loopCase.Call_Back__c= loopCase.Call_Back_defaut_true__c;                       
                }
                    

              /** @Description : Converted WF's Req. 3123 Release 5.3 Changes **/

              /** Case01_AssignOwnerToQueue **/  
              if((loopCase.Inquiry_Type__c == 'Payroll')&&((loopCase.Inquiry_Reason__c == 'Employee Data Setup and Maintenance') 
                  || (loopCase.Inquiry_Reason__c == 'Employee Payroll or Paycheck Inquiry')
                  || (loopCase.Inquiry_Reason__c == 'Employee Data Setup and Maintenance')  
                  || (loopCase.Inquiry_Reason__c == 'Manager Payroll or Paycheck Inquiry')
                  || (loopCase.Inquiry_Reason__c == 'Timecard/Kronos Inquiry')
                  || (loopCase.Inquiry_Reason__c == 'Travel & Expense Inquiry')
                  || (loopCase.Inquiry_Reason__c == 'Time Off Inquiry')
                  || (loopCase.Inquiry_Reason__c == 'Garnishment') 
                  || (loopCase.Inquiry_Reason__c == 'System Inquiries')
                  || (loopCase.Inquiry_Reason__c == 'Pay Inquiry')
                  || (loopCase.Inquiry_Reason__c == 'Kronos'))) 
              {
                loopCase.Team__c= '[Tier 1] Payroll T&E / Compensation' ;                
              }                 
              
             
             /** Case02_AssignOwnerToQueue **/  
              if((loopCase.Inquiry_Type__c == 'HR Benefits')&&((loopCase.Inquiry_Reason__c == 'ESL/Sick') 
                  || (loopCase.Inquiry_Reason__c == 'Health & Welfare')
                  || (loopCase.Inquiry_Reason__c == 'Health & Welfare - FSA')  
                  || (loopCase.Inquiry_Reason__c == 'Health & Welfare - Open Enrollment')
                  || (loopCase.Inquiry_Reason__c == 'Other Benefits')
                  || (loopCase.Inquiry_Reason__c == 'PTO/Vacation')
                  || (loopCase.Inquiry_Reason__c == 'Retirement - Defined Contribution')
                  || (loopCase.Inquiry_Reason__c == 'Retirement - General Inquiry')
                  || (loopCase.Inquiry_Reason__c == 'Tuition/Education Reimbursement')
                  || (loopCase.Inquiry_Reason__c == 'Wellness Program') 
                  || (loopCase.Inquiry_Reason__c == 'Work/Life Event')
                  || (loopCase.Inquiry_Reason__c == 'Health & Welfare - Premium Billing') ))
              {
                loopCase.Team__c= '[Tier 1] HR Benefits';  
              }
              
              if((loopCase.Inquiry_Type__c == 'HR Benefits') &&  (loopCase.Inquiry_Reason__c == 'Retirement - Defined Contribution'))
              {
               loopCase.Team__c= '[Tier 1] Defined Contribution'; 
              }
              
              if((loopCase.Inquiry_Type__c == 'HR Pension') &&  (loopCase.Inquiry_Reason__c == 'Retiree Medical (RHCA, ERMA and Post-65)')
               || (loopCase.Inquiry_Reason__c == 'Retirement - Pension'))
              {
               loopCase.Team__c= '[Tier 1] HR Pension'; 
               }
                                         
              /** Case03_AssignOwnerToQueue/Case04_AssignOwnerToQueue/Case06_AssignOwnerToQueue**/  
              if((loopCase.Inquiry_Type__c == 'HR General Inquiry') 
                  && ((loopCase.Inquiry_Reason__c == 'General Inquiry - HR') ||(loopCase.Inquiry_Reason__c == 'Employee Engagement')))
              {
                loopCase.Team__c= '[Tier 1] Workforce Relations'; 
              }
              
               if((loopCase.Inquiry_Type__c == 'HR Data') 
                  &&((loopCase.Inquiry_Reason__c == 'Employee Data Setup and Change')
                  || (loopCase.Inquiry_Reason__c == 'Employment & Salary Verification')))  
              {
                loopCase.Team__c= '[Tier 1] HR Data'; 
              }
              
              
              
              if((loopCase.Inquiry_Type__c == 'HR General Inquiry')&&(loopCase.Inquiry_Reason__c == 'HR Tool User Support'))
               {
               loopCase.Team__c= '[Tier 1] HRIS'; 
               }
                 
               
              /** Case05_AssignOwnerToQueue**/  
              if((loopCase.Inquiry_Type__c == 'HR General Inquiry')&&((loopCase.Inquiry_Reason__c == 'HR Reporting')))
              {
               loopCase.Team__c= '[Tier 3] HR Reporting'; 
              }                

              /** Case07_AssignOwnerToQueue**/  
              if((loopCase.Inquiry_Type__c == 'Performance/Learning')&& (loopCase.Inquiry_Reason__c == 'Employee Learning')) 
                   
              {
               loopCase.Team__c= '[Tier 1] Learning'; 
              }
              
              /** Case08_AssignOwnerToQueue**/  
              if((loopCase.Inquiry_Type__c == 'Recruitment')&&((loopCase.Inquiry_Reason__c == 'Recruitment')))
              {
               loopCase.Team__c= '[Tier 1] HR Recruitment';  
              } 


                /** @Description:Req. 3122 Release 5.3 Changes Date : 7/8/2014**/
                /** @Description: Adding records in list. **/
                beforeInsertCases.add(loopCase);     

                if(loopCase.Status == Label.CL05_Closed)
                {
                    if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Address Change Request'))
                    {
                        loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Address Change Request RO');
                    }
                    if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Affiliate Data Change Request'))
                    {
                        loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Affiliate Data Change Request RO');
                    }
                    if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Application Request'))
                    {
                        loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Application Request RO');
                    }
                    if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Data Change Request'))
                    {
                        loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Data Change Request RO');
                    }
                    if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Expirables Request'))
                    {
                        loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Expirables Request RO');
                    }
                    if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Other Request'))
                    {
                        loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Other Request RO');
                    }
                    if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Reapplication Request'))
                    {
                        loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Reapplication Request RO');
                    }
                    if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Report Request'))
                    {
                        loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Report Request RO');
                    }
                    if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Rush Application Request'))
                    {
                        loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Rush Application Request RO');
                    }
                     if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Temporary Privilege Request'))
                    {
                        loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Temporary Privilege Request RO');
                    }
                }
                
                 /** Req : 3242 **/
                if(loopCase.RecordTypeId == caseRecordTypeMap.get(System.Label.CL13_SHPInteractionLog)) {
                    if(loopCase.Reason__c == System.Label.Public_Action && (loopCase.Secondary_Reason__c == System.Label.Media_Threat || 
                          loopCase.Secondary_Reason__c == System.Label.Legal_Threat)) {
                       loopCase.IsThreatEMailSent__c = true; 
                    } else {
                        loopCase.IsThreatEMailSent__c = false; 
                    }
                }
                
                /** @Description:Req. 3262 Release 6.2 Changes Date : 01/05/2015 START**/
                if(loopCase.RecordtypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_OOA_OON).RecordTypeId){
                    ManageCaseDatabase.groupMember();
                        
                    if(!ManageCaseDatabase.isMemberOfSHP_OOA_OON){
                    
                        if(!String.isBlank(loopCase.HR_Authorization__c)){
                        
                            loopCase.addError(HR_AUTH_ERROR); 
                        }
                        if(loopCase.DMHC_30_min__c <> null || loopCase.Date_Time_Hospital_Notified_SHP__c <> null || loopCase.Date_Time_SHP_Notified_Hospital__c <> null){
                        
                            loopCase.addError(DMHC_ERROR); 
                        }
                    }
                }
                /** @Description:Req. 3262 Release 6.2 Changes Date : 01/05/2015 END**/
            }
            /* @@ Added as part of Req-3835 START */
            for(Case c : [select id, Has_Provider_Directory_Inaccuracy__c from case where id in :parentRecordsUdpateSetId and RecordType.Name=:Label.CL_379_PDI_Secondary_Reason_Grievance]){
                c.Has_Provider_Directory_Inaccuracy__c = true;
                c.Bypass_ValidationRule__c = true;
                
                parentRecordsUdpate.add(c);
            }
            
            update parentRecordsUdpate;
            /* @@ Added as part of Req-3835 START */
            /** @Description: Before passing the Insert Case list in function, we are validating its size, which must be greater than 0**/
            if(beforeInsertCases.size() > 0) {
            
                /**  @Description: This method is used to set the order of execution on the Case object before it is inserted. 
                *     
                **/
                  ManageCaseDatabase.ManageBeforeInsertedCases(beforeInsertCases);
            }
            
            //Req #3200
            if(milestoneUpdateCases.size() > 0)
            {
                /** @Description: Call the method AssignGrievanceEntitlement passing the list of cases **/
                ManageCaseMilestoneDatabase.AssignGrievanceEntitlement(milestoneUpdateCases);
                /*REQ 3835 - To fire entitlement process */
                ManageCaseMilestoneDatabase.assignPDIEntitlement(milestoneUpdateCases);
            }
        }
        if(Trigger.isAfter) {  
          
              

              Set<Id> contactIds=new Set<Id>();
             
              for(Case objCase : Trigger.new)
              {                    
                  contactIds.add(objCase.Member_Id_Contact__c);
                  
              }
              map<Id,Contact> mapContact=new map<Id,Contact>([Select Id,Name from Contact where Id in : contactIds ]);
              /** @Description: Capturing a list of the new Case records by iterating the "Trigger.New" and storing in list variable of Case type **/
              for(Case loopCase : Trigger.new) {
                
                
                 //3318 after insert
                if(loopCase.RecordtypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(Label.CL43_Grievance_RT).RecordTypeId){
                    
                    afterInsertGrievanceCases.add(loopCase);
                } 
                
                /** @Description: Inserting the Member Inquiry record if the Record Types are Benefits,Billing,Complaint,Documentation,Eligibility,Enrollment,Non-SHP Contact,Claim Review,Grievance,Provider Dispute and MemberId is not null**/
                if(loopCase.RecordTypeId == caseRecordTypeMap.get('Benefits') || loopCase.RecordTypeId == caseRecordTypeMap.get('Billing')
                || loopCase.RecordTypeId == caseRecordTypeMap.get('Complaint') 
                || loopCase.RecordTypeId == caseRecordTypeMap.get('Documentation') 
                || loopCase.RecordTypeId == caseRecordTypeMap.get('Eligibility') || loopCase.RecordTypeId == caseRecordTypeMap.get('Enrollment')
                || loopCase.RecordTypeId == caseRecordTypeMap.get('Non-SHP Contact')
                || loopCase.RecordTypeId == caseRecordTypeMap.get('Claim Review') || loopCase.RecordTypeId == caseRecordTypeMap.get('Grievance')
                || loopCase.RecordTypeId == caseRecordTypeMap.get('Provider Dispute') )
                {
                    if(loopCase.Member_Id_Contact__c != Null) //3087
                    {
                        Member_Enquiries__c objMemberEnquiry = new Member_Enquiries__c();
                        // objMemberEnquiry.Name=mapContact.get(loopCase.Member_Id_Contact__c).Name;
                        objMemberEnquiry.Case__c = loopCase.Id;
                        objMemberEnquiry.Member_Id__c = loopCase.Member_Id_Contact__c;
                        objMemberEnquiry.Intent__c = caseRecordTypeNameMap.get(loopCase.RecordTypeId);
                        afterInsertMemberInquiries.add(objMemberEnquiry);
                    }
                }
                
                /** @Description: Adding new record in list. **/              
                afterInsertCases.add(loopCase);
                
                /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 START**/ 
                if(loopCase.RecordtypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_OOA_OON).RecordTypeId
                            && loopCase.Member_Name_OOA_OON__c <> null)
                {
                    updateMemberFieldsSRList_OnInsert.add(loopCase);
                }
                if(loopCase.RecordtypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_OOA_OON).RecordTypeId
                                && loopCase.Secondary_Reason__c <> null)
                {
                    OOA_OON_SRList.add(loopCase);
                }
                /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 END**/  
            }
            
            /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 START**/ 
            if(!updateMemberFieldsSRList_OnInsert.isEmpty()){
                    
                ManageCaseDatabase.updateMemberFieldsSR(updateMemberFieldsSRList_OnInsert);
            }
            if(!OOA_OON_SRList.isEmpty()){
            
                ManageCaseDatabase.updateOOA_OON_InteractionLog(OOA_OON_SRList); 
            }
            /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 END**/ 
            
            if(afterInsertMemberInquiries.size() > 0) {
                    
            /**  @Description: This method will insert the new version of Case whose record after the insert is preformed.
            *     
            **/
            
                ManageCaseDatabase.ManageAfterInsertedUpdatedMemberInquiries(afterInsertMemberInquiries);
            }
            
            /** @Description: Before passing the InsertCase list in function, we are validating its size, which must be greater than 0**/
            if(afterInsertCases.size() > 0) {
            
                /**  @Description: This method will insert the new version of Case whose record after the insert is preformed.**/
                    
                
                ManageCaseDatabase.ManageAfterInsertedCases(afterInsertCases);
            }
         
                
               
               //3318
            if(!afterInsertGrievanceCases.isEmpty()){
                
                for(Case afterinsertCase : afterInsertGrievanceCases){
                    
                    afterInsertGrievanceCaseIdSet.add(afterinsertCase.Id);
                }
                if(!afterInsertGrievanceCaseIdSet.isEmpty()){
                    
                    ManageCaseMilestoneDatabase.caseUpdateMilestoneDate(afterInsertGrievanceCaseIdSet);
                }
            }
            
        }
        
          
         
         
         set<string> InsertedCaseIdsAR = new set<string>();
         List<case> caseListtoInsertedAR = new List<Case>();
         string assignmentRuleId = [Select Id From AssignmentRule where SobjectType = 'Case' and Active = true limit 1].Id;
            for(Case loopCase: Trigger.new) {
                /** @Description: Rel 5.3 - 3123 **/
                if(loopCase.RecordTypeId == caseRecordTypeMap.get('Employee Inquiry') 
                    || loopCase.RecordTypeId == caseRecordTypeMap.get('Human Resource Web To Case') 
                    || loopCase.RecordTypeId ==  caseRecordTypeMap.get('Human Resource Job Evaluation Form'))
                    {
                         InsertedCaseIdsAR.add(loopCase.Id);
                    }
            }
         
          for(Case InsertedCase : [Select Id from Case where Id IN :InsertedCaseIdsAR ])
                {
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.assignmentRuleId = assignmentRuleId ;
                    InsertedCase.setOptions(dmlOpts);
                    caseListtoInsertedAR.add(InsertedCase);                
                }
                
                if(!caseListtoInsertedAR.isEmpty())
                {
                   // upsert caseListtoUpdateAR;
                    Database.upsert(caseListtoInsertedAR);
                } 
}
    
    /** @Description: This section will execute if this trigger is fired due to an update operation, from the Salesforce user interface, Apex, or the API. **/
    else if(Trigger.isUpdate) {
        
        if(Trigger.isBefore) {

            //3318
            List<UserRole> shpRole = [SELECT Name FROM UserRole where id =: UserInfo.getUserRoleId() limit 1];
            Profile shpProfile = [Select Name from Profile where Id =: UserInfo.getProfileId() limit 1];
            
            /** @Description: Capturing a list of the new versions of the Case records by iterating Trigger.New and storing in list variable of Case type **/
            for(Case loopCase: Trigger.new) {  
               
             
            //Req:3708 This Condition checks that the other agents of specific Role can edit Urgency and Priority fields of case, based on specific recordtype.                   
             if((loopCase.OwnerId <> UserInfo.getUserId()) && !AP01_TestDataUtility.OwnerFlagManageCase ) //Check if the Current User and the case owner is not same.          
             {                                       
                 //Unlock_Cases_fields_Urgency_Priority Fieldsets contains the fields which can not be edited by other agents. 
                 List<Schema.FieldSetMember> fieldsAll = Schema.SObjectType.Case.fieldSets.Unlock_Cases_fields_Urgency_Priority.getFields();          
                   system.debug('Before if..');                  
                 if(loopCase.RecordTypeId == caseRecordTypeMap.get('Revenue Cycle') 
                     ||  loopCase.RecordTypeId == caseRecordTypeMap.get('Employee Inquiry')                   
                     ||  loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Accounts Payable')                  
                     ||  loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Payroll')                   
                     ||  loopCase.RecordTypeId == caseRecordTypeMap.get('Human Resources')           
                     ||  loopcase.RecordtypeId == caseRecordTypeMap.get('Supply Chain'))  
                            
                 {                                       
                     system.debug('Inside if..'); 
                     for(Schema.FieldSetMember s:  fieldsAll)   //For each field present in fieldSets.         
                     {                          
                         if(loopCase.get(s.FieldPath) <> trigger.oldMap.get(loopCase.id).get(s.FieldPath)) //Checking if any field of fieldSets changed.
                         {                                                                                   
                            if(String.valueOf(loopCase.OwnerId).substring(0,3) <> '00G')  //Condition If the case's owner is not queue, 'OOG' represents the queue's first 3 characters.        
                            {                                    
                             loopcase.addError(ERROR_URGENCY_PRIORITY_CHANGE,true);                      
                            }            
                            else if((String.valueOf(loopCase.OwnerId).substring(0,3) == '00G') && !AP01_TestDataUtility.OwnerFlagManageCase ) //Condition if the case's owner id queue.           
                            {                                                                
                                AP01_TestDataUtility.OwnerFlagManageCase =true;  //This variable stops trigger from Recurssion.                                        
                                loopcase.addError(ERROR_ASSIGN_CASE,true);                                                                                   
                            }            
                         }           
                     }                               
                 }           
             }                   
                                         
               /** @Description: Collision Detection Release 6.4 Changes Req 3271**/
               /** if(loopCase.OwnerId <> trigger.oldMap.get(loopCase.id).OwnerId
                 && trigger.oldMap.get(loopCase.id).OwnerId <> UserInfo.getUserId()
                 && String.valueOf(trigger.oldMap.get(loopCase.id).OwnerId).subString(0, 3) <> QUEUE_ID_PREFIX)
                    {
                    loopcase.addError(ERROR_OWNER_CHANGE,true);
 
                    break;                    
                    } **/  
                
        //3318 before update
        
        // REQ-3555: Check Executive Service flag for Executive service team profile  
                        if(shpProfile.Name == Label.CL_Executive_Service_Team          
                         && (loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Accounting')          
                         ||  loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Accounts Payable')        
                         ||  loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Payroll')          
                         ||  loopCase.RecordTypeId == caseRecordTypeMap.get('Human Resources')
                      )){          
                            loopCase.Executive_Service__c = true;          
                            if(!String.isBlank(loopCase.Executive_Calling_in_Reference_To__c)){
                                Contact c = [SELECT Id, name FROM Contact WHERE Id =: loopCase.Executive_Calling_in_Reference_To__c];
                                loopCase.Requestor_Calling_in_Reference_To__c = c.Name;
                            }
                            
                        }
                        
                        
                
                if(loopCase.RecordtypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(Label.CL43_Grievance_RT).RecordTypeId){
                    
                    if(loopCase.Date_Grievance_Requested__c <> null && loopCase.Date_Grievance_Requested__c <> trigger.oldMap.get(loopCase.Id).Date_Grievance_Requested__c
                            && String.isNotBlank(shpRole[0].Name)){
                        
                        if((shpRole[0].Name == Label.CL60_SHP_Grievance_Coordinator_Role && shpProfile.Name == Label.CL59_SHP_Agent_Profile)
                                        || shpProfile.Name == Label.CL61_SHP_Management_Profile){
                            
                            grievanceCasesUpdated.add(loopCase);
                        }
                    }
                }
                          
                if(loopCase.Case_Origin_Survey__c == null){
                    loopCase.Case_Origin_Survey__c = loopCase.Origin;
                }
    
                /** @Description:Req. 3040 Release 5.2 Changes **/    
                /** @Description:Req. 3123 Release 5.3 Changes **/    
                if(loopCase.RecordTypeId != caseRecordTypeMap.get('Internal Service Request') 
                && loopCase.RecordTypeId != caseRecordTypeMap.get('Employee Inquiry') 
                && loopCase.RecordTypeId != caseRecordTypeMap.get('Human Resource Web To Case') 
                && loopCase.RecordTypeId != caseRecordTypeMap.get('Human Resource Job Evaluation Form') )
                {  
                 if(loopCase.Function__c <> Null && loopCase.Team__c <> Null)
                    {
                        if(loopCase.Function__c <> trigger.oldMap.get(loopCase.Id).Function__c || loopCase.Team__c <> trigger.oldMap.get(loopCase.Id).Team__c )
                        {
                            if(loopCase.Function__c == 'Document Management Center')
                            {
                                loopCase.RecordTypeId = caseRecordTypeMap.get('Document Management Center');
                            }
                            else if(loopCase.Function__c == 'Finance')
                            {
                                if(loopCase.Team__c == '[Tier 3] Regional Accounting Leads' 
                                || loopCase.Team__c == '[Tier 3] JE & Balance Sheet Recons'
                                || loopCase.Team__c == '[Tier 3] Cash Accounting'
                                || loopCase.Team__c == '[Tier 3] Fixed Assets'
                                || loopCase.Team__c == '[Tier 3] Accounts Receivable'
                                || loopCase.Team__c == '[Tier 3] Managed Care'
                                || loopCase.Team__c == '[Tier 3] Financial Data & Applications'
                                || loopCase.Team__c == '[Tier 3] Reporting and Audit')
                                {
                                    loopCase.RecordTypeId = caseRecordTypeMap.get('Finance Accounting');
                                }
                                else if(loopCase.Team__c == '[Tier 1] AP / Purchasing / Supply Chain' 
                                || loopCase.Team__c == '[Tier 2] Finance Accounts Payable'
                                || loopCase.Team__c == '[Tier 3] Invoice & Payment Processing'
                                || loopCase.Team__c == '[Tier 3] Exception Resolution'
                                || loopCase.Team__c == '[Tier 3] Physician Contract Team')
                                {
                                    loopCase.RecordTypeId = caseRecordTypeMap.get('Finance Accounts Payable');
                                }
                                else if(loopCase.Team__c == '[Tier 2] Finance Payroll / T&E' 
                                || loopCase.Team__c == '[Tier 1] Payroll T&E / Compensation'
                                || loopCase.Team__c == '[Tier 3] Payroll Review'
                                || loopCase.Team__c == '[Tier 3] Compensation'
                                /** @Description:Req. 3190 Release 6.3 Changes Date : 11/03/2014**/
                                || loopCase.Team__c == '[Tier 3] Payroll Upload'  
                                || loopCase.Team__c == '[Tier 3] Payroll Absence Plans'
                                || loopCase.Team__c == '[Tier 3] Payroll Accounting and Banking'
                                || loopCase.Team__c == '[Tier 3] Payroll Deductions'
                                || loopCase.Team__c == '[Tier 3] Payroll Leave Processing'
                                || loopCase.Team__c == '[Tier 3] Payroll Taxes')
                                /** @Description:Req. 3190 Release 6.3 Changes Date : 11/03/2014**/
                                {
                                    loopCase.RecordTypeId = caseRecordTypeMap.get('Finance Payroll');
                                }
                            }
                            else if(loopCase.Function__c == 'Human Resource')
                            {
                            if(loopCase.Function__c == 'Human Resource' 
                            && loopCase.Customer_Intent__c == 'HR Reporting'
                            && loopCase.Team__c == '[Tier 3] HR Reporting'
                            && loopCase.Customer_Sub_Intents__c == 'Adhoc Report Request Web')
                            {
                              //   loopCase.RecordTypeId = caseRecordTypeMap.get('Human Resources Adhoc Reports');
                             //    Req 3193 Release 6.3 Changes 
                          
                                   loopCase.RecordTypeId = caseRecordTypeMap.get('Human Resource Web To Case');
                            }
                            else if(loopCase.Function__c == 'Human Resource' 
                            && loopCase.Customer_Intent__c == 'Employee Compensation'
                            && loopCase.Team__c == '[Tier 3] Compensation'
                            && loopCase.Customer_Sub_Intents__c == 'Job Evaluation' && loopCase.origin =='Web')
                            {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('Human Resource Job Evaluation Form');
                            }
                            else if(loopCase.Function__c == 'Human Resource')
                            {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('Human Resources');
                            }
                            }
                            else if(loopCase.Function__c == 'Revenue Cycle')
                            {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('Revenue Cycle');
                            }
                            else if(loopCase.Function__c == 'Supply Chain')
                            {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('Supply Chain');
                            }
                            
                        }
                    }
                }
           
                    
                
                /** @Description:Req. 3122 Release 5.3 Changes Date : 7/8/2014**/
                if(loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Accounts Payable') || 
                    loopCase.RecordTypeId == caseRecordTypeMap.get('Finance Payroll') || 
                    loopCase.RecordTypeId == caseRecordTypeMap.get('Human Resources') ||
                    loopCase.RecordTypeId == caseRecordTypeMap.get('Revenue Cycle')||
                    /** @Description:Req. 3402 Updated call back value with default value Date : 9/14/2015**/
                    loopCase.RecordTypeId == caseRecordTypeMap.get('Supply Chain'))
                    {
                        
                        loopCase.Call_Back__c= loopCase.Call_Back_defaut_true__c;                       
                    }
                 
                /** @Description:Req. 3122 Release 5.3 Changes  Date : 7/8/2014**/
                /** @Description: Add iterated Case variable to Case list updateCase **/
                updateCases.add(loopCase); 
                
                //3087
                // milestoneUpdateCases.add(loopCase);      
                
                /** 
                *    @Description: Condition to check if the secondary reason's old value was 'Expedited' or the new value is 'Expedited'.
                **/
              if((trigger.newMap.get(loopCase.id).Secondary_Reason__c == Label.CL42_Grievance_Expedited) || (trigger.OldMap.get(loopCase.id).Secondary_Reason__c == Label.CL42_Grievance_Expedited) 
               || (trigger.newMap.get(loopCase.id).Secondary_Reason__c == 'Routine') 
               || (trigger.OldMap.get(loopCase.id).Secondary_Reason__c == 'Routine') )
                {
                    
                    /** @Description: Condition to check if secondary reason field's value has been changed and recordtype is 'Grievance' **/
                    if((loopCase.Secondary_Reason__c <> trigger.OldMap.get(loopCase.id).Secondary_Reason__c) && loopCase.recordTypeId == caseRecordTypeMap.get(Label.CL43_Grievance_RT))
                    {
                      
                        /** @Description: Add the case to the milestoneUpdateCases list **/
                        milestoneUpdateCases.add(loopCase);
                    }
                }
                
                if(loopCase.Status == Label.CL05_Closed)
                {
                    if(loopCase.Status == Label.CL05_Closed)
                    {
                        if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Address Change Request'))
                        {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Address Change Request RO');
                        }
                        if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Affiliate Data Change Request'))
                        {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Affiliate Data Change Request RO');
                        }
                        if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Application Request'))
                        {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Application Request RO');
                        }
                        if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Data Change Request'))
                        {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Data Change Request RO');
                        }
                        if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Expirables Request'))
                        {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Expirables Request RO');
                        }
                        if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Other Request'))
                        {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Other Request RO');
                        }
                        if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Reapplication Request'))
                        {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Reapplication Request RO');
                        }
                        if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Report Request'))
                        {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Report Request RO');
                        }
                        if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Rush Application Request'))
                        {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Rush Application Request RO');
                        }
                         if(loopCase.RecordTypeId == caseRecordTypeMap.get('CV - Temporary Privilege Request'))
                        {
                            loopCase.RecordTypeId = caseRecordTypeMap.get('CV - Temporary Privilege Request RO');
                        }
                    }
                }
                
                /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
                if(loopCase.CreatedDate > Datetime.parse(Label.CL53_Case_Life_Cycle_Reporting_Start_Date))
                {
                    
                    if(loopCase.OwnerId <> trigger.oldMap.get(loopCase.id).OwnerId
                        && loopCase.Status <> trigger.oldMap.get(loopCase.id).Status)
                    {
                        oldCaseMap.put(loopCase.id, trigger.oldMap.get(loopCase.id));
                        newCaseMap.put(loopCase.id, trigger.newMap.get(loopCase.id));
                    }
                    else if(loopCase.OwnerId <> trigger.oldMap.get(loopCase.id).OwnerId)
                    {
                        oldCaseMap.put(loopCase.id, trigger.oldMap.get(loopCase.id));
                        newCaseMap.put(loopCase.id, trigger.newMap.get(loopCase.id));
                    }
                    else if(loopCase.Status <> trigger.oldMap.get(loopCase.id).Status)
                    {
                        oldCaseMap.put(loopCase.id, trigger.oldMap.get(loopCase.id));
                        newCaseMap.put(loopCase.id, trigger.newMap.get(loopCase.id));
                    }
                }
                
                /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
                
                /** @Description:Req. 3262 Release 6.2 Changes Date : 01/05/2015 START**/
                if(loopCase.RecordtypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_OOA_OON).RecordTypeId){
                    ManageCaseDatabase.groupMember();
                        
                    if(!ManageCaseDatabase.isMemberOfSHP_OOA_OON){
                    
                        if(!String.isBlank(loopCase.HR_Authorization__c)){
                        
                            loopCase.addError(HR_AUTH_ERROR);  
                        }
                        if(loopCase.DMHC_30_min__c <> null || loopCase.Date_Time_Hospital_Notified_SHP__c <> null || loopCase.Date_Time_SHP_Notified_Hospital__c <> null){
                        
                            loopCase.addError(DMHC_ERROR); 
                        }
                    }
                }
                /** @Description:Req. 3262 Release 6.2 Changes Date : 01/05/2015 END**/
                
                /** Req : 3242 **/
                if(loopCase.RecordTypeId == caseRecordTypeMap.get(System.Label.CL13_SHPInteractionLog)) {  // SHP Interaction Log
                    if(loopCase.Reason__c == System.Label.Public_Action && (loopCase.Secondary_Reason__c == System.Label.Media_Threat || 
                          loopCase.Secondary_Reason__c == System.Label.Legal_Threat) && Trigger.oldmap.get(loopCase.Id).IsMailSent__c  == loopCase.IsMailSent__c) {
                       loopCase.IsThreatEMailSent__c = true; 
                    } else {
                        loopCase.IsThreatEMailSent__c = false; 
                    }
                }
            }
            
            //3318
            if(!grievanceCasesUpdated.isEmpty()){
                
                ManageCaseMilestoneDatabase.incrementReceivedDateFrequencyCounter(grievanceCasesUpdated);
                
            }
            /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
            if(!oldCaseMap.isEmpty() && !newCaseMap.isEmpty())
            {
                ManageCaseDatabase.beforeUpdateLastOwnerCase(oldCaseMap, newCaseMap);
            }
            /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
            
            
            /** @Description: Copies a map of new value ID's of the Case records in newMap. **/
            newMap.putall(Trigger.newMap);
        
            /** @Description: Copies a map of old value ID's of the Case records in oldMap. **/
            oldMap.putall(Trigger.oldMap);
        
            /** @Description:  Null check for the List of Updated Cases**/
            if(updateCases.size() > 0) {
           
                /**
                *    @Description: This method call controls the order of execution around the 
                *      Case object when before update programatic changes are needed. 
                **/
                
                AP01_TestDataUtility.OwnerFlagManageCase=true;// This variable stops Trigger from recursion.
                
                ManageCaseDatabase.ManageBeforeUpdatedCases(updateCases, oldMap, newMap);
            }
            
            ManageCaseMilestoneDatabase.ManageCaseMilestoneBeforeUpdate(trigger.NewMap, trigger.OldMap);
            
            /** @Description: If milestoneUpdateCases list's size is greater than zero **/
            if(milestoneUpdateCases.size() > 0)
            {
                /** @Description: Call the method AssignGrievanceEntitlement passing the list of cases **/
                ManageCaseMilestoneDatabase.AssignGrievanceEntitlement(milestoneUpdateCases);
                /*REQ 3835 - To fire entitlement process */
                ManageCaseMilestoneDatabase.assignPDIEntitlement(milestoneUpdateCases);
            }
            
            /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
            if(oldCaseMap <> null)   
            {
                oldCaseMap.clear();
            }
            if(newCaseMap <> null)   
            {
                newCaseMap.clear();
            }
            /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
            
            /** @Description:Req. 3151  Release 6.4 Changes Date : 11/25/2014**/
            map<Id,Case> caseCorrespondenceMap = new map<Id,Case>();
            set<Id> setCases = new set<Id>();   
            for(Case caseObj : Trigger.New) {
                if(caseObj.RecordTypeId != null && caseRecordTypeNameMap != Null && 
                    (caseRecordTypeNameMap.get(caseObj.RecordTypeId) == Label.Correspondence_RT || 
                    caseRecordTypeNameMap.get(caseObj.RecordTypeId) == Label.Correspondence_RO_RT) 
                    && caseObj.status == System.Label.CL05_Closed) { //&&Trigger.oldMap.get(caseObj.id).Status != caseObj.status
                    setCases.add(caseObj.id);
                }
                
            }
            caseCorrespondenceMap = new map<Id,Case>([select Id,(select status__c from Correspondences__r where status__c != :System.Label.CL05_Closed limit 1) 
                                                        from Case where Id IN : setCases]);
            for(Case caseObj : Trigger.New) {
                if(caseObj.RecordTypeId != null && caseRecordTypeNameMap != Null && 
                    (caseRecordTypeNameMap.get(caseObj.RecordTypeId) == Label.Correspondence_RT || 
                        caseRecordTypeNameMap.get(caseObj.RecordTypeId) == Label.Correspondence_RO_RT)&& caseObj.status == Label.CL05_Closed &&
                    caseCorrespondenceMap != null && caseCorrespondenceMap.get(caseObj.id) !=null
                    && caseCorrespondenceMap.get(caseObj.id).Correspondences__r !=null && caseCorrespondenceMap.get(caseObj.id).Correspondences__r.size()>0) {
                    caseObj.addError(Label.Correspondence_Closed_Msg);
                }
            }                                            
            /***@Description:Req. 3151  Release 6.4 Changes Date : 11/25/2014***/
        }
        
        if(Trigger.isAfter)
        {
            ManageCaseMilestoneDatabase.ManageCaseMilestoneAfterUpdate(trigger.NewMap, trigger.OldMap);
            
            if(!ManageExecutions.isSameCaseUpdate)
            {
                
                set<string> updatedCaseIds = new set<string>();
                string assignmentRuleId = [Select Id From AssignmentRule where SobjectType = 'Case' and Active = true limit 1].Id;
                Set<Id> caseIds = new Set<Id>();
                Set<Id> contactIds=new Set<Id>();          
                boolean flag=true;
                for(Case objCase : Trigger.new)
                {
                     caseIds.add(objCase.Id);
                     contactIds.add(objCase.Member_Id_Contact__c);
                }
                map<Id,Contact> mapContact=new map<Id,Contact>([Select Id,Name from Contact where Id in : contactIds ]);
                list<Member_Enquiries__c> lstMemberEnquiries = new list<Member_Enquiries__c>([SELECT Id,Case__c,Member_Id__c FROM Member_Enquiries__c where Case__c in:caseIds]);
                List<case> caseListtoUpdate = new List<Case>();
                            
                for(Case loopCase:trigger.new)
                {
                    
                    if(loopCase.Function__c <> null && loopCase.Team__c <> null)
                    {
                        if((loopCase.Function__c <> trigger.oldMap.get(loopCase.Id).Function__c || loopCase.Team__c <> trigger.oldMap.get(loopCase.Id).Team__c) 
                        && loopCase.Status <> 'Closed')
                        {
                            updatedCaseIds.add(loopCase.Id);
                        }
                    }
                    
                    /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 START**/
                    if(loopCase.RecordtypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_OOA_OON).RecordTypeId 
                                && loopCase.ED_Type__c <> null && trigger.oldmap.get(loopCase.id).ED_Type__c == null ){
                            
                        updatedCaseIds.add(loopCase.Id);
                    }
                    /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 START**/
                    
                    /** @Description: Inserting the Member Inquiry record if the Record Types are Benefits,Billing,Complaint,Documentation,Eligibility,Enrollment,Non-SHP Contact,Claim Review,Grievance,Provider Dispute and MemberId is not null and Member Id has been changed.**/
                     if(loopCase.RecordTypeId == caseRecordTypeMap.get('Benefits') || loopCase.RecordTypeId == caseRecordTypeMap.get('Billing')
                      || loopCase.RecordTypeId == caseRecordTypeMap.get('Complaint') 
                      || loopCase.RecordTypeId == caseRecordTypeMap.get('Documentation') 
                      || loopCase.RecordTypeId == caseRecordTypeMap.get('Eligibility') || loopCase.RecordTypeId == caseRecordTypeMap.get('Enrollment')
                      || loopCase.RecordTypeId == caseRecordTypeMap.get('Non-SHP Contact')
                      || loopCase.RecordTypeId == caseRecordTypeMap.get('Claim Review') || loopCase.RecordTypeId == caseRecordTypeMap.get('Grievance')
                      || loopCase.RecordTypeId == caseRecordTypeMap.get('Provider Dispute') )
                      {
                      
                          if(loopCase.Member_Id_Contact__c != Null) 
                          { 
                            if(loopCase.Member_Id_Contact__c <> trigger.oldMap.get(loopCase.Id).Member_Id_Contact__c)
                            {       
                                   
                                for(Member_Enquiries__c objMemberEnquiries :lstMemberEnquiries)
                                {
                                    if(objMemberEnquiries.Member_Id__c == loopCase.Member_Id_Contact__c)
                                    {
                                        loopCase.Member_Id_Contact__c.addError('There is already a record with the same Case Id and Member Id.') ;
                                    
                                    }   
                                    flag=false;
                                } 
                                if(flag)
                                {                                   
                                    
                                    Member_Enquiries__c objMemberEnquiry = new Member_Enquiries__c();
                                    //objMemberEnquiry.Name=mapContact.get(loopCase.Member_Id_Contact__c).Name;
                                    objMemberEnquiry.Case__c = loopCase.Id;
                                    objMemberEnquiry.Member_Id__c = loopCase.Member_Id_Contact__c;
                                    objMemberEnquiry.Intent__c = caseRecordTypeNameMap.get(loopCase.RecordTypeId);
                                    afterUpdateMemberInquiries.add(objMemberEnquiry);
                                }
                            }                           
                        }
                    }
                    
                    /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
                    if(loopCase.CreatedDate > Datetime.parse(Label.CL53_Case_Life_Cycle_Reporting_Start_Date))
                    {
                        if(loopCase.OwnerId <> trigger.oldMap.get(loopCase.id).OwnerId
                            && loopCase.Status <> trigger.oldMap.get(loopCase.id).Status)
                        {
                            oldCaseMap.put(loopCase.id, trigger.oldMap.get(loopCase.id));
                            newCaseMap.put(loopCase.id, trigger.newMap.get(loopCase.id));
                        }
                        else if(loopCase.OwnerId <> trigger.oldMap.get(loopCase.id).OwnerId)
                        {
                            oldCaseMap.put(loopCase.id, trigger.oldMap.get(loopCase.id));
                            newCaseMap.put(loopCase.id, trigger.newMap.get(loopCase.id));
                        }
                        else if(loopCase.Status <> trigger.oldMap.get(loopCase.id).Status)
                        {
                            oldCaseMap.put(loopCase.id, trigger.oldMap.get(loopCase.id));
                            newCaseMap.put(loopCase.id, trigger.newMap.get(loopCase.id));
                        }
                    }
                    /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
                    
                    /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 START**/
                    if(loopCase.RecordtypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_OOA_OON).RecordTypeId
                                        && loopCase.Secondary_Reason__c <> trigger.oldMap.get(loopCase.id).Secondary_Reason__c)
                    {
                        OOA_OON_SRList.add(loopCase);
                    }
                    
                    if(loopCase.RecordtypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(CASE_RT_OOA_OON).RecordTypeId
                                && loopCase.Member_Name_OOA_OON__c <> trigger.oldMap.get(loopCase.id).Member_Name_OOA_OON__c)
                    {
                        updateMemberFieldsSRList.add(loopCase);
                    }
                    /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 END**/
                    
                    //3318
                    if(loopCase.RecordtypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(Label.CL43_Grievance_RT).RecordTypeId){
                        if(loopCase.Date_Grievance_Requested__c <> trigger.oldMap.get(loopCase.Id).Date_Grievance_Requested__c
                                    || loopCase.Secondary_Reason__c <> trigger.oldMap.get(loopCase.Id).Secondary_Reason__c
                                    || loopCase.Reason__c <> trigger.oldMap.get(loopCase.Id).Reason__c
                                    || loopCase.Request_Clinical_Records__c <> trigger.oldMap.get(loopCase.Id).Request_Clinical_Records__c){
                            
                            afterUpdateGrievanceCases.add(loopCase);
                        }
                    }
                }
                
                //3318
                if(!afterUpdateGrievanceCases.isEmpty()){
                    
                    for(Case updateCase : afterUpdateGrievanceCases){
                        
                        afterUpdateGrievanceCaseIdSet.add(updateCase.Id);
                    }
                    if(!afterUpdateGrievanceCaseIdSet.isEmpty()){
                        
                        ManageCaseMilestoneDatabase.caseUpdateMilestoneDate(afterUpdateGrievanceCaseIdSet);
                    }
                }
                
                /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
                if(!oldCaseMap.isEmpty() && !newCaseMap.isEmpty())
                {
                    
                    ManageCaseDatabase.afterUpdateStatusDurationRecordInsert(oldCaseMap, newCaseMap);
                }
                
                /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015**/
                if(!OOA_OON_SRList.isEmpty())
                {
                    ManageCaseDatabase.updateOOA_OON_InteractionLog(OOA_OON_SRList); 
                }
                if(!updateMemberFieldsSRList.isEmpty()){
                    
                    ManageCaseDatabase.updateMemberFieldsSR(updateMemberFieldsSRList);
                }
                /** @Description:Req. 3262 Release 7 Changes Date : 01/02/2015 END**/
                
                /** @Description:Req. 3048 Release 6.2 Changes Date : 9/30/2014**/
                
                for(Case updatedCase : [Select Id,isFiredAcceptButton__c from Case where Id IN :updatedCaseIds])
                {
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.assignmentRuleId = assignmentRuleId ;
                    updatedCase.setOptions(dmlOpts);
                    /** @Description:Req. 3248 Release 6.4 Changes Date : 11/20/2014 START**/
                    updatedCase.isFiredAcceptButton__c = false;
                    /** @Description:Req. 3248 Release 6.4 Changes Date : 11/20/2014 END**/
           
                    caseListtoUpdate.add(updatedCase);
                }
                
                if(!caseListtoUpdate.isEmpty())
                {
                    update caseListtoUpdate;
                }
                if(afterUpdateMemberInquiries.size() > 0) {
            
                /**  @Description: This method will insert the new version of Case whose record after the insert is preformed.
                *     
                **/
                    
                    ManageCaseDatabase.ManageAfterInsertedUpdatedMemberInquiries(afterUpdateMemberInquiries);
                }
                ManageExecutions.setSameCaseUpdate();
            }
        }
    }
    }
    if(Trigger.isInsert || Trigger.isUpdate){
       
     if(Trigger.isBefore)
        {
           ManageCaseHelpTrigger.autoPopulateFields(Trigger.New);
           /*REQ 3835 - To fire entitlement process */
           ManageCaseMilestoneDatabase.assignPDIEntitlement(milestoneUpdateCases);
        }
        for(case objCase :Trigger.new ){
            String recordTypeName = caseRecordTypeNameMap.get(objCase.recordTypeID);
            if(recordTypeName.containsIgnoreCase('SHP')){
                ManageCaseHelpTrigger.dynamicallyValidateMandatoryFieldsOnSR(Trigger.New, caseRecordTypeMap);
                
            }
        }
        
        
    /*@@ Added for Req-3835 START */       
     If(Trigger.isAfter){
         List<Case> PDICases = new List<Case>();
           for(case objCase :Trigger.new ){
            if(caseRecordTypeNameMap.get(objCase.recordTypeID).contains('Provider Directory Inaccuracy')){
            PDICases.add(objCase);
            
            }
         }
         if(!PDICases.isEmpty())
         {
             ManageCaseUpdate.closePDICaseMilestones(PDICases);
          }
        }
    /*@@ Added for Req-3835 END*/  
    
    } 
}