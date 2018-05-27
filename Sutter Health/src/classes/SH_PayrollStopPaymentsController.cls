public without sharing class SH_PayrollStopPaymentsController extends SH_BaseController{
  
  public Case caseObj {get;set;}
  public WREmployeeInformation wrEmployeeObj {get;set;}
  public boolean isCaseCreated {get;set;}
  
  public SH_PayrollStopPaymentsController(ApexPages.standardController controller) 
  {
     BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
     activePgName = 'Service Request';
     setBreadCrumbs();        
     BreadCrumbs.add(new SH_BreadCrumb('Service Request' , '#'));
     //added on 21-Sep-2015 by Saasfocus to redirect on last visited link 
    strCancelLink = SH_Common.CancelForm(BreadCrumbs) ;
         
    caseObj = new Case();
    isCaseCreated = false;
    wrEmployeeObj = new WREmployeeInformation();
    if(controller.getId() != null) {
      caseObj = [select Payment_Number__c, Payment_Date__c, Net_Amount__c, Contact_Phone_Number__c,Comments__c,CaseNumber from Case where Id= :controller.getId()];
      isCaseCreated = true;
      if(caseObj.Payment_Date__c !=null) {
        wrEmployeeObj.paymentDate =  caseObj.Payment_Date__c.format();
      }
    }
    List<User> userInfoLst = [select contact.Employee_ID__c,contact.Name,contact.phone,contact.MailingStreet,contact.MailingState,contact.MailingPostalCode,contact.MailingCountry,contact.MailingCity 
                    from User where Id =:UserInfo.getUserId()];
    if(userInfoLst != null && userInfoLst.size()>0) {
      wrEmployeeObj.employeeName = userInfoLst[0].contact.Name;
      wrEmployeeObj.employeeNumber = userInfoLst[0].contact.Employee_ID__c;
      wrEmployeeObj.employeeContactNumber = userInfoLst[0].contact.phone;
      if(userInfoLst[0].contact.MailingStreet != null) {
        string[] addressArr = userInfoLst[0].contact.MailingStreet.split(',',2);
        if(addressArr.size()>1) {
          wrEmployeeObj.employeeAdd2 = addressArr[1];
        }
        wrEmployeeObj.employeeAdd1 = addressArr[0];
      }
      wrEmployeeObj.employeeCity = userInfoLst[0].contact.MailingCity;
      wrEmployeeObj.employeeState = userInfoLst[0].contact.MailingState;
      wrEmployeeObj.employeeZipCode = userInfoLst[0].contact.MailingPostalCode;
    }
  }
  
  public class WREmployeeInformation {
    public string paymentDate{get;set;}
    public string employeeName {get;set;}
    public string employeeNumber {get;set;}
    public string employeeContactNumber {get;set;}
    public string employeeAdd1 {get;set;}
    public string employeeAdd2 {get;set;}
    public string employeeCity {get;set;}
    public string employeeState {get;set;}
    public string employeeZipCode {get;set;}
  }
  
  public PageReference submitCase() {
    try {
      caseObj.recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Finance Payroll').getRecordTypeId();
      caseObj.team__c = '[Tier 3] Payroll Accounting and Banking';
      caseObj.customer_intent__c = 'Pay Inquiry';
      caseObj.Customer_Sub_Intents__c = 'Missing Check';
      caseObj.subject = 'Finance Payroll SR: Stop Payment';
      caseObj.sub_function__c = 'Payroll/T&E';
      caseObj.description  = caseObj.Comments__c;
      caseObj.Internal_Comments__c = caseObj.Comments__c;
      caseObj.origin = 'Web';
      caseObj.Section_View__c = 'Payroll Stop Payment';
        string assignmentRuleId = [Select Id From AssignmentRule where SobjectType = 'Case' and Active = true limit 1].Id;
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId = assignmentRuleId;
            caseObj.setOptions(dmlOpts);
            
            //Added by sutterhealth salesforce support team as part of REQ 3708 to prevent case trigger recursiveness.
            AP01_TestDataUtility.OwnerFlagManageCase = true; 
            
            Database.upsert(caseObj);    
            
            
      PageReference pfRef = new PageReference('/apex/SH_PayrollStopPayments');
      
      //added on 22-Sep-2015 by SaasFocus to set Params
      pfRef.getParameters().put('id', caseObj.id);
      SH_Common.setFormUrlParams(pfRef);
      pfRef.setRedirect(true);
      return pfRef;
      //commented on 30-Sep-2015 on Sutter Request
      /*
        pfRef = Page.SH_Help_Support;
        pfRef.getParameters().put('Id',  caseObj.Id);
        pfRef.setRedirect(true);
        
        SH_Common.setFormUrlParams(pfRef);
        
        return pfRef; 
        */
                
    } catch(Exception ex) {
        //added by SaasFocus on 22-Sep-2015 for showing error message
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
    }
    return null;
  }
  
  public PageReference cancel() {
    PageReference pfRef = new PageReference('/SRMainPage');
    SH_Common.setFormUrlParams(pfRef);
    pfRef.setRedirect(true);
    return pfRef;
  }
  
  public PageReference newStopPayment() {
    PageReference pfRef = new PageReference('/apex/SH_PayrollStopPayments');
    //added on 22-Sep-2015 by SaasFocus to set Params
    SH_Common.setFormUrlParams(pfRef);
    pfRef.setRedirect(true);
    return pfRef;
  }
}