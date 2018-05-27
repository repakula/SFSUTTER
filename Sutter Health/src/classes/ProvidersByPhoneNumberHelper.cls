/*****************************************************
Class Name: ProvidersByPhoneNumberHelper 
Created By: Nagarjuna Kaipu
Created Date: 06/09/2016
Description: used to update providers status count on providers by phone number object.
*****************************************************/
public class ProvidersByPhoneNumberHelper {
    public static boolean firstRunAfterInsert = true;
    public static boolean firstRunbeforeInsert = true;
    public static boolean firstRunAfterUpdate = true;
    public static boolean firstRunSummaryAfterInsert = true;
    public static boolean firstRunSummaryAfterUpdate = true;
    public static boolean firstRunSummaryBeforeInsert = true;
    public static boolean firstRunSummaryBeforeUpdate = true;
    
    /*
Method Name: updateProvidersStatusCount
Input Param: N/A
Return type: void
Description: This is used to update provider status count on phone object
*/
    public void updateProvidersStatusCount(List<String> phoneNumbers, List<String> oldPhoneNumbers){
        Map<String, ProvidersByPhoneNumber__c> mapPhone = new Map<String, ProvidersByPhoneNumber__c>();
        List<ProvidersByPhoneNumber__c> phoneUpdateList = new List<ProvidersByPhoneNumber__c>();
        List<ProvidersByPhoneNumber__c> phoneExist = new List<ProvidersByPhoneNumber__c>([Select Tech_Phone_Number__c From ProvidersByPhoneNumber__c Where Tech_Phone_Number__c IN: phoneNumbers AND PDI_Campaign__c = :Label.CL176_PDI_Current_Campaign_Name ]);
        AggregateResult[] arrPhoneList = [select Tech_Phone_Number__c, status__c, count(id) statCount from contact_validation_summary__c where Tech_Phone_Number__c in :phoneNumbers and PDI_Campaign__c = :Label.CL176_PDI_Current_Campaign_Name group by Tech_Phone_Number__c, status__c];
        //Querying group to get the duplicate phone queue id
        Group que = [Select Id, name from group where type =: Label.CL411_PDIQueueAPI and Name =: Label.CL412_PDINonValidatedDuplicateQueue Limit 1];
        //if primary phone is changed with record count 1 or 2 in providers by phone number
        if(oldPhoneNumbers != null){
            AggregateResult[] arrOldPhoneList = [select Tech_Phone_Number__c, count(id) statCount from contact_validation_summary__c where Tech_Phone_Number__c in :oldPhoneNumbers and PDI_Campaign__c = :Label.CL176_PDI_Current_Campaign_Name group by Tech_Phone_Number__c];
            List<String> removePhoneList = new List<String>();
            Map<String, String> mapRem = new Map<String, String>();
            if(!arrOldPhoneList.isEmpty()){
                for(AggregateResult remPhone: arrOldPhoneList)
                {
                    mapRem.put(String.ValueOf(remPhone.get(Label.CL414_PDITechPhoneNumber)), String.ValueOf(remPhone.get('statCount')));
                } 
            }
            Map<String, ProvidersByPhoneNumber__c> newDelMap = new Map<String, ProvidersByPhoneNumber__c>();
            List<String> delPhone1 = new List<String>();
            List<String> delPhone0 = new List<String>();
            for(String sRemPhone: oldPhoneNumbers){
                if(mapRem.containsKey(sRemPhone) && mapRem.get(sRemPhone) == '1'){
                    delPhone1.add(sRemPhone);
                }
                else if(!mapRem.containsKey(sRemPhone)){
                    delPhone0.add(sRemPhone);
                }
            }
            List<ProvidersByPhoneNumber__c> updateDelList = new List<ProvidersByPhoneNumber__c>();
            if(!delPhone0.isEmpty()){
                for(ProvidersByPhoneNumber__c phoneEx: [Select Id, SER_Non_Validated__c, SER_Accepted__c, SER_Validated__c, Tech_Phone_Number__c From ProvidersByPhoneNumber__c Where Tech_Phone_Number__c IN: delPhone0 AND PDI_Campaign__c = :Label.CL176_PDI_Current_Campaign_Name ]){
                    phoneEx.SER_Non_Validated__c = 0;
                    phoneEx.SER_Accepted__c = 0;
                    phoneEx.SER_Validated__c = 0;
                    updateDelList.add(phoneEx);
                }
            }
            if(!delPhone1.isEmpty()){
                Map<String, String> delPhMap = new Map<String, String>();
                for(Contact_Validation_Summary__c remSummary: [Select Id, Tech_Phone_Number__c, Status__c From Contact_Validation_Summary__c 
                                                               Where Tech_Phone_Number__c IN: delPhone1]){
                                                                   delPhMap.put(remSummary.Tech_Phone_Number__c, remSummary.Status__c);
                                                               }
                for(ProvidersByPhoneNumber__c phoneEx: [Select Id, SER_Non_Validated__c, SER_Accepted__c, SER_Validated__c, Tech_Phone_Number__c From ProvidersByPhoneNumber__c Where Tech_Phone_Number__c IN: delPhone1 AND PDI_Campaign__c = :Label.CL176_PDI_Current_Campaign_Name ]){
                    if(delPhMap.containsKey(phoneEx.Tech_Phone_Number__c)){
                        if(delPhMap.get(phoneEx.Tech_Phone_Number__c) == Label.CL185_PDI_Non_Validated_Status){
                            phoneEx.SER_Non_Validated__c = 1;
                            phoneEx.SER_Accepted__c = 0;
                            phoneEx.SER_Validated__c = 0;
                        }
                        else if(delPhMap.get(phoneEx.Tech_Phone_Number__c) == Label.CL186_PDI_Accepted_Status){
                            phoneEx.SER_Non_Validated__c = 0;
                            phoneEx.SER_Accepted__c = 1;
                            phoneEx.SER_Validated__c = 0;
                        }
                        else if(delPhMap.get(phoneEx.Tech_Phone_Number__c) == Label.CL187_PDI_Validated_Status){
                            phoneEx.SER_Non_Validated__c = 0;
                            phoneEx.SER_Accepted__c = 0;
                            phoneEx.SER_Validated__c = 1;
                        }
                        updateDelList.add(phoneEx);
                    }
                }
            }
            if(!updateDelList.isEmpty()){
                update updateDelList;
            }
        }
        for(String sPhone: phoneNumbers)
        {
            ProvidersByPhoneNumber__c p = new ProvidersByPhoneNumber__c();
            p.Name = FormatPhone(sPhone);
            p.Tech_Phone_Number__c = sPhone;
            p.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            p.OwnerId = que.Id;
            if(!mapPhone.containsKey(sPhone)){
                mapPhone.put(sPhone, p);  
            }
        }
        for(AggregateResult arr: arrPhoneList)
        {
            if(mapPhone.containsKey(String.ValueOf(arr.get(Label.CL414_PDITechPhoneNumber))))
            {
                ProvidersByPhoneNumber__c pPhone = mapPhone.get(String.ValueOf(arr.get(Label.CL414_PDITechPhoneNumber)));
                if((String.ValueOf(arr.get(Label.CL406_PDIProviderStatusAPI))) == Label.CL185_PDI_Non_Validated_Status){
                    pPhone.SER_Non_Validated__c = Integer.ValueOf(arr.get(Label.CL407_PDIProviderStatusCountString));
                }else if((String.ValueOf(arr.get(Label.CL406_PDIProviderStatusAPI))) == Label.CL186_PDI_Accepted_Status)
                {
                    pPhone.SER_Accepted__c = Integer.ValueOf(arr.get(Label.CL407_PDIProviderStatusCountString));
                }else if((String.ValueOf(arr.get(Label.CL406_PDIProviderStatusAPI))) == Label.CL187_PDI_Validated_Status){
                    pPhone.SER_Validated__c = Integer.ValueOf(arr.get(Label.CL407_PDIProviderStatusCountString));
                }
                mapPhone.put(String.ValueOf(arr.get(Label.CL414_PDITechPhoneNumber)), pPhone);
            }
        }
        if(!phoneExist.isEmpty())
        {
            for(ProvidersByPhoneNumber__c phone: phoneExist)
            {
                phone.SER_Non_Validated__c = mapPhone.get(phone.Tech_Phone_Number__c).SER_Non_Validated__c == null ? 0: mapPhone.get(phone.Tech_Phone_Number__c).SER_Non_Validated__c;
                phone.SER_Accepted__c = mapPhone.get(phone.Tech_Phone_Number__c).SER_Accepted__c == null ? 0: mapPhone.get(phone.Tech_Phone_Number__c).SER_Accepted__c;
                phone.SER_Validated__c = mapPhone.get(phone.Tech_Phone_Number__c).SER_Validated__c == null ? 0: mapPhone.get(phone.Tech_Phone_Number__c).SER_Validated__c;
                phoneUpdateList.add(phone);
                mapPhone.remove(phone.Tech_Phone_Number__c);
            }
        }
        if(!mapPhone.isEmpty())
        {
            insert mapPhone.values();   
        }
        
        if(!phoneUpdateList.isEmpty())
        {
            upsert(phoneUpdateList);
        }
    } 
    
    /*
Method Name: UpdatePhoneObjectIdOnSummary
Input Param: N/A
Return type: void
Description: This is used to update Phone Object Id summary object.
*/
    public static void UpdatePhoneObjectIdOnSummary(List<Contact_Validation_Summary__c> summaryList){
        List<String> dupphones = new List<String>();
        Map<String, Id> phoneMap = new Map<String, Id>();
        for(Contact_Validation_Summary__c objSummary :  summaryList) {
            if(objSummary.Secure_Phone__c != null){
                objSummary.Tech_Phone_Number__c = String.valueOf(objSummary.Secure_Phone__c).replaceAll('[^0-9]',''); 
                dupphones.add(objSummary.Tech_Phone_Number__c);
            }
        }
        
        for(ProvidersByPhoneNumber__c phoneObj: [Select Id, Tech_Phone_Number__c From ProvidersByPhoneNumber__c Where Tech_Phone_Number__c IN: dupphones 
                                                 AND PDI_Campaign__c = :Label.CL176_PDI_Current_Campaign_Name Limit 50000]){
                                                     phoneMap.put(phoneObj.Tech_Phone_Number__c, phoneObj.Id);
                                                 }
        
        for(Contact_Validation_Summary__c objSummary :  summaryList) {
            if(objSummary.Secure_Phone__c != null){
                objSummary.Tech_Phone_Number__c = String.valueOf(objSummary.Secure_Phone__c).replaceAll('[^0-9]',''); 
                if(!phoneMap.isEmpty()){
                    if(phoneMap.containsKey(objSummary.Tech_Phone_Number__c)){
                        objSummary.Providers_By_Phone_Number__c = phoneMap.get(objSummary.Tech_Phone_Number__c);
                    }
                    else{
                        objSummary.Providers_By_Phone_Number__c = null; 
                    }
                }
                else{
                    objSummary.Providers_By_Phone_Number__c = null; 
                }
            }
        }
    }
    /*
Method Name: FormatPhone
Input Param: String
Return type: String
Description: Used to format the phone number into US format
*/ 
    public static String FormatPhone(String Phone) {
        string nondigits = '[^0-9]';
        string PhoneDigits;
        
        // remove all non numeric
        PhoneDigits = Phone.replaceAll(nondigits,'');
        
        // 10 digit: reformat with dashes
        if (PhoneDigits.length() == 10) 
            return '('+PhoneDigits.substring(0,3)+')' + ' ' +
            PhoneDigits.substring(3,6) + '-' +
            PhoneDigits.substring(6,10);
        // 11 digit: if starts with 1, format as 10 digit 
        if (PhoneDigits.length() == 11) {
            if (PhoneDigits.substring(0,1) == '1') {
                return  '('+PhoneDigits.substring(1,4)+')' + ' ' +
                    PhoneDigits.substring(4,7) + '-' +
                    PhoneDigits.substring(7,11);
            }
        }
        
        // if it isn't a 10 or 11 digit number, return the original because
        // it may contain an extension or special information
        return( Phone );
    } 
    
}