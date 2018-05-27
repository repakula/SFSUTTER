/**  
*    Trigger Name: PDIEAFFacilityTrigger 
*    Date: 10-October-2016
*    Created By: Nagarjuna		
*    Description: This Trigger used to update the is address changed flags 
on facility record if the facility address is validated by call center agent
**/
trigger PDIEAFFacilityTrigger on PDV_EAF_Facility__c (before insert, before update) {
    if(Trigger.isInsert && Trigger.isBefore){
        //Querying facility non validated queue and assigning the owner as non validated facility queue for newly inserted records.
        Id facQueId = [select Id from Group where Name =: Label.CL445_PDINonValidatedFacilityQueue and Type =: Label.CL411_PDIQueueAPI].id;
        if(PDIEAFFacilityTriggerHelper.firstRunFacilityBeforeInsert){
            for(PDV_EAF_Facility__c eaf: Trigger.New){
                if(eaf.Status__c == Label.CL185_PDI_Non_Validated_Status){
                    eaf.OwnerId = facQueId;
                }
            }
            PDIEAFFacilityTriggerHelper.firstRunFacilityBeforeInsert = false;
        }
    }
    if(Trigger.isUpdate && Trigger.isBefore){
        if(PDIEAFFacilityTriggerHelper.firstRunFacilityBeforeUpdate){
            //Updating address change flags on eaf object if any changes to the facility address.
            for(PDV_EAF_Facility__c eaf: Trigger.New){
                if(eaf.Tech_is_Facility_Updated__c == false){
                    if(eaf.Is_Address_Chagned__c == false && Trigger.oldMap.get(eaf.Id).Address__c != Trigger.newMap.get(eaf.Id).Address__c){
                        eaf.Is_Address_Chagned__c = true; 
                    }
                    if(eaf.Is_Address_Line_2_Changed__c == false && Trigger.oldMap.get(eaf.Id).Address_Line_2__c != Trigger.newMap.get(eaf.Id).Address_Line_2__c){
                        eaf.Is_Address_Line_2_Changed__c = true; 
                    }
                    if(eaf.Is_City_Changed__c == false && Trigger.oldMap.get(eaf.Id).City__c != Trigger.newMap.get(eaf.Id).City__c){
                        eaf.Is_City_Changed__c = true; 
                    }
                    if(eaf.Is_State_Changed__c == false && Trigger.oldMap.get(eaf.Id).State__c != Trigger.newMap.get(eaf.Id).State__c){
                        eaf.Is_State_Changed__c = true; 
                    }
                    if(eaf.Is_Zip_Code_Changed__c == false && Trigger.oldMap.get(eaf.Id).Zip_Code__c != Trigger.newMap.get(eaf.Id).Zip_Code__c){
                        eaf.Is_Zip_Code_Changed__c = true; 
                    }
                    if(eaf.Is_Phone_Changed__c == false && Trigger.oldMap.get(eaf.Id).Phone__c != Trigger.newMap.get(eaf.Id).Phone__c){
                        eaf.Is_Phone_Changed__c = true; 
                    }
                    if(eaf.Is_Phone_Extension_Changed__c == false && Trigger.oldMap.get(eaf.Id).Phone_Extension__c != Trigger.newMap.get(eaf.Id).Phone_Extension__c){
                        eaf.Is_Phone_Extension_Changed__c = true; 
                    }
                    if(eaf.Is_Fax_Changed__c == false && Trigger.oldMap.get(eaf.Id).Fax_Number__c != Trigger.newMap.get(eaf.Id).Fax_Number__c){
                        eaf.Is_Fax_Changed__c = true; 
                    }
                }
            }
            
            PDIEAFFacilityTriggerHelper.firstRunFacilityBeforeUpdate = false;
        }
    }
}