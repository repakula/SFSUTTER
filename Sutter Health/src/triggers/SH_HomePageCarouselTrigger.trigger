trigger SH_HomePageCarouselTrigger on SH_HomePage_carousel__c (before insert, before update) {
    SH_Trigger_Settings__c triggerSettings = SH_Trigger_Settings__c.getValues('SH_HomePageCarouselTrigger');
    
    if(triggerSettings == null || (triggerSettings != null && triggerSettings.SH_Is_Active__c == false)) return;
    
    integer maxPublishCount = triggerSettings.SH_Max_Publish_Count__c != null ? integer.valueOf(triggerSettings.SH_Max_Publish_Count__c): 10;
    SH_HomePageCarouselTriggerHandler triggerHandler = new SH_HomePageCarouselTriggerHandler();
    
    if(trigger.isBefore) {
        
        if(trigger.isInsert) triggerHandler.onBeforeInsert(trigger.New, maxPublishCount);
        
        if(trigger.isUpdate) triggerHandler.onBeforeUpdate(trigger.New, trigger.oldMap, maxPublishCount);
    }
}