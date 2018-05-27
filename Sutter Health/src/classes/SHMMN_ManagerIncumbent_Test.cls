/********************************************************    
     *     Class Name  : SHMMN_ManagerIncumbent_Test 
     *     Author      : IDC Offshore   
     *     Date        : 02-may-2016  
     *     Project Name: CRM - SFT - Sutter Health   
     *     Description : Test Class for ManagerIncumbent trigger.  
     *********************************************************/
    @isTest
    private class SHMMN_ManagerIncumbent_Test{

    /********************************************************        
     * @author IDC Team        
     * @date  05-may-2016       
     * @description method to create test data used by all tests       
     * @return void        
    ********************************/
        @testSetup
        Static void createTestData(){
        
        Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
        System.assert(recType!=null);
        
        Account tempaccount = new Account(name ='test account',NumberOfEmployees=10,RecordTypeId = recType);
        insert tempaccount;
        
        // assert to check account is created succesfully
        system.assert(tempaccount.id!=null);
        
        SHMMN_Incumbent_Carrier__c tempSHMMN = new SHMMN_Incumbent_Carrier__c(Sub_Product__c  ='EPO',Contain__c = 12,Incumbent_Carrier__c='AETNA',Account__c=tempaccount.id);
        insert tempSHMMN ;
        system.assert(tempSHMMN.id!=null);
        System.assert(tempSHMMN.Incumbent_Carrier__c =='AETNA');
        List<SHMMN_Incumbent_Carrier__c> lstSHMMNInc = new List<SHMMN_Incumbent_Carrier__c>();
        for(Integer i = 1;i<=200;i++)
                {
                    SHMMN_Incumbent_Carrier__c shmmnIncTest =  new SHMMN_Incumbent_Carrier__c();
                    shmmnIncTest.Incumbent_Carrier__c = 'AETNA';
                    shmmnIncTest.Sub_Product__c = 'Test'+i;
                    shmmnIncTest.Account__c = tempaccount.id;
                    shmmnIncTest.Contain__c = 0;
                    lstSHMMNInc.add(shmmnIncTest);
                }
        insert lstSHMMNInc;
        //Assert to check if SHMMN Incumbent Carrier has been created successfully 
            System.assert(lstSHMMNInc!=null);
        }
    /********************************************************        
     * @author IDC Team        
     * @date  03-may-2016       
     * @description method to test % contain more than 100       
     * @return void        
    ********************************************************/  
     static testmethod void positive_Test()
     {
       SHMMN_Incumbent_Carrier__c tempSHMMN= [select id,Incumbent_Carrier__c,Contain__c   from SHMMN_Incumbent_Carrier__c  where Sub_Product__c  ='EPO' ];
        try{
        System.assert(tempSHMMN != null);
        tempSHMMN.Incumbent_Carrier__c ='BLUE SHIELD';
        tempSHMMN.Contain__c = 120;
        update tempSHMMN;
         }
         catch(Exception ex)
         {
              // assert to check error mesaage if the % contain is more than 100
               System.assertequals(true, ex.getMessage().contains(System.Label.CL_42_SM_IncumbentErrorMsg));

         }
     }
    /********************************************************        
     * @author IDC Team        
     * @date  03-may-2016       
     * @description method to test duplicate incumbent carrier records       
     * @return void        
    ********************************************************/  
     static testmethod void DuplicateCheck_Test()
     {
       try{
       Account acc= [select id from Account where name ='test account' ];
       SHMMN_Incumbent_Carrier__c tempSHMMN = new SHMMN_Incumbent_Carrier__c(Sub_Product__c  ='PPO',Contain__c = 12,Incumbent_Carrier__c='AETNA',Account__c=acc.id);
       insert tempSHMMN ;
       tempSHMMN.Sub_Product__c='EPO';
       update tempSHMMN;
       }
       catch(Exception ex)
         {          
          // assert to check error mesaage for duplicate Incumbent carrier based on Incumbent Carrier and Sub Product
          System.assertequals(true, ex.getMessage().contains(System.Label.CL_74_SM_IncumbentDupErrorMsg));
         }
     }
    /********************************************************        
     * @author IDC Team        
     * @date  03-may-2016       
     * @description method to test bulk scenario of incumbent carrier records update      
     * @return void        
    ********************************************************/  
     static testmethod void bulkUpdate_Test()
     {
        
            Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHMMN Employer').getRecordTypeId();
            Account acc = [Select id from Account where name =: 'test account' and NumberOfEmployees =: 10 and RecordTypeId =: recType];
            //Assert to check account is fetched successfully
            System.Assert(acc.id!=null);
            String str = 'SHMMN';
            List<SHMMN_Incumbent_Carrier__c> SHMMNIncList = [Select id, Sub_Product__c from SHMMN_Incumbent_Carrier__c where Account__c =: acc.id and Contain__c =: 0];
            List<SHMMN_Incumbent_Carrier__c> tempSHMMNIncList = new List<SHMMN_Incumbent_Carrier__c>();
            //Assert to check SHMMN Incumbent Carrier records have been fetched successfully
            System.assert(SHMMNIncList!=null);
            for(SHMMN_Incumbent_Carrier__c shmnn :SHMMNIncList )
            {
                Integer i=0;
                shmnn.Sub_Product__c = shmnn.Sub_Product__c + String.valueof(i);
                i++;
            }
            test.startTest();
            update SHMMNIncList;
            test.stopTest(); 
            //Assert to check SHMMN Incumbent Carrier records have been updated successfully
            System.assert(SHMMNIncList!=null);
     }
    }