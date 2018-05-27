/**********************************************************************
Name: LeadTiggerHandler
======================================================
======================================================
Purpose:
This class manage candidate connect task for candidate type lead. Lead trigger calls this class.
======================================================
======================================================
History
-------
VERSION             AUTHOR              DATE                DETAIL                  Description
1.0                 Sandeep Sharma      05-11-2015      INITIAL DEVELOPMENT         This class manage candidate connect task for candidate type lead. It is used to manage 30/60/90         days                                                                                candidate connect task for candidate lead
***********************************************************************/

public class LeadTiggerHandler{

        Map<string, string> leadRecordTypeMap = null;
        public enum triggerredEvent {beforeInsert, beforeUpdate, afterInsert, afterUpdate}

        /*******************************************************************
        Purpose: This function calls handler methods to manage candidate tasks.
        Parameters: List<Lead>
        Returns: NA
        Throws [Exceptions]: NA
        ********************************************************************/
        public void manageTasks(Map<Id,Lead> newMap, Map<Id,Lead> oldMap,triggerredEvent tEvent)
        {
            leadRecordTypeMap = new Map<string, string>();
            //get the Lead record Types
            for(RecordType rec:[select Id , name from RecordType where sObjectType = 'Lead']) 
            {
                leadRecordTypeMap.put(rec.Name, rec.Id);
            }
            
            // Iterate through leads and filter all Condidate Records
            List<Lead> newLeads =  new List<Lead>();
            for(Lead loopLead: newMap.values())
            {
                if(loopLead.RecordTypeId == leadRecordTypeMap.get('Candidate')){
                    newLeads.add(loopLead); 
                }
            }
            
            LeadTaskHandler handler = new LeadTaskHandler();
            //after insert
            if(tEvent == triggerredEvent.afterInsert)
            {
                 handler.manageTaskAfterLeadInsert(newLeads);
            }
            
            //after update
            if(tEvent == triggerredEvent.afterUpdate)
            {
                handler.manageTaskAfterLeadUpdate(newLeads, newMap, oldMap);
            }
        }
    }