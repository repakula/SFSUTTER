/**
* Name : UpdateBenefitCovGridIdofBenefitCov_test
* Description : Test class for testing the before insert and Before Update Events of trigger to set 
matching Benefit Grid Look up Id on Benefit Plan.
* Date : 13/04/15 
* Version : <initial Draft> 
* Version : 2.0  IDC offshore  :  Req no 3379 Add utility method createBenefitPlansForGrids2016  , createBenefitGrids2015
*/
public class UtilityBenefitGrid_Test {
    public static User shpAgent;
    public static Profile shpProfile;
    public static UserRole portalRole; 
    /*
    *@name createBenefitPlans() 
    *@return List < Benefit_Plan_Coverage__c > 
    *@description This method is to create Test Benefit Plans for Testing Trigger.
    */
    public static List< Benefit_Plan_Coverage__c > createBenefitPlans() {
        
        List < Benefit_Plan_Coverage__c > plansToInsert = new List < Benefit_Plan_Coverage__c >();
        for(Integer i=0 ; i<200 ;i++ ) {
            Benefit_Plan_Coverage__c BenefitPlan = new Benefit_Plan_Coverage__c(PlanCov_Bene_Plan_HCC_ID__c = 'ML0'+i,
                                                                                PlanCov_Bene_Plan_Name__c = 'Test Plan'+i,
                                                                                PlanCov_Bene_Plan_Date_Start__c = Date.today(),
                                                                                PlanCov_Bene_Plan_Date_End__c = Date.today()+15);
            plansToInsert.add(BenefitPlan);
        }
        return plansToInsert; 
    }
    /*
    *@name createBenefitGrids() 
    *@return List < SHP_Benefit_Grid__c > 
    *@description This method is to create Test Benefit Grids for Testing Trigger on Benefit Grids.
    */
    public static List< SHP_Benefit_Grid__c > createBenefitGrids() {
        
        List < SHP_Benefit_Grid__c > gridsToInsert = new List < SHP_Benefit_Grid__c >();
        for(Integer i=0 ; i<100 ;i++ ) {
            SHP_Benefit_Grid__c BenefitGrid = new SHP_Benefit_Grid__c(Name = 'ML0'+i,
                                                                      Acupuncture__c = 'Test Plan'+i,
                                                                      Basic_Pediatric_Dental__c = '$40 per visit',
                                                                      Eye_Exam__c = '$30 per visit' ,
                                                                      
                                                                      SHP_Benefit_Plan_Year__c =2015);
            gridsToInsert.add(BenefitGrid);
        }
        return gridsToInsert; 
    }
    
    
    
    /*
    *@name createBenefitPlans() 
    *@return List < Benefit_Plan_Coverage__c > 
    *@description This method is to create Test Benefit Plans for Testing Trigger.
    */
    
    public static List< Benefit_Plan_Coverage__c > createBenefitPlansForGrids() {
        
        List < Benefit_Plan_Coverage__c > plansToInsert = new List < Benefit_Plan_Coverage__c >();
        for(Integer i=0 ; i<100 ;i++ ) {
            Benefit_Plan_Coverage__c BenefitPlan = new Benefit_Plan_Coverage__c(PlanCov_Bene_Plan_HCC_ID__c = 'ML0'+i,
                                                                                PlanCov_Bene_Plan_Name__c = 'Test Plan'+i,
                                                                                PlanCov_Bene_Plan_Date_Start__c = Date.today(),
                                                                                PlanCov_Bene_Plan_Date_End__c = Date.today()+15);
            plansToInsert.add(BenefitPlan);
        }
        return plansToInsert; 
    }
    
    
    /*
    *@name createBenefitPlans() 
    *@return List < Benefit_Plan_Coverage__c > 
    *@description This method is to create Test Benefit Plans for Testing Trigger.
    */
    
    public static List< Benefit_Plan_Coverage__c > createBenefitPlansForUpdate() {
        
        List < Benefit_Plan_Coverage__c > plansToInsert = new List < Benefit_Plan_Coverage__c >();
        for(Integer i=200 ; i<300 ;i++ ) {
            Benefit_Plan_Coverage__c BenefitPlan = new Benefit_Plan_Coverage__c(PlanCov_Bene_Plan_HCC_ID__c = 'ML0'+i,
                                                                                PlanCov_Bene_Plan_Name__c = 'Test Plan'+i,
                                                                                PlanCov_Bene_Plan_Date_Start__c = Date.today());
            plansToInsert.add(BenefitPlan);
        }
        return plansToInsert; 
    }
    
    
    /**
    * @author       :   IDC Offshore 
    * @date         :   14-Nov-2015
    * @version      :   1.0
    * @description  :   This method is to create Test Benefit Plans for Testing Trigger for Benefit Plan End Date 2016 .
    * @param        :   void
    * @return       :   List  Benefit_Plan_Coverage__c
    */
    public static List< Benefit_Plan_Coverage__c > createBenefitPlansForGrids2016WithDate () {
        
        List < Benefit_Plan_Coverage__c > plansToInsert = new List < Benefit_Plan_Coverage__c >();
        for(Integer i=0 ; i<100 ;i++ ) {
            Benefit_Plan_Coverage__c BenefitPlan = new Benefit_Plan_Coverage__c(PlanCov_Bene_Plan_HCC_ID__c = 'ML0'+i,
                                                                                PlanCov_Bene_Plan_Name__c = 'Test Plan'+i,
                                                                                PlanCov_Bene_Plan_Date_Start__c = Date.today(),
                                                                                PlanCov_Bene_Plan_Date_End__c =  Date.today() +365);
            plansToInsert.add(BenefitPlan);
        }
        return plansToInsert; 
    }
    
    /**
    * @author       :   IDC Offshore 
    * @date         :   14-Nov-2015
    * @version      :   1.0
    * @description  :   This method is to create Test Benefit Plans for Testing Trigger for Benefit Plan End Date 2016 and plan end date is null .
    * @param        :   void
    * @return       :   List  Benefit_Plan_Coverage__c
    */
    public static List< Benefit_Plan_Coverage__c > createBenefitPlansForGrids2016() {
        
        List < Benefit_Plan_Coverage__c > plansToInsert = new List < Benefit_Plan_Coverage__c >();
        for(Integer i=0 ; i<100 ;i++ ) {
            Benefit_Plan_Coverage__c BenefitPlan = new Benefit_Plan_Coverage__c(PlanCov_Bene_Plan_HCC_ID__c = 'ML0'+i,
                                                                                PlanCov_Bene_Plan_Name__c = 'Test Plan'+i,
                                                                                PlanCov_Bene_Plan_Date_Start__c = Date.today());
            plansToInsert.add(BenefitPlan);
        }
        return plansToInsert; 
    }
    /**
    * @author       :   IDC Offshore 
    * @date         :   14-Nov-2015
    * @version      :   1.0
    * @description  :   This method is to create Test Benefit Grids for Testing Trigger on Benefit Grids for Benefit Plan Year 2015
    * @param        :   void
    * @return       :   List  SHP_Benefit_Grid__c
    */
    public static List< SHP_Benefit_Grid__c > createBenefitGrids2016() {
        
        List < SHP_Benefit_Grid__c > gridsToInsert = new List < SHP_Benefit_Grid__c >();
        for(Integer i=0 ; i<100 ;i++ ) {
            SHP_Benefit_Grid__c BenefitGrid = new SHP_Benefit_Grid__c(Name = 'ML0'+i,
                                                                      Acupuncture__c = 'Test Plan'+i,
                                                                      Basic_Pediatric_Dental__c = '$40 per visit',
                                                                      Eye_Exam__c = '$30 per visit' ,
                                                                      
                                                                      SHP_Benefit_Plan_Year__c =2016);
            gridsToInsert.add(BenefitGrid);
        }
        return gridsToInsert; 
    }
    
    
    /**
    * @author Abhishek Gupta
    * @date 01/18/2015
    * @description This method prepares the User where the Profile Name is 'SHP Agent' wiith permission set "SHP_Benefit_Grid_Manager"
    * @param 
    * @return 
    */
    public static User createSHPUser() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];  
        System.runAs (thisUser) {  
            portalRole = [Select Id From UserRole Where PortalType =: AP01_TestDataTokens.PORTAL_TYPE Limit 1];
            shpProfile = [Select Id from Profile where name =: AP01_TestDataTokens.SHP_PROFILE_NAME Limit 1];
            
            
            shpAgent = new User(
                ProfileId = shpProfile.Id,
                Username = AP01_TestDataTokens.USER_NAME,
                UserRoleId = portalRole.Id,
                Alias = AP01_TestDataTokens.ALIAS,
                Email=AP01_TestDataTokens.EMAIL,
                EmailEncodingKey=AP01_TestDataTokens.EMAIL_ENCODING_KEYS,
                Firstname=AP01_TestDataTokens.FIRST_NAME,
                Lastname=AP01_TestDataTokens.LAST_NAME,
                CommunityNickname = AP01_TestDataTokens.COMMUNITY_NICK_NAME,
                LanguageLocaleKey=AP01_TestDataTokens.LANGUAGE_LOCALE_KEY,
                LocaleSidKey=AP01_TestDataTokens.LOCALE_SID_KEY,
                TimeZoneSidKey=AP01_TestDataTokens.TIME_ZONES_ID_KEY
            );
            insert shpAgent;
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'SHP_Benefit_Grid_Manager'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = shpAgent.Id;
            psa.PermissionSetId = ps.Id;
            
        }
        return shpAgent;
    }
}