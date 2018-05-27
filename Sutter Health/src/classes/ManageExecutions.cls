/**  
*     Class Name: ManageExecutions
*     Author: Brandon Cassis
*     Date: 9-September-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description: This class is defined with a global access modifier so that it can be called throughout the org.
*     It defines a boolean variable isSameExecution and a method that changes its value, this class is called to manage recursive 
*     execution of triggers and their helper classes.
*
*    History
*    --------
*
*    VERSION    AUTHOR         DATE        DETAIL 
*       
**/
global class ManageExecutions {
    
    /** @Description: Static boolean variable declared with global access modifier so that it can be called throught the org. **/
    global static Boolean isSameExecution = false;
    
    /** @Description: Static boolean variable declared with global access modifier so that it can be called throught the org. 
    *                    These are used in the classes that execute after the Case Trigger.
    **/
    global static Boolean isSameEntitlementBusinessHoursExecution = false;
    global static Boolean isSameInsertTriggerExecution = false;
    global static Boolean isSameCVServiceRequests = false;
    global static Boolean isSameGrienanceId = false;
    global static Boolean isSameUserId = false;
    global static Boolean isSameCaseUpdate = false;
    global static Boolean isTriggered = false; 
    
    /** @Description: Static variables declared with global access modifier so that it can be called throught the org. 
    *                    These are used in the classes that execute after the Case Trigger and store the values generated
    *                    from a SOQL Query.
    **/
    global static List<Id> cvServiceRequests = new List<Id>();
    global static Id webGrievanceRecordTypeId;
    global static Map<Id,String> recordTypeMap = new Map<Id, String>();
    global static Map<String, Entitlement> entitlementMap = new Map<String, Entitlement>();
    global static Id userId;
    
    /**
    *   @Description: This method is defined with global access modifier so that it can be called throught the org, it sets the value of 
    *   boolean variable isSameExecution to true.
    *   @Arguments: None      
    *   @Return: Void
    **/  
    global static void setSameExecution() {
        isSameExecution = true;
    }
    
    /**
    *   @Description: This method is defined with global access modifier so that it can be called throught the org, it sets the value of 
    *   boolean variable isSameEntitlementBusinessHoursExecution to true. Used in ManageCaseInsert Class.
    *   @Arguments: None     
    *   @Return: Void
    **/
    global static void setSameEntitlementBusinessHoursExecution() {
        isSameEntitlementBusinessHoursExecution = true;
    }
    
    /**
    *   @Description: This method is defined with global access modifier so that it can be called throught the org, it sets the value of 
    *   boolean variable isSameInsertTriggerExecution to true. Used in ManageCase Trigger.
    *   @Arguments: None     
    *   @Return: Void
    **/
    global static void setSameInsertTriggerExecution() {
        isSameInsertTriggerExecution = true;
    }
    
    /**
    *   @Description: This method is defined with global access modifier so that it can be called throught the org, it sets the value of 
    *   boolean variable isSameCVServiceRequests to true. Used in ManageCaseDatabase Class.
    *   @Arguments: None     
    *   @Return: Void
    **/
    global static void setSameCVServiceRequests() {
        isSameCVServiceRequests = true;
    }
    
    /**
    *   @Description: This method is defined with global access modifier so that it can be called throught the org, it sets the value of 
    *   boolean variable isSameGrienanceId to true. Used in ManageCaseDatabase Class.
    *   @Arguments: None     
    *   @Return: Void
    **/
    global static void setSameGrienanceId() {
        isSameGrienanceId = true;
    }
    
    /**
    *   @Description: This method is defined with global access modifier so that it can be called throught the org, it sets the value of 
    *   boolean variable isSameUserId to true. Used in ManageCaseInsert Class.
    *   @Arguments: None     
    *   @Return: Void
    **/
    global static void setSameUserId() {
        isSameUserId = true;
    }
    
    global static void setSameCaseUpdate() {
        isSameCaseUpdate = true;
    }
    
    /**
    *   @Description: This method is defined with global access modifier so that it can be called throught the org, it sets the values of 
    *   a list of Ids in the cvServiceRequests list. Used in ManageCaseDatabase Class.
    *   @Arguments: List of Ids     
    *   @Return: Void
    **/
    global static void setCVServiceRequests(List<Id> inputList) {
        for(Id loopId: inputList){
            cvServiceRequests.add(loopId);
        }
    }
    
    /**
    *   @Description: This method is defined with global access modifier so that it can be called throught the org, it sets the values of 
    *   an Id in the webGrievanceRecordTypeId variable. Used in ManageCaseDatabase Class.
    *   @Arguments: List of Ids     
    *   @Return: Void
    **/
    global static void setGrienanceId(Id inputId) {
        webGrievanceRecordTypeId = inputId;
    }
    
    /**
    *   @Description: This method is defined with global access modifier so that it can be called throught the org, it sets the values of 
    *   an Id in the userId variable. Used in ManageCaseDatabase Class.
    *   @Arguments: Id    
    *   @Return: Void
    **/
    global static void setUserId(Id inputId) {
        userId = inputId;
    }
    
    /**
    *   @Description: This method is defined with global access modifier so that it can be called throught the org, it sets the values of 
    *   an Id and String Map in the recordTypeMap variable. Used in ManageCaseInsert Class.
    *   @Arguments: Map of Id keys, String values     
    *   @Return: Void
    **/
    global static void setRecordTypeMap(Map<Id, String> inputMap) {
        recordTypeMap.putAll(inputMap);
    }
    
    /**
    *   @Description: This method is defined with global access modifier so that it can be called throught the org, it sets the values of 
    *   an String and Entitlement sObject Map in the recordTypeMap variable. Used in ManageCaseInsert Class.
    *   @Arguments: Map of String keys, Entitlement sObject values     
    *   @Return: Void
    **/
    global static void setEntitlementMap(Map<String, Entitlement> inputMap) {
        entitlementMap.putAll(inputMap);
    }
}