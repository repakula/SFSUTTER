public class SubmitCaseController {
        
   
    public Case c { get; set; }  
    public string acctNum {get; set;}
    public string TestFinalCaseNumber{get; set;}   
    public string EmployeeNumber{get; set;} 
    public string EmployeeManager{get; set;}  
    public boolean submited{get; set;} 
    public String status { get; set; }
    public blob cfile { get; set; }    
    public boolean rer{ get; set; }  
    public List<TimeCard__c> tc; 
    public List<TimeCard__c> tcr; 
    public boolean saveflag1 ; 
    public id contactold; 
    public string EmployeeName {get; set;}  
    public id conid;
    public string CaseNumber{get; set;}
    public String rType = '';//3206
     
    
    
    public SubmitCaseController(ApexPages.StandardController stdController) {
         
         RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Finance Payroll']; 
         if(stdController.getRecord().Id == null)
         {
             this.c = new Case();
             c.RecordTypeId = rt.id;
           
         }
         else
         {
             this.c=[SELECT Id, Function__c,OwnerId,Requestor_Name__c,Requestor_Type__c , Sub_Function__c,PayRoll_Type_of_Pay__c,DisClaimerCheck__c,Cust_Employee_Number__c,Reason_Payroll__c,contactid,CusContactName__c,Prior_Period_Adjustment__c,Cust_Manager_Name__c,Effective_Pay_period__c,Amount__c,Comments__c,Description,CaseNumber FROM Case WHERE Id=:stdController.getRecord().Id];
         }
         
          rType = ApexPages.currentPage().getParameters().get('RT');//3206
    }
 
    
    public SubmitCaseController() {
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Finance Payroll']; 
        this.c = new Case();   
        c.RecordTypeId = rt.id;
    }
        
    
    public PageReference submitCase() {

         
         if(rType == 'Additional Pay Request'){
         
            c.Prior_Period_Adjustment__c = 'Additional Pay Request';
         
         }
         
         else{
            c.Prior_Period_Adjustment__c = 'Payroll Adjustment';
         }
         
        if((c.CusContactName__c != null) && (c.Prior_Period_Adjustment__c != null) && (c.Effective_Pay_period__c != null) && (c.Comments__c != null)  ){          
         if(((c.Prior_Period_Adjustment__c == 'Payroll Adjustment') && (c.Reason_Payroll__c != null))
            || ((c.Prior_Period_Adjustment__c == 'Additional Pay Request') && (c.PayRoll_Type_of_Pay__c != null) && (c.Amount__c != null))){
         c.Origin='Web';   
         c.Section_View__c = 'Payroll';
         c.Internal_Comments__c = c.Comments__c;            
         RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Finance Payroll'];
         c.RecordTypeId = rt.id;
         c.Function__c = 'Finance';
         c.Sub_Function__c = 'Payroll/T&E';             
         c.Team__c='[Tier 3] Payroll Review';
         c.Subject = 'Finance Payroll SR : '+c.Prior_Period_Adjustment__c ;
         /** @Description:Req. 3117 Release 5.3 Changes Date : 7/22/2014**/ 
         c.Call_Back_defaut_true__c = false;  
         
         
         if (c.Prior_Period_Adjustment__c == 'Payroll Adjustment'){
            //c.Customer_Intent__c = 'Manager Payroll or Paycheck Inquiry';
            c.Customer_Intent__c = 'Pay Inquiry';
            c.Customer_Sub_Intents__c = 'Missing Pay'; 
         }
         else{
            c.Customer_Intent__c = 'Additional Pay';
         }               
          
           try {
                 //Fetching the assignment rules on case
                 AssignmentRule AR = new AssignmentRule();
                 AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                 Database.DMLOptions dmlOpts = new Database.DMLOptions();
                 dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                 c.setOptions(dmlOpts);             
                 insert c;   
                 InsertTimecard();
                  
               } catch (DMLException e) {
               
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Raise a new case'));
               } finally {
               
               }                

              upload();         
              
                //3206
                PageReference p;
                if(rType == 'Additional Pay Request'){
                    p = new PageReference('/apex/SRFinacePayrollDetail_AdditionalPay?Id='+c.Id+'&RT=Additional Pay Request');
                    
                }
                else{
                    p= new PageReference('/apex/SRFinacePayrollDetail?Id='+c.Id);
                }
              
              
              //3206
                      
              
              p.setRedirect(true);
              return p;
          }
         else {
          if(c.Prior_Period_Adjustment__c == null) ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Prior Period Adjustment'));      
            else if (c.Prior_Period_Adjustment__c == 'Additional Pay Request') {
                 if(c.PayRoll_Type_of_Pay__c == null ) ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Type of Pay'));
                 if(c.Amount__c == null ) ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Provide Amount'));
            }
            else if (c.Prior_Period_Adjustment__c == 'Payroll Adjustment') {
                 if(c.Reason_Payroll__c == null ) ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Reason'));
             }
           return null; 
         }     
        }
          else{
               if(c.CusContactName__c == null) ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Provide Contact Name'));
               if(c.Prior_Period_Adjustment__c == null) ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Prior Period Adjustment'));      
               if(c.Effective_Pay_period__c == null) ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Provide Effective Pay Period'));
               if(c.Comments__c == null) ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Describe the issue'));      
               return null;  
           }

    }
     public PageReference NewCase() {
    
              PageReference p= new PageReference('/apex/SRMainPage');
              p.setRedirect(true);
              return p;
    }
    
    public List<TimeCard__c> gettcr()
    {
        
       if (c.id == null)
         return null;
        tcr = [SELECT Cost_Center__c,Date__c,Id,In_Punch_Time__c,Name,Out_Punch_Time__c,PTO_HOL__c,TimeCardId__c FROM TimeCard__c WHERE TimeCardId__c=:c.Id];
        return tcr;
    }
    
    public void EmpNumandMan(){
    try{
        system.debug('@@EmployeeName : '+ EmployeeName);
            if (EmployeeName != null && EmployeeName != '')
            {
                //List<Contact> conList = [SELECT id,Employee_ID__c,Employee_Supervisor_Name__c,Name FROM Contact WHERE Name =: EmployeeName];
                system.debug('@@EmployeeName : '+ EmployeeName);
                List<Contact> conList = [SELECT id,Employee_ID__c,Employee_Supervisor_Name__c,Name FROM Contact WHERE Id =: EmployeeName];
                system.debug('@@conList : '+ conList);
                if(!conList.isEmpty())
                {
                     c.Cust_Employee_Number__c = conList[0].Employee_ID__c;
                     c.Cust_Manager_Name__c = conList[0].Employee_Supervisor_Name__c;
                }
            }
        } catch(Exception ex){
            system.debug('getMessage : ' + ex.getMessage());
        }
    }
     
  public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
  set;
  }

  public TimeCard__c TCard{
  get {
      if (TCard == null)
        TCard = new TimeCard__c();
      return TCard ;
    }
  set;
  }
 
  public attachment upload() {
    
    attachment.OwnerId = UserInfo.getUserId(); 
    attachment.ParentId = c.id; // the record the file is attached to
    attachment.IsPrivate = false;
 
    try {
      insert attachment;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
      return null;
    } finally {
      attachment = new Attachment(); 
    }
 
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
    
  return null;
  }
  
  public PageReference  InsertTimecard() {
    if ((c.id != null) ){
     boolean flag = true;    
     if ((TCard.Date__c == null) || (((TCard.In_Punch_Time__c == null) && (TCard.Out_Punch_Time__c == null)) && (TCard.PTO_HOL__c == null)) ) {
              
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide complete information on TimeCard'));
      
      flag = false;
      }
     
        if(flag == true){
              try {
                  
               TCard.TimeCardId__c = c.id;
               insert TCard;
               
              } catch (DMLException e) {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in TimeCard'));
                  return null;
                } finally {
                TCard = new TimeCard__c();
              
            }
        }
    }// if end
    else{
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please submit the case'));
    }
   return null;
  }    

}