/* 
     Trigger Name: SHP_updateRegionOnCensus 
     Author: Prerna Chandak
     Date: 23-Feb-2016
     Description: Trigger to update Region and County values on Census records based on the value in Employee Zip field.
     
     History:
     VERSION    AUTHOR              DATE        DETAIL 


*/
trigger SHP_updateRegionOnCensus on Census__c(before update){

List<Census__c> censusListToUpdate = new List<Census__c>();
List<Zip_Code_Master__c> zipCodeList = [Select id, Region__c, County__c, Zip_code__c from Zip_Code_Master__c limit 10000];
system.debug('---zipCodeList ----'+zipCodeList );
Boolean isZipMatch=false;
 for(Census__c census : trigger.new){
     
     isZipMatch=false;
     for(Zip_Code_Master__c zipCode :zipCodeList)
     {
         if(zipCode.Zip_code__c==Census.Employee_Zip__c)
         {
             
             census.Region__c = zipCode.Region__c;
             census.County__c = zipCode.County__c;
         
             isZipMatch=true;
             break;
         }
         
         
         
     }
     if(isZipMatch==false)
     {
                        system.debug('Match not found...');
                        census.Region__c = Label.SHP_Region_Value;
                        census.County__c = Label.SHP_Region_Value;   
         
     }
     else
     {
         system.debug('Match found...');
     }
     
     
 }   
     
 
}