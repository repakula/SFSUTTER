@isTest
private class SHPConsoleSearchController_Test
{
      
    static testMethod void memberSearchPositive1() 
    {
         Account acc = new Account();
         acc.Name = 'TestAccount';
         insert acc;
         // Assert to check Account is created successfully
         system.assert(acc.id!=null);
         
         RecordType recType = [select Id from RecordType where Name = 'Member' and sObjectType = 'Contact'];
         //Assert to check Record type is fetched succesfully
         system.assert(recType!=null);
         
         Contact con = new Contact();
         con.FirstName = 'TestFirst';
         con.LastName = 'TestLast';
         con.Member_HCC_ID__c = 'M0001234-01';
         con.Phone = '9953084953';
         con.Birthdate = system.today();
         con.RecordTypeId = recType.Id;
         con.AccountId = acc.Id;
         insert con;
          //Assert to check Contact is created succesfully
         system.assert(con.id!=null);
        
         SHPConsoleSearchController controller = new SHPConsoleSearchController();

         controller.getsearchTypes();
         
         controller.memberID = '000123401';
         controller.memberFirstName = 'TestFirst';
         controller.memberLastName = 'TestLast';
         controller.memberDOB.SearchDate__c = system.today();
         controller.memberContactNumber = '9953084953';
         controller.SearchMember();
         
         //system.assertEquals(controller.memberResults.size(), 1);
         
    }
    
    static testMethod void memberSearchPositive2() 
    {
         Account acc = new Account();
         acc.Name = 'TestAccount';
         insert acc;
         // Assert to check Account is created successfully
         system.assert(acc.id!=null);
         
         RecordType recType = [select Id from RecordType where Name = 'Member' and sObjectType = 'Contact'];
         //Assert to check Record type is fetched succesfully
         system.assert(recType!=null);
         
         Contact con = new Contact();
         con.FirstName = 'TestFirst';
         con.LastName = 'TestLast';
         con.Member_HCC_ID__c = 'M0001234-01';
         con.Phone = '9953084953';
         con.Birthdate = system.today();
         con.RecordTypeId = recType.Id;
         con.AccountId = acc.Id;
         insert con;
         //Assert to check Contact is created succesfully
         system.assert(con.id!=null);
        
         SHPConsoleSearchController controller = new SHPConsoleSearchController();

         controller.getsearchTypes();
         
         controller.memberID = '0001234*';
         controller.memberFirstName = 'TestFirst';
         controller.memberLastName = 'TestLast';
         controller.memberDOB.SearchDate__c = system.today();
         controller.memberContactNumber = '9953084953';
         controller.getMemberDOB();
         controller.SearchMember();
         
         //system.assertEquals(controller.memberResults.size(), 1);
         
    }
    
    static testMethod void memberSearchNegative1() 
    {
         Account acc = new Account();
         acc.Name = 'TestAccount';
         insert acc;
         // Assert to check Account is created successfully
         system.assert(acc.id!=null);
         
         RecordType recType = [select Id from RecordType where Name = 'Member' and sObjectType = 'Contact'];
         //Assert to check Record type is fetched succesfully
         system.assert(recType!=null);
         
         Contact con = new Contact();
         con.FirstName = 'TestFirst';
         con.LastName = 'TestLast';
         con.Member_HCC_ID__c = 'M0001234-01';
         con.Phone = '9953084953';
         con.Birthdate = system.today();
         con.RecordTypeId = recType.Id;
         con.AccountId = acc.Id;
         insert con;
          //Assert to check Contact is created succesfully
         system.assert(con.id!=null);
        
         SHPConsoleSearchController controller = new SHPConsoleSearchController();

         controller.getsearchTypes();
         
         controller.memberID = '000123402';
         controller.memberFirstName = 'TestFirst';
         controller.memberLastName = 'TestLast';
         controller.memberDOB.SearchDate__c = system.today();
         controller.memberContactNumber = '9953084953';
         controller.SearchMember();
         system.debug('&&&'+controller.memberResults);
         //system.assertEquals(controller.memberResults.size(), 0);
         
    }
    
    static testMethod void memberSearchNegative2() 
    {
         Account acc = new Account();
         acc.Name = 'TestAccount';
         insert acc;
         // Assert to check Account is created successfully
         system.assert(acc.id!=null);
         
         
         RecordType recType = [select Id from RecordType where Name = 'Member' and sObjectType = 'Contact'];
          //Assert to check Record type is fetched succesfully
         system.assert(recType!=null);
         
         Contact con = new Contact();
         con.FirstName = 'TestFirst';
         con.LastName = 'TestLast';
         con.Member_HCC_ID__c = 'M0001234-01';
         con.Phone = '9953084953';
         con.Birthdate = system.today();
         con.RecordTypeId = recType.Id;
         con.AccountId = acc.Id;
         insert con;
        //Assert to check Contact is created succesfully
         system.assert(con.id!=null);
        
         SHPConsoleSearchController controller = new SHPConsoleSearchController();

         controller.getsearchTypes();
         
         controller.SearchMember();
         
         //system.assertEquals(controller.memberResults.size(), 0);
    }
  
    static testMethod void claimSearchPositive1() 
    {
        Claim_Header__c clHead = new Claim_Header__c ();
        clHead.Name = '000123-01';
        clHead.SHPClaimHdr_Claim_HCC_ID__c = 'C0001234-01';
        clHead.SHPClaimHdr_Member_HCC_ID__c = 'M0001234-01';
        clHead.SHPClaimHdr_Supplier_HCC_ID__c = 'S0001234-01';
        clHead.SHPClaimHdr_Claim_DoS_Start__c = system.today();
        insert clHead;
        //Assert to check Claim Header is created succesfully
         system.assert(clHead.id!=null);
         
        SHPConsoleSearchController controller = new SHPConsoleSearchController();
        
        controller.getsearchTypes();
        
        controller.claimID = 'C0001234-01';
        controller.claimMemberID = '000123401';
        controller.claimProviderID = 'S0001234-01';
        controller.claimSearchStartDate.SearchDate__c = system.today() - 7;
        controller.claimSearchEndDate.SearchDate__c = system.today() + 7;
        controller.getClaimSearchStartDate();
        controller.getClaimSearchEndDate();
        controller.SearchClaim();    
        
        //system.assertEquals(controller.claimResults.size(), 1);
    }
    
    static testMethod void claimSearchNegative1() 
    {
        Claim_Header__c clHead = new Claim_Header__c ();
        clHead.Name = '000123-01';
        clHead.SHPClaimHdr_Claim_HCC_ID__c = 'C0001234-01';
        clHead.SHPClaimHdr_Member_HCC_ID__c = 'M0001234-01';
        clHead.SHPClaimHdr_Supplier_HCC_ID__c = 'S0001234-01';
        clHead.SHPClaimHdr_Claim_DoS_Start__c = system.today();
        insert clHead;
         //Assert to check Claim Header is created succesfully
         system.assert(clHead.id!=null);
        
        SHPConsoleSearchController controller = new SHPConsoleSearchController();
        
        controller.getsearchTypes();
        
        controller.claimID = 'C0001234-01';
        controller.claimMemberID = '000123401';
        controller.claimProviderID = 'S0001234-01';
        controller.claimSearchStartDate.SearchDate__c = system.today() - 7;
        controller.claimSearchEndDate.SearchDate__c = system.today() - 14;
        controller.getClaimSearchStartDate();
        controller.getClaimSearchEndDate();
        controller.SearchClaim();    
        
        //system.assertEquals(controller.claimResults.size(), 1);
    }
    
    static testMethod void claimSearchNegative2() 
    {
        Claim_Header__c clHead = new Claim_Header__c ();
        clHead.Name = '000123-01';
        clHead.SHPClaimHdr_Claim_HCC_ID__c = 'C0001234-01';
        clHead.SHPClaimHdr_Member_HCC_ID__c = 'M0001234-01';
        clHead.SHPClaimHdr_Supplier_HCC_ID__c = 'S0001234-01';
        clHead.SHPClaimHdr_Claim_DoS_Start__c = system.today();
        insert clHead;
         //Assert to check Claim Header is created succesfully
         system.assert(clHead.id!=null);
        
        SHPConsoleSearchController controller = new SHPConsoleSearchController();
        
        controller.getsearchTypes();
        
        controller.claimID = 'C0001234-01';
        controller.claimMemberID = '000123401';
        controller.claimProviderID = 'S0001234-01';
        controller.claimSearchStartDate.SearchDate__c = system.today() - 7;
        controller.getClaimSearchStartDate();
        controller.getClaimSearchEndDate();
        controller.SearchClaim();    
        
        //system.assertEquals(controller.claimResults.size(), 0);
        
    }
    
    static testMethod void claimSearchNegative3() 
    {
        Claim_Header__c clHead = new Claim_Header__c ();
        clHead.Name = '000123-01';
        clHead.SHPClaimHdr_Claim_HCC_ID__c = 'C0001234-01';
        clHead.SHPClaimHdr_Member_HCC_ID__c = 'M0001234-01';
        clHead.SHPClaimHdr_Supplier_HCC_ID__c = 'S0001234-01';
        clHead.SHPClaimHdr_Claim_DoS_Start__c = system.today();
        insert clHead;
         //Assert to check Claim Header is created succesfully
         system.assert(clHead.id!=null);
        
        SHPConsoleSearchController controller = new SHPConsoleSearchController();
        
        controller.getsearchTypes();
        
        controller.claimMemberID = '000123401';
        controller.SearchClaim();  
        
        //system.assertEquals(controller.claimResults.size(), 0);  
        
    }

}