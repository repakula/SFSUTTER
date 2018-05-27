trigger SH_HomePageHeadlinerTrigger on SH_Home_Page_Headliner__c (before insert, before update) {
    SH_Trigger_Settings__c triggerSettings = SH_Trigger_Settings__c.getValues('SH_HomePageHeadlinerTrigger');
    
    if(triggerSettings == null || (triggerSettings != null && triggerSettings.SH_Is_Active__c == false)) return;
    
    integer maxPublishCount = triggerSettings.SH_Max_Publish_Count__c != null ? integer.valueOf(triggerSettings.SH_Max_Publish_Count__c): 3;
    SH_HomePageHeadlinerTriggerHandler triggerHandler = new SH_HomePageHeadlinerTriggerHandler();
    
    if(trigger.isBefore) {
        
        if(trigger.isInsert) triggerHandler.onBeforeInsert(trigger.New, maxPublishCount);
        
        if(trigger.isUpdate) triggerHandler.onBeforeUpdate(trigger.New, trigger.oldMap, maxPublishCount);
    }
}