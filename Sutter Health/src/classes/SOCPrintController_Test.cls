@isTest
class SOCPrintController_Test {
    
    /**
    * @author Atul Gupta
    * @date 04/28/2014
    * @description This method tests for Printing out Provider Summary Address as PDF
    * @param 
    * @return
    */
    static testMethod void testProviderPrint(){
            
            createdDateCustSetting();
            
            Account acc = createAccount();
            //assert to check Account is created successfully
            system.assert(acc.id!=null);
            Contact cont = createProviderContact(acc);
            //assert to check Contact is created successfully
            system.assert(cont.id!=null);
            
            Contact_Validation_Summary__c proSummary = createProviderSummary(cont);
            //Assert to check Contact Validation summary is created successfully
            system.assert(proSummary.id!=null);
            
            PageReference pdfPage = new PageReference('/apex/VF_SOC_print_address?Id=' + proSummary.Id + '&socName=' + 'Test SOC');
            Test.setCurrentPage(pdfPage);
            
            SOCPrintController controller = new SOCPrintController();
    }
    
    /**
    * @author Atul Gupta
    * @date 04/28/2014
    * @description This method tests for Printing out EAF Facility Address as PDF
    * @param 
    * @return
    */
    static testMethod void testEAFPrint(){
        
        createdDateCustSetting();
        Account acc = createAccount();
        //assert to check Account is created successfully
        system.assert(acc.id!=null);
        Contact cont = createProviderContact(acc);
        //assert to check Contact is created successfully
        system.assert(cont.id!=null);
        
        PDV_EAF_Facility__c facility = createEAFRecord();
        // Assert to check facility record  is created successfully
        system.assert(facility.id!=null);
        PageReference pdfPage = new PageReference('/apex/VF_SOC_print_address?id=' + facility.Id + '&socName=' + 'Test SOC');
        Test.setCurrentPage(pdfPage);
        
        SOCPrintController controller = new SOCPrintController();
        
    }
    
    /**
    * @author Atul Gupta
    * @date 04/28/2014
    * @description Create EAF Facility record
    * @param 
    * @return 
    */
    public static PDV_EAF_Facility__c createEAFRecord(){
    
        PDV_EAF_Facility__c eaf = new PDV_EAF_Facility__c();
        eaf.Name = 'EAF Name';
        eaf.ADDRESS__c = 'EAF Address';
        eaf.Suite__c = 'EAF Suite';
        eaf.Floor__c = 'EAF Floor';
        eaf.CITY__c = 'EAF City';
        eaf.STATE__c = 'EAF State';
        eaf.ZIP_CODE__c = 'EAF Zip Code';
        
        insert eaf;
        // Assert to check PDV EAF record is created succesfully
        system.assert(eaf.id!=null);
        
        return eaf;
    }
    
    /**
    * @author Atul Gupta
    * @date 04/28/2014
    * @description This is a utility method to create a 'Provider' type Contact
    * @param Account 
    * @return Contact
    */
    public static Contact createProviderContact(Account acc){
    
        Contact con = new Contact();
        con.AccountId = acc.id;
        con.LastName =  'LastName';
        con.RecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Provider').RecordTypeId;
        con.Member_HR_ID__c = '12345';
        con.Member_PCP_Practitioner_HR_ID__c = '23456';
        insert con;
        // assert to check Contact is created successfully
        system.assert(con.id!=null);
        return con;
    }
    
    /**
    * @author Atul Gupta
    * @date 04/28/2014
    * @description This method create test data for Account.
    * @param 
    * @return 
    */
    public static Account createAccount(){
    
        Account acc = new Account();
        acc.Name = 'Test Acount';
            
        insert acc;
        //assert to check Account is created successfully
        system.assert(acc.id!=null);
        
        return acc;
    }
    
    /**
    * @author Atul Gupta
    * @date 04/28/2014
    * @description Create Provider Summary record
    * @param 
    * @return 
    */
    public static Contact_Validation_Summary__c createProviderSummary(Contact con){
    
        Contact_Validation_Summary__c summary = new Contact_Validation_Summary__c();
        summary.Name = 'Summary Record 01';
        summary.Printed_Contact_Name__c = 'Printed Contact';
        summary.Printed_Street_Address__c = 'Printed Address';
        summary.Printed_Suite__c = 'Printed Suite';
        summary.Printed_Floor__c = 'Printed Floor';
        summary.Printed_City__c = 'Printed City';
        summary.Printed_State__c = 'CA';
        summary.Printed_Zip_Code__c = 'Printed ZipCode';
        summary.Contact_Id__c = con.Id;
        insert summary;
        // assert to check Contact validation summary record is created succesfully
        system.assert(summary.id!=null);
        
        return summary;
    }
    
    /**
    * @author Atul Gupta
    * @date 04/28/2014
    * @description Create CreatedDate__c custom setting
    * @param 
    * @return 
    */
    public static CreatedDate__c createdDateCustSetting(){
    
        CreatedDate__c createdDate = new CreatedDate__c();
        createdDate.Name = 'CopyPcpDate';
        createdDate.Created_date__c = date.today();
        insert createdDate;
        //Assert to check Custom setting records are created successfully
        system.assert(createdDate.id!=null);
        
        return createdDate;
    }
}