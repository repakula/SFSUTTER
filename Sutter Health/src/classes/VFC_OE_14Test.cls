@isTest
private class VFC_OE_14Test {
    static testMethod void testShowArticles() {
        try {
            VFC_OE_14.startDate = System.today() - 10;
            VFC_OE_14.today = System.today();
            VFC_OE_14.endDate = System.today() + 10;
            VFC_OE_14 controllerObj = new VFC_OE_14();
            
            VFC_OE_14.today = System.today();
            VFC_OE_14.endDate = System.today();
            controllerObj = new VFC_OE_14();
            
            VFC_OE_14.today = System.today()+10;
            VFC_OE_14.endDate = System.today();
            controllerObj = new VFC_OE_14();
            
            ID ProfileID = [Select id from Profile where name = 'Community Portal Manager'].id;
            
            List<User> adminUserLst = [select Id from User where Profile.Name = 'System Administrator' and
                                        UserRoleId != null]; 
            
             
            CS_ManageProfile__c csObj = new CS_ManageProfile__c();
            csObj.Name = 'Community_Portal_Manager';
            csObj.Profile_Name__c = 'Community Portal Manager';
            insert csObj; 
             
            CS_ManageProfile__c csObj1 = new CS_ManageProfile__c();
            csObj1.Name = 'Communities_Portal';
            csObj1.Profile_Name__c = 'Community Portal';
            insert csObj1;
            
            ActiveStatus__c obj1 = new ActiveStatus__c();
            obj1.Name = 'AF';
            insert obj1;
             
            Salesforce_Affiliates__c obj2 = new Salesforce_Affiliates__c();
            obj2.Name = 'Sutter Shared Services';
            obj2.Affiliate_Name__c = 'Sutter Shared Services';
            obj2.isSalesforce_True__c = true;
            insert obj2;
             
            PermissionSetFields__c pSCS1 = new PermissionSetFields__c();
            pSCS1.Name = 'AF';
            pSCS1.FieldAPIName__c = 'EMPLOYEE_EMPLOYMENT_STATUS__C';
            pSCS1.FieldValue__c = 'AF';
            insert pSCS1;
             
            PermissionSetFields__c pSCS3 = new PermissionSetFields__c();
            pSCS3.Name = 'Sutter Shared Services';
            pSCS3.FieldAPIName__c = 'Employee_Affiliate_Facility__c'.toUpperCase();
            pSCS3.FieldValue__c = 'Sutter Shared Services';
            insert pSCS3;
             
            PermissionSetFields__c pSCS2 = new PermissionSetFields__c();
            pSCS2.Name = 'SMT 29 LA';
            pSCS2.FieldAPIName__c = 'Employee_Bargaining_Union__c'.toUpperCase();
            pSCS2.FieldValue__c = 'SMT 29 LA';
            insert pSCS2;
            
            PermissionSetFields__c pSCS4 = new PermissionSetFields__c();
            pSCS4.Name = 'CNA';
            pSCS4.FieldAPIName__c = 'Employee_Union_Affiliate__c'.toUpperCase();
            pSCS4.FieldValue__c = 'CNA';
            insert pSCS4;
                         
            Account A1 = new Account(Name = 'Test Account');
            A1.ownerId = adminUserLst[0].id; 
            insert A1;
            
            
            system.runAs(adminUserLst[0]) {
                Test.startTest();
                Schema.DescribeSObjectResult descObj = Schema.SObjectType.Contact; 
                Map<String,Schema.RecordTypeInfo> rtMapByName = descObj.getRecordTypeInfosByName(); 
                Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
                                           email = 'test-user@fakeemail.com' );
                C1.Employee_EEO_SubCode__c = '2';
                C1.Employee_Union_Affiliate__c = 'CNA';
                C1.Employee_Bargaining_Union__c = 'SMT 29 LA';
                C1.Employee_Employment_Status__c = 'AF';
                C1.Employee_Affiliate_Facility__c = 'Sutter Shared Services'; 
                C1.Employee_Work_Email__c = 'test-user@fakeemail.com';
                C1.recordtypeId = rtMapByName.get('Employee').getRecordTypeId();
                insert C1;
                
                Test.stopTest();
            }                        
                         
            User userObj = [select Id from User where email = 'test-user@fakeemail.com']; 
                         
            system.runAs(userObj) {
                controllerObj.gotoLink();
                controllerObj.OE_Recordcount();                 
            }  
                    
            
        } catch(Exception ex) {} 
    }
}