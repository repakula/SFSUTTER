/* 
     Class Name: VFC45_SHP_RFPForm_Test 
     Author: Prerna Chandak
     Date: 9-Mar-2016
     Description: Test class for VFC47_SHP_DispatcherRFPFormNew class.

*/
@isTest 

private class  VFC47_SHP_DispatcherRFPFormNew_Test{

    private static Account acc;
    private static Opportunity opp;
    private static Incumbent_Carrier__c inc;
    private static Incumbent_Carrier__c inc2;
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
    private static Id incRecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('RFP Form').getRecordTypeId();
    private static Id incRecordTypeId2 = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('Incumbent Carrier').getRecordTypeId();
 
/*Method to setup test data */
public static TestMethod void setupTestData(){
    incRecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('RFP Form').getRecordTypeId();
    incRecordTypeId2= Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('Incumbent Carrier').getRecordTypeId();
    Profile profile = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
    User user = new User(Alias = 'test', Email='test.user@sutter.com.pred',
    
    EmailEncodingKey='ISO-8859-1', LastName='Account Manager',LanguageLocaleKey='en_US',
    
    LocaleSidKey='en_US', ProfileId = profile .Id,TimeZoneSidKey='America/Los_Angeles',
    
    UserName='test.user@sutter.com.pred');
    insert user;
    
    acc = new Account();
    acc.Name = 'Test Account';
    acc.RecordTypeId = accRecordTypeId;
    acc.NumberOfEmployees = 50;
    acc.Industry = 'Test Industry';
    insert acc;
    
    opp = new Opportunity();
    opp.Name = 'Test Oppty';
    opp.AccountId = acc.id;
    opp.type = 'Test type';
    opp.CloseDate = Date.Today();
    opp.StageName = 'Pending Broker';
    opp.Current_Status__c = 'No';
    insert opp;
    
    inc = new Incumbent_Carrier__c();
    inc.RecordtypeId = incRecordTypeId ;
    inc.Opportunity__c = opp.id;
    insert inc;
    
    inc2 = new Incumbent_Carrier__c();
    inc2.RecordtypeId = incRecordTypeId2;
    inc2.Opportunity__c = opp.id;
    insert inc2; 
    
    List<Incumbent_Carrier__c> resultList1 = [Select Opportunity__r.name from Incumbent_Carrier__c  where  id=: inc.id];
    List<Incumbent_Carrier__c> resultList2 = [Select Opportunity__r.name from Incumbent_Carrier__c  where  id=: inc2.id];
    
    system.assertEquals('Test Oppty', resultList1[0].Opportunity__r.name);
    system.assertEquals('Test Oppty', resultList2[0].Opportunity__r.name);
    
}

/*Method to when record type is RFP Form*/
public static TestMethod void redirectTestPositive(){
    Test.startTest(); 
    setupTestData();
    ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(inc);
    String recTypeId = inc.RecordTypeId;
    String finalRectype = recTypeId.substring(0, 15);
    ApexPages.currentPage().getParameters().put('Id',inc.id);
    ApexPages.currentPage().getParameters().put('RecordType',finalRectype );
    
    VFC47_SHP_DispatcherRFPFormNew controller = new VFC47_SHP_DispatcherRFPFormNew(sc);
    controller.getredir();
    PageReference pageRef = Page.VFP45_SHP_RFPForm;
    pageRef.getParameters().put('Id', inc.id);
    pageRef.getParameters().put('OpportunityId', opp.id); 
    pageRef.getParameters().put('RecordType', finalRectype );
    Test.setCurrentPage(pageRef);
    
    system.assertEquals(incRecordTypeId ,inc.recordTypeId);
    Test.stopTest();

}


/*Method to when record type is Incumbent Carrier*/
public static TestMethod void redirectTestNegative(){
    Test.startTest(); 
    setupTestData();
    Schema.DescribeSObjectResult ObjectDetail = Incumbent_Carrier__c.sObjectType.getDescribe();
    String ObjectId = ObjectDetail.getKeyPrefix();
    ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(inc2);
    ApexPages.currentPage().getParameters().put('Id',inc2.id);
    VFC47_SHP_DispatcherRFPFormNew  controller = new VFC47_SHP_DispatcherRFPFormNew (sc);
    
    controller.getRedir();
    PageReference pageRef = new PageReference('+'+ObjectId+'/e');
    
    pageRef.getParameters().put('Id', inc2.id);
    Test.setCurrentPage(pageRef);
    
    system.assertEquals(incRecordTypeId2 ,inc2.recordTypeId);
    Test.stopTest();
     
    } 
        

    
}