/**  
*    Trigger Name: Provider_Address_Trigger 
*    Date: 18-8-2016
*    Created By: IDC OffShore		
*    Description: This Trigger used update the provider addresses
*	 updating is address changed flags once the call center agent validatied the provider primary/secondary addresses
*    if any changes provider primary address same will be updated on provider summary object.
**/
trigger Provider_Address_Trigger on Provider_Address__c (after delete, after insert, after undelete, after update,
                                                         before delete, before insert, before update)
{
    Map<Id, Provider_Address__c> sumPrimaryMap = new Map<Id, Provider_Address__c>();
    String userProfile = null;
    List<Profile> profileNameList = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    if(profileNameList != null && !profileNameList.isEmpty()){ userProfile = profileNameList[0].Name; }
    if(Trigger.isInsert && Trigger.isbefore) {
        if(ProviderAddressTriggerHelper.firstRunAddressBeforeInsert){
            //Updating secondary address serial nubmers on provider address object.
            ProviderAddressTriggerHelper.updateAddressSerialNumber(Trigger.New, userProfile);
            ProviderAddressTriggerHelper.firstRunAddressBeforeInsert = false;
        }
    }
    
    if(Trigger.isInsert && Trigger.isAfter) {
        if(ProviderAddressTriggerHelper.firstRunAddressAfterInsert){
            Set<Id> setContactIds = new Set<Id>();
            for(Provider_Address__c objAddress:Trigger.New) {
                //if(objAddress.Tech_Find_suggestAddress__c == false){
                setContactIds.add(objAddress.Id);
                //}
            }
            //isAfter trigger to update primary phone number on summary object
            for(Provider_Address__c objAddress :  Trigger.New) {
                if(objAddress.Address_Type__c == Label.CL303_PDIPrimary){
                    sumPrimaryMap.put(objAddress.Summary_Id__c, objAddress);
                }
            }
            //Updating primary address on summary object
            ProviderAddressTriggerHelper.updatePrimaryAddressOnSummary(sumPrimaryMap);
            //End: update primary phone number on summary object
            // As per the discussion with Arieh, Commenting the below lines, to dont make address doctor callouts to 
            // verify the address information, whil pushing data from ETL.
            // Please uncomment from line no : 108 to 112 to verify the address through Address Doctor Webservice, while pushing data from ETL. 
            /*if(userProfile == Label.CL561_PDIIntegrationProfile){
if(!setContactIds.isEmpty()){
ProviderAddressTriggerHelper.bulkAddressVerificationWebservice(setContactIds);  
}
}*/
            ProviderAddressTriggerHelper.firstRUnAddressAfterInsert = false;
        }
    }
    
    if(Trigger.isUpdate && Trigger.isbefore) {
        if(ProviderAddressTriggerHelper.firstRunAddressBeforeUpdate){
            //Update Provider Address Serial Number, if the address type is changed, Epic address is changed from inactive to active
            ProviderAddressTriggerHelper.updateProviderAddressSerialNumbers(Trigger.oldMap, Trigger.New, userProfile);
            ProviderAddressTriggerHelper.firstRunAddressBeforeUpdate = false;
        }
    }
    
    if(Trigger.isUpdate && Trigger.isAfter) {
        if(ProviderAddressTriggerHelper.firstRunAddressAfterUpdate){
            // As per the discussion with Arieh, Commenting the below lines, to dont make address doctor callouts to 
            // verify the address information, whil pushing data from ETL.
            // Please uncomment from line no : 190 to 201 to verify the address through Address Doctor Webservice, while pushing data from ETL. 
            /*Set<Id> setContactIds = new Set<Id>();
for(Provider_Address__c objAddress:Trigger.New) {
if(objAddress.Tech_Find_suggestAddress__c == false){
setContactIds.add(objAddress.Id);
}
}

if(userProfile == Label.CL561_PDIIntegrationProfile){
if(!setContactIds.isEmpty()){
ProviderAddressTriggerHelper.bulkAddressVerificationWebservice(setContactIds);  
}
}
*/
            //isAfter trigger to update primary phone number on summary object
            for(Provider_Address__c objAddress :  Trigger.New) {
                if(objAddress.Address_Type__c == Label.CL303_PDIPrimary){
                    sumPrimaryMap.put(objAddress.Summary_Id__c, objAddress);
                }
            }
            //Updating primary address on summary object.
            ProviderAddressTriggerHelper.updatePrimaryAddressOnSummary(sumPrimaryMap);
            //End: update primary phone number on summary object
            ProviderAddressTriggerHelper.firstRunAddressAfterUpdate = false;
        }
    }
}