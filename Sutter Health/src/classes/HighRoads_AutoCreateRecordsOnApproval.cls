/**
* Class Name  : HighRoads_AutoCreateRecordsOnApproval
* Author      : IDC Offshore
* Description : This class is used to call the methods when 
*               1. RFP status is Approved by Underwriting, quote will be created
*               2. Quote status is Approved by Sales, sso will be created
*               3. SSO status is Approved by Underwriting, SCN will be created
*               4. Checking the Rates for SSO before it is submitting for approval.
* Created Date: 8/25/2016
**/

public class HighRoads_AutoCreateRecordsOnApproval{
    //recursion protection
    public static boolean isQuoteAfterUpdate = true;
    public static boolean isQuoteAfterUpdateRejected = true;
    Savepoint sp;//to roll back the transation if it fails
    /**
* Method Name : crateQuote
* Parameters  : Set<ID> rfpIds
* Description : This method will be called when RFP is approved by underwriting to create the Quote.
* Return Type : void
**/
    public void createQuote(Set<ID> rfpIds){
        
        List<Proposal__c> proposalList = new List<Proposal__c>();
        //fetching opportunity and create quotes as many rfps are approved
        for(Incumbent_Carrier__c rfp : [SELECT ID,Opportunity__c FROM Incumbent_Carrier__c WHERE ID IN:rfpIds LIMIT 10000])
        {
            Proposal__c proposalObj = new Proposal__c();
            proposalObj.RFP_Form__c = rfp.Id;
            proposalObj.Opportunity_ID__c = rfp.Opportunity__c;
            proposalObj.Stage__c = System.Label.SCN_Status;
            proposalList.add(proposalObj);
        }
        //Inserting the proposal list if the query results are not empty and list is not empty
        if(proposalList != NULL && !proposalList.isEmpty()){
            try
            {
                sp = Database.setSavepoint();
                insert proposalList;
            } catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
            
        }
    }
    /**
* Method Name : crateSSO
* Parameters  : Set<ID> quoteIds
* Description : This method will be called when Quote is approved by sales to create the SSO.
* Return Type : void
**/
    public void createSSO(Set<ID> quoteIds){
        
        List<Sold_Sign_Off__c> ssoList = new List<Sold_Sign_Off__c>();
        //Querying all the opportunity level fields to auto populate the data in sold sign off
        for(Proposal__c quote : [SELECT ID,Opportunity_ID__c,Opportunity_ID__r.RFP_Due_Date__c,Opportunity_ID__r.of_Subscribers__c,Opportunity_ID__r.Slicing_with_Carrier_Name__c,
                                 Opportunity_ID__r.Renewed_Opportunity__c,Opportunity_ID__r.Additional_Buy_Ups__c,Opportunity_ID__r.Plan_Effective_Date__c,Opportunity_ID__r.Group_Renewal_Date__c,
                                 Opportunity_ID__r.Plan_End_Date__c,Opportunity_ID__r.NTE_Offered__c,Opportunity_ID__r.Amount FROM Proposal__c WHERE ID IN:quoteIds LIMIT 10000])
        {
            try{
                //auto populating the Sold Sign Off data on creation
                Sold_Sign_Off__c ssoObj = new Sold_Sign_Off__c();
                ssoObj.Quote__c = quote.Id;
                ssoObj.Stage__c = System.Label.SCN_Status;  
                ssoObj.Opportunity_ID__c = quote.Opportunity_ID__c != NULL ? quote.Opportunity_ID__c : NULL;
                ssoObj.SSO_RSO_Due_Date__c = quote.Opportunity_ID__r.RFP_Due_Date__c;
                ssoObj.Estimated_Subs__c = quote.Opportunity_ID__r.of_Subscribers__c;
                ssoObj.New_Business_SSO_or_Renewal_RSO__c = quote.Opportunity_ID__r.Renewed_Opportunity__c == true ? HighRoads_Constants.RSO : HighRoads_Constants.SSOOBJNAME;
                ssoObj.TR_Dual_Triple_Slice__c = quote.Opportunity_ID__r.Additional_Buy_Ups__c;
                ssoObj.Slicing_with_Carrier_Name__c = quote.Opportunity_ID__r.Slicing_with_Carrier_Name__c;
                ssoObj.Effective_Date__c = quote.Opportunity_ID__r.Plan_Effective_Date__c;
                ssoObj.Next_Renewal_Date__c = quote.Opportunity_ID__r.Group_Renewal_Date__c;
                ssoObj.NTE__c = quote.Opportunity_ID__r.NTE_Offered__c;
                ssoObj.Amount__c = quote.Opportunity_ID__r.Amount;
                if(quote.Opportunity_ID__r.Plan_End_Date__c != NULL && quote.Opportunity_ID__r.Plan_Effective_Date__c != NULL){
                    Integer monthsDiff = quote.Opportunity_ID__r.Plan_Effective_Date__c.monthsBetween(quote.Opportunity_ID__r.Plan_End_Date__c);
                        if(quote.Opportunity_ID__r.Plan_End_Date__c.day() > quote.Opportunity_ID__r.Plan_Effective_Date__c.day()){
                            monthsDiff++;
                        }    
                    ssoObj.Contract_Months__c = monthsDiff;
                }
                ssoList.add(ssoObj);
            }catch(Exception ex){
                quote.addError(ex.getMessage());//If any of the above value is null, then it will alert the user to enter the value in opportunity level
            }
            
        }
        //Inserting the list if it is not empty
        if(ssoList != NULL && !ssoList.isEmpty()){
            try
            {
                sp = Database.setSavepoint();
                insert ssoList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
        }
        
    }
    /**
* Method Name : createSCN
* Parameters  : Set<ID> ssoIds
* Description : This method will be called when SSO is approved by underwriting to create the SCN.
* Return Type : void
**/
    public void createSCN(Set<ID> ssoIds){
        
        List<Employer_Group_Data__c> scnList = new List<Employer_Group_Data__c>();
        Map<String,SF_P2A_Market_Segments_Mapping__c> mapping = SF_P2A_Market_Segments_Mapping__c.getAll();
        Map<String,String> oppSSOIdMap = new Map<String,String>();
        Group shpSalesQueue = [select Id from Group where Name = :System.Label.HR78_SHP_Sales_Queue and Type = :HighRoads_Constants.QUEUE];
        //fetching the opportunity id from sold sign off to populate the opportunity in Sold Case Notification.
        for(Sold_Sign_Off__c ssoObj : [select ID,Quote__r.RFP_Form__r.Opportunity__c from Sold_Sign_Off__c where id in :ssoIds LIMIT 10000]){
            oppSSOIdMap.put(ssoObj.Quote__r.RFP_Form__r.Opportunity__c, ssoObj.Id);
        }
        for(Opportunity oppObj : [SELECT ID,AccountId 
                                  from Opportunity where ID IN:oppSSOIdMap.keySet() LIMIT 10000])
        {
            Employer_Group_Data__c scnObj = new Employer_Group_Data__c();
            scnObj.Sold_Sign_Off__c = oppSSOIdMap.get(oppObj.ID);
            scnObj.Opportunity__c = oppObj.ID;
            scnObj.OwnerId = shpSalesQueue.Id;
            scnList.add(scnObj);
        }
        if(scnList != NULL && !scnList.isEmpty()){
            try{
                sp = Database.setSavepoint();
                insert scnList;
            }catch(DMLException ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
            //Calling method to send notification to final approver queue if that sold sign of contains any custom benefit plan
            sendNotificationToBPATeam(ssoIds);
        }
        
        
    }
    /**
* Method Name : sendNotificationToBPATeam
* Parameters  : Set<ID> ssoIds
* Description : This method will be called when SSO is approved by underwriting to check any custom plans sold
*               If any custom plans sold, an email will be sent to BPA team to final approve the custom plan.
* Return Type : void
**/
    public void sendNotificationToBPATeam(Set<ID> ssoIds){
        try{
            sp = Database.setSavepoint(); 
            // fetching all the benefit plans associated to sold sign off records to check is there any custom plan exists and sold
            List<Benefit_Plan_Association__c> benefitPlanList = [select ID,Benefit_Plan_Metadata__r.Name,Raider_ID__r.Name,Benefit_Plan_Metadata__r.Custom_Benefit_Plan_ID__c,
                                                                 Benefit_Plan_Metadata__c,Raider_ID__c,Benefit_Plan_Metadata__r.Benefit_Grid__c,Raider_ID__r.Custom_Benefit_Plan_ID__c,
                                                                 Raider_ID__r.Benefit_Grid__c,Benefit_Plan_Metadata__r.isCustom__c,Raider_ID__r.isCustom__c,
                                                                 Benefit_Plan_Metadata__r.Plan_Related_to_Account__c,Raider_ID__r.Plan_Related_to_Account__c
                                                                 from Benefit_Plan_Association__c where Sold_Sign_Off__c IN :ssoIds LIMIT 10000];
            Set<String> customPlanIdSet = new Set<String>();//to store custom plan ids
            // looping through the associated benefit plan ids
            for(Benefit_Plan_Association__c bpaObj : benefitPlanList){
                //At the time of custom plan sold, benefit grid id will not be available and checking the plan is custom and plan is related to is not null
                if(bpaObj.Raider_ID__c != NULL && bpaObj.Raider_ID__r.Benefit_Grid__c == NULL && bpaObj.Raider_ID__r.isCustom__c && bpaObj.Raider_ID__r.Plan_Related_to_Account__c != NULL){
                    customPlanIdSet.add(bpaObj.Raider_ID__r.Custom_Benefit_Plan_ID__c);
                }else if(bpaObj.Benefit_Plan_Metadata__r.Benefit_Grid__c == NULL && bpaObj.Benefit_Plan_Metadata__r.isCustom__c && bpaObj.Benefit_Plan_Metadata__r.Plan_Related_to_Account__c != NULL){
                    customPlanIdSet.add(bpaObj.Benefit_Plan_Metadata__r.Custom_Benefit_Plan_ID__c);
                } 
            }
            if(customPlanIdSet != NULL && !customPlanIdSet.isEmpty()){
                //Fetching queue id for Custom Benefit Plan Final Approver queue, 
                //which will be used to update the owner to this queue once the plan is sold at sold sign off stage
                Group grp = [select id from group where developername= :System.Label.HR109_CustomPlanFinalApproverQueueName and type = :System.Label.CL_24_SM_Queue LIMIT 1];
                List<Custom_Benefit_Plan__c> customBenefitPlanList = [select ID,Name,OwnerId,Plan_Related_to_Account__r.Name,Employer_Type__c,DBA__c from Custom_Benefit_Plan__c where 
                                                                      ID IN :customPlanIdSet LIMIT 10000];
                if(customBenefitPlanList != NULL && !customBenefitPlanList.isEmpty()){
                    //Fetching email template to send the email to Final Approver Queue members to take an action.
                    EmailTemplate mailTemplateObj = [select id,subject,name,body,HtmlValue from EmailTemplate where 
                                                     developername=:HighRoads_Constants.TEMPLATE_NAME limit 1];
                    String mailBody = mailTemplateObj.HtmlValue;
                    String subject = mailTemplateObj.Subject;
                    String customPlanIds = HighRoads_Constants.BLANK_VALUE;
                    String sfdcurl = URL.getSalesforceBaseUrl().toExternalForm()+HighRoads_Constants.FWRD_SLASH;
                    List<String> mailToAddresses = getEmailAddresses();
                    
                    for(Custom_Benefit_Plan__c customBenefitPlanObj : customBenefitPlanList){
                        //customPlanIds+= sfdcurl+customBenefitPlanObj.Id+HighRoads_Constants.NEW_LINE;
                        customBenefitPlanObj.OwnerId = grp.Id;
                        //Replacing the static context in the email template with plan ids
                        mailBody = mailBody.replace('{!Custom_Benefit_Plan__c.Name}','<a href="'+System.Label.HR201_CustomBenPlanListViewURL+'">'+customBenefitPlanObj.Name+'</a>').replace('{!Custom_Benefit_Plan__c.Plan_Related_to_Account__c}',customBenefitPlanObj.Plan_Related_to_Account__r.Name).replace('{!Custom_Benefit_Plan__c.DBA__c}',customBenefitPlanObj.DBA__c).replace('{!Custom_Benefit_Plan__c.Employer_Type__c}',customBenefitPlanObj.Employer_Type__c);
                        subject = subject.replace('{!Custom_Benefit_Plan__c.Plan_Related_to_Account__c}',customBenefitPlanObj.Plan_Related_to_Account__r.Name).replace('{!Custom_Benefit_Plan__c.DBA__c}',customBenefitPlanObj.DBA__c).replace('{!Custom_Benefit_Plan__c.Employer_Type__c}',customBenefitPlanObj.Employer_Type__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        if(mailToAddresses != NULL && !mailToAddresses.isEmpty()){
                            mail.setToAddresses(mailToAddresses);
                            mail.setSubject(subject);
                            mail.setHtmlBody(mailBody);
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });//sending email to final approrver queue members
                            
                        }
                    }
                    if(mailToAddresses != NULL && !mailToAddresses.isEmpty()){
                        update customBenefitPlanList;//update custom benefit plans as the owner changed for sold plans
                        
                    }
                    
                    
                }
            }
        }catch(Exception ex){ Database.rollback(sp); System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
    }
    /**
* Method Name : getEmailAddresses
* Paramerters : None
* Description : This method is used to get the SHP BPA Group users email ids to 
*               send the custom plan final approval notification email
* Return Type : List<String> - List of email ids.
**/
    private List<String> getEmailAddresses() {
        Set<String> idList = new Set<String>();//UserorGroupId list
        List<String> mailToAddresses = new List<String>();//to store the users mail id to send an email that custom plan is sold in sold sign off
        Set<String> groupIds = new Set<String>();//to store the group ids from the custom benefit plan final approval queue
        //Fetching the group members/users from custom benefit plan final approver queue
        List<Group> grpList = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE developername =:System.label.HR109_CustomPlanFinalApproverQueueName LIMIT 1];
        for(Group grpObj : grpList){
            for (GroupMember grpMem : grpObj.groupMembers) {
                if(String.valueOf(grpMem.UserOrGroupId).startsWith('00G')){
                    groupIds.add(grpMem.UserOrGroupId);
                }else{
                    idList.add(grpMem.userOrGroupId);
                }
            }
        }
        //Fetching the groupmembers from the groups which are added in Final Approver Queue
        for(GroupMember mem : [Select Id, UserOrGroupId From GroupMember Where GroupId in :groupIds LIMIT 10000]) {
            if(!idList.contains(mem.UserOrGroupId)){
                idList.add(mem.UserOrGroupId);
            }
        }
        //Fetching user email for the list of user ids 
        User[] usr = [SELECT email FROM user WHERE id IN :idList and isActive=true LIMIT 10000];
        for(User u : usr) {
            mailToAddresses.add(u.email);//adding the user email address
        }
        return mailToAddresses;
    }
    /**
* Method Name : checkAllRatesForSSO
* Paramerters : Map<ID,Sold_Sign_Off__c> ssoIdMap
* Description : This method is used to check all the plans contains rates or not. 
*               It will throw error message if any plans doesnot contain rates.
* Return Type : void
**/
    public void checkAllRatesForSSO(Map<ID,Sold_Sign_Off__c> ssoIdMap){
        
        //Retrieving the plans for each Sold Sign Off to check whether all plans having rates or not
        List<Sold_Sign_Off__c> ssoWithBPAList = [select id,(select ID,SSO_Rate_Card__c from Benefit_Plan_Associations__r)
                                                 from Sold_Sign_Off__c where ID IN:ssoIdMap.keySet() LIMIT 10000];
        
        for(Sold_Sign_Off__c ssoObj : ssoWithBPAList){
            //Taking the record from map to throw an error message if the rates are not entered for any of the plan
            Sold_Sign_Off__c originalRecord = ssoIdMap.get(ssoObj.Id);
            if(ssoObj.Benefit_Plan_Associations__r == NULL || ssoObj.Benefit_Plan_Associations__r.size() == 0){
                //the below error message will occur when there is no plan selected for Sold Sign Off and submitting for approval
                originalRecord.addError(System.Label.HR136_PlansMandatory);
            }else if(ssoObj.Benefit_Plan_Associations__r.size() > 0){
                for(Benefit_Plan_Association__c bpaObj : ssoObj.Benefit_Plan_Associations__r){
                    if(bpaObj.SSO_Rate_Card__c == NULL){
                        //the below error message will occur when there is no raate for a plan
                        originalRecord.addError(System.Label.HR113_RatesMandatory);
                    }
                }
                
            }
        }
        
    }
}