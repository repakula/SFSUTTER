/**********************************************************************
Name: LeadTrigger()
======================================================
======================================================
Purpose:
This trigger manage candidate connect task for candidate type lead.
======================================================
======================================================
History
-------
VERSION             AUTHOR              DATE                DETAIL                  Description
1.0                 Sandeep Sharma      05-11-2015      INITIAL DEVELOPMENT         This trigger runs on the insert and update of lead. It is used to manage 30/60/90 days candidate connect
                                                                                    task for candidate lead
1.1                 Umesh Vajpai        Aug 8, 2016     Added SHMMN code            Added method call to store lead last owner
                                                                                    details                                                             

***********************************************************************/

trigger LeadTrigger on Lead( before insert, before update, after insert, after update) {
    
    SHMMN_LeadHandler shmmnleadhandler = new SHMMN_LeadHandler();
    //after trigger block
    if (Trigger.isAfter) {
        //Instantiate the handler class
        LeadTiggerHandler leadHandler = new LeadTiggerHandler();
        
        // after insert
        if (trigger.isInsert) {
                leadHandler.manageTasks(Trigger.newMap,Trigger.OldMap,LeadTiggerHandler.triggerredEvent.afterInsert);
        }
        
        //after update
        if (trigger.isUpdate) { 
                leadHandler.manageTasks(Trigger.newMap,Trigger.OldMap,LeadTiggerHandler.triggerredEvent.afterUpdate);
                
                //SHMMN Ownership
                shmmnleadhandler.OwnershipAssignment(Trigger.new,Trigger.oldMap,SHMMN_LeadHandler.triggerredEvent.afterUpdate);
        }
    }
    
    
    if (Trigger.isBefore) {
        // Lead Ownership Assignment
        if (Trigger.isInsert){
            shmmnleadhandler.OwnershipAssignment(Trigger.new,Trigger.oldMap,SHMMN_LeadHandler.triggerredEvent.beforeInsert);
        }
    }
}