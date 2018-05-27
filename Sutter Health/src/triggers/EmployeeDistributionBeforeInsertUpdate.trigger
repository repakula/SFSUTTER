trigger EmployeeDistributionBeforeInsertUpdate on Account_Employee_Distribution__c (before insert, before update)
{
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            Set<Id> parentAccountIdSet = new Set<Id>();
            List<Account_Employee_Distribution__c> empList = new List<Account_Employee_Distribution__c>();
            
            for(Account_Employee_Distribution__c emp : trigger.new)
            {
                parentAccountIdSet.add(emp.Account__c);        
            }
            
            empList = [Select Region__c, County__c, Account__c from Account_Employee_Distribution__c where Account__c IN : parentAccountIdSet];
            
            for(Account_Employee_Distribution__c emp : Trigger.new)
            {
                String regionCountyNew = emp.Region__c + emp.County__c;
                for(Account_Employee_Distribution__c empDist : empList)
                {
                    String regionCountyValue = empDist.Region__c + empDist.County__c;
                    if(regionCountyNew == regionCountyValue)
                    {
                        emp.addError('Record already exists with same Region and County');
                    }
                }
            }
        }
    }
    
    if(Trigger.isBefore)
    {
        if(Trigger.isUpdate)
        {
            Set<Id> parentAccountIdSet = new Set<Id>();
            List<Account_Employee_Distribution__c> empList = new List<Account_Employee_Distribution__c>();
            
            for(Account_Employee_Distribution__c emp : trigger.new)
            {
                if(trigger.newMap.get(emp.id).County__c <> trigger.oldMap.get(emp.id).County__c)
                {
                    parentAccountIdSet.add(emp.Account__c);
                }
            }
            
            if(!parentAccountIdSet.isEmpty())
            {
                empList = [Select Region__c, County__c, Account__c from Account_Employee_Distribution__c where Account__c IN : parentAccountIdSet];
            }
            
            if(!empList.isEmpty())
            {
                for(Account_Employee_Distribution__c emp : Trigger.new)
                {
                    String regionCountyNew = emp.Region__c + emp.County__c;
                    for(Account_Employee_Distribution__c empDist : empList)
                    {
                        String regionCountyValue = empDist.Region__c + empDist.County__c;
                        if(regionCountyNew == regionCountyValue)
                        {
                            emp.addError('Record already exists with same Region and County');
                        }
                    }
                }
            }   
        }
    }
}