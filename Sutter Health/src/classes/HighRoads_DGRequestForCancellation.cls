/************************************************************************************************************************
Class Name : HighRoads_DGRequestForCancellation
Author     : IDC Offshore
Date       : 12/1/2016
Description: Req - 3980 This is used to restrict the user to cancel the document generation
History:
VERSION    AUTHOR              DATE        DETAIL
1.0        IDC-Offshore      12/1/2016     Req - 3980 This is used to restrict the user to cancel the document generation
2.0        Deloitte          19/04/2017    SHP29 Modified the if condition for BPA - Ability to Cancel DGR object when "Approved by Sales"
3.0        Deloitte          01/05/2017    Added a generic method(named cancelRequest) to handle the similar code used at multiple places
****************************************************************************************************************************/
global class HighRoads_DGRequestForCancellation {
    
    /**
* Method Name : cancelDocGenRequest
* Parameters  : ID recordId
* Description : To cancel/modify the request
* Req no      : 3980
* Return type : String - success or failure message
**/
    webservice static String cancelDocGenRequest(ID recordId){
        Savepoint sp = Database.setSavepoint();
        try{
            //fetching the admin queue
            Group grp = [select id from group where developername=:HighRoads_Constants.BPA_ADMIN_QUEUE  and type=:HighRoads_Constants.QUEUE limit 1];
            //fetching the sales profile name
            String profileName = [select Name from Profile where id=:UserInfo.getProfileId() LIMIT 1].Name;
            //fetching the sso and opportunity values and new and old status
            Document_Generation_Request__c docgenObj = [select Id,OwnerId,Sold_Sign_Off__c,Opportunity__c,Request_Status__c,Status_Before_Cancellation__c
                                                        from Document_Generation_Request__c where Id=:recordId LIMIT 1];
            
           
            //if sold sign off is not null then it is large group
            //  SHP29: Added "SHP Benefit Plan Administration" Profile to the below IF condition so that Users of this profile get DGR Cancellation access                                                        
            if((docgenObj.Sold_Sign_Off__c != NULL || (docgenObj.Sold_Sign_Off__c == NULL && docgenObj.Opportunity__c != NULL)) && ((profileName == HighRoads_Constants.SHP_SALES_PROFILE && docgenObj.OwnerId == grp.Id) || UserInfo.getUserId() == docgenObj.OwnerId || profileName == HighRoads_Constants.SHP_Benefit_Plan_Administration)){
                if(docgenObj.Sold_Sign_Off__c != NULL) {
                    cancelRequest(docgenObj.Sold_Sign_Off__c, 'Sold_Sign_Off__c', docgenObj);
                }
                else {
                    cancelRequest(docgenObj.Opportunity__c, 'Opportunity', docgenObj);
                }
                return System.Label.HR223_RequestCancelSuccess;
            }
            else{
                return System.Label.HR222_RequestCancellationError;      
            }
        }catch(Exception ex){Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}return System.Label.HR224_ErrorOccurredInCancelRequest;
    }
    /*
        Method Name        :    cancelRequest
        Description        :    Updates the "Request Status" field value of Doc Gen req. record to "Request Cancelled"
        Return Type        :    void
        Param count        :    3
        Parameters         :    recId         ==> Parent recordId of Doc gen Req.(could be either of SSO Id and Opportunity Id)
                                ObjectName    ==> sObject Type of the Parent (Ex: Sold_Sign_Off__c, if SSO)
                                docGenObj     ==> Doc Gen Req record, which is cancelled        
    */
    //    SHP29: This method is used to update the Status on the Document Generation Request object to "Cancelled"
    static void cancelRequest(Id recId, String ObjectName, Document_Generation_Request__c docGenObj) {
        
       if (docGenObj.Request_Status__c == System.Label.HR221_RequestCancelled){ 
            docGenObj.Request_Status__c = docGenObj.Status_Before_Cancellation__c; 
        } 
        else { 
            docGenObj.Status_Before_Cancellation__c = docGenObj.Request_Status__c; 
            docGenObj.Request_Status__c = System.Label.HR221_RequestCancelled; 
        } 
     // The status on the DGR is updated to Cancelled 
        update docGenObj;
 
    }
    
}