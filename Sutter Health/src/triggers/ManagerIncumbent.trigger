/*****************************************************************************************************************************************
*  Trigger Name: ManagerIncumbent
*  Author: IDC
*  Date: 27-Apr-2016
*  Description: This trigger is useful to manage SHMMN Incumbent Carrier on SHMMN Employer Account and check for duplicate records.
*
*  History
*  --------------------------------------------------------------------------------------------------------------------------------------
*  
*  VERSION     AUTHOR     DATE       DETAIL
*    1.0        IDC     27-04-2016   Check for duplicate SHMMN Incumbent records.
*
******************************************************************************************************************************************/
trigger ManagerIncumbent on SHMMN_Incumbent_Carrier__c (after update) 
    {

        List <SHMMN_Incumbent_Carrier__c > incumbentList = new List<SHMMN_Incumbent_Carrier__c >();
        Decimal sum = 0.00;
        Set<ID> ids = Trigger.newMap.keySet();
        Set<ID> accid = new Set<Id>();
        Set<String> mergeIncumbent = new Set<String>();
        for(SHMMN_Incumbent_Carrier__c sh: [select Account__c from SHMMN_Incumbent_Carrier__c where id in : (ids) limit 50000])
            {
                accid.add(sh.Account__c);
            }
        incumbentList = [select id,contain__c,Incumbent_Carrier__c,Sub_Product__c,Account__c   from SHMMN_Incumbent_Carrier__c where Account__c IN :(accid) limit 50000];

        /**@ Description: Check for duplicate records based on Incumbent Carrier and Sub product. 
                    Calculate sum of all Incumbent records on an account.**/
         for(SHMMN_Incumbent_Carrier__c sic: incumbentList )
             {
                if(sic.Incumbent_Carrier__c != null && sic.Sub_Product__c != null)
                  {
                     String dupCheck = sic.Incumbent_Carrier__c + sic.Sub_Product__c + sic.Account__c;
                     mergeIncumbent.add(dupCheck);
                  }  
                 if(sic.contain__c != null)
                 sum =sum + sic.contain__c ;
             }
        /**@ Description: Check if sum of % of all incumbent carrier records is more than 100%. 
                    Throw error message if sum is greater than 100%.**/
        if(sum >100)
            {
            for(SHMMN_Incumbent_Carrier__c sic: Trigger.new)
                {
                    sic.addError(System.Label.CL_42_SM_IncumbentErrorMsg);
                }

            }
        /**@ Description: Check if there are duplicate records in Incumbent Carrier records. 
            Throw error message if user is trying to update data with duplicate details.**/
        if(mergeIncumbent.size() != incumbentList .size())
            {
            for(SHMMN_Incumbent_Carrier__c sic: Trigger.new)
                {
                    sic.addError(System.Label.CL_74_SM_IncumbentDupErrorMsg);
                }
            }
    }