/* 
     Class Name: VFC46_SHP_DispatcherRFPEdit 
     Author: IDC Offshore
     Date: 23-Feb-2016
     Description: Controller for VFP46_SHP_DispatcherRFPEdit visualforce page to populate the oppty on Edit of Incumbent Carrier record.
     
     History:
     VERSION    AUTHOR              DATE        DETAIL 
*/

public with sharing class VFC46_SHP_DispatcherRFPEdit {
    private final ApexPages.StandardController controller;
    private static String RFPFORMRECTYPE = Label.SHP_RFPFORM_Record_Type;

    public VFC46_SHP_DispatcherRFPEdit(ApexPages.StandardController controller) {
        this.controller = controller;
    }

/********************************************************************************
*   @author ......: IDC Team                                                    *  
*   @date ........: 23-Feb-2016                                                 *  
*   @description .: To fetch the opportunity and record type id of the incumbent carrier record and redirect to RFP Form Page         *
*   @param........:                                                             *    
*   @return ......: page url.                                                           *
*********************************************************************************/ 
    public PageReference getRedir() {
       //To fetch the id, recordtypeId and opportunityId of Incumbent carrier record.
       Incumbent_Carrier__c ObjRec = [Select Id, RecordTypeId,Opportunity__c FROM Incumbent_Carrier__c  WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
       
       PageReference newPage;
      
       if(ObjRec.RecordTypeId == Schema.SObjectType.Incumbent_Carrier__c.getRecordTypeInfosByName().get(RFPFORMRECTYPE).getRecordTypeId()) {
           newPage = Page.VFP45_SHP_RFPForm;
          
           newPage.getParameters().put('OpportunityId',ObjRec.Opportunity__c);
           newPage.getParameters().put('RecordTypeId',ObjRec.RecordTypeId);
          
       }else {
           newPage = new PageReference('/' + ObjRec.id + '/e');
           newPage.getParameters().put( 'retURL', ObjRec.id);
           newPage.getParameters().put('nooverride', '1');
       }
       
        newPage.getParameters().put('Id',ObjRec.Id);
        return newPage.setRedirect(true); 
    }

}