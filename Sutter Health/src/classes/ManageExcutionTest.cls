/**  
*     Class Name: ManageExecutionsTest
*     Author: Saket mohan Jha
*     Date: 20-December-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description: This class is defined to test ManageExcution class.
*     
*    History
*    --------
*
*    VERSION    AUTHOR         DATE        DETAIL 
*       
**/


    @isTest()

    private class ManageExcutionTest{    
    
 /**   
*@author IDC Team    
*@date 01/01/2014    
*@description This method checks for setting value for same excution, same entitlement business hours excution ,Same Insert Trigger Execution,
        Set service request. 
*@param     
*@return     
*/
    
    static testMethod void ManageExceution_Test() {
            
        List<Id>  contId = new  List<Id>();
    
        ManageExecutions.setSameExecution();
        
        System.assert(ManageExecutions.isSameExecution);
        
        ManageExecutions.setSameEntitlementBusinessHoursExecution();
        
        System.assert(ManageExecutions.isSameEntitlementBusinessHoursExecution);
        
        ManageExecutions.setSameInsertTriggerExecution();
        
        System.assert(ManageExecutions.isSameInsertTriggerExecution);
        
        ManageExecutions.setSameCVServiceRequests();
    
        System.assert(ManageExecutions.isSameCVServiceRequests);
        
        ManageExecutions.setSameGrienanceId();
        
        System.assert(ManageExecutions.isSameGrienanceId);
        
        ManageExecutions.setSameUserId();
        
        System.assert(ManageExecutions.isSameUserId);
        
        ManageExecutions.setCVServiceRequests(contId);
        
        User usr = AP01_TestDataUtility.createUser();
        
        List<Entitlement> entl = AP01_TestDataUtility.createEntitlement();
        
        Id webGrievanceRecordTypeId = [select Id from RecordType where DeveloperName =:Label.WebGrievance and SObjectType=:AP01_TestDataTokens.S3_CASE limit 1].Id;
        
        ManageExecutions.setGrienanceId(webGrievanceRecordTypeId);
        
        System.assert(ManageExecutions.isSameGrienanceId);
        
        ManageExecutions.setUserId(usr.id);
        
        Map<ID,string> mapRecType = new Map<ID,string>();
        
        mapRecType.put(webGrievanceRecordTypeId,AP01_TestDataTokens.RECTYPE);
        
        ManageExecutions.setRecordTypeMap(mapRecType);
        
        Map<String, Entitlement> mapRecTypeEnt = new Map<String, Entitlement>();
        
        Entitlement entle;
        
        for(Entitlement ent:entl){
        
            entle = ent;
        
        }
        
        mapRecTypeEnt.put(AP01_TestDataTokens.ENTITLEMENT, entle);
        
        ManageExecutions.setEntitlementMap(mapRecTypeEnt);
    }
    
    }