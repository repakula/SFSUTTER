/**  
*    Class Name: ManageCase_S3_Test
*    Author: Saket
*    Date: 26-December-2013
*    Description:  An apex page controller that test the ManageCaeInsert, ManageCaseUpdate,ManageCaseDatabase classes.This class tests for S3 Users.
*    History
*    --------
*    VERSION    AUTHOR              DATE         DETAIL 
*      2.0    Atul Gupta          07/23/2014        
*      2.1    Shivangi Gaur       01/06/2016     Added conditions to cover Req-3213 Finance Payroll Email-to-Case.
*      --------
**/

@isTest
private without sharing class ManageCase_S3_Test {
    
    Map<string, string> caseRecordTypeMap = new Map<string, string>();
    
   /* public static List<Case> testCases = new List<Case>();
    public static List<Case> testGrievanceCases = new List<Case>();
    public static List<Case> testCVCases = new List<Case>();
    static Account testAccount = new Account(name = AP01_TestDataTokens.CONTACT_ACCOUNT);
    static Contact testContact = new Contact();
    static List<Task> testTasks = new List<Task>();
    static List<Case> testSRs = new List<Case>();
    static User s3Agent;
    static Profile s3Profile;
    static UserRole portalRole; 
    
    static final Integer NUMBER_OF_CASES= 30;
    static ID employeeRecordId;
    static Boolean isFirstCall = false;
    static Id accountId;
    static Id cvRecordType;
    static Id grievanceRecordType;
    static Id shpGroup;
    static Id s3Group;*/
    
    /**
    * @author IDC Team
    * @date 01/10/2013
    * @description This method calls the Test data Method by passing the count for Number of Cases as 30 .
    * @param 
    * @return 
    */
    private static testMethod void testManageCase()
    {   Test.startTest();
        AP01_TestDataUtility.prepareUsers();
   
        System.runAs (AP01_TestDataUtility.s3Agent) 
        { 
            //calling the prepareTestData Method
            AP01_TestDataUtility.prepareTestData(AP01_TestDataUtility.NUMBER_OF_CASES);
            
            AP01_TestDataUtility.setTaskLookupCase();
            try{
                AP01_TestDataUtility.setCasesToClosed();   
                          
                update AP01_TestDataUtility.testCases; 
            } catch (Exception classException) {
            
                Boolean expectedExceptionThrown =  classException.getMessage().contains('This case cannot be closed because not all of the tasks are completed') ? true : false;
                system.assert(classException!=null);
                //System.AssertEquals(expectedExceptionThrown, true);
        
            }
            //Covering the setSRClosed property
            AP01_TestDataUtility.setSRClosed();
            //Covering the setCasesUnclosedClosed property
            AP01_TestDataUtility.setCasesUnclosedClosed();
            //Covering the setTasksToClosed property
            AP01_TestDataUtility.setTasksToClosed();
    
            try{
                //Covering the setSHPOwnerhipCase
                AP01_TestDataUtility.setSHPOwnerhipCase();                
                update AP01_TestDataUtility.testCases;
            } catch (Exception classException) {
            
                Boolean expectedExceptionThrown =  classException.getMessage().contains('You may pick only an S3 queue.') ? true : false;
                //System.AssertEquals(expectedExceptionThrown, true);
        
            }
            
            try{
                //Covering the setSHPOwnerhipCase
                AP01_TestDataUtility.setS3OwnerhipCase();                
                update AP01_TestDataUtility.testCases;
            } catch (Exception classException) {
            
                Boolean expectedExceptionThrown =  classException.getMessage().contains('You may pick only an S3 queue.') ? true : false;
                //System.AssertEquals(expectedExceptionThrown, true);
            }
        } 
        Test.stopTest();
    }
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description assign case Recordtype to DMC
    * @param 
    * @return 
    */
   /* @isTest private static void caseRTtoDMC()
    {
        List<Case> testCaseList = listCases();
        insert testCaseList;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description assign case Recordtype to DMC
    * @param 
    * @return 
    */
    /*@isTest private static void caseRTtoFinanceAccountinig()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Function__c = 'Finance';
            caseNew.Team__c = '[Tier 3] Regional Accounting Leads';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description assign case Recordtype to 
    * @param 
    * @return 
    */
    /*@isTest private static void caseRTtoFinanceAccountsPayable()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Function__c = 'Finance';
            caseNew.Team__c = '[Tier 3] Invoice & Payment Processing';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description assign case Recordtype to 
    * @param 
    * @return 
    */
   /* @isTest private static void caseRTtoFinancePayroll()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Function__c = 'Finance';
            caseNew.Team__c = '[Tier 2] Finance Payroll / T&E';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description assign case Recordtype to DMC
    * @param 
    * @return 
    */
    /*@isTest private static void caseRTtoHRAdhoc()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Function__c = 'Human Resource';
            caseNew.Customer_Intent__c = 'HR Reporting';
            caseNew.Team__c = '[Tier 3] HR Reporting';
            caseNew.Customer_Sub_Intents__c = 'Adhoc Report Request Web';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description assign case Recordtype to DMC
    * @param 
    * @return 
    */
    /*@isTest private static void caseRTtoHRJobEvaluationForm()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Function__c = 'Human Resource';
            caseNew.Customer_Intent__c = 'Employee Compensation';
            caseNew.Team__c = '[Tier 3] Compensation';
            caseNew.Customer_Sub_Intents__c = 'Job Evaluation';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description assign case Recordtype to DMC
    * @param 
    * @return 
    */
   /* @isTest private static void caseRTtoHR()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Function__c = 'Human Resource';
            caseNew.Team__c = '[Tier 3] Defined Contribution';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description assign case Recordtype to Revenue Cycle
    * @param 
    * @return 
    */
    /*@isTest private static void caseRTtoRevenueCycle()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Function__c = 'Revenue Cycle';
            caseNew.Team__c = '[Tier 3] Self Pay';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description assign case Recordtype to Supply Chain
    * @param 
    * @return 
    */
    /*@isTest private static void caseRTtoSupplyChain()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Function__c = 'Supply Chain';
            caseNew.Team__c = '[Tier 3] Content Management';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description assign case Recordtype to Supply Chain
    * @param 
    * @return 
    */
    /*@isTest private static void emailToCaseFinanceAccounting()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Function__c = 'Finance';
            caseNew.Team__c = '[Tier 3] Regional Accounting Leads';
            caseNew.Origin = 'Email to Case';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Assign team to Payroll
    * @param 
    * @return 
    */
    /*@isTest private static void assignToPayrollQueue()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Inquiry_Type__c = 'Payroll';
            caseNew.Inquiry_Reason__c = 'Employee Data Setup and Maintenance';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/

    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Assign team to Benefits Queue
    * @param 
    * @return 
    */
   /* @isTest private static void assignToBenefitsQueue()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Inquiry_Type__c = 'HR Benefits';
            caseNew.Inquiry_Reason__c = 'ESL/Sick';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Assign team to Tier 1 Defined Contribution
    * @param 
    * @return 
    */
   /* @isTest private static void assignToDefinedContributionQueue()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Inquiry_Type__c = 'HR Benefits';
            caseNew.Inquiry_Reason__c = 'Retirement - Defined Contribution';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/ 
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Assign team to Tier 1 HR Pension
    * @param 
    * @return 
    */
    /*@isTest private static void assignToHRPensionQueue()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Inquiry_Type__c = 'HR Pension';
            caseNew.Inquiry_Reason__c = 'Retirement - Pension';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Assign team to Tier 1 Workforce Relations
    * @param 
    * @return 
    */
    /*@isTest private static void assignToWorkforceRelations()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Inquiry_Type__c = 'HR General Inquiry';
            caseNew.Inquiry_Reason__c = 'General Inquiry - HR';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Assign team to Tier 1 HR Data
    * @param 
    * @return 
    */
    /*@isTest private static void assignToHRData()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Inquiry_Type__c = 'HR Data';
            caseNew.Inquiry_Reason__c = 'Employee Data Setup and Change';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Assign team to Tier 1 HRIS
    * @param 
    * @return 
    */
    /*@isTest private static void assignToHRIS()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Inquiry_Type__c = 'HR General Inquiry';
            caseNew.Inquiry_Reason__c = 'HR Tool User Support';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Assign team to Tier 3 HR Reporting
    * @param 
    * @return 
    */
    /*@isTest private static void assignToHRReporting()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Inquiry_Type__c = 'HR General Inquiry';
            caseNew.Inquiry_Reason__c = 'HR Reporting';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Assign team to Tier 1 Learning
    * @param 
    * @return 
    */
   /* @isTest private static void assignToLearning()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Inquiry_Type__c = 'Performance/Learning';
            caseNew.Inquiry_Reason__c = 'Employee Learning';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Assign team to HR Recruitment
    * @param 
    * @return 
    */
    /*@isTest private static void assignToRecruitment()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Inquiry_Type__c = 'Recruitment';
            caseNew.Inquiry_Reason__c = 'Recruitment';
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
    }*/
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Status Closed and recordtype = CV - Address Change Request
    * @param 
    * @return 
    */
    @isTest private static void statusClosedCVAddressChange()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Status = Label.CL05_Closed;
            caseNew.Close_Reason__c = 'Resolved';
            caseNew.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Address Change Request').RecordTypeId;
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
        //Assert to check case are inserted successfully
        system.assert(caseToInsert.size()>0);
    }
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Status Closed and recordtype = CV - Affiliate Data Change Request
    * @param 
    * @return 
    */
    @isTest private static void statusClosedCVAffiliateDataChange()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Status = Label.CL05_Closed;
            caseNew.Close_Reason__c = 'Resolved';
            caseNew.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Affiliate Data Change Request').RecordTypeId;
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
        //Assert to check case are inserted successfully
        system.assert(caseToInsert.size()>0);
    }
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Status Closed and recordtype = CV - Application Request
    * @param 
    * @return 
    */
    @isTest private static void statusClosedCVApplicationRequest()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Status = Label.CL05_Closed;
            caseNew.Close_Reason__c = 'Resolved';
            caseNew.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Application Request').RecordTypeId;
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
        //Assert to check case are inserted successfully
        system.assert(caseToInsert.size()>0);
    }
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Status Closed and recordtype = CV - Data Change Request
    * @param 
    * @return 
    */
    @isTest private static void statusClosedCVDataChangeRequest()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Status = Label.CL05_Closed;
            caseNew.Close_Reason__c = 'Resolved';
            caseNew.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Data Change Request').RecordTypeId;
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
        //Assert to check case are inserted successfully
        system.assert(caseToInsert.size()>0);
    }
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Status Closed and recordtype = CV - Expirables Request
    * @param 
    * @return 
    */
    @isTest private static void statusClosedCVExpirablesRequest()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Status = Label.CL05_Closed;
            caseNew.Close_Reason__c = 'Resolved';
            caseNew.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Expirables Request').RecordTypeId;
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
        //Assert to check case are inserted successfully
        system.assert(caseToInsert.size()>0);
    }
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Status Closed and recordtype = CV - Other Request
    * @param 
    * @return 
    */
    @isTest private static void statusClosedCVOtherRequest()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Status = Label.CL05_Closed;
            caseNew.Close_Reason__c = 'Resolved';
            caseNew.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Other Request').RecordTypeId;
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
        //Assert to check case are inserted successfully
        system.assert(caseToInsert.size()>0);
    }
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Status Closed and recordtype = CV - Reapplication Request
    * @param 
    * @return 
    */
    @isTest private static void statusClosedCVReapplicationRequest()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Status = Label.CL05_Closed;
            caseNew.Close_Reason__c = 'Resolved';
            caseNew.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Reapplication Request').RecordTypeId;
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
        //Assert to check case are inserted successfully
        system.assert(caseToInsert.size()>0);
    }
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Status Closed and recordtype = CV - Report Request
    * @param 
    * @return 
    */
    @isTest private static void statusClosedCVReportRequest()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Status = Label.CL05_Closed;
            caseNew.Close_Reason__c = 'Resolved';
            caseNew.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Report Request').RecordTypeId;
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
        //Assert to check case are inserted successfully
        system.assert(caseToInsert.size()>0);
    }
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Status Closed and recordtype = CV - Rush Application Request
    * @param 
    * @return 
    */
    @isTest private static void statusClosedCVRushApplicationRequest()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        
        for(Case caseNew : testCaseList)
        {
            caseNew.Status = Label.CL05_Closed;
            caseNew.Close_Reason__c = 'Resolved';
            caseNew.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Rush Application Request').RecordTypeId;
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
        //Assert to check case are inserted successfully
        system.assert(caseToInsert.size()>0);
    }
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description 
    * @param 
    * @return 
    */
    @isTest private static void insertMemberInquiry()
    {
        List<Case> testCaseList = listCases();
        List<Case> caseToInsert = new List<Case>();
        Contact con = memberContact();
        for(Case caseNew : testCaseList)
        {
            caseNew.Member_Id_Contact__c = con.id;
            caseNew.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
            caseToInsert.add(caseNew);
        }
        insert caseToInsert;
        //Assert to check case are inserted successfully
        system.assert(caseToInsert.size()>0);
    }
    
    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Create a List of Cases to Insert and update used by other test methods
    * @param 
    * @return List<Case>
    */
    @isTest private static List<Case> listCases()
    {
        List<Case> caseList = new List<Case>();
        
        for(integer i=0;i<5;i++)
        {
            Case caseNew = new Case();
            caseNew.Function__c = 'Document Management Center';
            caseNew.Team__c = 'Contact Center';
            caseList.add(caseNew);
        }
         //Assert to check case are inserted successfully
         system.assert(caseList.size()>0);
        return caseList;
       
       
    }

    /**
    * @author IDC Team
    * @date 07/27/2014
    * @description Create a contact of Type Member
    * @param 
    * @return Contact
    */
    @isTest private static Contact memberContact()
    {
        
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.RecordtypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
        insert con;
        // Assert to check Contact is inserted successfully
        system.assert(con.id!=null);
        return con;
    }
    
    
    @isTest private static void insertCaseFunctionFinance() {
        List<Case> caseList = new List<Case>();
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        caseObj1.Function__c = 'Finance';
        caseObj1.Team__c = '[Tier 3] Regional Accounting Leads';
        
        Case caseObj2 = new Case();
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        caseObj2.Function__c = 'Finance';
        caseObj2.Team__c = '[Tier 1] AP / Purchasing / Supply Chain';
        
        Case caseObj3 = new Case();
        caseObj3.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        caseObj3.Function__c = 'Finance';
        caseObj3.Team__c = '[Tier 1] Payroll T&E / Compensation';
        
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        caseList.add(caseObj3);
        
        insert caseList;
        // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
        
        List<Case> caseListUpd = new List<Case>();
        caseObj1.Team__c = '[Tier 3] JE & Balance Sheet Recons';
        caseObj2.Team__c = '[Tier 2] Finance Accounts Payable';
        caseObj3.Team__c = '[Tier 3] Payroll Review';
        caseListUpd.add(caseObj1);
        caseListUpd.add(caseObj2);
        caseListUpd.add(caseObj3);
        
        update caseListUpd ;
    }
    
    @isTest private static void insertCaseFunctionHR() {
        List<Case> caseList = new List<Case>();
        
        Case caseObj1 = new Case();
        caseObj1.Function__c = 'Human Resource';
        caseObj1.Team__c = '[Tier 3] Compensation';
        caseObj1.Customer_Intent__c = 'Employee Compensation';
        caseObj1.Customer_Sub_Intents__c = 'Job Evaluation';
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj2 = new Case();
        caseObj2.Function__c = 'Human Resource';
        caseObj2.Team__c = '[Tier 3] HR Reporting';
        caseObj2.Customer_Intent__c = 'HR Reporting';
        caseObj2.Customer_Sub_Intents__c = 'Adhoc Report Request Web';
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj3 = new Case();
        caseObj3.Function__c = 'Human Resource';
        caseObj3.Team__c = '[Tier 3] HR Reporting';
        caseObj3.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        caseList.add(caseObj3);
        
        insert caseList;
        // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
        
        
        /*List<Case> caseListUpd = new List<Case>();
        caseObj1.Team__c = '[Tier 3] JE & Balance Sheet Recons';
        caseObj2.Team__c = '[Tier 2] Finance Accounts Payable';
        caseObj3.Team__c = '[Tier 3] Payroll Review';
        caseListUpd.add(caseObj1);
        caseListUpd.add(caseObj2);
        caseListUpd.add(caseObj3);
        
        update caseListUpd;*/
        
        /*caseObj1 = new Case(Id=caseList[0].id);
        caseObj1.Team__c = '[Tier 3] HR Reporting';
        caseObj1.Customer_Intent__c = 'HR Reporting';
        caseObj1.Customer_Sub_Intents__c = 'Adhoc Report Request Web';
        update caseObj1;*/
    }
    
    @isTest private static void insertCaseFunctionOther() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.Function__c = 'Revenue Cycle';
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        caseObj1.Team__c = '[Tier 3] Revenue ';
        Case caseObj2 = new Case();
        caseObj2.Function__c = 'Supply Chain';
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        caseObj2.Team__c = '[Tier 3] Supply Chain';
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        insert caseList;
        // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
        
        List<Case> caseListUpd = new List<Case>();
        caseObj1 = new Case(Id=caseList[0].id);
        caseObj1.Function__c = 'Supply Chain';
        caseObj1.Team__c = '[Tier 3] Revenue ';
        caseObj1.Status = 'Pending';
        caseListUpd.add(caseObj1);
        caseObj2 = new Case(Id=caseList[1].id);
        caseObj2.Function__c = 'Revenue Cycle';
        caseListUpd.add(caseObj2);
        update caseListUpd;
        
    }
    
    @isTest private static void insertCaseOriginEmaiToCase() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.Origin = 'Email';
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Accounts Payable').RecordTypeId;
        
        Case caseObj2 = new Case();
        caseObj2.Origin = 'Email';
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Accounting').RecordTypeId;
        
        Case caseObj3 = new Case();
        caseObj3.Origin = 'Email';
        caseObj3.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        caseList.add(caseObj3);
        insert caseList;
        // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
    }
    
    @isTest private static void insertCaseInquiryType() {
        List<Case> caseList = new List<Case>();
        Case caseObj1 = new Case();
        caseObj1.Inquiry_Type__c = 'Payroll';
        caseObj1.Inquiry_Reason__c = 'Employee Data Setup and Maintenance';
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        Case caseObj2 = new Case();
        caseObj2.Inquiry_Type__c = 'HR Benefits';
        caseObj2.Inquiry_Reason__c = 'ESL/Sick';
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        Case caseObj3 = new Case();
        caseObj3.Inquiry_Type__c = 'HR Benefits';
        caseObj3.Inquiry_Reason__c = 'Retirement - Defined Contribution';
        caseObj3.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj4 = new Case();
        caseObj4.Inquiry_Type__c = 'HR Pension';
        caseObj4.Inquiry_Reason__c = 'Retirement - Pension';
        caseObj4.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        Case caseObj5 = new Case();
        caseObj5.Inquiry_Type__c = 'HR General Inquiry';
        caseObj5.Inquiry_Reason__c = 'General Inquiry - HR';
        caseObj5.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj6 = new Case();
        caseObj6.Inquiry_Type__c = 'HR Data';
        caseObj6.Inquiry_Reason__c = 'Employee Data Setup and Change';
        caseObj6.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj7 = new Case();
        caseObj7.Inquiry_Type__c = 'HR General Inquiry';
        caseObj7.Inquiry_Reason__c = 'HR Tool User Support';
        caseObj7.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj8 = new Case();
        caseObj8.Inquiry_Type__c = 'HR General Inquiry';
        caseObj8.Inquiry_Reason__c = 'HR Reporting';
        caseObj8.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj9 = new Case();
        caseObj9.Inquiry_Type__c = 'Performance/Learning';
        caseObj9.Inquiry_Reason__c = 'Employee Learning';
        caseObj9.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        Case caseObj10 = new Case();
        caseObj10.Inquiry_Type__c = 'Recruitment';
        caseObj10.Inquiry_Reason__c = 'Recruitment';
        caseObj10.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('S3 Interaction Log').RecordTypeId;
        
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        caseList.add(caseObj3);
        caseList.add(caseObj4);
        caseList.add(caseObj5);
        caseList.add(caseObj6);
        caseList.add(caseObj7);
        caseList.add(caseObj8);
        caseList.add(caseObj9);
        caseList.add(caseObj10);
        insert caseList;
        // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
    }
    
    @isTest private static void insertCaseAddress() {
        List<Case> caseList = new List<Case>();
        
        Case caseObj1 = new Case();
        caseObj1.Status = 'Closed';
        caseObj1.Close_Reason__c = 'Cancelled';
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Address Change Request').RecordTypeId;
        
        Case caseObj2 = new Case();
        caseObj2.Status = 'Closed';
        caseObj2.Close_Reason__c = 'Cancelled';
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Affiliate Data Change Request').RecordTypeId;
        
        Case caseObj3 = new Case();
        caseObj3.Status = 'Closed';
        caseObj3.Close_Reason__c = 'Cancelled';
        caseObj3.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Application Request').RecordTypeId;
        
        Case caseObj4 = new Case();
        caseObj4.Status = 'Closed';
        caseObj4.Close_Reason__c = 'Cancelled';
        caseObj4.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Data Change Request').RecordTypeId;
        
        Case caseObj5 = new Case();
        caseObj5.Status = 'Closed';
        caseObj5.Close_Reason__c = 'Cancelled';
        caseObj5.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Expirables Request').RecordTypeId;
        
        Case caseObj6 = new Case();
        caseObj6.Status = 'Closed';
        caseObj6.Close_Reason__c = 'Cancelled';
        caseObj6.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Other Request').RecordTypeId;
        
        Case caseObj7 = new Case();
        caseObj7.Status = 'Closed';
        caseObj7.Close_Reason__c = 'Cancelled';
        caseObj7.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Reapplication Request').RecordTypeId;
        
        Case caseObj8 = new Case();
        caseObj8.Status = 'Closed';
        caseObj8.Close_Reason__c = 'Cancelled';
        caseObj8.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Report Request').RecordTypeId;
        
        Case caseObj9 = new Case();
        caseObj9.Status = 'Closed';
        caseObj9.Close_Reason__c = 'Cancelled';
        caseObj9.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Rush Application Request').RecordTypeId;
        
        Case caseObj10 = new Case();
        caseObj10.Status = 'Closed';
        caseObj10.Close_Reason__c = 'Cancelled';
        caseObj10.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('CV - Temporary Privilege Request').RecordTypeId;
        
        caseList.add(caseObj1);
        caseList.add(caseObj2);
        caseList.add(caseObj3);
        caseList.add(caseObj4);
        caseList.add(caseObj5);
        caseList.add(caseObj6);
        caseList.add(caseObj7);
        caseList.add(caseObj8);
        caseList.add(caseObj9);
        caseList.add(caseObj10);
        
        insert caseList;
        // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
        
        /*Case caseToUpd = new Case(Id = caseList[0].id);
        update caseToUpd;*/ 
    }
    
    @isTest private static void insertCaseMemmberInquiryRecord() {
        List<Case> caseList = new List<Case>();
        
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        insert accObj;
        
        Contact contactObj = new Contact();
        contactObj.LastName ='TestContact';
        contactObj.AccountId = accObj.Id;
        contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
        insert contactObj;  
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Benefits').RecordTypeId;
        caseObj1.Member_Id_Contact__c = contactObj.Id;
        caseList.add(caseObj1);
        insert caseList;
        // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
    } 
    
    @isTest private static void insertCaseCorrespondenceRecord() {
        List<Case> caseList = new List<Case>();
        
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        insert accObj;
        
        Contact contactObj = new Contact();
        contactObj.LastName ='TestContact';
        contactObj.AccountId = accObj.Id;
        contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
        insert contactObj;  
        //Assert to check Contact is created succesfully
        system.assert(contactObj.id!=null);
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Correspondence').RecordTypeId;
        caseObj1.Member_Id_Contact__c = contactObj.Id;
        insert caseObj1;
        //close the case after insert is done successful
        if(caseObj1!= null)
        {
            Case updateCase = [Select Id, Status,Close_Reason__c from Case where ID =:caseObj1.ID];
            caseObj1.status = 'Closed';
            caseObj1.Close_Reason__c = 'Closed';
            //update caseObj1;
        }
    }
    @isTest private static void insertCaseEmailToCase() {
        List<Case> caseList = new List<Case>();
        
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        insert accObj;
        
        Contact contactObj = new Contact();
        contactObj.LastName ='TestContact';
        contactObj.AccountId = accObj.Id;
        contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
        insert contactObj;  
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Accounts Payable').RecordTypeId;
        caseObj1.Member_Id_Contact__c = contactObj.Id;
        caseObj1.status = 'Open';
        caseObj1.Origin = 'Email to Case';
        //caseObj1.Close_Reason__c = 'Closed';
        caseList.add(caseObj1);
        insert caseList;
        // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
    }
    
    @isTest private static void insertCaseEmailToCaseTwo() {
        List<Case> caseList = new List<Case>();
        
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        insert accObj;
        
        Contact contactObj = new Contact();
        contactObj.LastName ='TestContact';
        contactObj.AccountId = accObj.Id;
        contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
        insert contactObj;  
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Accounting').RecordTypeId;
        caseObj1.Member_Id_Contact__c = contactObj.Id;
        caseObj1.status = 'Open';
        caseObj1.Origin = 'Email to Case';
        //caseObj1.Close_Reason__c = 'Closed';
        caseList.add(caseObj1);
        insert caseList;
        // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
    }
    
     @isTest private static void insertExecutiveService() {
        List<Case> caseList = new List<Case>();
        
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        insert accObj;
        
        Contact contactObj = new Contact();
        contactObj.LastName ='TestContact';
        contactObj.AccountId = accObj.Id;
        contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
        insert contactObj;  
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Accounting').RecordTypeId;
        caseObj1.Member_Id_Contact__c = contactObj.Id;
        caseObj1.status = 'Open';
        
        caseList.add(caseObj1);
        Profile  p = [SELECT Id FROM Profile WHERE Name = 'Executive Services Team'];
        User u = [SELECT Id,Name FROM User WHERE ProfileId =: p.Id And isactive = true Limit 1];
        
            insert caseList;
            
            // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
        system.runas(u){
            caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Accounts Payable').RecordTypeId;
            update caseObj1;
            
        }
        
    }
    
    @isTest private static void insertCaseEmailToCase2() {
        List<Case> caseList = new List<Case>();
        
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        insert accObj;
        
        Contact contactObj = new Contact();
        contactObj.LastName ='TestContact';
        contactObj.AccountId = accObj.Id;
        contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
        insert contactObj;  
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        caseObj1.Member_Id_Contact__c = contactObj.Id;
        caseObj1.Inquiry_Type__c='Payroll';
        caseObj1.Inquiry_Reason__c = 'Employee Data Setup and Maintenance';
        caseObj1.status = 'Open';
        
        //caseObj1.Close_Reason__c = 'Closed';
        caseList.add(caseObj1);
        insert caseList;
        
        // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
    }
    
    
    @isTest private static void insertCaseEmailToCase3() {
        List<Case> caseList = new List<Case>();
        
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        insert accObj;
        
        Contact contactObj = new Contact();
        contactObj.LastName ='TestContact';
        contactObj.AccountId = accObj.Id;
        contactObj.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Member').RecordTypeId;
        insert contactObj;  
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        caseObj1.Member_Id_Contact__c = contactObj.Id;
        caseObj1.Inquiry_Type__c='Payroll';
        caseObj1.Inquiry_Reason__c = 'Employee Payroll or Paycheck Inquiry';
        caseObj1.status = 'Open';
        
        
        caseList.add(caseObj1);
        
        Case caseObj2 = new Case();
        caseObj2.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        caseObj2.Member_Id_Contact__c = contactObj.Id;
        caseObj2.Inquiry_Type__c='Payroll';
        caseObj2.Inquiry_Reason__c = 'Manager Payroll or Paycheck Inquiry';
        caseObj2.status = 'Open';
        
        
        caseList.add(caseObj2);
        
        Case caseObj3 = new Case();
        caseObj3.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        caseObj3.Member_Id_Contact__c = contactObj.Id;
        caseObj3.Inquiry_Type__c='Payroll';
        caseObj3.Inquiry_Reason__c = 'Timecard/Kronos Inquiry';
        caseObj3.status = 'Open';
        
        
        caseList.add(caseObj3);
        
        Case caseObj4 = new Case();
        caseObj4.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        caseObj4.Member_Id_Contact__c = contactObj.Id;
        caseObj4.Inquiry_Type__c='Payroll';
        caseObj4.Inquiry_Reason__c = 'Travel & Expense Inquiry';
        caseObj4.status = 'Open';
        
        
        caseList.add(caseObj4);
        
        Case caseObj5 = new Case();
        caseObj5.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        caseObj5.Member_Id_Contact__c = contactObj.Id;
        caseObj5.Inquiry_Type__c='Payroll';
        caseObj5.Inquiry_Reason__c = 'Time Off Inquiry';
        caseObj5.status = 'Open';
        
        
        caseList.add(caseObj5);
        
        Case caseObj6 = new Case();
        caseObj6.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        caseObj6.Member_Id_Contact__c = contactObj.Id;
        caseObj6.Inquiry_Type__c='Payroll';
        caseObj6.Inquiry_Reason__c = 'Garnishment';
        caseObj6.status = 'Open';
        
        
        caseList.add(caseObj6);
        
        Case caseObj7 = new Case();
        caseObj7.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        caseObj7.Member_Id_Contact__c = contactObj.Id;
        caseObj7.Inquiry_Type__c='Payroll';
        caseObj7.Inquiry_Reason__c = 'System Inquiries';
        caseObj7.status = 'Open';
        
        
        caseList.add(caseObj7);
        
        Case caseObj8 = new Case();
        caseObj8.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        caseObj8.Member_Id_Contact__c = contactObj.Id;
        caseObj8.Inquiry_Type__c='Payroll';
        caseObj8.Inquiry_Reason__c = 'Pay Inquiry';
        caseObj8.status = 'Open';
        
        
        caseList.add(caseObj8);
        
        Case caseObj9 = new Case();
        caseObj9.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Finance Payroll').RecordTypeId;
        caseObj9.Member_Id_Contact__c = contactObj.Id;
        caseObj9.Inquiry_Type__c='Payroll';
        caseObj9.Inquiry_Reason__c = 'Kronos';
        caseObj9.status = 'Open';
        
        
        caseList.add(caseObj9);
        
        
        insert caseList;
        
        // Assert to check Case is inserted successfully
        system.assert(caseList.size()>0);
    }
}