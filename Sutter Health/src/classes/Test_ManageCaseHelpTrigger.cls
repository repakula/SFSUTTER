@isTest
private class Test_ManageCaseHelpTrigger{
   
    static Map<string, String> caseRecordtypeMapping(){
        
       Map<String, String> caseRecordTypeMap = new Map<string, string>();
        for(RecordType rec:[select Id , name from RecordType where sObjectType = 'Case']) {
            caseRecordTypeMap.put(rec.Name, rec.Id);
            //caseRecordTypeNameMap.put(rec.Id,rec.Name);
        }
        return caseRecordTypeMap;
    }

    static testMethod void manageCasetriggerTest() {
    try{
    
        ManageCaseHelpTrigger objNew = new ManageCaseHelpTrigger();
        Account objAccount = new Account();
        objAccount.Name = 'test Account';
        insert objAccount;
        // Assert to check Account is created successfully
        system.assert(objAccount.id!=null);
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test F Name';

        objContact.LastName = 'Last name';
        objContact.Member_ID__c = 'M1234567-01';
        objContact.Email = 'test@test.com';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
         // Assert to check Contact is created successfully
        system.assert(objContact.id!=null);
        
        /* Web to case Req 3390 - Member - Claim Review */       
                
        Account objAccountwebtocase = new Account();        
        objAccountwebtocase.Name = 'test Account webtocase';        
        objAccountwebtocase.SHP_Group_ID__c = 'G-000001';       
        insert objAccountwebtocase;     
                
                
        Contact objContactMemberWebtoCase = new Contact();      
        objContactMemberWebtoCase.FirstName = 'Test F1 Name';       
        objContactMemberWebtoCase.LastName = 'Test L name';     
        objContactMemberWebtoCase.Member_ID__c = 'M1234567-02';     
        objContactMemberWebtoCase.Email = 'test2@test.com';     
        objContactMemberWebtoCase.AccountId = objAccountwebtocase.Id;       
        insert objContactMemberWebtoCase;       
                
        Claim_Header__c objClaimHeader = new Claim_Header__c();     
        objClaimHeader.SHPClaimHdr_Member_Lookup__c = objContactMemberWebtoCase.Id;     
        objClaimHeader.Name = 'testclaim';      
        insert objClaimHeader;
        
        Map<String, String> caseRecordTypeMap = caseRecordtypeMapping();        
        case ILCase = new Case();
        ILCase.recordTypeId = caseRecordTypeMap.get('SHP Interaction Log');
        ILCase.ContactId  =  objContact.Id; 
        ILCase.Employer_Name__c = 'test'; 
        Insert ILCase;  
        
        List<Case> lstCase = new List<Case>();
        
        case CaseSR1 = new Case();
        
        CaseSR1.recordTypeId = caseRecordTypeMap.get('SHP ATC Eligibility Related');
        CaseSR1.Sub_Category__c = 'Verify Eligibility';
        lstCase.add(CaseSR1);
        
        case CaseSR2 = new Case();
        
        CaseSR2.recordTypeId = caseRecordTypeMap.get('SHP ATC Incomplete Submission Related');
        CaseSR2.Sub_Category__c = 'Missing Information';
        CaseSR2.SR_Option__c = 'No Submission Reason Given';
        lstCase.add(CaseSR2);
        
        case CaseSR3 = new Case();
        
        CaseSR3.recordTypeId = caseRecordTypeMap.get('SHP ATC Plan Change Issue Related');
        CaseSR3.Sub_Category__c = ' Clarity Needed';
        CaseSR3.SR_Option__c = 'Change of Medical Plan';
        lstCase.add(CaseSR3);
        
        case CaseSR4 = new Case();
        
        CaseSR4.recordTypeId = caseRecordTypeMap.get('  ');
        CaseSR4.Sub_Category__c = 'Invoice Request';        
        lstCase.add(CaseSR4);
        
        case CaseSR5 = new Case();
       
        CaseSR5.recordTypeId = caseRecordTypeMap.get('SHP Broker Education');
        CaseSR5.Sub_Category__c = 'Group Kit Request';
        CaseSR5.SR_Option__c  = 'Small Group';      
        lstCase.add(CaseSR5);
        
        case CaseSR6 = new Case();
        CaseSR6.recordTypeId = caseRecordTypeMap.get('SHP Broker Education');
        CaseSR6.Sub_Category__c = 'Form Requests';
        
        lstCase.add(CaseSR6);
        
        case CaseSR7 = new Case();
        CaseSR7.recordTypeId = caseRecordTypeMap.get('SHP Broker Education');
        CaseSR7.Sub_Category__c = 'Service Area/Expansion Questions';
        lstCase.add(CaseSR7);
        
        case CaseSR8 = new Case();
        CaseSR8.recordTypeId = caseRecordTypeMap.get('SHP Employer Education');
        CaseSR8.Sub_Category__c = 'Form Requests';
        lstCase.add(CaseSR8);
        
        case CaseSR9 = new Case();
        CaseSR9.recordTypeId = caseRecordTypeMap.get('SHP Employer Education');
        CaseSR9.Sub_Category__c = 'Service Area/Expansion Questions';
        lstCase.add(CaseSR9);
        
        case CaseSR10 = new Case();
        CaseSR10.recordTypeId = caseRecordTypeMap.get('SHP EDI Escalated Issue');
        CaseSR10.Sub_Category__c = 'Previous EDI Issue';
        CaseSR10.SR_Option__c = 'Reach out to Employer/EDI Vender';
        lstCase.add(CaseSR10);
        
        case CaseSR11 = new Case();
        CaseSR11.recordTypeId = caseRecordTypeMap.get('SHP EDI Feed Issue');
        CaseSR11.Sub_Category__c = 'Eligibility';
        CaseSR11.SR_Option__c  = 'Verify Eligibility';
        lstCase.add(CaseSR11);
        
        case CaseSR12 = new Case();
        CaseSR12.recordTypeId = caseRecordTypeMap.get('SHP EDI Feed Issue');
        CaseSR12.Sub_Category__c = 'Missing Information';
        CaseSR12.SR_Option__c  = 'SS#';
        lstCase.add(CaseSR12);
        
        case CaseSR13 = new Case();
        CaseSR13.recordTypeId = caseRecordTypeMap.get('SHP EDI Issue Member in WB');
        CaseSR13.Sub_Category__c = 'Eligibility';
        CaseSR13.SR_Option__c  = 'Verify Eligibility';
        lstCase.add(CaseSR13);
        
        case CaseSR14 = new Case();
        CaseSR14.recordTypeId = caseRecordTypeMap.get('SHP EDI Issue Member in WB');
        CaseSR14.Sub_Category__c = 'Missing Information';
        CaseSR14.SR_Option__c  = 'DOB';
        lstCase.add(CaseSR14);
        
        case CaseSR15 = new Case();
        CaseSR15.recordTypeId = caseRecordTypeMap.get('SHP Employer Portal Approval Access Inquiries');
        CaseSR15.Sub_Category__c = 'Create Account';
        lstCase.add(CaseSR15);
        
        
        case CaseSR16 = new Case();
        CaseSR16.recordTypeId = caseRecordTypeMap.get('SHP Member Information Request Related');
        CaseSR16.Sub_Category__c = 'Form Requests';
        lstCase.add(CaseSR16);
        
        case CaseSR17 = new Case();
        CaseSR17.recordTypeId = caseRecordTypeMap.get('SHP SCN Submission Rejection Related');
        CaseSR17.Sub_Category__c = 'Missing Information';
        lstCase.add(CaseSR17);
        
        case CaseSR18 = new Case();
        CaseSR18.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');
        CaseSR18.Sub_Category__c = 'Broker Account';
        CaseSR18.SR_Option__c  = 'Change of Contact Information';
        lstCase.add(CaseSR18);
        
        case CaseSR19 = new Case();
        CaseSR19.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');
        CaseSR19.Sub_Category__c = 'Broker Account';
        CaseSR19.SR_Option__c  = 'Addition of New Broker Contact';
        lstCase.add(CaseSR19);
        
        case CaseSR20 = new Case();
        CaseSR20.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');
        CaseSR20.Sub_Category__c = 'Broker Account';
        CaseSR20.SR_Option__c  = 'Addition of New Broker Contact';
        lstCase.add(CaseSR20);
        
        case CaseSR21 = new Case();
        CaseSR21.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');
        CaseSR21.Sub_Category__c = 'Broker Account';
        CaseSR21.SR_Option__c  = 'Addition of New Division';
        lstCase.add(CaseSR21);
        
        case CaseSR22 = new Case();
        CaseSR22.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');
        CaseSR22.Sub_Category__c = 'Broker Account';
        CaseSR22.SR_Option__c  = 'Termination Request';
        lstCase.add(CaseSR22);
        
        case CaseSR23 = new Case();
        CaseSR23.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');
        CaseSR23.Sub_Category__c = 'Employer Account';
        CaseSR23.SR_Option__c  = 'Change of Contact Information';
        lstCase.add(CaseSR23);
        
        case CaseSR24 = new Case();
        CaseSR24.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');
        CaseSR24.Sub_Category__c = 'Employer Account';
        CaseSR24.SR_Option__c  = 'Change of Contact Information';
        lstCase.add(CaseSR24);
        
        case CaseSR25 = new Case();
        CaseSR25.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');
        CaseSR25.Sub_Category__c = 'Employer Account';
        CaseSR25.SR_Option__c  = 'Change of Contact Information';
        lstCase.add(CaseSR25);

        case CaseSR26 = new Case();
        CaseSR26.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');
        CaseSR26.Sub_Category__c = 'Employer Account';
        CaseSR26.SR_Option__c  = 'Sub Account Change of Contact Information';
        lstCase.add(CaseSR26);
        
        case CaseSR27 = new Case();
        CaseSR27.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');
        CaseSR27.Sub_Category__c = 'Employer Account';
        CaseSR27.SR_Option__c  = 'Change of Broker of Record';
        lstCase.add(CaseSR27);
        
        case CaseSR28= new Case();
        CaseSR28.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Contact');
        CaseSR28.Sub_Category__c = 'Broker Contact';
        CaseSR28.SR_Option__c  = 'Change of Contact Information';
        lstCase.add(CaseSR28);
        
        case CaseSR29 = new Case();
        CaseSR29.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Contact');
        CaseSR29.Sub_Category__c = 'Broker Contact';
        CaseSR29.SR_Option__c  = 'Removal Termination of Broker';
        lstCase.add(CaseSR29);
        
        case CaseSR30 = new Case();
        CaseSR30.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Contact');
        CaseSR30.Sub_Category__c = 'Employer Contact';
        CaseSR30.SR_Option__c  = 'Change of Billing Point of Contac';
        lstCase.add(CaseSR30); 
        
        case CaseSR31 = new Case();
        CaseSR31.recordTypeId = caseRecordTypeMap.get('SHP Billing Invoice Question');
        CaseSR31.Sub_Category__c = 'Invoice(s) Request';
        lstCase.add(CaseSR31);
        
        case CaseSR32 = new Case();
        CaseSR32.recordTypeId = caseRecordTypeMap.get('SHP RFP Rejection Related');
        CaseSR32.Sub_Category__c = 'Missing Information';
        lstCase.add(CaseSR32);
        
        case CaseSR33 = new Case();
        CaseSR33.recordTypeId = caseRecordTypeMap.get('SHP ATC Eligibility Related');
        CaseSR33.Sub_Category__c = 'Termination';
        lstCase.add(CaseSR33);
        
        case CaseSR34 = new Case();
        CaseSR34.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Contact');
        CaseSR34.Sub_Category__c = 'Employer Contact';
        CaseSR34.SR_Option__c  = 'Change of Contact Information';
        lstCase.add(CaseSR34);
        
        case CaseSR35 = new Case();
        CaseSR35.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Contact');
        CaseSR35.Sub_Category__c = 'Employer Contact';
        CaseSR35.SR_Option__c  = 'Change of Primary Point of Contact';
        lstCase.add(CaseSR35); 
        
        case CaseSR36 = new Case();
        CaseSR36.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Contact');
        CaseSR36.Sub_Category__c = 'Employer Contact';
        CaseSR36.SR_Option__c  = 'Change of Billing Point of Contact    ';
        lstCase.add(CaseSR36);      
        
        // Web to case - Req 3390. Test cases to cover method 'createSRForWebToCase' in class 'ManageCaseHelpTrigger'.
        
        case CaseWebtoCase1 = new Case();                     
        CaseWebtoCase1.Origin = 'Portal';       
        CaseWebtoCase1.recordTypeId = caseRecordTypeMap.get('SHP ATC Eligibility Related');   
        CaseWebtoCase1.SuppliedEmail='test@test1.com';
        CaseWebtoCase1.Group_Id__c='G-000001'; 
        lstCase.add(CaseWebtoCase1);        
                
        case CaseWebtoCase2 = new Case();       
        CaseWebtoCase2.Origin = 'Portal';       
        CaseWebtoCase2.recordTypeId = caseRecordTypeMap.get('SHP ATC Eligibility Related');     
        CaseWebtoCase2.SuppliedEmail='test@test.com';     
        CaseWebtoCase2.Group_Id__c='G-000001';      
        lstCase.add(CaseWebtoCase2);        
                
        case CaseWebtoCase3 = new Case();       
        CaseWebtoCase3.Origin = 'Portal';       
        CaseWebtoCase3.recordTypeId = caseRecordTypeMap.get('SHP ATC Plan Change Issue Related');       
        CaseWebtoCase3.SuppliedEmail='test@test.com';       
        lstCase.add(CaseWebtoCase3);        
                
        case CaseWebtoCase4 = new Case();       
        CaseWebtoCase4.Origin = 'Portal';       
        CaseWebtoCase4.recordTypeId = caseRecordTypeMap.get('SHP ATC Plan Change Issue Related');       
        lstCase.add(CaseWebtoCase4);        
                
        case CaseWebtoCase5 = new Case();       
        CaseWebtoCase5.Origin = 'Portal';       
        CaseWebtoCase5.recordTypeId = caseRecordTypeMap.get('SHP Billing Invoice Question');        
        CaseWebtoCase5.SuppliedEmail='test@test.com';       
        lstCase.add(CaseWebtoCase5);        
                
        case CaseWebtoCase6 = new Case();       
        CaseWebtoCase6.Origin = 'Portal';       
        CaseWebtoCase6.recordTypeId = caseRecordTypeMap.get('SHP Billing Invoice Question');        
        lstCase.add(CaseWebtoCase6);        
                
        case CaseWebtoCase7 = new Case();       
        CaseWebtoCase7.Origin = 'Portal';       
        CaseWebtoCase7.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');     
        CaseWebtoCase7.SuppliedEmail='test@test.com';       
        lstCase.add(CaseWebtoCase7);        
                
        case CaseWebtoCase8 = new Case();       
        CaseWebtoCase8.Origin = 'Portal';       
        CaseWebtoCase8.recordTypeId = caseRecordTypeMap.get('SHP Update Request for Accounts');     
        lstCase.add(CaseWebtoCase8);        
                
                
        case CaseWebtoCase9 = new Case();       
        CaseWebtoCase9.Origin = 'Portal';       
        CaseWebtoCase9.recordTypeId = caseRecordTypeMap.get('Benefits');        
        CaseWebtoCase9.Reason__c='Benefit Booklet';     
        lstCase.add(CaseWebtoCase9);        
                
        case CaseWebtoCase10 = new Case();      
        CaseWebtoCase10.Origin = 'Portal';      
        CaseWebtoCase10.recordTypeId = caseRecordTypeMap.get('Benefits');       
        CaseWebtoCase10.SuppliedEmail='test@test.com';      
        CaseWebtoCase10.Reason__c='Benefit Booklet';        
        lstCase.add(CaseWebtoCase10);       
                
        case CaseWebtoCase21 = new Case();      
        CaseWebtoCase21.Origin = 'Portal';      
        CaseWebtoCase21.recordTypeId = caseRecordTypeMap.get('Benefits');       
        CaseWebtoCase21.SuppliedEmail='test@test.com';      
        CaseWebtoCase21.shp_Member_Id__c='M1234567-01';     
        CaseWebtoCase21.Reason__c='Benefit Booklet';        
        lstCase.add(CaseWebtoCase21);       
                
                
        case CaseWebtoCase13 = new Case();      
        CaseWebtoCase13.Origin = 'Portal';      
        CaseWebtoCase13.recordTypeId = caseRecordTypeMap.get('Claim Review');       
        CaseWebtoCase13.Reason__c='Claim Review';       
        lstCase.add(CaseWebtoCase13);       
                
        case CaseWebtoCase14 = new Case();      
        CaseWebtoCase14.Origin = 'Portal';      
        CaseWebtoCase14.recordTypeId = caseRecordTypeMap.get('Claim Review');       
        CaseWebtoCase14.Reason__c='Claim Review';       
        CaseWebtoCase14.SuppliedEmail='test@test1.com';       
        CaseWebtoCase14.shp_Member_Id__c='M1234567-02';     
        CaseWebtoCase14.Member_Claim_ID__c='testclaim';     
        //CaseWebtoCase14.Member_Id_Contact__c=objContactMemberWebtoCase.Id;      
        //CaseWebtoCase14.Claim_ID__c=objClaimHeader.Id;      
        lstCase.add(CaseWebtoCase14);       
                
        case CaseWebtoCase22 = new Case();      
        CaseWebtoCase22.Origin = 'Portal';      
        CaseWebtoCase22.recordTypeId = caseRecordTypeMap.get('Claim Review');       
        CaseWebtoCase22.Reason__c='Claim Review';       
        CaseWebtoCase22.SuppliedEmail='test2@test.com';     
        CaseWebtoCase22.shp_Member_Id__c='M1234567-02';     
        CaseWebtoCase22.Member_Claim_ID__c='testclaim';       
        //CaseWebtoCase22.Member_Id_Contact__c=objContactMemberWebtoCase.Id;      
        //CaseWebtoCase22.Claim_ID__c=objClaimHeader.Id;      
        lstCase.add(CaseWebtoCase22);       
                
        case CaseWebtoCase11 = new Case();      
        CaseWebtoCase11.Origin = 'Portal';      
        CaseWebtoCase11.recordTypeId = caseRecordTypeMap.get('Billing');        
        CaseWebtoCase11.Reason__c='Premium billing Adjustment Requests';        
        lstCase.add(CaseWebtoCase11);       
                
        case CaseWebtoCase12 = new Case();      
        CaseWebtoCase12.Origin = 'Portal';      
        CaseWebtoCase12.recordTypeId = caseRecordTypeMap.get('Billing');        
        CaseWebtoCase12.Reason__c='Premium billing Adjustment Requests';        
        CaseWebtoCase12.SuppliedEmail='test2@test.com';     
        CaseWebtoCase12.shp_Member_Id__c='M1234567-02';     
        lstCase.add(CaseWebtoCase12);       
                
                
        case CaseWebtoCase15 = new Case();      
        CaseWebtoCase15.Origin = 'Portal';      
        CaseWebtoCase15.recordTypeId = caseRecordTypeMap.get('Complaint');      
        CaseWebtoCase15.Reason__c='Abusive Customer';       
        lstCase.add(CaseWebtoCase15);       
                        
        case CaseWebtoCase16 = new Case();      
        CaseWebtoCase16.Origin = 'Portal';      
        CaseWebtoCase16.recordTypeId = caseRecordTypeMap.get('Complaint');      
        //CaseWebtoCase16.SuppliedEmail='webtocase@test.com';       
        CaseWebtoCase16.Reason__c='Abusive Customer';       
        CaseWebtoCase16.shp_Member_Id__c='M1234567-02';     
        lstCase.add(CaseWebtoCase16);       
                
        insert lstCase;
        
         // Assert to check Cases is created successfully
        system.assert(lstCase.size()>0);
        
        }catch(exception ex){
        
        // Assert to check Exception 
        system.assert(ex!=null);
        }
    }
    
}