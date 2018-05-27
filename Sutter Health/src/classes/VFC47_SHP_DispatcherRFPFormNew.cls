/* 
     Class Name: VFC47_SHP_DispatcherRFPFormNew 
     Author: IDC Offshore
     Date: 23-Feb-2016
     Description: Controller for VFP47_SHPDispatcherRFPFORMNew visualforce page to populate the oppty on New Incumbent Carrier record.
     
     History:
     VERSION    AUTHOR              DATE        DETAIL 

*/
public with sharing class VFC47_SHP_DispatcherRFPFormNew 
{
    public Incumbent_Carrier__c RFPForm;
    public static String RFPFORMRECTYPE = Label.SHP_RFPFORM_Record_Type;
   
    public VFC47_SHP_DispatcherRFPFormNew(ApexPages.StandardController controller) {
        this.controller = controller;
        RFPForm = (Incumbent_Carrier__c)controller.getRecord();
        
    }

/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: To fetch the opportunity and record type id of the incumbent carrier record and redirect to RFP Form Page         *
*   @param........:                                                             *    
*   @return ......: page url.                                                           *
*********************************************************************************/    
    public PageReference getredir() {

        PageReference newPage;
        
        Schema.DescribeSObjectResult ObjectDetail = Incumbent_Carrier__c.sObjectType.getDescribe();
        String ObjectId = ObjectDetail.getKeyPrefix(); //to get the prefix in order to construct the url.
        String RFPRecTypeId = Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(RFPFORMRECTYPE).getRecordTypeId();
        String recordType15digitId = RFPRecTypeId .substring(0, 15); //to remove the last 3 digits from recordTypeId.
        
        if ( recordType15digitId  == (ApexPages.currentPage().getParameters().get(System.Label.SHP_RFP_89))) {
            newPage = Page.VFP45_SHP_RFPForm;
            
            newPage.getParameters().put(System.Label.SHP_RFP_90,RFPForm.Id);
            newPage.getParameters().put(System.Label.SHP_RFP_87,ApexPages.currentPage().getParameters().get(Label.SHP_RFPForm_Opportunity_Lookup));
            newPage.getParameters().put(System.Label.SHP_RFP_86,ApexPages.currentPage().getParameters().get(System.Label.SHP_RFP_89));
            return newPage.setRedirect(true);
        } 
        else 
        {
        
            PageReference standardEditPage = new PageReference (System.Label.SHP_RFP_82+ObjectId+System.Label.SHP_RFP_91 +ApexPages.currentPage().getParameters().get(System.Label.SHP_RFP_89));
            standardEditPage.getParameters().put(Label.SHP_RFPForm_Opportunity,ApexPages.currentPage().getParameters().get(Label.SHP_RFPForm_Opportunity));
            standardEditPage.getParameters().put(Label.SHP_RFPForm_Opportunity_Lookup,ApexPages.currentPage().getParameters().get(Label.SHP_RFPForm_Opportunity_Lookup));
            standardEditPage.getParameters().put(System.Label.SHP_RFP_83,System.Label.SHP_RFP_85);
            return standardEditPage.setRedirect(true);
                    
        }
        
         
     }
   
    
    private final ApexPages.StandardController controller;
}