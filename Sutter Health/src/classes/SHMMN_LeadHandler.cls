/*********************************************************************************************  
*     Class Name  : SHMMN_LeadHandler                                                        
*     Author      : Umesh Vajpai                                                           
*     Date        : 08-Aug-2016                                                              
*     Project Name: CRM - SFT - Sutter Health                                                        
*     Description : Handler class for SHMMN Lead Trigger.                                                         
**********************************************************************************************/

public class SHMMN_LeadHandler{

  
    public enum triggerredEvent {beforeInsert, beforeUpdate, afterInsert, afterUpdate}
        
    public void OwnershipAssignment(List<Lead> newLeads, Map<Id,Lead> oldMap, triggerredEvent tEvent)
    {
        List<Lead> updateLeads = new List<Lead>();
        
        system.debug('***************'+newLeads);
        system.debug('***************'+oldMap);
        system.debug('***************'+tEvent);
        
        if(AP01_TestDataUtility.runOnce)
        {
            for(Lead newLead : newLeads)
            {
                
               
                if(newLead.RecordTypeId == Schema.SObjectType.Lead.getRecordTypeInfosByName().get('SHMMN Lead').getRecordTypeId() && newLead.Status !='Approved' && newLead.Status !='Rejected')
                {
                    if(tEvent == triggerredEvent.beforeInsert)
                    {
                        newLead.Lead_Assigned__c = newLead.ownerId;
                    }
                    
                    if(tEvent == triggerredEvent.afterUpdate)
                    {
                        if(String.valueOf(newLead.ownerId).startsWith('00G') )
                        {
                            Lead dupLead = new Lead(Id=newLead.Id);
                            dupLead.Lead_Assigned__c = oldMap.get(newLead.Id).ownerId;
                            dupLead.Skip_Validation__c =true;
                            updateLeads.add(dupLead);
                        }
                        
                        else
                        if(!String.valueOf(oldMap.get(newLead.Id).ownerId).startsWith('00G'))
                        {
                            Lead dupLead = new Lead(Id=newLead.Id);
                            dupLead.Lead_Assigned__c = newLead.ownerId;
                            dupLead.Skip_Validation__c =true;
                            updateLeads.add(dupLead);
                        }
                    }
                }
                if(!updateLeads.isEmpty())
                {
                    AP01_TestDataUtility.runOnce = false;
                    
                    update updateLeads;
                }
            }
        }
    }

}