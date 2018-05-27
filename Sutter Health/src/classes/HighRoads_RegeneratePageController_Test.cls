/* 
     Class Name: HighRoads_DocGenRequest_Test 
     Author: IDC Offshore
     Date: 01-Dec-2016
     Description: Test class for HighRoads_DocGenRequest Controller.
    Version          Name            Date                Description
   2.0           Deloitte    15-03-2017      Incresed the test coverage
*/
@isTest
public class HighRoads_RegeneratePageController_Test 
{
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Sales Employer').getRecordTypeId();
    private static Id incRecordTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get('RFP Form').getRecordTypeId();
    private static Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SHP Sales Opportunity').getRecordTypeId();
    public static TestMethod void Method_1()
    {
        List<SF_P2A_Market_Segments_Mapping__c> listp2amarketseg1 = HighRoads_TestDataUtility.insertP2AMarketSegmentsCS();
        insert listp2amarketseg1;
        HighRoads_TestDataUtility.DocGenReqforInd();
        
        Account acc = new Account(Name = 'Account1',RecordTypeId = accRecordTypeId,NumberOfEmployees = 50,Industry = 'Hospitaity',Employer_Type__c = 'Large Group (251-1000)');
        insert acc;
        
        Opportunity opp = new Opportunity( Name = 'Test Opp',AccountId = acc.id,RecordTypeId = oppRecordTypeId,type = 'New Business',CloseDate = Date.Today(),
                                StageName = 'Closed Won',Renewed_Opportunity__c = false,regenerate__c = true);        
        Opportunity opp2 = opp.clone();
        insert new list<Opportunity>{opp,opp2};

        Incumbent_Carrier__c rfp = new Incumbent_Carrier__c(RecordtypeId = incRecordTypeId,Opportunity__c = opp.id);
        insert rfp;

        Proposal__c quote = new Proposal__c(Opportunity_ID__c = opp.id,RFP_Form__c = rfp.id);
        insert quote;
        
        Sold_Sign_Off__c sso = new Sold_Sign_Off__c(Opportunity_ID__c = opp.id,Quote__c = quote.id,Stage__c = 'Approved by Underwriting',regenerate__c = true,
                                                    SSO_RSO_Due_Date__c = Date.today()+30);

        Sold_Sign_Off__c sso2 = sso.clone();
        insert new list<Sold_Sign_Off__c>{sso,sso2};

        insert new list<Document_Generation_Request__c>{new Document_Generation_Request__c(Opportunity__c = opp.ID),
                                                        new Document_Generation_Request__c(Sold_Sign_Off__c = sso.ID)};

        PageReference PR = Page.HighRoads_RegeneratePage; // Add your VF page Name here
        PR.getParameters().put(System.label.HR144_id, String.valueOf(opp.Id));
        Test.setCurrentPage(PR);
        HighRoads_RegeneratePageController H = new HighRoads_RegeneratePageController();
        H.checkDocGenExists();
        H.createRecord();

        PageReference PR2 = Page.HighRoads_RegeneratePage; // Add your VF page Name here
        PR2.getParameters().put(System.label.HR144_id, String.valueOf(sso.Id));
        Test.setCurrentPage(PR2);
        HighRoads_RegeneratePageController H2 = new HighRoads_RegeneratePageController();
        H2.checkDocGenExists();
        H2.createRecord();

        PageReference PR3 = Page.HighRoads_RegeneratePage; // Add your VF page Name here
        PR3.getParameters().put(System.label.HR144_id, String.valueOf(opp2.Id));
        Test.setCurrentPage(PR3);
        HighRoads_RegeneratePageController H3 = new HighRoads_RegeneratePageController();
        H3.checkDocGenExists();

        PageReference PR4 = Page.HighRoads_RegeneratePage; // Add your VF page Name here
        PR4.getParameters().put(System.label.HR144_id, String.valueOf(sso2.Id));
        Test.setCurrentPage(PR4);
        HighRoads_RegeneratePageController H4 = new HighRoads_RegeneratePageController();
        H4.checkDocGenExists();
        
        system.debug(H4.isErrorOccured);
    }
}