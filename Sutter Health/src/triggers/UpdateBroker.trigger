/**  
*    Trigger Name: UpdateBroker
*    Author:Saket Jha
*    Date: 09-April-2014
*    Description: This Trigger is written to associate Broker and Broker Rep of opportunity to related account.
*    History
*    --------
*    VERSION    AUTHOR           DATE        DETAIL 
*       1.0     IDC Offshore   04/09/2014  Ad ded Comments and Indentation
*       2.0     IDC Offshore   04/22/2016  Added the logic for Signed Agreement creation for SHMMN Opportunity on Closed won
        3.0     IDC Offshore   08/12/2016  Added logic to Create New SCN and Document Generation Request for Opprtunities 
                related to Small Group or Individual Accounts when Opportunity is Closed Won.
                Added logic to check any un rejected scns for the opportunity. Restring the user from 
                re opening the closed won opportunity If there is any un rejected scns exists for that opportunty

        4.0     Deloitte       03/13/2017  SHP-30 Changed the sequence of the order in which the "Current Opportunity flag is set
**/

trigger UpdateBroker on Opportunity (before insert,before update,after insert,after update) 
{
    /**
* @author IDC Team
* @date 10/07/2015
* @description -- This if loop is used to Mark the checkbox Latest Updated Opportunity of Account 
so that it can be selected for the Reporting Purpose.
* @Requirement : Req-3392 Sales Report Changes
*/
    
    /**********Req-3826 Changes Start*********************/
    if(AP01_TestDataUtility.runOnce == true){
        
        /* Req - 3880 Archive check box changes STARTS */
        Id shpSalesRecordTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(System.Label.SHP_Sales_Opportunity_RecType).getRecordTypeId();
        User usr = [select id, by_pass_validations__c from User where id=:UserInfo.getUserId()];
        if(!usr.By_Pass_Validations__c){
            if(Trigger.isInsert && Trigger.isBefore){
                Set<ID> archivedAccountIds = new Set<ID>();
                Set<ID> archiveConIds = new Set<ID>();
                List<Account> accList = new List<Account>();
                for(Opportunity oppObj : Trigger.New){
                    if(oppObj.RecordTypeId == shpSalesRecordTypId){
                        archiveConIds.add(oppObj.Broker_Rep1__c);
                        archiveConIds.add(oppObj.Account_Manager__c);
                        archiveConIds.add(oppObj.GA_Contact__c);
                        archivedAccountIds.add(oppObj.AccountId);
                    }
                }
                List<Account> updateAccList = [select id,By_Pass_Archive_Contact_Validation__c from Account where Broker_Rep__r.Archive__c = true and id in :archivedAccountIds];
                if(!updateAccList.isEmpty()){
                    for( Account accObj : updateAccList){
                        accObj.By_Pass_Archive_Contact_Validation__c = true;
                    }
                    try{
                        update updateAccList;
                    }catch(Exception e){
                        
                    }
                }
                
                if(!archiveConIds.isEmpty()){
                    Map<String,Contact> conMap = new Map<String,Contact>([select ID,Archive__c from Contact where ID IN:archiveConIds and Archive__c = true]);
                    for(Opportunity oppObj : Trigger.New){
                        if(conMap.get(oppObj.Broker_Rep1__c) != NULL && conMap.get(oppObj.Broker_Rep1__c).Archive__c){
                            oppObj.Broker_Rep1__c.AddError(System.Label.SHP_Archive_Error);
                        }else if(conMap.get(oppObj.Account_Manager__c) != NULL && conMap.get(oppObj.Account_Manager__c).Archive__c){
                            oppObj.Account_Manager__c.AddError(System.Label.SHP_Archive_Error);
                        }else if(conMap.get(oppObj.GA_Contact__c) != NULL && conMap.get(oppObj.GA_Contact__c).Archive__c){
                            oppObj.GA_Contact__c.AddError(System.Label.SHP_Archive_Error);
                        }
                    }
                }
                
            }
            if(Trigger.isUpdate && Trigger.isBefore){
                Set<ID> archiveConIds = new Set<ID>();
                for(Opportunity oppObj : Trigger.New){
                    if(oppObj.RecordTypeId == shpSalesRecordTypId){
                        if(HighRoads_ArchivedContacts.isByPassValidationUpdated && oppObj.By_Pass_Archive_Contact_Validation__c == FALSE){
                            archiveConIds.add(oppObj.Broker_Rep1__c);
                            archiveConIds.add(oppObj.Account_Manager__c);
                            archiveConIds.add(oppObj.GA_Contact__c);
                        }
                    }
                }
                
                HighRoads_ArchivedContacts.isByPassValidationUpdated = false; 
                if(!archiveConIds.isEmpty()){
                    Map<String,Contact> conMap = new Map<String,Contact>([select ID,Archive__c from Contact where ID IN:archiveConIds and Archive__c = true]);
                    for(Opportunity oppObj : Trigger.New){
                        if(conMap.get(oppObj.Broker_Rep1__c) != NULL && conMap.get(oppObj.Broker_Rep1__c).Archive__c){
                            oppObj.Broker_Rep1__c.AddError(System.Label.SHP_Archive_Error);
                        }else if(conMap.get(oppObj.Account_Manager__c) != NULL && conMap.get(oppObj.Account_Manager__c).Archive__c){
                            oppObj.Account_Manager__c.AddError(System.Label.SHP_Archive_Error);
                        }else if(conMap.get(oppObj.GA_Contact__c) != NULL && conMap.get(oppObj.GA_Contact__c).Archive__c){
                            oppObj.GA_Contact__c.AddError(System.Label.SHP_Archive_Error);
                        }
                    }
                }
            }
        }
        
        /* Req - 3880 Archive check box changes ENDS */
        
        /**********Req-3826 Changes End*********************/
       
        /*Req-3392 Sales Report Changes Ends */
        
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : Trigger.new)
        {
            accountIds.add(opp.AccountId);
        }
        
        //Update Accounts
        
        Map<ID, Account> mapAccounts = new Map<ID, Account>([SELECT Id,name, Broker__c,Broker_Rep__c FROM Account where Id IN :accountIds]);
        List<Account> lstAccToUpdate = new List<Account>();
        For(Opportunity opp : Trigger.new)
        { 
            if(trigger.isInsert || (trigger.isUpdate && ( trigger.oldmap.get(opp.id).Broker1__c != opp.Broker1__c ||  trigger.oldmap.get(opp.id).Broker_Rep1__c != opp.Broker_Rep1__c || trigger.oldmap.get(opp.id).Broker_of_Record__c != opp.Broker_of_Record__c || trigger.oldmap.get(opp.id).OverrideBrokerAndBrokerRep__c != opp.OverrideBrokerAndBrokerRep__c)))
            {
                Account acc = mapAccounts.get(opp.Accountid);
                
                if(opp.Broker_of_Record__c==true) {
                    
                    if(acc!=null && acc.Broker__c==null && acc.Broker_Rep__c==null ){
                        acc.Broker__c = opp.Broker1__c;
                        acc.Broker_Rep__c = opp.Broker_Rep1__c; 
                        lstAccToUpdate.add(acc);
                    }else if(acc.Broker__c!=null && acc.Broker_Rep__c!=null && opp.OverrideBrokerAndBrokerRep__c!=true && opp.Broker1__c!=null && opp.Broker_Rep1__c != null ){
                        opp.addError('Broker and Broker Rep are associated with this Account to override broker and broker rep please check "override Broker And BrokerRep" checkbox otherwise just unchecked "Broker of Record"');
                    }else if(opp.OverrideBrokerAndBrokerRep__c==true  && acc.Broker__c!=null && acc.Broker_Rep__c!=null){
                        acc.Broker__c = opp.Broker1__c;
                        acc.Broker_Rep__c = opp.Broker_Rep1__c;
                        lstAccToUpdate.add(acc);
                    }
                }
            }
        } 
        
        if(!lstAccToUpdate.isempty()) {
            update lstAccToUpdate;
        }
        
        /**********Req-3912 Changes Start*********************/  
        if(Trigger.isAfter &&  Trigger.isInsert)
        {  
            
            List<Opportunity> updateOppList = new List<Opportunity>();
            
            //Set of unique source opportunities
            Set<Id> sourceIds = new Set<Id>();
            
            for(Opportunity opp : Trigger.new)
            {
                
                sourceIds.add(opp.Record_Id__c);
            }
            //Query all source opportunities
            Map<Id,Opportunity> sourceOpportunities = new Map<ID,Opportunity>([SELECT id, name, Opp_Renewed__c FROM Opportunity WHERE Id IN:sourceIds]);
            
            //Query all new opportunities
            Map<Id,Opportunity> newOpportunities = new Map<ID,Opportunity>([SELECT id, name, StageName,Opp_Renewed__c,Renewed_Opportunity__c,Record_Id__c  FROM Opportunity WHERE Id IN:Trigger.new]);
            
            for(Opportunity opp : newOpportunities.values())
            {
                
                if(opp.Record_Id__c != null ) 
                {
                    Opportunity sourceOpp = sourceOpportunities.get(opp.Record_Id__c);
                    if(sourceOpp !=null)
                    {
                        Opportunity oldOpp = new Opportunity(id=sourceOpp.id);
                        oldOpp.Opp_Renewed__c = true;
                        updateOppList.add(oldOpp);
                    }
                }
                
                Opportunity newOpp = new Opportunity(id=opp.id);
                newOpp.Bypass_Validation_Rule__c = true;
                newOpp.Record_Id__c = opp.id;
                
                if(opp.StageName =='Closed Won' && opp.Record_Id__c != null)
                {
                    newOpp.Renewed_Opportunity__c = true;
                }
                updateOppList.add(newOpp);
            }
            //update all the source and new opportunities to have new changes 
            /*REQ: 3880 Wave 1 change START*/
            try{
                update updateOppList;  
            }catch(Exception e){
                
            }   
            /*REQ: 3880 Wave 1 change END */
        }    
    }   
    /**********Req-3912 Changes End*********************/
    /**********Req-3980 Changes Start*********************/
    if(Trigger.isUpdate && Trigger.isAfter){
        if(HighRoads_OpporutnityHelper.isOpportunityAfterUpdate){
            HighRoads_OpporutnityHelper oppHelperObj = new HighRoads_OpporutnityHelper();
            oppHelperObj.updateOpportunity(Trigger.NewMap,Trigger.OldMap);
            HighRoads_OpporutnityHelper.isOpportunityAfterUpdate = false;
        }
        
    }
    /**********Req-3980 Changes End *********************/
    
     /********** SHP-30 Change Start *********************/
    
     if( (Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter ) {
            SelectLatestOpportunity.selectLatestUpdatedOpportunity( trigger.new );
        }
    
    /********** SHP-30 Change End *********************/
}