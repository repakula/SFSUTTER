/* 
     Trigger Name: SHP_updateRegionOnZip 
     Author: Prerna Chandak
     Date: 23-Feb-2016
     Description: Trigger to update Region and County values on Census records based on any change to Zip Code Master data.
     
     History:
     VERSION    AUTHOR              DATE        DETAIL 


*/
trigger SHP_updateRegionOnZip on Zip_Code_Master__c (after insert, after update) {
List<Census__c> censusListToUpdate = new List<Census__c>();
 List<Census__c> census = [Select id,Employee_Zip__c from Census__c];
 for(Zip_Code_Master__c zipCode: trigger.new){
  for(Census__c censusList : census)
   {
  
   if(censusList.Employee_Zip__c == zipCode.Zip_code__c){
       censusList.Region__c = zipCode.Region__c;
       censusList.County__c = zipCode.County__c;
       censusListToUpdate.add(censusList);
        }
 
   
  } 
 }

update censusListToUpdate;

}