/*_______________________________________________________________________________________________________________________________________________________________
 * 
 * Class Name   : SCN_CustomTrackfieldPageController
 * Created by   : Deloitte 
 * Date         : 16/03/2017
 * User Story   : SFSHP-5
 * Description  : The below class is the test class for SCN_CustomTrackfieldPageController
 * 
 * Change Log
 * _______________________________________________________________________________________________________________________________________________________________
 * Name         Date        Userstory       Description
 * _______________________________________________________________________________________________________________________________________________________________
 * 
 * _______________________________________________________________________________________________________________________________________________________________
 * ______________________________________________________________________________________________________________________________________________________________*/
@isTest
private class SCN_CustomTrackfieldPageController_Test 
{
    static testMethod void Method_1()
    {
        Account Acc_1 = new Account(Name='Acc_1',Status__c= 'Contracted',NumberOfEmployees = 300);
        
        insert Acc_1;
        Opportunity Opp_1 = new Opportunity(Name = 'Opp_1',Type = 'New Business',AccountId = Acc_1.Id,StageName = 'Closed Won',Amount = 450,
                                            CloseDate = Date.today()+25,Plan_end_date__c = Date.today()+110,Current_Status__c = 'Information Requested',Opp_Renewed__c =false,
                                            RecordTypeID = System.label.SHP_Sales_Opportunity_Id,Sales_Team__c = 'TSS');
                                                       
        insert Opp_1;
        Employer_Group_Data__c SCN_1 = new Employer_Group_Data__c(Opportunity__c = Opp_1.Id,Stage__c = 'Completed',Opportunity_Account_Name__c = Acc_1.Id,Group_Type__c = 'Small',
                                                                 County__c = 'Canada');
                                                                    
        insert SCN_1;
        Employer_Group_Data__c SCN_2 = SCN_1.clone();
        SCN_2.Cloned_from__c = [select Name from Employer_Group_Data__c where ID =: SCN_1.ID].Name;
        SCN_2.Phone_Number__c = '1234';
        SCN_2.Group_Type__c = 'Individual';
        SCN_2.County__c = null;
        insert SCN_2;
        
        system.debug('### SCN_2 : '+SCN_2);
        system.debug('### SCN_2 : '+SCN_2.Cloned_from__c);
        system.debug('### SCN_2 : '+SCN_2.Sold_Case_Notification__c);
        ApexPages.StandardController SC = new ApexPages.StandardController(SCN_2);
        SCN_CustomTrackfieldPageController S = new SCN_CustomTrackfieldPageController(SC);
    }
}