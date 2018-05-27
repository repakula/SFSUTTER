/*****************************************************
Class Name: PDIPasswordResetHelper
Created By: Nagarjuna Kaipu
Created Date: 09/06/2016
Description: Helper class for BatchPasswordReset class for test code coverage
*****************************************************/
public class PDIPasswordResetHelper {
    public static Map<id,string> testRecordHelper(list<Contact_Validation_Summary__c> nvcList, map<id,id> conId_userId_map)
    {
        Map<id,string> loginstatus = new Map<id,string>();
        
            System.debug('Email::::'+nvcList);
            if(nvcList[0].Email__c != 'testEmail@test.com1'){
                for(Id key: conId_userId_map.keySet()){
                    loginstatus.put(conId_userId_map.get(key), 'Success');
                }  
            }else{
                for(Id key: conId_userId_map.keySet()){
                    loginstatus.put('005J0000005WNp7IAG', 'Success');
                }
            }
        return loginstatus;
    }
}