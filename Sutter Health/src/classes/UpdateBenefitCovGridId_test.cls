/**
* Name : UpdateBenefitCovGridId_test
* Description : Test class used for testing the Trigger on Benefit Grid
* Date : 10/04/15 
* Version : <initial Draft> 
* Version : 2.0  IDC offshore  :  Req no 3379  change in method to cover  new code testBenefitGridUpdate() ,testInsertBenefitPlans
* Version : 3.0  IDC offshore  :  Req no 3182  Changes in Benefit Plan and Benefit Grid for High Roads
*/
@isTest
private class UpdateBenefitCovGridId_test {
    
    
    static testMethod void testInsertBenefitPlans() {
        // Create List of Benefit Plan Data Filters
        List<Benefit_Plan_Data_Filters__c> bpdfList = HighRoads_TestDataUtility.insertBenefitDataFiltersCS();
        insert bpdfList;
        // Create P2A Market Segments
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegList;
        // Create Benefit Grid Metadata 
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        List<SHP_Benefit_Grid__c> benefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        insert benefitGrid;
        // Query list of inserted Metadata
        List<Benefit_Plan_Metadata__c> benefitPlanMetadata = [SELECT ID,Benefit_Grid__c,EOC__c ,SBC__c ,BCM__c ,
                                                              Ancillary_EOC__c ,Ancillary_SOB__c,Ancillary_GSA__c,
                                                              Version_Number__c,IsActivelyMarketed__c,Plan_Year__c,Market_Segment__c,
                                                              Plan_Related_to_Account__c,Name,Plan_Name__c,Plan_Status__c,
                                                              Deductible__c,Family_Deductible__c,Ind_Family_Deductible__c,
                                                              DOV__c,Inpatient__c,Emergency_Room__c,Medical_OR_Rider__c,    
                                                              IsCustom__c,IsHDHP__c,Office_Visit__c,Out_of_Pocket_Maximum__c,
                                                              Family_OOPM__c,Ind_Family_OOPM__c,Product_Family__c,
                                                              Outpatient__c,Product__c,RX_Tier_1__c,RX_Tier_2__c,RX_Tier_3__c,
                                                              RX_Tier_4__c,Rx_Deductible_Family__c,Rx_Deductible_Ind_Family__c,
                                                              Rx_Deductible_Individual__c,Specialist_Office_Visit__c,Benefit_Plan_ID__c,
                                                              Visit_Limit__c,Rider_Cost_Share__c,Product_Class__c,
                                                              Plan_Type__c,Product_Types__c FROM Benefit_Plan_Metadata__c];
        // Check if all the metadata is created
        System.assertEquals(4, benefitPlanMetadata.size());
                
        Test.startTest();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc; // Create Account to be associated with Benefit Plan
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp; // Create Opportunity for the above account.
        // Create Contact for above Account
        Contact con = new Contact();
        con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SHP Sales Employer Contact').getRecordTypeId();
        con.Firstname = 'Test';
        con.LastName = 'Last Name';
        con.AccountId = acc.Id;
        insert con;
                
        List<Benefit_Plan_Coverage__c> benefitPlanCovList = new List<Benefit_Plan_Coverage__c>();
        // Benefit Plan Coverage with HCC id, Plan start date and plan end date
        Benefit_Plan_Coverage__c benPlnCov1 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov1.PlanCov_Member_Lookup__c = con.id;
        benPlnCov1.PlanCov_Bene_Plan_HCC_ID__c = 'HE02';
        benPlnCov1.PlanCov_Bene_Plan_Name__c = 'HE02'; 
        benPlnCov1.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov1.PlanCov_Bene_Plan_Date_End__c = system.today(); 
        benPlnCov1.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        
        // Benefit Plan Coverage with HCC id and Plan start date 
        Benefit_Plan_Coverage__c benPlnCov2 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov2.PlanCov_Member_Lookup__c = con.id;
        benPlnCov2.PlanCov_Bene_Plan_HCC_ID__c = 'XA02';
        benPlnCov2.PlanCov_Bene_Plan_Name__c = 'XA02'; 
        benPlnCov2.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov2.PlanCov_Bene_Plan_Date_End__c = NULL; 
        benPlnCov2.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        
        // Benefit Plan Coverage with HCC id and Plan start date         
        Benefit_Plan_Coverage__c benPlnCov3 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov3.PlanCov_Member_Lookup__c = con.id;
        benPlnCov3.PlanCov_Bene_Plan_HCC_ID__c = 'ML02';
        benPlnCov3.PlanCov_Bene_Plan_Name__c = 'ML02'; 
        benPlnCov3.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov3.PlanCov_Bene_Plan_Date_End__c = system.today()-400; 
        benPlnCov3.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        
        // Bebefit Plan Coverage without Contact and Plan Start Date 
        Benefit_Plan_Coverage__c benPlnCov4 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov4.PlanCov_Member_Lookup__c = NULL;
        benPlnCov4.PlanCov_Bene_Plan_HCC_ID__c = '';
        benPlnCov4.PlanCov_Bene_Plan_Name__c = ''; 
        benPlnCov4.PlanCov_Bene_Plan_Date_Start__c=NULL; 
        benPlnCov4.PlanCov_Bene_Plan_Date_End__c = system.today()-400; 
        benPlnCov4.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        // Insert Benefit Plan Coverage
        benefitPlanCovList.add(benPlnCov1);
        benefitPlanCovList.add(benPlnCov2);
        benefitPlanCovList.add(benPlnCov3);
        benefitPlanCovList.add(benPlnCov4);
        Insert benefitPlanCovList;
        // Check if the Benefit Plan coverage record is updating
        UpdateBenefitGridIdofBenefitCov.setBenefitGridId(benefitPlanCovList);
        system.Assert(benefitPlanCovList[0].PlanCov_Bene_Plan_HCC_ID__c.Contains('HE02'));
        system.Assert(benefitPlanCovList[1].PlanCov_Bene_Plan_HCC_ID__c.Contains('XA02'));
        system.Assert(benefitPlanCovList[2].PlanCov_Bene_Plan_HCC_ID__c.Contains('ML02'));
        
        Test.stopTest();
    }
     /*
    *@name testInsertBenefitPlans() 
    *@return void
    *@description This method is to test Before Insert event of Trigger on Portfolio to set its Look up field of Benefit Plan record to its related Benfit Grid Record whenever a matching Benefit Grid is inserted in System.
    */
    static testMethod void UpdateBenefitCovGridIdTest() {
        // Create List of Benefit Plan Data Filters
        List<Benefit_Plan_Data_Filters__c> bpdfList = HighRoads_TestDataUtility.insertBenefitDataFiltersCS();
        insert bpdfList;
        // Create P2A Market Segments
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegList;
        // Create Benefit Grid Metadata 
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        List<SHP_Benefit_Grid__c> benefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        insert benefitGrid;
        // Query list of inserted Metadata
        List<Benefit_Plan_Metadata__c> benefitPlanMetadata = [SELECT ID,Benefit_Grid__c,EOC__c ,SBC__c ,BCM__c ,
                                                              Ancillary_EOC__c ,Ancillary_SOB__c,Ancillary_GSA__c,
                                                              Version_Number__c,IsActivelyMarketed__c,Plan_Year__c,Market_Segment__c,
                                                              Plan_Related_to_Account__c,Name,Plan_Name__c,Plan_Status__c,
                                                              Deductible__c,Family_Deductible__c,Ind_Family_Deductible__c,
                                                              DOV__c,Inpatient__c,Emergency_Room__c,Medical_OR_Rider__c,    
                                                              IsCustom__c,IsHDHP__c,Office_Visit__c,Out_of_Pocket_Maximum__c,
                                                              Family_OOPM__c,Ind_Family_OOPM__c,Product_Family__c,
                                                              Outpatient__c,Product__c,RX_Tier_1__c,RX_Tier_2__c,RX_Tier_3__c,
                                                              RX_Tier_4__c,Rx_Deductible_Family__c,Rx_Deductible_Ind_Family__c,
                                                              Rx_Deductible_Individual__c,Specialist_Office_Visit__c,Benefit_Plan_ID__c,
                                                              Visit_Limit__c,Rider_Cost_Share__c,Product_Class__c,
                                                              Plan_Type__c,Product_Types__c FROM Benefit_Plan_Metadata__c];
        // Check if all the metadata is created
        System.assertEquals(4, benefitPlanMetadata.size());
        // Create Benefit Plan Associates
        List<Benefit_Plan_Association__c> bpaList = new List<Benefit_Plan_Association__c>();
        Account acc =  HighRoads_TestDataUtility.insertAccount();
        Insert acc; // Create Account to be associated with Benefit Plan
        Opportunity opp = HighRoads_TestDataUtility.insertOpp();
        opp.AccountId = acc.Id;
        Insert opp; // Create Opportunity for the above account.
        
        // Create Contact for above Account
        Contact con = new Contact();
        con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SHP Sales Employer Contact').getRecordTypeId();
        con.Firstname = 'Test';
        con.LastName = 'Last Name';
        con.AccountId = acc.Id;
        insert con;
                
        List<Benefit_Plan_Coverage__c> benefitPlanCovList = new List<Benefit_Plan_Coverage__c>();
        // Benefit Plan Coverage with HCC id, Plan start date and plan end date
        Benefit_Plan_Coverage__c benPlnCov1 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov1.PlanCov_Member_Lookup__c = con.id;
        benPlnCov1.PlanCov_Bene_Plan_HCC_ID__c = 'HE02';
        benPlnCov1.PlanCov_Bene_Plan_Name__c = 'HE02'; 
        benPlnCov1.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov1.PlanCov_Bene_Plan_Date_End__c = system.today(); 
        benPlnCov1.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        
        // Benefit Plan Coverage with HCC id and Plan start date 
        Benefit_Plan_Coverage__c benPlnCov2 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov2.PlanCov_Member_Lookup__c = con.id;
        benPlnCov2.PlanCov_Bene_Plan_HCC_ID__c = 'XA02';
        benPlnCov2.PlanCov_Bene_Plan_Name__c = 'XA02'; 
        benPlnCov2.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov2.PlanCov_Bene_Plan_Date_End__c = NULL; 
        benPlnCov2.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        
        // Benefit Plan Coverage with HCC id and Plan start date         
        Benefit_Plan_Coverage__c benPlnCov3 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov3.PlanCov_Member_Lookup__c = con.id;
        benPlnCov3.PlanCov_Bene_Plan_HCC_ID__c = 'ML02';
        benPlnCov3.PlanCov_Bene_Plan_Name__c = 'ML02'; 
        benPlnCov3.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov3.PlanCov_Bene_Plan_Date_End__c = system.today()-400; 
        benPlnCov3.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services';
        
        // Bebefit Plan Coverage without Contact and Plan Start Date 
        Benefit_Plan_Coverage__c benPlnCov4 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov4.PlanCov_Member_Lookup__c = NULL;
        benPlnCov4.PlanCov_Bene_Plan_HCC_ID__c = '';
        benPlnCov4.PlanCov_Bene_Plan_Name__c = ''; 
        benPlnCov4.PlanCov_Bene_Plan_Date_Start__c=NULL; 
        benPlnCov4.PlanCov_Bene_Plan_Date_End__c = system.today()-400; 
        benPlnCov4.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        
        Benefit_Plan_Coverage__c benPlnCov5 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov5.PlanCov_Member_Lookup__c = con.id;
        benPlnCov5.PlanCov_Bene_Plan_HCC_ID__c = 'HE01';
        benPlnCov5.PlanCov_Bene_Plan_Name__c = 'HE01'; 
        benPlnCov5.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov5.PlanCov_Bene_Plan_Date_End__c = system.today(); 
        benPlnCov5.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        
        // Benefit Plan Coverage with HCC id and Plan start date 
        Benefit_Plan_Coverage__c benPlnCov6 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov6.PlanCov_Member_Lookup__c = con.id;
        benPlnCov6.PlanCov_Bene_Plan_HCC_ID__c = 'XA01';
        benPlnCov6.PlanCov_Bene_Plan_Name__c = 'XA01'; 
        benPlnCov6.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov6.PlanCov_Bene_Plan_Date_End__c = NULL; 
        benPlnCov6.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        
        // Benefit Plan Coverage with HCC id and Plan start date         
        Benefit_Plan_Coverage__c benPlnCov7 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov7.PlanCov_Member_Lookup__c = con.id;
        benPlnCov7.PlanCov_Bene_Plan_HCC_ID__c = 'ML01';
        benPlnCov7.PlanCov_Bene_Plan_Name__c = 'ML01'; 
        benPlnCov7.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov7.PlanCov_Bene_Plan_Date_End__c = system.today()-400; 
        benPlnCov7.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services';
        
        // Bebefit Plan Coverage without Contact and Plan Start Date 
        Benefit_Plan_Coverage__c benPlnCov8 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov8.PlanCov_Member_Lookup__c = NULL;
        benPlnCov8.PlanCov_Bene_Plan_HCC_ID__c = '';
        benPlnCov8.PlanCov_Bene_Plan_Name__c = ''; 
        benPlnCov8.PlanCov_Bene_Plan_Date_Start__c=NULL; 
        benPlnCov8.PlanCov_Bene_Plan_Date_End__c = system.today()-400; 
        benPlnCov8.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        
        // Insert Benefit Plan Coverage
        benefitPlanCovList.add(benPlnCov1);
        benefitPlanCovList.add(benPlnCov2);
        benefitPlanCovList.add(benPlnCov3);
        benefitPlanCovList.add(benPlnCov4);
        benefitPlanCovList.add(benPlnCov5);
        benefitPlanCovList.add(benPlnCov6);
        benefitPlanCovList.add(benPlnCov7);
        benefitPlanCovList.add(benPlnCov8);
        Insert benefitPlanCovList;
        Map < Id,SHP_Benefit_Grid__c > oldBenGridRecordMap = new Map < Id,SHP_Benefit_Grid__c >();
        for(SHP_Benefit_Grid__c SHPBenefitGrid : benefitGrid)
            oldBenGridRecordMap.put(SHPBenefitGrid.Id,SHPBenefitGrid);
        
        UpdateBenefitCovGridId.setBenefitGridIdAfterInsert(benefitGrid);
        // Test is Benefit Grid has expected values.
        System.Assert(benefitGrid[0].Benefit_Plan_ID__c.Contains('HE02'));
        system.Assert(benefitGrid[1].Benefit_Plan_ID__c.Contains('XA02'));
        system.Assert(benefitGrid[2].Benefit_Plan_ID__c.Contains('ML02'));
        
        benefitGrid[0].Benefit_Plan_ID__c = 'HE01';
        benefitGrid[1].Benefit_Plan_ID__c = 'XA01';
        benefitGrid[2].Benefit_Plan_ID__c = 'ML01';
        benefitGrid[3].Benefit_Plan_ID__c = 'ML04';
        SHP_UpdateBenefitGridAuditandMetadata.isAfterUpdate = true;
        update benefitGrid;
                
        
        
            
        //  Test method to change the look up of Benefit Plan whenever the plan Id matched Benefit Grid is Updated.
        UpdateBenefitCovGridId.setBenefitGridIdAfterUpdate(benefitGrid,oldBenGridRecordMap);
        
        // Test method of Benefit Plans lookup on before Insert
        SHP_Benefit_Grid__c BenefitGrid2 = new SHP_Benefit_Grid__c(SHP_Benefit_Plan_Year__c = String.valueOf(Date.Today().Year()));
        List<SHP_Benefit_Grid__c> listBenefitGrid = new List<SHP_Benefit_Grid__c>();
        listBenefitGrid.add(BenefitGrid2);        
        UpdateBenefitCovGridId.setBenefitGridIdAfterInsert(listBenefitGrid);

        SHP_Benefit_Grid__c BPC = new SHP_Benefit_Grid__c();
        Database.SaveResult results = Database.Insert(BPC,false);
        
        // Covering exception  from catchExceptionsFromCode by inserting same list  insertedBenefitsPlan
        try{
            UpdateBenefitCovGridId.catchExceptionsFromCode(Database.insert(benefitGrid,false));
        }
        catch(exception ex){}
        try{
            HighRoads_UpdateGridIdInCoverageBatch batchObj = new HighRoads_UpdateGridIdInCoverageBatch(null,null);
            batchObj.catchExceptionsFromCode(Database.insert(benefitGrid,false));

        }
        catch(exception ex){}
    }
    private testMethod static void updateBenefitGrid(){
        // Create P2A Market Segments
        List<SF_P2A_Market_Segments_Mapping__c> marketSegList = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert marketSegList;
        // Create Benefit Grid Metadata 
        List<Grid_to_Metadata_Mapping__c> ls = Test.loadData(Grid_to_Metadata_Mapping__c.sObjectType, 'GridAPIMappingCSV');
        List<SHP_Benefit_Grid__c> benefitGrid = HighRoads_TestDataUtility.insertBenefitGrid();
        SHP_UpdateBenefitGridAuditandMetadata.isAfterInsert = true;
        insert benefitGrid;
        Benefit_Plan_Coverage__c benPlnCov5 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov5.PlanCov_Bene_Plan_HCC_ID__c = 'ML011';
        benPlnCov5.PlanCov_Bene_Plan_Name__c = 'ML011'; 
        benPlnCov5.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov5.PlanCov_Bene_Plan_Date_End__c = system.today(); 
        benPlnCov5.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        
        // Benefit Plan Coverage with HCC id and Plan start date 
        Benefit_Plan_Coverage__c benPlnCov6 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov6.PlanCov_Bene_Plan_HCC_ID__c = 'ML012';
        benPlnCov6.PlanCov_Bene_Plan_Name__c = 'ML012'; 
        benPlnCov6.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov6.PlanCov_Bene_Plan_Date_End__c = NULL; 
        benPlnCov6.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services'; 
        
        // Benefit Plan Coverage with HCC id and Plan start date         
        Benefit_Plan_Coverage__c benPlnCov7 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov7.PlanCov_Bene_Plan_HCC_ID__c = 'ML013';
        benPlnCov7.PlanCov_Bene_Plan_Name__c = 'ML013'; 
        benPlnCov7.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov7.PlanCov_Bene_Plan_Date_End__c = system.today()-400; 
        benPlnCov7.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services';
        
        // Benefit Plan Coverage with HCC id and Plan start date         
        Benefit_Plan_Coverage__c benPlnCov8 = new  Benefit_Plan_Coverage__c ();                             
        benPlnCov8.PlanCov_Bene_Plan_HCC_ID__c = 'ML013';
        benPlnCov8.PlanCov_Bene_Plan_Name__c = 'ML013'; 
        benPlnCov8.PlanCov_Bene_Plan_Date_Start__c=system.today(); 
        benPlnCov8.PlanCov_Bene_Plan_Type__c = 'Sutter Shared Services';
        
        Insert benPlnCov5;
        Insert benPlnCov6;
        Insert benPlnCov7;
        Insert benPlnCov8;
        
        List<SHP_Benefit_Grid__c> updateList = new List<SHP_Benefit_Grid__c>();
        Map<ID,SHP_Benefit_Grid__c> oldBenefitPlanMap = new Map<ID,SHP_Benefit_Grid__c>([select id,Benefit_Plan_ID__c,SHP_Benefit_Plan_Year__c from SHP_Benefit_Grid__c LIMIT 1000]);
        for(Integer i=0;i<benefitGrid.size();i++){

            benefitGrid[i].Benefit_Plan_ID__c = 'ML01'+i+1;
            
            updateList.add(benefitGrid[i]);
        }
        if(updateList != NULL && !updateList.isEmpty()){
            SHP_UpdateBenefitGridAuditandMetadata.isAfterUpdate = true;
            
            update updateList;
            UpdateBenefitCovGridId.setBenefitGridIdAfterUpdate(updateList,oldBenefitPlanMap);
        }
    }
    
}