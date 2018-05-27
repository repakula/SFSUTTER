/**  
*    Class Name: EmailToCaseNotificationController
*    Author: Offshore IDC
*    Date: 12-Nov-2015
*    Description: This component works as controller for Email to case notification service console component.
*    
*    History
*    VERSION    AUTHOR              DATE         DETAIL  Description
*    1.1        Offshore IDC        12-Nov-2015  This component works as controller for Email to case notification service console component - REQ - 3139 
*    1.2        Offshore IDC        04-Feb-2016  Added condition for Supply Chain record type.
*    1.3        Mohan Pindi         06-Jan-2016  Added condition to cover Req-3213 Email-to-Case for Finance Payroll 
*   --------
**/
public with sharing class EmailToCaseNotificationController {

    //Static variables
    public Set<Case> setCases; //To get set of cases
    private ApexPages.StandardSetController setCon; // StandardSetController for pagination 
    public List <case> lstCases;
    public List <WrCase> wrCaseLst {
        get;
        set;
    }
    // To get total number of records
    public Integer recordCount {  
        get;
        set;
    }
    
    /*******************************************************************
    Purpose: Method to get list of cases with new email message.
    Parameters: [NA]
    Returns: [List of WrCase]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public List <WrCase> getListCases() {
        List<WrCase> lstTmpCases = new List<WrCase>();
        map < id, List < EmailMessage >> mapCaseEmailMsgsLst = new Map < id, List < EmailMessage >> ();
        Set<id> setCasesIds = new Set<Id>();
        if (setCon != NULL) {
            List < Case > lstCase = (List < Case > ) setCon.getRecords();
            if (!lstCase.isEmpty()) {
                for (case objCa : lstCase) {
                    setCasesIds.add(objCa.id);
                }
                for (EmailMessage objEmailMsg: [select id, Status, Parentid, FromAddress from EmailMessage where status = '0' AND Parentid in : setCasesIds order by CreatedDate DESC limit 1000]) {
                    if (mapCaseEmailMsgsLst.get(objEmailMsg.parentid) == null)
                        mapCaseEmailMsgsLst.put(objEmailMsg.parentid, new List < EmailMessage > {
                            objEmailMsg
                        });
                    else
                        mapCaseEmailMsgsLst.get(objEmailMsg.parentid).add(objEmailMsg);
                }

                for (Case obj: lstCase) {
                    List<EmailMessage> lstEmailMsgs = mapCaseEmailMsgsLst.get(obj.id);
                    if (lstEmailMsgs != null && !lstEmailMsgs.isEmpty() && recordCount > 0) {
                        WrCase objWrap = new WrCase(obj, lstEmailMsgs[0].FromAddress);
                        lstTmpCases.add(objWrap);
                    }
                }
            }
        }
        return lstTmpCases;
    }
   
    /*******************************************************************
    Purpose: Method to check whether previous page exists or not
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public Boolean getHasPrevious() {
        // Checks whether previous page exists or not
        if (setCon != null)
            return this.setCon.getHasPrevious(); 
        else
            return false;
    }

    /*******************************************************************
    Purpose: Method set "setCon" reference to the previous page 
    Parameters: [NA]
    Returns: [Pagereference]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public Pagereference doPrevious() {
        // set "setCon" reference to the previous page
        if (this.setCon.getHasPrevious()) {
            this.setCon.previous();
        }
        return null;
    }
        
    /*******************************************************************
    Purpose: Method set "setCon" reference to the next page 
    Parameters: [NA]
    Returns: [Pagereference]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public Pagereference doNext() {
        //set "setCon" reference to the next page
        if (this.setCon.getHasNext()) {
            this.setCon.next();
        }
        return null;
    }
    
    /*******************************************************************
    Purpose: Method to check whether next page exists or not
    Parameters: [NA]
    Returns: [Boolean]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    public Boolean getHasNext() {
        if (setCon != null)
            return this.setCon.getHasNext();
        else
            return false;
    }

   /*******************************************************************
    Purpose: Method set "setCon" reference to first page 
    Parameters: [NA]
    Returns: [Pagereference]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public Pagereference doFirst() {
        // Sets "setCon" reference to first page 
        this.setCon.first();
        return null;
    }

    /*******************************************************************
    Purpose: Method returns the Page Number
    Parameters: [NA]
    Returns: [Integer]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public Integer getPageNumber() {
        // Get Current Page Number 
        return this.setCon.getPageNumber();

    }

    /*******************************************************************
    Purpose: Method returns the total number of pages
    Parameters: [NA]
    Returns: [Integer]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public Integer getTotalPages() {
        if (setcon != null) {
            // Get Result Size
            Decimal totalSize = this.setCon.getResultSize();
            // Get Page Size
            Decimal pageSize = this.setCon.getPageSize();
            // Get Total Number of pages
            Decimal pages = totalSize / pageSize;
            return (Integer) pages.round(System.RoundingMode.CEILING);
        } else
            return 0;
    }

    /*******************************************************************
    Purpose: Method sets "setCon" object reference the Last page  
    Parameters: [NA]
    Returns: [Pagereference]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public Pagereference doLast() {
        // Set "setCon" object reference the Last page
        this.setCon.last();
        return null;
    }
    
    // Wrapper Class: To wrap CaseId, CaseNumber and From Address in single container.
    public class WrCase {
        public id caseId {
            get;
            set;
        }
        public string strCaseNumber {
            get;
            set;
        }
        public string FromAddress {
            get;
            set;
        }
        // Intializing the members inside the constructor
        public WrCase(Case objCase, String str) {
            this.caseId = objCase.id;
            this.strCaseNumber = objCase.CaseNumber;
            this.FromAddress = str;
        }
    }
  
    /*******************************************************************
    Purpose: Constructor  
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public EmailToCaseNotificationController() {
        lstCases = new List <case>();
        setCases = new Set < Case > ();
        wrCaseLst = new List < WrCase > ();
        callMethod();
        recordCount = wrCaseLst.size();
    }
    
    /*******************************************************************
    Purpose: Get List of "Email to Case" cases with new email message which is assigned to logged-in User.  
    Parameters: [NA]
    Returns: [Void]
    Throws [Exceptions]: [NA]
    ********************************************************************/ 
    public void callMethod() {
        map < id, List < EmailMessage >> mapCaseEmailMsgsLst = new Map < id, List < EmailMessage >> ();
        //Get Record Type Id of "Finance Account Payable" record type.
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.E2C_Recordtype).getRecordTypeId();
        // REQ-3213 Get Record Type Id of "Finance Payroll" record type.
        Id caseFinancePayrollRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.S3_Finance_Payroll_Record_type).getRecordTypeId();
        Id caseSCRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.SC_RecordType).getRecordTypeId();
        lstCases = new List < case >();
        setCases = new Set < Case > ();
        wrCaseLst = new List < WrCase > ();
        list < id > caselist = new list < id > ();
        list < id > caselistowned = new list < id > ();
        // Get Current User Id
        String strOwner = Userinfo.getuserid();
        
        // Query Case to get list of Email Messages  
        for(Case objCase : [select id, ownerid, casenumber,Origin, Status,(select id, Status, Parentid, FromAddress from EmailMessages where status = '0'
                                and (toaddress =: System.Label.EmailToCaseId OR toaddress =: System.Label.FinancePayroll_Email_to_Case_Id) order by CreatedDate DESC limit 1000) from Case 
                                where (recordtypeid  =: caseRecordTypeId OR recordtypeid = : caseSCRecordTypeId OR recordtypeid  =: caseFinancePayrollRecordTypeId) AND ownerid = : strOwner and (Origin = 'Email' OR Origin = 'Email to Case')
                                and Status != 'Closed' Order by CreatedDate DESC limit 300]) {
            if(objCase.EmailMessages != NULL) {
                // Loop on Email Message Records
                for(EmailMessage objEmailMg:objCase.EmailMessages) {                        
                    WrCase wrcaseObj = new WrCase(objCase, objEmailMg.FromAddress);
                    wrCaseLst.add(wrcaseObj);
                    setCases.add(objCase);
                }
            }
        }
        // Initializing Case List
        lstCases = new List <Case>(setCases);
        if(lstCases <> null && !lstCases.isEmpty()) {
            //Initializing StandardSet Contoller 
            this.setCon = new ApexPages.StandardSetController(lstCases);
            this.setCon.setpageNumber(1);
            // Set Page Size to 10 records
            this.setCon.setPageSize(10); 
        }
        recordCount = wrCaseLst.size();
    }
}