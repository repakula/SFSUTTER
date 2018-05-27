/**********************************************************************
 Name: VFC41_Potential_Quality_Issue_test
 Copyright © 2015 IDC Offshore
 ======================================================
 ======================================================
 Purpose:
 This is the test class for VFC05_Claim_Detail class
 ======================================================
 ======================================================
 History
 -------
 VERSION  AUTHOR        DATE        DETAIL                 Description
 1.0      IDC Offshore  14-Aug-2015 Development complete   Test Class for VFC41_Potential_Quality_Issue  and PQIUpdateQueue. This class tests for different scenarios that are handled in the code.
 2.0      IDC Offshore  14-Dec-2015  Class Optimization   Incorporated changes to implement best test practices in the test class.
 ***********************************************************************/
@isTest
private class VFC41_Potential_Quality_Issue_test {
        

    /*******************************************************************
    Purpose: This method is used to Test submit approval process from from vf page and When a user clicks on the Save button on Cutomer all value will get save in PQI object.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/  
    static testMethod void CompletedAndSave_Test() {
        //Create test User
        user us=AP01_TestDataUtility.createUserPQI();
        /*********************************************************************** 
        Verifying the User has been created successfully
        Expected Result: user id is not null
        Actual Result: user id  is not null 
        ***********************************************************************/ 
        system.assert(us.id!=null);
        
        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        /*********************************************************************** 
        Verifying the Account has been created successfully
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(assignedAccount.id!=null);
        
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPQI(assignedAccount);
        set<Id> setTestRecId = new set<Id>();
        
        for(Contact co : ContactToInsert){
            setTestRecId.add(co.id);
        }
        Potential_Quality_Issue__c   newPotentialQualityIssue = new Potential_Quality_Issue__c (Access_Availability__c =true,
                                                                                                Description_of_Events1__c ='Test Address',
                                                                                                Medical_Director_Recommendations__c ='test',
                                                                                                Medical_Director_Review_Summary1__c ='123123',
                                                                                                Member_ID__c =ContactToInsert[0].id,
                                                                                                Member_Name__c = 'test',
                                                                                                Member_Medical_Group_Affiliation__c ='Small',
                                                                                                Member_DOB__C =system.today(),
                                                                                                PCP_Practioner_Name__c ='Test',
                                                                                                Settings__c ='Office',
                                                                                                PQI_Status__C ='Closed',
                                                                                                PQI_Referral_Date__c = system.today(),
                                                                                                PQI_Referred_By__c ='test',
                                                                                                Assigned_RN__c =us.id,
                                                                                                Reason_for_Referral__c ='test user',
                                                                                                RN_Timeline_of_Key_Events__c ='test rn',
                                                                                                RN_Case_Review_Summary1__c ='test summary',
                                                                                                RN_Justification_of_Recommendation__C ='test',
                                                                                                RN_Pertinent_criteria_guidelines_standa__c ='test critera',
                                                                                                Peer_Review_Credentialing_Outcome__c ='test',
                                                                                                PQI_Required_Field__C =true
                                                                                               );
        insert newPotentialQualityIssue;
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c has been created successfully
        Expected Result: Potential_Quality_Issue__c id is not null
        Actual Result: Potential_Quality_Issue__c id  is not null 
        ***********************************************************************/
        system.assert(newPotentialQualityIssue.id!=null);
        
        system.debug('!!!!newPotentialQualityIssue' +newPotentialQualityIssue);
        ApexPages.StandardController sc = new ApexPages.StandardController(newPotentialQualityIssue );
        test.startTest();
        VFC41_Potential_Quality_Issue potentialQualityIssue= new VFC41_Potential_Quality_Issue (sc);
        potentialQualityIssue.Completed();
        potentialQualityIssue.sendPRC();
        potentialQualityIssue.approveRecord();
        potentialQualityIssue.rejectRecord();
        potentialQualityIssue.autoPopulateMember();
        potentialQualityIssue.closeRecord();
        potentialQualityIssue.save();
        test.stopTest();
        list <Potential_Quality_Issue__c>  pqi = [SELECT Peer_Review_Credentialing_Outcome__c
                                                  FROM Potential_Quality_Issue__c
                                                  WHERE Id =:newPotentialQualityIssue.id ];
        
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c record list size
        Expected Result: Potential_Quality_Issue__c record list size should be 1
        Actual Result: Potential_Quality_Issue__c record list size should be 1 
        ***********************************************************************/ 
        system.assertEquals(pqi.size(),1 );
        
    }        
     /*******************************************************************
    Purpose: This method is used to Negative Testing submit approval process from from vf page and When a user clicks on the Save button on Cutomer all value will get save in PQI object.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/  
    static testMethod void CompletedAndSave_NegativeTest() {
        
        user us=AP01_TestDataUtility.createUser();
        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        /*********************************************************************** 
        Verifying the Account has been created successfully
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(assignedAccount.id!=null);
        
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPQI(assignedAccount);
        set<Id> setTestRecId = new set<Id>();
        
        for(Contact co : ContactToInsert){
            setTestRecId.add(co.id);
        }
        Potential_Quality_Issue__c   newPotentialQualityIssue = new Potential_Quality_Issue__c (Access_Availability__c =true,
                                                                                                Description_of_Events1__c ='Test Address',
                                                                                                Medical_Director_Recommendations__c ='test',
                                                                                                Medical_Director_Review_Summary1__c ='123123',
                                                                                                Member_ID__c =ContactToInsert[0].id,
                                                                                                Member_Name__c = 'test',
                                                                                                Member_Medical_Group_Affiliation__c ='Small',
                                                                                                Member_DOB__C =system.today(),
                                                                                                PCP_Practioner_Name__c ='Test',
                                                                                                Settings__c ='Office',
                                                                                                PQI_Status__C ='PRC',
                                                                                                Comment_PRC__c ='Rejected',
                                                                                                PQI_Referral_Date__c = system.today(),
                                                                                                PQI_Referred_By__c ='test',
                                                                                                Assigned_RN__c =us.id,
                                                                                                Reason_for_Referral__c ='test user',
                                                                                                RN_Timeline_of_Key_Events__c ='test rn',
                                                                                                RN_Case_Review_Summary1__c ='test summary',
                                                                                                RN_Justification_of_Recommendation__C ='test',
                                                                                                RN_Pertinent_criteria_guidelines_standa__c ='test critera',
                                                                                                Peer_Review_Credentialing_Outcome__c ='test',
                                                                                                PQI_Required_Field__C =true
                                                                                                
                                                                                               );
        insert newPotentialQualityIssue;
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c has been created successfully
        Expected Result: Potential_Quality_Issue__c id is not null
        Actual Result: Potential_Quality_Issue__c id  is not null 
        ***********************************************************************/ 
        system.assert(newPotentialQualityIssue.id!=null);
        
        system.debug('!!!!newPotentialQualityIssue' +newPotentialQualityIssue);
        ApexPages.StandardController sc = new ApexPages.StandardController(newPotentialQualityIssue );
        test.startTest();
        VFC41_Potential_Quality_Issue potentialQualityIssue= new VFC41_Potential_Quality_Issue (sc);
        potentialQualityIssue.showBlankVlaue = '';
        potentialQualityIssue.PQITrainingDocument = new SHP_Training_Document__kav();
        potentialQualityIssue.Completed();
        potentialQualityIssue.sendPRC();
        potentialQualityIssue.approveRecord();
        potentialQualityIssue.rejectRecord();
        potentialQualityIssue.autoPopulateMember();
        potentialQualityIssue.closeRecord();
        potentialQualityIssue.save();
        test.stopTest();
        
        
    }

    /*******************************************************************
    Purpose: This method is used to test submit approval process from from vf page  and send to PRC.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/ 
    static testMethod void sendPRC_Test() {
        
        user us=AP01_TestDataUtility.createUser();  
        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        /*********************************************************************** 
        Verifying the Account has been created successfully
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(assignedAccount.id!=null);
        
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPQINegative(assignedAccount);
        //create test Contact data for PCP Information custom console.
            PCP_Information__c pcp = new   PCP_Information__c ();
            pcp.Medical_Group_Affiliation__c = AP01_TestDataTokens.CONTACT_F_NAME ;
            pcp.Member_ID__c = ContactToInsert[0].id;
            pcp.PCP_Effective_date__c = system.today();
            pcp.PCP_Member_HR_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Practitioner_First_Name__c=AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
            pcp.PCP_Practitioner_HR_ID__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
            pcp.PCP_Practitioner_Last_Name__c = AP01_TestDataTokens.MEMBER_HCC_ID ;
            pcp.PCP_Practitioner_Middle_Name__c = AP01_TestDataTokens.SUPPLIER_Tax_ID;
            pcp.PCP_Practitioner_Name__c = AP01_TestDataTokens.SUPPLIER_NPI;
            pcp.PCP_Speciality__c = AP01_TestDataTokens.VENDOR_ID;
            pcp.PCP_Specialty_HCC_ID__c= AP01_TestDataTokens.VENDOR_TaxID;
            pcp.PCP_Specialty_HR_ID__c= AP01_TestDataTokens.CONT_EMPLOYEE_ID ;
            pcp.PCP_Specialty_Sub_HCC_ID__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Specialty_Sub_HR_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_sub_Specialty__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Supplier_Location_HR_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Supplier_Location_name__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Supplier_Name__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Supplier_NPI__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Termination_Date__c=system.today();
            pcp.SPS_Epic_ID__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            insert pcp;
         
        Potential_Quality_Issue__c   newPotentialQualityIssue = new Potential_Quality_Issue__c (
                                                                                                Description_of_Events1__c ='<a href',
                                                                                                Medical_Director_Recommendations__c ='Other',
                                                                                                Medical_Director_Review_Summary1__c ='<a href',
                                                                                                Member_ID__c =ContactToInsert[0].id,
                                                                                                Member_Name__c = null,
                                                                                                Member_Medical_Group_Affiliation__c =null,
                                                                                                Member_DOB__C =system.today(),
                                                                                                PCP_Practioner_Name__c ='Test',
                                                                                                Settings__c ='other',
                                                                                                PQI_Status__C ='New',
                                                                                                PQI_Referral_Date__c = null,
                                                                                                PQI_Referred_By__c =null,
                                                                                                Assigned_RN__c =null,
                                                                                                Reason_for_Referral__c =null,
                                                                                                RN_Timeline_of_Key_Events__c ='<a href',
                                                                                                RN_Case_Review_Summary1__c ='<a href',
                                                                                                RN_Justification_of_Recommendation__C ='<a href',
                                                                                                RN_Pertinent_criteria_guidelines_standa__c ='<a href',
                                                                                                Peer_Review_Credentialing_Outcome__c ='Other',
                                                                                                Peer_Review_Other__c = null,
                                                                                                Medical_Director_Recommendations_Other__c =  null,
                                                                                                Setting_other__c = null,
                                                                                                Other_CheckBox__c = true,
                                                                                                PQI_indicator_Other__c = null,
                                                                                                PQI_Required_Field__C =false                                                                                                                                                                                              
                                                                                            );
        insert newPotentialQualityIssue;
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c has been created successfully
        Expected Result: Potential_Quality_Issue__c id is not null
        Actual Result: Potential_Quality_Issue__c id  is not null 
        ***********************************************************************/ 
        system.assert(newPotentialQualityIssue.id!=null);

        ApexPages.StandardController sc = new ApexPages.StandardController(newPotentialQualityIssue );
        test.startTest();
        VFC41_Potential_Quality_Issue potentialQualityIssue= new VFC41_Potential_Quality_Issue (sc);   
        potentialQualityIssue.autoPopulateMember();
        potentialQualityIssue.Completed();
        potentialQualityIssue.sendPRC();
        potentialQualityIssue.approveRecord();
        potentialQualityIssue.rejectRecord();
        potentialQualityIssue.autoPopulateMember();
        potentialQualityIssue.closeRecord();
        potentialQualityIssue.save();
        potentialQualityIssue.OtherValue();
        potentialQualityIssue.OtherValuePqiIndicator();
        potentialQualityIssue.isOtherMedical();
        test.stopTest();
    }
    /*******************************************************************
    Purpose: This method is used to testing populate member from contact object and PCP object.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/ 
    static testMethod void autoPopulateMember_Test() {
        
        user us=AP01_TestDataUtility.createUser();  
        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        /*********************************************************************** 
        Verifying the Account has been created successfully
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(assignedAccount.id!=null);
        
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPQINegative(assignedAccount);
        //create test Contact data for PCP Information custom console.
            PCP_Information__c pcp = new   PCP_Information__c ();
            pcp.Medical_Group_Affiliation__c = AP01_TestDataTokens.CONTACT_F_NAME ;
            pcp.Member_ID__c = ContactToInsert[0].id;
            datetime todayTimeAndDate = System.today(); 
            date CurrentDate = Date.newInstance(todayTimeAndDate.year(),todayTimeAndDate.month(),todayTimeAndDate.day());
            pcp.PCP_Effective_date__c = CurrentDate;
            pcp.PCP_Member_HR_ID__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Practitioner_First_Name__c=AP01_TestDataTokens.EMPLOYEE_AFFILIATE_FACILITY ;
            pcp.PCP_Practitioner_HR_ID__c = AP01_TestDataTokens.MEMBER_ID_FIELD  ;
            pcp.PCP_Practitioner_Last_Name__c = AP01_TestDataTokens.MEMBER_HCC_ID ;
            pcp.PCP_Practitioner_Middle_Name__c = AP01_TestDataTokens.SUPPLIER_Tax_ID;
            pcp.PCP_Practitioner_Name__c = AP01_TestDataTokens.SUPPLIER_NPI;
            pcp.PCP_Speciality__c = AP01_TestDataTokens.VENDOR_ID;
            pcp.PCP_Specialty_HCC_ID__c= AP01_TestDataTokens.VENDOR_TaxID;
            pcp.PCP_Specialty_HR_ID__c= AP01_TestDataTokens.CONT_EMPLOYEE_ID ;
            pcp.PCP_Specialty_Sub_HCC_ID__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Specialty_Sub_HR_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_sub_Specialty__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Supplier_Location_HR_ID__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Supplier_Location_name__c =AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Supplier_Name__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Supplier_NPI__c = AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            pcp.PCP_Termination_Date__c=CurrentDate;
            pcp.SPS_Epic_ID__c=AP01_TestDataTokens.CONT_EMPLOYEE_ID;
            insert pcp;
         
        Potential_Quality_Issue__c   newPotentialQualityIssue = new Potential_Quality_Issue__c (
                                                                                                Description_of_Events1__c ='<a href',
                                                                                                Medical_Director_Recommendations__c ='Other',
                                                                                                Medical_Director_Review_Summary1__c ='<a href',
                                                                                                Member_ID__c =ContactToInsert[0].id,
                                                                                                Member_Name__c = null,
                                                                                                Member_Medical_Group_Affiliation__c =null,
                                                                                                Member_DOB__C =system.today(),
                                                                                                PCP_Practioner_Name__c ='Test',
                                                                                                Settings__c ='other',
                                                                                                PQI_Status__C ='New',
                                                                                                PQI_Referral_Date__c = null,
                                                                                                PQI_Referred_By__c =null,
                                                                                                Assigned_RN__c =null,
                                                                                                Reason_for_Referral__c =null,
                                                                                                RN_Timeline_of_Key_Events__c ='<a href',
                                                                                                RN_Case_Review_Summary1__c ='<a href',
                                                                                                RN_Justification_of_Recommendation__C ='<a href',
                                                                                                RN_Pertinent_criteria_guidelines_standa__c ='<a href',
                                                                                                Peer_Review_Credentialing_Outcome__c ='Other',
                                                                                                Peer_Review_Other__c = null,
                                                                                                Medical_Director_Recommendations_Other__c =  null,
                                                                                                Setting_other__c = null,
                                                                                                Other_CheckBox__c = true,
                                                                                                PQI_indicator_Other__c = null,
                                                                                                PQI_Required_Field__C =false                                                                                                                                                                                              
                                                                                            );
        insert newPotentialQualityIssue;
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c has been created successfully
        Expected Result: Potential_Quality_Issue__c id is not null
        Actual Result: Potential_Quality_Issue__c id  is not null 
        ***********************************************************************/ 
        system.assert(newPotentialQualityIssue.id!=null);

        ApexPages.StandardController sc = new ApexPages.StandardController(newPotentialQualityIssue );
        test.startTest();
        VFC41_Potential_Quality_Issue potentialQualityIssue= new VFC41_Potential_Quality_Issue (sc);   
        potentialQualityIssue.autoPopulateMember();
        test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method is use to testing  for the validation in mandatory fields.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/ 
    static testMethod void PQIRequired_Test() {
        
        user us=AP01_TestDataUtility.createUser();  
        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        /*********************************************************************** 
        Verifying the Account has been created successfully
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(assignedAccount.id!=null);
        
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPQINegative(assignedAccount);
        set<Id> setTestRecId = new set<Id>();
        for(Contact co : ContactToInsert){
            setTestRecId.add(co.id);
        }
        Potential_Quality_Issue__c   newPotentialQualityIssue = new Potential_Quality_Issue__c (
                                                                                                Description_of_Events1__c ='<a href',
                                                                                                Medical_Director_Recommendations__c ='Other',
                                                                                                Medical_Director_Review_Summary1__c ='<a href',                                                                                      
                                                                                                Member_Name__c = null,
                                                                                                Member_Medical_Group_Affiliation__c =null,
                                                                                                Member_DOB__C =system.today(),
                                                                                                PCP_Practioner_Name__c ='Test',
                                                                                                Settings__c ='other',
                                                                                                PQI_Status__C ='New',
                                                                                                PQI_Referral_Date__c = null,
                                                                                                PQI_Referred_By__c =null,
                                                                                                Assigned_RN__c =null,
                                                                                                Reason_for_Referral__c =null,
                                                                                                RN_Timeline_of_Key_Events__c ='<a href',
                                                                                                RN_Case_Review_Summary1__c ='<a href',
                                                                                                RN_Justification_of_Recommendation__C ='<a href',
                                                                                                RN_Pertinent_criteria_guidelines_standa__c ='<a href',
                                                                                                Peer_Review_Credentialing_Outcome__c ='Other',
                                                                                                Peer_Review_Other__c = null,
                                                                                                Medical_Director_Recommendations_Other__c =  null,
                                                                                                Setting_other__c = null,
                                                                                                Other_CheckBox__c = true,
                                                                                                PQI_indicator_Other__c = null,
                                                                                                PQI_Required_Field__C =false                                                                                                                                                                                              
                                                                                            );
        insert newPotentialQualityIssue;
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c has been created successfully
        Expected Result: Potential_Quality_Issue__c id is not null
        Actual Result: Potential_Quality_Issue__c id  is not null 
        ***********************************************************************/ 
        system.assert(newPotentialQualityIssue.id !=null);

        ApexPages.StandardController sc = new ApexPages.StandardController(newPotentialQualityIssue );
        test.startTest();
        VFC41_Potential_Quality_Issue potentialQualityIssue= new VFC41_Potential_Quality_Issue (sc);   
        potentialQualityIssue.Completed();
        potentialQualityIssue.sendPRC();
        potentialQualityIssue.approveRecord();
        potentialQualityIssue.rejectRecord();
        potentialQualityIssue.autoPopulateMember();
        potentialQualityIssue.closeRecord();
        potentialQualityIssue.save();
        potentialQualityIssue.OtherValue();
        potentialQualityIssue.OtherValuePqiIndicator();
        potentialQualityIssue.isOtherMedical();
        test.stopTest();
    }
    
   /*******************************************************************
    Purpose:  This method is used to test approve record and this method is use for  Approve button and approve prc button
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void approveRecord_Test() {
        
        user us=AP01_TestDataUtility.createUserPQI();
        /*********************************************************************** 
        Verifying the User has been created successfully
        Expected Result: user id is not null
        Actual Result: user id  is not null 
        ***********************************************************************/ 
        system.assert(us.id!=null);
        
        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        /*********************************************************************** 
        Verifying the Account has been created successfully
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(assignedAccount.id!=null);
        
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPQI(assignedAccount);
        set<Id> setTestRecId = new set<Id>();
        for(Contact co : ContactToInsert){
            setTestRecId.add(co.id);
        }
        Potential_Quality_Issue__c   newPotentialQualityIssue = new Potential_Quality_Issue__c (Access_Availability__c =true,
                                                                                                Description_of_Events1__c ='Test Address',
                                                                                                Medical_Director_Recommendations__c ='test',
                                                                                                Medical_Director_Review_Summary1__c ='123123',
                                                                                                Member_ID__c =ContactToInsert[0].id,
                                                                                                Member_Name__c = 'test',
                                                                                                Member_Medical_Group_Affiliation__c ='Small',
                                                                                                Member_DOB__C =system.today(),
                                                                                                PCP_Practioner_Name__c ='Test',
                                                                                                Settings__c ='Office',
                                                                                                PQI_Status__C ='New',
                                                                                                bypass_cmo__c = true,
                                                                                                Comment_CMO__c =null,
                                                                                                Comment_PRC__c = null,
                                                                                                Comment_UM__c = null,
                                                                                                PQI_Referral_Date__c = system.today(),
                                                                                                PQI_Referred_By__c ='test',
                                                                                                Assigned_RN__c =us.id,
                                                                                                Reason_for_Referral__c ='test user',
                                                                                                RN_Timeline_of_Key_Events__c ='test rn',
                                                                                                RN_Case_Review_Summary1__c ='test summary',
                                                                                                RN_Justification_of_Recommendation__C ='test',
                                                                                                RN_Pertinent_criteria_guidelines_standa__c ='test critera',
                                                                                                Peer_Review_Credentialing_Outcome__c ='test',
                                                                                                PQI_Required_Field__C =true
                                                                                               );
        insert newPotentialQualityIssue;
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c has been created successfully
        Expected Result: Potential_Quality_Issue__c id is not null
        Actual Result: Potential_Quality_Issue__c id  is not null 
        ***********************************************************************/ 
        system.assert(newPotentialQualityIssue.id!=null);
        ApexPages.StandardController sc = new ApexPages.StandardController(newPotentialQualityIssue );
        test.startTest();
        VFC41_Potential_Quality_Issue potentialQualityIssue= new VFC41_Potential_Quality_Issue (sc);
        potentialQualityIssue.Completed();
        potentialQualityIssue.approveRecord();
        newPotentialQualityIssue.PQI_Status__C ='UM Review';
        update newPotentialQualityIssue;
        potentialQualityIssue.approveRecord();
        potentialQualityIssue.rejectRecord();
        test.stopTest();    
    }

    /*******************************************************************
    Purpose:  This method is used to test hit the approval process by the Vf page  for reject button
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: Yes
    ********************************************************************/
    static testMethod void updatequeueReject_Negative() {
        
        user us=AP01_TestDataUtility.createUserPQI();
        /*********************************************************************** 
        Verifying the User has been created successfully
        Expected Result: user id is not null
        Actual Result: user id  is not null 
        ***********************************************************************/ 
        system.assert(us.id!=null);
        
        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        /*********************************************************************** 
        Verifying the Account has been created successfully
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(assignedAccount.id!=null);
        
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPQI(assignedAccount);
        set<Id> setTestRecId = new set<Id>();
        for(Contact co : ContactToInsert){
            setTestRecId.add(co.id);
        }
        Potential_Quality_Issue__c   newPotentialQualityIssue = new Potential_Quality_Issue__c (Access_Availability__c =true,
                                                                                                Description_of_Events1__c ='Test Address',
                                                                                                Medical_Director_Recommendations__c ='test',
                                                                                                Medical_Director_Review_Summary1__c ='123123',
                                                                                                Member_ID__c =ContactToInsert[0].id,
                                                                                                Member_Name__c = 'test',
                                                                                                Member_Medical_Group_Affiliation__c ='Small',
                                                                                                Member_DOB__C =system.today(),
                                                                                                PCP_Practioner_Name__c ='Test',
                                                                                                Settings__c ='Office',
                                                                                                PQI_Status__C ='New',
                                                                                                bypass_cmo__c = false,
                                                                                                Comment_CMO__c =null,
                                                                                                Comment_PRC__c = null,
                                                                                                Comment_UM__c = null,
                                                                                                PQI_Referral_Date__c = system.today(),
                                                                                                PQI_Referred_By__c ='test',
                                                                                                Assigned_RN__c =us.id,
                                                                                                Reason_for_Referral__c ='test user',
                                                                                                RN_Timeline_of_Key_Events__c ='test rn',
                                                                                                RN_Case_Review_Summary1__c ='test summary',
                                                                                                RN_Justification_of_Recommendation__C ='test',
                                                                                                RN_Pertinent_criteria_guidelines_standa__c ='test critera',
                                                                                                Peer_Review_Credentialing_Outcome__c ='test',
                                                                                                PQI_Required_Field__C =true
                                                                                               );
        insert newPotentialQualityIssue;
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c has been created successfully
        Expected Result: Potential_Quality_Issue__c id is not null
        Actual Result: Potential_Quality_Issue__c id  is not null 
        ***********************************************************************/ 
        system.assert(newPotentialQualityIssue.id!=null);
        ApexPages.StandardController sc = new ApexPages.StandardController(newPotentialQualityIssue );
        test.startTest();
        VFC41_Potential_Quality_Issue potentialQualityIssue= new VFC41_Potential_Quality_Issue (sc);
        potentialQualityIssue.Completed();
        potentialQualityIssue.approveRecord();
        newPotentialQualityIssue.PQI_Status__C ='UM Review';
        update newPotentialQualityIssue;
        potentialQualityIssue.approveRecord();
        potentialQualityIssue.rejectRecord();
        PQIUpdateQueue objPQIUpdateQueue = new PQIUpdateQueue();
        objPQIUpdateQueue.updatequeueReject(null);
        test.stopTest();
        
        
    }
    /*******************************************************************
    Purpose:  This method is used to test hit the approval process by the Vf page  for reject button
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void approveRecord_NegativeTest() {
        user us=AP01_TestDataUtility.createUserPQI();
        /*********************************************************************** 
        Verifying the User has been created successfully
        Expected Result: user id is not null
        Actual Result: user id  is not null 
        ***********************************************************************/ 
        system.assert(us.id!=null);
        
        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        /*********************************************************************** 
        Verifying the Account has been created successfully
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(assignedAccount.id!=null);
        
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPQI(assignedAccount);
        set<Id> setTestRecId = new set<Id>();
        for(Contact co : ContactToInsert){
            setTestRecId.add(co.id);
        }
        Potential_Quality_Issue__c   newPotentialQualityIssue = new Potential_Quality_Issue__c (Access_Availability__c =true,
                                                                                                Description_of_Events1__c ='Test Address',
                                                                                                Medical_Director_Recommendations__c ='test',
                                                                                                Medical_Director_Review_Summary1__c ='123123',
                                                                                                Member_ID__c =ContactToInsert[0].id,
                                                                                                Member_Name__c = 'test',
                                                                                                Member_Medical_Group_Affiliation__c ='Small',
                                                                                                Member_DOB__C =system.today(),
                                                                                                PCP_Practioner_Name__c ='Test',
                                                                                                Settings__c ='Office',
                                                                                                PQI_Status__C =System.Label.CL147_MD_Review,
                                                                                                Comment_CMO__c =null,
                                                                                                Comment_PRC__c = null,
                                                                                                Comment_UM__c = null,
                                                                                                bypass_cmo__c = false,
                                                                                                PQI_Referral_Date__c = system.today(),
                                                                                                PQI_Referred_By__c ='test',
                                                                                                Assigned_RN__c =us.id,
                                                                                                Reason_for_Referral__c ='test user',
                                                                                                RN_Timeline_of_Key_Events__c ='test rn',
                                                                                                RN_Case_Review_Summary1__c ='test summary',
                                                                                                RN_Justification_of_Recommendation__C ='test',
                                                                                                RN_Pertinent_criteria_guidelines_standa__c ='test critera',
                                                                                                Peer_Review_Credentialing_Outcome__c ='test',
                                                                                                PQI_Required_Field__C =true
                                                                                               );
        insert newPotentialQualityIssue;
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c has been created successfully
        Expected Result: Potential_Quality_Issue__c id is not null
        Actual Result: Potential_Quality_Issue__c id  is not null 
        ***********************************************************************/ 
        system.assert(newPotentialQualityIssue.id!=null);
        ApexPages.StandardController sc = new ApexPages.StandardController(newPotentialQualityIssue );
        test.startTest();
        VFC41_Potential_Quality_Issue potentialQualityIssue= new VFC41_Potential_Quality_Issue (sc);
        potentialQualityIssue.Completed();
        potentialQualityIssue.approveRecord();
        newPotentialQualityIssue.PQI_Status__C = System.Label.CL148_MD_Approved;
        newPotentialQualityIssue.bypass_cmo__c = true;
        update newPotentialQualityIssue;
        ApexPages.StandardController sc4 = new ApexPages.StandardController(newPotentialQualityIssue );
        VFC41_Potential_Quality_Issue potentialQualityIssue4= new VFC41_Potential_Quality_Issue (sc4);
        potentialQualityIssue4.approveRecord();
        potentialQualityIssue.rejectRecord();
        test.stopTest();
    }
    
    /*******************************************************************
    Purpose:   This method is used to negative test submit approval process from from vf page.
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void CompletedapproveRecord_Test() {
        user us=AP01_TestDataUtility.createUserPQI();
        /*********************************************************************** 
        Verifying the User has been created successfully
        Expected Result: user id is not null
        Actual Result: user id  is not null 
        ***********************************************************************/ 
        system.assert(us.id!=null);

        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        /*********************************************************************** 
        Verifying the Account has been created successfully
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(assignedAccount.id!=null);
        
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPQI(assignedAccount);
        set<Id> setTestRecId = new set<Id>();
        for(Contact co : ContactToInsert){
            setTestRecId.add(co.id);
        }
        Potential_Quality_Issue__c   newPotentialQualityIssue = new Potential_Quality_Issue__c (Access_Availability__c =true,
                                                                                                Description_of_Events1__c ='Test Address',
                                                                                                Medical_Director_Recommendations__c ='test',
                                                                                                Medical_Director_Review_Summary1__c ='123123',
                                                                                                Member_ID__c =ContactToInsert[0].id,
                                                                                                Member_Name__c = 'test',
                                                                                                Member_Medical_Group_Affiliation__c ='Small',
                                                                                                Member_DOB__C =system.today(),
                                                                                                PCP_Practioner_Name__c ='Test',
                                                                                                Settings__c ='Office',
                                                                                                PQI_Status__C ='PRC',
                                                                                                Comment_CMO__c =null,
                                                                                                Comment_PRC__c = null,
                                                                                                Comment_UM__c = null,
                                                                                                bypass_cmo__c = false,
                                                                                                PQI_Referral_Date__c = system.today(),
                                                                                                PQI_Referred_By__c ='test',
                                                                                                Assigned_RN__c =us.id,
                                                                                                Reason_for_Referral__c ='test user',
                                                                                                RN_Timeline_of_Key_Events__c ='test rn',
                                                                                                RN_Case_Review_Summary1__c ='test summary',
                                                                                                RN_Justification_of_Recommendation__C ='test',
                                                                                                RN_Pertinent_criteria_guidelines_standa__c ='test critera',
                                                                                                Peer_Review_Credentialing_Outcome__c ='test',
                                                                                                PQI_Required_Field__C =true
                                                                                               );
        insert newPotentialQualityIssue;
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c has been created successfully
        Expected Result: Potential_Quality_Issue__c id is not null
        Actual Result: Potential_Quality_Issue__c id  is not null 
        ***********************************************************************/ 
        system.assert(newPotentialQualityIssue.id!=null);
        ApexPages.StandardController sc = new ApexPages.StandardController(newPotentialQualityIssue );
        test.startTest();
        VFC41_Potential_Quality_Issue potentialQualityIssue= new VFC41_Potential_Quality_Issue (sc);
        potentialQualityIssue.Completed();
        potentialQualityIssue.approveRecord();
        potentialQualityIssue.rejectrecord();
        test.stopTest();
    }
   
     /*******************************************************************
    Purpose:   This method is used to test approve record and this method is use for  Reject button and Reject prc button
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void rejectrecord_Test() {
        
        user us=AP01_TestDataUtility.createUserPQI();
        /*********************************************************************** 
        Verifying the User has been created successfully
        Expected Result: user id is not null
        Actual Result: user id  is not null 
        ***********************************************************************/ 
        system.assert(us.id!=null);

        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        /*********************************************************************** 
        Verifying the Account has been created successfully
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(assignedAccount.id!=null);
        
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPQI(assignedAccount);
        set<Id> setTestRecId = new set<Id>();
        for(Contact co : ContactToInsert){
            setTestRecId.add(co.id);
        }
        Potential_Quality_Issue__c   newPotentialQualityIssue = new Potential_Quality_Issue__c (Access_Availability__c =true,
                                                                                                Description_of_Events1__c ='Test Address',
                                                                                                Medical_Director_Recommendations__c ='test',
                                                                                                Medical_Director_Review_Summary1__c ='123123',
                                                                                                Member_ID__c =ContactToInsert[0].id,
                                                                                                Member_Name__c = 'test',
                                                                                                Member_Medical_Group_Affiliation__c ='Small',
                                                                                                Member_DOB__C =system.today(),
                                                                                                PCP_Practioner_Name__c ='Test',
                                                                                                Settings__c ='Office',
                                                                                                PQI_Status__C ='New',
                                                                                                Comment_CMO__c =null,
                                                                                                Comment_PRC__c = null,
                                                                                                Comment_UM__c = null,
                                                                                                bypass_cmo__c = false,
                                                                                                PQI_Referral_Date__c = system.today(),
                                                                                                PQI_Referred_By__c ='test',
                                                                                                Assigned_RN__c =us.id,
                                                                                                Reason_for_Referral__c ='test user',
                                                                                                RN_Timeline_of_Key_Events__c ='test rn',
                                                                                                RN_Case_Review_Summary1__c ='test summary',
                                                                                                RN_Justification_of_Recommendation__C ='test',
                                                                                                RN_Pertinent_criteria_guidelines_standa__c ='test critera',
                                                                                                Peer_Review_Credentialing_Outcome__c ='test',
                                                                                                PQI_Required_Field__C =true
                                                                                               );
        insert newPotentialQualityIssue;
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c has been created successfully
        Expected Result: Potential_Quality_Issue__c id is not null
        Actual Result: Potential_Quality_Issue__c id  is not null 
        ***********************************************************************/ 
        system.assert(newPotentialQualityIssue.id!=null);
        ApexPages.StandardController sc = new ApexPages.StandardController(newPotentialQualityIssue );
        test.startTest();
        VFC41_Potential_Quality_Issue potentialQualityIssue= new VFC41_Potential_Quality_Issue (sc);
        potentialQualityIssue.Completed();
        newPotentialQualityIssue.PQI_Status__C = System.Label.CL146_UM_Review;
        update newPotentialQualityIssue;
        ApexPages.StandardController sc1 = new ApexPages.StandardController(newPotentialQualityIssue );
        VFC41_Potential_Quality_Issue potentialQualityIssue1= new VFC41_Potential_Quality_Issue (sc1);
        potentialQualityIssue1.rejectrecord();
        
        newPotentialQualityIssue.PQI_Status__C = System.Label.CL147_MD_Review;
        update newPotentialQualityIssue;
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(newPotentialQualityIssue );
        VFC41_Potential_Quality_Issue potentialQualityIssue2= new VFC41_Potential_Quality_Issue (sc2);
        potentialQualityIssue2.rejectrecord();
        
        newPotentialQualityIssue.PQI_Status__C = System.Label.CL154_PRC;
        update newPotentialQualityIssue;
        
        ApexPages.StandardController sc3 = new ApexPages.StandardController(newPotentialQualityIssue );
        VFC41_Potential_Quality_Issue potentialQualityIssue3= new VFC41_Potential_Quality_Issue (sc3);
        potentialQualityIssue3.rejectrecord();
        // comment is not null
        newPotentialQualityIssue.Comment_CMO__c ='test111';
        newPotentialQualityIssue.Comment_PRC__c = 'test111';
        newPotentialQualityIssue.Comment_UM__c = 'test111';
        newPotentialQualityIssue.PQI_Status__C = System.Label.CL146_UM_Review;
        update newPotentialQualityIssue;
        ApexPages.StandardController sc4 = new ApexPages.StandardController(newPotentialQualityIssue );
        VFC41_Potential_Quality_Issue potentialQualityIssue4= new VFC41_Potential_Quality_Issue (sc4);
        potentialQualityIssue4.rejectrecord();
        
        newPotentialQualityIssue.PQI_Status__C = System.Label.CL147_MD_Review;
        update newPotentialQualityIssue;
        ApexPages.StandardController sc5 = new ApexPages.StandardController(newPotentialQualityIssue );
        VFC41_Potential_Quality_Issue potentialQualityIssue5= new VFC41_Potential_Quality_Issue (sc5);
        potentialQualityIssue5.rejectrecord();
        
        newPotentialQualityIssue.PQI_Status__C = System.Label.CL154_PRC;
        update newPotentialQualityIssue;
        ApexPages.StandardController sc6 = new ApexPages.StandardController(newPotentialQualityIssue );
        VFC41_Potential_Quality_Issue potentialQualityIssue6= new VFC41_Potential_Quality_Issue (sc6);
        potentialQualityIssue6.rejectrecord();
        
        test.StopTest();
    }
     /*******************************************************************
    Purpose:   This method is used to Negative test approve record and this method is use for  Reject button and Reject prc button
    Parameters: N/A 
    Returns: PageReference 
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testMethod void rejectrecord_NegativeTest() {
        
        user us=AP01_TestDataUtility.createUserPQI();
        /*********************************************************************** 
        Verifying the User has been created successfully
        Expected Result: user id is not null
        Actual Result: user id  is not null 
        ***********************************************************************/ 
        system.assert(us.id!=null);

        Account assignedAccount =  AP01_TestDataUtility.createPortalAccount();
        /*********************************************************************** 
        Verifying the Account has been created successfully
        Expected Result: Account id is not null
        Actual Result: Account id  is not null 
        ***********************************************************************/ 
        system.assert(assignedAccount.id!=null);
        
        List<Contact> ContactToInsert = AP01_TestDataUtility.createContactListForPQI(assignedAccount);
        set<Id> setTestRecId = new set<Id>();
        for(Contact co : ContactToInsert){
            setTestRecId.add(co.id);
        }
        Potential_Quality_Issue__c   newPotentialQualityIssue = new Potential_Quality_Issue__c (Access_Availability__c =true,
                                                                                                Description_of_Events1__c ='Test Address',
                                                                                                Medical_Director_Recommendations__c ='test',
                                                                                                Medical_Director_Review_Summary1__c ='123123',
                                                                                                Member_ID__c =ContactToInsert[0].id,
                                                                                                Member_Name__c = 'test',
                                                                                                Member_Medical_Group_Affiliation__c ='Small',
                                                                                                Member_DOB__C =system.today(),
                                                                                                PCP_Practioner_Name__c ='Test',
                                                                                                Settings__c ='Office',
                                                                                                PQI_Status__C ='New',
                                                                                                Comment_CMO__c =null,
                                                                                                Comment_PRC__c = null,
                                                                                                Comment_UM__c = null,
                                                                                                bypass_cmo__c = false,
                                                                                                PQI_Referral_Date__c = system.today(),
                                                                                                PQI_Referred_By__c ='test',
                                                                                                Assigned_RN__c =us.id,
                                                                                                Reason_for_Referral__c ='test user',
                                                                                                RN_Timeline_of_Key_Events__c ='test rn',
                                                                                                RN_Case_Review_Summary1__c ='test summary',
                                                                                                RN_Justification_of_Recommendation__C ='test',
                                                                                                RN_Pertinent_criteria_guidelines_standa__c ='test critera',
                                                                                                Peer_Review_Credentialing_Outcome__c ='test',
                                                                                                PQI_Required_Field__C =true
                                                                                               );
        insert newPotentialQualityIssue;
        /*********************************************************************** 
        Verifying the Potential_Quality_Issue__c has been created successfully
        Expected Result: Potential_Quality_Issue__c id is not null
        Actual Result: Potential_Quality_Issue__c id  is not null 
        ***********************************************************************/ 
        system.assert(newPotentialQualityIssue.id!=null);
        ApexPages.StandardController sc = new ApexPages.StandardController(newPotentialQualityIssue );
        test.startTest();
        VFC41_Potential_Quality_Issue potentialQualityIssue= new VFC41_Potential_Quality_Issue (sc);
        potentialQualityIssue.Completed();
        newPotentialQualityIssue.PQI_Status__C = System.Label.CL146_UM_Review;
        update newPotentialQualityIssue;
        ApexPages.StandardController sc1 = new ApexPages.StandardController(newPotentialQualityIssue );
        VFC41_Potential_Quality_Issue potentialQualityIssue1= new VFC41_Potential_Quality_Issue (sc1);
        potentialQualityIssue1.rejectrecord();
        
        newPotentialQualityIssue.PQI_Status__C = System.Label.CL147_MD_Review;
        newPotentialQualityIssue.Comment_CMO__c = 'test';
        update newPotentialQualityIssue;
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(newPotentialQualityIssue );
        VFC41_Potential_Quality_Issue potentialQualityIssue2= new VFC41_Potential_Quality_Issue (sc2);
        potentialQualityIssue2.rejectrecord();
      
        test.StopTest();
    }
}