/*_______________________________________________________________________________________________________________________________________________________________
 * 
 * Class Name  : SCN_CustomTrackfieldPageController
 * Created by  : Deloitte 
 * Date      : 16/03/2017
 * User Story  : SFSHP-5
 * Description  : Sales - SCN - Visual Notification of Changes in SCN. The below class is for the functionality of tracking the difference between 
 *           Solid case notification data and its cloned record through a button that is comparing the cloned record and its source record.
 * Change Log
 * _______________________________________________________________________________________________________________________________________________________________
 * Version    Name      Date    Userstory    Description
 * _______________________________________________________________________________________________________________________________________________________________
 * 
 * _______________________________________________________________________________________________________________________________________________________________
 * ______________________________________________________________________________________________________________________________________________________________*/
public  without sharing class SCN_CustomTrackfieldPageController
{
    public list<list<String>> FieldHistoryList  {get;set;}
    public Boolean ShowMessage                  {get;set;}
    public SCN_CustomTrackfieldPageController(ApexPages.StandardController SC)
    {
        system.debug('###' + ApexPages.currentPage().getURL());
        ShowMessage = false;
        ID RecordID = SC.getID();
        FieldHistoryList = new list<list<String>>();
        String SOQL = 'select ';
        list<String> UpdateableFields = new list<String>();
        for(String S : Employer_Group_Data__c.SObjectType.getDescribe().fields.getMap().keySet())
        {
            Schema.DisplayType FieldType = Schema.SObjectType.Employer_Group_Data__c.fields.getMap().get(S).getDescribe().getType();
            if(S.Contains('__c'))
            {
                
                if(String.valueOf(FieldType) == 'REFERENCE')
                {
                    String LookupString = S.replace('__c','__r.Name');
                    SOQL += S +','+'Sold_Case_Notification__r.'+S+ ','+LookupString+','+'Sold_Case_Notification__r.'+LookupString+ ',';
                    UpdateableFields.add(S);
                }
                else
                {
                    SOQL += S +','+'Sold_Case_Notification__r.'+S+ ',';
                    UpdateableFields.add(S);
                }
            }          
        }
        
        SOQL = SOQL.substring(0, SOQL.length()-1);
        SOQL += ' from Employer_Group_Data__c where ID = :RecordID and Sold_Case_Notification__c != null limit 1';
        system.debug('@@@ : '+SOQL);
        Employer_Group_Data__c E = Database.query(SOQL);
        String FieldLabel,OldValue,NewValue;
        set<String> FiedlAPI = new set<String>();
        for(SCN_Field__mdt S : [select MasterLabel from SCN_Field__mdt])
        {
            FiedlAPI.add(S.MasterLabel.toLowerCase());
        }
        system.debug('@@@ FiedlAPI : '+FiedlAPI);
        for(String S : UpdateableFields)
        {
            if(E.getSobject('Sold_Case_Notification__r').get(S) != E.get(S) && !FiedlAPI.Contains(S))
            {
                Schema.DisplayType FieldType = Schema.SObjectType.Employer_Group_Data__c.fields.getMap().get(S).getDescribe().getType();
                if(String.valueOf(FieldType) == 'REFERENCE')
                {
                    system.debug('%%% S : '+S);
                    String LookupString = S.replace('__c','__r');
                    FieldLabel = Schema.getGlobalDescribe().get('Employer_Group_Data__c').getDescribe().fields.getMap().get(S).getDescribe().getLabel();
                    OldValue =  String.valueOf(E.getSobject('Sold_Case_Notification__r').get(S)) != null                        ?
                                String.valueOf(E.getSobject('Sold_Case_Notification__r').getSobject(LookupString).get('Name'))  :
                                '' ;
                    NewValue =  String.valueOf(E.get(S)) != null                        ?
                                String.valueOf(E.getSobject(LookupString).get('Name'))  :
                                '';
                    FieldHistoryList.add(new list<String>{FieldLabel,OldValue,NewValue});
                }
                else
                {
                    system.debug('### S : '+S);
                    FieldLabel = Schema.getGlobalDescribe().get('Employer_Group_Data__c').getDescribe().fields.getMap().get(S).getDescribe().getLabel();
                    OldValue =  String.valueOf(E.getSobject('Sold_Case_Notification__r').get(S)) != null  ?
                                String.valueOf(E.getSobject('Sold_Case_Notification__r').get(S))          :
                                '' ;
                    NewValue =  String.valueOf(E.get(S)) != null  ?
                                String.valueOf(E.get(S))          :
                                '';
                    FieldHistoryList.add(new list<String>{FieldLabel,OldValue,NewValue});
                }
            }
        }
        if(FieldHistoryList.isEmpty())
        {
          ShowMessage = true;
        }
    }
}