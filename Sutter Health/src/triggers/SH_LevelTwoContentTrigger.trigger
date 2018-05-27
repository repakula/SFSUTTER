trigger SH_LevelTwoContentTrigger on SH_Level_2_Content__c (before insert, before update) 
{
    SH_Trigger_Settings__c triggerSettings = SH_Trigger_Settings__c.getValues('SH_LevelTwoContentTrigger');
     if(triggerSettings == null || (triggerSettings != null && triggerSettings.SH_Is_Active__c == false)) return;
     
     SH_LevelTwoContentTriggerHandler objHandler = new SH_LevelTwoContentTriggerHandler();
     
     if(trigger.isInsert)  
     {
         objHandler.OnBeforeInsert(trigger.new);
     }
     else
     {
     	objHandler.OnBeforeUpdate(trigger.new, trigger.oldMap);
     }
}