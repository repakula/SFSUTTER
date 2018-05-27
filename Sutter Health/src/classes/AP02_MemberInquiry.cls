/**  
*    Class Name: AP02_MemberInquiry
*    Author: IDC Sutter Health Team
*    Date: 12/31/2014
*    Description: Helper class for MemberInquiryTrigger trigger. Includes functionlality invoked on any DML operation
*
*    History
*    VERSION    AUTHOR              DATE        DETAIL 
*
*    --------
**/
public with sharing class AP02_MemberInquiry {
    
    /** @Description: static final variables to hold contact values and strings **/
    private static final string BLANK_STRING = '';
    private static final string SPLIT_FROM = ',';
    private static final string REPLACE_STRING = '\\s+';
    private static final string EXEPTION_MSG = '\r\n';
    private static final string EXEPTION_MSG1 = '--------------';
    private static final string REASON_CLINICAL = 'Clinical';
    private static final string CONTACT_RT_MEMBER = 'Member';
    private static final string CONTACT_RT_SHP_PROVIDER = 'SHP Provider';
    private static final string SEC_REASON_OUT_OF = 'Out of';
    private static final string MEM_INQ_ERROR = 'You cannot choose the same type of Contact as the Parent IL. Example: If Provider is selected on the IL, Member must be entered on Customer Inquiries By Others.';
    private static final string ED_NOTIFICATON = 'ED Notification';
     
            
    /**
    *   @Description: method invoked by Member Inquiry trigger in after insert context, this method updates the automatically created
    *                       SR's Facility name or Member Name and its corresponding fields
    *   @Arguments: List of Member Enquiries(trigger.new), Map of Member Inquiries(trigger.newMap)
    *   @Return: Void
    **/
    public static void updateOOASR_Member_fields(List<Member_Enquiries__c> triggernew, Map<Id, Member_Enquiries__c> triggerNewMap) {
        
        try{
            
            /** @Description: Collections declared/instantiated to be used in the method **/
            Integer age;
            Set<Id> memInquiryIds = new Set<Id>();
            List<Case> updateSRList = new List<Case>();
            Map<Id, Member_Enquiries__c> IL_IdMemInqMap = new Map<Id, Member_Enquiries__c>();
            Map<Id, Member_Enquiries__c> SR_IdMemInqMap = new Map<Id, Member_Enquiries__c>();
            List<Case> casesToUpdateList = new List<Case>();
            
            /** @Description: iterate over inserted records of memeber inquiries **/
            for(Member_Enquiries__c memInq : triggernew) {
                
                /** @Description: if the record is related to a case **/
                if(memInq.Case__c <> null){
                    
                    /** @Description: add the record id to the SET **/
                    memInquiryIds.add(memInq.id);
                }
            }
            
            /** @Description: if SET of inserted member ids is not empty **/
            if(!memInquiryIds.isEmpty()){
                
                /** @Description: query record fields, its related IL's Contact's fields and related Member/Provider fields **/
                for(Member_Enquiries__c mem : [Select Case__c, Case__r.Contact.RecordtypeId, Case__r.Secondary_Reason__c, Case__r.Reason__c, Member_Id__r.Name, Member_Id__r.Birthdate, Member_Id__r.Phone, Member_Id__r.Member_PCP_Name_Full__c, 
                                                Member_Id__r.Member_Group_Affiliation__c, Member_Id__r.Member_ID__c, Member_Id__r.RecordtypeId
                                                from Member_Enquiries__c where Id IN : memInquiryIds])
                {
                    
                    /** @Description: capture the value of related IL's secondary reason **/
                    String secReasonStr = (String)mem.Case__r.Secondary_Reason__c;
                    
                    /** @Description: if related IL's reason and secondary reason satisfy the condition **/
                    if(mem.Case__r.Reason__c == REASON_CLINICAL && (secReasonStr.contains(SEC_REASON_OUT_OF) || secReasonStr == ED_NOTIFICATON)){
                        
                        /** @Description: if related IL's contact and Member/Provider contact are of same Recordtype **/
                        if(mem.Case__r.Contact.RecordtypeId == mem.Member_Id__r.RecordtypeId){
                            
                            /** @Description: show an error **/
                            triggerNewMap.get(mem.Id).addError(MEM_INQ_ERROR);
                        }
                        
                        /** @Description: else add the IL ID and member inq to the map **/
                        else{
                    
                            IL_IdMemInqMap.put(mem.Case__c, mem);
                        }
                    }
                }
            
            }
            
            /** @Description: if IL id and member inq map is not empty  **/
            if(!IL_IdMemInqMap.isEmpty()){
                
                /** @Description: query the SR's related to the IL **/
                updateSRList = [Select Id, ParentId, Contact.RecordtypeId from Case where ParentId IN : IL_IdMemInqMap.keyset()];
            }
            
            /** @Description: if related SR list is not empty **/
            if(!updateSRList.isEmpty()){
                
                /** @Description: iterate of related SR list **/
                for(Case caseSR : updateSRList){
                    
                    /** @Description: if IL ID and SR's Parent Case ID are same **/
                    if(IL_IdMemInqMap.containsKey(caseSR.ParentId)){
                        
                        /** @Description: populate the map of SR ID and member inquiries **/
                        SR_IdMemInqMap.put(caseSR.Id, IL_IdMemInqMap.get(caseSR.ParentId));
                    }
                }
                
                /** @Description: if SR ID and member inq map is not empty **/
                if(!SR_IdMemInqMap.isEmpty()){
                    
                    /** @Description: iterate over the list of SRs **/
                    for(Case caseSR : updateSRList){
                        
                        if(SR_IdMemInqMap.containsKey(caseSR.Id)){
                            
                            /** @Description: if SR's contact is of Provider type **/
                            if(caseSR.Contact.RecordtypeId == Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT_SHP_PROVIDER).RecordTypeId){
                                
                                /** @Description: Populate the member fiels of SR **/
                                caseSR.Member_DOB_OOA_OON__c = SR_IdMemInqMap.get(caseSR.Id).Member_Id__r.Birthdate;
                                
                                caseSR.Member_Name_OOA_OON__c = SR_IdMemInqMap.get(caseSR.Id).Member_Id__c;
                                
                                
                                caseSR.Member_Phone__c = SR_IdMemInqMap.get(caseSR.Id).Member_Id__r.Phone;
                                caseSR.Member_PCP__c = SR_IdMemInqMap.get(caseSR.Id).Member_Id__r.Member_PCP_Name_Full__c;
                                caseSR.Medical_Group__c = SR_IdMemInqMap.get(caseSR.Id).Member_Id__r.Member_Group_Affiliation__c;
                                
                                caseSR.Member_ID_OOA_OON__c = SR_IdMemInqMap.get(caseSR.Id).Member_Id__r.Member_ID__c;
                                
                                if(SR_IdMemInqMap.get(caseSR.Id).Member_Id__r.Birthdate <> null)
                                {
                                    age = ((SR_IdMemInqMap.get(caseSR.Id).Member_Id__r.Birthdate).monthsBetween(System.today()))/12;
                                }
                                caseSR.Member_Age__c = String.valueOf(age);
                                casesToUpdateList.add(caseSR);
                            }
                            
                            /** @Description: else if SRs Contact is of member type, populate the provider field **/
                            else if(caseSR.Contact.RecordtypeId == Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RT_MEMBER).RecordTypeId){
                                
                                caseSR.Facility_Name_OOA_OON__c = SR_IdMemInqMap.get(caseSR.Id).Member_Id__c;
                                
                                casesToUpdateList.add(caseSR);
                            }
                        }
                    }
                }
            }
            
            /** @Description: if the case update list is not empty **/
            if(!casesToUpdateList.isEmpty()){
                
                /** @Description: update the SRs **/
                Database.update(casesToUpdateList);
            }
            
        /** @Description: catch block to catch any exceptions **/
        } catch(Exception classException){
            Utility.handleExceptionFromCode(classException.getMessage() + EXEPTION_MSG + classException.getStackTraceString() + EXEPTION_MSG  + classException.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
        }
    }
}