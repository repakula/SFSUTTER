public class HighRoads_TestDataUtility {
    public static List<SF_P2A_Market_Segments_Mapping__c> insertP2AMarketSegmentsCS(){
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg = new List<SF_P2A_Market_Segments_Mapping__c>();
        SF_P2A_Market_Segments_Mapping__c p2aMarketSegment = new SF_P2A_Market_Segments_Mapping__c();
        p2aMarketSegment.Name = 'Jumbo (>1000)';
        p2aMarketSegment.P2A_Market_Segment__c = 'Large Group';
        
        SF_P2A_Market_Segments_Mapping__c p2aMarketSegment1 = new SF_P2A_Market_Segments_Mapping__c();
        p2aMarketSegment1.Name = 'Key Accounts';
        p2aMarketSegment1.P2A_Market_Segment__c = 'Large Group';
        
        SF_P2A_Market_Segments_Mapping__c p2aMarketSegment2 = new SF_P2A_Market_Segments_Mapping__c();
        p2aMarketSegment2.Name = 'Labor and Trust';
        p2aMarketSegment2.P2A_Market_Segment__c = 'Large Group';
        
        SF_P2A_Market_Segments_Mapping__c p2aMarketSegment3 = new SF_P2A_Market_Segments_Mapping__c();
        p2aMarketSegment3.Name = 'Large Group (251-1000)';
        p2aMarketSegment3.P2A_Market_Segment__c = 'Large Group';
        
        SF_P2A_Market_Segments_Mapping__c p2aMarketSegment4 = new SF_P2A_Market_Segments_Mapping__c();
        p2aMarketSegment4.Name = 'Large Mid-Market Group (101 - 250)';
        p2aMarketSegment4.P2A_Market_Segment__c = 'Large Group';
        
        SF_P2A_Market_Segments_Mapping__c p2aMarketSegment5 = new SF_P2A_Market_Segments_Mapping__c();
        p2aMarketSegment5.Name = 'National Accounts';
        p2aMarketSegment5.P2A_Market_Segment__c = 'Large Group';
                
        SF_P2A_Market_Segments_Mapping__c p2aMarketSegment6 = new SF_P2A_Market_Segments_Mapping__c();
        p2aMarketSegment6.Name = 'Public Sector';
        p2aMarketSegment6.P2A_Market_Segment__c = 'Large Group';
        
        SF_P2A_Market_Segments_Mapping__c p2aMarketSegment8 = new SF_P2A_Market_Segments_Mapping__c();
        p2aMarketSegment8.Name = 'Small Group (1 - 50)';
        p2aMarketSegment8.P2A_Market_Segment__c = 'Small Group';
        
        SF_P2A_Market_Segments_Mapping__c p2aMarketSegment7 = new SF_P2A_Market_Segments_Mapping__c();
        p2aMarketSegment7.Name = 'Small Mid-Market Group (51 - 100)';
        p2aMarketSegment7.P2A_Market_Segment__c = 'Small Group';
        
        listp2amarketseg.add(p2aMarketSegment);
        listp2amarketseg.add(p2aMarketSegment1);
        listp2amarketseg.add(p2aMarketSegment2);
        listp2amarketseg.add(p2aMarketSegment3);
        listp2amarketseg.add(p2aMarketSegment4);
        listp2amarketseg.add(p2aMarketSegment5);
        listp2amarketseg.add(p2aMarketSegment6);
        listp2amarketseg.add(p2aMarketSegment7);
        listp2amarketseg.add(p2aMarketSegment8); 
        
        return listp2amarketseg;
    }
    
    public static List<SHP_Benefit_Grid__c> insertBenefitGrid(){
        List<SHP_Benefit_Grid__c> benefitGridList = new List<SHP_Benefit_Grid__c>();
        SHP_Benefit_Grid__c grid = new SHP_Benefit_Grid__c();
        grid.Benefit_Plan_ID__c = 'HE02';
        grid.Market_Segment__c = 'Large Group';
        grid.SHP_Benefit_Plan_Year__c = String.valueOf(System.today().year());
        grid.Plan_Name__c = 'HE02 - 2016';
        grid.Plan_Status__c = 'Available for Sale - Approved';
        grid.Effective_Start__c = Date.parse('1/1/2016');
        grid.Effective_End__c = Date.parse('12/31/2016');
        grid.Tech_Date_Time__c = 'ddmmyyyy';
        grid.Plan_Type__c = 'Medical';
		grid.c01_For_any_one_Member_in_a_Family__c = '$100';
        grid.c01_For_an_entire_Family__c = '$100';
        grid.SHP_Benefit_Plan_Year__c = '2016';
        benefitGridList.add(grid);
        
        SHP_Benefit_Grid__c grid1 = new SHP_Benefit_Grid__c();
        grid1.Benefit_Plan_ID__c = 'XA02';
        grid1.Market_Segment__c = 'Large Group';
        grid1.SHP_Benefit_Plan_Year__c = String.valueOf(System.today().year());
        grid1.Plan_Status__c = 'Available for Sale - Approved';
        grid1.IsRider__c = true;
        grid1.Effective_Start__c = Date.parse('1/1/2016');
        grid1.Effective_End__c = Date.parse('12/31/2016');
        grid1.Tech_Date_Time__c = 'ddmmyyyy';
        grid1.Plan_Type__c = 'Dental';
        grid1.c01_For_an_entire_Family__c = '$100';
        grid1.c01_For_any_one_Member_in_a_Family__c = '$100';
        grid1.SHP_Benefit_Plan_Year__c = '2016';
        benefitGridList.add(grid1);
        
        SHP_Benefit_Grid__c grid2 = new SHP_Benefit_Grid__c();
        grid2.Benefit_Plan_ID__c = 'ML02';
        grid2.Market_Segment__c = 'Large Group';
        grid2.Plan_Status__c = 'Available for Sale - Approved';
        grid2.SHP_Benefit_Plan_Year__c = String.valueOf(System.today().year());
        grid2.Effective_Start__c = Date.parse('1/1/2016');
        grid2.Effective_End__c = Date.parse('12/31/2016');
        grid2.Tech_Date_Time__c = 'ddmmyyyy';
        grid2.Plan_Type__c = 'Medical';
        grid2.c01_For_any_one_Member_in_a_Family__c = '$100';
        grid2.c01_For_an_entire_Family__c = '$100';
        grid2.SHP_Benefit_Plan_Year__c = '2016';
        benefitGridList.add(grid2);
        
        SHP_Benefit_Grid__c grid3 = new SHP_Benefit_Grid__c();
        grid3.Benefit_Plan_ID__c = 'XA17';
        grid3.Market_Segment__c = 'Large Group';
        grid3.SHP_Benefit_Plan_Year__c = String.valueOf(System.today().year());
        grid3.Plan_Status__c = 'Available for Sale - Approved';
        grid3.IsRider__c = true;
        grid3.Effective_Start__c = Date.parse('1/1/2016');
        grid3.Effective_End__c = Date.parse('12/31/2016');
        grid3.Tech_Date_Time__c = 'ddmmyyyy';
        grid3.Plan_Type__c = 'Chiro';
        grid3.c01_For_an_entire_Family__c = '$100';
        grid3.c01_For_any_one_Member_in_a_Family__c = '$100';
        grid3.SHP_Benefit_Plan_Year__c = '2016';
        benefitGridList.add(grid3);
        
        return benefitGridList;
    }
    
    public static List<Benefit_Plan_Metadata__c> insertBenefitPlanMetadata(){
        List<Benefit_Plan_Metadata__c> bpmList = new List<Benefit_Plan_Metadata__c>();
        Benefit_Plan_Metadata__c bpm = new Benefit_Plan_Metadata__c();
        bpm.Name = 'HE02 - 2016';
        bpm.Medical_OR_Rider__c = 'Medical';
        bpm.Product_Class__c = 'Medical';
        bpm.Effective_Date__c = System.today();
        bpm.End_Date__c = system.today()+360;
        bpm.Market_Segment__c = 'Large Group';
        bpm.Plan_Type__c = 'Standard';
        bpm.Ancillary_EOC__c = false;
        bpm.Ancillary_GSA__c = false;
        bpm.Ancillary_SOB__c = false;
        bpm.EOC__c = true;
        bpm.BCM__c = true;
        bpm.SBC__c = true;
        bpm.Benefit_Plan_ID__c = 'HE02';
        bpm.Plan_Status__c = 'Available for Sale - Approved';
        bpm.Plan_Year__c = string.valueOf(system.today().year());
        bpmList.add(bpm);
        
        Benefit_Plan_Metadata__c bpm1 = new Benefit_Plan_Metadata__c();
        bpm1.Name = 'XA02 - 2016';
        bpm1.Medical_OR_Rider__c = 'Rider';
        bpm1.Product_Class__c = 'Acupuncture and Chiro';
        bpm1.Effective_Date__c = System.today();
        bpm1.End_Date__c = system.today()+360;
        bpm1.Market_Segment__c = 'Large Group';
        bpm1.Plan_Type__c = 'Standard';
        bpm1.Ancillary_EOC__c = true;
        bpm1.Ancillary_GSA__c = true;
        bpm1.Ancillary_SOB__c = true;
        bpm1.EOC__c = true;
        bpm1.BCM__c = true;
        bpm1.SBC__c = true;
        bpm1.Benefit_Plan_ID__c = 'XA02';
        bpm1.Plan_Status__c = 'Available for Sale - Approved';
        bpm1.Plan_Year__c = string.valueOf(system.today().year());
        bpmList.add(bpm1);
        
        Benefit_Plan_Metadata__c bpm2 = new Benefit_Plan_Metadata__c();
        bpm2.Name = 'ML02';
        bpm2.Medical_OR_Rider__c = 'Medical';
        bpm2.Product_Class__c = 'Medical';
        bpm2.Effective_Date__c = System.today();
        bpm2.End_Date__c = system.today()+360;
        bpm2.Market_Segment__c = 'Large Group';
        bpm2.Plan_Type__c = 'Custom';
        bpm2.Ancillary_EOC__c = true;
        bpm2.Ancillary_GSA__c = true;
        bpm2.Ancillary_SOB__c = true;
        bpm2.EOC__c = false;
        bpm2.BCM__c = false;
        bpm2.SBC__c = false;
        bpm2.Benefit_Plan_ID__c = 'ML02';
        bpm2.Plan_Status__c = 'Available for Sale - Approved';
        bpm2.Plan_Year__c = string.valueOf(system.today().year());
        bpmList.add(bpm2);
        
        return bpmList;
    }
    
    public static List<Benefit_Plan_Data_Filters__c> insertBenefitDataFiltersCS(){
        List<Benefit_Plan_Data_Filters__c> bpdfList = new List<Benefit_Plan_Data_Filters__c>();
        Benefit_Plan_Data_Filters__c bpdf = new Benefit_Plan_Data_Filters__c();
        bpdf.Name = 'Market_Segment__c';
        bpdf.Operator__c = 'INCLUDES';
        bpdf.Reference_Field_API__c = 'Employer_Type__c';
        
        bpdfList.add(bpdf);
        
        Benefit_Plan_Data_Filters__c bpdf1 = new Benefit_Plan_Data_Filters__c();
        bpdf1.Name = 'Plan_Status__c';
        bpdf1.Operator__c = 'IN';
        bpdf1.Field_Value__c = 'Available for Sale - Approved,Soft Approved,Available for Sale - Pending Regulatory Approval';
        
        bpdfList.add(bpdf1);
        
        Benefit_Plan_Data_Filters__c bpdf2 = new Benefit_Plan_Data_Filters__c();
        bpdf2.Name = 'Plan_Year__c';
        bpdf2.Operator__c = '=';
        bpdf2.Reference_Field_API__c = 'Plan_Year__c';
        
        bpdfList.add(bpdf2);
        
        return bpdfList;
    }
    
   
    public static Account insertAccount(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test Account1';
        acc.RecordTypeId = accRecordTypeId;
        acc.NumberOfEmployees = 50;
        acc.Industry = 'Hospitaity';
        acc.Employer_Type__c = 'Large Group (251-1000)';
        return acc;
    }
    
    public static Opportunity insertOpp(){
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHP Sales Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.RecordTypeId = oppRecordTypeId;
        opp.type = 'New Business';
        opp.CloseDate = Date.Today()+120;
        opp.Plan_Effective_Date__c = Date.Today();
        opp.Plan_end_date__c = Date.today()+360;
        opp.StageName = 'Pending Broker';
        opp.Renewed_Opportunity__c = false;
        return opp;
    }
    
    public static void DocGenReqforInd(){
        HR_Individual_Document_Generation__c docRequired = new HR_Individual_Document_Generation__c();
        docRequired.Name = 'IndividualAccount';
        docRequired.Document_Generation_Required__c = true;
        insert docRequired;
    }
    
     public static User createAEUser(){
        
        Id profileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        Id uRole =  [SELECT Id FROM UserRole WHERE Name='Account Executive'].Id;
        
        User AEUser = new User(Alias = 'standt', Email='standarduser@testmethod.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profileId, UserRoleId = uRole,
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testmethod.com');
        
        insert AEUser;
        return AEUser;
    }
    
    public static Employer_Group_Data__c insertSCN() {
       
       Employer_Group_Data__c testSCN2 = new Employer_Group_Data__c();
       testSCN2.Company_Name__c = 'TestCompany1';
       testSCN2.Federal_Employer_ID_Number__c = '12345'; 
       testSCN2.Phone_Number__c = '(88) 9547 5689';
       testSCN2.Zip_SA__c = '85749';
       testSCN2.State_SA__c = 'State1';
       testSCN2.city_SA__c = 'City1';
       testSCN2.Group_Type__c = 'Large';
       testSCN2.of_Employees__c = 500;
       testSCN2.of_Eligible_Employees__c = 200;
       testSCN2.Projected_Enrollment__c = 150;
       testSCN2.Performance_or_Implementation__c = 'Test Data';
       testSCN2.Cobra_Members_with_this_Group__c = 'COBRA';
       testSCN2.Effective_Date__c = Date.Today();
       testSCN2.CompletedBy__c = userInfo.getUserid();
       testSCN2.AuditorName__c = userInfo.getUserid();
       testSCN2.Broker_Agency__c = 'Test Agency';
       testSCN2.Broker_Name__c = 'Test Broker';
       return testSCN2;
    }
}